# Scripts

One-time setup scripts, grouped by the machine they run on.

## One-shot setup

Most people only need these two. Each downloads and runs the rest for that machine.

- `windows/setup.ps1` runs the host install and tuning on the gaming PC.
- `setup-client.sh` detects Mac or Linux and runs the matching client installer.

See the Quick Start in the main [README](../README.md) for the copy-paste commands.

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
