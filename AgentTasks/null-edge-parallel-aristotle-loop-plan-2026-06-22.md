# Null-edge parallel autonomous Aristotle loop plan

Date: 2026-06-22

## Purpose

Drive the null-edge program with an autonomous agent that can run **up to about
five or six independent Aristotle projects in parallel** when that serves the
research. The objective is not high slot utilization. The objective is
semantically reviewed theorem, definition, and audit artifacts that move one of
the publication gates in
[`Sources/Null_Edge_Causal_Graph_Publication_Plan.md`](../Sources/Null_Edge_Causal_Graph_Publication_Plan.md)
toward a credible paper.

The north star is **publication-worthy progress**: bank trusted theorem islands,
stabilize definitions that unlock real theorems, and kill or demote beautiful
ideas when the finite tests fail. Prefer one result that clarifies a claim
boundary over several jobs that merely keep the scheduler busy. This supersedes
the cadence and concurrency model of
[`null-edge-autonomous-aristotle-loop-plan-2026-06-21.md`](null-edge-autonomous-aristotle-loop-plan-2026-06-21.md)
(one job per cycle, hourly). It does **not** replace that note's reusable parts:
the job ledger format, the pre-integration convention checklist, the Aristotle
prompt templates, and the definition backlog are inherited verbatim and only
referenced here.

What is new:

- an adaptive pool of up to about 5-6 concurrent jobs organized by publication gates;
- self-paced reconciliation cycles (submit, wait, integrate, refill when useful);
- explicit token-budget discipline so the agent spends Aristotle's clock, not its
  own context window;
- strategy jobs only when they can change the next decisions, plus stall
  triggers.

House rule, unchanged and load-bearing: lead with the finite, kernel-checked
algebra; keep continuum physics in an explicitly conjectural layer; never promote
draft to trusted without a semantic/convention review. The kernel checks the
proof, not that the statement is the intended one.

## Adaptive portfolio model

- **Concurrency is a ceiling, not a KPI.** Run up to about 5-6 Aristotle
  projects when there are that many independent, high-value jobs ready. Running
  two or three is better than filling slots with decorative work. Running six is
  fine when the jobs are independent and the next reconciliation still has
  integration budget.
- **Lanes are a map, not a scheduler.** The six lanes below organize the
  research surface. They do not require round-robin service, an idle-lane
  rotation, or equal attention. Advance the lane that can most plausibly unlock
  a publishable theorem, expose a decisive obstruction, or stabilize a shared
  definition. Revisit quiet lanes often enough to avoid losing easy wins, but do
  not spend a slot only to prove that every lane got a turn.
- **Refill by publication leverage.** At the end of every reconciliation, if there is
  capacity, fill open slots from the highest-value *ready* job: dependencies are
  all `INTEGRATED`, the target decl already elaborates with a lone placeholder
  body, and the result would change a publication claim, a gate, or a dependency
  frontier. It is acceptable, and often better, to leave capacity unused when the
  next available target is filler. Never submit a job whose target decl will be
  renamed or re-typed by a pending consolidation job.
- **One integration at a time.** Fetching and placeholder-scanning may be
  batched; draft-to-trusted promotion is strictly serial, one theorem per
  semantic review, per the inherited checklist.
- **Focused packages by default.** Use
  `Scripts/prepare_aristotle_focused_submission.ps1` (Mathlib + a few copied
  defs) for finite algebra / matrix / list / finset / small-API targets. Use the
  full-repo `Scripts/prepare_aristotle_submission.ps1` only when the target
  genuinely needs the project import graph. The recurring failure mode is a job
  that burns its budget on a full `PhysicsSM` build and times out before proof
  search; focused packages are the fix.

## Publication-first priority order

Use the lanes as a portfolio, but rank jobs by the result they can actually
deliver:

1. **Advance the strongest publication gate, not the prettiest queue.** The loop
   should always ask: which next result would make a paper more credible,
   sharper, or more honestly falsifiable? If the answer is one lane for three
   cycles in a row, keep pushing that lane.
2. **Treat P9 as the flagship physics campaign.** The cosmological-constant
   branch is worth front-loading because it can either give the program genuine
   leverage over a major physics problem or force a valuable demotion. It may
   receive multiple simultaneous jobs when they attack independent pieces of the
   finite visibility test: source definitions, boundary-exact vanishing,
   BF-closure/no-bulk-divergence, observer-channel recoverability, or residual
   fluctuation pilots.
3. **Promote clean completed standalones that unlock near papers.** The fetched
   artifacts in Lanes A-D are high value because they can convert existing
   Aristotle work into trusted or reviewable surfaces for P1, P2, P3, P7, and
   P9.
4. **Stabilize shared definitions before theorem campaigns.** A small, correct
   API that lets later jobs state the right theorem is better than a larger proof
   over names that will move. This matters most for `DiamondSourceVisibility`,
   observer channels, and the causal super-Dirac block.
5. **Prefer decisive negative results over decorative positives.** A `REFUTED`
   P9 or higher-gauge target that tells us the proposed mechanism cannot work is
   publishable guidance for the program. Record it, revise the statement, and
   demote the branch if the decision threshold is crossed.

## The six lanes

Each lane maps to a publication target in
[`Sources/Null_Edge_Causal_Graph_Publication_Plan.md`](../Sources/Null_Edge_Causal_Graph_Publication_Plan.md)
and carries a short ready-queue. The queues are ranked menus, not a fairness
contract. Detailed target decls, files, and dependencies live in the inherited
job ledger; only the lane head and immediate next jobs are summarized here.

### Lane A - Plucker / celestial bridge integration and repair (P1, P6 edge)

- **State.** `PhysicsSM.Spinor.PluckerMass` and `TwistorPluckerMass` trusted. The
  six-cycle run's celestial-bridge result (`ac0430a9-...`) is integrated as
  `PhysicsSM.Draft.NullEdgePluckerCelestialBridge`.
- **Ready queue.** (1) semantic review before any trusted promotion; (2)
  celestial-moment wrapper
  (`fin_bundle_det_eq_bloch_minkowski_norm`,
  `mass_zero_iff_bloch_dipole_saturates`); (3) Gram-weighted generalization
  bridge to P6, scoped orthonormal-vs-coherent.
- **Repair flavor.** This lane also absorbs convention-drift fixes surfaced by
  other lanes (signature, wedge normalization, `m^2 = det P` vs `P^2 = 2 det P`).

### Lane B - Yukawa mass-operator promotion into `PhysicsSM.Draft` (P2)

- **State.** The Yukawa mass-operator standalone (`24156b85-...`) closed all five
  targets and checks as a standalone artifact; not yet promoted into
  `PhysicsSM.Draft`.
- **Ready queue.** (1) promote the standalone into `PhysicsSM.Draft` with a
  convention audit of the Dirac square-root cluster (`NullEdgeDiracSlashCore`,
  `NullEdgeBundleDiracPluckerCore`, `NullEdgeDiracTwoSheetCore`,
  `NullEdgeSuperDiracBlockCore`); (2) one coherent operator narrative tying the
  blocks together with explicit gamma-matrix and signature conventions in one
  place; (3) the static operator spine
  (`chiralDiracSlash_bundleMomentum_sq_eq_pluckerMass` end to end).

### Lane C - relative entropy / recoverability scaffold (P7)

- **State.** The relative-entropy observer-channel scaffold and the
  recoverability-toy witness (`95795ba9-...`) are integrated as draft modules:
  `NullEdgeRelativeEntropyObserverRoadmap` and `NullEdgeRecoverabilityToy`.
- **Ready queue.** (1) semantic review of the finite observer-channel and
  classical KL/data-processing statements; (2)
  `massRatio_eq_sqrt_one_minus_blochNormSq` and
  `massRatio_monotone_under_unital_bloch_contraction`; (3)
  `petzRecoverable_iff_relativeEntropyLoss_zero` as a finite matrix statement, if
  isolable. Every job in this lane must **name the observer channel first**;
  monotonicity claims must name a finite LOCC or local hidden-channel class.

### Lane D - P9 source visibility and finite diamond-source additivity (P9)

- **State.** The diamond-source-visibility core (`9b37228c-...`) and the QNEC
  finite KL/DPI scaffold (`eb02f565-...`) are integrated as standalone artifacts;
  the spinor-network closure identity (`f1be6e52-...`) is integrated standalone,
  not yet promoted to `PhysicsSM`. The first focused boundary-source visibility
  job (`ea84d10d-...`) is integrated as
  `PhysicsSM.Draft.NullEdgeP9BoundarySource`; it proves the finite
  integration-by-parts theorem `boundaryExact_source_eq_zero`. The next focused
  BF-closure/no-bulk toy job (`789f2c53-...`) is integrated as
  `PhysicsSM.Draft.NullEdgeP9BFClosure`. The finite
  `DiamondSourceVisibility` wrapper/sanity-check job (`4b710873-...`) is
  integrated as `PhysicsSM.Draft.NullEdgeP9DiamondVisibility`. The finite
  mean-zero fluctuation job (`11e12028-...`) is integrated as
  `PhysicsSM.Draft.NullEdgeP9MeanZeroFluctuation`. The visible-closure
  source guardrail job (`e3558146-...`) is integrated as
  `PhysicsSM.Draft.NullEdgeP9VisibleClosureSource`. The P9 strategy/audit job
  (`b4a64238-...`) is running to rank the next nontrivial proof targets.
- **Scientific role.** This is the cosmological-constant flagship lane. Its job
  is not to "solve Lambda" in prose; it is to make the finite visibility test
  sharp enough that the branch can either clear the P9 gate or be demoted.
- **Substantive progress test.** A P9 job is worth a slot when it changes one of
  these facts: what the source observable is; which hidden/internal data are
  invisible to it; which visible Plucker excitations are bulk-visible; whether
  the residual behaves like a controlled mean-zero fluctuation; or whether the
  branch fails. It is not worth a slot when it merely restates "vacuum energy
  should not gravitate" in graph language.
- **Phase 1: guardrail integration.** Promote spinor-network closure
  (`pluckerMass_eq_energy_sq_sub_closureDefect_sq`,
  `closed_spinorFan_is_restFrame`) as a guardrail: visible closure is a rest-frame
  condition, not source invisibility. This prevents the P9 lane from confusing
  `C = 0` with vacuum.
- **Phase 2: minimal source API.** Stabilize `DiamondSourceVisibility` with the
  fewest definitions needed for theorem statements: finite diamond/screen,
  visible fan, BF/surface closure predicate, boundary-exact vs bulk source
  functional, observer/coarse-graining map, and source pairing with diamond
  holonomy/curvature.
- **Phase 3: toy visibility theorems.** Prove or refute the first finite source
  lemmas:
  `boundaryExact_source_eq_zero`,
  `bfClosure_implies_no_bulkDivergence`,
  `visiblePluckerMass_nonzero_of_noncollinear`,
  `diamondSource_additive_iff_orthogonal`, and a deliberately small theorem
  separating hidden/internal cancellation from visible rest energy.
- **Phase 4: information and fluctuation gate.** Add the finite
  relative-entropy/recoverability diagnostic that P7 can share. Only after that
  introduce an SJ-style finite diamond reference state, with the Pauli-Jordan
  truncation convention stated before any area-law or horizon-entropy claim.
  A residual-fluctuation pilot is valuable only if it addresses the mean-zero
  and amplitude issues that everpresent-Lambda already exposes.
- **Decision threshold.** If coherent/internal or BF-closed bookkeeping still
  produces a bulk volume-scaling source, or if the residual noise inherits the
  everpresent-Lambda amplitude problem with no suppression/correlation mechanism,
  report that the flagship branch failed its finite test.

### Lane E - Klein quadric / simple bivector / mass-as-simplicity-defect

- **State.** Aspirational (the bivector/BF simplicity-defect target). Gated on a
  finite `Lambda^2` wrapper compatible with the diamond composition laws.
- **Ready queue.** (1) Stage-0 irrep check (the Plucker bracket is `Lambda^2 S`,
  self-dual curvature is `Sym^2 S`, visible momentum is `S tensor Sbar`, the
  genuine bivector arena is `Lambda^2 C^4`) - submit this as a small design/audit
  job before any bivector proof; (2) `massless_iff_repeated_principal_spinor`;
  (3) a convention-audited off-quadric / simplicity-defect identity
  (`bivector_massDefect_eq_plucker`), kept separate from full spin-foam
  cross-simplicity until the EPRL/FK convention map exists.

### Lane F - higher-gauge interchange / fake-flatness, or a no-build audit (P3)

- **State.** `PhysicsSM.Gauge.CausalDiamondHolonomy` trusted; the path-pair
  interchange law (`3d595909-...`) is integrated.
- **Ready queue.** (1) the crossed-module / fake-flatness wrapper: identify which
  finite `H`-valued 2-cell labels, endpoint actions, and surface-transport
  conditions are *forced* by the trusted path-pair API; (2) the Abelian `2 x 2`
  grid defect factorization. When this lane has no ready proof job, submit a
  **no-build strategy/audit job** only if it will answer a live convention
  question, unblock a theorem, or decide whether the higher-gauge wrapper is
  forced or optional. Otherwise leave the capacity for a higher-leverage lane.

## Reconciliation cycle

One reconciliation = check status, integrate what is ready, and submit only what
is worth submitting. Keep each reconciliation cheap in tokens; the work is on
Aristotle's clock, not the agent's. The cadence is flexible. A 20-30 minute
check is reasonable when several jobs are active; a longer gap is better when
the queue is stable or the next step requires human-quality semantic review.

1. **Reconcile.** `aristotle list --limit 20`; for each `RUNNING`/`IDLE`/recently
   complete project run `aristotle tasks <project-id>` as needed. Update the
   inherited ledger rows in the same edit. The ledger is the single source of
   truth across checks; a shell timeout can occur *after* a project was created,
   so reconcile before resubmitting anything.
2. **Fetch + inspect (batched).** Run `Scripts/aristotle/integrate_completed.py`
   in dry-run mode for the newly completed projects. Read the helper's report and
   the `git diff --no-index` surface it prints - **not** the extracted tree.
3. **Integrate clean results (serial).** For each semantically-aligned,
   placeholder-free candidate: run the convention checklist, `--apply --build`,
   `lake env lean <file>`, targeted `lake build <module>`, set the ledger row to
   `INTEGRATED`, and update the task note from `complete` to `integrated` in the
   same edit. Stop and record a mismatch rather than integrating on any checklist
   failure.
4. **Refill opportunistically.** If there are high-value independent jobs ready,
   choose them by publication leverage, dependency-unlocking value, and semantic
   clarity. Generate a focused context pack
   (`Scripts/aristotle/make_context_pack.py --query "<target>"`), prepare the
   focused package, confirm the target elaborates with a lone placeholder, then
   `aristotle submit`. One submit at a time; verify each with `aristotle list`
   before the next so a timeout does not cause a duplicate. It is acceptable to
   stop below five when the next best job is merely filler or when integration
   debt is accumulating.
5. **Targeted research (only when a job needs it).** See the next section. Skip
   on most cycles.
6. **Choose the next check time.** Use the pacing notes below as defaults, but
   let scientific work dominate the timer. If a result needs careful reading,
   read it; if the next useful step is a P9 definition design, do that before
   filling slots.

A full `lake build` and `pre-commit run --all-files` run **once per integration
batch**, not every cycle, before claiming a trusted milestone.

## Pacing

- **Default to 20-30 min while jobs are active.** Aristotle proof jobs routinely
  take longer than the 5-minute prompt-cache window, so there is little to gain
  from waking sooner. Do not poll at sub-5-minute intervals.
- **Completed jobs are external state.** The harness cannot notify the agent when
  an Aristotle project finishes, so periodic reconciliation is the polling
  mechanism; this is legitimate external-state checking, unlike polling
  harness-tracked background work.
- **Stretch when idle.** If a check finds nothing to integrate and the active set
  is healthy, push the next delay toward 30-60 min. Shorten after a cycle that
  integrated something, freed a slot, or exposed a P9 decision point.

## Strategy and review cadence

- **Submit strategy jobs when they can change decisions.** A strategy-only job
  should receive the current publication plan, the strengthened-program doc, and
  the live ledger, then return a ranked theorem/definition backlog with gates,
  blockers, and stop/demote criteria. Output is a **report**, copied to
  `AgentTasks/null-edge-grand-strategy-vN-output.md` and marked
  `STRATEGY-ONLY`; nothing is integrated into Lean from it without a separate
  proof job.
- **Use a loose checkpoint rhythm.** After roughly 6-10 checks, after a major
  integration batch, or after a publication gate changes status, ask whether a
  strategy job would materially improve the next queue. If the next high-value
  jobs are already clear, keep proving or integrating.
- **Trigger immediately** if any of these fire: a lane stalls because its next
  theorem is ill-typed or underdefined, two consecutive `REFUTED` outcomes in one
  lane, the pipeline cannot find enough high-value ready jobs for two cycles, a
  convention question blocks more than one lane, or the P9 source-visibility
  branch cannot separate visible closure, BF closure, and observer invisibility.
- A strategy job counts against the active set only loosely: it may run as an
  extra project when it is cheap and does not displace a proof or integration
  that is ready now.

## Research and token-budget discipline

The point of folding literature/graph/semantic tools into the loop is to keep
proof jobs well-sourced **without** spending the agent's context window. Defaults:

- **Semantic search over grep.** Use `lean-explore` (offline, indexes Mathlib and
  PhysLean under package label `Physlib`) and the `lean-lsp` search tools to find
  lemmas and check names before preparing a handoff. Use `make_context_pack.py`
  to assemble the submission's nearby-lemma/convention context instead of pasting
  raw file dumps.
- **Literature is a background staging loop, consumed on demand.** The lit-search
  autoloop (`Scripts/lit/autoloop/`, staging-only: no Zotero/Neo4j writes) runs
  separately. The Aristotle loop **reads** its staging output when a lane needs a
  source or guardrail; it does not run a second heavy search loop during routine
  reconciliation.
  Targeted paper/graph lookups use `Scripts/lit/neo4j_paper_search.py`
  (scoped to collections `9W59V3K9` and `null-edge-lit` by default) and
  `neo4j_doc_search.py`, refreshed after meaningful doc/Lean edits.
- **Zotero/Neo4j writes only for guardrails.** Add a source only after its
  statement and conventions are checked against ours; use the canonical
  `paper_key` and the pre-add existence check (keyed on arxiv_id/doi, not title)
  to avoid duplicates. Sources are guardrails, not imported conclusions - the
  null-edge contribution must be the finite theorem, not a restatement of
  spin-foam or lattice-fermion prior art.
- **Read the diff, not the tree.** During integration, the canonical first
  inspection surface is the dry-run helper report and the diff it prints. Open
  extracted Lean only when a signature changed or the report flags something.

## Inherited guardrails (do not re-derive)

From [`null-edge-autonomous-aristotle-loop-plan-2026-06-21.md`](null-edge-autonomous-aristotle-loop-plan-2026-06-21.md)
and [`../docs/ARISTOTLE.md`](../docs/ARISTOTLE.md):

- the **job ledger** format and status vocabulary
  (`QUEUED -> SUBMITTED -> RUNNING -> COMPLETE -> INTEGRATING -> INTEGRATED`,
  plus terminal `REFUTED` and `STRATEGY-ONLY`); `REFUTED` is a success - route to
  statement revision, do not reproof;
- the **pre-integration convention checklist** (signature `(+---)`, Pauli/Weyl
  block ordering, wedge/Plucker normalization, explicit `m^2 = det P` vs
  `P^2 = 2 det P`, chirality/gamma signs, orthonormal-vs-coherent Gram labels);
- the **prompt templates** (proof job, definition-design job, stalled-job
  instruction) and the precondition that a proof target must already elaborate
  with a lone placeholder body before submission;
- the **definition backlog** (`VisibleSpinor`, `SuperDirac`, `OrderComplex`,
  `BivectorB`, `DiamondSourceVisibility`, etc.) and the rule that `NullEdge/Core`
  consolidation is scoped to structures with no trusted home yet, so landing it
  later cannot force a reproof of banked results;
- the **live-status tooling** (`aristotle tasks`, `aristotle show`,
  `aristotle continue --mode ask|instruct`, `aristotle download` for in-progress
  snapshots; set `PYTHONIOENCODING=utf-8` on Windows before `show`/`continue`).

## Stop conditions

Pause the loop and report (do not keep submitting) if:

- a theorem needs a new assumption that changes the physics content;
- signs, signature, basis order, or Plucker normalization are ambiguous and block
  more than one lane;
- a proof only succeeds after weakening the statement;
- a lane stays interpretive after two definition-design passes;
- repeated jobs spend their budget on broad builds rather than proof search
  (switch them to focused packages first; if that fails twice, stop and report);
- the pipeline repeatedly finds only filler jobs or wholly dependency-blocked
  jobs after the ready high-leverage work is integrated - escalate to a strategy
  job, then to the user if the strategy job does not expose a substantive next
  step;
- the P9 branch cannot define a source functional that separates boundary-exact,
  BF-closed/internal, and visible Plucker-excitation cases;
- coherent/internal or BF-closed bookkeeping produces an unavoidable bulk
  volume-scaling diamond source in the finite toy model.

## First-cycle bootstrap

The first check is the only one that does not start from a full pipeline:

1. Reconcile the ledger against `aristotle list --limit 20`.
2. Fetch + inspect the already-completed standalones flagged above
   (Lanes A, B, C, D each have a fetched-but-unpromoted artifact); integrate the
   cleanest one or two if semantic review is straightforward.
3. If the immediate queue is unclear, submit a cycle-1 **grand-strategy** job;
   otherwise spend that slot on a concrete proof/definition target.
4. Refill from the highest-leverage ready jobs, with an initial bias toward
   B's Dirac/operator promotion, A's celestial-bridge verification, C's
   observer-channel promotion, and D's spinor-network closure promotion.
5. Start one P9-enabling job as soon as its dependencies are ready: either the
   `DiamondSourceVisibility` API design, a boundary-exact/source-zero toy lemma,
   or a recoverability/observer-channel diagnostic shared with P7.
6. Pick the next check time from the pacing guidance above; repeat the standard
   reconciliation cycle thereafter.

## Expected end state

Not one giant proof. A curated set of theorem islands and stable definition
modules: the four fetched standalones (Lanes A-D) promoted with convention
audits; the celestial-moment and Gram-weighted wrappers banked toward P1/P6; the
Dirac square-root cluster consolidated for P2; the observer-channel + finite
data-processing core banked for P7; the diamond-source-visibility and
spinor-network-closure surface banked toward P9; a finite P9 verdict that says
whether boundary-exact/BF-closed/internal bookkeeping can be source-invisible or
mean-zero while visible Plucker excitations remain bulk-visible; a
forced-or-optional verdict on the crossed-module/fake-flatness layer for P3; and
a Stage-0-checked decision on whether the Klein-quadric simplicity-defect lane is
worth a proof campaign. Plus a current ledger, a ranked backlog with no
duplicated context, no broad-build timeouts, and no jobs submitted merely to keep
the active count pretty.
