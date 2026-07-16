import PhysicsSM.Draft.NullEdge.ChangingCellFourierPDE

/-!
# Strong time continuity of the exact momentum-space L2 multiplier

The live continuum lane now has a representative-safe linear isometry
`momMultL2Isometry m t` for each elapsed time. This target proves strong
continuity of each orbit `t |-> momMultL2Isometry m t f`, rather than the much
stronger and generally false claim of operator-norm continuity on the full
unbounded momentum space.

The expected proof uses pointwise continuity of the finite-dimensional matrix
exponential, exact norm preservation, and an `Lp` dominated-convergence
argument with domination by a constant multiple of the fixed representative's
norm.
-/

noncomputable section

open Matrix Complex
open MeasureTheory

namespace PhysicsSM.Draft.NullEdge.MomMultL2StrongContinuity

open ChangingCellScaledLiveWalk
open ChangingCellFourierL2
open ChangingCellFourierPDE

/-- **Immutable zero-time fibre control.** The actual exact multiplier at zero
elapsed time is the continuous-linear identity on every momentum fibre. -/
theorem momMult_zero_time (m : Real) (k : FourierMomentum3) :
    momMult m 0 k = ContinuousLinearMap.id Complex Spinor := by
  sorry

/-- **Immutable zero-time L2 control.** The representative-safe lift is the
identity on every momentum-space `L2` class at zero elapsed time. -/
theorem momMultL2Isometry_zero_time (m : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    momMultL2Isometry m 0 f = f := by
  sorry

/-- Orbit of one fixed momentum-space `L2` state under the exact multiplier. -/
def momMultL2Orbit (m : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) (t : Real) :
    Lp Spinor 2 (volume : Measure FourierMomentum3) :=
  momMultL2Isometry m t f

/-- **Immutable analytic target.** Every state has a strongly continuous
time orbit under the exact momentum-space multiplier. -/
theorem momMultL2Orbit_continuous (m : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    Continuous (momMultL2Orbit m f) := by
  sorry

/-! ## Non-degeneracy and scope controls -/

/-- The strong-continuity target concerns norm-preserving nonzero-time orbits,
not a constant zero map. -/
theorem momMultL2Orbit_norm (m t : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    norm (momMultL2Orbit m f t) = norm f :=
  momMultL2Isometry_norm m t f

/-- At the nonzero rest witness and nonzero time, the orbit still uses the
actual live multiplier family. -/
theorem rest_orbit_representative (f : Lp Spinor 2
    (volume : Measure FourierMomentum3)) :
    momMultL2Orbit 4 f 1 =ᵐ[(volume : Measure FourierMomentum3)]
      fun k => momMult 4 1 k (f k) :=
  momMultL2Isometry_coeFn 4 1 f

end PhysicsSM.Draft.NullEdge.MomMultL2StrongContinuity
