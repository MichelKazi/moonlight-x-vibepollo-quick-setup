# Game Streaming Guide: Moonlight + Vibepollo

Play your gaming PC's games on a Mac, a laptop, a Steam Deck, an iPhone, or an iPad. The PC does the work, the other device just shows the picture and sends your controls. It works at home over your network and away from home over the internet.

This guide gets a non-technical person from nothing to playing. Start with Quick Start. The numbered sections after it explain each piece in more detail if you want it.

---

## Quick Start

### Words you will see

- **Host**: your gaming PC. The machine the games actually run on.
- **Client**: the device you play on. Mac, laptop, Steam Deck, phone, tablet.
- **Vibepollo**: the server software on the host. A tuned fork of Sunshine/Apollo. It captures the game and sends it out.
- **Moonlight**: the client app on every device you play on. It receives the stream.
- **VoidLink**: the best Moonlight-style client for iPhone and iPad. Sold on the App Store.
- **Tailscale**: a free app that makes all your devices act like they share one home network, even over the internet. This is how you play away from home with no router setup.
- **HEVC / H.265**: the video format to prefer. Better picture for the same bandwidth than older H.264.
- **Bitrate**: how much data the video uses. Higher looks sharper but needs a faster connection.
- **WOL (Wake-on-LAN)**: wakes a sleeping PC when you start streaming.

### Downloads

- Vibepollo, host server: https://github.com/Nonary/Vibepollo/releases/latest
- Moonlight enhanced client for PC, Mac, Linux, Steam Deck: https://github.com/qiin2333/moonlight-qt/releases/latest
- VoidLink for iPhone and iPad: search "VoidLink - Extreme" on the App Store
- Tailscale: https://tailscale.com/download

### Run the one-shot setup

The fastest path is two commands. Each one downloads and runs the right scripts for that machine.

On the gaming PC, open PowerShell as administrator and run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
irm https://raw.githubusercontent.com/MichelKazi/moonlight-streaming-guide/main/scripts/windows/setup.ps1 | iex
```

On a Mac or Linux device you play on, open a terminal and run:

```bash
curl -fsSL https://raw.githubusercontent.com/MichelKazi/moonlight-streaming-guide/main/scripts/setup-client.sh | bash
```

For iPhone or iPad there is no script. Install VoidLink - Extreme and Tailscale from the App Store.

### Then finish by hand

1. Sign in to Tailscale on the PC and every device using the same account.
2. On the PC, open `https://localhost:47990`, accept the security warning, set a username and password.
3. Open Moonlight or VoidLink on your device. Your PC shows up. Select it.
4. It shows a four digit PIN. Type that PIN into the Vibepollo web page to pair.
5. Pick a bitrate and codec from the [table below](#bitrate-and-codec), then play.

Prefer to do it step by step instead of the one-shot scripts? The sections below walk through everything.

---

## 1. Set up the host PC

The host is your Windows gaming PC. You do this once. The server software is Vibepollo, and big shoutout to Nonary for this absolute gem of an Apollo fork.

### Install

Download this repo or just the `scripts/windows` folder onto the PC. Open PowerShell as administrator, then run:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
.\install-host.ps1
.\tune-host.ps1
```

`install-host.ps1` installs Vibepollo and Tailscale. `tune-host.ps1` applies the settings that make streaming smooth. Reboot once when it finishes.

### First time Vibepollo setup

1. Open a browser on the PC and go to `https://localhost:47990`.
2. Accept the security warning. It is your own PC, so this is safe.
3. Set a username and password. You will use these to manage the server.
4. Leave the rest at defaults for now. The pairing PIN appears here later.

### Why the tuning script matters

- **High performance power plan** stops the CPU from slowing down mid-game.
- **Hardware Accelerated GPU Scheduling** lowers input lag and helps NVIDIA Reflex and frame pacing work well.
- **Wake-on-LAN** lets a sleeping PC wake up the moment you start a stream, so you do not have to leave it on all day. If your PC is wired, also turn on Wake-on-LAN in the BIOS. Look for "Wake on LAN", "Power On By PCIe", or set "ErP" to disabled.

## 2. Connect everything with Tailscale

Tailscale is what lets you play away from home without touching your router. Install it on the PC and on every device you play on, then sign in to all of them with the same account. That is the whole setup.

At home your devices talk directly over your local network for the lowest latency. Away from home Tailscale routes the stream securely over the internet and it just works.

Check your connection quality from a client device with:

```
tailscale ping <your-pc-name>
```

If it says "direct" you have the best path. If it says "via DERP" it is using a relay, which adds delay. The optional port forwarding step below fixes that.

## 3. Set up each client device

### Mac

Open Terminal, then run the script from `scripts/mac`:

```bash
bash install-client.sh
```

This installs the enhanced Moonlight client and Tailscale. Sign in to Tailscale, open Moonlight, pick your PC.

### Windows or Linux laptop, Steam Deck, other handhelds

Use the enhanced Moonlight client. On Linux and Steam Deck run the script from `scripts/linux`:

```bash
bash install-client.sh
```

On a Steam Deck, run it in Desktop Mode, then add the Moonlight AppImage to Steam as a non-Steam game so it launches from Game Mode.

For a Windows laptop, download `MoonlightSetup` from the [Moonlight releases page](https://github.com/qiin2333/moonlight-qt/releases/latest) and run it.

### iPhone and iPad

Get **VoidLink - Extreme** from the App Store. It is the best client for iOS and supports HEVC, HDR, multi-touch, and external controllers. Install Tailscale from the App Store too and sign in.

### Pairing

1. Open Moonlight or VoidLink. Your PC appears in the list if Tailscale is running on both.
2. Tap or click the PC.
3. It shows a four digit PIN. Type that PIN into the Vibepollo web page at `https://localhost:47990` under the PIN section.
4. Done. The PC's apps and desktop now show up on the client.

## 4. Picture and performance settings

Set these in Moonlight or VoidLink on the client.

### Bitrate and codec

Prefer **HEVC**, also called H.265, if your client supports it. AV1 is even better but needs a 40 series NVIDIA card or newer. H.264 is the fallback for old devices.

| Where you play | Resolution | Bitrate | Codec |
|---|---|---|---|
| Same house, wired or strong Wi-Fi | 1080p 60 | 30 to 50 Mbps | HEVC |
| Same house, Steam Deck or handheld | 800p to 1080p 60 | 25 to 40 Mbps | HEVC |
| Away from home over Tailscale | 1080p 60 | 15 to 25 Mbps | HEVC |
| Weak or unstable connection | 720p 60 | 10 Mbps | HEVC |

Start in the middle of the range. If the picture breaks up or stutters, lower the bitrate. If it looks soft but plays smoothly, raise it. Bitrate is the dial you will touch most.

### HDR

Turn HDR on only if both the game and the client screen support it. It looks great on an OLED Steam Deck or a good TV. On screens without real HDR it can look washed out, so leave it off there.

### Frame rate

Match the client screen. 60 fps is the common choice. Steam Deck OLED can do 90. A 120 Hz TV or tablet can do 120 if your connection is strong.

## 5. Get the lowest latency

These are the things that make a stream feel like a local game instead of a video call.

### Use Ethernet wherever you can

A wired connection beats Wi-Fi every time. The single biggest upgrade is plugging the **host PC** into the router with an Ethernet cable. If you can wire the client too, do it. For a Steam Deck, a USB-C dock with Ethernet works well when docked.

### If you must use Wi-Fi, pick the right radio

- Use the **5 GHz** network, not 2.4 GHz. 2.4 GHz is slower and crowded.
- Stay close to the router with clear line of sight.
- On the router, set a fixed 5 GHz channel rather than auto. The upper channels, 149 and above, are often cleaner and many routers transmit at higher power there. Test a couple and keep whichever gives the strongest signal and least packet loss.
- Use an 80 MHz channel width for a good balance of speed and stability.

### NVIDIA Reflex, frame limiting, and RTSS

Latency comes mostly from the host rendering too many frames into a backlog. Cap the frame rate so the GPU stays ahead of the stream instead of buffering.

- **NVIDIA Reflex**: turn it on in any game that offers it. It is the easiest latency win and needs no setup beyond a checkbox.
- **Cap the frame rate** a little above your stream's fps. If you stream at 60, cap the game near 60 to 63. Reflex does this on its own when enabled.
- **RTSS (RivaTuner Statistics Server)** is the most precise frame limiter when a game has no built-in cap. Install it, set a global limit that matches your stream, and it gives you steady frame times. Vibepollo also has its own frame limiter you can enable as a fallback.

The goal is steady frame times. A locked 60 fps feels better than an uneven 90.

## 6. Optional: port forwarding for the best remote latency

Skip this unless `tailscale ping` shows "via DERP" when you are away from home. Most setups get a direct connection automatically and need nothing here.

If you do want it, run the helper on the PC from `scripts/windows`:

```powershell
.\setup-port-forward.ps1
```

It opens the right port in the Windows Firewall and prints the exact rule to add in your router. You then add one rule in your router admin page:

- Protocol: UDP
- External and internal port: 41641
- Forward to: your PC's local IP

Your router admin page is usually `http://192.168.0.1` or `http://192.168.1.1`. Look for a section called Port Forwarding, NAT, or Virtual Server. While you are there, reserve your PC's IP in the DHCP settings so it never changes.

## Troubleshooting

- **PC does not appear in Moonlight**: make sure Tailscale is running and signed in on both the PC and the client with the same account.
- **Stream is blocky or stutters**: lower the bitrate one step. If on Wi-Fi, move closer to the router or switch to 5 GHz.
- **Picture looks washed out**: turn HDR off unless the client screen truly supports it.
- **Input feels laggy**: turn on NVIDIA Reflex, cap your frame rate, and use Ethernet on the host.
- **Sleeping PC will not wake**: re-run `tune-host.ps1`, and enable Wake-on-LAN in the BIOS for wired PCs.
- **Away from home feels slow**: check `tailscale ping`. If it says "via DERP", do the port forwarding step.

## Credits

- [Sunshine](https://github.com/LizardByte/Sunshine) and [Apollo](https://github.com/ClassicOldSong/Apollo), the host server projects.
- [Vibepollo](https://github.com/Nonary/Vibepollo), the tuned host fork used here.
- [Moonlight](https://moonlight-stream.org) and the [qiin2333 fork](https://github.com/qiin2333/moonlight-qt), the clients.
- [Tailscale](https://tailscale.com) for the networking.
