# setup.ps1
# One-shot host setup. Downloads and runs install-host.ps1 then tune-host.ps1.
# This is the only script you need to run by hand on the gaming PC.
#
# Easiest way to run it, in an admin PowerShell:
#   Set-ExecutionPolicy Bypass -Scope Process -Force
#   irm https://raw.githubusercontent.com/MichelKazi/moonlight-x-vibepollo-quick-setup/main/scripts/windows/setup.ps1 | iex

#Requires -RunAsAdministrator

$ErrorActionPreference = "Stop"
$base = "https://raw.githubusercontent.com/MichelKazi/moonlight-x-vibepollo-quick-setup/main/scripts/windows"

foreach ($name in "install-host.ps1", "tune-host.ps1") {
    Write-Host "==> Running $name" -ForegroundColor Cyan
    $path = Join-Path $env:TEMP $name
    Invoke-WebRequest -Uri "$base/$name" -OutFile $path
    & $path
}

Write-Host ""
Write-Host "==> Host setup complete. Reboot once, then open https://localhost:47990 to finish Vibepollo setup." -ForegroundColor Green
