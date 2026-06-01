# Aristotle task: DVT Z3 central-unit conversion API

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium-High
**Prepared**: 2026-05-31
**Submitted**: 2026-05-31
**Job ID**: `49e49ea3-e9ef-42eb-8def-506374e88d29`
**Submission project**: `AgentTasks/aristotle-submit/octonion-sm-paper-goals-20260531-project`
**Output**: `AgentTasks/aristotle-output/baez-dvt-z3-central-unit-conversions-20260531-result`
**Extracted output**: `AgentTasks/aristotle-output/baez-dvt-z3-central-unit-conversions-20260531-extracted`
**Type**: DVT/Yokota central-kernel API polish

## Goal

Polish the DVT central-unit API by proving that the scalar/unit conversions
are inverse and that the group operations are compatible with the forgotten
complex scalar values.

This is small but important for paper readability: it lets us talk about the
bundled cube-root central units without repeatedly unpacking subtype fields.

## Requested file

Create:

```text
PhysicsSM/Algebra/Jordan/DVTZ3CentralUnitConversions.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.DVTZ3CentralUnit
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.DVTAction
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Current context

Useful existing declarations:

- `DVTZ3CentralScalar`
- `DVTZ3CentralScalar.ne_zero`
- `DVTZ3CentralScalar.action`
- `DVTZ3CentralScalar.action_eq_id`
- `DVTZ3CentralScalar.action_apply`
- `DVTZ3CentralUnit`
- `DVTZ3CentralUnit.toScalar`
- `DVTZ3CentralScalar.toUnit`
- `DVTZ3CentralUnit.instGroup`
- `DVTZ3CentralUnit.action_eq_id`
- `DVTZ3CentralUnit.action_apply`

## Target declarations

Prove the conversion inverse laws:

```lean
theorem DVTZ3CentralUnit.toScalar_toUnit
    (u : DVTZ3CentralUnit) :
    u.toScalar.toUnit = u := ...

theorem DVTZ3CentralScalar.toUnit_toScalar
    (z : DVTZ3CentralScalar) :
    z.toUnit.toScalar = z := ...
```

Prove coercion-level compatibility with group operations:

```lean
theorem DVTZ3CentralUnit.toScalar_one_val :
    (((1 : DVTZ3CentralUnit).toScalar : Complex) = 1) := ...

theorem DVTZ3CentralUnit.toScalar_mul_val
    (u v : DVTZ3CentralUnit) :
    (((u * v).toScalar : Complex) =
      (u.toScalar : Complex) * (v.toScalar : Complex)) := ...

theorem DVTZ3CentralUnit.toScalar_inv_val
    (u : DVTZ3CentralUnit) :
    (((Inv.inv u).toScalar : Complex) =
      Inv.inv (u.toScalar : Complex)) := ...
```

Also prove action triviality for products and inverses:

```lean
theorem DVTZ3CentralUnit.action_mul_eq_id
    (u v : DVTZ3CentralUnit) :
    DVTZ3CentralScalar.action ((u * v).toScalar) =
      AddMonoidHom.id H3OComplement := ...

theorem DVTZ3CentralUnit.action_inv_eq_id
    (u : DVTZ3CentralUnit) :
    DVTZ3CentralScalar.action ((Inv.inv u).toScalar) =
      AddMonoidHom.id H3OComplement := ...
```

Package the result:

```lean
structure DVTZ3CentralUnitConversionsPackage where
  unit_to_scalar_to_unit :
    forall u : DVTZ3CentralUnit, u.toScalar.toUnit = u
  scalar_to_unit_to_scalar :
    forall z : DVTZ3CentralScalar, z.toUnit.toScalar = z
  action_mul_trivial :
    forall u v : DVTZ3CentralUnit,
      DVTZ3CentralScalar.action ((u * v).toScalar) =
        AddMonoidHom.id H3OComplement

theorem dvtZ3CentralUnitConversionsPackage :
    DVTZ3CentralUnitConversionsPackage := ...
```

## Claim boundary

This is only API polish for the central-kernel scaffold. It does not prove
faithfulness, quotient-group structure, or the full DVT stabilizer theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Prefer coercion-level statements if subtype equality becomes brittle.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTZ3CentralUnitConversions.lean
lake build PhysicsSM.Algebra.Jordan.DVTZ3CentralUnitConversions
```

## Integration result

Integrated on 2026-05-31 from Aristotle job
`49e49ea3-e9ef-42eb-8def-506374e88d29`.

Live file:

```text
PhysicsSM/Algebra/Jordan/DVTZ3CentralUnitConversions.lean
```

Root import added to `PhysicsSM.lean`, and the package was added to the
publication theorem index as `JordanAlgebraIndex.dvt_z3_unit_conversions`.

Verification run during integration:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTZ3CentralUnitConversions.lean
lake build PhysicsSM.Algebra.Jordan.DVTZ3CentralUnitConversions
```
