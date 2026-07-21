import PhysicsSM.Draft.NullEdge.LorentzPlaquetteSecondJetCurvature
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionCancellation
import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylAnalyticNoBranch

noncomputable section

open scoped Matrix.Norms.Frobenius

/-!
# Actual plaquette curves imply the local vacuum Einstein equation

This module upgrades the formal ordered-plaquette coefficient to an analytic
statement about actual group-valued link curves.  A local affine encoding
records the values of a Lorentz connection and its first jet on the four links
of every plaquette based at one site.  Primitive quadratic expansions of the
forward and inverse links then imply

`U_ab(t) = 1 + t^2 (partial_a omega_b - partial_b omega_a
  + [omega_a, omega_b]) + o(t^2)`.

The second half applies the existing expansions of the concrete nonlinear
link and coframe Euler coefficients.  If both actual Euler sectors vanish near
the identity along the same link/coframe family, the link first derivative is
the affine Palatini connection residual and the coframe quadratic coefficient
is the local Palatini curvature response.  The final guarded capstone therefore
selects the Christoffel connection, identifies its coordinate curvature with
the plaquette coefficient, and proves the standard mixed vacuum Einstein
equation without supplying either Euler equation separately.

The affine chart data, primitive link expansions, site-constant first link
jet, symmetric predecessor coframe second jet, and stationary family remain
hypotheses.  This module does not construct them from causal order, prove a
uniform refinement rate, or produce a stationary family dynamically.  Claim
label: analytic local plaquette-to-Einstein theorem under displayed sampling,
regularity, and stationarity hypotheses.  Originality tag: `[comp/orig]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniPlaquetteEinsteinCurve

open Filter Topology
open PhysicsSM.Draft.NullEdge.CausalLeviCivita
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoordinateCurvatureBridge
open PhysicsSM.Draft.NullEdge.LorentzMatrixSecondJet
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteSecondJetCurvature
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoordinateLeviCivita
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge.ResponseProof
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylAnalyticNoBranch
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylSecondOrderObstruction
open PhysicsSM.Draft.NullEdge.SecondOrderCurveExpansion

/-- Scalar multiplication commutes with the six-coordinate Lorentz-generator
map. -/
theorem lorentzGenerator_smul_local (scalar : Real) (field : Fiber 6) :
    lorentzGenerator (scalar • field) = scalar • lorentzGenerator field := by
  funext row column
  fin_cases row <;> fin_cases column <;>
    simp [lorentzGenerator, bivectorMatrix, MinkowskiConvention.eta,
      Matrix.mul_apply, Fin.sum_univ_four]

/-- The zero six-vector generates the zero Lorentz matrix. -/
theorem lorentzGenerator_zero_local :
    lorentzGenerator (0 : Fiber 6) = 0 := by
  simpa using lorentzGenerator_smul_local 0 (0 : Fiber 6)

/-- Local affine sampling law for the first two coefficients of link curves.
The first coefficient is the connection value at the base point.  On a link
whose initial site is shifted in direction `left`, the second Lie-algebra
coefficient is twice `partial_left omega_right`; the factor two matches the
normalization `1 + t A + (t^2 / 2) (A^2 + B)`. -/
structure LocalAffineConnectionSecondJetEncoding
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (first correction : LinkVariation Site) (site : Site)
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet) : Prop where
  first_center : forall direction,
    first site direction = connection direction
  first_forward : forall left right,
    first (shift left site) right = connection right
  correction_center : forall direction,
    correction site direction = 0
  correction_forward : forall left right,
    correction (shift left site) right =
      (2 : Real) • connectionFirstJet left right

/-- Under the local affine encoding, the corrected four-link jet used by the
actual curve expansion is exactly the local differential plaquette jet. -/
theorem correctedPlaquetteSecondJet_eq_localAffineLorentzPlaquetteSecondJet
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (first correction : LinkVariation Site) (site : Site)
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (hEncoding : LocalAffineConnectionSecondJetEncoding shift first correction
      site connection connectionFirstJet)
    (left right : Fin 4) :
    correctedPlaquetteSecondJet shift first correction site left right =
      localAffineLorentzPlaquetteSecondJet connection connectionFirstJet
        left right := by
  apply MatrixSecondJet.ext
  · simp only [correctedPlaquetteSecondJet, correctedForwardJet,
      correctedInverseJet, localAffineLorentzPlaquetteSecondJet,
      forwardAffineExponentialSecondJet, inverseAffineExponentialSecondJet,
      MatrixSecondJet.mul, MatrixSecondJet.exponential,
      MatrixSecondJet.inverseExponential, linkTangentGenerator]
    rw [hEncoding.first_center left,
      hEncoding.first_forward left right,
      hEncoding.first_forward right left,
      hEncoding.first_center right]
  · simp only [correctedPlaquetteSecondJet, correctedForwardJet,
      correctedInverseJet, localAffineLorentzPlaquetteSecondJet,
      forwardAffineExponentialSecondJet, inverseAffineExponentialSecondJet,
      MatrixSecondJet.mul, MatrixSecondJet.exponential,
      MatrixSecondJet.inverseExponential, linkTangentGenerator]
    rw [hEncoding.first_center left,
      hEncoding.first_forward left right,
      hEncoding.first_forward right left,
      hEncoding.first_center right,
      hEncoding.correction_center left,
      hEncoding.correction_forward left right,
      hEncoding.correction_forward right left,
      hEncoding.correction_center right]
    simp only [lorentzGenerator_smul_local, lorentzGenerator_zero_local]
    ext row column
    simp [Matrix.mul_apply, Fin.sum_univ_four]
    ring

/-- The actual ordered plaquette curve has the full nonlinear Lorentz
curvature as its quadratic coefficient.  The analytic remainder is derived by
four applications of the matrix product rule to the primitive link
expansions. -/
def localAffinePlaquetteExpansion
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    {linkCurve : Real -> LinkConnection Site GL4}
    {first correction : LinkVariation Site}
    (hLink : IdentityLinkSecondExpansion linkCurve first correction)
    (site : Site) (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (hEncoding : LocalAffineConnectionSecondJetEncoding shift first correction
      site connection connectionFirstJet)
    (left right : Fin 4) :
    QuadraticExpansionAtZero
      (fun t => unitMatrix (plaquetteUnit shift (linkCurve t) site left right))
      1 0
      (lorentzCurvatureMatrix (generatedLorentzConnection connection)
        (generatedLorentzConnectionFirstJet connectionFirstJet) left right) :=
  QuadraticExpansionAtZero.congr
    (plaquetteExpansion shift hLink site left right) rfl rfl
    (by
      rw [correctedPlaquetteSecondJet_eq_localAffineLorentzPlaquetteSecondJet
        shift first correction site connection connectionFirstJet hEncoding]
      exact localAffineLorentzPlaquetteSecondJet_linear_eq_zero
        connection connectionFirstJet left right)
    (by
      rw [correctedPlaquetteSecondJet_eq_localAffineLorentzPlaquetteSecondJet
        shift first correction site connection connectionFirstJet hEncoding]
      exact
        localAffineLorentzPlaquetteSecondJet_quadratic_eq_lorentzCurvature
          connection connectionFirstJet left right)

/-- The corrected plaquette jet closes at first order under the local affine
sampling law. -/
theorem correctedPlaquetteSecondJet_linear_eq_zero_of_localAffine
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (first correction : LinkVariation Site) (site : Site)
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (hEncoding : LocalAffineConnectionSecondJetEncoding shift first correction
      site connection connectionFirstJet)
    (left right : Fin 4) :
    (correctedPlaquetteSecondJet shift first correction site left right).linear =
      0 := by
  rw [correctedPlaquetteSecondJet_eq_localAffineLorentzPlaquetteSecondJet
    shift first correction site connection connectionFirstJet hEncoding]
  exact localAffineLorentzPlaquetteSecondJet_linear_eq_zero
    connection connectionFirstJet left right

/-- The corrected plaquette quadratic coefficient is the full differential
Lorentz curvature under the local affine sampling law. -/
theorem correctedPlaquetteSecondJet_quadratic_eq_lorentzCurvature_of_localAffine
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (first correction : LinkVariation Site) (site : Site)
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (hEncoding : LocalAffineConnectionSecondJetEncoding shift first correction
      site connection connectionFirstJet)
    (left right : Fin 4) :
    (correctedPlaquetteSecondJet shift first correction site left right).quadratic =
      lorentzCurvatureMatrix (generatedLorentzConnection connection)
        (generatedLorentzConnectionFirstJet connectionFirstJet) left right := by
  rw [correctedPlaquetteSecondJet_eq_localAffineLorentzPlaquetteSecondJet
    shift first correction site connection connectionFirstJet hEncoding]
  exact localAffineLorentzPlaquetteSecondJet_quadratic_eq_lorentzCurvature
    connection connectionFirstJet left right

/-- A zero first coframe argument gives a zero complementary Palatini face
variation. -/
theorem complementaryPalatiniFaceWeightFirstVariation_zero_left
    (probe : Matrix4R) (left right : Fin 4) :
    complementaryPalatiniFaceWeightFirstVariation 0 probe left right = 0 := by
  rw [complementaryPalatiniFaceWeightFirstVariation_swap_arguments]
  have h := complementaryPalatiniFaceWeightFirstVariation_smul
    probe probe 0 left right
  simpa using h

/-- The first-order coframe Euler coefficient vanishes because every local
affine plaquette has zero linear coefficient. -/
theorem linearizedCoframeEulerCoefficient_eq_zero_of_localAffine
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (first correction : LinkVariation Site) (site : Site)
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (hEncoding : LocalAffineConnectionSecondJetEncoding shift first correction
      site connection connectionFirstJet)
    (internal direction : Fin 4) :
    linearizedCoframeEulerCoefficient shift first site internal direction = 0 := by
  unfold linearizedCoframeEulerCoefficient linearizedCoframeEulerFunctional
  apply Finset.sum_eq_zero
  intro left _
  apply Finset.sum_eq_zero
  intro right _
  rw [<- correctedPlaquetteSecondJet_linear_eq_variation
    shift first correction site left right]
  rw [correctedPlaquetteSecondJet_linear_eq_zero_of_localAffine
    shift first correction site connection connectionFirstJet hEncoding]
  simp [orderedPlaquetteActionFirstResponse]

/-- The quadratic coefficient derived from the actual coframe Euler curve is
exactly the Palatini first variation evaluated on the full local Lorentz
curvature. -/
theorem coframeEulerSecondCoefficientFromJet_eq_palatiniDensityFirstVariation
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (first correction : LinkVariation Site) (site : Site)
    (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (hEncoding : LocalAffineConnectionSecondJetEncoding shift first correction
      site connection connectionFirstJet)
    (coframeFirst : CoframeField Site)
    (internal direction : Fin 4) :
    coframeEulerSecondCoefficientFromJet shift first correction
        coframeFirst site internal direction =
      palatiniDensityFirstVariation 1 (Matrix.single internal direction 1)
        (generatedLorentzCurvatureCoordinates connection
          connectionFirstJet) := by
  unfold coframeEulerSecondCoefficientFromJet palatiniDensityFirstVariation
  apply Finset.sum_congr rfl
  intro left _
  apply Finset.sum_congr rfl
  intro right _
  rw [correctedPlaquetteSecondJet_quadratic_eq_lorentzCurvature_of_localAffine
    shift first correction site connection connectionFirstJet hEncoding]
  rw [correctedPlaquetteSecondJet_linear_eq_zero_of_localAffine
    shift first correction site connection connectionFirstJet hEncoding]
  simp only [Matrix.mul_zero, add_zero]
  rw [<- lorentzGenerator_generatedLorentzCurvatureCoordinates]
  exact normalizedTracePair_eq_kreinPair
    (complementaryPalatiniFaceWeightFirstVariation 1
      (Matrix.single internal direction 1) left right)
    (generatedLorentzCurvatureCoordinates connection connectionFirstJet
      left right)

/-- Primitive second-order expansion of the constant identity coframe family.
It is used only as the refinement background on which the coframe Euler map is
evaluated; the Euler probes themselves remain arbitrary matrices. -/
def constantIdentityCoframeSecondExpansion
    {Site : Type*} :
    IdentityCoframeSecondExpansion
      (fun _ : Real => (fun _ : Site =>
        (1 : Matrix (Fin 4) (Fin 4) Real)))
      (0 : CoframeField Site) (0 : CoframeField Site) where
  point := fun _ => by
    simpa using QuadraticExpansionAtZero.constant
      (1 : Matrix (Fin 4) (Fin 4) Real)

/-- Primitive second-order expansion of the affine coframe line through the
identity field. -/
def identityCoframeLineSecondExpansion
    {Site : Type*} (coframeFirst : CoframeField Site) :
    IdentityCoframeSecondExpansion
      (coframeLine (identityCoframeField Site) coframeFirst)
      coframeFirst (0 : CoframeField Site) where
  point := fun site =>
    { remainder := fun _ => 0
      remainder_tendsto := tendsto_const_nhds
      expansion := by
        intro t
        simp [coframeLine, identityCoframeField] }

/-- The concrete nonlinear coframe Euler coefficient along an actual affine
link curve has zero base and linear terms, and its derived quadratic
coefficient is the Palatini first variation for the full differential
curvature. -/
def nonlinearCoframeEulerCoefficientLocalAffineExpansion
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    {linkCurve : Real -> LinkConnection Site GL4}
    {first correction : LinkVariation Site}
    (hLink : IdentityLinkSecondExpansion linkCurve first correction)
    (site : Site) (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (hEncoding : LocalAffineConnectionSecondJetEncoding shift first correction
      site connection connectionFirstJet)
    (internal direction : Fin 4) :
    QuadraticExpansionAtZero
      (fun t => nonlinearCoframeEulerCoefficient shift (linkCurve t)
        (fun _ : Site => (1 : Matrix (Fin 4) (Fin 4) Real))
        site internal direction)
      0 0
      (palatiniDensityFirstVariation 1 (Matrix.single internal direction 1)
        (generatedLorentzCurvatureCoordinates connection
          connectionFirstJet)) :=
  QuadraticExpansionAtZero.congr
    (nonlinearCoframeEulerCoefficientExpansion shift hLink
      (constantIdentityCoframeSecondExpansion (Site := Site))
      site internal direction)
    rfl rfl
    (linearizedCoframeEulerCoefficient_eq_zero_of_localAffine
      shift first correction site connection connectionFirstJet hEncoding
        internal direction)
    (coframeEulerSecondCoefficientFromJet_eq_palatiniDensityFirstVariation
      shift first correction site connection connectionFirstJet hEncoding 0
        internal direction)

/-- The same local affine curvature coefficient is obtained while the
coframe follows an arbitrary affine first-order line.  The coframe-dependent
cross term vanishes because the plaquette has zero linear coefficient. -/
def nonlinearCoframeEulerCoefficientLocalAffineLineExpansion
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    {linkCurve : Real -> LinkConnection Site GL4}
    {first correction : LinkVariation Site}
    (hLink : IdentityLinkSecondExpansion linkCurve first correction)
    (coframeFirst : CoframeField Site)
    (site : Site) (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (hEncoding : LocalAffineConnectionSecondJetEncoding shift first correction
      site connection connectionFirstJet)
    (internal direction : Fin 4) :
    QuadraticExpansionAtZero
      (fun t => nonlinearCoframeEulerCoefficient shift (linkCurve t)
        (coframeLine (identityCoframeField Site) coframeFirst t)
        site internal direction)
      0 0
      (palatiniDensityFirstVariation 1 (Matrix.single internal direction 1)
        (generatedLorentzCurvatureCoordinates connection
          connectionFirstJet)) :=
  QuadraticExpansionAtZero.congr
    (nonlinearCoframeEulerCoefficientExpansion shift hLink
      (identityCoframeLineSecondExpansion coframeFirst)
      site internal direction)
    rfl rfl
    (linearizedCoframeEulerCoefficient_eq_zero_of_localAffine
      shift first correction site connection connectionFirstJet hEncoding
        internal direction)
    (coframeEulerSecondCoefficientFromJet_eq_palatiniDensityFirstVariation
      shift first correction site connection connectionFirstJet hEncoding
        coframeFirst internal direction)

/-- Vanishing on all matrix-unit coframe probes implies vanishing of the
Palatini first variation on every coframe variation. -/
theorem palatiniDensityFirstVariation_eq_zero_of_matrixUnits
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (hUnits : forall internal direction,
      palatiniDensityFirstVariation 1 (Matrix.single internal direction 1)
        curvature = 0)
    (variation : Matrix (Fin 4) (Fin 4) Real) :
    palatiniDensityFirstVariation 1 variation curvature = 0 := by
  have hCoordinates := palatiniDensityFirstVariation_mul_eq_coordinateSum
    (1 : Matrix (Fin 4) (Fin 4) Real) variation curvature
  simpa [hUnits] using hCoordinates

/-- Eventual stationarity of the actual nonlinear coframe Euler equations
forces stationarity of the local Palatini density for the full affine-sampled
Lorentz curvature. -/
theorem actualCoframeStationarity_implies_palatiniDensity_stationary
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    {linkCurve : Real -> LinkConnection Site GL4}
    {first correction : LinkVariation Site}
    (hLink : IdentityLinkSecondExpansion linkCurve first correction)
    (site : Site) (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (hEncoding : LocalAffineConnectionSecondJetEncoding shift first correction
      site connection connectionFirstJet)
    (hStationary : Filter.Eventually (fun t => forall internal direction,
      nonlinearCoframeEulerCoefficient shift (linkCurve t)
        (fun _ : Site => (1 : Matrix (Fin 4) (Fin 4) Real))
        site internal direction = 0) (nhds 0)) :
    forall variation,
      palatiniDensityFirstVariation 1 variation
        (generatedLorentzCurvatureCoordinates connection
          connectionFirstJet) = 0 := by
  have hUnits : forall internal direction,
      palatiniDensityFirstVariation 1 (Matrix.single internal direction 1)
        (generatedLorentzCurvatureCoordinates connection
          connectionFirstJet) = 0 := by
    intro internal direction
    have hExpansion := nonlinearCoframeEulerCoefficientLocalAffineExpansion
      shift hLink site connection connectionFirstJet hEncoding
        internal direction
    have hZero : Filter.Eventually (fun t =>
        nonlinearCoframeEulerCoefficient shift (linkCurve t)
          (fun _ : Site => (1 : Matrix (Fin 4) (Fin 4) Real))
          site internal direction = 0) (nhds 0) := by
      filter_upwards [hStationary] with t ht
      exact ht internal direction
    exact QuadraticExpansionAtZero.quadratic_eq_zero_of_eventually_eq_zero
      hExpansion hZero
  intro variation
  exact palatiniDensityFirstVariation_eq_zero_of_matrixUnits
    (generatedLorentzCurvatureCoordinates connection connectionFirstJet)
      hUnits variation

/-- Eventual coframe stationarity along an affine coframe line forces the
same local Palatini density stationarity. -/
theorem actualCoframeLineStationarity_implies_palatiniDensity_stationary
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    {linkCurve : Real -> LinkConnection Site GL4}
    {first correction : LinkVariation Site}
    (hLink : IdentityLinkSecondExpansion linkCurve first correction)
    (coframeFirst : CoframeField Site)
    (site : Site) (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (hEncoding : LocalAffineConnectionSecondJetEncoding shift first correction
      site connection connectionFirstJet)
    (hStationary : Filter.Eventually (fun t => forall internal direction,
      nonlinearCoframeEulerCoefficient shift (linkCurve t)
        (coframeLine (identityCoframeField Site) coframeFirst t)
        site internal direction = 0) (nhds 0)) :
    forall variation,
      palatiniDensityFirstVariation 1 variation
        (generatedLorentzCurvatureCoordinates connection
          connectionFirstJet) = 0 := by
  have hUnits : forall internal direction,
      palatiniDensityFirstVariation 1 (Matrix.single internal direction 1)
        (generatedLorentzCurvatureCoordinates connection
          connectionFirstJet) = 0 := by
    intro internal direction
    have hExpansion := nonlinearCoframeEulerCoefficientLocalAffineLineExpansion
      shift hLink coframeFirst site connection connectionFirstJet hEncoding
        internal direction
    have hZero : Filter.Eventually (fun t =>
        nonlinearCoframeEulerCoefficient shift (linkCurve t)
          (coframeLine (identityCoframeField Site) coframeFirst t)
          site internal direction = 0) (nhds 0) := by
      filter_upwards [hStationary] with t ht
      exact ht internal direction
    exact QuadraticExpansionAtZero.quadratic_eq_zero_of_eventually_eq_zero
      hExpansion hZero
  intro variation
  exact palatiniDensityFirstVariation_eq_zero_of_matrixUnits
    (generatedLorentzCurvatureCoordinates connection connectionFirstJet)
      hUnits variation

open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection

/-- Primitive identity-based link expansions force the underlying group-valued
link curve to start at the identity connection. -/
theorem identityLinkSecondExpansion_curve_zero
    {Site : Type*} {linkCurve : Real -> LinkConnection Site GL4}
    {first correction : LinkVariation Site}
    (hLink : IdentityLinkSecondExpansion linkCurve first correction) :
    linkCurve 0 = identityConnection Site := by
  funext site direction
  apply Units.ext
  exact (hLink.forward site direction).value_zero

/-- The first coefficient stored by the primitive link expansion is the
ordinary derivative required by the curve-generic link Euler theorem. -/
theorem identityLinkSecondExpansion_hasDerivAt
    {Site : Type*} {linkCurve : Real -> LinkConnection Site GL4}
    {first correction : LinkVariation Site}
    (hLink : IdentityLinkSecondExpansion linkCurve first correction)
    (site : Site) (direction : Fin 4) :
    HasDerivAt (fun t => unitMatrix (linkCurve t site direction))
      (linkMatrixVariation (identityConnection Site) first site direction) 0 := by
  have hDerivative := QuadraticExpansionAtZero.hasDerivAt
    (E := Matrix (Fin 4) (Fin 4) Real)
    (hLink.forward site direction)
  simpa [linkMatrixVariation, identityConnection, linkTangentGenerator] using
    hDerivative

/-- Eventual stationarity of the actual nonlinear link Euler coefficients at
the selected site, along the same link/coframe family, forces the local affine
Palatini connection residual to vanish there. -/
theorem actualLinkStationarity_implies_affinePalatiniResidual
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    {linkCurve : Real -> LinkConnection Site GL4}
    {first correction : LinkVariation Site}
    (hLink : IdentityLinkSecondExpansion linkCurve first correction)
    (coframeFirst : CoframeField Site)
    (hFirstConstant : forall x y, first x = first y)
    (site : Site)
    (hStationary : Filter.Eventually (fun t => forall direction component,
      nonlinearLinkEulerCoefficient shift (linkCurve t)
        (coframeLine (identityCoframeField Site) coframeFirst t)
        site direction component = 0) (nhds 0)) :
    forall direction component,
      linearizedAffineCovariantPalatiniResidual 1
        (fun connectionDirection => first site connectionDirection)
        (backwardCoframeVelocity shift coframeFirst site)
        direction component = 0 := by
  intro direction component
  have hRaised :
      transportApply lorentzBivectorFundamentalSymmetry.matrix
        (linearizedAffineCovariantPalatiniResidual 1
          (fun connectionDirection => first site connectionDirection)
          (backwardCoframeVelocity shift coframeFirst site) direction) = 0 := by
    funext index
    have hDerivative :=
      hasDerivAt_nonlinearLinkEulerCoefficient_identity_of_linkCurve
        shift first coframeFirst
          (identityLinkSecondExpansion_curve_zero hLink)
          (identityLinkSecondExpansion_hasDerivAt hLink)
          site direction index
    have hZero : Filter.EventuallyEq (nhds 0)
        (fun t => nonlinearLinkEulerCoefficient shift (linkCurve t)
          (coframeLine (identityCoframeField Site) coframeFirst t)
          site direction index)
        (fun _ => 0) := by
      filter_upwards [hStationary] with t ht
      exact ht direction index
    have hLinearizedZero :
        linearizedLinkEulerCoefficient shift first coframeFirst
          site direction index = 0 := by
      have hDerivEq := hZero.deriv_eq
      simpa [hDerivative.deriv] using hDerivEq
    rw [linearizedLinkEulerCoefficient_eq_covariantPalatiniResidual
      shift first coframeFirst site (fun x => hFirstConstant x site)
        direction index] at hLinearizedZero
    simp only [Pi.zero_apply]
    linarith
  exact congrFun
    ((transportApply_fundamentalSymmetry_eq_zero_iff _).mp hRaised)
    component

/-- **Actual-action plaquette-to-Einstein capstone.**  Primitive expansions
of actual group-valued links derive the full local plaquette curvature.
Eventual vanishing of the concrete nonlinear coframe Euler equations supplies
coframe Palatini stationarity, while affine connection stationarity selects
the Christoffel connection.  The curvature of that connection is the
tetrad-conjugated plaquette coefficient and its standard mixed Einstein tensor
vanishes. -/
theorem actualCoframeStationary_affinePalatini_imply_vacuumEinstein
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    {linkCurve : Real -> LinkConnection Site GL4}
    {first correction : LinkVariation Site}
    (hLink : IdentityLinkSecondExpansion linkCurve first correction)
    (site : Site) (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (hEncoding : LocalAffineConnectionSecondJetEncoding shift first correction
      site connection connectionFirstJet)
    (velocity : CoframeVelocity)
    (velocityFirstJet : PredecessorCoframeSecondJet)
    (hPalatini : forall direction component,
      linearizedAffineCovariantPalatiniResidual 1 connection velocity
        direction component = 0)
    (hMixed : forall left right,
      velocityFirstJet left right = velocityFirstJet right left)
    (hStationary : Filter.Eventually (fun t => forall internal direction,
      nonlinearCoframeEulerCoefficient shift (linkCurve t)
        (fun _ : Site => (1 : Matrix (Fin 4) (Fin 4) Real))
        site internal direction = 0) (nhds 0)) :
    inducedCoordinateConnection 1 1 connection velocity =
        christoffelSecondKind (inverseCoframeMetric 1)
          (inducedMetricFirstJet 1 velocity) /\
      LorentzCoordinateEinsteinContraction.inducedCoordinateCurvature
          1 1 connection velocity connectionFirstJet velocityFirstJet =
        coordinateCurvatureFromPlaquetteSecondJet 1 1 connection
          connectionFirstJet /\
      forall coframeDirection raisedDirection,
        LorentzCoordinateEinsteinContraction.coordinateMixedEinstein
          (inverseCoframeMetric 1)
          (coordinateCurvatureFromPlaquetteSecondJet 1 1 connection
            connectionFirstJet)
          coframeDirection raisedDirection = 0 := by
  have hGeneratedStationary :=
    actualCoframeStationarity_implies_palatiniDensity_stationary
      shift hLink site connection connectionFirstJet hEncoding hStationary
  have hPlaquetteStationary : forall variation,
      palatiniDensityFirstVariation 1 variation
        (fun left right => lorentzGeneratorCoordinates
          (localAffineLorentzPlaquetteSecondJet connection connectionFirstJet
            left right).quadratic) = 0 := by
    intro variation
    rw [show
      (fun left right => lorentzGeneratorCoordinates
          (localAffineLorentzPlaquetteSecondJet connection connectionFirstJet
            left right).quadratic) =
        generatedLorentzCurvatureCoordinates connection connectionFirstJet by
      funext left right
      exact localAffineLorentzPlaquetteSecondJet_coordinates_eq
        connection connectionFirstJet left right]
    exact hGeneratedStationary variation
  exact affinePalatini_and_plaquetteCoframeStationarity_imply_vacuumEinstein
    1 1 connection velocity connectionFirstJet velocityFirstJet
      (by simp) (by simp) hPalatini hMixed hPlaquetteStationary

/-- **Joint actual-action plaquette-to-Einstein capstone.**  At the selected
site, the same identity-based group-valued link curve and affine coframe line
satisfy both nonlinear Euler sectors near zero.  Link stationarity supplies
the affine Palatini residual and therefore selects the Christoffel connection.
Coframe stationarity supplies the Palatini curvature response.  The plaquette
second jet is the full Lorentz curvature, its tetrad conjugate is the
coordinate curvature, and the standard mixed vacuum Einstein tensor vanishes. -/
theorem actualJointStationary_localAffine_imply_vacuumEinstein
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    {linkCurve : Real -> LinkConnection Site GL4}
    {first correction : LinkVariation Site}
    (hLink : IdentityLinkSecondExpansion linkCurve first correction)
    (hFirstConstant : forall x y, first x = first y)
    (coframeFirst : CoframeField Site)
    (site : Site) (connection : LorentzConnectionVelocity)
    (connectionFirstJet : LorentzConnectionFirstJet)
    (hEncoding : LocalAffineConnectionSecondJetEncoding shift first correction
      site connection connectionFirstJet)
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
          coframeDirection raisedDirection = 0 := by
  have hLinkStationary : Filter.Eventually (fun t =>
      forall direction component,
        nonlinearLinkEulerCoefficient shift (linkCurve t)
          (coframeLine (identityCoframeField Site) coframeFirst t)
          site direction component = 0) (nhds 0) := by
    filter_upwards [hStationary] with t ht
    exact ht.1
  have hCoframeStationary : Filter.Eventually (fun t =>
      forall internal direction,
        nonlinearCoframeEulerCoefficient shift (linkCurve t)
          (coframeLine (identityCoframeField Site) coframeFirst t)
          site internal direction = 0) (nhds 0) := by
    filter_upwards [hStationary] with t ht
    exact ht.2
  have hPalatiniRaw := actualLinkStationarity_implies_affinePalatiniResidual
    shift hLink coframeFirst hFirstConstant site hLinkStationary
  have hConnection :
      (fun direction => first site direction) = connection := by
    funext direction
    exact hEncoding.first_center direction
  rw [hConnection] at hPalatiniRaw
  have hGeneratedStationary :=
    actualCoframeLineStationarity_implies_palatiniDensity_stationary
      shift hLink coframeFirst site connection connectionFirstJet hEncoding
        hCoframeStationary
  have hPlaquetteStationary : forall variation,
      palatiniDensityFirstVariation 1 variation
        (fun left right => lorentzGeneratorCoordinates
          (localAffineLorentzPlaquetteSecondJet connection connectionFirstJet
            left right).quadratic) = 0 := by
    intro variation
    rw [show
      (fun left right => lorentzGeneratorCoordinates
          (localAffineLorentzPlaquetteSecondJet connection connectionFirstJet
            left right).quadratic) =
        generatedLorentzCurvatureCoordinates connection connectionFirstJet by
      funext left right
      exact localAffineLorentzPlaquetteSecondJet_coordinates_eq
        connection connectionFirstJet left right]
    exact hGeneratedStationary variation
  exact affinePalatini_and_plaquetteCoframeStationarity_imply_vacuumEinstein
    1 1 connection (backwardCoframeVelocity shift coframeFirst site)
      connectionFirstJet velocityFirstJet (by simp) (by simp) hPalatiniRaw
        hMixed hPlaquetteStationary

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniPlaquetteEinsteinCurve.actualLinkStationarity_implies_affinePalatiniResidual' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms actualLinkStationarity_implies_affinePalatiniResidual

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniPlaquetteEinsteinCurve.actualJointStationary_localAffine_imply_vacuumEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms actualJointStationary_localAffine_imply_vacuumEinstein

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniPlaquetteEinsteinCurve.correctedPlaquetteSecondJet_eq_localAffineLorentzPlaquetteSecondJet' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms correctedPlaquetteSecondJet_eq_localAffineLorentzPlaquetteSecondJet

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniPlaquetteEinsteinCurve.actualCoframeStationarity_implies_palatiniDensity_stationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms actualCoframeStationarity_implies_palatiniDensity_stationary

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniPlaquetteEinsteinCurve.actualCoframeStationary_affinePalatini_imply_vacuumEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms actualCoframeStationary_affinePalatini_imply_vacuumEinstein

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniPlaquetteEinsteinCurve
