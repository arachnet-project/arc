# ARC_FILE: docs/mobile-setup-howto.md

# Mobile setup howto (iPhone SE)

Companion to `docs/mobile-integration.md`. That doc explains the *why*;
this one is the *how* — what to install, where from, and a gradual test
sequence so nothing is trusted until it's actually confirmed working.

## 1. Install the apps

All from the App Store, on the iPhone SE itself.

| App | App Store search term | Cost |
|---|---|---|
| Working Copy | "Working Copy" (by Anders Borum) | Free to install; Pro Unlock $35.99 one-time (needed to push) |
| Blink Shell | "Blink Shell" | Free 2-week trial, then $19.99/year |
| Claude | "Claude by Anthropic" | Free app; you already have Pro |

If you'd rather try Termius instead of Blink, search "Termius" — same
process, ~$9.99–10/month instead. Doc recommends Blink for cost + Mosh,
but nothing below depends on which one you pick.

## 2. Set up GitHub access on the phone

Working Copy needs its own way to authenticate to GitHub — it does not
reuse keys from Ubuntu/macOS.

1. Open Working Copy.
2. Go to its settings (gear icon) → **SSH Keys** (or **GitHub** sign-in,
   Working Copy supports both — SSH key is more consistent with how
   Ubuntu/macOS already work, so that's the recommended path).
3. Generate a new key **inside Working Copy** (it stores the private key
   in the iOS Keychain — never move a key from Ubuntu/macOS onto the
   phone).
4. Copy the generated public key.
5. On github.com (any device): **Settings → SSH and GPG keys → New SSH
   key**, paste it in, save. Give it a recognizable name, e.g.
   "iPhone SE — Working Copy".

## 3. Set up SSH access to Ubuntu / `ara` from the phone

Same principle: generate a fresh key pair **on the phone, inside Blink**,
don't copy an existing private key onto it.

1. Open Blink Shell.
2. Run `ssh-keygen` inside Blink (or use its key management UI) to create
   a new key pair.
3. Copy the public key.
4. Add that public key to `~/.ssh/authorized_keys` on **both** Ubuntu and
   `ara` (the machines you want to reach) — from an existing session on
   each, not from the phone.
5. In Blink, add a host entry for each machine (hostname/IP, username,
   the key just created).

## 4. Gradual tests — Git side (Working Copy)

Do these in order; stop and report back if any step doesn't behave as
expected, rather than continuing.

1. **Clone, read-only:** clone `arc` from GitHub into Working Copy.
   Confirm you can browse the file list and open `README.md`.
2. **Edit, no commit:** open `docs/mobile-integration.md` in Working
   Copy's editor, make a trivial edit (e.g. add a blank line), then
   discard it without committing. Confirms the editor is usable with
   VoiceOver before anything is at stake.
3. **Commit, no push:** make a small real edit, commit it locally in
   Working Copy, but don't push yet. Confirms commit UI works.
4. **Push:** push that commit to GitHub. Confirms the SSH key set up in
   step 2 above actually works end to end.
5. **Pull:** from Ubuntu or macOS, `git pull` and confirm the change
   made on the phone shows up.

## 5. Gradual tests — SSH side (Blink Shell)

1. **Connect:** open the host entry for `ara`, connect, confirm you land
   in a normal shell prompt.
2. **Run something harmless:** `pwd`, `ls`, `echo hello` — confirm input
   and output are both readable via VoiceOver comfortably.
3. **Source `arc`:** `export PROJECT_ROOT=...` then
   `source ~/arc/aliases.sh`, confirm no errors.
4. **Try one `arc` command:** something low-stakes like `xls` or `xcat`
   on an existing file, to confirm the toolset behaves the same as on
   Ubuntu/macOS.
5. **Mosh resilience test:** start a Blink Mosh session, turn on Airplane
   Mode for a few seconds, turn it off, confirm the session is still
   alive rather than dropped.

<!--
NOTE FROM RECONSTRUCTION: the original doc likely continued past this
point (there was at least one more numbered item, and possibly a closing
note) — that part wasn't recoverable from conversation search. Worth
checking the source conversation directly if the ending matters:
https://claude.ai/chat/56dee56a-b392-4585-99e8-5ac8c2218758
-->
