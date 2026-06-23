import Mathlib.Tactic

namespace NullEdgeP1MassRatioBounds

def massRatioSqFromSpeedSq (vSq : Real) : Real :=
  1 - vSq

theorem massRatioSq_bounds_of_speedSq_bounds
    (vSq : Real) (hv0 : 0 <= vSq) (hv1 : vSq <= 1) :
    0 <= massRatioSqFromSpeedSq vSq ∧ massRatioSqFromSpeedSq vSq <= 1 := by
  sorry

end NullEdgeP1MassRatioBounds
