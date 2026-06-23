import Mathlib.Tactic

/-!
# P2 dephasing equality iff zero coherence

The exact determinant gap after explicit chirality dephasing is `c^2`; equality
therefore holds exactly when the real chirality coherence is zero.
-/

namespace PhysicsSM.Draft.NullEdgeP2DephasingEqualityIff

def chiralDet (q c : Real) : Real :=
  q * (1 - q) - c ^ 2

def dephasedDet (q _c : Real) : Real :=
  q * (1 - q)

theorem dephasedDet_eq_chiralDet_iff_coherence_zero (q c : Real) :
    dephasedDet q c = chiralDet q c <-> c = 0 := by
  unfold dephasedDet chiralDet
  constructor <;> intro h <;> nlinarith

theorem chiralDet_le_dephasedDet_and_eq_iff (q c : Real) :
    And (chiralDet q c <= dephasedDet q c)
      (chiralDet q c = dephasedDet q c <-> c = 0) := by
  constructor
  · unfold chiralDet dephasedDet
    nlinarith [sq_nonneg c]
  · unfold chiralDet dephasedDet
    constructor <;> intro h <;> nlinarith

end PhysicsSM.Draft.NullEdgeP2DephasingEqualityIff
