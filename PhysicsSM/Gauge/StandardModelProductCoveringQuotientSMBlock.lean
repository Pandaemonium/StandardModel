import Mathlib
import PhysicsSM.Gauge.StandardModelCoveringMapSurjective
import PhysicsSM.Gauge.StandardModelBlockSubgroupMulEquiv

/-!
# Gauge.StandardModelProductCoveringQuotientSMBlock

Quotient of the SM product covering domain by image equivalence,
and its multiplicative equivalence with `SMBlockUnitsSubgroup`.

## Mathematical context

The covering homomorphism `ι : U(1) × SU(2) × SU(3) → S(U(2) × U(3))`
sends `(α, g, h)` to `(α³ · g, α⁻² · h)`. Taking the quotient of
`SMCoveringTriple` (the unit-norm, unitary, det-product-one covering domain)
by the equivalence relation "same image" yields a group isomorphic to
`SMBlockUnitsSubgroup ≅ S(U(2) × U(3))`.

## Main declarations

* `SMProductCoveringTriple` — type alias for `SMCoveringTriple`.
* `smProductCoveringTripleToSMBlockUnits` — the map to `SMBlockUnitsSubgroup`.
* `SMProductCoveringTriple.ImageEquivalent` — image equivalence relation.
* `SMProductCoveringTriple.imageSetoid` — the setoid.
* `SMProductCoveringQuotient` — the quotient type.
* `Group SMProductCoveringQuotient` — group instance on the quotient.
* `smProductCoveringQuotientToSMBlockUnits` — descended monoid hom.
* `smProductCoveringQuotientToSMBlockUnits_injective` — injectivity.
* `smProductCoveringQuotientToSMBlockUnits_surjective` — surjectivity.
* `smProductCoveringQuotientMulEquivSMBlockUnits` — the `MulEquiv`.
* `StandardModelProductCoveringQuotientSMBlockPackage` — bundled record.

## Claim boundary

This is an algebraic quotient theorem. It does not prove a topological
quotient, smooth Lie group isomorphism, compactness, or physical dynamics.

Status: trusted — no s o r r y.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.GUTSquare

/-! ## Type alias -/

/-- The product covering domain. -/
abbrev SMProductCoveringTriple := SMCoveringTriple

/-! ## Map to SMBlockUnitsSubgroup -/

/-- Send an `SMProductCoveringTriple` to `SMBlockUnitsSubgroup`. -/
noncomputable def smProductCoveringTripleToSMBlockUnits
    (x : SMProductCoveringTriple) : SMBlockUnitsSubgroup :=
  ⟨unitOfIsUnitary (isUnitary_fromBlocks x.image.1.val x.image.2.val
    (smCoveringTriple_image_fst_unitary x)
    (smCoveringTriple_image_snd_unitary x)),
   smCoveringTriple_image_satisfiesSMBlock x⟩

/-! ## Image equivalence and quotient -/

/-- Two triples are equivalent when they map to the same block unit. -/
def SMProductCoveringTriple.ImageEquivalent
    (x y : SMProductCoveringTriple) : Prop :=
  smProductCoveringTripleToSMBlockUnits x =
    smProductCoveringTripleToSMBlockUnits y

instance SMProductCoveringTriple.imageSetoid :
    Setoid SMProductCoveringTriple where
  r := SMProductCoveringTriple.ImageEquivalent
  iseqv := ⟨fun _ => rfl, fun h => h.symm, fun h₁ h₂ => h₁.trans h₂⟩

/-- The quotient of `SMProductCoveringTriple` by image equivalence. -/
abbrev SMProductCoveringQuotient :=
  Quotient SMProductCoveringTriple.imageSetoid

/-! ## SM covering triple operations -/

/-- Product of two SM covering triples. -/
noncomputable def SMProductCoveringTriple.mul'
    (x y : SMProductCoveringTriple) : SMProductCoveringTriple where
  toUnitCoveringTriple := x.toUnitCoveringTriple * y.toUnitCoveringTriple
  phase_norm_one := by
    simp only [UnitCoveringTriple.mul_phase, Units.val_mul, norm_mul,
               x.phase_norm_one, y.phase_norm_one, mul_one]
  su2_unitary := by simpa using isUnitary_mul x.su2_unitary y.su2_unitary
  su3_unitary := by simpa using isUnitary_mul x.su3_unitary y.su3_unitary
  det_product_one := by
    simp only [UnitCoveringTriple.mul_su2Part, UnitCoveringTriple.mul_su3Part,
               Units.val_mul, det_mul]
    have h1 := x.det_product_one; have h2 := y.det_product_one
    have : x.su2Part.val.det * y.su2Part.val.det *
           (x.su3Part.val.det * y.su3Part.val.det) =
      (x.su2Part.val.det * x.su3Part.val.det) *
      (y.su2Part.val.det * y.su3Part.val.det) := by ring
    rw [this, h1, h2, mul_one]

/-- The identity covering triple. -/
noncomputable def SMProductCoveringTriple.one' :
    SMProductCoveringTriple where
  toUnitCoveringTriple := 1
  phase_norm_one := by simp [Units.val_one]
  su2_unitary := by unfold IsUnitary; simp
  su3_unitary := by unfold IsUnitary; simp
  det_product_one := by simp [det_one]

/-- Inverse of a covering triple. -/
noncomputable def SMProductCoveringTriple.inv'
    (x : SMProductCoveringTriple) : SMProductCoveringTriple where
  toUnitCoveringTriple := x.toUnitCoveringTriple⁻¹
  phase_norm_one := by simp [x.phase_norm_one]
  su2_unitary := by simpa using isUnitary_inv x.su2_unitary
  su3_unitary := by simpa using isUnitary_inv x.su3_unitary
  det_product_one := by
    simp only [UnitCoveringTriple.inv_su2Part,
               UnitCoveringTriple.inv_su3Part]
    simp [isUnitary_inv_eq_conjTranspose x.su2_unitary,
          isUnitary_inv_eq_conjTranspose x.su3_unitary,
          det_conjTranspose, ← starRingEnd_apply, ← map_mul,
          x.det_product_one]

/-! ## Map is a homomorphism (image level) -/

private theorem smMap_image_mul
    (x y : SMProductCoveringTriple) :
    (x.mul' y).image = x.image * y.image :=
  UnitCoveringTriple.image_mul _ _

private theorem smMap_image_one :
    SMProductCoveringTriple.one'.image = 1 :=
  UnitCoveringTriple.image_one

private theorem smMap_image_inv
    (x : SMProductCoveringTriple) :
    x.inv'.image = x.image⁻¹ :=
  UnitCoveringTriple.image_inv _

/-- The map to `SMBlockUnitsSubgroup` is multiplicative. -/
private theorem smMap_hom_mul
    (x y : SMProductCoveringTriple) :
    smProductCoveringTripleToSMBlockUnits (x.mul' y) =
      smProductCoveringTripleToSMBlockUnits x *
        smProductCoveringTripleToSMBlockUnits y := by
  ext
  unfold smProductCoveringTripleToSMBlockUnits
  simp +decide [smMap_image_mul, fromBlocks_mul_zero_off_diag]

/-- The map sends `one'` to `1`. -/
private theorem smMap_hom_one :
    smProductCoveringTripleToSMBlockUnits
      SMProductCoveringTriple.one' = 1 := by
  unfold smProductCoveringTripleToSMBlockUnits
  simp +decide [SMProductCoveringTriple.one']
  unfold unitOfIsUnitary; aesop

/-- The map sends `inv'` to inverse. -/
private theorem smMap_hom_inv
    (x : SMProductCoveringTriple) :
    smProductCoveringTripleToSMBlockUnits x.inv' =
      (smProductCoveringTripleToSMBlockUnits x)⁻¹ := by
  refine eq_inv_of_mul_eq_one_left ?_
  rw [← smMap_hom_mul]
  rw [show x.inv'.mul' x = SMProductCoveringTriple.one' from by
    unfold SMProductCoveringTriple.inv'
      SMProductCoveringTriple.mul' SMProductCoveringTriple.one'
    aesop]
  exact smMap_hom_one

/-! ## Group structure on the quotient -/

noncomputable instance : Group SMProductCoveringQuotient where
  one := ⟦SMProductCoveringTriple.one'⟧
  mul := Quotient.lift₂
    (fun x y => (⟦x.mul' y⟧ : SMProductCoveringQuotient))
    (fun _ _ _ _ hab hcd => Quotient.sound (by
      change SMProductCoveringTriple.ImageEquivalent _ _
      simp only [SMProductCoveringTriple.ImageEquivalent] at *
      rw [smMap_hom_mul, smMap_hom_mul, hab, hcd]))
  inv := Quotient.lift
    (fun x => (⟦x.inv'⟧ : SMProductCoveringQuotient))
    (fun _ _ hab => Quotient.sound (by
      change SMProductCoveringTriple.ImageEquivalent _ _
      simp only [SMProductCoveringTriple.ImageEquivalent] at *
      rw [smMap_hom_inv, smMap_hom_inv, hab]))
  mul_assoc a b c := by
    induction a using Quotient.ind
    induction b using Quotient.ind
    induction c using Quotient.ind; apply Quotient.sound
    change SMProductCoveringTriple.ImageEquivalent _ _
    simp only [SMProductCoveringTriple.ImageEquivalent,
               smMap_hom_mul, mul_assoc]
  one_mul a := by
    induction a using Quotient.ind; apply Quotient.sound
    change SMProductCoveringTriple.ImageEquivalent _ _
    simp only [SMProductCoveringTriple.ImageEquivalent,
               smMap_hom_mul, smMap_hom_one, one_mul]
  mul_one a := by
    induction a using Quotient.ind; apply Quotient.sound
    change SMProductCoveringTriple.ImageEquivalent _ _
    simp only [SMProductCoveringTriple.ImageEquivalent,
               smMap_hom_mul, smMap_hom_one, mul_one]
  inv_mul_cancel a := by
    induction a using Quotient.ind; apply Quotient.sound
    change SMProductCoveringTriple.ImageEquivalent _ _
    simp only [SMProductCoveringTriple.ImageEquivalent,
               smMap_hom_mul, smMap_hom_inv, smMap_hom_one,
               inv_mul_cancel]

/-! ## Descended map -/

/-- The map from `SMProductCoveringQuotient` to `SMBlockUnitsSubgroup`,
descended from `smProductCoveringTripleToSMBlockUnits`. -/
noncomputable def smProductCoveringQuotientToSMBlockUnits :
    SMProductCoveringQuotient →* SMBlockUnitsSubgroup where
  toFun := Quotient.lift smProductCoveringTripleToSMBlockUnits
    (fun _ _ h => h)
  map_one' := smMap_hom_one
  map_mul' a b := by
    induction a using Quotient.ind
    induction b using Quotient.ind
    exact smMap_hom_mul _ _

/-! ## Injectivity -/

/-- The descended map is injective by construction. -/
theorem smProductCoveringQuotientToSMBlockUnits_injective :
    Function.Injective
      smProductCoveringQuotientToSMBlockUnits := by
  intro a b hab
  induction a using Quotient.ind
  induction b using Quotient.ind
  exact Quotient.sound hab

/-! ## Sixth root lemma -/

/-- Every unit complex number has a sixth root on the unit circle. -/
theorem exists_sixth_root_of_norm_one
    {z : ℂ} (hz : ‖z‖ = 1) :
    ∃ α : ℂ, ‖α‖ = 1 ∧ α ^ 6 = z := by
  obtain ⟨θ, hθ⟩ : ∃ θ : ℝ, z = Complex.exp (θ * Complex.I) := by
    rw [← Complex.norm_mul_exp_arg_mul_I z]; aesop
  exact ⟨Complex.exp (θ / 6 * Complex.I),
    by norm_num [Complex.norm_exp],
    by rw [hθ, ← Complex.exp_nat_mul]; ring⟩

/-! ## Surjectivity helpers -/

/-- The norm of the determinant of a unitary matrix is 1. -/
theorem norm_det_of_isUnitary
    {n : Type*} [Fintype n] [DecidableEq n]
    {M : Matrix n n ℂ} (hM : IsUnitary M) : ‖M.det‖ = 1 := by
  have := congr_arg Matrix.det hM
  norm_num at this
  rw [← sq_eq_sq₀] <;>
    norm_num [Complex.normSq_apply, Complex.sq_norm]
  simp_all +decide [Complex.ext_iff]

/-- Multiplication by a norm-one scalar preserves unitarity. -/
theorem isUnitary_smul_of_norm_one
    {n : Type*} [Fintype n] [DecidableEq n]
    {z : ℂ} (hz : ‖z‖ = 1)
    {M : Matrix n n ℂ} (hM : IsUnitary M) :
    IsUnitary (z • M) := by
  convert isUnitary_mul (isUnitary_smul_one hz) hM using 1 <;>
    (ext i j; simp +decide [Matrix.mul_apply, Matrix.smul_eq_diagonal_mul]; ring) <;>
    simp +decide [Matrix.diagonal]

/-- A nonzero complex number with unit norm gives a unit of ℂ. -/
noncomputable def unitsOfNormOne
    {z : ℂ} (hz : ‖z‖ = 1) : Units ℂ :=
  Units.mk0 z (by intro h; simp [h] at hz)

@[simp] theorem unitsOfNormOne_val
    {z : ℂ} (hz : ‖z‖ = 1) :
    (unitsOfNormOne hz : ℂ) = z := rfl

/-! ## Surjectivity -/

/-- Every element of `SMBlockUnitsSubgroup` is in the image of the
descended quotient map. The key step is extracting a sixth root of
`det(A)` on the unit circle to decompose `(A, B)` into a phase and
special-unitary parts. -/
theorem smProductCoveringQuotientToSMBlockUnits_surjective :
    Function.Surjective
      smProductCoveringQuotientToSMBlockUnits := by
  intro U
  obtain ⟨A, B, hAB⟩ :
      ∃ A : Matrix (Fin 2) (Fin 2) ℂ,
      ∃ B : Matrix (Fin 3) (Fin 3) ℂ,
        U.val.val = fromBlocks A 0 0 B ∧
        IsUnitary A ∧ IsUnitary B ∧ A.det * B.det = 1 := by
    rcases U with ⟨U, hU⟩
    rcases hU with ⟨A, B, hA, hB, h_det⟩
    exact ⟨A, B, hA, hB, h_det⟩
  obtain ⟨α, hα⟩ :
      ∃ α : ℂ, ‖α‖ = 1 ∧ α ^ 6 = A.det :=
    exists_sixth_root_of_norm_one (norm_det_of_isUnitary hAB.2.1)
  obtain ⟨phaseUnit, hphaseUnit⟩ :
      ∃ phaseUnit : Units ℂ,
        ‖(phaseUnit : ℂ)‖ = 1 ∧ (phaseUnit : ℂ) ^ 6 = A.det := by
    exact ⟨Units.mk0 α (by aesop_cat), hα.1, hα.2⟩
  obtain ⟨su2Unit, hsu2Unit⟩ :
      ∃ su2Unit : Units (Matrix (Fin 2) (Fin 2) ℂ),
        su2Unit.val = (phaseUnit⁻¹ ^ 3 : ℂ) • A ∧
        IsUnitary su2Unit.val := by
    have hsu2 : IsUnitary ((phaseUnit⁻¹ ^ 3 : ℂ) • A) := by
      convert isUnitary_smul_of_norm_one _ hAB.2.1 using 1
      simp +decide [hphaseUnit.1]
    exact ⟨unitOfIsUnitary hsu2, rfl, hsu2⟩
  obtain ⟨su3Unit, hsu3Unit⟩ :
      ∃ su3Unit : Units (Matrix (Fin 3) (Fin 3) ℂ),
        su3Unit.val = (phaseUnit ^ 2 : ℂ) • B ∧
        IsUnitary su3Unit.val := by
    refine ⟨unitOfIsUnitary ?_, rfl, ?_⟩ <;>
      exact isUnitary_smul_of_norm_one
        (by simp [hphaseUnit.1]) hAB.2.2.1
  use ⟦⟨⟨phaseUnit, su2Unit, su3Unit⟩,
    hphaseUnit.left, hsu2Unit.right, hsu3Unit.right, by
      simp_all +decide
      grind⟩⟧
  generalize_proofs at *
  ext
  simp [smProductCoveringQuotientToSMBlockUnits,
        smProductCoveringTripleToSMBlockUnits]
  simp_all +decide [UnitCoveringTriple.image]

/-! ## Multiplicative equivalence -/

/-- The quotient is multiplicatively equivalent to
`SMBlockUnitsSubgroup`. -/
noncomputable def smProductCoveringQuotientMulEquivSMBlockUnits :
    MulEquiv SMProductCoveringQuotient SMBlockUnitsSubgroup :=
  MulEquiv.ofBijective smProductCoveringQuotientToSMBlockUnits
    ⟨smProductCoveringQuotientToSMBlockUnits_injective,
     smProductCoveringQuotientToSMBlockUnits_surjective⟩

/-! ## Bundled package -/

/-- Bundled record of the quotient equivalence. -/
structure StandardModelProductCoveringQuotientSMBlockPackage where
  /-- The multiplicative equivalence. -/
  quotient_equiv_sm_block :
    MulEquiv SMProductCoveringQuotient SMBlockUnitsSubgroup

/-- The canonical package. -/
noncomputable def standardModelProductCoveringQuotientSMBlockPackage :
    StandardModelProductCoveringQuotientSMBlockPackage :=
  { quotient_equiv_sm_block :=
      smProductCoveringQuotientMulEquivSMBlockUnits }

end PhysicsSM.Gauge.StandardModelSubgroup
