#!/usr/bin/env bash
# ARC_FILE: wrk/repo-session-open.sh
# Purpose: read-only Git repository checks for a project session opening.
# Usage:   repo-session-open.sh [--tracked-files] [REPO_PATH]
#          Run from anywhere; REPO_PATH defaults to the current directory.
#
# This script does not fetch, pull, checkout, stage, commit, or modify files.

set -u

show_tracked_files=0
repo_path="."
repo_path_set=0
end_options=0

usage() {
    cat <<'USAGE'
Usage: repo-session-open.sh [--tracked-files] [REPO_PATH]

Run standard read-only checks for a Git repository. If REPO_PATH is omitted,
the current directory is used. REPO_PATH may be the repository or a directory
inside it.

Options:
  --tracked-files  Print the full list of paths in Git's index.
  -h, --help       Show this help.

The script does not contact a remote or change the repository.
USAGE
}

for arg in "$@"; do
    if [ "$end_options" -eq 1 ]; then
        if [ "$repo_path_set" -eq 1 ]; then
            printf 'ERROR: provide at most one repository path.\n' >&2
            usage >&2
            exit 2
        fi
        repo_path="$arg"
        repo_path_set=1
        continue
    fi
    case "$arg" in
        --tracked-files)
            show_tracked_files=1
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        --)
            end_options=1
            ;;
        -* )
            printf 'ERROR: unknown option: %s\n' "$arg" >&2
            usage >&2
            exit 2
            ;;
        *)
            if [ "$repo_path_set" -eq 1 ]; then
                printf 'ERROR: provide at most one repository path.\n' >&2
                usage >&2
                exit 2
            fi
            repo_path="$arg"
            repo_path_set=1
            ;;
    esac
done

if ! cd "$repo_path" 2>/dev/null; then
    printf 'ERROR: cannot enter path: %s\n' "$repo_path" >&2
    exit 2
fi

repo_root=$(GIT_OPTIONAL_LOCKS=0 git -c core.fsmonitor=false rev-parse --show-toplevel 2>/dev/null) || {
    printf 'ERROR: not inside a Git working tree: %s\n' "$PWD" >&2
    exit 2
}

git_ro() {
    GIT_OPTIONAL_LOCKS=0 git -c core.fsmonitor=false -C "$repo_root" "$@"
}

section() {
    printf '\n== %s ==\n' "$1"
}

section "Session and machine"
printf 'Date: %s\n' "$(date '+%Y-%m-%d %H:%M:%S %Z')"
printf 'Host: %s\n' "$(uname -srm 2>/dev/null || uname -a)"
printf 'Bash: %s\n' "${BASH_VERSION:-unknown}"
printf 'Started from: %s\n' "$PWD"

section "Repository identity"
printf 'Root: %s\n' "$repo_root"
branch=$(git_ro symbolic-ref --quiet --short HEAD 2>/dev/null) || branch='DETACHED HEAD'
printf 'Branch: %s\n' "$branch"
head=$(git_ro rev-parse --verify HEAD 2>/dev/null) || head='unavailable'
printf 'HEAD: %s\n' "$head"
if [ "$head" != 'unavailable' ]; then
    git_ro log -1 --format='HEAD commit date: %cI%nHEAD subject: %s' 2>/dev/null || true
fi

upstream=$(git_ro rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null) || upstream='none'
printf 'Upstream: %s\n' "$upstream"
if [ "$upstream" != 'none' ] && [ "$head" != 'unavailable' ]; then
    counts=$(git_ro rev-list --left-right --count "HEAD...@{upstream}" 2>/dev/null) || counts='unavailable'
    case "$counts" in
        *[!0-9\ ]*|"") printf 'Local/upstream-only commits: %s\n' "$counts" ;;
        *)
            set -- $counts
            printf 'Local-only commits: %s\n' "${1:-0}"
            printf 'Upstream-only commits: %s\n' "${2:-0}"
            ;;
    esac
fi

section "Remotes (credentials redacted where present)"
remote_output=$(git_ro remote -v 2>/dev/null | sed -E \
    -e 's#(https?://)[^/@]*@#\1[REDACTED]@#g' \
    -e 's/[?].*/?[REDACTED]/')
if [ -n "$remote_output" ]; then
    printf '%s\n' "$remote_output"
else
    printf 'No remotes configured.\n'
fi

section "Working tree"
git_ro status --short --branch --untracked-files=all 2>&1 || true
printf '\nUnstaged change summary:\n'
git_ro diff --stat 2>&1 || true
printf '\nStaged change summary:\n'
git_ro diff --cached --stat 2>&1 || true

section "Recent history (local refs; no fetch performed)"
git_ro log --oneline --decorate --all -10 2>&1 || true

section "Top-level files"
ls -la "$repo_root" 2>&1 || true

if [ "$show_tracked_files" -eq 1 ]; then
    section "Tracked paths"
    git_ro ls-files 2>&1 || true
fi

printf '\nNOTE: No remote was contacted. Upstream counts and history use local\n'
printf 'remote-tracking refs, which may be stale. Review this output before\n'
printf 'deciding whether any fetch, pull, or other repository action is safe.\n'
