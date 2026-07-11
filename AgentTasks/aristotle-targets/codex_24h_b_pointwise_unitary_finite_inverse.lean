import PhysicsSM.Draft.NullEdge.LaurentFourierWalkBridge

/-!
Paper B hardening target. This file is a non-imported proof handoff.

The target asks whether the finite-Laurent-inverse hypothesis in the landed
Fourier determinant phase law is derivable from exact pointwise unitarity. The
expected route is the scalar rigidity theorem: a finite Laurent polynomial of
constant modulus one on the unit circle is a unit, hence a monomial times a
unit-modulus constant. The matrix result then follows from the determinant.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.LaurentFourierFiniteInverse

open Matrix
open LaurentFlowIndex
open LaurentFourierWalkBridge

/-- Scalar hard core: exact unit-circle modulus one forces a finite Laurent
polynomial to be a Laurent unit. Do not weaken `forall q : Real`. -/
theorem constant_circle_norm_laurent_isUnit
    (f : LaurentPolynomial Complex)
    (h : forall q : Real, norm (fourierEval q f) = 1) :
    IsUnit f := by
  sorry

/-- Exact pointwise unitarity of a finite Laurent matrix already supplies a
finite Laurent inverse. If false, return a counterexample rather than changing
the statement. -/
theorem pointwiseUnitary_implies_isUnit {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial Complex))
    (hUnit : forall q : Real,
      fourierSymbol M q ∈ Matrix.unitaryGroup (Fin r) Complex) :
    IsUnit M := by
  sorry

/-- Positive control: every scalar shift satisfies the derived theorem. -/
theorem scalarShift_pointwiseUnitary (n : Int) :
    forall q : Real,
      fourierSymbol (scalarShift (K := Complex) n) q ∈
        Matrix.unitaryGroup (Fin 1) Complex := by
  sorry

/-- Negative control: the nonmonomial `1 + T` does not have constant modulus
one. This prevents the scalar theorem from being vacuous. -/
theorem one_add_T_not_constant_circle_norm :
    Not (forall q : Real,
      norm (fourierEval q
        ((1 : LaurentPolynomial Complex) + LaurentPolynomial.T 1)) = 1) := by
  sorry

end PhysicsSM.Draft.NullEdge.LaurentFourierFiniteInverse
