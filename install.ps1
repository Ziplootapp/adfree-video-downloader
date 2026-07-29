# ZipLootDL Ad-Free Video Downloader 1-Click PowerShell Installer
Write-Host "[+] Installing ZipLootDL Ad-Free Video Downloader Engine..." -ForegroundColor Cyan
$installDir = "$env:USERPROFILE\ZipLootDL"
New-Item -ItemType Directory -Force -Path $installDir | Out-Null
Set-Location $installDir

Remove-Item "$installDir\server.js" -ErrorAction SilentlyContinue
Remove-Item "$installDir\app_server.py" -ErrorAction SilentlyContinue

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Write-Host "[*] Fetching ZipLootDL Server files..." -ForegroundColor Yellow
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Ziplootapp/adfree-video-downloader/HEAD/server.js" -OutFile "$installDir\server.js"
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Ziplootapp/adfree-video-downloader/HEAD/app_server.py" -OutFile "$installDir\app_server.py"

if (Get-Command node -ErrorAction SilentlyContinue) {
    Write-Host "[SUCCESS] Node.js runtime detected! Starting ZipLootDL Server on http://localhost:3000..." -ForegroundColor Green
    node "$installDir\server.js"
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
    Write-Host "[SUCCESS] Python runtime detected! Starting ZipLootDL Server on http://localhost:3000..." -ForegroundColor Green
    python "$installDir\app_server.py"
} else {
    Write-Host "[!] Neither Node.js nor Python detected. Auto-installing Node.js via winget..." -ForegroundColor Yellow
    winget install OpenJS.NodeJS.LTS --accept-source-agreements --accept-package-agreements --silent
    $env:PATH += ";C:\Program Files\nodejs"
    node "$installDir\server.js"
}
