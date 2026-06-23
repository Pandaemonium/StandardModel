# Aristotle integration round

Date: 2026-06-23

Scope: integrated completed Aristotle jobs that were not yet represented in the
live repo after Claude's autonomous run. The proof jobs were downloaded from
Aristotle, extracted from gzip tar archives, checked locally, copied into
`PhysicsSM/Draft`, namespaced under `PhysicsSM.Draft`, imported from
`PhysicsSMDraft.lean`, and rechecked.

## Integrated proof modules

### P9 visible-fan mass characterization

Project: `9402d8cb-ff53-478c-a3b5-bf6303d505ea`

New module:

```text
PhysicsSM.Draft.NullEdgeP9VisibleFanMassCharacterization
```

Main declarations:

- `gap_identity`
- `momentMassSq_ge_pair_term`
- `visibleFan_massless_of_collinear`
- `visibleFan_massless_imp_collinear`

Value: completes the P9 non-collinearity no-go into a two-sided finite
characterization. A positive unit visible fan is massless exactly when all
positively weighted directions are collinear. This is one of the strongest
finite guardrails for the cosmological-constant/source-visibility branch.

### P7 Bloch mass ratio

Project: `7a9e87d1-a100-4888-817a-7396600b4a80`

New module:

```text
PhysicsSM.Draft.NullEdgeP7BlochMassRatio
```

Main declarations:

- `massRatio_eq_sqrt_one_minus_blochNormSq`
- `massRatio_monotone_under_bloch_contraction`

Value: finite qubit/Bloch-ball wrapper for the reduced-density mass-ratio
reading. Contracting the visible Bloch vector does not decrease the mass ratio,
giving a clean toy observer-channel monotonicity statement.

### P7 relative-entropy nonnegativity

Project: `002d0a2a-0bec-4517-a518-1eef4bd38ed1`

New module:

```text
PhysicsSM.Draft.NullEdgeP7RelativeEntropyNonneg
```

Main declarations:

- `kl_nonneg`
- `kl_self`

Value: finite Gibbs-inequality anchor for the P7 observer-channel and
recoverability program.

### Trace identities

Project: `93ed8172-d702-405f-a3b3-2ac9b54939fe`

New module:

```text
PhysicsSM.Draft.NullEdgeTraceIdentities
```

Main declarations:

- `trace_commutator_zero`
- `trace_transpose_mul_self_nonneg`

Value: support infrastructure for matrix/operator modules, especially spectral
and super-Dirac bookkeeping.

### Lorentz boost identities

Project: `b21afb44-63d3-45f1-932e-022e701c03b4`

New module:

```text
PhysicsSM.Draft.NullEdgeLorentzBoost
```

Main declarations:

- `boost_preserves_mink`
- `boost_compose`

Value: a small convention anchor for 1+1-dimensional rapidity boosts and
Minkowski-signature bookkeeping.

### SU2 Pauli commutators

Project: `bb985ad4-f586-46ab-9bd8-49db9941c847`

New module:

```text
PhysicsSM.Draft.NullEdgeSU2Algebra
```

Main declarations:

- `comm_01`
- `comm_12`
- `comm_20`

Value: a finite Pauli-matrix commutator anchor for the spin/gauge convention
layer.

### Yukawa mass operator bridge

Project: `24156b85-0176-455e-9f92-e80cb94502b8`

New module:

```text
PhysicsSM.Draft.NullEdgeYukawaMassOperator
```

Main declarations:

- `physicalYukawaFlip_gaugeLegal`
- `candidateGaugeLegal_iff_exists_yukawaFlip`
- `scalarYukawaFlipOperator_anticommutes_chirality`
- `scalarYukawaFlipOperator_sq_eq_massSq`
- `legalCandidate_has_yukawaMassOperator`

Value: connects the finite Higgs/Yukawa legality layer to the first-order
operator audit. A legal Yukawa flip now has a scalar off-diagonal mass operator
that anticommutes with chirality and squares to the expected `mass * mass`
diagonal block.

### P7 observer-loss factorization

Project: `3cfb5bcc-f262-45a2-8941-3151350a4617`

New module:

```text
PhysicsSM.Draft.NullEdgeP7ObserverLoss
```

Main declarations:

- `recoverabilityGap_eq_observerLoss_plus_recoveryLoss`
- `sourceDefect_le_recoverabilityGap_of_le_observerLoss`

Value: separates observer loss, post-recovery loss, and total recoverability
gap. This keeps the P7/P9 bridge honest: recoverability bookkeeping is useful,
but it is not automatically the same thing as source invisibility.

### P1 SL(2,C) determinant frame audit

Project: `c91d864e-60d7-44dc-bbf7-1bfa97e5ac4a`

New module:

```text
PhysicsSM.Draft.NullEdgeP1SL2Frame
```

Main declaration:

- `sl2_congruence_det_invariant`

Value: proves the finite determinant-invariance lemma behind the P1
frame-audit: the unnormalized two-spinor momentum determinant is invariant
under `SL(2,C)` congruence, while normalized celestial mixedness remains
observer-conditioned.

## Completed design/strategy outputs reviewed

The following completed Aristotle outputs were extracted and reviewed at summary
level. They were not copied wholesale into the repo because their value is as
roadmap material, not kernel-checked proof code.

### Diamond visibility geometric API

Project: `2961fe8f-2505-4efb-8306-55739bd8d563`

Useful content:

- proposes a finite `Diamond` object with cells, faces, incidence, and positive
  geometric weights;
- replaces abstract amplitudes with geometric cell weights;
- replaces the `unitTest` toy with curvature-defect/source pairings;
- ranks `boundaryExact_iff_invisible_to_curvatureDefects`,
  `recoverabilityGap_controls_sourceVisibility`, and
  `diamondResidualVariance_scales_with_cellArea` as the highest-value next
  theorem signatures.

Integration decision: keep as P9 API guidance. Do not promote the scaffold as a
permanent Lean API until the existing `NullEdgeP9*` theorem atoms are
consolidated.

### Super-Dirac block design

Project: `a74a947b-65fe-42e7-b951-7ee8d9117801`

Useful content:

- proposes a two-layer finite super-Dirac API: abstract block operator plus
  concrete null-edge graph transport;
- identifies `D^2` decomposition into Laplacian, curvature, Higgs-potential,
  Higgs-curvature, and cross terms;
- ranks the pure matrix expansion and odd/self-adjoint bookkeeping as the
  lowest-risk next theorems.

Integration decision: useful roadmap, but keep separate from existing
kernel-clean super-Dirac block modules until the operator API is consolidated.

### Grand strategy scaffold outputs

Projects:

- `472cdba6-e775-422c-823f-82a64db15839`
- `727d7c2a-9020-4119-a091-3edc23b7d5c9`

Useful content:

- first scaffold prioritizes P9 source visibility, P2 Dirac/operator mass, and
  P1/P6 celestial/reduced-density chains;
- second scaffold adds P3 higher gauge, P7 information, Lane E Klein quadric,
  and spectral-triple/Standard-Model chains;
- both outputs agree that P9 should be driven by finite source API definitions
  and that P7 recoverability is the shared diagnostic for observer invisibility.

Integration decision: use as strategy background; do not import Lean skeletons
with proof handoffs into the live repo.

### Order-complex design

Project: `e62190bd-8085-4b9e-8e01-a9e7a6d54497`

Useful content:

- proposes a finite Kähler-Dirac API with `d`, adjoint `delta`, chirality, and
  massive `D + m gamma`;
- identifies `dirac_sq_eq_laplacian` and `diracMass_sq` as pure algebra once
  the abstract hypotheses are present;
- flags the direct-sum/cochain assembly and signed-incidence nilpotency as the
  real construction blockers.

Integration decision: useful design note for later order-complex consolidation.

### P9 diamond source-visibility API skeleton

Project: `45929669-f4b1-4cbf-9f49-e4f624ef66bc`

Useful content:

- proposes a unified `DiamondScreen`, `CellMeasure`, `CurvatureDefect`, and
  `Observer` API for the source-visibility branch;
- makes abstract amplitudes geometric as `density * cellVol`;
- replaces the old toy test with closed curvature/holonomy-defect cochains;
- ranks boundary-exact invisibility, residual variance scaling, mean-zero
  residual invisibility, and everpresent-Lambda comparison as next proof
  targets.

Integration decision: do not copy the returned Lean skeleton into live code.
It is explicitly a handoff API with proof holes and needs adjustment to the new
Pro-critique caveat that recoverability and invisibility are distinct notions.
Use it as guidance for the next focused P9 proof jobs.

### Octonion / exceptional-Jordan scaffold

Project: `a582880e-9f8b-42cb-9742-33522a1f799e`

Useful content:

- confirms that most exceptional-Jordan infrastructure is not available in
  Mathlib and would need project-local development;
- identifies the repo octonion sign convention as the first serious guardrail;
- recommends proving concrete octonion algebra laws against the existing XOR
  table before attempting `H_3(O)`/Standard-Model claims.

Integration decision: useful roadmap only. Keep generations/internal algebra as
a long-horizon branch until the octonion convention bridge is audited.

## Verification performed

```text
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide <six extracted result files>
lake env lean <six extracted result files>
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide <six integrated draft modules>
lake env lean <six integrated draft modules>
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeYukawaMassOperator.lean
lake env lean PhysicsSM/Draft/NullEdgeYukawaMassOperator.lean
lake build PhysicsSM.Draft.NullEdgeYukawaMassOperator
lake env lean PhysicsSMDraft.lean
pre-commit run --files PhysicsSM/Draft/NullEdgeYukawaMassOperator.lean PhysicsSMDraft.lean
lake env lean PhysicsSM/Draft/NullEdgeP7ObserverLoss.lean
lake build PhysicsSM.Draft.NullEdgeP7ObserverLoss
lake env lean PhysicsSM/Draft/NullEdgeP1SL2Frame.lean
lake build PhysicsSM.Draft.NullEdgeP1SL2Frame
lake env lean PhysicsSMDraft.lean
```

All checks above passed. Two minor linter warnings from the extracted results
were cleaned in the integrated draft modules.

Still to run before calling the batch fully integrated:

```text
lake env lean PhysicsSMDraft.lean
lake build PhysicsSM.Draft.<new module>   # for each new module
pre-commit run --all-files
```
