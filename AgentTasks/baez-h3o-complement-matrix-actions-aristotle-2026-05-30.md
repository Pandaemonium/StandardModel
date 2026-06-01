# Aristotle task: H3O complement matrix actions

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `72d6bacb-6da5-4c26-8c38-a6358071c7bb`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-raft-20260530-project`
**Output**: `AgentTasks/aristotle-output/baez-h3o-complement-matrix-actions-20260530`
**Extracted output**: `AgentTasks/aristotle-output/baez-h3o-complement-matrix-actions-20260530-extracted`
**Integrated file**: `PhysicsSM/Algebra/Jordan/H3OComplementMatrixAction.lean`
**Type**: DVT/Yokota complement matrix-action scaffold

## Goal

Use the new complex-linear equivalence

```text
complementLinearEquivM3C :
  complementAddSubgroup ~=l[Complex] Matrix (Fin 3) (Fin 3) Complex
```

to transport ordinary left and right matrix multiplication on `M3(C)` back to
the H3O complement. This is the clean algebraic scaffold for the DVT/Yokota
`SU(3) x SU(3)` action on the complement.

## Current context

Use:

```text
PhysicsSM.Algebra.Jordan.H3OComplexMatrixLinear
```

Important declarations include:

- `complementAddSubgroup`
- `complementLinearEquivM3C`
- `complementToM3C`
- `m3CToComplement`
- `m3CToComplement_inComplementOfB`

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Jordan/H3OComplementMatrixAction.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.H3OComplexMatrixLinear
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.H3O
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Define left matrix multiplication transported to the complement:

```lean
noncomputable def complementMatrixLeftAction
    (A : Matrix (Fin 3) (Fin 3) Complex) :
    complementAddSubgroup ->l[Complex] complementAddSubgroup := ...
```

Prove the coordinate equation:

```lean
theorem complementLinearEquivM3C_leftAction
    (A : Matrix (Fin 3) (Fin 3) Complex)
    (x : complementAddSubgroup) :
    complementLinearEquivM3C (complementMatrixLeftAction A x) =
      A * complementLinearEquivM3C x := ...
```

Define right matrix multiplication transported to the complement:

```lean
noncomputable def complementMatrixRightAction
    (B : Matrix (Fin 3) (Fin 3) Complex) :
    complementAddSubgroup ->l[Complex] complementAddSubgroup := ...
```

Prove the coordinate equation:

```lean
theorem complementLinearEquivM3C_rightAction
    (B : Matrix (Fin 3) (Fin 3) Complex)
    (x : complementAddSubgroup) :
    complementLinearEquivM3C (complementMatrixRightAction B x) =
      complementLinearEquivM3C x * B := ...
```

Then prove identity, composition, and commutation laws. Suggested names:

```lean
theorem complementMatrixLeftAction_one :
    complementMatrixLeftAction 1 = LinearMap.id := ...

theorem complementMatrixRightAction_one :
    complementMatrixRightAction 1 = LinearMap.id := ...

theorem complementMatrixLeftAction_mul
    (A B : Matrix (Fin 3) (Fin 3) Complex) :
    complementMatrixLeftAction (A * B) =
      (complementMatrixLeftAction A).comp (complementMatrixLeftAction B) := ...

theorem complementMatrixRightAction_mul
    (A B : Matrix (Fin 3) (Fin 3) Complex) :
    complementMatrixRightAction (A * B) =
      (complementMatrixRightAction B).comp (complementMatrixRightAction A) := ...

theorem complementMatrixLeftRight_commute
    (A B : Matrix (Fin 3) (Fin 3) Complex)
    (x : complementAddSubgroup) :
    complementMatrixLeftAction A (complementMatrixRightAction B x) =
      complementMatrixRightAction B (complementMatrixLeftAction A x) := ...
```

If the exact `LinearMap.id` notation is awkward, use the locally typechecking
equivalent statement.

## Claim boundary

This is only the linear action scaffold on the complement. Do not claim
unitarity, determinant one, quotient by `Z3`, or Jordan-product preservation.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Preserve the existing row convention: complement rows are `x`, `y`, `z`.
- Be explicit about left-vs-right composition order.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/H3OComplementMatrixAction.lean
lake build PhysicsSM.Algebra.Jordan.H3OComplementMatrixAction
lake build PhysicsSM
```

## Integration result

Integrated on 2026-05-30.

Aristotle produced a trusted theorem package containing:

- `complementMatrixLeftAction`
- `complementMatrixRightAction`
- `complementLinearEquivM3C_leftAction`
- `complementLinearEquivM3C_rightAction`
- `complementMatrixLeftAction_one`
- `complementMatrixRightAction_one`
- `complementMatrixLeftAction_mul`
- `complementMatrixRightAction_mul`
- `complementMatrixLeftRight_commute`
