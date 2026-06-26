import Mathlib

/-!
# NullStrand i.i.d. trajectory telescoping target

Focused ERG-002 algebra layer: positions built by summing primitive increments
have displacement equal to the finite partial sum of increments.
-/

noncomputable section

namespace NullStrandIIDTelescope

open scoped BigOperators

/-- Position after finitely many increments. -/
def position {E : Type*} [Add E] (x0 : E) (step : Nat -> E) : Nat -> E
  | 0 => x0
  | n + 1 => position x0 step n + step n

/-- Recursive positions are initial point plus the finite increment sum. -/
theorem position_eq_initial_add_sum {E : Type*} [AddCommMonoid E]
    (x0 : E) (step : Nat -> E) (n : Nat) :
    position x0 step n = x0 + (Finset.range n).sum step := by
  induction n with
  | zero => simp [position]
  | succ k ih =>
    rw [position, ih, Finset.sum_range_succ, add_assoc]

/-- The displacement is exactly the finite sum of increments. -/
theorem displacement_eq_sum {E : Type*} [AddCommGroup E]
    (x0 : E) (step : Nat -> E) (n : Nat) :
    position x0 step n - x0 = (Finset.range n).sum step := by
  rw [position_eq_initial_add_sum, add_sub_cancel_left]

/-- Coarse displacement is the empirical increment average. -/
theorem coarse_displacement_eq_average
    {E : Type*} [NormedAddCommGroup E] [NormedSpace Real E]
    (x0 : E) (step : Nat -> E) (n : Nat) :
    (n : Real)⁻¹ • (position x0 step n - x0) =
      (n : Real)⁻¹ • (Finset.range n).sum step := by
  rw [displacement_eq_sum]

end NullStrandIIDTelescope
