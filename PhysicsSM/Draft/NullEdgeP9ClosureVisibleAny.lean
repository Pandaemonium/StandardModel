import Mathlib.Tactic

/-!
# P9 visible closure source from any nonzero component

This scalar diagnostic strengthens the current closure-source API: any nonzero
closure-defect component makes the closure-defect source observable nonzero.
It is still only a scalar diagnostic, not the full finite diamond source
functional needed for the cosmology branch.
-/

namespace PhysicsSM.Draft.NullEdgeP9ClosureVisibleAny

def closureDefectSq (cx cy cz : Real) : Real :=
  cx ^ 2 + cy ^ 2 + cz ^ 2

def VisibleClosureSource (cx cy cz : Real) : Prop :=
  closureDefectSq cx cy cz = 0 -> False

theorem visibleClosureSource_of_any_nonzero_component
    (cx cy cz : Real)
    (h : Or (cx = 0 -> False)
          (Or (cy = 0 -> False) (cz = 0 -> False))) :
    VisibleClosureSource cx cy cz := by
  intro hzero
  unfold closureDefectSq at hzero
  rcases h with hx | hy | hz
  · exact hx (by nlinarith [sq_nonneg cx, sq_nonneg cy, sq_nonneg cz])
  · exact hy (by nlinarith [sq_nonneg cx, sq_nonneg cy, sq_nonneg cz])
  · exact hz (by nlinarith [sq_nonneg cx, sq_nonneg cy, sq_nonneg cz])

end PhysicsSM.Draft.NullEdgeP9ClosureVisibleAny
