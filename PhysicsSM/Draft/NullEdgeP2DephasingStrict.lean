import Mathlib.Tactic

/-!
# P2 strict chirality-dephasing determinant increase

The scalar two-level model records the explicit observer/dephasing step:
removing a nonzero real left/right coherence strictly increases this determinant
observable. This does not make the Higgs coupling dissipative; it isolates the
readout/dephasing shadow of coherent chirality coupling.
-/

namespace PhysicsSM.Draft.NullEdgeP2DephasingStrict

def chiralDet (q c : Real) : Real :=
  q * (1 - q) - c ^ 2

def dephasedDet (q _c : Real) : Real :=
  q * (1 - q)

theorem chiralDet_lt_dephasedDet_of_coherence_ne_zero
    (q c : Real) (hc : c = 0 -> False) :
    chiralDet q c < dephasedDet q c := by
  unfold chiralDet dephasedDet
  nlinarith [mul_self_pos.2 hc]

end PhysicsSM.Draft.NullEdgeP2DephasingStrict
