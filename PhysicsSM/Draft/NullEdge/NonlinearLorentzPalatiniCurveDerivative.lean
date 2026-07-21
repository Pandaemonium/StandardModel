import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
import PhysicsSM.Draft.NullEdge.ProperLorentzExponential
import Mathlib.Analysis.Normed.Algebra.MatrixExponential
import Mathlib.Analysis.SpecialFunctions.Exponential

noncomputable section

/-!
# Curve derivative of the nonlinear Lorentz plaquette action

This module realizes the previously formal product/inverse response as an
actual derivative.  A curve of invertible link matrices is based at a supplied
connection, and each underlying matrix curve has right-trivialized tangent

`d U / dt = U * hat(delta A)`

at `t = 0`.  Product and inverse differentiation then give exactly the
existing `plaquetteMatrixVariation`.  Differentiating the finite ordered sum
proves that the derivative of the displayed concrete coframe action is exactly
`nonlinearCoframePlaquetteFirstResponse`.

## Scope and provenance

The result is an exact finite curve-level identity.  The curve is valued in
`GL4`, so invertibility needed for differentiating the reverse path is present
without an extra analytic neighborhood assumption.  A canonical linkwise
matrix-exponential curve realizes every six-component variation.  When the
base connection is pointwise eta-Lorentz with determinant `+1`, the entire
curve remains in that proper Lorentz subgroup.  This does not yet prove the
separate orthochronous sign condition.  The theorem does not add metric
dual-cell volumes, prove Levi-Civita selection, or establish a continuum
limit.  Matrix calculus uses Mathlib's scoped Frobenius norm;
finite-dimensional norm choice does not alter the derivative or any algebraic
formula.  Claim label: finite identity.  Originality tag: `[comp]`.
-/

open scoped Matrix.Norms.Frobenius

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative

open ContinuousLinearMap Ring
open NormedSpace
open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.ProperLorentzExponential

/-- Matrix trace as a continuous linear map for the scoped Frobenius norm. -/
def matrixTraceContinuousLinearMap :
    Matrix (Fin 4) (Fin 4) Real →L[Real] Real :=
  LinearMap.toContinuousLinearMap
    (Matrix.traceLinearMap (Fin 4) Real Real)

/-- Differentiation commutes with the trace of a finite real matrix curve. -/
theorem hasDerivAt_matrixTrace
    (f : Real -> Matrix (Fin 4) (Fin 4) Real)
    (f' : Matrix (Fin 4) (Fin 4) Real) (t : Real)
    (hf : HasDerivAt f f' t) :
    HasDerivAt (fun s => Matrix.trace (f s)) (Matrix.trace f') t := by
  have ht : HasFDerivAt
      (fun matrix : Matrix (Fin 4) (Fin 4) Real => Matrix.trace matrix)
      matrixTraceContinuousLinearMap (f t) := by
    simpa [matrixTraceContinuousLinearMap] using
      (matrixTraceContinuousLinearMap.hasFDerivAt (x := f t))
  exact ht.comp_hasDerivAt (𝕜 := Real) (f := f) (f' := f') t hf

/-- The derivative of one ordered scalar face term is its formal response. -/
theorem hasDerivAt_orderedPlaquetteActionTerm
    (face : Fiber 6) (curve : Real -> GL4)
    (deltaHolonomy : Matrix (Fin 4) (Fin 4) Real)
    (hCurve : HasDerivAt (fun t => unitMatrix (curve t)) deltaHolonomy 0) :
    HasDerivAt (fun t => orderedPlaquetteActionTerm face (curve t))
      (orderedPlaquetteActionFirstResponse face deltaHolonomy) 0 := by
  have hProduct :=
    (hCurve.sub_const (1 : Matrix (Fin 4) (Fin 4) Real)).const_mul
      (lorentzGenerator face)
  have hTrace := hasDerivAt_matrixTrace
    (fun t => lorentzGenerator face * (unitMatrix (curve t) - 1))
    (lorentzGenerator face * deltaHolonomy) 0 hProduct
  simpa [orderedPlaquetteActionTerm, orderedPlaquetteActionFirstResponse] using
    hTrace.const_mul (-(1 / 2 : Real))

/-- The derivative of a two-link path is the existing product-rule tangent. -/
theorem hasDerivAt_twoStepUnit_curve
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (curve : Real -> LinkConnection Site GL4)
    (connection : LinkConnection Site GL4) (variation : LinkVariation Site)
    (hCurveZero : curve 0 = connection)
    (hCurve : forall site direction,
      HasDerivAt (fun t => unitMatrix (curve t site direction))
        (linkMatrixVariation connection variation site direction) 0)
    (site : Site) (a b : Fin 4) :
    HasDerivAt (fun t => unitMatrix (twoStepUnit shift (curve t) site a b))
      (twoStepMatrixVariation shift connection variation site a b) 0 := by
  have hMul := (hCurve site a).mul (hCurve (shift a site) b)
  simpa [twoStepUnit, twoStepTransport, twoStepMatrixVariation, unitMatrix,
    hCurveZero] using hMul

/-- The derivative of the inverse of an invertible matrix curve has the
standard noncommutative `-U^(-1) (dU) U^(-1)` form. -/
theorem hasDerivAt_unitMatrix_inv_curve
    (curve : Real -> GL4) (base : GL4)
    (delta : Matrix (Fin 4) (Fin 4) Real)
    (hCurve : HasDerivAt (fun t => unitMatrix (curve t)) delta 0)
    (hCurveZero : curve 0 = base) :
    HasDerivAt (fun t => unitMatrix (curve t)⁻¹)
      (-(unitMatrix base⁻¹ * delta * unitMatrix base⁻¹)) 0 := by
  have hInverseAt :=
    hasFDerivAt_ringInverse (𝕜 := Real) (curve 0)
  have hComp := hInverseAt.comp_hasDerivAt
    (𝕜 := Real) (f := fun t => unitMatrix (curve t)) (f' := delta) 0 hCurve
  have hDerivative :
      (-mulLeftRight Real (Matrix (Fin 4) (Fin 4) Real)
          (unitMatrix (curve 0)⁻¹) (unitMatrix (curve 0)⁻¹)) delta =
        -(unitMatrix base⁻¹ * delta * unitMatrix base⁻¹) := by
    simp [hCurveZero, ContinuousLinearMap.mulLeftRight_apply]
  apply (hComp.congr_deriv hDerivative).congr_of_eventuallyEq
  filter_upwards with t
  simp [unitMatrix]

/-- Linkwise right-trivialized derivatives produce exactly the existing
product/inverse plaquette variation. -/
theorem hasDerivAt_plaquetteUnit_curve
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (curve : Real -> LinkConnection Site GL4)
    (connection : LinkConnection Site GL4) (variation : LinkVariation Site)
    (hCurveZero : curve 0 = connection)
    (hCurve : forall site direction,
      HasDerivAt (fun t => unitMatrix (curve t site direction))
        (linkMatrixVariation connection variation site direction) 0)
    (site : Site) (a b : Fin 4) :
    HasDerivAt (fun t => unitMatrix (plaquetteUnit shift (curve t) site a b))
      (plaquetteMatrixVariation shift connection variation site a b) 0 := by
  have hAB := hasDerivAt_twoStepUnit_curve shift curve connection variation
    hCurveZero hCurve site a b
  have hBA := hasDerivAt_twoStepUnit_curve shift curve connection variation
    hCurveZero hCurve site b a
  have hPathBAZero :
      (fun t => twoStepUnit shift (curve t) site b a) 0 =
        twoStepUnit shift connection site b a := by
    simp [hCurveZero]
  have hInvBA := hasDerivAt_unitMatrix_inv_curve
    (fun t => twoStepUnit shift (curve t) site b a)
    (twoStepUnit shift connection site b a)
    (twoStepMatrixVariation shift connection variation site b a)
    hBA hPathBAZero
  have hMul := hAB.mul hInvBA
  simpa [plaquetteUnit, plaquetteHolonomy, plaquetteMatrixVariation,
    hCurveZero, unitMatrix, Matrix.mul_assoc, sub_eq_add_neg] using hMul

/-- The matrix exponential regarded as a concrete invertible `GL4` element. -/
def matrixExponentialUnit
    (matrix : Matrix (Fin 4) (Fin 4) Real) : GL4 :=
  (Matrix.isUnit_exp matrix).unit

/-- Forgetting the unit structure recovers the matrix exponential. -/
@[simp]
theorem unitMatrix_matrixExponentialUnit
    (matrix : Matrix (Fin 4) (Fin 4) Real) :
    unitMatrix (matrixExponentialUnit matrix) = NormedSpace.exp matrix := by
  exact (Matrix.isUnit_exp matrix).unit_spec

/-- The exponential unit at the zero matrix is the identity unit. -/
@[simp]
theorem matrixExponentialUnit_zero :
    matrixExponentialUnit (0 : Matrix (Fin 4) (Fin 4) Real) = 1 := by
  apply Units.ext
  change unitMatrix (matrixExponentialUnit 0) = unitMatrix (1 : GL4)
  rw [unitMatrix_matrixExponentialUnit, unitMatrix_one, NormedSpace.exp_zero]

/-- Exponentiating a six-component link variation gives a proper eta-Lorentz
matrix in the project's fixed mostly-minus convention. -/
theorem matrixExponentialUnit_isProperEtaLorentz
    (variation : Fiber 6) (t : Real) :
    IsEtaLorentz
        (unitMatrix (matrixExponentialUnit
          (t • lorentzGenerator variation))) /\
      IsProperLorentz
        (unitMatrix (matrixExponentialUnit
          (t • lorentzGenerator variation))) := by
  rw [unitMatrix_matrixExponentialUnit]
  exact exp_isProperEtaLorentz
    (lorentzGenerator variation) (lorentzGenerator_mem variation) t

/-- Canonical linkwise curve realizing an arbitrary six-component variation
by right multiplication with a matrix exponential. -/
def exponentialLinkCurve {Site : Type*}
    (connection : LinkConnection Site GL4) (variation : LinkVariation Site) :
    Real -> LinkConnection Site GL4 :=
  fun t site direction =>
    connection site direction *
      matrixExponentialUnit (t • lorentzGenerator (variation site direction))

/-- The exponential link curve starts at the supplied connection. -/
@[simp]
theorem exponentialLinkCurve_zero {Site : Type*}
    (connection : LinkConnection Site GL4) (variation : LinkVariation Site) :
    exponentialLinkCurve connection variation 0 = connection := by
  funext site direction
  apply Units.ext
  change unitMatrix (connection site direction) *
      unitMatrix (matrixExponentialUnit
        (0 • lorentzGenerator (variation site direction))) =
    unitMatrix (connection site direction)
  rw [unitMatrix_matrixExponentialUnit]
  simp

/-- A pointwise proper eta-Lorentz base connection remains pointwise proper
eta-Lorentz along every canonical exponential variation curve. -/
theorem exponentialLinkCurve_isProperEtaLorentz
    {Site : Type*} (connection : LinkConnection Site GL4)
    (variation : LinkVariation Site)
    (hConnection : forall site direction,
      IsEtaLorentz (unitMatrix (connection site direction)) /\
        IsProperLorentz (unitMatrix (connection site direction)))
    (t : Real) (site : Site) (direction : Fin 4) :
    IsEtaLorentz
        (unitMatrix
          (exponentialLinkCurve connection variation t site direction)) /\
      IsProperLorentz
        (unitMatrix
          (exponentialLinkCurve connection variation t site direction)) := by
  have hExponential := matrixExponentialUnit_isProperEtaLorentz
    (variation site direction) t
  constructor
  · simpa [exponentialLinkCurve, unitMatrix] using
      isEtaLorentz_mul _ _ (hConnection site direction).1 hExponential.1
  · simpa [exponentialLinkCurve, unitMatrix] using
      isProperLorentz_mul _ _ (hConnection site direction).2 hExponential.2

/-- The exponential link curve has exactly the prescribed right-trivialized
matrix tangent. -/
theorem hasDerivAt_exponentialLinkCurve {Site : Type*}
    (connection : LinkConnection Site GL4) (variation : LinkVariation Site)
    (site : Site) (direction : Fin 4) :
    HasDerivAt
      (fun t => unitMatrix
        (exponentialLinkCurve connection variation t site direction))
      (linkMatrixVariation connection variation site direction) 0 := by
  have hExp := hasDerivAt_exp_smul_const
    (lorentzGenerator (variation site direction)) (0 : Real)
  have hMul := hExp.const_mul (unitMatrix (connection site direction))
  simpa [exponentialLinkCurve, linkMatrixVariation, unitMatrix] using hMul

/-- The formal nonlinear response is the actual derivative of the displayed
concrete coframe plaquette action along every link curve with the prescribed
right-trivialized tangent. -/
theorem hasDerivAt_nonlinearCoframePlaquetteAction_curve
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (curve : Real -> LinkConnection Site GL4)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (variation : LinkVariation Site)
    (hCurveZero : curve 0 = connection)
    (hCurve : forall site direction,
      HasDerivAt (fun t => unitMatrix (curve t site direction))
        (linkMatrixVariation connection variation site direction) 0) :
    HasDerivAt
      (fun t => nonlinearCoframePlaquetteAction shift (curve t) coframe)
      (nonlinearCoframePlaquetteFirstResponse shift connection coframe variation)
      0 := by
  unfold nonlinearCoframePlaquetteAction nonlinearFacePlaquetteAction
    nonlinearCoframePlaquetteFirstResponse
  have hSite (a b : Fin 4) : HasDerivAt
      (fun t => Finset.sum Finset.univ (fun site =>
        orderedPlaquetteActionTerm (coframeFaceWeight coframe site a b)
          (plaquetteUnit shift (curve t) site a b)))
      (Finset.sum Finset.univ (fun site =>
        orderedPlaquetteActionFirstResponse
          (coframeFaceWeight coframe site a b)
          (plaquetteMatrixVariation shift connection variation site a b)))
      0 := by
    have hSum := HasDerivAt.sum (u := Finset.univ) fun site _ =>
        hasDerivAt_orderedPlaquetteActionTerm
          (coframeFaceWeight coframe site a b)
          (fun t => plaquetteUnit shift (curve t) site a b)
          (plaquetteMatrixVariation shift connection variation site a b)
          (hasDerivAt_plaquetteUnit_curve shift curve connection variation
            hCurveZero hCurve site a b)
    apply hSum.congr_of_eventuallyEq
    filter_upwards with t
    simp
  have hDirection (a : Fin 4) : HasDerivAt
      (fun t => Finset.sum Finset.univ (fun b =>
        Finset.sum Finset.univ (fun site =>
          orderedPlaquetteActionTerm (coframeFaceWeight coframe site a b)
            (plaquetteUnit shift (curve t) site a b))))
      (Finset.sum Finset.univ (fun b =>
        Finset.sum Finset.univ (fun site =>
          orderedPlaquetteActionFirstResponse
            (coframeFaceWeight coframe site a b)
            (plaquetteMatrixVariation shift connection variation site a b))))
      0 := by
    have hSum := HasDerivAt.sum (u := Finset.univ) fun b _ => hSite a b
    apply hSum.congr_of_eventuallyEq
    filter_upwards with t
    simp
  have hSum := HasDerivAt.sum (u := Finset.univ) fun a _ => hDirection a
  apply hSum.congr_of_eventuallyEq
  filter_upwards with t
  simp

/-- Every six-component link variation is realized by a canonical exponential
curve whose action derivative is the exact nonlinear formal response. -/
theorem hasDerivAt_nonlinearCoframePlaquetteAction_exponentialLinkCurve
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (variation : LinkVariation Site) :
    HasDerivAt
      (fun t => nonlinearCoframePlaquetteAction shift
        (exponentialLinkCurve connection variation t) coframe)
      (nonlinearCoframePlaquetteFirstResponse shift connection coframe variation)
      0 := by
  exact hasDerivAt_nonlinearCoframePlaquetteAction_curve shift
    (exponentialLinkCurve connection variation) connection coframe variation
    (exponentialLinkCurve_zero connection variation)
    (hasDerivAt_exponentialLinkCurve connection variation)

/-- Formal connection stationarity is exactly ordinary derivative stationarity
along every canonical exponential link curve. -/
theorem nonlinearCoframePlaquetteConnectionStationary_iff_exponential_deriv
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    NonlinearCoframePlaquetteConnectionStationary shift connection coframe <->
      forall variation,
        deriv (fun t => nonlinearCoframePlaquetteAction shift
          (exponentialLinkCurve connection variation t) coframe) 0 = 0 := by
  constructor
  · intro hStationary variation
    rw [(hasDerivAt_nonlinearCoframePlaquetteAction_exponentialLinkCurve
      shift connection coframe variation).deriv]
    exact hStationary variation
  · intro hDerivative variation
    rw [<-
      (hasDerivAt_nonlinearCoframePlaquetteAction_exponentialLinkCurve
        shift connection coframe variation).deriv]
    exact hDerivative variation

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative.hasDerivAt_plaquetteUnit_curve' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_plaquetteUnit_curve

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative.exponentialLinkCurve_isProperEtaLorentz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exponentialLinkCurve_isProperEtaLorentz

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative.hasDerivAt_nonlinearCoframePlaquetteAction_curve' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_nonlinearCoframePlaquetteAction_curve

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative.hasDerivAt_nonlinearCoframePlaquetteAction_exponentialLinkCurve' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_nonlinearCoframePlaquetteAction_exponentialLinkCurve

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative.nonlinearCoframePlaquetteConnectionStationary_iff_exponential_deriv' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteConnectionStationary_iff_exponential_deriv

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
