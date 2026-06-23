import Mathlib.Tactic

namespace NullEdgeP9ClosureVisibleSource

def closureDefectSq (cx cy cz : Real) : Real :=
  cx ^ 2 + cy ^ 2 + cz ^ 2

def VisibleClosureSource (cx cy cz : Real) : Prop :=
  closureDefectSq cx cy cz ≠ 0

theorem visibleClosureSource_of_nonzero_component
    (cx cy cz : Real) (hx : cx ≠ 0) :
    VisibleClosureSource cx cy cz := by
  sorry

end NullEdgeP9ClosureVisibleSource
