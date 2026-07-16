# AFPL local agent instructions

Repository-root `AGENTS.md` remains authoritative. These instructions govern
work inside `AutonomousLab/`.

## Persistent state is part of the product

- Run `python AutonomousLab/scripts/labctl.py validate` at session start and
  before handoff.
- Treat `state/LAB_STATE.json`, `PORTFOLIO.json`, and `WORK_ITEMS.json` as the
  current machine-readable truth.
- Append to `state/LEDGER.md`; do not rewrite history.
- Record durable changes in decisions, blockers, incidents, or lessons as
  appropriate.
- Do not create a new ad-hoc autonomous-run constitution when the work belongs
  in an existing AFPL project. Create a bounded work item instead.

## Roles

- Use the role assigned by the work item and load the shared constitution plus
  model overlay (`codex`, `claude` for interactive Claude Code sessions, or
  `aristotle`).
- A role switch within one model context is self-review, not independent
  review.
- Builder and skeptic must be different **model families** for headline
  promotion: Codex/GPT, interactive Claude Code, and Aristotle.
  `labctl.py validate` enforces this.
- AFPL does not invoke Claude through an API or repository review wrapper.
  Claude-family work is performed in the user-started interactive Claude Code
  session and coordinated through the durable mailbox.
- Aristotle cannot own a work item; it contributes through jobs recorded in
  `state/ARISTOTLE_JOBS.json`.
- Release candidates require independent reproduction.

## State changes

- Prefer `labctl.py transition` for lifecycle changes so state and ledger stay
  synchronized; use `labctl.py log` for other ledger appends so timestamps
  come from the system clock (hand-written stamps have drifted from wall
  time in recorded runs).
- JSON state files have a single writer at a time: the agent currently acting
  as Lab Manager. On an edit conflict, re-read and re-apply; never overwrite
  another agent's entry. Validate before and after mutations.
- Use `--force` only with a decision or incident record explaining the
  nonstandard transition.
- Keep JSON UTF-8, LF, deterministic indentation, and schema version 1.
- Human-only decisions are appended to `state/DIRECTOR_QUEUE.md` with context
  and a safe default; agents never act on queued entries.
- Registries: `state/ARISTOTLE_JOBS.json` (fleet inventory, harvest states),
  `state/CLAIMS.json` (canonical claim grades/anchors), and
  `state/FORECASTS.json` (auto-appended by `labctl.py transition`).
- Do not store secrets, API keys, binary outputs, or large generated artifacts
  in lab state.

## Scientific discipline

- Every project and work item has a kill condition.
- Every result distinguishes claim grade and SRL.
- Do not promote a project based on its strongest isolated theorem.
- Preserve conventional baselines, failed routes, and external service
  degradation.
- Human-only decisions in `SAFETY_AND_AUTHORITY.md` remain human-only.
