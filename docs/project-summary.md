# ARC_FILE: docs/project-summary.md

# ARC project summary

## Purpose

ARC is Jan Mura's personal Bash workflow toolkit. It provides short,
screen-reader-friendly commands for clipboard handling, command-output
capture, file transfer, deployment, Git operations, archive extraction,
and Markdown conversion across macOS, Ubuntu, and an OCI server.

## Repository

`git@github.com:arachnet-project/arc.git`, branch `main`.

Commits:
- `9e9a2d8` — Initial commit (July 17, 2026)
- `3f8067d` — docs: TODO, dev_workflow, howto, mobile-integration,
  mobile-setup-howto, project-summary; feat: timestamp in `_arc_capture`;
  chore: gitignore `wrk/session_plan.md` (July 27, 2026)

Both commits pushed and confirmed on `origin/main`.

## Repository layout (as committed, confirmed via `ls -la` this session)

```text
arc/
  .gitignore
  aliases.sh
  README.md
  docs/
    conventions.md
    dev_workflow.md
    howto.md
    mobile-integration.md
    mobile-setup-howto.md
    project-summary.md
    TODO.md
  wrk/
    commit.sh
    pull.sh
    session_plan.md   (gitignored — working scratch, lives in wrk/)
```

`wrk/out` and `wrk/session_plan.md` are both gitignored (bare `out`
pattern matches at any depth; `wrk/session_plan.md` added explicitly
this session).

## Governance: `docs/dev_workflow.md` is now in force

Adopted this session as a strict, mandatory rule set (not guidance) —
mirrors the discipline Jan already uses on the separate ACE project,
adopted specifically to prevent the kind of drift/neglect problems
experienced there. Six rules; status vocabulary is Proposed → Agreed →
Applied → Tested → Committed. All work in this and future sessions
should be tracked through that vocabulary explicitly.

## This session's work (all confirmed Tested/Committed)

1. **Root cause found for a stray duplicate file:** a root-level
   `project-summary.md` (stale, July 20) existed alongside the correct
   `docs/project-summary.md` (July 27) — found via `ls -la`, deleted.
   Also removed `.DS_Store` and `aliases.sh.save` (a nano emergency-save
   artifact) from the repo root — neither belonged in the working tree.
2. **`_arc_capture` timestamp change** — applied and tested in both
   `overwrite` and `append` modes. Each captured command's output in
   `~/.cb/cb` now starts with `===== YYYY-MM-DD HH:MM:SS =====` via a
   `{ echo "$ts"; "$@"; }` group wrapped before the `tee` pipe;
   `PIPESTATUS[0]` still correctly reflects the real command's exit
   code (the group's exit status is its last command's).
3. **`EDITOR=nano` confirmed** in `.bash_profile` (line 35) — was
   already Applied from a prior session, now also live-tested via
   `xed`.
4. **`wrk/commit.sh` on macOS reviewed line-by-line — confirmed
   correct and canonical.** Matches the previously-documented
   parameterized design: required `$1` with usage error, anti-footgun
   check refusing an explicit path list when the index has staged
   changes, `git add -A :/` vs per-path staging, auto-set-upstream on
   push. The shebang-then-`ARC_FILE:`-marker-on-line-2 format is
   correct per `_arc_marker_path`'s shebang handling — not a bug.
5. **`wrk/pull.sh` on macOS reviewed — confirmed clean.** Requires a
   fully clean working tree before pulling, uses `--ff-only` (no
   surprise merge commits). No issues found.
6. **`docs/howto.md` located** — it already existed on disk (July 17),
   the "never recovered" concern from earlier in the session turned out
   to be moot. Committed as-is.
7. **`docs/session_plan.md` relocated to `wrk/session_plan.md`** and
   gitignored — established as Jan's ongoing per-session scratch file,
   not a versioned doc.
8. **Full commit + push executed and verified** — `git log --oneline`
   and `git show --stat HEAD` both confirm commit `3f8067d` on
   `origin/main` with exactly the intended 8 files changed.

## Open item: Ubuntu repository is in an inconsistent state (unresolved)

`git status` on Ubuntu shows:
```
modified:   aliases.sh
deleted:    commit.sh
deleted:    pull.sh
Untracked:  .gitignore, README.md, docs/, wrk/
```

This means Git's index on Ubuntu currently believes `commit.sh` and
`pull.sh` were tracked at the **repo root** (not inside `wrk/`) and are
now gone from there, while `.gitignore`, `README.md`, `docs/`, and
`wrk/` all show as untracked — inconsistent with a normal clone of the
initial commit, which per this doc's history should already have all of
those tracked. Root cause not yet diagnosed. Possible causes (not
determined): wrong directory / not the expected clone, a corrupted or
reset index, or a manual file move done outside Git — none of these
individually explains every symptom, so no cause should be assumed yet.

**Do not commit or pull on Ubuntu until this is diagnosed.** A commit
now risks accidentally committing a repo restructuring; a pull risks an
unpredictable conflict or overwrite given the index's current state.

Ubuntu's `wrk/commit.sh` content itself **is** understood and is not
part of this open item — it's the previously-documented simpler v2.0
(`msg=$1`, plain `git add .`, no anti-footgun check, no usage-message-
on-missing-arg), confirmed via direct `cat` this session. Once the
structural index issue is resolved, the plan is to sync it via a normal
`git pull`/`xpull` from `origin/main` (which now has the fuller,
macOS-confirmed version) — not a manual file copy — since Git itself is
the intended sync mechanism between machines.

## Editor: resolved

`nano` selected (`vim` broken on macOS due to a Homebrew/Perl mismatch;
VS Code's `-w` ties to the whole app/window, not the document; BBEdit's
window wouldn't close, root cause undiagnosed). `xoe`/`xoae`/`xed` use
`"${EDITOR:-nano}"`. `EDITOR=nano` confirmed on line 35 of
`.bash_profile` and live-tested.

## Mobile integration

iPhone SE: ED25519 SSH key generated inside Working Copy, GitHub OAuth
completed, public key registered. Not yet started this session — carried
over. See `docs/mobile-integration.md` and `docs/mobile-setup-howto.md`
(both now committed).

## Next session

New topics Jan wants to open with, ahead of resuming iPhone SE work:
- **Dictation on macOS** — interest in Whisper-based dictation features.
- **Agentics discussion** — principles behind agent frameworks; a
  specific claim about an Austrian originator and a subsequent
  acquisition was raised but not yet verified — treat as a discussion
  topic to research together, not an established fact.
- **Pricing trends and related opportunities** — general discussion,
  no specifics yet.

Numbered plan:
1. Diagnose the Ubuntu repository inconsistency (`git log --oneline
   --all`, `git ls-files`, `git remote -v`, `pwd && git rev-parse
   --show-toplevel` — gather these before acting on anything).
2. Once diagnosed, bring Ubuntu in line with `origin/main` via a normal
   `git pull`/`xpull` (not a manual copy), after confirming no
   uncommitted local work would be lost.
3. Open with the three new topics above (dictation/Whisper, agentics
   principles, pricing/opportunities) as a discussion, likely before
   returning to `arc` code.
4. Resume iPhone SE setup: clone `arc` into Working Copy (read-only
   test, open `README.md`), then Blink Shell/SSH setup for Ubuntu and
   `ara`.

## Known limitations

- `xdep` overwrites an existing destination without confirmation.
- Archives should come from trusted sources.
- Linux clipboard access requires `xclip` and a graphical clipboard
  session.
- PDF/format conversion requires Pandoc and a suitable engine for `xmd`.
