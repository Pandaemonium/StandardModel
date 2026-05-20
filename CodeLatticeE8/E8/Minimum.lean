import CodeLatticeE8.E8.Gram

/-!
# Minimum norm in the E8 normalization

The integer Construction A model has minimum nonzero squared norm `4`.  The
standard E8 normalization divides the quadratic form by `2`, so the promoted
minimum norm statement is `2`.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace CodeLatticeE8.E8

open CodeLatticeE8.ConstructionA

/-- Every nonzero Hamming Construction A vector has scaled squared norm at least `2`. -/
theorem hammingConstructionA_scaledSqNorm_ge_two (z : Fin 8 → ℤ)
    (hz : z ∈ hammingConstructionA) (hne : z ≠ 0) :
    2 ≤ scaledSqNorm z := by
  unfold scaledSqNorm
  have h : (4 : ℚ) ≤ (sqNorm z : ℚ) := by
    exact_mod_cast hammingConstructionA_sqNorm_ge_four z hz hne
  linarith

/-- The scaled minimum squared norm `2` is attained. -/
theorem hammingConstructionA_achieves_scaledSqNorm_two :
    ∃ z : Fin 8 → ℤ, z ∈ hammingConstructionA ∧ z ≠ 0 ∧ scaledSqNorm z = 2 := by
  obtain ⟨z, hz, hne, hsq⟩ := hammingConstructionA_achieves_sqNorm_four
  refine ⟨z, hz, hne, ?_⟩
  unfold scaledSqNorm
  rw [hsq]
  norm_num

/-- The Hamming Construction A lattice has scaled minimum squared norm `2`. -/
theorem hammingConstructionA_scaledMinSqNorm :
    (∀ z : Fin 8 → ℤ, z ∈ hammingConstructionA → z ≠ 0 → 2 ≤ scaledSqNorm z) ∧
      (∃ z : Fin 8 → ℤ, z ∈ hammingConstructionA ∧ z ≠ 0 ∧ scaledSqNorm z = 2) :=
  ⟨hammingConstructionA_scaledSqNorm_ge_two,
    hammingConstructionA_achieves_scaledSqNorm_two⟩

end CodeLatticeE8.E8
