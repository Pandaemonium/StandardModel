# Aristotle task: Standard Model Z6 kernel equivalence package

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `fcaceee1-d950-4499-bedf-f588ef1b1063`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-raft-20260530-project`
**Output**: `AgentTasks/aristotle-output/baez-sm-z6-kernel-equivalence-20260530`
**Extracted output**: `AgentTasks/aristotle-output/baez-sm-z6-kernel-equivalence-20260530-extracted`
**Integrated file**: `PhysicsSM/Gauge/StandardModelZ6KernelEquiv.lean`
**Type**: finite kernel equivalence and cardinality wrapper

## Goal

Package the now-proved bijection

```text
sixCoveringKernelElts : Fin 6 -> CoveringKernelElt
```

as an explicit equivalence and finite-cardinality theorem. This gives us a
clean reusable kernel object for later quotient language without claiming a
topological group quotient theorem.

## Current context

Use:

```text
PhysicsSM.Gauge.StandardModelZ6FiniteKernel
```

Important declarations include:

- `CoveringKernelElt`
- `sixCoveringKernelElts`
- `sixCoveringKernelElts_injective`
- `sixCoveringKernelElts_surjective`
- `sixCoveringKernelElts_bijective`
- `kernelPhases`
- `kernelPhases_eq_omega_pow`
- `coveringMap_eq_one_iff_kernelElt`

## Requested file

Create a trusted file:

```text
PhysicsSM/Gauge/StandardModelZ6KernelEquiv.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelZ6FiniteKernel
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Build an explicit equivalence from `Fin 6` to the kernel elements:

```lean
noncomputable def fin6EquivCoveringKernelElt :
    Fin 6 ~= CoveringKernelElt := ...
```

Prove the forward apply theorem:

```lean
theorem fin6EquivCoveringKernelElt_apply (k : Fin 6) :
    fin6EquivCoveringKernelElt k = sixCoveringKernelElts k := ...
```

Then build the inverse orientation:

```lean
noncomputable def coveringKernelEltEquivFin6 :
    CoveringKernelElt ~= Fin 6 :=
  fin6EquivCoveringKernelElt.symm
```

Add a `Fintype` instance and cardinality theorem:

```lean
noncomputable instance : Fintype CoveringKernelElt := ...

theorem coveringKernelElt_card :
    Fintype.card CoveringKernelElt = 6 := ...
```

Useful optional wrappers:

```lean
theorem coveringKernelElt_eq_sixCoveringKernelElts
    (k : CoveringKernelElt) :
    sixCoveringKernelElts (coveringKernelEltEquivFin6 k) = k := ...

theorem coveringKernelElt_phase_eq_kernelPhase
    (k : CoveringKernelElt) :
    kernelPhases (coveringKernelEltEquivFin6 k) = k.phase := ...
```

## Claim boundary

This is finite set/equivalence packaging only. Do not claim a quotient group,
Lie group, or first-isomorphism theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change the `kernelPhases` convention or the covering exponents.
- Keep the equivalence orientation documented.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelZ6KernelEquiv.lean
lake build PhysicsSM.Gauge.StandardModelZ6KernelEquiv
lake build PhysicsSM
```

## Integration result

Integrated on 2026-05-30.

Aristotle produced a trusted theorem package containing:

- `fin6EquivCoveringKernelElt`
- `fin6EquivCoveringKernelElt_apply`
- `coveringKernelEltEquivFin6`
- a `Fintype CoveringKernelElt` instance
- `coveringKernelElt_card`
- `coveringKernelElt_eq_sixCoveringKernelElts`
- `coveringKernelElt_phase_eq_kernelPhase`
