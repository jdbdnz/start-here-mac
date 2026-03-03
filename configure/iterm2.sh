#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Installing iTerm2 profile..."
mkdir -p "$HOME/Library/Application Support/iTerm2/DynamicProfiles"
cp "$SCRIPT_DIR/iterm2/profile.json" "$HOME/Library/Application Support/iTerm2/DynamicProfiles/profile.json"
