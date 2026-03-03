#!/bin/bash
set -e

GITHUB_USER="jdbdnz"

if ! xcode-select -p &>/dev/null; then
    echo "Installing Xcode Command Line Tools..."
    xcode-select --install
    echo "Press Enter when the installation dialog completes..."
    read -r
fi

mkdir -p "$HOME/$GITHUB_USER"
git clone "https://github.com/$GITHUB_USER/start-here-mac.git" "$HOME/$GITHUB_USER/start-here-mac"
cd "$HOME/$GITHUB_USER/start-here-mac"
./setup.sh
