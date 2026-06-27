import PhysicsSM.Coding.E8ThetaSeries
import Mathlib.NumberTheory.ArithmeticFunction.Misc

/-!
# API compatibility bridge: local σ₃ ↔ Mathlib's `ArithmeticFunction.sigma`

This module proves that the `sigma3` function defined in
`PhysicsSM.Coding.E8ThetaSeries` (as a plain `Finset.sum` over `Nat.divisors`)
agrees with Mathlib's canonical divisor-sum arithmetic function
`ArithmeticFunction.sigma 3`.

The bridge is intended for future modular-forms work connecting the E8 theta
series to the Eisenstein series `E₄` via Mathlib's number-theory API.

## Main results

* `sigma3_eq_mathlib_sigma` — the general identity for all `n : ℕ`.
* `sigma3_five`, `e4Coeff_five` — convenience values at `n = 5`.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding

open ArithmeticFunction in
/-- The local `sigma3` agrees with Mathlib's `ArithmeticFunction.sigma 3`
for every natural number. -/
theorem sigma3_eq_mathlib_sigma (n : ℕ) :
    sigma3 n = (sigma 3) n := by
  unfold sigma3
  rw [sigma_apply]

/-- `σ₃(5) = 126`. -/
theorem sigma3_five : sigma3 5 = 126 := by native_decide

/-- The 5th Eisenstein coefficient: `240 · σ₃(5) = 30240`. -/
theorem e4Coeff_five : e4Coeff 5 = 30240 := by native_decide

/-- Bridge corollary for `n = 1`. -/
theorem sigma3_eq_mathlib_sigma_one :
    sigma3 1 = (ArithmeticFunction.sigma 3) 1 :=
  sigma3_eq_mathlib_sigma 1

/-- Bridge corollary for `n = 2`. -/
theorem sigma3_eq_mathlib_sigma_two :
    sigma3 2 = (ArithmeticFunction.sigma 3) 2 :=
  sigma3_eq_mathlib_sigma 2

/-- Bridge corollary for `n = 3`. -/
theorem sigma3_eq_mathlib_sigma_three :
    sigma3 3 = (ArithmeticFunction.sigma 3) 3 :=
  sigma3_eq_mathlib_sigma 3

/-- Bridge corollary for `n = 4`. -/
theorem sigma3_eq_mathlib_sigma_four :
    sigma3 4 = (ArithmeticFunction.sigma 3) 4 :=
  sigma3_eq_mathlib_sigma 4

/-- Bridge corollary for `n = 5`. -/
theorem sigma3_eq_mathlib_sigma_five :
    sigma3 5 = (ArithmeticFunction.sigma 3) 5 :=
  sigma3_eq_mathlib_sigma 5

end PhysicsSM.Coding
