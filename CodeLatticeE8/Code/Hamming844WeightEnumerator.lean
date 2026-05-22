import CodeLatticeE8.Code.Hamming844Basic

/-!
# Structural weight enumerator for the extended Hamming `[8,4,4]` code

This module packages a structural proof of the weight distribution of the
extended Hamming code.  The proof uses a four-parameter description of the
16 codewords instead of enumerating all 256 ambient binary vectors.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.Code

/-! ## Structural parametrization of the extended Hamming code -/

/-- Encode a 4-bit message into an 8-bit codeword.

The free message coordinates are the codeword coordinates `v_2`, `v_4`, `v_5`,
and `v_6`.  The remaining four coordinates are solved from the parity-check
equations of `extendedHamming8ParityCheck`.
-/
def codewordOfMsg (msg : Fin 4 → ZMod 2) : BinaryVector 8 :=
  ![msg 0 + msg 1 + msg 3,
    msg 0 + msg 2 + msg 3,
    msg 0,
    msg 1 + msg 2 + msg 3,
    msg 1,
    msg 2,
    msg 3,
    msg 0 + msg 1 + msg 2]

/-- Extract the message coordinates `(v_2, v_4, v_5, v_6)` from a vector. -/
def msgOfCodeword (v : BinaryVector 8) : Fin 4 → ZMod 2 :=
  ![v 2, v 4, v 5, v 6]

/-- Extracting the message from an encoded codeword recovers the message. -/
theorem msg_codeword_left_inv (msg : Fin 4 → ZMod 2) :
    msgOfCodeword (codewordOfMsg msg) = msg := by
  decide +revert

/-- Every encoded message satisfies the parity-check equations. -/
theorem codewordOfMsg_mem_code (msg : Fin 4 → ZMod 2) :
    Matrix.mulVec extendedHamming8ParityCheck (codewordOfMsg msg) = 0 := by
  decide +revert

/-- Every codeword is recovered by encoding its extracted message. -/
theorem codeword_msg_right_inv (v : BinaryVector 8)
    (hv : Matrix.mulVec extendedHamming8ParityCheck v = 0) :
    codewordOfMsg (msgOfCodeword v) = v := by
  revert hv
  simp +decide [funext_iff, Fin.forall_fin_succ]
  simp +decide [Matrix.mulVec, dotProduct]
  simp +decide [extendedHamming8ParityCheck]
  simp +decide [Fin.sum_univ_succ, codewordOfMsg, msgOfCodeword]
  grind

/-- The encoding map is injective because `msgOfCodeword` is a left inverse. -/
theorem codewordOfMsg_injective : Function.Injective codewordOfMsg :=
  Function.HasLeftInverse.injective ⟨msgOfCodeword, msg_codeword_left_inv⟩

/-- Every encoded message has weight `0`, `4`, or `8`. -/
theorem codewordOfMsg_weight_class (msg : Fin 4 → ZMod 2) :
    hammingWeight (codewordOfMsg msg) = 0 ∨
    hammingWeight (codewordOfMsg msg) = 4 ∨
    hammingWeight (codewordOfMsg msg) = 8 := by
  decide +revert

/-! ## Weight distribution -/

/-- The codeword filter equals the image of the message-space filter. -/
theorem code_weight_filter_eq_image (w : ℕ) :
    Finset.univ.filter (fun v : BinaryVector 8 =>
      Matrix.mulVec extendedHamming8ParityCheck v = 0 ∧ hammingWeight v = w) =
    Finset.image codewordOfMsg (Finset.univ.filter (fun msg : Fin 4 → ZMod 2 =>
      hammingWeight (codewordOfMsg msg) = w)) := by
  ext v
  simp only [Finset.mem_filter, Finset.mem_univ, true_and, Finset.mem_image]
  constructor
  · exact fun h =>
      ⟨msgOfCodeword v, by simpa [codeword_msg_right_inv v h.1] using h.2,
        codeword_msg_right_inv v h.1⟩
  · rintro ⟨a, rfl, rfl⟩
    exact ⟨codewordOfMsg_mem_code a, rfl⟩

/-- Weight distribution reduces to a 16-message count. -/
theorem weightDist_eq_msg_count (w : ℕ) :
    extendedHamming8WeightDist w =
    (Finset.univ.filter (fun msg : Fin 4 → ZMod 2 =>
      hammingWeight (codewordOfMsg msg) = w)).card := by
  unfold extendedHamming8WeightDist
  rw [code_weight_filter_eq_image]
  exact Finset.card_image_of_injective _ codewordOfMsg_injective

/-- There is exactly one codeword of weight zero. -/
theorem extendedHamming8_weight_zero_count :
    extendedHamming8WeightDist 0 = 1 := by
  rw [weightDist_eq_msg_count]
  decide

/-- There are exactly fourteen codewords of weight four. -/
theorem extendedHamming8_weight_four_count :
    extendedHamming8WeightDist 4 = 14 := by
  rw [weightDist_eq_msg_count]
  decide

/-- There is exactly one codeword of weight eight. -/
theorem extendedHamming8_weight_eight_count :
    extendedHamming8WeightDist 8 = 1 := by
  rw [weightDist_eq_msg_count]
  decide

/-- Every codeword has weight `0`, `4`, or `8`. -/
theorem extendedHamming8_weight_support (v : BinaryVector 8)
    (hv : Matrix.mulVec extendedHamming8ParityCheck v = 0) :
    hammingWeight v = 0 ∨ hammingWeight v = 4 ∨ hammingWeight v = 8 := by
  rw [← codeword_msg_right_inv v hv]
  exact codewordOfMsg_weight_class (msgOfCodeword v)

/-- The complete weight distribution package. -/
theorem extendedHamming8_weight_distribution :
    extendedHamming8WeightDist 0 = 1 ∧
      extendedHamming8WeightDist 4 = 14 ∧
      extendedHamming8WeightDist 8 = 1 :=
  ⟨extendedHamming8_weight_zero_count,
    extendedHamming8_weight_four_count,
    extendedHamming8_weight_eight_count⟩

end CodeLatticeE8.Code
