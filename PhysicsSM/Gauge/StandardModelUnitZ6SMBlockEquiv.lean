import Mathlib
import PhysicsSM.Gauge.StandardModelCoverageImageSMBlock
import PhysicsSM.Gauge.StandardModelBlockSubgroupMulEquiv
import PhysicsSM.Gauge.StandardModelUnitZ6Kernel

/-!
# Gauge.StandardModelUnitZ6SMBlockEquiv

The unit-level Z₆ quotient equivalence for the Standard Model gauge group.

## Mathematical context

The Standard Model gauge group `S(U(2) × U(3))` can be presented as a
quotient of the covering group `U(1) × SU(2) × SU(3)` by a ℤ₆ kernel.
The covering homomorphism `ι : U(1) × SU(2) × SU(3) → S(U(2) × U(3))`
sends `(α, g, h)` to `(α³ · g, α⁻² · h)`.

This module constructs:

1. The group structure on `SMCoveringTriple` (unit-norm phase, unitary
   parts, determinant product = 1).
2. The quotient `SMCoveringQuotient` by the image equivalence relation
   (two triples are identified when the covering map sends them to the
   same element).
3. A group homomorphism `smCoveringQuotientToSMBlockUnits` from the
   quotient into the SM block-diagonal subgroup.
4. Proofs that this homomorphism is injective and surjective.
5. The resulting multiplicative equivalence
   `smCoveringQuotientMulEquivSMBlockUnits`.
6. A bundled evidence package `standardModelUnitZ6SMBlockEquivPackage`.

## Main declarations

* `SMCoveringTriple.instGroup` — group structure on SM covering triples.
* `SMCoveringQuotient` — quotient by the image equivalence.
* `smCoveringQuotientToSMBlockUnits` — the quotient-to-block homomorphism.
* `smCoveringQuotientToSMBlockUnits_injective` — injectivity.
* `smCoveringQuotientToSMBlockUnits_surjective` — surjectivity.
* `smCoveringQuotientMulEquivSMBlockUnits` — the multiplicative equivalence.
* `standardModelUnitZ6SMBlockEquivPackage` — bundled evidence.

## Claim boundary

This file proves the algebraic (unit-level) Z₆ quotient equivalence.
It does **not** prove:
- topological or smooth Lie group quotient structure,
- connectedness or compactness,
- that the kernel is *exactly* ℤ₆ (only that the quotient by the image
  relation is isomorphic to S(U(2) × U(3))).

This is the Z₆ quotient convention. The true-product quotient theorem
is in a separate file and both are useful.

Status: trusted — s o r r y-free.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.GUTSquare

/-! ## SMCoveringTriple group structure -/

/-- The identity element of `SMCoveringTriple`. -/
noncomputable def SMCoveringTriple.one :
    SMCoveringTriple where
  toUnitCoveringTriple := 1
  phase_norm_one := by simp [Units.val_one]
  su2_unitary := by simp [IsUnitary, Units.val_one]
  su3_unitary := by simp [IsUnitary, Units.val_one]
  det_product_one := by simp [Units.val_one]

/-- Multiplication of `SMCoveringTriple`s, lifting pointwise
multiplication of `UnitCoveringTriple`s. -/
noncomputable def SMCoveringTriple.mul
    (x y : SMCoveringTriple) : SMCoveringTriple where
  toUnitCoveringTriple :=
    x.toUnitCoveringTriple * y.toUnitCoveringTriple
  phase_norm_one := by
    simp only [UnitCoveringTriple.mul_phase,
      Units.val_mul, norm_mul,
      x.phase_norm_one, y.phase_norm_one, mul_one]
  su2_unitary := by
    simp only [UnitCoveringTriple.mul_su2Part,
      Units.val_mul]
    exact isUnitary_mul x.su2_unitary y.su2_unitary
  su3_unitary := by
    simp only [UnitCoveringTriple.mul_su3Part,
      Units.val_mul]
    exact isUnitary_mul x.su3_unitary y.su3_unitary
  det_product_one := by
    simp only [UnitCoveringTriple.mul_su2Part,
      UnitCoveringTriple.mul_su3Part,
      Units.val_mul, det_mul]
    have h1 := x.det_product_one
    have h2 := y.det_product_one
    have : (x.su2Part.val.det * y.su2Part.val.det) *
        (x.su3Part.val.det * y.su3Part.val.det) =
        (x.su2Part.val.det * x.su3Part.val.det) *
        (y.su2Part.val.det * y.su3Part.val.det) :=
      by ring
    rw [this, h1, h2, one_mul]

/-- The inverse of a matrix unit equals its nonsing inv. -/
private theorem units_val_inv_eq_nonsing_inv
    {n : Type*} [Fintype n] [DecidableEq n]
    (U : Units (Matrix n n ℂ)) :
    (U⁻¹ : Units (Matrix n n ℂ)).val = U.val⁻¹ := by
  symm; exact Matrix.inv_eq_right_inv U.val_inv

/-- Unitarity is preserved under `Units` inverse. -/
private theorem isUnitary_of_units_inv
    {n : Type*} [Fintype n] [DecidableEq n]
    {U : Units (Matrix n n ℂ)}
    (hU : IsUnitary U.val) :
    IsUnitary (U⁻¹ : Units (Matrix n n ℂ)).val := by
  rw [units_val_inv_eq_nonsing_inv]
  exact isUnitary_inv hU

/-- Inverse of an `SMCoveringTriple`. -/
noncomputable def SMCoveringTriple.inv
    (x : SMCoveringTriple) : SMCoveringTriple where
  toUnitCoveringTriple := x.toUnitCoveringTriple⁻¹
  phase_norm_one := by
    simp only [UnitCoveringTriple.inv_phase,
      Units.val_inv_eq_inv_val, norm_inv,
      x.phase_norm_one, inv_one]
  su2_unitary := isUnitary_of_units_inv x.su2_unitary
  su3_unitary := isUnitary_of_units_inv x.su3_unitary
  det_product_one := by
    have : x.su2Part.val.det * x.su3Part.val.det = 1 :=
      x.det_product_one
    simp_all +decide
    grind +qlia

/-- `toUnitCoveringTriple` is injective. -/
private theorem
    SMCoveringTriple.toUnitCoveringTriple_injective :
    Function.Injective
      SMCoveringTriple.toUnitCoveringTriple := by
  intro a b h; cases a; cases b; simp_all

/-- The group instance on `SMCoveringTriple`, inheriting
associativity and unit laws from `UnitCoveringTriple` via
injectivity.

Note: The `show` tactics below are structurally needed to
unfold the Group field definitions (`one`, `mul`, `inv`) to
their explicit `SMCoveringTriple.*` counterparts, enabling
`simp` to close the goals. -/
noncomputable instance SMCoveringTriple.instGroup :
    Group SMCoveringTriple where
  one := SMCoveringTriple.one
  mul := SMCoveringTriple.mul
  inv := SMCoveringTriple.inv
  mul_assoc x y z := by
    apply SMCoveringTriple.toUnitCoveringTriple_injective
    exact mul_assoc _ _ _
  one_mul x := by
    apply SMCoveringTriple.toUnitCoveringTriple_injective
    show (SMCoveringTriple.mul SMCoveringTriple.one x
      ).toUnitCoveringTriple = x.toUnitCoveringTriple
    simp [SMCoveringTriple.mul, SMCoveringTriple.one]
  mul_one x := by
    apply SMCoveringTriple.toUnitCoveringTriple_injective
    show (SMCoveringTriple.mul x SMCoveringTriple.one
      ).toUnitCoveringTriple = x.toUnitCoveringTriple
    simp [SMCoveringTriple.mul, SMCoveringTriple.one]
  inv_mul_cancel x := by
    apply SMCoveringTriple.toUnitCoveringTriple_injective
    show (SMCoveringTriple.mul (SMCoveringTriple.inv x) x
      ).toUnitCoveringTriple =
      SMCoveringTriple.one.toUnitCoveringTriple
    simp [SMCoveringTriple.mul, SMCoveringTriple.inv,
      SMCoveringTriple.one]

/-! ## Image map on SMCoveringTriple -/

/-- The covering image of an `SMCoveringTriple`. -/
noncomputable def SMCoveringTriple.smImage
    (x : SMCoveringTriple) :
    UnitCoveringImageCodomain :=
  x.toUnitCoveringTriple.image

theorem SMCoveringTriple.smImage_eq
    (x : SMCoveringTriple) :
    x.smImage = x.toUnitCoveringTriple.image := rfl

theorem SMCoveringTriple.smImage_one :
    SMCoveringTriple.one.smImage = 1 :=
  UnitCoveringTriple.image_one

theorem SMCoveringTriple.smImage_mul
    (x y : SMCoveringTriple) :
    (SMCoveringTriple.mul x y).smImage =
      x.smImage * y.smImage :=
  UnitCoveringTriple.image_mul _ _

/-- The image map as a group homomorphism. -/
noncomputable def smCoveringTripleImageHom :
    SMCoveringTriple →* UnitCoveringImageCodomain where
  toFun := SMCoveringTriple.smImage
  map_one' := SMCoveringTriple.smImage_one
  map_mul' := SMCoveringTriple.smImage_mul

/-! ## Image equivalence and quotient -/

/-- Two `SMCoveringTriple`s are image-equivalent when they map
to the same element under the covering homomorphism. -/
def SMCoveringTriple.ImageEquiv
    (x y : SMCoveringTriple) : Prop :=
  x.smImage = y.smImage

instance SMCoveringTriple.imageSetoid :
    Setoid SMCoveringTriple where
  r := SMCoveringTriple.ImageEquiv
  iseqv :=
    ⟨fun _ => rfl, fun h => h.symm,
      fun h₁ h₂ => h₁.trans h₂⟩

/-- The quotient of `SMCoveringTriple` by image equivalence. -/
abbrev SMCoveringQuotient :=
  Quotient SMCoveringTriple.imageSetoid

/-- The image of `SMCoveringTriple.inv x` is the inverse of
the image. -/
private theorem SMCoveringTriple.smImage_inv
    (x : SMCoveringTriple) :
    (SMCoveringTriple.inv x).smImage =
      (x.smImage)⁻¹ := by
  simp only [SMCoveringTriple.smImage,
    SMCoveringTriple.inv]
  convert UnitCoveringTriple.image_inv _ using 1

noncomputable instance :
    Group SMCoveringQuotient where
  one := ⟦SMCoveringTriple.one⟧
  mul := Quotient.lift₂
    (fun x y =>
      (⟦SMCoveringTriple.mul x y⟧ :
        SMCoveringQuotient))
    (fun _ _ _ _ hab hcd => by
      apply Quotient.sound
      -- `show` needed to reify `≈` as `ImageEquiv`.
      show SMCoveringTriple.ImageEquiv _ _
      unfold SMCoveringTriple.ImageEquiv
      rw [SMCoveringTriple.smImage_mul,
        SMCoveringTriple.smImage_mul, hab, hcd])
  inv := Quotient.lift
    (fun x =>
      (⟦SMCoveringTriple.inv x⟧ :
        SMCoveringQuotient))
    (fun a b hab => by
      apply Quotient.sound
      show SMCoveringTriple.ImageEquiv _ _
      unfold SMCoveringTriple.ImageEquiv
      rw [SMCoveringTriple.smImage_inv,
        SMCoveringTriple.smImage_inv, hab])
  mul_assoc a b c := by
    induction a using Quotient.ind
    induction b using Quotient.ind
    induction c using Quotient.ind
    apply Quotient.sound
    show SMCoveringTriple.ImageEquiv _ _
    unfold SMCoveringTriple.ImageEquiv
    simp [SMCoveringTriple.smImage_mul, mul_assoc]
  one_mul a := by
    induction a using Quotient.ind
    apply Quotient.sound
    show SMCoveringTriple.ImageEquiv _ _
    unfold SMCoveringTriple.ImageEquiv
    simp [SMCoveringTriple.smImage_mul,
      SMCoveringTriple.smImage_one]
  mul_one a := by
    induction a using Quotient.ind
    apply Quotient.sound
    show SMCoveringTriple.ImageEquiv _ _
    unfold SMCoveringTriple.ImageEquiv
    simp [SMCoveringTriple.smImage_mul,
      SMCoveringTriple.smImage_one]
  inv_mul_cancel a := by
    induction a using Quotient.ind
    apply Quotient.sound
    show SMCoveringTriple.ImageEquiv _ _
    unfold SMCoveringTriple.ImageEquiv
    rename_i x
    rw [SMCoveringTriple.smImage_mul,
      SMCoveringTriple.smImage_inv, inv_mul_cancel,
      SMCoveringTriple.smImage_one]

/-! ## Block embedding into GUTMatrix units -/

/-- Embed a pair of invertible matrices into
`Units GUTMatrix` as a block-diagonal matrix. -/
noncomputable def pairToGUTUnit
    (p : Units (Matrix (Fin 2) (Fin 2) ℂ) ×
      Units (Matrix (Fin 3) (Fin 3) ℂ)) :
    Units GUTMatrix where
  val := fromBlocks p.1.val 0 0 p.2.val
  inv := fromBlocks p.1.inv 0 0 p.2.inv
  val_inv := by
    rw [fromBlocks_mul_zero_off_diag]
    simp [fromBlocks_one]
  inv_val := by
    rw [fromBlocks_mul_zero_off_diag]
    simp [fromBlocks_one]

theorem pairToGUTUnit_val
    (p : Units (Matrix (Fin 2) (Fin 2) ℂ) ×
      Units (Matrix (Fin 3) (Fin 3) ℂ)) :
    (pairToGUTUnit p).val =
      fromBlocks p.1.val 0 0 p.2.val := rfl

/-- `pairToGUTUnit` as a group homomorphism. -/
noncomputable def pairToGUTUnitHom :
    (Units (Matrix (Fin 2) (Fin 2) ℂ) ×
      Units (Matrix (Fin 3) (Fin 3) ℂ)) →*
      Units GUTMatrix where
  toFun := pairToGUTUnit
  map_one' := by
    ext : 1
    simp [pairToGUTUnit_val, fromBlocks_one]
  map_mul' p q := by
    ext : 1
    simp [pairToGUTUnit_val, Units.val_mul,
      fromBlocks_mul_zero_off_diag]

/-! ## Map from SMCoveringTriple to SMBlockUnitsSubgroup -/

/-- Map an `SMCoveringTriple` to the SM block subgroup via
the covering image. -/
noncomputable def smCoveringTripleToSMBlockUnit
    (x : SMCoveringTriple) : SMBlockUnitsSubgroup :=
  ⟨pairToGUTUnit x.smImage,
    smCoveringTriple_image_satisfiesSMBlock x⟩

theorem smCoveringTripleToSMBlockUnit_val
    (x : SMCoveringTriple) :
    (smCoveringTripleToSMBlockUnit x :
      Units GUTMatrix).val =
      fromBlocks x.smImage.1.val 0 0
        x.smImage.2.val := rfl

theorem smCoveringTripleToSMBlockUnit_one :
    smCoveringTripleToSMBlockUnit
      SMCoveringTriple.one = 1 := by
  ext
  simp +decide [SMCoveringTriple.one]
  unfold smCoveringTripleToSMBlockUnit
    SMCoveringTriple.smImage
  simp +decide [UnitCoveringTriple.image]
  rename_i i j
  fin_cases i <;> fin_cases j <;> rfl

theorem smCoveringTripleToSMBlockUnit_mul
    (x y : SMCoveringTriple) :
    smCoveringTripleToSMBlockUnit
      (SMCoveringTriple.mul x y) =
      smCoveringTripleToSMBlockUnit x *
        smCoveringTripleToSMBlockUnit y := by
  ext
  simp +decide [SMCoveringTriple.mul]
  convert congr_arg (fun m : GUTMatrix => m _ _)
    (unitCoveringTripleToGUTMatrix_mul
      x.toUnitCoveringTriple
      y.toUnitCoveringTriple) using 1

/-- The quotient-to-SM-block homomorphism. -/
noncomputable def smCoveringQuotientToSMBlockUnits :
    SMCoveringQuotient →*
      SMBlockUnitsSubgroup where
  toFun := Quotient.lift
    smCoveringTripleToSMBlockUnit (fun a b h => by
    exact Subtype.ext (by
      change (pairToGUTUnit a.smImage :
        Units GUTMatrix) = pairToGUTUnit b.smImage
      rw [h]))
  map_one' := by
    show smCoveringTripleToSMBlockUnit
      SMCoveringTriple.one = 1
    exact smCoveringTripleToSMBlockUnit_one
  map_mul' a b := by
    induction a using Quotient.ind
    induction b using Quotient.ind
    exact smCoveringTripleToSMBlockUnit_mul _ _

/-! ## Injectivity -/

theorem smCoveringQuotientToSMBlockUnits_injective :
    Function.Injective
      smCoveringQuotientToSMBlockUnits := by
  intro a b hab
  obtain ⟨x, rfl⟩ := Quotient.exists_rep a
  obtain ⟨y, rfl⟩ := Quotient.exists_rep b
  simp_all +decide [smCoveringQuotientToSMBlockUnits]
  apply Quotient.sound
  injection hab
  injection ‹_›
  simp_all +decide [funext_iff,
    Fin.forall_fin_succ, fromBlocks]
  exact Prod.ext
    (Units.ext <| by
      ext i j
      fin_cases i <;> fin_cases j <;> tauto)
    (Units.ext <| by
      ext i j
      fin_cases i <;> fin_cases j <;> tauto)

/-! ## Sixth root existence -/

theorem complex_sixth_root_exists
    (z : ℂ) (hz : z ≠ 0) :
    ∃ w : ℂ, w ^ 6 = z ∧ w ≠ 0 := by
  have ⟨w, hw⟩ := IsAlgClosed.exists_pow_nat_eq z
    (by norm_num : (0 : ℕ) < 6)
  exact ⟨w, hw, fun h =>
    hz (by rw [← hw, h]; ring)⟩

theorem sixth_root_unit_norm {z w : ℂ}
    (hw6 : w ^ 6 = z) (hz : ‖z‖ = 1) :
    ‖w‖ = 1 := by
  have h : ‖w‖ ^ 6 = 1 := by
    rw [← norm_pow, hw6, hz]
  have hnn : (0 : ℝ) ≤ ‖w‖ := norm_nonneg w
  rw [pow_eq_one_iff_of_nonneg] at h <;> aesop

theorem det_norm_one_of_isUnitary
    {n : Type*} [Fintype n] [DecidableEq n]
    {A : Matrix n n ℂ} (hA : IsUnitary A) :
    ‖A.det‖ = 1 := by
  replace hA := congr_arg Matrix.det hA
  norm_num [Complex.ext_iff] at *
  norm_num [Complex.normSq, Complex.norm_def, hA]

theorem det_ne_zero_of_isUnitary
    {n : Type*} [Fintype n] [DecidableEq n]
    {A : Matrix n n ℂ} (hA : IsUnitary A) :
    A.det ≠ 0 := by
  intro h; have := det_norm_one_of_isUnitary hA
  rw [h, norm_zero] at this
  exact zero_ne_one this

/-! ## Surjectivity -/

set_option maxHeartbeats 1600000 in
-- The `smBlockPreimage` construction needs 1.6M heartbeats
-- because the `det_product_one` field elaborates
-- `simp +zetaDelta` / `grind` chains that unfold deep
-- matrix-scalar-unit and determinant identities to verify
-- det(α⁻³ · A) · det(α² · B) = 1.
/-- Construct a preimage `SMCoveringTriple` for a given
unitary pair `(A, B)` with `det(A) · det(B) = 1`, using a
sixth root `α` of `det(A)`.
The triple is `(α, α⁻³ · A, α² · B)`. -/
noncomputable def smBlockPreimage
    (A : Matrix (Fin 2) (Fin 2) ℂ)
    (B : Matrix (Fin 3) (Fin 3) ℂ)
    (hA : IsUnitary A) (hB : IsUnitary B)
    (hdet : A.det * B.det = 1)
    (α : ℂ) (hα6 : α ^ 6 = A.det)
    (hαnorm : ‖α‖ = 1) :
    SMCoveringTriple := by
  have hα_ne : α ≠ 0 := by
    intro h; rw [h] at hα6; simp at hα6
    exact det_ne_zero_of_isUnitary hA hα6.symm
  let αu : Units ℂ := Units.mk0 α hα_ne
  let Au : Units (Matrix (Fin 2) (Fin 2) ℂ) :=
    ⟨A, A.conjTranspose,
      by rw [mul_eq_one_comm.mpr hA], hA⟩
  let Bu : Units (Matrix (Fin 3) (Fin 3) ℂ) :=
    ⟨B, B.conjTranspose,
      by rw [mul_eq_one_comm.mpr hB], hB⟩
  exact {
    phase := αu
    su2Part := matrixScalarUnit (αu⁻¹ ^ 3) * Au
    su3Part := matrixScalarUnit (αu ^ 2) * Bu
    phase_norm_one := by simp [αu, hαnorm]
    su2_unitary := by
      convert isUnitary_mul _ _ using 1
      exact inferInstance
      · convert isUnitary_smul_one _ using 1
        convert matrixScalarUnit_val _
        · infer_instance
        · simp +decide [αu, hαnorm]
      · exact hA
    su3_unitary := by
      convert isUnitary_mul _ _ using 1
      exact inferInstance
      · convert isUnitary_smul_one _ using 1
        convert matrixScalarUnit_val _
        · infer_instance
        · simp [αu, hαnorm]
      · exact hB
    det_product_one := by
      simp +zetaDelta at *
      grind +qlia
  }

theorem smBlockPreimage_image
    (A : Matrix (Fin 2) (Fin 2) ℂ)
    (B : Matrix (Fin 3) (Fin 3) ℂ)
    (hA : IsUnitary A) (hB : IsUnitary B)
    (hdet : A.det * B.det = 1)
    (α : ℂ) (hα6 : α ^ 6 = A.det)
    (hαnorm : ‖α‖ = 1) :
    (smBlockPreimage A B hA hB hdet α hα6 hαnorm
      ).smImage =
      (⟨A, A.conjTranspose,
        by rw [mul_eq_one_comm.mpr hA], hA⟩,
       ⟨B, B.conjTranspose,
        by rw [mul_eq_one_comm.mpr hB], hB⟩) := by
  unfold smBlockPreimage SMCoveringTriple.smImage
    UnitCoveringTriple.image
  simp +decide [matrixScalarUnit] at *

theorem smCoveringQuotientToSMBlockUnits_surjective :
    Function.Surjective
      smCoveringQuotientToSMBlockUnits := by
  intro x
  obtain ⟨A, B, hA, hB, hdet⟩ :
      ∃ A : Matrix (Fin 2) (Fin 2) ℂ,
        ∃ B : Matrix (Fin 3) (Fin 3) ℂ,
        x.val.val = fromBlocks A 0 0 B ∧
        IsUnitary A ∧ IsUnitary B ∧
        A.det * B.det = 1 := x.2
  obtain ⟨α, hα6, hαnorm⟩ :
      ∃ α : ℂ, α ^ 6 = A.det ∧ ‖α‖ = 1 := by
    have h_det_norm : ‖A.det‖ = 1 :=
      det_norm_one_of_isUnitary hB
    exact ⟨A.det ^ (1 / 6 : ℂ),
      by rw [← Complex.cpow_nat_mul]; norm_num,
      by rw [Complex.norm_cpow_of_ne_zero (by aesop)]
         norm_num [h_det_norm]⟩
  use ⟦smBlockPreimage A B hB hdet.1 hdet.2
    α hα6 hαnorm⟧
  convert Subtype.ext _
  convert smBlockPreimage_image A B hB hdet.1
    hdet.2 α hα6 hαnorm using 1
  constructor <;> intro h <;>
    simp_all +decide only [SetLike.coe_eq_coe]
  · exact smBlockPreimage_image A B hB hdet.1
      hdet.2 α hα6 hαnorm
  · ext
    simp only [smCoveringQuotientToSMBlockUnits]
    unfold smCoveringTripleToSMBlockUnit
    aesop

/-! ## The multiplicative equivalence -/

/-- The multiplicative equivalence between the Z₆ quotient
and the SM block-diagonal subgroup. -/
noncomputable def
    smCoveringQuotientMulEquivSMBlockUnits :
    SMCoveringQuotient ≃* SMBlockUnitsSubgroup :=
  MulEquiv.ofBijective smCoveringQuotientToSMBlockUnits
    ⟨smCoveringQuotientToSMBlockUnits_injective,
     smCoveringQuotientToSMBlockUnits_surjective⟩

/-- Composed equivalence with the SU(5) ⊓ Pati-Salam
intersection. -/
noncomputable def smCoveringQuotientMulEquivInf :
    SMCoveringQuotient ≃*
      ↥(SU5UnitsSubgroup ⊓
        PatiSalamUnitsSubgroup) :=
  smCoveringQuotientMulEquivSMBlockUnits.trans
    smBlockUnitsMulEquivInf

/-! ## Bundled package -/

/-- Bundled evidence for the Z₆ quotient equivalence. -/
structure StandardModelUnitZ6SMBlockEquivPackage where
  /-- The quotient type. -/
  quotient_type : Type
  /-- Its group structure. -/
  quotient_group : Group quotient_type
  /-- Equivalence with the SM block subgroup. -/
  quotient_equiv_sm_block :
    @MulEquiv quotient_type SMBlockUnitsSubgroup
      quotient_group.toMul _
  /-- Equivalence with the SU(5) ⊓ Pati-Salam
  intersection. -/
  quotient_equiv_inf :
    @MulEquiv quotient_type
      ↥(SU5UnitsSubgroup ⊓
        PatiSalamUnitsSubgroup)
      quotient_group.toMul _

/-- The canonical Z₆ quotient equivalence package. -/
noncomputable def
    standardModelUnitZ6SMBlockEquivPackage :
    StandardModelUnitZ6SMBlockEquivPackage where
  quotient_type := SMCoveringQuotient
  quotient_group := inferInstance
  quotient_equiv_sm_block :=
    smCoveringQuotientMulEquivSMBlockUnits
  quotient_equiv_inf :=
    smCoveringQuotientMulEquivInf

end PhysicsSM.Gauge.StandardModelSubgroup
