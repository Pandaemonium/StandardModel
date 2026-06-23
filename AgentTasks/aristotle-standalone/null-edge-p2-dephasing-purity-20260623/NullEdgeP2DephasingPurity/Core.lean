import Mathlib.Tactic

namespace NullEdgeP2DephasingPurity

def chiralPurity (q c : Real) : Real :=
  q ^ 2 + (1 - q) ^ 2 + 2 * c ^ 2

def dephasedPurity (q _c : Real) : Real :=
  q ^ 2 + (1 - q) ^ 2

theorem chiralPurity_sub_dephasedPurity_eq_two_coherenceSq
    (q c : Real) :
    chiralPurity q c - dephasedPurity q c = 2 * c ^ 2 := by
  sorry

end NullEdgeP2DephasingPurity
