import Mathlib.Tactic

/-!
# P2 exact dephasing determinant gap

The scalar determinant increase after explicit chirality dephasing is exactly
the squared real coherence removed by the readout channel.
-/

namespace PhysicsSM.Draft.NullEdgeP2DephasingGap

def chiralDet (q c : Real) : Real :=
  q * (1 - q) - c ^ 2

def dephasedDet (q _c : Real) : Real :=
  q * (1 - q)

theorem dephasedDet_sub_chiralDet_eq_coherenceSq
    (q c : Real) :
    dephasedDet q c - chiralDet q c = c ^ 2 := by
  unfold dephasedDet chiralDet
  ring

theorem dephasedDet_eq_chiralDet_add_coherenceSq
    (q c : Real) :
    dephasedDet q c = chiralDet q c + c ^ 2 := by
  unfold dephasedDet chiralDet
  ring

end PhysicsSM.Draft.NullEdgeP2DephasingGap
