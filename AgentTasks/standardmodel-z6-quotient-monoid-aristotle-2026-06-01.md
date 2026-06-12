# Aristotle task: Standard Model Z6 quotient monoid scaffold

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `da5f3ea2-9d9c-4d99-8df5-e5e7a22d18f3`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave3-20260601-project`
**Output**: `AgentTasks/aristotle-output/standardmodel-z6-quotient-monoid-20260601`
**Integrated**: 2026-06-01
**Type**: Quotient/image monoid scaffold for the SM covering map

## Goal

Upgrade the current image-equivalence quotient scaffold from a set-theoretic
quotient to a multiplicative scaffold. Define pointwise multiplication on
`CoveringTriple`, prove `CoveringTriple.image` is multiplicative, and define
the induced multiplication on `StandardModelCoveringQuotient`.

This is the next safe step toward a quotient-group theorem, but it remains a
purely algebraic monoid/image scaffold.

## Requested file

Create:

```text
PhysicsSM/Gauge/StandardModelZ6QuotientMonoid.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelZ6QuotientImageFiber
import PhysicsSM.Gauge.StandardModelBlockHom
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

From `StandardModelZ6QuotientScaffold` and descendants:

- `CoveringTriple`
- `CoveringTriple.identity`
- `CoveringTriple.image`
- `CoveringTriple.ImageEquivalent`
- `CoveringTriple.imageSetoid`
- `StandardModelCoveringQuotient`
- `standardModelCoveringQuotientImage`
- `standardModelCoveringQuotientImage_mk`
- `standardModelCoveringQuotientImage_injective`

From `StandardModelBlockHom`:

- `coveringMap_one`
- `coveringMap_mul`

## Target declarations

Define pointwise multiplication:

```lean
instance : One CoveringTriple := ⟨CoveringTriple.identity⟩

instance : Mul CoveringTriple := ⟨fun x y =>
  { phase := x.phase * y.phase
    su2Part := x.su2Part * y.su2Part
    su3Part := x.su3Part * y.su3Part }⟩
```

Prove:

```lean
theorem CoveringTriple.image_one :
    (1 : CoveringTriple).image = 1 := ...

theorem CoveringTriple.image_mul
    (x y : CoveringTriple) :
    (x * y).image = x.image * y.image := ...

theorem CoveringTriple.imageEquivalent_mul
    {x x' y y' : CoveringTriple}
    (hx : CoveringTriple.ImageEquivalent x x')
    (hy : CoveringTriple.ImageEquivalent y y') :
    CoveringTriple.ImageEquivalent (x * y) (x' * y') := ...
```

If feasible, add:

```lean
instance : Monoid CoveringTriple := ...
```

Then define quotient multiplication:

```lean
noncomputable instance : One StandardModelCoveringQuotient := ...
noncomputable instance : Mul StandardModelCoveringQuotient := ...
```

Prove representative lemmas:

```lean
theorem standardModelCoveringQuotient_one_mk :
    (1 : StandardModelCoveringQuotient) =
      Quotient.mk CoveringTriple.imageSetoid (1 : CoveringTriple) := ...

theorem standardModelCoveringQuotient_mul_mk
    (x y : CoveringTriple) :
    (Quotient.mk CoveringTriple.imageSetoid x *
      Quotient.mk CoveringTriple.imageSetoid y :
        StandardModelCoveringQuotient) =
      Quotient.mk CoveringTriple.imageSetoid (x * y) := ...
```

Most important target:

```lean
theorem standardModelCoveringQuotientImage_mul
    (q r : StandardModelCoveringQuotient) :
    standardModelCoveringQuotientImage (q * r) =
      standardModelCoveringQuotientImage q *
        standardModelCoveringQuotientImage r := ...
```

If the `Monoid StandardModelCoveringQuotient` instance is feasible, add it.
If it is time-consuming, prioritize the multiplication definition and image
multiplicativity theorem.

Package:

```lean
structure StandardModelZ6QuotientMonoidPackage where
  image_mul :
    forall q r : StandardModelCoveringQuotient,
      standardModelCoveringQuotientImage (q * r) =
        standardModelCoveringQuotientImage q *
          standardModelCoveringQuotientImage r
  image_one :
    standardModelCoveringQuotientImage (1 : StandardModelCoveringQuotient) = 1

theorem standardModelZ6QuotientMonoidPackage :
    StandardModelZ6QuotientMonoidPackage := ...
```

## Claim boundary

This is a monoid/image scaffold for the current quotient-by-image-equivalence
type. It does not prove a quotient group, a topological quotient, a smooth
quotient, or an isomorphism with `S(U(2) x U(3))`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change the definition of `CoveringTriple.ImageEquivalent`.
- Prefer representative induction on the quotient.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelZ6QuotientMonoid.lean
lake build PhysicsSM.Gauge.StandardModelZ6QuotientMonoid
```
