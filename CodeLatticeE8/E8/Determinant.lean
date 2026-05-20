import CodeLatticeE8.E8.Gram
import Mathlib.LinearAlgebra.Matrix.Block

/-!
# Determinants for the Hamming Construction A E8 basis

This module proves the determinant facts behind the unimodularity statement for
the Hamming Construction A model.

The important proof-design point is that we do not expand the determinant of
the full `8` by `8` Gram matrix.  Instead, we first compute the determinant of
the displayed basis matrix.  With rows and columns split into the first four
coordinates and the last four coordinates, that basis matrix is block upper
triangular:

* the upper-left block is a `4` by `4` binary message block with determinant
  `-1`;
* the lower-right block is `2 I_4`, with determinant `16`;
* the lower-left block is zero.

Thus the basis determinant is `-16`.  The Gram determinant is then
`(-16)^2 = 256`, and the conventional E8 scaling divides the Gram matrix by
`2`, so the scaled determinant is `2^(-8) * 256 = 1`.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.E8

/-! ## The displayed basis as a matrix -/

/--
The matrix whose `i`-th row is `hammingConstructionBasis i`.

Keeping this as a named matrix makes the determinant proof readable: the Gram
matrix is `B * Bᵀ`, while `B` itself has a visible block-upper-triangular form.
-/
def hammingConstructionBasisMatrix : Matrix (Fin 8) (Fin 8) ℤ :=
  Matrix.of hammingConstructionBasis

private theorem hammingConstructionBasisMatrix_lowerLeft_zero :
    ∀ i : Fin 8, ¬ i.val < 4 →
      ∀ j : Fin 8, j.val < 4 → hammingConstructionBasisMatrix i j = 0 := by
  intro i hi j hj
  fin_cases i <;> fin_cases j <;>
    simp [hammingConstructionBasisMatrix, hammingConstructionBasis] at hi hj ⊢

private theorem hammingConstructionBasisMatrix_upperLeft_det :
    (hammingConstructionBasisMatrix.toSquareBlockProp (fun i : Fin 8 => i.val < 4)).det =
      -1 := by
  decide

private theorem hammingConstructionBasisMatrix_lowerRight_det :
    (hammingConstructionBasisMatrix.toSquareBlockProp (fun i : Fin 8 => ¬ i.val < 4)).det =
      16 := by
  decide

/--
The determinant of the displayed Construction A basis matrix.

The proof uses `Matrix.twoBlockTriangular_det` with the split
`{0,1,2,3} | {4,5,6,7}`.  This reduces the determinant to two small blocks:
the message block of determinant `-1` and the even-coordinate block of
determinant `16`.
-/
theorem hammingConstructionBasisMatrix_det :
    hammingConstructionBasisMatrix.det = -16 := by
  rw [Matrix.twoBlockTriangular_det hammingConstructionBasisMatrix
    (fun i : Fin 8 => i.val < 4) hammingConstructionBasisMatrix_lowerLeft_zero]
  rw [hammingConstructionBasisMatrix_upperLeft_det,
    hammingConstructionBasisMatrix_lowerRight_det]
  norm_num

/-! ## Raw and scaled Gram determinants -/

/-- The displayed Gram matrix is `B * Bᵀ` for the displayed basis matrix `B`. -/
theorem hammingConstructionGram_eq_basisMatrix_mul_transpose :
    hammingConstructionGram =
      hammingConstructionBasisMatrix * hammingConstructionBasisMatrix.transpose := by
  ext i j
  rw [Matrix.mul_apply]
  simp [hammingConstructionBasisMatrix, Matrix.transpose_apply, hammingConstructionGram_eq]

/--
The raw integer-coordinate Gram determinant is `256`.

This is the square of the displayed basis determinant.  It is the determinant
before applying the conventional E8 normalization that divides the quadratic
form by `2`.
-/
theorem hammingConstructionGram_det :
    hammingConstructionGram.det = 256 := by
  rw [hammingConstructionGram_eq_basisMatrix_mul_transpose]
  rw [Matrix.det_mul, Matrix.det_transpose, hammingConstructionBasisMatrix_det]
  norm_num

/--
The scaled rational Gram matrix is one half of the raw integer Gram matrix.

This equality is stated with an explicit integer-to-rational map so that the
determinant computation can use `Matrix.det_smul` and `Int.cast_det`.
-/
theorem hammingConstructionScaledGram_eq_smul_map :
    hammingConstructionScaledGram =
      (1 / 2 : ℚ) • hammingConstructionGram.map (fun x : ℤ => (x : ℚ)) := by
  ext i j
  calc
    hammingConstructionScaledGram i j = (hammingConstructionGram i j : ℚ) / 2 :=
      hammingConstructionScaledGram_apply i j
    _ = (1 / 2 : ℚ) * (hammingConstructionGram i j : ℚ) := by ring
    _ = ((1 / 2 : ℚ) • hammingConstructionGram.map (fun x : ℤ => (x : ℚ))) i j := by
      simp only [one_div, Matrix.smul_apply, Matrix.map_apply, smul_eq_mul]

/--
The scaled E8 Gram matrix has determinant `1`.

This is the finite-dimensional algebraic form of unimodularity for the
displayed basis in the conventional E8 normalization.
-/
theorem hammingConstructionScaledGram_det :
    hammingConstructionScaledGram.det = 1 := by
  rw [hammingConstructionScaledGram_eq_smul_map]
  rw [Matrix.det_smul]
  rw [← Int.cast_det hammingConstructionGram]
  rw [hammingConstructionGram_det]
  norm_num

end CodeLatticeE8.E8
