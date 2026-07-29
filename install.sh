#!/usr/bin/env bash
# ZipLootDL Ad-Free Video Downloader 1-Click Bash Installer
echo "⚡ Installing ZipLootDL Ad-Free Video Downloader Engine..."
INSTALL_DIR="$HOME/ZipLootDL"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR" || exit

curl -sSL "https://raw.githubusercontent.com/Ziplootapp/adfree-video-downloader/main/server.js" -o "$INSTALL_DIR/server.js"
echo "✅ Installation complete! Run 'node server.js' to start local video downloader."
