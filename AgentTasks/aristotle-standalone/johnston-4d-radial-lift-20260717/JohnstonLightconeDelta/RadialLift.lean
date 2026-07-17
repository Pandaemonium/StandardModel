import JohnstonLightconeDelta.GaussianKernel

/-!
# Radial lift of the Johnston light-cone delta sequence

This file proves the analytic radial integration step after spherical averaging.
The bounded continuous input `F (r,s)` is an abstract angular average. No
spherical-coordinate identity or full Minkowski distribution theorem is
claimed here.
-/

noncomputable section

namespace JohnstonLightconeDelta

open Filter MeasureTheory Set
open scoped Topology

/-- Future-cone radial Jacobian after using squared timelike separation
`s = t^2-r^2` and a normalized spherical average. -/
def radialJacobian (r s : Real) : Real :=
  2 * Real.pi * r ^ 2 / Real.sqrt (r ^ 2 + s)

/-- The future-cone radial Jacobian is nonnegative. -/
theorem radialJacobian_nonneg
    {r s : Real} (hr : 0 <= r) (hs : 0 <= s) :
    0 <= radialJacobian r s := by
  sorry

/-- The radial Jacobian is bounded by its light-cone value. -/
theorem radialJacobian_le_lightcone
    {r s : Real} (hr : 0 <= r) (hs : 0 <= s) :
    radialJacobian r s <= 2 * Real.pi * r := by
  sorry

/-- At every positive radius, the Jacobian tends to `2*pi*r` from the
timelike side of the light cone. -/
theorem radialJacobian_tendsto_lightcone
    {r : Real} (hr : 0 < r) :
    Tendsto (radialJacobian r) (nhdsWithin 0 (Ici 0))
      (nhds (2 * Real.pi * r)) := by
  sorry

/-- Fixed-radius pairing limit for an abstract bounded continuous angular
average. -/
theorem fixedRadius_pairing_tendsto
    {r : Real} (hr : 0 < r)
    (F : BoundedContinuousFunction (Real × Real) Real) :
    Tendsto
      (fun rho : Real =>
        integral (Measure.restrict volume (Ioi 0))
          (fun s => lightconeApprox rho s * radialJacobian r s * F (r, s)))
      atTop (nhds (r * F (r, 0))) := by
  sorry

/-- Dominated radial lift on a compact radial interval. This is the analytic
limit needed after, but logically separate from, a spherical coarea theorem. -/
theorem radialPairing_tendsto
    {R : Real} (hR : 0 < R)
    (F : BoundedContinuousFunction (Real × Real) Real) :
    Tendsto
      (fun rho : Real =>
        integral (Measure.restrict volume (Ioc 0 R))
          (fun r =>
            integral (Measure.restrict volume (Ioi 0))
              (fun s =>
                lightconeApprox rho s * radialJacobian r s * F (r, s))))
      atTop
      (nhds
        (integral (Measure.restrict volume (Ioc 0 R))
          (fun r => r * F (r, 0)))) := by
  sorry

end JohnstonLightconeDelta

end
