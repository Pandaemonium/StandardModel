import Mathlib.Tactic

/-!
# P9 visible Pluecker source toy API

This module records the non-tautology half of a source-visibility API: a
nonzero Pluecker spread must produce a nonzero source in the stated finite
observable.

The scalar chart here is intentionally tiny. It is a guardrail for later, richer
P9 definitions rather than a full cosmological source model.
-/

namespace PhysicsSM.Draft.NullEdgeP9VisiblePluckerSourceAPI

/-- Squared two-edge Pluecker source amplitude in a scalar toy chart. -/
def pluckerSourceSq (wedge : Real) : Real :=
  wedge ^ 2

/-- A visible source is nonzero when the Pluecker spread is nonzero. -/
def VisibleSource (wedge : Real) : Prop :=
  pluckerSourceSq wedge ≠ 0

/--
Nonzero Pluecker spread produces a nonzero visible source in the toy scalar API.
-/
theorem visibleSource_of_nonzero_pluckerSpread
    (wedge : Real) (hw : wedge ≠ 0) :
    VisibleSource wedge := by
  exact pow_ne_zero 2 hw

end PhysicsSM.Draft.NullEdgeP9VisiblePluckerSourceAPI
