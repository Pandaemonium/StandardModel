import Mathlib.Tactic

/-!
# P2 strict chirality-dephasing determinant increase

The existing draft theorem proves that dephasing away a real chirality
coherence cannot decrease the determinant. This target asks for the strict
version: if the coherence is nonzero, the dephased determinant is strictly
larger in the scalar two-level model.
-/

namespace NullEdgeP2DephasingStrict

def chiralDet (q c : Real) : Real :=
  q * (1 - q) - c ^ 2

def dephasedDet (q _c : Real) : Real :=
  q * (1 - q)

theorem chiralDet_lt_dephasedDet_of_coherence_ne_zero
    (q c : Real) (hc : c = 0 -> False) :
    chiralDet q c < dephasedDet q c := by
  sorry

end NullEdgeP2DephasingStrict
