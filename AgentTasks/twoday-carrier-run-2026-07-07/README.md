# Two-day carrier run (2026-07-07 -> 2026-07-09) - document map

A 48-hour co-equal **Claude Opus 4.8 + Codex 5.5** autonomous run executing the
Weitzenbock-carrier program (Fable-5's synthesis) with heavy Aristotle use and
2-hourly Fable-5 calls. Designed by Fable-5.

## Start here (per agent)

1. Read YOUR goal prompt: `GOAL_PROMPT_CLAUDE.md` / `GOAL_PROMPT_CODEX.md`.
2. Read `RUN_PLAN.md` (mission, arc, cadences, discipline, escalation).
3. Read `THREAD_BOARD.md` (your threads + done-conditions).
4. Post your standing claims to `LEDGER.md`; run the first cycle (harvest the
   three in-flight jobs listed in the ledger seed).

## The documents

| Doc | What it is | Mutability |
|---|---|---|
| `RUN_PLAN.md` | master plan: mission, 48h arc, cadence table, discipline, escalation ladder, success criteria | frozen (Fable call can amend) |
| `GOAL_PROMPT_CLAUDE.md` | Claude's standing orders (lanes T/A/carrier; 2-hourly Fable calls; 30-min lit; odd-hour strategy) | frozen |
| `GOAL_PROMPT_CODEX.md` | Codex's standing orders (lanes C/gauge/polymer; 30-min lit; even-hour strategy) | frozen |
| `THREAD_BOARD.md` | work queue with per-thread done-conditions and live status | edit-in-place (claim first) |
| `LEDGER.md` | THE coordination channel: claims, heartbeats, reviews, call digests | append-only |
| `FABLE_CALL_PROTOCOL.md` | the 2-hourly call, used OFFENSIVELY (CRACK hard cruxes / SYNTHESIZE / STRATEGIZE, ride-along RATIFY): mechanics, ambitious packet contract, call types, schedule | frozen |
| `FABLE_QUEUE.md` | standing escalation queue feeding the calls | append + mark-answered |
| `ARISTOTLE_PLAYBOOK.md` | heavy-use doctrine: fleet mix (proof/audit/strategy), stale-check, mechanics crib | frozen |
| `LIT_NEO4J_PROTOCOL.md` | literature cadence, graph read/write pipeline, priority reading list | frozen |
| `LIT_LOG.md` | numbered lit rounds (created at round 1) | append-only |
| `fable-calls/` | numbered call packets (committed) + the template | append |
| `MORNING_REPORT.md` | T+24 honest day-1 report | written once |
| `FINAL_REPORT.md` | T+48 honest final report (graded claims, lit delta, call log, next run) | written once |

## Context documents (prior run; read as needed)

- `AgentTasks/overnight-mass-run-2026-07-06/FABLE_STEER.md` - the organizing
  principle this run executes (the carrier, the Moves, the cruxes, re-scopes).
- `.../FABLE_HELP.md` - Fable's full synthesis (the reasoning).
- `.../HONEST_SCORECARD.md` - the program dashboard (updated by consolidations).
- `.../FABLE_LOOP_DESIGN_BRIEF.md` - the loop-design requirements this run
  implements (reading tiers + the 10 invariants).
- `AGENTS.md`, `docs/ARISTOTLE.md`, `docs/BUILD.md`, `docs/CONVENTIONS.md`,
  `docs/NULLSTRAND.md`, `docs/NERD_ROADMAP.md`, `Scripts/MCP_SERVERS.md`.

## The one-paragraph mission

Turn Fable-5's carrier verdict into kernel-checked mathematics: Move 1 (the
discrete Weitzenbock decomposition `D^#D = Q_A + Q_C + Q_T + E` on a finite
null-edge 2-complex), Move 2 (the component-identification lemmas, graded
irreducibility, and relative exhaustiveness - the unification theorem in honest
form), and Move 3 (the re-scoped strong-coupling SU(2) gap with explicit beta_0,
Osterwalder-Seiler mechanized) - with every claim graded PROVED/MODELED/OPEN,
every flagship axiom-guarded and cross-reviewed, the literature graph read
before building and grown along the way, and every conceptual fork routed to
Fable-5 instead of churned on.
