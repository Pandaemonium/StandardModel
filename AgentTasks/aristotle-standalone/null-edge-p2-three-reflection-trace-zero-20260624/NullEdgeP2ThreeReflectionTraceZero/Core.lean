import Mathlib

/-!
# NullEdgeP2ThreeReflectionTraceZero

Focused Aristotle package for the finite P2 branch-reflection trace ladder.

The live draft module `PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace` proves that
the trace of two real `2 x 2` branch reflections is the first non-parity scalar:

```text
trace(R2 R1) = 2 * (h1*h2*p1*p2 + m1*m2) / (E1*E2).
```

This focused package asks for the next odd-length guardrail: in the same real
two-generator branch-reflection model, a product of three branch reflections has
zero trace. The result is finite matrix algebra only; it makes no continuum,
twistor, phase, or causal-diamond topology claim.
-/

noncomputable section

namespace NullEdgeP2ThreeReflectionTraceZero

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

end NullEdgeP2ThreeReflectionTraceZero

end
