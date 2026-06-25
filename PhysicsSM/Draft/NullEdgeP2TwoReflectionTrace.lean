import Mathlib

/-!
# Draft.NullEdgeP2TwoReflectionTrace

This module records the first non-parity scalar for products of two finite P2
branch reflections.

The determinant parity guardrail shows that determinant-only products carry
only reflection-count parity. The trace of a two-reflection product is the next
finite scalar: here it is proved by direct real `2 x 2` matrix algebra, without
eigenvalues, phases, arccosines, Lorentz groups, path sums, or continuum proper
time.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace

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

/--
Explicit trace formula for a product of two branch reflections. This is the
finite scalar that remains after determinant data collapses to parity.
-/
theorem trace2_mul_two_branchReflections_formula
    (h1 p1 m1 E1 h2 p2 m2 E2 : Real) :
    trace2 (branchReflection h2 p2 m2 E2 * branchReflection h1 p1 m1 E1) =
      2 * (h1 * h2 * p1 * p2 + m1 * m2) / (E1 * E2) := by
  simp [trace2, branchReflection, chiralHamiltonian, Matrix.mul_apply, Fin.sum_univ_two]
  ring

/-- The two-reflection trace scalar is symmetric under reversing the pair. -/
theorem trace2_mul_two_branchReflections_symm
    (h1 p1 m1 E1 h2 p2 m2 E2 : Real) :
    trace2 (branchReflection h2 p2 m2 E2 * branchReflection h1 p1 m1 E1) =
      trace2 (branchReflection h1 p1 m1 E1 * branchReflection h2 p2 m2 E2) := by
  rw [trace2_mul_two_branchReflections_formula]
  rw [trace2_mul_two_branchReflections_formula]
  ring

/-- On shell, the trace of a reflection composed with itself is `2`. -/
theorem trace2_branchReflection_sq_eq_two_on_massShell
    (h p m E : Real) (hh : h * h = 1) (hE0 : E ≠ 0)
    (hshell : E ^ 2 = p ^ 2 + m ^ 2) :
    trace2 (branchReflection h p m E * branchReflection h p m E) = 2 := by
  rw [trace2_mul_two_branchReflections_formula]
  field_simp
  nlinarith [hh, hshell]

/--
Three branch reflections have zero trace in the real two-generator P2 model.

This is the odd-length companion to the two-reflection trace formula. It says
that the next length after the two-reflection scalar does not by itself provide
a new trace observable. Any later four-reflection or causal-diamond trace claim
therefore needs explicit closure/geometric constraints rather than a generic
topological-invariance assumption.
-/
theorem trace2_mul_three_branchReflections_eq_zero
    (h1 p1 m1 E1 h2 p2 m2 E2 h3 p3 m3 E3 : Real) :
    trace2 (branchReflection h3 p3 m3 E3 *
        branchReflection h2 p2 m2 E2 *
        branchReflection h1 p1 m1 E1) = 0 := by
  simp only [branchReflection, chiralHamiltonian, smul_mul_assoc, mul_smul_comm,
    Matrix.mul_fin_two, trace2, Matrix.smul_apply, Matrix.of_apply, Matrix.cons_val',
    Matrix.cons_val_zero, Matrix.cons_val_one, Matrix.empty_val',
    Matrix.cons_val_fin_one, smul_eq_mul]
  ring

/--
Explicit trace formula for four branch reflections in the current
`h,p,m,E` convention.

This is the finite capstone of the local trace ladder before adding separate
closure or causal-diamond hypotheses. The cross terms record orientation in the
real two-generator plane; the theorem does not assert any topological
invariance.
-/
theorem trace2_mul_four_branchReflections_formula
    (h1 p1 m1 E1 h2 p2 m2 E2 h3 p3 m3 E3 h4 p4 m4 E4 : Real) :
    trace2 (branchReflection h4 p4 m4 E4 *
        branchReflection h3 p3 m3 E3 *
        branchReflection h2 p2 m2 E2 *
        branchReflection h1 p1 m1 E1) =
      2 * ((((h1 * p1) * (h2 * p2) + m1 * m2) *
            ((h3 * p3) * (h4 * p4) + m3 * m4)) -
          ((m1 * (h2 * p2) - (h1 * p1) * m2) *
            (m3 * (h4 * p4) - (h3 * p3) * m4))) /
        (E1 * E2 * E3 * E4) := by
  unfold branchReflection trace2 chiralHamiltonian
  norm_num [Matrix.mul_apply]
  ring

end PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace

end
