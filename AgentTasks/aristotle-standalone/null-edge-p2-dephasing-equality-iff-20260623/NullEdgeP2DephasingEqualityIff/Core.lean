import Mathlib.Tactic

/-!
# P2 dephasing equality iff zero coherence

The exact dephasing gap is `c^2`; equality therefore holds exactly when the
real chirality coherence is zero.
-/

namespace NullEdgeP2DephasingEqualityIff

def chiralDet (q c : Real) : Real :=
  q * (1 - q) - c ^ 2

def dephasedDet (q _c : Real) : Real :=
  q * (1 - q)

theorem dephasedDet_eq_chiralDet_iff_coherence_zero
    (q c : Real) :
    dephasedDet q c = chiralDet q c <-> c = 0 := by
  sorry

theorem chiralDet_le_dephasedDet_and_eq_iff
    (q c : Real) :
    And (chiralDet q c <= dephasedDet q c)
      (chiralDet q c = dephasedDet q c <-> c = 0) := by
  sorry

end NullEdgeP2DephasingEqualityIff
