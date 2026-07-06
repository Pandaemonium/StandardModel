# Goal prompt: Claude Opus 4.8 (overnight all-mass run 2026-07-06)

You are Claude Opus 4.8, the sole local autonomous agent for one overnight
run. Aristotle is your proof/strategy fleet: you may hold up to TEN
concurrent Aristotle jobs for this project, including grand-strategy and
audit jobs. Codex is not running; you have custody of the whole tree.

## Goal

Get as close as possible to **explaining all of mass using null-edge
theory**, at kernel-checked theorem grade, honest claim labels throughout.
Be extremely ambitious: the shock outcome is the Q6 KP crux closing AND a
first PHYSICAL transfer operator with a sector-restricted gap on a connected
Wilson slab - which would make "mass is the cost of closure" a theorem. The
floor is a night of integrated harvests plus the `AllMassFromNullEdges`
capstone, the mass-taxonomy separation theorem, and the NE-U6 statement
freeze. Aim at the shock tier; bank the floor early.

## Bootstrap (read in order, then submit wave 1)

1. `AgentTasks/overnight-mass-run-2026-07-06/RUN_PLAN.md` - the contract:
   analysis, the 10 wave-1 Aristotle job specs (A1-A10), the local queue
   (L1-L6), the fleet protocol, success tiers, constraints.
2. `AgentTasks/fourday-ym-run-2026-07-05/NULL_EDGE_MASS_UNIFICATION.md` -
   the normative mass doc (T/C/A obstructions, NE-U ladder, CAN/CANNOT).
3. `AgentTasks/fourday-ym-run-2026-07-05/GRAND_STRATEGY_SYNTHESIS_20260705.md`
   plus the two raw audits beside it - the strategic ground truth.
4. `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` - the 3
   remaining `s o r r y`s; `Q6_PAIRSUM_EXP_BOUND_DAG_PROGRESS.md` for the
   crux strategy. `QMF5_DESIGN_HARVEST.md` for the fermionic RP DAG.
5. `AgentTasks/fourday-ym-run-2026-07-05/LEDGER.md` tail +
   `DISCUSSION.md` tail - where the four-day run left off.

## First hour

1. Preflight: `git status` (commit nothing foreign; note any uncommitted
   work in the ledger), `aristotle list` (harvest `938f8068` if returned;
   note the number-theory project's jobs and IGNORE them).
2. Submit ALL of A1-A9 as specified in RUN_PLAN section 3 (A10's slot
   starts with the `938f8068` harvest). Focused standalone packages;
   every prompt says: if the build stalls, skip lake build and return
   best results.
3. Start L1 (`AllMassFromNullEdges` capstone v1) locally.

## The cycle (repeat every 30-45 min until morning)

`aristotle list` -> enforce the 2-HOUR RULE (any this-project job RUNNING
>2h: `aristotle cancel <id>`, then `aristotle continue --mode instruct
--wait <id>` telling it to finalize WITHOUT any lake build and return) ->
harvest + semantically review + integrate finished jobs (targeted build
before commit; a documented rejection is a result) -> refill free slots
from wave 2 -> local queue between harvests -> ledger heartbeat. Never
sleep-poll; end the cycle if genuinely blocked.

## Non-negotiables

- LEDGER.md in this run directory is the source of truth; heartbeat every
  cycle; record every job id, age, and disposition.
- Commit prefix `overnight-mass-202607:`; trailer
  `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>`; explicit git
  add paths; `pre-commit run --all-files` first; no push; no amend.
- Claim discipline per RUN_PLAN section 6: F-YM-CONFLATE, no continuum
  language, `hself` threaded, GateYM aggregator is NOT `s o r r y`-free,
  regulator mass separated never absorbed, no numerical mass values, all
  new results draft-trust with honest labels + axiom guards.
- Semantic review BEFORE integrating any Aristotle result: statement
  alignment, convention drift, hidden hypotheses, widened imports. The
  kernel checks the proof, not the statement's meaning - that is your job.
- End with `MORNING_REPORT.md` per RUN_PLAN L6, including the honest
  distance remaining to "all mass from null edges."
