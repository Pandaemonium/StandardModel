# Null-edge checkerboard generator-expansion Aristotle job

You are working in the standalone Lean 4 package `NullEdgeStandalone`.

## Build commands

Run the narrow checks first:

```powershell
lake env lean PhysicsSM/Draft/CheckerboardContinuumScaffold.lean
lake env lean PhysicsSM/Draft/CheckerboardSpacetimeCounts.lean
```

If those pass, run:

```powershell
lake build NullEdgeStandalone
```

## Current verified state

The checkerboard finite layer now includes:

- `checkerStep_pow_apply_isotropic_velocityEndpoint`;
- `checkerStep_pow_apply_isotropic_spacetimeEndpoint`;
- `spacetimeEndpointTurnClassClosedForm`;
- `spacetimeEndpointTurnClassCount_eq_closedForm`;
- `checkerStep_pow_apply_isotropic_spacetimeClosedForm`.

The exact finite generator setup now lives in:

```text
PhysicsSM/Draft/CheckerboardContinuumScaffold.lean
```

with:

- `isotropicGenerator`;
- `isotropicGenerator_sq`;
- `isotropicStep_eq_cos_smul_one_add_sin_smul_generator`;
- `isotropicStep_eq_one_add_sin_generator_add_cos_remainder`.

The intended first target has been sanity-checked to typecheck:

```lean
HasDerivAt isotropicStep isotropicGenerator 0
```

## Requested work

1. Prove the strongest clean generator-expansion theorem you can, preferably:

```lean
theorem hasDerivAt_isotropicStep_zero :
    HasDerivAt isotropicStep isotropicGenerator 0 := by
  ...
```

2. If useful, add supporting finite/calculus lemmas in
   `PhysicsSM/Draft/CheckerboardContinuumScaffold.lean`, such as:

- derivative of each matrix entry;
- a small-angle remainder theorem derived from
  `isotropicStep_eq_one_add_sin_generator_add_cos_remainder`;
- an exact statement identifying `isotropicGenerator` as the tangent generator
  of the one-parameter group `isotropicStep`.

3. Add a short report or update docs only if the proof requires a theorem
   statement adjustment. Keep the result framed as finite calculus / analytic
   scaffold. Do not claim a continuum Dirac limit.

## Constraints

- Do not weaken the theorem silently.
- Do not introduce new assumptions or fake placeholders in trusted-looking code.
- Do not assert convergence to the continuum Dirac equation.
- Keep this target separate from the 3+1D hyperdiamond/Gate C material.

## Desired output

Return:

1. modified Lean/docs files;
2. exact commands run and whether they passed;
3. semantic review of new theorem statements;
4. ranked next steps after this generator layer.
