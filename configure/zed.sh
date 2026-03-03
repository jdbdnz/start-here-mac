#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Installing Zed config..."
mkdir -p "$HOME/.config/zed"
cp "$SCRIPT_DIR/zed/keymap.json" "$HOME/.config/zed/keymap.json"
