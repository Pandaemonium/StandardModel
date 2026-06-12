# Aristotle task: true Standard Model product covering triple

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Paper-critical
**Prepared**: 2026-06-02
**Submitted**: 2026-06-02
**Job ID**: `f7b377da-468b-4c85-b060-a6eefeb00d78`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave5-20260602`
**Output**:
**Integrated**:
**Type**: Standard Model covering-domain correction

## Goal

Create the actual algebraic covering domain for

```text
U(1) x SU(2) x SU(3) -> S(U(2) x U(3)).
```

The current `UnitCoveringTriple` is too broad: it uses arbitrary units in the
matrix rings, not unitary determinant-one matrices. The recently integrated
`StandardModelCoveringMapSurjective` proves surjectivity for `SMCoveringTriple`,
but `SMCoveringTriple` is also not the true product-covering domain: it allows
the two matrix blocks to have determinant product one rather than determinant
one separately.

This job should define the correct restricted domain and prove its basic group
and covering-map facts.

## Requested file

Create:

```text
PhysicsSM/Gauge/StandardModelProductCoveringTriple.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Gauge.StandardModelCoveringMapSurjective
import PhysicsSM.Gauge.StandardModelUnitZ6Kernel
```

Use namespace:

```lean
namespace PhysicsSM.Gauge.StandardModelSubgroup
```

Do not edit `PhysicsSM.lean`.

## Target declarations

Define a determinant-one unitary matrix package:

```lean
structure SUUnitMatrix (n : Type*) [Fintype n] [DecidableEq n] where
  unit : Units (Matrix n n Complex)
  unitary : IsUnitary unit.val
  det_one : unit.val.det = 1
```

Give it componentwise group structure if possible.

Define the true product-covering domain:

```lean
structure SMProductCoveringTriple where
  phase : Units Complex
  phase_norm_one : norm (phase : Complex) = 1
  su2Part : SUUnitMatrix (Fin 2)
  su3Part : SUUnitMatrix (Fin 3)
```

Prove extensionality, one, multiplication, inverse, and if possible:

```lean
noncomputable instance SMProductCoveringTriple.instGroup :
    Group SMProductCoveringTriple := ...
```

Construct the forgetful inclusion into the already existing
`SMCoveringTriple`:

```lean
noncomputable def SMProductCoveringTriple.toSMCoveringTriple
    (x : SMProductCoveringTriple) : SMCoveringTriple := ...
```

Prove the covering image satisfies `SMBlockPredicate`:

```lean
theorem SMProductCoveringTriple.image_satisfiesSMBlock
    (x : SMProductCoveringTriple) :
    SMBlockPredicate
      (fromBlocks x.toSMCoveringTriple.image.1.val 0 0
        x.toSMCoveringTriple.image.2.val) := ...
```

Define the image as a group hom into `Units GUTMatrix` or into
`SMBlockUnitsSubgroup`, whichever is easiest:

```lean
noncomputable def smProductCoveringTripleToSMBlockUnits :
    SMProductCoveringTriple ->* SMBlockUnitsSubgroup := ...
```

## Kernel target

Prove that the six unit-level kernel elements from `StandardModelUnitZ6Kernel`
belong to this restricted product domain and map to identity.

If possible, prove the converse identity-fiber theorem:

```lean
theorem smProductCoveringTriple_identityFiber_z6
    (x : SMProductCoveringTriple)
    (hx : smProductCoveringTripleToSMBlockUnits x = 1) :
    exists k : UnitCoveringKernelElt,
      x.phase = k.phase /\
      x.toSMCoveringTriple.toUnitCoveringTriple =
        k.toUnitCoveringTriple := ...
```

Adjust the exact statement if equality of the restricted structures is easier.

## Fallback

If the full group structure is too large, prioritize a trusted prefix:

- `SUUnitMatrix`;
- closure under one, multiplication, and inverse;
- `SMProductCoveringTriple`;
- inclusion into `SMCoveringTriple`;
- map into `SMBlockPredicate`;
- explicit six kernel elements.

Draft `sorry` is allowed only in:

```text
PhysicsSM/Draft/StandardModelProductCoveringTripleHandoff.lean
```

No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe` in trusted files.

## Claim boundary

This is still algebraic. It does not prove a topological quotient, smooth Lie
group theorem, compactness, or gauge-field dynamics.

## Verification

Run:

```bash
lake build PhysicsSM.Gauge.StandardModelProductCoveringTriple
```
