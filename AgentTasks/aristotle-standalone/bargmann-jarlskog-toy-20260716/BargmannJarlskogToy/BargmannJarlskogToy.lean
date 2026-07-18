import Mathlib

/-!
# Two-family Jarlskog toy: the CP-odd interference observable

Standalone Aristotle package (Mathlib-only imports). Spiral-layer wave 6,
2026-07-16. This is the second half of the C2 gate of the spiral-layer
conjecture ledger ("CP-odd = handedness"): a two-family toy with a
relative phase, CKM-shaped. The first half (all-orders planar
CP-inertness) landed as PlanarCornerRealityAristotle.

## What this file states

For spin-coherent corner matrices P(v) = (1 + v.sigma)/2 and two
three-corner families A = (a1, a2, a3), B = (b1, b2, b3), define the
interference observable

  jarlskogObs A B = Im( tr(P a1 P a2 P a3) * conj(tr(P b1 P b2 P b3)) ).

By the landed three-cycle identity each trace is
[(1 + sum of dots) + i * triple]/4, so the observable measures the
RELATIVE phase of the two families - the corner-calculus analog of a
CKM-shaped rephasing-invariant CP observable built from two flavor
paths.

1. `jarlskog_decomposition` - the exact polynomial law
   jarlskogObs A B
     = (triple a1 a2 a3 * (1 + dots B) - triple b1 b2 b3 * (1 + dots A))
       / 16.
   Every CP-odd interference of two three-corner families is a function
   of the two oriented volumes and the CP-even dot sums: exactly the C2
   claim shape at the two-family level. No unit hypotheses.
2. `jarlskog_antisymm` - swapping the two families flips the sign:
   jarlskogObs A B = -(jarlskogObs B A).
3. `jarlskog_cp_odd` - reversing the corner order of BOTH families
   (the CP action; orientation reversal = conjugation) flips the sign:
   jarlskogObs (rev A) (rev B) = -(jarlskogObs A B).
4. `jarlskog_rotation_invariant` - for R with R^T R = 1 and det R = 1,
   applying R to all six directions preserves the observable (the
   rephasing/frame-invariance analog: only relative geometry matters).
5. `jarlskog_both_planar` - if both triples vanish the observable
   vanishes (two planar families cannot interfere CP-oddly), and
   `jarlskog_equal_families` - a family does not interfere with itself.
6. `jarlskog_witness` - one spiraling family (the coordinate octant)
   against one PLANAR family still produces a nonzero CP-odd
   observable: with A = (ex, ey, ez), B = (ex, exy, ey) where
   exy = (3/5, 4/5, 0), the observable is exactly 3/20. A single
   planar family is NOT CP-protection; only both-planar is (statement
   5): the relative phase is what counts.

## Conventions

Directions are raw `Fin 3 -> Real` triples; Pauli matrices standard;
`dot` Euclidean; `triple a b c = a . (b x c)` right-handed. Same
conventions as the wave-1..5 companions (SpinCornerBargmann,
PlanarCornerReality, BargmannSolidAngle, BargmannCocycle,
BargmannFanInduction).

## Proof guidance

Everything is 2x2 entrywise-finite and polynomial; no unit hypotheses
exist anywhere except the rotation lemma's hypotheses on R. For
statements 1-3 and 5-6: unfold, `Matrix.trace_fin_two` +
`Matrix.mul_apply` + `Fin.sum_univ_succ`, then `Complex.ext_iff` and
`ring`/`norm_num`. Statement 3 can also be derived from statement 1
plus triple antisymmetry (reversal flips the triple, fixes the dots).
For statement 4: prove the two invariance lemmas
dot (R.mulVec v) (R.mulVec w) = dot v w (from R^T R = 1, expand
mulVec/dotProduct) and
triple (R.mulVec u) (R.mulVec v) (R.mulVec w) = triple u v w (identify
triple with `Matrix.det` of the 3x3 matrix having rows u, v, w via
`Matrix.det_fin_three`, then `Matrix.det_mul`/`det_transpose` with
det R = 1), then rewrite through statement 1. The witness is rational
arithmetic: A-trace = (1 + i)/4 (octant: zero dots, unit triple);
B-trace for the planar triangle (ex, (3/5,4/5,0), ey): dot sums
3/5 + 4/5 + 0 = 7/5, triple = 0 (all z-components vanish), so B-trace
= (1 + 7/5)/4 = 3/5, a positive real; observable
= Im((1+i)/4 * 3/5) = 3/20. This value and the decomposition law were
verified numerically in preflight (numpy, residuals < 1e-12, three
random-vector trials for the decomposition). Helper lemmas welcome; the
numbered statements must stay verbatim. Do not weaken or modify any
statement or definition; the placeholder proofs are the only intended
gaps.
-/

noncomputable section

namespace BargmannJarlskogToy

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

/-- Euclidean dot product. -/
def dot (a b : Vec3) : ℝ := a 0 * b 0 + a 1 * b 1 + a 2 * b 2

/-- Right-handed oriented scalar triple product a.(b x c). -/
def triple (a b c : Vec3) : ℝ :=
  a 0 * (b 1 * c 2 - b 2 * c 1) + a 1 * (b 2 * c 0 - b 0 * c 2)
    + a 2 * (b 0 * c 1 - b 1 * c 0)

/-- Three-corner family invariant: the ordered Bargmann trace. -/
def famTrace (a b c : Vec3) : ℂ := (proj a * proj b * proj c).trace

/-- The two-family CP-odd interference observable: the imaginary part of
the first family's invariant against the conjugate of the second's. -/
def jarlskogObs (a1 a2 a3 b1 b2 b3 : Vec3) : ℝ :=
  (famTrace a1 a2 a3 * star (famTrace b1 b2 b3)).im

/-- **1. Jarlskog decomposition.** The CP-odd interference of two
three-corner families is exactly the antisymmetric pairing of oriented
volumes against CP-even dot sums. Fully polynomial; no unit hypotheses. -/
theorem jarlskog_decomposition (a1 a2 a3 b1 b2 b3 : Vec3) :
    jarlskogObs a1 a2 a3 b1 b2 b3
      = (triple a1 a2 a3 * (1 + dot b1 b2 + dot b2 b3 + dot b3 b1)
          - triple b1 b2 b3 * (1 + dot a1 a2 + dot a2 a3 + dot a3 a1))
        / 16 := by
  sorry

/-- **2. Family swap is odd.** -/
theorem jarlskog_antisymm (a1 a2 a3 b1 b2 b3 : Vec3) :
    jarlskogObs a1 a2 a3 b1 b2 b3 = -(jarlskogObs b1 b2 b3 a1 a2 a3) := by
  sorry

/-- **3. CP is odd.** Reversing the corner order of both families flips
the sign of the interference observable. -/
theorem jarlskog_cp_odd (a1 a2 a3 b1 b2 b3 : Vec3) :
    jarlskogObs a3 a2 a1 b3 b2 b1 = -(jarlskogObs a1 a2 a3 b1 b2 b3) := by
  sorry

/-- **4. Common-frame invariance.** A simultaneous proper rotation of all
six directions preserves the observable: only the relative geometry of
the two families enters. -/
theorem jarlskog_rotation_invariant (R : Matrix (Fin 3) (Fin 3) ℝ)
    (hR : Rᵀ * R = 1) (hdet : R.det = 1)
    (a1 a2 a3 b1 b2 b3 : Vec3) :
    jarlskogObs (R.mulVec a1) (R.mulVec a2) (R.mulVec a3)
        (R.mulVec b1) (R.mulVec b2) (R.mulVec b3)
      = jarlskogObs a1 a2 a3 b1 b2 b3 := by
  sorry

/-- **5a. Both-planar protection.** Two planar families cannot interfere
CP-oddly. -/
theorem jarlskog_both_planar (a1 a2 a3 b1 b2 b3 : Vec3)
    (hA : triple a1 a2 a3 = 0) (hB : triple b1 b2 b3 = 0) :
    jarlskogObs a1 a2 a3 b1 b2 b3 = 0 := by
  sorry

/-- **5b. Self-interference vanishes.** A family against itself has zero
relative phase. -/
theorem jarlskog_equal_families (a1 a2 a3 : Vec3) :
    jarlskogObs a1 a2 a3 a1 a2 a3 = 0 := by
  sorry

/-- Unit x direction. -/
def ex : Vec3 := ![1, 0, 0]

/-- Unit y direction. -/
def ey : Vec3 := ![0, 1, 0]

/-- Unit z direction. -/
def ez : Vec3 := ![0, 0, 1]

/-- Pythagorean unit direction (3/5, 4/5, 0) in the xy-plane. -/
def exy : Vec3 := ![3 / 5, 4 / 5, 0]

/-- **6. One-planar witness.** The spiraling coordinate octant against a
PLANAR xy-family still interferes CP-oddly: the observable is exactly
3/20. One planar family is not CP-protection; only both-planar is. -/
theorem jarlskog_witness :
    jarlskogObs ex ey ez ex exy ey = 3 / 20 := by
  sorry

end BargmannJarlskogToy

end
