import CodeLatticeE8.Code.Hamming844

/-!
# Dual binary codes and the Type II property of the extended Hamming code

This module promotes the self-duality part of the coding-theory story into the
standalone `CodeLatticeE8` package.  The proof is structural: it uses the
four-message parametrization of the extended Hamming code, rather than a
finite enumeration of all ambient words.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.Code

/-! ## Dual and Type II predicates -/

/-- The dual code `C^\perp` under the binary dot product. -/
def dualCode {n : ℕ} (C : BinaryLinearCode n) : BinaryLinearCode n where
  carrier := { v | ∀ w ∈ C, binaryDot v w = 0 }
  zero_mem' := by
    intro w _hw
    exact binaryDot_zero_left w
  add_mem' := by
    intro a b ha hb w hw
    rw [binaryDot_add_left, ha w hw, hb w hw, add_zero]
  smul_mem' := by
    intro c v hv w hw
    rw [binaryDot_smul_left, hv w hw, mul_zero]

/-- Membership in the dual code is orthogonality to every codeword. -/
theorem mem_dualCode_iff {n : ℕ} (C : BinaryLinearCode n) (v : BinaryVector n) :
    v ∈ dualCode C ↔ ∀ w ∈ C, binaryDot v w = 0 :=
  Iff.rfl

/-- A binary linear code is self-dual if it equals its binary dual. -/
def IsSelfDual {n : ℕ} (C : BinaryLinearCode n) : Prop :=
  C = dualCode C

/-- A Type II binary code is self-dual and doubly even. -/
def IsTypeII {n : ℕ} (C : BinaryLinearCode n) : Prop :=
  IsSelfDual C ∧ IsDoublyEven C

/-! ## Orthogonality of the Hamming code -/

private theorem codewordOfMsg_selfOrthogonal (a b : Fin 4 → ZMod 2) :
    binaryDot (codewordOfMsg a) (codewordOfMsg b) = 0 := by
  simp [binaryDot, codewordOfMsg, Fin.sum_univ_eight]
  ring_nf
  simp [show (2 : ZMod 2) = 0 by decide, show (4 : ZMod 2) = 0 by decide]

/-- Any two extended Hamming codewords are orthogonal under the binary dot product. -/
theorem extendedHamming8_selfOrthogonal (v w : BinaryVector 8)
    (hv : v ∈ extendedHamming8) (hw : w ∈ extendedHamming8) :
    binaryDot v w = 0 := by
  rw [← codeword_msg_right_inv v ((extendedHamming8_mem_iff_mulVec v).mp hv)]
  rw [← codeword_msg_right_inv w ((extendedHamming8_mem_iff_mulVec w).mp hw)]
  exact codewordOfMsg_selfOrthogonal (msgOfCodeword v) (msgOfCodeword w)

/-- The extended Hamming code is contained in its dual. -/
theorem extendedHamming8_le_dual :
    extendedHamming8 ≤ dualCode extendedHamming8 := by
  intro v hv
  rw [mem_dualCode_iff]
  exact fun w hw => extendedHamming8_selfOrthogonal v w hv hw

/-! ## Reverse inclusion -/

private theorem zmod2_two : (2 : ZMod 2) = 0 := by
  decide

private theorem zmod2_three : (3 : ZMod 2) = 1 := by
  decide

private theorem parity_row0_of_basis_dots (x0 x1 x2 x3 x4 x5 x6 x7 : ZMod 2)
    (h0 : x0 + x1 + x2 + x7 = 0)
    (h1 : x0 + x3 + x4 + x7 = 0)
    (h2 : x1 + x3 + x5 + x7 = 0)
    (h3 : x0 + x1 + x3 + x6 = 0) :
    x0 + x1 + x2 + x3 + x4 + x5 + x6 + x7 = 0 := by
  calc
    x0 + x1 + x2 + x3 + x4 + x5 + x6 + x7 =
        (x0 + x1 + x2 + x7) + (x0 + x3 + x4 + x7) +
          (x1 + x3 + x5 + x7) + (x0 + x1 + x3 + x6) := by
      ring_nf
      simp [zmod2_three]
    _ = 0 := by rw [h0, h1, h2, h3]; simp

private theorem parity_row1_of_basis_dots (x0 x1 x3 x4 x5 x6 x7 : ZMod 2)
    (h1 : x0 + x3 + x4 + x7 = 0)
    (h2 : x1 + x3 + x5 + x7 = 0)
    (h3 : x0 + x1 + x3 + x6 = 0) :
    x3 + x4 + x5 + x6 = 0 := by
  calc
    x3 + x4 + x5 + x6 =
        (x0 + x3 + x4 + x7) + (x1 + x3 + x5 + x7) +
          (x0 + x1 + x3 + x6) := by
      ring_nf
      simp [zmod2_two, zmod2_three]
    _ = 0 := by rw [h1, h2, h3]; simp

private theorem parity_row2_of_basis_dots (x0 x1 x2 x3 x5 x6 x7 : ZMod 2)
    (h0 : x0 + x1 + x2 + x7 = 0)
    (h2 : x1 + x3 + x5 + x7 = 0)
    (h3 : x0 + x1 + x3 + x6 = 0) :
    x1 + x2 + x5 + x6 = 0 := by
  calc
    x1 + x2 + x5 + x6 =
        (x0 + x1 + x2 + x7) + (x1 + x3 + x5 + x7) +
          (x0 + x1 + x3 + x6) := by
      ring_nf
      simp [zmod2_two, zmod2_three]
    _ = 0 := by rw [h0, h2, h3]; simp

private theorem parity_row3_of_basis_dots (x0 x1 x2 x3 x4 x6 x7 : ZMod 2)
    (h0 : x0 + x1 + x2 + x7 = 0)
    (h1 : x0 + x3 + x4 + x7 = 0)
    (h3 : x0 + x1 + x3 + x6 = 0) :
    x0 + x2 + x4 + x6 = 0 := by
  calc
    x0 + x2 + x4 + x6 =
        (x0 + x1 + x2 + x7) + (x0 + x3 + x4 + x7) +
          (x0 + x1 + x3 + x6) := by
      ring_nf
      simp [zmod2_two, zmod2_three]
    _ = 0 := by rw [h0, h1, h3]; simp

set_option linter.flexible false in
private theorem orthogonal_to_message_basis_mem (v : BinaryVector 8)
    (h0 : binaryDot v (codewordOfMsg ![1, 0, 0, 0]) = 0)
    (h1 : binaryDot v (codewordOfMsg ![0, 1, 0, 0]) = 0)
    (h2 : binaryDot v (codewordOfMsg ![0, 0, 1, 0]) = 0)
    (h3 : binaryDot v (codewordOfMsg ![0, 0, 0, 1]) = 0) :
    Matrix.mulVec extendedHamming8ParityCheck v = 0 := by
  ext r
  fin_cases r
  · change Matrix.mulVec extendedHamming8ParityCheck v 0 = 0
    simp [Matrix.mulVec, dotProduct, extendedHamming8ParityCheck, binaryDot,
      codewordOfMsg, Fin.sum_univ_eight] at h0 h1 h2 h3 ⊢
    exact parity_row0_of_basis_dots (v 0) (v 1) (v 2) (v 3) (v 4) (v 5) (v 6) (v 7)
      h0 h1 h2 h3
  · change Matrix.mulVec extendedHamming8ParityCheck v 1 = 0
    simp [Matrix.mulVec, dotProduct, extendedHamming8ParityCheck, binaryDot,
      codewordOfMsg, Fin.sum_univ_eight] at h0 h1 h2 h3 ⊢
    exact parity_row1_of_basis_dots (v 0) (v 1) (v 3) (v 4) (v 5) (v 6) (v 7)
      h1 h2 h3
  · change Matrix.mulVec extendedHamming8ParityCheck v 2 = 0
    simp [Matrix.mulVec, dotProduct, extendedHamming8ParityCheck, binaryDot,
      codewordOfMsg, Fin.sum_univ_eight] at h0 h1 h2 h3 ⊢
    exact parity_row2_of_basis_dots (v 0) (v 1) (v 2) (v 3) (v 5) (v 6) (v 7)
      h0 h2 h3
  · change Matrix.mulVec extendedHamming8ParityCheck v 3 = 0
    simp [Matrix.mulVec, dotProduct, extendedHamming8ParityCheck, binaryDot,
      codewordOfMsg, Fin.sum_univ_eight] at h0 h1 h2 h3 ⊢
    exact parity_row3_of_basis_dots (v 0) (v 1) (v 2) (v 3) (v 4) (v 6) (v 7)
      h0 h1 h3

/-- The dual of the extended Hamming code is contained in the code. -/
theorem extendedHamming8_dual_le :
    dualCode extendedHamming8 ≤ extendedHamming8 := by
  intro v hv
  rw [extendedHamming8_mem_iff_mulVec]
  apply orthogonal_to_message_basis_mem
  · exact hv _ ((extendedHamming8_mem_iff_mulVec _).mpr
      (codewordOfMsg_mem_code ![1, 0, 0, 0]))
  · exact hv _ ((extendedHamming8_mem_iff_mulVec _).mpr
      (codewordOfMsg_mem_code ![0, 1, 0, 0]))
  · exact hv _ ((extendedHamming8_mem_iff_mulVec _).mpr
      (codewordOfMsg_mem_code ![0, 0, 1, 0]))
  · exact hv _ ((extendedHamming8_mem_iff_mulVec _).mpr
      (codewordOfMsg_mem_code ![0, 0, 0, 1]))

/-! ## Self-duality and Type II package -/

/-- The extended Hamming `[8,4,4]` code is self-dual. -/
theorem extendedHamming8_selfDual :
    IsSelfDual extendedHamming8 :=
  le_antisymm extendedHamming8_le_dual extendedHamming8_dual_le

/-- The extended Hamming `[8,4,4]` code is Type II. -/
theorem extendedHamming8_typeII :
    IsTypeII extendedHamming8 :=
  ⟨extendedHamming8_selfDual,
    fun v hv => extendedHamming8_doublyEven_mem v hv⟩

end CodeLatticeE8.Code
