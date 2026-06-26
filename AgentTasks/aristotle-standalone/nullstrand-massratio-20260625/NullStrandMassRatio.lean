import Mathlib

/-!
# NullStrand finite mass-ratio algebra target

Small algebraic bridge for KIN-008 after the flux variance theorem.
-/

namespace NullStrandMassRatio

/-- KIN-008 algebraic core: if `E = m * gamma`, then `(m/E)^2 = 1/gamma^2`. -/
theorem massRatioSq_eq_invGammaSq
    {m E gamma : Real} (hm : m ≠ 0) (hgamma : gamma ≠ 0) (hE : E = m * gamma) :
    (m / E) ^ 2 = 1 / gamma ^ 2 := by
  subst hE
  field_simp

/-- Equivalent form used when the flux variance is already `1/gamma^2`. -/
theorem invGammaSq_eq_massRatioSq
    {m E gamma : Real} (hm : m ≠ 0) (hgamma : gamma ≠ 0) (hE : E = m * gamma) :
    1 / gamma ^ 2 = m ^ 2 / E ^ 2 := by
  subst hE
  field_simp

end NullStrandMassRatio
