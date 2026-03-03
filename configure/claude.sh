#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

echo "Installing Claude Code config..."
mkdir -p "$HOME/.claude/commands"
cp "$SCRIPT_DIR/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
cp "$SCRIPT_DIR/claude/commands/opportunity.md" "$HOME/.claude/commands/opportunity.md"
