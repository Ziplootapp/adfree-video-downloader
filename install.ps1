# ZipLootDL Ad-Free Video Downloader 1-Click PowerShell Installer
Write-Host "⚡ Installing ZipLootDL Ad-Free Video Downloader Engine..." -ForegroundColor Cyan
$installDir = "$env:USERPROFILE\ZipLootDL"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Set-Location $installDir

# 1. Auto-detect Node.js / Python runtime
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "⚠️ Node.js runtime not found on this system." -ForegroundColor Yellow
    Write-Host "⚙️ Automatically installing Node.js runtime via winget / portable download..." -ForegroundColor Yellow
    
    try {
        winget install OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements --silent
        $env:PATH += ";C:\Program Files\nodejs"
    } catch {
        Write-Host "📥 Downloading Portable Node.js..." -ForegroundColor Yellow
        $nodeUrl = "https://nodejs.org/dist/v18.18.2/node-v18.18.2-win-x64.zip"
        $nodeZip = "$installDir\node.zip"
        [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
        Invoke-WebRequest -Uri $nodeUrl -OutFile $nodeZip
        Expand-Archive -Path $nodeZip -DestinationPath "$installDir\node_env" -Force
        Remove-Item $nodeZip -ErrorAction SilentlyContinue
        $env:PATH += ";$installDir\node_env\node-v18.18.2-win-x64"
    }
}

Write-Host "📦 Fetching ZipLootDL Server Engine..." -ForegroundColor Yellow
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Ziplootapp/adfree-video-downloader/main/server.js" -OutFile "$installDir\server.js"

Write-Host "✅ Installation complete!" -ForegroundColor Green
Write-Host "🚀 Launching ZipLootDL Server on http://localhost:3000..." -ForegroundColor Cyan

if (Get-Command node -ErrorAction SilentlyContinue) {
    node "$installDir\server.js"
} else {
    & "$installDir\node_env\node-v18.18.2-win-x64\node.exe" "$installDir\server.js"
}
