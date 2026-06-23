import Mathlib.Tactic

/-!
# P2 dephasing determinant monotonicity

Removing a real off-diagonal chirality coherence term cannot decrease the
determinant of this two-level scalar model.
-/

namespace PhysicsSM.Draft.NullEdgeP2DephasingDetMonotone

def chiralDet (q c : Real) : Real :=
  q * (1 - q) - c ^ 2

def dephasedDet (q _c : Real) : Real :=
  q * (1 - q)

theorem chiralDet_le_dephasedDet
    (q c : Real) :
    chiralDet q c <= dephasedDet q c := by
  unfold chiralDet dephasedDet
  nlinarith [sq_nonneg c]

end PhysicsSM.Draft.NullEdgeP2DephasingDetMonotone
