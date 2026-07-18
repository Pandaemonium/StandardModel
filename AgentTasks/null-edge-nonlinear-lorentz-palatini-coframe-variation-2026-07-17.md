# Nonlinear Lorentz Palatini coframe variation and curvature extraction

Date: 2026-07-17
Work item: `GR-PALATINI-COFRAME-001`

## Result

The concrete nonlinear ordered-holonomy action now has both finite partial
variation systems derived from the same scalar functional.

- Along every affine coframe line, the action has an exact quadratic
  expansion. Its linear coefficient is therefore the ordinary coframe
  derivative.
- The coframe response is a sum of site-local linear maps and is equivalent
  to vanishing of sixteen matrix-entry Euler coefficients per site.
- Joint stationarity is equivalent to the six link coefficients and sixteen
  coframe coefficients vanishing at every site.
- Every ordered holonomy trace functional has an explicit six-component
  Krein-dual curvature representative.
- Antisymmetrizing this representative in the two plaquette directions leaves
  the full action unchanged, because the complementary coframe face is
  antisymmetric.
- Consequently the exact nonlinear action is a finite Palatini pairing with
  an explicitly extracted antisymmetric curvature field.

All headline theorems carry build-enforced standard-three assumption guards.
There are no proof holes or compiler-trust finite decisions in either live
module.

## Main declarations

- `nonlinearCoframePlaquetteAction_coframeLine`
- `hasDerivAt_nonlinearCoframePlaquetteAction_coframeLine`
- `nonlinearCoframePlaquetteCoframeStationary_iff_coefficients`
- `nonlinearCoframePlaquetteJointStationary_iff_coefficients`
- `orderedPlaquetteActionTerm_eq_kreinPair_curvature`
- `orderedHolonomyCurvature_unique`
- `extractedPlaquetteCurvature_isAntisymmetric`
- `nonlinearCoframePlaquetteAction_eq_extractedCurvaturePalatiniAction`

## Files

- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniCoframeVariation.lean`
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniCurvatureExtraction.lean`

## Verification

```text
lake build PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
lake build PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction
```

Both targeted builds passed under the pinned Lean toolchain. Broader facade,
strict-token, pre-commit, and full-build checks remain scheduled after the
determinant/scalar-curvature bridge is integrated.

## Remaining semantic gate

The extracted six-vector is exactly the curvature component seen by the
Palatini trace functional. The current theorem does not identify it with a
continuum Riemann tensor. To connect the coframe Euler coefficients to the
finite Einstein tensor, the next exact algebraic step is

```text
PalatiniDensity(e,F) = -det(e) ScalarCurvature(e^{-1},F),
```

with the project orientation and mostly-minus bivector conventions. That
normalization-sensitive theorem is the focused Aristotle task recorded in
`AgentTasks/null-edge-palatini-density-einstein-aristotle-2026-07-17.md`.
