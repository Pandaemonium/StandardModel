import Mathlib.Tactic

/-!
# P1 mass-ratio bounds

If the squared speed satisfies `0 <= v^2 <= 1`, then the observer-conditioned
mass-ratio square `1 - v^2` also lies in `[0,1]`.
-/

namespace PhysicsSM.Draft.NullEdgeP1MassRatioBounds

def massRatioSqFromSpeedSq (vSq : Real) : Real :=
  1 - vSq

theorem massRatioSq_bounds_of_speedSq_bounds
    (vSq : Real) (hv0 : 0 <= vSq) (hv1 : vSq <= 1) :
    0 <= massRatioSqFromSpeedSq vSq ∧ massRatioSqFromSpeedSq vSq <= 1 := by
  exact ⟨sub_nonneg.2 hv1, sub_le_self _ hv0⟩

end PhysicsSM.Draft.NullEdgeP1MassRatioBounds
