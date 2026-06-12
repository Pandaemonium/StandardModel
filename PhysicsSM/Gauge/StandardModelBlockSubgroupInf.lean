import Mathlib
import PhysicsSM.Gauge.StandardModelBlockSubgroupIntersection

/-!
# Gauge.StandardModelBlockSubgroupInf

Expresses the Standard Model block-predicate subgroup as the lattice infimum
of the SU(5) units subgroup and the Pati-Salam units subgroup:

  `SMBlockUnitsSubgroup = SU5UnitsSubgroup ⊓ PatiSalamUnitsSubgroup`

This gives a cleaner Lean statement of the Baez–Huerta intersection picture
at the concrete matrix-unit subgroup level, using the subgroup lattice
structure rather than a manually constructed conjunction subgroup.

## Main results

- `SU5UnitPredicate`, `PatiSalamUnitPredicate`: unit-level predicates.
- `SU5UnitsSubgroup`, `PatiSalamUnitsSubgroup`: the two subgroups.
- `mem_SU5UnitsSubgroup`, `mem_PatiSalamUnitsSubgroup`: membership lemmas.
- `SU5PatiSalamUnitsSubgroup_eq_inf`: the conjunction subgroup equals the
  lattice infimum.
- `SMBlockUnitsSubgroup_eq_inf`: the SM block subgroup equals the infimum.
- `SMBlockUnitsInfPackage` / `smBlockUnitsInfPackage`: bundled evidence.

## Claim boundary

This is a concrete matrix-unit subgroup theorem. It does not prove a
topological Lie subgroup theorem, a smooth quotient theorem, connectedness,
or an isomorphism with an abstract compact Lie group.

Status: trusted — no `sorry`.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open PhysicsSM.Gauge.GUTSquare
open Matrix Complex

/-! ## Unit-level predicates -/

/-- Predicate on `Units GUTMatrix` expressing that the underlying matrix
satisfies the SU(5) predicate. -/
def SU5UnitPredicate (U : Units GUTMatrix) : Prop :=
  SU5Predicate (U : GUTMatrix)

/-- Predicate on `Units GUTMatrix` expressing that the underlying matrix
satisfies the Pati-Salam (block-diagonal unitary) predicate. -/
def PatiSalamUnitPredicate (U : Units GUTMatrix) : Prop :=
  PatiSalamPredicate (U : GUTMatrix)

/-! ## SU(5) subgroup closure -/

private theorem SU5UnitPredicate_one :
    SU5UnitPredicate (1 : Units GUTMatrix) := by
  unfold SU5UnitPredicate SU5Predicate IsUnitary
  simp [Units.val_one]

private theorem SU5UnitPredicate_mul
    {U V : Units GUTMatrix}
    (hU : SU5UnitPredicate U)
    (hV : SU5UnitPredicate V) :
    SU5UnitPredicate (U * V) := by
  unfold SU5UnitPredicate SU5Predicate at hU hV ⊢
  simp only [Units.val_mul]
  exact ⟨isUnitary_mul hU.1 hV.1,
    by rw [det_mul, hU.2, hV.2, one_mul]⟩

private theorem SU5UnitPredicate_inv
    {U : Units GUTMatrix}
    (hU : SU5UnitPredicate U) :
    SU5UnitPredicate U⁻¹ := by
      convert isUnitary_inv hU.1 using 1;
      convert iff_of_true ?_ ?_;
      · have := hU.1;
        exact ⟨by simpa [isUnitary_inv_eq_conjTranspose this] using isUnitary_inv this, by
          have := hU.2; have := U.val_inv; simp_all +decide⟩;
      · exact isUnitary_inv hU.1

/-! ## Pati-Salam subgroup closure -/

private theorem PatiSalamUnitPredicate_one :
    PatiSalamUnitPredicate (1 : Units GUTMatrix) := by
  unfold PatiSalamUnitPredicate PatiSalamPredicate
  refine ⟨1, 1, ?_, ?_, ?_⟩
  · simp [Units.val_one, fromBlocks_one]
  · unfold IsUnitary; simp
  · unfold IsUnitary; simp

private theorem PatiSalamUnitPredicate_mul
    {U V : Units GUTMatrix}
    (hU : PatiSalamUnitPredicate U)
    (hV : PatiSalamUnitPredicate V) :
    PatiSalamUnitPredicate (U * V) := by
  obtain ⟨A₁, B₁, hU⟩ := hU
  obtain ⟨A₂, B₂, hV⟩ := hV
  use A₁ * A₂, B₁ * B₂
  simp_all +decide [IsUnitary]
  simp_all +decide [← mul_assoc, fromBlocks_mul_zero_off_diag]
  simp_all +decide [mul_assoc]

private theorem PatiSalamUnitPredicate_inv
    {U : Units GUTMatrix}
    (hU : PatiSalamUnitPredicate U) :
    PatiSalamUnitPredicate U⁻¹ := by
  obtain ⟨A, B, hAB⟩ := hU
  use A⁻¹, B⁻¹
  have h_inv : (U⁻¹ : GUTMatrix) = fromBlocks A⁻¹ 0 0 B⁻¹ := by
    rw [hAB.1, fromBlocks_inv_zero_off_diag]
    · aesop
    · exact hAB.2.2
  exact ⟨by simpa using h_inv,
    isUnitary_inv hAB.2.1, isUnitary_inv hAB.2.2⟩

/-! ## The two subgroups -/

/-- The subgroup of `Units GUTMatrix` whose underlying matrix satisfies the
SU(5) predicate (unitary with determinant 1). -/
def SU5UnitsSubgroup : Subgroup (Units GUTMatrix) where
  carrier := {U | SU5UnitPredicate U}
  one_mem' := SU5UnitPredicate_one
  mul_mem' := SU5UnitPredicate_mul
  inv_mem' := SU5UnitPredicate_inv

/-- The subgroup of `Units GUTMatrix` whose underlying matrix satisfies the
Pati-Salam (block-diagonal unitary) predicate. -/
def PatiSalamUnitsSubgroup : Subgroup (Units GUTMatrix) where
  carrier := {U | PatiSalamUnitPredicate U}
  one_mem' := PatiSalamUnitPredicate_one
  mul_mem' := PatiSalamUnitPredicate_mul
  inv_mem' := PatiSalamUnitPredicate_inv

/-! ## Membership lemmas -/

@[simp]
theorem mem_SU5UnitsSubgroup
    (U : Units GUTMatrix) :
    U ∈ SU5UnitsSubgroup ↔ SU5Predicate (U : GUTMatrix) :=
  Iff.rfl

@[simp]
theorem mem_PatiSalamUnitsSubgroup
    (U : Units GUTMatrix) :
    U ∈ PatiSalamUnitsSubgroup ↔
      PatiSalamPredicate (U : GUTMatrix) :=
  Iff.rfl

/-! ## Infimum theorems -/

/-- The conjunction subgroup `SU5PatiSalamUnitsSubgroup` equals the lattice
infimum of `SU5UnitsSubgroup` and `PatiSalamUnitsSubgroup`. -/
theorem SU5PatiSalamUnitsSubgroup_eq_inf :
    SU5PatiSalamUnitsSubgroup =
      SU5UnitsSubgroup ⊓ PatiSalamUnitsSubgroup := by
  refine le_antisymm ?_ ?_ <;>
    intro x hx <;>
    simp_all +decide [Subgroup.mem_inf]

/-- The Standard Model block subgroup is the infimum of the SU(5) units
subgroup and the Pati-Salam units subgroup.

This is the subgroup-lattice formulation of the Baez–Huerta intersection:
  `G_SM = SU(5) ∩ (U(2) × U(3))`
-/
theorem SMBlockUnitsSubgroup_eq_inf :
    SMBlockUnitsSubgroup =
      SU5UnitsSubgroup ⊓ PatiSalamUnitsSubgroup := by
  rw [← SU5PatiSalamUnitsSubgroup_eq_inf]
  exact SMBlockUnitsSubgroup_eq_SU5PatiSalamUnitsSubgroup

/-! ## Bundled package -/

/-- Bundled evidence that the SM block subgroup is the infimum of two
separately named subgroups. -/
structure SMBlockUnitsInfPackage where
  /-- The SU(5) units subgroup. -/
  su5_units : Subgroup (Units GUTMatrix)
  /-- The Pati-Salam units subgroup. -/
  pati_salam_units : Subgroup (Units GUTMatrix)
  /-- The SM block subgroup equals the infimum. -/
  smBlock_eq_inf :
    SMBlockUnitsSubgroup = su5_units ⊓ pati_salam_units

/-- The canonical `SMBlockUnitsInfPackage`. -/
def smBlockUnitsInfPackage : SMBlockUnitsInfPackage where
  su5_units := SU5UnitsSubgroup
  pati_salam_units := PatiSalamUnitsSubgroup
  smBlock_eq_inf := SMBlockUnitsSubgroup_eq_inf

end PhysicsSM.Gauge.StandardModelSubgroup
