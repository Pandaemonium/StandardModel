import Mathlib
import PhysicsSM.Algebra.Octonion.G2FixingE111Faithful

/-!
# Algebra.Octonion.G2FixingE111SU3Equiv

Surjectivity of the `FixingE111MulLinear → SU(3)` matrix homomorphism,
and the resulting multiplicative equivalence.

## Mathematical context

The preceding files prove that every `FixingE111MulLinear` map (an octonion
automorphism fixing `1` and `e111`) induces a unitary 3×3 complex matrix
with determinant 1 on the complement `ℂ³`, and that this assignment is an
injective monoid homomorphism.

This file proves the reverse direction: every SU(3) matrix extends uniquely
to a `FixingE111MulLinear` map. The extension sends
`x ↦ x.toChosenComplex.toOctonion + (M · x.toComplexTriple).toOctonion`.

Source: Baez, "Can We Understand the Standard Model Using Octonions?", 2021.
-/

namespace PhysicsSM.Algebra.Octonion.G2ComplexLine

open PhysicsSM.Algebra.Octonion

/-! ## Extension map definition -/

/-- Extend a `3 × 3` complex matrix to a map on all octonions, acting as the
    identity on the chosen complex line and as `M` on the complement `ℂ³`. -/
noncomputable def su3MatrixExtension
    (M : Matrix (Fin 3) (Fin 3) Complex) :
    Octonion → Octonion :=
  fun x => x.toChosenComplex.toOctonion +
    (ComplexTriple.ofComplexVec
      (M.mulVec x.toComplexTriple.toComplexVec)).toOctonion

/-! ## Basic properties of the extension -/

theorem su3MatrixExtension_add (M : Matrix (Fin 3) (Fin 3) Complex)
    (x y : Octonion) :
    su3MatrixExtension M (x + y) =
      su3MatrixExtension M x + su3MatrixExtension M y := by
  revert x y
  unfold su3MatrixExtension
  intro x y
  ext <;>
    simp +decide [ComplexTriple.ofComplexVec, Matrix.mulVec] <;>
    ring <;>
    simp +decide [Complex.ext_iff, dotProduct] <;>
    ring <;>
    simp +decide [Fin.sum_univ_three, ComplexTriple.toComplexVec] <;>
    ring

theorem su3MatrixExtension_smul (M : Matrix (Fin 3) (Fin 3) Complex)
    (r : ℝ) (x : Octonion) :
    su3MatrixExtension M (r • x) =
      r • su3MatrixExtension M x := by
  unfold su3MatrixExtension
  simp +decide [ComplexTriple.ofComplexVec]
  ext <;>
    simp +decide [mul_assoc, mul_comm, mul_left_comm,
      smul_add, smul_sub, Matrix.mulVec] <;>
    simp +decide [dotProduct, Fin.sum_univ_three] <;>
    ring <;>
    simp +decide [ComplexTriple.toComplexVec,
      Octonion.toComplexTriple] <;>
    ring

theorem su3MatrixExtension_one
    (M : Matrix (Fin 3) (Fin 3) Complex) :
    su3MatrixExtension M 1 = 1 := by
  unfold su3MatrixExtension
  simp +decide [Octonion.toChosenComplex, Octonion.toComplexTriple,
    ComplexTriple.ofComplexVec, ComplexTriple.toComplexVec,
    Matrix.mulVec, dotProduct, Fin.sum_univ_three,
    ChosenComplex.toOctonion, Octonion.toChosenComplex]
  aesop (simp_config := { decide := true })

theorem su3MatrixExtension_e111
    (M : Matrix (Fin 3) (Fin 3) Complex) :
    su3MatrixExtension M e111 = e111 := by
  unfold su3MatrixExtension
  simp +decide [ComplexTriple.ofComplexVec, Matrix.mulVec,
    ChosenComplex.toOctonion, Octonion.ext_iff,
    Octonion.toComplexTriple, dotProduct,
    ComplexTriple.toComplexVec, Fin.sum_univ_three, e111]

theorem su3MatrixExtension_conj
    (M : Matrix (Fin 3) (Fin 3) Complex) (x : Octonion) :
    su3MatrixExtension M (Octonion.conj x) =
      Octonion.conj (su3MatrixExtension M x) := by
  unfold su3MatrixExtension
  simp +decide [conj_add, conj_smul, ComplexTriple.ofComplexVec,
    ComplexTriple.toComplexVec, Matrix.mulVec]
  congr 1
  · ext <;> simp +decide [ChosenComplex.toOctonion]
  · unfold Octonion.toComplexTriple
    simp +decide [dotProduct]; ring
    simp +decide [Fin.sum_univ_three,
      ComplexTriple.toComplexVec]; ring
    unfold ComplexTriple.toOctonion; simp +decide [conj]; ring
    norm_num

/-! ## SU(3) matrix lemmas -/

/-- An SU(3) matrix satisfies `M^* M = I`. -/
theorem MatrixActsAsSU3OnC3.conjTranspose_mul_self
    {M : Matrix (Fin 3) (Fin 3) ℂ} (hM : MatrixActsAsSU3OnC3 M) :
    M.conjTranspose * M = 1 := by
  ext i j
  simp only [Matrix.mul_apply, Matrix.conjTranspose_apply,
    Matrix.one_apply]
  have h := hM.unitary (Pi.single i 1) (Pi.single j 1)
  simp [ComplexTriple.hermitian, ComplexTriple.ofComplexVec,
    ComplexTriple.toComplexVec, Matrix.mulVec, dotProduct,
    Fin.sum_univ_three, Pi.single] at h
  fin_cases i <;> fin_cases j <;>
    simpa [Fin.sum_univ_three] using h

/-- An SU(3) matrix satisfies `M * M^* = I`. -/
theorem MatrixActsAsSU3OnC3.mul_conjTranspose_self
    {M : Matrix (Fin 3) (Fin 3) ℂ} (hM : MatrixActsAsSU3OnC3 M) :
    M * M.conjTranspose = 1 := by
  have h1 := hM.conjTranspose_mul_self
  have hunit : IsUnit M.det := by rw [hM.det_one]; exact isUnit_one
  have hadj_eq : M.adjugate = M.conjTranspose := by
    have hadj : M.adjugate * M = 1 := by
      rw [Matrix.adjugate_mul, hM.det_one, one_smul]
    calc M.adjugate
        = M.adjugate * (M * M⁻¹) := by
          rw [Matrix.mul_nonsing_inv M hunit, mul_one]
      _ = (M.adjugate * M) * M⁻¹ := by rw [mul_assoc]
      _ = M⁻¹ := by rw [hadj, one_mul]
      _ = (M.conjTranspose * M) * M⁻¹ := by
          rw [h1, one_mul]
      _ = M.conjTranspose * (M * M⁻¹) := by rw [mul_assoc]
      _ = M.conjTranspose := by
          rw [Matrix.mul_nonsing_inv M hunit, mul_one]
  rw [← hadj_eq, Matrix.mul_adjugate, hM.det_one, one_smul]

/-- Adjugate of an SU(3) matrix equals its conjugate transpose. -/
theorem MatrixActsAsSU3OnC3.adjugate_eq_conjTranspose
    {M : Matrix (Fin 3) (Fin 3) ℂ} (hM : MatrixActsAsSU3OnC3 M) :
    M.adjugate = M.conjTranspose := by
  have h1 := hM.conjTranspose_mul_self
  have hunit : IsUnit M.det := by rw [hM.det_one]; exact isUnit_one
  have hadj : M.adjugate * M = 1 := by
    rw [Matrix.adjugate_mul, hM.det_one, one_smul]
  calc M.adjugate
      = M.adjugate * (M * M⁻¹) := by
        rw [Matrix.mul_nonsing_inv M hunit, mul_one]
    _ = (M.adjugate * M) * M⁻¹ := by rw [mul_assoc]
    _ = M⁻¹ := by rw [hadj, one_mul]
    _ = (M.conjTranspose * M) * M⁻¹ := by rw [h1, one_mul]
    _ = M.conjTranspose * (M * M⁻¹) := by rw [mul_assoc]
    _ = M.conjTranspose := by
        rw [Matrix.mul_nonsing_inv M hunit, mul_one]

/-! ## Multiplication preservation

We decompose the proof into 8 coordinate identities. Each uses the SU(3)
conditions (unitarity for the line part, unitarity + det=1 for the
complement part).
-/

/-
Helper: the c0 component of the extension of a product equals the c0
    component of the product of extensions. Uses unitarity.
-/
theorem su3MatrixExtension_mul_c0
    (M : Matrix (Fin 3) (Fin 3) Complex)
    (hM : MatrixActsAsSU3OnC3 M)
    (x y : Octonion) :
    (su3MatrixExtension M (x * y)).c0 =
      (su3MatrixExtension M x * su3MatrixExtension M y).c0 := by
  -- By definition of `su3MatrixExtension`, we can expand both sides.
  simp [su3MatrixExtension];
  have h_expand : ∀ (u v : Fin 3 → ℂ), (∑ i, (M.mulVec u) i * starRingEnd ℂ ((M.mulVec v) i)) = (∑ i, u i * starRingEnd ℂ (v i)) := by
    intro u v
    have h_unit : M.conjTranspose * M = 1 := by
      exact hM.conjTranspose_mul_self
    have h_expand : ∀ (u v : Fin 3 → ℂ), (∑ i, (M.mulVec u) i * starRingEnd ℂ ((M.mulVec v) i)) = (∑ i, u i * starRingEnd ℂ (v i)) := by
      intro u v
      have h_unit : M.conjTranspose * M = 1 := h_unit
      have h_expand : ∀ (i j : Fin 3), ∑ k, starRingEnd ℂ (M k i) * M k j = if i = j then 1 else 0 := by
        intro i j; replace h_unit := congr_fun ( congr_fun h_unit i ) j; simp_all +decide [ Matrix.mul_apply, Fin.sum_univ_three ] ;
        fin_cases i <;> fin_cases j <;> rfl
      simp_all +decide [ Matrix.mulVec, dotProduct, Fin.sum_univ_three ];
      grind;
    exact h_expand u v;
  have := h_expand x.toComplexTriple.toComplexVec y.toComplexTriple.toComplexVec; norm_num [ Complex.ext_iff, Fin.sum_univ_three ] at *; linarith!;

/-
Helper: the c7 component of the extension of a product equals the c7
    component of the product of extensions. Uses unitarity.
-/
theorem su3MatrixExtension_mul_c7
    (M : Matrix (Fin 3) (Fin 3) Complex)
    (hM : MatrixActsAsSU3OnC3 M)
    (x y : Octonion) :
    (su3MatrixExtension M (x * y)).c7 =
      (su3MatrixExtension M x * su3MatrixExtension M y).c7 := by
  unfold su3MatrixExtension;
  have h_unitary : ∀ (u v : Fin 3 → ℂ), ∑ i, (starRingEnd ℂ (M.mulVec u i)) * (M.mulVec v i) = ∑ i, (starRingEnd ℂ (u i)) * (v i) := by
    convert hM.1 using 1;
  simp +decide [ Complex.ext_iff, Fin.sum_univ_three ] at *;
  linarith! [ h_unitary x.toComplexTriple.toComplexVec y.toComplexTriple.toComplexVec ]

/-
Helper: the c1 component. Uses unitarity + det=1.
-/
theorem su3MatrixExtension_mul_c1
    (M : Matrix (Fin 3) (Fin 3) Complex)
    (hM : MatrixActsAsSU3OnC3 M)
    (x y : Octonion) :
    (su3MatrixExtension M (x * y)).c1 =
      (su3MatrixExtension M x * su3MatrixExtension M y).c1 := by
  obtain ⟨h_unit, h_det⟩ := hM;
  -- Let's simplify the expression using the fact that M is unitary and has determinant 1.
  have h_unitary : M.conjTranspose * M = 1 := by
    grind +suggestions
  have h_adj : M.adjugate = M.conjTranspose := by
    rw [ ← Matrix.inv_eq_left_inv h_unitary, Matrix.inv_def ];
    aesop;
  unfold su3MatrixExtension; simp +decide [ ComplexTriple.ofComplexVec ] ; ring;
  simp +decide [ Matrix.mulVec, dotProduct, Fin.sum_univ_three ] at *;
  simp +decide [ ComplexTriple.toComplexVec, Octonion.toComplexTriple ] at *;
  simp +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ] at *;
  simp +decide [ Matrix.adjugate_apply, Matrix.det_fin_three ] at *;
  simp +decide [ Complex.ext_iff ] at *;
  grind +splitIndPred

/-
Helper: the c2 component.
-/
theorem su3MatrixExtension_mul_c2
    (M : Matrix (Fin 3) (Fin 3) Complex)
    (hM : MatrixActsAsSU3OnC3 M)
    (x y : Octonion) :
    (su3MatrixExtension M (x * y)).c2 =
      (su3MatrixExtension M x * su3MatrixExtension M y).c2 := by
  obtain ⟨h_unit, h_det⟩ := hM;
  obtain ⟨h_unitary, h_adj⟩ : M.conjTranspose * M = 1 ∧ M.adjugate = M.conjTranspose := by
    apply And.intro;
    · grind +suggestions;
    · exact MatrixActsAsSU3OnC3.adjugate_eq_conjTranspose ⟨ h_unit, h_det ⟩;
  simp +decide [ su3MatrixExtension, ComplexTriple.ofComplexVec, ComplexTriple.toComplexVec ] at *;
  simp +decide [ Matrix.mulVec, dotProduct, Fin.sum_univ_three ] at *;
  simp +decide [ ← Matrix.ext_iff ] at *;
  simp +decide [ Fin.forall_fin_succ, Matrix.mul_apply, Matrix.adjugate_apply, Matrix.det_fin_three ] at *;
  simp +decide [ Complex.ext_iff, Octonion.toComplexTriple, ComplexTriple.toComplexVec ] at *;
  grind

/-
Helper: the c3 component.
-/
theorem su3MatrixExtension_mul_c3
    (M : Matrix (Fin 3) (Fin 3) Complex)
    (hM : MatrixActsAsSU3OnC3 M)
    (x y : Octonion) :
    (su3MatrixExtension M (x * y)).c3 =
      (su3MatrixExtension M x * su3MatrixExtension M y).c3 := by
  obtain ⟨h_unitary, h_det⟩ := hM;
  obtain ⟨h_unitary, h_adj⟩ : M.conjTranspose * M = 1 ∧ M.adjugate = M.conjTranspose := by
    exact ⟨ MatrixActsAsSU3OnC3.conjTranspose_mul_self ⟨ h_unitary, h_det ⟩, MatrixActsAsSU3OnC3.adjugate_eq_conjTranspose ⟨ h_unitary, h_det ⟩ ⟩;
  simp_all +decide [ su3MatrixExtension, ComplexTriple.toOctonion, ComplexTriple.ofComplexVec ];
  simp +decide [ Matrix.mulVec, dotProduct, Fin.sum_univ_three ];
  simp +decide [ ComplexTriple.toComplexVec, Octonion.mul_c3 ];
  simp +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ] at *;
  simp_all +decide [ Complex.ext_iff, Matrix.mul_apply, Matrix.adjugate_apply, Matrix.det_fin_three ];
  grind +qlia

/-
Helper: the c4 component.
-/
theorem su3MatrixExtension_mul_c4
    (M : Matrix (Fin 3) (Fin 3) Complex)
    (hM : MatrixActsAsSU3OnC3 M)
    (x y : Octonion) :
    (su3MatrixExtension M (x * y)).c4 =
      (su3MatrixExtension M x * su3MatrixExtension M y).c4 := by
  obtain ⟨hM_unitary, hM_det⟩ := hM;
  have h_adj : M.adjugate = M.conjTranspose := by
    apply MatrixActsAsSU3OnC3.adjugate_eq_conjTranspose; exact ⟨hM_unitary, hM_det⟩;
  unfold su3MatrixExtension;
  simp +decide [ ComplexTriple.ofComplexVec, Matrix.mulVec, dotProduct, Fin.sum_univ_three ];
  simp +decide [ ComplexTriple.toComplexVec, Octonion.toComplexTriple ];
  simp +decide [ Matrix.adjugate_fin_three, Matrix.det_fin_three ] at *;
  simp +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ] at *;
  simp +decide [ Complex.ext_iff ] at *;
  grind

/-
Helper: the c5 component.
-/
theorem su3MatrixExtension_mul_c5
    (M : Matrix (Fin 3) (Fin 3) Complex)
    (hM : MatrixActsAsSU3OnC3 M)
    (x y : Octonion) :
    (su3MatrixExtension M (x * y)).c5 =
      (su3MatrixExtension M x * su3MatrixExtension M y).c5 := by
  unfold su3MatrixExtension;
  -- By definition of matrix multiplication and the properties of the adjugate matrix, we can simplify the expression.
  have h_adj : M.adjugate = M.conjTranspose := by
    exact?;
  simp_all +decide [ ComplexTriple.ofComplexVec, ComplexTriple.toComplexVec, Matrix.mulVec ];
  simp_all +decide [ Fin.sum_univ_three, dotProduct ];
  simp_all +decide [ ComplexTriple.toComplexVec, Octonion.toComplexTriple ];
  have := congr_fun ( congr_fun h_adj 0 ) 1; have := congr_fun ( congr_fun h_adj 1 ) 1; have := congr_fun ( congr_fun h_adj 2 ) 1; simp_all +decide [ Matrix.adjugate_apply, Matrix.det_fin_three ] ;
  simp_all +decide [ Complex.ext_iff, Matrix.conjTranspose ];
  grind

/-
Helper: the c6 component.
-/
-- The c6 coordinate proof needs extra heartbeats for the large simp/grind computation.
set_option maxHeartbeats 400000 in
theorem su3MatrixExtension_mul_c6
    (M : Matrix (Fin 3) (Fin 3) Complex)
    (hM : MatrixActsAsSU3OnC3 M)
    (x y : Octonion) :
    (su3MatrixExtension M (x * y)).c6 =
      (su3MatrixExtension M x * su3MatrixExtension M y).c6 := by
  unfold su3MatrixExtension
  have := MatrixActsAsSU3OnC3.conjTranspose_mul_self hM
  have := MatrixActsAsSU3OnC3.mul_conjTranspose_self hM
  have := MatrixActsAsSU3OnC3.adjugate_eq_conjTranspose hM
  simp_all +decide [← Matrix.ext_iff, Fin.forall_fin_succ]
  simp_all +decide [Fin.sum_univ_three, Matrix.mulVec,
    dotProduct, Complex.ext_iff]
  simp_all +decide [Matrix.mulVec, dotProduct,
    ComplexTriple.ofComplexVec]
  simp_all +decide [Fin.sum_univ_three,
    Octonion.toComplexTriple, ComplexTriple.toComplexVec]
  simp_all +decide [Matrix.mul_apply, Matrix.adjugate_apply,
    Matrix.det_fin_three]
  simp_all +decide [Fin.sum_univ_three]
  grind

/-- The extension preserves multiplication when the matrix is SU(3). -/
theorem su3MatrixExtension_mul
    (M : Matrix (Fin 3) (Fin 3) Complex)
    (hM : MatrixActsAsSU3OnC3 M) (x y : Octonion) :
    su3MatrixExtension M (x * y) =
      su3MatrixExtension M x * su3MatrixExtension M y := by
  exact Octonion.ext
    (su3MatrixExtension_mul_c0 M hM x y)
    (su3MatrixExtension_mul_c1 M hM x y)
    (su3MatrixExtension_mul_c2 M hM x y)
    (su3MatrixExtension_mul_c3 M hM x y)
    (su3MatrixExtension_mul_c4 M hM x y)
    (su3MatrixExtension_mul_c5 M hM x y)
    (su3MatrixExtension_mul_c6 M hM x y)
    (su3MatrixExtension_mul_c7 M hM x y)

/-! ## Construction of `FixingE111MulLinear` from SU(3) -/

noncomputable def matrixActsAsSU3OnC3.toFixingE111MulLinear
    (M : Matrix (Fin 3) (Fin 3) Complex)
    (hM : MatrixActsAsSU3OnC3 M) :
    FixingE111MulLinear where
  toFun := su3MatrixExtension M
  map_add := su3MatrixExtension_add M
  map_smul := su3MatrixExtension_smul M
  map_one := su3MatrixExtension_one M
  map_mul := su3MatrixExtension_mul M hM
  fixes_e111 := su3MatrixExtension_e111 M
  map_conj := su3MatrixExtension_conj M

theorem matrixActsAsSU3OnC3.extension_onComplexVecMatrix
    (M : Matrix (Fin 3) (Fin 3) Complex)
    (hM : MatrixActsAsSU3OnC3 M) :
    (matrixActsAsSU3OnC3.toFixingE111MulLinear M hM).onComplexVecMatrix =
      M := by
  ext i j; simp +decide [ FixingE111MulLinear.onComplexVecMatrix, FixingE111MulLinear.onComplexVecLinear, FixingE111MulLinear.onComplexTriple ] ;
  -- By definition of `su3MatrixExtension`, we know that it acts as `M` on the complex triple part.
  have h_su3MatrixExtension : ∀ (w : ComplexTriple), (su3MatrixExtension M w.toOctonion).toComplexTriple = ComplexTriple.ofComplexVec (M.mulVec w.toComplexVec) := by
    intro w; unfold su3MatrixExtension; simp +decide [ ComplexTriple.ofComplexVec ] ;
    unfold Octonion.toComplexTriple; simp +decide [ ComplexTriple.toOctonion ] ;
  convert congr_arg ( fun w : ComplexTriple => w.toComplexVec i ) ( h_su3MatrixExtension ( ComplexTriple.ofComplexVec ( Pi.single j 1 ) ) ) using 1;
  fin_cases i <;> fin_cases j <;> simp +decide [ ComplexTriple.ofComplexVec, ComplexTriple.toComplexVec, Matrix.mulVec ];
  all_goals simp +decide [ ComplexTriple.toComplexVec, dotProduct ] ;
  all_goals erw [ Fin.sum_univ_three ] ; simp +decide [ Complex.ext_iff ] ;

theorem fixingE111MulLinearToSU3Hom_surjective :
    Function.Surjective fixingE111MulLinearToSU3Hom := by
  intro ⟨ M, hM ⟩ ; exact ⟨ matrixActsAsSU3OnC3.toFixingE111MulLinear M hM, Subtype.ext (matrixActsAsSU3OnC3.extension_onComplexVecMatrix M hM)⟩ ;

noncomputable def fixingE111MulLinearEquivSU3 :
    MulEquiv FixingE111MulLinear su3Submonoid :=
  MulEquiv.ofBijective fixingE111MulLinearToSU3Hom
    ⟨fixingE111MulLinearToSU3Hom_injective,
     fixingE111MulLinearToSU3Hom_surjective⟩

end PhysicsSM.Algebra.Octonion.G2ComplexLine
