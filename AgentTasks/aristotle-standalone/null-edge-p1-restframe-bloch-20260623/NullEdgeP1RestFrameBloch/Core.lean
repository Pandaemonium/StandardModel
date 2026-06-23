import Mathlib.Tactic

namespace NullEdgeP1RestFrameBloch

/-- Squared Bloch/dipole radius of the observer-normalized momentum block. -/
def blochRadiusSq (px py pz : Real) : Real :=
  px ^ 2 + py ^ 2 + pz ^ 2

/--
The normalized momentum block is maximally mixed exactly when the spatial
dipole vanishes.
-/
theorem blochRadiusSq_zero_iff_restFrame
    (px py pz : Real) :
    blochRadiusSq px py pz = 0 <-> px = 0 ∧ py = 0 ∧ pz = 0 := by
  sorry

end NullEdgeP1RestFrameBloch
