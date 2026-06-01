# Aristotle task: Standard Model Z6 quotient-image fiber uniqueness

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium-High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `c8351305-cf22-432d-88a6-332784c3e1c8`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-paper-goals-20260531-project`
**Output**: `AgentTasks/aristotle-output/standardmodel-z6-quotient-image-fiber-20260601-result`
**Extracted output**: `AgentTasks/aristotle-output/standardmodel-z6-quotient-image-fiber-20260601-extracted`
**Type**: quotient-image equivalence API polish for the paper

## Goal

Build the next small API layer on top of the quotient-image equivalence:
prove that every image-subtype fiber of
`standardModelCoveringQuotientEquivImage` is subsingleton, and expose a
plain uniqueness theorem for the quotient image map.

This is still deliberately set-theoretic. It should not claim a group
isomorphism, topological quotient, smooth quotient, or Lie-group theorem.

## Requested file

Create:

```text
PhysicsSM/Gauge/StandardModelZ6QuotientImageFiber.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelZ6QuotientImageEquiv
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Current context

Useful existing declarations:

- `standardModelCoveringQuotientImage`
- `standardModelCoveringQuotientImage_injective`
- `standardModelCoveringQuotientEquivImage`
- `standardModelCoveringQuotientEquivImage_apply`
- `standardModelCoveringQuotientEquivImage_symm_apply`
- `standardModelZ6QuotientImageEquivPackage`

## Target declarations

Prove injectivity and equality iff lemmas for the equivalence:

```lean
theorem standardModelCoveringQuotientEquivImage_injective :
    Function.Injective standardModelCoveringQuotientEquivImage := ...

theorem standardModelCoveringQuotientEquivImage_eq_iff
    (q1 q2 : StandardModelCoveringQuotient) :
    standardModelCoveringQuotientEquivImage q1 =
      standardModelCoveringQuotientEquivImage q2 <-> q1 = q2 := ...
```

Expose the corresponding statement for the underlying image map:

```lean
theorem standardModelCoveringQuotientImage_eq_iff
    (q1 q2 : StandardModelCoveringQuotient) :
    standardModelCoveringQuotientImage q1 =
      standardModelCoveringQuotientImage q2 <-> q1 = q2 := ...

theorem standardModelCoveringQuotientImage_fiber_unique
    {q1 q2 : StandardModelCoveringQuotient}
    (h : standardModelCoveringQuotientImage q1 =
      standardModelCoveringQuotientImage q2) :
    q1 = q2 := ...
```

Prove subtype fiber subsingletonness over the equivalence:

```lean
theorem standardModelCoveringQuotientEquivImage_fiber_subsingleton
    (y : Set.range CoveringTriple.image) :
    Subsingleton {q : StandardModelCoveringQuotient //
      standardModelCoveringQuotientEquivImage q = y} := ...
```

Package the result:

```lean
structure StandardModelZ6QuotientImageFiberPackage where
  equiv_injective : Function.Injective standardModelCoveringQuotientEquivImage
  image_fiber_unique :
    forall {q1 q2 : StandardModelCoveringQuotient},
      standardModelCoveringQuotientImage q1 =
        standardModelCoveringQuotientImage q2 -> q1 = q2
  equiv_fiber_subsingleton :
    forall y : Set.range CoveringTriple.image,
      Subsingleton {q : StandardModelCoveringQuotient //
        standardModelCoveringQuotientEquivImage q = y}

theorem standardModelZ6QuotientImageFiberPackage :
    StandardModelZ6QuotientImageFiberPackage := ...
```

## Claim boundary

This proves uniqueness/fiber API for the existing quotient-by-image-equality
scaffold. It does not prove a quotient-group theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not weaken the fiber theorem to a non-dependent informal statement.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelZ6QuotientImageFiber.lean
lake build PhysicsSM.Gauge.StandardModelZ6QuotientImageFiber
```

## Integration result

Integrated on 2026-06-01 from Aristotle job
`c8351305-cf22-432d-88a6-332784c3e1c8`.

Live file:

```text
PhysicsSM/Gauge/StandardModelZ6QuotientImageFiber.lean
```

Root import added to `PhysicsSM.lean`, and the package was added to the
publication theorem index as `GaugeIndex.z6_quotient_image_fiber`.

Verification run during integration:

```bash
lake env lean PhysicsSM/Gauge/StandardModelZ6QuotientImageFiber.lean
lake build PhysicsSM.Gauge.StandardModelZ6QuotientImageFiber
lake build PhysicsSM.Publication.FureyBaezDVTTheoremIndex
```
