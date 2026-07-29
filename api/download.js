const { instagramGetUrl } = require('instagram-url-direct');

module.exports = async function handler(req, res) {
  // CORS
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

  try {
    const { url, platform } = req.body || {};

    if (!url) return res.status(400).json({ error: 'No URL provided' });

    let result;

    switch (platform) {
      case 'tiktok':
        result = await handleTikTok(url);
        break;
      case 'instagram':
        result = await handleInstagram(url);
        break;
      case 'twitter':
        result = await handleTwitter(url);
        break;
      default:
        return res.status(400).json({ error: 'Unsupported platform' });
    }

    return res.status(200).json(result);
  } catch (err) {
    console.error('Download API Error:', err);
    return res.status(500).json({
      error: err.message || 'Failed to process video. Please try again.'
    });
  }
};

function formatUrl(path) {
  if (!path) return null;
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  return 'https://www.tikwm.com' + path;
}

// ========== TIKTOK HANDLER ==========
async function handleTikTok(url) {
  const apiUrl = `https://www.tikwm.com/api/?url=${encodeURIComponent(url)}`;

  const response = await fetch(apiUrl, {
    method: 'GET',
    headers: {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      'Accept': 'application/json'
    }
  });

  const json = await response.json();

  if (json.code !== 0 || !json.data) {
    throw new Error('Could not fetch TikTok video. Check the URL and try again.');
  }

  const data = json.data;

  return {
    platform: 'tiktok',
    title: data.title || 'TikTok Video',
    author: data.author?.unique_id || data.author?.nickname || '',
    videoUrl: formatUrl(data.play),
    audioUrl: formatUrl(data.music),
    thumbnail: formatUrl(data.cover),
    quality: 'HD (No Watermark)',
    duration: data.duration || 0
  };
}

// ========== INSTAGRAM HANDLER ==========
async function handleInstagram(url) {
  try {
    const result = await instagramGetUrl(url);

    if (!result || !result.url_list || result.url_list.length === 0) {
      throw new Error('Could not extract Instagram video. Make sure the post/reel is public.');
    }

    const videoUrl = result.url_list[0];

    return {
      platform: 'instagram',
      title: 'Instagram Reel/Post',
      author: '',
      videoUrl: videoUrl,
      audioUrl: null,
      thumbnail: null,
      quality: 'HD'
    };
  } catch (err) {
    if (err.message.includes('Only posts/reels')) {
      throw new Error('Invalid Instagram URL. Only public posts and reels are supported.');
    }
    throw new Error('Failed to fetch Instagram video: ' + err.message);
  }
}

// ========== TWITTER/X HANDLER ==========
async function handleTwitter(url) {
  const match = url.match(/status\/(\d+)/);
  if (!match) throw new Error('Invalid Twitter/X URL. Please paste a tweet URL with a video.');

  const fxUrl = url
    .replace('twitter.com', 'api.fxtwitter.com')
    .replace('x.com', 'api.fxtwitter.com');

  const response = await fetch(fxUrl, {
    headers: {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      'Accept': 'application/json'
    }
  });

  const json = await response.json();

  if (!json.tweet) {
    throw new Error('Could not fetch tweet. Make sure the tweet exists and contains a video.');
  }

  const tweet = json.tweet;

  let videoUrl = null;
  let thumbnail = null;

  if (tweet.media && tweet.media.videos && tweet.media.videos.length > 0) {
    const video = tweet.media.videos[0];
    videoUrl = video.url || null;
    thumbnail = video.thumbnail_url || null;
  } else if (tweet.media && tweet.media.all && tweet.media.all.length > 0) {
    for (const m of tweet.media.all) {
      if (m.type === 'video' || m.type === 'gif') {
        videoUrl = m.url || null;
        thumbnail = m.thumbnail_url || null;
        break;
      }
    }
  }

  if (!videoUrl) {
    throw new Error('No video found in this tweet. Make sure the tweet contains a video or GIF.');
  }

  return {
    platform: 'twitter',
    title: tweet.text ? tweet.text.substring(0, 120) : 'Twitter Video',
    author: tweet.author?.screen_name || '',
    videoUrl: videoUrl,
    audioUrl: null,
    thumbnail: thumbnail,
    quality: 'HD'
  };
}
