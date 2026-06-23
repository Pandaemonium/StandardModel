import Mathlib.Tactic

/-!
# P9 visible closure source

This tiny scalar API records the non-tautology direction for closure defects:
if one closure component is nonzero, the stated closure-defect source observable
is nonzero.
-/

namespace PhysicsSM.Draft.NullEdgeP9ClosureVisibleSource

def closureDefectSq (cx cy cz : Real) : Real :=
  cx ^ 2 + cy ^ 2 + cz ^ 2

def VisibleClosureSource (cx cy cz : Real) : Prop :=
  closureDefectSq cx cy cz ≠ 0

theorem visibleClosureSource_of_nonzero_component
    (cx cy cz : Real) (hx : cx ≠ 0) :
    VisibleClosureSource cx cy cz := by
  unfold VisibleClosureSource closureDefectSq
  have hxpos : 0 < cx ^ 2 := sq_pos_of_ne_zero hx
  have hy : 0 <= cy ^ 2 := sq_nonneg cy
  have hz : 0 <= cz ^ 2 := sq_nonneg cz
  linarith

end PhysicsSM.Draft.NullEdgeP9ClosureVisibleSource
