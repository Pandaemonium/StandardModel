import Mathlib

/-!
# Exact cancellation in a rotating two-band discrete evolution

This finite control tests the replacement for the failed absolute
moving-projector telescope. A rank-one band rotates through a fixed macroscopic
angle while each frozen step has the same exact two-phase gap. In the moving
frame the physical product reduces to a single matrix whose square is the
identity. The resulting cross-band leakage is `O(1 / N)` even though the sum
of absolute projector mismatches has a nonzero fixed-path limit.

The result is not an HNU adiabatic theorem. It proves that coherent
cancellation can close a gate which the triangle inequality cannot, and it
isolates the algebra needed by the HNU successor.

Provenance: theorem design and statements prepared in this repository from the
discrete-adiabatic literature review; all proofs returned by Aristotle project
`ab02a59c-b5dd-428b-9470-0ab8a76bbad9` and locally kernel-checked under the
pinned Lean 4.28.0 toolchain.
-/

noncomputable section

open Matrix
open scoped BigOperators Topology

namespace PhysicsSM.Draft.NullEdge.DiscreteAdiabaticCancellation

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
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [rotation]

theorem rotation_add (a b : Real) :
    rotation (a + b) = rotation a * rotation b := by
  unfold rotation
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Real.sin_add, Real.cos_add, Matrix.mul_apply] <;> ring

theorem rotation_neg_mul (a : Real) :
    rotation (-a) * rotation a = 1 := by
  ext i j
  fin_cases i <;> fin_cases j <;> norm_num [rotation]
  · norm_num [Matrix.mul_apply]
    nlinarith [Real.sin_sq_add_cos_sq a]
  · norm_num [Matrix.mul_apply]
    ring
  · norm_num [Matrix.mul_apply]
    ring
  · norm_num [Matrix.mul_apply]
    nlinarith [Real.sin_sq_add_cos_sq a]

/-- The frozen dynamics preserve the instantaneous band exactly. -/
theorem frozenStep_commutes_bandProjector (theta : Real) :
    frozenStep theta * bandProjector theta =
      bandProjector theta * frozenStep theta := by
  unfold bandProjector frozenStep rotation
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Matrix.mul_apply, phaseGap, baseProjector] <;> ring

/-- The two frozen phases remain noncollapsed: the trace is exactly zero. -/
theorem frozenStep_trace_zero (theta : Real) :
    Matrix.trace (frozenStep theta) = 0 := by
  unfold frozenStep
  norm_num [rotation, phaseGap] <;> ring
  norm_num [Matrix.mul_apply, Matrix.trace] <;> ring

/-- Moving-frame reduction of the genuinely time-ordered physical evolution. -/
theorem moving_frame_reduction (delta : Real) (n : Nat) :
    rotation (-((n : Real) * delta)) * evolution delta n =
      frameStep delta ^ n := by
  induction' n with n ih
  · simp +zetaDelta at *
    exact rotation_zero.symm ▸ one_mul _
  · simp_all +decide [pow_succ', mul_assoc, evolution]
    convert congr_arg (fun x => rotation (-delta) * phaseGap * x) ih using 1
    simp +decide [← mul_assoc, ← rotation_add, ← rotation_neg_mul, frozenStep]
    ring

/-- The exact cancellation identity in the moving frame. -/
theorem frameStep_sq (delta : Real) :
    frameStep delta ^ 2 = 1 := by
  unfold frameStep rotation phaseGap
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [sq, Matrix.mul_apply] <;> ring
  · norm_num
  · exact Real.cos_sq_add_sin_sq _

theorem frameStep_even (delta : Real) (n : Nat) :
    frameStep delta ^ (2 * n) = 1 := by
  rw [pow_mul, frameStep_sq, one_pow]

theorem frameStep_odd (delta : Real) (n : Nat) :
    frameStep delta ^ (2 * n + 1) = frameStep delta := by
  rw [pow_succ, frameStep_even]
  aesop

/-- Even step counts cancel the cross-band amplitude exactly. -/
theorem frameLeakage_even (delta : Real) (n : Nat) :
    frameLeakage delta (2 * n) = 0 := by
  change (frameStep delta ^ (2 * n)) 1 0 = 0
  rw [frameStep_even]
  simp

/-- Odd step counts leave only one microscopic rotation mismatch. -/
theorem frameLeakage_odd (delta : Real) (n : Nat) :
    frameLeakage delta (2 * n + 1) = -Real.sin delta := by
  convert congr_arg (fun m : Mat2 => m 1 0) (frameStep_odd delta n) using 1
  unfold frameStep rotation phaseGap
  norm_num [Matrix.mul_apply]

/-- A fixed macroscopic path has `O(1/N)` physical leakage. -/
theorem fixed_path_leakage_bound (Theta : Real) (N : Nat) :
    |frameLeakage (Theta / ((N + 1 : Nat) : Real)) (N + 1)| <=
      |Theta| / ((N + 1 : Nat) : Real) := by
  rcases Nat.even_or_odd' N with ⟨k, rfl | rfl⟩ <;> norm_num [Nat.add_div]
  · rw [frameLeakage_odd]
    norm_num [abs_div, abs_mul, abs_neg, abs_of_nonneg, add_nonneg]
    exact le_trans Real.abs_sin_le_abs
      (by rw [abs_div, abs_of_nonneg (by positivity : (0 : Real) <= 2 * k + 1)])
  · rw [show frameLeakage (Theta / (2 * k + 1 + 1)) (2 * k + 1 + 1) = 0 from _]
    · norm_num
      positivity
    · convert frameLeakage_even (Theta / (2 * k + 1 + 1)) (k + 1) using 1

/-- The schedule traverses the full path rather than a shrinking path. -/
theorem fixed_path_nonvacuous (Theta : Real) (N : Nat) :
    ((N + 1 : Nat) : Real) *
        (Theta / ((N + 1 : Nat) : Real)) = Theta := by
  rw [mul_div_cancel₀ _ (by positivity)]

/-- Cancellation makes the physical leakage vanish along the fixed path. -/
theorem fixed_path_leakage_tendsto_zero (Theta : Real) :
    Filter.Tendsto
      (fun N : Nat =>
        |frameLeakage (Theta / ((N + 1 : Nat) : Real)) (N + 1)|)
      Filter.atTop (nhds 0) := by
  refine' squeeze_zero (fun N => abs_nonneg _) (fun N => _) _
  exact fun N => |Theta| / (N + 1)
  · convert fixed_path_leakage_bound Theta N using 1
    norm_cast
  · exact tendsto_const_nhds.div_atTop
      (Filter.tendsto_atTop_add_const_right _ _ tendsto_natCast_atTop_atTop)

end PhysicsSM.Draft.NullEdge.DiscreteAdiabaticCancellation
