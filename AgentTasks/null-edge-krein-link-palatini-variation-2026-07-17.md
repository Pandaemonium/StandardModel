# Null-edge Krein link/face Palatini variation

Date: 2026-07-17
Work item: `GR-PALATINI-LINK-005`
Status: kernel-checked full linearized Lorentz/Krein Euler chain

## Result

`PhysicsSM/Draft/NullEdge/FinitePeriodicKreinLinkPalatiniVariation.lean`
combines the finite-fiber ordered face action with the indefinite pairing and
predecessor adjoint. It proves:

- the exact two-branch periodic Krein summation-by-parts response;
- the full local Euler pairing with predecessor transport `J U^T J`;
- finite-sum linearity of matrix action and the Krein pairing;
- `J`-raised site/link/component probes extract ordinary Euler components;
- stationarity is equivalent to pointwise vanishing of every Euler component;
- antisymmetric face data reduce the equation to vanishing Krein covariant
  backward divergence;
- identity transport and site-constant face data are stationary;
- the complete action and Euler pairing specialize to the spacetime-derived
  six-component Lorentz-bivector fundamental symmetry.

The headline results carry build-enforced standard-three axiom guards. No
proof handoff or compiled-evaluator shortcut is used.

## Interpretation boundary

This closes the full linearized Lorentz/Krein link/face variation. The face
weight is still supplied rather than derived from null-coframe bivectors and
dual-cell volumes. Transport is still varied through an additive tangent
curvature rather than exact nonlinear Lorentz plaquette holonomy, and no
Levi-Civita selection theorem is claimed.

## Next target

Define the coframe-derived bivector face field with orientation and dual-cell
volume, then derive the nonlinear group-valued plaquette variation and rerun
the exact conformal witness. The resulting stationary equation must select
the compatible Levi-Civita link, modulo any explicitly classified projective
or boundary freedom.

## Verification

```text
lake env lean PhysicsSM/Draft/NullEdge/FinitePeriodicKreinLinkPalatiniVariation.lean
```

The command passed after removing one unused section variable.
