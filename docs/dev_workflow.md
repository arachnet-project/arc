# ARC_FILE: docs/dev_workflow.md

# arc — development workflow

## Rules, in order of how much they cost when skipped

1. **Verify against the real file before trusting any memory or summary.**
   If a claim can be checked with `cat`, `grep`, `git status`, or
   `git log`, check it before acting on it. A prior session's summary is
   a starting hypothesis, not a fact.

2. **Never silently pick between conflicting accounts.** If two sessions
   (or a session and a live file) disagree, say so explicitly in the doc
   and leave it flagged as unresolved rather than quietly assuming one
   side is right.

3. **Write down a decision the moment it's made, not at session end.**
   Editor choice, design choice, rejected approach — each gets a line in
   the relevant doc as soon as it's settled.

4. **Don't mark something done until it's actually tested.** "Agreed in
   chat" and "applied to disk" and "confirmed working" are three
   different states — keep them visibly distinct (see status vocabulary
   below) until all three are true.

5. **Every session close-out updates `docs/project-summary.md` and
   `docs/TODO.md`, and ends with an explicit next-session plan.** Not a
   vague "continue later" — a numbered list, ordered, of what happens
   first.

6. **No exploratory dead end disappears without a note.** If an approach
   was tried and rejected (an editor, a library, a design), it goes in
   the summary with the reason it was rejected, so it isn't re-tried
   next session.

7. **Commit is obligatory at close-out**

## Status vocabulary

Use these words consistently in `TODO.md` and `project-summary.md` so
"done" never silently means "discussed":

| Status | Meaning |
|---|---|
| Proposed | An idea was raised, nothing written yet |
| Agreed | Design/wording settled in chat, not yet applied to any file |
| Applied | Written to the actual file on disk |
| Tested | Run for real and confirmed to behave as expected |
| Committed | Applied, tested, and pushed |

## Session close-out checklist

At the end of every session:

1. Update `docs/project-summary.md` with current state — what's
   verified, what's pending, what's still unresolved.
2. Update `docs/TODO.md` — move items between Done / Pending review /
   Pending as their status actually changes.
3. Write the next-session plan as a numbered, ordered list.
4. Flag any conflicting accounts discovered this session rather than
   resolving them by guessing.
5. Update Claude's memory (`memory_user_edits`) only with durable facts —
   not with in-progress guesses.

## Scope

This workflow applies to `arc` only. It's independent of `ACE`'s own
`dev_workflow.md` — no visibility exists between the two Projects, so if
ACE's doc has rules not captured here, they need to be copied over by
hand, not assumed to carry across automatically.
