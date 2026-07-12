import PhysicsSM.Draft.NullEdge.FullBlochSplitDeterminants
import PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge

/-!
# Global chirality boundary of the live ordered Bloch step

This module tests the actual all-momentum split step and proves that the same
constant chirality that splits the local cubic tangent commutes with the full
Bloch update exactly at the massless angles where `sin theta = 0`.

Provenance: theorem statements prepared locally after the corrected July 11,
2026 charge audit; proofs completed without statement changes by Aristotle
project `d9517f33-6fc6-4c5e-a9c9-556fedefc5ad`, task
`dc9dc4fa-88ef-4ba8-ad12-e4f1aec0bf41`.
-/

open Matrix Complex

namespace PhysicsSM.Draft.NullEdge.FullBlochGlobalChirality

open FullBlochSplitDeterminants

abbrev Mat4 := Matrix (Fin 4) (Fin 4) Complex

set_option maxHeartbeats 4000000

noncomputable def Xi : Mat4 :=
  PhysicsSM.Draft.NullEdge.CubicWeylSectorCharge.Xi

/-- The chirality is the explicit permutation matrix. -/
theorem Xi_eq_explicit : Xi = CubicWeylSectorCharge.xiExplicit :=
  CubicWeylSectorCharge.Xi_eq_explicit

theorem Xi_sq : Xi * Xi = 1 := by
  rw [Xi_eq_explicit]
  simp only [CubicWeylSectorCharge.xiExplicit]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four]

/-- The live chirality is a Hermitian involution, not merely an algebraic
grading.  This justifies treating its `+1` and `-1` eigenspaces as orthogonal
Weyl sectors. -/
theorem Xi_conjTranspose : Matrix.conjTranspose Xi = Xi := by
  rw [Xi_eq_explicit]
  simp only [CubicWeylSectorCharge.xiExplicit]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.conjTranspose_apply]

/-- Orthogonal projector onto the positive chirality sector. -/
noncomputable def plusProjector : Mat4 :=
  (2 : Complex)⁻¹ • (1 + Xi)

theorem Xi_commutes_alpha1 : Xi * alpha1 = alpha1 * Xi := by
  rw [Xi_eq_explicit]
  simp only [CubicWeylSectorCharge.xiExplicit, alpha1]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four]

theorem Xi_commutes_alpha2 : Xi * alpha2 = alpha2 * Xi := by
  rw [Xi_eq_explicit]
  simp only [CubicWeylSectorCharge.xiExplicit, alpha2]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four]

theorem Xi_commutes_alpha3 : Xi * alpha3 = alpha3 * Xi := by
  rw [Xi_eq_explicit]
  simp only [CubicWeylSectorCharge.xiExplicit, alpha3]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four]

theorem Xi_anticommutes_beta : Xi * beta + beta * Xi = 0 := by
  rw [Xi_eq_explicit]
  simp only [CubicWeylSectorCharge.xiExplicit, beta]
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [Matrix.add_apply]

theorem Xi_commutes_spatial_factor (q : Real) (A : Mat4)
    (hA : Xi * A = A * Xi) :
    Xi * factor q A = factor q A * Xi := by
  simp only [factor, mul_sub, sub_mul, smul_mul_assoc, mul_smul_comm,
    Matrix.mul_one, Matrix.one_mul, hA]

/-- Determinant of the first ordered spatial factor is one. -/
theorem det_factor_alpha1 (q : Real) : (factor q alpha1).det = 1 := by
  rw [factor_alpha1, det_fin_four]
  simp only [Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
    Matrix.head_fin_const, Matrix.cons_val_fin_one, Matrix.cons_val, Matrix.of_apply,
    Matrix.empty_val', Matrix.cons_val_two, Matrix.tail_cons]
  have h : (Real.cos q : ℂ)^2 + (Real.sin q : ℂ)^2 = 1 := by
    rw [← Complex.ofReal_pow, ← Complex.ofReal_pow, ← Complex.ofReal_add, Real.cos_sq_add_sin_sq]
    simp
  have hI2 : (I:ℂ)^2 = -1 := Complex.I_sq
  have hI4 : (I:ℂ)^4 = 1 := by rw [show (4:ℕ)=2*2 from rfl, pow_mul, hI2]; ring
  ring_nf
  rw [hI2, hI4]
  ring_nf
  linear_combination ((Real.cos q:ℂ)^2 + (Real.sin q:ℂ)^2 + 1) * h

/-- Determinant of the second ordered spatial factor is one. -/
theorem det_factor_alpha2 (q : Real) : (factor q alpha2).det = 1 := by
  rw [factor_alpha2, det_fin_four]
  simp only [Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
    Matrix.head_fin_const, Matrix.cons_val_fin_one, Matrix.cons_val, Matrix.of_apply,
    Matrix.empty_val', Matrix.cons_val_two, Matrix.tail_cons]
  have h : (Real.cos q : ℂ)^2 + (Real.sin q : ℂ)^2 = 1 := by
    rw [← Complex.ofReal_pow, ← Complex.ofReal_pow, ← Complex.ofReal_add, Real.cos_sq_add_sin_sq]
    simp
  ring_nf
  linear_combination ((Real.cos q:ℂ)^2 + (Real.sin q:ℂ)^2 + 1) * h

/-- Determinant of the third ordered spatial factor is one. -/
theorem det_factor_alpha3 (q : Real) : (factor q alpha3).det = 1 := by
  rw [factor_alpha3, det_fin_four]
  simp only [Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
    Matrix.head_fin_const, Matrix.cons_val_fin_one, Matrix.cons_val, Matrix.of_apply,
    Matrix.empty_val', Matrix.cons_val_two, Matrix.tail_cons]
  have h : (Real.cos q : ℂ)^2 + (Real.sin q : ℂ)^2 = 1 := by
    rw [← Complex.ofReal_pow, ← Complex.ofReal_pow, ← Complex.ofReal_add, Real.cos_sq_add_sin_sq]
    simp
  have hI2 : (I:ℂ)^2 = -1 := Complex.I_sq
  have hI4 : (I:ℂ)^4 = 1 := by rw [show (4:ℕ)=2*2 from rfl, pow_mul, hI2]; ring
  ring_nf
  rw [hI2, hI4]
  ring_nf
  linear_combination ((Real.cos q:ℂ)^2 + (Real.sin q:ℂ)^2 + 1) * h

theorem det_Xi : Xi.det = 1 := by
  rw [Xi_eq_explicit]
  simp only [CubicWeylSectorCharge.xiExplicit, det_fin_four,
    Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
    Matrix.head_fin_const, Matrix.cons_val_fin_one, Matrix.cons_val, Matrix.of_apply,
    Matrix.empty_val', Matrix.cons_val_two, Matrix.tail_cons]
  norm_num

theorem det_beta : (beta : Mat4).det = 1 := by
  simp only [beta, det_fin_four,
    Matrix.cons_val', Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.head_cons,
    Matrix.head_fin_const, Matrix.cons_val_fin_one, Matrix.cons_val, Matrix.of_apply,
    Matrix.empty_val', Matrix.cons_val_two, Matrix.tail_cons]
  norm_num

/-- The exact commutator of the chirality with the full ordered step is the
mass sine times the (invertible) spatial part composed with `Xi * beta`. -/
theorem commutator_eq (qx qy qz theta : Real) :
    Xi * splitStep qx qy qz theta - splitStep qx qy qz theta * Xi
      = (-(2 : ℂ) * I * (Real.sin theta)) •
          (factor qx alpha1 * factor qy alpha2 * factor qz alpha3 * (Xi * beta)) := by
  have c1 : Commute Xi (factor qx alpha1) :=
    Xi_commutes_spatial_factor qx alpha1 Xi_commutes_alpha1
  have c2 : Commute Xi (factor qy alpha2) :=
    Xi_commutes_spatial_factor qy alpha2 Xi_commutes_alpha2
  have c3 : Commute Xi (factor qz alpha3) :=
    Xi_commutes_spatial_factor qz alpha3 Xi_commutes_alpha3
  have cP : Commute Xi (factor qx alpha1 * factor qy alpha2 * factor qz alpha3) :=
    (c1.mul_right c2).mul_right c3
  have hbc : beta * Xi = -(Xi * beta) := eq_neg_of_add_eq_zero_right Xi_anticommutes_beta
  have hB : Xi * factor theta beta - factor theta beta * Xi
      = (-(2:ℂ) * I * (Real.sin theta)) • (Xi * beta) := by
    simp only [factor, mul_sub, sub_mul, smul_mul_assoc, mul_smul_comm,
      Matrix.mul_one, Matrix.one_mul]
    rw [hbc]; module
  set P := factor qx alpha1 * factor qy alpha2 * factor qz alpha3 with hP
  show Xi * (P * factor theta beta) - (P * factor theta beta) * Xi
      = (-(2 : ℂ) * I * (Real.sin theta)) • (P * (Xi * beta))
  have key : Xi * (P * factor theta beta) - (P * factor theta beta) * Xi
      = P * (Xi * factor theta beta - factor theta beta * Xi) := by
    rw [mul_sub, ← mul_assoc Xi P (factor theta beta), cP,
      mul_assoc P Xi (factor theta beta), mul_assoc P (factor theta beta) Xi]
  rw [key, hB, mul_smul_comm]

/-- The spatial-plus-chirality core is invertible: its determinant is one. -/
theorem M_det (qx qy qz : Real) :
    (factor qx alpha1 * factor qy alpha2 * factor qz alpha3 * (Xi * beta)).det = 1 := by
  rw [Matrix.det_mul, Matrix.det_mul, Matrix.det_mul, Matrix.det_mul,
    det_factor_alpha1, det_factor_alpha2, det_factor_alpha3, det_Xi, det_beta]
  ring

/-- The complete massless live Bloch step has a global constant chirality. -/
theorem massless_splitStep_commutes (qx qy qz : Real) :
    Xi * splitStep qx qy qz 0 = splitStep qx qy qz 0 * Xi := by
  have c1 : Commute Xi (factor qx alpha1) :=
    Xi_commutes_spatial_factor qx alpha1 Xi_commutes_alpha1
  have c2 : Commute Xi (factor qy alpha2) :=
    Xi_commutes_spatial_factor qy alpha2 Xi_commutes_alpha2
  have c3 : Commute Xi (factor qz alpha3) :=
    Xi_commutes_spatial_factor qz alpha3 Xi_commutes_alpha3
  have cb : Commute Xi (factor 0 beta) := by
    have hb : factor 0 beta = (1 : Mat4) := by
      simp [factor]
    rw [hb]; exact Commute.one_right Xi
  have : Commute Xi (splitStep qx qy qz 0) := by
    rw [splitStep]
    exact (((c1.mul_right c2).mul_right c3).mul_right cb)
  exact this

/-- The massless all-momentum update commutes with the positive chirality
projector.  This is the explicit block-invariance statement behind the phrase
"globally Weyl-sector split." -/
theorem massless_splitStep_commutes_plusProjector (qx qy qz : Real) :
    plusProjector * splitStep qx qy qz 0 =
      splitStep qx qy qz 0 * plusProjector := by
  have h := massless_splitStep_commutes qx qy qz
  simp only [plusProjector, smul_mul_assoc, mul_smul_comm, add_mul, mul_add,
    Matrix.one_mul, Matrix.mul_one]
  rw [h]

/-- Sharp global boundary: the complete live step commutes with this chirality
exactly when its mass angle has zero sine. -/
theorem splitStep_commutes_iff_sin_theta_zero
    (qx qy qz theta : Real) :
    (Xi * splitStep qx qy qz theta = splitStep qx qy qz theta * Xi) ↔
      Real.sin theta = 0 := by
  rw [← sub_eq_zero, commutator_eq, smul_eq_zero]
  constructor
  · rintro (hc | hM)
    · have hsin : (Real.sin theta : ℂ) = 0 := by
        rcases mul_eq_zero.mp hc with h | h
        · exact absurd h (by simp [Complex.I_ne_zero])
        · exact h
      exact_mod_cast hsin
    · exfalso
      have hd := M_det qx qy qz
      have hz : (0 : Mat4).det = 0 := Matrix.det_zero ⟨(0 : Fin 4)⟩
      rw [hM, hz] at hd
      exact one_ne_zero hd.symm
  · intro h
    left
    rw [h]
    push_cast
    ring

/-- Mandatory nonzero control at a quarter-turn mass angle. -/
theorem quarter_mass_breaks_global_chirality :
    Xi * splitStep 0 0 0 (Real.pi / 2) ≠
      splitStep 0 0 0 (Real.pi / 2) * Xi := by
  rw [ne_eq, splitStep_commutes_iff_sin_theta_zero, Real.sin_pi_div_two]
  norm_num

end PhysicsSM.Draft.NullEdge.FullBlochGlobalChirality
