import CodeLatticeE8.E8.Basis

/-!
# The E8 normalization of the Hamming Construction A Gram matrix

The Construction A lattice in this package is intentionally kept in integer
coordinates.  In those coordinates the shortest nonzero vectors have squared
norm `4`.  The conventional E8 root normalization divides the quadratic form by
`2`, so those same vectors have squared norm `2`.

This module records that normalization at the level of Gram matrices.  It does
not introduce real coordinates or analytic theta functions; it is just the
small rational bridge needed by later, more geometric statements.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.E8

open CodeLatticeE8.ConstructionA

/-! ## Integer dot product -/

/-- The standard integer dot product on `Z^8`. -/
def intDot (u v : Fin 8 → ℤ) : ℤ :=
  ∑ i, u i * v i

/-- The integer dot product is symmetric. -/
theorem intDot_comm (u v : Fin 8 → ℤ) : intDot u v = intDot v u := by
  simp only [intDot, mul_comm]

/-- The integer dot product is additive in its first argument. -/
theorem intDot_add_left (u v w : Fin 8 → ℤ) :
    intDot (u + v) w = intDot u w + intDot v w := by
  simp only [intDot, Pi.add_apply, add_mul, Finset.sum_add_distrib]

/-- The integer dot product is homogeneous in its first argument. -/
theorem intDot_smul_left (c : ℤ) (u v : Fin 8 → ℤ) :
    intDot (c • u) v = c * intDot u v := by
  simp only [intDot, Pi.smul_apply, smul_eq_mul, mul_assoc, Finset.mul_sum]

/-- The displayed Gram matrix records the dot products of the displayed basis vectors. -/
theorem intDot_basis_eq_gram (i j : Fin 8) :
    intDot (hammingConstructionBasis i) (hammingConstructionBasis j) =
      hammingConstructionGram i j :=
  (hammingConstructionGram_eq i j).symm

/-! ## Rational E8 normalization -/

/--
The rational Gram matrix after the conventional E8 scaling.

The integer model has squared norm `4` on roots.  Dividing the bilinear form by
`2` gives squared norm `2`, the standard normalization for simply-laced root
systems.
-/
def hammingConstructionScaledGram : Matrix (Fin 8) (Fin 8) ℚ :=
  Matrix.of fun i j => (hammingConstructionGram i j : ℚ) / 2

/-- The scaled Gram matrix is exactly one half of the integer Gram matrix. -/
theorem hammingConstructionScaledGram_apply (i j : Fin 8) :
    hammingConstructionScaledGram i j = (hammingConstructionGram i j : ℚ) / 2 :=
  rfl

/-- Every displayed basis vector has squared norm two after E8 normalization. -/
theorem hammingConstructionScaledGram_diag (i : Fin 8) :
    hammingConstructionScaledGram i i = 2 := by
  rw [hammingConstructionScaledGram_apply, hammingConstructionGram_diag]
  norm_num

/-- The scaled Gram matrix is symmetric. -/
theorem hammingConstructionScaledGram_comm (i j : Fin 8) :
    hammingConstructionScaledGram i j = hammingConstructionScaledGram j i := by
  rw [hammingConstructionScaledGram_apply, hammingConstructionScaledGram_apply,
    hammingConstructionGram_comm]

/--
Although `hammingConstructionScaledGram` is written as a rational matrix, every
entry is integral.  This is the visible evenness consequence of the Hamming
code being doubly even.
-/
theorem hammingConstructionScaledGram_int_valued (i j : Fin 8) :
    ∃ n : ℤ, hammingConstructionScaledGram i j = n := by
  obtain ⟨n, hn⟩ := hammingConstructionGram_even i j
  refine ⟨n, ?_⟩
  rw [hammingConstructionScaledGram_apply, hn]
  norm_num

/-- The scaled squared norm attached to the integer model. -/
def scaledSqNorm (z : Fin 8 → ℤ) : ℚ :=
  (sqNorm z : ℚ) / 2

/-- The displayed basis vectors have scaled squared norm two. -/
theorem scaledSqNorm_basis (i : Fin 8) :
    scaledSqNorm (hammingConstructionBasis i) = 2 := by
  have hsq :
      sqNorm (hammingConstructionBasis i) =
        intDot (hammingConstructionBasis i) (hammingConstructionBasis i) := by
    simp [sqNorm, intDot, pow_two]
  rw [scaledSqNorm, hsq, intDot_basis_eq_gram, hammingConstructionGram_diag]
  norm_num

end CodeLatticeE8.E8
