import Mathlib

/-!
# Exact slice no-go for the chirality-coupled reciprocal walk

This module proves exact determinant factorizations and physical unit-circle
crossing existentials for one chirality-coupled reciprocal walk.  The final
result is an architecture-level no-go: it does not rule out enlarged-register
or otherwise modified reciprocal constructions.

The matrices use the repository convention
`alpha3 = sigma_x tensor sigma_z`, `Xi = sigma_x tensor I`. The coupled
generator anticommutes with `Xi`; the conditional shift acts on the second
tensor factor. The slice is `q_x = pi`, `q_y = 0`, with `z = exp(i q_z)`.

The two final theorems are the manuscript consequence: this exact-unitary,
quadratically-flat, chirality-coupled reciprocal architecture has additional
zero- and pi-quasienergy crossings and therefore is not alias-free.

Proof provenance: Aristotle project
`06fe540d-54ff-423e-8595-fceeb9b54ee0`, integrated and semantically reviewed
on 2026-07-11.  The proof is exact over Gaussian rationals and real analysis;
no sampled or approximate crossing claim is used.
-/

open Matrix Complex

noncomputable section

namespace PhysicsSM.Draft.NullEdge.CoupledReciprocalSliceNoGo

abbrev M4 := Matrix (Fin 4) (Fin 4) Complex

def alpha3 : M4 :=
  !![0, 0, 1, 0;
     0, 0, 0, -1;
     1, 0, 0, 0;
     0, -1, 0, 0]

def Xi : M4 :=
  !![0, 0, 1, 0;
     0, 0, 0, 1;
     1, 0, 0, 0;
     0, 1, 0, 0]

def coupledGenerator : M4 :=
  !![0, 1, 0, 0;
     1, 0, 0, 0;
     0, 0, 0, -1;
     0, 0, -1, 0]

def coupledCoin : M4 :=
  (3 / 5 : Complex) • 1 + (I * (4 / 5 : Complex)) • coupledGenerator

def coupledCoinInv : M4 :=
  (3 / 5 : Complex) • 1 - (I * (4 / 5 : Complex)) • coupledGenerator

def conditionalShift4 (z : Complex) : M4 :=
  !![z, 0, 0, 0;
     0, 1, 0, 0;
     0, 0, z, 0;
     0, 0, 0, 1]

def coupledCommutator (z : Complex) : M4 :=
  conditionalShift4 z * coupledCoin * conditionalShift4 z⁻¹ * coupledCoinInv

def coupledReciprocal (z : Complex) : M4 :=
  coupledCommutator z * coupledCommutator z⁻¹

def axis3LaurentFactor (z : Complex) : M4 :=
  ((z + z⁻¹) / 2) • 1 - ((z - z⁻¹) / 2) • alpha3

/-- The complete candidate restricted to `q_x=pi`, `q_y=0`. -/
def sliceWalk (z : Complex) : M4 :=
  -(coupledReciprocal (-1) * coupledReciprocal z * axis3LaurentFactor z)

def positiveQuartic (z : Complex) : Complex :=
  11376 * z ^ 4 + 143521 * z ^ 3 - 187294 * z ^ 2 + 143521 * z + 11376

def negativeQuartic (z : Complex) : Complex :=
  11376 * z ^ 4 - 637729 * z ^ 3 - 187294 * z ^ 2 - 637729 * z + 11376

def positiveReduced (x : Real) : Real :=
  11376 * x ^ 2 + 143521 * x - 210046

def negativeReduced (x : Real) : Real :=
  11376 * x ^ 2 - 637729 * x - 210046

/-! ## Auxiliary closed forms (derived over exact Gaussian rationals). -/

/-- Powers of `I` beyond the square, used to close ring goals. -/
private lemma I_cube : (I : Complex) ^ 3 = -I := by
  rw [pow_succ, Complex.I_sq]; ring

private lemma I_quartic : (I : Complex) ^ 4 = 1 := by
  rw [show (4 = 2 + 2) from rfl, pow_add, Complex.I_sq]; ring

private lemma fin4_mk2 (h : 2 < 4) : (⟨2, h⟩ : Fin 4) = 2 := rfl
private lemma fin4_mk3 (h : 3 < 4) : (⟨3, h⟩ : Fin 4) = 3 := rfl

/-- Concrete form of the coupled coin. -/
def coinMat : M4 :=
  !![3/5, I*(4/5), 0, 0;
     I*(4/5), 3/5, 0, 0;
     0, 0, 3/5, -(I*(4/5));
     0, 0, -(I*(4/5)), 3/5]

/-- Concrete form of the inverse coupled coin. -/
def coinInvMat : M4 :=
  !![3/5, -(I*(4/5)), 0, 0;
     -(I*(4/5)), 3/5, 0, 0;
     0, 0, 3/5, I*(4/5);
     0, 0, I*(4/5), 3/5]

/-- Numerator matrix of the conjugated coin commutator: `coupledCommutator z = (25 z)⁻¹ • commNum z`. -/
def commNum (z : Complex) : M4 :=
  !![(16*z^2 + 9*z), (12*I*z^2 - 12*I*z), 0, 0;
     (-12*I*z + 12*I), (9*z + 16), 0, 0;
     0, 0, (16*z^2 + 9*z), (-12*I*z^2 + 12*I*z);
     0, 0, (12*I*z - 12*I), (9*z + 16)]

/-- Numerator matrix of the reciprocal walk: `coupledReciprocal z = (625 z²)⁻¹ • recipNum z`. -/
def recipNum (z : Complex) : M4 :=
  !![(-144*z^4 + 432*z^3 + 193*z^2 + 144*z), (192*I*z^4 - 276*I*z^3 - 24*I*z^2 + 108*I*z), 0, 0;
     (108*I*z^3 - 24*I*z^2 - 276*I*z + 192*I), (144*z^3 + 193*z^2 + 432*z - 144), 0, 0;
     0, 0, (-144*z^4 + 432*z^3 + 193*z^2 + 144*z), (-192*I*z^4 + 276*I*z^3 + 24*I*z^2 - 108*I*z);
     0, 0, (-108*I*z^3 + 24*I*z^2 + 276*I*z - 192*I), (144*z^3 + 193*z^2 + 432*z - 144)]

/-- Numerator matrix of the slice walk: `sliceWalk z = (781250 z³)⁻¹ • sliceNum z`. -/
def sliceNum (z : Complex) : M4 :=
  !![(-75888*z^6 + 263952*z^5 + 17759*z^4 + 247104*z^3 + 158159*z^2 - 16848*z + 64512), (101184*I*z^6 - 193836*I*z^5 + 23688*I*z^4 - 282072*I*z^3 - 29112*I*z^2 - 88236*I*z + 48384*I), (75888*z^6 - 263952*z^5 - 169535*z^4 + 280800*z^3 + 29135*z^2 - 16848*z + 64512), (101184*I*z^6 - 193836*I*z^5 - 178680*I*z^4 + 105600*I*z^3 + 125880*I*z^2 + 88236*I*z - 48384*I);
     (48384*I*z^6 - 88236*I*z^5 - 29112*I*z^4 - 282072*I*z^3 + 23688*I*z^2 - 193836*I*z + 101184*I), (64512*z^6 - 16848*z^5 + 158159*z^4 + 247104*z^3 + 17759*z^2 + 263952*z - 75888), (-48384*I*z^6 + 88236*I*z^5 + 125880*I*z^4 + 105600*I*z^3 - 178680*I*z^2 - 193836*I*z + 101184*I), (64512*z^6 - 16848*z^5 + 29135*z^4 + 280800*z^3 - 169535*z^2 - 263952*z + 75888);
     (75888*z^6 - 263952*z^5 - 169535*z^4 + 280800*z^3 + 29135*z^2 - 16848*z + 64512), (-101184*I*z^6 + 193836*I*z^5 + 178680*I*z^4 - 105600*I*z^3 - 125880*I*z^2 - 88236*I*z + 48384*I), (-75888*z^6 + 263952*z^5 + 17759*z^4 + 247104*z^3 + 158159*z^2 - 16848*z + 64512), (-101184*I*z^6 + 193836*I*z^5 - 23688*I*z^4 + 282072*I*z^3 + 29112*I*z^2 + 88236*I*z - 48384*I);
     (48384*I*z^6 - 88236*I*z^5 - 125880*I*z^4 - 105600*I*z^3 + 178680*I*z^2 + 193836*I*z - 101184*I), (64512*z^6 - 16848*z^5 + 29135*z^4 + 280800*z^3 - 169535*z^2 - 263952*z + 75888), (-48384*I*z^6 + 88236*I*z^5 + 29112*I*z^4 + 282072*I*z^3 - 23688*I*z^2 + 193836*I*z - 101184*I), (64512*z^6 - 16848*z^5 + 158159*z^4 + 247104*z^3 + 17759*z^2 + 263952*z - 75888)]

private lemma coupledCoin_eq : coupledCoin = coinMat := by
  simp only [coupledCoin, coupledGenerator, coinMat]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four, Matrix.one_apply]

private lemma coupledCoinInv_eq : coupledCoinInv = coinInvMat := by
  simp only [coupledCoinInv, coupledGenerator, coinInvMat]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four, Matrix.one_apply]

set_option maxHeartbeats 4000000 in
private lemma coupledCommutator_eq (z : Complex) (hz : z ≠ 0) :
    coupledCommutator z = (25 * z)⁻¹ • commNum z := by
  rw [coupledCommutator, coupledCoin_eq, coupledCoinInv_eq]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp only [conditionalShift4, coinMat, coinInvMat, commNum,
      Matrix.mul_apply, Fin.sum_univ_four, Matrix.smul_apply, smul_eq_mul,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
      Matrix.cons_val_fin_one, Matrix.of_apply, Fin.isValue, Matrix.cons_val',
      Matrix.empty_val', Fin.mk_zero, Fin.mk_one, Matrix.cons_val, Matrix.head_fin_const] <;>
    norm_num <;>
    (field_simp; ring_nf; try (rw [Complex.I_sq]; ring))

set_option maxHeartbeats 4000000 in
private lemma coupledReciprocal_eq (z : Complex) (hz : z ≠ 0) :
    coupledReciprocal z = (625 * z ^ 2)⁻¹ • recipNum z := by
  rw [coupledReciprocal, coupledCommutator_eq z hz,
    coupledCommutator_eq z⁻¹ (inv_ne_zero hz)]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp only [commNum, recipNum,
      Matrix.mul_apply, Fin.sum_univ_four, Matrix.smul_apply, smul_eq_mul,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
      Matrix.cons_val_fin_one, Matrix.of_apply, Fin.isValue, Matrix.cons_val',
      Matrix.empty_val', Fin.mk_zero, Fin.mk_one, Matrix.cons_val, Matrix.head_fin_const] <;>
    norm_num <;>
    (field_simp; ring_nf; try (rw [Complex.I_sq]; ring))

set_option maxHeartbeats 8000000 in
private lemma sliceWalk_eq (z : Complex) (hz : z ≠ 0) :
    sliceWalk z = (781250 * z ^ 3)⁻¹ • sliceNum z := by
  rw [sliceWalk, coupledReciprocal_eq (-1) (by norm_num), coupledReciprocal_eq z hz]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp only [recipNum, axis3LaurentFactor, alpha3, sliceNum,
      Matrix.mul_apply, Fin.sum_univ_four, Matrix.smul_apply, Matrix.neg_apply,
      Matrix.sub_apply, Matrix.add_apply, Matrix.one_apply, smul_eq_mul,
      Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
      Matrix.cons_val_fin_one, Matrix.of_apply, Fin.isValue, Matrix.cons_val',
      Matrix.empty_val', Fin.mk_zero, Fin.mk_one, fin4_mk2, fin4_mk3,
      Matrix.cons_val, Matrix.head_fin_const] <;>
    norm_num <;>
    (try simp only [Fin.reduceEq, if_false, if_true, mul_zero, add_zero, mul_one]) <;>
    (try field_simp) <;>
    ring_nf <;>
    (try simp only [Complex.I_sq, I_cube, I_quartic]) <;>
    first | rfl | ring | ring_nf

/-! ## Determinant identities. -/

theorem generator_anticommutes_Xi :
    Xi * coupledGenerator + coupledGenerator * Xi = 0 := by
  simp only [Xi, coupledGenerator]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four, Matrix.add_apply]

theorem coupledCoin_mul_inv : coupledCoin * coupledCoinInv = 1 := by
  simp only [coupledCoin, coupledCoinInv, coupledGenerator]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four, Matrix.one_apply] <;>
    ring_nf <;> simp [Complex.I_sq] <;> ring

set_option maxHeartbeats 40000000 in
set_option maxRecDepth 6000 in
theorem sliceWalk_det (z : Complex) (hz : z ≠ 0) :
    (sliceWalk z).det = 1 := by
  rw [sliceWalk_eq z hz, Matrix.det_succ_row_zero]
  simp only [Fin.sum_univ_four, Matrix.det_fin_three, Matrix.submatrix_apply, sliceNum,
    Matrix.smul_apply, smul_eq_mul,
    Fin.succAbove, Fin.castSucc, Fin.castAdd, Fin.castLE, Fin.succ, Fin.lt_def,
    Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.head_cons, Matrix.empty_val', Matrix.cons_val_fin_one, Fin.isValue,
    Matrix.cons_val_two, Matrix.cons_val_three, Matrix.tail_cons, Matrix.head_fin_const]
  norm_num
  field_simp
  ring_nf
  simp only [Complex.I_sq, I_cube, I_quartic, Fin.reduceEq, if_false, mul_zero]
  ring

set_option maxHeartbeats 40000000 in
set_option maxRecDepth 6000 in
theorem slice_det_sub_one (z : Complex) (hz : z ≠ 0) :
    (sliceWalk z - 1).det =
      positiveQuartic z ^ 2 / (152587890625 * z ^ 4) := by
  rw [sliceWalk_eq z hz, Matrix.det_succ_row_zero]
  simp only [Fin.sum_univ_four, Matrix.det_fin_three, Matrix.submatrix_apply, sliceNum,
    positiveQuartic, Matrix.sub_apply, Matrix.one_apply, Matrix.smul_apply, smul_eq_mul,
    Fin.succAbove, Fin.castSucc, Fin.castAdd, Fin.castLE, Fin.succ, Fin.lt_def,
    Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.head_cons, Matrix.empty_val', Matrix.cons_val_fin_one, Fin.isValue,
    Matrix.cons_val_two, Matrix.cons_val_three, Matrix.tail_cons, Matrix.head_fin_const]
  norm_num
  field_simp
  ring_nf
  simp only [Complex.I_sq, I_cube, I_quartic, Fin.reduceEq, if_false, mul_zero]
  ring

set_option maxHeartbeats 40000000 in
set_option maxRecDepth 6000 in
theorem slice_det_add_one (z : Complex) (hz : z ≠ 0) :
    (sliceWalk z + 1).det =
      negativeQuartic z ^ 2 / (152587890625 * z ^ 4) := by
  rw [sliceWalk_eq z hz, Matrix.det_succ_row_zero]
  simp only [Fin.sum_univ_four, Matrix.det_fin_three, Matrix.submatrix_apply, sliceNum,
    negativeQuartic, Matrix.add_apply, Matrix.one_apply, Matrix.smul_apply, smul_eq_mul,
    Fin.succAbove, Fin.castSucc, Fin.castAdd, Fin.castLE, Fin.succ, Fin.lt_def,
    Matrix.of_apply, Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one,
    Matrix.head_cons, Matrix.empty_val', Matrix.cons_val_fin_one, Fin.isValue,
    Matrix.cons_val_two, Matrix.cons_val_three, Matrix.tail_cons, Matrix.head_fin_const]
  norm_num
  field_simp
  ring_nf
  simp only [Complex.I_sq, I_cube, I_quartic, Fin.reduceEq, if_false, mul_zero]
  ring

theorem positive_reduced_signs :
    positiveReduced 1 = -55149 ∧ positiveReduced 2 = 122500 := by
  constructor <;> norm_num [positiveReduced]

theorem negative_reduced_signs :
    negativeReduced (-1) = 439059 ∧ negativeReduced 0 = -210046 := by
  constructor <;> norm_num [negativeReduced]

theorem exists_positive_reduced_root :
    ∃ x : Real, 1 < x ∧ x < 2 ∧ positiveReduced x = 0 := by
  have hcont : ContinuousOn positiveReduced (Set.Icc 1 2) := by
    unfold positiveReduced; fun_prop
  have h1 : positiveReduced 1 < 0 := by norm_num [positiveReduced]
  have h2 : (0 : ℝ) < positiveReduced 2 := by norm_num [positiveReduced]
  have hsub : (0 : ℝ) ∈ Set.Ioo (positiveReduced 1) (positiveReduced 2) :=
    ⟨h1, h2⟩
  have := intermediate_value_Ioo (by norm_num : (1:ℝ) ≤ 2) hcont hsub
  obtain ⟨x, hx, hfx⟩ := this
  exact ⟨x, hx.1, hx.2, hfx⟩

theorem exists_negative_reduced_root :
    ∃ x : Real, -1 < x ∧ x < 0 ∧ negativeReduced x = 0 := by
  have hcont : ContinuousOn negativeReduced (Set.Icc (-1) 0) := by
    unfold negativeReduced; fun_prop
  have h1 : (0 : ℝ) < negativeReduced (-1) := by norm_num [negativeReduced]
  have h2 : negativeReduced 0 < 0 := by norm_num [negativeReduced]
  have hsub : (0 : ℝ) ∈ Set.Ioo (negativeReduced 0) (negativeReduced (-1)) :=
    ⟨h2, h1⟩
  have := intermediate_value_Ioo' (by norm_num : (-1:ℝ) ≤ 0) hcont hsub
  obtain ⟨x, hx, hfx⟩ := this
  exact ⟨x, hx.1, hx.2, hfx⟩

theorem positive_quartic_unit_circle_relation (q : Real) :
    positiveQuartic (Real.cos q + I * Real.sin q) =
      (Real.cos q + I * Real.sin q) ^ 2 •
        (positiveReduced (2 * Real.cos q) : Complex) := by
  have hpyth : (Real.cos q : Complex) ^ 2 + (Real.sin q : Complex) ^ 2 = 1 := by
    have := Real.sin_sq_add_cos_sq q
    have : (Real.sin q : Complex) ^ 2 + (Real.cos q : Complex) ^ 2 = 1 := by
      exact_mod_cast congrArg (Complex.ofReal ·) this
    linear_combination this
  simp only [positiveQuartic, positiveReduced, smul_eq_mul]
  push_cast [-Complex.ofReal_cos, -Complex.ofReal_sin]
  linear_combination
    (-34128 * (Real.cos q : Complex) ^ 2 - 45504 * (Real.cos q : Complex) * (Real.sin q : Complex) * I
        - 143521 * (Real.cos q : Complex) + 11376 * (Real.sin q : Complex) ^ 2
        - 143521 * (Real.sin q : Complex) * I - 11376) * hpyth
      + (22752 * (Real.cos q : Complex) ^ 2 * (Real.sin q : Complex) ^ 2
        + 45504 * (Real.cos q : Complex) * (Real.sin q : Complex) ^ 3 * I
        + 143521 * (Real.cos q : Complex) * (Real.sin q : Complex) ^ 2
        + 11376 * (Real.sin q : Complex) ^ 4 * I ^ 2 - 11376 * (Real.sin q : Complex) ^ 4
        + 143521 * (Real.sin q : Complex) ^ 3 * I + 22752 * (Real.sin q : Complex) ^ 2) * Complex.I_sq

theorem negative_quartic_unit_circle_relation (q : Real) :
    negativeQuartic (Real.cos q + I * Real.sin q) =
      (Real.cos q + I * Real.sin q) ^ 2 •
        (negativeReduced (2 * Real.cos q) : Complex) := by
  have hpyth : (Real.cos q : Complex) ^ 2 + (Real.sin q : Complex) ^ 2 = 1 := by
    have := Real.sin_sq_add_cos_sq q
    have : (Real.sin q : Complex) ^ 2 + (Real.cos q : Complex) ^ 2 = 1 := by
      exact_mod_cast congrArg (Complex.ofReal ·) this
    linear_combination this
  simp only [negativeQuartic, negativeReduced, smul_eq_mul]
  push_cast [-Complex.ofReal_cos, -Complex.ofReal_sin]
  linear_combination
    (-34128 * (Real.cos q : Complex) ^ 2 - 45504 * (Real.cos q : Complex) * (Real.sin q : Complex) * I
        + 637729 * (Real.cos q : Complex) + 11376 * (Real.sin q : Complex) ^ 2
        + 637729 * (Real.sin q : Complex) * I - 11376) * hpyth
      + (22752 * (Real.cos q : Complex) ^ 2 * (Real.sin q : Complex) ^ 2
        + 45504 * (Real.cos q : Complex) * (Real.sin q : Complex) ^ 3 * I
        - 637729 * (Real.cos q : Complex) * (Real.sin q : Complex) ^ 2
        + 11376 * (Real.sin q : Complex) ^ 4 * I ^ 2 - 11376 * (Real.sin q : Complex) ^ 4
        - 637729 * (Real.sin q : Complex) ^ 3 * I + 22752 * (Real.sin q : Complex) ^ 2) * Complex.I_sq

/-- The point `cos q + i sin q` on the unit circle is nonzero. -/
private lemma unit_circle_ne_zero (q : Real) :
    (Real.cos q + I * Real.sin q) ≠ 0 := by
  intro h
  have hre : Real.cos q = 0 := by
    have := congrArg Complex.re h
    simpa using this
  have him : Real.sin q = 0 := by
    have := congrArg Complex.im h
    simpa using this
  have := Real.sin_sq_add_cos_sq q
  rw [hre, him] at this
  norm_num at this

/-- Extra zero-quasienergy crossing on the exact physical unit circle. -/
theorem exists_additional_zero_crossing :
    ∃ q : Real, q ≠ 0 ∧
      (sliceWalk (Real.cos q + I * Real.sin q) - 1).det = 0 := by
  obtain ⟨x, hx1, hx2, hxr⟩ := exists_positive_reduced_root
  refine ⟨Real.arccos (x / 2), ?_, ?_⟩
  · intro h
    have hcos : Real.cos (Real.arccos (x / 2)) = x / 2 :=
      Real.cos_arccos (by linarith) (by linarith)
    rw [h, Real.cos_zero] at hcos
    linarith
  · have hcos : Real.cos (Real.arccos (x / 2)) = x / 2 :=
      Real.cos_arccos (by linarith) (by linarith)
    set q := Real.arccos (x / 2) with hq
    set z := (Real.cos q + I * Real.sin q) with hz
    have hzne : z ≠ 0 := unit_circle_ne_zero q
    rw [slice_det_sub_one z hzne]
    have hrel := positive_quartic_unit_circle_relation q
    have h2c : (2 : ℝ) * Real.cos q = x := by rw [hcos]; ring
    have : positiveQuartic z = 0 := by
      rw [hrel, h2c, hxr]
      simp
    rw [this]
    simp

/-- Extra pi-quasienergy crossing on the exact physical unit circle. -/
theorem exists_additional_pi_crossing :
    ∃ q : Real, q ≠ 0 ∧
      (sliceWalk (Real.cos q + I * Real.sin q) + 1).det = 0 := by
  obtain ⟨x, hx1, hx2, hxr⟩ := exists_negative_reduced_root
  refine ⟨Real.arccos (x / 2), ?_, ?_⟩
  · intro h
    have hcos : Real.cos (Real.arccos (x / 2)) = x / 2 :=
      Real.cos_arccos (by linarith) (by linarith)
    rw [h, Real.cos_zero] at hcos
    linarith
  · have hcos : Real.cos (Real.arccos (x / 2)) = x / 2 :=
      Real.cos_arccos (by linarith) (by linarith)
    set q := Real.arccos (x / 2) with hq
    set z := (Real.cos q + I * Real.sin q) with hz
    have hzne : z ≠ 0 := unit_circle_ne_zero q
    rw [slice_det_add_one z hzne]
    have hrel := negative_quartic_unit_circle_relation q
    have h2c : (2 : ℝ) * Real.cos q = x := by rw [hcos]; ring
    have : negativeQuartic z = 0 := by
      rw [hrel, h2c, hxr]
      simp
    rw [this]
    simp

/-! ## Build-enforced assumption pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.CoupledReciprocalSliceNoGo.sliceWalk_det' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sliceWalk_det

/-- info: 'PhysicsSM.Draft.NullEdge.CoupledReciprocalSliceNoGo.slice_det_sub_one' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms slice_det_sub_one

/-- info: 'PhysicsSM.Draft.NullEdge.CoupledReciprocalSliceNoGo.exists_additional_zero_crossing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_additional_zero_crossing

/-- info: 'PhysicsSM.Draft.NullEdge.CoupledReciprocalSliceNoGo.exists_additional_pi_crossing' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exists_additional_pi_crossing

end PhysicsSM.Draft.NullEdge.CoupledReciprocalSliceNoGo
