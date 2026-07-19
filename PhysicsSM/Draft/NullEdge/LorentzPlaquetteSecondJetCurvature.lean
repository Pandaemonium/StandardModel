import PhysicsSM.Draft.NullEdge.LorentzCoordinateEinsteinContraction
import PhysicsSM.Draft.NullEdge.LorentzMatrixSecondJet

noncomputable section

/-!
# Ordered Lorentz plaquette second jet equals differential curvature

This module closes the exact local algebraic bridge between the ordered
group-valued plaquette used by the null-edge Palatini action and the full
differential Lorentz curvature used by the tetrad/coordinate dictionary.

At one chart point, let `omega_a` be the Lorentz-connection matrices and let
`partial_a omega_b` be their supplied first jet.  The four link curves around
the oriented `(a,b)` plaquette have formal expansions

`exp(t omega_a)`,
`exp(t omega_b + t^2 partial_a omega_b)`,
`exp(-t omega_a - t^2 partial_b omega_a)`, and
`exp(-t omega_b)`.

Their ordered product has zero linear coefficient and quadratic coefficient

`partial_a omega_b - partial_b omega_a + omega_a omega_b - omega_b omega_a`.

Thus the same finite second-jet coefficient is the full `d omega + omega wedge
omega` curvature, is represented by the six action coordinates, and is
coframe-conjugate to the curvature of the induced coordinate connection.

This is an exact formal Taylor-coefficient theorem.  It does not construct the
jets from a causal graph, prove that a finite-spacing plaquette logarithm is
single-valued, or establish convergence of actual holonomies on a refinement.
Those are separate analytic and reconstruction gates.  Claim label: finite
nonlinear plaquette-curvature identity.  Originality tag: `[comp/orig]`.
-/

namespace PhysicsSM.Draft.NullEdge.LorentzPlaquetteSecondJetCurvature

open PhysicsSM.Draft.NullEdge.CausalLeviCivita
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoordinateCurvatureBridge
open PhysicsSM.Draft.NullEdge.LorentzMatrixSecondJet
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoordinateLeviCivita
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection

/-- Second jet of `exp(t generator + t^2 derivative)`, normalized as
`1 + t linear + t^2 quadratic + O(t^3)`. -/
def forwardAffineExponentialSecondJet
    (generator derivative : Matrix4R) : MatrixSecondJet where
  linear := generator
  quadratic := (1 / 2 : Real) • (generator * generator) + derivative

/-- Second jet of `exp(-t generator - t^2 derivative)`, the inverse of the
corresponding forward affine link through quadratic order. -/
def inverseAffineExponentialSecondJet
    (generator derivative : Matrix4R) : MatrixSecondJet where
  linear := -generator
  quadratic := (1 / 2 : Real) • (generator * generator) - derivative

/-- Formal second jet of the local ordered Lorentz plaquette
`U_a(x) U_b(x+a) U_a(x+b)^-1 U_b(x)^-1`, with the shifted generators supplied
by the first jet of one Lorentz connection. -/
def localAffineLorentzPlaquetteSecondJet
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (left right : Fin 4) : MatrixSecondJet :=
  MatrixSecondJet.mul
    (MatrixSecondJet.mul
      (MatrixSecondJet.mul
        (MatrixSecondJet.exponential
          (lorentzGenerator (connection left)))
        (forwardAffineExponentialSecondJet
          (lorentzGenerator (connection right))
          (lorentzGenerator (connectionFirstJet left right))))
      (inverseAffineExponentialSecondJet
        (lorentzGenerator (connection left))
        (lorentzGenerator (connectionFirstJet right left))))
    (MatrixSecondJet.inverseExponential
      (lorentzGenerator (connection right)))

/-- The ordered local plaquette closes at first order. -/
theorem localAffineLorentzPlaquetteSecondJet_linear_eq_zero
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (left right : Fin 4) :
    (localAffineLorentzPlaquetteSecondJet connection connectionFirstJet
      left right).linear = 0 := by
  unfold localAffineLorentzPlaquetteSecondJet
    forwardAffineExponentialSecondJet inverseAffineExponentialSecondJet
    MatrixSecondJet.mul MatrixSecondJet.exponential
    MatrixSecondJet.inverseExponential
  ext row column
  simp

/-- **Ordered-plaquette curvature theorem.**  The quadratic coefficient of
the affine sampled Lorentz plaquette is exactly the full differential
curvature `d omega + omega wedge omega`. -/
theorem localAffineLorentzPlaquetteSecondJet_quadratic_eq_lorentzCurvature
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (left right : Fin 4) :
    (localAffineLorentzPlaquetteSecondJet connection connectionFirstJet
      left right).quadratic =
      lorentzCurvatureMatrix (generatedLorentzConnection connection)
        (generatedLorentzConnectionFirstJet connectionFirstJet) left right := by
  unfold localAffineLorentzPlaquetteSecondJet
    forwardAffineExponentialSecondJet inverseAffineExponentialSecondJet
    MatrixSecondJet.mul MatrixSecondJet.exponential
    MatrixSecondJet.inverseExponential lorentzCurvatureMatrix
    generatedLorentzConnection generatedLorentzConnectionFirstJet
  ext row column
  simp [Matrix.mul_apply, Fin.sum_univ_four]
  ring

/-- The six action coordinates of the plaquette quadratic coefficient are
exactly the generated differential-curvature coordinates. -/
theorem localAffineLorentzPlaquetteSecondJet_coordinates_eq
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (left right : Fin 4) :
    lorentzGeneratorCoordinates
        (localAffineLorentzPlaquetteSecondJet connection connectionFirstJet
          left right).quadratic =
      generatedLorentzCurvatureCoordinates connection connectionFirstJet
        left right := by
  rw [localAffineLorentzPlaquetteSecondJet_quadratic_eq_lorentzCurvature]
  rfl

/-- **Plaquette-to-coordinate-curvature bridge.**  With compatible coframe
second jets, the curvature of the induced coordinate connection is the
coframe conjugate of the same ordered-plaquette quadratic coefficient. -/
theorem inducedCoordinateConnection_curvature_eq_plaquetteSecondJet
    (coframe inverseCoframe : Matrix4R)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (velocityFirstJet : PredecessorCoframeSecondJet)
    (hRight : coframe * inverseCoframe = 1)
    (hMixed : forall left right,
      velocityFirstJet left right = velocityFirstJet right left)
    (left right : Fin 4) :
    matrixConnectionCurvature
        (fun direction => inducedCoordinateConnectionMatrix coframe
          inverseCoframe connection velocity direction)
        (predecessorInducedConnectionFirstJet coframe inverseCoframe
          (generatedLorentzConnection connection) velocity
          (generatedLorentzConnectionFirstJet connectionFirstJet)
          velocityFirstJet) left right =
      inverseCoframe *
          (localAffineLorentzPlaquetteSecondJet connection connectionFirstJet
            left right).quadratic *
        coframe := by
  rw [localAffineLorentzPlaquetteSecondJet_quadratic_eq_lorentzCurvature]
  exact inducedCoordinateConnection_curvature_eq_generatedLorentzCurvature
    coframe inverseCoframe connection velocity connectionFirstJet
      velocityFirstJet hRight hMixed left right

/-- **Palatini-selected coordinate connection with plaquette curvature.**
Affine connection stationarity selects the Christoffel connection at first-jet
order, while the ordered Lorentz plaquette supplies its full curvature at
compatible second-jet order. -/
theorem affinePalatiniResidual_vanish_implies_leviCivita_and_plaquetteCurvature
    (coframe inverseCoframe : Matrix4R)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (velocityFirstJet : PredecessorCoframeSecondJet)
    (hLeft : inverseCoframe * coframe = 1)
    (hRight : coframe * inverseCoframe = 1)
    (hPalatini : forall direction component,
      linearizedAffineCovariantPalatiniResidual coframe connection velocity
        direction component = 0)
    (hMixed : forall left right,
      velocityFirstJet left right = velocityFirstJet right left)
    (left right : Fin 4) :
    inducedCoordinateConnection coframe inverseCoframe connection velocity =
        christoffelSecondKind (inverseCoframeMetric inverseCoframe)
          (inducedMetricFirstJet coframe velocity) /\
      matrixConnectionCurvature
          (fun direction => inducedCoordinateConnectionMatrix coframe
            inverseCoframe connection velocity direction)
          (predecessorInducedConnectionFirstJet coframe inverseCoframe
            (generatedLorentzConnection connection) velocity
            (generatedLorentzConnectionFirstJet connectionFirstJet)
            velocityFirstJet) left right =
        inverseCoframe *
            (localAffineLorentzPlaquetteSecondJet connection connectionFirstJet
              left right).quadratic *
          coframe := by
  exact And.intro
    (affinePalatiniResidual_vanish_implies_inducedLeviCivita
      coframe inverseCoframe connection velocity hLeft hRight hPalatini)
    (inducedCoordinateConnection_curvature_eq_plaquetteSecondJet
      coframe inverseCoframe connection velocity connectionFirstJet
        velocityFirstJet hRight hMixed left right)

/-- Coordinate curvature reconstructed directly from the quadratic coefficient
of the ordered local Lorentz plaquette. -/
def coordinateCurvatureFromPlaquetteSecondJet
    (coframe inverseCoframe : Matrix4R)
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet) :
    LorentzCoordinateEinsteinContraction.LocalCoordinateCurvature :=
  fun left right =>
    inverseCoframe *
        (localAffineLorentzPlaquetteSecondJet connection connectionFirstJet
          left right).quadratic *
      coframe

/-- **Plaquette-level Palatini derivation of the vacuum Einstein equation.**
Affine connection stationarity selects the Christoffel connection.  Coframe
stationarity for the six coordinates extracted from the same ordered
plaquette then makes the ordinary mixed Einstein tensor of its tetrad-
conjugated quadratic coefficient vanish.  The middle conclusion identifies
that plaquette reconstruction with the curvature of the selected induced
connection. -/
theorem affinePalatini_and_plaquetteCoframeStationarity_imply_vacuumEinstein
    (coframe inverseCoframe : Matrix4R)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (velocityFirstJet : PredecessorCoframeSecondJet)
    (hLeft : inverseCoframe * coframe = 1)
    (hRight : coframe * inverseCoframe = 1)
    (hPalatini : forall direction component,
      linearizedAffineCovariantPalatiniResidual coframe connection velocity
        direction component = 0)
    (hMixed : forall left right,
      velocityFirstJet left right = velocityFirstJet right left)
    (hCoframeStationary : forall variation,
      palatiniDensityFirstVariation coframe variation
        (fun left right => lorentzGeneratorCoordinates
          (localAffineLorentzPlaquetteSecondJet connection connectionFirstJet
            left right).quadratic) = 0) :
    inducedCoordinateConnection coframe inverseCoframe connection velocity =
        christoffelSecondKind (inverseCoframeMetric inverseCoframe)
          (inducedMetricFirstJet coframe velocity) /\
      LorentzCoordinateEinsteinContraction.inducedCoordinateCurvature coframe
          inverseCoframe connection velocity connectionFirstJet
          velocityFirstJet =
        coordinateCurvatureFromPlaquetteSecondJet coframe inverseCoframe
          connection connectionFirstJet /\
      forall coframeDirection raisedDirection,
        LorentzCoordinateEinsteinContraction.coordinateMixedEinstein
          (inverseCoframeMetric inverseCoframe)
          (coordinateCurvatureFromPlaquetteSecondJet coframe inverseCoframe
            connection connectionFirstJet)
          coframeDirection raisedDirection = 0 := by
  have hCoordinates :
      (fun left right => lorentzGeneratorCoordinates
          (localAffineLorentzPlaquetteSecondJet connection connectionFirstJet
            left right).quadratic) =
        generatedLorentzCurvatureCoordinates connection connectionFirstJet := by
    funext left right
    exact localAffineLorentzPlaquetteSecondJet_coordinates_eq
      connection connectionFirstJet left right
  have hGeneratedStationary : forall variation,
      palatiniDensityFirstVariation coframe variation
        (generatedLorentzCurvatureCoordinates connection connectionFirstJet) =
          0 := by
    intro variation
    rw [<- hCoordinates]
    exact hCoframeStationary variation
  have hMain :=
    LorentzCoordinateEinsteinContraction.affinePalatini_and_coframeStationarity_imply_leviCivita_vacuumEinstein
      coframe inverseCoframe connection velocity connectionFirstJet
      velocityFirstJet hLeft hRight hPalatini hMixed hGeneratedStationary
  have hCurvature :
      LorentzCoordinateEinsteinContraction.inducedCoordinateCurvature coframe
          inverseCoframe connection velocity connectionFirstJet
          velocityFirstJet =
        coordinateCurvatureFromPlaquetteSecondJet coframe inverseCoframe
          connection connectionFirstJet := by
    funext left right
    exact inducedCoordinateConnection_curvature_eq_plaquetteSecondJet
      coframe inverseCoframe connection velocity connectionFirstJet
        velocityFirstJet hRight hMixed left right
  exact And.intro hMain.1 (And.intro hCurvature (by
    rw [<- hCurvature]
    exact hMain.2))

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzPlaquetteSecondJetCurvature.localAffineLorentzPlaquetteSecondJet_quadratic_eq_lorentzCurvature' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms localAffineLorentzPlaquetteSecondJet_quadratic_eq_lorentzCurvature

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzPlaquetteSecondJetCurvature.inducedCoordinateConnection_curvature_eq_plaquetteSecondJet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms inducedCoordinateConnection_curvature_eq_plaquetteSecondJet

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzPlaquetteSecondJetCurvature.affinePalatiniResidual_vanish_implies_leviCivita_and_plaquetteCurvature' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms affinePalatiniResidual_vanish_implies_leviCivita_and_plaquetteCurvature

/-- info: 'PhysicsSM.Draft.NullEdge.LorentzPlaquetteSecondJetCurvature.affinePalatini_and_plaquetteCoframeStationarity_imply_vacuumEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms affinePalatini_and_plaquetteCoframeStationarity_imply_vacuumEinstein

end PhysicsSM.Draft.NullEdge.LorentzPlaquetteSecondJetCurvature
