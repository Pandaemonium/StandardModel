import Mathlib

/-!
# Causal-operator concentration audit seed

This standalone seed records the exact dimensionless scale variables and the
Poisson-averaged broad-layer polynomial used by the A41/A42 audit. It does not
assert a probabilistic concentration theorem.
-/

namespace CausalOperatorConcentrationAudit

noncomputable section

/-- The broad-layer parameter for microscopic length `ell` and nonlocality
scale `L`. -/
def epsilon (ell L : ℝ) : ℝ := (ell / L) ^ 4

/-- The reciprocal effective kernel count associated with the same scales. -/
def effectiveKernelCount (ell L : ℝ) : ℝ := (L / ell) ^ 4

/-- The polynomial in the exact Poisson transform of the four-dimensional
smeared causal-set kernel. -/
def poissonKernelPolynomial (z : ℝ) : ℝ :=
  1 - 9 * z + 8 * z ^ 2 - (4 / 3) * z ^ 3

/-- The two exact scale variables are reciprocal away from zero scales. -/
theorem epsilon_mul_effectiveKernelCount
    {ell L : ℝ} (hell : ell ≠ 0) (hL : L ≠ 0) :
    epsilon ell L * effectiveKernelCount ell L = 1 := by
  unfold epsilon effectiveKernelCount
  field_simp

end

end CausalOperatorConcentrationAudit
