# Null-edge checkerboard scoped operator-norm stability

You are working in the standalone Lean 4 package `NullEdgeStandalone`.

## Build command

```powershell
lake env lean PhysicsSM/Draft/CheckerboardDiracScaling.lean
```

## Current verified state

The target module is:

```text
PhysicsSM.Draft.CheckerboardDiracScaling
```

The module now contains:

- `continuumStepSymbol`
- `continuumStepBridgeRemainder`
- `continuumStepBridgeDiscrepancy`
- `momentumStepFirstOrderDiscrepancy_isBigO_sq`
- `matrixL1Norm_one`
- `linftyOpNorm_one`
- `linftyOpNorm_mul_le`
- `linftyOpNorm_le_matrixL1Norm`
- `linftyOpNorm_momentumStepFirstOrderRemainder_isBigO_sq`

The theorem `linftyOpNorm_momentumStepFirstOrderRemainder_isBigO_sq` is inside
a section using:

```lean
open scoped Matrix.Norms.Operator
```

This scoped Mathlib norm has identity size `1` and multiplication
submultiplicativity, so it is the likely norm for the final long-product
stability argument.

## Primary targets

Please work in `PhysicsSM/Draft/CheckerboardDiracScaling.lean`.

Target A: prove the one-step exponential bridge in the scoped operator norm:

```lean
theorem linftyOpNorm_continuumStepBridgeRemainder_isBigO_sq
    (m p : Real) :
    (fun eps : Real => ‖continuumStepBridgeRemainder eps m p‖)
      =O[nhds (0 : Real)] (fun eps : Real => eps ^ 2) := by
  ...
```

Target B: prove a reusable scoped-operator-norm power stability theorem. A good
shape is:

```lean
theorem linftyOpNorm_pow_sub_pow_le
    (A B : Matrix Direction Direction Complex)
    (M delta : Real) (n : Nat)
    (hA : ‖A‖ ≤ M) (hB : ‖B‖ ≤ M)
    (hAB : ‖A - B‖ ≤ delta) :
    ‖A ^ n - B ^ n‖ ≤ (n : Real) * M ^ (n - 1) * delta := by
  ...
```

Use the scoped `Matrix.Norms.Operator` norm in the theorem. If the exact formula
needs a nonnegativity hypothesis on `M` or `delta`, add the minimal honest
hypotheses.

Target C, if A and B are complete: prove the immediate triangle/bridge estimate
that combines finite-step error and exponential-bridge error:

```text
momentumStepSymbolRaw eps m p - continuumStepSymbol eps m p
```

is second order in the scoped operator norm.

## Constraints

- Do not change `momentumStepSymbolRaw`, `diracHamiltonianSymbol`, or
  `continuumStepSymbol`.
- Do not add global matrix norm instances; use the scoped Mathlib norm locally.
- Do not promote the full checkerboard-to-Dirac theorem unless all product and
  refinement estimates are actually proved.
- Keep statements pointwise in momentum.

## Desired output

Return:

1. modified Lean/docs files;
2. exact commands run and whether they passed;
3. semantic review of the stability norm choice;
4. the best next theorem after these scoped-norm estimates.
