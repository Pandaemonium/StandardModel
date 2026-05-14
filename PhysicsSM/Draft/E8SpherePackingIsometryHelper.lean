import Mathlib

/-!
# Helper lemmas for the E8 isometry bridge

Abstract bilinear form identities for integer-scaled sums of vectors.
These are used by `E8SpherePackingImported.lean` for the norm/isometry theorem.
-/

set_option linter.style.longLine false
set_option linter.unusedVariables false

namespace PhysicsSM.Draft.E8SpherePackingIsometryHelper

open Finset Matrix

/-
The dot product of two integer-linear combinations of vectors equals
a double sum over the Gram matrix entries.

Given basis vectors `r : Fin n → (Fin n → ℝ)` and integer coefficient
vectors `a b : Fin n → ℤ`:

  `(∑ i, a_i • r_i) ⬝ᵥ (∑ j, b_j • r_j) = ∑ i j, a_i * G_ij * b_j`

where `G_ij = r_i ⬝ᵥ r_j` is the Gram matrix.
-/
theorem dotProduct_sum_smul_eq_gram {n : ℕ}
    (r : Fin n → (Fin n → ℝ)) (a b : Fin n → ℤ) :
    (∑ i, (a i) • r i) ⬝ᵥ (∑ j, (b j) • r j) =
    ∑ i : Fin n, ∑ j : Fin n,
      (a i : ℝ) * (r i ⬝ᵥ r j) * (b j : ℝ) := by
  have h_expand : (∑ i, (a i • r i)) ⬝ᵥ (∑ j, (b j • r j)) = ∑ i, (a i • r i) ⬝ᵥ (∑ j, (b j • r j)) := by
    exact?;
  simp_all +decide [ mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul, dotProduct ];
  exact Finset.sum_congr rfl fun _ _ => Finset.sum_comm.trans ( Finset.sum_congr rfl fun _ _ => Finset.sum_congr rfl fun _ _ => by ring )

/-
If `G` is the Gram matrix of a basis `r` (i.e., `G i j = r_i ⬝ᵥ r_j`),
and `T` is a ℤ-valued transition matrix, then the Gram form through `T` is:

  `∑ i j, (T·c₁)_i * G_ij * (T·c₂)_j = ∑ i j, c₁_i * (Tᵀ·G·T)_ij * c₂_j`

This is the standard change-of-basis formula for bilinear forms.
-/
theorem gram_form_change_of_basis {n : ℕ}
    (G : Matrix (Fin n) (Fin n) ℝ)
    (T : Matrix (Fin n) (Fin n) ℤ)
    (c₁ c₂ : Fin n → ℤ) :
    ∑ i : Fin n, ∑ j : Fin n,
      (T.mulVec c₁ i : ℝ) * G i j * (T.mulVec c₂ j : ℝ) =
    ∑ i : Fin n, ∑ j : Fin n,
      (c₁ i : ℝ) *
      ((T.map (Int.castRingHom ℝ)).transpose * G * T.map (Int.castRingHom ℝ)) i j *
      (c₂ j : ℝ) := by
  simp +decide [ Matrix.mul_apply, mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul ];
  simp +decide [ Matrix.mulVec, dotProduct, mul_assoc, mul_comm, mul_left_comm, Finset.mul_sum _ _ _, Finset.sum_mul ];
  simp +decide only [← sum_product'];
  apply Finset.sum_bij (fun x _ => (x.2.2.2, x.2.2.1, x.2.1, x.1));
  · aesop;
  · grind;
  · aesop;
  · grind

/-- Combined theorem: the inner product of integer-linear combinations of
row vectors equals the quadratic form given by `Tᵀ · (M · Mᵀ) · T`.

This combines `dotProduct_sum_smul_eq_gram` and `gram_form_change_of_basis`. -/
theorem inner_intLinComb_eq_gram_form {n : ℕ}
    (M : Matrix (Fin n) (Fin n) ℝ)
    (T : Matrix (Fin n) (Fin n) ℤ)
    (c₁ c₂ : Fin n → ℤ) :
    (∑ i, (T.mulVec c₁ i) • M.row i) ⬝ᵥ
    (∑ j, (T.mulVec c₂ j) • M.row j) =
    ∑ i : Fin n, ∑ j : Fin n,
      (c₁ i : ℝ) *
      ((T.map (Int.castRingHom ℝ)).transpose *
       (M * M.transpose) *
       T.map (Int.castRingHom ℝ)) i j *
      (c₂ j : ℝ) := by
  rw [dotProduct_sum_smul_eq_gram M.row (T.mulVec c₁) (T.mulVec c₂)]
  have hGram : ∀ i j : Fin n, M.row i ⬝ᵥ M.row j = (M * M.transpose) i j := by
    intro i j; simp [dotProduct, Matrix.mul_apply, Matrix.transpose_apply]
  simp_rw [hGram]
  exact gram_form_change_of_basis (M * M.transpose) T c₁ c₂

/-- Casting a matrix identity from ℚ to ℝ: if two ℚ-matrices are equal,
their images under `algebraMap ℚ ℝ` are also equal. -/
theorem matrix_eq_cast_Q_to_R {n : ℕ}
    (A B : Matrix (Fin n) (Fin n) ℚ)
    (h : A = B) :
    A.map (algebraMap ℚ ℝ) = B.map (algebraMap ℚ ℝ) := by
  rw [h]

/-- The ℤ → ℝ cast factors through ℤ → ℚ → ℝ for matrix maps. -/
theorem matrix_map_int_cast_factors {n : ℕ}
    (T : Matrix (Fin n) (Fin n) ℤ) :
    T.map (Int.castRingHom ℝ) =
    (T.map (Int.castRingHom ℚ)).map (algebraMap ℚ ℝ) := by
  ext i j; simp [Matrix.map_apply]

/-
The ℚ Gram congruence lifts to ℝ: if `Tᵀ_ℚ * G_ℚ * T_ℚ = H_ℚ` (over ℚ),
then `Tᵀ_ℝ * G_ℝ * T_ℝ = H_ℝ` (over ℝ), where the subscripts denote
applying `algebraMap ℚ ℝ` to the matrix entries, and the ℤ transition
matrix is cast via `Int.castRingHom`.
-/
theorem gram_congruence_Q_to_R {n : ℕ}
    (T : Matrix (Fin n) (Fin n) ℤ)
    (G H : Matrix (Fin n) (Fin n) ℚ)
    (hGram : (T.map (Int.castRingHom ℚ)).transpose * G * (T.map (Int.castRingHom ℚ)) = H) :
    (T.map (Int.castRingHom ℝ)).transpose *
    (G.map (algebraMap ℚ ℝ)) *
    (T.map (Int.castRingHom ℝ)) =
    H.map (algebraMap ℚ ℝ) := by
  convert congr_arg ( fun x : Matrix ( Fin n ) ( Fin n ) ℚ => x.map ( algebraMap ℚ ℝ ) ) hGram using 1;
  ext i j; simp +decide [ Matrix.mul_apply ] ;

end PhysicsSM.Draft.E8SpherePackingIsometryHelper
