import Mathlib

/-!
# NullStrand positive-part rate core

Focused LA-004/Bell-rate algebra: positive parts of an antisymmetric current
recover the current after division by positive source densities.
-/

noncomputable section

namespace NullStrandRatePositivePart

/-- Positive part of a real number. -/
def realPos (x : Real) : Real := max x 0

/-- Difference of positive parts recovers the original real. -/
theorem realPos_sub_realPos_neg (x : Real) :
    realPos x - realPos (-x) = x := by
  unfold realPos; cases le_total 0 x <;> simp +decide [*]

/-- Bell-style positive-part rate attached to a density and antisymmetric current. -/
def positivePartRate {Alpha : Type*} (rho : Alpha -> Real) (J : Alpha -> Alpha -> Real)
    (i j : Alpha) : Real :=
  realPos (J i j) / rho i

/-- Positive-part rates have the prescribed antisymmetric net current. -/
theorem positivePartRate_net_current {Alpha : Type*}
    (rho : Alpha -> Real) (J : Alpha -> Alpha -> Real) (i j : Alpha)
    (hrhoi : rho i ≠ 0) (hrhoj : rho j ≠ 0) (hanti : J j i = -J i j) :
    rho i * positivePartRate rho J i j - rho j * positivePartRate rho J j i = J i j := by
  simp only [positivePartRate, hanti]
  rw [mul_div_cancel₀ _ hrhoi, mul_div_cancel₀ _ hrhoj, realPos_sub_realPos_neg]

end NullStrandRatePositivePart
