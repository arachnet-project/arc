# ARC_FILE: docs/project-summary.md

# ARC project summary

## Purpose

ARC is Jan Mura's personal Bash workflow toolkit. It provides short,
screen-reader-friendly commands for clipboard handling, command-output capture,
file transfer, deployment, Git operations, archive extraction, and Markdown
conversion across macOS, Ubuntu, and an OCI server.

ARC is independent of any individual development project. A project exports
its own `PROJECT_ROOT` and then sources ARC's `aliases.sh`.

## Repository

GitHub repository:
`git@github.com:arachnet-project/arc.git`

- Branch: `main`, tracks `origin/main`.
- Initial commit `9e9a2d8`, "Initial commit: ARC personal workflow toolset",
  pushed July 17, 2026.
- Confirmed live via `git status` on macOS.

## Repository layout (as committed)

```text
arc/
  .gitignore
  aliases.sh
  README.md
  docs/
    conventions.md
  wrk/
    commit.sh
    pull.sh
```

Not yet committed, pending close-out:

```text
docs/howto.md
docs/project-summary.md   (this file)
docs/mobile-integration.md
docs/mobile-setup-howto.md
```

Runtime files remain outside Git:

```text
~/.cb/cb
~/.cb/downloads/
~/.cb/transformed_files/
```

## Machines and roles

| Machine | Role |
|---|---|
| Ubuntu | Intended long-term canonical working clone |
| macOS | Current active testing machine |
| OCI server, SSH alias `ara` | Deployment target, not an editing environment |
| iPhone SE | Client-only node: Git client (Working Copy) and SSH client (Blink Shell/Termius), no shell of its own — see `docs/mobile-integration.md` |

## Major finding (most recent session): macOS default shell was zsh

`aliases.sh` and `PROJECT_ROOT` were correctly wired into `.bash_profile`,
but macOS's default login shell (zsh since Catalina) does not source
`.bash_profile`. This meant `arc` had likely never actually loaded in a
normal macOS terminal session before — nothing was "live" to test.

**Resolved:** ran `chsh -s /bin/bash`, confirmed via
`dscl . -read /Users/jan UserShell` → `/bin/bash`, confirmed via
`echo $SHELL` in a fresh terminal → `/bin/bash`.

**Confirmed working after the fix:**
- `xcat` runs (no "command not found") — `aliases.sh` is genuinely sourced.
- `xclear` → `xcom` (no args) → `xcat` round-trip confirmed: `xcom`
  errors cleanly with a usage message, and that error text is correctly
  captured into `~/.cb/cb` via `tee` (accessibility-relevant: no silent
  hang).

## `aliases.sh` — current design (re-verified)

- `PROJECT_ROOT` guard at the top — refuses to load if unset.
- Clipboard bridge: `xi`/`xo`/`xoa`/`xoe`/`xoae`/`xed`/`xcat`/`xclear` —
  functions with OS detection (`Darwin` → `pbcopy`/`pbpaste`, else `xclip`).
- File-to-CB: `xcf`/`xcfa`.
- Run-and-capture via shared helper `_arc_capture` (modes: `overwrite`/
  `append`, calls `_arc_runtime_setup`, tees to `$CB`) — used by:
  `xcom`/`xcoma`, `xpull`/`xpulla`, `xbash`/`xbasha`, `xpy`/`xpya`,
  `xrun`/`xruna`.
- `xcom`/`xcoma` forward `"$@"` through to `commit.sh` — confirmed correct,
  they do not call it with no arguments.
- OCI transfer: `xsup`/`xsd`/`xls`.
- Deployment: `xdep` with `ARC_FILE:` marker convention, path traversal
  guard rejecting `..` or a leading `/`.
- Package unpacking: `xupkg`; Markdown transform: `xmd` via pandoc.
- `xoe`/`xoae`/`xed` updated to use `"${EDITOR:-nano}"` (nano selected as
  the final editor choice — see below).

## Editor decision: resolved

Moved away from `vim` (broken on macOS due to a missing `libperl.dylib`
from a Homebrew/Perl mismatch, and not VoiceOver-friendly anyway).

- **VS Code (`code -w`)** — tested twice (fresh launch, and with VS Code
  already running). Rejected: the wait ties to the whole application/
  window lifecycle, not the individual document.
- **BBEdit (`bbedit --wait`)** — tested. Rejected: the document window
  would not close via any method (⌘W, File menu, ⌘Q); root cause
  undiagnosed, likely a stuck permission dialog or hung window state.
- **nano** — selected. Terminal-based, no window-lifecycle ambiguity,
  control returns immediately on ⌃X, shortcuts shown on-screen at all
  times.

`xoe`/`xoae`/`xed` in `aliases.sh` updated to `"${EDITOR:-nano}"`,
confirmed applied via file re-paste.

## `wrk/commit.sh` — confirmed parameterized design

Takes commit message as `$1` (required; errors clearly with a usage
message if missing — no silent hang, good for VoiceOver accessibility),
optional paths as remaining args. Checks repo root/remote/branch;
anti-footgun check refuses an explicit path list if the index already has
staged changes; stages via `git add -A :/` (no args) or `git add` per
path; auto-sets upstream on push if missing.

## Pending changes (agreed, not yet applied)

- `export EDITOR=nano` in `.bash_profile` — requested, not yet confirmed
  via `grep`.
- Add a timestamp line to `_arc_capture` (both `overwrite` and `append`
  modes) so `~/.cb/cb` entries are distinguishable by time. Planned form:
  wrap the captured command in `{ echo "===== $ts ====="; "$@"; }` before
  piping to `tee`, preserving `PIPESTATUS[0]` for exit-status capture.
  Not yet tested or committed.

## Conflicting accounts to reconcile

An earlier Ubuntu session produced a simpler `commit.sh` v2.0 (msg=`$1`,
`git add .` if no files given) and an `xcom`/`xcoma` using plain `tee`
passthrough (no `_arc_capture` helper). These conflict with the
macOS-verified versions described above. Which version is actually
deployed/authoritative is unresolved.

## Unresolved Ubuntu sourcing bug

Sourcing `~/arc/aliases.sh` (directly or via `.bashrc`) throws
`syntax error near unexpected token '('` at line 82 (`xi()` function),
consistently — yet `bash -n ~/arc/aliases.sh` passes silently. Diagnostics
exhausted: confirmed same absolute path, real bash 5.1.16, `cat -A` on
lines 70–90 shows a byte-clean file. Root cause unidentified. Separately,
`~/.bashrc` has an unrelated `unexpected EOF while looking for matching
quote` around lines 76–77, not yet diagnosed. Workaround: call
`wrk/commit.sh` directly, bypassing aliases entirely.

## Mobile integration

iPhone SE: ED25519 SSH key generated inside Working Copy, GitHub OAuth
sign-in completed, public key registered to GitHub account. Not yet done:
cloning `arc` into Working Copy, Blink Shell/SSH-side setup for
Ubuntu/`ara`. See `docs/mobile-integration.md` and
`docs/mobile-setup-howto.md`.

## Next session plan

1. Confirm the `EDITOR=nano` export in `.bash_profile`.
2. Run a live `xed` round-trip test with nano.
3. Apply and test the `_arc_capture` timestamp change.
4. Commit the pending docs and code changes together via `xcom`.
5. Test the full `arc` process end to end after committing.
6. Resume iPhone SE setup: clone `arc` into Working Copy (read-only test,
   open `README.md`), then Blink Shell/SSH setup for Ubuntu and `ara`.
7. Reconcile the conflicting `commit.sh`/`xcom`/`xcoma` versions between
   Ubuntu and macOS sessions.

## Known limitations

- `xdep` overwrites an existing destination without confirmation.
- Archives should come from trusted sources.
- Linux clipboard access requires `xclip` and a graphical clipboard session.
- PDF conversion requires Pandoc and a suitable PDF engine.
