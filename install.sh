#!/usr/bin/env bash
# ZipLootDL Ad-Free Video Downloader 1-Click Bash Installer
echo "⚡ Installing ZipLootDL Ad-Free Video Downloader Engine..."
INSTALL_DIR="$HOME/ZipLootDL"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR" || exit

if ! command -v node &> /dev/null; then
    echo "⚠️ Node.js runtime not found. Auto-installing Node.js..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y nodejs npm
    elif command -v brew &> /dev/null; then
        brew install node
    fi
fi

curl -sSL "https://raw.githubusercontent.com/Ziplootapp/adfree-video-downloader/main/server.js" -o "$INSTALL_DIR/server.js"
echo "✅ Installation complete!"
echo "🚀 Launching ZipLootDL Server on http://localhost:3000..."
node "$INSTALL_DIR/server.js"
