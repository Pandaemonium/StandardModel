import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylSecondOrderObstruction
import PhysicsSM.Draft.NullEdge.SecondOrderCurveExpansion

noncomputable section

open scoped Matrix.Norms.Frobenius

/-!
# Taylor-admissible no-branch theorem for the two-site curved sector

The formal two-site calculation gives a negative-definite quadratic charge.
This module connects that charge to actual curves of invertible link matrices
and coframes.  The hypotheses are primitive second-order Taylor expansions of
each forward link, inverse link, and coframe matrix.  The plaquette expansion
and nonlinear coframe Euler expansion are then derived by continuous finite
algebra; the scalar Euler coefficient is not assumed.

For first link tangent `A` and second Lie-algebra correction `B`, the forward
and inverse link jets are normalized as

`U(t)    = 1 + t A + (t^2 / 2) (A^2 + B) + o(t^2)`,
`U(t)^-1 = 1 - t A + (t^2 / 2) (A^2 - B) + o(t^2)`.

The coframe has the analogous expansion

`e(t) = 1 + t h + (t^2 / 2) k + o(t^2)`.

Every curve satisfying these primitive expansions and all nonlinear coframe
Euler equations near the identity background has zero plus and cross tangent
amplitudes.  Thus the formal charge is promoted to a local no-branch theorem
for Taylor-admissible curves.  The successor module
`PeriodicVacuumWeylC2NoBranch` supplies the standard finite-dimensional Taylor
bridge and derives inverse-link expansions from exact invertibility.  No
continuum Taub-charge identification is claimed.

Claim label: finite analytic no-branch theorem under displayed Taylor
hypotheses.  Originality tag: `[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylAnalyticNoBranch

set_option maxHeartbeats 3000000

open Filter Topology
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzMatrixSecondJet
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylSecondOrderObstruction
open PhysicsSM.Draft.NullEdge.SecondOrderCurveExpansion

/-- Corrected forward-link jet with first Lie-algebra tangent and second
Lie-algebra correction. -/
def correctedForwardJet
    (first correction : Matrix (Fin 4) (Fin 4) Real) : MatrixSecondJet where
  linear := first
  quadratic := (1 / 2 : Real) • (first * first + correction)

/-- Corrected inverse-link jet.  The correction changes sign, while the
square of the first tangent does not. -/
def correctedInverseJet
    (first correction : Matrix (Fin 4) (Fin 4) Real) : MatrixSecondJet where
  linear := -first
  quadratic := (1 / 2 : Real) • (first * first - correction)

/-- Corrected second jet of the ordered plaquette. -/
def correctedPlaquetteSecondJet
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (first correction : LinkVariation Site) (site : Site) (a b : Fin 4) :
    MatrixSecondJet :=
  MatrixSecondJet.mul
    (MatrixSecondJet.mul
      (MatrixSecondJet.mul
        (correctedForwardJet
          (linkTangentGenerator first site a)
          (linkTangentGenerator correction site a))
        (correctedForwardJet
          (linkTangentGenerator first (shift a site) b)
          (linkTangentGenerator correction (shift a site) b)))
      (correctedInverseJet
        (linkTangentGenerator first (shift b site) a)
        (linkTangentGenerator correction (shift b site) a)))
    (correctedInverseJet
      (linkTangentGenerator first site b)
      (linkTangentGenerator correction site b))

/-- The corrected plaquette has the same linear coefficient as the ordinary
exponential plaquette jet. -/
theorem correctedPlaquetteSecondJet_linear
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (first correction : LinkVariation Site) (site : Site) (a b : Fin 4) :
    (correctedPlaquetteSecondJet shift first correction site a b).linear =
      (exponentialPlaquetteSecondJet shift first site a b).linear := by
  rfl

/-- Negation commutes with the Lorentz-generator map. -/
theorem lorentzGenerator_neg_local (field : Fiber 6) :
    lorentzGenerator (-field) = -lorentzGenerator field := by
  have h := lorentzGenerator_smul (-1 : Real) field
  simpa using h

/-- Subtraction commutes with the Lorentz-generator map. -/
theorem lorentzGenerator_sub_local (left right : Fiber 6) :
    lorentzGenerator (left - right) =
      lorentzGenerator left - lorentzGenerator right := by
  rw [sub_eq_add_neg, lorentzGenerator_add, lorentzGenerator_neg_local]
  rfl

/-- The linear plaquette jet is the actual identity-link plaquette
variation. -/
theorem correctedPlaquetteSecondJet_linear_eq_variation
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (first correction : LinkVariation Site) (site : Site) (a b : Fin 4) :
    (correctedPlaquetteSecondJet shift first correction site a b).linear =
      plaquetteMatrixVariation shift (identityConnection Site)
        first site a b := by
  rw [plaquetteMatrixVariation_identity]
  simp only [correctedPlaquetteSecondJet, correctedForwardJet,
    correctedInverseJet, MatrixSecondJet.mul]
  unfold linkTangentGenerator additivePlaquetteCurl
  have hCurl :
      lorentzGenerator (fun component =>
        first site a component + first ((shift a) site) b component -
          first site b component - first ((shift b) site) a component) =
        lorentzGenerator (first site a) +
          lorentzGenerator (first ((shift a) site) b) -
          lorentzGenerator (first site b) -
          lorentzGenerator (first ((shift b) site) a) := by
    change lorentzGenerator
        (first site a + first ((shift a) site) b - first site b -
          first ((shift b) site) a) = _
    rw [lorentzGenerator_sub_local, lorentzGenerator_sub_local,
      lorentzGenerator_add]
  rw [hCurl]
  abel

/-- The second correction enters the plaquette quadratic coefficient as one
half of the ordinary linearized plaquette variation. -/
theorem correctedPlaquetteSecondJet_quadratic
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (first correction : LinkVariation Site) (site : Site) (a b : Fin 4) :
    (correctedPlaquetteSecondJet shift first correction site a b).quadratic =
      (exponentialPlaquetteSecondJet shift first site a b).quadratic +
        (1 / 2 : Real) •
          plaquetteMatrixVariation shift (identityConnection Site)
            correction site a b := by
  rw [plaquetteMatrixVariation_identity]
  simp only [correctedPlaquetteSecondJet, correctedForwardJet,
    correctedInverseJet, exponentialPlaquetteSecondJet,
    MatrixSecondJet.mul, MatrixSecondJet.exponential,
    MatrixSecondJet.inverseExponential]
  unfold linkTangentGenerator additivePlaquetteCurl
  have hCorrectionCurl :
      lorentzGenerator (fun component =>
        correction site a component +
          correction ((shift a) site) b component -
          correction site b component -
          correction ((shift b) site) a component) =
        lorentzGenerator (correction site a) +
          lorentzGenerator (correction ((shift a) site) b) -
          lorentzGenerator (correction site b) -
          lorentzGenerator (correction ((shift b) site) a) := by
    change lorentzGenerator
        (correction site a + correction ((shift a) site) b -
          correction site b - correction ((shift b) site) a) = _
    rw [lorentzGenerator_sub_local, lorentzGenerator_sub_local,
      lorentzGenerator_add]
  rw [hCorrectionCurl]
  simp only [smul_add, smul_sub]
  module

/-- Primitive second-order Taylor data for an identity-based link curve.
Both the forward and inverse expansions are recorded so that plaquette
inversion is handled analytically rather than by a formal substitution. -/
structure IdentityLinkSecondExpansion
    {Site : Type*} (curve : Real -> LinkConnection Site GL4)
    (first correction : LinkVariation Site) where
  forward : forall site direction,
    QuadraticExpansionAtZero
      (fun t => unitMatrix (curve t site direction))
      1 (linkTangentGenerator first site direction)
      ((1 / 2 : Real) •
        (linkTangentGenerator first site direction *
            linkTangentGenerator first site direction +
          linkTangentGenerator correction site direction))
  inverse : forall site direction,
    QuadraticExpansionAtZero
      (fun t => unitMatrix (curve t site direction)⁻¹)
      1 (-linkTangentGenerator first site direction)
      ((1 / 2 : Real) •
        (linkTangentGenerator first site direction *
            linkTangentGenerator first site direction -
          linkTangentGenerator correction site direction))

/-- Primitive second-order Taylor data for an identity-based coframe curve. -/
structure IdentityCoframeSecondExpansion
    {Site : Type*} (curve : Real -> CoframeField Site)
    (first correction : CoframeField Site) where
  point : forall site,
    QuadraticExpansionAtZero (fun t => curve t site)
      1 (first site) ((1 / 2 : Real) • correction site)

/-- Four applications of the matrix product rule derive the corrected
plaquette expansion from the primitive forward/inverse link expansions. -/
def plaquetteExpansion
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    {curve : Real -> LinkConnection Site GL4}
    {first correction : LinkVariation Site}
    (h : IdentityLinkSecondExpansion curve first correction)
    (site : Site) (a b : Fin 4) :
    QuadraticExpansionAtZero
      (fun t => unitMatrix (plaquetteUnit shift (curve t) site a b))
      1
      (correctedPlaquetteSecondJet shift first correction site a b).linear
      (correctedPlaquetteSecondJet shift first correction site a b).quadratic := by
  have hAB := QuadraticExpansionAtZero.matrixMul
    (h.forward site a) (h.forward (shift a site) b)
  have hABA := QuadraticExpansionAtZero.matrixMul hAB
    (h.inverse (shift b site) a)
  have hPlaquette := QuadraticExpansionAtZero.matrixMul hABA
    (h.inverse site b)
  have hCurve :
      (fun t => unitMatrix (plaquetteUnit shift (curve t) site a b)) =
        (fun t => unitMatrix (curve t site a) *
          unitMatrix (curve t (shift a site) b) *
          unitMatrix (curve t (shift b site) a)⁻¹ *
          unitMatrix (curve t site b)⁻¹) := by
    funext t
    simp [plaquetteUnit, plaquetteHolonomy, twoStepTransport, unitMatrix,
      Matrix.mul_assoc]
  apply QuadraticExpansionAtZero.congr hPlaquette hCurve.symm
  · simp
  · simp [correctedPlaquetteSecondJet, correctedForwardJet,
      correctedInverseJet, MatrixSecondJet.mul]
  · simp only [correctedPlaquetteSecondJet, correctedForwardJet,
      correctedInverseJet, MatrixSecondJet.mul, one_mul, mul_one]
    module

/-- The polarized coframe wedge is symmetric in its two matrix arguments. -/
theorem coframeWedgeFirstVariation_swap_arguments
    (left right : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    coframeWedgeFirstVariation left right a b =
      coframeWedgeFirstVariation right left a b := by
  funext component
  simp [coframeWedgeFirstVariation]
  ring

/-- The Hodge-dualized first face variation inherits the argument symmetry. -/
theorem palatiniFaceWeightFirstVariation_swap_arguments
    (left right : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    palatiniFaceWeightFirstVariation left right a b =
      palatiniFaceWeightFirstVariation right left a b := by
  unfold palatiniFaceWeightFirstVariation
  rw [coframeWedgeFirstVariation_swap_arguments]

/-- The complementary face variation is symmetric in coframe and probe. -/
theorem complementaryPalatiniFaceWeightFirstVariation_swap_arguments
    (left right : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    complementaryPalatiniFaceWeightFirstVariation left right a b =
      complementaryPalatiniFaceWeightFirstVariation right left a b := by
  funext component
  unfold complementaryPalatiniFaceWeightFirstVariation
  simp_rw [palatiniFaceWeightFirstVariation_swap_arguments left right]

/-- The coframe-to-face-generator operation for a fixed Euler probe is a
real linear map. -/
def faceGeneratorLinearMap
    (probe : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    Matrix (Fin 4) (Fin 4) Real →ₗ[Real]
      Matrix (Fin 4) (Fin 4) Real where
  toFun := fun coframe =>
    lorentzGenerator
      (complementaryPalatiniFaceWeightFirstVariation coframe probe a b)
  map_add' left right := by
    rw [complementaryPalatiniFaceWeightFirstVariation_swap_arguments,
      complementaryPalatiniFaceWeightFirstVariation_add,
      complementaryPalatiniFaceWeightFirstVariation_swap_arguments probe left,
      complementaryPalatiniFaceWeightFirstVariation_swap_arguments probe right,
      lorentzGenerator_add]
  map_smul' scalar coframe := by
    rw [complementaryPalatiniFaceWeightFirstVariation_swap_arguments,
      complementaryPalatiniFaceWeightFirstVariation_smul,
      complementaryPalatiniFaceWeightFirstVariation_swap_arguments probe coframe,
      lorentzGenerator_smul]
    simp

/-- Continuous form of `faceGeneratorLinearMap`; continuity is automatic in
this finite-dimensional matrix space. -/
def faceGeneratorContinuousLinearMap
    (probe : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    Matrix (Fin 4) (Fin 4) Real →L[Real]
      Matrix (Fin 4) (Fin 4) Real :=
  LinearMap.toContinuousLinearMap (faceGeneratorLinearMap probe a b)

/-- A primitive coframe expansion induces the corresponding face-generator
expansion. -/
def faceGeneratorExpansion
    {Site : Type*} {curve : Real -> CoframeField Site}
    {first correction : CoframeField Site}
    (h : IdentityCoframeSecondExpansion curve first correction)
    (site : Site) (probe : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    QuadraticExpansionAtZero
      (fun t => lorentzGenerator
        (complementaryPalatiniFaceWeightFirstVariation
          (curve t site) probe a b))
      (lorentzGenerator
        (complementaryPalatiniFaceWeightFirstVariation 1 probe a b))
      (lorentzGenerator
        (complementaryPalatiniFaceWeightFirstVariation
          (first site) probe a b))
      ((1 / 2 : Real) • lorentzGenerator
        (complementaryPalatiniFaceWeightFirstVariation
          (correction site) probe a b)) := by
  simpa [faceGeneratorContinuousLinearMap, faceGeneratorLinearMap,
    lorentzGenerator_smul,
    complementaryPalatiniFaceWeightFirstVariation_smul] using
    QuadraticExpansionAtZero.continuousLinearMap
      (E := Matrix (Fin 4) (Fin 4) Real)
      (F := Matrix (Fin 4) (Fin 4) Real)
      (faceGeneratorContinuousLinearMap probe a b) (h.point site)

/-- One nonlinear coframe Euler summand inherits the expected quadratic
coefficient from the primitive link and coframe expansions. -/
def orderedEulerTermExpansion
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    {linkCurve : Real -> LinkConnection Site GL4}
    {coframeCurve : Real -> CoframeField Site}
    {first correction : LinkVariation Site}
    {coframeFirst coframeCorrection : CoframeField Site}
    (hLink : IdentityLinkSecondExpansion linkCurve first correction)
    (hCoframe : IdentityCoframeSecondExpansion
      coframeCurve coframeFirst coframeCorrection)
    (site : Site) (probe : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    let plaquetteJet :=
      correctedPlaquetteSecondJet shift first correction site a b
    let faceBase := lorentzGenerator
      (complementaryPalatiniFaceWeightFirstVariation 1 probe a b)
    let faceLinear := lorentzGenerator
      (complementaryPalatiniFaceWeightFirstVariation
        (coframeFirst site) probe a b)
    QuadraticExpansionAtZero
      (fun t => orderedPlaquetteActionTerm
        (complementaryPalatiniFaceWeightFirstVariation
          (coframeCurve t site) probe a b)
        (plaquetteUnit shift (linkCurve t) site a b))
      0
      (-(1 / 2 : Real) * Matrix.trace (faceBase * plaquetteJet.linear))
      (-(1 / 2 : Real) * Matrix.trace
        (faceBase * plaquetteJet.quadratic +
          faceLinear * plaquetteJet.linear)) := by
  dsimp only
  have hFace := faceGeneratorExpansion hCoframe site probe a b
  have hPlaquette := plaquetteExpansion shift hLink site a b
  have hIncrementRaw := QuadraticExpansionAtZero.sub hPlaquette
    (QuadraticExpansionAtZero.constant
      (1 : Matrix (Fin 4) (Fin 4) Real))
  have hIncrement : QuadraticExpansionAtZero
      (fun t => unitMatrix (plaquetteUnit shift (linkCurve t) site a b) - 1)
      0
      (correctedPlaquetteSecondJet shift first correction site a b).linear
      (correctedPlaquetteSecondJet shift first correction site a b).quadratic := by
    apply QuadraticExpansionAtZero.congr hIncrementRaw rfl <;> simp
  have hProductRaw := QuadraticExpansionAtZero.matrixMul hFace hIncrement
  have hProduct : QuadraticExpansionAtZero
      (fun t => lorentzGenerator
          (complementaryPalatiniFaceWeightFirstVariation
            (coframeCurve t site) probe a b) *
        (unitMatrix (plaquetteUnit shift (linkCurve t) site a b) - 1))
      0
      (lorentzGenerator
          (complementaryPalatiniFaceWeightFirstVariation 1 probe a b) *
        (correctedPlaquetteSecondJet shift first correction site a b).linear)
      (lorentzGenerator
          (complementaryPalatiniFaceWeightFirstVariation 1 probe a b) *
          (correctedPlaquetteSecondJet shift first correction site a b).quadratic +
        lorentzGenerator
          (complementaryPalatiniFaceWeightFirstVariation
            (coframeFirst site) probe a b) *
          (correctedPlaquetteSecondJet shift first correction site a b).linear) := by
    apply QuadraticExpansionAtZero.congr hProductRaw rfl <;> simp
    abel
  have hTrace := QuadraticExpansionAtZero.continuousLinearMap
    (E := Matrix (Fin 4) (Fin 4) Real) (F := Real)
    matrixTraceContinuousLinearMap hProduct
  have hScaled := QuadraticExpansionAtZero.constSMul
    (-(1 / 2 : Real)) hTrace
  apply QuadraticExpansionAtZero.congr hScaled
  · rfl
  · simp
  · simp [smul_eq_mul, matrixTraceContinuousLinearMap]
  · simp [smul_eq_mul, matrixTraceContinuousLinearMap]

/-- Quadratic coefficient of one local nonlinear coframe Euler equation,
expressed through the corrected plaquette jet. -/
def coframeEulerSecondCoefficientFromJet
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (first correction : LinkVariation Site)
    (coframeFirst : CoframeField Site)
    (site : Site) (internal direction : Fin 4) : Real :=
  let probe := Matrix.single internal direction (1 : Real)
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      -(1 / 2 : Real) * Matrix.trace
        (lorentzGenerator
            (complementaryPalatiniFaceWeightFirstVariation 1 probe a b) *
            (correctedPlaquetteSecondJet shift first correction
              site a b).quadratic +
          lorentzGenerator
            (complementaryPalatiniFaceWeightFirstVariation
              (coframeFirst site) probe a b) *
            (correctedPlaquetteSecondJet shift first correction
              site a b).linear)))

/-- The corrected-jet coefficient is exactly the old quadratic term plus one
half of the ordinary Hessian response to the second link correction. -/
theorem coframeEulerSecondCoefficientFromJet_eq
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (first correction : LinkVariation Site)
    (coframeFirst : CoframeField Site)
    (site : Site) (internal direction : Fin 4) :
    coframeEulerSecondCoefficientFromJet shift first correction
        coframeFirst site internal direction =
      coframeEulerQuadraticCoefficient shift first coframeFirst
        site internal direction +
        (1 / 2 : Real) * linearizedCoframeEulerCoefficient
          shift correction site internal direction := by
  unfold coframeEulerSecondCoefficientFromJet
    coframeEulerQuadraticCoefficient linearizedCoframeEulerCoefficient
    linearizedCoframeEulerFunctional
  rw [Finset.mul_sum, ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro a _
  rw [Finset.mul_sum, ← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro b _
  rw [correctedPlaquetteSecondJet_linear,
    correctedPlaquetteSecondJet_quadratic]
  simp only [orderedPlaquetteActionFirstResponse, Matrix.mul_add,
    Matrix.trace_add, Matrix.mul_smul, Matrix.trace_smul, smul_eq_mul]
  ring

/-- One full nonlinear coframe Euler coefficient has the expansion derived
from the primitive curves. -/
def nonlinearCoframeEulerCoefficientExpansion
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    {linkCurve : Real -> LinkConnection Site GL4}
    {coframeCurve : Real -> CoframeField Site}
    {first correction : LinkVariation Site}
    {coframeFirst coframeCorrection : CoframeField Site}
    (hLink : IdentityLinkSecondExpansion linkCurve first correction)
    (hCoframe : IdentityCoframeSecondExpansion
      coframeCurve coframeFirst coframeCorrection)
    (site : Site) (internal direction : Fin 4) :
    QuadraticExpansionAtZero
      (fun t => nonlinearCoframeEulerCoefficient shift
        (linkCurve t) (coframeCurve t) site internal direction)
      0
      (linearizedCoframeEulerCoefficient shift first
        site internal direction)
      (coframeEulerSecondCoefficientFromJet shift first correction
        coframeFirst site internal direction) := by
  let probe := Matrix.single internal direction (1 : Real)
  have hInner (a : Fin 4) : QuadraticExpansionAtZero
      (fun t => Finset.sum Finset.univ (fun b =>
        orderedPlaquetteActionTerm
          (complementaryPalatiniFaceWeightFirstVariation
            (coframeCurve t site) probe a b)
          (plaquetteUnit shift (linkCurve t) site a b)))
      0
      (Finset.sum Finset.univ (fun b =>
        -(1 / 2 : Real) * Matrix.trace
          (lorentzGenerator
              (complementaryPalatiniFaceWeightFirstVariation 1 probe a b) *
            (correctedPlaquetteSecondJet shift first correction
              site a b).linear)))
      (Finset.sum Finset.univ (fun b =>
        -(1 / 2 : Real) * Matrix.trace
          (lorentzGenerator
              (complementaryPalatiniFaceWeightFirstVariation 1 probe a b) *
              (correctedPlaquetteSecondJet shift first correction
                site a b).quadratic +
            lorentzGenerator
              (complementaryPalatiniFaceWeightFirstVariation
                (coframeFirst site) probe a b) *
              (correctedPlaquetteSecondJet shift first correction
                site a b).linear))) := by
    simpa using
      (QuadraticExpansionAtZero.fintypeSum
        (fun b t => orderedPlaquetteActionTerm
          (complementaryPalatiniFaceWeightFirstVariation
            (coframeCurve t site) probe a b)
          (plaquetteUnit shift (linkCurve t) site a b))
        (fun _ => (0 : Real))
        (fun b =>
          -(1 / 2 : Real) * Matrix.trace
            (lorentzGenerator
                (complementaryPalatiniFaceWeightFirstVariation 1 probe a b) *
              (correctedPlaquetteSecondJet shift first correction
                site a b).linear))
        (fun b =>
          -(1 / 2 : Real) * Matrix.trace
            (lorentzGenerator
                (complementaryPalatiniFaceWeightFirstVariation 1 probe a b) *
                (correctedPlaquetteSecondJet shift first correction
                  site a b).quadratic +
              lorentzGenerator
                (complementaryPalatiniFaceWeightFirstVariation
                  (coframeFirst site) probe a b) *
                (correctedPlaquetteSecondJet shift first correction
                  site a b).linear))
        (fun b => orderedEulerTermExpansion shift hLink hCoframe
          site probe a b))
  have hOuter := QuadraticExpansionAtZero.fintypeSum
    (fun a t => Finset.sum Finset.univ (fun b =>
      orderedPlaquetteActionTerm
        (complementaryPalatiniFaceWeightFirstVariation
          (coframeCurve t site) probe a b)
        (plaquetteUnit shift (linkCurve t) site a b)))
    (fun _ => (0 : Real))
    (fun a => Finset.sum Finset.univ (fun b =>
      -(1 / 2 : Real) * Matrix.trace
        (lorentzGenerator
            (complementaryPalatiniFaceWeightFirstVariation 1 probe a b) *
          (correctedPlaquetteSecondJet shift first correction
            site a b).linear)))
    (fun a => Finset.sum Finset.univ (fun b =>
      -(1 / 2 : Real) * Matrix.trace
        (lorentzGenerator
            (complementaryPalatiniFaceWeightFirstVariation 1 probe a b) *
            (correctedPlaquetteSecondJet shift first correction
              site a b).quadratic +
          lorentzGenerator
            (complementaryPalatiniFaceWeightFirstVariation
              (coframeFirst site) probe a b) *
            (correctedPlaquetteSecondJet shift first correction
              site a b).linear)))
    hInner
  simpa [probe, nonlinearCoframeEulerCoefficient,
    nonlinearCoframeLocalEulerLinearMap,
    nonlinearCoframeLocalEulerFunctional,
    coframeEulerSecondCoefficientFromJet,
    linearizedCoframeEulerCoefficient,
    linearizedCoframeEulerFunctional,
    orderedPlaquetteActionFirstResponse,
    correctedPlaquetteSecondJet_linear_eq_variation] using hOuter

/-- Integrated time-time nonlinear coframe Euler residual along a two-site
curve. -/
def integratedTimeTimeEulerCurve
    (linkCurve : Real -> LinkConnection NullWaveSite GL4)
    (coframeCurve : Real -> CoframeField NullWaveSite) (t : Real) : Real :=
  nonlinearCoframeEulerCoefficient nullWaveShift
      (linkCurve t) (coframeCurve t) 0 0 0 +
    nonlinearCoframeEulerCoefficient nullWaveShift
      (linkCurve t) (coframeCurve t) 1 0 0

/-- The actual integrated nonlinear residual has the formal charge as its
quadratic Taylor coefficient. -/
def integratedTimeTimeEulerCurveExpansion
    (plusScale crossScale : Real)
    (linkCorrection : LinkVariation NullWaveSite)
    (coframeCorrection : CoframeField NullWaveSite)
    {linkCurve : Real -> LinkConnection NullWaveSite GL4}
    {coframeCurve : Real -> CoframeField NullWaveSite}
    (hLink : IdentityLinkSecondExpansion linkCurve
      (plusCrossLinkCombination plusScale crossScale) linkCorrection)
    (hCoframe : IdentityCoframeSecondExpansion coframeCurve
      (plusCrossCoframeCombination plusScale crossScale) coframeCorrection) :
    QuadraticExpansionAtZero
      (integratedTimeTimeEulerCurve linkCurve coframeCurve)
      0 0
      (integratedTimeTimeSecondOrderCharge
        plusScale crossScale linkCorrection) := by
  have hZero := nonlinearCoframeEulerCoefficientExpansion nullWaveShift
    hLink hCoframe 0 0 0
  have hOne := nonlinearCoframeEulerCoefficientExpansion nullWaveShift
    hLink hCoframe 1 0 0
  have hSum := QuadraticExpansionAtZero.add hZero hOne
  have hStationary := plusCrossCombination_coframeStationary
    plusScale crossScale
  convert hSum using 1
  all_goals
    simp [integratedTimeTimeSecondOrderCharge,
      integratedTimeTimeQuadraticCharge,
      coframeEulerSecondCoefficientFromJet_eq,
      hStationary 0 0 0, hStationary 1 0 0]
    <;> ring

/-- **Taylor-admissible local no-branch theorem.** Any identity-based
link/coframe curve with the displayed primitive second jets that satisfies
every nonlinear coframe Euler equation near the identity background has zero
plus and cross first-order curvature amplitudes. -/
theorem no_nonzero_plusCross_coframeStationary_branch
    (plusScale crossScale : Real)
    (linkCorrection : LinkVariation NullWaveSite)
    (coframeCorrection : CoframeField NullWaveSite)
    {linkCurve : Real -> LinkConnection NullWaveSite GL4}
    {coframeCurve : Real -> CoframeField NullWaveSite}
    (hLink : IdentityLinkSecondExpansion linkCurve
      (plusCrossLinkCombination plusScale crossScale) linkCorrection)
    (hCoframe : IdentityCoframeSecondExpansion coframeCurve
      (plusCrossCoframeCombination plusScale crossScale) coframeCorrection)
    (hStationary : Filter.Eventually (fun t => forall site internal direction,
      nonlinearCoframeEulerCoefficient nullWaveShift (linkCurve t)
        (coframeCurve t) site internal direction = 0) (nhds 0)) :
    plusScale = 0 /\ crossScale = 0 := by
  have hExpansion := integratedTimeTimeEulerCurveExpansion
    plusScale crossScale linkCorrection coframeCorrection hLink hCoframe
  have hIntegratedZero : Filter.Eventually (fun t =>
      integratedTimeTimeEulerCurve linkCurve coframeCurve t = 0) (nhds 0) := by
    filter_upwards [hStationary] with t ht
    rw [integratedTimeTimeEulerCurve,
      ht 0 0 0, ht 1 0 0]
    ring
  have hCharge :=
    QuadraticExpansionAtZero.quadratic_eq_zero_of_eventually_eq_zero
      hExpansion hIntegratedZero
  exact (integratedTimeTimeSecondOrderCharge_zero_iff
    plusScale crossScale linkCorrection).1 hCharge

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylAnalyticNoBranch.correctedPlaquetteSecondJet_quadratic' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms correctedPlaquetteSecondJet_quadratic

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylAnalyticNoBranch.coframeEulerSecondCoefficientFromJet_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms coframeEulerSecondCoefficientFromJet_eq

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylAnalyticNoBranch.no_nonzero_plusCross_coframeStationary_branch' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_nonzero_plusCross_coframeStationary_branch

end PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylAnalyticNoBranch
