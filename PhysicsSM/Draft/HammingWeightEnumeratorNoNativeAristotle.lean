import PhysicsSM.Coding.HammingWeightEnumerator

/-!
# Aristotle target: no-native Hamming weight enumerator

This file proves the weight distribution of the extended Hamming `[8,4,4]` code
without `n a t i v e _ d e c i d e`. The approach:

1. Parametrize the 16 codewords via four free coordinates (positions 2,4,5,6)
   solved from the parity-check equations.
2. Show every codeword arises from this parametrization.
3. Reduce weight-distribution counting from 2⁸ = 256 vectors to 2⁴ = 16
   messages, where `decide` handles the small enumeration.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding

/-! ## Structural parametrization of the extended Hamming [8,4,4] code

The parity-check matrix H has rows:
  Row 0: v₀ + v₁ + v₂ + v₃ + v₄ + v₅ + v₆ + v₇ = 0  (overall parity)
  Row 1: v₃ + v₄ + v₅ + v₆ = 0
  Row 2: v₁ + v₂ + v₅ + v₆ = 0
  Row 3: v₀ + v₂ + v₄ + v₆ = 0

Choosing free coordinates a = v₂, b = v₄, c = v₅, d = v₆, the dependent
coordinates are:
  v₀ = a + b + d       (from Row 3)
  v₁ = a + c + d       (from Row 2)
  v₃ = b + c + d       (from Row 1)
  v₇ = a + b + c       (from Row 0 + Rows 1–3)
-/

/-- Encode a 4-bit message into an 8-bit codeword.
    `msg 0` = v₂, `msg 1` = v₄, `msg 2` = v₅, `msg 3` = v₆. -/
def codewordOfMsg (msg : Fin 4 → ZMod 2) : BinaryVector 8 :=
  ![msg 0 + msg 1 + msg 3,
    msg 0 + msg 2 + msg 3,
    msg 0,
    msg 1 + msg 2 + msg 3,
    msg 1,
    msg 2,
    msg 3,
    msg 0 + msg 1 + msg 2]

/-- Extract the message (free coordinates v₂, v₄, v₅, v₆) from a vector. -/
def msgOfCodeword (v : BinaryVector 8) : Fin 4 → ZMod 2 :=
  ![v 2, v 4, v 5, v 6]

/-! ### Parametrization lemmas -/

/-
Extracting the message from an encoded codeword recovers the message.
-/
theorem msg_codeword_left_inv (msg : Fin 4 → ZMod 2) :
    msgOfCodeword (codewordOfMsg msg) = msg := by
  decide +revert

/-
Every encoded message satisfies the parity-check equations.
-/
theorem codewordOfMsg_mem_code (msg : Fin 4 → ZMod 2) :
    Matrix.mulVec extendedHamming8ParityCheck (codewordOfMsg msg) = 0 := by
  decide +revert

/-
For any codeword, encoding the extracted message recovers the codeword.
    This is the key surjectivity lemma: every codeword arises from the
    parametrization.
-/
theorem codeword_msg_right_inv (v : BinaryVector 8)
    (hv : Matrix.mulVec extendedHamming8ParityCheck v = 0) :
    codewordOfMsg (msgOfCodeword v) = v := by
  revert hv;
  simp +decide [ funext_iff, Fin.forall_fin_succ ];
  simp +decide [ Matrix.mulVec, dotProduct ];
  simp +decide [ extendedHamming8ParityCheck ];
  simp +decide [ Fin.sum_univ_succ, codewordOfMsg, msgOfCodeword ];
  grind

/-- The encoding function is injective (immediate from the left inverse). -/
theorem codewordOfMsg_injective : Function.Injective codewordOfMsg :=
  Function.HasLeftInverse.injective ⟨msgOfCodeword, msg_codeword_left_inv⟩

/-! ### Weight classification from the parametrization -/

/-
Every encoded message has weight 0, 4, or 8 (16-case `decide`).
-/
theorem codewordOfMsg_weight_class (msg : Fin 4 → ZMod 2) :
    hammingWeight (codewordOfMsg msg) = 0 ∨
    hammingWeight (codewordOfMsg msg) = 4 ∨
    hammingWeight (codewordOfMsg msg) = 8 := by
  decide +revert

/-! ### Reduction of weight distribution to 16-element enumeration -/

/-
The codeword filter equals the image of the message filter.
-/
theorem code_weight_filter_eq_image (w : ℕ) :
    Finset.univ.filter (fun v : BinaryVector 8 =>
      Matrix.mulVec extendedHamming8ParityCheck v = 0 ∧ hammingWeight v = w) =
    Finset.image codewordOfMsg (Finset.univ.filter (fun msg : Fin 4 → ZMod 2 =>
      hammingWeight (codewordOfMsg msg) = w)) := by
  ext v; simp [codewordOfMsg_mem_code, codeword_msg_right_inv];
  constructor;
  · exact fun h => ⟨ msgOfCodeword v, by simpa [ codeword_msg_right_inv v h.1 ] using h.2, codeword_msg_right_inv v h.1 ⟩;
  · rintro ⟨ a, rfl, rfl ⟩ ; exact ⟨ codewordOfMsg_mem_code a, rfl ⟩

/-- Weight distribution equals message-space count. -/
theorem weightDist_eq_msg_count (w : ℕ) :
    extendedHamming8WeightDist w =
    (Finset.univ.filter (fun msg : Fin 4 → ZMod 2 =>
      hammingWeight (codewordOfMsg msg) = w)).card := by
  unfold extendedHamming8WeightDist
  rw [code_weight_filter_eq_image]
  exact Finset.card_image_of_injective _ codewordOfMsg_injective

/-! ## Main theorems -/

/-- No-native replacement: there is exactly one codeword of weight zero. -/
theorem extendedHamming8_weight_zero_count_no_native :
    extendedHamming8WeightDist 0 = 1 := by
  rw [weightDist_eq_msg_count]; decide

/-- No-native replacement: there are exactly fourteen codewords of weight four. -/
theorem extendedHamming8_weight_four_count_no_native :
    extendedHamming8WeightDist 4 = 14 := by
  rw [weightDist_eq_msg_count]; decide

/-- No-native replacement: there is exactly one codeword of weight eight. -/
theorem extendedHamming8_weight_eight_count_no_native :
    extendedHamming8WeightDist 8 = 1 := by
  rw [weightDist_eq_msg_count]; decide

/-- No-native replacement: every codeword has weight `0`, `4`, or `8`. -/
theorem extendedHamming8_weight_support_no_native (v : BinaryVector 8)
    (hv : Matrix.mulVec extendedHamming8ParityCheck v = 0) :
    hammingWeight v = 0 ∨ hammingWeight v = 4 ∨ hammingWeight v = 8 := by
  rw [← codeword_msg_right_inv v hv]
  exact codewordOfMsg_weight_class (msgOfCodeword v)

/--
No-native replacement for the total weight distribution package.
-/
theorem extendedHamming8_weight_distribution_no_native :
    extendedHamming8WeightDist 0 = 1 ∧
      extendedHamming8WeightDist 4 = 14 ∧
      extendedHamming8WeightDist 8 = 1 :=
  ⟨extendedHamming8_weight_zero_count_no_native,
    extendedHamming8_weight_four_count_no_native,
    extendedHamming8_weight_eight_count_no_native⟩

end PhysicsSM.Coding
