import Mathlib.Tactic

/-!
# P7 proper-time / purity bridge

This draft module packages the scalar finite-qubit identity behind the
observer-channel proper-time proposal.

For a normalized celestial qubit with Bloch radius `r`, the squared
observer-conditioned proper-time ratio is modeled by `1 - r^2`, while purity is
`(1 + r^2) / 2`. Thus the proper-time ratio squared is exactly twice the
linear entropy. Unital visible contractions decrease purity and increase the
proper-time ratio squared.

Claim boundary: this is finite normalized-qubit algebra. It does not identify a
physical Higgs/Yukawa channel, does not prove dynamics, and does not derive a
continuum proper-time law.
-/

namespace PhysicsSM.Draft.NullEdgeP7ProperTimePurityBridge

noncomputable section

/-- Squared observer-conditioned proper-time ratio as a function of Bloch
radius. In units `c = 1`, this is the scalar model for `(d tau / dt)^2`. -/
def properTimeRatioSqFromBlochRadius (r : Real) : Real :=
  1 - r ^ 2

/-- Purity of a normalized qubit with Bloch radius `r`. -/
def purityFromBlochRadius (r : Real) : Real :=
  (1 + r ^ 2) / 2

/-- Linear entropy of a normalized qubit with Bloch radius `r`. -/
def linearEntropyFromBlochRadius (r : Real) : Real :=
  1 - purityFromBlochRadius r

/--
The scalar proper-time ratio squared is exactly twice the visible linear
entropy of the normalized celestial qubit.
-/
theorem properTimeRatioSq_eq_two_linearEntropy (r : Real) :
    properTimeRatioSqFromBlochRadius r =
      2 * linearEntropyFromBlochRadius r := by
  unfold properTimeRatioSqFromBlochRadius linearEntropyFromBlochRadius
    purityFromBlochRadius
  ring

/-- Equivalent form: purity and proper-time ratio squared sum to one after the
standard qubit normalization. -/
theorem purity_eq_one_sub_half_properTimeRatioSq (r : Real) :
    purityFromBlochRadius r =
      1 - properTimeRatioSqFromBlochRadius r / 2 := by
  unfold purityFromBlochRadius properTimeRatioSqFromBlochRadius
  ring

/-- A unital Bloch-radius contraction cannot decrease linear entropy. -/
theorem blochContraction_linearEntropy_monotone
    (a r : Real) (_ha0 : 0 <= a) (ha1 : a <= 1) :
    linearEntropyFromBlochRadius r <=
      linearEntropyFromBlochRadius (a * r) := by
  unfold linearEntropyFromBlochRadius purityFromBlochRadius
  nlinarith [mul_le_mul_of_nonneg_right ha1 (sq_nonneg r)]

/--
A unital Bloch-radius contraction cannot decrease the squared proper-time
ratio.
-/
theorem blochContraction_properTimeRatioSq_monotone
    (a r : Real) (_ha0 : 0 <= a) (ha1 : a <= 1) :
    properTimeRatioSqFromBlochRadius r <=
      properTimeRatioSqFromBlochRadius (a * r) := by
  unfold properTimeRatioSqFromBlochRadius
  nlinarith [mul_le_mul_of_nonneg_right ha1 (sq_nonneg r)]

/-- A genuine contraction of a nonzero Bloch radius strictly increases linear
entropy. -/
theorem blochContraction_linearEntropy_strict
    (a r : Real) (_ha0 : 0 <= a) (ha1 : a < 1) (hr : r = 0 -> False) :
    linearEntropyFromBlochRadius r <
      linearEntropyFromBlochRadius (a * r) := by
  unfold linearEntropyFromBlochRadius purityFromBlochRadius
  nlinarith [mul_pos (sub_pos.mpr ha1) (mul_self_pos.mpr hr)]

/--
A genuine contraction of a nonzero Bloch radius strictly increases the squared
proper-time ratio.
-/
theorem blochContraction_properTimeRatioSq_strict
    (a r : Real) (_ha0 : 0 <= a) (ha1 : a < 1) (hr : r = 0 -> False) :
    properTimeRatioSqFromBlochRadius r <
      properTimeRatioSqFromBlochRadius (a * r) := by
  unfold properTimeRatioSqFromBlochRadius
  nlinarith [mul_pos (sub_pos.mpr ha1) (mul_self_pos.mpr hr)]

end

end PhysicsSM.Draft.NullEdgeP7ProperTimePurityBridge
