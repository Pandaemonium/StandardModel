# Aristotle task: DVT Z3 central unit group-like API

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium-High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `300dff9a-af39-4406-830a-7ff1cf17ef4d`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-next-wave-20260531-project`
**Type**: DVT/Yokota central-kernel strengthening

## Goal

Strengthen the bundled cube-root central-scalar API by moving to nonzero
complex units. This should make the DVT central kernel look more like the
group-theoretic `Z3` that appears in the literature, while staying below the
full quotient-group theorem.

## Requested file

Create:

```text
PhysicsSM/Algebra/Jordan/DVTZ3CentralUnit.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.DVTZ3CentralKernel
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.DVTAction
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Target declarations

Define a bundled unit version:

```lean
abbrev DVTZ3CentralUnit := { u : Complexˣ // ((u : Complex) ^ 3 = 1) }
```

Add conversions:

```lean
noncomputable def DVTZ3CentralUnit.toScalar
    (u : DVTZ3CentralUnit) : DVTZ3CentralScalar := ...

noncomputable def DVTZ3CentralScalar.toUnit
    (z : DVTZ3CentralScalar) : DVTZ3CentralUnit := ...
```

If feasible, add `One`, `Mul`, and `Inv` instances, and a `Group` instance for
`DVTZ3CentralUnit`. If the full `Group` instance is unexpectedly brittle, stop
at explicit `one`, `mul`, and `inv` definitions with closure theorems.

Prove action triviality through the unit bundle:

```lean
theorem DVTZ3CentralUnit.action_eq_id
    (u : DVTZ3CentralUnit) :
    DVTZ3CentralScalar.action u.toScalar =
      AddMonoidHom.id H3OComplement := ...

theorem DVTZ3CentralUnit.action_apply
    (u : DVTZ3CentralUnit) (w : H3OComplement) :
    DVTZ3CentralScalar.action u.toScalar w = w := ...
```

Package the result:

```lean
structure DVTZ3CentralUnitPackage where
  action_trivial :
    forall u : DVTZ3CentralUnit,
      DVTZ3CentralScalar.action u.toScalar =
        AddMonoidHom.id H3OComplement

theorem dvtZ3CentralUnitPackage :
    DVTZ3CentralUnitPackage := ...
```

## Claim boundary

This is still only the central-kernel API for the current DVT complement
scaffold. It does not prove the full `(SU(3) x SU(3)) / Z3` action theorem,
faithfulness, compact group quotients, or the DVT stabilizer theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not introduce a fake quotient or new assumptions.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTZ3CentralUnit.lean
lake build PhysicsSM.Algebra.Jordan.DVTZ3CentralUnit
```

## Integration result

**Completed**: 2026-05-31
**Result bundle**: `AgentTasks/aristotle-output/baez-dvt-z3-central-unit-20260531-result`
**Extracted project**: `AgentTasks/aristotle-output/baez-dvt-z3-central-unit-20260531-extracted/octonion-sm-next-wave-20260531-project_aristotle`
**Integrated file**: `PhysicsSM/Algebra/Jordan/DVTZ3CentralUnit.lean`
**Root import**: `PhysicsSM.Algebra.Jordan.DVTZ3CentralUnit`

Aristotle strengthened the DVT cube-root central-kernel API by adding a
nonzero unit bundle with `One`, `Mul`, `Inv`, and `Group` structure, plus the
same trivial-action package on the current complement scaffold.

Verification run during integration:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTZ3CentralUnit.lean
lake build PhysicsSM.Algebra.Jordan.DVTZ3CentralUnit
```
