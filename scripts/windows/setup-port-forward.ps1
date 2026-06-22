# setup-port-forward.ps1
# OPTIONAL. Only needed if you want the lowest possible latency when streaming
# away from home, and Tailscale is connecting through a relay instead of directly.
#
# Most people do NOT need this. Tailscale usually finds a direct path on its own.
# Run the "tailscale ping" check in the guide first. If it says "via DERP", this helps.
#
# This script:
#   1. Tells you your PC's local IP and the single port to forward.
#   2. Opens that port in the Windows Firewall.
# You still have to add the forwarding rule in your router yourself (every router differs).
#
# Run in an admin PowerShell:
#   Set-ExecutionPolicy Bypass -Scope Process -Force
#   .\setup-port-forward.ps1

#Requires -RunAsAdministrator

# Tailscale uses UDP 41641 for direct peer-to-peer connections.
$port = 41641

$ip = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.NetAdapter.Status -eq "Up" } |
       Select-Object -First 1).IPv4Address.IPAddress

Write-Host "==> Opening UDP $port in Windows Firewall..." -ForegroundColor Cyan
New-NetFirewallRule -DisplayName "Tailscale Direct (UDP $port)" `
    -Direction Inbound -Action Allow -Protocol UDP -LocalPort $port -ErrorAction SilentlyContinue | Out-Null

Write-Host ""
Write-Host "==> Now add this rule in your router's admin page:" -ForegroundColor Yellow
Write-Host ""
Write-Host "    Protocol:        UDP"
Write-Host "    External port:   $port"
Write-Host "    Internal port:   $port"
Write-Host "    Forward to IP:   $ip   (this PC)"
Write-Host ""
Write-Host "Your router admin page is usually http://192.168.0.1 or http://192.168.1.1" -ForegroundColor Yellow
Write-Host "Look for a section named 'Port Forwarding', 'NAT', or 'Virtual Server'." -ForegroundColor Yellow
Write-Host ""
Write-Host "Tip: also reserve this PC's IP ($ip) in your router's DHCP settings" -ForegroundColor Yellow
Write-Host "so it does not change later." -ForegroundColor Yellow
