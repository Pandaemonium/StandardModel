# Null-edge checkerboard remainder-estimates Aristotle job

You are working in the standalone Lean 4 package `NullEdgeStandalone`.

## Build commands

Run narrow checks first:

```powershell
lake env lean PhysicsSM/Draft/CheckerboardContinuumScaffold.lean
lake env lean PhysicsSM/Draft/CheckerboardContinuumNext.lean
```

If those pass, run:

```powershell
lake build NullEdgeStandalone
```

## Current verified state

The checkerboard finite layer now includes:

- `isotropicGenerator`;
- `isotropicGenerator_sq`;
- `isotropicStep_eq_cos_smul_one_add_sin_smul_generator`;
- `isotropicStep_eq_one_add_sin_generator_add_cos_remainder`;
- `isotropicStepFirstOrderRemainder`;
- `isotropicStep_eq_one_add_theta_generator_add_remainder`;
- `isotropicStepFirstOrderRemainder_hasDerivAt_zero`;
- `hasDerivAt_isotropicStep`;
- `isotropicStep_hasDerivAt_zero`;
- `hasDerivAt_isotropicStep_zero`;
- `isotropicGenerator_commutes_isotropicStep`;
- `isotropicStep_mul`;
- `isotropicStep_pow_eq`.

The finite path-count layer also includes the packaged closed-form propagator:

- `spacetimeEndpointTurnClassClosedForm`;
- `spacetimeEndpointTurnClassCount_eq_closedForm`;
- `checkerStep_pow_apply_isotropic_spacetimeClosedForm`.

## Literature and physics orientation

This is a finite checkerboard / discrete-time quantum-walk scaffold for the
1+1D Dirac limit. Strauch's relativistic quantum walk
<https://arxiv.org/abs/quant-ph/0508096> and Di Molfetta--Arrighi's
continuous-time/continuous-spacetime quantum-walk limit
<https://arxiv.org/abs/1906.04483> motivate quantitative small-angle/product
estimates. Do not claim a continuum Dirac theorem here; the goal is only to
prepare exact finite and entrywise analytic lemmas that make such a theorem
well-posed later.

## Requested Lean work

Work in `PhysicsSM/Draft/CheckerboardContinuumScaffold.lean`, and import or use
`PhysicsSM/Draft/CheckerboardContinuumNext.lean` only if the group-law theorems
are useful.

Please prove the strongest clean next theorem you can around the packaged
first-order remainder. Good target shapes include:

1. Scalar quotient estimates showing that
   `(sin theta - theta) / theta -> 0` and
   `(cos theta - 1) / theta -> 0` as `theta -> 0` through nonzero real values.
2. Entrywise matrix quotient estimates showing that each entry of
   `isotropicStepFirstOrderRemainder theta / theta` tends to zero.
3. If Mathlib's asymptotics API is friendlier, equivalent `IsLittleO` or
   `Asymptotics` statements for the same scalar and entrywise claims.
4. Any exact finite product/remainder lemma that combines
   `isotropicStep_pow_eq` with
   `isotropicStep_eq_one_add_theta_generator_add_remainder`.

If a fully quantitative estimate is blocked by Mathlib API friction, leave the
Lean source in a compiling state and return precise theorem statements, imports,
and the exact missing lemmas or API names. Do not weaken semantic content into a
vacuous statement.

## Strategy request

Also return a ranked list of the most important next pieces for the null-edge
standalone project after this job. Compare:

- checkerboard quantitative limit preparation;
- hyperdiamond four-edge/fifth-vector pole-structure no-go;
- converting free physical audit fields into operator-derived predicates.

For each item, say whether it is a finite identity, asymptotic theorem,
reconstruction theorem, consistency check, or physical prediction.

## Constraints

- Do not introduce new assumptions or fake placeholders.
- Do not assert convergence to the continuum Dirac equation.
- Keep checkerboard 1+1D results separate from the 3+1D hyperdiamond/Gate C
  lane.
- Keep theorem statements semantically faithful to the current Lean definitions.

## Desired output

Return:

1. modified Lean/docs files;
2. exact commands run and whether they passed;
3. semantic review of any new theorem statements;
4. ranked next steps and the single best next Aristotle job.
