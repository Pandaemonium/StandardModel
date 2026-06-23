import Mathlib.Tactic
import Mathlib.Data.Matrix.Basic

/-!
# Finite Schmidt determinant core

This draft module records the finite two-qubit determinant identity used by the
observer-channel mass conjecture.

For a pure two-qubit state with real coefficient matrix

```text
M = [[a, b],
     [c, d]],
```

the visible reduced block `M M^T` and the chirality/internal reduced block
`M^T M` have equal determinants.  Both determinants are `(a*d - b*c)^2`.

Physics interpretation boundary: this is only the finite Schmidt determinant
algebra.  Reading the off-diagonal chirality entry as `m / E` requires an
additional balance/frame convention, tracked separately in the observer-channel
plan.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeSchmidtDeterminantCore

open Matrix

/-- Real coefficient matrix of a pure two-qubit state. -/
def coeff (a b c d : Real) : Matrix (Fin 2) (Fin 2) Real :=
  !![a, b; c, d]

/-- Visible reduced density `M M^T`, written in closed form. -/
def visibleReduced (a b c d : Real) : Matrix (Fin 2) (Fin 2) Real :=
  !![a ^ 2 + b ^ 2, a * c + b * d;
     a * c + b * d, c ^ 2 + d ^ 2]

/-- Chirality/internal reduced density `M^T M`, written in closed form. -/
def chiralityReduced (a b c d : Real) : Matrix (Fin 2) (Fin 2) Real :=
  !![a ^ 2 + c ^ 2, a * b + c * d;
     a * b + c * d, b ^ 2 + d ^ 2]

/-- Off-diagonal chirality coherence in the reduced chirality block. -/
def chiralityOffdiag (a b c d : Real) : Real :=
  a * b + c * d

/-- First chirality population in the reduced chirality block. -/
def chiralityPopulationLeft (a _b c _d : Real) : Real :=
  a ^ 2 + c ^ 2

/-- Second chirality population in the reduced chirality block. -/
def chiralityPopulationRight (_a b _c d : Real) : Real :=
  b ^ 2 + d ^ 2

/-- Visible and chirality reduced determinants are equal for a pure state. -/
theorem det_visibleReduced_eq_det_chiralityReduced
    (a b c d : Real) :
    (visibleReduced a b c d).det =
      (chiralityReduced a b c d).det := by
  unfold visibleReduced chiralityReduced
  simp [Matrix.det_fin_two]
  ring_nf

/-- The visible reduced determinant is the square of the coefficient determinant. -/
theorem det_visibleReduced_eq_sq_detCoeff
    (a b c d : Real) :
    (visibleReduced a b c d).det =
      (a * d - b * c) ^ 2 := by
  unfold visibleReduced
  simp [Matrix.det_fin_two]
  ring_nf

/-- The chirality reduced determinant is the same square. -/
theorem det_chiralityReduced_eq_sq_detCoeff
    (a b c d : Real) :
    (chiralityReduced a b c d).det =
      (a * d - b * c) ^ 2 := by
  unfold chiralityReduced
  simp [Matrix.det_fin_two]
  ring_nf

/-- Balanced chirality populations are exactly equality of the diagonal weights. -/
theorem balanced_populations_iff_left_eq_right
    (a b c d : Real) :
    chiralityPopulationLeft a b c d =
        chiralityPopulationRight a b c d <->
      a ^ 2 + c ^ 2 = b ^ 2 + d ^ 2 := by
  rfl

end PhysicsSM.Draft.NullEdgeSchmidtDeterminantCore

end
