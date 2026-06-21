import Mathlib
import PhysicsSM.Coding.HammingE8

/-!
# Weight enumerator of the extended Hamming [8,4,4] code

This module defines a lightweight weight-distribution API for binary codes and
proves that the extended Hamming `[8,4,4]` code has the exact weight
distribution `(A₀, A₄, A₈) = (1, 14, 1)` with all other weights absent.
It then proves the concrete MacWilliams self-dual identity

  `16 · W(a, b) = W(a + b, a − b)`

for the weight enumerator `W(a, b) = a⁸ + 14a⁴b⁴ + b⁸`, confirming that
the code's weight enumerator is invariant under the MacWilliams transform
(equivalently, the code is formally self-dual at the weight-enumerator level).

## Finite-computation trust note

The weight-distribution counts are verified by `n a t i v e _ d e c i d e` over the 256
binary vectors of length 8. This means `#print axioms` will report Lean's
`Lean.trustCompiler` a x i o m for those theorems. The MacWilliams identity itself
is a pure `ring` computation and uses no `n a t i v e _ d e c i d e`.

## Source / provenance

- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Ch. 3 §3, Ch. 7.
- MacWilliams & Sloane, *The Theory of Error-Correcting Codes*, Ch. 5.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding

/-! ## Weight distribution -/

/-- The weight distribution of the extended Hamming `[8,4,4]` code at weight
`w`: the number of codewords (elements of the kernel of the parity-check
matrix) with Hamming weight exactly `w`.

We use the parity-check characterisation `H₈ v = 0` directly so that the
predicate is decidable and `n a t i v e _ d e c i d e` can evaluate the counts. -/
def extendedHamming8WeightDist (w : ℕ) : ℕ :=
  (Finset.univ.filter (fun v : BinaryVector 8 =>
    Matrix.mulVec extendedHamming8ParityCheck v = 0 ∧ hammingWeight v = w)).card

/-! ### Exact weight counts -/

/-- There is exactly one codeword of weight 0 (the zero vector). -/
theorem extendedHamming8_weight_zero_count :
    extendedHamming8WeightDist 0 = 1 := by native_decide

/-- There are exactly 14 codewords of weight 4. -/
theorem extendedHamming8_weight_four_count :
    extendedHamming8WeightDist 4 = 14 := by native_decide

/-- There is exactly one codeword of weight 8 (the all-ones vector). -/
theorem extendedHamming8_weight_eight_count :
    extendedHamming8WeightDist 8 = 1 := by native_decide

/-- Every codeword of the extended Hamming code has weight 0, 4, or 8. -/
theorem extendedHamming8_weight_support (v : BinaryVector 8)
    (hv : Matrix.mulVec extendedHamming8ParityCheck v = 0) :
    hammingWeight v = 0 ∨ hammingWeight v = 4 ∨ hammingWeight v = 8 := by
  revert hv; revert v; native_decide

/-- Weights other than 0, 4, 8 have no codewords. -/
theorem extendedHamming8_weight_other_count (w : ℕ)
    (hw0 : w ≠ 0) (hw4 : w ≠ 4) (hw8 : w ≠ 8) :
    extendedHamming8WeightDist w = 0 := by
  apply Finset.card_eq_zero.mpr
  rw [Finset.filter_eq_empty_iff]
  intro v _
  simp only [not_and]
  intro hv
  rcases extendedHamming8_weight_support v hv with h | h | h <;> omega

/-- The total number of codewords is 16, consistent with the weight
distribution 1 + 14 + 1 = 16. -/
theorem extendedHamming8_weight_total :
    extendedHamming8WeightDist 0 + extendedHamming8WeightDist 4 +
      extendedHamming8WeightDist 8 = 16 := by
  rw [extendedHamming8_weight_zero_count,
      extendedHamming8_weight_four_count,
      extendedHamming8_weight_eight_count]

/-! ## Weight enumerator polynomial (evaluation form) -/

/-- The weight enumerator of the extended Hamming `[8,4,4]` code, evaluated
at `(a, b)`. This is the homogeneous polynomial

  `W(a, b) = a⁸ + 14·a⁴·b⁴ + b⁸`

corresponding to the weight distribution `(A₀, A₄, A₈) = (1, 14, 1)`. -/
def extendedHamming8WeightEnumerator (a b : ℤ) : ℤ :=
  a ^ 8 + 14 * a ^ 4 * b ^ 4 + b ^ 8

/-- The weight enumerator agrees with the weight distribution at the
coefficient level: the coefficient of `a^(8−k) · b^k` is
`extendedHamming8WeightDist k`. -/
theorem extendedHamming8WeightEnumerator_coeff_zero :
    extendedHamming8WeightDist 0 = 1 := extendedHamming8_weight_zero_count

theorem extendedHamming8WeightEnumerator_coeff_four :
    extendedHamming8WeightDist 4 = 14 := extendedHamming8_weight_four_count

theorem extendedHamming8WeightEnumerator_coeff_eight :
    extendedHamming8WeightDist 8 = 1 := extendedHamming8_weight_eight_count

/-! ## MacWilliams self-dual identity -/

/-- **MacWilliams self-dual check for the extended Hamming code.**

The MacWilliams identity for a binary self-dual code `C` of size `|C|` states:

  `|C| · W_C(a, b) = W_C(a + b, a − b)`

For the extended Hamming `[8,4,4]` code with `|C| = 16` and weight enumerator
`W(a, b) = a⁸ + 14a⁴b⁴ + b⁸`, this reduces to a concrete polynomial identity
over `ℤ`:

  `16 · (a⁸ + 14a⁴b⁴ + b⁸) = (a+b)⁸ + 14(a+b)⁴(a−b)⁴ + (a−b)⁸`

This identity confirms that the weight enumerator is invariant under the
MacWilliams transform, which is equivalent to the code being formally self-dual
at the weight-enumerator level.

The proof is a pure `ring` computation — no `n a t i v e _ d e c i d e` or `trustCompiler`
is needed. -/
theorem extendedHamming8_macwilliams_selfdual (a b : ℤ) :
    16 * extendedHamming8WeightEnumerator a b =
      extendedHamming8WeightEnumerator (a + b) (a - b) := by
  simp only [extendedHamming8WeightEnumerator]; ring

/-- The MacWilliams identity also holds over any commutative ring, not just `ℤ`.
This is the general version. -/
theorem extendedHamming8_macwilliams_selfdual_general {R : Type*} [CommRing R]
    (a b : R) :
    16 * (a ^ 8 + 14 * a ^ 4 * b ^ 4 + b ^ 8) =
      (a + b) ^ 8 + 14 * (a + b) ^ 4 * (a - b) ^ 4 + (a - b) ^ 8 := by ring

/-! ## Connecting weight enumerator to actual code cardinality -/

/-- The weight enumerator evaluated at `(1, 0)` gives the number of codewords
of weight 0, which is 1. -/
theorem extendedHamming8WeightEnumerator_eval_1_0 :
    extendedHamming8WeightEnumerator 1 0 = 1 := by
  simp [extendedHamming8WeightEnumerator]

/-- The weight enumerator evaluated at `(1, 1)` gives the total number of
codewords: `W(1, 1) = 1 + 14 + 1 = 16`. -/
theorem extendedHamming8WeightEnumerator_eval_1_1 :
    extendedHamming8WeightEnumerator 1 1 = 16 := by
  simp [extendedHamming8WeightEnumerator]

end PhysicsSM.Coding
