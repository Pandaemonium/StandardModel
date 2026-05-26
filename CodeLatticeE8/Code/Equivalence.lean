import CodeLatticeE8.Code.Binary

/-!
# Equivalence of binary linear codes

This module defines coordinate permutation for binary vectors and the induced
equivalence relation on binary linear codes.

Convention: `permuteBinaryVector sigma v` is the vector whose coordinate `i`
is the old coordinate `sigma.symm i`.  Thus `sigma` describes where positions
move in the output, and the implementation uses the inverse permutation when
reading from the input vector.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.Code

/-! ## Coordinate permutations -/

/-- Permute the coordinates of a binary vector. -/
def permuteBinaryVector {n : ℕ} (sigma : Equiv.Perm (Fin n))
    (v : BinaryVector n) : BinaryVector n :=
  v ∘ sigma.symm

@[simp]
theorem permuteBinaryVector_apply {n : ℕ} (sigma : Equiv.Perm (Fin n))
    (v : BinaryVector n) (i : Fin n) :
    permuteBinaryVector sigma v i = v (sigma.symm i) := rfl

@[simp]
theorem permuteBinaryVector_one {n : ℕ} (v : BinaryVector n) :
    permuteBinaryVector 1 v = v := by
  ext i
  simp [permuteBinaryVector]

theorem permuteBinaryVector_mul {n : ℕ} (sigma tau : Equiv.Perm (Fin n))
    (v : BinaryVector n) :
    permuteBinaryVector tau (permuteBinaryVector sigma v) =
      permuteBinaryVector (tau * sigma) v := by
  ext i
  simp [permuteBinaryVector, Function.comp, Equiv.symm_trans_apply, Equiv.Perm.mul_def]

@[simp]
theorem permuteBinaryVector_inv_cancel {n : ℕ} (sigma : Equiv.Perm (Fin n))
    (v : BinaryVector n) :
    permuteBinaryVector sigma.symm (permuteBinaryVector sigma v) = v := by
  ext i
  simp [permuteBinaryVector, Function.comp]

@[simp]
theorem permuteBinaryVector_cancel_inv {n : ℕ} (sigma : Equiv.Perm (Fin n))
    (v : BinaryVector n) :
    permuteBinaryVector sigma (permuteBinaryVector sigma.symm v) = v := by
  ext i
  simp [permuteBinaryVector]

/-- Coordinate permutation is injective. -/
theorem permuteBinaryVector_injective {n : ℕ} (sigma : Equiv.Perm (Fin n)) :
    Function.Injective (permuteBinaryVector sigma) := by
  intro a b h
  have h_cancelled := congr_arg (permuteBinaryVector sigma.symm) h
  simpa using h_cancelled

/-- Coordinate permutation is surjective. -/
theorem permuteBinaryVector_surjective {n : ℕ} (sigma : Equiv.Perm (Fin n)) :
    Function.Surjective (permuteBinaryVector sigma) := by
  intro v
  exact ⟨permuteBinaryVector sigma.symm v, by simp⟩

@[simp]
theorem permuteBinaryVector_zero {n : ℕ} (sigma : Equiv.Perm (Fin n)) :
    permuteBinaryVector sigma (0 : BinaryVector n) = 0 := by
  ext i
  simp [permuteBinaryVector]

theorem permuteBinaryVector_add {n : ℕ} (sigma : Equiv.Perm (Fin n))
    (v w : BinaryVector n) :
    permuteBinaryVector sigma (v + w) =
      permuteBinaryVector sigma v + permuteBinaryVector sigma w := by
  ext i
  simp [permuteBinaryVector, Pi.add_apply]

/-- Coordinate permutation as a linear map. -/
def permuteBinaryVectorLinear {n : ℕ} (sigma : Equiv.Perm (Fin n)) :
    BinaryVector n →ₗ[ZMod 2] BinaryVector n where
  toFun := permuteBinaryVector sigma
  map_add' := permuteBinaryVector_add sigma
  map_smul' := by
    intro c v
    ext i
    simp [permuteBinaryVector, Pi.smul_apply]

/-- Permuting coordinates preserves nonzeroness. -/
theorem permuteBinaryVector_ne_zero {n : ℕ} (sigma : Equiv.Perm (Fin n))
    (v : BinaryVector n) (hv : v ≠ 0) :
    permuteBinaryVector sigma v ≠ 0 := by
  intro h
  apply hv
  have h_cancelled := congr_arg (permuteBinaryVector sigma.symm) h
  simpa using h_cancelled

/-- Hamming weight is invariant under coordinate permutation. -/
theorem hammingWeight_permuteBinaryVector {n : ℕ} (sigma : Equiv.Perm (Fin n))
    (v : BinaryVector n) :
    hammingWeight (permuteBinaryVector sigma v) = hammingWeight v := by
  unfold hammingWeight permuteBinaryVector
  rw [Finset.card_filter, Finset.card_filter]
  conv_rhs => rw [← Equiv.sum_comp sigma.symm]
  rfl

/-! ## Code equivalence -/

/-- The image of a code under coordinate permutation. -/
def permuteCode {n : ℕ} (sigma : Equiv.Perm (Fin n))
    (C : BinaryLinearCode n) : BinaryLinearCode n :=
  C.map (permuteBinaryVectorLinear sigma)

/-- Membership in a permuted code can be tested by inverse-permuting. -/
theorem mem_permuteCode_iff {n : ℕ} (sigma : Equiv.Perm (Fin n))
    (C : BinaryLinearCode n) (v : BinaryVector n) :
    v ∈ permuteCode sigma C ↔ permuteBinaryVector sigma.symm v ∈ C := by
  constructor
  · intro hv
    obtain ⟨w, hwC, hw⟩ := hv
    have hw_eq : permuteBinaryVector sigma w = v := by
      simpa [permuteBinaryVectorLinear] using hw
    rw [← hw_eq]
    simpa using hwC
  · intro hv
    use permuteBinaryVector sigma.symm v
    exact ⟨hv, by ext i; simp +decide [permuteBinaryVectorLinear]⟩

/-- Two binary linear codes are equivalent if one is obtained from the other by
a coordinate permutation. -/
def CodeEquivalent {n : ℕ} (C D : BinaryLinearCode n) : Prop :=
  ∃ sigma : Equiv.Perm (Fin n), permuteCode sigma C = D

@[simp]
theorem permuteCode_one {n : ℕ} (C : BinaryLinearCode n) :
    permuteCode 1 C = C := by
  ext v
  simp [permuteCode, permuteBinaryVectorLinear]

theorem permuteCode_mul {n : ℕ} (sigma tau : Equiv.Perm (Fin n))
    (C : BinaryLinearCode n) :
    permuteCode tau (permuteCode sigma C) = permuteCode (tau * sigma) C := by
  ext v
  simp only [permuteCode, Submodule.mem_map]
  constructor
  · rintro ⟨w, ⟨u, huC, rfl⟩, rfl⟩
    refine ⟨u, huC, ?_⟩
    ext i
    simp only [permuteBinaryVectorLinear, LinearMap.coe_mk, AddHom.coe_mk]
    exact (congr_fun (permuteBinaryVector_mul sigma tau u) i).symm
  · rintro ⟨u, huC, rfl⟩
    refine ⟨(permuteBinaryVectorLinear sigma) u, ⟨u, huC, rfl⟩, ?_⟩
    ext i
    simp only [permuteBinaryVectorLinear, LinearMap.coe_mk, AddHom.coe_mk]
    exact congr_fun (permuteBinaryVector_mul sigma tau u) i

theorem CodeEquivalent.refl {n : ℕ} (C : BinaryLinearCode n) :
    CodeEquivalent C C := by
  exact ⟨1, by ext v; simp [permuteCode, permuteBinaryVectorLinear]⟩

theorem CodeEquivalent.symm {n : ℕ} {C D : BinaryLinearCode n}
    (h : CodeEquivalent C D) : CodeEquivalent D C := by
  obtain ⟨sigma, rfl⟩ := h
  use sigma.symm
  ext v
  simp +decide [mem_permuteCode_iff, Equiv.symm_symm]

theorem CodeEquivalent.trans {n : ℕ} {C D E : BinaryLinearCode n}
    (hCD : CodeEquivalent C D) (hDE : CodeEquivalent D E) :
    CodeEquivalent C E := by
  obtain ⟨sigma, hsigma⟩ := hCD
  obtain ⟨tau, htau⟩ := hDE
  refine ⟨tau * sigma, ?_⟩
  rw [← htau, ← hsigma, permuteCode_mul]

/-- Code equivalence is an equivalence relation. -/
theorem codeEquivalent_equivalence (n : ℕ) :
    Equivalence (@CodeEquivalent n) :=
  ⟨CodeEquivalent.refl, fun h => h.symm, fun h1 h2 => h1.trans h2⟩

/-- Minimum-weight lower bounds are invariant under coordinate permutation. -/
theorem minWeight_preserved_of_permuteCode {n : ℕ} (sigma : Equiv.Perm (Fin n))
    (C : BinaryLinearCode n) (d : ℕ) :
    (∀ v ∈ C, v ≠ 0 → d ≤ hammingWeight v) ↔
    (∀ v ∈ permuteCode sigma C, v ≠ 0 → d ≤ hammingWeight v) := by
  constructor
  · intro h v hv hv'
    rw [mem_permuteCode_iff] at hv
    rw [← hammingWeight_permuteBinaryVector sigma.symm]
    exact h (permuteBinaryVector sigma.symm v) hv
      (permuteBinaryVector_ne_zero sigma.symm v hv')
  · intro h v hv hv'
    have hmem : permuteBinaryVector sigma v ∈ permuteCode sigma C := ⟨v, hv, rfl⟩
    rw [← hammingWeight_permuteBinaryVector sigma v]
    exact h (permuteBinaryVector sigma v) hmem
      (permuteBinaryVector_ne_zero sigma v hv')

/-- Doubly-evenness is invariant under coordinate permutation. -/
theorem isDoublyEven_permuteCode {n : ℕ} (sigma : Equiv.Perm (Fin n))
    (C : BinaryLinearCode n) :
    IsDoublyEven C ↔ IsDoublyEven (permuteCode sigma C) := by
  constructor
  · intro hC v hv
    obtain ⟨w, hwC, rfl⟩ := hv
    show 4 ∣ hammingWeight (permuteBinaryVectorLinear sigma w)
    simp only [permuteBinaryVectorLinear, LinearMap.coe_mk, AddHom.coe_mk,
      hammingWeight_permuteBinaryVector]
    exact hC w hwC
  · intro hC' v hv
    have hmem : permuteBinaryVector sigma v ∈ permuteCode sigma C := ⟨v, hv, rfl⟩
    rw [← hammingWeight_permuteBinaryVector sigma v]
    exact hC' (permuteBinaryVector sigma v) hmem

end CodeLatticeE8.Code
