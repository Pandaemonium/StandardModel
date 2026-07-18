# Null-edge Krein link adjoint

Date: 2026-07-17
Work item: `GR-PALATINI-LINK-003`
Status: kernel-checked abstract bridge; physical bivector successor landed

## Result

`PhysicsSM/Draft/NullEdge/FinitePeriodicKreinLinkAdjoint.lean` separates the
Lorentzian pairing convention from the Euclidean transported-fiber control.
A finite fundamental symmetry `J` carries explicit involutivity and
self-adjointness laws. The module defines

```text
[u,v]_J = <J u,v>
U^sharp u = J U^T J u
```

and proves:

- symmetry of the finite `J` pairing;
- the exact adjoint identity `[u,Uv]_J = [U^sharp u,v]_J`;
- exact periodic summation by parts with `U^sharp` on the predecessor link;
- recovery of ordinary transpose when `J` is the identity fundamental
  symmetry;
- an explicit diagonal `(3,3)` six-component fundamental-symmetry control.

The main results carry build-enforced standard-three axiom guards. No proof
placeholder or compiled-evaluator shortcut is used.

## Interpretation boundary at landing

This module is abstract in the finite fiber and `J`. Its successor
`LorentzBivectorKreinBridge.lean` now chooses the physical ordering of the six
Lorentz bivector components, derives the pairing from the mostly-minus metric,
and proves preservation by the exterior-square action of every eta-Lorentz
transport. The face weight from null-coframe `e wedge e` and the nonlinear
plaquette-holonomy variation remain open.

## Successor

`FinitePeriodicKreinLinkPalatiniVariation.lean` now replaces the Euclidean
pairing in the full transported link/face action by the derived
Lorentz-bivector `J` pairing. The remaining target is to derive the face weight
from coframe bivectors and dual volumes, nonlinearize the Lorentz holonomy
variation, and test the resulting Euler equation on the three-site conformal
null-edge chart before any Levi-Civita recovery claim.

## Verification

```text
lake env lean PhysicsSM/Draft/NullEdge/FinitePeriodicKreinLinkAdjoint.lean
lake build PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
lake build PhysicsSM.Draft.NullEdge.GRFoundations
```

All commands passed. The six-file strict GR source scan found no forbidden
Lean-code tokens.
