// ZipLootDL Serverless Video Extractor API
const express = require('express');
const fetch = require('node-fetch');
const app = express();
app.use(express.json());

// TikTok Handler (No Watermark)
app.post('/api/tiktok', async (req, res) => {
  const { url } = req.body;
  if (!url) return res.status(400).json({ error: 'URL required' });
  try {
    const apiRes = await fetch(`https://www.tikwm.com/api/?url=${encodeURIComponent(url)}`);
    const data = await apiRes.json();
    if (data.code === 0) {
      res.json({
        title: data.data.title,
        video_url: data.data.play,
        cover: data.data.cover
      });
    } else {
      res.status(500).json({ error: 'Extraction failed' });
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(3000, () => console.log('🚀 ZipLootDL Backend running on port 3000'));
