# Aristotle task: Standard Model Z6 quotient scaffold

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `1a664aa0-b8f8-4d28-9773-7dbe01fe1f38`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-wave-20260531-project`
**Output**: `AgentTasks/aristotle-output/baez-sm-z6-quotient-scaffold-20260531-result`
**Extracted output**: `AgentTasks/aristotle-output/baez-sm-z6-quotient-scaffold-20260531-extracted`
**Type**: quotient-shaped scaffold below the full Lie-group theorem

## Integration

Integrated on 2026-05-31 from Aristotle job
`1a664aa0-b8f8-4d28-9773-7dbe01fe1f38`.

Live file:

```text
PhysicsSM/Gauge/StandardModelZ6QuotientScaffold.lean
```

Root import added to `PhysicsSM.lean`.

## Goal

Create the next trusted theorem layer after the finite `Z6` kernel package.

The goal is a quotient-shaped scaffold for the Standard Model covering map:
define an image-equivalence relation on covering triples, prove it is an
equivalence relation, prove the covering map factors through the quotient, and
record how kernel elements represent the identity fiber.

This is not the full quotient-group isomorphism theorem.

## Requested file

Create a trusted file:

```text
PhysicsSM/Gauge/StandardModelZ6QuotientScaffold.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelZ6KernelPackage
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Current context

Useful existing declarations include:

- `coveringMap`
- `CoveringKernelElt`
- `coveringMap_eq_one_iff_kernelElt`
- `coveringKernel_maps_to_one_auto`
- `standardModelCoveringKernel_maps_to_identity`
- `standardModelCoveringKernel_card`
- `standardModelZ6KernelPackage`

## Target declarations

Define a small raw triple structure for the covering-map domain:

```lean
structure CoveringTriple where
  phase : Complex
  su2Part : Matrix (Fin 2) (Fin 2) Complex
  su3Part : Matrix (Fin 3) (Fin 3) Complex
```

Define its covering-map image:

```lean
def CoveringTriple.image (x : CoveringTriple) :
    Matrix (Fin 2) (Fin 2) Complex × Matrix (Fin 3) (Fin 3) Complex :=
  coveringMap x.phase x.su2Part x.su3Part
```

Define image-equivalence:

```lean
def CoveringTriple.ImageEquivalent (x y : CoveringTriple) : Prop :=
  x.image = y.image
```

Prove:

```lean
theorem CoveringTriple.imageEquivalent_refl ...
theorem CoveringTriple.imageEquivalent_symm ...
theorem CoveringTriple.imageEquivalent_trans ...
```

Then build a `Setoid`:

```lean
instance CoveringTriple.imageSetoid : Setoid CoveringTriple := ...

abbrev StandardModelCoveringQuotient := Quot CoveringTriple.imageSetoid
```

Define the induced image map:

```lean
noncomputable def standardModelCoveringQuotientImage :
    StandardModelCoveringQuotient ->
      Matrix (Fin 2) (Fin 2) Complex × Matrix (Fin 3) (Fin 3) Complex := ...
```

Prove the quotient map agrees with representatives:

```lean
theorem standardModelCoveringQuotientImage_mk
    (x : CoveringTriple) :
    standardModelCoveringQuotientImage (Quot.mk _ x) = x.image := ...
```

Add kernel identity-fiber wrappers:

```lean
def CoveringTriple.ofKernelElt (k : CoveringKernelElt) : CoveringTriple := ...

def CoveringTriple.identity : CoveringTriple := ...

theorem kernelElt_imageEquivalent_identity
    (k : CoveringKernelElt) :
    CoveringTriple.ImageEquivalent (CoveringTriple.ofKernelElt k)
      CoveringTriple.identity := ...
```

If feasible, add a bundled structure:

```lean
structure StandardModelZ6QuotientScaffold where
  kernel_card : Fintype.card CoveringKernelElt = 6
  kernel_maps_to_identity :
    forall k : CoveringKernelElt,
      CoveringTriple.ImageEquivalent (CoveringTriple.ofKernelElt k)
        CoveringTriple.identity
```

and instantiate it.

## Claim boundary

This file should say explicitly in its module docstring that it is a quotient
scaffold by image equivalence, not a topological Lie-group quotient or a proof
that the quotient is isomorphic to `S(U(2) x U(3))`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not introduce fake quotient-group assumptions.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelZ6QuotientScaffold.lean
lake build PhysicsSM.Gauge.StandardModelZ6QuotientScaffold
```
