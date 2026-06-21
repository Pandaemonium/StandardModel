import Mathlib
import PhysicsSM.Gauge.StandardModelBlockSubgroupInf

/-!
# Gauge.StandardModelBlockSubgroupMulEquiv

Builds explicit multiplicative equivalences between the Standard Model
block-predicate subgroup and the intersection / infimum subgroups,
using the equality theorems from `StandardModelBlockSubgroupInf`.

This is a citation-friendly form of the concrete Baez-Huerta
intersection theorem at the level of matrix-unit subgroups.

## Main results

- `smBlockUnitsMulEquivSU5PatiSalam`:
    `MulEquiv SMBlockUnitsSubgroup SU5PatiSalamUnitsSubgroup`
- `smBlockUnitsMulEquivInf`:
    `MulEquiv SMBlockUnitsSubgroup ↥(SU5UnitsSubgroup ⊓ PatiSalamUnitsSubgroup)`
- `smBlockUnitsMulEquivSU5PatiSalam_apply_val`,
  `smBlockUnitsMulEquivInf_apply_val`: coercion-simp lemmas.
- `SMBlockUnitsMulEquivPackage` / `smBlockUnitsMulEquivPackage`:
    bundled evidence.

## Claim boundary

This is a concrete multiplicative equivalence of subgroups of matrix units.
It does not prove a topological Lie subgroup theorem, a smooth quotient
theorem, connectedness, or an abstract compact Lie group isomorphism.

Status: trusted - no `s o r r y`.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open PhysicsSM.Gauge.GUTSquare

/-! ## Multiplicative equivalences -/

/-- Multiplicative equivalence between the SM block subgroup and the
SU(5)-Pati-Salam conjunction subgroup, built from their equality. -/
noncomputable def smBlockUnitsMulEquivSU5PatiSalam :
    SMBlockUnitsSubgroup ≃* SU5PatiSalamUnitsSubgroup :=
  MulEquiv.subgroupCongr SMBlockUnitsSubgroup_eq_SU5PatiSalamUnitsSubgroup

/-- Multiplicative equivalence between the SM block subgroup and the
lattice infimum `SU5UnitsSubgroup ⊓ PatiSalamUnitsSubgroup`. -/
noncomputable def smBlockUnitsMulEquivInf :
    SMBlockUnitsSubgroup ≃* ↥(SU5UnitsSubgroup ⊓ PatiSalamUnitsSubgroup) :=
  MulEquiv.subgroupCongr SMBlockUnitsSubgroup_eq_inf

/-! ## Coercion lemmas -/

@[simp]
theorem smBlockUnitsMulEquivSU5PatiSalam_apply_val
    (U : SMBlockUnitsSubgroup) :
    (smBlockUnitsMulEquivSU5PatiSalam U : Units GUTMatrix) =
      (U : Units GUTMatrix) :=
  MulEquiv.subgroupCongr_apply _ U

@[simp]
theorem smBlockUnitsMulEquivInf_apply_val
    (U : SMBlockUnitsSubgroup) :
    (smBlockUnitsMulEquivInf U : Units GUTMatrix) =
      (U : Units GUTMatrix) :=
  MulEquiv.subgroupCongr_apply _ U

/-! ## Bundled package -/

/-- Bundled evidence providing the multiplicative equivalences and a
coercion identity. -/
structure SMBlockUnitsMulEquivPackage where
  /-- Equivalence with the conjunction subgroup. -/
  equiv_intersection :
    SMBlockUnitsSubgroup ≃* SU5PatiSalamUnitsSubgroup
  /-- Equivalence with the lattice infimum. -/
  equiv_inf :
    SMBlockUnitsSubgroup ≃* ↥(SU5UnitsSubgroup ⊓ PatiSalamUnitsSubgroup)
  /-- The infimum equivalence preserves the underlying unit. -/
  equiv_inf_val :
    ∀ U : SMBlockUnitsSubgroup,
      (equiv_inf U : Units GUTMatrix) = (U : Units GUTMatrix)

/-- The canonical `SMBlockUnitsMulEquivPackage`. -/
noncomputable def smBlockUnitsMulEquivPackage :
    SMBlockUnitsMulEquivPackage where
  equiv_intersection := smBlockUnitsMulEquivSU5PatiSalam
  equiv_inf := smBlockUnitsMulEquivInf
  equiv_inf_val := smBlockUnitsMulEquivInf_apply_val

end PhysicsSM.Gauge.StandardModelSubgroup
