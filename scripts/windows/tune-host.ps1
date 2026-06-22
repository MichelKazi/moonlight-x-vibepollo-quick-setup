# tune-host.ps1
# One-time tuning for the gaming PC. Safe to run more than once.
# Applies the settings that matter most for smooth, low-latency streaming:
#   - Wake-on-LAN that actually works through sleep
#   - High performance power plan
#   - Hardware accelerated GPU scheduling (helps NVIDIA Reflex and frame pacing)
#
# Run in an admin PowerShell:
#   Set-ExecutionPolicy Bypass -Scope Process -Force
#   .\tune-host.ps1

#Requires -RunAsAdministrator

$ErrorActionPreference = "Continue"

Write-Host "==> Setting High Performance power plan..." -ForegroundColor Cyan
# Stops the CPU from down-clocking mid-game.
powercfg /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c 2>$null
# Never turn off the network adapter to save power.
powercfg /setacvalueindex SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY 0 2>$null

Write-Host "==> Enabling Hardware Accelerated GPU Scheduling..." -ForegroundColor Cyan
# Lowers input latency. Takes effect after a reboot.
$gpuKey = "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers"
Set-ItemProperty -Path $gpuKey -Name "HwSchMode" -Value 2 -Type DWord -Force

Write-Host "==> Configuring Wake-on-LAN on the network adapter..." -ForegroundColor Cyan
# This is the fix that lets a sleeping PC wake up when you start streaming.
$nic = Get-NetAdapter -Physical | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
if ($nic) {
    Write-Host "    Using adapter: $($nic.Name)"
    # Allow this device to wake the computer, and only on a magic packet.
    Enable-NetAdapterPowerManagement -Name $nic.Name -WakeOnMagicPacket -ErrorAction SilentlyContinue | Out-Null
    powercfg /deviceenablewake "$($nic.InterfaceDescription)" 2>$null

    # Many Realtek/Intel NICs drop to a slow link speed during sleep and miss the wake packet.
    # Force the link to stay at full speed. The exact property name varies by driver, so try the common ones.
    $props = @(
        @{ Keyword = "*WakeOnMagicPacket"; Value = 1 },
        @{ Keyword = "WolShutdownLinkSpeed"; Value = 0 },   # 0 = "Not Speed Down" on Realtek
        @{ Keyword = "*EEE"; Value = 0 },                    # disable Energy Efficient Ethernet
        @{ Keyword = "EnableGreenEthernet"; Value = 0 }
    )
    foreach ($p in $props) {
        try {
            Set-NetAdapterAdvancedProperty -Name $nic.Name -RegistryKeyword $p.Keyword -RegistryValue $p.Value -ErrorAction Stop
            Write-Host "    Set $($p.Keyword) = $($p.Value)"
        } catch {
            # Property not present on this driver, that is fine.
        }
    }
} else {
    Write-Host "    No active wired adapter found. Skipping WOL (you are likely on Wi-Fi)." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "==> Tuning applied." -ForegroundColor Green
Write-Host "    Reboot once for GPU scheduling to take effect." -ForegroundColor Yellow
Write-Host ""
Write-Host "If your PC is wired by Ethernet, also enable Wake-on-LAN in the BIOS/UEFI" -ForegroundColor Yellow
Write-Host "(look for 'Wake on LAN', 'Power On By PCIe', or 'ErP' set to disabled)." -ForegroundColor Yellow
