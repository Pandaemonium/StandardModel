import Mathlib

/-!
# Binary code foundations

This module contains the small binary-code vocabulary used throughout the
Hamming-to-E8 package.  The definitions are deliberately concrete:

- a binary vector of length `n` is `Fin n -> ZMod 2`;
- a binary linear code is a `ZMod 2`-submodule of that ambient vector space;
- Hamming weight counts nonzero coordinates;
- the binary dot product is the ordinary coordinatewise sum over `ZMod 2`.

The point of keeping this file small is reviewability: later modules should
read as ordinary coding theory, without forcing the reader to unpack a large
framework before reaching the Hamming code.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.Code

/-- A binary vector of length `n`. -/
abbrev BinaryVector (n : ℕ) := Fin n → ZMod 2

/-- A binary linear code of length `n`. -/
abbrev BinaryLinearCode (n : ℕ) := Submodule (ZMod 2) (BinaryVector n)

/-- The Hamming weight of a binary vector: the number of nonzero coordinates. -/
def hammingWeight {n : ℕ} (v : BinaryVector n) : ℕ :=
  (Finset.univ.filter fun i => v i ≠ 0).card

/-- A binary code is doubly even if every codeword has weight divisible by four. -/
def IsDoublyEven {n : ℕ} (C : BinaryLinearCode n) : Prop :=
  ∀ v ∈ C, 4 ∣ hammingWeight v

/-- The binary dot product over `ZMod 2`. -/
def binaryDot {n : ℕ} (v w : BinaryVector n) : ZMod 2 :=
  ∑ i, v i * w i

@[simp]
theorem binaryDot_zero_left {n : ℕ} (w : BinaryVector n) :
    binaryDot 0 w = 0 := by
  simp [binaryDot]

@[simp]
theorem binaryDot_zero_right {n : ℕ} (v : BinaryVector n) :
    binaryDot v 0 = 0 := by
  simp [binaryDot]

theorem binaryDot_add_left {n : ℕ} (u v w : BinaryVector n) :
    binaryDot (u + v) w = binaryDot u w + binaryDot v w := by
  simp [binaryDot, add_mul, Finset.sum_add_distrib]

/-- The binary dot product is homogeneous in the first argument. -/
theorem binaryDot_smul_left {n : ℕ} (c : ZMod 2) (v w : BinaryVector n) :
    binaryDot (c • v) w = c * binaryDot v w := by
  simp [binaryDot, Pi.smul_apply, smul_eq_mul, mul_assoc, Finset.mul_sum]

theorem binaryDot_comm {n : ℕ} (v w : BinaryVector n) :
    binaryDot v w = binaryDot w v := by
  simp [binaryDot, mul_comm]

end CodeLatticeE8.Code
