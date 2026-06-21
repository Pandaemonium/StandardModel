import Mathlib
import PhysicsSM.Gauge.StandardModelProductCoveringTriple
import PhysicsSM.Gauge.StandardModelCoveringMapSurjective
import PhysicsSM.Gauge.StandardModelBlockSubgroupMulEquiv

/-!
# Gauge.StandardModelProductCoveringTrueQuotientSMBlock

Quotient of the **true** product-covering domain `U(1) × SU(2) × SU(3)`
(with individually determinant-one matrix parts) by image equivalence,
and its multiplicative equivalence with `SMBlockUnitsSubgroup`.

## Mathematical context

The covering homomorphism `ι : U(1) × SU(2) × SU(3) → S(U(2) × U(3))`
sends `(α, g, h)` to `(α³ · g, α⁻² · h)`. This module works with the
**true restricted domain** `SMProductCoveringTriple` where each matrix part
is separately unitary with determinant one (as opposed to `SMCoveringTriple`,
which only constrains the product of determinants).

## Main declarations

* `smTrueProductCoveringTripleToSMBlockUnits` — map to `SMBlockUnitsSubgroup`.
* `SMProductCoveringTriple.TrueImageEquivalent` — image equivalence relation.
* `SMProductCoveringTriple.trueImageSetoid` — the setoid.
* `SMTrueProductCoveringQuotient` — the quotient type.
* `Group SMTrueProductCoveringQuotient` — group instance on the quotient.
* `smTrueProductCoveringQuotientToSMBlockUnits` — descended monoid hom.
* `smTrueProductCoveringQuotientToSMBlockUnits_injective` — injectivity.
* `smTrueProductCoveringQuotientToSMBlockUnits_surjective` — surjectivity.
* `smTrueProductCoveringQuotientMulEquivSMBlockUnits` — the `MulEquiv`.
* `StandardModelTrueProductCoveringQuotientSMBlockPackage` — bundled record.

## Claim boundary

This is an algebraic quotient theorem. It does not prove a topological
quotient, smooth Lie group isomorphism, compactness, connectedness, or
physical dynamics.

Status: trusted — no s o r r y.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.GUTSquare PhysicsSM.Gauge.BlockEmbeddings

/-! ## Map to SMBlockUnitsSubgroup -/

/-- Send a true `SMProductCoveringTriple` to `SMBlockUnitsSubgroup`. -/
noncomputable def smTrueProductCoveringTripleToSMBlockUnits
    (x : SMProductCoveringTriple) : SMBlockUnitsSubgroup :=
  ⟨unitOfIsUnitary (isUnitary_fromBlocks
    x.toSMCoveringTriple.image.1.val x.toSMCoveringTriple.image.2.val
    (smCoveringTriple_image_fst_unitary x.toSMCoveringTriple)
    (smCoveringTriple_image_snd_unitary x.toSMCoveringTriple)),
   x.image_satisfiesSMBlock⟩

/-! ## Image equivalence and quotient -/

/-- Two true product-covering triples are equivalent when they map to the
same block unit. -/
def SMProductCoveringTriple.TrueImageEquivalent
    (x y : SMProductCoveringTriple) : Prop :=
  smTrueProductCoveringTripleToSMBlockUnits x =
    smTrueProductCoveringTripleToSMBlockUnits y

instance SMProductCoveringTriple.trueImageSetoid :
    Setoid SMProductCoveringTriple where
  r := SMProductCoveringTriple.TrueImageEquivalent
  iseqv := ⟨fun _ => rfl, fun h => h.symm, fun h₁ h₂ => h₁.trans h₂⟩

/-- The quotient of `SMProductCoveringTriple` by image equivalence. -/
abbrev SMTrueProductCoveringQuotient :=
  Quotient SMProductCoveringTriple.trueImageSetoid

/-! ## True-product operations as SMCoveringTriple operations -/

/-- Product of two true product-covering triples, forwarded through SMCoveringTriple. -/
noncomputable def SMProductCoveringTriple.trueMul
    (x y : SMProductCoveringTriple) : SMProductCoveringTriple where
  phase := x.phase * y.phase
  phase_norm_one := by
    rw [Units.val_mul, norm_mul, x.phase_norm_one, y.phase_norm_one, mul_one]
  su2Part := x.su2Part * y.su2Part
  su3Part := x.su3Part * y.su3Part

/-- The identity true product-covering triple. -/
noncomputable def SMProductCoveringTriple.trueOne :
    SMProductCoveringTriple where
  phase := 1
  phase_norm_one := by simp [Units.val_one]
  su2Part := 1
  su3Part := 1

/-- Inverse of a true product-covering triple. -/
noncomputable def SMProductCoveringTriple.trueInv
    (x : SMProductCoveringTriple) : SMProductCoveringTriple where
  phase := x.phase⁻¹
  phase_norm_one := by simp [norm_inv, x.phase_norm_one]
  su2Part := x.su2Part⁻¹
  su3Part := x.su3Part⁻¹

/-! ## Relating trueMul / trueOne / trueInv to toSMCoveringTriple -/

private theorem trueMul_toSMCoveringTriple (x y : SMProductCoveringTriple) :
    (x.trueMul y).toSMCoveringTriple.toUnitCoveringTriple =
      x.toSMCoveringTriple.toUnitCoveringTriple *
        y.toSMCoveringTriple.toUnitCoveringTriple := by
  ext <;> simp [SMProductCoveringTriple.trueMul, SMProductCoveringTriple.toSMCoveringTriple]

private theorem trueOne_toSMCoveringTriple :
    SMProductCoveringTriple.trueOne.toSMCoveringTriple.toUnitCoveringTriple =
      (1 : UnitCoveringTriple) := by
  ext <;> simp [SMProductCoveringTriple.trueOne, SMProductCoveringTriple.toSMCoveringTriple]

private theorem trueInv_toSMCoveringTriple (x : SMProductCoveringTriple) :
    x.trueInv.toSMCoveringTriple.toUnitCoveringTriple =
      x.toSMCoveringTriple.toUnitCoveringTriple⁻¹ := by
  ext <;> simp [SMProductCoveringTriple.trueInv, SMProductCoveringTriple.toSMCoveringTriple]

/-! ## Map is a homomorphism -/

private theorem trueSmMap_image_mul (x y : SMProductCoveringTriple) :
    (x.trueMul y).toSMCoveringTriple.toUnitCoveringTriple.image =
      x.toSMCoveringTriple.toUnitCoveringTriple.image *
        y.toSMCoveringTriple.toUnitCoveringTriple.image := by
  rw [trueMul_toSMCoveringTriple, UnitCoveringTriple.image_mul]

private theorem trueSmMap_image_one :
    SMProductCoveringTriple.trueOne.toSMCoveringTriple.toUnitCoveringTriple.image = 1 := by
  rw [trueOne_toSMCoveringTriple, UnitCoveringTriple.image_one]

private theorem trueSmMap_image_inv (x : SMProductCoveringTriple) :
    x.trueInv.toSMCoveringTriple.toUnitCoveringTriple.image =
      x.toSMCoveringTriple.toUnitCoveringTriple.image⁻¹ := by
  rw [trueInv_toSMCoveringTriple, UnitCoveringTriple.image_inv]

/-- The map to `SMBlockUnitsSubgroup` is multiplicative. -/
private theorem trueSmMap_hom_mul (x y : SMProductCoveringTriple) :
    smTrueProductCoveringTripleToSMBlockUnits (x.trueMul y) =
      smTrueProductCoveringTripleToSMBlockUnits x *
        smTrueProductCoveringTripleToSMBlockUnits y := by
  ext
  unfold smTrueProductCoveringTripleToSMBlockUnits
  simp +decide [trueSmMap_image_mul, fromBlocks_mul_zero_off_diag]

/-- The map sends `trueOne` to `1`. -/
private theorem trueSmMap_hom_one :
    smTrueProductCoveringTripleToSMBlockUnits
      SMProductCoveringTriple.trueOne = 1 := by
  ext
  unfold smTrueProductCoveringTripleToSMBlockUnits
  simp +decide [SMProductCoveringTriple.trueOne, SMProductCoveringTriple.toSMCoveringTriple,
    UnitCoveringTriple.image, SUUnitMatrix.one_unit]

/-- The map sends `trueInv` to inverse. -/
private theorem trueSmMap_hom_inv (x : SMProductCoveringTriple) :
    smTrueProductCoveringTripleToSMBlockUnits x.trueInv =
      (smTrueProductCoveringTripleToSMBlockUnits x)⁻¹ := by
  refine eq_inv_of_mul_eq_one_left ?_
  rw [← trueSmMap_hom_mul]
  rw [show x.trueInv.trueMul x = SMProductCoveringTriple.trueOne from by
    unfold SMProductCoveringTriple.trueInv
      SMProductCoveringTriple.trueMul SMProductCoveringTriple.trueOne
    aesop]
  exact trueSmMap_hom_one

/-! ## Group structure on the quotient -/

noncomputable instance : Group SMTrueProductCoveringQuotient where
  one := ⟦SMProductCoveringTriple.trueOne⟧
  mul := Quotient.lift₂
    (fun x y => (⟦x.trueMul y⟧ : SMTrueProductCoveringQuotient))
    (fun _ _ _ _ hab hcd => Quotient.sound (by
      change SMProductCoveringTriple.TrueImageEquivalent _ _
      simp only [SMProductCoveringTriple.TrueImageEquivalent] at *
      rw [trueSmMap_hom_mul, trueSmMap_hom_mul, hab, hcd]))
  inv := Quotient.lift
    (fun x => (⟦x.trueInv⟧ : SMTrueProductCoveringQuotient))
    (fun _ _ hab => Quotient.sound (by
      change SMProductCoveringTriple.TrueImageEquivalent _ _
      simp only [SMProductCoveringTriple.TrueImageEquivalent] at *
      rw [trueSmMap_hom_inv, trueSmMap_hom_inv, hab]))
  mul_assoc a b c := by
    induction a using Quotient.ind
    induction b using Quotient.ind
    induction c using Quotient.ind; apply Quotient.sound
    change SMProductCoveringTriple.TrueImageEquivalent _ _
    simp only [SMProductCoveringTriple.TrueImageEquivalent,
               trueSmMap_hom_mul, mul_assoc]
  one_mul a := by
    induction a using Quotient.ind; apply Quotient.sound
    change SMProductCoveringTriple.TrueImageEquivalent _ _
    simp only [SMProductCoveringTriple.TrueImageEquivalent,
               trueSmMap_hom_mul, trueSmMap_hom_one, one_mul]
  mul_one a := by
    induction a using Quotient.ind; apply Quotient.sound
    change SMProductCoveringTriple.TrueImageEquivalent _ _
    simp only [SMProductCoveringTriple.TrueImageEquivalent,
               trueSmMap_hom_mul, trueSmMap_hom_one, mul_one]
  inv_mul_cancel a := by
    induction a using Quotient.ind; apply Quotient.sound
    change SMProductCoveringTriple.TrueImageEquivalent _ _
    simp only [SMProductCoveringTriple.TrueImageEquivalent,
               trueSmMap_hom_mul, trueSmMap_hom_inv, trueSmMap_hom_one,
               inv_mul_cancel]

/-! ## Descended map -/

/-- The map from `SMTrueProductCoveringQuotient` to `SMBlockUnitsSubgroup`,
descended from `smTrueProductCoveringTripleToSMBlockUnits`. -/
noncomputable def smTrueProductCoveringQuotientToSMBlockUnits :
    SMTrueProductCoveringQuotient →* SMBlockUnitsSubgroup where
  toFun := Quotient.lift smTrueProductCoveringTripleToSMBlockUnits
    (fun _ _ h => h)
  map_one' := trueSmMap_hom_one
  map_mul' a b := by
    induction a using Quotient.ind
    induction b using Quotient.ind
    exact trueSmMap_hom_mul _ _

/-! ## Injectivity -/

/-- The descended map is injective by construction. -/
theorem smTrueProductCoveringQuotientToSMBlockUnits_injective :
    Function.Injective
      smTrueProductCoveringQuotientToSMBlockUnits := by
  intro a b hab
  induction a using Quotient.ind
  induction b using Quotient.ind
  exact Quotient.sound hab

/-! ## Sixth root lemma -/

/-- Every unit complex number has a sixth root on the unit circle. -/
private theorem exists_sixth_root_of_norm_one'
    {z : ℂ} (hz : ‖z‖ = 1) :
    ∃ α : ℂ, ‖α‖ = 1 ∧ α ^ 6 = z := by
  obtain ⟨θ, hθ⟩ : ∃ θ : ℝ, z = Complex.exp (θ * Complex.I) := by
    rw [← Complex.norm_mul_exp_arg_mul_I z]; aesop
  exact ⟨Complex.exp (θ / 6 * Complex.I),
    by norm_num [Complex.norm_exp],
    by rw [hθ, ← Complex.exp_nat_mul]; ring⟩

/-! ## Surjectivity helpers -/

/-- The norm of the determinant of a unitary matrix is 1. -/
private theorem norm_det_of_isUnitary'
    {n : Type*} [Fintype n] [DecidableEq n]
    {M : Matrix n n ℂ} (hM : IsUnitary M) : ‖M.det‖ = 1 := by
  have := congr_arg Matrix.det hM
  norm_num at this
  rw [← sq_eq_sq₀] <;>
    norm_num [Complex.normSq_apply, Complex.sq_norm]
  simp_all +decide [Complex.ext_iff]

/-- Multiplication by a norm-one scalar preserves unitarity. -/
private theorem isUnitary_smul_of_norm_one'
    {n : Type*} [Fintype n] [DecidableEq n]
    {z : ℂ} (hz : ‖z‖ = 1)
    {M : Matrix n n ℂ} (hM : IsUnitary M) :
    IsUnitary (z • M) := by
  convert isUnitary_mul (isUnitary_smul_one hz) hM using 1 <;>
    (ext i j; simp +decide [Matrix.mul_apply, Matrix.smul_eq_diagonal_mul]; ring) <;>
    simp +decide [Matrix.diagonal]

/-! ## Surjectivity -/

/-
Every element of `SMBlockUnitsSubgroup` is in the image of the
descended quotient map. The key step is extracting a sixth root of
`det(A)` on the unit circle and then showing the resulting
`(α⁻³ A, α² B)` parts are individually determinant-one and unitary.
-/
theorem smTrueProductCoveringQuotientToSMBlockUnits_surjective :
    Function.Surjective
      smTrueProductCoveringQuotientToSMBlockUnits := by
  intro U;
  obtain ⟨A, B, hA, hB, h_det⟩ : ∃ A : Matrix (Fin 2) (Fin 2) ℂ, ∃ B : Matrix (Fin 3) (Fin 3) ℂ, IsUnitary A ∧ IsUnitary B ∧ A.det * B.det = 1 ∧ fromBlocks A 0 0 B = U.val.val := by
    obtain ⟨A, B, hA, hB, h_det⟩ : ∃ A : Matrix (Fin 2) (Fin 2) ℂ, ∃ B : Matrix (Fin 3) (Fin 3) ℂ, fromBlocks A 0 0 B = U.val ∧ IsUnitary A ∧ IsUnitary B ∧ A.det * B.det = 1 := by
      have := U.2;
      obtain ⟨ A, B, h ⟩ := this;
      exact ⟨ A, B, h.1.symm, h.2 ⟩;
    exact ⟨ A, B, hB, h_det.1, h_det.2, hA ⟩;
  have h_det_A : ‖A.det‖ = 1 := by
    grind +suggestions
  have h_det_B : ‖B.det‖ = 1 := by
    grind +suggestions;
  -- Use the existence of α to construct the SMProductCoveringTriple.
  obtain ⟨α, hα⟩ : ∃ α : ℂ, ‖α‖ = 1 ∧ α ^ 6 = A.det := exists_sixth_root_of_norm_one' h_det_A;
  -- Define the SMProductCoveringTriple with the given α.
  obtain ⟨x, hx⟩ : ∃ x : SMProductCoveringTriple, x.toSMCoveringTriple.toUnitCoveringTriple.image = (unitOfIsUnitary hA, unitOfIsUnitary hB) := by
    refine' ⟨ ⟨ Units.mk0 α ( by aesop_cat ), _, _, _ ⟩, _ ⟩ <;> norm_num [ hα ];
    exact ⟨ unitOfIsUnitary ( isUnitary_smul_of_norm_one' ( show ‖α⁻¹ ^ 3‖ = 1 from by simp +decide [ hα.1, norm_pow ] ) hA ), by
                                                              exact isUnitary_smul_of_norm_one' ( show ‖α⁻¹ ^ 3‖ = 1 from by simp +decide [ hα.1, norm_pow ] ) hA, by
                                                              simp +decide [ unitOfIsUnitary, hα.2 ];
                                                              rw [ ← pow_mul, hα.2, inv_mul_cancel₀ ( by aesop_cat ) ] ⟩
    exact ⟨ unitOfIsUnitary ( isUnitary_smul_of_norm_one' ( show ‖α ^ 2‖ = 1 from by simp +decide [ hα.1, norm_pow ] ) hB ), by
                                                              exact isUnitary_smul_of_norm_one' ( show ‖α ^ 2‖ = 1 from by simp +decide [ hα.1, norm_pow ] ) hB, by
                                                              simp +decide [ unitOfIsUnitary, hα.2 ];
                                                              linear_combination' hα.2 * B.det + h_det.1 ⟩
    generalize_proofs at *;
    ext <;> simp +decide [ *, UnitCoveringTriple.image ];
  use ⟦x⟧;
  ext; simp [hx, smTrueProductCoveringQuotientToSMBlockUnits];
  unfold smTrueProductCoveringTripleToSMBlockUnits; simp_all +decide [ SMProductCoveringTriple.toSMCoveringTriple ] ;

/-! ## Multiplicative equivalence -/

/-- The quotient is multiplicatively equivalent to
`SMBlockUnitsSubgroup`. -/
noncomputable def smTrueProductCoveringQuotientMulEquivSMBlockUnits :
    MulEquiv SMTrueProductCoveringQuotient SMBlockUnitsSubgroup :=
  MulEquiv.ofBijective smTrueProductCoveringQuotientToSMBlockUnits
    ⟨smTrueProductCoveringQuotientToSMBlockUnits_injective,
     smTrueProductCoveringQuotientToSMBlockUnits_surjective⟩

/-! ## Bundled package -/

/-- Bundled record of the true product-covering quotient equivalence. -/
structure StandardModelTrueProductCoveringQuotientSMBlockPackage where
  /-- The multiplicative equivalence. -/
  quotient_equiv_sm_block :
    MulEquiv SMTrueProductCoveringQuotient SMBlockUnitsSubgroup

/-- The canonical package. -/
noncomputable def standardModelTrueProductCoveringQuotientSMBlockPackage :
    StandardModelTrueProductCoveringQuotientSMBlockPackage :=
  { quotient_equiv_sm_block :=
      smTrueProductCoveringQuotientMulEquivSMBlockUnits }

end PhysicsSM.Gauge.StandardModelSubgroup
