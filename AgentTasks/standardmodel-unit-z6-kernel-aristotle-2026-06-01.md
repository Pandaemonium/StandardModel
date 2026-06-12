# Aristotle task: unit-level Standard Model Z6 kernel

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Paper-critical
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `c0e508c7-b2aa-49d3-b145-0c309eaa8186`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave9-20260601-project`
**Output**:
**Integrated**:
**Type**: Standard Model algebraic Z6 kernel

## Goal

Upgrade the unit-level Standard Model covering scaffold with an explicit
six-element kernel for `unitCoveringTripleImageGroupHom`.

The repo already has:

- raw finite kernel results in `StandardModelZ6KernelPackage`;
- unit covering triples in `StandardModelUnitCoveringTriple`;
- quotient-by-image group scaffold in `StandardModelUnitZ6QuotientGroup`.

This task should construct unit-level versions of the six kernel elements and
prove they map to the identity under the unit image homomorphism.

## Requested file

Create:

```text
PhysicsSM/Gauge/StandardModelUnitZ6Kernel.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelUnitZ6QuotientGroup
import PhysicsSM.Gauge.StandardModelZ6KernelPackage
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`; Codex will add imports during integration.

## Target declarations

Define the unit-level kernel element type. A good concrete starting point is:

```lean
structure UnitCoveringKernelElt where
  phase : Units Complex
  phase_pow_six : (phase : Complex) ^ 6 = 1
```

Then define the corresponding covering triple:

```lean
noncomputable def UnitCoveringKernelElt.toUnitCoveringTriple
    (k : UnitCoveringKernelElt) : UnitCoveringTriple := ...
```

The intended triple is:

```text
(alpha, alpha^-3 * I_2, alpha^2 * I_3)
```

where the matrix entries are represented using `matrixScalarUnit`.

Prove:

```lean
theorem UnitCoveringKernelElt.image_eq_one
    (k : UnitCoveringKernelElt) :
    unitCoveringTripleImageGroupHom k.toUnitCoveringTriple = 1 := ...
```

Define the six explicit kernel elements indexed by `Fin 6`, using existing
`kernelPhases` if convenient:

```lean
noncomputable def sixUnitCoveringKernelElts : Fin 6 -> UnitCoveringKernelElt := ...
```

Prove:

```lean
theorem sixUnitCoveringKernelElts_image_eq_one (i : Fin 6) :
    unitCoveringTripleImageGroupHom
      (sixUnitCoveringKernelElts i).toUnitCoveringTriple = 1 := ...
```

If feasible, prove injectivity:

```lean
theorem sixUnitCoveringKernelElts_injective :
    Function.Injective sixUnitCoveringKernelElts := ...
```

If full injectivity is hard because of unit extensionality, prove the image
theorem first and include a package.

## Package

Add:

```lean
structure StandardModelUnitZ6KernelPackage where
  kernel_family : Fin 6 -> UnitCoveringKernelElt
  kernel_maps_to_one :
    forall i : Fin 6,
      unitCoveringTripleImageGroupHom
        ((kernel_family i).toUnitCoveringTriple) = 1
  kernel_injective :
    Function.Injective kernel_family

noncomputable def standardModelUnitZ6KernelPackage :
    StandardModelUnitZ6KernelPackage := ...
```

If `kernel_injective` is not feasible, omit that field and document the
remaining gap in the module docstring.

## Claim boundary

This proves explicit unit-level kernel elements and their identity image. It
does not prove topological quotient structure, smooth Lie group structure, or
that the kernel is exactly these six elements unless Aristotle manages the
injectivity/surjectivity refinements cleanly.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted output.
- Do not change the existing covering map convention.
- Do not edit `PhysicsSM.lean`.
- Preserve the project's hypercharge/phase normalization.

## Verification

Run:

```bash
lake build PhysicsSM.Gauge.StandardModelUnitZ6Kernel
```
