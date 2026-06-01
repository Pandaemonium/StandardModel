# Aristotle task: Standard Model Z6 image quotient theorem

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `7cd2b7c8-ab9a-49c5-af6d-0f4f90d931ff`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-wave-20260531-project`
**Type**: quotient-scaffold strengthening below the Lie-group theorem

## Goal

Strengthen the existing image-equivalence quotient scaffold by proving that the
induced image map from the quotient is injective and has range exactly the
image of the covering map.

This is a real theorem about the current quotient-by-image-equivalence
construction. It is still not a topological quotient-group isomorphism.

## Requested file

Create:

```text
PhysicsSM/Gauge/StandardModelZ6ImageQuotient.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelZ6QuotientScaffold
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Target declarations

Prove:

```lean
theorem standardModelCoveringQuotientImage_injective :
    Function.Injective standardModelCoveringQuotientImage := ...
```

Useful proof idea:

- Use quotient induction on two quotient representatives.
- The hypothesis becomes equality of `CoveringTriple.image`.
- The equivalence relation is exactly image equality.
- Use `Quotient.sound`.

Also prove a range/surjectivity-to-image theorem:

```lean
theorem standardModelCoveringQuotientImage_range :
    Set.range standardModelCoveringQuotientImage =
      Set.range CoveringTriple.image := ...
```

or, if the exact extensional equality is awkward:

```lean
theorem standardModelCoveringQuotientImage_surjective_onto_image
    (y : Matrix (Fin 2) (Fin 2) Complex ×
        Matrix (Fin 3) (Fin 3) Complex)
    (hy : y ∈ Set.range CoveringTriple.image) :
    ∃ q : StandardModelCoveringQuotient,
      standardModelCoveringQuotientImage q = y := ...
```

Finally package them:

```lean
structure StandardModelZ6ImageQuotientPackage where
  image_injective : Function.Injective standardModelCoveringQuotientImage
  image_range :
    Set.range standardModelCoveringQuotientImage =
      Set.range CoveringTriple.image

theorem standardModelZ6ImageQuotientPackage :
    StandardModelZ6ImageQuotientPackage := ...
```

If the range equality is harder than expected, use the one-direction
surjectivity theorem and adjust the structure accordingly. Do not use `sorry`.

## Claim boundary

This proves facts about the image-equivalence quotient type already defined in
`StandardModelZ6QuotientScaffold`. It does not prove a group quotient,
topological quotient, Lie group isomorphism, or first isomorphism theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not weaken `standardModelCoveringQuotientImage_injective`.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelZ6ImageQuotient.lean
lake build PhysicsSM.Gauge.StandardModelZ6ImageQuotient
```

## Integration result

**Completed**: 2026-05-31
**Result bundle**: `AgentTasks/aristotle-output/standardmodel-z6-image-quotient-20260531-result`
**Extracted project**: `AgentTasks/aristotle-output/standardmodel-z6-image-quotient-20260531-extracted/octonion-sm-next-wave-20260531-project_aristotle`
**Integrated file**: `PhysicsSM/Gauge/StandardModelZ6ImageQuotient.lean`
**Root import**: `PhysicsSM.Gauge.StandardModelZ6ImageQuotient`

Aristotle proved the requested injectivity and image-range package for the
image-equivalence quotient scaffold. The imported theorem package remains
below the Lie-group quotient boundary: it is about the current quotient type
by image equality, not a topological or Lie-group first-isomorphism theorem.

Verification run during integration:

```bash
lake env lean PhysicsSM/Gauge/StandardModelZ6ImageQuotient.lean
lake build PhysicsSM.Gauge.StandardModelZ6ImageQuotient
```
