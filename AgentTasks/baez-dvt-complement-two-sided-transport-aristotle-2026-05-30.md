# Aristotle task: DVT complement two-sided transported action

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-05-30
**Submitted**: 2026-05-30
**Job ID**: `9e2b85ec-07c5-4670-83ac-9191466ea159`
**Retry job ID**: `fc05afe3-861b-46a1-afc9-929e3569adc2`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-raft-20260530-project`
**Output**: `AgentTasks/aristotle-output/baez-dvt-complement-two-sided-transport-20260530`
**Downloaded output**: `AgentTasks/aristotle-output/fc05afe3-20260531-result`
**Extracted output**: `AgentTasks/aristotle-output/fc05afe3-20260531-extracted`
**Type**: DVT/Yokota complement action bridge

## Job history

- `9e2b85ec-07c5-4670-83ac-9191466ea159` failed with an Aristotle internal
  error before producing an artifact.
- `fc05afe3-861b-46a1-afc9-929e3569adc2` was resubmitted on 2026-05-30 after
  refreshing the submission project from the live tree.

## Goal

Transport the trusted two-sided matrix action on
`H3O.complementAddSubgroup` back to the older DVT complement scaffold
`DVTAction.H3OComplement`.

This should make the DVT scaffold usable with the newer coordinate action
API without duplicating the matrix calculations.

## Current context

Use:

```text
PhysicsSM.Algebra.Jordan.DVTComplementBridge
PhysicsSM.Algebra.Jordan.H3OComplementTwoSidedAction
```

Important declarations include:

- `H3OComplement`
- `h3oComplementAddEquivComplementSubgroup`
- `h3oComplementEquivM3C`
- `h3oComplementEquivM3C_apply`
- `H3O.complementMatrixTwoSidedAction`
- `H3O.complementLinearEquivM3C_twoSidedAction`
- `H3O.complementMatrixTwoSidedAction_one_one`
- `H3O.complementMatrixTwoSidedAction_mul`
- `H3O.complementMatrixTwoSidedAction_scalar_cancel`

## Requested file

Create a trusted file:

```text
PhysicsSM/Algebra/Jordan/DVTComplementTwoSidedAction.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.DVTComplementBridge
import PhysicsSM.Algebra.Jordan.H3OComplementTwoSidedAction
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.DVTAction
```

If the file is sorry-free, add it to `PhysicsSM.lean`.

## Target declarations

Define the transported two-sided action on the DVT complement scaffold:

```lean
noncomputable def h3oComplementTwoSidedAction
    (A B : Matrix (Fin 3) (Fin 3) Complex) :
    H3OComplement ->+ H3OComplement := ...
```

The intended implementation is:

```text
h3oComplementAddEquivComplementSubgroup.symm
  (H3O.complementMatrixTwoSidedAction A B
    (h3oComplementAddEquivComplementSubgroup w))
```

Prove the coordinate equation:

```lean
theorem h3oComplementEquivM3C_twoSidedAction
    (A B : Matrix (Fin 3) (Fin 3) Complex)
    (w : H3OComplement) :
    h3oComplementEquivM3C (h3oComplementTwoSidedAction A B w) =
      A * h3oComplementEquivM3C w * B := ...
```

Prove the identity and composition laws:

```lean
theorem h3oComplementTwoSidedAction_one_one :
    h3oComplementTwoSidedAction 1 1 = AddMonoidHom.id H3OComplement := ...

theorem h3oComplementTwoSidedAction_mul
    (A1 A2 B1 B2 : Matrix (Fin 3) (Fin 3) Complex) :
    h3oComplementTwoSidedAction (A1 * A2) (B2 * B1) =
      (h3oComplementTwoSidedAction A1 B1).comp
        (h3oComplementTwoSidedAction A2 B2) := ...
```

Then prove the DVT-scaffold version of central scalar cancellation:

```lean
theorem h3oComplementTwoSidedAction_scalar_cancel
    {z : Complex} (hz : z != 0) :
    h3oComplementTwoSidedAction
      (z • (1 : Matrix (Fin 3) (Fin 3) Complex))
      (z⁻¹ • (1 : Matrix (Fin 3) (Fin 3) Complex)) =
    AddMonoidHom.id H3OComplement := ...

theorem h3oComplementTwoSidedAction_scalar_cancel_apply
    {z : Complex} (hz : z != 0) (w : H3OComplement) :
    h3oComplementTwoSidedAction
      (z • (1 : Matrix (Fin 3) (Fin 3) Complex))
      (z⁻¹ • (1 : Matrix (Fin 3) (Fin 3) Complex)) w = w := ...
```

Use the actual Lean spelling for inequality (`≠`) in the final code.

## Claim boundary

This is only a transported additive action on the DVT complement scaffold.
Do not claim unitarity, determinant one, quotient by `Z3`, the DVT stabilizer
theorem, or Jordan-product preservation.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Preserve the row convention from `H3OComplexMatrix`: rows are `x`, `y`, `z`.
- Do not alter existing bridge definitions unless a tiny simp theorem is
  needed for the transported proof.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTComplementTwoSidedAction.lean
lake build PhysicsSM.Algebra.Jordan.DVTComplementTwoSidedAction
lake build PhysicsSM
```

## Integration notes

- Integrated on 2026-05-31.
- Added trusted file `PhysicsSM/Algebra/Jordan/DVTComplementTwoSidedAction.lean`.
- Added `PhysicsSM.Algebra.Jordan.DVTComplementTwoSidedAction` to
  `PhysicsSM.lean`.
- Aristotle returned a sorry-free theorem package. The live `PhysicsSM.lean`
  import list was patched manually instead of copying Aristotle's stale root
  import file over newer local imports.
