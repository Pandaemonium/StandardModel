# Checkerboard Normed Product-Bound Estimates

Date: 2026-07-02

Lean modules:
`PhysicsSM.Draft.CheckerboardContinuumScaffold`,
`PhysicsSM.Draft.CheckerboardContinuumNext`.

## What Was Proved

This layer upgrades the earlier *entrywise* small-angle estimate to a genuine
*scalar-norm* estimate, using an explicit, local (non-typeclass) entrywise
matrix norm, and derives an exact product/remainder norm identity for step
powers.

### Explicit entrywise L1 norm (`CheckerboardContinuumScaffold`)

`matrixL1Norm M := sum_i sum_j ||M i j||` is a plain `Real`-valued function on
`Matrix Direction Direction Complex`. It is deliberately **not** registered as a
global `Norm`/`NormedAddCommGroup` instance, so it cannot change any Mathlib
default matrix-norm resolution in downstream files.

| Theorem | Meaning | Claim type |
| --- | --- | --- |
| `matrixL1Norm_nonneg` | `0 <= matrixL1Norm M` | finite identity/helper |
| `matrixL1Norm_zero` | `matrixL1Norm 0 = 0` | finite identity/helper |
| `matrixL1Norm_eq_zero_iff` | `matrixL1Norm M = 0 <-> M = 0` (definiteness) | finite identity/helper |
| `matrixL1Norm_smul_real` | `matrixL1Norm (c • M) = |c| * matrixL1Norm M` | finite identity/helper |
| `matrixL1Norm_add_le` | triangle inequality | finite identity/helper |
| `continuous_matrixL1Norm` | `Continuous matrixL1Norm` | topology helper |
| `matrixL1Norm_tendsto_zero` | `Tendsto f l (nhds 0) -> Tendsto (matrixL1Norm o f) l (nhds 0)` | topology helper |

Together these four properties (nonnegativity, definiteness, absolute
homogeneity, subadditivity) show `matrixL1Norm` is a genuine norm as a function,
even though it is not installed as an instance.

### Scalar normed estimate

| Theorem | Meaning | Claim type |
| --- | --- | --- |
| `matrixL1Norm_isotropicStepFirstOrderRemainder` | `matrixL1Norm (remainder theta) = 2*|cos theta - 1| + 2*|sin theta - theta|` | finite identity |
| `isotropicStepFirstOrderRemainder_l1Norm_div_tendsto_zero` | `matrixL1Norm (remainder theta) / |theta| -> 0` as `theta -> 0` through nonzero reals | asymptotic theorem |

The second theorem is the requested scalar-norm upgrade of the entrywise
`isotropicStepFirstOrderRemainder_div_tendsto_zero`. It is derived by composing
continuity of `matrixL1Norm` with the entrywise quotient limit and then using
absolute homogeneity (`matrixL1Norm_smul_real`) to rewrite
`matrixL1Norm (theta^-1 • R theta) = matrixL1Norm (R theta) / |theta|`.

### Product/remainder norm identity for step powers (`CheckerboardContinuumNext`)

| Theorem | Meaning | Claim type |
| --- | --- | --- |
| `isotropicStep_pow_sub_linear_l1Norm_eq` | `matrixL1Norm (step theta ^ n - (1 + (n*theta)•generator)) = matrixL1Norm (remainder (n*theta))` | finite identity |
| `isotropicStep_pow_sub_linear_l1Norm_eq_explicit` | `= 2*|cos(n*theta) - 1| + 2*|sin(n*theta) - n*theta|` | finite identity |
| `isotropicStep_equal_subdivision_exact` | `step (T/(N+1))^(N+1) = step T` | finite identity / guardrail |
| `isotropicStep_equal_subdivision_sub_linear_l1Norm_eq` | fixed-time subdivision error against `1 + T*generator` is the fixed remainder at `T` | finite identity / guardrail |
| `isotropicStep_pow_sub_linear_l1Norm_tendsto_zero_of_accumulated_tendsto_zero` | if `n*theta -> 0`, then the product error against the accumulated-angle linear model tends to zero | asymptotic theorem |
| `isotropicStep_pow_sub_linear_l1Norm_le_accumulated_sq_add_cube` | product error is `<= (n*theta)^2 + (1/3)*|n*theta|^3` | asymptotic theorem / quantitative scaffold |

These use `isotropicStep_pow_eq_one_add_scaled_generator_add_remainder` to reduce
the L1 distance between the exact `n`-fold step and its first-order model
`1 + (n*theta)•isotropicGenerator` to the norm of the packaged remainder at the
accumulated angle `n*theta`, with a fully explicit closed form.

### Quantitative scalar Taylor bounds

| Theorem | Meaning | Claim type |
| --- | --- | --- |
| `abs_cos_sub_one_le_half_sq` | `|cos x - 1| <= x^2/2` | scalar analysis helper |
| `sin_ge_sub_cube_of_nonneg` | `x - x^3/6 <= sin x` for `0 <= x` | scalar analysis helper |
| `abs_sin_sub_le_sixth_cube` | `|sin x - x| <= |x|^3/6` | scalar analysis helper |
| `isotropicStepFirstOrderRemainder_l1Norm_le_sq_add_cube` | `matrixL1Norm (remainder x) <= x^2 + (1/3)*|x|^3` | asymptotic theorem / quantitative scaffold |
| `isotropicStepFirstOrderRemainder_l1Norm_isBigO_sq` | `matrixL1Norm (remainder x) = O(x^2)` at `x -> 0` | asymptotic theorem |
| `isotropicStep_sub_linear_l1Norm_isBigO_sq` | one-step linearization error is `O(x^2)` at `x -> 0` | asymptotic theorem |
| `isotropicStepFirstOrderRemainder_l1Norm_isLittleO_id` | `matrixL1Norm (remainder x) = o(x)` at `x -> 0` | asymptotic theorem |
| `isotropicStepFirstOrderRemainder_l1Norm_isLittleO_comp` | composed-filter little-o form for an accumulated-angle map | asymptotic theorem |
| `isotropicStep_sub_linear_l1Norm_isLittleO_id` | one-step linearization error is `o(x)` at `x -> 0` | asymptotic theorem |
| `isotropicStep_pow_sub_linear_l1Norm_isLittleO_accumulated` | product error is little-o of accumulated angle when that angle tends to zero | asymptotic theorem |

These prove the explicit product bound without adding any continuum claim. The
bound is centered on the accumulated angle `x = n*theta`, so it pairs with
`isotropicStep_pow_sub_linear_l1Norm_tendsto_zero_of_accumulated_tendsto_zero`.

## Semantic Review

- `matrixL1Norm` is a real function, not an instance; no global typeclass is
  introduced, satisfying the "avoid surprising global norm instances" constraint.
- `matrixL1Norm_eq_zero_iff` confirms definiteness, so the estimates are not
  vacuous (a degenerate seminorm collapsing to `0` is excluded).
- The asymptotic theorem uses the punctured-neighborhood filter
  `nhdsWithin 0 {0}ᶜ`, because the quotient by `|theta|` is only meaningful for
  nonzero `theta`.
- The product identities are exact equalities (not merely inequalities); the
  explicit form makes them immediately usable to derive bounds such as
  `<= (n*theta)^2 + ...` via standard `|cos x - 1| <= x^2/2`,
  `|sin x - x| <= |x|^3/6`, now formalized in Lean.
- Fixed-time subdivision must be interpreted carefully. Since
  `isotropicStep` is a one-parameter group, `step (T/(N+1))^(N+1)` is exactly
  `step T`; comparing this to the first-order model `1 + T*generator` leaves
  the fixed first-order remainder at `T`, not an error that vanishes as
  `N -> infinity`.
- No continuum Dirac-limit statement is asserted anywhere. All results are
  finite-dimensional identities or one-variable asymptotics.
- 1+1D checkerboard content remains fully separate from the 3+1D
  hyperdiamond/Gate C modules.
- Dependency audit: every listed theorem depends only on `propext`, `Classical.choice`,
  `Quot.sound`.

## Ranked Next Steps

1. **Reconstruction theorem statement -- `checkerboard_dirac_limit_statement`.**
   Use the finite path-sum, endpoint-count, one-parameter group, and
   accumulated-angle asymptotic layers to state the exact topology and
   interpolation map required for a future 1+1D Dirac-limit theorem. Do not
   assert convergence until the comparison norm and field interpolation are
   explicit. Label: **reconstruction theorem statement / analytic scaffold**.

2. **Consistency check -- `checkerboard_step_pow_unitary` / operator audit.**
   Prove `matrixL1Norm`-level control is consistent with unitarity
   (`isotropicStep theta` is unitary; its powers preserve an entrywise-controlled
   norm). Compare against operator-derived physical audit predicates. Label:
   **consistency check**.

3. **Finite identity -- source-fixed hyperdiamond pole data.**
   Independent 3+1D lane; discharge `PoleStructureNeedsFifthVector` for a
   concrete convention. Kept strictly separate from this 1+1D lane. Label:
   **finite identity** (reconstruction once a named operator is fixed).

4. **Reconstruction theorem -- topology-explicit checkerboard-to-Dirac limit.**
   Only after step 1: state (not yet prove) the scaling hypotheses under which
   the interpolated finite recurrence converges to the 1+1D Dirac evolution.
   Label: **reconstruction theorem** (do not assert convergence yet).

### Comparison of the requested candidates

| Candidate | Label | Readiness |
| --- | --- | --- |
| source-fixed hyperdiamond pole data | finite identity / reconstruction | separate 3+1D lane; blocked on a fixed convention |
| operator-derived physical audit predicates | consistency check / physical prediction | needs a concrete operator referent |
| topology-explicit checkerboard-to-Dirac limit | reconstruction theorem | premature; depends on step 1 |
| **topology-explicit checkerboard-to-Dirac statement** (recommended) | **reconstruction theorem statement** | **ready for design, not proof** |

## Single Best Next Aristotle Job

Design `checkerboard_dirac_limit_statement`: a topology-explicit Lean scaffold
for a future checkerboard-to-Dirac reconstruction theorem. It should name the
interpolation map, comparison norm, scaling assumptions, and exact finite
theorems it depends on. It should not prove or assert convergence yet.
