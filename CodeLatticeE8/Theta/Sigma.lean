import Mathlib.NumberTheory.ArithmeticFunction.Misc

/-!
# Eisenstein `E4` coefficient normalization

This module contains the elementary arithmetic normalization used by the
theta-series files in the standalone `CodeLatticeE8` package.

The classical Eisenstein series is normalized as

```text
E4(q) = 1 + 240 * sum_{n >= 1} sigma3(n) q^n,
```

where `sigma3(n)` is the sum of cubes of the positive divisors of `n`.

The definition `e4Coeff` includes the constant term, so it is the actual
coefficient function of this normalized formal series:

```text
e4Coeff 0 = 1,
e4Coeff n = 240 * sigma3 n   for n > 0.
```

Finite coefficient facts are verified by `decide` (kernel-verified computation)
for `sigma3`, and derived from those values for `e4Coeff`.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.Theta

/-! ## Divisor sums -/

/-- The sum-of-cubes-of-divisors function `sigma3(n) = sum_{d | n} d^3`. -/
def sigma3 (n : ℕ) : ℕ :=
  (Nat.divisors n).sum (fun d => d ^ 3)

open ArithmeticFunction in
/-- The local `sigma3` agrees with Mathlib's arithmetic-function divisor sum. -/
theorem sigma3_eq_mathlib_sigma (n : ℕ) :
    sigma3 n = (sigma 3) n := by
  unfold sigma3
  rw [sigma_apply]

theorem sigma3_one : sigma3 1 = 1 := by decide
theorem sigma3_two : sigma3 2 = 9 := by decide
theorem sigma3_three : sigma3 3 = 28 := by decide
theorem sigma3_four : sigma3 4 = 73 := by decide
theorem sigma3_five : sigma3 5 = 126 := by decide
theorem sigma3_six : sigma3 6 = 252 := by decide

/-! ## `E4` coefficients -/

/--
The coefficient of `q^n` in the normalized Eisenstein series `E4`.

The constant term is built into the definition:
`e4Coeff 0 = 1`, while for positive `n` the coefficient is
`240 * sigma3 n`.
-/
def e4Coeff (n : ℕ) : ℕ :=
  if n = 0 then 1 else 240 * sigma3 n

/-- For positive `n`, `e4Coeff` reduces to `240 * sigma3 n`. -/
private theorem e4Coeff_pos {n : ℕ} (hn : n ≠ 0) : e4Coeff n = 240 * sigma3 n := by
  simp [e4Coeff, hn]

theorem e4Coeff_zero : e4Coeff 0 = 1 := by simp [e4Coeff]
theorem e4Coeff_one : e4Coeff 1 = 240 := by
  rw [e4Coeff_pos (by omega), sigma3_one]
theorem e4Coeff_two : e4Coeff 2 = 2160 := by
  rw [e4Coeff_pos (by omega), sigma3_two]
theorem e4Coeff_three : e4Coeff 3 = 6720 := by
  rw [e4Coeff_pos (by omega), sigma3_three]
theorem e4Coeff_four : e4Coeff 4 = 17520 := by
  rw [e4Coeff_pos (by omega), sigma3_four]
theorem e4Coeff_five : e4Coeff 5 = 30240 := by
  rw [e4Coeff_pos (by omega), sigma3_five]
theorem e4Coeff_six : e4Coeff 6 = 60480 := by
  rw [e4Coeff_pos (by omega), sigma3_six]

end CodeLatticeE8.Theta
