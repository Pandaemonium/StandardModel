import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniExponentialConnectionTorsionSelection
import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction

noncomputable section

/-!
# Torsion selection from the actual nonlinear link Euler coefficient

This module closes the first-jet gap between the concrete nonlinear Lorentz
plaquette action and the exact exponential covariant residual.  It first
proves that the repository's previously formal identity-background
`linearizedLinkEulerFunctional` is the ordinary derivative of the actual
nonlinear local link Euler functional along simultaneous exact exponential
link and affine coframe curves.

The resulting twenty-four component calculation then gives

`d Euler_link = -2 J (linearized covariant Palatini residual)`.

All first-order plaquette-holonomy terms in the four nonlinear link-corner
families cancel.  Only the incoming connection jet and the predecessor-minus-
center coframe jet remain.  Since the split-six fundamental symmetry `J` is
involutive and the identity coframe is invertible, vanishing of all actual
nonlinear link-Euler derivatives is equivalent to vanishing linearized
Cartan torsion at every site.

This is an exact finite identity and an identity-background first-jet
theorem.  It does not prove nonlinear finite-spacing Levi-Civita uniqueness,
extend the action comparison to an arbitrary background coframe or
nonidentity background connection, supply metric dual-cell weights, or prove
a graph continuum limit.

Provenance: clean-room differentiation of the repository's concrete
nonlinear plaquette action.  The target structure is the standard Palatini
implication `D(e wedge e) = 0 => T = 0`; Kur and Glasser,
*Discrete Gravity with Local Lorentz Invariance* (arXiv:2202.02486), remains
the nearest discrete action comparator.  Conventions are mostly-minus
signature, orientation `0123`, and ordered bivectors
`(12,13,23,01,02,03)`.  Claim label: finite first-jet identity.
Originality tag: `[orig]`.
-/

open scoped Matrix.Norms.Frobenius

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection

open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniExponentialConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction

abbrev Matrix4R := Matrix (Fin 4) (Fin 4) Real

/-! ## Derivative of one weighted nonlinear face response -/

/-- The Lorentz generator as a real linear map from the six ordered bivector
coordinates to four-vector matrices. -/
def lorentzGeneratorLinear : Fiber 6 →ₗ[Real] Matrix4R where
  toFun := lorentzGenerator
  map_add' := lorentzGenerator_add
  map_smul' := lorentzGenerator_smul

/-- The finite-dimensional Lorentz-generator map as a continuous linear map.
-/
def lorentzGeneratorContinuous : Fiber 6 →L[Real] Matrix4R :=
  lorentzGeneratorLinear.toContinuousLinearMap

/-- Differentiation commutes with the linear Lorentz-generator map. -/
theorem hasDerivAt_lorentzGenerator
    (curve : Real -> Fiber 6) (derivative : Fiber 6)
    (hCurve : HasDerivAt curve derivative 0) :
    HasDerivAt (fun t => lorentzGenerator (curve t))
      (lorentzGenerator derivative) 0 := by
  have h := (lorentzGeneratorContinuous.hasFDerivAt
    (x := curve 0)).comp_hasDerivAt (𝕜 := Real) 0 hCurve
  simpa [lorentzGeneratorContinuous, lorentzGeneratorLinear] using h

/-- The formal weighted identity-background response is the ordinary
derivative of the nonlinear weighted adjoint response. -/
theorem hasDerivAt_nonlinearWeightedAdjointFaceResponse_identity
    (faceCurve : Real -> Fiber 6) (face faceVariation : Fiber 6)
    (transportCurve holonomyCurve : Real -> GL4)
    (transportVariation holonomyVariation : Matrix4R)
    (probe : Fiber 6)
    (hFaceZero : faceCurve 0 = face)
    (hTransportZero : transportCurve 0 = 1)
    (hHolonomyZero : holonomyCurve 0 = 1)
    (hFace : HasDerivAt faceCurve faceVariation 0)
    (hTransport : HasDerivAt (fun t => unitMatrix (transportCurve t))
      transportVariation 0)
    (hHolonomy : HasDerivAt (fun t => unitMatrix (holonomyCurve t))
      holonomyVariation 0) :
    HasDerivAt
      (fun t => nonlinearWeightedAdjointFaceResponse
        (faceCurve t) (transportCurve t) probe (holonomyCurve t))
      (linearizedWeightedAdjointFaceResponse face faceVariation
        transportVariation probe holonomyVariation) 0 := by
  have hFaceGenerator := hasDerivAt_lorentzGenerator
    faceCurve faceVariation hFace
  have hProbe : HasDerivAt
      (fun _ : Real => lorentzGenerator probe) 0 0 :=
    hasDerivAt_const (x := (0 : Real)) (lorentzGenerator probe)
  have hInverse := hasDerivAt_unitMatrix_inv_curve transportCurve 1
    transportVariation hTransport hTransportZero
  have hAdjoint := (hTransport.mul hProbe).mul hInverse
  have hAdjointHolonomy := hAdjoint.mul hHolonomy
  have hProduct := hFaceGenerator.mul hAdjointHolonomy
  have hTrace := hasDerivAt_matrixTrace _ _ 0 hProduct
  have hResponse := hTrace.const_mul (-(1 / 2 : Real))
  simpa [nonlinearWeightedAdjointFaceResponse,
    linearizedWeightedAdjointFaceResponse,
    orderedPlaquetteActionFirstResponse, lorentzAdjoint,
    hFaceZero, hTransportZero, hHolonomyZero, unitMatrix] using hResponse

/-! ## Derivative of the four-family local nonlinear Euler functional -/

/-- The previously formal simultaneous link/coframe linearization at the
identity fields is the actual derivative of the nonlinear local Euler
functional along exact exponential links. -/
theorem hasDerivAt_nonlinearLinkEulerFunctional_identity
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (direction : Fin 4) (probe : Fiber 6) :
    HasDerivAt
      (fun t => nonlinearLinkEulerFunctional shift
        (exponentialLinkCurve (identityConnection Site) linkVariation t)
        (coframeLine (identityCoframeField Site) coframeVariation t)
        site direction probe)
      (linearizedLinkEulerFunctional shift linkVariation coframeVariation
        site direction probe) 0 := by
  let linkCurve := exponentialLinkCurve
    (identityConnection Site) linkVariation
  let coframeCurve := coframeLine
    (identityCoframeField Site) coframeVariation
  have hCurveZero : linkCurve 0 = identityConnection Site := by
    simp [linkCurve]
  have hCoframeZero :
      coframeCurve 0 = identityCoframeField Site := by
    funext x
    simp [coframeCurve, coframeLine]
  have hLinkZero (x : Site) (a : Fin 4) :
      linkCurve 0 x a = 1 := by
    rw [hCurveZero]
    rfl
  have hTwoStepZero (x : Site) (a b : Fin 4) :
      twoStepUnit shift (linkCurve 0) x a b = 1 := by
    rw [hCurveZero]
    simp [twoStepUnit, twoStepTransport, identityConnection]
  have hPlaquetteZero (x : Site) (a b : Fin 4) :
      plaquetteUnit shift (linkCurve 0) x a b = 1 := by
    rw [hCurveZero]
    simp [plaquetteUnit, plaquetteHolonomy, twoStepTransport,
      identityConnection]
  have hLink (x : Site) (a : Fin 4) :
      HasDerivAt (fun t => unitMatrix (linkCurve t x a))
        (linkMatrixVariation (identityConnection Site) linkVariation x a) 0 := by
    simpa [linkCurve] using hasDerivAt_exponentialLinkCurve
      (identityConnection Site) linkVariation x a
  have hTwoStep (x : Site) (a b : Fin 4) :
      HasDerivAt (fun t => unitMatrix
        (twoStepUnit shift (linkCurve t) x a b))
        (twoStepMatrixVariation shift (identityConnection Site)
          linkVariation x a b) 0 :=
    hasDerivAt_twoStepUnit_curve shift linkCurve (identityConnection Site)
      linkVariation hCurveZero hLink x a b
  have hPlaquette (x : Site) (a b : Fin 4) :
      HasDerivAt (fun t => unitMatrix
        (plaquetteUnit shift (linkCurve t) x a b))
        (plaquetteMatrixVariation shift (identityConnection Site)
          linkVariation x a b) 0 :=
    hasDerivAt_plaquetteUnit_curve shift linkCurve (identityConnection Site)
      linkVariation hCurveZero hLink x a b
  have hFace (x : Site) (a b : Fin 4) :
      HasDerivAt
        (fun t => coframeFaceWeight (coframeCurve t) x a b)
        (coframeFaceWeightFirstVariation
          (identityCoframeField Site) coframeVariation x a b) 0 := by
    simpa [coframeCurve, coframeLine, coframeFaceWeight,
      coframeFaceWeightFirstVariation] using
      hasDerivAt_complementaryPalatiniFaceWeight_line
        ((identityCoframeField Site) x) (coframeVariation x) a b
  have hFirst (b : Fin 4) :=
    hasDerivAt_nonlinearWeightedAdjointFaceResponse_identity
      (fun t => coframeFaceWeight (coframeCurve t) site direction b)
      (coframeFaceWeight (identityCoframeField Site) site direction b)
      (coframeFaceWeightFirstVariation
        (identityCoframeField Site) coframeVariation site direction b)
      (fun t => linkCurve t site direction)
      (fun t => plaquetteUnit shift (linkCurve t) site direction b)
      (linkMatrixVariation (identityConnection Site) linkVariation
        site direction)
      (plaquetteMatrixVariation shift (identityConnection Site) linkVariation
        site direction b) probe
      (by
        change coframeFaceWeight (coframeCurve 0) site direction b = _
        rw [hCoframeZero])
      (hLinkZero site direction)
      (hPlaquetteZero site direction b)
      (hFace site direction b) (hLink site direction)
      (hPlaquette site direction b)
  have hSecond (a : Fin 4) :=
    let predecessor := (shift a).symm site
    hasDerivAt_nonlinearWeightedAdjointFaceResponse_identity
      (fun t => coframeFaceWeight (coframeCurve t) predecessor a direction)
      (coframeFaceWeight (identityCoframeField Site) predecessor a direction)
      (coframeFaceWeightFirstVariation
        (identityCoframeField Site) coframeVariation predecessor a direction)
      (fun t => twoStepUnit shift (linkCurve t) predecessor a direction)
      (fun t => plaquetteUnit shift (linkCurve t) predecessor a direction)
      (twoStepMatrixVariation shift (identityConnection Site) linkVariation
        predecessor a direction)
      (plaquetteMatrixVariation shift (identityConnection Site) linkVariation
        predecessor a direction) probe
      (by
        change coframeFaceWeight (coframeCurve 0) predecessor a direction = _
        rw [hCoframeZero])
      (hTwoStepZero predecessor a direction)
      (hPlaquetteZero predecessor a direction)
      (hFace predecessor a direction) (hTwoStep predecessor a direction)
      (hPlaquette predecessor a direction)
  have hThird (a : Fin 4) :=
    let holonomyCurve := fun t =>
      plaquetteUnit shift (linkCurve t) site a direction
    have hTransport : HasDerivAt
        (fun t => unitMatrix
          (holonomyCurve t * linkCurve t site direction))
        (plaquetteMatrixVariation shift (identityConnection Site)
            linkVariation site a direction +
          linkMatrixVariation (identityConnection Site) linkVariation
            site direction) 0 := by
      have hMul := (hPlaquette site a direction).mul (hLink site direction)
      simpa [holonomyCurve, hPlaquetteZero, hLinkZero] using hMul
    hasDerivAt_nonlinearWeightedAdjointFaceResponse_identity
      (fun t => coframeFaceWeight (coframeCurve t) site a direction)
      (coframeFaceWeight (identityCoframeField Site) site a direction)
      (coframeFaceWeightFirstVariation
        (identityCoframeField Site) coframeVariation site a direction)
      (fun t => holonomyCurve t * linkCurve t site direction)
      holonomyCurve
      (plaquetteMatrixVariation shift (identityConnection Site) linkVariation
          site a direction +
        linkMatrixVariation (identityConnection Site) linkVariation
          site direction)
      (plaquetteMatrixVariation shift (identityConnection Site) linkVariation
        site a direction) probe
      (by
        change coframeFaceWeight (coframeCurve 0) site a direction = _
        rw [hCoframeZero])
      (by simp [holonomyCurve, hPlaquetteZero, hLinkZero])
      (by simp [holonomyCurve, hPlaquetteZero])
      (hFace site a direction)
      hTransport
      (hPlaquette site a direction)
  have hFourth (b : Fin 4) :=
    let predecessor := (shift b).symm site
    hasDerivAt_nonlinearWeightedAdjointFaceResponse_identity
      (fun t => coframeFaceWeight (coframeCurve t) predecessor direction b)
      (coframeFaceWeight (identityCoframeField Site) predecessor direction b)
      (coframeFaceWeightFirstVariation
        (identityCoframeField Site) coframeVariation predecessor direction b)
      (fun t => twoStepUnit shift (linkCurve t) predecessor direction b)
      (fun t => plaquetteUnit shift (linkCurve t) predecessor direction b)
      (twoStepMatrixVariation shift (identityConnection Site) linkVariation
        predecessor direction b)
      (plaquetteMatrixVariation shift (identityConnection Site) linkVariation
        predecessor direction b) probe
      (by
        change coframeFaceWeight (coframeCurve 0) predecessor direction b = _
        rw [hCoframeZero])
      (hTwoStepZero predecessor direction b)
      (hPlaquetteZero predecessor direction b)
      (hFace predecessor direction b) (hTwoStep predecessor direction b)
      (hPlaquette predecessor direction b)
  have hFirstSum := HasDerivAt.sum (u := Finset.univ) fun b _ => hFirst b
  have hSecondSum := HasDerivAt.sum (u := Finset.univ) fun a _ => hSecond a
  have hThirdSum := HasDerivAt.sum (u := Finset.univ) fun a _ => hThird a
  have hFourthSum := HasDerivAt.sum (u := Finset.univ) fun b _ => hFourth b
  have hTotal := ((hFirstSum.add hSecondSum).sub hThirdSum).sub hFourthSum
  simpa [linkCurve, coframeCurve, nonlinearLinkEulerFunctional,
    linearizedLinkEulerFunctional] using hTotal

/-- Every coordinate of the formal linearized link equation is therefore the
actual derivative of the corresponding nonlinear Euler coefficient. -/
theorem hasDerivAt_nonlinearLinkEulerCoefficient_identity
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) :
    HasDerivAt
      (fun t => nonlinearLinkEulerCoefficient shift
        (exponentialLinkCurve (identityConnection Site) linkVariation t)
        (coframeLine (identityCoframeField Site) coframeVariation t)
        site direction component)
      (linearizedLinkEulerCoefficient shift linkVariation coframeVariation
        site direction component) 0 := by
  exact hasDerivAt_nonlinearLinkEulerFunctional_identity shift linkVariation
    coframeVariation site direction (Pi.single component (1 : Real))

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.hasDerivAt_nonlinearLinkEulerCoefficient_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_nonlinearLinkEulerCoefficient_identity

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection
