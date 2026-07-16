# Aristotle task: gamma-centralizer chirality-selector no-go

```yaml
aristotle:
  project_id: 87e8d4f4-0f1b-452e-bd9a-54b1f103f86e
  task_id: 4ec59560-d8b1-4861-a4ae-61068edc375b
  target_file: GammaTransverseControl/ChiralitySelectorNoGo.lean
  expected_module: GammaTransverseControl.ChiralitySelectorNoGo
  status: submitted
```

## Objective

Build directly on the completed `GammaTransverseControl.Core`. Prove the
finite centralizer theorem that explains why its paired Dirac kernel cannot be
turned into one Weyl sector by a fixed internal projector while retaining the
full transverse gamma coupling.

## Required ladder

1. For `P : Matrix Spin4 Spin4 Complex`, prove that commuting with each of
   `gamma1`, `gamma2`, `gamma3`, and `gamma4` forces `P` to be a scalar matrix.
   Prefer an explicit coefficient or entry classification over imported
   representation theory.
2. Add idempotency and prove the scalar is zero or one, hence `P = 0` or
   `P = 1`.
3. Prove the chirality projectors `Pplus` and `Pminus` commute with the three
   tangential gamma matrices but fail to commute with `gamma4`.
4. Package the exact no-go: no nontrivial fixed projector simultaneously
   selects one tangent chirality and is invariant under the full four-gamma
   algebra.
5. Include explicit nonzero witnesses showing `Pplus != 0`, `Pplus != 1`, and
   its noncommutation with `gamma4`; add standard-three axiom guards.

## Boundary

This is a finite internal-algebra obstruction. It does not rule out
position-dependent projectors, transported selectors, boundary conditions,
larger parent Hilbert spaces, or anomaly inflow. Do not call it a universal
single-Weyl no-go. No proof placeholders, compiled evaluation, or new
assumptions.
