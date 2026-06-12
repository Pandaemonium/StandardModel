# Aristotle task: DVT Z3 central scalar group and multiplicative equivalence

**Agent**: Aristotle
**Status**: Integrated
**Priority**: High
**Prepared**: 2026-06-01
**Submitted**: 2026-06-01
**Job ID**: `4beb36ce-1410-4e9c-82c6-1e1e5f37a337`
**Submission project**: `AgentTasks/aristotle-submit/paper-wave4-20260601-project`
**Output**: `AgentTasks/aristotle-output/dvt-z3-central-scalar-group-20260601`
**Integrated**: 2026-06-01
**Type**: DVT/Yokota central-kernel group API

## Goal

Complete the algebraic API around the DVT central `Z3` scaffold by giving
`DVTZ3CentralScalar` the same group structure already available on
`DVTZ3CentralUnit`, and by proving that
`dvtZ3CentralUnitEquivScalar` is multiplicative.

This keeps the DVT central-kernel story clean: bundled cube-root scalars and
bundled nonzero cube-root units are not merely equivalent as types, but carry
the same group law.

## Requested file

Create:

```text
PhysicsSM/Algebra/Jordan/DVTZ3CentralScalarGroup.lean
```

Suggested imports:

```lean
import Mathlib
import PhysicsSM.Algebra.Jordan.DVTZ3CentralUnitEquiv
```

Use namespace:

```lean
namespace PhysicsSM.Algebra.Jordan.DVTAction
```

Do not edit `PhysicsSM.lean`; Codex will add root imports during integration.

## Existing declarations

- `DVTZ3CentralScalar := { z : Complex // z ^ 3 = 1 }`
- `DVTZ3CentralScalar.ne_zero`
- `DVTZ3CentralScalar.mul`
- `DVTZ3CentralScalar.action_eq_id`
- `DVTZ3CentralUnit`
- `DVTZ3CentralUnit.instGroup`
- `DVTZ3CentralUnit.toScalar`
- `DVTZ3CentralScalar.toUnit`
- `dvtZ3CentralUnitEquivScalar`
- `dvtZ3CentralUnitEquivScalar_apply`
- `dvtZ3CentralUnitEquivScalar_symm_apply`
- `dvtZ3CentralUnitEquivScalar_mul_val`
- `dvtZ3CentralUnitEquivScalar_inv_val`

## Target declarations

Define the scalar group structure:

```lean
instance : One DVTZ3CentralScalar := ...
instance : Mul DVTZ3CentralScalar := ...
instance : Inv DVTZ3CentralScalar := ...
instance DVTZ3CentralScalar.instGroup : Group DVTZ3CentralScalar := ...
```

Add coercion lemmas:

```lean
@[simp] theorem DVTZ3CentralScalar.coe_one :
    ((1 : DVTZ3CentralScalar) : Complex) = 1 := ...

theorem DVTZ3CentralScalar.coe_mul
    (z w : DVTZ3CentralScalar) :
    ((z * w : DVTZ3CentralScalar) : Complex) =
      (z : Complex) * (w : Complex) := ...

theorem DVTZ3CentralScalar.coe_inv
    (z : DVTZ3CentralScalar) :
    ((z^-1 : DVTZ3CentralScalar) : Complex) = ((z : Complex)^-1) := ...
```

Prove multiplicativity of the equivalence at the subtype level:

```lean
theorem dvtZ3CentralUnitEquivScalar_one :
    dvtZ3CentralUnitEquivScalar (1 : DVTZ3CentralUnit) =
      (1 : DVTZ3CentralScalar) := ...

theorem dvtZ3CentralUnitEquivScalar_mul
    (u v : DVTZ3CentralUnit) :
    dvtZ3CentralUnitEquivScalar (u * v) =
      dvtZ3CentralUnitEquivScalar u *
        dvtZ3CentralUnitEquivScalar v := ...

theorem dvtZ3CentralUnitEquivScalar_inv
    (u : DVTZ3CentralUnit) :
    dvtZ3CentralUnitEquivScalar (u^-1) =
      (dvtZ3CentralUnitEquivScalar u)^-1 := ...
```

Package the equivalence as a monoid hom:

```lean
noncomputable def dvtZ3CentralUnitToScalarMonoidHom :
    DVTZ3CentralUnit ->* DVTZ3CentralScalar := ...
```

Add a bundled result:

```lean
structure DVTZ3CentralScalarGroupPackage where
  scalar_group : Group DVTZ3CentralScalar
  unit_to_scalar_hom : DVTZ3CentralUnit ->* DVTZ3CentralScalar
  unit_to_scalar_hom_injective :
    Function.Injective unit_to_scalar_hom

noncomputable def dvtZ3CentralScalarGroupPackage :
    DVTZ3CentralScalarGroupPackage := ...
```

If the package field for the `Group` instance is awkward, replace it with the
named group laws rather than weakening the mathematical result.

## Claim boundary

This proves the algebraic group structure on the cube-root central scalar
subtype and the multiplicative compatibility of the existing equivalence. It
does not prove that the group has cardinality three, is cyclic, or completes
the full DVT stabilizer theorem.

## Constraints

- No `sorry`, `admit`, `axiom`, `opaque`, or `unsafe`.
- Do not change the definition of `DVTZ3CentralScalar`.
- Do not change the definition of `DVTZ3CentralUnit`.
- Do not edit `PhysicsSM.lean`.

## Verification

Run:

```bash
lake env lean PhysicsSM/Algebra/Jordan/DVTZ3CentralScalarGroup.lean
lake build PhysicsSM.Algebra.Jordan.DVTZ3CentralScalarGroup
```
