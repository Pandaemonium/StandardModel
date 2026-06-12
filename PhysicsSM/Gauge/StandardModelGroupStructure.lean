import Mathlib
import PhysicsSM.Gauge.StandardModelSubgroup
import PhysicsSM.Gauge.GUTSquare
import PhysicsSM.Gauge.BlockEmbeddings

/-!
# Gauge.StandardModelGroupStructure

Subgroup closure properties for the Standard Model block predicate
`SMBlockPredicate` on `Matrix (Fin 2 ⊕ Fin 3) (Fin 2 ⊕ Fin 3) ℂ`.

## Main results

- `SMBlockPredicate_one`: the identity matrix satisfies `SMBlockPredicate`.
- `SMBlockPredicate_mul`: `SMBlockPredicate` is closed under multiplication.
- `SMBlockPredicate_inv`: `SMBlockPredicate` is closed under matrix inversion.

These establish the algebraic closure facts needed to package the matrices
satisfying `SMBlockPredicate` as a subgroup of invertible matrices.

## Mathematical context

`SMBlockPredicate M` asserts that `M` is a block-diagonal unitary matrix
`fromBlocks A 0 0 B` with `A ∈ U(2)`, `B ∈ U(3)`, and
`det(A) * det(B) = 1`. This characterizes the Standard Model gauge group
`S(U(2) × U(3))` at the matrix-predicate level.

Status: trusted, no `sorry`.
-/

namespace PhysicsSM.Gauge.StandardModelSubgroup

open Complex Matrix PhysicsSM.Gauge.GUTSquare

/-- The 5×5 block type used throughout the gauge section. -/
abbrev GUTMatrix := Matrix (Fin 2 ⊕ Fin 3) (Fin 2 ⊕ Fin 3) ℂ

/-! ## Helper lemmas -/

/-- The identity matrix decomposes as `fromBlocks 1 0 0 1`. -/
theorem one_eq_fromBlocks :
    (1 : GUTMatrix) = fromBlocks 1 0 0 1 := by
  ext i j
  by_cases hi : i = j <;> simp_all +decide [Matrix.one_apply]

/-- Unitary matrices are closed under multiplication. -/
theorem isUnitary_mul {n : Type*} [Fintype n] [DecidableEq n]
    {A B : Matrix n n ℂ}
    (hA : IsUnitary A) (hB : IsUnitary B) :
    IsUnitary (A * B) := by
  unfold IsUnitary at *
  simp_all +decide [Matrix.mul_assoc]
  simp +decide [← Matrix.mul_assoc, hA, hB]

/-- If `IsUnitary A`, then `A⁻¹ = Aᴴ`. -/
theorem isUnitary_inv_eq_conjTranspose {n : Type*} [Fintype n] [DecidableEq n]
    {A : Matrix n n ℂ}
    (hA : IsUnitary A) :
    A⁻¹ = A.conjTranspose := by
  rw [Matrix.inv_eq_left_inv hA]

/-- If `IsUnitary A`, then `IsUnitary A⁻¹`. -/
theorem isUnitary_inv {n : Type*} [Fintype n] [DecidableEq n]
    {A : Matrix n n ℂ}
    (hA : IsUnitary A) :
    IsUnitary A⁻¹ := by
  unfold IsUnitary at *
  simp +decide [Matrix.inv_eq_left_inv hA]
  rw [← mul_eq_one_comm, hA]

/-- The inverse of a block-diagonal matrix with unitary blocks is block-diagonal
with inverted blocks. -/
theorem fromBlocks_inv_zero_off_diag
    (A : Matrix (Fin 2) (Fin 2) ℂ) (B : Matrix (Fin 3) (Fin 3) ℂ)
    (hA : IsUnitary A) (hB : IsUnitary B) :
    (fromBlocks A 0 0 B)⁻¹ = fromBlocks A⁻¹ 0 0 B⁻¹ := by
  rw [Matrix.inv_eq_right_inv]
  simp_all +decide [fromBlocks_multiply]
  rw [Matrix.mul_nonsing_inv _ _, Matrix.mul_nonsing_inv _ _] <;> norm_num [hA, hB]
  · exact fun h => by simpa [h] using congr_arg Matrix.det hB
  · exact fun h => by simpa [h] using congr_arg Matrix.det hA

/-! ## Main theorems -/

/-- The identity matrix satisfies `SMBlockPredicate`. -/
theorem SMBlockPredicate_one :
    SMBlockPredicate (1 : GUTMatrix) := by
  exact ⟨1, 1, one_eq_fromBlocks, by unfold IsUnitary; simp,
    by unfold IsUnitary; simp, by simp [det_one]⟩

/-- `SMBlockPredicate` is closed under matrix multiplication. -/
theorem SMBlockPredicate_mul
    {A B : GUTMatrix}
    (hA : SMBlockPredicate A) (hB : SMBlockPredicate B) :
    SMBlockPredicate (A * B) := by
  obtain ⟨A₁, B₁, rfl, hA₁, hB₁, hdet₁⟩ := hA
  obtain ⟨A₂, B₂, rfl, hA₂, hB₂, hdet₂⟩ := hB
  exact ⟨A₁ * A₂, B₁ * B₂, fromBlocks_mul_zero_off_diag A₁ A₂ B₁ B₂,
    isUnitary_mul hA₁ hA₂, isUnitary_mul hB₁ hB₂, by
      rw [det_mul, det_mul]
      have : A₁.det * B₁.det = 1 := hdet₁
      have : A₂.det * B₂.det = 1 := hdet₂
      linear_combination A₂.det * B₂.det * hdet₁ + hdet₂⟩

/-- If `A` satisfies `SMBlockPredicate`, so does its inverse. -/
theorem SMBlockPredicate_inv
    {A : GUTMatrix}
    (hA : SMBlockPredicate A) :
    SMBlockPredicate A⁻¹ := by
  obtain ⟨A₁, B₁, rfl, hA₁, hB₁, hdet₁⟩ := hA
  refine ⟨A₁⁻¹, B₁⁻¹, fromBlocks_inv_zero_off_diag A₁ B₁ hA₁ hB₁,
    isUnitary_inv hA₁, isUnitary_inv hB₁, ?_⟩
  rw [isUnitary_inv_eq_conjTranspose hA₁, isUnitary_inv_eq_conjTranspose hB₁,
      det_conjTranspose, det_conjTranspose,
      ← starRingEnd_apply, ← starRingEnd_apply, ← map_mul, hdet₁]
  simp

end PhysicsSM.Gauge.StandardModelSubgroup
