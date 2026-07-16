import HNURealSpace.HNUExactCore

/-!
# Real-space realization seed for the exact HNU endpoint

The supplied sibling module contains the exact momentum-space endpoint.  The
Aristotle task asks for its faithful finite real-space conditioned-shift
realization and symbol bridge.
-/

namespace HNURealSpace

/-- A finite periodic three-dimensional site register. -/
abbrev Site (L : Nat) := Fin L × Fin L × Fin L

end HNURealSpace
