# ZipLootDL Ad-Free Video Downloader 1-Click PowerShell Installer
Write-Host "[+] Installing ZipLootDL Ad-Free Video Downloader Engine..." -ForegroundColor Cyan
$installDir = "$env:USERPROFILE\ZipLootDL"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Set-Location $installDir

Remove-Item "$installDir\index.html" -ErrorAction SilentlyContinue
Remove-Item "$installDir\style.css" -ErrorAction SilentlyContinue
Remove-Item "$installDir\app.js" -ErrorAction SilentlyContinue
Remove-Item "$installDir\app_server.py" -ErrorAction SilentlyContinue

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Host "[*] Fetching ZipLootDL Web UI and Server Engine..." -ForegroundColor Yellow
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Ziplootapp/adfree-video-downloader/HEAD/index.html" -OutFile "$installDir\index.html"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Ziplootapp/adfree-video-downloader/HEAD/style.css" -OutFile "$installDir\style.css"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Ziplootapp/adfree-video-downloader/HEAD/app.js" -OutFile "$installDir\app.js"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Ziplootapp/adfree-video-downloader/HEAD/app_server.py" -OutFile "$installDir\app_server.py"

if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host "[SUCCESS] Node.js detected! Starting ZipLootDL Web App on http://localhost:3000..." -ForegroundColor Green
    python "$installDir\app_server.py"
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Host "[SUCCESS] Python detected! Starting ZipLootDL Web App on http://localhost:3000..." -ForegroundColor Green
    python "$installDir\app_server.py"
} else {
    Write-Host "[!] Neither Node.js nor Python detected. Auto-installing Node.js via winget..." -ForegroundColor Yellow
    winget install OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements --silent
    python "$installDir\app_server.py"
}
