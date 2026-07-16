#!/bin/bash
# ARC_FILE: wrk/commit.sh
# =============================================================================
# arc — personal workflow toolset
# wrk/commit.sh
# =============================================================================
# Usage:
#   bash wrk/commit.sh "commit message"
#   bash wrk/commit.sh "commit message" path1 [path2 ...]

set -euo pipefail

if [[ $# -lt 1 ]]; then
    echo "ERROR: commit message required."
    echo "Usage: $0 \"commit message\" [path1 path2 ...]"
    exit 1
fi

msg="$1"
shift
files=("$@")

if [[ "$msg" != *[![:space:]]* ]]; then
    echo "ERROR: commit message must not be empty."
    exit 1
fi

repo_root="$(git rev-parse --show-toplevel 2>/dev/null)" || {
    echo "ERROR: not inside a Git repository."
    exit 1
}

if ! git remote get-url origin >/dev/null 2>&1; then
    echo "ERROR: remote 'origin' is not configured."
    exit 1
fi

branch="$(git branch --show-current)"
if [[ -z "$branch" ]]; then
    echo "ERROR: cannot commit and push from detached HEAD."
    exit 1
fi

if [[ ${#files[@]} -gt 0 ]] && ! git diff --cached --quiet; then
    echo "ERROR: the index already contains staged changes."
    echo "Unstage them or commit them before using an explicit path list."
    git diff --cached --name-status
    exit 1
fi

if [[ ${#files[@]} -eq 0 ]]; then
    echo "Staging all changes in: $repo_root"
    git add -A :/
else
    echo "Staging requested paths..."
    for f in "${files[@]}"; do
        git add -- "$f"
        echo "  staged  $f"
    done
fi

if git diff --cached --quiet; then
    echo "ERROR: nothing is staged; no commit was created."
    exit 1
fi

echo ""
echo "Changes to be committed:"
git diff --cached --stat
git diff --cached --name-status

echo ""
echo "Committing: $msg"
git commit -m "$msg"

echo ""
if git rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' \
        >/dev/null 2>&1; then
    echo "Pushing current branch to its configured upstream..."
    git push
else
    echo "Pushing to origin $branch and setting upstream..."
    git push --set-upstream origin "$branch"
fi

echo ""
echo "Git status after push:"
git status
echo ""
echo "Done."
