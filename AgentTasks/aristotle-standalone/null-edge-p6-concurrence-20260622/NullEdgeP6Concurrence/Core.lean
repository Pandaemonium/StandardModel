import Mathlib.Tactic

/-!
# P6 two-qubit concurrence bounds and separability

For a (real-amplitude) two-qubit pure state `a|00> + b|01> + c|10> + d|11>`, the
Wootters concurrence is `C = 2|ad - bc|`. It is nonnegative, bounded by the norm
(so `C <= 1` for normalized states), and vanishes exactly on product
(separable) states `ad = bc`. This is the entanglement-measure foundation linking
the celestial reduced-density / mass-ratio program (P6/P7) to a finite invariant.

Standalone (Mathlib only).
-/

noncomputable section

namespace NullEdgeP6Concurrence

/-- Wootters concurrence of a real two-qubit pure state. -/
def concurrence (a b c d : Real) : Real := 2 * |a * d - b * c|

/-- Squared norm of the state. -/
def normSq (a b c d : Real) : Real := a ^ 2 + b ^ 2 + c ^ 2 + d ^ 2

/-- Concurrence is nonnegative. -/
theorem concurrence_nonneg (a b c d : Real) : 0 ≤ concurrence a b c d := by
  sorry

/-- Concurrence is bounded by the squared norm (so `C <= 1` when normalized). -/
theorem concurrence_le_normSq (a b c d : Real) :
    concurrence a b c d ≤ normSq a b c d := by
  sorry

/-- Concurrence vanishes exactly on product (separable) states. -/
theorem concurrence_zero_iff_product (a b c d : Real) :
    concurrence a b c d = 0 ↔ a * d = b * c := by
  sorry

end NullEdgeP6Concurrence
