# Aristotle task: clean finite Z6 kernel bijection

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `92547a54-5c9a-4be0-8e38-a11319d7ec60`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-wave-20260530-project`
**Output**: `AgentTasks/aristotle-output/baez-sm-z6-finite-kernel-bijection-20260530-result`
**Extracted output**: `AgentTasks/aristotle-output/baez-sm-z6-finite-kernel-bijection-20260530-extracted`
**Type**: Standard Model covering kernel finite enumeration

## Goal

Build a clean trusted wrapper around the algebraic exact-kernel theorem:

```text
kernel(coveringMap) is exactly the six elements indexed by Fin 6.
```

The previous Aristotle result proved the exact iff with `CoveringKernelElt`.
Its optional finite-enumeration stretch proof was not merged because the proof
script was too noisy for trusted source. This job should produce a cleaner
module.

## Current context

Use:

```text
PhysicsSM.Gauge.BlockEmbeddings
PhysicsSM.Gauge.StandardModelSubgroup
PhysicsSM.Gauge.StandardModelBlockHom
PhysicsSM.Gauge.StandardModelZ6Kernel
```

Important declarations include:

- `kernelPhases : Fin 6 -> Complex`
- `kernelPhases_pow_six`
- `kernelPhases_ne_zero`
- `kernelPhases_injective`
- `omega_isPrimitiveRoot`
- `z6_kernel_card`
- `CoveringKernelElt`
- `sixCoveringKernelElts`
- `sixCoveringKernelElts_injective`
- `coveringMap_eq_one_iff_kernelElt`

## Requested file

Create a trusted file:

```text
PhysicsSM/Gauge/StandardModelZ6FiniteKernel.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelZ6Kernel
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Prove that the explicit six kernel phases are exhaustive among sixth roots:

```lean
theorem kernelPhases_surj_of_pow_six
    {alpha : Complex} (halpha : alpha ^ 6 = 1) :
    exists k : Fin 6, kernelPhases k = alpha := ...
```

Then prove the six covering kernel elements are surjective and bijective:

```lean
theorem sixCoveringKernelElts_surjective :
    Function.Surjective sixCoveringKernelElts := ...

theorem sixCoveringKernelElts_bijective :
    Function.Bijective sixCoveringKernelElts := ...
```

If direct phase-surjectivity is hard, an acceptable alternate route is to build
an equivalence between `CoveringKernelElt` and `{alpha : Complex // alpha ^ 6 =
1}`, then use `z6_kernel_card` plus `sixCoveringKernelElts_injective` to prove
surjectivity by cardinality. Prefer the route with the shortest, most readable
trusted proof.

## Claim boundary

This is finite algebraic kernel enumeration only. Do not claim a topological
Lie group quotient theorem or first-isomorphism theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change existing phase/exponent conventions.
- Do not reintroduce a large fragile polynomial proof if a mathlib
  `IsPrimitiveRoot` or finite-cardinality proof is available.

## Verification

Run:

```bash
lake env lean PhysicsSM/Gauge/StandardModelZ6FiniteKernel.lean
lake build PhysicsSM.Gauge.StandardModelZ6FiniteKernel
lake build PhysicsSM
```

## Integration result

Integrated on 2026-05-30.

Added trusted module:

```text
PhysicsSM/Gauge/StandardModelZ6FiniteKernel.lean
```

Main declarations:

- `kernelPhases_eq_omega_pow`
- `kernelPhases_surj_of_pow_six`
- `sixCoveringKernelElts_surjective`
- `sixCoveringKernelElts_bijective`

The proof uses `omega_isPrimitiveRoot.eq_pow_of_pow_eq_one` rather than a
fragile explicit polynomial factorization. The module was added to
`PhysicsSM.lean`.
