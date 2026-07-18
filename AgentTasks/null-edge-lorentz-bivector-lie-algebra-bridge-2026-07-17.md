# Null-edge Lorentz bivector/Lie-algebra bridge

Date: 2026-07-17
Work item: `GR-PALATINI-LINK-006B`
Status: landed

## Result

`PhysicsSM/Draft/NullEdge/LorentzBivectorLieAlgebraBridge.lean` closes the
type mismatch between the six-component Palatini face field and matrix-valued
Lorentz holonomy tangents.

In the fixed basis `(12,13,23,01,02,03)`, it defines the antisymmetric
contravariant bivector matrix `F(B)` and the infinitesimal Lorentz generator
`hat(B)=F(B) eta`. The guarded exact results prove:

- `hat(B)^T eta + eta hat(B)=0`;
- ordered coordinate recovery is a two-sided inverse on the Lorentz Lie
  algebra, hence an equivalence with the six-component fiber;
- `-1/2 tr(hat(B)hat(C))` is exactly the existing Lorentz-bivector Krein
  pairing with signature `(+,+,+,-,-,-)`.

The result does not assert that an arbitrary matrix plaquette tangent is in the
Lorentz image. That is the next nonlinear link-variation gate.

## Verification

```text
lake env lean PhysicsSM/Draft/NullEdge/LorentzBivectorLieAlgebraBridge.lean
lake build PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
lake build PhysicsSM.Draft.NullEdge.GRFoundations
```

All three commands passed. The live module contains no proof placeholders or
native evaluator shortcuts and carries build-enforced axiom guards.

## Provenance

The identification of bivectors with `so(1,3)` and the normalized matrix-trace
pairing are standard finite Lorentz representation theory. The explicit
rotation/boost ordering, mostly-minus signs, and bridge to the repository's
Krein link/face API are project-local convention work.

## Remaining gate

Prove that the exact right-logarithmic derivative of the group plaquette is a
Lorentz Lie-algebra element, recover its six coordinates, and pair those
coordinates with the coframe/Hodge face field. Aristotle task
`b96861ca-12ff-460e-b123-f06995cf2750` targets this step.
