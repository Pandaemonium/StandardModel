import PhysicsSM.Draft.HammingWeightEnumeratorNoNativeAristotle
import PhysicsSM.Coding.Hamming844UniquenessBasic

/-!
# Concrete extended Hamming facts without n a t i v e _ d e c i d e

This module provides no-native certificates for the concrete extended Hamming
code `extendedHamming8`.  These theorems replace the remaining finite
`n a t i v e _ d e c i d e` checks used by `extendedHamming8_isLinearCode_4_4`:

* the 16-codeword cardinality;
* the dimension-four statement;
* minimum distance at least four;
* doubly-evenness;
* an explicit weight-four witness.

The proof uses the structural four-parameter description of the code from
`HammingWeightEnumeratorNoNativeAristotle`: every codeword is uniquely
`codewordOfMsg msg` for a message `msg : Fin 4 -> ZMod 2`.

Provenance: Aristotle job `98effd4a-af1a-461b-a1f0-da62c4d5e721`, reviewed
and integrated 2026-05-19.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding

/-! ### Helper: the codeword filter equals the image of `codewordOfMsg` -/

/-- The set of codewords, as a `Finset`, is exactly the image of
`codewordOfMsg` over all 4-bit messages. -/
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

/-- No-native replacement for `extendedHamming8_card`. -/
theorem extendedHamming8_card_no_native :
    (Finset.univ.filter (fun v : BinaryVector 8 =>
      Matrix.mulVec extendedHamming8ParityCheck v = 0)).card = 16 := by
  rw [code_filter_eq_image]
  rw [Finset.card_image_of_injective _ codewordOfMsg_injective]
  -- `Fin 4 -> ZMod 2` has `2^4 = 16` elements.
  simp [ZMod.card]

/-- No-native replacement for `extendedHamming8_subtype_card`. -/
theorem extendedHamming8_subtype_card_no_native :
    Fintype.card ↥extendedHamming8 = 16 := by
  rw [Fintype.card_subtype]
  exact extendedHamming8_card_no_native

/-- No-native replacement for `extendedHamming8_finrank`. -/
theorem extendedHamming8_finrank_no_native :
    Module.finrank (ZMod 2) extendedHamming8 = 4 := by
  have h1 := extendedHamming8_subtype_card_no_native
  have h2 := @Module.card_eq_pow_finrank (ZMod 2) extendedHamming8 _ _ _ _ _
  simp only [ZMod.card] at h2
  rw [h1] at h2
  have h3 : 2 ^ Module.finrank (ZMod 2) ↥extendedHamming8 = 2 ^ 4 := by omega
  exact Nat.pow_right_injective (by norm_num : 1 < 2) h3

/-- No-native replacement for `extendedHamming8_minWeight`. -/
theorem extendedHamming8_minWeight_no_native (v : BinaryVector 8)
    (hv : Matrix.mulVec extendedHamming8ParityCheck v = 0)
    (hne : v ≠ 0) : 4 ≤ hammingWeight v := by
  rcases extendedHamming8_weight_support_no_native v hv with h0 | h4 | h8
  · -- Weight zero means every coordinate is zero, contradicting `hne`.
    exfalso
    apply hne
    ext i
    simp only [hammingWeight, Finset.card_eq_zero, Finset.filter_eq_empty_iff] at h0
    simpa using h0 (Finset.mem_univ i)
  · omega
  · omega

/-- No-native replacement for `extendedHamming8_doublyEven`. -/
theorem extendedHamming8_doublyEven_no_native (v : BinaryVector 8)
    (hv : Matrix.mulVec extendedHamming8ParityCheck v = 0) :
    4 ∣ hammingWeight v := by
  rcases extendedHamming8_weight_support_no_native v hv with h0 | h4 | h8
  · rw [h0]
    exact dvd_zero 4
  · rw [h4]
  · rw [h8]
    exact ⟨2, rfl⟩

/-- Submodule-facing no-native minimum-distance theorem. -/
theorem extendedHamming8_minWeight_no_native' (v : BinaryVector 8)
    (hv : v ∈ extendedHamming8) (hne : v ≠ 0) :
    4 ≤ hammingWeight v :=
  extendedHamming8_minWeight_no_native v
    ((extendedHamming8_mem_iff_mulVec v).mp hv) hne

/-- Submodule-facing no-native doubly-even theorem. -/
theorem extendedHamming8_doublyEven_no_native' (v : BinaryVector 8)
    (hv : v ∈ extendedHamming8) : 4 ∣ hammingWeight v :=
  extendedHamming8_doublyEven_no_native v
    ((extendedHamming8_mem_iff_mulVec v).mp hv)

/-- No-native replacement for the explicit weight-4 witness. -/
theorem extendedHamming8_has_weight4_no_native :
    ∃ v, v ∈ extendedHamming8 ∧ v ≠ 0 ∧ hammingWeight v = 4 := by
  refine ⟨![0, 0, 0, 1, 1, 1, 1, 0], ?_, ?_, ?_⟩
  · -- Membership: this vector is `codewordOfMsg ![0, 1, 1, 1]`.
    rw [extendedHamming8_mem_iff_mulVec]
    have : (![0, 0, 0, 1, 1, 1, 1, 0] : BinaryVector 8) =
        codewordOfMsg ![0, 1, 1, 1] := by decide
    rw [this]
    exact codewordOfMsg_mem_code ![0, 1, 1, 1]
  · intro h
    have := congr_fun h 3
    simp at this
  · decide

/-- No-native certificate that the concrete extended Hamming code is `[8,4,4]`. -/
theorem extendedHamming8_isLinearCode_4_4_no_native :
    IsLinearCode extendedHamming8 4 4 where
  dim_eq := extendedHamming8_finrank_no_native
  min_dist := fun v hv hne => extendedHamming8_minWeight_no_native' v hv hne
  min_dist_achieved := extendedHamming8_has_weight4_no_native

end PhysicsSM.Coding
