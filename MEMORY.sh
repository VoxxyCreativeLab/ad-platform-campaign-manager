#!/usr/bin/env bash
# MEMORY.sh — Injects live git context at launch
# Run: bash MEMORY.sh

echo "=== MEMORY — Live Context ==="
echo ""

# Check if inside a git repo
if ! git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  echo "Not a git repository. Run 'git init' first."
  exit 0
fi

# Current branch
echo "Branch: $(git branch --show-current)"
echo ""

# Last 5 commits
echo "--- Last 5 Commits ---"
git log --oneline -5 2>/dev/null || echo "(no commits yet)"
echo ""

# Modified and untracked files
echo "--- Modified / Untracked ---"
git status --short 2>/dev/null || echo "(clean)"
echo ""

echo "=== END ==="
