# ZipLootDL Ad-Free Video Downloader 1-Click PowerShell Installer
Write-Host "⚡ Installing ZipLootDL Ad-Free Video Downloader Engine..." -ForegroundColor Cyan
$installDir = "$env:USERPROFILE\ZipLootDL"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null

Write-Host "📦 Downloading Node.js server dependencies..." -ForegroundColor Yellow
Set-Location $installDir
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Ziplootapp/adfree-video-downloader/main/server.js" -OutFile "$installDir\server.js"

Write-Host "✅ Installation complete! Run 'node server.js' to start local video downloader." -ForegroundColor Green
