import Mathlib

/-!
# Cap-square Berry factor: smooth closure costs phase, kinks cost magnitude

Standalone Aristotle package (Mathlib-only imports). Spiral-layer wave 7,
2026-07-16. This is target T1 of the C3 gate ("closure channel =
circulation cost") of the spiral-layer conjecture ledger: the exact
finite statement that a closed circulating history pays its closure cost
in PHASE (the Berry/solid-angle factor) while genuine kinks pay in
MAGNITUDE (per-corner overlap factors).

## What this file states

For spin-coherent corner matrices P(v) = (1 + v.sigma)/2, consider the
one-parameter family of closed square loops on the latitude cap at
height t: directions (u,0,t), (0,u,t), (-u,0,t), (0,-u,t) with
u^2 + t^2 = 1.

1. `cap_square_invariant` - the closed four-corner Bargmann invariant is
   EXACTLY the fourth power of one corner amplitude:
   tr(P(u,0,t) P(0,u,t) P(-u,0,t) P(0,-u,t)) = z^4 where
   z = (1+t)/2 + i (1-t)/2. This is the telescoped coherent-state
   overlap: each of the four equal corners contributes the same complex
   factor z, so the loop weight splits exactly into magnitude^4 and
   4x(corner phase).
2. `cap_square_normSq` - the squared magnitude is exactly
   ((1+t^2)/2)^4: maximal (= 1) at the poles (degenerate loop),
   minimal (= 1/16) at the equator, where the four corners are right
   angles - the (1/2)^4 four-corner constant of the C3-T2 transfer
   design appears as the equatorial value of this exact family.
3. `equator_square_invariant` - at the equator (u = 1, t = 0) the
   invariant is exactly -1/4. The MINUS SIGN is the Berry phase of the
   enclosed hemisphere as a kernel fact: the equatorial square encloses
   solid angle 2 pi, and exp(-i * 2 pi / 2) = -1. This matches the
   wave-1 opposite-meridian hairpin value -1/4
   (HairpinLunePhaseAristotle.hairpin_pair_trace), whose closed
   great-circle lune also encloses a hemisphere - two different loops,
   same enclosed solid angle, same kernel-checked value.
4. `pole_square_invariant` - at the pole (u = 0, t = 1) the four
   directions coincide, the loop encloses nothing, and the invariant is
   exactly 1 (degenerate control).
5. `kink_insertion_penalty` - rewalking one edge of the equatorial
   square (inserting the backtrack P0 P1 P0 P1 before completing the
   loop) multiplies the invariant by exactly the single right-angle
   corner factor 1/2:
   tr(P0 P1 P0 P1 P2 P3) = -1/8 = (1/2) * (-1/4).
   The phase is untouched (the factor is a positive real); the cost of
   the kink is pure magnitude. Together with statement 2 this is the
   finite form of "smooth closure costs only phase; kinks cost
   magnitude" - the structural discovery that shapes the C3 bridge to
   the landed YM1 area law.

## Conventions

Directions are raw `Fin 3 -> Real` triples; Pauli matrices standard;
same conventions as the wave-1..6 companions (SpinCornerBargmann,
HairpinLunePhase, BargmannCocycle, BargmannFanInduction,
BargmannJarlskogToy).

## Provenance

Clean-room from spin-coherent-state overlap algebra
(<v|w> telescoping; Bargmann invariants; Berry phase for spin-1/2,
standard literature reading only). The closed forms were verified
numerically in preflight (numpy, residuals < 1e-12) at
t in {0, 0.3, -0.6, 1} and for the kink insertion.

## Proof guidance

Everything is a 2x2 entrywise polynomial identity in u and t under the
single hypothesis u^2 + t^2 = 1. For `cap_square_invariant`: expand
both sides; the left side is a product of four explicit 2x2 matrices;
the right side is a fourth power of a scalar; after
`Matrix.trace_fin_two`, `Matrix.mul_apply`, `Fin.sum_univ_succ`, close
with `Complex.ext_iff`, `ring_nf`, and `linear_combination` calls using
u^2 = 1 - t^2 to eliminate even powers of u (odd powers of u cancel
identically between the antipodal pairs - if they do not cancel
syntactically, substitute u^2 first and keep u as an opaque symbol; no
square roots are needed anywhere). `cap_square_normSq` follows from
statement 1 via Complex.normSq_pow and normSq of the explicit z
(normSq z = ((1+t)/2)^2 + ((1-t)/2)^2 = (1+t^2)/2), or entrywise.
Statements 3-5 are rational instantiations (u = 1, t = 0 and u = 0,
t = 1): unfold and `norm_num [Complex.ext_iff]`; `simp +decide` on
rational matrix entries is acceptable in this draft-layer package.
For statement 5 the structured route uses the rank-one collapse
P0 P1 P0 = ((1 + v0.v1)/2) P0 = (1/2) P0 at right angles, then the
base value from statement 3; a direct six-matrix expansion also works.

Helper lemmas welcome; the five numbered statements must stay verbatim.
Do not weaken or modify any statement or definition; the placeholder
proofs are the only intended gaps.
-/

noncomputable section

namespace CapSquareBerry

open Matrix

/-- 2x2 complex matrices: the spin-coherent corner algebra. -/
abbrev SpinMat := Matrix (Fin 2) (Fin 2) ℂ

/-- Raw real direction triples. -/
abbrev Vec3 := Fin 3 → ℝ

/-- Standard Pauli sigma_x. -/
def sigmaX : SpinMat := !![0, 1; 1, 0]

/-- Standard Pauli sigma_y. -/
def sigmaY : SpinMat := !![0, -Complex.I; Complex.I, 0]

/-- Standard Pauli sigma_z. -/
def sigmaZ : SpinMat := !![1, 0; 0, -1]

/-- Pauli vector a.sigma. -/
def pauli (a : Vec3) : SpinMat :=
  ((a 0 : ℂ)) • sigmaX + ((a 1 : ℂ)) • sigmaY + ((a 2 : ℂ)) • sigmaZ

/-- Spin-coherent corner matrix (1 + a.sigma)/2. -/
def proj (a : Vec3) : SpinMat := (1 / 2 : ℂ) • (1 + pauli a)

/-- Cap-square direction at azimuth 0: (u, 0, t). -/
def capE (u t : ℝ) : Vec3 := ![u, 0, t]

/-- Cap-square direction at azimuth pi/2: (0, u, t). -/
def capN (u t : ℝ) : Vec3 := ![0, u, t]

/-- Cap-square direction at azimuth pi: (-u, 0, t). -/
def capW (u t : ℝ) : Vec3 := ![-u, 0, t]

/-- Cap-square direction at azimuth 3 pi/2: (0, -u, t). -/
def capS (u t : ℝ) : Vec3 := ![0, -u, t]

/-- The equal per-corner complex amplitude of the cap square. -/
def cornerAmp (t : ℝ) : ℂ :=
  (((1 + t) / 2 : ℝ) : ℂ) + Complex.I * (((1 - t) / 2 : ℝ) : ℂ)

/-- **1. Cap-square invariant.** The closed four-corner Bargmann
invariant of the latitude square is exactly the fourth power of the
single corner amplitude. -/
theorem cap_square_invariant (u t : ℝ) (h : u ^ 2 + t ^ 2 = 1) :
    (proj (capE u t) * proj (capN u t) * proj (capW u t)
        * proj (capS u t)).trace
      = cornerAmp t ^ 4 := by
  sorry

/-- **2. Cap-square magnitude.** The squared magnitude of the invariant
is exactly ((1 + t^2)/2)^4: one at the poles, the four-right-angle
constant 1/16 at the equator. -/
theorem cap_square_normSq (u t : ℝ) (h : u ^ 2 + t ^ 2 = 1) :
    Complex.normSq
        ((proj (capE u t) * proj (capN u t) * proj (capW u t)
          * proj (capS u t)).trace)
      = ((1 + t ^ 2) / 2) ^ 4 := by
  sorry

/-- **3. Equatorial hemisphere sign.** At the equator the invariant is
exactly -1/4: the minus sign is the Berry phase of the enclosed
hemisphere (solid angle 2 pi, phase 2 pi / 2 = pi) as a kernel fact. -/
theorem equator_square_invariant :
    (proj (capE 1 0) * proj (capN 1 0) * proj (capW 1 0)
        * proj (capS 1 0)).trace
      = -(1 / 4) := by
  sorry

/-- **4. Polar degenerate control.** At the pole the loop encloses
nothing and the invariant is exactly 1. -/
theorem pole_square_invariant :
    (proj (capE 0 1) * proj (capN 0 1) * proj (capW 0 1)
        * proj (capS 0 1)).trace
      = 1 := by
  sorry

/-- **5. Kink insertion penalty.** Rewalking one edge of the equatorial
square multiplies the invariant by exactly the single right-angle corner
factor 1/2, leaving the phase untouched: kinks cost magnitude, not
phase. -/
theorem kink_insertion_penalty :
    (proj (capE 1 0) * proj (capN 1 0) * proj (capE 1 0)
        * proj (capN 1 0) * proj (capW 1 0) * proj (capS 1 0)).trace
      = -(1 / 8) := by
  sorry

end CapSquareBerry

end
