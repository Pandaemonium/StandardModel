import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelectionCapstone

noncomputable section

/-!
# Nonuniform neighbor defect in the nonlinear link-Euler first jet

The actual nonlinear link-Euler torsion theorem is exact for a site-uniform
connection variation.  This successor removes that hypothesis from the first
jet by displaying the term that survives for a general site-dependent
variation.

At a chosen center site, split the connection variation into its constant
extension from that site and a fluctuation that vanishes there.  The constant
part gives the covariant Cartan residual by the preceding theorem.  The
fluctuation gives the explicit four-corner `nonuniformConnectionDefect` below.
Its formula contains only neighboring-minus-center connection values; it is
independent of the coframe variation and vanishes on every site-uniform
connection jet.

This is an exact identity at the identity coframe and connection.  It does not
yet prove that the defect is small on a graph refinement.  A successor must
equip sampled smooth connection fields with a spacing normalization and prove
the corresponding finite-difference bound before claiming continuum torsion
selection.

Claim label: finite first-jet identity.  Originality tag: `[orig]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection

open Filter Topology
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement

/-! ## Center extension and neighbor differences -/

/-- Extend the connection variation at one site constantly over the carrier. -/
def constantLinkVariationAt {Site : Type*}
    (linkVariation : LinkVariation Site) (center : Site) :
    LinkVariation Site :=
  fun _ => linkVariation center

/-- Connection value at a site minus the value in the same direction at a
chosen center site. -/
def linkNeighborDifference {Site : Type*}
    (linkVariation : LinkVariation Site) (center site : Site)
    (direction : Fin 4) : Fiber 6 :=
  linkVariation site direction - linkVariation center direction

/-- The connection fluctuation around the constant extension of its value at
the chosen center. -/
def centeredLinkVariation {Site : Type*}
    (linkVariation : LinkVariation Site) (center : Site) :
    LinkVariation Site :=
  fun site direction =>
    linkNeighborDifference linkVariation center site direction

@[simp]
theorem centeredLinkVariation_apply {Site : Type*}
    (linkVariation : LinkVariation Site) (center site : Site)
    (direction : Fin 4) :
    centeredLinkVariation linkVariation center site direction =
      linkNeighborDifference linkVariation center site direction :=
  rfl

@[simp]
theorem constantLinkVariationAt_apply {Site : Type*}
    (linkVariation : LinkVariation Site) (center site : Site)
    (direction : Fin 4) :
    constantLinkVariationAt linkVariation center site direction =
      linkVariation center direction :=
  rfl

@[simp]
theorem linkNeighborDifference_center {Site : Type*}
    (linkVariation : LinkVariation Site) (center : Site)
    (direction : Fin 4) :
    linkNeighborDifference linkVariation center center direction = 0 := by
  simp [linkNeighborDifference]

@[simp]
theorem centeredLinkVariation_center {Site : Type*}
    (linkVariation : LinkVariation Site) (center : Site)
    (direction : Fin 4) :
    centeredLinkVariation linkVariation center center direction = 0 :=
  linkNeighborDifference_center linkVariation center direction

/-- The center extension plus the centered fluctuation recovers the original
connection variation pointwise. -/
theorem constant_add_centeredLinkVariation {Site : Type*}
    (linkVariation : LinkVariation Site) (center : Site) :
    constantLinkVariationAt linkVariation center +
        centeredLinkVariation linkVariation center =
      linkVariation := by
  funext site direction component
  simp [constantLinkVariationAt, centeredLinkVariation,
    linkNeighborDifference]

/-- A site-uniform connection variation has zero centered fluctuation. -/
theorem centeredLinkVariation_eq_zero_of_constant {Site : Type*}
    (linkVariation : LinkVariation Site) (center : Site)
    (hLinkConstant : forall site, linkVariation site = linkVariation center) :
    centeredLinkVariation linkVariation center = 0 := by
  funext site direction component
  change linkVariation site direction component -
    linkVariation center direction component = 0
  rw [show linkVariation site direction component =
      linkVariation center direction component by
    exact congrFun (congrFun (hLinkConstant site) direction) component]
  ring

/-! ## Linearity of the identity-background first jet -/

/-- One coordinate response is additive when all first-order inputs are
added.  The background face and link probe remain fixed. -/
theorem linearizedGeneratorFaceResponse_add_variations
    (face leftFace rightFace leftTransport rightTransport probe
      leftHolonomy rightHolonomy : Fiber 6) :
    linearizedGeneratorFaceResponse face (leftFace + rightFace)
        (leftTransport + rightTransport) probe
        (leftHolonomy + rightHolonomy) =
      linearizedGeneratorFaceResponse face leftFace leftTransport probe
          leftHolonomy +
        linearizedGeneratorFaceResponse face rightFace rightTransport probe
          rightHolonomy := by
  unfold linearizedGeneratorFaceResponse
  rw [lorentzGenerator_add, lorentzGenerator_add, lorentzGenerator_add]
  simp only [Matrix.add_mul, Matrix.mul_add, Matrix.mul_sub, Matrix.trace_add,
    Matrix.trace_sub]
  ring

/-- Additivity when a transport variation is itself the sum of two link
contributions.  The regrouping keeps both left-field contributions together
and both right-field contributions together. -/
theorem linearizedGeneratorFaceResponse_add_twoStepVariations
    (face leftFace rightFace
      leftTransportOne rightTransportOne leftTransportTwo rightTransportTwo
      probe leftHolonomy rightHolonomy : Fiber 6) :
    linearizedGeneratorFaceResponse face (leftFace + rightFace)
        ((leftTransportOne + rightTransportOne) +
          (leftTransportTwo + rightTransportTwo))
        probe (leftHolonomy + rightHolonomy) =
      linearizedGeneratorFaceResponse face leftFace
          (leftTransportOne + leftTransportTwo) probe leftHolonomy +
        linearizedGeneratorFaceResponse face rightFace
          (rightTransportOne + rightTransportTwo) probe rightHolonomy := by
  rw [show (leftTransportOne + rightTransportOne) +
      (leftTransportTwo + rightTransportTwo) =
      (leftTransportOne + leftTransportTwo) +
        (rightTransportOne + rightTransportTwo) by abel]
  exact linearizedGeneratorFaceResponse_add_variations
    face leftFace rightFace
      (leftTransportOne + leftTransportTwo)
      (rightTransportOne + rightTransportTwo)
      probe leftHolonomy rightHolonomy

/-- The additive plaquette curl is additive in its link field. -/
theorem additivePlaquetteCurl_add_local {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site)
    (left right : LinkVariation Site) (site : Site) (a b : Fin 4) :
    additivePlaquetteCurl shift (left + right) site a b =
      additivePlaquetteCurl shift left site a b +
        additivePlaquetteCurl shift right site a b := by
  funext component
  simp [additivePlaquetteCurl]
  ring

/-- The pointwise complementary-face first variation is additive in its
coframe field variation. -/
theorem coframeFaceWeightFirstVariation_add_local {Site : Type*}
    (coframe left right : CoframeField Site) (site : Site) (a b : Fin 4) :
    coframeFaceWeightFirstVariation coframe (left + right) site a b =
      coframeFaceWeightFirstVariation coframe left site a b +
        coframeFaceWeightFirstVariation coframe right site a b := by
  exact complementaryPalatiniFaceWeightFirstVariation_add
    (coframe site) (left site) (right site) a b

@[simp]
theorem coframeFaceWeightFirstVariation_zero_local {Site : Type*}
    (coframe : CoframeField Site) (site : Site) (a b : Fin 4) :
    coframeFaceWeightFirstVariation coframe 0 site a b = 0 := by
  have hAdd := coframeFaceWeightFirstVariation_add_local
    coframe 0 0 site a b
  funext component
  change coframeFaceWeightFirstVariation coframe 0 site a b component =
    (0 : Real)
  have hComponent := congrFun hAdd component
  simp only [zero_add, Pi.add_apply] at hComponent
  linarith

/-- The complete identity-background link Euler first jet is additive in the
simultaneous connection and coframe variations. -/
theorem linearizedLinkEulerFunctional_add
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (leftLink rightLink : LinkVariation Site)
    (leftCoframe rightCoframe : CoframeField Site)
    (site : Site) (direction : Fin 4) (probe : Fiber 6) :
    linearizedLinkEulerFunctional shift (leftLink + rightLink)
        (leftCoframe + rightCoframe) site direction probe =
      linearizedLinkEulerFunctional shift leftLink leftCoframe
          site direction probe +
        linearizedLinkEulerFunctional shift rightLink rightCoframe
          site direction probe := by
  simp_rw [linearizedLinkEulerFunctional_eq_coordinates]
  unfold linearizedLinkEulerFunctionalCoordinates
  simp_rw [coframeFaceWeightFirstVariation_add_local,
    additivePlaquetteCurl_add_local]
  simp only [Pi.add_apply]
  simp_rw [linearizedGeneratorFaceResponse_add_twoStepVariations]
  simp_rw [linearizedGeneratorFaceResponse_add_variations]
  simp only [Finset.sum_add_distrib]
  ring

/-- Coordinate coefficients inherit simultaneous first-jet additivity. -/
theorem linearizedLinkEulerCoefficient_add
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (leftLink rightLink : LinkVariation Site)
    (leftCoframe rightCoframe : CoframeField Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) :
    linearizedLinkEulerCoefficient shift (leftLink + rightLink)
        (leftCoframe + rightCoframe) site direction component =
      linearizedLinkEulerCoefficient shift leftLink leftCoframe
          site direction component +
        linearizedLinkEulerCoefficient shift rightLink rightCoframe
          site direction component :=
  linearizedLinkEulerFunctional_add shift leftLink rightLink
    leftCoframe rightCoframe site direction _

/-- One coordinate response scales when all first-order inputs are scaled.
The background face and link probe remain fixed. -/
theorem linearizedGeneratorFaceResponse_smul_variations
    (face faceVariation transportVariation probe holonomyVariation : Fiber 6)
    (scalar : Real) :
    linearizedGeneratorFaceResponse face (scalar • faceVariation)
        (scalar • transportVariation) probe
        (scalar • holonomyVariation) =
      scalar * linearizedGeneratorFaceResponse face faceVariation
        transportVariation probe holonomyVariation := by
  unfold linearizedGeneratorFaceResponse
  rw [lorentzGenerator_smul, lorentzGenerator_smul, lorentzGenerator_smul]
  simp only [Matrix.smul_mul, Matrix.mul_smul]
  rw [<- smul_sub, <- smul_add, Matrix.mul_smul, <- smul_add,
    Matrix.trace_smul]
  simp only [smul_eq_mul]
  ring

/-- The additive plaquette curl respects scalar multiplication of its link
field. -/
theorem additivePlaquetteCurl_smul_local {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site) (scalar : Real)
    (linkVariation : LinkVariation Site) (site : Site) (a b : Fin 4) :
    additivePlaquetteCurl shift (scalar • linkVariation) site a b =
      scalar • additivePlaquetteCurl shift linkVariation site a b := by
  funext component
  simp [additivePlaquetteCurl]
  ring

/-- The pointwise complementary-face first variation respects scalar
multiplication of its coframe field variation. -/
theorem coframeFaceWeightFirstVariation_smul_local {Site : Type*}
    (coframe : CoframeField Site) (scalar : Real)
    (variation : CoframeField Site) (site : Site) (a b : Fin 4) :
    coframeFaceWeightFirstVariation coframe (scalar • variation) site a b =
      scalar • coframeFaceWeightFirstVariation coframe variation site a b := by
  exact complementaryPalatiniFaceWeightFirstVariation_smul
    (coframe site) (variation site) scalar a b

/-- The complete identity-background link Euler first jet respects
simultaneous real scaling of the connection and coframe variations. -/
theorem linearizedLinkEulerFunctional_smul
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (scalar : Real)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (direction : Fin 4) (probe : Fiber 6) :
    linearizedLinkEulerFunctional shift (scalar • linkVariation)
        (scalar • coframeVariation) site direction probe =
      scalar * linearizedLinkEulerFunctional shift linkVariation
        coframeVariation site direction probe := by
  simp_rw [linearizedLinkEulerFunctional_eq_coordinates]
  unfold linearizedLinkEulerFunctionalCoordinates
  simp_rw [coframeFaceWeightFirstVariation_smul_local,
    additivePlaquetteCurl_smul_local]
  simp only [Pi.smul_apply]
  simp_rw [<- smul_add]
  simp_rw [linearizedGeneratorFaceResponse_smul_variations]
  simp_rw [<- Finset.mul_sum]
  ring

/-- Coordinate coefficients inherit simultaneous first-jet homogeneity. -/
theorem linearizedLinkEulerCoefficient_smul
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (scalar : Real)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) :
    linearizedLinkEulerCoefficient shift (scalar • linkVariation)
        (scalar • coframeVariation) site direction component =
      scalar * linearizedLinkEulerCoefficient shift linkVariation
        coframeVariation site direction component :=
  linearizedLinkEulerFunctional_smul shift scalar linkVariation
    coframeVariation site direction _

/-- Centering commutes with real scaling of a connection variation. -/
theorem centeredLinkVariation_smul {Site : Type*}
    (scalar : Real) (linkVariation : LinkVariation Site) (center : Site) :
    centeredLinkVariation (scalar • linkVariation) center =
      scalar • centeredLinkVariation linkVariation center := by
  funext site direction component
  simp [centeredLinkVariation, linkNeighborDifference]
  ring

/-! ## Explicit nonuniform connection defect -/

/-- The exact four-corner correction produced by neighboring-minus-center
connection values.  Every occurrence of `delta` is a literal finite
difference from the selected center site. -/
def nonuniformConnectionDefect
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) : Real :=
  let identityCoframe := identityCoframeField Site
  let delta := linkNeighborDifference linkVariation site
  let probe : Fiber 6 := Pi.single component (1 : Real)
  Finset.sum Finset.univ (fun b =>
      linearizedGeneratorFaceResponse
        (coframeFaceWeight identityCoframe site direction b)
        0 0 probe
        (delta (shift direction site) b -
          delta (shift b site) direction)) +
    Finset.sum Finset.univ (fun a =>
      let predecessor := (shift a).symm site
      linearizedGeneratorFaceResponse
        (coframeFaceWeight identityCoframe predecessor a direction)
        0 (delta predecessor a) probe
        (delta predecessor a - delta predecessor direction -
          delta (shift direction predecessor) a)) -
    Finset.sum Finset.univ (fun a =>
      let curl := delta (shift a site) direction -
        delta (shift direction site) a
      linearizedGeneratorFaceResponse
        (coframeFaceWeight identityCoframe site a direction)
        0 curl probe curl) -
    Finset.sum Finset.univ (fun b =>
      let predecessor := (shift b).symm site
      let transport := delta predecessor direction +
        delta (shift direction predecessor) b
      linearizedGeneratorFaceResponse
        (coframeFaceWeight identityCoframe predecessor direction b)
        0 transport probe (transport - delta predecessor b))

/-- Curl of the centered fluctuation at its center. -/
theorem additivePlaquetteCurl_centered_center
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site) (site : Site) (a b : Fin 4) :
    additivePlaquetteCurl shift (centeredLinkVariation linkVariation site)
        site a b =
      linkNeighborDifference linkVariation site (shift a site) b -
        linkNeighborDifference linkVariation site (shift b site) a := by
  funext component
  simp [additivePlaquetteCurl, centeredLinkVariation,
    linkNeighborDifference]

/-- Curl of the centered fluctuation at a predecessor in its first
direction. -/
theorem additivePlaquetteCurl_centered_firstPredecessor
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site) (site : Site) (a b : Fin 4) :
    additivePlaquetteCurl shift (centeredLinkVariation linkVariation site)
        ((shift a).symm site) a b =
      linkNeighborDifference linkVariation site ((shift a).symm site) a -
        linkNeighborDifference linkVariation site ((shift a).symm site) b -
        linkNeighborDifference linkVariation site
          (shift b ((shift a).symm site)) a := by
  funext component
  simp [additivePlaquetteCurl, centeredLinkVariation,
    linkNeighborDifference]

/-- Curl of the centered fluctuation at a predecessor in its second
direction. -/
theorem additivePlaquetteCurl_centered_secondPredecessor
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site) (site : Site) (a b : Fin 4) :
    additivePlaquetteCurl shift (centeredLinkVariation linkVariation site)
        ((shift b).symm site) a b =
      linkNeighborDifference linkVariation site ((shift b).symm site) a +
        linkNeighborDifference linkVariation site
          (shift a ((shift b).symm site)) b -
        linkNeighborDifference linkVariation site ((shift b).symm site) b := by
  funext component
  simp [additivePlaquetteCurl, centeredLinkVariation,
    linkNeighborDifference]

/-- The expanded neighbor formula is exactly the link-Euler response to the
centered connection fluctuation with zero coframe variation. -/
theorem linearizedLinkEulerCoefficient_centered_eq_nonuniformDefect
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) :
    linearizedLinkEulerCoefficient shift
        (centeredLinkVariation linkVariation site) 0
        site direction component =
      nonuniformConnectionDefect shift linkVariation site direction
        component := by
  unfold linearizedLinkEulerCoefficient
  rw [linearizedLinkEulerFunctional_eq_coordinates]
  unfold linearizedLinkEulerFunctionalCoordinates
    nonuniformConnectionDefect
  simp_rw [coframeFaceWeightFirstVariation_zero_local]
  simp_rw [additivePlaquetteCurl_centered_firstPredecessor,
    additivePlaquetteCurl_centered_center,
    additivePlaquetteCurl_centered_secondPredecessor,
    centeredLinkVariation_apply]
  simp only [Equiv.apply_symm_apply,
    linkNeighborDifference_center, add_zero]

/-- **General first-jet decomposition.**  The identity-background link Euler
coefficient is the covariant Cartan residual evaluated at the center-site
connection value, plus the explicit nonuniform neighboring-link defect. -/
theorem linearizedLinkEulerCoefficient_eq_covariantResidual_add_defect
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) :
    linearizedLinkEulerCoefficient shift linkVariation coframeVariation
        site direction component =
      -2 * transportApply lorentzBivectorFundamentalSymmetry.matrix
        (linearizedAffineCovariantPalatiniResidual
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (fun connectionDirection =>
            linkVariation site connectionDirection)
          (backwardCoframeVelocity shift coframeVariation site)
          direction) component +
        nonuniformConnectionDefect shift linkVariation site direction
          component := by
  have hLink := constant_add_centeredLinkVariation linkVariation site
  calc
    linearizedLinkEulerCoefficient shift linkVariation coframeVariation
        site direction component =
      linearizedLinkEulerCoefficient shift
          (constantLinkVariationAt linkVariation site +
            centeredLinkVariation linkVariation site)
          (coframeVariation + 0) site direction component := by
        rw [hLink, add_zero]
    _ = linearizedLinkEulerCoefficient shift
          (constantLinkVariationAt linkVariation site) coframeVariation
          site direction component +
        linearizedLinkEulerCoefficient shift
          (centeredLinkVariation linkVariation site) 0
          site direction component :=
      linearizedLinkEulerCoefficient_add shift
        (constantLinkVariationAt linkVariation site)
        (centeredLinkVariation linkVariation site) coframeVariation 0
        site direction component
    _ = _ := by
      rw [linearizedLinkEulerCoefficient_eq_covariantPalatiniResidual
        shift (constantLinkVariationAt linkVariation site) coframeVariation
        site (fun _ => rfl) direction component,
        linearizedLinkEulerCoefficient_centered_eq_nonuniformDefect]
      rfl

/-- The derivative of the actual nonlinear Euler coefficient has the same
Cartan-plus-neighbor-defect decomposition for every site-dependent connection
variation. -/
theorem hasDerivAt_nonlinearLinkEulerCoefficient_eq_covariantResidual_add_defect
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
      (-2 * transportApply lorentzBivectorFundamentalSymmetry.matrix
        (linearizedAffineCovariantPalatiniResidual
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (fun connectionDirection =>
            linkVariation site connectionDirection)
          (backwardCoframeVelocity shift coframeVariation site)
          direction) component +
        nonuniformConnectionDefect shift linkVariation site direction
          component) 0 := by
  exact (hasDerivAt_nonlinearLinkEulerCoefficient_identity shift
    linkVariation coframeVariation site direction component).congr_deriv
      (linearizedLinkEulerCoefficient_eq_covariantResidual_add_defect
        shift linkVariation coframeVariation site direction component)

/-- The nonuniform defect vanishes identically on site-uniform connection
variations. -/
theorem nonuniformConnectionDefect_eq_zero_of_constant
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site) (site : Site)
    (hLinkConstant : forall x, linkVariation x = linkVariation site)
    (direction : Fin 4) (component : Fin 6) :
    nonuniformConnectionDefect shift linkVariation site direction component =
      0 := by
  have hDelta (x : Site) (a : Fin 4) :
      linkNeighborDifference linkVariation site x a = 0 := by
    funext index
    change linkVariation x a index - linkVariation site a index = 0
    rw [show linkVariation x a index = linkVariation site a index by
      exact congrFun (congrFun (hLinkConstant x) a) index]
    ring
  unfold nonuniformConnectionDefect
  simp_rw [hDelta]
  have hGeneratorZero :
      lorentzGenerator (0 : Fiber 6) = 0 := by
    simpa using lorentzGenerator_smul (0 : Real) (0 : Fiber 6)
  simp [linearizedGeneratorFaceResponse, hGeneratorZero]

/-- Adding a globally constant connection mode does not change any
neighbor-minus-center difference. -/
theorem linkNeighborDifference_add_constant
    {Site : Type*} (linkVariation offset : LinkVariation Site)
    (center site : Site) (direction : Fin 4) :
    linkNeighborDifference
        (linkVariation + constantLinkVariationAt offset center)
        center site direction =
      linkNeighborDifference linkVariation center site direction := by
  funext component
  simp [linkNeighborDifference, constantLinkVariationAt]

/-- The finite defect depends only on nonuniform connection differences: it
is invariant under addition of any site-independent connection mode. -/
theorem nonuniformConnectionDefect_add_constant
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation offset : LinkVariation Site) (site : Site)
    (direction : Fin 4) (component : Fin 6) :
    nonuniformConnectionDefect shift
        (linkVariation + constantLinkVariationAt offset site)
        site direction component =
      nonuniformConnectionDefect shift linkVariation site direction
        component := by
  unfold nonuniformConnectionDefect
  simp_rw [linkNeighborDifference_add_constant]

/-- The nonuniform defect is exactly homogeneous in the amplitude of the
connection variation. -/
theorem nonuniformConnectionDefect_smul
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (scalar : Real)
    (linkVariation : LinkVariation Site) (site : Site)
    (direction : Fin 4) (component : Fin 6) :
    nonuniformConnectionDefect shift (scalar • linkVariation)
        site direction component =
      scalar * nonuniformConnectionDefect shift linkVariation
        site direction component := by
  calc
    nonuniformConnectionDefect shift (scalar • linkVariation)
        site direction component =
      linearizedLinkEulerCoefficient shift
        (centeredLinkVariation (scalar • linkVariation) site) 0
        site direction component :=
      (linearizedLinkEulerCoefficient_centered_eq_nonuniformDefect
        shift (scalar • linkVariation) site direction component).symm
    _ = linearizedLinkEulerCoefficient shift
        (scalar • centeredLinkVariation linkVariation site) 0
        site direction component := by rw [centeredLinkVariation_smul]
    _ = scalar * linearizedLinkEulerCoefficient shift
        (centeredLinkVariation linkVariation site) 0
        site direction component := by
      simpa using linearizedLinkEulerCoefficient_smul shift scalar
        (centeredLinkVariation linkVariation site) 0
        site direction component
    _ = scalar * nonuniformConnectionDefect shift linkVariation
        site direction component := by
      rw [linearizedLinkEulerCoefficient_centered_eq_nonuniformDefect]

/-- A global connection mode plus a scaled nonuniform fluctuation has exactly
the scaled defect of that fluctuation. -/
theorem nonuniformConnectionDefect_constant_add_scaled
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (scalar : Real)
    (linkVariation offset : LinkVariation Site) (site : Site)
    (direction : Fin 4) (component : Fin 6) :
    nonuniformConnectionDefect shift
        (scalar • linkVariation + constantLinkVariationAt offset site)
        site direction component =
      scalar * nonuniformConnectionDefect shift linkVariation
        site direction component := by
  rw [nonuniformConnectionDefect_add_constant,
    nonuniformConnectionDefect_smul]

/-- **Conditional shrinking-nonuniformity endpoint.**  If the amplitude of a
fixed nonuniform connection mode tends to zero, every component of its exact
finite neighbor defect tends to zero.  This theorem supplies the analytic
interface but does not derive the amplitude law from smooth graph sampling. -/
theorem nonuniformConnectionDefect_tendsto_zero_of_scale
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (scale : Nat -> Real) (hScale : Tendsto scale atTop (nhds 0))
    (linkVariation : LinkVariation Site) (site : Site)
    (direction : Fin 4) (component : Fin 6) :
    Tendsto
      (fun n => nonuniformConnectionDefect shift
        (scale n • linkVariation) site direction component)
      atTop (nhds 0) := by
  simp_rw [nonuniformConnectionDefect_smul]
  simpa using hScale.mul_const
    (nonuniformConnectionDefect shift linkVariation site direction component)

/-! ## Shrinking-neighbor torsion selection -/

/-- A prescribed local refinement family: keep the connection value at the
selected center fixed and scale an arbitrary centered neighboring mode. -/
def shrinkingNeighborLinkVariation {Site : Type*}
    (connectionVariation neighborVariation : LinkVariation Site)
    (site : Site) (scalar : Real) : LinkVariation Site :=
  scalar • centeredLinkVariation neighborVariation site +
    constantLinkVariationAt connectionVariation site

@[simp]
theorem shrinkingNeighborLinkVariation_center {Site : Type*}
    (connectionVariation neighborVariation : LinkVariation Site)
    (site : Site) (scalar : Real) (direction : Fin 4) :
    shrinkingNeighborLinkVariation connectionVariation neighborVariation
        site scalar site direction =
      connectionVariation site direction := by
  simp [shrinkingNeighborLinkVariation]

/-- The exact defect of the prescribed local refinement family is the scale
times the defect of its centered neighboring mode. -/
theorem nonuniformConnectionDefect_shrinkingNeighbor
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connectionVariation neighborVariation : LinkVariation Site)
    (site : Site) (scalar : Real) (direction : Fin 4) (component : Fin 6) :
    nonuniformConnectionDefect shift
        (shrinkingNeighborLinkVariation connectionVariation
          neighborVariation site scalar)
        site direction component =
      scalar * nonuniformConnectionDefect shift
        (centeredLinkVariation neighborVariation site)
        site direction component := by
  unfold shrinkingNeighborLinkVariation
  rw [nonuniformConnectionDefect_add_constant,
    nonuniformConnectionDefect_smul]

/-- The prescribed local refinement defect tends to zero whenever its scale
does. -/
theorem nonuniformConnectionDefect_shrinkingNeighbor_tendsto_zero
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (scale : Nat -> Real) (hScale : Tendsto scale atTop (nhds 0))
    (connectionVariation neighborVariation : LinkVariation Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) :
    Tendsto
      (fun n => nonuniformConnectionDefect shift
        (shrinkingNeighborLinkVariation connectionVariation
          neighborVariation site (scale n))
        site direction component)
      atTop (nhds 0) := by
  simp_rw [nonuniformConnectionDefect_shrinkingNeighbor]
  simpa using hScale.mul_const
    (nonuniformConnectionDefect shift
      (centeredLinkVariation neighborVariation site)
      site direction component)

/-- **Actual-action shrinking-neighbor torsion selection.**  Keep the
connection value and backward coframe jet fixed at one center site, while an
arbitrary centered neighboring connection mode is multiplied by a scale that
tends to zero.  If every actual nonlinear link-Euler derivative is stationary
along that family, the center data obey the linearized covariant Cartan
torsion equation.

This theorem removes exact site uniformity but assumes the displayed
shrinking-neighbor family and stationarity at every refinement level.  It does
not derive such a family from sampled smooth null-edge geometry. -/
theorem nonlinearLinkEulerCoefficient_shrinkingNeighbor_torsionFree
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (scale : Nat -> Real) (hScale : Tendsto scale atTop (nhds 0))
    (connectionVariation neighborVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site) (site : Site)
    (hStationary : forall n direction component,
      deriv (fun t => nonlinearLinkEulerCoefficient shift
        (exponentialLinkCurve (identityConnection Site)
          (shrinkingNeighborLinkVariation connectionVariation
            neighborVariation site (scale n)) t)
        (coframeLine (identityCoframeField Site) coframeVariation t)
        site direction component) 0 = 0) :
    LinearizedCovariantTorsionFree
      (1 : Matrix (Fin 4) (Fin 4) Real)
      (fun connectionDirection =>
        connectionVariation site connectionDirection)
      (backwardCoframeVelocity shift coframeVariation site) := by
  apply (linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
    (1 : Matrix (Fin 4) (Fin 4) Real) 1 (by simp)
    (fun connectionDirection =>
      connectionVariation site connectionDirection)
    (backwardCoframeVelocity shift coframeVariation site)).mp
  intro direction component
  have hRaised :
      transportApply lorentzBivectorFundamentalSymmetry.matrix
        (linearizedAffineCovariantPalatiniResidual
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (fun connectionDirection =>
            connectionVariation site connectionDirection)
          (backwardCoframeVelocity shift coframeVariation site)
          direction) = 0 := by
    funext index
    let defectSequence : Nat -> Real := fun n =>
      nonuniformConnectionDefect shift
        (shrinkingNeighborLinkVariation connectionVariation
          neighborVariation site (scale n))
        site direction index
    have hDefect : Tendsto defectSequence atTop (nhds 0) := by
      exact nonuniformConnectionDefect_shrinkingNeighbor_tendsto_zero
        shift scale hScale connectionVariation neighborVariation site
          direction index
    have hDefectEq : defectSequence = fun _ =>
        2 * transportApply lorentzBivectorFundamentalSymmetry.matrix
          (linearizedAffineCovariantPalatiniResidual
            (1 : Matrix (Fin 4) (Fin 4) Real)
            (fun connectionDirection =>
              connectionVariation site connectionDirection)
            (backwardCoframeVelocity shift coframeVariation site)
            direction) index := by
      funext n
      have hDerivative :=
        (hasDerivAt_nonlinearLinkEulerCoefficient_eq_covariantResidual_add_defect
          shift
          (shrinkingNeighborLinkVariation connectionVariation
            neighborVariation site (scale n))
          coframeVariation site direction index).deriv
      have hStationaryAt := hStationary n direction index
      rw [hDerivative] at hStationaryAt
      simp only [shrinkingNeighborLinkVariation_center] at hStationaryAt
      dsimp only [defectSequence]
      linarith
    rw [hDefectEq] at hDefect
    have hTwiceZero :
        2 * transportApply lorentzBivectorFundamentalSymmetry.matrix
          (linearizedAffineCovariantPalatiniResidual
            (1 : Matrix (Fin 4) (Fin 4) Real)
            (fun connectionDirection =>
              connectionVariation site connectionDirection)
            (backwardCoframeVelocity shift coframeVariation site)
            direction) index = 0 :=
      tendsto_nhds_unique tendsto_const_nhds hDefect
    simp only [Pi.zero_apply]
    linarith
  exact congrFun
    ((transportApply_fundamentalSymmetry_eq_zero_iff _).mp hRaised)
    component

/-! ## Nonzero finite-spacing witness -/

/-- A single noncentral connection component on the period-two null-wave
carrier.  Its value at the selected center site `0` is zero. -/
def nonuniformDefectWitness : LinkVariation NullWaveSite :=
  fun site direction =>
    if site = 1 ∧ direction = 0 then
      Pi.single 0 (1 : Real)
    else
      0

/-- The neighboring-link correction is genuinely nonzero.  For the sparse
period-two witness, one exact Euler component equals `2`. -/
theorem nonuniformConnectionDefect_witness :
    nonuniformConnectionDefect nullWaveShift nonuniformDefectWitness
        0 1 4 = 2 := by
  unfold nonuniformConnectionDefect
  simp_rw [linearizedGeneratorFaceResponse_eq_pairs,
    coframeFaceWeight_identity_eq_coordinates]
  simp +decide [linkNeighborDifference, nonuniformDefectWitness,
    nullWaveShift, toggleFinTwo, identityPalatiniFaceCoordinates,
    lorentzTriplePair, kreinPair,
    lorentzBivectorFundamentalSymmetry_matrix, splitSixMatrix,
    Fin.sum_univ_four]
  ring

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.linearizedLinkEulerCoefficient_eq_covariantResidual_add_defect' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linearizedLinkEulerCoefficient_eq_covariantResidual_add_defect

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.hasDerivAt_nonlinearLinkEulerCoefficient_eq_covariantResidual_add_defect' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_nonlinearLinkEulerCoefficient_eq_covariantResidual_add_defect

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.nonuniformConnectionDefect_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonuniformConnectionDefect_witness

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.nonlinearLinkEulerCoefficient_shrinkingNeighbor_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearLinkEulerCoefficient_shrinkingNeighbor_torsionFree

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection
