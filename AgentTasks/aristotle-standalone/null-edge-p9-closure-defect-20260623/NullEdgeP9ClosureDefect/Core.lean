import Mathlib.Tactic

namespace NullEdgeP9ClosureDefect

def closureDefectSq (cx cy cz : Real) : Real :=
  cx ^ 2 + cy ^ 2 + cz ^ 2

theorem closureDefectSq_zero_iff_closed
    (cx cy cz : Real) :
    closureDefectSq cx cy cz = 0 <-> cx = 0 ∧ cy = 0 ∧ cz = 0 := by
  sorry

end NullEdgeP9ClosureDefect
