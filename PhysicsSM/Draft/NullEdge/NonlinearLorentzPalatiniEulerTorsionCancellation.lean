import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection

noncomputable section

/-!
# Nonlinear link-Euler first-jet cancellation

This module performs the finite twenty-four component cancellation that
identifies the actual nonlinear link-Euler derivative with the covariant
Palatini residual for a site-uniform connection jet.  Without that hypothesis
the fixed-spacing nonlinear coefficient retains differences of connection
jets at neighboring sites.  It is separated from the curve-derivative
construction so the two large kernel-checked calculations compile
independently.

Claim label: finite first-jet identity.  Originality tag: `[orig]`.
-/

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
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction

/-- Predecessor-minus-center coframe jet seen by the backward face difference
at one site. -/
def backwardCoframeVelocity {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site) (coframeVariation : CoframeField Site)
    (site : Site) : CoframeVelocity :=
  fun direction =>
    coframeVariation ((shift direction).symm site) - coframeVariation site

set_option maxHeartbeats 50000000 in
/-- **Nonlinear Euler first jet equals covariant Palatini residual.**  The
four nonlinear link-corner families cancel every first-order plaquette
holonomy term for a site-uniform connection jet, leaving minus twice the
Krein-raised covariant residual. -/
theorem linearizedLinkEulerCoefficient_eq_covariantPalatiniResidual
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site)
    (hLinkConstant : forall x, linkVariation x = linkVariation site)
    (direction : Fin 4) (component : Fin 6) :
    linearizedLinkEulerCoefficient shift linkVariation coframeVariation
        site direction component =
      -2 * transportApply lorentzBivectorFundamentalSymmetry.matrix
        (linearizedAffineCovariantPalatiniResidual
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (fun connectionDirection =>
            linkVariation site connectionDirection)
          (backwardCoframeVelocity shift coframeVariation site)
          direction) component := by
  have hLinkField : linkVariation = fun _ => linkVariation site := by
    funext x
    exact hLinkConstant x
  rw [hLinkField]
  unfold linearizedLinkEulerCoefficient
  rw [linearizedLinkEulerFunctional_eq_coordinates]
  unfold linearizedLinkEulerFunctionalCoordinates
  simp_rw [linearizedGeneratorFaceResponse_eq_pairs]
  simp_rw [coframeFaceWeight_identity_eq_coordinates]
  simp_rw [lorentzBivectorFundamentalSymmetry_matrix]
  fin_cases direction <;> fin_cases component <;>
    simp +decide [backwardCoframeVelocity,
      linearizedAffineCovariantPalatiniResidual,
      identityPalatiniFaceCoordinates, lorentzTriplePair,
      explicitPhysicalPalatiniTransportTangent,
      physicalPalatiniTransportTangent_eq_explicit,
      coframeFaceWeightFirstVariation, identityCoframeField,
      complementaryPalatiniFaceWeight,
      complementaryPalatiniFaceWeightFirstVariation,
      palatiniFaceWeight, palatiniFaceWeightFirstVariation,
      coframeWedge, coframeWedgeFirstVariation,
      spacetimeAlternatingSymbol, lorentzHodgeStar,
      additivePlaquetteCurl, splitSixMatrix, splitSixSign,
      kreinPair, transportApply, fiberPair,
      lorentzBivectorFundamentalSymmetry_matrix,
      LorentzBivectorKreinBridge.bivectorFirst,
      LorentzBivectorKreinBridge.bivectorSecond,
      Matrix.one_apply,
      Fin.sum_univ_four, Fin.sum_univ_six] <;>
    ring

/-- The actual nonlinear Euler coefficient has the covariant Palatini
residual as its derivative along simultaneous exact exponential-link and
coframe curves. -/
theorem hasDerivAt_nonlinearLinkEulerCoefficient_eq_covariantPalatiniResidual
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site)
    (hLinkConstant : forall x, linkVariation x = linkVariation site)
    (direction : Fin 4) (component : Fin 6) :
    HasDerivAt
      (fun t => nonlinearLinkEulerCoefficient shift
        (exponentialLinkCurve (identityConnection Site) linkVariation t)
        (coframeLine (identityCoframeField Site) coframeVariation t)
        site direction component)
      (-2 * transportApply lorentzBivectorFundamentalSymmetry.matrix
        (linearizedAffineCovariantPalatiniResidual
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (fun connectionDirection =>
            linkVariation site connectionDirection)
          (backwardCoframeVelocity shift coframeVariation site)
          direction) component) 0 := by
  exact (hasDerivAt_nonlinearLinkEulerCoefficient_identity shift
    linkVariation coframeVariation site direction component).congr_deriv
      (linearizedLinkEulerCoefficient_eq_covariantPalatiniResidual shift
        linkVariation coframeVariation site hLinkConstant direction component)

/-- The split-six fundamental symmetry has trivial kernel. -/
theorem transportApply_fundamentalSymmetry_eq_zero_iff
    (field : Fiber 6) :
    transportApply lorentzBivectorFundamentalSymmetry.matrix field = 0 <->
      field = 0 := by
  constructor
  · intro hField
    have hInvolutive := lorentzBivectorFundamentalSymmetry.involutive field
    rw [hField] at hInvolutive
    have hZero :
        transportApply lorentzBivectorFundamentalSymmetry.matrix 0 = 0 := by
      funext component
      simp [transportApply]
    rw [hZero] at hInvolutive
    exact hInvolutive.symm
  · intro hField
    rw [hField]
    funext component
    simp [transportApply]

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection
