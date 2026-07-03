# Null-edge checkerboard normed product-bound Aristotle job

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

- `isotropicStepFirstOrderRemainder`;
- `isotropicStep_eq_one_add_theta_generator_add_remainder`;
- `isotropicStepFirstOrderRemainder_hasDerivAt_zero`;
- `sin_sub_id_div_tendsto_zero`;
- `cos_sub_one_div_tendsto_zero`;
- `sin_sub_id_isLittleO`;
- `cos_sub_one_isLittleO`;
- `isotropicStepFirstOrderRemainder_div_tendsto_zero`;
- `isotropicStep_mul`;
- `isotropicStep_pow_eq`;
- `isotropicStep_pow_eq_one_add_scaled_generator_add_remainder`.

## Physics/literature orientation

The target is still the 1+1D checkerboard / quantum-walk lane. Strauch's
relativistic quantum walk and Di Molfetta--Arrighi's quantum-walk limits support
developing quantitative finite-dimensional estimates before any continuum Dirac
statement. Do not assert a continuum limit here.

## Requested Lean work

Work in:

```text
PhysicsSM/Draft/CheckerboardContinuumScaffold.lean
PhysicsSM/Draft/CheckerboardContinuumNext.lean
```

Please prove the strongest clean normed estimate you can without adding global
typeclass instances that might surprise downstream files.

Preferred approach:

1. Define an explicit finite entrywise matrix norm, for example an L1/Frobenius-
   style scalar function on `Matrix Direction Direction Complex`. A simple
   entrywise L1 norm is fine if it is easier than square roots.
2. Prove basic helper lemmas needed to use it as a measure of matrix size:
   nonnegativity, zero on the zero matrix, and finite-sum/tendsto behavior.
3. Upgrade the entrywise theorem
   `isotropicStepFirstOrderRemainder_div_tendsto_zero` to a scalar norm theorem,
   e.g. the explicit matrix norm of the first-order remainder divided by
   `abs theta` tends to zero through nonzero real values.
4. Use
   `isotropicStep_pow_eq_one_add_scaled_generator_add_remainder`
   to prove an exact product/remainder norm identity or inequality comparing
   `isotropicStep theta ^ n` with
   `1 + ((n : Real) * theta : Complex) • isotropicGenerator`.

If Mathlib API friction blocks the full normed theorem, keep the source
compiling and return the most precise theorem statements, missing API names, and
proof plan. Do not weaken semantic content into a vacuous statement.

## Strategy request

Return the next most important theorem after this normed estimate. Compare it
against:

- source-fixed hyperdiamond pole data;
- operator-derived physical audit predicates;
- a topology-explicit checkerboard-to-Dirac limit statement.

Label each as finite identity, asymptotic theorem, reconstruction theorem,
consistency check, or physical prediction.

## Constraints

- Do not introduce new assumptions or fake placeholders.
- Do not assert convergence to the continuum Dirac equation.
- Keep checkerboard 1+1D estimates separate from 3+1D hyperdiamond/Gate C.
- Avoid global norm/typeclass instances unless they are clearly harmless and
  documented.

## Desired output

Return:

1. modified Lean/docs files;
2. exact commands run and whether they passed;
3. semantic review of any new theorem statements;
4. ranked next steps and the single best next Aristotle job.
