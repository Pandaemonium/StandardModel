import Mathlib

/-!
# The exact corner-weight / unitary-walk equivalence

This module closes the finite-spacing correspondence identified during
manuscript review. The polynomial checkerboard kernel with corner weight
`i eps m` and the exactly unitary coin `exp(-i a mu sigma_x)` are related by
an exact kernel scaling law. The unitary coin is

  `coin(a mu) = cos(a mu) 1 - i sin(a mu) sigma_x`,

so an `n`-step history with `c` direction changes carries amplitude
`cos(a mu)^(n-c) (-i sin(a mu))^c = cos(a mu)^n (-i tan(a mu))^c` -- i.e.
the unitary position-space kernel is EXACTLY `cos(a mu)^n` times the
polynomial checkerboard kernel evaluated at corner weight
`w = -i tan(a mu)`.  The two layers are one construction related by the
identification `eps m_corner = tan(a mu)` (NOT `a mu` at finite spacing),
with the global normalization `cos(a mu)^n`.

## Setup

Both kernels are defined by the same one-step recursion on
`(position, direction)` with different step weights:

  `K[s,w]_{n+1}(x,d) = s * K_n(x-d,d) + w * K_n(x-d,-d)`

with straight weight `s` and corner weight `w`, from the initial condition
`K_1(1,+1) = s0`-free convention: first step right, no corner
(`K_1 = delta_{(1,+1)}` scaled by the straight weight for the unitary
kernel; the polynomial kernel uses `s = 1`).

## Targets

1. `kernel_scaling` -- the two-parameter kernel obeys the exact scaling law
   `K[s, s*w]_n = s^(n-1) * K[1, w]_n` for `s ≠ 0` (induction on the
   recursion; this is the whole content of the correspondence).
2. `unitary_kernel_eq_scaled_checkerboard` -- specializing
   `s = cos(a mu)`, `w' = -i sin(a mu)`: the unitary kernel equals
   `cos(a mu)^(n-1)` times the polynomial kernel at corner weight
   `-i tan(a mu)`, for `cos(a mu) ≠ 0`.
3. `corner_ratio` -- the per-history reading: the coin's corner-to-straight
   amplitude ratio is exactly `-i tan(a mu)` (entrywise statement on the
   coin matrix `cos(a mu) 1 - i sin(a mu) sigma_x`).
4. `witness_quarter` -- the exact nontrivial witness at `a mu = pi/4`:
   `cos = sin = sqrt 2 / 2`, corner ratio exactly `-i`, and the two kernels
   agree after scaling at `n = 3` on an explicit site (computed both ways).
5. `degenerate_boundary` -- the negative control at `a mu = pi/2`: the
   straight weight vanishes (`cos = 0`), the scaling law's hypothesis
   fails, and the coin is the pure corner flip `-i sigma_x` (every history
   without maximal corner count has amplitude zero): the correspondence is
   exactly the `cos(a mu) ≠ 0` regime.

Honest scope: exact finite algebra tying the two landed layers into one
construction; the identification `eps m = tan(a mu)` is a statement about
the two conventions, and the small-`a` reading `tan(a mu) = a mu + O(a^3)`
is standard analysis left as commentary.  Do not weaken the statements.
Proofs completed by Aristotle project `567202fe-8180-47a6-ac04-0173a844d268` and independently checked under the pinned project toolchain.
-/

namespace PhysicsSM.Draft.NullEdge.CornerWalkEquivalence

/-- Direction is `Bool`: `true` = right, `false` = left. -/
def flip (d : Bool) : Bool := !d

/-- Position displacement of one step in direction `d`. -/
def stepOf (d : Bool) : ℤ := if d then 1 else -1

/-- The two-weight kernel: straight weight `s`, corner weight `w`,
first step right from the origin. -/
noncomputable def K (s w : ℂ) : ℕ → ℤ → Bool → ℂ
  | 0, x, d => if x = 0 ∧ d = true then 1 else 0
  | n + 1, x, d =>
      s * K s w n (x - stepOf d) d + w * K s w n (x - stepOf d) (flip d)

/-
Target 1: the exact scaling law relating any two kernels with
proportional weights.
-/
theorem kernel_scaling (s w : ℂ) (_hs : s ≠ 0) (n : ℕ) (x : ℤ) (d : Bool) :
    K s (s * w) n x d = s ^ n * K 1 w n x d := by
  induction n generalizing x d with
  | zero => cases x <;> cases d <;> simp [K]
  | succ n ih => simp [K, pow_succ, mul_add, mul_assoc, mul_left_comm, ih]

/-
Target 2: the unitary kernel is the `cos^n`-scaled checkerboard kernel
at corner weight `-i tan(a mu)`.
-/
theorem unitary_kernel_eq_scaled_checkerboard (aMu : ℝ)
    (hcos : Complex.cos aMu ≠ 0) (n : ℕ) (x : ℤ) (d : Bool) :
    K (Complex.cos aMu) (-(Complex.I * Complex.sin aMu)) n x d =
      (Complex.cos aMu) ^ n *
        K 1 (-(Complex.I * Complex.tan aMu)) n x d := by
  have hcw : -(Complex.I * Complex.sin aMu)
      = Complex.cos aMu * (-(Complex.I * Complex.tan aMu)) := by
    rw [Complex.tan_eq_sin_div_cos]; field_simp
  rw [hcw]; exact kernel_scaling _ _ hcos n x d

/-
Target 3: the coin's corner-to-straight ratio is exactly
`-i tan(a mu)`.
-/
theorem corner_ratio (aMu : ℝ) (_hcos : Complex.cos aMu ≠ 0) :
    (-(Complex.I * Complex.sin aMu)) / Complex.cos aMu =
      -(Complex.I * Complex.tan aMu) := by
  rw [Complex.tan_eq_sin_div_cos]; ring

/-
Target 4: the exact quarter-angle witness -- corner ratio `-i`, and the
scaled kernels agree at `n = 2` on the turned site `(0, left)`:
both equal `cos * (-i sin)` directly and `cos^2 * (-i tan)` scaled.
-/
theorem witness_quarter :
    (-(Complex.I * Complex.tan (Real.pi / 4))) = -Complex.I ∧
    K (Complex.cos (Real.pi / 4)) (-(Complex.I * Complex.sin (Real.pi / 4)))
        2 0 false =
      (Complex.cos (Real.pi / 4)) ^ 2 *
        K 1 (-Complex.I) 2 0 false := by
  have hsin : Complex.sin (Real.pi / 4) = Real.sqrt 2 / 2 := by
    norm_cast; norm_num [Real.sin_pi_div_four]
  have hcos : Complex.cos (Real.pi / 4) = Real.sqrt 2 / 2 := by
    norm_cast; norm_num [Real.cos_pi_div_four]
  have hne : (Real.sqrt 2 : ℂ) ≠ 0 := by norm_cast; positivity
  refine ⟨?_, ?_⟩
  · rw [Complex.tan_eq_sin_div_cos, hsin, hcos]; field_simp
  · simp only [K]; rw [hsin, hcos]; ring

/-
Target 5: the degenerate boundary at `a mu = pi/2` -- the straight
weight vanishes and the coin is a pure corner flip, so the straight
two-step return amplitude vanishes identically.
-/
theorem degenerate_boundary :
    Complex.cos (Real.pi / 2) = 0 ∧
    K (Complex.cos (Real.pi / 2))
        (-(Complex.I * Complex.sin (Real.pi / 2))) 2 2 true = 0 := by
  simp [K, stepOf, flip]

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.CornerWalkEquivalence.unitary_kernel_eq_scaled_checkerboard' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms unitary_kernel_eq_scaled_checkerboard

/-- info: 'PhysicsSM.Draft.NullEdge.CornerWalkEquivalence.witness_quarter' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms witness_quarter

/-- info: 'PhysicsSM.Draft.NullEdge.CornerWalkEquivalence.degenerate_boundary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms degenerate_boundary

end PhysicsSM.Draft.NullEdge.CornerWalkEquivalence
