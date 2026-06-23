import Mathlib.Tactic

/-!
# P2 exact dephasing determinant gap

The strict dephasing result has an exact scalar gap: the determinant increase is
the squared real chirality coherence removed by the dephasing/readout channel.
-/

namespace NullEdgeP2DephasingGap

def chiralDet (q c : Real) : Real :=
  q * (1 - q) - c ^ 2

def dephasedDet (q _c : Real) : Real :=
  q * (1 - q)

theorem dephasedDet_sub_chiralDet_eq_coherenceSq
    (q c : Real) :
    dephasedDet q c - chiralDet q c = c ^ 2 := by
  sorry

theorem dephasedDet_eq_chiralDet_add_coherenceSq
    (q c : Real) :
    dephasedDet q c = chiralDet q c + c ^ 2 := by
  sorry

end NullEdgeP2DephasingGap
