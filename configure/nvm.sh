#!/bin/bash
set -e

export NVM_DIR="$HOME/.nvm"

if [ ! -s "$NVM_DIR/nvm.sh" ]; then
    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
fi

\. "$NVM_DIR/nvm.sh"

echo "Installing Node 22..."
nvm install 22
nvm alias default 22
nvm use 22

echo "Node $(node --version), npm $(npm --version)"

echo "Enabling corepack (yarn)..."
corepack enable

echo "Installing global npm packages..."
npm install -g netlify-cli @anthropic-ai/claude-code
