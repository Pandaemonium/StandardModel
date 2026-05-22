import CodeLatticeE8.Code.Hamming844WeightEnumerator
import CodeLatticeE8.Theta.Sigma

/-!
# Hamming weight-contribution table for the E8 theta series

This module packages the finite Hamming weight-contribution table through
`q^6`.

For the extended Hamming code, codeword weights are only `0`, `4`, and `8`,
with multiplicities `1`, `14`, and `1`.  In the verified range
`sqNorm <= 24`, the one-coordinate square choices are:

- odd residue: square `1` or `9`, each with two signs;
- even residue: square `0`, `4`, or `16`, with two signs for the nonzero
  square values.

The table `weightContribRange9` records the resulting manually entered
closed-form counts for weights `0`, `4`, and `8` and shells `0,4,...,24`.
The individual `rfl` lemmas certify that the lookup table exposes the displayed
values; they are not a derivation of those values from the semantic shell
definition.  The theorem
`hammingThetaTableCoeff_eq_e4Coeff_of_le_six` then combines the table with the
proved Hamming weight distribution to recover the normalized `E4` coefficients
through `q^6`.

This file does **not** claim the full unbounded identity `Theta_E8 = E4`, and
it does not claim that the finite table is itself the semantic shell-count
definition.  The semantic all-shell Construction A convolution theorem is in
`CodeLatticeE8.ConstructionA.ThetaConvolution`; the analytic all-coefficient
identity belongs in the SPL-facing root.  The purpose here is to give the core
package a compact, readable finite table check.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.E8

open CodeLatticeE8.Code
open CodeLatticeE8.Theta

/-! ## Per-weight contribution table -/

/--
Contribution from codewords of Hamming weight `w` to an unscaled shell `s`.

Only the entries needed through `q^6` are populated.  Other values return `0`
because this is a finite verification table, not the unbounded contribution
function.
-/
def weightContribRange9 : ℕ → ℕ → ℕ
  | 0, 0 => 1
  | 0, 4 => 16
  | 0, 8 => 112
  | 0, 12 => 448
  | 0, 16 => 1136
  | 0, 20 => 2016
  | 0, 24 => 3136
  | 4, 0 => 0
  | 4, 4 => 16
  | 4, 8 => 128
  | 4, 12 => 448
  | 4, 16 => 1024
  | 4, 20 => 2016
  | 4, 24 => 3584
  | 8, 0 => 0
  | 8, 4 => 0
  | 8, 8 => 256
  | 8, 12 => 0
  | 8, 16 => 2048
  | 8, 20 => 0
  | 8, 24 => 7168
  | _, _ => 0

theorem weightContribRange9_w0_s0 : weightContribRange9 0 0 = 1 := rfl
theorem weightContribRange9_w4_s0 : weightContribRange9 4 0 = 0 := rfl
theorem weightContribRange9_w8_s0 : weightContribRange9 8 0 = 0 := rfl

theorem weightContribRange9_w0_s4 : weightContribRange9 0 4 = 16 := rfl
theorem weightContribRange9_w4_s4 : weightContribRange9 4 4 = 16 := rfl
theorem weightContribRange9_w8_s4 : weightContribRange9 8 4 = 0 := rfl

theorem weightContribRange9_w0_s8 : weightContribRange9 0 8 = 112 := rfl
theorem weightContribRange9_w4_s8 : weightContribRange9 4 8 = 128 := rfl
theorem weightContribRange9_w8_s8 : weightContribRange9 8 8 = 256 := rfl

theorem weightContribRange9_w0_s12 : weightContribRange9 0 12 = 448 := rfl
theorem weightContribRange9_w4_s12 : weightContribRange9 4 12 = 448 := rfl
theorem weightContribRange9_w8_s12 : weightContribRange9 8 12 = 0 := rfl

theorem weightContribRange9_w0_s16 : weightContribRange9 0 16 = 1136 := rfl
theorem weightContribRange9_w4_s16 : weightContribRange9 4 16 = 1024 := rfl
theorem weightContribRange9_w8_s16 : weightContribRange9 8 16 = 2048 := rfl

theorem weightContribRange9_w0_s20 : weightContribRange9 0 20 = 2016 := rfl
theorem weightContribRange9_w4_s20 : weightContribRange9 4 20 = 2016 := rfl
theorem weightContribRange9_w8_s20 : weightContribRange9 8 20 = 0 := rfl

theorem weightContribRange9_w0_s24 : weightContribRange9 0 24 = 3136 := rfl
theorem weightContribRange9_w4_s24 : weightContribRange9 4 24 = 3584 := rfl
theorem weightContribRange9_w8_s24 : weightContribRange9 8 24 = 7168 := rfl

/-! ## Hamming-weight convolution coefficients -/

/--
The verified Hamming weight-contribution coefficient through `q^6`.

For theta index `n`, the unscaled shell is `4 * n`.  The value combines the
three possible Hamming weights using the certified weight distribution.
-/
def hammingThetaTableCoeff (n : ℕ) : ℕ :=
  extendedHamming8WeightDist 0 * weightContribRange9 0 (4 * n) +
  extendedHamming8WeightDist 4 * weightContribRange9 4 (4 * n) +
  extendedHamming8WeightDist 8 * weightContribRange9 8 (4 * n)

theorem hammingThetaTableCoeff_zero :
    hammingThetaTableCoeff 0 = 1 := by
  unfold hammingThetaTableCoeff
  rw [extendedHamming8_weight_zero_count, extendedHamming8_weight_four_count,
    extendedHamming8_weight_eight_count, weightContribRange9_w0_s0,
    weightContribRange9_w4_s0, weightContribRange9_w8_s0]

theorem hammingThetaTableCoeff_one :
    hammingThetaTableCoeff 1 = 240 := by
  unfold hammingThetaTableCoeff
  rw [extendedHamming8_weight_zero_count, extendedHamming8_weight_four_count,
    extendedHamming8_weight_eight_count, weightContribRange9_w0_s4,
    weightContribRange9_w4_s4, weightContribRange9_w8_s4]

theorem hammingThetaTableCoeff_two :
    hammingThetaTableCoeff 2 = 2160 := by
  unfold hammingThetaTableCoeff
  rw [extendedHamming8_weight_zero_count, extendedHamming8_weight_four_count,
    extendedHamming8_weight_eight_count, weightContribRange9_w0_s8,
    weightContribRange9_w4_s8, weightContribRange9_w8_s8]

theorem hammingThetaTableCoeff_three :
    hammingThetaTableCoeff 3 = 6720 := by
  unfold hammingThetaTableCoeff
  rw [extendedHamming8_weight_zero_count, extendedHamming8_weight_four_count,
    extendedHamming8_weight_eight_count, weightContribRange9_w0_s12,
    weightContribRange9_w4_s12, weightContribRange9_w8_s12]

theorem hammingThetaTableCoeff_four :
    hammingThetaTableCoeff 4 = 17520 := by
  unfold hammingThetaTableCoeff
  rw [extendedHamming8_weight_zero_count, extendedHamming8_weight_four_count,
    extendedHamming8_weight_eight_count, weightContribRange9_w0_s16,
    weightContribRange9_w4_s16, weightContribRange9_w8_s16]

theorem hammingThetaTableCoeff_five :
    hammingThetaTableCoeff 5 = 30240 := by
  unfold hammingThetaTableCoeff
  rw [extendedHamming8_weight_zero_count, extendedHamming8_weight_four_count,
    extendedHamming8_weight_eight_count, weightContribRange9_w0_s20,
    weightContribRange9_w4_s20, weightContribRange9_w8_s20]

theorem hammingThetaTableCoeff_six :
    hammingThetaTableCoeff 6 = 60480 := by
  unfold hammingThetaTableCoeff
  rw [extendedHamming8_weight_zero_count, extendedHamming8_weight_four_count,
    extendedHamming8_weight_eight_count, weightContribRange9_w0_s24,
    weightContribRange9_w4_s24, weightContribRange9_w8_s24]

/--
The verified Hamming weight-contribution coefficients agree with the normalized
`E4` coefficients through `q^6`.
-/
theorem hammingThetaTableCoeff_eq_e4Coeff_of_le_six
    (n : ℕ) (hn : n ≤ 6) :
    hammingThetaTableCoeff n = e4Coeff n := by
  interval_cases n <;>
    simp [hammingThetaTableCoeff_zero, hammingThetaTableCoeff_one,
      hammingThetaTableCoeff_two, hammingThetaTableCoeff_three,
      hammingThetaTableCoeff_four, hammingThetaTableCoeff_five,
      hammingThetaTableCoeff_six,
      e4Coeff_zero, e4Coeff_one, e4Coeff_two, e4Coeff_three, e4Coeff_four,
      e4Coeff_five, e4Coeff_six]

end CodeLatticeE8.E8
