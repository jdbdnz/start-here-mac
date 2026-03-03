#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Starting Mac development environment setup..."

bash "$SCRIPT_DIR/configure/homebrew.sh"

# Export Homebrew PATH so all subsequent scripts inherit it
eval "$(/opt/homebrew/bin/brew shellenv)"

bash "$SCRIPT_DIR/configure/shell.sh"
bash "$SCRIPT_DIR/configure/nvm.sh"
bash "$SCRIPT_DIR/configure/git.sh"
bash "$SCRIPT_DIR/configure/python.sh"
bash "$SCRIPT_DIR/configure/iterm2.sh"
bash "$SCRIPT_DIR/configure/zed.sh"
bash "$SCRIPT_DIR/configure/claude.sh"
bash "$SCRIPT_DIR/configure/rectangle.sh"
bash "$SCRIPT_DIR/configure/ssh.sh"

echo ""
echo "Setup complete. Restart your terminal (or run: source ~/.zshrc)"
