import CodeLatticeE8.Code.Equivalence

/-!
# The `[n,k,d]` predicate for binary linear codes

This module packages the usual coding-theory parameters:

- `n`: ambient length, already present in the type `BinaryLinearCode n`;
- `k`: dimension over `ZMod 2`;
- `d`: minimum Hamming distance, with an explicit witness attaining it.

The predicate is a structure-valued proposition rather than a typeclass: code
parameters are mathematical data to pass explicitly, not global inference
state.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.Code

/-- A binary linear code has parameters `[n,k,d]`. -/
structure IsLinearCode {n : ℕ} (C : BinaryLinearCode n) (k d : ℕ) : Prop where
  /-- The code has dimension `k` over `ZMod 2`. -/
  dim_eq : Module.finrank (ZMod 2) C = k
  /-- Every nonzero codeword has Hamming weight at least `d`. -/
  min_dist : ∀ v ∈ C, v ≠ 0 → d ≤ hammingWeight v
  /-- The lower bound `d` is attained by some nonzero codeword. -/
  min_dist_achieved : ∃ v ∈ C, v ≠ 0 ∧ hammingWeight v = d

/-- A coordinate permutation is a linear equivalence of the ambient space. -/
def permuteBinaryVectorEquiv {n : ℕ} (sigma : Equiv.Perm (Fin n)) :
    BinaryVector n ≃ₗ[ZMod 2] BinaryVector n where
  toFun := permuteBinaryVector sigma
  map_add' := permuteBinaryVector_add sigma
  map_smul' := by
    intro c v
    ext i
    simp [permuteBinaryVector, Pi.smul_apply]
  invFun := permuteBinaryVector sigma.symm
  left_inv := by intro v; simp
  right_inv := by intro v; simp

/-- `permuteCode` agrees with the image under the corresponding linear equivalence. -/
theorem permuteCode_eq_map_equiv {n : ℕ} (sigma : Equiv.Perm (Fin n))
    (C : BinaryLinearCode n) :
    permuteCode sigma C =
      Submodule.map
        (permuteBinaryVectorEquiv sigma : BinaryVector n →ₗ[ZMod 2] BinaryVector n)
        C := by
  ext v
  simp only [permuteCode, Submodule.mem_map]
  constructor
  · rintro ⟨w, hw, rfl⟩
    exact ⟨w, hw, rfl⟩
  · rintro ⟨w, hw, rfl⟩
    exact ⟨w, hw, rfl⟩

/-- Coordinate permutation preserves code dimension. -/
theorem finrank_permuteCode {n : ℕ} (sigma : Equiv.Perm (Fin n))
    (C : BinaryLinearCode n) :
    Module.finrank (ZMod 2) (permuteCode sigma C) =
      Module.finrank (ZMod 2) C := by
  rw [permuteCode_eq_map_equiv]
  exact LinearEquiv.finrank_map_eq (permuteBinaryVectorEquiv sigma) C

/-- Code equivalence preserves the `[n,k,d]` predicate. -/
theorem CodeEquivalent.isLinearCode {n : ℕ} {C D : BinaryLinearCode n}
    {k d : ℕ} (hCD : CodeEquivalent C D) (hC : IsLinearCode C k d) :
    IsLinearCode D k d := by
  obtain ⟨sigma, rfl⟩ := hCD
  exact {
    dim_eq := by
      rw [finrank_permuteCode]
      exact hC.dim_eq
    min_dist := by
      intro v hv hne
      rw [mem_permuteCode_iff] at hv
      rw [← hammingWeight_permuteBinaryVector sigma.symm]
      exact hC.min_dist _ hv (permuteBinaryVector_ne_zero _ _ hne)
    min_dist_achieved := by
      obtain ⟨w, hw_mem, hw_ne, hw_wt⟩ := hC.min_dist_achieved
      exact ⟨permuteBinaryVector sigma w,
        ⟨w, hw_mem, rfl⟩,
        permuteBinaryVector_ne_zero sigma w hw_ne,
        by rw [hammingWeight_permuteBinaryVector]; exact hw_wt⟩ }

end CodeLatticeE8.Code
