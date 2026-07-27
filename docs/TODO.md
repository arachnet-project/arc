# ARC_FILE: docs/TODO.md
# arc — development tracker

## Done
- [x] Clipboard bridge (`xi/xo/xoa/xoe/xoae/xed/xcat/xclear`) — OS detection
      confirmed working on macOS (bash sourcing fixed via `chsh -s /bin/bash`)
- [x] `xdep` — path traversal guard (rejects `..` and leading `/`)
- [x] `wrk/commit.sh` (macOS) — reviewed line-by-line, confirmed correct and
      canonical: required `$1`, usage error on missing arg, anti-footgun
      check, `git add -A :/` vs per-path, auto-set-upstream
- [x] `wrk/pull.sh` (macOS) — reviewed, confirmed clean: clean-tree
      requirement, `--ff-only`, consistent error style
- [x] `xcom`/`xcoma` (macOS) — confirmed using `_arc_capture`, forwards
      `"$@"` correctly
- [x] `_arc_capture` — timestamp line added and tested in both `overwrite`
      and `append` modes; `PIPESTATUS[0]` still correctly captured
- [x] Editor decision — `nano` selected, `EDITOR=nano` confirmed in
      `.bash_profile` line 35, live-tested via `xed`
- [x] `docs/howto.md`, `docs/mobile-integration.md`,
      `docs/mobile-setup-howto.md`, `docs/project-summary.md`,
      `docs/dev_workflow.md`, `docs/TODO.md` (this file) — committed
      together in `3f8067d`
- [x] `docs/session_plan.md` relocated to `wrk/session_plan.md`, gitignored
- [x] Stray files removed from repo root: `.DS_Store`, `aliases.sh.save`,
      duplicate root-level `project-summary.md`
- [x] Obsolete plain-alias draft confirmed obsolete (from earlier session)

## Pending review
- [ ] **Ubuntu repository structural inconsistency** — `git status` shows
      `commit.sh`/`pull.sh` as deleted from repo root and `.gitignore`/
      `README.md`/`docs/`/`wrk/` as untracked. Root cause not yet
      diagnosed. Do not commit or pull on Ubuntu until this is resolved.
      See `docs/project-summary.md` for full detail and diagnostic
      commands to run next session.
- [ ] `.bashrc` unrelated `unexpected EOF` error around lines 76–77 — not
      yet diagnosed (separate from the aliases.sh sourcing bug, which was
      resolved this session — root cause was zsh being the default login
      shell, not sourcing `.bash_profile`)

## Pending
- [ ] Resume iPhone SE setup: Working Copy clone/test, then Blink Shell/
      SSH setup for Ubuntu and `ara`
