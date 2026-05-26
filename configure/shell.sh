#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh already installed."
fi

if [ -e "$HOME/.zshrc" ]; then
    echo "~/.zshrc already exists — leaving it alone. To apply repo changes, diff against $SCRIPT_DIR/zshrc manually."
else
    echo "Copying zshrc to ~/.zshrc..."
    cp "$SCRIPT_DIR/zshrc" "$HOME/.zshrc"
fi
