import Mathlib
import PhysicsSM.Gauge.StandardModelGroupStructure

/-!
# Gauge.StandardModelBlockSubgroup

Packages matrices satisfying `SMBlockPredicate` as a `Subgroup` of
`Units GUTMatrix`, the unit group of the 5x5 complex matrix ring.

## Main results

- `SMBlockUnitPredicate`: predicate on `Units GUTMatrix` lifting `SMBlockPredicate`.
- `SMBlockUnitsSubgroup`: the actual `Subgroup (Units GUTMatrix)`.
- `mem_SMBlockUnitsSubgroup`: membership is equivalent to `SMBlockPredicate` on the
  underlying matrix.
- `smBlockUnitsSubgroupPackage`: bundled evidence that the subgroup exists and has
  the expected membership characterization.

## Claim boundary

This proves subgroup structure for the concrete matrix predicate inside
`Units GUTMatrix`. It does not prove a Lie-group isomorphism, quotient by the
Z6 kernel, smooth/topological structure, or DVT stabilizer theorem.

Status: trusted; no `sorry`.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.GUTSquare

/-! ## Connecting Units inverse with matrix inverse -/

/-- The coercion of a unit inverse equals the matrix inverse of the coercion. -/
private theorem units_inv_val_eq_matrix_inv (U : Units GUTMatrix) :
    ((U⁻¹ : Units GUTMatrix) : GUTMatrix) = (U : GUTMatrix)⁻¹ := by
  symm
  exact Matrix.inv_eq_right_inv (U.val_inv)

/-- If `U : Units GUTMatrix` satisfies `SMBlockPredicate`, so does `U⁻¹`. -/
theorem SMBlockPredicate_unit_inv
    {U : Units GUTMatrix}
    (hU : SMBlockPredicate (U : GUTMatrix)) :
    SMBlockPredicate ((U⁻¹ : Units GUTMatrix) : GUTMatrix) := by
  rw [units_inv_val_eq_matrix_inv]
  exact SMBlockPredicate_inv hU

/-! ## Unit predicate and closure theorems -/

/-- Predicate on `Units GUTMatrix` lifting `SMBlockPredicate` to units. -/
def SMBlockUnitPredicate (U : Units GUTMatrix) : Prop :=
  SMBlockPredicate (U : GUTMatrix)

theorem SMBlockUnitPredicate_one :
    SMBlockUnitPredicate (1 : Units GUTMatrix) :=
  SMBlockPredicate_one

theorem SMBlockUnitPredicate_mul
    {U V : Units GUTMatrix}
    (hU : SMBlockUnitPredicate U)
    (hV : SMBlockUnitPredicate V) :
    SMBlockUnitPredicate (U * V) :=
  SMBlockPredicate_mul hU hV

theorem SMBlockUnitPredicate_inv
    {U : Units GUTMatrix}
    (hU : SMBlockUnitPredicate U) :
    SMBlockUnitPredicate U⁻¹ :=
  SMBlockPredicate_unit_inv hU

/-! ## Subgroup packaging -/

/-- The subgroup of `Units GUTMatrix` consisting of units whose underlying
matrix satisfies `SMBlockPredicate`. -/
def SMBlockUnitsSubgroup : Subgroup (Units GUTMatrix) where
  carrier := {U | SMBlockUnitPredicate U}
  one_mem' := SMBlockUnitPredicate_one
  mul_mem' := SMBlockUnitPredicate_mul
  inv_mem' := SMBlockUnitPredicate_inv

@[simp]
theorem mem_SMBlockUnitsSubgroup
    (U : Units GUTMatrix) :
    U ∈ SMBlockUnitsSubgroup ↔ SMBlockPredicate (U : GUTMatrix) :=
  Iff.rfl

/-- Bundled evidence that the subgroup exists with the expected membership
characterization. -/
structure SMBlockUnitsSubgroupPackage where
  subgroup : Subgroup (Units GUTMatrix)
  mem_iff :
    ∀ U : Units GUTMatrix,
      U ∈ subgroup ↔ SMBlockPredicate (U : GUTMatrix)

def smBlockUnitsSubgroupPackage :
    SMBlockUnitsSubgroupPackage :=
  ⟨SMBlockUnitsSubgroup, mem_SMBlockUnitsSubgroup⟩

end PhysicsSM.Gauge.StandardModelSubgroup
