import Mathlib

/-!
# Bargmann polygon triangulation

Focused Mathlib-only handoff for the exact algebra behind additive geometric
phase.  Rank-one spinor rays turn ordered projector traces into products of
adjacent overlaps.  A quadrilateral holonomy times its positive-real diagonal
pair invariant equals the product of the two triangular holonomies obtained
by triangulating along that diagonal.

No normalization or nonzero hypotheses are used except for the division
form of the triangulation identity.  The file does not formalize a global
branch of `arg` or a spherical solid-angle theorem.  Proof gaps are deliberate
Aristotle targets; definitions and multiplication order must remain fixed.
-/

noncomputable section

open Matrix Complex

namespace BargmannTriangulation

abbrev Spinor := Fin 2 -> Complex
abbrev M2 := Matrix (Fin 2) (Fin 2) Complex

/-- Standard Hermitian overlap, conjugate-linear in the first spinor. -/
def overlap (u v : Spinor) : Complex :=
  star (u 0) * v 0 + star (u 1) * v 1

/-- Unnormalized rank-one ray matrix `|u><u|`. -/
def ray (u : Spinor) : M2 := fun i j => u i * star (u j)

/-- Gauge-invariant two-ray overlap product. -/
def pairInvariant (u v : Spinor) : Complex :=
  overlap u v * overlap v u

/-- Ordered triangular Bargmann invariant. -/
def triangle (u v w : Spinor) : Complex :=
  overlap u v * overlap v w * overlap w u

/-- Ordered quadrilateral Bargmann invariant. -/
def quadrilateral (u v w x : Spinor) : Complex :=
  overlap u v * overlap v w * overlap w x * overlap x u

/-- Reversing an overlap conjugates it. -/
theorem overlap_reverse (u v : Spinor) :
    overlap v u = star (overlap u v) := by
  sorry

/-- The pair invariant is the real nonnegative overlap norm squared. -/
theorem pairInvariant_normSq (u v : Spinor) :
    pairInvariant u v = ((Complex.normSq (overlap u v) : Real) : Complex) := by
  sorry

/-- Pair invariant as a trace of two rank-one ray matrices. -/
theorem trace_ray_pair (u v : Spinor) :
    Matrix.trace (ray u * ray v) = pairInvariant u v := by
  sorry

/-- Triangle invariant as a trace of three rank-one ray matrices. -/
theorem trace_ray_triangle (u v w : Spinor) :
    Matrix.trace (ray u * ray v * ray w) = triangle u v w := by
  sorry

/-- Quadrilateral invariant as a trace of four rank-one ray matrices. -/
theorem trace_ray_quadrilateral (u v w x : Spinor) :
    Matrix.trace (ray u * ray v * ray w * ray x) = quadrilateral u v w x := by
  sorry

/-- Exact diagonal triangulation identity. -/
theorem quadrilateral_triangulation (u v w x : Spinor) :
    quadrilateral u v w x * pairInvariant u w =
      triangle u v w * triangle u w x := by
  sorry

/-- Division form when the chosen diagonal overlap is nonzero. -/
theorem quadrilateral_triangulation_div (u v w x : Spinor)
    (hdiag : pairInvariant u w ≠ 0) :
    quadrilateral u v w x =
      triangle u v w * triangle u w x / pairInvariant u w := by
  sorry

/-- Reversing the based quadrilateral conjugates its invariant. -/
theorem quadrilateral_reverse (u v w x : Spinor) :
    quadrilateral u x w v = star (quadrilateral u v w x) := by
  sorry

/-- The diagonal correction carries no imaginary phase and has nonnegative real part. -/
theorem pairInvariant_real_nonnegative (u v : Spinor) :
    (pairInvariant u v).im = 0 ∧ 0 ≤ (pairInvariant u v).re := by
  sorry

end BargmannTriangulation
