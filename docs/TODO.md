# ARC_FILE: docs/TODO.md
# arc — development tracker
# Created: 2026-07-27
# Updated: 2026-11-01

## Done

- [x] [Committed] Clipboard bridge (`xi/xo/xoa/xoe/xoae/xed/xcat/xclear`) — OS
      detection confirmed working on macOS.
- [x] [Committed] `xdep` — path traversal guard rejects `..` and leading `/`.
- [x] [Applied] `wrk/commit.sh` (macOS) — reviewed; required commit message,
      staging safeguards, and push behavior documented.
- [x] [Applied] `wrk/pull.sh` (macOS) — reviewed; clean-tree requirement and
      fast-forward-only pull documented.
- [x] [Tested] `xcom`/`xcoma` — use `_arc_capture` and forward arguments.
- [x] [Committed] `_arc_capture` — timestamp output tested in overwrite and append
      modes; command exit status is preserved.
- [x] [Tested] Editor decision — `nano` selected and `EDITOR=nano` live-tested
      through `xed` on macOS.
- [x] [Committed] Core project documentation committed in `3f8067d`.
- [x] [Applied] Stray root files and the duplicate root-level project summary
      removed in the earlier cleanup.
- [x] Obsolete plain-alias draft confirmed obsolete.

## Current status

- [Agreed] No tracked session-plan file is needed. Keep
  `wrk/session_plan.md` ignored if it exists.
- [Applied] Obsolete, untracked Ubuntu `wrk/status.sh` removed from the
  working tree; its removal does not produce a Git change to commit.
- [Tested] Ubuntu and MacBook session-opening audits report the same
  `main` HEAD (`0c8ecb6`) and expected tracked paths. The audits use local
  refs and do not contact the remote. A separate `git fetch origin` on
  Ubuntu on 2026-11-01 was followed by a `0 0` divergence result.
- [Tested] Ubuntu's in-repository `wrk/repo-session-open.sh` passes
  `bash -n` and runs with `--tracked-files`. It remains untracked and has
  not yet been committed.
- [Tested] `git diff --check` passed on Ubuntu on 2026-11-01.
- [Tested] Ubuntu `.gitignore` ignores `wrk/session_plan.md`, confirmed by
  `git check-ignore -v --no-index` on 2026-11-01.
- [Applied] The updated Ubuntu `docs/dev_workflow.md` has rule 8, uses
  `xcom` in the close-out checklist, and contains the document metadata
  rule. Its changes are not yet committed.

## Pending review

- [ ] [Pending review] **Historical repository-state discrepancy** — an
      earlier report described expected files as untracked and
      `commit.sh`/`pull.sh` as deleted. Later Ubuntu and MacBook audits show
      the expected tracked paths and the same HEAD. The cause of the earlier
      report is unknown; retain this note without treating it as a current
      structural issue.
- [ ] [Pending review] `.bashrc` `unexpected EOF` error around lines 76–77 remains
      undiagnosed; it is separate from the resolved aliases-loading issue.
- [ ] [Agreed] **Sync the MacBook clone** — its local workflow edit must be
      preserved until the Ubuntu version is pushed. Then reconcile that
      edit and run `xpull` on MacBook. Ubuntu's fetch on 2026-11-01 found
      local `HEAD` and `origin/main` equal at that time.

## Pending

- [ ] [Agreed] Review the final Ubuntu diff, including the opening script,
      and confirm that only intended files will be included in the commit.
- [ ] [Agreed] Commit and push the reviewed Ubuntu changes with `xcom`; verify
      `HEAD` matches `origin/main` and the working tree is clean.
- [ ] [Agreed] On MacBook, preserve the local `docs/dev_workflow.md` change,
      confirm its content is present in the pushed version, restore that
      local edit, then run `xpull` and verify a clean tree at the same
      commit.
- [ ] [Proposed] **Define ARC agent supervision principles** — agree what
      agents may inspect, edit, and test when using ARC's general-purpose
      workflow tools; what requires Jan's review; and who controls commits
      and pushes. Keep this guidance general to ARC.
- [ ] [Proposed] Apply the document-metadata rule to the other maintained
      documents: add creation and update dates, and version stable guidance
      documents. Leave `TODO.md` and `project-summary.md` unversioned.
- [ ] [Deferred] Resume iPhone SE setup after agent-workflow decisions: Working Copy
      clone/test, then Blink Shell/SSH setup for Ubuntu and `ara`.
