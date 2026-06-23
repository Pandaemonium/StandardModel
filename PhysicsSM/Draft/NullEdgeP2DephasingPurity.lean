import Mathlib.Tactic

/-!
# P2 dephasing and purity loss

This module complements the determinant dephasing theorem. Removing a real
off-diagonal chirality coherence term lowers the two-level purity by exactly
twice the squared coherence.
-/

namespace PhysicsSM.Draft.NullEdgeP2DephasingPurity

def chiralPurity (q c : Real) : Real :=
  q ^ 2 + (1 - q) ^ 2 + 2 * c ^ 2

def dephasedPurity (q _c : Real) : Real :=
  q ^ 2 + (1 - q) ^ 2

theorem chiralPurity_sub_dephasedPurity_eq_two_coherenceSq
    (q c : Real) :
    chiralPurity q c - dephasedPurity q c = 2 * c ^ 2 := by
  unfold chiralPurity dephasedPurity
  ring

end PhysicsSM.Draft.NullEdgeP2DephasingPurity
