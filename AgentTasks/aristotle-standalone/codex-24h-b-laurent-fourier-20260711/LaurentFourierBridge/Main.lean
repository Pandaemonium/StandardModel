import LaurentFourierBridge.Seed.LaurentFlowIndex

/-!
# Fourier evaluation of the Laurent determinant flow

Focused Paper B target. The positive Fourier convention is fixed by
`T n -> exp(i n q)`. The result is a one-particle determinant phase law. It is
not the many-body GNVW index and it is not a no-doubling theorem.
-/

noncomputable section

namespace LaurentFourierBridge

open PhysicsSM.Draft.NullEdge.LaurentFlowIndex

/-- Positive Fourier convention: the Laurent generator evaluates to
`exp(i q)`. -/
def phaseUnit (q : Real) : Units Complex :=
  Units.mk0
    (Complex.exp (Complex.I * (q : Complex)))
    (Complex.exp_ne_zero _)

/-- Evaluation of finite Laurent symbols at positive Fourier angle `q`. -/
def fourierEval (q : Real) : LaurentPolynomial Complex →+* Complex :=
  LaurentPolynomial.eval₂ (RingHom.id Complex) (phaseUnit q)

/-- Entrywise Fourier evaluation of a finite Laurent matrix. -/
def fourierSymbol {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial Complex))
    (q : Real) : Matrix (Fin r) (Fin r) Complex :=
  (fourierEval q).mapMatrix M

/-- A one-variable strict translation-invariant one-particle walk: its Laurent
matrix has a finite Laurent inverse and every circle evaluation is unitary. -/
def IsStrictTIUnitaryWalk {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial Complex)) : Prop :=
  IsUnit M /
    forall q : Real,
      fourierSymbol M q ∈ Matrix.unitaryGroup (Fin r) Complex

/-- The algebraic determinant exponent becomes an exact Fourier phase winding,
with a unit-modulus constant. Do not weaken the finite-inverse or pointwise
unitarity hypotheses. -/
theorem strictTIUnitaryWalk_det_phase {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial Complex))
    (hW : IsStrictTIUnitaryWalk M) :
    exists c : Complex, norm c = 1 /
      forall q : Real,
        (fourierSymbol M q).det =
          c * Complex.exp
            ((flowExponent M hW.1 : Complex) *
              (Complex.I * (q : Complex))) := by
  sorry

/-- Nonzero flow witness: a scalar Laurent shift evaluates to its expected
Fourier phase. -/
theorem scalarShift_fourier_witness (n : Int) (q : Real) :
    (fourierSymbol
      (PhysicsSM.Draft.NullEdge.LaurentFlowIndex.scalarShift
        (K := Complex) n) q).det =
      Complex.exp ((n : Complex) * (Complex.I * (q : Complex))) := by
  sorry

end LaurentFourierBridge
