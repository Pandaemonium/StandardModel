# Aristotle task: null-edge decoherence channel bridge

## Objective

Fill the remaining proof holes in:

```text
PhysicsSM/Draft/NullEdgeDecoherenceChannelAristotle.lean
```

This is the next finite physics bridge for the null-edge causal graph program.
The previous batch proved that visible determinant mass is Bloch mixedness,
two-direction angular separation, and finite Pluecker spread.  This batch asks
for the next sharper layer:

- coherent visible alternatives remain rank-one and determinant-massless;
- decohered hidden alternatives acquire exactly the Pluecker determinant mass;
- collinear hidden splitting creates no determinant mass;
- a two-state hidden-basis isometry leaves the reduced visible density
  invariant;
- partial hidden coherence scales Pluecker mass by the hidden Gram determinant
  factor `1 - |k|^2`.

## Target file

```text
PhysicsSM/Draft/NullEdgeDecoherenceChannelAristotle.lean
```

Expected module:

```text
PhysicsSM.Draft.NullEdgeDecoherenceChannelAristotle
```

## Constraints

- No `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, or `u n s a f e` in the final target file.
- Do not use `n a t i v e _ d e c i d e`.
- Do not weaken theorem statements merely to close proofs.
- Helper lemmas in this file are welcome.
- Keep the file draft-facing; do not modify trusted definitions or conventions.
- The target is finite `2 x 2` complex matrix algebra only.  Do not add
  continuum, Hilbert-space completion, scattering, or analytic assumptions.

## Already proved locally

Before submission, the file already proves the bookkeeping and collinear
targets:

```lean
coherentSpinorPairMomentum_det_eq_zero
decoheredSpinorPairMomentum_eq_twoEdgeMomentum
decoheredSpinorPairMomentum_det_eq_plucker
hiddenCoherenceMassGap_eq_plucker
hiddenCoherenceMassGap_re_nonneg
hiddenCoherenceMassGap_zero_iff_collinear
rankOneHermitian_smul
collinearSplitMomentum_eq_weighted_rankOne
collinearSplitMomentum_det_eq_zero
collinearSplitMomentum_eq_rankOne_of_isometric_split
spinorWedge_collinear_split_eq_zero
two_edge_collinear_split_mass_eq_zero
hiddenColumnInner_self_eq_abs_sum
visibleReducedDensity_pairSpinorFamily_eq_decohered
visibleReducedDensity_pairSpinorFamily_det_eq_plucker
spinorOuter_self_eq_rankOneHermitian
```

## Remaining proof targets

### 1. Hidden-basis isometry invariance

```lean
visibleReducedDensity_hiddenMix2_eq_pairSpinorFamily
visibleReducedDensity_hiddenMix2_det_eq_plucker
visibleReducedDensity_hiddenMix2_det_re_nonneg
visibleReducedDensity_hiddenMix2_mass_zero_iff_original_collinear
```

Guidance:

- `hiddenMix2 U00 U01 U10 U11 psi phi` is the two-state hidden family
  obtained from `pairSpinorFamily psi phi` by a `2 x 2` coefficient matrix.
- `HiddenMix2Isometry` states column normalization and both off-diagonal
  orthogonality equations.
- The main calculation is:

```text
sum_k |U_k0 psi + U_k1 phi><U_k0 psi + U_k1 phi|
  =
|psi><psi| + |phi><phi|
```

  using the four column-isometry equations.
- The determinant, nonnegativity, and zero-mass/collinearity theorems should
  then follow from the already proved pair-family Pluecker theorem and
  `spinorWedge_eq_zero_iff_exists_smul_of_left_nonzero`.

### 2. Partial hidden coherence / Gram determinant factor

```lean
partialCoherenceMomentum_zero_eq_decohered
partialCoherenceMomentum_one_eq_coherent
partialCoherenceMomentum_det_eq_overlap_factor_mul_plucker
partialCoherenceMomentum_zero_det_eq_plucker
partialCoherenceMomentum_one_det_eq_zero
partialCoherenceMomentum_det_re_nonneg_of_normSq_le_one
```

Guidance:

- `partialCoherenceMomentum k psi phi` is

```text
|psi><psi| + |phi><phi| + k |psi><phi| + conj(k) |phi><psi|.
```

- Interpret this as `A G A^dagger`, where `A` has columns `psi, phi` and
  `G = [[1, k], [conj(k), 1]]`.
- The determinant identity should be the finite Cauchy-Binet / Gram formula:

```text
det(A G A^dagger) = det(G) * |det(A)|^2
                  = (1 - |k|^2) * |psi wedge phi|^2.
```

- The `k = 0` and `k = 1` specialization theorems are important semantic
  wrappers:
  - `k = 0`: orthogonal/decohered hidden labels give Pluecker mass;
  - `k = 1`: full coherence collapses to a single rank-one visible state.
- For the nonnegativity theorem, use:

```lean
complexAbsSq_eq_ofReal_normSq
Complex.normSq_nonneg
```

  together with the hypothesis `Complex.normSq k <= 1`.

## Why this matters physically

This batch turns the slogan "mass is hidden-label mixedness" into a sharper
finite theorem family.  It distinguishes three regimes:

- coherent alternatives: zero determinant mass;
- orthogonal/decohered hidden alternatives: full Pluecker mass;
- partially coherent hidden alternatives: Pluecker mass multiplied by the
  hidden Gram determinant.

That gives the program a concrete algebraic knob for decoherence/coarse
graining without leaving finite spinor geometry.

## Local validation before submission

```text
lake env lean PhysicsSM/Draft/NullEdgeDecoherenceChannelAristotle.lean
```

Result before submission: typechecks with exactly the intended 10 proof-hole
warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 725e3f65-e6fd-4d3d-97fe-7a2133ae1cc6
  task_id: 0df9f67e-0a3d-4d8e-91a1-e2573b9dc582
  target_file: PhysicsSM/Draft/NullEdgeDecoherenceChannelAristotle.lean
  expected_module: PhysicsSM.Draft.NullEdgeDecoherenceChannelAristotle
  submission_project: AgentTasks/aristotle-submit/null-edge-decoherence-channel-20260621-project
  output_dir: AgentTasks/aristotle-output/725e3f65-e6fd-4d3d-97fe-7a2133ae1cc6
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`725e3f65-e6fd-4d3d-97fe-7a2133ae1cc6`. `aristotle tasks` reported task
`0df9f67e-0a3d-4d8e-91a1-e2573b9dc582` as `QUEUED`, and `aristotle list`
reported the project as `RUNNING`.

Submission note: the Aristotle CLI warned that the slim package contains Lean
files but no `.lake` folder. This is expected from
`Scripts/prepare_aristotle_submission.ps1`, which intentionally excludes local
build artifacts and dependency caches. If dependency resolution fails, retry
with an alternate package strategy.

Integrated 2026-06-21 after `aristotle tasks` reported task
`0df9f67e-0a3d-4d8e-91a1-e2573b9dc582` as `COMPLETE`.
Fetched output to
`AgentTasks/aristotle-output/725e3f65-e6fd-4d3d-97fe-7a2133ae1cc6`,
reviewed the candidate target file, and applied it with:

```text
python Scripts/aristotle/integrate_completed.py --task-note AgentTasks/null-edge-decoherence-channel-aristotle-2026-06-21.md --apply --build 725e3f65-e6fd-4d3d-97fe-7a2133ae1cc6
```

Post-integration checks:

```text
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeDecoherenceChannelAristotle.lean
lake build PhysicsSM.Draft.NullEdgeDecoherenceChannelAristotle
```
