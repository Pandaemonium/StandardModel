import Mathlib
import PhysicsSM.Spinor.Checkerboard
import PhysicsSM.Draft.CheckerboardCornerCountAristotle
import PhysicsSM.Draft.CheckerboardCornerClosedFormsAristotle
import PhysicsSM.Draft.CheckerboardCornerPolynomialAristotle
import PhysicsSM.Draft.CheckerboardKernelClosedFormsAristotle
import PhysicsSM.Draft.CheckerboardSpinorRecursionAristotle
import PhysicsSM.Draft.NullEdge.CheckerboardCarrierBridge

/-!
# Draft.NullEdge.ExactCheckerboardPathSum

The exact finite path-history theorem for the `1+1`-dimensional Feynman
checkerboard, phrased over an explicit Gaussian-rational commutative ring.

This file turns the static null-edge carrier of
`PhysicsSM.Draft.NullEdge.CheckerboardCarrierBridge` into a genuine finite
checkerboard sum over lattice histories with a Gaussian-rational corner
amplitude `mu = i · (eps · m)`, and proves:

1. `GaussianRat`, an explicit commutative ring of rational pairs with the usual
   complex multiplication (`ofRat`, `I`, and `GaussianRat.I_sq : I * I = -1`).
   No analytic `Complex` is used for the payload.
2. `pathAmplitude_eq_corner_power`: each history amplitude is
   `(I · ofRat (eps · m)) ^ turnCount startDir h`, i.e. the finite corner
   weight raised to the number of corners.
3. `exact_path_sum_eq_closed_kernel`: the finite sum over histories equals the
   binomial corner-count kernel exactly (a specialization of the landed
   generic-semiring closed form).
4. `exact_path_sum_dirac_recursion`: the same exact path sum satisfies the
   landed one-step discrete Dirac recursion.
5. `massless_positive_corner_vanishes` / `massless_only_straight`: the turn-phase
   boundary at `m = 0`, where every positive-corner history has zero amplitude
   and only zero-corner straight histories can contribute.
6. `t3_mass_dependent_witness`: an explicit `n = 3` nondegenerate witness with a
   corner, a nonzero amplitude, and visibly different values at two rational
   masses.

**Verdict (`turn_phase_verdict`).** In the finite `1+1` checkerboard, the
propagator is exactly a sum over null histories and mass enters each history
only through corner amplitudes.  No continuum limit, no `3+1` propagator, and no
measured mass is claimed.

Status: draft, kernel-checked; axiom footprint printed in-file.
-/

/-! ## The Gaussian-rational commutative ring -/

/-- Gaussian rationals: rational pairs `re + im · i` with the usual complex
multiplication.  This is the explicit payload ring for the finite checkerboard
path sum; no analytic `Complex` is involved. -/
@[ext] structure GaussianRat where
  re : ℚ
  im : ℚ
deriving DecidableEq, Repr

namespace GaussianRat

instance : Add GaussianRat := ⟨fun x y => ⟨x.re + y.re, x.im + y.im⟩⟩
instance : Mul GaussianRat := ⟨fun x y => ⟨x.re * y.re - x.im * y.im, x.re * y.im + x.im * y.re⟩⟩
instance : Neg GaussianRat := ⟨fun x => ⟨-x.re, -x.im⟩⟩
instance : Zero GaussianRat := ⟨⟨0, 0⟩⟩
instance : One GaussianRat := ⟨⟨1, 0⟩⟩

@[simp] theorem add_re (x y : GaussianRat) : (x + y).re = x.re + y.re := rfl
@[simp] theorem add_im (x y : GaussianRat) : (x + y).im = x.im + y.im := rfl
@[simp] theorem mul_re (x y : GaussianRat) : (x * y).re = x.re * y.re - x.im * y.im := rfl
@[simp] theorem mul_im (x y : GaussianRat) : (x * y).im = x.re * y.im + x.im * y.re := rfl
@[simp] theorem neg_re (x : GaussianRat) : (-x).re = -x.re := rfl
@[simp] theorem neg_im (x : GaussianRat) : (-x).im = -x.im := rfl
@[simp] theorem zero_re : (0 : GaussianRat).re = 0 := rfl
@[simp] theorem zero_im : (0 : GaussianRat).im = 0 := rfl
@[simp] theorem one_re : (1 : GaussianRat).re = 1 := rfl
@[simp] theorem one_im : (1 : GaussianRat).im = 0 := rfl

instance : CommRing GaussianRat :=
  CommRing.ofMinimalAxioms
    (fun _ _ _ => by ext <;> simp <;> ring)
    (fun _ => by ext <;> simp)
    (fun _ => by ext <;> simp)
    (fun _ _ _ => by ext <;> simp <;> ring)
    (fun _ _ => by ext <;> simp <;> ring)
    (fun _ => by ext <;> simp)
    (fun _ _ _ => by ext <;> simp <;> ring)

/-- The imaginary unit `i = (0, 1)`. -/
def I : GaussianRat := ⟨0, 1⟩

/-- The ring embedding of a rational `q ↦ (q, 0)`. -/
def ofRat (q : ℚ) : GaussianRat := ⟨q, 0⟩

@[simp] theorem I_re : I.re = 0 := rfl
@[simp] theorem I_im : I.im = 1 := rfl
@[simp] theorem ofRat_re (q : ℚ) : (ofRat q).re = q := rfl
@[simp] theorem ofRat_im (q : ℚ) : (ofRat q).im = 0 := rfl

/-- The defining relation `i² = -1`. -/
theorem I_sq : I * I = -1 := by
  ext <;> simp

@[simp] theorem ofRat_zero : ofRat 0 = 0 := by ext <;> simp
@[simp] theorem ofRat_one : ofRat 1 = 1 := by ext <;> simp

theorem ofRat_mul (a b : ℚ) : ofRat (a * b) = ofRat a * ofRat b := by
  ext <;> simp

end GaussianRat

open PhysicsSM.Spinor.Checkerboard
open PhysicsSM.Spinor.Checkerboard.Direction

/-! ## The Gaussian-rational corner amplitude -/

/-- The finite checkerboard corner weight `mu = i · (eps · m)` as a
Gaussian rational.  In the physical checkerboard `eps` is the lattice spacing
and `m` the (rational) Dirac mass; the amplitude to reverse direction at a
corner is exactly this scalar. -/
def cornerWeight (eps m : ℚ) : GaussianRat := GaussianRat.I * GaussianRat.ofRat (eps * m)

/-- The Gaussian-rational amplitude of a single finite null history: the corner
weight `mu = i · (eps · m)` raised to the number of corners. -/
def pathAmplitude (eps m : ℚ) (startDir : Direction) (h : List Direction) : GaussianRat :=
  (cornerWeight eps m) ^ turnCount startDir h

/-- At zero mass the corner weight vanishes: `mu = i · (eps · 0) = 0`. -/
@[simp] theorem cornerWeight_massless (eps : ℚ) : cornerWeight eps 0 = 0 := by
  simp [cornerWeight]

/-- **History amplitude = corner power.**  The multiplicative `pathWeight` in the
Gaussian-rational corner weight `mu = i · (eps · m)` is exactly the corner
amplitude `mu ^ turnCount`: mass enters a history only through its corners. -/
theorem pathAmplitude_eq_corner_power (eps m : ℚ) (startDir : Direction)
    (h : List Direction) :
    pathWeight (cornerWeight eps m) startDir h = pathAmplitude eps m startDir h := by
  rw [pathAmplitude,
    PhysicsSM.Draft.CheckerboardSpinorRecursion.pathWeight_eq_pow_turnCount]

/-! ## The exact finite path sum equals the closed binomial kernel -/

/-- **Exact checkerboard path sum = closed binomial kernel.**  For a path from
`0` to displacement `p - q` in `p + q` lightlike steps, incoming right and
terminating right, the finite Gaussian-rational sum over histories equals the
binomial corner-count kernel exactly.  Only even corner counts contribute; the
coefficient of `mu ^ (2r)` counts the alternating runs of the `p` right and `q`
left steps.  This is a specialization of the landed generic-semiring closed form
`PhysicsSM.Draft.CheckerboardKernelClosedForms.pathSum_right_right_closed_form`. -/
theorem exact_path_sum_eq_closed_kernel (eps m : ℚ) (p q : Nat) (hq : 0 < q) :
    pathSum (cornerWeight eps m) 0 Direction.right (p + q)
        ((p : Int) - (q : Int)) Direction.right
      =
        ∑ r ∈ Finset.Icc 1 (p + q),
          ((p.choose r * (q - 1).choose (r - 1) : Nat) : GaussianRat)
            * (cornerWeight eps m) ^ (2 * r) :=
  PhysicsSM.Draft.CheckerboardKernelClosedForms.pathSum_right_right_closed_form
    (cornerWeight eps m) p q hq

/-- **Chirality-flip kernel.**  The right-incoming, left-terminating exact path
sum equals the odd-corner binomial kernel; this is the companion component of
the finite Dirac kernel.  Specialization of
`PhysicsSM.Draft.CheckerboardKernelClosedForms.pathSum_right_left_closed_form`. -/
theorem exact_path_sum_flip_closed_kernel (eps m : ℚ) (p q : Nat) (hq : 0 < q) :
    pathSum (cornerWeight eps m) 0 Direction.right (p + q)
        ((p : Int) - (q : Int)) Direction.left
      =
        ∑ r ∈ Finset.range (p + 1),
          ((p.choose r * (q - 1).choose r : Nat) : GaussianRat)
            * (cornerWeight eps m) ^ (2 * r + 1) :=
  PhysicsSM.Draft.CheckerboardKernelClosedForms.pathSum_right_left_closed_form
    (cornerWeight eps m) p q hq

/-! ## The exact path sum satisfies the discrete Dirac recursion -/

/-- **Discrete Dirac recursion.**  The exact Gaussian-rational path sum satisfies
the landed one-step (last-step / detector-side) recursion: an amplitude arriving
at `(finishX, finishDir)` in `n + 1` steps is the straight continuation from the
previous site plus the corner reversal weighted by `mu = i · (eps · m)` on the
right.  Specialization of
`PhysicsSM.Draft.CheckerboardSpinorRecursion.pathSum_last_step`. -/
theorem exact_path_sum_dirac_recursion (eps m : ℚ) (startX : Int)
    (startDir : Direction) (n : Nat) (finishX : Int) (finishDir : Direction) :
    pathSum (cornerWeight eps m) startX startDir (n + 1) finishX finishDir
      =
        pathSum (cornerWeight eps m) startX startDir n
          (finishX - finishDir.step) finishDir
        +
        pathSum (cornerWeight eps m) startX startDir n
          (finishX - finishDir.step) finishDir.flip
          * cornerWeight eps m :=
  PhysicsSM.Draft.CheckerboardSpinorRecursion.pathSum_last_step
    (cornerWeight eps m) startX startDir n finishX finishDir

/-! ## The turn-phase boundary at zero mass -/

/-- **Massless positive-corner vanishing.**  At `m = 0` every history with at
least one corner has zero amplitude: the corner weight is `0`, so any positive
power vanishes. -/
theorem massless_positive_corner_vanishes (eps : ℚ) (startDir : Direction)
    (h : List Direction) (hpos : 0 < turnCount startDir h) :
    pathAmplitude eps 0 startDir h = 0 := by
  rw [pathAmplitude, cornerWeight_massless]
  exact zero_pow (Nat.ne_of_gt hpos)

/-- **Massless only straight histories contribute.**  At `m = 0` the amplitude of
a history is `1` if it is straight (zero corners) and `0` otherwise: only the
cornerless null lines survive the massless limit. -/
theorem massless_only_straight (eps : ℚ) (startDir : Direction) (h : List Direction) :
    pathAmplitude eps 0 startDir h = if turnCount startDir h = 0 then 1 else 0 := by
  rw [pathAmplitude, cornerWeight_massless]
  rcases Nat.eq_zero_or_pos (turnCount startDir h) with hz | hp
  · rw [hz]; simp
  · rw [if_neg (Nat.ne_of_gt hp), zero_pow (Nat.ne_of_gt hp)]

/-! ## An explicit `n = 3` mass-dependent witness -/

/-- **Nondegenerate `n = 3` witness.**  The length-`3` history `[right, left,
right]` (incoming right) has two corners, a nonzero Gaussian-rational amplitude
at unit spacing and mass `1`, and a visibly different amplitude at mass `2`.
This certifies that the corner amplitude genuinely depends on the mass. -/
theorem t3_mass_dependent_witness :
    0 < turnCount Direction.right [Direction.right, Direction.left, Direction.right]
      ∧ pathAmplitude 1 1 Direction.right
            [Direction.right, Direction.left, Direction.right] ≠ 0
      ∧ pathAmplitude 1 1 Direction.right
            [Direction.right, Direction.left, Direction.right]
          ≠ pathAmplitude 1 2 Direction.right
            [Direction.right, Direction.left, Direction.right] := by
  have h1 : pathAmplitude 1 1 Direction.right
      [Direction.right, Direction.left, Direction.right] = -1 := by
    ext <;> simp +decide [pathAmplitude, cornerWeight, turnCount,
      GaussianRat.I, GaussianRat.ofRat, pow_two] <;> norm_num
  have h2 : pathAmplitude 1 2 Direction.right
      [Direction.right, Direction.left, Direction.right] =
        ({ re := -4, im := 0 } : GaussianRat) := by
    ext <;> simp +decide [pathAmplitude, cornerWeight, turnCount,
      GaussianRat.I, GaussianRat.ofRat, pow_two] <;> norm_num
  refine ⟨by decide, ?_, ?_⟩
  · rw [h1]
    intro h
    have hre := congrArg GaussianRat.re h
    norm_num at hre
  · rw [h1, h2]
    intro h
    have hre := congrArg GaussianRat.re h
    norm_num at hre

/-! ## Verdict -/

/-- **Turn-phase verdict.**  In the finite `1+1` checkerboard, the propagator is
exactly a sum over null histories and mass enters each history only through
corner amplitudes.  Concretely, for right-incoming/right-terminating endpoints
with `0 < q`:

* the exact Gaussian-rational path sum equals the closed binomial corner-count
  kernel (a genuine finite sum over null histories);
* the multiplicative history weight is exactly the corner amplitude
  `(i · eps · m) ^ turnCount` (mass enters only through corners);
* at `m = 0` every positive-corner history vanishes.

No continuum limit, no `3+1` propagator, and no measured mass is asserted. -/
theorem turn_phase_verdict (eps m : ℚ) (p q : Nat) (hq : 0 < q) :
    (pathSum (cornerWeight eps m) 0 Direction.right (p + q)
        ((p : Int) - (q : Int)) Direction.right
      =
        ∑ r ∈ Finset.Icc 1 (p + q),
          ((p.choose r * (q - 1).choose (r - 1) : Nat) : GaussianRat)
            * (cornerWeight eps m) ^ (2 * r))
    ∧ (∀ (startDir : Direction) (h : List Direction),
        pathWeight (cornerWeight eps m) startDir h = pathAmplitude eps m startDir h)
    ∧ (∀ (startDir : Direction) (h : List Direction),
        0 < turnCount startDir h → pathAmplitude eps 0 startDir h = 0) :=
  ⟨exact_path_sum_eq_closed_kernel eps m p q hq,
    fun startDir h => pathAmplitude_eq_corner_power eps m startDir h,
    fun startDir h hpos => massless_positive_corner_vanishes eps startDir h hpos⟩

/-! ## Kernel-footprint guard pins -/

/-- info: 'GaussianRat.I_sq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms GaussianRat.I_sq

/-- info: 'pathAmplitude_eq_corner_power' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms pathAmplitude_eq_corner_power

/-- info: 'exact_path_sum_eq_closed_kernel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exact_path_sum_eq_closed_kernel

/-- info: 'exact_path_sum_flip_closed_kernel' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exact_path_sum_flip_closed_kernel

/-- info: 'exact_path_sum_dirac_recursion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exact_path_sum_dirac_recursion

/-- info: 'massless_positive_corner_vanishes' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_positive_corner_vanishes

/-- info: 'massless_only_straight' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_only_straight

/-- info: 't3_mass_dependent_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms t3_mass_dependent_witness

/-- info: 'turn_phase_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms turn_phase_verdict
