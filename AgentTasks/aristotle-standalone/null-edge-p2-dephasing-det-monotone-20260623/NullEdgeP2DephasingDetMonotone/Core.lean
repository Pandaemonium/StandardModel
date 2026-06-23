import Mathlib.Tactic

namespace NullEdgeP2DephasingDetMonotone

def chiralDet (q c : Real) : Real :=
  q * (1 - q) - c ^ 2

def dephasedDet (q _c : Real) : Real :=
  q * (1 - q)

theorem chiralDet_le_dephasedDet
    (q c : Real) :
    chiralDet q c <= dephasedDet q c := by
  sorry

end NullEdgeP2DephasingDetMonotone
