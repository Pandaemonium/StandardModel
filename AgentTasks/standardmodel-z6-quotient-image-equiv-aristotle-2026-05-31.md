# Aristotle task: Standard Model Z6 quotient-image equivalence

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `e90b1534-754a-4bae-a776-f0da4301be6a`
**Retry submitted**: 2026-05-31
**Retry job ID**: `6916d730-efbb-4523-8dc7-d9086eded39e`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-paper-goals-20260531-project`
**Output**: `AgentTasks/aristotle-output/standardmodel-z6-quotient-image-equiv-20260531-result`
**Extracted output**: `AgentTasks/aristotle-output/standardmodel-z6-quotient-image-equiv-20260531-extracted`
**Type**: quotient-scaffold equivalence below the Lie-group theorem

## Goal

Upgrade the current image-quotient scaffold from injectivity/range lemmas to an
actual type equivalence between the quotient-by-image-equivalence type and the
image subtype of the covering map.

This is a paper-facing strengthening of the Z6 quotient story, but it remains
strictly set-theoretic. It must not claim a topological quotient, Lie-group
quotient, or first-isomorphism theorem.

## Requested file

Create:

```text
PhysicsSM/Gauge/StandardModelZ6QuotientImageEquiv.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelZ6IdentityFiber
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
- `standardModelCoveringQuotientImage_range`
- `standardModelCoveringQuotientImage_surjective_onto_image`
- `kernelElt_quotient_eq_identity`
- `quotient_eq_identity_iff_image_eq_identity`
- `kernelElt_quotientImage_eq_identityImage`

## Target declarations

Define the equivalence:

```lean
noncomputable def standardModelCoveringQuotientEquivImage :
    Equiv StandardModelCoveringQuotient (Set.range CoveringTriple.image) := ...
```

Prove coercion/apply lemmas:

```lean
theorem standardModelCoveringQuotientEquivImage_apply
    (q : StandardModelCoveringQuotient) :
    (standardModelCoveringQuotientEquivImage q).val =
      standardModelCoveringQuotientImage q := ...

theorem standardModelCoveringQuotientEquivImage_symm_apply
    (y : Set.range CoveringTriple.image) :
    standardModelCoveringQuotientImage
      (standardModelCoveringQuotientEquivImage.symm y) = y.val := ...
```

Then package the result:

```lean
structure StandardModelZ6QuotientImageEquivPackage where
  quotient_equiv_image :
    Equiv StandardModelCoveringQuotient (Set.range CoveringTriple.image)
  apply_image :
    forall q : StandardModelCoveringQuotient,
      (quotient_equiv_image q).val = standardModelCoveringQuotientImage q
  symm_image :
    forall y : Set.range CoveringTriple.image,
      standardModelCoveringQuotientImage (quotient_equiv_image.symm y) = y.val

theorem standardModelZ6QuotientImageEquivPackage :
    StandardModelZ6QuotientImageEquivPackage := ...
```

## Claim boundary

This proves a canonical equivalence between a quotient type and an image
subtype for the current quotient-by-image-equality scaffold. It does not prove
a group isomorphism, topological quotient, smooth quotient, or Lie-group
theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not weaken the equivalence to only another range theorem.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelZ6QuotientImageEquiv.lean
lake build PhysicsSM.Gauge.StandardModelZ6QuotientImageEquiv
```

## Retry note

The initial job `e90b1534-754a-4bae-a776-f0da4301be6a` failed with an
Aristotle internal-error message and produced no usable result bundle. It was
resubmitted unchanged as job `6916d730-efbb-4523-8dc7-d9086eded39e`.

## Integration result

Integrated on 2026-05-31 from retry job
`6916d730-efbb-4523-8dc7-d9086eded39e`.

Live file:

```text
PhysicsSM/Gauge/StandardModelZ6QuotientImageEquiv.lean
```

Root import added to `PhysicsSM.lean`, and the package was added to the
publication theorem index as `GaugeIndex.z6_quotient_image_equiv`.

Verification run during integration:

```bash
lake env lean PhysicsSM/Gauge/StandardModelZ6QuotientImageEquiv.lean
lake build PhysicsSM.Gauge.StandardModelZ6QuotientImageEquiv
lake env lean PhysicsSM/Publication/FureyBaezDVTTheoremIndex.lean
```
