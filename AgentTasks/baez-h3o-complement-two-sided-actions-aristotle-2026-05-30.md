# Aristotle task: H3O complement two-sided matrix actions

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `29b1529d-dbb1-4ed4-a984-6db840b37db0`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-raft-20260530-project`
**Output**: `AgentTasks/aristotle-output/baez-h3o-complement-two-sided-actions-20260530`
**Downloaded output**: `AgentTasks/aristotle-output/baez-h3o-complement-two-sided-actions-20260530-result`
**Extracted output**: `AgentTasks/aristotle-output/baez-h3o-complement-two-sided-actions-20260530-extracted`
**Integrated file**: `PhysicsSM/Algebra/Jordan/H3OComplementTwoSidedAction.lean`
**Type**: DVT/Yokota two-sided complement action and central scalar precursor

## Goal

Build the next layer on top of
`PhysicsSM.Algebra.Jordan.H3OComplementMatrixAction`: a two-sided matrix action
on the complement of `h3(C)` in `h3(O)`.

In coordinates, the action should be:

```text
X |-> A * X * B
```

where `X : Matrix (Fin 3) (Fin 3) Complex` is the coordinate matrix of a
complement element.

This is the algebraic skeleton behind the DVT/Yokota
`SU(3) x SU(3)` complement action. The central-scalar cancellation theorem is
a first formal precursor to the eventual quotient by `Z3`.

## Current context

Use:

```text
PhysicsSM.Algebra.Jordan.H3OComplementMatrixAction
```

Important declarations include:

- `complementMatrixLeftAction`
- `complementMatrixRightAction`
- `complementLinearEquivM3C_leftAction`
- `complementLinearEquivM3C_rightAction`
- `complementMatrixLeftAction_one`
- `complementMatrixRightAction_one`
- `complementMatrixLeftAction_mul`
- `complementMatrixRightAction_mul`
- `complementMatrixLeftRight_commute`

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Jordan/H3OComplementTwoSidedAction.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.H3OComplementMatrixAction
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.H3O
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Define the two-sided action:

```lean
noncomputable def complementMatrixTwoSidedAction
    (A B : Matrix (Fin 3) (Fin 3) Complex) :
    complementAddSubgroup ->l[Complex] complementAddSubgroup := ...
```

Suggested implementation:

```text
left action by A composed with right action by B
```

Prove the coordinate equation:

```lean
theorem complementLinearEquivM3C_twoSidedAction
    (A B : Matrix (Fin 3) (Fin 3) Complex)
    (x : complementAddSubgroup) :
    complementLinearEquivM3C
      (complementMatrixTwoSidedAction A B x) =
      A * complementLinearEquivM3C x * B := ...
```

Prove identity and composition laws:

```lean
theorem complementMatrixTwoSidedAction_one_one :
    complementMatrixTwoSidedAction 1 1 = LinearMap.id := ...

theorem complementMatrixTwoSidedAction_mul
    (A1 A2 B1 B2 : Matrix (Fin 3) (Fin 3) Complex) :
    complementMatrixTwoSidedAction (A1 * A2) (B2 * B1) =
      (complementMatrixTwoSidedAction A1 B1).comp
        (complementMatrixTwoSidedAction A2 B2) := ...
```

Then prove scalar cancellation. Any clean equivalent statement is acceptable.
One useful version:

```lean
theorem complementMatrixTwoSidedAction_scalar_cancel
    {z : Complex} (hz : z != 0) :
    complementMatrixTwoSidedAction
      (z • (1 : Matrix (Fin 3) (Fin 3) Complex))
      (z⁻¹ • (1 : Matrix (Fin 3) (Fin 3) Complex)) =
    LinearMap.id := ...
```

Optional stretch:

```lean
theorem complementMatrixTwoSidedAction_scalar_cancel_apply
    {z : Complex} (hz : z != 0) (x : complementAddSubgroup) :
    complementMatrixTwoSidedAction
      (z • (1 : Matrix (Fin 3) (Fin 3) Complex))
      (z⁻¹ • (1 : Matrix (Fin 3) (Fin 3) Complex)) x = x := ...
```

Use the actual Lean spelling for inequality (`≠`) in the final code.

## Claim boundary

Do not claim the full DVT stabilizer theorem, group quotient, unitarity, or
Jordan-product preservation. This file is only the two-sided linear action
and the central scalar cancellation calculation.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Preserve the row convention from `H3OComplexMatrix`: rows are `x`, `y`, `z`.
- Be explicit about left-vs-right composition order.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/H3OComplementTwoSidedAction.lean
lake build PhysicsSM.Algebra.Jordan.H3OComplementTwoSidedAction
lake build PhysicsSM
```

## Integration result

Integrated on 2026-05-30.

Aristotle produced a trusted theorem package containing:

- `complementMatrixTwoSidedAction`
- `complementLinearEquivM3C_twoSidedAction`
- `complementMatrixTwoSidedAction_one_one`
- `complementMatrixTwoSidedAction_mul`
- `complementMatrixTwoSidedAction_scalar_cancel`
- `complementMatrixTwoSidedAction_scalar_cancel_apply`
