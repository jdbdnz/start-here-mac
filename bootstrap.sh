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
REPO_DIR="$HOME/$GITHUB_USER/start-here-mac"
if [ -d "$REPO_DIR" ]; then
    echo "Repo already exists, pulling latest..."
    git -C "$REPO_DIR" pull
else
    git clone "https://github.com/$GITHUB_USER/start-here-mac.git" "$REPO_DIR"
fi
cd "$REPO_DIR"
./setup.sh
