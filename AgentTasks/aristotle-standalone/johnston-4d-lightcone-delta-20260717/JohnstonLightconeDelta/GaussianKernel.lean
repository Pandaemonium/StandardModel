import Mathlib

/-!
# Johnston four-dimensional light-cone Gaussian

This focused handoff isolates the one-variable analytic calibration behind the
expected four-dimensional causal-set link kernel.  With squared timelike
separation `s = tau^2`, Alexandrov volume `V = pi * s^2 / 24`, and sprinkling
density `rho`, the expected link indicator is `exp (-rho * V)`.  Johnston's
massless normalization supplies the prefactor below.

The results here concern the positive half-line in the scalar variable `s`.
They do not by themselves prove convergence as a distribution on Minkowski
spacetime, identify a finite sprinkling with its expectation, or prove a
concentration theorem for random causal sets.
-/

noncomputable section

namespace JohnstonLightconeDelta

open Filter MeasureTheory Set
open scoped Topology

/-- Johnston's normalized expected four-dimensional link kernel as a function
of squared timelike separation `s = tau^2`. -/
def lightconeApprox (rho s : Real) : Real :=
  Real.sqrt rho / (2 * Real.pi * Real.sqrt 6) *
    Real.exp (-(rho * Real.pi / 24) * s ^ 2)

/-- The kernel is nonnegative at nonnegative sprinkling density. -/
theorem lightconeApprox_nonneg (rho s : Real) (hrho : 0 <= rho) :
    0 <= lightconeApprox rho s := by
  sorry

/-- At positive density the kernel is integrable on squared timelike
separations `s > 0`. -/
theorem lightconeApprox_integrableOn_Ioi (rho : Real) (hrho : 0 < rho) :
    IntegrableOn (lightconeApprox rho) (Ioi 0) := by
  sorry

/-- Exact one-sided normalization.  The factor `1 / (2*pi)` is the standard
coefficient of the massless four-dimensional retarded Green distribution. -/
theorem lightconeApprox_integral_Ioi (rho : Real) (hrho : 0 < rho) :
    integral (Measure.restrict volume (Ioi 0)) (lightconeApprox rho) =
      1 / (2 * Real.pi) := by
  sorry

/-- Away from the light cone (`s != 0`), the expected kernel decays to zero as
the sprinkling density tends to infinity. -/
theorem lightconeApprox_tendsto_zero (s : Real) (hs : s != 0) :
    Tendsto (fun rho : Real => lightconeApprox rho s) atTop (nhds 0) := by
  sorry

/-- Distributional calibration in the one-sided variable `s`: pairing with a
bounded continuous test function converges to the light-cone evaluation with
coefficient `1 / (2*pi)`.

This is deliberately only the one-variable delta-sequence theorem.  A full
Minkowski result still requires the Lorentzian light-cone coarea/disintegration
step and a convention check for the retarded Heaviside factor. -/
theorem lightconeApprox_pairing_tendsto
    (f : BoundedContinuousFunction Real Real) :
    Tendsto
      (fun rho : Real =>
        integral (Measure.restrict volume (Ioi 0))
          (fun s => lightconeApprox rho s * f s))
      atTop (nhds ((1 / (2 * Real.pi)) * f 0)) := by
  sorry

end JohnstonLightconeDelta

end
