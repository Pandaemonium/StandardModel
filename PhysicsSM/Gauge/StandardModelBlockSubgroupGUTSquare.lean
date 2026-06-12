import Mathlib
import PhysicsSM.Gauge.StandardModelBlockSubgroup
import PhysicsSM.Gauge.GUTSquare

/-!
# Gauge.StandardModelBlockSubgroupGUTSquare

Connects the `SMBlockUnitsSubgroup` (units of `GUTMatrix` satisfying
`SMBlockPredicate`) with the GUT-square intersection theorem
`SMBlockPredicate M ↔ SU5Predicate M ∧ PatiSalamPredicate M`.

## Main results

- `mem_SMBlockUnitsSubgroup_iff_su5_and_patiSalam`: membership in
  `SMBlockUnitsSubgroup` is equivalent to the conjunction of
  `SU5Predicate` and `PatiSalamPredicate` on the underlying matrix.
- `mem_SMBlockUnitsSubgroup_su5`: projection to the SU(5) predicate.
- `mem_SMBlockUnitsSubgroup_patiSalam`: projection to the Pati-Salam predicate.
- `SMBlockUnitsGUTSquarePackage` / `smBlockUnitsGUTSquarePackage`:
  bundled evidence combining the subgroup package with the GUT-square
  characterization.

## Claim boundary

This is only a predicate-intersection theorem for concrete matrix units.
It does not prove a Lie-group theorem, a quotient theorem, or a DVT
stabilizer intersection theorem.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open PhysicsSM.Gauge.GUTSquare

/-! ## Unit-subgroup membership via GUT square -/

/--
Membership in `SMBlockUnitsSubgroup` is equivalent to the underlying matrix
satisfying both the SU(5) predicate and the Pati-Salam (block-diagonal
unitary) predicate.
-/
theorem mem_SMBlockUnitsSubgroup_iff_su5_and_patiSalam
    (U : Units GUTMatrix) :
    U ∈ SMBlockUnitsSubgroup ↔
      SU5Predicate (U : GUTMatrix) ∧
        PatiSalamPredicate (U : GUTMatrix) := by
  rw [mem_SMBlockUnitsSubgroup]
  exact smBlock_iff_su5_and_patiSalam (U : GUTMatrix)

/--
If `U` belongs to `SMBlockUnitsSubgroup`, then its underlying matrix
satisfies the SU(5) predicate.
-/
theorem mem_SMBlockUnitsSubgroup_su5
    {U : Units GUTMatrix}
    (hU : U ∈ SMBlockUnitsSubgroup) :
    SU5Predicate (U : GUTMatrix) :=
  ((mem_SMBlockUnitsSubgroup_iff_su5_and_patiSalam U).mp hU).1

/--
If `U` belongs to `SMBlockUnitsSubgroup`, then its underlying matrix
satisfies the Pati-Salam (block-diagonal unitary) predicate.
-/
theorem mem_SMBlockUnitsSubgroup_patiSalam
    {U : Units GUTMatrix}
    (hU : U ∈ SMBlockUnitsSubgroup) :
    PatiSalamPredicate (U : GUTMatrix) :=
  ((mem_SMBlockUnitsSubgroup_iff_su5_and_patiSalam U).mp hU).2

/-! ## Bundled package -/

/--
Bundled evidence that `SMBlockUnitsSubgroup` exists, has the expected
membership characterization, and that membership is equivalent to the
conjunction of the SU(5) and Pati-Salam predicates.
-/
structure SMBlockUnitsGUTSquarePackage where
  subgroup_package : SMBlockUnitsSubgroupPackage
  mem_iff_gut_square :
    ∀ U : Units GUTMatrix,
      U ∈ SMBlockUnitsSubgroup ↔
        SU5Predicate (U : GUTMatrix) ∧
          PatiSalamPredicate (U : GUTMatrix)

/--
The canonical `SMBlockUnitsGUTSquarePackage`, combining the subgroup
package with the GUT-square characterization.
-/
def smBlockUnitsGUTSquarePackage :
    SMBlockUnitsGUTSquarePackage :=
  ⟨smBlockUnitsSubgroupPackage, mem_SMBlockUnitsSubgroup_iff_su5_and_patiSalam⟩

end PhysicsSM.Gauge.StandardModelSubgroup
