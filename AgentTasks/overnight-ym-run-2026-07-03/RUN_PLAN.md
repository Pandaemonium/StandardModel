# Overnight YM run 2026-07-03: system of record

Two co-equal goal-mode agents - Claude Sonnet 5 (Claude Code) and Codex 5.5 -
work this repo overnight on the Yang-Mills / confinement ladder (Track A of
`Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md`), sharing and refining
ideas, submitting jobs to Aristotle, and integrating results. Aristotle
serves both as the proof engine and as a third intelligent partner
(strategy, red-team, triage jobs). This file is the contract; the shared
state lives in `LEDGER.md` and `DISCUSSION.md` in this directory.

Design inputs: the YM program plan
(`Sources/Null_Edge_Yang_Mills_Mass_Gap_Program.md`), the statement freeze
(`AgentTasks/nerd-gate-ym0-ym4-analysis-freeze-2026-07-03.md` - READ IT IN
FULL, it is the night's substrate: pinned conventions C-1..C-8, complete
finite-level proofs, the Aristotle package map, and the Mathlib
character-theory API map in its section 15), the 2026-07-02 run
(`AgentTasks/overnight-nerd-run-2026-07-02/RUN_PLAN.md`, whose protocol this
file inherits), and the 2026-06-23 postmortem lessons baked in below.

## Mission (in priority order)

1. YM3 flagship lane: character positivity (Theorem 3) -> finite Bochner
   (Cor 3a) -> transfer positivity (Cor 3b) -> link-reflection positivity
   RP-LINK -> reconstruction skeleton, with the C-8 trace identity as the
   acceptance test. Nobody has ever formalized reflection positivity; the
   freeze reduced the finite-G case to finite mathematics end to end.
2. YM1 completion: PKG-YM1-B (Z2 torus exact solution, even-cover
   combinatorics) and PKG-YM1-C (fusion lemma + nonabelian 2D exact
   solution) - the remaining content of "the first formalized lattice gauge
   theory theorems" paper unit.
3. YM0 breadth: general finite-G core (PKG-YM0-B: L1-L5 beyond Z2) and the
   D12 mass-gap definition module with 't Hooft flux sectors.
4. QCD1: the finite Banks-Casher spectral identity (PKG-QCD1-A), bridging
   the ladder to the existing C2 overlap machinery.
5. YM4 groundwork: Kotecky-Preiss statement freeze in Lean + polymer
   representation + strong-coupling oracle fixtures; submit PKG-YM4-A only
   if the board is healthy.
6. YM-LIT: the literature verification sprint (freeze/program debt
   register) - woven through every lane AND a standing lane of its own;
   includes the prior-formalization novelty check that gates every
   "first ever" claim.
7. Aristotle-as-partner jobs: YM3 semantic red-team; ladder strategy audit.

Per-task first moves and tiered success criteria (baseline / strong /
shocking) live in `TASK_DIRECTIONS.md`. **Aim at the shocking tier;
baseline is the floor, not the target.** `PREP_NOTES.md` records what the
planning session already verified and pre-built (oracle v0.2, Mathlib API
checks, the Route B simplification, Neo4j restart, lit-graph state, the
`WilsonWeightPositivity.lean` scaffold, both partner prompts) - read it
before starting T1/T2/T6 so nothing is re-derived.

Budget note (user-authorized for tonight): the program's standing rule
"the YM ladder gets at most one active Aristotle job" is LIFTED for this
run - tonight the ladder IS the program. The generic soft caps still
apply: 6 concurrent proof jobs + 2 strategy jobs, existing to block
filler, not ambition. The one-job rule resumes at morning review.

Preflight facts (verified 2026-07-03 by the planning session, `aristotle
list`): one RUNNING job, `203fd831` (gate-c2-flux2d-witness resubmission,
NOT a YM job - poll and harvest it, do not duplicate it); `a6ebbbf7`
(earlier flux2d) and `f501f8c8` (ym1-elitzur-core, already harvested and
integrated per freeze section 13) are IDLE; a deep IDLE backlog of audit
and C2 jobs exists - reconcile at T0 against
`AgentTasks/overnight-nerd-run-2026-07-02/LEDGER.md` before submitting
anything. The YM baseline (Elitzur chain, program docs) is committed at
`30a5523`; the planning session's prep (this run package, oracle v0.2,
the `WilsonWeightPositivity` scaffold, partner prompts) is committed on
top of it - T0 just verifies `git status` is clean before claiming work.

## What a shockingly successful night looks like

```text
RP-LINK kernel-checked for arbitrary finite gauge group - the first
  formalized reflection positivity anywhere - with the reconstruction
  skeleton and the C-8 trace identity as its acceptance test;
Theorem 3 + Corollaries 3a/3b (character positivity, finite Bochner,
  transfer positivity) kernel-checked;
the 2D exact solutions (Z2 torus + nonabelian fusion route) verified;
the D12 flux-sector gap definition compiled in Lean;
QCD1-i (exact finite Banks-Casher identity) proved on the C2 assets;
the Kotecky-Preiss statement frozen in Lean and cross-reviewed;
the debt register's load-bearing imports source-verified and ingested,
  with the prior-formalization novelty check resolved;
every new statement prior-art-checked, every convention oracle-pinned.
```

That is the entire finite-G floor of the YM ladder (YM0-YM3 content plus
the YM4 doorstep) in one night. It is reachable because the freeze already
did the mathematics: every target above has a complete finite-level proof
or a fixed proof route in the freeze document, and the hard search
(Mathlib character-theory API) is already mapped in its section 15. Two
clarifications:

- **Ambition raises the theorem count, never the verification bar.** The
  guardrails below are unchanged at every tier.
- **Honest negatives count as shocking successes**: a refuted statement, a
  caught convention slip, a Mathlib API gap documented precisely, or a
  novelty check that FAILS (someone did formalize LGT somewhere) is worth
  as much as a proof - each redirects weeks of effort and protects the
  papers.

## Architecture

```text
Claude Sonnet 5 (goal mode) <-- co-equal partners --> Codex 5.5 (goal mode)
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
  jobs at branch points; `aristotle continue --mode ask` triage on running
  jobs.
- Gemini may be consulted only through
  `Scripts/autonomous_loop/send_gemini_review.py` (logs to
  `AgentTasks/model-calls/gemini/`). Partner-to-partner exchange happens in
  `DISCUSSION.md`, which is self-logging.

## Coordination protocol

**Claims.** The ledger task board is the single source of truth. To work a
task: set its row to `claimed-<agent>`, add the file globs you will touch,
post a heartbeat. One active task per agent (plus passive Aristotle
waiting). Never edit files inside the other agent's claimed globs. A claim
with no heartbeat for 90 minutes may be taken over after posting a note in
`DISCUSSION.md`.

**Heartbeats.** Every cycle (30-45 min), append one line to the ledger
heartbeat log: local time, agent, current task, next step.

**Cycle shape.** (1) Read ledger + discussion deltas. (2) Respond to any
review requests addressed to you (these outrank new work). (3) Act on your
claim. (4) Poll Aristotle registry if you own submissions. (5) Post
heartbeat; update board; post a discussion note only when you have
something substantive.

**Cross-review (the co-equality mechanism).** Required before:
- submitting any new-statement Aristotle proof job (statement review),
- integrating any Aristotle result into the live tree (semantic review),
- changing any claim-language document.
Open a `review:<short-id>` thread in `DISCUSSION.md` with the exact Lean
statement or diff pointer. The other agent answers within one cycle with
verdict + three questions: what changes a theorem target? what would
demote the claim? what is the most ambitious defensible version of this
statement? Exception: harvesting/integrating a job submitted BEFORE
tonight only needs the standard integration checklist plus a post-hoc
review note.

**Disagreement.** Argue from math and repo evidence, max two rounds. If
unresolved and load-bearing: submit it as an Aristotle strategy/audit
question as tiebreaker, or park it in the ledger `Parked for user` section
with both positions stated. Never resolve a disagreement by silently
proceeding.

**Commits.** Checkpoint commits to `main` are allowed and encouraged after
each integrated + verified batch. Rules: `git add` explicit paths only
(your claimed files + shared run files); message prefix
`overnight-ym-20260703: `; run `pre-commit run --files <paths>` first; no
push. On a `.git/index.lock` collision, wait a few seconds and retry;
never delete the lock unless the other agent's heartbeat is >30 min stale.

## Aristotle protocol (lessons enforced)

1. **Harvest before submitting.** Reconcile the IDLE backlog against the
   previous run's ledger first; poll and harvest `203fd831` (flux2d) when
   it completes. Banked results were the previous runs' biggest win;
   integration debt their biggest cost.
2. **Focused standalone Mathlib-only packages** via
   `Scripts/prepare_aristotle_focused_submission.ps1` (invoke with `&`,
   pwsh is not on PATH). Never point a package at a file that imports the
   full project. Tell Aristotle to run the narrow `lake env lean <file>`
   first, not `lake build`. The "no .lake folder" warning at submit time
   is expected. Package naming: `ym3-charpos-rp-20260703`,
   `ym1-torus-evencover-20260703`, etc., under
   `AgentTasks/aristotle-standalone/`.
3. **Fewer, sharper jobs - and sharp includes ambitious.** Every
   submission must name the ladder rung and freeze section it advances
   (YM3 Theorem 3, YM1 Theorem 2', QCD1-i, ...) in the task note. One
   ambitious multi-target package counts as one job. Do not sandbag
   statements to raise the apparent success rate.
4. **Ambition calibration.** Small proofs you can already see (the freeze
   has complete paper proofs for Theorems 1-3 and their lemmas - many
   steps are direct) - just complete them locally, now. Large targets or
   uncertain formulations (RP-LINK's cut-factorization bookkeeping, KP's
   statement shape) - one `idea:`/`review:` round to refine the statement
   together, then Aristotle at full strength, un-weakened. If you beat a
   submitted job locally, cancel it.
5. **Registry discipline.** Every submission, poll result, ask-mode
   answer, and integration goes in the ledger registry table with project
   id, targets, status, and owner. Run `aristotle list` before any
   resubmission.
6. **Integration checklist** (per `docs/ARISTOTLE.md`): dry-run helper ->
   read the report not the tree -> signature-change check (stop and audit
   if any statement changed) -> placeholder scan -> `lake env lean` on the
   target -> cross-review -> copy -> targeted `lake build` -> ledger.
   Batch fetches; never batch semantic review.
7. **Aristotle as partner.** Strategy/red-team jobs follow the
   `AgentTasks/aristotle-prompts/*.prompt.md` format: context, explicit
   deliverable filename, numbered questions, claim guardrails. Prompts
   must state: ASCII in returned code and prose; spaced placeholder-token
   forms in prose.
8. **Context packs.** Before a nontrivial submission, generate a semantic
   context pack with `Scripts/aristotle/make_context_pack.py` unless the
   target is tiny and self-contained. For YM packages, the freeze
   document's relevant section pasted verbatim usually IS the right
   context - it contains the complete paper proof to formalize.

## Convention and oracle discipline (YM-specific, normative)

- Conventions C-1..C-8 in the freeze document are NORMATIVE. Any Lean
  statement touching plaquette orientation, weights, character
  coefficients, or the transfer matrix must match them; when in doubt,
  check against `Scripts/oracle/validate_lgt_core.py` (v0.2, 36/36 as of
  the planning session).
- **Oracle-first rule:** any NEW convention-sensitive statement (a new
  group, a new observable, a new normalization) gets an oracle fixture
  BEFORE its Lean statement is frozen. Oracle output corroborates; it is
  never cited as proof. ORACLE-TODO-1 and -2 were CLOSED by the planning
  session (oracle v0.2, section [9]); the new fixture found a normative
  fact for tonight's statement files - the fusion lemma's argument order
  (state it in convolution form `sum_h w(h) chi_R(h^{-1} A)`; the freeze
  s4 order is valid only for inversion-symmetric weights). Details:
  `PREP_NOTES.md` section 1.
- **LINK vs SITE reflection are different theorems.** Tonight formalizes
  LINK reflection only (freeze section 6). Do not blur them in names,
  docstrings, or claims.
- **D12 flux-sector qualifier is load-bearing.** The finite-lattice mass
  gap is defined in the Gauss-invariant, zero-momentum, trivial 't Hooft
  flux sector. A gap definition omitting flux quantum numbers measures a
  winding flux line, not a glueball (oracle-discovered, freeze section 1).

## Literature protocol (liberal by design - tonight leans on it hard)

Search early, search often, and ingest what you use. The standing target
list with per-item verification goals is in `LIT_LOG.md`; the protocol:

**When (non-exhaustive):** before drafting any new theorem statement
(prior-art check); before submitting an ambitious Aristotle job (context);
whenever a claim depends on a paper's internals (use `--chunks`, never
trust the abstract); before writing any "first ever formalized" phrase
(the novelty check is a LIT_LOG standing item); when a strategy report
cites work.

**How:** meaning-based search with
`Scripts/lit/neo4j_paper_search.py --query` (abstracts) and `--chunks`
(where in a paper a lemma/convention lives); exact lookups via the
`neo4j_graph` MCP Cypher; repo docs + Lean via
`Scripts/lit/neo4j_doc_search.py`. Web search is fine for discovery, but
anything load-bearing gets pulled into the graph. If the scripts report
missing `NEO4J_*` variables, run from a shell inheriting the Windows user
environment.

**Ingest:** `Scripts/lit/lit_ingest.py` (Zotero + Neo4j + embeddings).
Always run the pre-add existence check keyed on arxiv_id/doi (not title);
canonical `paper_key` = bare Zotero item key; collection scoping requires
the IN_COLLECTION edge to `9W59V3K9`. No duplicates.

**Log:** every search-that-mattered and every ingest goes in `LIT_LOG.md`
with the claim or decision it affected.

## Guardrails (non-negotiable)

- **No trusted promotion overnight.** Everything lands as draft modules
  under `PhysicsSM/Draft/NullEdge/GateYM/` (wired into the `GateYM.lean`
  aggregator) plus task notes. Promotion requires the user's morning
  review. No `a x i o m` (spaced intentionally), no `o p a q u e`, no
  statement weakening - hand hard targets to Aristotle or leave a
  documented handoff `s o r r y` in draft.
- **F-YM-CONFLATE (constitution-grade).** Keep three notions separate at
  all times: (a) mass gap (spectral), (b) Wilson-loop area law
  (confinement), (c) entanglement area law (unrelated here). Never present
  a lattice-regime result as the prize target. Finite-volume Polyakov-loop
  vanishing is a symmetry identity, not confinement (freeze L5). All
  claims regulator-level.
- **Attribution vs correctness debt.** The finite-G proofs are
  self-contained (zero correctness debt); the names Elitzur, Wegner,
  Osterwalder-Seiler, Kotecky-Preiss carry ATTRIBUTION debt until YM-LIT
  verifies sources. Fine to use the names in file/theorem comments with a
  "attribution pending YM-LIT" tag; not fine in any claim-language or
  paper-facing sentence until verified.
- **Hygiene.** ASCII, LF, final newline; spaced escape-hatch tokens in
  prose; `pre-commit run --files` before every commit; do not reformat
  untouched files.
- **Build safety.** If the live tree stops building because of tonight's
  change: fixing it outranks everything; if unfixable in ~45 min, revert
  your own commits (`git revert`, not reset) and record why.
- **Scope.** No new physics lanes tonight; Track B (YMG gates) and YM2-PW
  (Peter-Weyl) are explicitly OUT - note ideas in `DISCUSSION.md`, do not
  code them. The mission list is closed.

## Timeline (suggested, local time)

- **Phase A (first ~90 min).** T0 preflight: baseline commit, registry
  reconciliation, flux2d poll; the `design:ym3-unitarity` decision thread
  resolved (it gates the flagship lane); T1/T2 statement files started;
  wave-1 submissions cross-reviewed and sent.
- **Phase B (bulk of night).** Parallel lanes per the board; poll every
  30-45 min; integrate as returns arrive; local Lean on the small freeze
  lemmas between polls; YM-LIT woven through.
- **Phase C (from 05:30).** No new proof submissions. Final integration
  sweep, targeted builds, one full `lake build` if the live tree was
  touched, ledger reconciliation.
- **Phase D (by 07:30).** Morning report written (T8), cross-reviewed by
  the other agent, committed.

## Morning report spec (T8)

`MORNING_REPORT.md` in this directory, sections:

1. Executive summary (5 lines max).
2. Theorems landed: name, file, verification command actually run, axiom
   footprint.
3. Aristotle registry final state (submitted/integrated/pruned/running),
   with project ids and job count.
4. Integration debt: harvested but not integrated, and why.
5. Decisions made + review-thread outcomes; disagreements parked for the
   user (with both positions).
6. Build + hygiene status (exact commands run and results).
7. Ideas raised but out of scope tonight.
8. Recommended next three actions (including: which YM paper unit is
   closest to assembly, and whether the one-job budget rule should stay
   lifted).
9. Literature log summary: register items verified, novelty checks
   resolved, sources ingested (keys), claims affected.

Report faithfully: failed jobs, refuted statements, and reverted commits
are results, not embarrassments. A useful failed task beats a misleading
successful-looking patch.
