import Mathlib
import PhysicsSM.Algebra.Jordan.DVTZ3CentralUnit

/-!
# Algebra.Jordan.DVTZ3CentralUnitConversions

Conversion inverse laws and group-operation compatibility for the
DVT central-unit API.

## Main declarations

- `DVTZ3CentralUnit.toScalar_toUnit`: round-trip unit to scalar to unit.
- `DVTZ3CentralScalar.toUnit_toScalar`: round-trip scalar to unit to scalar.
- `DVTZ3CentralUnit.toScalar_one_val`: the scalar of `1` is `1`.
- `DVTZ3CentralUnit.toScalar_mul_val`: multiplicativity at the coercion level.
- `DVTZ3CentralUnit.toScalar_inv_val`: inverse compatibility at the coercion level.
- `DVTZ3CentralUnit.action_mul_eq_id`: product action is trivial.
- `DVTZ3CentralUnit.action_inv_eq_id`: inverse action is trivial.
- `DVTZ3CentralUnitConversionsPackage`: packaged result.

## Claim boundary

This is only API polish for the central-kernel scaffold. It does not prove
faithfulness, quotient-group structure, or the full DVT stabilizer theorem.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O
open Complex

/-! ### Conversion inverse laws -/

theorem DVTZ3CentralUnit.toScalar_toUnit
    (u : DVTZ3CentralUnit) :
    u.toScalar.toUnit = u := by
  exact Subtype.ext ( Units.ext rfl )

theorem DVTZ3CentralScalar.toUnit_toScalar
    (z : DVTZ3CentralScalar) :
    z.toUnit.toScalar = z := by
  exact Subtype.ext rfl

/-! ### Coercion-level compatibility with group operations -/

theorem DVTZ3CentralUnit.toScalar_one_val :
    (((1 : DVTZ3CentralUnit).toScalar : Complex) = 1) := by
  rfl

theorem DVTZ3CentralUnit.toScalar_mul_val
    (u v : DVTZ3CentralUnit) :
    (((u * v).toScalar : Complex) =
      (u.toScalar : Complex) * (v.toScalar : Complex)) := by
  exact Units.val_mul _ _

theorem DVTZ3CentralUnit.toScalar_inv_val
    (u : DVTZ3CentralUnit) :
    (((Inv.inv u).toScalar : Complex) =
      Inv.inv (u.toScalar : Complex)) := by
  convert Units.val_inv_eq_inv_val u.val using 1

/-! ### Action triviality for products and inverses -/

theorem DVTZ3CentralUnit.action_mul_eq_id
    (u v : DVTZ3CentralUnit) :
    DVTZ3CentralScalar.action ((u * v).toScalar) =
      AddMonoidHom.id H3OComplement := by
  apply DVTZ3CentralUnit.action_eq_id

theorem DVTZ3CentralUnit.action_inv_eq_id
    (u : DVTZ3CentralUnit) :
    DVTZ3CentralScalar.action ((Inv.inv u).toScalar) =
      AddMonoidHom.id H3OComplement := by
  exact DVTZ3CentralUnit.action_eq_id _

/-! ### Packaged result -/

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
    DVTZ3CentralUnitConversionsPackage where
  unit_to_scalar_to_unit := DVTZ3CentralUnit.toScalar_toUnit
  scalar_to_unit_to_scalar := DVTZ3CentralScalar.toUnit_toScalar
  action_mul_trivial := DVTZ3CentralUnit.action_mul_eq_id

end PhysicsSM.Algebra.Jordan.DVTAction
