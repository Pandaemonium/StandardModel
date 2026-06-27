import Mathlib
import PhysicsSM.Algebra.Jordan.DVTZ3CentralKernel

/-!
# Algebra.Jordan.DVTZ3CentralUnit

Bundled cube-root central-unit API for the DVT complement scaffold.

This module lifts the `DVTZ3CentralScalar` (a subtype of `ℂ`) to the
nonzero complex units `ℂˣ`, yielding `DVTZ3CentralUnit`. It provides
`One`, `Mul`, `Inv`, and a full `Group` instance, making the central kernel
look more like the group-theoretic `ℤ₃` that appears in the literature.

## Main declarations

- `DVTZ3CentralUnit` — the subtype `{ u : ℂˣ // ((u : ℂ) ^ 3 = 1) }`.
- `DVTZ3CentralUnit.toScalar` — forget the unit structure, keeping the cube-root property.
- `DVTZ3CentralScalar.toUnit` — promote a cube-root scalar to a unit.
- `DVTZ3CentralUnit.instGroup` — full `Group` instance.
- `DVTZ3CentralUnit.action_eq_id` — the central scalar action is the identity.
- `DVTZ3CentralUnit.action_apply` — pointwise triviality.
- `DVTZ3CentralUnitPackage` — the packaged result.

## Claim boundary

This is still only the central-kernel API for the current DVT complement
scaffold. It does not prove the full `(SU(3) × SU(3)) / ℤ₃` action theorem,
faithfulness, compact group quotients, or the DVT stabilizer theorem.

Status: trusted theorem package; proofs are complete.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O
open Complex

/-- The bundled type of nonzero complex cube roots of unity, viewed as units. -/
abbrev DVTZ3CentralUnit := { u : ℂˣ // ((u : ℂ) ^ 3 = 1) }

/-- Convert a central unit to a central scalar by forgetting the unit structure. -/
noncomputable def DVTZ3CentralUnit.toScalar
    (u : DVTZ3CentralUnit) : DVTZ3CentralScalar :=
  ⟨(u.val : ℂ), u.prop⟩

/-- Promote a central scalar to a central unit. -/
noncomputable def DVTZ3CentralScalar.toUnit
    (z : DVTZ3CentralScalar) : DVTZ3CentralUnit :=
  ⟨Units.mk0 (z : ℂ) (DVTZ3CentralScalar.ne_zero z), by
    simp only [Units.val_mk0]
    exact z.prop⟩

/-! ### Group structure -/

private theorem cube_eq_one_one : ((1 : ℂˣ) : ℂ) ^ 3 = 1 := by norm_num

private theorem cube_eq_one_mul {u v : ℂˣ}
    (hu : ((u : ℂ) ^ 3 = 1)) (hv : ((v : ℂ) ^ 3 = 1)) :
    ((u * v : ℂˣ) : ℂ) ^ 3 = 1 := by
  simp [Units.val_mul, mul_pow, hu, hv]

private theorem cube_eq_one_inv {u : ℂˣ}
    (hu : ((u : ℂ) ^ 3 = 1)) :
    ((u⁻¹ : ℂˣ) : ℂ) ^ 3 = 1 := by
  rw [Units.val_inv_eq_inv_val, inv_pow, hu, inv_one]

instance : One DVTZ3CentralUnit where
  one := ⟨1, cube_eq_one_one⟩

instance : Mul DVTZ3CentralUnit where
  mul u v := ⟨u.val * v.val, cube_eq_one_mul u.prop v.prop⟩

instance : Inv DVTZ3CentralUnit where
  inv u := ⟨u.val⁻¹, cube_eq_one_inv u.prop⟩

instance DVTZ3CentralUnit.instGroup : Group DVTZ3CentralUnit where
  mul_assoc a b c := Subtype.ext (mul_assoc a.val b.val c.val)
  one_mul a := Subtype.ext (one_mul a.val)
  mul_one a := Subtype.ext (mul_one a.val)
  inv_mul_cancel a := Subtype.ext (inv_mul_cancel a.val)

/-! ### Action triviality -/

/-- The central scalar pair action of any cube-root unit is the identity. -/
theorem DVTZ3CentralUnit.action_eq_id
    (u : DVTZ3CentralUnit) :
    DVTZ3CentralScalar.action u.toScalar =
      AddMonoidHom.id H3OComplement :=
  DVTZ3CentralScalar.action_eq_id u.toScalar

/-- The central scalar pair action of any cube-root unit fixes every
    element pointwise. -/
theorem DVTZ3CentralUnit.action_apply
    (u : DVTZ3CentralUnit) (w : H3OComplement) :
    DVTZ3CentralScalar.action u.toScalar w = w :=
  DVTZ3CentralScalar.action_apply u.toScalar w

/-! ### Packaged result -/

/-- Packaged triviality result for the central-unit action. -/
structure DVTZ3CentralUnitPackage where
  action_trivial :
    ∀ u : DVTZ3CentralUnit,
      DVTZ3CentralScalar.action u.toScalar =
        AddMonoidHom.id H3OComplement

/-- The central-unit action package: every cube-root unit acts trivially. -/
theorem dvtZ3CentralUnitPackage :
    DVTZ3CentralUnitPackage :=
  ⟨DVTZ3CentralUnit.action_eq_id⟩

end PhysicsSM.Algebra.Jordan.DVTAction
