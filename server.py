import http.server
import socketserver
import json
import urllib.request

PORT = 3000

class Handler(http.server.SimpleHTTPRequestHandler):
    def do_POST(self):
        if self.path == '/api/tiktok':
            length = int(self.headers['Content-Length'])
            req_data = json.loads(self.rfile.read(length).decode('utf-8'))
            url = req_data.get('url', '')
            
            req = urllib.request.Request(f"https://www.tikwm.com/api/?url={urllib.parse.quote(url)}")
            with urllib.request.urlopen(req) as resp:
                data = json.loads(resp.read().decode('utf-8'))
                
            self.send_response(200)
            self.send_header('Content-Type', 'application/json')
            self.end_headers()
            self.wfile.write(json.dumps(data).encode('utf-8'))

print(f"🚀 ZipLootDL Server running on http://localhost:{PORT}")
with socketserver.TCPServer(("", PORT), Handler) as httpd:
    httpd.serve_forever()
