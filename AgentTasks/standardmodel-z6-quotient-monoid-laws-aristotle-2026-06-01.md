# Aristotle task: Standard Model Z6 quotient monoid laws and image hom

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `6c1794df-d31b-4fd6-a9c8-fe0f7cda23a7`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave4-20260601-project`
**Output**: `AgentTasks/aristotle-output/standardmodel-z6-quotient-monoid-laws-20260601`
**Integrated**: 2026-06-01
**Type**: Standard Model gauge quotient, monoid laws, image homomorphism

## Goal

Upgrade the current quotient-monoid scaffold from `One`/`Mul` plus image
compatibility to a genuine `Monoid` API. Then package the quotient-image map as
a monoid homomorphism and expose the covering-map image as a submonoid of the
matrix-pair codomain.

This is the next algebraic step toward the paper's Standard Model gauge-group
quotient story. It remains deliberately weaker than a quotient group, Lie group,
or topological quotient theorem.

## Requested file

Create:

```text
PhysicsSM/Gauge/StandardModelZ6QuotientMonoidLaws.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelZ6QuotientMonoid
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

From `StandardModelZ6QuotientMonoid`:

- `CoveringTriple`
- existing `One CoveringTriple` and `Mul CoveringTriple`
- `CoveringTriple.image`
- `CoveringTriple.image_one`
- `CoveringTriple.image_mul`
- `CoveringTriple.imageEquivalent_mul`
- `StandardModelCoveringQuotient`
- existing `One StandardModelCoveringQuotient` and
  `Mul StandardModelCoveringQuotient`
- `standardModelCoveringQuotient_one_mk`
- `standardModelCoveringQuotient_mul_mk`
- `standardModelCoveringQuotientImage`
- `standardModelCoveringQuotientImage_one`
- `standardModelCoveringQuotientImage_mul`

The codomain of `standardModelCoveringQuotientImage` is:

```lean
Prod (Matrix (Fin 2) (Fin 2) Complex) (Matrix (Fin 3) (Fin 3) Complex)
```

which is definitionally the same codomain as the existing product type syntax.

## Target declarations

First prove monoid laws for representatives:

```lean
noncomputable instance CoveringTriple.instMonoid : Monoid CoveringTriple := ...

theorem CoveringTriple.mul_assoc
    (x y z : CoveringTriple) : x * y * z = x * (y * z) := ...

theorem CoveringTriple.one_mul
    (x : CoveringTriple) : 1 * x = x := ...

theorem CoveringTriple.mul_one
    (x : CoveringTriple) : x * 1 = x := ...
```

Then prove the quotient has a monoid structure:

```lean
noncomputable instance StandardModelCoveringQuotient.instMonoid :
    Monoid StandardModelCoveringQuotient := ...
```

It is fine if the named theorem lemmas come after the instance, but please
include usable names for associativity and identity on the quotient if
convenient:

```lean
theorem standardModelCoveringQuotient_mul_assoc
    (q r s : StandardModelCoveringQuotient) :
    q * r * s = q * (r * s) := ...

theorem standardModelCoveringQuotient_one_mul
    (q : StandardModelCoveringQuotient) : 1 * q = q := ...

theorem standardModelCoveringQuotient_mul_one
    (q : StandardModelCoveringQuotient) : q * 1 = q := ...
```

Package the quotient image map as a monoid hom:

```lean
abbrev StandardModelCoveringImageCodomain :=
  Prod (Matrix (Fin 2) (Fin 2) Complex) (Matrix (Fin 3) (Fin 3) Complex)

noncomputable def standardModelCoveringQuotientImageMonoidHom :
    StandardModelCoveringQuotient ->* StandardModelCoveringImageCodomain := ...
```

Expose the range as a submonoid:

```lean
noncomputable def standardModelCoveringImageSubmonoid :
    Submonoid StandardModelCoveringImageCodomain := ...
```

Package the map into that submonoid:

```lean
noncomputable def standardModelCoveringQuotientImageSubmonoidHom :
    StandardModelCoveringQuotient ->*
      standardModelCoveringImageSubmonoid := ...
```

Add a bundled result:

```lean
structure StandardModelZ6QuotientMonoidLawsPackage where
  quotient_monoid : Monoid StandardModelCoveringQuotient
  image_monoid_hom :
    StandardModelCoveringQuotient ->* StandardModelCoveringImageCodomain
  image_submonoid : Submonoid StandardModelCoveringImageCodomain

noncomputable def standardModelZ6QuotientMonoidLawsPackage :
    StandardModelZ6QuotientMonoidLawsPackage := ...
```

If the exact package field for `quotient_monoid` causes instance elaboration
trouble, replace it with named laws instead of weakening theorem statements.

## Claim boundary

This proves a monoid-level quotient/image scaffold for the current
quotient-by-image-equivalence type. It does not prove inverses, a quotient
group, a topological quotient, a smooth quotient, or an isomorphism with
`S(U(2) x U(3))`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change the definition of `CoveringTriple.ImageEquivalent`.
- Do not change any existing quotient relation.
- Prefer quotient induction and `Subtype.ext`/`Prod.ext` for extensional goals.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelZ6QuotientMonoidLaws.lean
lake build PhysicsSM.Gauge.StandardModelZ6QuotientMonoidLaws
```
