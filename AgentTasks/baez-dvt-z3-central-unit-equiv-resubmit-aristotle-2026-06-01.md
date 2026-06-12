# Aristotle task: DVT Z3 central-unit scalar equivalence resubmission

**Agent**: Aristotle
**Status**: Integrated
**Priority**: Medium
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `98ad2d2f-86ef-4640-93b6-2ac468e80974`
**Previous failed job**: `fffc0391-c3d2-491e-8b26-622d1550ee31`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave3-20260601-project`
**Output**: `AgentTasks/aristotle-output/dvt-z3-central-unit-equiv-resubmit-20260601`
**Integrated**: 2026-06-01
**Type**: DVT/Yokota central-kernel API polish

## Goal

The previous Aristotle job failed before producing an integrated result. Retry
the same modest API package: use the proved scalar/unit round-trip lemmas to
package an explicit type equivalence between bundled central units and bundled
central scalars.

## Requested file

Create:

```text
PhysicsSM/Algebra/Jordan/DVTZ3CentralUnitEquiv.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.DVTZ3CentralUnitConversions
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.DVTAction
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

Useful context:

- `DVTZ3CentralScalar`
- `DVTZ3CentralUnit`
- `DVTZ3CentralUnit.toScalar`
- `DVTZ3CentralScalar.toUnit`
- `DVTZ3CentralUnit.toScalar_toUnit`
- `DVTZ3CentralScalar.toUnit_toScalar`
- `DVTZ3CentralUnit.toScalar_mul_val`
- `DVTZ3CentralUnit.toScalar_inv_val`
- `dvtZ3CentralUnitConversionsPackage`

## Target declarations

Define the equivalence:

```lean
noncomputable def dvtZ3CentralUnitEquivScalar :
    Equiv DVTZ3CentralUnit DVTZ3CentralScalar := ...
```

Prove apply/symm lemmas:

```lean
theorem dvtZ3CentralUnitEquivScalar_apply
    (u : DVTZ3CentralUnit) :
    dvtZ3CentralUnitEquivScalar u = u.toScalar := ...

theorem dvtZ3CentralUnitEquivScalar_symm_apply
    (z : DVTZ3CentralScalar) :
    dvtZ3CentralUnitEquivScalar.symm z = z.toUnit := ...
```

Expose coercion compatibility through the equivalence:

```lean
theorem dvtZ3CentralUnitEquivScalar_mul_val
    (u v : DVTZ3CentralUnit) :
    ((dvtZ3CentralUnitEquivScalar (u * v) : Complex) =
      (dvtZ3CentralUnitEquivScalar u : Complex) *
        (dvtZ3CentralUnitEquivScalar v : Complex)) := ...

theorem dvtZ3CentralUnitEquivScalar_inv_val
    (u : DVTZ3CentralUnit) :
    ((dvtZ3CentralUnitEquivScalar (Inv.inv u) : Complex) =
      Inv.inv (dvtZ3CentralUnitEquivScalar u : Complex)) := ...
```

Package the result:

```lean
structure DVTZ3CentralUnitEquivPackage where
  unit_equiv_scalar : Equiv DVTZ3CentralUnit DVTZ3CentralScalar
  unit_equiv_scalar_apply :
    forall u : DVTZ3CentralUnit, unit_equiv_scalar u = u.toScalar
  unit_equiv_scalar_symm_apply :
    forall z : DVTZ3CentralScalar, unit_equiv_scalar.symm z = z.toUnit
  unit_equiv_scalar_mul_val :
    forall u v : DVTZ3CentralUnit,
      ((unit_equiv_scalar (u * v) : Complex) =
        (unit_equiv_scalar u : Complex) *
          (unit_equiv_scalar v : Complex))

theorem dvtZ3CentralUnitEquivPackage :
    DVTZ3CentralUnitEquivPackage := ...
```

## Claim boundary

This is only an equivalence between two bundled representations of the same
central-unit data. It does not prove a cardinality-three theorem, a cyclic
group isomorphism, quotient faithfulness, or the full DVT stabilizer theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Keep the claim boundary explicit.
- Do not introduce a `ZMod 3` or `Fin 3` equivalence unless it already follows
  directly from existing trusted declarations.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTZ3CentralUnitEquiv.lean
lake build PhysicsSM.Algebra.Jordan.DVTZ3CentralUnitEquiv
```
