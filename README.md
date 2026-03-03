# start-here-mac
Initialize a Mac for development

## Usage

Run the setup script to install Homebrew and all applications defined in the Brewfile:

```bash
./setup.sh
```

This will:
1. Install Homebrew (if not already installed)
2. Configure Homebrew for Apple Silicon Macs
3. Install all packages from the Brewfile
4. Install and configure Oh My Zsh
5. Configure nvm and install Node 22 as the default version

## What Gets Installed

- **Homebrew**: Package manager for macOS
- **Zsh** and **Zsh Completions**: Enhanced shell
- **Oh My Zsh**: Framework for managing Zsh configuration
- **nvm**: Node Version Manager
- **Node 22**: JavaScript runtime (set as default)
- **iTerm2**: Modern terminal emulator for macOS
- **Rectangle**: Window management application for macOS
