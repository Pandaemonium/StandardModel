import Mathlib.Tactic

/-!
# P2 dephasing purity equality iff zero coherence

The purity drop after dephasing is exactly `2*c^2`, so equality holds exactly
when the real chirality coherence is zero.
-/

namespace NullEdgeP2DephasingPurityEquality

def chiralPurity (q c : Real) : Real :=
  q ^ 2 + (1 - q) ^ 2 + 2 * c ^ 2

def dephasedPurity (q _c : Real) : Real :=
  q ^ 2 + (1 - q) ^ 2

theorem chiralPurity_sub_dephasedPurity_eq_two_coherenceSq
    (q c : Real) :
    chiralPurity q c - dephasedPurity q c = 2 * c ^ 2 := by
  sorry

theorem chiralPurity_eq_dephasedPurity_iff_coherence_zero
    (q c : Real) :
    chiralPurity q c = dephasedPurity q c <-> c = 0 := by
  sorry

theorem dephasedPurity_le_chiralPurity (q c : Real) :
    dephasedPurity q c <= chiralPurity q c := by
  sorry

end NullEdgeP2DephasingPurityEquality
