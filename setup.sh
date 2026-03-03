#!/bin/bash

set -e

echo "Starting Mac development environment setup..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == 'arm64' ]]; then
        echo "Adding Homebrew to PATH for Apple Silicon..."
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "Homebrew is already installed."
fi

# Install applications from Brewfile
if [ -f "Brewfile" ]; then
    echo "Installing applications from Brewfile..."
    brew bundle
else
    echo "Warning: Brewfile not found in current directory."
    exit 1
fi

echo "Brewfile installations complete. Starting configurations..."

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "Oh My Zsh is already installed."
fi

# Configure nvm and install Node 22
echo "Configuring nvm..."
export NVM_DIR="$HOME/.nvm"

# Create nvm directory if it doesn't exist
mkdir -p "$NVM_DIR"

# Add nvm to shell profile if not already present
if ! grep -q 'NVM_DIR' ~/.zshrc 2>/dev/null; then
    echo "Adding nvm to ~/.zshrc..."
    cat >> ~/.zshrc << 'EOF'

# NVM configuration
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"
EOF
fi

# Load nvm for current session
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"

# Install Node 22 and set as default if nvm is available
if command -v nvm &> /dev/null; then
    echo "Installing Node 22..."
    nvm install 22
    nvm alias default 22
    nvm use 22
    
    echo "Node version: $(node --version)"
    echo "npm version: $(npm --version)"
else
    echo "Warning: nvm command not found. Please restart your terminal and run 'nvm install 22' manually."
fi

echo "Setup complete!"
