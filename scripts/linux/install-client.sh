#!/bin/bash
# install-client.sh
# One-time setup for a Linux PC, Steam Deck, or handheld you want to stream TO.
# Installs the enhanced Moonlight client as an AppImage and installs Tailscale.
#
# How to run:
#   bash install-client.sh
#
# On a Steam Deck, run this in Desktop Mode from a terminal (Konsole).

set -euo pipefail

BIN_DIR="$HOME/bin"
APPIMAGE="$BIN_DIR/Moonlight.AppImage"
mkdir -p "$BIN_DIR"

echo "==> Installing Tailscale..."
if ! command -v tailscale >/dev/null 2>&1; then
    # The official installer detects your distro. On SteamOS the filesystem is read-only,
    # so we skip the system install there and tell you to use the Decky plugin instead.
    if grep -qi steamos /etc/os-release 2>/dev/null; then
        echo "    SteamOS detected. Install Tailscale from the Discover store or the Decky 'Tailscale' plugin."
        echo "    Skipping system install."
    else
        curl -fsSL https://tailscale.com/install.sh | sh
    fi
else
    echo "    Already installed."
fi

echo "==> Downloading the enhanced Moonlight client (qiin2333 fork AppImage)..."
url="$(curl -fsSL https://api.github.com/repos/qiin2333/moonlight-qt/releases/latest \
    | grep -o 'https://[^"]*x86_64\.AppImage' | head -1)"

if [ -z "$url" ]; then
    echo "    Could not find an AppImage in the latest release. Aborting." >&2
    exit 1
fi

echo "    $url"
curl -fsSL -o "$APPIMAGE.new" "$url"
chmod +x "$APPIMAGE.new"
mv "$APPIMAGE.new" "$APPIMAGE"

echo ""
echo "==> Done. Moonlight is at: $APPIMAGE"
echo ""
echo "Next steps:"
echo "  1. Start Tailscale and sign in with the same account as your PC:"
echo "       sudo tailscale up"
echo "  2. Launch Moonlight:"
echo "       $APPIMAGE"
echo "  3. Your PC should appear. Click it and enter the PIN from the PC's Vibepollo web page to pair."
echo ""
echo "Steam Deck tip: add the AppImage to Steam as a non-Steam game so you can launch it from Game Mode."
echo ""
