#!/bin/bash
# setup-client.sh
# One-shot client setup for Mac and Linux. Detects your OS and runs the right installer.
# This is the only script you need to run by hand on a device you play on.
#
# Easiest way to run it:
#   curl -fsSL https://raw.githubusercontent.com/MichelKazi/moonlight-x-vibepollo-quick-setup/main/scripts/setup-client.sh | bash

set -euo pipefail

base="https://raw.githubusercontent.com/MichelKazi/moonlight-x-vibepollo-quick-setup/main/scripts"

case "$(uname -s)" in
    Darwin) os="mac" ;;
    Linux)  os="linux" ;;
    *)      echo "Unsupported OS. For iPhone or iPad, install VoidLink - Extreme from the App Store." >&2; exit 1 ;;
esac

echo "==> Detected $os. Downloading and running the installer..."
curl -fsSL "$base/$os/install-client.sh" | bash
