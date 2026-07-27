# ARC_FILE: docs/mobile-integration.md

# Mobile integration (iPhone SE)

## Purpose

The iPhone SE joins `arc`'s machine topology as a **client-only** node. It
has no shell, so `aliases.sh` is never sourced on the phone itself. Instead,
the phone reaches the same Git remote and the same always-on machine
(`ara`, the OCI VM) that Ubuntu and macOS already use, either as a Git
client or as an SSH terminal into a real shell.

This keeps the core `arc` design (Ubuntu canonical, macOS secondary, `ara`
central/deployment target) unchanged. The phone adds a fourth access point,
not a fourth execution environment.

## Two ways in

### 1. Git client — Working Copy

Working Copy clones, edits, commits, and pushes against any of Jan's repos,
including `git@github.com:arachnet-project/arc.git`, without needing a
shell. Useful for:

- quick edits to Markdown/docs (e.g. `docs/*.md`) from the phone
- committing small changes while away from Ubuntu/macOS
- reviewing diffs and history without SSH

Push support requires the Pro Unlock in-app purchase.

### 2. SSH client — terminal into Ubuntu or `ara`

An SSH client turns the phone into a terminal for a real machine, so the
full `arc` toolset (all `x*` functions, `commit.sh`, `pull.sh`) becomes
available exactly as on Ubuntu/macOS — just remotely.

Two realistic options:

| App | Model | Notes |
|---|---|---|
| Blink Shell | ~$19.99/year (2 weeks free trial) | Native Mosh support — session survives Wi-Fi/cellular switches, sleep, and brief drops. iOS/iPadOS only. Recommended default given connection resilience and low yearly cost. |
| Termius | ~$9.99–10/month (~$60/year) | Cross-platform (also Android, Mac, Windows, Linux), cloud sync across devices. Costs more per year than Blink; worth it only if cross-platform sync matters beyond this phone. |

Recommendation: **Blink Shell** as the default SSH client for this use case
— lower annual cost than Termius, and Mosh is a real accessibility win
(no need to re-establish a session after every connection hiccup).

## Voice and dictation utilities

Given typing is to be minimized wherever possible, three distinct tools are
relevant here — they are not interchangeable:

- **Claude mobile Voice Mode** — full spoken conversation with Claude:
  speak, hear a spoken reply, switch to text mid-conversation. As of
  mid-2026 this has expanded past English-only to 18 languages (out of
  beta since June 2026) with push-to-talk. This is the closest thing to
  fully hands-free interaction with Claude on the phone.
- **Claude mobile dictation** — tap the microphone in the chat input;
  speech becomes editable text in the prompt box before sending, rather
  than a live spoken exchange. Useful when the text needs review before
  it goes anywhere (e.g. drafting a commit message).
- **Claude Code `/voice`** — push-to-talk voice input inside Claude Code
  on desktop (hold space bar to talk, release to send). Not a mobile
  feature; relevant only if/when coding sessions happen through Claude
  Code directly rather than via SSH + `arc`.

None of these are system-wide, type-into-any-app dictation. For that,
third-party tools exist (e.g. FluidVox, ~$2.99/month or ~$39 one-time for
on-device transcription) that type into any focused field, including a
terminal session — potentially useful for dictating commands into an SSH
session on the phone itself, though this has not been tested against
Blink Shell or Termius specifically.

## Monthly cost summary

Existing subscriptions (not `arc`-specific, included for full picture):

| Item | Cost |
|---|---|
| ChatGPT Plus | $20.00/month |
| Claude Pro | $20.00/month |

Proposed additions for mobile `arc` access:

| Item | Cost | Billing |
|---|---|---|
| Working Copy Pro Unlock | $35.99 | one-time |
| Blink Shell | ~$19.99/year (~$1.67/month equivalent) | annual |
| FluidVox (optional, if system-wide dictation is wanted) | ~$2.99/month or ~$39 one-time | monthly or one-time |

Ongoing monthly total if all optional items are added (Blink amortized,
FluidVox monthly): existing $40.00/month + ~$1.67 (Blink) + ~$2.99
(FluidVox) ≈ **$44.66/month**, plus a one-time $35.99 for Working Copy.
Skipping FluidVox brings ongoing monthly cost to ≈ **$41.67/month**.

Prices are as listed by each vendor at time of writing and may change —
worth reconfirming in the App Store before purchasing.

## Open questions / next steps

- Test Blink Shell (or Termius) against `ara` and Ubuntu: confirm Mosh
  session survives a real network drop, confirm VoiceOver usability of
  the app itself.
- Test Working Copy against the `arc` repo: clone, edit a doc, commit,
  push — confirm VoiceOver can navigate the diff/commit UI comfortably.
- Decide whether FluidVox (or an alternative) is worth adding for
  dictating directly into an SSH terminal session, versus relying on
  Claude Voice Mode / dictation for anything that goes through Claude.
- No changes to `aliases.sh` are implied by this doc — the phone does not
  source it and is not expected to.
