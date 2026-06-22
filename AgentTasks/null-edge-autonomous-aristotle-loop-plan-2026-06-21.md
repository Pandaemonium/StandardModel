# Null-edge autonomous Aristotle loop plan

Date: 2026-06-21

## Purpose

This note prepares the next goal-mode run. The aim is to let Codex drive an
autonomous loop with Aristotle while keeping the research program honest:
definition work first, focused proof jobs second, and physics interpretation
only after a finite theorem has a stable statement.

For the overnight version of this loop, use
`AgentTasks/null-edge-overnight-run-plan-2026-06-21.md`. That note adds the
hourly cycle, semantic-search/literature cadence, manuscript-sketch blocks, and
P9-specific gates.

The immediate inputs are:

- `Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`
- `Sources/Null_Edge_Causal_Graph_Research_Plan.md`
- Aristotle strategy project `f5f8699c-4042-4af7-b4cd-2ebdef8de952`
- completed generation-blindness project `6dfab21d-321a-45c4-8e34-eca3e155a3c6`

## Lessons from the strategy run

Aristotle's strategy output understood the assignment and returned a useful
roadmap rather than trying to build the whole project. Its best suggestions
were operational:

- consolidate duplicated visible-spinor, Weyl-block, Pluecker, and momentum
  definitions before proving more wrapper theorems;
- prove the bundle determinant is a nonnegative real before using square-root
  or mass-ratio statements;
- use only closed-loop or triangle Pluecker phases, because pairwise phases are
  not gauge invariant under independent spinor rephasing;
- treat diamond source visibility as a definition-building target before asking
  for cosmology-scale theorems;
- keep Kahler-Dirac/order-complex and BF/simplicity claims guarded by source
  conventions.

## 2026-06-21 categorical and irrep feedback update

The next autonomous batches should incorporate the newest program sharpening:

- add a Stage-0 irrep check before any bivector job. The Pluecker mass bracket
  is the antisymmetric scalar `Lambda^2 S ~= C`; self-dual curvature lives in
  `Sym^2 S ~= Lambda^2_+`; visible momentum lives in `S tensor Sbar`; the
  genuine bivector/Klein-quadric arena is `Lambda^2 C^4`;
- promote `normalized_mass_ratio_eq_concurrence` as the cheapest physics-facing
  reduced-density theorem. Any monotonicity theorem must name a finite LOCC or
  local hidden-channel class;
- treat proper-time/concurrence monotonicity and ANEC/QNEC source visibility as
  two instances of the same relative-entropy/data-processing audit. Every such
  job must first name the observer channel or coarse-graining map;
- add recoverability as the quantitative version of observer invisibility:
  small relative-entropy loss, Petz/rotated-Petz recovery, or approximate
  Markov structure should be the diagnostic for hidden bookkeeping that is
  claimed to be invisible;
- make `pathPairDefect_interchange` the next decisive higher-gauge theorem.
  If it holds, continue to crossed-module/fake-flatness wrappers; if it fails,
  record the obstruction;
- prove the pairwise Klein-quadric wrapper before broad BF claims:
  `massless_iff_repeated_principal_spinor` and a convention-audited
  off-quadric/simplicity-defect identity;
- treat Albert/triality as an internal-generation lead only. It should not
  modify the visible Pluecker mass theorem until it reproduces representation,
  Yukawa, and mixing data without ad hoc states;
- for source visibility, test closure/Gauss law first:
  coherent/internal bookkeeping satisfying `sum_f B_f = 0` should be
  boundary-like, while visible Pluecker excitations should appear as closure
  violation or diamond source defects.
- for the discrete entropy side, use Sorkin-Johnston-style diamond reference
  states only with explicit Pauli-Jordan truncation conventions;
- add Hopf-link volume simplicity only as a spin-foam geometricity guardrail:
  define boundary-graph functionals and compare them with pairwise Pluecker
  simplicity plus closure, without claiming full Plebanski-sector isolation;
- add spinor-network closure as the most actionable source-visibility bridge:
  express the celestial Pluecker identity as a moment-map closure identity,
  while keeping visible closure, BF closure, and source invisibility separate;
- add CPTP celestial-channel dynamics so l=1 relaxation becomes a finite
  channel/generator spectral target rather than a raw flip-count claim;
- use positive-Grassmannian language only for Pluecker-minor stratification,
  and require a real ordered / phase-gauge-fixed sector before asserting
  positivity;
- add `edgeNeighbor_N` as the effective energetic-causal-set link-locality
  definition before using any local action or propagation claim;
- keep Dirac-Bianconi graph neural networks in the simulation track, where
  they are compared against ordinary Laplacian/message-passing baselines.

## Definition clarifications needed

These definitions are the main blockers for high-value proof jobs.

1. `VisibleSpinor`

   Canonical visible two-spinor type, preferred basis order, scalar field, and
   normalization convention. This should replace ad hoc local copies in draft
   files.

2. `rankOneHermitian` and `bundleMomentum`

   A canonical map `psi -> psi psi^dagger`, finite bundle sum, Weyl-coordinate
   extraction, and Minkowski norm. The determinant target should explicitly say
   when it is a real nonnegative value.

3. `spinorWedge` and Pluecker mass

   One canonical wedge convention, one squared-norm convention, and one bridge
   theorem to the trusted `finPairwisePluckerMass` result. Any phase theorem
   must use closed loops or normalized Bargmann triples.

4. `ReducedDensity`

   A visible density matrix with exact trace normalization. The clean theorem is
   `m / E = 2 sqrt(det rho_vis)` only under orthonormal or decohered internal
   labels; nonorthogonal internal labels require a Gram-weighted theorem.

5. `BivectorB` and `simplicityDefect`

   A finite `Lambda^2` wrapper whose mass-sector simplicity defect is the
   Pluecker Gram determinant. This must remain separate from full spin-foam
   cross-simplicity until the EPRL/FK convention map is written.

6. `OrderComplex`

   Finite poset simplices, cochains, coboundary, adjoint, grading, and
   `D = d + delta`. This is the seed for the graph Kahler-Dirac route and the
   finite topological Dirac theorem.

7. `SuperDirac`

   A finite odd self-adjoint block operator
   `D_{U,Phi} = d_U + delta_U + Phi + Phi^dagger`, with explicit Hilbert-space
   decomposition, edge transport, Higgs/Yukawa block, and curvature block.

8. `DiamondSourceVisibility`

   A diamond screen, source pairing, visible/boundary split, flux functional,
   and fluctuation observable. The first target is definitional coherence, not a
   cosmological-constant theorem.

9. `ObservableNullity`

   Quotient incidence map, kernel of an observer functional, exact cochain
   holonomy, tree gauge, and boundary-chain diagnostics.

10. `HopfLinkVolumeSimplicity`

   Boundary-graph Hopf-link/crossing data, bivector volume functionals, and the
   comparison map to pairwise Pluecker simplicity plus closure.

11. `EdgeNeighborLocality`

   A finite causal-set link-neighborhood relation `edgeNeighbor_N`, monotonicity
   in `N`, and stability under induced sub-diamonds.

12. `SpinorNetworkClosure`

   Closure vector, energy, and Pluecker mass as a finite moment-map identity:
   `m^2 = (E^2 - |C|^2) / 4`; plus source-pairing definitions that do not
   confuse visible closure with BF face closure.

13. `CelestialChannelDynamics`

   Finite CPTP maps on `2 x 2` density matrices, affine Bloch action, and l=1
   channel/generator spectral targets.

14. `PositiveGrassmannianStrata`

   Pluecker-minor vanishing/sign/phase patterns for null-edge bundles, with
   positivity gated by a real ordered sector.

15. `SpectralTripleAudit`

   Finite real structure, first-order condition, inner fluctuation, and
   low-order spectral-action checks for `D_{U,Phi}`.

16. `RelativeEntropyObserverChannel`

   Finite observer/coarse-graining maps for the two monotonicity branches:
   visible/internal reduction for concurrence, and diamond screen/source
   reduction for ANEC/QNEC-style positivity. This is a definition prerequisite
   before asking for monotonicity theorems.

## Critical path and definition ordering

A lesson from the strategy run is to consolidate duplicated definitions before
proving more wrapper theorems. To honor that without stalling banked work, the
loop uses an explicit split instead of a single global gate:

- Wave-1 proof jobs reuse the already-trusted `PhysicsSM.Spinor.PluckerMass`
  API and the existing kernel-clean draft cores. They must not depend on a new
  `NullEdge/Core` namespace, so landing `NullEdge/Core` later cannot force a
  reproof of banked results.
- `NullEdge/Core` consolidation is scoped to structures that have no trusted
  home yet: `SuperDirac`, `OrderComplex`, `BivectorB`, and
  `DiamondSourceVisibility`. The `VisibleSpinor` / `rankOneHermitian` /
  `spinorWedge` / `ReducedDensity` definitions are consolidated in wave 1 only
  as a documented API proposal (design pass, no landed code), then adopted in a
  single dedicated refactor job once the wave-1 proofs that pin their intended
  shape are integrated.

Net rule: never submit a proof job whose target decl will be renamed or re-typed
by a pending consolidation job. If a job would, reorder it after the
consolidation or rebase it onto the trusted API first.

## Source audit added

Three missing guardrails were added to Zotero collection `9W59V3K9` and mirrored
in Neo4j:

- `MQRXNUIX`: Engle-Livine-Pereira-Rovelli, `0711.0146`, finite-Immirzi LQG
  vertex;
- `K8QAB5UD`: Freidel-Krasnov, `0708.1595`, constrained-BF spin-foam model;
- `8RSBSW7Z`: Catterall, `10.21468/scipostphys.16.4.108`, reduced
  Kahler-Dirac fermions and chiral-fermion connections.

Gemini triage also adds four source anchors to review/add formally when the
literature workflow is next run: Bahr-Belov volume simplicity `1710.06195`,
Assanioussi-Bahr Hopf-link volume simplicity `2005.12004`,
Barnum-Graydon-Wilce Euclidean Jordan composites `1606.09331`, and
Dirac-Bianconi graph neural networks as a simulation baseline.

The spinor-network triage adds these source anchors to review/add formally:
Dupuis-Speziale-Tambornino `1201.2120`, Arkani-Hamed et al. positive
Grassmannian `1212.5605`, Kim-Lee massive ambitwistor zig-zag `2301.06203`,
Ruskai-Szarek-Werner qubit CPTP maps `quant-ph/0101003`, Klyachko quantum
marginals `quant-ph/0511102`, Faulkner-Leigh-Parrikar-Wang ANEC
`1605.08072`, and Dowker-Philpott-Sorkin swerves `0810.5591`.

Use these as guardrails, not as imported conclusions. The null-edge contribution
must be the finite Pluecker/operator/order-complex theorem, not a restatement of
spin-foam or lattice-fermion prior art.

## First autonomous loop

Run this loop until all active Aristotle jobs are integrated, refuted, split, or
recorded as strategy-only.

1. Query active jobs.

   Run `aristotle list --limit 20`, then `aristotle tasks <project-id>` for any
   project that is `RUNNING`, `IDLE`, or recently completed. Reconcile every
   result against the job ledger below - the single source of truth across loop
   iterations - updating each row's status, then mirror the detail into the
   relevant task note.

2. Refresh semantic context before new submissions.

   After meaningful doc or Lean edits, run the idempotent repo and paper
   embedders. Before each new Aristotle job, create a focused context pack:

   ```text
   Scripts/aristotle/make_context_pack.py --query "<target theorem or branch>"
   ```

   Include the generated `AgentTasks/context-packs/*.md` file in the submission
   package and cite it in the task note. This replaces broad, duplicated context
   dumps.

3. Fetch completed jobs.

   Use `Scripts/aristotle/integrate_completed.py` in dry-run mode first. Inspect
   candidate files, scan executable Lean for proof-hole and escape-hatch tokens,
   and compare theorem statements against the intended mathematics before
   copying anything.

4. Integrate one clean result at a time.

   If a result is semantically aligned and placeholder-free, apply the
   integration helper, run the narrow Lean check, run the targeted module build,
   and update imports. Do this on a branch and require a clean full `lake build`
   before merging, so a downstream regression is caught before integration
   lands. Complete the pre-integration convention checklist, then set the
   matching ledger row to `INTEGRATED` and update the task note from `complete`
   to `integrated` in the same edit.

5. Split stalled or ambiguous work.

   If Aristotle times out in a broad build, resubmit as a focused package. If the
   theorem statement is ambiguous, create a design/scaffold job instead of
   weakening the statement.

6. Keep a small pipeline full.

   Maintain two to four active focused jobs. Prefer proof-only standalone
   packages for finite algebra. Use full-repo packages only when project imports
   are genuinely needed.

7. Promote only theorem islands.

   A job advances the research plan only if it creates a stable finite
   definition, proves a kernel-checkable theorem, or reveals that a proposed
   statement is false or underspecified.

## Job ledger

Single source of truth across loop iterations. Reconcile it against
`aristotle list` at the top of every loop pass (loop step 1) before submitting or
integrating anything. Status vocabulary:

`QUEUED` -> `SUBMITTED` -> `RUNNING` -> `COMPLETE` -> `INTEGRATING` ->
`INTEGRATED`, plus the terminal outcomes `REFUTED` (statement shown false or
underspecified - this is a success: route it to statement revision, do not
reproof) and `STRATEGY-ONLY` (roadmap output, nothing to integrate).

A proof job is not `SUBMITTED` until its target decl elaborates with a lone
placeholder body (see the proof-job template precondition). A job is not
`INTEGRATED` until the pre-integration convention checklist passes. Paths marked
`?` are best guesses to confirm on first reconcile.

| job | target decl(s) | file | project-id | status | deps | acceptance |
|---|---|---|---|---|---|---|
| gen-blindness | `generation_blind_visible_mass` | `Draft/NullEdgeGenerationBlindnessCore.lean ?` | `6dfab21d-...` | COMPLETE | - | `lake env lean` + module build |
| qubit-concurrence | `normalized_mass_ratio_eq_concurrence`, `linearEntropyComplex_eq_concurrenceSq_of_trace_one` | `Draft/NullEdgeQubitConcurrence.lean` | `097cc326-5ae4-46b2-8786-de2975ac8103` | INTEGRATED | reduced-density convention audit | `lake env lean` + module build + placeholder scan |
| pathpair-interchange | `pathPairDefect_interchange`, `pathPairDefect_grid_comm` | `Draft/NullEdgePathPairInterchange.lean` | `3d595909-e7bb-4c44-a4a3-fc86f305774e` | INTEGRATED | trusted diamond holonomy API | `lake env lean` + module build + placeholder scan |
| core-design | `NullEdge/Core` API proposal | design only | (unsubmitted) | - | QUEUED | API + dep graph note, no landed code |
| det-nonneg | finite bundle det is real `>= 0` | `Spinor/PluckerMass.lean` | (unsubmitted) | trusted PluckerMass | QUEUED | `lake env lean` + module build |
| static-spine | `leftRightDiracBlock_sq_eq_pluckerMass`, `diracSlash_massless_iff_common_spinor_direction`, mass-shell projector bridge | `Draft/NullEdgeBundleDiracPluckerCore.lean` | (unsubmitted) | trusted PluckerMass, slash cores | QUEUED | `lake env lean` + module build |
| celestial-moment | `fin_bundle_det_eq_bloch_minkowski_norm`, `mass_zero_iff_bloch_dipole_saturates` | `Spinor/CelestialPluckerMass.lean ?` | (unsubmitted) | trusted PluckerMass | QUEUED | `lake env lean` + module build |
| spinor-network-closure | `pluckerMass_eq_energy_sq_sub_closureDefect_sq`, `closed_spinorFan_is_restFrame` | `NullEdgeSpinorNetworkClosure/Finite.lean` | `f1be6e52-31cc-411b-86b7-a841b1cfd318` | COMPLETE | celestial-moment | focused standalone check + integration review |
| positive-grassmannian | `pluckerMinorVanishingPattern_refines_nullEdgeDegeneration`, `positiveOrderedFan_has_nonnegative_pairwiseMass` | `Draft/PositiveGrassmannianNullEdge.lean ?` | (unsubmitted) | trusted PluckerMass | QUEUED | `lake env lean` + module build |
| reduced-density | `properTimeRate_eq_two_sqrt_det_visibleDensity` | `Draft/ReducedCelestialMixedness.lean ?` | (unsubmitted) | det-nonneg, exact trace norm | QUEUED | `lake env lean` + module build |
| celestial-channel | `normSq_scalarBlochChannel`, `scalarChannel_massRatioSq_mono_of_contraction` | `NullEdgeCelestialScalarChannel/Finite.lean` | `d2ffbd94-bb7c-4582-94b5-1bafdc2ab481` | COMPLETE | reduced-density | focused standalone check + integration review |
| simplicity-defect | `bivector_massDefect_eq_plucker` | `Draft/NullEdgeBivector.lean ?` | (unsubmitted) | core-design (BivectorB), EPRL/FK audit | QUEUED | `lake env lean` + module build |
| hopf-volume | `hopfLinkVolumeSimplicity_functional`, `hopfLinkVolumeSimplicity_refines_pairwise_simplicity` | `Draft/NullEdgeHopfVolumeSimplicity.lean ?` | (unsubmitted) | simplicity-defect, boundary-graph defs | QUEUED | `lake env lean` + module build |
| observable-nullity | `exact_one_cochain_has_trivial_cycle_holonomy`, `tree_phase_assignment_is_gauge_trivial` | `Draft/ObservableNullity.lean ?` | (unsubmitted) | - | QUEUED | `lake env lean` + module build |
| topological-dirac | `topological_dirac_sq_eq_laplacian` | `Draft/KahlerDiracGraph.lean ?` | (unsubmitted) | core-design (OrderComplex) | QUEUED | `lake env lean` + module build |
| edge-locality | `edgeNeighborN_finite`, `edgeNeighborN_subdiamond_mono` | `Draft/EdgeNeighborLocality.lean ?` | (unsubmitted) | finite causal-set defs | QUEUED | `lake env lean` + module build |
| dbg-pilot | topological-Dirac vs Laplacian/message-passing simulation | script/design only | (unsubmitted) | topological-dirac | QUEUED | pilot report, no Lean trust claim |
| diamond-source | `DiamondSourceVisibility` defs | design only | (unsubmitted) | - | QUEUED | API + dep graph note |
| qnec-audit | `relativeEntropyDataProcessing_for_diamondObserver`, `visiblePluckerFlux_satisfies_discreteANEC`, `diamondRelativeEntropy_secondDifference_nonnegative`, `sjDiamondReferenceState_def`, `petzRecoverabilityGap_controls_sourceVisibility` | design/proof split | (unsubmitted) | diamond-source, relative-entropy observer channel | QUEUED | source/entropy API + observer-channel proof split |
| super-dirac | `superDirac_sq_eq_laplacian_plus_curvature_plus_higgs` | `Draft/CausalSuperDirac.lean ?` | (unsubmitted) | static-spine, topological-dirac, diamond-source | QUEUED | `lake env lean` + module build |
| spectral-triple-audit | `firstOrderCondition_fails_or_forces_YukawaLegality`, `higgsPhi_is_innerFluctuation_of_finiteDirac` | `Draft/CausalSuperDiracSpectralTripleAudit.lean ?` | (unsubmitted) | super-dirac | QUEUED | `lake env lean` + design note |
| swerve-pilot | stochastic flip residual momentum diffusion | script/design only | (unsubmitted) | celestial-channel | QUEUED | pilot report, no Lean trust claim |
| strategy | roadmap | - | `f5f8699c-...` | STRATEGY-ONLY | - | - |
| strategy-v2 | complete strengthened-program proof scaffold | strategy/scaffold output | `ba66d47f-68d3-4752-b6a0-ac1f10830f5d` | COMPLETE | current plan docs | roadmap output, no Lean trust claim |
| physics-audit | semantic confidence scoring and comment/docstring suggestions | audit/comment output | `51bf086e-37da-441c-9657-75f15f6036c7` | COMPLETE | current plan docs, null-edge theorem surface | audit table + comment-only patches, no theorem changes |

Keep the table current: every status change updates the matching row in the same
edit that updates the task note. Independent rows (no shared `deps`) may run as
concurrent Aristotle jobs up to the pipeline cap; dependent rows wait for their
`deps` to reach `INTEGRATED`.

## Pre-integration convention checklist

No job moves to `INTEGRATED` until each item below is confirmed in its ledger
row, against the Stage-0 convention table in
`Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`. This is the autonomous
guard against silent convention drift, which the program flags as its main
semantic risk.

- metric signature is `(+---)` as used by the trusted modules;
- Pauli matrix basis and ordering match the trusted Weyl-block convention;
- spinor wedge and Pluecker normalization match `finPairwisePluckerMass`;
- mass-square convention is recorded explicitly: `m^2 = det P` and the
  trace-pairing `P^2 = 2 det P` are never silently mixed;
- chirality/handedness and gamma-matrix signs match the Dirac-slash cores;
- internal Gram / hidden-label data is labeled orthonormal-vs-coherent, so a
  decohered theorem is never silently applied to a coherent case.

If any item cannot be confirmed, stop and record the mismatch in the task note
and ledger rather than integrating.

## First-wave queue

1. Integrate the completed generation-blindness job

   Project: `6dfab21d-321a-45c4-8e34-eca3e155a3c6`.

   Goal: determine whether it proves internal relabeling/unitary invariance of
   visible Pluecker mass without accidentally freezing nonorthogonal Gram data.

2. Definition consolidation scaffold

   Ask Aristotle for a non-building design pass over:

   - `NullEdge/Core/VisibleSpinor.lean`
   - `NullEdge/Core/WeylBlocks.lean`
   - `NullEdge/Core/PluckerConventions.lean`

   Acceptance criterion: a clean module API and theorem dependency graph. Do not
   copy illustrative placeholders into the live repo.

3. Determinant nonnegative-real theorem

   Focused proof job. Prove the determinant of the finite visible bundle
   momentum is a real nonnegative scalar, not merely that its real part is
   nonnegative.

4. Static operator spine

   Focused proof job around:

   - `leftRightDiracBlock_sq_eq_pluckerMass`
   - `diracSlash_massless_iff_common_spinor_direction`
   - mass-shell projector bridge laws

5. Celestial moment wrapper

   Focused finite algebra job. Package Bloch-vector decomposition, dipole
   saturation, and weighted angular variance as an equivalent form of the
   Pluecker mass theorem.

## Second-wave queue

1. Reduced density matrix wrapper

   Depends on the determinant nonnegative-real theorem and exact trace
   normalization. Separate orthonormal/decohered internal labels from
   Gram-weighted internal labels.

2. Simplicity-defect theorem

   Depends on `BivectorB` definitions and the EPRL/FK source audit. The safe
   theorem is single-bivector simplicity/Pluecker masslessness, not full
   spin-foam cross-simplicity.

3. Observable-nullity diagnostics

   Define quotient incidence and observer kernels; prove exact cochain holonomy
   and tree-gauge lemmas before interpreting measurement.

4. Topological Dirac on a finite order complex

   Define `d`, `delta`, grading, and `D = d + delta`; prove `D^2` is the
   combinatorial Laplacian and that a chiral mass term gives the expected
   finite square under explicit anticommutation hypotheses.

5. Diamond source visibility

   Definition-design job first. Only later ask for mean-zero or
   `1 / sqrt(N)` fluctuation theorems.

6. Super-Dirac assembly

   Once the static spine, order-complex Dirac, and diamond curvature blocks are
   stable, ask for the square decomposition of `D_{U,Phi}`.

## Aristotle prompt templates

Proof job template.

Precondition before submission: the target theorem must already elaborate under
the pinned toolchain with a single placeholder body (a lone `s o r r y`, with
only the placeholder warning emitted by `lake env lean TARGET.lean`). Submit the
elaborating statement, not a prose description, so Aristotle spends budget on
proof search rather than guessing the statement. Package as a standalone job:
Mathlib plus the minimal copied definitions listed in the prompt; do not import
`PhysicsSM` unless the target genuinely needs the project import graph, and
justify it in the prompt if so.

```text
Please prove the stated theorem without changing its statement. You may add
small helper lemmas. Do not add escape hatches or placeholders. First run:
lake env lean TARGET.lean
If the statement appears false or convention-mismatched, stop and explain the
counterexample or missing hypothesis instead of weakening it.
```

Definition-design job template:

```text
This is a roadmap/scaffold job, not a proof-completion job. Do not build the
whole repo. Read the supplied research document and nearby Lean files, propose a
minimal module API, theorem statements, proof sketches, dependencies, and likely
blockers. You may include Lean-like skeletons, but label every unfinished point
as a handoff and do not claim kernel proof.
```

Stalled-job instruction template. Trigger this on a threshold, not a judgment
call: when a job shows no proof progress at the next reconcile, or is spending
budget on a broad project build rather than proof search.

```text
Stop waiting on the broad build. Please return the current target file and a
concise status report: solved targets, current Lean error, any changed theorem
statements, and whether this should be split into smaller jobs.
```

## Verification policy during the loop

For every integrated Lean result:

- scan the integrated Lean file for proof-hole and escape-hatch tokens;
- run `lake env lean <file>`;
- run `lake build <module>`;
- update `PhysicsSMDraft.lean` only after the module itself checks;
- record exact commands in the task note;
- run `lake build` and `pre-commit run --all-files` before claiming a trusted
  milestone rather than a draft integration.

## Stop conditions

Pause the loop and report if:

- a theorem requires a new assumption that changes the physics content;
- signs, metric signature, basis order, or Pluecker normalization are ambiguous;
- a proof only works after weakening the statement;
- a branch remains interpretive after two definition-design passes;
- repeated Aristotle runs spend their budget on broad builds rather than proof
  search.

## Expected end state of goal-mode run

The best realistic outcome is not one giant proof. It is a curated set of
definition modules and theorem islands:

- generation-blindness either integrated or demoted with a precise blocker;
- determinant nonnegative-real theorem submitted or proved;
- one static operator-spine wrapper submitted;
- one celestial or reduced-density wrapper submitted;
- a clear `NullEdge/Core` API proposal;
- a ranked backlog of remaining focused jobs with no duplicated context and no
  broad-build timeouts.
