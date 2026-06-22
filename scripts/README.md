# Scripts

One-time setup scripts, grouped by the machine they run on.

## windows (run on the gaming PC, the host)

- `install-host.ps1` installs Vibepollo and Tailscale.
- `tune-host.ps1` applies power, GPU scheduling, and Wake-on-LAN settings.
- `setup-port-forward.ps1` optional, only for the lowest remote latency.

Run all three in a PowerShell window opened as administrator. First run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
```

## mac (run on a Mac you play on)

- `install-client.sh` installs the Moonlight client and Tailscale.

```bash
bash install-client.sh
```

## linux (run on a Linux PC, Steam Deck, or handheld you play on)

- `install-client.sh` installs the Moonlight AppImage and Tailscale.

```bash
bash install-client.sh
```

For iPhone and iPad there is no script. Get VoidLink - Extreme and Tailscale from the App Store.
