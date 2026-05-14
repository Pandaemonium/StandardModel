import Mathlib
import PhysicsSM.Coding.ConstructionA
import PhysicsSM.Coding.HammingE8

/-!
# Code equivalence under coordinate permutations

This module defines the notion of equivalence of binary linear codes under
coordinate permutations (column permutations of the generator/parity-check
matrix). Two codes are *equivalent* if one can be obtained from the other by
permuting the coordinate positions.

We prove that code equivalence is an equivalence relation, and that key
code-theoretic invariants — Hamming weight, minimum distance, and the
doubly-even property — are preserved under coordinate permutations.

## Main definitions

- `permuteBinaryVector σ v`: permute coordinates of `v` by `σ : Equiv.Perm (Fin n)`.
- `permuteCode σ C`: the image of code `C` under coordinate permutation `σ`.
- `CodeEquivalent C D`: two codes are equivalent iff there exists a coordinate
  permutation mapping one to the other.

## Main results

- `CodeEquivalent.refl`, `CodeEquivalent.symm`, `CodeEquivalent.trans`:
  code equivalence is an equivalence relation.
- `hammingWeight_permuteBinaryVector`: Hamming weight is invariant under
  coordinate permutations.
- `minWeight_permuteCode`: minimum weight is preserved by code equivalence.
- `isDoublyEven_permuteCode`: the doubly-even property is preserved by code
  equivalence.

## Finite-computation trust note

This file does not use `native_decide`. All proofs are structural.

## Source / provenance

- Huffman & Pless, *Fundamentals of Error-Correcting Codes*, Chapter 1.
- Aristotle job for PhysicsSM, 2026-05-07.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Coding

/-! ## Coordinate permutation of binary vectors -/

/-- Permute the coordinates of a binary vector by a permutation `σ`.
The resulting vector satisfies `(permuteBinaryVector σ v) i = v (σ⁻¹ i)`,
so that position `i` of the output receives the value that was at position
`σ⁻¹ i` in the input. This is the standard "right action" convention. -/
def permuteBinaryVector {n : ℕ} (σ : Equiv.Perm (Fin n)) (v : BinaryVector n) :
    BinaryVector n :=
  v ∘ σ.symm

@[simp]
theorem permuteBinaryVector_apply {n : ℕ} (σ : Equiv.Perm (Fin n))
    (v : BinaryVector n) (i : Fin n) :
    permuteBinaryVector σ v i = v (σ.symm i) := rfl

/-- Permuting by the identity does nothing. -/
@[simp]
theorem permuteBinaryVector_one {n : ℕ} (v : BinaryVector n) :
    permuteBinaryVector 1 v = v := by
  ext i; simp [permuteBinaryVector]

/-- Permuting by `σ` then `τ` is the same as permuting by `τ * σ`.
Note: we use `Equiv.Perm` multiplication convention `(τ * σ) x = τ (σ x)`. -/
theorem permuteBinaryVector_mul {n : ℕ} (σ τ : Equiv.Perm (Fin n))
    (v : BinaryVector n) :
    permuteBinaryVector τ (permuteBinaryVector σ v) =
      permuteBinaryVector (τ * σ) v := by
  ext i; simp [permuteBinaryVector, Function.comp, Equiv.symm_trans_apply, Equiv.Perm.mul_def]

/-- Permuting by `σ` then `σ⁻¹` recovers the original vector. -/
@[simp]
theorem permuteBinaryVector_inv_cancel {n : ℕ} (σ : Equiv.Perm (Fin n))
    (v : BinaryVector n) :
    permuteBinaryVector σ.symm (permuteBinaryVector σ v) = v := by
  ext i; simp [permuteBinaryVector, Function.comp]

/-- Permuting by `σ⁻¹` then `σ` recovers the original vector. -/
@[simp]
theorem permuteBinaryVector_cancel_inv {n : ℕ} (σ : Equiv.Perm (Fin n))
    (v : BinaryVector n) :
    permuteBinaryVector σ (permuteBinaryVector σ.symm v) = v := by
  ext i; simp [permuteBinaryVector]

/-- Coordinate permutation is injective. -/
theorem permuteBinaryVector_injective {n : ℕ} (σ : Equiv.Perm (Fin n)) :
    Function.Injective (permuteBinaryVector σ) := by
  intro a b h
  have := congr_arg (permuteBinaryVector σ.symm) h
  simp only [permuteBinaryVector_inv_cancel] at this
  exact this

/-- Coordinate permutation is surjective. -/
theorem permuteBinaryVector_surjective {n : ℕ} (σ : Equiv.Perm (Fin n)) :
    Function.Surjective (permuteBinaryVector σ) := by
  intro v; exact ⟨permuteBinaryVector σ.symm v, by simp⟩

/-- Coordinate permutation is bijective. -/
theorem permuteBinaryVector_bijective {n : ℕ} (σ : Equiv.Perm (Fin n)) :
    Function.Bijective (permuteBinaryVector σ) :=
  ⟨permuteBinaryVector_injective σ, permuteBinaryVector_surjective σ⟩

/-- Coordinate permutation preserves zero. -/
@[simp]
theorem permuteBinaryVector_zero {n : ℕ} (σ : Equiv.Perm (Fin n)) :
    permuteBinaryVector σ (0 : BinaryVector n) = 0 := by
  ext i; simp [permuteBinaryVector]

/-- Coordinate permutation preserves addition. -/
theorem permuteBinaryVector_add {n : ℕ} (σ : Equiv.Perm (Fin n))
    (v w : BinaryVector n) :
    permuteBinaryVector σ (v + w) =
      permuteBinaryVector σ v + permuteBinaryVector σ w := by
  ext i; simp [permuteBinaryVector, Pi.add_apply]

/-- Coordinate permutation as a linear map. -/
def permuteBinaryVectorLinear {n : ℕ} (σ : Equiv.Perm (Fin n)) :
    BinaryVector n →ₗ[ZMod 2] BinaryVector n where
  toFun := permuteBinaryVector σ
  map_add' := permuteBinaryVector_add σ
  map_smul' := by
    intro c v; ext i
    simp [permuteBinaryVector, Pi.smul_apply]

/-- Permuting preserves being nonzero. -/
theorem permuteBinaryVector_ne_zero {n : ℕ} (σ : Equiv.Perm (Fin n))
    (v : BinaryVector n) (hv : v ≠ 0) :
    permuteBinaryVector σ v ≠ 0 := by
  intro h
  apply hv
  have := congr_arg (permuteBinaryVector σ.symm) h
  simp only [permuteBinaryVector_inv_cancel, permuteBinaryVector_zero] at this
  exact this

/-! ## Hamming weight invariance -/

/-
**Hamming weight is invariant under coordinate permutation.**

This is the key weight-preservation theorem: permuting coordinate positions
does not change the number of nonzero entries.
-/
theorem hammingWeight_permuteBinaryVector {n : ℕ} (σ : Equiv.Perm (Fin n))
    (v : BinaryVector n) :
    hammingWeight (permuteBinaryVector σ v) = hammingWeight v := by
  unfold hammingWeight permuteBinaryVector;
  rw [ Finset.card_filter, Finset.card_filter ];
  conv_rhs => rw [ ← Equiv.sum_comp σ.symm ] ;
  rfl

/-! ## Code permutation -/

/-- Permute all codewords of a binary linear code by `σ`. The result is the
image of the code under the linear coordinate permutation. -/
def permuteCode {n : ℕ} (σ : Equiv.Perm (Fin n)) (C : BinaryLinearCode n) :
    BinaryLinearCode n :=
  C.map (permuteBinaryVectorLinear σ)

/-
A vector is in the permuted code iff its inverse-permuted preimage is in
the original code.
-/
theorem mem_permuteCode_iff {n : ℕ} (σ : Equiv.Perm (Fin n))
    (C : BinaryLinearCode n) (v : BinaryVector n) :
    v ∈ permuteCode σ C ↔ permuteBinaryVector σ.symm v ∈ C := by
  constructor;
  · intro hv
    obtain ⟨w, hwC, hw⟩ := hv;
    unfold permuteBinaryVectorLinear at hw; aesop;
  · intro hv;
    use permuteBinaryVector σ.symm v;
    exact ⟨ hv, by ext i; simp +decide [ permuteBinaryVectorLinear ] ⟩

/-! ## Code equivalence -/

/-- Two binary linear codes of the same length are *equivalent* if one can be
obtained from the other by a coordinate permutation. -/
def CodeEquivalent {n : ℕ} (C D : BinaryLinearCode n) : Prop :=
  ∃ σ : Equiv.Perm (Fin n), permuteCode σ C = D

/-
Code equivalence is reflexive.
-/
theorem CodeEquivalent.refl {n : ℕ} (C : BinaryLinearCode n) :
    CodeEquivalent C C := by
  exact ⟨1, by ext v; simp [permuteCode, permuteBinaryVectorLinear]⟩

/-
Code equivalence is symmetric.
-/
theorem CodeEquivalent.symm {n : ℕ} {C D : BinaryLinearCode n}
    (h : CodeEquivalent C D) : CodeEquivalent D C := by
  obtain ⟨ σ, rfl ⟩ := h;
  use σ.symm;
  ext v;
  simp +decide [ mem_permuteCode_iff, Equiv.symm_symm ]

/-
Code equivalence is transitive.
-/
theorem CodeEquivalent.trans {n : ℕ} {C D E : BinaryLinearCode n}
    (hCD : CodeEquivalent C D) (hDE : CodeEquivalent D E) :
    CodeEquivalent C E := by
  obtain ⟨σ, hσ⟩ := hCD
  obtain ⟨τ, hτ⟩ := hDE
  use τ * σ;
  ext v; simp +decide [ ← hτ, ← hσ ] ;
  simp +decide [ permuteCode ];
  congr! 3

/-- Code equivalence as an `Equivalence` relation. -/
theorem codeEquivalent_equivalence (n : ℕ) :
    Equivalence (@CodeEquivalent n) :=
  ⟨CodeEquivalent.refl, fun h => h.symm, fun h1 h2 => h1.trans h2⟩

/-! ## Invariants under code equivalence -/

/-
The minimum Hamming weight of a code (over nonzero codewords) is preserved
by coordinate permutation.
-/
theorem minWeight_preserved_of_permuteCode {n : ℕ} (σ : Equiv.Perm (Fin n))
    (C : BinaryLinearCode n) (d : ℕ) :
    (∀ v ∈ C, v ≠ 0 → d ≤ hammingWeight v) ↔
    (∀ v ∈ permuteCode σ C, v ≠ 0 → d ≤ hammingWeight v) := by
  constructor
  · intro h v hv hv'
    rw [mem_permuteCode_iff] at hv
    rw [← hammingWeight_permuteBinaryVector σ.symm]
    exact h _ hv (permuteBinaryVector_ne_zero _ _ hv')
  · intro h v hv hv'
    have hmem : permuteBinaryVector σ v ∈ permuteCode σ C := ⟨v, hv, rfl⟩
    rw [← hammingWeight_permuteBinaryVector σ v]
    exact h _ hmem (permuteBinaryVector_ne_zero _ _ hv')

/-
The doubly-even property is preserved by coordinate permutation.
-/
theorem isDoublyEven_permuteCode {n : ℕ} (σ : Equiv.Perm (Fin n))
    (C : BinaryLinearCode n) :
    IsDoublyEven C ↔ IsDoublyEven (permuteCode σ C) := by
  constructor
  · intro hC v hv
    obtain ⟨w, hwC, rfl⟩ := hv
    show 4 ∣ hammingWeight (permuteBinaryVectorLinear σ w)
    simp only [permuteBinaryVectorLinear, LinearMap.coe_mk, AddHom.coe_mk,
      hammingWeight_permuteBinaryVector]
    exact hC w hwC
  · intro hC' v hv
    have hmem : permuteBinaryVector σ v ∈ permuteCode σ C := ⟨v, hv, rfl⟩
    rw [← hammingWeight_permuteBinaryVector σ v]
    exact hC' _ hmem

/-! ## `permuteCode` interaction with identity and composition -/

/-
Permuting by the identity preserves the code.
-/
@[simp]
theorem permuteCode_one {n : ℕ} (C : BinaryLinearCode n) :
    permuteCode 1 C = C := by
  ext; simp [permuteCode, permuteBinaryVectorLinear]

/-
Composing permutations on codes.
-/
theorem permuteCode_mul {n : ℕ} (σ τ : Equiv.Perm (Fin n))
    (C : BinaryLinearCode n) :
    permuteCode τ (permuteCode σ C) = permuteCode (τ * σ) C := by
  ext v
  simp only [permuteCode, Submodule.mem_map]
  constructor
  · rintro ⟨w, ⟨u, huC, rfl⟩, rfl⟩
    refine ⟨u, huC, ?_⟩
    ext i; simp only [permuteBinaryVectorLinear, LinearMap.coe_mk, AddHom.coe_mk]
    exact (congr_fun (permuteBinaryVector_mul σ τ u) i).symm
  · rintro ⟨u, huC, rfl⟩
    refine ⟨(permuteBinaryVectorLinear σ) u, ⟨u, huC, rfl⟩, ?_⟩
    ext i; simp only [permuteBinaryVectorLinear, LinearMap.coe_mk, AddHom.coe_mk]
    exact congr_fun (permuteBinaryVector_mul σ τ u) i

end PhysicsSM.Coding
