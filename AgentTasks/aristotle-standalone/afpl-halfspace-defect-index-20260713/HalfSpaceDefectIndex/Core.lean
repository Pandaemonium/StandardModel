import Mathlib

/-!
Construct the smallest exact boundary-defect precursor that escapes global
finite trace cancellation. Use the unilateral shift on a half-line/truncated
half-line, compare `S* S` with `S S*`, and isolate the rank-one boundary defect.
The final theorem must distinguish a localized defect from a global finite
unitary cut trace and include a zero-defect bilateral/permutation control.
-/

namespace HalfSpaceDefectIndex

open Matrix

/-- Truncated unilateral right shift on `Fin (N+1)`. -/
def unilateral (N : Nat) : Matrix (Fin (N + 1)) (Fin (N + 1)) Rat :=
  fun i j => if i.val = j.val + 1 then 1 else 0

/-- The source-boundary defect is the rank-one projector onto site zero. -/
theorem unilateral_star_mul_sub_mul_star (N : Nat) :
    (unilateral N)ᴴ * unilateral N - unilateral N * (unilateral N)ᴴ =
      fun i j => if i = 0 ∧ j = 0 then 1 else
        if i.val = N ∧ j.val = N then -1 else 0 := by
  sorry

/-- The full finite trace cancels between the two ends. -/
theorem global_defect_trace_zero (N : Nat) :
    Matrix.trace ((unilateral N)ᴴ * unilateral N -
      unilateral N * (unilateral N)ᴴ) = 0 := by
  sorry

/-- A localized projector that excludes the far boundary detects the +1 source
defect. Choose a precise finite window statement that is nonvacuous for N>=1. -/
theorem localized_source_defect {N : Nat} (hN : 1 ≤ N) :
    ((unilateral N)ᴴ * unilateral N - unilateral N * (unilateral N)ᴴ) 0 0 = 1 := by
  sorry

end HalfSpaceDefectIndex
