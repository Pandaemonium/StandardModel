# Null-edge physical Lorentz plaquette refinement

Date: 2026-07-18
Work item: `GR-PALATINI-LIMIT-007`
Status: nonflat proper eta-Lorentz refinement witness landed; dynamical selection active

## Objective

Replace the arbitrary-`GL4` existence witness in the action-visible
curvature-limit interface with a genuine nonzero periodic link refinement in
which every link preserves the mostly-minus metric and has determinant `+1`.
Specialize the varying-coframe Einstein endpoint to this stronger physical
refinement class.

## Kernel-checked chain

`PhysicalLorentzPlaquetteRefinement` adds:

1. `exponentialHolonomy`, the exact group element
   `exp(area_n hat(F))`;
2. `exponentialResidual_tendsto_zero`, derived from the matrix-exponential
   derivative at zero;
3. `exponentialActionVisibleFirstOrderHolonomyLimit`, proving that the exact
   exponential holonomy has action-visible first-order limit `F`;
4. `exponentialHolonomy_isProperEtaLorentz`, certifying eta preservation and
   determinant `+1` at every refinement;
5. `squareShift_commute`, proving the four displayed periodic chart shifts
   commute;
6. `squareLorentzConnection`, a `2 x 2` square with identity horizontal links
   and a column-dependent vertical exponential link;
7. `squarePlaquetteHolonomy_eq_exponential`, computing every ordered
   plaquette exactly. The two horizontal columns carry opposite exponential
   plaquettes and all other ordered faces are flat;
8. `physicalSquarePlaquetteRefinement`, packaging the exact square as an
   action-visible refinement with proper eta-Lorentz links;
9. `nonzero_physicalSquarePlaquetteRefinement`, proving every nonzero input
   `F` produces a nonzero physical target field;
10. `coframeStationary_physicalVaryingRefinementLimit`, passing stationary
    physical-link refinements with convergent varying tetrads to the limiting
    mixed vacuum Einstein equations.

## Claim boundary

The periodic square is a nonvacuous decorated witness. It does not prove:

- that a bare null-edge graph selects this connection or area scale;
- that the displayed nonzero square is stationary for the Palatini action;
- the orthochronous sign of the proper eta-Lorentz exponentials;
- Levi-Civita selection by the nonlinear link Euler equation;
- identification of the target with continuum Riemann curvature;
- dual-cell weighting, constants, boundary terms, or matter coupling.

No Baker-Campbell-Hausdorff approximation is used: each nontrivial plaquette
is exactly one exponential or its group inverse.

## Convention lock

- metric signature: mostly minus;
- orientation: `0123`;
- bivector order: `(12,13,23,01,02,03)`;
- group sector: eta-preserving and determinant `+1`;
- square directions: horizontal `0`, vertical `1`, inactive `2,3`;
- target orientation: opposite signs on the two horizontal columns.

## Verification

Passed:

```text
lake env lean PhysicsSM/Draft/NullEdge/PhysicalLorentzPlaquetteRefinement.lean
lake build PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement
lake build PhysicsSM.Draft.NullEdge.GRFoundations
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdge/PhysicalLorentzPlaquetteRefinement.lean PhysicsSM/Draft/NullEdge/GRFoundations.lean
pre-commit run --all-files
lake build
```

The full build completed successfully with 8,319 jobs. Reported informational
suggestions and linter warnings are pre-existing and nonfatal.

## Next gates

1. test the nonlinear link and coframe Euler coefficients on the physical
   square witness;
2. derive a stationary physical refinement or prove a precise obstruction;
3. connect the refinement to synchronized null-edge coframes;
4. prove Levi-Civita selection and identify the target with Riemann curvature;
5. add metric dual-cell weighting and matter/constants.
