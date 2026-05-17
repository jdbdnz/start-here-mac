#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Installing Claude Code config..."
mkdir -p "$HOME/.claude/commands"
cp "$SCRIPT_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
cp "$SCRIPT_DIR/claude/settings.json" "$HOME/.claude/settings.json"

shopt -s nullglob
commands=("$SCRIPT_DIR/claude/commands/"*.md)
if (( ${#commands[@]} > 0 )); then
  cp "${commands[@]}" "$HOME/.claude/commands/"
fi

# Install chrome-devtools MCP server (idempotent — skips if already added)
if command -v claude >/dev/null 2>&1; then
  if ! claude mcp list 2>/dev/null | grep -q '^chrome-devtools'; then
    echo "Adding chrome-devtools MCP server..."
    claude mcp add -s user chrome-devtools -- npx chrome-devtools-mcp@latest
  fi
else
  echo "(claude CLI not found; skipping MCP setup — re-run after installing Claude Code)"
fi
