# Aristotle task: DVT Z3 central scalar finite cardinality

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `b99cc428-4c91-4237-ae38-6b73b6490771`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave5-20260601-project`
**Output**: `AgentTasks/aristotle-output/dvt-z3-central-scalar-finite-20260601`
**Integrated**: 2026-06-01
**Type**: DVT/Yokota central-kernel finite group API

## Goal

Prove that the DVT central cube-root scalar group really has three elements.
The current trusted development has:

- `DVTZ3CentralScalar := { z : Complex // z ^ 3 = 1 }`
- `DVTZ3CentralUnit`, the bundled nonzero complex cube roots viewed as units
- an equivalence between these two bundled views,
- a `Group DVTZ3CentralScalar` instance.

This task should connect the bundled type to Mathlib's `rootsOfUnity 3 Complex`
and derive `Fintype.card DVTZ3CentralScalar = 3`.

## Requested file

Create:

```text
PhysicsSM/Algebra/Jordan/DVTZ3CentralScalarFinite.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.DVTZ3CentralScalarGroup
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.DVTAction
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

- `DVTZ3CentralScalar`
- `DVTZ3CentralScalar.ne_zero`
- `DVTZ3CentralUnit`
- `DVTZ3CentralUnit.toScalar`
- `DVTZ3CentralScalar.toUnit`
- `dvtZ3CentralUnitEquivScalar`
- `DVTZ3CentralScalar.instGroup`
- Mathlib `rootsOfUnity 3 Complex`
- Mathlib `Complex.card_rootsOfUnity`

## Target declarations

Define an explicit equivalence between the bundled central units and Mathlib's
third roots of unity:

```lean
noncomputable def dvtZ3CentralUnitEquivRootsOfUnity :
    Equiv DVTZ3CentralUnit (rootsOfUnity 3 Complex) := ...
```

Use that equivalence to provide finite instances:

```lean
noncomputable instance DVTZ3CentralUnit.instFintype :
    Fintype DVTZ3CentralUnit := ...

noncomputable instance DVTZ3CentralScalar.instFintype :
    Fintype DVTZ3CentralScalar := ...
```

Prove the cardinality results:

```lean
theorem dvtZ3CentralUnit_card :
    Fintype.card DVTZ3CentralUnit = 3 := ...

theorem dvtZ3CentralScalar_card :
    Fintype.card DVTZ3CentralScalar = 3 := ...
```

Add a bundled package:

```lean
structure DVTZ3CentralScalarFinitePackage where
  scalar_fintype : Fintype DVTZ3CentralScalar
  unit_fintype : Fintype DVTZ3CentralUnit
  scalar_card_three : Fintype.card DVTZ3CentralScalar = 3
  unit_card_three : Fintype.card DVTZ3CentralUnit = 3

noncomputable def dvtZ3CentralScalarFinitePackage :
    DVTZ3CentralScalarFinitePackage := ...
```

Optional stretch goal, only if it is straightforward: add a multiplicative
equivalence with `rootsOfUnity 3 Complex` or a cyclicity theorem for the scalar
group. Do not leave an unfinished stretch goal in trusted code.

## Claim boundary

This proves finite cardinality for the current central-kernel scaffold. It does
not prove the full DVT stabilizer theorem, a compact Lie group quotient, or the
faithfulness of a noncentral DVT action.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not redefine `DVTZ3CentralScalar` or `DVTZ3CentralUnit`.
- Do not change existing group instances.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTZ3CentralScalarFinite.lean
lake build PhysicsSM.Algebra.Jordan.DVTZ3CentralScalarFinite
```
