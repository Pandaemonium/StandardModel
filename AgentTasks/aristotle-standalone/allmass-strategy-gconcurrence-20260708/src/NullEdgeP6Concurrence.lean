import Mathlib.Tactic
import Mathlib.Data.Matrix.Basic

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

namespace PhysicsSM.Draft.NullEdgeP6Concurrence

open Matrix

/-- Wootters concurrence of a real two-qubit pure state. -/
def concurrence (a b c d : Real) : Real := 2 * |a * d - b * c|

/-- Squared norm of the state. -/
def normSq (a b c d : Real) : Real := a ^ 2 + b ^ 2 + c ^ 2 + d ^ 2

/-
Concurrence is nonnegative.
-/
theorem concurrence_nonneg (a b c d : Real) : 0 ≤ concurrence a b c d := by
  exact mul_nonneg zero_le_two ( abs_nonneg _ )

/-
Concurrence is bounded by the squared norm (so `C <= 1` when normalized).
-/
theorem concurrence_le_normSq (a b c d : Real) :
    concurrence a b c d ≤ normSq a b c d := by
  unfold concurrence normSq
  cases abs_cases (a * d - b * c) <;>
    linarith [sq_nonneg (a - d), sq_nonneg (a + d), sq_nonneg (b - c), sq_nonneg (b + c)]

/-
Concurrence vanishes exactly on product (separable) states.
-/
theorem concurrence_zero_iff_product (a b c d : Real) :
    concurrence a b c d = 0 ↔ a * d = b * c := by
  grind +locals

def rho (a b c d : Real) : Matrix (Fin 2) (Fin 2) Real :=
  !![a^2 + b^2, a * c + b * d;
     a * c + b * d, c^2 + d^2]

theorem concurrence_sq_eq_four_mul_det (a b c d : Real) :
    concurrence a b c d ^ 2 = 4 * (rho a b c d).det := by
  unfold concurrence rho
  rw [mul_pow, sq_abs]
  simp [Matrix.det_fin_two]
  ring

end PhysicsSM.Draft.NullEdgeP6Concurrence
