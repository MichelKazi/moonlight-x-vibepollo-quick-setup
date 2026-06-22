#!/bin/bash
# install-client.sh
# One-time setup for a Mac you want to stream TO.
# Installs the enhanced Moonlight client and Tailscale.
#
# How to run:
#   1. Open the Terminal app (Cmd+Space, type "Terminal")
#   2. Paste this line and press Enter:
#        bash install-client.sh
#   (or:  chmod +x install-client.sh && ./install-client.sh )

set -euo pipefail

echo "==> Checking for Homebrew (the Mac package manager)..."
if ! command -v brew >/dev/null 2>&1; then
    echo "    Installing Homebrew. Follow any prompts it shows."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Make brew available in this session on Apple Silicon.
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
fi

echo "==> Installing Tailscale..."
# This is the menu-bar app version. Sign in after it installs.
brew install --cask tailscale-app 2>/dev/null || brew install --cask tailscale

echo "==> Installing the enhanced Moonlight client (qiin2333 fork)..."
# This fork has better reconnect handling and quality controls than stock Moonlight.
# We grab the latest .dmg straight from GitHub and install it.
tmp="$(mktemp -d)"
dmg_url="$(curl -fsSL https://api.github.com/repos/qiin2333/moonlight-qt/releases/latest \
    | grep -o 'https://[^"]*\.dmg' | head -1)"

if [ -z "$dmg_url" ]; then
    echo "    Could not find a .dmg in the latest release. Falling back to stock Moonlight via Homebrew."
    brew install --cask moonlight
else
    echo "    Downloading: $dmg_url"
    curl -fsSL -o "$tmp/Moonlight.dmg" "$dmg_url"
    echo "    Mounting and copying to /Applications..."
    vol="$(hdiutil attach "$tmp/Moonlight.dmg" -nobrowse | grep -o '/Volumes/.*' | head -1)"
    cp -R "$vol"/*.app /Applications/
    hdiutil detach "$vol" >/dev/null
    rm -rf "$tmp"
fi

echo ""
echo "==> Done."
echo ""
echo "Next steps:"
echo "  1. Open Tailscale from the menu bar and sign in with the same account as your PC."
echo "  2. Open Moonlight from /Applications. Your PC should appear automatically."
echo "  3. Click it, enter the PIN shown on the PC's Vibepollo web page to pair."
echo ""
