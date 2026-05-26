import CodeLatticeE8.Code.Hamming844WeightEnumerator
import CodeLatticeE8.Code.LinearCode

/-!
# The extended Hamming `[8,4,4]` code

This module starts the interface for the concrete extended
Hamming code.  The theorems here give structural certificates for its
cardinality, dimension, minimum distance, doubly-evenness, and `[8,4,4]`
parameter package.

The key point is that these certificates use the four-message parametrization
from `CodeLatticeE8.Code.Hamming844WeightEnumerator`.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.Code

/-! ## Cardinality and dimension -/

/-- The set of Hamming codewords is exactly the image of `codewordOfMsg`. -/
private theorem code_filter_eq_image :
    Finset.univ.filter (fun v : BinaryVector 8 =>
      Matrix.mulVec extendedHamming8ParityCheck v = 0) =
    Finset.image codewordOfMsg Finset.univ := by
  ext v
  simp only [Finset.mem_filter, Finset.mem_univ, true_and, Finset.mem_image]
  constructor
  · intro hv
    exact ⟨msgOfCodeword v, codeword_msg_right_inv v hv⟩
  · rintro ⟨msg, rfl⟩
    exact codewordOfMsg_mem_code msg

/-- The extended Hamming code has exactly 16 codewords. -/
theorem extendedHamming8_card :
    (Finset.univ.filter (fun v : BinaryVector 8 =>
      Matrix.mulVec extendedHamming8ParityCheck v = 0)).card = 16 := by
  rw [code_filter_eq_image]
  rw [Finset.card_image_of_injective _ codewordOfMsg_injective]
  simp [ZMod.card]

/-- The subtype of codewords has cardinality 16. -/
theorem extendedHamming8_subtype_card :
    Fintype.card ↥extendedHamming8 = 16 := by
  rw [Fintype.card_subtype]
  exact extendedHamming8_card

/-- The extended Hamming code has dimension 4 over `ZMod 2`. -/
theorem extendedHamming8_finrank :
    Module.finrank (ZMod 2) extendedHamming8 = 4 := by
  have h1 := extendedHamming8_subtype_card
  have h2 := @Module.card_eq_pow_finrank (ZMod 2) extendedHamming8 _ _ _ _ _
  simp only [ZMod.card] at h2
  rw [h1] at h2
  have h3 : 2 ^ Module.finrank (ZMod 2) ↥extendedHamming8 = 2 ^ 4 := by omega
  exact Nat.pow_right_injective (by norm_num : 1 < 2) h3

/-! ## Minimum distance and doubly-evenness -/

/-- Every nonzero codeword has Hamming weight at least four. -/
theorem extendedHamming8_minWeight (v : BinaryVector 8)
    (hv : Matrix.mulVec extendedHamming8ParityCheck v = 0)
    (hne : v ≠ 0) : 4 ≤ hammingWeight v := by
  rcases extendedHamming8_weight_support v hv with h0 | h4 | h8
  · exfalso
    apply hne
    ext i
    simp only [hammingWeight, Finset.card_eq_zero, Finset.filter_eq_empty_iff] at h0
    simpa using h0 (Finset.mem_univ i)
  · omega
  · omega

/-- Every codeword has Hamming weight divisible by four. -/
theorem extendedHamming8_doublyEven (v : BinaryVector 8)
    (hv : Matrix.mulVec extendedHamming8ParityCheck v = 0) :
    4 ∣ hammingWeight v := by
  rcases extendedHamming8_weight_support v hv with h0 | h4 | h8
  · rw [h0]
    exact dvd_zero 4
  · rw [h4]
  · rw [h8]
    exact ⟨2, rfl⟩

/-- Submodule-facing minimum-distance theorem. -/
theorem extendedHamming8_minWeight_mem (v : BinaryVector 8)
    (hv : v ∈ extendedHamming8) (hne : v ≠ 0) :
    4 ≤ hammingWeight v :=
  extendedHamming8_minWeight v
    ((extendedHamming8_mem_iff_mulVec v).mp hv) hne

/-- Submodule-facing doubly-even theorem. -/
theorem extendedHamming8_doublyEven_mem (v : BinaryVector 8)
    (hv : v ∈ extendedHamming8) : 4 ∣ hammingWeight v :=
  extendedHamming8_doublyEven v
    ((extendedHamming8_mem_iff_mulVec v).mp hv)

/-- An explicit weight-four codeword. -/
theorem extendedHamming8_has_weight4 :
    ∃ v, v ∈ extendedHamming8 ∧ v ≠ 0 ∧ hammingWeight v = 4 := by
  refine ⟨![0, 0, 0, 1, 1, 1, 1, 0], ?_, ?_, ?_⟩
  · rw [extendedHamming8_mem_iff_mulVec]
    have : (![0, 0, 0, 1, 1, 1, 1, 0] : BinaryVector 8) =
        codewordOfMsg ![0, 1, 1, 1] := by decide
    rw [this]
    exact codewordOfMsg_mem_code ![0, 1, 1, 1]
  · intro h
    have := congr_fun h 3
    simp at this
  · decide

/-- The concrete extended Hamming code is a binary `[8,4,4]` code. -/
theorem extendedHamming8_isLinearCode_4_4 :
    IsLinearCode extendedHamming8 4 4 where
  dim_eq := extendedHamming8_finrank
  min_dist := fun v hv hne => extendedHamming8_minWeight_mem v hv hne
  min_dist_achieved := extendedHamming8_has_weight4

end CodeLatticeE8.Code
