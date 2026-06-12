import Mathlib
import PhysicsSM.Algebra.Jordan.DVTZ3CentralUnitEquiv

/-!
# Algebra.Jordan.DVTZ3CentralScalarGroup

Group structure on `DVTZ3CentralScalar` and multiplicativity of the
equivalence `dvtZ3CentralUnitEquivScalar`.

## Main declarations

- `DVTZ3CentralScalar.instGroup` — full `Group` instance on `DVTZ3CentralScalar`.
- `DVTZ3CentralScalar.coe_one`, `coe_mul`, `coe_inv` — coercion lemmas.
- `dvtZ3CentralUnitEquivScalar_one`, `_mul`, `_inv` — multiplicativity.
- `dvtZ3CentralUnitToScalarMonoidHom` — bundled monoid homomorphism.
- `dvtZ3CentralScalarGroupPackage` — packaged result.

## Claim boundary

This proves the algebraic group structure on the cube-root central scalar
subtype and the multiplicative compatibility of the existing equivalence. It
does not prove that the group has cardinality three, is cyclic, or completes
the full DVT stabilizer theorem.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O
open Complex

/-! ### Group structure on `DVTZ3CentralScalar` -/

private theorem scalar_cube_one : (1 : ℂ) ^ 3 = 1 := by norm_num

private theorem scalar_cube_mul {z w : ℂ} (hz : z ^ 3 = 1) (hw : w ^ 3 = 1) :
    (z * w) ^ 3 = 1 := by rw [mul_pow, hz, hw, one_mul]

private theorem scalar_cube_inv {z : ℂ} (hz : z ^ 3 = 1) :
    z⁻¹ ^ 3 = 1 := by rw [inv_pow, hz, inv_one]

instance : One DVTZ3CentralScalar where
  one := ⟨1, scalar_cube_one⟩

instance : Mul DVTZ3CentralScalar where
  mul z w := ⟨(z : ℂ) * (w : ℂ), scalar_cube_mul z.prop w.prop⟩

noncomputable instance : Inv DVTZ3CentralScalar where
  inv z := ⟨(z : ℂ)⁻¹, scalar_cube_inv z.prop⟩

noncomputable instance DVTZ3CentralScalar.instGroup : Group DVTZ3CentralScalar where
  mul_assoc a b c := Subtype.ext (mul_assoc _ _ _)
  one_mul a := Subtype.ext (one_mul _)
  mul_one a := Subtype.ext (mul_one _)
  inv_mul_cancel a := Subtype.ext (inv_mul_cancel₀ (DVTZ3CentralScalar.ne_zero a))

/-! ### Coercion lemmas -/

@[simp] theorem DVTZ3CentralScalar.coe_one :
    ((1 : DVTZ3CentralScalar) : ℂ) = 1 := rfl

theorem DVTZ3CentralScalar.coe_mul
    (z w : DVTZ3CentralScalar) :
    ((z * w : DVTZ3CentralScalar) : ℂ) =
      (z : ℂ) * (w : ℂ) := rfl

theorem DVTZ3CentralScalar.coe_inv
    (z : DVTZ3CentralScalar) :
    ((z⁻¹ : DVTZ3CentralScalar) : ℂ) = (z : ℂ)⁻¹ := rfl

/-! ### Multiplicativity of the equivalence -/

theorem dvtZ3CentralUnitEquivScalar_one :
    dvtZ3CentralUnitEquivScalar (1 : DVTZ3CentralUnit) =
      (1 : DVTZ3CentralScalar) := by
  simp only [dvtZ3CentralUnitEquivScalar_apply]
  exact Subtype.ext rfl

theorem dvtZ3CentralUnitEquivScalar_mul
    (u v : DVTZ3CentralUnit) :
    dvtZ3CentralUnitEquivScalar (u * v) =
      dvtZ3CentralUnitEquivScalar u *
        dvtZ3CentralUnitEquivScalar v := by
  simp only [dvtZ3CentralUnitEquivScalar_apply]
  exact Subtype.ext (Units.val_mul _ _)

theorem dvtZ3CentralUnitEquivScalar_inv
    (u : DVTZ3CentralUnit) :
    dvtZ3CentralUnitEquivScalar (u⁻¹) =
      (dvtZ3CentralUnitEquivScalar u)⁻¹ := by
  simp only [dvtZ3CentralUnitEquivScalar_apply]
  exact Subtype.ext (Units.val_inv_eq_inv_val _)

/-! ### Bundled monoid homomorphism -/

noncomputable def dvtZ3CentralUnitToScalarMonoidHom :
    DVTZ3CentralUnit →* DVTZ3CentralScalar where
  toFun := dvtZ3CentralUnitEquivScalar
  map_one' := dvtZ3CentralUnitEquivScalar_one
  map_mul' := dvtZ3CentralUnitEquivScalar_mul

/-! ### Packaged result -/

structure DVTZ3CentralScalarGroupPackage where
  scalar_group : Group DVTZ3CentralScalar
  unit_to_scalar_hom : DVTZ3CentralUnit →* DVTZ3CentralScalar
  unit_to_scalar_hom_injective :
    Function.Injective unit_to_scalar_hom

noncomputable def dvtZ3CentralScalarGroupPackage :
    DVTZ3CentralScalarGroupPackage where
  scalar_group := DVTZ3CentralScalar.instGroup
  unit_to_scalar_hom := dvtZ3CentralUnitToScalarMonoidHom
  unit_to_scalar_hom_injective := by
    intro u v h
    have := dvtZ3CentralUnitEquivScalar.injective h
    exact this

end PhysicsSM.Algebra.Jordan.DVTAction
