# Null-edge checkerboard row-sum factor bounds

You are working in the standalone Lean 4 package `NullEdgeStandalone`.

## Build command

```powershell
lake env lean PhysicsSM/Draft/CheckerboardDiracScaling.lean
```

## Target file

```text
PhysicsSM/Draft/CheckerboardDiracScaling.lean
```

Namespace:

```lean
PhysicsSM.Draft.CheckerboardDiracScaling
```

## Context

Codex locally proved:

```lean
open scoped Matrix.Norms.Operator in
theorem linftyOpNorm_nullShiftSymbol_le_one (eps p : Real) :
    ‖nullShiftSymbol eps p‖ ≤ 1
```

The broader accumulated-Trotter job is also running, but this job is deliberately
narrow: finish the missing row-sum bounds for the finite one-step symbol in the
scoped L-infinity operator norm.

Relevant existing declarations:

- `isotropicStep`
- `momentumStepSymbolRaw`
- `linftyOpNorm_mul_le`
- `linftyOpNorm_nullShiftSymbol_le_one`
- `linftyOpNorm_momentumEvolution_sub_diracEvolution_le`

## Requested Lean targets

Please prove, in `PhysicsSM/Draft/CheckerboardDiracScaling.lean`, as many of
these as possible:

```lean
open scoped Matrix.Norms.Operator in
theorem linftyOpNorm_isotropicStep_le_abs_cos_add_abs_sin (theta : Real) :
    ‖isotropicStep theta‖ ≤ |Real.cos theta| + |Real.sin theta| := by
  ...
```

```lean
open scoped Matrix.Norms.Operator in
theorem linftyOpNorm_isotropicStep_le_one_add_abs (theta : Real) :
    ‖isotropicStep theta‖ ≤ 1 + |theta| := by
  ...
```

```lean
open scoped Matrix.Norms.Operator in
theorem linftyOpNorm_momentumStepSymbolRaw_le_one_add_abs
    (eps m p : Real) :
    ‖momentumStepSymbolRaw eps m p‖ ≤ 1 + |eps * m| := by
  ...
```

If the exact theorem names need slight adjustment, keep the mathematical
content the same and explain the change.

## Constraints

- Do not change existing definitions.
- Do not add global norm instances.
- Keep the proof pointwise and finite-dimensional.
- Do not promote the full continuum-limit theorem.

## Desired output

Return:

1. modified Lean/docs files;
2. exact commands run and whether they passed;
3. remaining blockers if any;
4. best next steps for the accumulated Trotter theorem.
