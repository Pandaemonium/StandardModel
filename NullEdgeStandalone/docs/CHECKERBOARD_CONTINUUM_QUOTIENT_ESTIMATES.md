# Checkerboard Continuum Quotient Estimates

Date: 2026-07-02

Lean module:
`PhysicsSM.Draft.CheckerboardContinuumScaffold`.

## What Was Proved

The checkerboard finite calculus layer now has quantitative small-angle
estimates for the packaged first-order remainder
`isotropicStepFirstOrderRemainder`.

New theorems:

| Theorem | Meaning | Claim type |
| --- | --- | --- |
| `sin_sub_id_div_tendsto_zero` | `(sin theta - theta) / theta -> 0` as `theta -> 0` through nonzero reals | scalar quotient limit |
| `cos_sub_one_div_tendsto_zero` | `(cos theta - 1) / theta -> 0` as `theta -> 0` through nonzero reals | scalar quotient limit |
| `sin_sub_id_isLittleO` | `sin theta - theta = o(theta)` at zero | scalar asymptotic |
| `cos_sub_one_isLittleO` | `cos theta - 1 = o(theta)` at zero | scalar asymptotic |
| `isotropicStepFirstOrderRemainder_div_tendsto_zero` | the first-order matrix remainder divided by `theta` tends to the zero matrix entrywise | finite-dimensional matrix quotient limit |

These theorems are derived from the existing packaged derivative facts:

- `hasDerivAt_isotropicStep`;
- `isotropicStep_hasDerivAt_zero`;
- `isotropicStepFirstOrderRemainder_hasDerivAt_zero`.

## Semantic Review

The scalar quotient limits use the punctured-neighborhood filter, because the
quotient is undefined in the intended analytic sense at `theta = 0`. The matrix
quotient theorem uses the product/entrywise topology on
`Matrix Direction Direction Complex`, avoiding any hidden choice of matrix norm.

A matrix-valued `IsLittleO` theorem was deliberately not added yet, because this
matrix type is currently used as a topological vector space rather than with a
chosen canonical norm. The next step is to introduce an explicit finite matrix
norm or normed-model wrapper, then restate the entrywise result as a normed
asymptotic theorem.

No continuum Dirac-limit theorem is claimed here.

## Next Steps

1. Define or select a finite matrix norm for `Matrix Direction Direction Complex`
   and prove equivalence to the entrywise topology in this two-by-two setting.
2. Upgrade `isotropicStepFirstOrderRemainder_div_tendsto_zero` to a normed
   `IsLittleO` statement.
3. Use `isotropicStep_pow_eq` to derive a product/remainder bound comparing
   `isotropicStep theta ^ n` with the first-order generator approximation.
4. Only after those estimates, state a topology-explicit checkerboard-to-Dirac
   scaling theorem.

Codex follow-up added the exact finite bridge
`isotropicStep_pow_eq_one_add_scaled_generator_add_remainder`; the remaining
work is now the normed/asymptotic bound, not the algebraic product identity.
