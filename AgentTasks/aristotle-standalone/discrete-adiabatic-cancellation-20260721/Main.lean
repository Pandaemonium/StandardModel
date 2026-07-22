import Mathlib

/-!
# Exact cancellation in a rotating two-band discrete evolution

This focused target tests the replacement for the failed absolute
moving-projector telescope.  A rank-one band rotates through a fixed macroscopic
angle while each frozen step has the same exact two-phase gap.  In the moving
frame the physical product reduces to a single matrix whose square is the
identity.  The resulting cross-band leakage is `O(1 / N)` even though the sum
of absolute projector mismatches has a nonzero fixed-path limit.

The target is a finite two-level control, not an HNU adiabatic theorem.  It is
designed to prove that cancellation can close a gate which the triangle
inequality cannot, and to isolate the algebra needed by the HNU successor.
-/

noncomputable section

open Matrix
open scoped BigOperators Topology

namespace DiscreteAdiabaticCancellation

abbrev Vec2 := Fin 2 -> Real
abbrev Mat2 := Matrix (Fin 2) (Fin 2) Real

/-- Counterclockwise rotation in the displayed real two-level basis. -/
def rotation (theta : Real) : Mat2 :=
  ![![Real.cos theta, -Real.sin theta],
    ![Real.sin theta, Real.cos theta]]

/-- Frozen quasienergy phases `+1` and `-1`. -/
def phaseGap : Mat2 := ![![1, 0], ![0, -1]]

/-- Projector onto the first vector of the unrotated basis. -/
def baseProjector : Mat2 := ![![1, 0], ![0, 0]]

/-- Projector onto the first member of the rotated basis. -/
def bandProjector (theta : Real) : Mat2 :=
  rotation theta * baseProjector * rotation (-theta)

/-- Physical frozen step at parameter `theta`. -/
def frozenStep (theta : Real) : Mat2 :=
  rotation theta * phaseGap * rotation (-theta)

/-- One physical update per schedule point, ordered with later steps on the left. -/
def evolution (delta : Real) : Nat -> Mat2
  | 0 => 1
  | n + 1 => frozenStep ((n : Real) * delta) * evolution delta n

/-- The constant step seen in the frame moving with the selected band. -/
def frameStep (delta : Real) : Mat2 := rotation (-delta) * phaseGap

/-- Cross-band amplitude after `n` moving-frame steps. -/
def frameLeakage (delta : Real) (n : Nat) : Real :=
  (frameStep delta ^ n) 1 0

theorem rotation_zero : rotation 0 = 1 := by
  sorry

theorem rotation_add (a b : Real) :
    rotation (a + b) = rotation a * rotation b := by
  sorry

theorem rotation_neg_mul (a : Real) :
    rotation (-a) * rotation a = 1 := by
  sorry

/-- The frozen dynamics preserve the instantaneous band exactly. -/
theorem frozenStep_commutes_bandProjector (theta : Real) :
    frozenStep theta * bandProjector theta =
      bandProjector theta * frozenStep theta := by
  sorry

/-- The two frozen phases remain noncollapsed: the trace is exactly zero. -/
theorem frozenStep_trace_zero (theta : Real) :
    Matrix.trace (frozenStep theta) = 0 := by
  sorry

/-- Moving-frame reduction of the genuinely time-ordered physical evolution. -/
theorem moving_frame_reduction (delta : Real) (n : Nat) :
    rotation (-((n : Real) * delta)) * evolution delta n =
      frameStep delta ^ n := by
  sorry

/-- The key cancellation identity. -/
theorem frameStep_sq (delta : Real) :
    frameStep delta ^ 2 = 1 := by
  sorry

theorem frameStep_even (delta : Real) (n : Nat) :
    frameStep delta ^ (2 * n) = 1 := by
  sorry

theorem frameStep_odd (delta : Real) (n : Nat) :
    frameStep delta ^ (2 * n + 1) = frameStep delta := by
  sorry

/-- Even step counts cancel the cross-band amplitude exactly. -/
theorem frameLeakage_even (delta : Real) (n : Nat) :
    frameLeakage delta (2 * n) = 0 := by
  sorry

/-- Odd step counts leave only one microscopic rotation mismatch. -/
theorem frameLeakage_odd (delta : Real) (n : Nat) :
    frameLeakage delta (2 * n + 1) = -Real.sin delta := by
  sorry

/-- A fixed macroscopic path has `O(1/N)` physical leakage. -/
theorem fixed_path_leakage_bound (Theta : Real) (N : Nat) :
    |frameLeakage (Theta / ((N + 1 : Nat) : Real)) (N + 1)| <=
      |Theta| / ((N + 1 : Nat) : Real) := by
  sorry

/-- The schedule still traverses the full path rather than a shrinking path. -/
theorem fixed_path_nonvacuous (Theta : Real) (N : Nat) :
    ((N + 1 : Nat) : Real) *
        (Theta / ((N + 1 : Nat) : Real)) = Theta := by
  sorry

/-- Cancellation makes the physical leakage vanish along the fixed path. -/
theorem fixed_path_leakage_tendsto_zero (Theta : Real) :
    Filter.Tendsto
      (fun N : Nat =>
        |frameLeakage (Theta / ((N + 1 : Nat) : Real)) (N + 1)|)
      Filter.atTop (nhds 0) := by
  sorry

end DiscreteAdiabaticCancellation
