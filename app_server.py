import http.server
import socketserver
import json
import urllib.request
import urllib.parse
import os

PORT = 3000
DIRECTORY = os.path.dirname(os.path.abspath(__file__))
os.chdir(DIRECTORY)

def format_url(path):
    if not path:
        return None
    if path.startswith('http://') or path.startswith('https://'):
        return path
    return f"https://www.tikwm.com{path}"

class ZipLootHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/' or self.path == '':
            self.path = '/index.html'
        return super().do_GET()

    def do_POST(self):
        if self.path in ['/api/download', '/api/tiktok']:
            length = int(self.headers['Content-Length'])
            req_data = json.loads(self.rfile.read(length).decode('utf-8'))
            url = req_data.get('url', '')
            platform = req_data.get('platform', 'tiktok')
            
            try:
                apiUrl = f"https://www.tikwm.com/api/?url={urllib.parse.quote(url)}"
                req = urllib.request.Request(apiUrl, headers={'User-Agent': 'Mozilla/5.0'})
                with urllib.request.urlopen(req) as resp:
                    res_json = json.loads(resp.read().decode('utf-8'))
                    if res_json.get('code') == 0:
                        d = res_json.get('data', {})
                        result = {
                            "platform": platform,
                            "title": d.get("title", "TikTok Video"),
                            "author": d.get("author", {}).get("unique_id", ""),
                            "videoUrl": format_url(d.get('play')),
                            "audioUrl": format_url(d.get('music')),
                            "thumbnail": format_url(d.get('cover')),
                            "quality": "HD (No Watermark)"
                        }
                        self.send_response(200)
                        self.send_header('Content-Type', 'application/json')
                        self.end_headers()
                        self.wfile.write(json.dumps(result).encode('utf-8'))
                        return
            except Exception as e:
                pass
                
            self.send_response(500)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps({"error": "Extraction failed. Check URL."}).encode('utf-8'))

print(f"[SUCCESS] ZipLootDL Web Downloader running on http://localhost:{PORT}")
if __name__ == '__main__':
    with http.server.ThreadingHTTPServer(("", PORT), ZipLootHandler) as httpd:
        httpd.serve_forever()
