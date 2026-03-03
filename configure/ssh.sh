#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Installing SSH config..."
mkdir -p "$HOME/.ssh"
cp "$SCRIPT_DIR/ssh/config" "$HOME/.ssh/config"
chmod 600 "$HOME/.ssh/config"

if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
    read -rp "Generate an SSH key? Enter email (or press Enter to skip): " ssh_email
    if [ -n "$ssh_email" ]; then
        mkdir -p "$HOME/.ssh"
        ssh-keygen -t ed25519 -C "$ssh_email" -f "$HOME/.ssh/id_ed25519" -N ""
        echo ""
        echo "SSH public key (add this to GitHub → Settings → SSH keys):"
        echo ""
        cat "$HOME/.ssh/id_ed25519.pub"
    fi
else
    echo "SSH key already exists at ~/.ssh/id_ed25519"
fi
