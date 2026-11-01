# ARC_FILE: docs/TODO.md
# arc — development tracker
# Created: 2026-07-27
# Updated: 2026-11-01

## Done

- [x] [Committed] Clipboard bridge (`xi/xo/xoa/xoe/xoae/xed/xcat/xclear`) — OS
      detection confirmed working on macOS.
- [x] [Committed] `xdep` — path traversal guard rejects `..` and leading `/`.
- [x] [Applied] `wrk/commit.sh` (macOS) reviewed; required message,
      staging safeguards, and push behavior documented.
- [x] [Applied] `wrk/pull.sh` (macOS) reviewed; clean-tree requirement and
      fast-forward-only pull documented.
- [x] [Tested] `xcom`/`xcoma` use `_arc_capture` and forward arguments.
- [x] [Committed] `_arc_capture` timestamp output tested in overwrite and
      append modes; command exit status is preserved.
- [x] [Tested] `EDITOR=nano` live-tested through `xed` on macOS.
- [x] [Committed] Core project documentation committed in `3f8067d`.
- [x] [Applied] Stray root files and the duplicate root-level project summary
      removed in the earlier cleanup.
- [x] Obsolete plain-alias draft confirmed obsolete.
- [x] [Committed] Session-opening audit script added as
      `wrk/repo-session-open.sh` in commit `81a26ae`; Bash syntax and Ubuntu
      execution verified. A copy of the script was also exercised on macOS.
- [x] [Committed] Workflow and TODO updated with session-opening steps,
      rule 8, document metadata policy, and the `xcom` close-out procedure
      in commit `81a26ae`.
- [x] [Committed] `.gitignore` retains the ignore rule for
      `wrk/session_plan.md`; `git check-ignore -v --no-index` confirmed it.

## Current status

- [Committed] Ubuntu pushed commit `81a26ae` to `origin/main`. The push
  output reported a clean working tree afterward.
- [Tested] Before that push, Ubuntu fetched `origin` and confirmed
  `HEAD...origin/main` divergence was `0 0`.
- [Tested] `git diff --check` passed on Ubuntu before the push.
- [Applied] Obsolete, untracked Ubuntu `wrk/status.sh` was removed; its
  removal did not produce a Git change.
- [Pending] The MacBook clone has not yet been confirmed at the pushed
  commit. Its last reported local change was to `docs/dev_workflow.md`.

## Pending review

- [ ] [Pending review] **Historical repository-state discrepancy** — an
      earlier report described expected files as untracked and
      `commit.sh`/`pull.sh` as deleted. Later Ubuntu and MacBook audits show
      the expected tracked paths and the same earlier HEAD. The cause of
      the earlier report remains unknown; it is not a current structural
      issue in the audited clones.
- [ ] [Pending review] Ubuntu `.bashrc` `unexpected EOF` error around lines
      76–77 remains undiagnosed; it is separate from the resolved aliases
      loading issue.

## Pending

- [ ] [Agreed] On MacBook, inspect the local `docs/dev_workflow.md` diff.
      Preserve any unique content; once the pushed version contains it,
      restore the local edit, run `xpull`, and verify a clean tree at the
      latest commit.
- [ ] [Proposed] **Define ARC agent supervision principles** — decide what
      agents may inspect, edit, and test when used with ARC's general
      workflow tools; what requires Jan's review; and who controls commits
      and pushes. Keep the guidance general to ARC.
- [ ] [Proposed] Apply the document-metadata rule to other maintained
      documents: add creation and update dates, and version stable guidance
      documents. Leave `TODO.md` and `project-summary.md` unversioned.
- [ ] [Deferred] Resume iPhone SE setup after agent-workflow decisions:
      Working Copy clone/test, then Blink Shell/SSH setup for Ubuntu and
      `ara`.
