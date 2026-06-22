# Aristotle prompt: P9 weighted finite fluctuation scaling

Please fill the proof holes in:

```text
NullEdgeP9WeightedFluctuation/Core.lean
```

This is a focused standalone Mathlib-only package. Do not import the full
PhysicsSM repo.

## Goal

Prove the weighted sign-source fluctuation theorem:

```lean
weightedEnsembleSecondMoment_eq_amplitudeSqSum_times_configs
normalizedWeightedSecondMoment_eq_amplitudeSqSum
```

The physical motivation is the P9 cosmological-constant/source-visibility
branch. The equal-cell theorem gives variance `N`; this weighted theorem gives
variance `sum_i amp_i^2`, which is the finite algebra needed for nonuniform
diamond cells, suppression factors, or residual-source weighting.

## Constraints

- Preserve theorem statements exactly unless a statement is genuinely false.
- Do not add assumptions, axioms, or escape hatches.
- Keep the package standalone: Mathlib plus the definitions already in the file.
- You may add local helper lemmas inside the file if helpful.

## Completion report

End with:

```text
solved targets:
statement changes:
remaining proof holes:
assumptions or escape hatches used:
notes for integration:
```
