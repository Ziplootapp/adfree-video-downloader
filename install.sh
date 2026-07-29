#!/usr/bin/env bash
# ZipLootDL Ad-Free Video Downloader 1-Click Bash Installer
echo "[+] Installing ZipLootDL Ad-Free Video Downloader Engine..."
INSTALL_DIR="$HOME/ZipLootDL"
mkdir -p "$INSTALL_DIR"
cd "$INSTALL_DIR" || exit

curl -sSL "https://raw.githubusercontent.com/Ziplootapp/adfree-video-downloader/main/server.js" -o "$INSTALL_DIR/server.js"
curl -sSL "https://raw.githubusercontent.com/Ziplootapp/adfree-video-downloader/main/server.py" -o "$INSTALL_DIR/server.py"

if command -v node &> /dev/null; then
    echo "[SUCCESS] Node.js runtime detected! Starting ZipLootDL Server on http://localhost:3000..."
    node "$INSTALL_DIR/server.js"
elif command -v python3 &> /dev/null; then
    echo "[SUCCESS] Python runtime detected! Starting ZipLootDL Server on http://localhost:3000..."
    python3 "$INSTALL_DIR/server.py"
else
    echo "[!] Installing Node.js..."
    sudo apt-get update && sudo apt-get install -y nodejs
    node "$INSTALL_DIR/server.js"
fi
