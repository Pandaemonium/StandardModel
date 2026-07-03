# Overnight NERD run 2026-07-02: system of record

Two co-equal goal-mode agents - Claude 4.8 (Claude Code) and Codex 5.5 -
work this repo overnight, sharing and refining ideas, submitting jobs to
Aristotle, and integrating results. Aristotle serves both as the proof
engine and as a third intelligent partner (strategy, red-team, triage
jobs). This file is the contract; the shared state lives in `LEDGER.md`
and `DISCUSSION.md` in this directory.

Design inputs: `docs/NERD_ROADMAP.md` (priorities), `docs/ARISTOTLE.md`
(mechanics), and the 2026-06-23 postmortem
(`AgentTasks/null-edge-codex-overnight-run-postmortem-2026-06-23.md`),
whose lessons are baked in as rules below.

## Mission (in priority order)

1. Advance the Gate C1 critical path (`TetraFreeOperatorGap_equalN` chain)
   and harvest/integrate the completed checkerboard wave.
2. Land the Gate I1 kinematic core in Lean (first clusters).
3. Land the Gate D finite stack (D1, D2, D6; D3.0 statement + submission).
4. Run Aristotle-as-partner jobs: L0.1 no-go audit; C1 semantic red-team.
5. Q2 massless calibration numerics + D3.1 modular-defect measurement.
6. C0 three-J / claim-scope audit note.
7. Liberal literature scouting and ingestion, woven through every lane
   (protocol below).

Per-task first moves and tiered success criteria (baseline / strong /
shocking) live in `TASK_DIRECTIONS.md`. **Aim at the shocking tier;
baseline is the floor, not the target.**

Preflight fact (verified 2026-07-02 ~21:00 by the planning session):
`aristotle list` authenticates; there are 7+ IDLE
`null-edge-checkerboard-*` projects awaiting harvest and one RUNNING
project (`81f6a500`, ms1-tiling, non-null-edge). Nine prepared C1 prompt
files sit unsubmitted in `AgentTasks/aristotle-prompts/gate-c1-c264..c272`.

## What a shockingly successful night looks like

The per-lane tiers are in `TASK_DIRECTIONS.md`; the global picture is:

```text
C1 free core (operator gap + self-adjointness) kernel-checked,
  or an honest obstruction minimized and banked;
the COMPLETE P2 theorem set (I1 + A1 + A2 + I3.5 + U(2) split) verified;
D3.0 (finite half-sided-inclusion triviality) proved;
first F-M2 data: QNEC deficit and modular-defect scaling exponents;
L0.1 audit and C1 red-team verdicts triaged into actions;
Q2 novelty check resolved; Gate D reading backlog ingested;
every new statement prior-art-checked.
```

That is about a month of normal program progress in one night, and it is
reachable because every target is finite mathematics with prepared
statements and an authenticated proof engine. Two clarifications:

- **Ambition raises the theorem count, never lowers the verification
  bar.** The guardrails below are unchanged at every tier.
- **Honest negatives count as shocking successes**: a refuted statement,
  a caught semantic bug, or a minimized obstruction is worth as much as
  a proof, because each one redirects weeks of effort.

## Architecture

```text
Claude 4.8 (goal mode)  <-- co-equal partners -->  Codex 5.5 (goal mode)
        |        \\                       //         |
        |         shared LEDGER.md + DISCUSSION.md   |
        |                    |                       |
        +---------->   Aristotle (proof jobs + strategy/red-team jobs)
                             |
                  AgentTasks/aristotle-output/, integrate_completed.py
```

- Both agents run in the same working tree on `main`. Safety comes from
  task claims (file globs) in the ledger, not from isolation.
- Aristotle is consulted three ways: focused proof jobs; strategy/audit
  jobs at branch points; `aristotle continue --mode ask` triage on
  running jobs.
- Gemini may be consulted only through
  `Scripts/autonomous_loop/send_gemini_review.py` (logs to
  `AgentTasks/model-calls/gemini/`). Partner-to-partner exchange happens
  in `DISCUSSION.md`, which is self-logging.

## Coordination protocol

**Claims.** The ledger task board is the single source of truth. To work
a task: set its row to `claimed-<agent>`, add the file globs you will
touch, post a heartbeat. One active task per agent (plus passive
Aristotle waiting). Never edit files inside the other agent's claimed
globs. A claim with no heartbeat for 90 minutes may be taken over after
posting a note in `DISCUSSION.md`.

**Heartbeats.** Every cycle (30-45 min), append one line to the ledger
heartbeat log: local time, agent, current task, next step. Cheap, but it
is how the other agent and the user reconstruct the night.

**Cycle shape.** (1) Read ledger + discussion deltas. (2) Respond to any
review requests addressed to you (these outrank new work). (3) Act on
your claim. (4) Poll Aristotle registry if you own submissions. (5) Post
heartbeat; update board; post a discussion note only when you have
something substantive (an idea, a risk, a red-team hit - do not force
chatter).

**Cross-review (the co-equality mechanism).** Required before:
- submitting any new-statement Aristotle proof job (statement review),
- integrating any Aristotle result into the live tree (semantic review),
- changing any claim-language document.
Open a `review:<short-id>` thread in `DISCUSSION.md` with the exact Lean
statement or diff pointer. The other agent answers within one cycle with
verdict + three questions: what changes a theorem target? what would
demote the claim? what is the most ambitious defensible version of this
statement? Reviewer verdict is recorded in the thread. Exception: harvesting/integrating a
job that was submitted BEFORE tonight only needs the standard
integration checklist plus a post-hoc review note.

**Disagreement.** Argue from math and repo evidence, max two rounds. If
unresolved and load-bearing: submit it as an Aristotle strategy/audit
question (mode ask on a related running job, or a small strategy job) as
tiebreaker, or park it in the ledger `Parked for user` section with both
positions stated. Never resolve a disagreement by silently proceeding.

**Commits.** Checkpoint commits to `main` are allowed and encouraged
after each integrated + verified batch. Rules: `git add` explicit paths
only (your claimed files + shared run files); message prefix
`overnight-20260702: `; run `pre-commit run --files <paths>` first; no
push. On a `.git/index.lock` collision, wait a few seconds and retry;
never delete the lock unless the other agent's heartbeat is >30 min
stale.

## Aristotle protocol (lessons enforced)

1. **Harvest before submitting.** Sweep all IDLE projects with the
   dry-run integration helper first; the previous run's biggest win was
   banked results, its biggest cost was integration debt.
2. **Focused standalone Mathlib-only packages** via
   `Scripts/prepare_aristotle_focused_submission.ps1` (invoke with `&`,
   pwsh is not on PATH). Never point a package at a file that imports the
   full project. Tell Aristotle to run the narrow
   `lake env lean <file>` first, not `lake build`. The "no .lake folder"
   warning at submit time is expected.
3. **Fewer, sharper jobs - and sharp includes ambitious.** Every
   submission must name the gate and ladder step it advances (C1 chain
   step, I1.n, D.n, L0.1) in the task note. No "natural follow-up" jobs
   that do not change a research decision. Soft caps: 6 concurrent proof
   jobs + 2 strategy jobs - the caps exist to block filler, not
   ambition; one ambitious multi-target package counts as one job.
   Aristotle is the top Lean prover available to this repo and exists to
   be pushed with ambitious proofs - do not sandbag statements to raise
   the apparent success rate.
4. **Ambition calibration.** Small proofs - finite lemmas where you can
   already see the argument (I1.1-I1.4, D1, D2(i), D6(i) and their kin) -
   just complete them locally, now: no discussion thread, no remote
   budget. Large ambitious targets - full-chain theorems, D3.0-class
   lemmas, statements whose right formulation is uncertain - get one
   `idea:`/`review:` round to refine the statement together, then go to
   Aristotle at full strength, un-weakened. If you beat a submitted job
   locally, cancel it (this happened last run and was correct).
5. **Registry discipline.** Every submission, poll result, ask-mode
   answer, and integration goes in the ledger registry table with
   project id (canonical locator), targets, status, and owner. Run
   `aristotle list` before any resubmission - timeouts can occur after
   project creation.
6. **Integration checklist** (per `docs/ARISTOTLE.md`): dry-run helper ->
   read the report not the tree -> signature-change check (stop and audit
   if any statement changed) -> placeholder scan -> `lake env lean` on
   the target -> cross-review -> copy -> targeted `lake build` -> ledger.
   Batch fetches; never batch semantic review.
7. **Aristotle as partner.** Strategy/red-team jobs follow the
   `AgentTasks/aristotle-prompts/*.prompt.md` format: context, explicit
   deliverable filename, numbered questions, claim guardrails. Use
   `--mode ask` freely on running jobs for triage ("solved targets?
   exact blockers? keep waiting or split?"). Prompts must state: ASCII
   in returned code and prose; spaced placeholder-token forms in prose.

## Literature protocol (liberal by design)

Search early, search often, and ingest what you use. The graph only
compounds if tonight's finds land in it.

**When (non-exhaustive):** before drafting any new theorem statement
(prior-art check); before submitting an ambitious Aristotle job (context
for the prompt); whenever a claim depends on a paper's internals (use
`--chunks`, never trust the abstract); when a strategy report cites
work; and for the standing checks listed in `LIT_LOG.md` (Q2 novelty,
C1 positioning set, Gate D backlog).

**How:** meaning-based search with
`Scripts/lit/neo4j_paper_search.py --query` (abstract level) and
`--chunks` (where in a paper a lemma/convention lives); exact lookups by
arxiv_id/doi/title via the `neo4j_graph` MCP Cypher; repo docs + Lean
via `Scripts/lit/neo4j_doc_search.py`. Web search is fine for discovery,
but anything load-bearing gets pulled into the graph. If the scripts
report missing `NEO4J_*` variables, run from a shell inheriting the
Windows user environment.

**Ingest:** `Scripts/lit/lit_ingest.py` (automates Zotero + Neo4j +
embeddings). Always run the pre-add existence check keyed on
arxiv_id/doi (not title); canonical `paper_key` = bare Zotero item key;
normalize ids; collection scoping requires the IN_COLLECTION edge to
`9W59V3K9`. No duplicates.

**Log:** every search-that-mattered and every ingest goes in
`LIT_LOG.md` with the claim or decision it affected. The morning report
summarizes it.

## Guardrails (non-negotiable)

- **No trusted promotion overnight.** Everything lands as draft modules
  plus task notes. Promotion to trusted requires the user's morning
  review. No `a x i o m` (spaced here intentionally), no `o p a q u e`,
  no statement weakening to force progress - hand hard targets to
  Aristotle or leave a documented handoff `s o r r y` in draft.
- **Convention discipline.** Mostly-minus signature; three-J separation
  and tetrahedral claim-scope rules in `docs/CONVENTIONS.md`; claim
  labels on every physics-facing sentence; C1 statements are
  regulator-level (see `docs/NERD_ROADMAP.md`).
- **Hygiene.** ASCII, LF, final newline; spaced escape-hatch tokens in
  prose; `pre-commit run --files` before every commit; do not reformat
  untouched files.
- **Build safety.** If the live tree stops building because of tonight's
  change: fixing it outranks everything; if unfixable in ~45 min, revert
  your own commits (`git revert`, not reset) and record why.
- **Scope.** No new physics lanes tonight. The mission list is closed;
  new ideas go to `DISCUSSION.md` and the morning report, not into code.

## Timeline (suggested, local time)

- **Phase A (first ~90 min).** T0 preflight + harvest sweep; wave-1
  triage of the nine prepared C1 prompts (cross-review which 3-5 to
  submit); submit wave 1 + the two partner jobs (T4).
- **Phase B (bulk of night).** Parallel lanes per the board; poll every
  30-45 min; integrate as returns arrive; local Lean on I1/D stacks; Q2
  numerics between polls.
- **Phase C (from 05:30).** No new proof submissions. Final integration
  sweep, targeted builds, one full `lake build` if the live tree was
  touched, ledger reconciliation.
- **Phase D (by 07:30).** Morning report written (T8), cross-reviewed by
  the other agent, committed.

## Morning report spec (T8)

`MORNING_REPORT.md` in this directory, sections:

1. Executive summary (5 lines max).
2. Theorems landed: name, file, verification command actually run.
3. Aristotle registry final state (submitted/integrated/pruned/running),
   with project ids and job count.
4. Integration debt: harvested but not integrated, and why.
5. Decisions made + review-thread outcomes; disagreements parked for the
   user (with both positions).
6. Build + hygiene status (exact commands run and results).
7. Ideas raised but out of scope tonight.
8. Recommended next three actions.
9. Literature log summary: checks resolved, sources ingested (keys),
   claims affected.

Report faithfully: failed jobs, refuted statements, and reverted commits
are results, not embarrassments. A useful failed task beats a
misleading successful-looking patch.
