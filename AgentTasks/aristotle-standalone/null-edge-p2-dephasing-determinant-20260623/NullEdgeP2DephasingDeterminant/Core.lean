import Mathlib.Tactic

namespace NullEdgeP2DephasingDeterminant

/--
Determinant of a real two-level chiral density block with diagonal weight `q`
and real off-diagonal chirality coherence `c`.
-/
def chiralDet (q c : Real) : Real :=
  q * (1 - q) - c ^ 2

/-- Determinant after the observer channel removes the off-diagonal coherence. -/
def dephasedDet (q _c : Real) : Real :=
  q * (1 - q)

/--
Observer dephasing increases the determinant by exactly the squared removed
chirality coherence.

This is the finite algebra behind the statement that Higgs/Yukawa coupling first
creates left/right coherence; visible mixedness appears only after an explicit
observer/dephasing channel.
-/
theorem dephasedDet_sub_chiralDet_eq_coherenceSq
    (q c : Real) :
    dephasedDet q c - chiralDet q c = c ^ 2 := by
  sorry

end NullEdgeP2DephasingDeterminant
