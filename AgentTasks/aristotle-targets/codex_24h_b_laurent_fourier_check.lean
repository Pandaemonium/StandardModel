import PhysicsSM.Draft.NullEdge.LaurentFlowIndex

noncomputable section

namespace LaurentFourierBridgeCheck

open PhysicsSM.Draft.NullEdge.LaurentFlowIndex

def phaseUnit (q : Real) : Units Complex :=
  Units.mk0
    (Complex.exp (Complex.I * (q : Complex)))
    (Complex.exp_ne_zero _)

def fourierEval (q : Real) : LaurentPolynomial Complex →+* Complex :=
  LaurentPolynomial.eval₂ (RingHom.id Complex) (phaseUnit q)

def fourierSymbol {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial Complex))
    (q : Real) : Matrix (Fin r) (Fin r) Complex :=
  (fourierEval q).mapMatrix M

def IsStrictTIUnitaryWalk {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial Complex)) : Prop :=
  IsUnit M ∧
    forall q : Real,
      fourierSymbol M q ∈ Matrix.unitaryGroup (Fin r) Complex

theorem strictTIUnitaryWalk_det_phase {r : Nat}
    (M : Matrix (Fin r) (Fin r) (LaurentPolynomial Complex))
    (hW : IsStrictTIUnitaryWalk M) :
    exists c : Complex, norm c = 1 ∧
      forall q : Real,
        (fourierSymbol M q).det =
          c * Complex.exp
            ((flowExponent M hW.1 : Complex) *
              (Complex.I * (q : Complex))) := by
  sorry

theorem scalarShift_fourier_witness (n : Int) (q : Real) :
    (fourierSymbol
      (PhysicsSM.Draft.NullEdge.LaurentFlowIndex.scalarShift
        (K := Complex) n) q).det =
      Complex.exp ((n : Complex) * (Complex.I * (q : Complex))) := by
  sorry

end LaurentFourierBridgeCheck
