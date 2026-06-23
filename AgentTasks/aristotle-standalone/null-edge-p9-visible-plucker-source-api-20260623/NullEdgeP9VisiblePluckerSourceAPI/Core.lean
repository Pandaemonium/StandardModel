import Mathlib.Tactic

namespace NullEdgeP9VisiblePluckerSourceAPI

/-- Squared two-edge Pluecker source amplitude in a scalar toy chart. -/
def pluckerSourceSq (wedge : Real) : Real :=
  wedge ^ 2

/-- A visible source is nonzero when the Pluecker spread is nonzero. -/
def VisibleSource (wedge : Real) : Prop :=
  pluckerSourceSq wedge ≠ 0

/--
Nonzero Pluecker spread produces a nonzero visible source in the toy scalar API.

This is the non-tautology half of the P9 source-visibility program: visible
Pluecker excitation must source something under the stated observable, rather
than source visibility being true merely by definition.
-/
theorem visibleSource_of_nonzero_pluckerSpread
    (wedge : Real) (hw : wedge ≠ 0) :
    VisibleSource wedge := by
  sorry

end NullEdgeP9VisiblePluckerSourceAPI
