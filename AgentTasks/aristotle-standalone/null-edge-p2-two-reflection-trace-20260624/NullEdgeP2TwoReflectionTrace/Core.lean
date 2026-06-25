import Mathlib

/-!
# P2 two-reflection trace invariant

This standalone target records the first non-parity scalar for a product of two
branch reflections.

Physics context: determinant of branch-reflection products collapses to parity.
The trace of a two-reflection product is the next finite scalar and can carry
relative two-reflection data without invoking eigenvalues, phases, arccosines,
Lorentz groups, or continuum proper time. This file proves only explicit real
`2 x 2` matrix identities.
-/

noncomputable section

namespace NullEdgeP2TwoReflectionTrace

open Matrix

abbrev RMat2 := Matrix (Fin 2) (Fin 2) Real

/-- Two-level chiral Hamiltonian for fixed helicity sign `h`. -/
def chiralHamiltonian (h p m : Real) : RMat2 :=
  !![-h * p, m; m, h * p]

/-- Branch reflection in scalar form. -/
def branchReflection (h p m E : Real) : RMat2 :=
  E⁻¹ • chiralHamiltonian h p m

/-- Explicit trace for a real `2 x 2` matrix. -/
def trace2 (M : RMat2) : Real :=
  M 0 0 + M 1 1

/-
Explicit trace formula for a product of two branch reflections. This is the
finite scalar that remains after determinant data collapses to parity.
-/
theorem trace2_mul_two_branchReflections_formula
    (h1 p1 m1 E1 h2 p2 m2 E2 : Real) :
    trace2 (branchReflection h2 p2 m2 E2 * branchReflection h1 p1 m1 E1) =
      2 * (h1 * h2 * p1 * p2 + m1 * m2) / (E1 * E2) := by
  simp [trace2, branchReflection, chiralHamiltonian, Matrix.mul_apply, Fin.sum_univ_two];
  ring

/-
The two-reflection trace scalar is symmetric under reversing the pair.
-/
theorem trace2_mul_two_branchReflections_symm
    (h1 p1 m1 E1 h2 p2 m2 E2 : Real) :
    trace2 (branchReflection h2 p2 m2 E2 * branchReflection h1 p1 m1 E1) =
      trace2 (branchReflection h1 p1 m1 E1 * branchReflection h2 p2 m2 E2) := by
  unfold branchReflection trace2; norm_num [ Matrix.mul_apply ] ; ring;

/-
On shell, the trace of a reflection composed with itself is `2`.
-/
theorem trace2_branchReflection_sq_eq_two_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    trace2 (branchReflection h p m E * branchReflection h p m E) = 2 := by
  convert trace2_mul_two_branchReflections_formula h p m E h p m E using 1;
  grind

end NullEdgeP2TwoReflectionTrace

end
