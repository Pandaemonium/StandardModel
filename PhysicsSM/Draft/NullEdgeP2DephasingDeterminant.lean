import Mathlib.Tactic

/-!
# P2 dephasing and determinant growth

This module formalizes a small part of the refined Higgs/Yukawa story. The
off-diagonal mass coupling first creates left/right chirality coherence. If an
observer channel removes that off-diagonal coherence, the determinant increases
by exactly the squared coherence that was removed.
-/

namespace PhysicsSM.Draft.NullEdgeP2DephasingDeterminant

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
-/
theorem dephasedDet_sub_chiralDet_eq_coherenceSq
    (q c : Real) :
    dephasedDet q c - chiralDet q c = c ^ 2 := by
  unfold dephasedDet chiralDet
  ring

end PhysicsSM.Draft.NullEdgeP2DephasingDeterminant
