# Null-edge checkerboard accumulated-angle product-error bound

You are working in the standalone Lean 4 package `NullEdgeStandalone`.

## Build commands

Run narrow checks first:

```powershell
lake env lean PhysicsSM/Draft/CheckerboardContinuumScaffold.lean
lake env lean PhysicsSM/Draft/CheckerboardContinuumNext.lean
```

If those pass, run the focused package target available in the submission.

## Current verified state

The checkerboard finite/asymptotic scaffold now includes:

- `matrixL1Norm` on `Matrix Direction Direction Complex`;
- `matrixL1Norm_isotropicStepFirstOrderRemainder`;
- `isotropicStepFirstOrderRemainder_l1Norm_div_tendsto_zero`;
- `isotropicStep_pow_eq`;
- `isotropicStep_pow_eq_one_add_scaled_generator_add_remainder`;
- `isotropicStep_pow_sub_linear_l1Norm_eq`;
- `isotropicStep_pow_sub_linear_l1Norm_eq_explicit`;
- `isotropicStep_equal_subdivision_exact`;
- `isotropicStep_equal_subdivision_sub_linear_l1Norm_eq`;
- `isotropicStep_equal_subdivision_sub_linear_l1Norm_eq_explicit`;
- `isotropicStep_pow_sub_linear_l1Norm_tendsto_zero_of_accumulated_tendsto_zero`.

The fixed-time subdivision guardrail is load-bearing: because
`isotropicStep (T/(N+1))^(N+1) = isotropicStep T`, subdivision at fixed
accumulated angle `T` does **not** make the first-order linearization error
against `1 + T*generator` vanish. Do not try to prove that false statement.

## Requested Lean work

Work in:

```text
PhysicsSM/Draft/CheckerboardContinuumScaffold.lean
PhysicsSM/Draft/CheckerboardContinuumNext.lean
```

Please prove the strongest clean quantitative product-error bound you can,
centered on the accumulated angle

```text
x = (n : Real) * theta
```

Preferred theorem shape:

```lean
theorem isotropicStep_pow_sub_linear_l1Norm_le_accumulated_sq_add_cube
    (theta : Real) (n : Nat) :
    matrixL1Norm
        (isotropicStep theta ^ n -
          ((1 : Matrix Direction Direction Complex) +
            (((n : Real) * theta : Real) : Complex) • isotropicGenerator)) ≤
      ((n : Real) * theta) ^ 2 +
        (1 / 3 : Real) * |((n : Real) * theta)| ^ 3 := by
  ...
```

This follows from
`isotropicStep_pow_sub_linear_l1Norm_eq_explicit` plus scalar Taylor bounds
such as:

```text
|cos x - 1| <= x^2 / 2
|sin x - x| <= |x|^3 / 6
```

If the exact constants above are awkward in Mathlib, return a nearby clean
bound with explicit constants and no semantic weakening to a vacuous statement.

Helpful fallback theorem:

```lean
theorem isotropicStepFirstOrderRemainder_l1Norm_le_sq_add_cube
    (x : Real) :
    matrixL1Norm (isotropicStepFirstOrderRemainder x) ≤
      x ^ 2 + (1 / 3 : Real) * |x| ^ 3 := by
  ...
```

Then use it to prove the product-error theorem.

## Strategy request

Please also report the best next theorem after the quantitative bound. Compare:

- strengthening to a `BigO`/`IsLittleO` formulation in the accumulated angle;
- proving a topology-explicit checkerboard-to-Dirac theorem statement;
- returning to the source-fixed hyperdiamond pole-data lane;
- adding a finite serialization/scheduler toy API.

Label each as finite identity, asymptotic theorem, reconstruction theorem,
consistency check, or physical prediction.

## Constraints

- Do not introduce new assumptions or fake proof placeholders.
- Do not assert convergence to the continuum Dirac equation.
- Do not assert the false fixed-`T` linearization limit ruled out above.
- Keep checkerboard 1+1D estimates separate from 3+1D hyperdiamond/Gate C.
- Avoid global norm/typeclass instances.

## Desired output

Return:

1. modified Lean/docs files;
2. exact commands run and whether they passed;
3. semantic review of any new theorem statements;
4. ranked next steps and the single best next Aristotle job.
