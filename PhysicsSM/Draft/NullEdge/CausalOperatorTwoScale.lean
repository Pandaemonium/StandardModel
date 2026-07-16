import Mathlib

/-!
# Two-scale causal-operator diagnostics

This draft module records exact algebraic identities behind the microscopic
length `ell`, nonlocality scale `L`, and outer scale `R` used in the causal
operator experiments. The quantity called `kernelAmplitudeScale` is the
dimensionful combination suggested by the diagonal second-moment calculation;
this file does not prove a probabilistic variance or concentration theorem.

Claim grade: `M [comp]` for the displayed algebraic identities only.
-/

namespace PhysicsSM.Draft.NullEdge.CausalOperatorTwoScale

noncomputable section

/-- The dimensionless broad-layer parameter `(ell/L)^4`. -/
def broadLayerEpsilon (ell L : ℝ) : ℝ := (ell / L) ^ 4

/-- The reciprocal effective kernel count `(L/ell)^4`. -/
def effectiveKernelCount (ell L : ℝ) : ℝ := (L / ell) ^ 4

/-- The amplitude combination `sqrt(epsilon)/L^2`, written without a square
root as `(ell/L)^2/L^2`. -/
def kernelAmplitudeScale (ell L : ℝ) : ℝ := (ell / L) ^ 2 / L ^ 2

/-- Away from zero scales, epsilon and effective count are reciprocal. -/
theorem broadLayerEpsilon_mul_effectiveKernelCount
    {ell L : ℝ} (hell : ell ≠ 0) (hL : L ≠ 0) :
    broadLayerEpsilon ell L * effectiveKernelCount ell L = 1 := by
  unfold broadLayerEpsilon effectiveKernelCount
  field_simp

/-- The kernel-amplitude diagnostic is exactly `ell^2/L^4`. -/
theorem kernelAmplitudeScale_eq
    {ell L : ℝ} (hL : L ≠ 0) :
    kernelAmplitudeScale ell L = ell ^ 2 / L ^ 4 := by
  unfold kernelAmplitudeScale
  field_simp

/-- A boundary schedule `L^2 = c^2 ell R` leaves the amplitude diagnostic
independent of `ell`; shrinking the microscopic scale alone gives no
suppression in this conditional schedule. -/
theorem boundarySchedule_kernelAmplitudeScale
    {ell L c R : ℝ}
    (hell : ell ≠ 0) (hL : L ≠ 0) (hc : c ≠ 0) (hR : R ≠ 0)
    (hschedule : L ^ 2 = c ^ 2 * ell * R) :
    kernelAmplitudeScale ell L = 1 / (c ^ 4 * R ^ 2) := by
  rw [kernelAmplitudeScale_eq hL]
  have hfourth : L ^ 4 = c ^ 4 * ell ^ 2 * R ^ 2 := by
    calc
      L ^ 4 = (L ^ 2) ^ 2 := by ring
      _ = (c ^ 2 * ell * R) ^ 2 := by rw [hschedule]
      _ = c ^ 4 * ell ^ 2 * R ^ 2 := by ring
  rw [hfourth]
  field_simp

end

end PhysicsSM.Draft.NullEdge.CausalOperatorTwoScale
