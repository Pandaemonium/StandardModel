# Null-edge atlas component-character bridge

Date: 2026-07-16

Work item: `GRAV-GROWING-ATLAS-001`

Status: kernel-checked and built

## Purpose

`PhysicsSM/Draft/NullEdge/AtlasComponentCharacter.lean` isolates the generic
atlas algebra needed by both orientability and time orientability.  For a Cech
transition field in any group `G` and a group homomorphism

```text
G -> Multiplicative (ZMod 2),
```

the induced component transition is again an exact Cech field.  Taking the
character commutes with chart gauge, maps path transport to path transport,
and gives gauge-invariant products on closed nerve paths.

## GR interpretation

Once concrete determinant and time-orientation characters are available for
the graph-derived Lorentz transition group, this one theorem supplies both
first obstruction layers:

- determinant character: orientability of the derived cotangent atlas;
- time character: time orientability of the derived Lorentz atlas.

A nontrivial closed product is a global reduction obstruction.  It is not
curvature: valid Cech transitions remain triangle-flat on occupied triple
overlaps.  Curvature continues to belong to the independent connection
transport field.

## Claim boundary

- Generic character/Cech/gauge/path algebra: finite `M`.
- Concrete determinant and time characters: kernel-checked in
  `LorentzComponentCharacter.lean`.
- Bundling eta-Lorentz matrices as a group and exposing both characters as
  `MonoidHom`s: open packaging step.
- Vanishing of either obstruction on graph-derived atlases: open.

## Verification record

- Module SHA-256:
  `7bb05bbf7f48a314bfeacb88f1b1bd52a52a8d7b14665802959c928132684917`.
- Lean LSP diagnostics passed with no errors or warnings after elaborating the
  complete module and all four build-enforced axiom guards.
- `lake build PhysicsSM.Draft.NullEdge.LorentzComponentCharacter` built this
  module as a dependency and completed successfully (`8043` jobs).
- Targeted pre-commit passed.
