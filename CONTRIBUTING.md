# Contributing

## Structure

```
setup.sh              # orchestrator — runs all configure/ scripts in order
configure/            # one script per app/concern, each independently runnable
  homebrew.sh
  shell.sh
  nvm.sh
  git.sh
  zed.sh
  claude.sh
  rectangle.sh
  ssh.sh
Brewfile              # declarative package list (brew bundle)
zshrc                 # shell config → ~/.zshrc
gitconfig             # git config → ~/.gitconfig (no [user] section)
zed/
  keymap.json         # Zed keybindings → ~/.config/zed/keymap.json
claude/
  CLAUDE.md           # Claude Code global instructions → ~/.claude/CLAUDE.md
  commands/           # custom slash commands → ~/.claude/commands/
```

## Adding a new app

1. Add it to `Brewfile` (or `configure/nvm.sh` for npm globals)
2. If it needs configuration, create `configure/<app>.sh`
3. Add the new script to `setup.sh`
4. Track any config files in the repo and copy them in the script
5. Update the idempotency table in `README.md`

## Adding a new config file

1. Copy the file into the repo (pick a sensible location mirroring its destination)
2. Add a `cp` call in the relevant `configure/` script
3. Add a row to the tracked config files table in `README.md`

## Writing configure scripts

- Always include `#!/bin/bash` and `set -e`
- Use `SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"` to find the repo root
- Guard against re-running where possible (check if something is already installed before installing)
- Scripts should be idempotent — safe to run multiple times on the same machine
- No interactive prompts except in `git.sh` (name/email) and `ssh.sh` (key generation)

## Idempotency

Every script must be safe to re-run. Use guards like:

```bash
# Only install if not already present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    ...
fi

# cp overwrites cleanly — always safe
cp "$SCRIPT_DIR/zshrc" "$HOME/.zshrc"
```

Interactive prompts should only fire when needed:

```bash
current_name=$(git config --global user.name 2>/dev/null || true)
if [ -z "$current_name" ]; then
    read -rp "  Git name: " git_name
    git config --global user.name "$git_name"
fi
```

## README hygiene

The README should describe **behaviour**, not specifics that go stale. Avoid:

- Version numbers (Node 22, Python 3.10.18, etc.) — these change and will be wrong
- App version numbers
- Full lists of installed packages — the Brewfile is the source of truth for that

Prefer language like "installs your configured Python version" over "installs Python 3.10.18".

## macOS-only

This repo targets Apple Silicon Macs only. Do not add Intel/x86 compatibility paths or install Rosetta — the goal is a clean native Apple Silicon environment.
