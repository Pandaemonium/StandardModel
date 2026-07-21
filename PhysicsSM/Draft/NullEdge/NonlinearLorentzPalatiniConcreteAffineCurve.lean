import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniPlaquetteEinsteinCurve

noncomputable section

/-!
# Concrete affine-exponential link curves for the local Einstein bridge

This module constructs the local sampling data left abstract by
`NonlinearLorentzPalatiniPlaquetteEinsteinCurve`.  A free forward star at a
selected site distinguishes the four outgoing carrier endpoints.  It then
supports a constant first link jet and a canonical second correction carrying
twice the four directional derivatives of the Lorentz connection.

The resulting matrix-exponential curve is pointwise proper eta-Lorentz and has
the primitive forward and inverse quadratic expansions required by the ordered
plaquette product rule.

Claim label: finite local construction.  Originality tag: `[comp/orig]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniConcreteAffineCurve

open scoped BigOperators
open PhysicsSM.Draft.NullEdge.CausalLeviCivita
open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoordinateCurvatureBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteSecondJetCurvature
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoordinateLeviCivita
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniPlaquetteEinsteinCurve
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylAnalyticNoBranch
open PhysicsSM.Draft.NullEdge.SecondOrderCurveExpansion

/-- The four forward endpoints at a selected site are distinct from the center
and from each other.  This is the minimal local carrier condition needed to
sample four independent directional connection derivatives. -/
structure FreeForwardStar
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site) (site : Site) : Prop where
  forward_ne_center : forall direction, shift direction site ≠ site
  forward_injective : Function.Injective (fun direction => shift direction site)

/-- Site-independent first link jet carrying a supplied Lorentz connection. -/
def constantConnectionVariation
    {Site : Type*} (connection : LorentzConnectionVelocity) :
    LinkVariation Site :=
  fun _ direction => connection direction

/-- Sparse second link correction carrying twice the directional derivative at
the corresponding forward endpoint. -/
def localAffineConnectionCorrection
    {Site : Type*} [Fintype Site] [DecidableEq Site]
    (shift : Fin 4 -> Equiv Site Site) (site : Site)
    (connectionFirstJet : LorentzConnectionFirstJet) : LinkVariation Site :=
  fun x right => Finset.univ.sum fun left =>
    if x = shift left site then
      (2 : Real) • connectionFirstJet left right
    else 0

/-- The constant first variation is site-independent. -/
theorem constantConnectionVariation_eq
    {Site : Type*} (connection : LorentzConnectionVelocity)
    (x y : Site) :
    constantConnectionVariation connection x =
      constantConnectionVariation connection y :=
  rfl

/-- A free forward star makes the sparse correction vanish at its center. -/
theorem localAffineConnectionCorrection_center
    {Site : Type*} [Fintype Site] [DecidableEq Site]
    (shift : Fin 4 -> Equiv Site Site) (site : Site)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (hStar : FreeForwardStar shift site) (direction : Fin 4) :
    localAffineConnectionCorrection shift site connectionFirstJet
      site direction = 0 := by
  simp only [localAffineConnectionCorrection]
  apply Finset.sum_eq_zero
  intro left _
  simp [Ne.symm (hStar.forward_ne_center left)]

/-- At a forward endpoint, the sparse correction returns exactly twice the
corresponding directional derivative. -/
theorem localAffineConnectionCorrection_forward
    {Site : Type*} [Fintype Site] [DecidableEq Site]
    (shift : Fin 4 -> Equiv Site Site) (site : Site)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (hStar : FreeForwardStar shift site) (left right : Fin 4) :
    localAffineConnectionCorrection shift site connectionFirstJet
        (shift left site) right =
      (2 : Real) • connectionFirstJet left right := by
  classical
  simp only [localAffineConnectionCorrection]
  rw [Finset.sum_eq_single left]
  · simp
  · intro other _ hOther
    have hNe : shift left site ≠ shift other site := by
      intro hEqual
      exact hOther (hStar.forward_injective hEqual).symm
    simp [hNe]
  · simp

/-- The explicit constant first jet and sparse second correction satisfy the
local affine second-jet encoding. -/
def freeForwardStarLocalAffineEncoding
    {Site : Type*} [Fintype Site] [DecidableEq Site]
    (shift : Fin 4 -> Equiv Site Site) (site : Site)
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (hStar : FreeForwardStar shift site) :
    LocalAffineConnectionSecondJetEncoding shift
      (constantConnectionVariation connection)
      (localAffineConnectionCorrection shift site connectionFirstJet)
      site connection connectionFirstJet where
  first_center := by intro direction; rfl
  first_forward := by intro left right; rfl
  correction_center :=
    localAffineConnectionCorrection_center shift site connectionFirstJet hStar
  correction_forward :=
    localAffineConnectionCorrection_forward shift site connectionFirstJet hStar

/-- Actual group-valued curve with the connection in its first coefficient and
the affine connection jet in its second coefficient. -/
def affineExponentialLinkCurve
    {Site : Type*} (first correction : LinkVariation Site) :
    Real -> LinkConnection Site GL4 :=
  fun t x direction => matrixExponentialUnit
    (lorentzGenerator
      (t • first x direction + ((t ^ 2) / 2) • correction x direction))

/-- Every link of the affine-exponential curve is proper eta-Lorentz. -/
theorem affineExponentialLinkCurve_isProperEtaLorentz
    {Site : Type*} (first correction : LinkVariation Site)
    (t : Real) (x : Site) (direction : Fin 4) :
    IsEtaLorentz
        (unitMatrix (affineExponentialLinkCurve first correction t x direction)) /\
      IsProperLorentz
        (unitMatrix (affineExponentialLinkCurve first correction t x direction)) := by
  simpa [affineExponentialLinkCurve] using
    matrixExponentialUnit_isProperEtaLorentz
      (t • first x direction + ((t ^ 2) / 2) • correction x direction) 1

/-- Negating the exponent gives the inverse in the matrix-unit group. -/
theorem matrixExponentialUnit_neg_eq_inv
    (matrix : Matrix (Fin 4) (Fin 4) Real) :
    matrixExponentialUnit (-matrix) = (matrixExponentialUnit matrix)⁻¹ := by
  have hCancel :
      matrixExponentialUnit (-matrix) * matrixExponentialUnit matrix = 1 := by
    apply Units.ext
    change unitMatrix
        (matrixExponentialUnit (-matrix) * matrixExponentialUnit matrix) =
      unitMatrix (1 : GL4)
    rw [unitMatrix_mul, unitMatrix_matrixExponentialUnit,
      unitMatrix_matrixExponentialUnit, unitMatrix_one]
    simpa using
      (Matrix.exp_add_of_commute (-matrix) matrix
        (Commute.refl matrix).neg_left).symm
  calc
    matrixExponentialUnit (-matrix) =
        (matrixExponentialUnit (-matrix) * matrixExponentialUnit matrix) *
          (matrixExponentialUnit matrix)⁻¹ := by simp
    _ = (matrixExponentialUnit matrix)⁻¹ := by rw [hCancel]; simp

/-- The concrete affine-exponential link curve supplies both primitive forward
and inverse second-order expansions required by the plaquette product rule. -/
def affineExponentialLinkSecondExpansion
    {Site : Type*} (first correction : LinkVariation Site) :
    IdentityLinkSecondExpansion
      (affineExponentialLinkCurve first correction) first correction where
  forward := by
    intro x direction
    apply QuadraticExpansionAtZero.congr
      (QuadraticExpansionAtZero.affineMatrixExpExpansion
        (lorentzGenerator (first x direction))
        (lorentzGenerator (correction x direction)))
    · funext t
      simp only [affineExponentialLinkCurve,
        unitMatrix_matrixExponentialUnit]
      rw [lorentzGenerator_add, lorentzGenerator_smul_local,
        lorentzGenerator_smul_local]
    · rfl
    · rfl
    · rfl
  inverse := by
    intro x direction
    apply QuadraticExpansionAtZero.congr
      (QuadraticExpansionAtZero.affineMatrixExpInverseExpansion
        (lorentzGenerator (first x direction))
        (lorentzGenerator (correction x direction)))
    · funext t
      rw [affineExponentialLinkCurve,
        ← matrixExponentialUnit_neg_eq_inv,
        unitMatrix_matrixExponentialUnit]
      rw [lorentzGenerator_add, lorentzGenerator_smul_local,
        lorentzGenerator_smul_local, Matrix.exp_neg]
    · rfl
    · rfl
    · rfl

/-- The joint local Einstein capstone with the site-constant first jet and
local affine encoding discharged by the free-forward-star construction. -/
theorem actualJointStationary_freeForwardStar_imply_vacuumEinstein
    {Site : Type*} [Fintype Site] [DecidableEq Site]
    (shift : Fin 4 -> Equiv Site Site) (site : Site)
    (hStar : FreeForwardStar shift site)
    {linkCurve : Real -> LinkConnection Site GL4}
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (hLink : IdentityLinkSecondExpansion linkCurve
      (constantConnectionVariation connection)
      (localAffineConnectionCorrection shift site connectionFirstJet))
    (coframeFirst : CoframeField Site)
    (velocityFirstJet : PredecessorCoframeSecondJet)
    (hMixed : forall left right,
      velocityFirstJet left right = velocityFirstJet right left)
    (hStationary : Filter.Eventually (fun t =>
      (forall direction component,
        nonlinearLinkEulerCoefficient shift (linkCurve t)
          (coframeLine (identityCoframeField Site) coframeFirst t)
          site direction component = 0) /\
      (forall internal direction,
        nonlinearCoframeEulerCoefficient shift (linkCurve t)
          (coframeLine (identityCoframeField Site) coframeFirst t)
          site internal direction = 0)) (nhds 0)) :
    inducedCoordinateConnection 1 1 connection
          (backwardCoframeVelocity shift coframeFirst site) =
        christoffelSecondKind (inverseCoframeMetric 1)
          (inducedMetricFirstJet 1
            (backwardCoframeVelocity shift coframeFirst site)) /\
      LorentzCoordinateEinsteinContraction.inducedCoordinateCurvature
          1 1 connection (backwardCoframeVelocity shift coframeFirst site)
          connectionFirstJet velocityFirstJet =
        coordinateCurvatureFromPlaquetteSecondJet 1 1 connection
          connectionFirstJet /\
      forall coframeDirection raisedDirection,
        LorentzCoordinateEinsteinContraction.coordinateMixedEinstein
          (inverseCoframeMetric 1)
          (coordinateCurvatureFromPlaquetteSecondJet 1 1 connection
            connectionFirstJet)
          coframeDirection raisedDirection = 0 :=
  actualJointStationary_localAffine_imply_vacuumEinstein shift hLink
    (constantConnectionVariation_eq connection) coframeFirst site connection
      connectionFirstJet
      (freeForwardStarLocalAffineEncoding shift site connection
        connectionFirstJet hStar)
      velocityFirstJet hMixed hStationary

/-! ## Explicit finite carrier witness -/

/-- A `3^4` periodic carrier is large enough for the four outgoing endpoints
at the origin to be distinct. -/
abbrev FourTorusSite := Fin 4 -> ZMod 3

/-- Unit displacement in one of the four coordinate directions. -/
def fourTorusUnit (direction : Fin 4) : FourTorusSite :=
  fun coordinate => if coordinate = direction then 1 else 0

/-- Periodic translation by one unit in the selected direction. -/
def fourTorusShift (direction : Fin 4) : Equiv FourTorusSite FourTorusSite :=
  Equiv.addRight (fourTorusUnit direction)

/-- The four coordinate translations commute. -/
theorem fourTorusShift_commute (left right : Fin 4) (x : FourTorusSite) :
    fourTorusShift left (fourTorusShift right x) =
      fourTorusShift right (fourTorusShift left x) := by
  simp [fourTorusShift, add_left_comm, add_comm]

/-- The origin of the finite four-torus has a free forward star. -/
def fourTorusFreeForwardStar :
    FreeForwardStar fourTorusShift (0 : FourTorusSite) where
  forward_ne_center := by
    intro direction hEqual
    have hEntry := congrFun hEqual direction
    simp [fourTorusShift, fourTorusUnit] at hEntry
  forward_injective := by
    intro left right hEqual
    by_contra hNe
    have hEntry := congrFun hEqual left
    simp [fourTorusShift, fourTorusUnit, hNe] at hEntry

/-- The concrete affine-exponential link family on the finite four-torus.  Its
first coefficient is the supplied Lorentz connection, while its sparse second
correction samples the supplied connection first jet at the four forward
neighbors of the origin. -/
def fourTorusAffineExponentialLinkCurve
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet) :
    Real -> LinkConnection FourTorusSite GL4 :=
  affineExponentialLinkCurve
    (constantConnectionVariation connection)
    (localAffineConnectionCorrection fourTorusShift 0 connectionFirstJet)

/-- **Concrete local plaquette-to-Einstein endpoint.**  On the explicit
`3^4` periodic carrier, eventual local stationarity of the displayed proper
Lorentz affine-exponential link family and its affine coframe line selects the
Christoffel connection, identifies the plaquette coefficient with coordinate
curvature, and forces the standard mixed vacuum Einstein tensor to vanish at
the origin. -/
theorem actualJointStationary_fourTorusAffineExponential_imply_vacuumEinstein
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (coframeFirst : CoframeField FourTorusSite)
    (velocityFirstJet : PredecessorCoframeSecondJet)
    (hMixed : forall left right,
      velocityFirstJet left right = velocityFirstJet right left)
    (hStationary : Filter.Eventually (fun t =>
      (forall direction component,
        nonlinearLinkEulerCoefficient fourTorusShift
          (fourTorusAffineExponentialLinkCurve connection connectionFirstJet t)
          (coframeLine (identityCoframeField FourTorusSite) coframeFirst t)
          0 direction component = 0) /\
      (forall internal direction,
        nonlinearCoframeEulerCoefficient fourTorusShift
          (fourTorusAffineExponentialLinkCurve connection connectionFirstJet t)
          (coframeLine (identityCoframeField FourTorusSite) coframeFirst t)
          0 internal direction = 0)) (nhds 0)) :
    inducedCoordinateConnection 1 1 connection
          (backwardCoframeVelocity fourTorusShift coframeFirst 0) =
        christoffelSecondKind (inverseCoframeMetric 1)
          (inducedMetricFirstJet 1
            (backwardCoframeVelocity fourTorusShift coframeFirst 0)) /\
      LorentzCoordinateEinsteinContraction.inducedCoordinateCurvature
          1 1 connection
          (backwardCoframeVelocity fourTorusShift coframeFirst 0)
          connectionFirstJet velocityFirstJet =
        coordinateCurvatureFromPlaquetteSecondJet 1 1 connection
          connectionFirstJet /\
      forall coframeDirection raisedDirection,
        LorentzCoordinateEinsteinContraction.coordinateMixedEinstein
          (inverseCoframeMetric 1)
          (coordinateCurvatureFromPlaquetteSecondJet 1 1 connection
            connectionFirstJet)
          coframeDirection raisedDirection = 0 := by
  have hLink : IdentityLinkSecondExpansion
      (fourTorusAffineExponentialLinkCurve connection connectionFirstJet)
      (constantConnectionVariation connection)
      (localAffineConnectionCorrection fourTorusShift 0 connectionFirstJet) := by
    simpa [fourTorusAffineExponentialLinkCurve] using
      affineExponentialLinkSecondExpansion
        (constantConnectionVariation connection)
        (localAffineConnectionCorrection fourTorusShift 0 connectionFirstJet)
  exact actualJointStationary_freeForwardStar_imply_vacuumEinstein
    fourTorusShift 0 fourTorusFreeForwardStar connection connectionFirstJet
      hLink coframeFirst velocityFirstJet hMixed hStationary

/-! ## Flat nonvacuity control -/

/-- Zero connection data make the displayed affine-exponential family exactly
the identity-link family at every parameter value. -/
theorem fourTorusAffineExponentialLinkCurve_zero (t : Real) :
    fourTorusAffineExponentialLinkCurve
        (0 : LorentzConnectionVelocity) (0 : LorentzConnectionFirstJet) t =
      identityConnection FourTorusSite := by
  funext site direction
  apply Units.ext
  change unitMatrix
      (fourTorusAffineExponentialLinkCurve
        (0 : LorentzConnectionVelocity) (0 : LorentzConnectionFirstJet)
          t site direction) =
    unitMatrix (identityConnection FourTorusSite site direction)
  simp [fourTorusAffineExponentialLinkCurve, affineExponentialLinkCurve,
    constantConnectionVariation, localAffineConnectionCorrection,
    identityConnection, unitMatrix, lorentzGenerator_zero_local]

/-- The concrete stationarity premise is inhabited: zero connection and
coframe jets give the exact flat identity-link/identity-coframe family.  This
is a nonvacuity control, not a nonflat gravitational solution. -/
theorem fourTorusFlatJointStationarity :
    Filter.Eventually (fun t =>
      (forall direction component,
        nonlinearLinkEulerCoefficient fourTorusShift
          (fourTorusAffineExponentialLinkCurve
            (0 : LorentzConnectionVelocity) (0 : LorentzConnectionFirstJet) t)
          (coframeLine (identityCoframeField FourTorusSite)
            (0 : CoframeField FourTorusSite) t)
          0 direction component = 0) /\
      (forall internal direction,
        nonlinearCoframeEulerCoefficient fourTorusShift
          (fourTorusAffineExponentialLinkCurve
            (0 : LorentzConnectionVelocity) (0 : LorentzConnectionFirstJet) t)
          (coframeLine (identityCoframeField FourTorusSite)
            (0 : CoframeField FourTorusSite) t)
          0 internal direction = 0)) (nhds 0) := by
  filter_upwards with t
  rw [fourTorusAffineExponentialLinkCurve_zero]
  have hCoframe : coframeLine (identityCoframeField FourTorusSite)
      (0 : CoframeField FourTorusSite) t =
        identityCoframeField FourTorusSite := by
    funext site
    simp [coframeLine]
  rw [hCoframe]
  constructor
  · intro direction component
    simpa [identityCoframeField] using
      nonlinearLinkEulerCoefficient_identity_siteConstantCoframe
        fourTorusShift (1 : Matrix (Fin 4) (Fin 4) Real)
          (0 : FourTorusSite) direction component
  · intro internal direction
    exact nonlinearCoframeEulerCoefficient_identityConnection
      fourTorusShift (identityCoframeField FourTorusSite)
        (0 : FourTorusSite) internal direction

/-- Applying the concrete capstone to the exact flat family proves its local
vacuum Einstein endpoint without any stationarity assumption. -/
theorem fourTorusFlatVacuumEinstein :
    inducedCoordinateConnection 1 1 (0 : LorentzConnectionVelocity)
          (backwardCoframeVelocity fourTorusShift
            (0 : CoframeField FourTorusSite) 0) =
        christoffelSecondKind (inverseCoframeMetric 1)
          (inducedMetricFirstJet 1
            (backwardCoframeVelocity fourTorusShift
              (0 : CoframeField FourTorusSite) 0)) /\
      LorentzCoordinateEinsteinContraction.inducedCoordinateCurvature
          1 1 (0 : LorentzConnectionVelocity)
          (backwardCoframeVelocity fourTorusShift
            (0 : CoframeField FourTorusSite) 0)
          (0 : LorentzConnectionFirstJet)
          (0 : PredecessorCoframeSecondJet) =
        coordinateCurvatureFromPlaquetteSecondJet 1 1
          (0 : LorentzConnectionVelocity) (0 : LorentzConnectionFirstJet) /\
      forall coframeDirection raisedDirection,
        LorentzCoordinateEinsteinContraction.coordinateMixedEinstein
          (inverseCoframeMetric 1)
          (coordinateCurvatureFromPlaquetteSecondJet 1 1
            (0 : LorentzConnectionVelocity) (0 : LorentzConnectionFirstJet))
          coframeDirection raisedDirection = 0 := by
  exact actualJointStationary_fourTorusAffineExponential_imply_vacuumEinstein
    (0 : LorentzConnectionVelocity) (0 : LorentzConnectionFirstJet)
      (0 : CoframeField FourTorusSite) (0 : PredecessorCoframeSecondJet)
      (by simp) fourTorusFlatJointStationarity

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniConcreteAffineCurve.affineExponentialLinkCurve_isProperEtaLorentz' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms affineExponentialLinkCurve_isProperEtaLorentz

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniConcreteAffineCurve.affineExponentialLinkSecondExpansion' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms affineExponentialLinkSecondExpansion

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniConcreteAffineCurve.fourTorusFreeForwardStar' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourTorusFreeForwardStar

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniConcreteAffineCurve.actualJointStationary_fourTorusAffineExponential_imply_vacuumEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms actualJointStationary_fourTorusAffineExponential_imply_vacuumEinstein

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniConcreteAffineCurve.fourTorusFlatJointStationarity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourTorusFlatJointStationarity

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniConcreteAffineCurve.fourTorusFlatVacuumEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms fourTorusFlatVacuumEinstein

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniConcreteAffineCurve
