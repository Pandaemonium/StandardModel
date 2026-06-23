import Mathlib.Tactic

noncomputable section

namespace NullEdgeP1MassRatioVelocity

def speedSq (E pSq : Real) : Real :=
  pSq / E ^ 2

def massRatioSq (E pSq : Real) : Real :=
  (E ^ 2 - pSq) / E ^ 2

theorem massRatioSq_eq_one_sub_speedSq
    (E pSq : Real) (hE : E ≠ 0) :
    massRatioSq E pSq = 1 - speedSq E pSq := by
  sorry

end NullEdgeP1MassRatioVelocity
