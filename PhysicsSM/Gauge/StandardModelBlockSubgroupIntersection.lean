import Mathlib
import PhysicsSM.Gauge.StandardModelBlockSubgroupGUTSquare

/-!
# Gauge.StandardModelBlockSubgroupIntersection

Defines the subgroup of `Units GUTMatrix` whose members satisfy **both**
the SU(5) predicate and the Pati-Salam (block-diagonal unitary) predicate,
and proves that this subgroup is equal to `SMBlockUnitsSubgroup`.

This gives a clean formal statement of the Baez–Huerta intersection
picture at the concrete matrix-unit subgroup level:

  `SMBlockUnitsSubgroup = SU5PatiSalamUnitsSubgroup`

## Main results

- `SU5PatiSalamUnitPredicate`: conjunction of `SU5Predicate` and
  `PatiSalamPredicate` lifted to `Units GUTMatrix`.
- `SU5PatiSalamUnitsSubgroup`: the subgroup of units satisfying both
  GUT-square predicates.
- `mem_SU5PatiSalamUnitsSubgroup`: membership characterization.
- `SMBlockUnitsSubgroup_eq_SU5PatiSalamUnitsSubgroup`: the equality of the
  two subgroups.
- `SMBlockUnitsIntersectionPackage` / `smBlockUnitsIntersectionPackage`:
  bundled evidence.

## Claim boundary

This is a concrete matrix-unit subgroup theorem. It does not prove a
topological Lie subgroup theorem, a smooth quotient theorem, or an
isomorphism with the abstract Standard Model gauge group.

Status: trusted — no `s o r r y`.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open PhysicsSM.Gauge.GUTSquare

/-! ## Unit-level intersection predicate -/

/--
Predicate on `Units GUTMatrix` expressing that the underlying matrix
satisfies both the SU(5) predicate and the Pati-Salam (block-diagonal
unitary) predicate.
-/
def SU5PatiSalamUnitPredicate (U : Units GUTMatrix) : Prop :=
  SU5Predicate (U : GUTMatrix) ∧ PatiSalamPredicate (U : GUTMatrix)

/-! ## Closure of the intersection predicate -/

/--
The identity unit satisfies both GUT-square predicates.
-/
private theorem SU5PatiSalamUnitPredicate_one :
    SU5PatiSalamUnitPredicate (1 : Units GUTMatrix) := by
  rw [SU5PatiSalamUnitPredicate]
  rw [← smBlock_iff_su5_and_patiSalam]
  exact SMBlockPredicate_one

/--
The conjunction of GUT-square predicates is closed under multiplication.
-/
private theorem SU5PatiSalamUnitPredicate_mul
    {U V : Units GUTMatrix}
    (hU : SU5PatiSalamUnitPredicate U)
    (hV : SU5PatiSalamUnitPredicate V) :
    SU5PatiSalamUnitPredicate (U * V) := by
  rw [SU5PatiSalamUnitPredicate] at hU hV ⊢
  rw [← smBlock_iff_su5_and_patiSalam] at hU hV ⊢
  exact SMBlockPredicate_mul hU hV

/--
The conjunction of GUT-square predicates is closed under inversion.
-/
private theorem SU5PatiSalamUnitPredicate_inv
    {U : Units GUTMatrix}
    (hU : SU5PatiSalamUnitPredicate U) :
    SU5PatiSalamUnitPredicate U⁻¹ := by
  rw [SU5PatiSalamUnitPredicate] at hU ⊢
  rw [← smBlock_iff_su5_and_patiSalam] at hU ⊢
  exact SMBlockPredicate_unit_inv hU

/-! ## The intersection subgroup -/

/--
The subgroup of `Units GUTMatrix` consisting of units whose underlying
matrix satisfies both the SU(5) predicate and the Pati-Salam (block-diagonal
unitary) predicate. This is the unit-level formalization of
`SU(5) ∩ (U(2) × U(3))`.
-/
def SU5PatiSalamUnitsSubgroup : Subgroup (Units GUTMatrix) where
  carrier := {U | SU5PatiSalamUnitPredicate U}
  one_mem' := SU5PatiSalamUnitPredicate_one
  mul_mem' := SU5PatiSalamUnitPredicate_mul
  inv_mem' := SU5PatiSalamUnitPredicate_inv

/--
Membership in `SU5PatiSalamUnitsSubgroup` is equivalent to the underlying
matrix satisfying both the SU(5) predicate and the Pati-Salam predicate.
-/
@[simp]
theorem mem_SU5PatiSalamUnitsSubgroup
    (U : Units GUTMatrix) :
    U ∈ SU5PatiSalamUnitsSubgroup ↔
      SU5Predicate (U : GUTMatrix) ∧
        PatiSalamPredicate (U : GUTMatrix) :=
  Iff.rfl

/-! ## Subgroup equality -/

/--
The Standard Model block-predicate subgroup is equal to the intersection
subgroup defined by the SU(5) and Pati-Salam predicates.

This is the unit-subgroup-level shadow of the Baez–Huerta theorem:
  `G_SM = SU(5) ∩ (U(2) × U(3))`
-/
theorem SMBlockUnitsSubgroup_eq_SU5PatiSalamUnitsSubgroup :
    SMBlockUnitsSubgroup = SU5PatiSalamUnitsSubgroup := by
  ext U
  rw [mem_SMBlockUnitsSubgroup, mem_SU5PatiSalamUnitsSubgroup]
  exact smBlock_iff_su5_and_patiSalam (U : GUTMatrix)

/-! ## Bundled package -/

/--
Bundled evidence that the GUT-square intersection subgroup exists, has the
expected membership characterization, and equals `SMBlockUnitsSubgroup`.
-/
structure SMBlockUnitsIntersectionPackage where
  /-- The intersection subgroup. -/
  intersection_subgroup : Subgroup (Units GUTMatrix)
  /-- Membership is equivalent to the conjunction of the two GUT-square predicates. -/
  mem_iff :
    ∀ U : Units GUTMatrix,
      U ∈ intersection_subgroup ↔
        SU5Predicate (U : GUTMatrix) ∧
          PatiSalamPredicate (U : GUTMatrix)
  /-- The Standard Model block subgroup equals the intersection subgroup. -/
  smBlock_eq_intersection :
    SMBlockUnitsSubgroup = intersection_subgroup

/--
The canonical `SMBlockUnitsIntersectionPackage`, combining the intersection
subgroup with its membership characterization and the subgroup equality.
-/
def smBlockUnitsIntersectionPackage :
    SMBlockUnitsIntersectionPackage :=
  ⟨SU5PatiSalamUnitsSubgroup,
   mem_SU5PatiSalamUnitsSubgroup,
   SMBlockUnitsSubgroup_eq_SU5PatiSalamUnitsSubgroup⟩

end PhysicsSM.Gauge.StandardModelSubgroup
