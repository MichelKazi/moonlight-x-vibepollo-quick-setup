# LLM Setup Runbook

This file is written for an AI coding agent such as Claude Code that has terminal access on the user's machines. It walks the setup end to end and marks the points where a human has to step in.

Read this whole file before starting. Work one machine at a time. After each command, check the output matches what is described before moving on. When you hit a STOP, do not continue until the human confirms they finished the manual step.

## What you can automate vs what you cannot

You can install software, apply tuning, open firewall ports, and read back values. You cannot do the interactive auth and pairing steps. Those are deliberate security gates:

- Tailscale sign-in is a browser login. The human does it.
- The Vibepollo web setup and the pairing PIN happen in a browser. The human does it.
- BIOS settings, Ethernet cables, router admin pages are physical or device-specific. The human does it.

Do not try to script around these. Stop and hand off.

## Before you start

Confirm with the human:

1. Which machine is the host. It must be a Windows gaming PC.
2. Which machines are clients. Mac, Linux, Steam Deck, iPhone, iPad.
3. That they have a Tailscale account, or are willing to make a free one.

## Phase 1: Host PC (Windows)

You need an administrator PowerShell on the host.

### 1.1 Install Vibepollo and Tailscale

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
irm https://raw.githubusercontent.com/MichelKazi/moonlight-x-vibepollo-quick-setup/main/scripts/windows/setup.ps1 | iex
```

This runs `install-host.ps1` then `tune-host.ps1`. Expected result: the Vibepollo installer window opens. The human accepts defaults. The tuning script prints the settings it applied.

Verify Vibepollo installed:

```powershell
Test-Path "C:\Program Files\Vibepollo"
```

If that path is missing, check where the installer placed it before continuing.

### 1.2 STOP: human signs in to Tailscale on the host

Ask the human to open the Tailscale tray app or run `tailscale up`, then sign in. Wait.

Verify once they say they are done:

```powershell
tailscale status
```

You should see the host listed with an IP in the 100.x range. Note the host's Tailscale name, you will need it on the clients.

### 1.3 STOP: human finishes Vibepollo web setup

Ask the human to open `https://localhost:47990`, accept the security warning, and set a username and password. Wait for confirmation.

### 1.4 Reboot

The GPU scheduling change needs a reboot. Ask the human if it is okay to reboot now, then:

```powershell
Restart-Computer
```

## Phase 2: Each client (Mac or Linux)

Run the one-shot client installer on the device.

### 2.1 Install Moonlight and Tailscale

```bash
curl -fsSL https://raw.githubusercontent.com/MichelKazi/moonlight-x-vibepollo-quick-setup/main/scripts/setup-client.sh | bash
```

Expected result: the script reports the OS it detected and installs the Moonlight client plus Tailscale. On a Steam Deck run this in Desktop Mode.

Verify on Mac:

```bash
ls /Applications | grep -i moonlight
```

Verify on Linux:

```bash
ls ~/bin/Moonlight.AppImage
```

### 2.2 STOP: human signs in to Tailscale on the client

Same as the host. The human signs in with the same account. Verify:

```bash
tailscale status
```

The host should appear in the list.

### 2.3 STOP: human pairs the client

Pairing needs eyes on two screens at once, so the human does it:

1. Open Moonlight on the client. The host appears in the list. Select it.
2. Moonlight shows a four digit PIN.
3. On the host, in the Vibepollo web page, enter that PIN.

Wait until the human confirms the host now shows its apps in Moonlight.

## Phase 3: iPhone and iPad

There is no script. Tell the human to:

1. Install "VoidLink - Extreme" from the App Store.
2. Install Tailscale from the App Store and sign in with the same account.
3. Open VoidLink, select the host, pair with the PIN shown in the Vibepollo web page.

## Phase 4: Tune for their connection

Ask how they will mostly play, same house or away, and on what device. Then point them at the bitrate and codec table in the [README](README.md#bitrate-and-codec) and set Moonlight or VoidLink to match. Prefer HEVC.

If they want lowest latency, remind them:

- Wire the host with Ethernet if at all possible.
- Turn on NVIDIA Reflex in games that have it.
- Cap the frame rate near the stream fps.

## Phase 5: Optional remote latency check

If they play away from home and it feels slow, check the path from a client:

```bash
tailscale ping <host-name>
```

If it says "via DERP", run the port forward helper on the host:

```powershell
irm https://raw.githubusercontent.com/MichelKazi/moonlight-x-vibepollo-quick-setup/main/scripts/windows/setup-port-forward.ps1 | iex
```

It opens the firewall port and prints the exact router rule. The human adds that one rule in their router admin page. You cannot do this for them, router UIs all differ.

## Done

The user can now launch Moonlight or VoidLink, pick the host, and play. If anything fails, the Troubleshooting section of the [README](README.md#troubleshooting) covers the common cases.
