# Null-edge checkerboard L2 operator norm and unitary stability

You are working in the standalone Lean 4 package `NullEdgeStandalone`.

## Build command

```powershell
lake env lean PhysicsSM/Draft/CheckerboardDiracScaling.lean
```

## Context

Two related jobs may still be running on the L-infinity operator-norm route.
This job is intentionally independent: investigate and use Mathlib's scoped
`Matrix.Norms.L2Operator` norm from
`Mathlib.Analysis.CStarAlgebra.Matrix`, which transports the Hilbert-space
operator norm to finite matrices and is a natural match for unitary quantum
walk evolution.

Current local facts in `PhysicsSM.Draft.CheckerboardDiracScaling`:

- `momentumStepSymbolRaw eps m p`
- `continuumStepSymbol eps m p`
- `diracHamiltonianSymbol m p`
- `continuumStepBridgeRemainder eps m p`
- `momentumStepFirstOrderRemainder eps m p`
- `matrixL1Norm_one`
- `linftyOpNorm_one`
- `linftyOpNorm_mul_le`
- `linftyOpNorm_le_matrixL1Norm`
- `linftyOpNorm_momentumStepFirstOrderRemainder_isBigO_sq`

## Requested work

Work in `PhysicsSM/Draft/CheckerboardDiracScaling.lean`.

Please explore the scoped L2 operator norm route:

```lean
open scoped Matrix.Norms.L2Operator
```

High-value targets:

1. Add local bridge facts showing that the scoped L2 operator norm has identity
   size `1` and multiplication submultiplicativity for
   `Matrix Direction Direction Complex`.

2. If feasible, prove that the finite one-step symbol is unitary:

```text
momentumStepSymbolRaw eps m p ∈ Matrix.unitaryGroup Direction Complex
```

or prove the two components separately:

```text
nullShiftSymbol eps p ∈ Matrix.unitaryGroup Direction Complex
isotropicStep (eps * m) ∈ Matrix.unitaryGroup Direction Complex
```

3. If unitary packaging is feasible, prove the corresponding L2 operator-norm
stability fact:

```text
‖momentumStepSymbolRaw eps m p‖ = 1
```

in the scoped `Matrix.Norms.L2Operator` norm.

4. If the direct unitary route is too expensive, return the exact Mathlib lemmas
and theorem statement needed to finish it.

## Constraints

- Do not change existing definitions.
- Do not add global matrix norm instances; keep any norm facts inside a scoped
  section.
- Do not promote the full checkerboard-to-Dirac theorem.
- Keep statements pointwise in momentum and one-step/finite-dimensional.

## Desired output

Return:

1. modified Lean/docs files;
2. exact commands run and whether they passed;
3. semantic review of whether the L2 operator norm is better than the
   L-infinity operator norm for this project;
4. the best next theorem after the unitary/stability result.
