import Mathlib
import PhysicsSM.Algebra.Jordan.DVTZ3CentralUnitConversions

/-!
# Algebra.Jordan.DVTZ3CentralUnitEquiv

Explicit type equivalence between bundled central units and bundled central
scalars, built from the proved scalar/unit round-trip lemmas.

## Main declarations

- `dvtZ3CentralUnitEquivScalar`: the `Equiv` between `DVTZ3CentralUnit` and
  `DVTZ3CentralScalar`.
- `dvtZ3CentralUnitEquivScalar_apply` / `_symm_apply`: computation rules.
- `dvtZ3CentralUnitEquivScalar_mul_val` / `_inv_val`: coercion compatibility
  with group operations through the equivalence.
- `DVTZ3CentralUnitEquivPackage` / `dvtZ3CentralUnitEquivPackage`: packaged
  result.

## Claim boundary

This is only an equivalence between two bundled representations of the same
central-unit data. It does not prove a cardinality-three theorem, a cyclic
group isomorphism, quotient faithfulness, or the full DVT stabilizer theorem.
-/

namespace PhysicsSM.Algebra.Jordan.DVTAction

open PhysicsSM.Algebra.Octonion
open PhysicsSM.Algebra.Jordan.H3O
open Complex

/-! ### The equivalence -/

noncomputable def dvtZ3CentralUnitEquivScalar :
    Equiv DVTZ3CentralUnit DVTZ3CentralScalar where
  toFun := DVTZ3CentralUnit.toScalar
  invFun := DVTZ3CentralScalar.toUnit
  left_inv u := DVTZ3CentralUnit.toScalar_toUnit u
  right_inv z := DVTZ3CentralScalar.toUnit_toScalar z

/-! ### Apply / symm lemmas -/

theorem dvtZ3CentralUnitEquivScalar_apply
    (u : DVTZ3CentralUnit) :
    dvtZ3CentralUnitEquivScalar u = u.toScalar := rfl

theorem dvtZ3CentralUnitEquivScalar_symm_apply
    (z : DVTZ3CentralScalar) :
    dvtZ3CentralUnitEquivScalar.symm z = z.toUnit := rfl

/-! ### Coercion compatibility through the equivalence -/

theorem dvtZ3CentralUnitEquivScalar_mul_val
    (u v : DVTZ3CentralUnit) :
    ((dvtZ3CentralUnitEquivScalar (u * v) : Complex) =
      (dvtZ3CentralUnitEquivScalar u : Complex) *
        (dvtZ3CentralUnitEquivScalar v : Complex)) := by
  simp only [dvtZ3CentralUnitEquivScalar_apply]
  exact DVTZ3CentralUnit.toScalar_mul_val u v

theorem dvtZ3CentralUnitEquivScalar_inv_val
    (u : DVTZ3CentralUnit) :
    ((dvtZ3CentralUnitEquivScalar (Inv.inv u) : Complex) =
      Inv.inv (dvtZ3CentralUnitEquivScalar u : Complex)) := by
  simp only [dvtZ3CentralUnitEquivScalar_apply]
  exact DVTZ3CentralUnit.toScalar_inv_val u

/-! ### Packaged result -/

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

noncomputable def dvtZ3CentralUnitEquivPackage :
    DVTZ3CentralUnitEquivPackage where
  unit_equiv_scalar := dvtZ3CentralUnitEquivScalar
  unit_equiv_scalar_apply := dvtZ3CentralUnitEquivScalar_apply
  unit_equiv_scalar_symm_apply := dvtZ3CentralUnitEquivScalar_symm_apply
  unit_equiv_scalar_mul_val := dvtZ3CentralUnitEquivScalar_mul_val

end PhysicsSM.Algebra.Jordan.DVTAction
