# ARC_FILE: docs/project-summary.md
# arc — project summary
# Created: 2026-07-27
# Updated: 2026-11-01

## Purpose

ARC is Jan Mura's general-purpose personal Bash workflow toolkit. It
provides short, screen-reader-friendly commands for clipboard handling,
command-output capture, file transfer, deployment, Git operations,
archive extraction, and Markdown conversion across macOS, Ubuntu, and an
OCI server. ARC has its own repository and workflow.

## Repository

- Remote: `git@github.com:arachnet-project/arc.git`
- Branch: `main`
- Latest verified feature/workflow commit: `81a26ae` — `feat: add repo
  session-opening audit and workflow`
- The commit was pushed from Ubuntu to `origin/main`. The push output
  confirmed a clean Ubuntu working tree.

The Ubuntu audit fetched `origin` before the push and reported zero
local-only and zero upstream-only commits. The earlier MacBook audit
reported the same base commit and tracked paths, but its working tree had
a local change to `docs/dev_workflow.md`. The MacBook has not yet been
confirmed synchronized to `81a26ae`.

## Repository layout

The tracked project includes `aliases.sh`, `README.md`, the `docs/`
project-control and user-guidance documents, and `wrk/commit.sh`,
`wrk/pull.sh`, and `wrk/repo-session-open.sh`.

`wrk/session_plan.md` is not used as a shared plan and remains ignored by
Git. The numbered next-session plan belongs in this summary; actionable
work remains in `docs/TODO.md`.

## Tools and configuration

- `aliases.sh` is sourced after `PROJECT_ROOT` is exported. On Ubuntu,
  `.bashrc` sets `PROJECT_ROOT="$HOME/project_embeddings"` and
  `ARC_ROOT="$HOME/arc"`, then sources `$ARC_ROOT/aliases.sh`.
- The same aliases file is intended for macOS and Ubuntu. macOS uses
  `pbcopy`/`pbpaste`; Linux uses `xclip`.
- The clipboard capture file and download/transformation directories live
  under `~/.cb`. `xcom` and `xpull` capture their command output there.
- `nano` is the selected editor; `EDITOR=nano` was confirmed and tested
  through `xed` on macOS.
- Ubuntu smoke tests confirmed aliases load, `xrun` captures timestamped
  output, and `xdep` is defined.
- `wrk/commit.sh` requires a commit message, supports explicit paths, and
  pushes to the configured upstream. `wrk/pull.sh` requires a clean tree
  and uses fast-forward-only pulling.

## Workflow and document policy

`docs/dev_workflow.md` now defines session opening and close-out. At
session opening, read the workflow, this summary, and TODO; run
`bash wrk/repo-session-open.sh --tracked-files`; review the local state;
then use `xpull` before work if the tree is clean and the state is
understood.

Rule 8 states that no machine is primary: pull before a work block and
commit/push before handing work to another machine. Close-out commits use
`xcom` and must be verified on `origin/main`.

The document metadata policy is: maintained documents carry `Created`
and `Updated` dates; stable guidance documents carry a version; frequently
changing `TODO.md` and `project-summary.md` do not. Their revisions are
recorded by Git.

This workflow governs ARC only.

## Work completed this session

1. Added `wrk/repo-session-open.sh`, a read-only repository audit. It
   reports machine and repository identity, remotes, working-tree changes,
   recent local history, top-level files, and optionally tracked paths.
   It does not fetch or modify the repository. Ubuntu syntax checking and
   execution with `--tracked-files` passed; a copy was also run on macOS.
2. Added a formal session-opening procedure to `docs/dev_workflow.md` and
   clarified the no-primary-machine handoff rule.
3. Added document creation/update dates and versioning guidance. Stable
   guidance documents receive versions; living trackers do not.
4. Restored the `.gitignore` rule for `wrk/session_plan.md`. Ubuntu's
   `git check-ignore -v --no-index` confirmed the match at `.gitignore`
   line 4.
5. Removed the obsolete untracked Ubuntu `wrk/status.sh`; its removal
   required no Git change.
6. Updated `docs/TODO.md` and pushed the reviewed work in commit
   `81a26ae`.

## Current status and unresolved history

- Ubuntu was clean after the push of `81a26ae`.
- The MacBook still needs its local `docs/dev_workflow.md` change
  reconciled with the pushed version, then `xpull` and a clean-state
  check.
- An earlier account described an Ubuntu checkout with expected files
  untracked and Git helper files deleted. Later audits showed the expected
  tracked paths on both machines. The cause of that earlier discrepancy
  is unknown; no current structural mismatch was found.
- The Ubuntu `.bashrc` `unexpected EOF` report around lines 76–77 remains
  undiagnosed.

## Known limitations

- `xdep` replaces an existing destination without prompting.
- Linux clipboard commands require `xclip` and an available graphical
  clipboard session.
- Archive extraction should be limited to trusted files.
- Markdown conversion with `xmd` requires Pandoc and a suitable output
  engine for the requested format.
- The iPhone SE setup is incomplete. The ED25519 key was generated in
  Working Copy, GitHub OAuth was completed, and the public key was
  registered; the Working Copy clone test and Blink Shell/SSH setup remain.

## Next-session plan

1. Complete the MacBook synchronization: preserve and inspect its local
   workflow diff, confirm the pushed file includes its intended content,
   restore only the redundant local edit, run `xpull`, and verify the
   latest commit and clean tree.
2. Define ARC's agent supervision principles: allowed inspection, scoped
   edits and tests, review points, and commit/push authority.
3. Apply the approved metadata scheme to the remaining maintained
   documents, updating dates and adding versions only where appropriate.
4. Resume iPhone SE setup after the agent workflow work: Working Copy
   clone/test, then Blink Shell/SSH setup for Ubuntu and `ara`.
