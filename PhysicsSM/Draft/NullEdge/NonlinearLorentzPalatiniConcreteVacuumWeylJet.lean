import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniConcreteAffineCurve
import PhysicsSM.Draft.NullEdge.VacuumWeylCurvatureTarget

noncomputable section

/-!
# A concrete nonflat vacuum-Weyl jet of the null-edge Palatini action

This module realizes the unit algebraic vacuum-Weyl target as the quadratic
plaquette coefficient of actual proper-Lorentz affine-exponential links on the
explicit `3^4` carrier.  The connection and coframe Euler maps vanish at their
respective first nontrivial orders, and the same finite jet gives the standard
mixed vacuum Einstein equation.

This is an exact finite perturbative theorem.  It does not assert that the jet
continues to a nearby nonlinear stationary branch.

Claim label: finite second-jet consistency theorem.  Originality tag:
`[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniConcreteVacuumWeylJet

open PhysicsSM.Draft.NullEdge.CausalLeviCivita
open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoordinateCurvatureBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteSecondJetCurvature
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniConcreteAffineCurve
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoordinateLeviCivita
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniPlaquetteEinsteinCurve
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylAnalyticNoBranch
open PhysicsSM.Draft.NullEdge.SecondOrderCurveExpansion
open PhysicsSM.Draft.NullEdge.VacuumWeylCurvatureTarget

/-- Half of the antisymmetric unit vacuum-Weyl curvature is a connection first
jet whose exterior derivative recovers the full target at zero connection. -/
def unitVacuumWeylConnectionFirstJet : LorentzConnectionFirstJet :=
  fun left right =>
    (1 / 2 : Real) • unitVacuumWeylTarget.curvature left right

/-- The actual proper-Lorentz link curve realizing the unit vacuum-Weyl jet. -/
def fourTorusUnitVacuumWeylLinkCurve :
    Real -> LinkConnection FourTorusSite GL4 :=
  fourTorusAffineExponentialLinkCurve
    (0 : LorentzConnectionVelocity) unitVacuumWeylConnectionFirstJet

/-- Primitive forward and inverse expansions of the concrete vacuum-Weyl link
curve. -/
def fourTorusUnitVacuumWeylLinkSecondExpansion :
    IdentityLinkSecondExpansion fourTorusUnitVacuumWeylLinkCurve
      (constantConnectionVariation (0 : LorentzConnectionVelocity))
      (localAffineConnectionCorrection fourTorusShift 0
        unitVacuumWeylConnectionFirstJet) := by
  simpa [fourTorusUnitVacuumWeylLinkCurve,
    fourTorusAffineExponentialLinkCurve] using
    affineExponentialLinkSecondExpansion
      (constantConnectionVariation (0 : LorentzConnectionVelocity))
      (localAffineConnectionCorrection fourTorusShift 0
        unitVacuumWeylConnectionFirstJet)

/-- The differential curvature coordinates of the half-curvature first jet
are exactly the unit vacuum-Weyl target. -/
theorem generatedLorentzCurvatureCoordinates_unitVacuumWeyl :
    generatedLorentzCurvatureCoordinates
        (0 : LorentzConnectionVelocity) unitVacuumWeylConnectionFirstJet =
      unitVacuumWeylTarget.curvature := by
  funext left right
  apply lorentzGenerator_injective
  rw [lorentzGenerator_generatedLorentzCurvatureCoordinates]
  have hSwap : unitVacuumWeylTarget.curvature right left =
      -unitVacuumWeylTarget.curvature left right := by
    funext component
    exact unitVacuumWeylTarget.face_antisymmetric left right component
  simp [lorentzCurvatureMatrix, generatedLorentzConnection,
    generatedLorentzConnectionFirstJet, unitVacuumWeylConnectionFirstJet,
    hSwap, lorentzGenerator_smul_local, lorentzGenerator_neg_local,
    lorentzGenerator_zero_local]
  module

/-- The curvature coordinates realized by the concrete jet are genuinely
nonzero. -/
theorem generatedLorentzCurvatureCoordinates_unitVacuumWeyl_ne_zero :
    generatedLorentzCurvatureCoordinates
        (0 : LorentzConnectionVelocity) unitVacuumWeylConnectionFirstJet ≠ 0 := by
  rw [generatedLorentzCurvatureCoordinates_unitVacuumWeyl]
  exact unitVacuumWeylTarget.nonzero

/-- Every link in the concrete vacuum-Weyl curve remains in the proper
eta-Lorentz component. -/
theorem fourTorusUnitVacuumWeylLinkCurve_isProperEtaLorentz
    (t : Real) (site : FourTorusSite) (direction : Fin 4) :
    IsEtaLorentz
        (unitMatrix (fourTorusUnitVacuumWeylLinkCurve t site direction)) /\
      IsProperLorentz
        (unitMatrix (fourTorusUnitVacuumWeylLinkCurve t site direction)) := by
  exact affineExponentialLinkCurve_isProperEtaLorentz
    (constantConnectionVariation (0 : LorentzConnectionVelocity))
    (localAffineConnectionCorrection fourTorusShift 0
      unitVacuumWeylConnectionFirstJet) t site direction

/-- Each ordered plaquette based at the origin has the corresponding nonflat
vacuum-Weyl generator as its exact quadratic coefficient. -/
def fourTorusUnitVacuumWeylPlaquetteExpansion
    (left right : Fin 4) :
    QuadraticExpansionAtZero
      (fun t => unitMatrix
        (plaquetteUnit fourTorusShift (fourTorusUnitVacuumWeylLinkCurve t)
          0 left right))
      1 0 (lorentzGenerator (unitVacuumWeylTarget.curvature left right)) := by
  apply QuadraticExpansionAtZero.congr
    (localAffinePlaquetteExpansion fourTorusShift
      fourTorusUnitVacuumWeylLinkSecondExpansion 0
      (0 : LorentzConnectionVelocity) unitVacuumWeylConnectionFirstJet
      (freeForwardStarLocalAffineEncoding fourTorusShift 0
        (0 : LorentzConnectionVelocity) unitVacuumWeylConnectionFirstJet
        fourTorusFreeForwardStar) left right)
    rfl rfl rfl
  calc
    lorentzCurvatureMatrix
        (generatedLorentzConnection (0 : LorentzConnectionVelocity))
        (generatedLorentzConnectionFirstJet unitVacuumWeylConnectionFirstJet)
        left right =
      lorentzGenerator
        (generatedLorentzCurvatureCoordinates
          (0 : LorentzConnectionVelocity) unitVacuumWeylConnectionFirstJet
          left right) :=
        (lorentzGenerator_generatedLorentzCurvatureCoordinates
          (0 : LorentzConnectionVelocity) unitVacuumWeylConnectionFirstJet
          left right).symm
    _ = lorentzGenerator (unitVacuumWeylTarget.curvature left right) := by
      rw [generatedLorentzCurvatureCoordinates_unitVacuumWeyl]

/-- The unit vacuum-Weyl curvature annihilates every coframe variation of the
identity-coframe Palatini density. -/
theorem palatiniDensityFirstVariation_unitVacuumWeyl_zero
    (variation : Matrix (Fin 4) (Fin 4) Real) :
    palatiniDensityFirstVariation 1 variation
        unitVacuumWeylTarget.curvature = 0 := by
  have hCoefficients : forall internal direction,
      mixedEinsteinCoframeCoefficient 1 unitVacuumWeylTarget.curvature
        internal direction = 0 :=
    (mixedEinsteinCoframeCoefficient_vanish_iff 1 1
      unitVacuumWeylTarget.curvature (by simp) (by simp)).2 (by
        intro coframeDirection raisedDirection
        rw [unitVacuumWeylTarget.ricci_zero,
          unitVacuumWeylTarget.scalar_zero]
        ring)
  rw [palatiniDensityFirstVariation_eq_det_mul_mixedEinstein
    1 1 variation unitVacuumWeylTarget.curvature (by simp)]
  · simp_rw [hCoefficients]
    simp
  · intro left right component
    exact unitVacuumWeylTarget.face_antisymmetric right left component

/-- Along the actual proper-Lorentz curve, every local coframe Euler
coefficient has zero base, linear, and quadratic terms. -/
def fourTorusUnitVacuumWeylCoframeEulerExpansion
    (internal direction : Fin 4) :
    QuadraticExpansionAtZero
      (fun t => nonlinearCoframeEulerCoefficient fourTorusShift
        (fourTorusUnitVacuumWeylLinkCurve t)
        (identityCoframeField FourTorusSite) 0 internal direction)
      0 0 0 := by
  apply QuadraticExpansionAtZero.congr
    (nonlinearCoframeEulerCoefficientLocalAffineExpansion fourTorusShift
      fourTorusUnitVacuumWeylLinkSecondExpansion 0
      (0 : LorentzConnectionVelocity)
      unitVacuumWeylConnectionFirstJet
      (freeForwardStarLocalAffineEncoding fourTorusShift 0
        (0 : LorentzConnectionVelocity) unitVacuumWeylConnectionFirstJet
        fourTorusFreeForwardStar) internal direction)
    rfl rfl rfl
  rw [generatedLorentzCurvatureCoordinates_unitVacuumWeyl]
  exact palatiniDensityFirstVariation_unitVacuumWeyl_zero
    (Matrix.single internal direction 1)

/-- The same nonflat curvature jet satisfies the affine connection equation:
its zero connection and zero coframe first jet have zero Cartan torsion. -/
theorem fourTorusUnitVacuumWeyl_affinePalatiniResidual_zero
    (direction : Fin 4) (component : Fin 6) :
    linearizedAffineCovariantPalatiniResidual 1
        (0 : LorentzConnectionVelocity) (0 : CoframeVelocity)
        direction component = 0 := by
  simpa [lorentzGenerator_zero_local] using
    connectionGeneratedVelocity_affineResidual_zero
      1 1 (by simp) (0 : LorentzConnectionVelocity) direction component

/-- The first derivative of every local nonlinear link Euler coefficient
along the actual vacuum-Weyl link curve and constant identity coframe is zero. -/
theorem fourTorusUnitVacuumWeylLinkEuler_hasDerivAt_zero
    (direction : Fin 4) (component : Fin 6) :
    HasDerivAt
      (fun t => nonlinearLinkEulerCoefficient fourTorusShift
        (fourTorusUnitVacuumWeylLinkCurve t)
        (coframeLine (identityCoframeField FourTorusSite)
          (0 : CoframeField FourTorusSite) t)
        0 direction component)
      0 0 := by
  have hDerivative :=
    hasDerivAt_nonlinearLinkEulerCoefficient_identity_of_linkCurve
      fourTorusShift
      (constantConnectionVariation (0 : LorentzConnectionVelocity))
      (0 : CoframeField FourTorusSite)
      (identityLinkSecondExpansion_curve_zero
        fourTorusUnitVacuumWeylLinkSecondExpansion)
      (identityLinkSecondExpansion_hasDerivAt
        fourTorusUnitVacuumWeylLinkSecondExpansion)
      0 direction component
  apply hDerivative.congr_deriv
  rw [linearizedLinkEulerCoefficient_eq_covariantPalatiniResidual
    fourTorusShift
    (constantConnectionVariation (0 : LorentzConnectionVelocity))
    (0 : CoframeField FourTorusSite) 0
    (fun x => constantConnectionVariation_eq
      (0 : LorentzConnectionVelocity) x 0) direction component]
  have hResidual :
      linearizedAffineCovariantPalatiniResidual 1
        (fun _ => 0)
        (backwardCoframeVelocity fourTorusShift
          (0 : CoframeField FourTorusSite) 0)
        direction = 0 := by
    have hConnection : (fun _ : Fin 4 => (0 : Fiber 6)) =
        (0 : LorentzConnectionVelocity) := by rfl
    have hBackward : backwardCoframeVelocity fourTorusShift
        (0 : CoframeField FourTorusSite) 0 = (0 : CoframeVelocity) := by
      funext predecessor internal coordinate
      simp [backwardCoframeVelocity]
    rw [hConnection, hBackward]
    funext residualComponent
    exact fourTorusUnitVacuumWeyl_affinePalatiniResidual_zero
      direction residualComponent
  change -2 * transportApply
      lorentzBivectorFundamentalSymmetry.matrix
      (linearizedAffineCovariantPalatiniResidual 1 (fun _ => 0)
        (backwardCoframeVelocity fourTorusShift
          (0 : CoframeField FourTorusSite) 0) direction) component = 0
  rw [hResidual]
  simp [transportApply]

/-- **Concrete nonflat vacuum-Einstein jet.**  The actual proper-Lorentz
plaquette coefficient is nonzero, the affine connection equation is
torsion-free, and its standard mixed coordinate Einstein tensor vanishes. -/
theorem fourTorusUnitVacuumWeyl_christoffel_and_vacuumEinstein :
    inducedCoordinateConnection 1 1 (0 : LorentzConnectionVelocity)
          (0 : CoframeVelocity) =
        christoffelSecondKind (inverseCoframeMetric 1)
          (inducedMetricFirstJet 1 (0 : CoframeVelocity)) /\
      LorentzCoordinateEinsteinContraction.inducedCoordinateCurvature
          1 1 (0 : LorentzConnectionVelocity) (0 : CoframeVelocity)
          unitVacuumWeylConnectionFirstJet
          (0 : PredecessorCoframeSecondJet) =
        coordinateCurvatureFromPlaquetteSecondJet 1 1
          (0 : LorentzConnectionVelocity) unitVacuumWeylConnectionFirstJet /\
      forall coframeDirection raisedDirection,
        LorentzCoordinateEinsteinContraction.coordinateMixedEinstein
          (inverseCoframeMetric 1)
          (coordinateCurvatureFromPlaquetteSecondJet 1 1
            (0 : LorentzConnectionVelocity)
            unitVacuumWeylConnectionFirstJet)
          coframeDirection raisedDirection = 0 := by
  apply affinePalatini_and_plaquetteCoframeStationarity_imply_vacuumEinstein
    1 1 (0 : LorentzConnectionVelocity) (0 : CoframeVelocity)
      unitVacuumWeylConnectionFirstJet
      (0 : PredecessorCoframeSecondJet) (by simp) (by simp)
      fourTorusUnitVacuumWeyl_affinePalatiniResidual_zero (by simp)
  intro variation
  rw [show
    (fun left right => lorentzGeneratorCoordinates
      (localAffineLorentzPlaquetteSecondJet
        (0 : LorentzConnectionVelocity) unitVacuumWeylConnectionFirstJet
        left right).quadratic) = unitVacuumWeylTarget.curvature by
      funext left right
      rw [localAffineLorentzPlaquetteSecondJet_coordinates_eq,
        generatedLorentzCurvatureCoordinates_unitVacuumWeyl]]
  exact palatiniDensityFirstVariation_unitVacuumWeyl_zero variation

/-- Data certified by the concrete nonflat actual-action Einstein jet.  The
Euler fields record Taylor stationarity, not exact nonlinear stationarity away
from the identity background. -/
structure FourTorusUnitVacuumWeylActualActionJet where
  curvatureNonzero :
    generatedLorentzCurvatureCoordinates
        (0 : LorentzConnectionVelocity) unitVacuumWeylConnectionFirstJet ≠ 0
  properLinks : forall t site direction,
    IsEtaLorentz
        (unitMatrix (fourTorusUnitVacuumWeylLinkCurve t site direction)) /\
      IsProperLorentz
        (unitMatrix (fourTorusUnitVacuumWeylLinkCurve t site direction))
  plaquetteExpansion : forall left right,
    QuadraticExpansionAtZero
      (fun t => unitMatrix
        (plaquetteUnit fourTorusShift
          (fourTorusUnitVacuumWeylLinkCurve t) 0 left right))
      1 0 (lorentzGenerator (unitVacuumWeylTarget.curvature left right))
  linkEulerFirstOrder : forall direction component,
    HasDerivAt
      (fun t => nonlinearLinkEulerCoefficient fourTorusShift
        (fourTorusUnitVacuumWeylLinkCurve t)
        (coframeLine (identityCoframeField FourTorusSite)
          (0 : CoframeField FourTorusSite) t)
        0 direction component)
      0 0
  coframeEulerSecondOrder : forall internal direction,
    QuadraticExpansionAtZero
      (fun t => nonlinearCoframeEulerCoefficient fourTorusShift
        (fourTorusUnitVacuumWeylLinkCurve t)
        (identityCoframeField FourTorusSite) 0 internal direction)
      0 0 0
  leviCivita :
    inducedCoordinateConnection 1 1 (0 : LorentzConnectionVelocity)
          (0 : CoframeVelocity) =
      christoffelSecondKind (inverseCoframeMetric 1)
        (inducedMetricFirstJet 1 (0 : CoframeVelocity))
  plaquetteCurvature :
    LorentzCoordinateEinsteinContraction.inducedCoordinateCurvature
          1 1 (0 : LorentzConnectionVelocity) (0 : CoframeVelocity)
          unitVacuumWeylConnectionFirstJet
          (0 : PredecessorCoframeSecondJet) =
      coordinateCurvatureFromPlaquetteSecondJet 1 1
        (0 : LorentzConnectionVelocity) unitVacuumWeylConnectionFirstJet
  vacuumEinstein : forall coframeDirection raisedDirection,
    LorentzCoordinateEinsteinContraction.coordinateMixedEinstein
      (inverseCoframeMetric 1)
      (coordinateCurvatureFromPlaquetteSecondJet 1 1
        (0 : LorentzConnectionVelocity) unitVacuumWeylConnectionFirstJet)
      coframeDirection raisedDirection = 0

/-- **Concrete nonflat actual-action Einstein-jet certificate.**  This bundles
the nonzero curvature, proper-Lorentz links, actual plaquette and Euler
expansions, Levi-Civita selection, and standard vacuum Einstein endpoint. -/
def fourTorusUnitVacuumWeyl_actualActionJet :
    FourTorusUnitVacuumWeylActualActionJet where
  curvatureNonzero :=
    generatedLorentzCurvatureCoordinates_unitVacuumWeyl_ne_zero
  properLinks := fourTorusUnitVacuumWeylLinkCurve_isProperEtaLorentz
  plaquetteExpansion := fourTorusUnitVacuumWeylPlaquetteExpansion
  linkEulerFirstOrder := fourTorusUnitVacuumWeylLinkEuler_hasDerivAt_zero
  coframeEulerSecondOrder := fourTorusUnitVacuumWeylCoframeEulerExpansion
  leviCivita :=
    fourTorusUnitVacuumWeyl_christoffel_and_vacuumEinstein.1
  plaquetteCurvature :=
    fourTorusUnitVacuumWeyl_christoffel_and_vacuumEinstein.2.1
  vacuumEinstein :=
    fourTorusUnitVacuumWeyl_christoffel_and_vacuumEinstein.2.2

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniConcreteVacuumWeylJet.fourTorusUnitVacuumWeylPlaquetteExpansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourTorusUnitVacuumWeylPlaquetteExpansion

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniConcreteVacuumWeylJet.fourTorusUnitVacuumWeylCoframeEulerExpansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourTorusUnitVacuumWeylCoframeEulerExpansion

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniConcreteVacuumWeylJet.fourTorusUnitVacuumWeylLinkEuler_hasDerivAt_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourTorusUnitVacuumWeylLinkEuler_hasDerivAt_zero

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniConcreteVacuumWeylJet.fourTorusUnitVacuumWeyl_christoffel_and_vacuumEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourTorusUnitVacuumWeyl_christoffel_and_vacuumEinstein

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniConcreteVacuumWeylJet.fourTorusUnitVacuumWeyl_actualActionJet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourTorusUnitVacuumWeyl_actualActionJet

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniConcreteVacuumWeylJet
