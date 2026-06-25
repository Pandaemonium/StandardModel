import Mathlib

/-!
# NullEdgeP2FourReflectionTraceFormula

Focused Aristotle package for the finite P2 four-reflection trace formula.

The live draft module `PhysicsSM.Draft.NullEdgeP2TwoReflectionTrace` now proves:

```text
one reflection: trace zero
two reflections: first continuous non-parity scalar
three reflections: trace zero
```

This package asks for the next even-length scalar in the same real `2 x 2`
branch-reflection model. The theorem is deliberately stated in the existing
`h,p,m,E` API rather than introducing angle or causal-diamond closure
definitions. It is finite matrix algebra only.
-/

noncomputable section

namespace NullEdgeP2FourReflectionTraceFormula

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

end NullEdgeP2FourReflectionTraceFormula

end
