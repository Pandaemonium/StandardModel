# Aristotle task: DVT Z3 central scalar action monoid hom

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `e5c4ceb9-5b74-4aac-8c28-1ae545c32581`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave5-20260601-project`
**Output**: `AgentTasks/aristotle-output/dvt-z3-central-action-hom-20260601`
**Integrated**: 2026-06-01
**Type**: DVT/Yokota central-kernel action API

## Goal

Bundle the already-proved trivial central action of cube-root scalars on the
DVT complement as a monoid homomorphism into additive endomorphisms.

The mathematical content is intentionally modest but useful for the paper:
the central `Z3` subgroup acts trivially, and this trivial action is compatible
with the group law.

## Requested file

Create:

```text
PhysicsSM/Algebra/Jordan/DVTZ3CentralActionHom.lean
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
- `DVTZ3CentralScalar.instGroup`
- `DVTZ3CentralScalar.action : DVTZ3CentralScalar -> H3OComplement ->+ H3OComplement`
- `DVTZ3CentralScalar.action_eq_id`
- `DVTZ3CentralScalar.action_apply`
- `DVTZ3CentralUnit`
- `DVTZ3CentralUnit.toScalar`

## Target declarations

Define the action homomorphism:

```lean
noncomputable def dvtZ3CentralScalarActionMonoidHom :
    DVTZ3CentralScalar ->* AddMonoid.End H3OComplement := ...
```

Prove useful application and triviality lemmas:

```lean
@[simp] theorem dvtZ3CentralScalarActionMonoidHom_apply
    (z : DVTZ3CentralScalar) :
    dvtZ3CentralScalarActionMonoidHom z = DVTZ3CentralScalar.action z := ...

theorem dvtZ3CentralScalarActionMonoidHom_eq_id
    (z : DVTZ3CentralScalar) :
    dvtZ3CentralScalarActionMonoidHom z =
      AddMonoidHom.id H3OComplement := ...

theorem dvtZ3CentralScalarActionMonoidHom_apply_point
    (z : DVTZ3CentralScalar) (w : H3OComplement) :
    dvtZ3CentralScalarActionMonoidHom z w = w := ...
```

If convenient, also add a unit-facing version:

```lean
noncomputable def dvtZ3CentralUnitActionMonoidHom :
    DVTZ3CentralUnit ->* AddMonoid.End H3OComplement := ...
```

Add a bundled package:

```lean
structure DVTZ3CentralActionHomPackage where
  scalar_action_hom :
    DVTZ3CentralScalar ->* AddMonoid.End H3OComplement
  scalar_action_trivial :
    forall z : DVTZ3CentralScalar,
      scalar_action_hom z = AddMonoidHom.id H3OComplement

noncomputable def dvtZ3CentralActionHomPackage :
    DVTZ3CentralActionHomPackage := ...
```

## Claim boundary

This only packages the trivial action of the central cube-root subgroup on the
current DVT complement scaffold. It does not prove the full `(SU(3) x SU(3)) /
Z3` DVT action theorem or the DVT stabilizer theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change the definition of `DVTZ3CentralScalar.action`.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTZ3CentralActionHom.lean
lake build PhysicsSM.Algebra.Jordan.DVTZ3CentralActionHom
```
