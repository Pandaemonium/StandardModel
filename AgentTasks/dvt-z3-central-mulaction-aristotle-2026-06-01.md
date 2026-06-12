# Aristotle task: DVT Z3 central scalars as a trivial MulAction

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `3748ca8e-c844-4963-94b1-60aa42d6f16f`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave7-20260601-project`
**Output**: `AgentTasks/aristotle-output/dvt-z3-central-mulaction-20260601`
**Integrated**: 2026-06-01
**Type**: DVT/Yokota central-kernel action API

## Goal

Promote the already proved trivial central scalar action on `H3OComplement`
from a monoid hom into additive endomorphisms to an explicit `MulAction`.
Then prove every orbit is a singleton.

This gives the paper a clean Lean formulation of "the central Z3 acts
trivially" without claiming the full DVT stabilizer theorem.

## Requested file

Create:

```text
PhysicsSM/Algebra/Jordan/DVTZ3CentralMulAction.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.DVTZ3CentralRootsMulEquiv
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.DVTAction
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

- `DVTZ3CentralScalar`
- `DVTZ3CentralUnit`
- group instances for both
- `DVTZ3CentralScalar.action`
- `DVTZ3CentralScalar.action_eq_id`
- `DVTZ3CentralScalar.action_apply`
- `dvtZ3CentralScalarActionMonoidHom`
- `dvtZ3CentralUnitActionMonoidHom`
- `dvtZ3CentralUnitMulEquivScalar`

## Target declarations

Define the scalar action as scalar multiplication:

```lean
noncomputable instance DVTZ3CentralScalar.instSMulH3OComplement :
    SMul DVTZ3CentralScalar H3OComplement := ...

noncomputable instance DVTZ3CentralScalar.instMulActionH3OComplement :
    MulAction DVTZ3CentralScalar H3OComplement := ...
```

Add simp/triviality lemmas:

```lean
@[simp] theorem dvtZ3CentralScalar_smul_eq
    (z : DVTZ3CentralScalar) (w : H3OComplement) :
    z • w = DVTZ3CentralScalar.action z w := ...

@[simp] theorem dvtZ3CentralScalar_smul_eq_self
    (z : DVTZ3CentralScalar) (w : H3OComplement) :
    z • w = w := ...
```

If convenient, add the unit-facing version:

```lean
noncomputable instance DVTZ3CentralUnit.instSMulH3OComplement :
    SMul DVTZ3CentralUnit H3OComplement := ...

noncomputable instance DVTZ3CentralUnit.instMulActionH3OComplement :
    MulAction DVTZ3CentralUnit H3OComplement := ...

@[simp] theorem dvtZ3CentralUnit_smul_eq_self
    (u : DVTZ3CentralUnit) (w : H3OComplement) :
    u • w = w := ...
```

Prove orbit statements:

```lean
theorem dvtZ3CentralScalar_orbit_eq_singleton
    (w : H3OComplement) :
    MulAction.orbit DVTZ3CentralScalar w = {w} := ...

theorem dvtZ3CentralUnit_orbit_eq_singleton
    (w : H3OComplement) :
    MulAction.orbit DVTZ3CentralUnit w = {w} := ...
```

If `MulAction.orbit` has a slightly different namespace in Lean 4.28, use the
available mathlib orbit notation/theorem and keep the theorem names.

Add a package:

```lean
structure DVTZ3CentralMulActionPackage where
  scalar_action : MulAction DVTZ3CentralScalar H3OComplement
  scalar_smul_trivial :
    forall z : DVTZ3CentralScalar, forall w : H3OComplement, z • w = w
  scalar_orbit_singleton :
    forall w : H3OComplement,
      MulAction.orbit DVTZ3CentralScalar w = {w}

noncomputable def dvtZ3CentralMulActionPackage :
    DVTZ3CentralMulActionPackage := ...
```

If bundling typeclass instances directly causes elaboration trouble, replace
the `scalar_action` field with the two named laws.

## Claim boundary

This only packages the central cube-root subgroup as a trivial action on the
current DVT complement scaffold. It does not prove the full
`(SU(3) x SU(3)) / Z3` DVT action theorem, faithfulness off the central
subgroup, or the DVT stabilizer theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not redefine `DVTZ3CentralScalar.action`.
- Do not change existing group or cyclicity instances.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTZ3CentralMulAction.lean
lake build PhysicsSM.Algebra.Jordan.DVTZ3CentralMulAction
```
