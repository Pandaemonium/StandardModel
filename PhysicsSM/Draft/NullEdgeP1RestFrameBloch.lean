import Mathlib.Tactic

/-!
# P1 rest-frame Bloch criterion

This module records the finite scalar criterion that the observer-normalized
momentum block is maximally mixed exactly when its spatial Bloch/dipole
components vanish.
-/

namespace PhysicsSM.Draft.NullEdgeP1RestFrameBloch

/-- Squared Bloch/dipole radius of the observer-normalized momentum block. -/
def blochRadiusSq (px py pz : Real) : Real :=
  px ^ 2 + py ^ 2 + pz ^ 2

/--
The normalized momentum block is maximally mixed exactly when the spatial
dipole vanishes.
-/
theorem blochRadiusSq_zero_iff_restFrame
    (px py pz : Real) :
    blochRadiusSq px py pz = 0 <-> px = 0 /\ py = 0 /\ pz = 0 := by
  unfold blochRadiusSq
  constructor
  · intro h
    refine ⟨?_, ?_, ?_⟩ <;>
      nlinarith [sq_nonneg px, sq_nonneg py, sq_nonneg pz]
  · rintro ⟨hx, hy, hz⟩
    subst hx
    subst hy
    subst hz
    ring

end PhysicsSM.Draft.NullEdgeP1RestFrameBloch
