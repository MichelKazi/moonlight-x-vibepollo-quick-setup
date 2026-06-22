# install-host.ps1
# One-time setup for the gaming PC (the machine you stream FROM).
# Installs Vibepollo (the streaming server) and Tailscale.
#
# How to run:
#   1. Press Start, type "PowerShell"
#   2. Right-click "Windows PowerShell" and choose "Run as administrator"
#   3. Paste this and press Enter:
#        Set-ExecutionPolicy Bypass -Scope Process -Force
#   4. Then run this script:
#        .\install-host.ps1

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"

Write-Host "==> Installing winget packages (Tailscale)..." -ForegroundColor Cyan
# winget ships with modern Windows 10/11. If this fails, install "App Installer" from the Microsoft Store.
winget install --id Tailscale.Tailscale -e --accept-source-agreements --accept-package-agreements

Write-Host "==> Downloading the latest Vibepollo installer..." -ForegroundColor Cyan
# Vibepollo is a Sunshine/Apollo fork tuned for low latency. It is the streaming server.
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/Nonary/Vibepollo/releases/latest"
$asset = $release.assets | Where-Object { $_.name -like "*Setup*.exe" } | Select-Object -First 1
if (-not $asset) { throw "Could not find a Vibepollo setup .exe in the latest release." }

$installer = "$env:USERPROFILE\Downloads\$($asset.name)"
Write-Host "    $($asset.name)"
Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $installer

Write-Host "==> Running the Vibepollo installer..." -ForegroundColor Cyan
# This opens the normal installer window. Accept the defaults.
# It installs a virtual display driver, which is what lets the PC run "headless" with no monitor.
Start-Process -FilePath $installer -Wait

Write-Host ""
Write-Host "==> Done with installs." -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Open a browser and go to https://localhost:47990"
Write-Host "     Accept the security warning (it is your own PC). Set a username and password."
Write-Host "  2. Run 'tailscale up' (or open the Tailscale tray app) and sign in."
Write-Host "  3. Run the tuning script next:  .\tune-host.ps1"
Write-Host ""
