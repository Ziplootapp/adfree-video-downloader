function detectPlatform(url) {
  if (/tiktok\.com|vm\.tiktok/i.test(url)) return 'tiktok';
  if (/instagram\.com|instagr\.am/i.test(url)) return 'instagram';
  if (/twitter\.com|x\.com|t\.co/i.test(url)) return 'twitter';
  return null;
}
function showError(msg) {
  const el = document.getElementById('errorAlert');
  document.getElementById('errorText').textContent = msg;
  el.style.display = 'flex';
  setTimeout(() => { el.style.display = 'none'; }, 6000);
}
function hideError() { document.getElementById('errorAlert').style.display = 'none'; }
function setLoading(loading) {
  const btn = document.getElementById('downloadBtn');
  const text = btn.querySelector('.btn-text');
  const loader = btn.querySelector('.btn-loader');
  if (loading) { text.style.display = 'none'; loader.style.display = 'flex'; btn.disabled = true; }
  else { text.style.display = 'inline'; loader.style.display = 'none'; btn.disabled = false; }
}
function showResult(data) {
  const card = document.getElementById('resultCard');
  const platform = data.platform || 'tiktok';
  const badge = card.querySelector('.platform-badge');
  badge.textContent = platform.toUpperCase();
  document.getElementById('resultQuality').textContent = data.quality || 'HD';
  const videoPreview = document.getElementById('videoPreview');
  const previewPlayer = document.getElementById('previewPlayer');
  if (data.videoUrl) { previewPlayer.src = data.videoUrl; videoPreview.style.display = 'block'; }
  document.getElementById('videoTitle').textContent = data.title || 'Video Ready';
  document.getElementById('videoAuthor').textContent = data.author ? '@' + data.author : '';
  const dlVideo = document.getElementById('dlVideo');
  const dlAudio = document.getElementById('dlAudio');
  if (data.videoUrl) { dlVideo.href = data.videoUrl; dlVideo.style.display = 'inline-flex'; }
  if (data.audioUrl) { dlAudio.href = data.audioUrl; dlAudio.style.display = 'inline-flex'; }
  card.style.display = 'block';
  card.scrollIntoView({ behavior: 'smooth' });
}
function hideResult() { document.getElementById('resultCard').style.display = 'none'; }
async function handleDownload() {
  const input = document.getElementById('videoUrl');
  const url = input.value.trim();
  hideError(); hideResult();
  if (!url) { showError('Please paste a video link first.'); return; }
  const platform = detectPlatform(url) || 'tiktok';
  setLoading(true);
  try {
    const res = await fetch('/api/download', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ url, platform })
    });
    const data = await res.json();
    if (!res.ok || data.error) throw new Error(data.error || 'Failed to fetch video.');
    showResult(data);
  } catch (err) { showError(err.message || 'Something went wrong.'); }
  finally { setLoading(false); }
}
document.getElementById('videoUrl').addEventListener('keydown', (e) => { if (e.key === 'Enter') handleDownload(); });
