# Task directions: first moves and success tiers

Per-task guidance for the overnight run. Each task lists first moves and
three tiers: **baseline** (the floor - do not end the night below this),
**strong**, and **shocking** (the aim). The literature protocol in
`RUN_PLAN.md` applies to every task; log ingests in `LIT_LOG.md`.

Ambition rule, restated: small lemmas you can see the proof of - just
prove them, now, locally. Ambitious targets - one `idea:` discussion
round to refine the statement, then Aristotle at full strength,
un-weakened. Ambition raises the theorem count, never the verification
bar.

---

## T0 - Preflight + harvest sweep

**First moves.** `$env:PYTHONIOENCODING='utf-8'; aristotle list --limit 40`
(the list paginates - reconcile older pages too). Update the ledger
registry with full names. For every IDLE project: dry-run
`python Scripts/aristotle/integrate_completed.py <project-id>` (find or
create the matching task note), read the report not the tree, and rank
integration order. Cross-check the nine unsubmitted
`AgentTasks/aristotle-prompts/gate-c1-c26*.prompt.md` against anything
already in flight so nothing is double-submitted.

- **Baseline:** registry complete and reconciled; every IDLE project
  dry-run-inspected; integration order posted in the ledger.
- **Strong:** all clean checkerboard returns handed to T1b with report
  links; anything superseded explicitly pruned with reasons.
- **Shocking:** T0 finishes inside the first hour and the harvest
  reveals composable pieces that upgrade T1b's target (see below).

## T1 - Gate C1 critical path (the flagship lane)

**Context.** The ladder: phase-to-trig adapters -> full `Hfree` Fourier
diagonalization -> unitary block-diagonal gap instantiation ->
finite/free operator gap -> self-adjointness -> only then the sign/GW
layer. Live file: `PhysicsSM/Draft/NullEdge/GateC1/TetraFreeOperator.lean`
(modified today - assess its exact state first). Release plan:
`Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md`.

**First moves.** Read the live file and inventory which ladder steps are
stated, proved, or missing. Read all nine prepared prompts: by name,
c271 (hfree-realspace-symbol) and c272 (full-c1-strategy-after-kfree)
sit closest to the gap chain; c264-c270 are branch/flavor/index and
locality side-layers - verify by reading, then post the wave triage in
the `triage:wave-1-composition` thread. Submit the agreed wave as
focused packages.

- **Baseline:** wave (3-5 jobs) submitted with registry rows; first
  returns integrated; ladder-state inventory posted.
- **Strong:** the unitary block-diagonal gap theorem instantiated on the
  finite tetrahedral torus - the finite/free operator gap reduced to
  already-proved symbol bounds.
- **Shocking:** `TetraFreeOperatorGap_equalN` AND self-adjointness of
  `H_free` both kernel-checked - the C1 free core done, with sign/GW
  layer statements drafted (statements only) for morning review.
  EQUALLY shocking: a genuine obstruction found, minimized, and
  documented per the pre-registered obstruction framing - that is the
  other paper.

**Lit hooks.** Verify the hyperdiamond/minimal-doubling positioning set
(Bedaque-Buchoff-Tiburzi-Walker-Loud 0804.1145, Kimura-Misumi,
Creutz-Kimura-Misumi) is in the graph; ingest what is missing. P1's
comparison section depends on it.

## T1b - Checkerboard harvest integration

**Context.** The IDLE backlog is today's checkerboard wave
(accumulated-angle bounds, Trotter, l2op unitary stability, exp bridge,
Dirac-limit statement, generator expansion, BC conventions). Target
tree: `NullEdgeStandalone/PhysicsSM/Draft/Checkerboard*.lean`.

**First moves.** Integrate per checklist (dry-run report -> signature
check -> placeholder scan -> `lake env lean` -> copy -> targeted build).
Post-hoc review notes suffice for these pre-tonight submissions.

- **Baseline:** every clean return integrated and building; failures
  documented with exact errors.
- **Strong:** integrated pieces reorganized so the continuum-limit
  chain reads as one ladder across the Checkerboard modules.
- **Shocking:** the pieces compose into a single named draft theorem -
  a checkerboard continuum Dirac-limit statement with explicitly
  labeled remaining analytic holes (documented handoff `s o r r y`
  markers in draft context) - plus the D4 growth-dictionary docstrings
  from T7 applied while you are in the files.

## T2 - Gate I1 kinematic core (the P2 engine)

**Plan:** `AgentTasks/nerd-gate-i1-kinematic-core-lean-plan-2026-07-02.md`
(build order, module layout, semantic risks).

**First moves.** Check Physlib/Lean-QuantumInfo for existing
entropy/fidelity layers (feeds Q1 too). Scaffold the standalone package
(`AgentTasks/aristotle-standalone/gate-i1-kinematic-core-20260702/`).
Prove I1.1-I1.4 locally - they are direct 2x2 computations. Attempt
I1.5 (Cauchy-Binet 2xn) locally; if it resists, that is the first
Aristotle package.

- **Baseline:** I1.1-I1.6 kernel-checked (soldering determinant, PSD
  characterization, rank dichotomy, rank-one factorization,
  Cauchy-Binet, the `2 p_i . p_j` cross-check).
- **Strong:** plus I1.7 (Stiefel splitting), I1.8 (normalized
  dictionary), I1.9 (`(gamma . P)^2 = det P`).
- **Shocking:** the COMPLETE P2 theorem set verified in one night -
  add A1 (boost-Gibbs form; search Mathlib for the 2x2 exponential
  first), A2 (Minkowski determinant inequality - check whether Mathlib
  already has `det` superadditivity for PSD matrices before proving),
  I3.5 (determinant-line clock at frequency 2m), and the
  `U(2) = spin x clock` factorization lemmas - plus the Lean-name to
  P2-claim mapping table drafted in the plan file. That is an entire
  publication's mathematics, machine-checked, overnight.

**Lit hooks.** Confirm Arkani-Hamed-Huang-Huang 1709.04891 and the
Fullwood-Vedral line are in the graph (P2 references); ingest if not.

## T3 - Gate D finite stack

**Source:** `Sources/Null_Edge_Dynamics_Gate_D.md` sections 2, 3.2, 5.2.

**First moves.** D1 (Bernoulli product maximizes entropy under fixed
inclusion probabilities) and D2(i) (the exact identity
`Delta S = Delta<K> - S_rel`) are small - prove locally, reusing any
entropy layer found in T2's library check. D6(i)-(ii) (checkerboard
turn-sequence max-ent) likewise. D3.0 (finite half-sided modular
inclusions are trivial) is the ambitious one: draft the statement, open
a `review:` thread on its formulation (the recurrence step is the
subtlety), then submit to Aristotle at full strength.

- **Baseline:** D1 + D2(i) kernel-checked or honestly blocked with
  documented handoffs; D3.0 statement cross-reviewed and submitted.
- **Strong:** D6 toy done; D2(ii)-(iii) (first-order first law +
  Gibbs-family stationarity) packaged.
- **Shocking:** D3.0 PROVED - a genuinely publishable standalone lemma
  ("no finite system supports a proper half-sided modular inclusion",
  the precise finite form of F-M2) - making the D-note paper's core
  complete in its first night.

**Lit hooks.** Ingest the Gate D reading backlog (document section 12):
gr-qc/9904062, gr-qc/0003117, 2008.02607, 1108.6036, 1307.6167,
1308.2206, 1407.0032, 1505.04753, math/0412061.

## T4 - Aristotle as partner (strategy/red-team jobs)

**First moves.** Write two prompts in the established
`AgentTasks/aristotle-prompts/*.prompt.md` format (context, explicit
deliverable filename, numbered questions, claim guardrails, ASCII
instruction):

1. `overnight-l0-nogo-audit.prompt.md` - embed the full L0.1 argument
   from `AgentTasks/nerd-gate-l0-lorentz-ensemble-nogo-plan-2026-07-02.md`.
   Ask: where are the holes; how to make the marginalization lemma and
   stabilizer step precise; what is the exact BHS statement being
   imported; what would a counterexample look like; verdict plus the
   strongest attack on the argument.
2. `overnight-c1-semantic-redteam.prompt.md` - embed the VERBATIM
   current statements from `TetraFreeOperator.lean` plus the intended
   mathematics from the release plan. Ask: statement-vs-intent
   mismatches; convention drift (signature, three-J, grading);
   hidden hypotheses; what would demote the claim; and the most
   ambitious defensible strengthening of each statement.

- **Baseline:** both submitted with registry rows.
- **Strong:** reports returned and triaged into concrete ledger actions.
- **Shocking:** the red-team catches a real semantic bug before it costs
  a week (catching it IS the win), or the L0.1 audit returns a skeleton
  solid enough that the no-go paper draft can start in the morning.

## T5 - Q2 numerics + D3.1 modular defect (first F-M2 data)

**Protocol:** `AgentTasks/nerd-gate-q2-discrete-qnec-protocol-2026-07-02.md`.

**First moves.** Scaffold `Scripts/qnec/` (plain Python + numpy, exact
linear algebra). Free-fermion chain ground state; Peschel
correlation-matrix entropies on nested null cuts in the checkerboard
geometry. Sanity anchor first: reproduce the known logarithmic CFT
growth of interval entropy in the massless case before trusting
anything downstream.

- **Baseline:** code runs; massless entropy curve matches the CFT log
  scaling; fixture metadata recorded per oracle policy.
- **Strong:** discrete QNEC second-difference deficit measured vs
  lattice spacing with a fitted exponent; first inclusion-leak and
  Bisognano-Wichmann defect numbers (D3.1).
- **Shocking:** full massless calibration + defect scaling exponents -
  the first quantitative data anyone has on how type III modular
  structure emerges from finite graphs (F-M2) - plus a first massive
  run tying the QNEC gap to the concurrence mass, and a short results
  note drafted for the morning.

**Lit hooks.** Execute the standing Q2 literature check (the N=8*
asterisk from NERD_3): is a lattice-native QNEC formulation with
systematic discretization analysis actually absent? Search the graph,
then the web; write the verdict in `LIT_LOG.md`; ingest what you find.
This check gates P3's novelty claim and is itself deliverable tonight.

## T6 - C0 convention audit

**First moves.** Grep-driven audit of `J`/grading usage across
`PhysicsSM/Draft/NullEdge/GateC1/`, the super-Dirac modules, and the C1
release plan, against the three-J and claim-scope conventions in
`docs/CONVENTIONS.md`. Produce `c0-audit-note.md` in this directory:
file:line, what is conflated or v1-flavored, severity, proposed fix.

- **Baseline:** complete audit note.
- **Strong:** docstring/comment-level fixes applied (prose-only edits
  are safe) with the note updated to "fixed".
- **Shocking:** the audit yields a crisp convention-table amendment
  proposal ready for the user to lock in the morning.

## T7 - Stretch (only if T1-T3 are moving)

D4: growth-dictionary docstrings on the Checkerboard modules + the
coin-weighted kernel lemma (should sit adjacent to the existing
`checkerStep` closed forms). D8: the 1+1 decorated-growth
decoherence-functional positivity probe (small matrices, one script,
`Scripts/dynamics/`). Shocking here: D8 produces a clean
positivity-domain observation worth a thread and a morning
recommendation.

## T8 - Morning report

Per the RUN_PLAN spec, plus the literature log summary. The report
should let the user reconstruct the night in five minutes and decide
the day's promotions in thirty. Draft by whoever is active at 07:00;
cross-review mandatory.

---

## What shocking looks like globally

C1 free core kernel-checked (or an honest obstruction banked); the
complete P2 theorem set verified; D3.0 proved; first F-M2 defect
exponents measured; the L0.1 and C1 red-team verdicts in hand; the Q2
novelty check resolved; the Gate D reading backlog ingested; every new
statement prior-art-checked. That is roughly a month of normal program
progress, verified, in one night - and it is reachable because every
target above is finite mathematics with statements already prepared.
