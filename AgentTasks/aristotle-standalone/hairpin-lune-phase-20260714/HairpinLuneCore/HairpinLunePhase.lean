import Mathlib

/-!
# Hairpin lune phase: the checkerboard corner factor i as enclosed solid angle

Standalone Aristotle package (Mathlib-only imports). Spiral-layer wave 1,
job C, 2026-07-14.

## What this file states

Rational 2x2 witnesses for the claim that the 1+1 checkerboard's corner
factor i (quarter-turn weight per mass corner) is the fossil of a handed
spiral regularization of the hairpin. With P(n) = (1 + n.sigma)/2 for the
axis directions (all four matrices are rational, so the whole file lives
over Q):

1. `hairpin_annihilation`: P(z) P(-z) = 0 - the bare same-chirality hairpin
   has amplitude zero; it must be resolved through an intermediate direction.
2. `hairpin_pair_trace`: resolving the hairpin pair through ANTIPODAL
   meridians (direction path z -> x -> -z -> -x, closing a full great circle
   on the direction sphere, enclosed solid angle 2*pi) gives the four-corner
   Bargmann invariant -1/4: negative, i.e. phase pi = half the enclosed
   solid angle. This matches i^2 = -1 for two checkerboard corners.
3. `backtrack_pair_trace`: the control - resolving through the SAME meridian
   (z -> x -> -z -> x, zero enclosed lune) gives +1/4. The entire sign is
   the enclosed geometry.
4. `hairpin_magnitude`: the magnitude 1/4 factorizes as the product of the
   two free-bend factors tr(P(z)P(x)) * tr(P(-z)P(-x)) = (1/2)*(1/2); the
   -1 is pure geometric phase.

## Conventions

- P(z) = !![1,0;0,0], P(-z) = !![0,0;0,1], P(x) = !![1/2,1/2;1/2,1/2],
  P(-x) = !![1/2,-1/2;-1/2,1/2]: spin-coherent projectors for the unit
  directions +-z, +-x in the standard Pauli convention.
- Bargmann invariants are traces of ordered products; reversal symmetry makes
  these two four-cycles real, so Q suffices and the kernel can decide.

## Intended reading (spiral layer)

The 1+1 checkerboard weights each mass corner by i * eps * m, with the
quarter-turn phase i an INPUT convention (turn weight pi/2). This file's
witnesses show the finite geometric mechanism that produces that phase: a
hairpin pair resolved with consistent handedness closes a great circle on
the direction sphere and picks up exactly the sign -1 = i^2 predicted by the
solid-angle rule (phase = minus half the enclosed solid angle for spin 1/2),
while the zero-area backtrack picks up +1. The general law
phase = exp(-i * Omega / 2) for arbitrary corner polygons is deliberately
NOT stated here; it stays a pre-registered C-grade conjecture in the program
docs. The sign choice +i vs -i per corner corresponds to the two handedness
choices of meridian resolution (matter/antimatter orientation in the
program's CPT reading).

These are M-grade finite identities once proved; the checkerboard-limit
reading is interpretation.

## Provenance

Clean-room from standard Pauli algebra and the spin-1/2 geometric-phase rule
(Bargmann invariant phase = minus half the enclosed solid angle). Companion
modules in the parent repo: the exact 1+1 checkerboard corner sum (corner
factor i * eps * m), `PhysicsSM.Draft.NullEdge.TetrahedralSpinProjectorPath`
(three-cycle witness), and the CPT zigzag module (handedness reversal =
conjugation). The general three-cycle identity is the target of the
companion job B (SpinCornerCore.SpinCornerBargmann); this file is
deliberately witness-level and rational.

## Proof guidance

Everything is concrete 2x2 rational arithmetic: `ext i j` plus `fin_cases`
plus `simp [Matrix.mul_apply, Fin.sum_univ_succ]` and `norm_num`, or
`decide`-style evaluation, or `Matrix.trace_fin_two` for the trace goals.

Do not weaken or modify any statement or definition; the placeholder proofs
are the only intended gaps.
-/

namespace HairpinLuneCore

open Matrix

/-- 2x2 rational matrices: all four axis projectors are rational. -/
abbrev CoinMat := Matrix (Fin 2) (Fin 2) ℚ

/-- Spin-coherent projector for +z. -/
def Pz : CoinMat := !![1, 0; 0, 0]

/-- Spin-coherent projector for -z. -/
def Pmz : CoinMat := !![0, 0; 0, 1]

/-- Spin-coherent projector for +x. -/
def Px : CoinMat := !![1/2, 1/2; 1/2, 1/2]

/-- Spin-coherent projector for -x. -/
def Pmx : CoinMat := !![1/2, -(1/2); -(1/2), 1/2]

/-- Sanity: P(z) is idempotent. -/
theorem Pz_idem : Pz * Pz = Pz := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Pz, Matrix.mul_apply, Fin.sum_univ_succ]

/-- Sanity: P(x) is idempotent. -/
theorem Px_idem : Px * Px = Px := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Px, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The bare same-chirality hairpin is forbidden: P(z) P(-z) = 0. -/
theorem hairpin_annihilation : Pz * Pmz = 0 := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    norm_num [Pz, Pmz, Matrix.mul_apply, Fin.sum_univ_succ]

/-- Free right-angle bend factor: tr(P(z) P(x)) = 1/2. -/
theorem bend_trace : (Pz * Px).trace = 1 / 2 := by
  norm_num [Pz, Px, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_succ]

/-- Free right-angle bend factor on the return leg:
tr(P(-z) P(-x)) = 1/2. -/
theorem bend_trace_return : (Pmz * Pmx).trace = 1 / 2 := by
  norm_num [Pmz, Pmx, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_succ]

/-- Hairpin pair resolved through ANTIPODAL meridians
(z -> x -> -z -> -x): the four-corner Bargmann invariant is -1/4. The
direction path closes a full great circle (enclosed solid angle 2*pi) and
the sign is the geometric phase, matching i^2 = -1 for two checkerboard
corners. -/
theorem hairpin_pair_trace : (Pz * Px * Pmz * Pmx).trace = -(1 / 4) := by
  norm_num [Pz, Px, Pmz, Pmx, Matrix.trace, Matrix.mul_apply,
    Fin.sum_univ_succ]

/-- Control: the SAME-meridian backtrack (z -> x -> -z -> x) encloses no
lune and gives +1/4. The entire hairpin-pair sign is enclosed geometry. -/
theorem backtrack_pair_trace : (Pz * Px * Pmz * Px).trace = 1 / 4 := by
  norm_num [Pz, Px, Pmz, Matrix.trace, Matrix.mul_apply, Fin.sum_univ_succ]

/-- The magnitude factorizes into the two free-bend factors; the -1 is pure
phase: |tr(P(z)P(x)P(-z)P(-x))| = tr(P(z)P(x)) * tr(P(-z)P(-x)). -/
theorem hairpin_magnitude :
    |(Pz * Px * Pmz * Pmx).trace| = (Pz * Px).trace * (Pmz * Pmx).trace := by
  rw [hairpin_pair_trace, bend_trace, bend_trace_return]
  norm_num

end HairpinLuneCore
