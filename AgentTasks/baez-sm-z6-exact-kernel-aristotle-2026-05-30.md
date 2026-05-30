# Aristotle task: exact Z6 kernel for the SM covering map

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `11e2d903-cc36-4961-8de6-64650f43a30d`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-big-targets-20260530-min-project`
**Output**: `AgentTasks/aristotle-output/baez-sm-z6-exact-kernel-20260530`
**Type**: Standard Model group quotient scaffold

## Integration result

Integrated 2026-05-30 into:

```text
PhysicsSM/Gauge/StandardModelZ6Kernel.lean
```

The merged module proves the exact algebraic kernel reconstruction for the
concrete covering map, including the forward reconstruction of the `SU(2)` and
`SU(3)` components, the determinant-forces-sixth-root theorem, and the iff with
`CoveringKernelElt`.

The optional finite-enumeration stretch proof from the Aristotle output was not
merged into trusted code. The exact iff is the intended milestone for this
round, while the six-element list and injectivity theorem remain available from
`StandardModelBlockHom`.

## Goal

Strengthen the current Standard Model block-group scaffold by proving the
exact kernel theorem for the covering map into `S(U(2) x U(3))`.

The current project has determinant/block arithmetic and kernel examples. This
job should prove the converse: if a triple maps to the identity and the `SU(2)`
and `SU(3)` determinant constraints hold, then the phase is a sixth root of
unity and the matrix components are the expected central scalar matrices.

## Current context

Use:

```text
PhysicsSM.Gauge.BlockEmbeddings
PhysicsSM.Gauge.StandardModelSubgroup
PhysicsSM.Gauge.StandardModelGroup
PhysicsSM.Gauge.StandardModelBlockHom
```

Important declarations include:

- `StandardModelSubgroup.coveringMap`
- `StandardModelSubgroup.CoveringKernelElt`
- `CoveringKernelElt.su2Part`
- `CoveringKernelElt.su3Part`
- `coveringKernel_maps_to_one`
- `coveringKernelElt_su2_det`
- `coveringKernelElt_su3_det`
- `sixCoveringKernelElts`
- `sixCoveringKernelElts_injective`
- `kernelPhases`
- `kernelPhases_pow_six`

## Requested file

Create a trusted file:

```text
PhysicsSM/Gauge/StandardModelZ6Kernel.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelBlockHom
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Prove raw kernel reconstruction:

```lean
theorem coveringMap_eq_one_implies_su2Part
    {alpha : Complex} (halpha : alpha != 0)
    {g : Matrix (Fin 2) (Fin 2) Complex}
    {h : Matrix (Fin 3) (Fin 3) Complex}
    (hk : coveringMap alpha g h = (1, 1)) :
    g = (alpha^-1 ^ 3) *? 1 := ...
```

Use the actual scalar notation that fits the existing `coveringMap` definition:
`(alpha^-1 ^ 3) • 1`, `alpha ^ 2 • 1`, etc.

Also prove:

```lean
theorem coveringMap_eq_one_implies_su3Part ...
theorem coveringMap_eq_one_implies_phase_pow_six
    (hg : g.det = 1) (hh : h.det = 1) :
    alpha ^ 6 = 1 := ...
```

Then bundle the exact statement:

```lean
theorem coveringMap_eq_one_iff_kernelElt
    {alpha : Complex} (halpha : alpha != 0)
    {g : Matrix (Fin 2) (Fin 2) Complex}
    {h : Matrix (Fin 3) (Fin 3) Complex}
    (hg : g.det = 1) (hh : h.det = 1) :
    coveringMap alpha g h = (1, 1) <->
      exists k : CoveringKernelElt,
        k.phase = alpha /\
        g = k.su2Part /\
        h = k.su3Part := ...
```

If this exact iff is awkward, deliver the two implications as named theorems
with a clear comment about the remaining quotient packaging.

## Stretch target

Define a finite subtype of kernel triples indexed by `Fin 6` and prove the map
from `Fin 6` into the kernel is injective and surjective under the determinant
constraints.

Do not attempt the full first isomorphism theorem unless the supporting API is
already straightforward.

## Claim boundary

Do not claim a topological Lie group quotient theorem. The desired theorem is
the algebraic kernel identification for the concrete matrix covering map.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change the existing phase/exponent conventions.
- Preserve the project hypercharge convention `Q = T3 + Y / 2`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelZ6Kernel.lean
lake build PhysicsSM.Gauge.StandardModelZ6Kernel
lake build PhysicsSM
```
