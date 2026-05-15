#!/bin/bash
# role-build-skill setup script
# 用法：bash scripts/setup.sh

set -e

echo "Setting up role-build-skill..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"

# Hermes
mkdir -p ~/.hermes/skills/role-build-skill
ln -sf "$SKILL_DIR/SKILL.md" ~/.hermes/skills/role-build-skill/SKILL.md
echo "[Hermes] installed → ~/.hermes/skills/role-build-skill/SKILL.md"

# Claude Code
if [ -d ~/claude/skills ]; then
    mkdir -p ~/claude/skills/role-build-skill
    ln -sf "$SKILL_DIR/SKILL.md" ~/claude/skills/role-build-skill/SKILL.md
    echo "[Claude Code] installed → ~/claude/skills/role-build-skill/SKILL.md"
fi

# OpenClaw
if [ -d ~/.claude/skills ]; then
    mkdir -p ~/.claude/skills/role-build-skill
    ln -sf "$SKILL_DIR/SKILL.md" ~/.claude/skills/role-build-skill/SKILL.md
    echo "[OpenClaw] installed → ~/.claude/skills/role-build-skill/SKILL.md"
fi

echo ""
echo "Done! role-build-skill ready."
