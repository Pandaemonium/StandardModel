# Aristotle task: Standard Model Z6 kernel map wrappers

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `05dc95fa-d65a-4b65-abcd-f6c32d8f07b5`
**Retry job ID**: `e2a8dfb8-e799-48a0-a56a-125dacc098f2`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-raft-20260530-project`
**Output**: `AgentTasks/aristotle-output/baez-sm-z6-kernel-map-wrapper-20260530`
**Retry output**: `AgentTasks/aristotle-output/baez-sm-z6-kernel-map-wrapper-20260530-retry`
**Downloaded retry output**: `AgentTasks/aristotle-output/baez-sm-z6-kernel-map-wrapper-20260530-retry-result`
**Extracted retry output**: `AgentTasks/aristotle-output/baez-sm-z6-kernel-map-wrapper-20260530-retry-extracted`
**Integrated file**: `PhysicsSM/Gauge/StandardModelZ6KernelMap.lean`
**Type**: finite Z6 kernel wrapper cleanup

## Job history

- `05dc95fa-d65a-4b65-abcd-f6c32d8f07b5` failed with an Aristotle internal
  error before producing an artifact.
- `e2a8dfb8-e799-48a0-a56a-125dacc098f2` resubmitted on 2026-05-30 after
  refreshing the submission project from the live tree.

## Goal

Remove the remaining manual nonzero hypothesis from the existing theorem
`coveringKernel_maps_to_one`.

Every `CoveringKernelElt` has phase satisfying `phase ^ 6 = 1`, so its phase
is automatically nonzero. This task packages that fact and gives simpler
wrappers for the covering-map kernel theorem.

## Current context

Use:

```text
PhysicsSM.Gauge.StandardModelZ6KernelEquiv
```

Important declarations include:

- `CoveringKernelElt`
- `CoveringKernelElt.phase`
- `CoveringKernelElt.phase_pow_six`
- `CoveringKernelElt.su2Part`
- `CoveringKernelElt.su3Part`
- `coveringMap`
- `coveringKernel_maps_to_one`
- `sixCoveringKernelElts`
- `fin6EquivCoveringKernelElt`

## Requested file

Create a trusted file:

```text
PhysicsSM/Gauge/StandardModelZ6KernelMap.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelZ6KernelEquiv
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Prove automatic nonzero phase:

```lean
theorem CoveringKernelElt.phase_ne_zero (k : CoveringKernelElt) :
    k.phase != 0 := ...
```

Use the actual Lean spelling for inequality (`≠`) in the final code.

Then prove the hypothesis-free covering map theorem:

```lean
theorem coveringKernel_maps_to_one_auto (k : CoveringKernelElt) :
    coveringMap k.phase k.su2Part k.su3Part = (1, 1) := ...
```

Useful wrappers for the six-element enumeration:

```lean
theorem sixCoveringKernelElts_maps_to_one (i : Fin 6) :
    coveringMap
      (sixCoveringKernelElts i).phase
      (sixCoveringKernelElts i).su2Part
      (sixCoveringKernelElts i).su3Part = (1, 1) := ...

theorem fin6EquivCoveringKernelElt_maps_to_one (i : Fin 6) :
    coveringMap
      (fin6EquivCoveringKernelElt i).phase
      (fin6EquivCoveringKernelElt i).su2Part
      (fin6EquivCoveringKernelElt i).su3Part = (1, 1) := ...
```

Optional stretch, only if short:

```lean
theorem coveringKernelElt_inSU2U3_auto (k : CoveringKernelElt) :
    InSU2U3 k.su2Part k.su3Part := ...
```

This may already be available as `coveringKernelElt_inSU2U3`; if so, add only
a naming wrapper if it improves discoverability.

## Claim boundary

This is still only the algebraic finite-kernel package. Do not claim a
quotient group, Lie group, or first-isomorphism theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change the `kernelPhases` convention or covering exponents.
- Keep theorem names discoverable under `StandardModelZ6Kernel...`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelZ6KernelMap.lean
lake build PhysicsSM.Gauge.StandardModelZ6KernelMap
lake build PhysicsSM
```

## Integration result

Integrated on 2026-05-30.

Aristotle produced a trusted theorem package containing:

- `CoveringKernelElt.phase_ne_zero`
- `coveringKernel_maps_to_one_auto`
- `sixCoveringKernelElts_maps_to_one`
- `fin6EquivCoveringKernelElt_maps_to_one`
- `coveringKernelElt_inSU2U3_auto`
