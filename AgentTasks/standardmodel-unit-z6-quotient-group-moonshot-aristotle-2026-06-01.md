# Aristotle task: Unit-level Standard Model Z6 quotient group moonshot

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Moonshot
**Prepared**: 2026-06-01
**Superseded job**: `5ad3fbb4-222c-44b8-9e07-222a7a0ee735` (canceled after `StandardModelUnitCoveringTriple` integrated)
**Submitted**: 2026-06-01
**Job ID**: `8484c1de-d4e8-4eef-9a3f-398730a60245`
**Submission project**: `AgentTasks/aristotle-submit/paper-stretch-wave8b-20260601-project`
**Output**: `AgentTasks/aristotle-output/standardmodel-unit-z6-quotient-group-moonshot-20260601`
**Integrated**: 2026-06-01
**Type**: Standard Model gauge quotient, unit-level group scaffold

## Goal

Move beyond the raw monoid quotient scaffold by building a unit-level covering
domain and a genuine group quotient-by-image-equivalence API.

This is intentionally very ambitious. The current raw `CoveringTriple` uses
plain complex numbers and plain matrices, so it supports a monoid quotient but
not a clean group quotient. This job should build the unit-domain replacement
and push as far as possible toward a group equivalence with the image subgroup.

## Requested file

Create:

```text
PhysicsSM/Gauge/StandardModelUnitZ6QuotientGroup.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelUnitCoveringTriple
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Target design

Use the already integrated unit-level covering triple:

```lean
UnitCoveringTriple
UnitCoveringTriple.instGroup
UnitCoveringTriple.toCoveringTriple
unitCoveringTripleToCoveringTripleMonoidHom
standardModelUnitCoveringTriplePackage
```

Do not redefine these names.

Construct a unit-valued covering image. A useful helper is a scalar-matrix unit:

```lean
noncomputable def matrixScalarUnit
    {n : Type} [Fintype n] [DecidableEq n]
    (z : Units Complex) :
    Units (Matrix n n Complex) := ...
```

The value should be `z • 1`, with inverse `z⁻¹ • 1`.

Then define:

```lean
abbrev UnitCoveringImageCodomain :=
  Units (Matrix (Fin 2) (Fin 2) Complex) *
    Units (Matrix (Fin 3) (Fin 3) Complex)
```

If product notation as a type is awkward, use `Prod`.

```lean
noncomputable def UnitCoveringTriple.image
    (x : UnitCoveringTriple) : UnitCoveringImageCodomain := ...

def UnitCoveringTriple.ImageEquivalent
    (x y : UnitCoveringTriple) : Prop := x.image = y.image

instance UnitCoveringTriple.imageSetoid : Setoid UnitCoveringTriple := ...

abbrev StandardModelUnitCoveringQuotient :=
  Quotient UnitCoveringTriple.imageSetoid
```

Prove the quotient has a group structure induced by componentwise operations:

```lean
noncomputable instance : Group StandardModelUnitCoveringQuotient := ...
```

Build the image map as a group hom:

```lean
noncomputable def standardModelUnitCoveringQuotientImageGroupHom :
    StandardModelUnitCoveringQuotient ->*
      UnitCoveringImageCodomain := ...
```

If `->*` gives a monoid hom because groups are monoids, that is fine.

Build the range subgroup and equivalence:

```lean
noncomputable def standardModelUnitCoveringImageSubgroup :
    Subgroup UnitCoveringImageCodomain := ...

noncomputable def standardModelUnitCoveringQuotientMulEquivImageSubgroup :
    StandardModelUnitCoveringQuotient ≃*
      standardModelUnitCoveringImageSubgroup := ...
```

Package the result:

```lean
structure StandardModelUnitZ6QuotientGroupPackage where
  quotient_group : Group StandardModelUnitCoveringQuotient
  image_hom :
    StandardModelUnitCoveringQuotient ->* UnitCoveringImageCodomain
  image_subgroup : Subgroup UnitCoveringImageCodomain
  quotient_equiv_image :
    StandardModelUnitCoveringQuotient ≃* image_subgroup
```

Adjust field types if Lean elaboration requires naming the subgroup before the
structure.

## Claim boundary

This is still an algebraic unit-domain quotient-by-image scaffold. It does not
prove a topological quotient, smooth quotient, compact Lie group theorem, or
the exact `S(U(2) x U(3))` theorem. It also does not enforce determinant-one
or unitarity unless you can do so cleanly without blocking the group quotient
scaffold.

## Fallback

If the full quotient group is too hard, prioritize:

1. `UnitCoveringTriple`
2. `Group UnitCoveringTriple`
3. `UnitCoveringTriple.image` as a monoid/group hom
4. image-equivalence setoid
5. quotient `Group`

Return any strong sorry-free prefix in trusted code. Put blocked theorem
statements only in a draft handoff file.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted output.
- Do not modify existing raw quotient files.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake build PhysicsSM.Gauge.StandardModelUnitZ6QuotientGroup
```
