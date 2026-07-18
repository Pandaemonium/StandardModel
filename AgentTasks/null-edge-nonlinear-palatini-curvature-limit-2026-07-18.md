# Null-edge nonlinear Palatini curvature-limit bridge

Date: 2026-07-18
Work item: `GR-PALATINI-LIMIT-005`
Status: finite and conditional limit bridge landed; physical reconstruction active

## Objective

Connect the exact six-component curvature extracted by the concrete nonlinear
Palatini action to a first-order plaquette-holonomy limit, then pass the finite
coframe Euler equation to the limiting mixed vacuum Einstein equation.

## Kernel-checked chain

`NonlinearLorentzPalatiniCurvatureLimit` adds the following exact interfaces:

1. `actionVisibleMatrixCurvature` is a linear map from arbitrary real `4 x 4`
   matrix increments to the ordered six-component curvature fiber;
2. `actionVisibleMatrixCurvature_lorentzGenerator` proves exact identity on
   the project Lorentz-generator image, including the Krein/trace signs;
3. `orderedHolonomyCurvature_eq_actionVisibleMatrixCurvature` identifies this
   map with the curvature already used by the concrete action;
4. `actionVisibleFirstOrderHolonomyLimit_converges` turns an exact expansion
   `H_n = I + A_n (hat(F) + r_n)`, with shrinking nonzero area and vanishing
   matrix residual, into convergence of the normalized action-visible
   curvature to `F`;
5. `normalizedExtractedPlaquetteCurvature_tendsto` proves that ordered-face
   antisymmetrization preserves the same target;
6. `mixedVacuumEinsteinEntryLinear` packages each fixed-coframe mixed Einstein
   entry as a continuous linear curvature functional;
7. `coframeStationary_refinementLimit_mixedVacuumEinstein` composes the exact
   finite stationarity theorem with those limits. If the fixed coframe is
   stationary at every refinement, the target satisfies every equation
   `2 Ric^d_c - delta^d_c R = 0`.

The flat identity-holonomy family is an explicit witness that the first-order
limit structure is consistent.

## Claim boundary

The headline is a conditional asymptotic theorem. It does not derive:

- a refinement family or plaquette areas from a bare graph;
- convergence of the coframe or inverse coframe;
- eta-Lorentz membership of the supplied `GL4` links;
- Levi-Civita selection by the separate link Euler equation;
- identification of the six-component target with continuum Riemann
  curvature;
- metric dual-cell weights, physical boundary terms, matter coupling, or
  global variation-limit interchange.

The theorem therefore closes the action-visible extraction and fixed-coframe
limit composition without claiming an unconditional derivation of continuum
general relativity.

## Convention lock

- metric signature: mostly minus;
- orientation: `0123`;
- bivector order: `(12,13,23,01,02,03)`;
- Krein signs: `(+,+,+,-,-,-)`;
- normalized trace pairing: `-1/2 tr(hat(B) hat(F)) = [B,F]_J`;
- curvature normalization: `(H-I)/area`;
- finite vacuum equation: `2 Ric^d_c - delta^d_c R = 0`.

## Verification

Passed:

```text
lake env lean PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniCurvatureLimit.lean
lake build PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
lake build PhysicsSM.Draft.NullEdge.GRFoundations
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniCurvatureLimit.lean PhysicsSM/Draft/NullEdge/GRFoundations.lean
pre-commit run --all-files
lake build
```

The full build completed successfully with 8,319 jobs. Its informational
suggestions and linter warnings were pre-existing or nonfatal; the new module
has one nonfatal `ring_nf` suggestion.

## Next gates

1. derive or construct the first-order expansion on the physical eta-Lorentz
   link family;
2. allow varying coframes and prove joint coframe/curvature convergence;
3. identify the target with Levi-Civita Riemann curvature;
4. derive the dual-cell weight and physical boundary normalization;
5. add cosmological and matter responses on the same limiting geometry.
