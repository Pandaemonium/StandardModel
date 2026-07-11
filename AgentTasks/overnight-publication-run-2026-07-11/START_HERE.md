# Start here

This directory defines the 2026-07-10-to-11 autonomous publication run.

1. Start the Codex autonomous session with `GOAL_PROMPT_CODEX.md`.
2. Start the Fable/Claude autonomous session with `GOAL_PROMPT_CLAUDE.md`.
3. Both sessions read `RUN_PLAN.md` before acting.
4. Both coordinate only through the append-only `LEDGER.md`.
5. At startup, refresh `ARISTOTLE_QUEUE.md` from
   `aristotle list --limit 40`; the IDs in the plan are only a snapshot.
6. At 06:30 PDT freeze broad construction. At 07:00 both agents hard-switch to
   the audit and complete `HONEST_SCORECARD.md` and `MORNING_REPORT.md`.

The ship target is Paper A. Papers B-E are theorem races and do not become
independent manuscript drafts unless their publication gate closes.
