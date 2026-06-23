import Mathlib.Tactic

/-!
# P1 mass-ratio and velocity algebra

This module isolates the scalar identity behind the observer-conditioned
relation `(m / E)^2 = 1 - v^2`, with `v^2 = |p|^2 / E^2`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP1MassRatioVelocity

def speedSq (E pSq : Real) : Real :=
  pSq / E ^ 2

def massRatioSq (E pSq : Real) : Real :=
  (E ^ 2 - pSq) / E ^ 2

theorem massRatioSq_eq_one_sub_speedSq
    (E pSq : Real) (hE : E ≠ 0) :
    massRatioSq E pSq = 1 - speedSq E pSq := by
  unfold massRatioSq speedSq
  field_simp

end PhysicsSM.Draft.NullEdgeP1MassRatioVelocity
