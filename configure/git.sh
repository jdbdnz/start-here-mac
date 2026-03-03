#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Configuring git..."

existing_name=$(git config --global user.name 2>/dev/null || true)
existing_email=$(git config --global user.email 2>/dev/null || true)

cp "$SCRIPT_DIR/gitconfig" "$HOME/.gitconfig"
git lfs install

if [ -n "$existing_name" ]; then
    git config --global user.name "$existing_name"
else
    read -rp "  Git name: " git_name
    git config --global user.name "$git_name"
fi

if [ -n "$existing_email" ]; then
    git config --global user.email "$existing_email"
else
    read -rp "  Git email: " git_email
    git config --global user.email "$git_email"
fi
