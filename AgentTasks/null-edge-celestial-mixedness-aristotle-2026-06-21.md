# Aristotle task: null-edge celestial mixedness bridge

## Objective

Fill the proof holes in:

```text
PhysicsSM/Draft/NullEdgeCelestialMixednessAristotle.lean
```

This is a large next-wave proof batch for the null-edge causal graph program.
The goal is to connect the existing finite Plucker/twistor bridge to a
physics-facing reduced-density interpretation:

- visible mass as Bloch/qubit mixedness;
- two celestial directions as angular determinant mass;
- internal/generation labels as visible-density blind data after forgetting;
- twistor-chart reduced-density wrappers.

## Target file

```text
PhysicsSM/Draft/NullEdgeCelestialMixednessAristotle.lean
```

Expected module:

```text
PhysicsSM.Draft.NullEdgeCelestialMixednessAristotle
```

## Constraints

- No `s o r r y`, `a d m i t`, `a x i o m`, `o p a q u e`, or `u n s a f e` in the final target file.
- Do not use `n a t i v e _ d e c i d e`.
- Do not weaken theorem statements merely to close proofs.
- Helper lemmas in this file are welcome.
- Keep the file draft-facing; do not modify trusted definitions or conventions.
- The target is finite algebra only. Do not add continuum, Penrose transform,
  scattering, or analytic assumptions.

## Proof targets

### 1. Bloch-density determinant and mixedness

```lean
blochDensity_trace
blochDensity_det_eq_one_sub_radius_sq
blochDensity_trace_square_eq_radius_sq
blochDensity_purity_eq_radius_sq
blochDensity_linearEntropy_eq_four_det
blochDensity_massless_iff_unit_radius
blochDensity_zero_vector_eq_half_identity
blochDensity_antipodal_average_eq_half_identity
```

Guidance:

- Use definitions from
  `PhysicsSM.Draft.SpinCoherentProjectorAristotle`.
- `blochDensity` is definitionally `spinProjector`.
- `trace_spinProjector` should prove the trace target directly.
- The determinant and trace-square identities are small `2 x 2` matrix
  computations:

```text
det((1 + sigma.r) / 2) = (1 - r.r) / 4
tr(rho(r)^2) = (1 + r.r) / 2
```

- The entropy theorem follows by combining those two identities over real
  parts:

```text
2 * (1 - purity) = 4 * Re(det rho)
```

- Antipodal averaging should use `spinProjector_add_antipodal`.

### 2. Two celestial directions and angular mass

```lean
coherentPairMomentum_trace
coherentPairMomentum_det_eq_angular_separation
coherentPairMomentum_massless_iff_parallel
coherentPairMomentum_antipodal_identity
coherentPairMomentum_antipodal_rest_det
unit_blochDensity_is_rankOneHermitian
```

Guidance:

- `coherentPairMomentum a b = P(a) + P(b)`.
- For unit `a` and `b`, prove:

```text
det(P(a) + P(b)) = (1 - a.b) / 2
```

  This can be an entrywise calculation or derived from the Bloch determinant
  identity applied to `a + b`.
- `coherentPairMomentum_massless_iff_parallel` follows from the determinant
  formula and real coercion injectivity.
- `coherentPairMomentum_antipodal_identity` should use
  `spinProjector_add_antipodal`.
- `unit_blochDensity_is_rankOneHermitian` should use
  `exists_rankOne_spinProjector` and the definition of `rankOneHermitian`.

### 3. Visible reduced density from internal alternatives

```lean
visibleReducedDensity_det_eq_plucker
visibleReducedDensity_det_re_nonneg
visibleReducedDensity_mass_zero_iff_common_direction
normalizedVisibleDensity_det_eq_det_div_trace_sq
normalizedVisibleDensity_det_eq_plucker_over_trace_sq
```

Guidance:

- `visibleReducedDensity` is definitionally `finBundleMomentum`.
- Use existing trusted Plucker mass theorems:

```lean
fin_bundle_det_eq_ofReal_pluckerMassReal
fin_bundle_det_re_nonneg
fin_bundle_mass_zero_iff_common_direction
```

- For the normalized determinant theorem use the `2 x 2` determinant scaling
  identity for scalar multiplication:

```text
det(c * A) = c^2 det(A)
```

  Here `c = (visibleTrace psi)^-1`. Lean's total inverse convention means no
  nonzero-trace hypothesis should be necessary for the stated equation.

### 4. Generation/internal-label blindness

```lean
labeledVisibleReducedDensity_eq_of_same_visible
labeledVisibleReducedDensity_relabel
labeledVisibleMass_relabel
labeledVisibleMass_eq_plucker
```

Guidance:

- These are definitional/funext wrappers once the visible spinor family is
  isolated.
- The point is important semantically: visible determinant mass is blind to
  generation/internal labels except through the visible spinors left after
  forgetting labels.

### 5. Twistor-chart reduced-density wrappers

```lean
twistorVisibleReducedDensity_det_eq_pairwiseMass
twistorVisibleReducedDensity_mass_zero_iff_common_pi_direction
```

Guidance:

- `twistorVisibleReducedDensity` is definitionally `multiTwistorMomentum`.
- Use:

```lean
multi_twistor_momentum_det_eq_pairwiseMass
multiTwistorMassSqDetConvention_eq_zero_iff_common_pi_direction
```

## Why this matters physically

This batch tries to turn the most useful speculative slogan into exact finite
math:

- massless visible motion is purity / rank-one direction;
- finite massive visible motion is mixedness after hidden alternatives are
  forgotten;
- two null directions acquire mass exactly by angular separation;
- generation and other internal labels are not visible mass sources by
  themselves; only their visible reduced density matters.

If this closes, the program has a much sharper bridge into real physics: mass
becomes a determinant/mixedness invariant of finite visible density matrices,
with twistor and Plucker language all matching the same object.

## Local validation before submission

```text
lake env lean PhysicsSM/Draft/NullEdgeCelestialMixednessAristotle.lean
```

Result before submission: typechecks with the intended proof-hole warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 9ac17188-80fe-4d27-a52c-69a1e1f0e9d4
  task_id: 5f0b55af-2474-40e0-972f-48fcd85b1b13
  target_file: PhysicsSM/Draft/NullEdgeCelestialMixednessAristotle.lean
  expected_module: PhysicsSM.Draft.NullEdgeCelestialMixednessAristotle
  submission_project: AgentTasks/aristotle-submit/null-edge-celestial-mixedness-20260621-project
  output_dir: AgentTasks/aristotle-output/9ac17188-80fe-4d27-a52c-69a1e1f0e9d4
  status: integrated
```

Submitted 2026-06-21.  `aristotle submit` created project
`9ac17188-80fe-4d27-a52c-69a1e1f0e9d4`.  `aristotle tasks` reported task
`5f0b55af-2474-40e0-972f-48fcd85b1b13` as `QUEUED`, and `aristotle list`
reported the project as `RUNNING`.

Submission note: the Aristotle CLI warned that the slim package contains Lean
files but no `.lake` folder. This is expected from
`Scripts/prepare_aristotle_submission.ps1`, which intentionally excludes local
build artifacts and dependency caches. If dependency resolution fails, retry
with an alternate package strategy.

Integrated 2026-06-21 after `aristotle tasks` reported task
`5f0b55af-2474-40e0-972f-48fcd85b1b13` as `COMPLETE`.
Fetched output to
`AgentTasks/aristotle-output/9ac17188-80fe-4d27-a52c-69a1e1f0e9d4`,
reviewed the candidate target file, and applied it with:

```text
python Scripts/aristotle/integrate_completed.py --task-note AgentTasks/null-edge-celestial-mixedness-aristotle-2026-06-21.md --apply --build 9ac17188-80fe-4d27-a52c-69a1e1f0e9d4
```

Post-integration checks:

```text
lake env lean AgentTasks/aristotle-output/9ac17188-80fe-4d27-a52c-69a1e1f0e9d4/extracted/project-files.tar/null-edge-celestial-mixedness-20260621-project_aristotle/PhysicsSM/Draft/NullEdgeCelestialMixednessAristotle.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeCelestialMixednessAristotle.lean
```
