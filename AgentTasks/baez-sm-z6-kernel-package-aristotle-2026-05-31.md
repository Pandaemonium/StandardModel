# Aristotle task: Standard Model Z6 kernel theorem package

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `dccd7d6f-ff88-49fd-baa3-70f4171ed49c`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-family-z6-next-20260531-project`
**Output**: `AgentTasks/aristotle-output/baez-sm-z6-kernel-package-20260531-result`
**Extracted output**: `AgentTasks/aristotle-output/baez-sm-z6-kernel-package-20260531-extracted`
**Type**: Standard Model Z6 kernel theorem index

## Integration

Integrated on 2026-05-31 from Aristotle job
`dccd7d6f-ff88-49fd-baa3-70f4171ed49c`.

Live file:

```text
PhysicsSM/Gauge/StandardModelZ6KernelPackage.lean
```

Root import added to `PhysicsSM.lean`.

## Goal

Create a citation-friendly theorem package for the trusted finite `Z6` kernel
results already proved in the `StandardModelZ6*` modules.

This should be a small index/wrapper module: no quotient group theorem, no new
physics claims, just a clean landing page for the finite kernel theorem island.

## Requested file

Create a trusted file:

```text
PhysicsSM/Gauge/StandardModelZ6KernelPackage.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelZ6KernelMap
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Current context

Useful existing declarations include:

- `CoveringKernelElt`
- `kernelPhases`
- `sixCoveringKernelElts`
- `sixCoveringKernelElts_bijective`
- `fin6EquivCoveringKernelElt`
- `coveringKernelEltEquivFin6`
- `coveringKernelElt_card`
- `coveringKernel_maps_to_one_auto`
- `sixCoveringKernelElts_maps_to_one`
- `fin6EquivCoveringKernelElt_maps_to_one`
- `coveringKernelElt_inSU2U3_auto`

## Target declarations

Create named theorem wrappers such as:

```lean
theorem standardModelCoveringKernel_equiv_fin6 :
    Nonempty (CoveringKernelElt ≃ Fin 6) := ...

theorem standardModelCoveringKernel_card :
    Fintype.card CoveringKernelElt = 6 := ...

theorem standardModelCoveringKernel_maps_to_identity
    (k : CoveringKernelElt) :
    coveringMap k.phase k.su2Part k.su3Part = (1, 1) := ...

theorem standardModelCoveringKernel_in_SU2_U3
    (k : CoveringKernelElt) :
    InSU2U3 k.su2Part k.su3Part := ...

theorem standardModelSixKernelElts_maps_to_identity
    (i : Fin 6) :
    coveringMap
      (sixCoveringKernelElts i).phase
      (sixCoveringKernelElts i).su2Part
      (sixCoveringKernelElts i).su3Part = (1, 1) := ...
```

If useful, define a bundled structure:

```lean
structure StandardModelZ6KernelPackage where
  card_six : Fintype.card CoveringKernelElt = 6
  maps_to_identity :
    forall k : CoveringKernelElt,
      coveringMap k.phase k.su2Part k.su3Part = (1, 1)
```

and instantiate:

```lean
theorem standardModelZ6KernelPackage :
    StandardModelZ6KernelPackage := ...
```

Keep theorem names discoverable and source-facing.

## Claim boundary

This package identifies the finite kernel type with six elements and proves
that its elements map to identity under the project covering map. It does not
prove a quotient-group isomorphism
`(U(1) x SU(2) x SU(3)) / Z6 ~= S(U(2) x U(3))`.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Prefer wrappers over re-proving finite enumeration.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelZ6KernelPackage.lean
lake build PhysicsSM.Gauge.StandardModelZ6KernelPackage
```
