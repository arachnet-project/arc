# ARC_FILE: docs/TODO.md
# arc — development tracker

## Done
- [x] Clipboard bridge (`xi/xo/xoa/xoe/xoae/xed/xcat/xclear`) — OS detection in place
      (Darwin → `pbcopy`/`pbpaste`, else `xclip`)
- [x] `xdep` — path traversal guard (rejects `..` and leading `/` in `ARC_FILE:` rel_path)
- [x] `wrk/commit.sh` v2.0 — parameterized (`msg` = `$1`, `files` = remaining args),
      branch-aware push (`git branch --show-current` instead of hardcoded `main`)
- [x] `xcom`/`xcoma` — updated to pass `"$@"` through to `commit.sh` v2.0
- [x] `.gitignore` — standard Linux/bash repo ignores, plus `*.bkp` and `out`
- [x] Confirmed obsolete draft of `aliases.sh` (plain aliases, no OS detection,
      no `../` guard) — do not merge forward, safe to delete or archive

## Pending review
- [ ] `wrk/pull.sh` — not yet reviewed
- [ ] Confirm `.bashrc_alias` vs documented "`.bashrc` source block" — same thing
      or separate?

<!--
NOTE FROM RECONSTRUCTION: this file was drafted in the July 21 Ubuntu
session. Its content conflicts in places with the later macOS-verified
design (e.g. this lists commit.sh v2.0 with plain-tee xcom/xcoma, while
the macOS session confirmed a different _arc_capture-based design) —
this is the same unresolved reconciliation flagged in project-summary.md.
Treat this TODO as a historical snapshot from the Ubuntu side until that
reconciliation happens, not as the current source of truth.
-->
