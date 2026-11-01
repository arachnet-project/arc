# ARC_FILE: docs/dev_workflow.md
# arc — development workflow
# Version: 1.0
# Created: 2026-07-27
# Updated: 2026-10-31

## Session opening

At the start of an ARC work session:

1. Read this workflow document.
2. Read `docs/project-summary.md` for carry-over context, then verify
   relevant claims against the live repository.
3. Read `docs/TODO.md` and identify the current next step.
4. Run `bash wrk/repo-session-open.sh --tracked-files` from the repository
   root and review its output. It uses local Git references and does not
   contact a remote.
5. If the working tree is clean and the repository state is understood,
   run `xpull` before beginning work. If the tree is dirty or the output
   conflicts with the project documents, preserve and review the changes
   before pulling or editing.

## Rules, in order of how much they cost when skipped

1. **Verify against the real file before trusting any memory or summary.**
   If a claim can be checked with `cat`, `grep`, `git status`, or
   `git log`, check it before acting on it. A prior session's summary is a
   starting hypothesis, not a fact.
2. **Never silently pick between conflicting accounts.** If two sessions
   (or a session and a live file) disagree, say so explicitly in the doc
   and leave it flagged as unresolved rather than quietly assuming one
   side is right.
3. **Write down a decision the moment it's made, not at session end.**
   Editor choice, design choice, rejected approach — each gets a line in
   the relevant doc as soon as it's settled.
4. **Don't mark something done until it's actually tested.** "Agreed in
   chat", "applied to disk", and "confirmed working" are three different
   states. Keep them visibly distinct using the status vocabulary below.
5. **Every session close-out updates `docs/project-summary.md` and
   `docs/TODO.md`, and ends with an explicit next-session plan.** The
   summary is updated at close-out, not as a substitute for verifying the
   live repository during the session.
6. **No exploratory dead end disappears without a note.** If an approach
   was tried and rejected (an editor, a library, a design), record it in
   the summary with the reason it was rejected, so it isn't re-tried next
   session.
7. **Commit is obligatory at close-out.**
8. **No machine is primary.** Any machine may pull, commit, and push. Pull
   before starting a work block. Commit and push before handing work to
   another machine or ending the work block. Leave each machine with a
   clean working tree so the next work block can start from the pushed
   state.
9. **Maintain document metadata.** Every maintained document includes
   `Created` and `Updated` dates in `YYYY-MM-DD` format. Update `Updated`
   whenever the document changes. Add a `Version` to stable guidance
   documents, such as workflows, conventions, and specifications, and
   increment it for substantive revisions. Do not number frequently
   changing trackers such as `TODO.md` or `project-summary.md`; Git
   history records their revisions.

## Status vocabulary

Use these words consistently in `TODO.md` and `project-summary.md` so
"done" never silently means "discussed":

| Status | Meaning |
|---|---|
| Proposed | An idea was raised; nothing written yet |
| Agreed | Design or wording settled in discussion, not yet applied |
| Applied | Written to the actual file on disk |
| Tested | Run for real and confirmed to behave as expected |
| Committed | Applied, tested, and pushed |

## Session close-out checklist

At the end of every session:

1. Update `docs/project-summary.md` with the current verified state,
   pending work, and unresolved questions.
2. Update `docs/TODO.md`; move items between Done, Pending review, and
   Pending only when their status supports it.
3. Write the next-session plan as a numbered, ordered list.
4. Flag conflicting accounts discovered during the session rather than
   resolving them by guessing.
5. Update Claude's memory (`memory_user_edits`) only with durable facts,
   not in-progress guesses.
6. Commit and push the close-out changes with `xcom`. Confirm that the
   push succeeded and that the working tree is clean before marking the
   close-out Committed.

## Scope

This workflow governs the ARC repository.
