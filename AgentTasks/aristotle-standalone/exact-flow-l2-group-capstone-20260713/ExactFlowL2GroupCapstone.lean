import PhysicsSM.Draft.NullEdge.ExactFlowTimeGroup
import PhysicsSM.Draft.NullEdge.PositionExactFlowL2

/-!
# Exact momentum- and position-space L2 time-group capstone

This target composes the live pointwise matrix group law, the representative-
safe variable-multiplier lift, and Fourier conjugation. The result should be an
exact strongly continuous one-parameter group on the common spinor-valued `L2`
space.

The immutable targets below are group laws on `L2` equivalence classes, not
pointwise representative equalities. Strong continuity is already proved in
the imported modules. No generator domain, Schwartz invariance, position-space
PDE, walk limit, or Lorentz statement follows from this file alone.
-/

noncomputable section

open MeasureTheory

namespace PhysicsSM.Draft.NullEdge.ExactFlowL2GroupCapstone

open ChangingCellFourierL2
open ChangingCellFourierPDE
open ChangingCellScaledLiveWalk
open ExactFlowTimeGroup
open MomMultL2StrongContinuity
open PositionExactFlowL2
open VariablePointwiseL2Isometry

/-- Pointwise operator-family group law, with composition order matching
`U(s+t) = U(s) U(t)`. -/
theorem momMult_add_time (m s t : Real) (k : FourierMomentum3) :
    momMult m (s + t) k =
      (momMult m s k).comp (momMult m t k) := by
  unfold momMult
  rw [ExactFlowTimeGroup.exactFlow_add_time, map_mul]
  rfl

/-- The exact momentum multiplier is a time-additive group on `L2`
equivalence classes. -/
theorem momMultL2Isometry_add_time (m s t : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    momMultL2Isometry m (s + t) f =
      momMultL2Isometry m s (momMultL2Isometry m t f) := by
  unfold momMultL2Isometry
  rw [← variablePointwiseL2Isometry_comp (volume : Measure FourierMomentum3)
    (momMult m s) (momMult m t)
    (momMult_aestronglyMeasurable m s) (momMult_aestronglyMeasurable m t)
    (momMult_isometry m s) (momMult_isometry m t) f]
  refine Lp.ext ?_
  filter_upwards [variablePointwiseL2Isometry_coeFn (volume : Measure FourierMomentum3)
      (momMult m (s + t)) (momMult_aestronglyMeasurable m (s + t))
      (momMult_isometry m (s + t)) f,
    variablePointwiseL2Isometry_coeFn (volume : Measure FourierMomentum3)
      (fun k => (momMult m s k).comp (momMult m t k))
      (composedFamily_aestronglyMeasurable (volume : Measure FourierMomentum3)
        (momMult m s) (momMult m t)
        (momMult_aestronglyMeasurable m s) (momMult_aestronglyMeasurable m t))
      (composedFamily_isometry (momMult m s) (momMult m t)
        (momMult_isometry m s) (momMult_isometry m t)) f] with k h1 h2
  rw [h1, h2]
  simp only [appliedRepresentative, ContinuousLinearMap.comp_apply]
  rw [momMult_add_time]
  rfl

/-- Fourier conjugation transports the same group law to position-space `L2`. -/
theorem positionExactFlowL2Isometry_add_time (m s t : Real)
    (f : SpinorL2) :
    positionExactFlowL2Isometry m (s + t) f =
      positionExactFlowL2Isometry m s
        (positionExactFlowL2Isometry m t f) := by
  refine (MeasureTheory.Lp.fourierTransformₗᵢ FourierMomentum3 Spinor).injective ?_
  rw [fourier_positionExactFlowL2Isometry, fourier_positionExactFlowL2Isometry,
    fourier_positionExactFlowL2Isometry]
  exact momMultL2Isometry_add_time m s t _

/-- Momentum-space inverse control in the displayed order. -/
theorem momMultL2Isometry_mul_neg_time (m t : Real)
    (f : Lp Spinor 2 (volume : Measure FourierMomentum3)) :
    momMultL2Isometry m t (momMultL2Isometry m (-t) f) = f := by
  rw [← momMultL2Isometry_add_time, add_neg_cancel]
  exact momMultL2Isometry_zero_time m f

/-- Position-space reverse-order inverse control. -/
theorem positionExactFlowL2Isometry_neg_time_mul (m t : Real)
    (f : SpinorL2) :
    positionExactFlowL2Isometry m (-t)
      (positionExactFlowL2Isometry m t f) = f := by
  rw [← positionExactFlowL2Isometry_add_time, neg_add_cancel]
  exact positionExactFlowL2Isometry_zero_time m f

/-- The capstone includes the already established strong continuity of every
fixed position-space orbit. -/
theorem position_orbit_continuous_control (m : Real) (f : SpinorL2) :
    Continuous (fun t : Real => positionExactFlowL2Isometry m t f) :=
  positionExactFlowL2Orbit_continuous m f

end PhysicsSM.Draft.NullEdge.ExactFlowL2GroupCapstone
