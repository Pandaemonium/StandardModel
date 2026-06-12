# Aristotle task: Standard Model Z6 quotient monoid equivalence with image

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `1bb0aab1-9dd9-4b01-b476-a17619c180b3`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave6-20260601-project`
**Output**: `AgentTasks/aristotle-output/standardmodel-z6-quotient-monoid-equiv-20260601`
**Integrated**: 2026-06-01
**Type**: Standard Model gauge quotient, monoid equivalence

## Goal

Upgrade the newly integrated monoid-law scaffold to a monoid equivalence between
the quotient-by-image-equivalence type and the image submonoid of the covering
map.

This is the natural monoid-level analogue of the already trusted type
equivalence:

```lean
standardModelCoveringQuotientEquivImage :
    Equiv StandardModelCoveringQuotient (Set.range CoveringTriple.image)
```

The result should remain deliberately weaker than a quotient group, Lie group,
or topological quotient theorem.

## Requested file

Create:

```text
PhysicsSM/Gauge/StandardModelZ6QuotientMonoidEquiv.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelZ6QuotientImageEquiv
import PhysicsSM.Gauge.StandardModelZ6QuotientMonoidLaws
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

- `StandardModelCoveringQuotient`
- `CoveringTriple.image`
- `standardModelCoveringQuotientImage`
- `standardModelCoveringQuotientImage_injective`
- `standardModelCoveringQuotientImage_range`
- `standardModelCoveringQuotientEquivImage`
- `standardModelCoveringQuotientEquivImage_apply`
- `standardModelCoveringQuotientEquivImage_symm_apply`
- `StandardModelCoveringImageCodomain`
- `standardModelCoveringQuotientImageMonoidHom`
- `standardModelCoveringImageSubmonoid`
- `standardModelCoveringQuotientImageSubmonoidHom`
- `StandardModelZ6QuotientMonoidLawsPackage`

## Target declarations

First prove useful coercion/apply lemmas for the submonoid hom:

```lean
@[simp] theorem standardModelCoveringQuotientImageSubmonoidHom_val
    (q : StandardModelCoveringQuotient) :
    (standardModelCoveringQuotientImageSubmonoidHom q).val =
      standardModelCoveringQuotientImage q := ...

theorem standardModelCoveringQuotientImageSubmonoidHom_injective :
    Function.Injective standardModelCoveringQuotientImageSubmonoidHom := ...

theorem standardModelCoveringQuotientImageSubmonoidHom_surjective :
    Function.Surjective standardModelCoveringQuotientImageSubmonoidHom := ...
```

Then construct the monoid equivalence. It is fine to build this manually from
bijectivity and prove `map_mul'` using
`standardModelCoveringQuotientImageSubmonoidHom.map_mul`.

```lean
noncomputable def standardModelCoveringQuotientMulEquivImageSubmonoid :
    MulEquiv StandardModelCoveringQuotient standardModelCoveringImageSubmonoid := ...
```

Add application lemmas:

```lean
@[simp] theorem standardModelCoveringQuotientMulEquivImageSubmonoid_apply_val
    (q : StandardModelCoveringQuotient) :
    (standardModelCoveringQuotientMulEquivImageSubmonoid q).val =
      standardModelCoveringQuotientImage q := ...

theorem standardModelCoveringQuotientMulEquivImageSubmonoid_symm_image
    (y : standardModelCoveringImageSubmonoid) :
    standardModelCoveringQuotientImage
      (standardModelCoveringQuotientMulEquivImageSubmonoid.symm y) =
      y.val := ...
```

Bundle the result:

```lean
structure StandardModelZ6QuotientMonoidEquivPackage where
  quotient_mul_equiv_image :
    MulEquiv StandardModelCoveringQuotient standardModelCoveringImageSubmonoid
  apply_image :
    forall q : StandardModelCoveringQuotient,
      (quotient_mul_equiv_image q).val = standardModelCoveringQuotientImage q
  symm_image :
    forall y : standardModelCoveringImageSubmonoid,
      standardModelCoveringQuotientImage (quotient_mul_equiv_image.symm y) =
        y.val

noncomputable def standardModelZ6QuotientMonoidEquivPackage :
    StandardModelZ6QuotientMonoidEquivPackage := ...
```

## Claim boundary

This proves a monoid equivalence between the current quotient scaffold and its
image submonoid. It does not prove inverses, a quotient group, a topological
quotient, a smooth quotient, or an isomorphism with `S(U(2) x U(3))`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change the definition of `CoveringTriple.ImageEquivalent`.
- Do not change existing quotient, monoid, or image definitions.
- Prefer quotient induction, `Subtype.ext`, and existing injectivity/range
  lemmas.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelZ6QuotientMonoidEquiv.lean
lake build PhysicsSM.Gauge.StandardModelZ6QuotientMonoidEquiv
```
