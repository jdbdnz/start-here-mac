# start-here-mac

Bootstrap a new Apple Silicon Mac for development.

## Fresh machine setup

Open Terminal and paste this:

```bash
curl -fsSL https://raw.githubusercontent.com/jdbdnz/start-here-mac/main/bootstrap.sh -o /tmp/bootstrap.sh && bash /tmp/bootstrap.sh
```

This will:
1. Install Xcode Command Line Tools if needed (a dialog will appear — click Install, then press Enter to continue)
2. Clone this repo to `~/jdbdnz/start-here-mac`
3. Run `setup.sh`

You'll be prompted for your git name/email and whether to generate an SSH key. The full run takes 10–20 minutes depending on download speeds. See [After setup](#after-setup) when it completes.

## Re-running individual scripts

Each configure script can be run independently — useful when iterating on a specific app's config:

```bash
./configure/homebrew.sh    # install Homebrew + Brewfile packages
./configure/shell.sh       # Oh My Zsh + zshrc
./configure/nvm.sh         # nvm + Node 22 + global npm packages
./configure/git.sh         # gitconfig + git lfs
./configure/python.sh      # Python via pyenv
./configure/iterm2.sh      # iTerm2 profile
./configure/zed.sh         # Zed keymap
./configure/claude.sh      # Claude Code config + commands
./configure/rectangle.sh   # Rectangle shortcuts + preferences
./configure/ssh.sh         # SSH key generation
```

## Idempotency

All scripts are safe to re-run.

| Script | Notes |
|---|---|
| `homebrew.sh` | `brew bundle` skips already-installed packages |
| `shell.sh` | Oh My Zsh skipped if already installed; zshrc overwritten |
| `nvm.sh` | nvm and Node skipped if already installed; npm globals reinstalled (slow but harmless) |
| `git.sh` | Overwrites gitconfig; name/email only prompted if unset |
| `python.sh` | Skips install if version already present; updates global |
| `iterm2.sh` | Overwrites profile |
| `zed.sh` | Overwrites keymap |
| `claude.sh` | Overwrites config files |
| `rectangle.sh` | Rewrites shortcuts each run |
| `ssh.sh` | Skipped entirely if key already exists |

## Tracked config files

| Repo path | Installed to |
|---|---|
| `zshrc` | `~/.zshrc` |
| `gitconfig` | `~/.gitconfig` |
| `ssh/config` | `~/.ssh/config` |
| `iterm2/profile.json` | `~/Library/Application Support/iTerm2/DynamicProfiles/profile.json` |
| `zed/keymap.json` | `~/.config/zed/keymap.json` |
| `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| `claude/commands/opportunity.md` | `~/.claude/commands/opportunity.md` |

Edit files here, then re-run the relevant `configure/` script to apply on the current machine.

## What gets installed

See [Brewfile](./Brewfile) for the full package list.

## After setup

1. **Authenticate GitHub CLI:** `gh auth login --scopes write:packages`
2. **Add your SSH public key to GitHub:** [github.com/settings/keys](https://github.com/settings/keys)
3. **Grant Rectangle Accessibility permission:** System Settings → Privacy & Security → Accessibility → enable Rectangle
4. Authenticate remaining cloud CLIs:
   - `aws configure`
   - `heroku login`
   - `gcloud init`
   - `netlify login`
5. Authenticate with GitHub Container Registry:
   ```bash
   gh auth token | docker login ghcr.io -u $(gh api user --jq .login) --password-stdin
   ```
