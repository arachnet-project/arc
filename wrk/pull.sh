#!/bin/bash
# ARC_FILE: wrk/pull.sh
# =============================================================================
# arc — personal workflow toolset
# wrk/pull.sh
# =============================================================================
# Fast-forwards the current branch from its matching branch on origin.

set -euo pipefail

repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "ERROR: not inside a Git repository."
    exit 1
}

cd "$repo_root"

if ! git remote get-url origin >/dev/null 2>&1; then
    echo "ERROR: remote 'origin' is not configured."
    exit 1
fi

branch="$(git branch --show-current)"
if [[ -z "$branch" ]]; then
    echo "ERROR: cannot pull in detached HEAD state."
    exit 1
fi

if [[ -n "$(git status --porcelain)" ]]; then
    echo "ERROR: working tree is not clean."
    echo "Commit or stash local changes before pulling."
    git status --short
    exit 1
fi

echo "Pulling from origin $branch (fast-forward only)..."
git pull --ff-only origin "$branch"

echo ""
echo "Git status after pull:"
git status
echo ""
echo "Done."
