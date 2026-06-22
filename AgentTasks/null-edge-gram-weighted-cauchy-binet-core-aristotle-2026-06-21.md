# Aristotle task: Gram-weighted Cauchy-Binet core

Date: 2026-06-21

## Objective

Prove the finite Cauchy-Binet core for the Gram-weighted visible mass
identity in a tiny standalone Lean package:

```text
AgentTasks/aristotle-submit/null-edge-gram-cauchy-binet-core-20260621-project
```

Target file:

```text
NullEdgeGramCore/WeightedCauchyBinet.lean
```

Expected module:

```text
NullEdgeGramCore.WeightedCauchyBinet
```

## Context

The larger project
`59f9fbb0-6172-4bb5-b54b-832072fd3e2d` ended `OUT_OF_BUDGET` after spending
most of its budget building the full PhysicsSM dependency graph. Its partial
download was useful because it suggested the right decomposition:

1. Expand the determinant of `P_vis = M G M^dagger` as a four-fold sum.
2. Fold the hidden/output indices into exterior Gram entries.
3. Fold the visible/input indices into spinor wedges.

This follow-up keeps only that finite algebra. It intentionally duplicates the
small spinor and Gram definitions so the proof search is not coupled to the
full repository.

## Theorem targets

Main target:

```lean
visibleDet_eq_exteriorGram_weighted_plucker
```

Supporting targets:

```lean
gramWeightedVisibleMomentum_det_fullSum
gramDetFullSum_eq_innerFold
gramDetInnerFold_eq_pluckerMass
```

## Proof guidance

The determinant expansion target is a direct `2 x 2` calculation:

```text
det(P) = P00 * P11 - P01 * P10
```

After unfolding `gramWeightedVisibleMomentum`, use finite distributivity
(`Finset.sum_mul_sum`, `Finset.sum_sub_distrib`) and the definition of
`spinorWedge`.

For the hidden-index fold, split the full `(j,l)` sum into diagonal terms plus
unordered pairs. Diagonal wedge terms vanish. For each unordered pair
`q = (j,l)` with `j < l`, combine the two ordered terms:

```text
G i j * G k l * conj(wedge j l)
  + G i l * G k j * conj(wedge l j)
= (G i j * G k l - G i l * G k j) * conj(wedge j l).
```

Use antisymmetry of `spinorWedge`.

For the visible-index fold, do the same with `(i,k)`:

```text
psi i 0 * psi k 1 * E(i,k,q)
  + psi k 0 * psi i 1 * E(k,i,q)
= wedge(i,k) * E(i,k,q).
```

Here `E = exteriorPairGram G`.

## Constraints

- Do not weaken statements silently.
- Do not add new assumptions such as Hermitian or positive-semidefinite `G`.
  This identity is pure finite algebra over `Complex`.
- Final target file should contain no proof holes or escape-hatch declarations.
- It is acceptable to add helper lemmas in the same file if they are fully
  proved.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-submit/null-edge-gram-cauchy-binet-core-20260621-project/NullEdgeGramCore/WeightedCauchyBinet.lean
```

## Aristotle metadata

```yaml
aristotle:
  project_id: 153c8555-b764-4169-9468-0abff103bd23
  task_id: e194952f-8432-4cb5-b599-c7894a2fa08a
  target_file: NullEdgeGramCore/WeightedCauchyBinet.lean
  expected_module: NullEdgeGramCore.WeightedCauchyBinet
  submission_project: AgentTasks/aristotle-submit/null-edge-gram-cauchy-binet-core-20260621-project
  output_dir: AgentTasks/aristotle-output/153c8555-b764-4169-9468-0abff103bd23
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`153c8555-b764-4169-9468-0abff103bd23`; `aristotle tasks` reported task
`e194952f-8432-4cb5-b599-c7894a2fa08a` as `QUEUED`.

Submission note: this focused package intentionally has no `.lake` directory.
The target imports only:

```lean
import Mathlib.Data.Complex.Basic
import Mathlib.LinearAlgebra.Matrix.Determinant.Basic
```

Local validation before submission:

```text
lake env lean AgentTasks/aristotle-submit/null-edge-gram-cauchy-binet-core-20260621-project/NullEdgeGramCore/WeightedCauchyBinet.lean
```

Result: passed with exactly three intended proof-hole warnings.

Integrated 2026-06-21 after `aristotle tasks` reported task
`e194952f-8432-4cb5-b599-c7894a2fa08a` as `COMPLETE`.
Fetched output to
`AgentTasks/aristotle-output/153c8555-b764-4169-9468-0abff103bd23`.

Aristotle proved the standalone Cauchy-Binet core:

```lean
gramWeightedVisibleMomentum_det_fullSum
gramDetFullSum_eq_innerFold
gramDetInnerFold_eq_pluckerMass
visibleDet_eq_exteriorGram_weighted_plucker
```

The proof was ported into:

```text
PhysicsSM/Draft/NullEdgeGramWeightedMassAristotle.lean
```

Additional live wrappers closed during integration:

```lean
gramWeightedVisibleMomentum_one_eq_finBundleMomentum
rankOne_internalGram_eq_rankOneHermitian
gramWeightedVisibleMomentum_twoStatePartial_eq_partialCoherence
```

Post-integration checks:

```text
lake env lean PhysicsSM/Draft/NullEdgeGramWeightedMassAristotle.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeGramWeightedMassAristotle.lean
```
