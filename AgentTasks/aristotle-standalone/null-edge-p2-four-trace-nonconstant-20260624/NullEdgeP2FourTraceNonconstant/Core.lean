import Mathlib

/-!
# NullEdgeP2FourTraceNonconstant

Focused Aristotle package for a concrete nonconstancy witness for the P2
four-reflection trace.

The live trace ladder now has exact one-, two-, three-, and four-reflection
facts. This package records the smallest finite witness that the four-reflection
trace is not a topology-only constant in the unconstrained branch-reflection
API. The witness uses the two simplest on-shell reflections:

```text
A = branchReflection 1 1 0 1 = diag(-1, 1)
B = branchReflection 1 0 1 1 = swap
```

Then `trace(A A A A) = 2`, while `trace(B A B A) = -2`.
-/

noncomputable section

namespace NullEdgeP2FourTraceNonconstant

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

/-- The diagonal witness `A^4` has trace `2`. -/
theorem trace2_four_diagWitness_eq_two :
    trace2 (branchReflection 1 1 0 1 *
        branchReflection 1 1 0 1 *
        branchReflection 1 1 0 1 *
        branchReflection 1 1 0 1) = 2 := by
  simp only [trace2, branchReflection, chiralHamiltonian]
  norm_num [Matrix.mul_fin_two, Matrix.smul_apply, Matrix.cons_val_zero,
    Matrix.cons_val_one]

/-- The alternating witness `B A B A` has trace `-2`. -/
theorem trace2_four_alternatingWitness_eq_neg_two :
    trace2 (branchReflection 1 0 1 1 *
        branchReflection 1 1 0 1 *
        branchReflection 1 0 1 1 *
        branchReflection 1 1 0 1) = -2 := by
  simp only [trace2, branchReflection, chiralHamiltonian]
  norm_num [Matrix.mul_fin_two, Matrix.smul_apply, Matrix.cons_val_zero,
    Matrix.cons_val_one]

/--
The unconstrained four-reflection trace is not constant on the simplest
on-shell branch-reflection witnesses.
-/
theorem trace2_four_branchReflections_nonconstant :
    trace2 (branchReflection 1 1 0 1 *
        branchReflection 1 1 0 1 *
        branchReflection 1 1 0 1 *
        branchReflection 1 1 0 1) ≠
      trace2 (branchReflection 1 0 1 1 *
        branchReflection 1 1 0 1 *
        branchReflection 1 0 1 1 *
        branchReflection 1 1 0 1) := by
  rw [trace2_four_diagWitness_eq_two, trace2_four_alternatingWitness_eq_neg_two]
  norm_num

end NullEdgeP2FourTraceNonconstant

end
