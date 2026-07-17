import Mathlib

/-!
# Johnston four-dimensional light-cone Gaussian

Copied focused source for the radial-lift successor. The statements are locked
identically to the first Gaussian task so this package is self-contained.
-/

noncomputable section

namespace JohnstonLightconeDelta

open Filter MeasureTheory Set
open scoped Topology

def lightconeApprox (rho s : Real) : Real :=
  Real.sqrt rho / (2 * Real.pi * Real.sqrt 6) *
    Real.exp (-(rho * Real.pi / 24) * s ^ 2)

theorem lightconeApprox_nonneg (rho s : Real) (hrho : 0 <= rho) :
    0 <= lightconeApprox rho s := by
  sorry

theorem lightconeApprox_integrableOn_Ioi (rho : Real) (hrho : 0 < rho) :
    IntegrableOn (lightconeApprox rho) (Ioi 0) := by
  sorry

theorem lightconeApprox_integral_Ioi (rho : Real) (hrho : 0 < rho) :
    integral (Measure.restrict volume (Ioi 0)) (lightconeApprox rho) =
      1 / (2 * Real.pi) := by
  sorry

theorem lightconeApprox_tendsto_zero (s : Real) (hs : s != 0) :
    Tendsto (fun rho : Real => lightconeApprox rho s) atTop (nhds 0) := by
  sorry

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
