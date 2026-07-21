# Overnight mission 2026-07-18: Aristotle saturation across the publication portfolio

Set by the Research Director (chat directive, evening 2026-07-18). This file is
the night's mission overlay for the interactive Claude session. Procedure,
roles, and non-negotiables come from `CLAUDE_LAB_GOAL.md`; repository
`AGENTS.md` remains supreme. This overlay adds a fleet-size directive, a lane
map, and a submission backlog. It relaxes no evidence standard.

## Mission statement

Keep at least 12 Aristotle jobs active (submitted or running) at every moment
of the run, distributed across all publication lanes below. Harvest every
completed job promptly; verify the artifact verbatim at the repo toolchain pin;
audit it semantically against the intended statement; integrate what passes
(with guards and an axiom audit); and immediately replace it from the backlog
so the floor never drops. By morning, deliver integrated kernel-checked
progress in every lane that returned, an accurate job registry, updated status
maps, and a handoff that lets the next session continue without re-derivation.

The floor is a throughput commitment, not a quality waiver. Every submission
must be a well-shaped target per `docs/ARISTOTLE.md` and the checklist in
`ARISTOTLE_GRAND_STRATEGY.md`: exact statement, declarations to reuse, witness
and negative control, prohibited weakening, smaller fallback, stop/split
criterion. The backlog below is deep enough that the floor never forces filler.
A kernel refutation of a backlog target is a first-class result: record it and
backfill.

## Startup deltas (before the standard CLAUDE_LAB_GOAL.md startup)

1. Raise the Aristotle fleet cap: in `state/LAB_STATE.json`, set
   `work_in_progress_limits.aristotle_projects` from 8 to 16 (floor 12 plus
   headroom). Director-authorized by the 2026-07-18 directive; log the
   capacity change in the ledger. `labctl.py job-register` refuses
   registrations above the cap, so this edit precedes the ninth concurrent
   registration.
2. Reconcile the registry with reality before counting. Known drift at time of
   writing: Hurwitz stage-2b `1b045f4b` is in flight but unregistered;
   `d5b0eac8` shows submitted but its stage-2 harvest is already archived;
   eq-36 `46c3246a` was superseded by the verified eq36-v2 harvest. Fix states
   through `labctl.py`, register missing jobs, and cross-check live status
   with the dispatch helper's list command (the show subcommand is broken; use
   list with a limit).
3. Count active = submitted + running after reconciliation, then replenish to
   at least 12 within the first work block.

## Lane map and submission backlog

Keep at least one active job in every lane that still has a target; spread the
remainder by priority order (Director-set in the /goal directive): A
(flagship) > AU (division-algebra audit) > B (QCA doubling) > H (Hurwitz) > J
(exceptional Jordan) > D (continuum limit) > C (winding) > E (CAR/Fock) > G
(GR, ownership-gated) > R (reserve). Prefer
focused standalone Mathlib-only packages (import-check the bundle); generate a
context pack via `Scripts/aristotle/make_context_pack.py` for anything
nontrivial; use full-repo packages only when the project import graph is truly
needed. Reuse the prepared package dirs under `AgentTasks/aristotle-standalone/`
before building new ones.

Lane A - Paper A flagship gates (portfolio doc):
- A1: close or scope out each advertised full-Bloch determinant formula.
- A2: promote the two-site transported-phase identity to a genuine
  ring-holonomy spectral witness.
- A3: generator-level dynamical covariance classification.

Lane AU - division-algebra audit (S2b/Dixon/composition; status map items 1-4):
- AU1: eq-36 isospin-grading realization, candidate 1 - the minus-tau3
  orientation on the rank-one closed forms.
- AU2: eq-36 candidate 2 - the PL-projected adjoint grading.
- AU3: eq-37 B_j transition census (in flight - verify, then extend the
  j = 2, 3 CAR blocks).
- AU4: eq-40/41/42 exclusion-theorem assembly from the landed
  Re7-commutant and Mix witnesses.
- AU5: P5 three generations - transcribe the 48-state four-sector Cl(6) split
  of 1910.08395 THROUGH the convention bridge (the paper basis is not the
  repo XOR basis; see the P5 grounding note).
- AU6: item-1 deep remainder - beta-ladder realization on the actual C(x)O
  leptonic ideal.

Lane H - Hurwitz campaign (P6; task record `AgentTasks/hurwitz-campaign-2026-07-18.md`):
- H1: stage-2b Moufang pair closure (in flight - verify/harvest first).
- H2: stage-4a `doubling_assoc_iff` (the load-bearing Cayley-Dickson lemma).
- H3: stage-4b tower assembly and dim > 8 saturation contradiction (gated on
  H1; finalize statements against the harvested stage-2 API, never guessed).

Lane J - exceptional Jordan spectral theory (items 4/9):
- J1: Peirce/idempotent spectral decomposition for h3(O) on top of the landed
  unconditional real-spectrum theorem.
- J2: invariance of the trace/sigma/det triple under the automorphism
  (F4-side) action, stated structurally.
- J3: a rank or mixing constraint linking the dimensionless spectral ratios to
  the Gram-overlap flavor lane (the portfolio's flavor gate).

Lane B - strict 3+1 QCA doubling (Paper B):
- B1: exact all-zone alias classification for the live factorized class.
- B2: six-channel / D4 / BCC successor - exact all-momentum unitarity plus
  Dirac tangent check.
- B3: sharp resource lower bound (internal dimension, cell, range, or substep
  count) with a witness at the first relaxed architecture.

Lane D - changing-lattice continuum limit (Paper D):
- D1: sampling/interpolation operators and strong L2 convergence on a stated
  Sobolev class.
- D2: multiplier identification with the position-space Dirac PDE.

Lane C - winding insufficiency (Paper C):
- C1: kernel-only certificates replacing compiled decisions in the 16-field
  four-site discriminant.
- C2: full-walk status of the same-winding counterexample.

Lane E - CAR/Fock dynamics (Paper E):
- E1: compose the placed pair-kick layer with the spatial one-particle walk
  via an exact operator exponential or action derivation.
- E2: one operational two-particle quantity (scattering phase, bound-state
  energy, threshold, or selection rule).

Lane G - GR (codex-owned; ownership-gated):
- G1: next torsion-selection or coframe Cartan-limit lemma after the landed
  commits.
- G2: marked-Alexandrov Malament sub-lemma preparation.
- Rule: in solo mode, do not take over codex-owned items or live leases.
  Prepare statements and queue proposals; submit only on unclaimed items.

Lane R - reserve (backfill when a lane saturates):
- R1: SU(5) full group action on 5* (+) 10 (+) 1 (item-3 remainder).
- R2: Yang-Mills lasso layer, next lemma in the derived ordering.
- R3: KM/CP extension (PMNS-side seesaw bridge or N = 3 parametrization
  completeness).
- R4: Cl(8)/Cl(10) generation census extensions (`p5-cl8-generation` package).
- R5: anomalous-Floquet interior-decoupling test for the 3+1 route.

## Operating loop

Work in blocks; between blocks, check the fleet inline (never a blocking sleep
or poll loop):

1. Check dispatch status; harvest, verify, and integrate any returns
   (verbatim artifact check at the pin, standard-three axiom audit, guards
   for anything flagship-shaped).
2. Top the fleet back up to at least 12 from the backlog, one task note and
   one `labctl.py job-register` per submission.
3. Do one unit of genuine repo work from the integration queue: statement
   preparation for the next submissions, guard builds, semantic audits,
   status-map and portfolio updates, manuscript claim-discipline edits.
4. Log submissions, harvests, and integrations through `labctl.py log`
   (system clock; never hand-written timestamps). Write the handoff early,
   not only at session end.

Submission hygiene (see `docs/ARISTOTLE.md` and the harvest-gotchas memory):
no backticks in bash-submitted prompt strings (command substitution corrupts
them); COMPLETE_WITH_ERRORS is often a false alarm - always verify the
artifact before treating a job as failed; on resubmission, sharpen the prompt
from project docs and proceed without asking which mode.

## Morning deliverables

- The floor held: at least 12 active at every check, each replenishment
  ledger-logged; report the dawn count and any dips with cause.
- Every return harvested, verified, semantically audited, and either
  integrated with guards or recorded as a documented failure/kill.
- Updated: ten-goals status map, publication portfolio (if a gate moved),
  `docs/DOCUMENT_MAP.md` for new documents, the job registry, blockers, and
  the Director queue (human-only decisions, never assumed).
- A handoff in dependency order, plus the AGENTS.md final response format
  (summary, files changed, verification commands actually run, provenance,
  remaining issues - any proof holes reported explicitly as draft/handoff).

## Stop conditions and escalation

- Two consecutive dispatch failures or a budget anomaly: queue for the
  Director, keep the other lanes running; do not churn.
- A target that the kernel refutes or that proves vacuous, hollow, or
  false-shaped (the four over-claim modes): record the kill as a result,
  update the status map, backfill from reserve.
- Never weaken a statement to keep the floor or to make a job return green;
  hand the honest statement to Aristotle or record the blocker.
