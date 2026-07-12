# Start here: Section 7 six-gate run

Run window: 2026-07-12 10:30 PDT to 2026-07-13 10:30 PDT.

Mission: attack the six open challenges in Section 7.1-7.6 of
`Sources/Null_Edge_Program_Overview_Packet_2026-07-12.tex` without confusing a
finite avatar with the continuum physics it is meant to approach.

Read in this order:

1. `RUN_PLAN.md`;
2. `PACKET_REVIEW_2026-07-12.md`;
3. `SECTION7_GATE_MATRIX.md`;
4. the previous run's `FINAL_REPORT.md` and `HONEST_SCORECARD.md` in
   `AgentTasks/24h-publication-run-2026-07-12/`;
5. your executor prompt;
6. exact Lean sources and primary literature for the lane you claim.

Coordination is append-only through `LEDGER.md`. Claim a target before editing
or submitting it. Do not edit the same manuscript section concurrently.

Executor prompts:

- Codex: `GOAL_PROMPT_CODEX.md`;
- Opus: `GOAL_PROMPT_OPUS.md`;
- compatibility pointer: `GOAL_PROMPT_CLAUDE.md`.

The Opus wrapper reported `Credit balance is too low` at 10:13 PDT. The failed
call is logged at
`AgentTasks/model-calls/claude/2026-07-12-101329-six-open-gates-24h-strategy.md`.
Retry through the repository wrapper; do not silently replace Opus with a
different model. Codex work continues while that external service is
unavailable.
