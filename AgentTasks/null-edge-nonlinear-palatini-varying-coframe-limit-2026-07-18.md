# Null-edge nonlinear Palatini varying-coframe limit

Date: 2026-07-18
Work item: `GR-PALATINI-LIMIT-006`
Status: conditional varying-coframe limit bridge landed; physical reconstruction active

## Objective

Remove the fixed-coframe restriction from the action-visible curvature-limit
theorem. Allow the finite tetrad and its supplied inverse to vary with
refinement, prove their inverse relation survives the limit, and pass finite
Palatini coframe stationarity to the limiting mixed vacuum Einstein equation.

## Kernel-checked chain

`NonlinearLorentzPalatiniVaryingCoframeLimit` adds:

1. `bivectorMatrixLinear` and `bivectorMatrixContinuous`, making the internal
   six-component bivector conversion continuous;
2. `inverseCoframeScalarCurvature_tendsto_joint`, proving joint convergence of
   the scalar curvature contraction;
3. `mixedRicciCurvature_tendsto_joint`, proving joint convergence of each
   mixed Ricci entry;
4. `mixedVacuumEinsteinEntry_tendsto_joint`, proving joint continuity of the
   complete mixed Einstein polynomial;
5. `CoframeRefinementLimit`, packaging exact finite left inverses and
   simultaneous componentwise coframe/inverse-coframe convergence;
6. `CoframeRefinementLimit.target_leftInverse`, proving the limiting pair is
   still left-inverse;
7. `coframeStationary_varyingRefinementLimit`, composing the supplied tetrad
   and action-visible curvature refinements. It concludes both the limiting
   inverse relation and all equations
   `2 Ric^d_c - delta^d_c R = 0`.

## Claim boundary

The headline remains a conditional asymptotic theorem. It does not derive:

- the graph refinement, plaquette areas, or first-order holonomy expansion;
- convergence of the coframe or inverse coframe from null-edge dynamics;
- eta-Lorentz membership of the supplied group links;
- Levi-Civita selection from the separate link Euler equation;
- identification of the limiting target with continuum Riemann curvature;
- metric dual-cell weights, constants, matter, or physical boundary terms.

The new theorem closes the mathematical limit passage once joint convergence
is supplied. It does not claim that a bare graph supplies those hypotheses.

## Convention lock

- metric signature: mostly minus;
- orientation: `0123`;
- bivector order: `(12,13,23,01,02,03)`;
- Krein signs: `(+,+,+,-,-,-)`;
- finite vacuum equation: `2 Ric^d_c - delta^d_c R = 0`;
- limiting nondegeneracy: convergence of both coframe and exact inverse.

## Verification

Passed:

```text
lake env lean PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniVaryingCoframeLimit.lean
lake build PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniVaryingCoframeLimit
lake build PhysicsSM.Draft.NullEdge.GRFoundations
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniVaryingCoframeLimit.lean PhysicsSM/Draft/NullEdge/GRFoundations.lean
pre-commit run --all-files
lake build
```

The full build completed successfully with 8,319 jobs. Reported informational
suggestions and linter warnings are pre-existing and nonfatal.

## Next gates

1. construct a physical eta-Lorentz first-order plaquette refinement;
2. derive the coframe convergence hypotheses from synchronized null-edge data;
3. prove that the nonlinear link equation selects Levi-Civita transport;
4. identify the common curvature target with Levi-Civita Riemann curvature;
5. derive dual-cell weighting and matter/constants on the same limit.
