# Claude model call log

## Metadata

- Provider: `Claude CLI`
- Model: `opus`
- Status: `failed`
- Dry run: `False`
- Started: `2026-07-18T21:00:56`
- Finished: `2026-07-18T21:01:10`
- Timeout seconds: `600`
- Max budget USD: `2.00`
- Return code: `1`

## Command

```text
claude -p --bare --model opus --max-budget-usd 2.00 --output-format text --add-dir 'C:\Projects\StandardModel' --tools default --permission-mode bypassPermissions --disallowed-tools 'Edit Write NotebookEdit mcp__neo4j_graph__write-cypher mcp__zotero_write' --mcp-config 'C:\Projects\StandardModel\Scripts\autonomous_loop\review.mcp.json' --strict-mcp-config
```

## Prompt

```text
You are reviewing a Lean 4 mathematical-physics result for semantic alignment, not merely kernel acceptance.\n\nProject context: this is a draft null-edge/lattice Palatini gravity formalization with mostly-minus signature, rotation-then-boost six-bivector coordinates, a Krein fundamental symmetry J, and a concrete nonlinear ordered-holonomy action. The intended new result is only an identity-background first-jet theorem, not a derivation of continuum GR.\n\nIntended reading:\n1. For an arbitrary site-dependent Lorentz-connection variation omega and coframe variation V at a selected site x, the derivative of each actual nonlinear link Euler coefficient along exact exponential-link and affine-coframe curves is\n   -2 * J * CartanResidual(omega(x), backwardDifference(V,x)) + D_x(omega),\n   where D_x is explicitly built only from neighboring-minus-center connection values.\n2. D_x vanishes for site-uniform omega, is invariant under adding a site-independent mode, is exactly homogeneous, and is genuinely nonzero (a period-two witness has one component equal to 2).\n3. If a centered neighbor mode is multiplied by a scalar sequence tending to zero, while the center connection value and coframe jet stay fixed, and all actual Euler derivatives are zero at every level, then the center Cartan torsion vanishes.\n4. This does NOT derive the shrinking law from smooth graph sampling, does not change carriers, does not work at a nonidentity base connection/coframe, and does not derive continuum Einstein gravity.\n\nAudit the verbatim Lean sources against the four repo overclaim modes: vacuity, hollow telescoping, docstring outruns kernel, and false shape. Check especially:\n- whether nonuniformConnectionDefect really contains only neighbor-minus-center data;\n- whether the decomposition is non-tautological;\n- whether the witness actually proves nonzero defect;\n- whether shrinkingNeighborLinkVariation secretly restores exact site uniformity or assumes torsion freedom;\n- whether stationarity plus Tendsto genuinely implies torsion freedom;\n- whether any signs/factors are hidden by a rewrite;\n- whether the prose claims more than the exact hypotheses.\n\nReturn:\nA. findings ordered Critical/High/Medium/Low with exact declaration references;\nB. a plain-language statement of exactly what is proved;\nC. concrete corrections if needed;\nD. publication-readiness verdict for this theorem package.\nDo not praise generally; be adversarial and precise.

## Verbatim source artifacts under review

These are the ACTUAL files. Base every finding on the real statements and definitions below, not on any paraphrase above. For each theorem under review, explicitly check whether the Lean matches its intended reading, and flag every mismatch.

### PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEulerNeighborDefect.lean (816 lines)

```lean
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

```

### PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEulerTorsionCancellation.lean (147 lines)

```lean
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

```

### PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEulerTorsionSelectionCapstone.lean (111 lines)

```lean
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionCancellation

noncomputable section

/-!
# Nonlinear link-Euler torsion-selection capstone

This short successor turns the component identity of
`NonlinearLorentzPalatiniEulerTorsionSelection` into the sitewise equivalence:
all derivatives of the actual nonlinear link Euler coefficients vanish if
and only if the globally site-constant connection variation and backward
coframe jets have zero linearized Cartan torsion.

The theorem has the same identity-background and first-jet scope as its
predecessor.  Claim label: finite first-jet identity.  Originality tag:
`[orig]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection

open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction

/-- **Actual nonlinear link-Euler first jets select Cartan torsion.**  At the
identity coframe and connection, all local nonlinear Euler derivatives vanish
if and only if the global zero-lattice-momentum connection variation and
backward coframe jets are covariantly torsion-free at every site. -/
theorem nonlinearLinkEulerCoefficient_derivatives_vanish_iff_torsionFree
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (hLinkConstant : forall x y, linkVariation x = linkVariation y) :
    (forall site direction component,
      deriv (fun t => nonlinearLinkEulerCoefficient shift
        (exponentialLinkCurve (identityConnection Site) linkVariation t)
        (coframeLine (identityCoframeField Site) coframeVariation t)
        site direction component) 0 = 0) <->
      forall site,
        LinearizedCovariantTorsionFree
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (fun connectionDirection =>
            linkVariation site connectionDirection)
          (backwardCoframeVelocity shift coframeVariation site) := by
  constructor
  · intro hEuler site
    apply (linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
      (1 : Matrix (Fin 4) (Fin 4) Real) 1 (by simp)
      (fun connectionDirection => linkVariation site connectionDirection)
      (backwardCoframeVelocity shift coframeVariation site)).mp
    intro direction component
    have hRaised :
        transportApply lorentzBivectorFundamentalSymmetry.matrix
          (linearizedAffineCovariantPalatiniResidual
            (1 : Matrix (Fin 4) (Fin 4) Real)
            (fun connectionDirection =>
              linkVariation site connectionDirection)
            (backwardCoframeVelocity shift coframeVariation site)
            direction) = 0 := by
      funext index
      have hDerivative :=
        (hasDerivAt_nonlinearLinkEulerCoefficient_eq_covariantPalatiniResidual
          shift linkVariation coframeVariation site
            (fun x => hLinkConstant x site) direction index).deriv
      have hComponent := hEuler site direction index
      rw [hDerivative] at hComponent
      simp only [Pi.zero_apply] at hComponent ⊢
      linarith
    exact congrFun
      ((transportApply_fundamentalSymmetry_eq_zero_iff _).mp hRaised)
      component
  · intro hTorsion site direction component
    have hResidual :=
      (linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
        (1 : Matrix (Fin 4) (Fin 4) Real) 1 (by simp)
        (fun connectionDirection => linkVariation site connectionDirection)
        (backwardCoframeVelocity shift coframeVariation site)).mpr
          (hTorsion site)
    rw [(hasDerivAt_nonlinearLinkEulerCoefficient_eq_covariantPalatiniResidual
      shift linkVariation coframeVariation site
        (fun x => hLinkConstant x site) direction component).deriv]
    have hResidualField :
        linearizedAffineCovariantPalatiniResidual
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (fun connectionDirection =>
            linkVariation site connectionDirection)
          (backwardCoframeVelocity shift coframeVariation site)
          direction = 0 := by
      funext index
      exact hResidual direction index
    rw [hResidualField]
    simp [transportApply]

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.nonlinearLinkEulerCoefficient_derivatives_vanish_iff_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearLinkEulerCoefficient_derivatives_vanish_iff_torsionFree

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection

```

### PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEulerTorsionSelection.lean (322 lines)

```lean
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

```

### PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniAffineConnectionTorsionSelection.lean (662 lines)

```lean
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection

noncomputable section

/-!
# Connection-dependent torsion selection from an affine Lorentz-link tangent

This module introduces the first connection-dependent torsion theorem in the
null-edge Palatini chain.  A six-component Lorentz connection velocity
`omega_b` supplies an infinitesimal four-vector generator and, through the
exterior-square/Hodge transport, an infinitesimal Palatini-face transport.
The Krein adjoint reverses the sign of that generator.  Consequently the
linear coefficient of the backward transported face difference is the
ordinary Palatini coframe response evaluated on

`V_b - lorentzGenerator(omega_b) * e`.

With predecessor increments `V_b = -partial_b e`, vanishing of the resulting
Cartan torsion is the usual equation `de + omega wedge e = 0` up to one overall
sign.  At every coframe with a supplied inverse, the twenty-four affine
connection equations therefore vanish exactly when this connection-dependent
torsion vanishes.

The exact finite affine residual has terms through order three in the spacing:

`h * linear + h^2 * quadratic - h^3 * cubic`.

This is a finite affine-tangent identity and a conditional shrinking-spacing
theorem.  The affine six-fiber transport is not yet an exact exponential
Lorentz link, and this module does not prove equivalence with the full
nonidentity nonlinear link Euler coefficients, nonlinear Levi-Civita
uniqueness, metric compatibility at finite spacing, graph refinement, or a
continuum limit.

Provenance: clean-room finite implementation of the standard first-order
Palatini connection equation `D(e wedge e) = 0 => de + omega wedge e = 0`,
with Kur and Glasser, *Discrete Gravity with Local Lorentz Invariance*
(arXiv:2202.02486, especially their continuum equation (14) and discrete
connection equations (28)-(29)), as the closest action/Euler-equation
comparator.  The definitions are specialized to the repository's
mostly-minus, orientation-`0123`, ordered-bivector, and
predecessor-difference conventions; no source implementation text is copied.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection

open Filter Topology
open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection

/-! ## Infinitesimal Palatini transport -/

/-- Polarized first variation at the identity of the quadratic Palatini
bivector transport. -/
def palatiniBivectorTransportFirstVariation
    (generator : Matrix (Fin 4) (Fin 4) Real) :
    Matrix (Fin 6) (Fin 6) Real :=
  palatiniBivectorTransport (1 + generator) -
    palatiniBivectorTransport 1 - palatiniBivectorTransport generator

/-- Polarized first variation at the identity of the exterior-square
four-vector transport. -/
def wedgeTwoTransportFirstVariation
    (generator : Matrix (Fin 4) (Fin 4) Real) :
    Matrix (Fin 6) (Fin 6) Real :=
  wedgeTwoTransport (1 + generator) -
    wedgeTwoTransport 1 - wedgeTwoTransport generator

/-- Hodge conjugation commutes with taking the polarized first variation. -/
theorem palatiniBivectorTransportFirstVariation_eq_hodgeConjugate
    (generator : Matrix (Fin 4) (Fin 4) Real) :
    palatiniBivectorTransportFirstVariation generator =
      -(lorentzHodgeStar * wedgeTwoTransportFirstVariation generator *
        lorentzHodgeStar) := by
  unfold palatiniBivectorTransportFirstVariation
    wedgeTwoTransportFirstVariation palatiniBivectorTransport
  noncomm_ring

/-- The conjugated Palatini transport of the identity matrix is the identity
on the six-component face fiber. -/
theorem palatiniBivectorTransport_one :
    palatiniBivectorTransport (1 : Matrix (Fin 4) (Fin 4) Real) = 1 := by
  have hWedge :
      wedgeTwoTransport (1 : Matrix (Fin 4) (Fin 4) Real) = 1 := by
    ext row column
    fin_cases row <;> fin_cases column <;>
      simp +decide [wedgeTwoTransport, bivectorFirst, bivectorSecond]
  unfold palatiniBivectorTransport
  rw [hWedge, Matrix.mul_one, lorentzHodgeStar_sq]
  simp

/-- Transport is linear in its matrix argument. -/
theorem transportApply_matrix_sub
    (left right : Matrix (Fin 6) (Fin 6) Real) (field : Fiber 6) :
    transportApply (left - right) field =
      transportApply left field - transportApply right field := by
  funext component
  simp [transportApply, Finset.sum_sub_distrib, sub_mul]

/-- Arbitrary internal basis covariance of an unpolarized Hodge-dual
Palatini face. -/
theorem palatiniFaceWeight_mul_arbitrary
    (matrix coframe : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    palatiniFaceWeight (matrix * coframe) first second =
      transportApply (palatiniBivectorTransport matrix)
        (palatiniFaceWeight coframe first second) := by
  unfold palatiniFaceWeight
  rw [coframeWedge_mul]
  simp only [transportApply_eq_mulVec, Matrix.mulVec_mulVec]
  rw [palatiniBivectorTransport_mul_lorentzHodgeStar]

/-- Arbitrary internal basis covariance of the complementary Palatini face. -/
theorem complementaryPalatiniFaceWeight_mul_arbitrary
    (matrix coframe : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    complementaryPalatiniFaceWeight (matrix * coframe) first second =
      transportApply (palatiniBivectorTransport matrix)
        (complementaryPalatiniFaceWeight coframe first second) := by
  rw [complementaryPalatiniFaceWeight_eq_double_sum,
    complementaryPalatiniFaceWeight_eq_double_sum]
  simp_rw [palatiniFaceWeight_mul_arbitrary]
  exact (transportApply_weightedDoubleSum_fin4
    (palatiniBivectorTransport matrix)
    (fun left right => (1 / 2 : Real) *
      spacetimeAlternatingSymbol left right first second)
    (fun left right => palatiniFaceWeight coframe left right)).symm

/-- The infinitesimal Palatini transport acting on a background face equals
the polarized face response generated by the corresponding internal coframe
change. -/
theorem transportApply_palatiniBivectorTransportFirstVariation
    (generator coframe : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    transportApply (palatiniBivectorTransportFirstVariation generator)
        (complementaryPalatiniFaceWeight coframe first second) =
      complementaryPalatiniFaceWeightFirstVariation coframe
        (generator * coframe) first second := by
  unfold palatiniBivectorTransportFirstVariation
  rw [transportApply_matrix_sub, transportApply_matrix_sub]
  rw [<- complementaryPalatiniFaceWeight_mul_arbitrary,
    <- complementaryPalatiniFaceWeight_mul_arbitrary,
    <- complementaryPalatiniFaceWeight_mul_arbitrary]
  have hMatrix :
      ((1 : Matrix (Fin 4) (Fin 4) Real) + generator) * coframe =
        coframe + generator * coframe := by
    simp [Matrix.add_mul]
  rw [hMatrix, Matrix.one_mul]
  have hLine := complementaryPalatiniFaceWeight_line coframe
    (generator * coframe) first second 1
  norm_num at hLine
  rw [hLine]
  module

/-- A first connection jet: one six-component Lorentz generator coordinate
for each null-edge direction. -/
abbrev LorentzConnectionVelocity := Fin 4 -> Fiber 6

/-- Physical infinitesimal action of one Lorentz connection coordinate on
the Hodge-dual Palatini face fiber. -/
def physicalPalatiniTransportTangent (connection : Fiber 6) :
    Matrix (Fin 6) (Fin 6) Real :=
  palatiniBivectorTransportFirstVariation (lorentzGenerator connection)

/-- Explicit matrix of the infinitesimal Palatini-face representation in the
ordered rotation-then-boost basis.  Displaying this matrix makes the physical
connection convention and every sign in the Krein audit reviewable. -/
def explicitPhysicalPalatiniTransportTangent (connection : Fiber 6) :
    Matrix (Fin 6) (Fin 6) Real :=
  !![0, -connection 2, connection 1, connection 4, -connection 3, 0;
     connection 2, 0, -connection 0, connection 5, 0, -connection 3;
     -connection 1, connection 0, 0, 0, connection 5, -connection 4;
     connection 4, connection 5, 0, 0, -connection 0, -connection 1;
     -connection 3, 0, connection 5, connection 0, 0, -connection 2;
     0, -connection 3, -connection 4, connection 1, connection 2, 0]

/-- The first variation of the exterior-square transport at a physical
Lorentz generator is the displayed six-dimensional generator. -/
theorem wedgeTwoTransportFirstVariation_lorentzGenerator
    (connection : Fiber 6) :
    wedgeTwoTransportFirstVariation (lorentzGenerator connection) =
      explicitPhysicalPalatiniTransportTangent connection := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp +decide [wedgeTwoTransportFirstVariation,
      explicitPhysicalPalatiniTransportTangent, lorentzGenerator,
      bivectorMatrix, wedgeTwoTransport,
      bivectorFirst, bivectorSecond, MinkowskiConvention.eta]

set_option maxHeartbeats 1000000 in
/-- The displayed six-dimensional Lorentz generator commutes with the
Lorentzian Hodge star. -/
theorem lorentzHodgeStar_mul_explicitPhysicalPalatiniTransportTangent
    (connection : Fiber 6) :
    lorentzHodgeStar * explicitPhysicalPalatiniTransportTangent connection =
      explicitPhysicalPalatiniTransportTangent connection * lorentzHodgeStar := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp +decide [explicitPhysicalPalatiniTransportTangent,
      lorentzHodgeStar]

/-- The transport tangent obtained by polarizing the quadratic Hodge/exterior
square construction is exactly the displayed Lorentz-algebra matrix. -/
theorem physicalPalatiniTransportTangent_eq_explicit
    (connection : Fiber 6) :
    physicalPalatiniTransportTangent connection =
      explicitPhysicalPalatiniTransportTangent connection := by
  unfold physicalPalatiniTransportTangent
  rw [palatiniBivectorTransportFirstVariation_eq_hodgeConjugate,
    wedgeTwoTransportFirstVariation_lorentzGenerator]
  rw [lorentzHodgeStar_mul_explicitPhysicalPalatiniTransportTangent,
    Matrix.mul_assoc, lorentzHodgeStar_sq]
  simp

/-- The physical Palatini transport tangent is skew for the derived Krein
metric.  This pins the minus sign in the backward adjoint connection term. -/
theorem physicalPalatiniTransportTangent_kreinSkew
    (connection : Fiber 6) :
    lorentzBivectorFundamentalSymmetry.matrix *
        (physicalPalatiniTransportTangent connection).transpose *
          lorentzBivectorFundamentalSymmetry.matrix =
      -physicalPalatiniTransportTangent connection := by
  rw [lorentzBivectorFundamentalSymmetry_matrix,
    physicalPalatiniTransportTangent_eq_explicit]
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp +decide [explicitPhysicalPalatiniTransportTangent,
      splitSixMatrix, splitSixSign, Matrix.mul_apply,
      Matrix.transpose_apply, Fin.sum_univ_six]

/-- The Krein adjoint of an affine physical transport has the opposite
infinitesimal generator. -/
theorem kreinAdjointApply_one_add_physicalTangent
    (connection : Fiber 6) (spacing : Real) (field : Fiber 6) :
    kreinAdjointApply lorentzBivectorFundamentalSymmetry
        (1 + spacing • physicalPalatiniTransportTangent connection) field =
      field - spacing •
        transportApply (physicalPalatiniTransportTangent connection) field := by
  have hMatrix :
      lorentzBivectorFundamentalSymmetry.matrix *
          (1 + spacing • physicalPalatiniTransportTangent connection).transpose *
            lorentzBivectorFundamentalSymmetry.matrix =
        1 - spacing • physicalPalatiniTransportTangent connection := by
    rw [Matrix.transpose_add, Matrix.transpose_one, Matrix.transpose_smul]
    simp only [Matrix.add_mul, Matrix.mul_add, Matrix.smul_mul,
      Matrix.mul_smul]
    rw [show lorentzBivectorFundamentalSymmetry.matrix *
          (1 : Matrix (Fin 6) (Fin 6) Real) *
            lorentzBivectorFundamentalSymmetry.matrix = 1 by
      simp only [Matrix.mul_one]
      rw [lorentzBivectorFundamentalSymmetry_matrix,
        splitSixMatrix_mul_self]]
    rw [physicalPalatiniTransportTangent_kreinSkew]
    module
  unfold kreinAdjointApply
  rw [transportApply_eq_mulVec, transportAdjointApply_eq_transpose_mulVec,
    transportApply_eq_mulVec]
  simp only [Matrix.mulVec_mulVec]
  rw [<- Matrix.mul_assoc]
  rw [hMatrix, Matrix.sub_mulVec, Matrix.one_mulVec, Matrix.smul_mulVec]
  rfl

/-! ## Connection-dependent linear residual and torsion -/

/-- Coframe first jet after subtracting the infinitesimal forward Lorentz
transport.  With predecessor increments this is minus the usual covariant
coframe derivative. -/
def covariantCoframeVelocity
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity) :
    CoframeVelocity :=
  fun direction =>
    velocity direction - lorentzGenerator (connection direction) * coframe

/-- Cartan torsion including the first-order Lorentz connection term. -/
def linearizedCovariantCartanTorsion
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (internal first second : Fin 4) : Real :=
  linearizedCartanTorsion
    (covariantCoframeVelocity coframe connection velocity)
      internal first second

/-- Every component of the connection-dependent linearized Cartan torsion
vanishes. -/
def LinearizedCovariantTorsionFree
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity)
    (velocity : CoframeVelocity) : Prop :=
  forall internal first second,
    linearizedCovariantCartanTorsion coframe connection velocity
      internal first second = 0

/-- Explicit component shape of `de + omega wedge e`, with the overall sign
fixed by predecessor rather than forward coframe increments. -/
theorem linearizedCovariantCartanTorsion_eq
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (internal first second : Fin 4) :
    linearizedCovariantCartanTorsion coframe connection velocity
        internal first second =
      velocity first internal second - velocity second internal first -
        (lorentzGenerator (connection first) * coframe) internal second +
          (lorentzGenerator (connection second) * coframe) internal first := by
  unfold linearizedCovariantCartanTorsion covariantCoframeVelocity
    linearizedCartanTorsion
  simp only [Matrix.sub_apply]
  ring

/-- Linear coefficient of the affine Krein-backward Palatini residual. -/
def linearizedAffineCovariantPalatiniResidual
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      complementaryPalatiniFaceWeightFirstVariation coframe
          (velocity backwardDirection) direction backwardDirection component -
        transportApply
          (physicalPalatiniTransportTangent (connection backwardDirection))
          (complementaryPalatiniFaceWeight coframe direction backwardDirection)
          component)

/-- The connection term combines with the coframe first jet into the ordinary
Palatini residual of the covariant coframe velocity. -/
theorem linearizedAffineCovariantPalatiniResidual_eq
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (direction : Fin 4) :
    linearizedAffineCovariantPalatiniResidual coframe connection velocity
        direction =
      linearizedPalatiniConnectionResidual coframe
        (covariantCoframeVelocity coframe connection velocity) direction := by
  funext component
  unfold linearizedAffineCovariantPalatiniResidual
    linearizedPalatiniConnectionResidual covariantCoframeVelocity
  apply Finset.sum_congr rfl
  intro backwardDirection _
  unfold physicalPalatiniTransportTangent
  rw [transportApply_palatiniBivectorTransportFirstVariation]
  rw [show velocity backwardDirection -
          lorentzGenerator (connection backwardDirection) * coframe =
        velocity backwardDirection +
          (-1 : Real) •
            (lorentzGenerator (connection backwardDirection) * coframe) by
      module]
  rw [complementaryPalatiniFaceWeightFirstVariation_add,
    complementaryPalatiniFaceWeightFirstVariation_smul]
  simp
  ring

/-- **Affine connection-dependent Palatini equation equals zero torsion.**
At every coframe with a supplied inverse, all twenty-four first-order
Krein-backward connection coefficients vanish exactly when
`de + omega wedge e` vanishes. -/
theorem linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity) :
    (forall direction component,
      linearizedAffineCovariantPalatiniResidual coframe connection velocity
        direction component = 0) <->
      LinearizedCovariantTorsionFree coframe connection velocity := by
  rw [show LinearizedCovariantTorsionFree coframe connection velocity =
      LinearizedTorsionFree
        (covariantCoframeVelocity coframe connection velocity) by rfl]
  simp_rw [linearizedAffineCovariantPalatiniResidual_eq]
  exact linearizedPalatiniConnectionResidual_invertible_iff_torsionFree
    coframe inverseCoframe hLeft
      (covariantCoframeVelocity coframe connection velocity)

/-! ## Exact affine finite-spacing residual -/

/-- Quadratic coefficient in the affine-link finite residual.  Its second
term is the mixed action of the connection tangent on the polarized coframe
face. -/
def quadraticAffineCovariantPalatiniResidual
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      complementaryPalatiniFaceWeight (velocity backwardDirection)
          direction backwardDirection component -
        transportApply
          (physicalPalatiniTransportTangent (connection backwardDirection))
          (complementaryPalatiniFaceWeightFirstVariation coframe
            (velocity backwardDirection) direction backwardDirection)
          component)

/-- Cubic coefficient in the affine-link finite residual.  This is the
connection tangent acting on the face quadratic in the coframe jet. -/
def cubicAffineCovariantPalatiniResidual
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      transportApply
        (physicalPalatiniTransportTangent (connection backwardDirection))
        (complementaryPalatiniFaceWeight (velocity backwardDirection)
          direction backwardDirection) component)

/-- Exact local backward Palatini residual for affine physical link transport
`1 + h A(omega_b)` and predecessor coframe `e + h V_b`. -/
def finiteAffineCovariantPalatiniResidual
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (spacing : Real) (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      kreinAdjointApply lorentzBivectorFundamentalSymmetry
          (1 + spacing • physicalPalatiniTransportTangent
            (connection backwardDirection))
          (complementaryPalatiniFaceWeight
            (coframe + spacing • velocity backwardDirection)
            direction backwardDirection) component -
        complementaryPalatiniFaceWeight coframe direction backwardDirection
          component)

/-- One transported predecessor face has an exact cubic expansion. -/
theorem affineTransportedComplementaryFace_scaled
    (coframe velocity : Matrix (Fin 4) (Fin 4) Real)
    (connection : Fiber 6) (spacing : Real) (first second : Fin 4) :
    kreinAdjointApply lorentzBivectorFundamentalSymmetry
          (1 + spacing • physicalPalatiniTransportTangent connection)
          (complementaryPalatiniFaceWeight
            (coframe + spacing • velocity) first second) -
        complementaryPalatiniFaceWeight coframe first second =
      spacing •
          (complementaryPalatiniFaceWeightFirstVariation coframe velocity
              first second -
            transportApply (physicalPalatiniTransportTangent connection)
              (complementaryPalatiniFaceWeight coframe first second)) +
        spacing ^ 2 •
          (complementaryPalatiniFaceWeight velocity first second -
            transportApply (physicalPalatiniTransportTangent connection)
              (complementaryPalatiniFaceWeightFirstVariation coframe velocity
                first second)) -
        spacing ^ 3 •
          transportApply (physicalPalatiniTransportTangent connection)
            (complementaryPalatiniFaceWeight velocity first second) := by
  rw [kreinAdjointApply_one_add_physicalTangent,
    complementaryPalatiniFaceWeight_line]
  rw [transportApply_add_local, transportApply_add_local,
    transportApply_smul_local, transportApply_smul_local]
  funext component
  simp only [Pi.add_apply, Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
  ring

/-- Exact affine lattice product rule.  Simultaneously varying the quadratic
coframe face and the affine link produces linear, quadratic, and cubic
spacing coefficients and no higher terms. -/
theorem finiteAffineCovariantPalatiniResidual_scaled
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (spacing : Real) (direction : Fin 4) :
    finiteAffineCovariantPalatiniResidual coframe connection velocity spacing
        direction =
      spacing • linearizedAffineCovariantPalatiniResidual coframe connection
          velocity direction +
        spacing ^ 2 • quadraticAffineCovariantPalatiniResidual coframe
          connection velocity direction -
        spacing ^ 3 • cubicAffineCovariantPalatiniResidual connection velocity
          direction := by
  funext component
  unfold finiteAffineCovariantPalatiniResidual
    linearizedAffineCovariantPalatiniResidual
    quadraticAffineCovariantPalatiniResidual
    cubicAffineCovariantPalatiniResidual
  have hTerm (backwardDirection : Fin 4) :
      kreinAdjointApply lorentzBivectorFundamentalSymmetry
            (1 + spacing • physicalPalatiniTransportTangent
              (connection backwardDirection))
            (complementaryPalatiniFaceWeight
              (coframe + spacing • velocity backwardDirection)
              direction backwardDirection) component -
          complementaryPalatiniFaceWeight coframe direction backwardDirection
            component =
        spacing *
            (complementaryPalatiniFaceWeightFirstVariation coframe
                (velocity backwardDirection) direction backwardDirection
                  component -
              transportApply
                (physicalPalatiniTransportTangent
                  (connection backwardDirection))
                (complementaryPalatiniFaceWeight coframe direction
                  backwardDirection) component) +
          spacing ^ 2 *
            (complementaryPalatiniFaceWeight (velocity backwardDirection)
                direction backwardDirection component -
              transportApply
                (physicalPalatiniTransportTangent
                  (connection backwardDirection))
                (complementaryPalatiniFaceWeightFirstVariation coframe
                  (velocity backwardDirection) direction backwardDirection)
                component) -
          spacing ^ 3 *
            transportApply
              (physicalPalatiniTransportTangent
                (connection backwardDirection))
              (complementaryPalatiniFaceWeight (velocity backwardDirection)
                direction backwardDirection) component := by
    have hFace := congrFun
      (affineTransportedComplementaryFace_scaled coframe
      (velocity backwardDirection) (connection backwardDirection) spacing
        direction backwardDirection) component
    simpa only [Pi.add_apply, Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
      using hFace
  simp_rw [hTerm]
  simp only [Pi.add_apply, Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
  simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib]
  simp_rw [<- Finset.mul_sum]
  simp only [Finset.sum_sub_distrib]

/-- Exact affine residuals vanishing along nonzero spacings tending to zero
force the connection-dependent linear coefficient to vanish. -/
theorem finiteAffineCovariantPalatiniResidual_scaled_limit
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (spacing : Nat -> Real) (hNonzero : forall n, spacing n ≠ 0)
    (hToZero : Tendsto spacing atTop (nhds 0))
    (hResidual : forall n direction component,
      finiteAffineCovariantPalatiniResidual coframe connection velocity
        (spacing n) direction component = 0) :
    forall direction component,
      linearizedAffineCovariantPalatiniResidual coframe connection velocity
        direction component = 0 := by
  intro direction component
  let linear := linearizedAffineCovariantPalatiniResidual coframe connection
    velocity direction component
  let quadratic := quadraticAffineCovariantPalatiniResidual coframe connection
    velocity direction component
  let cubic := cubicAffineCovariantPalatiniResidual connection velocity
    direction component
  have hFactor (n : Nat) :
      linear + spacing n * quadratic - spacing n ^ 2 * cubic = 0 := by
    have h := hResidual n direction component
    rw [finiteAffineCovariantPalatiniResidual_scaled] at h
    change spacing n * linear + spacing n ^ 2 * quadratic -
      spacing n ^ 3 * cubic = 0 at h
    have hProduct :
        spacing n *
            (linear + spacing n * quadratic - spacing n ^ 2 * cubic) = 0 := by
      calc
        spacing n *
            (linear + spacing n * quadratic - spacing n ^ 2 * cubic) =
          spacing n * linear + spacing n ^ 2 * quadratic -
            spacing n ^ 3 * cubic := by ring
        _ = 0 := h
    exact (mul_eq_zero.mp hProduct).resolve_left (hNonzero n)
  have hLimit :
      Tendsto
        (fun n => linear + spacing n * quadratic - spacing n ^ 2 * cubic)
        atTop (nhds linear) := by
    simpa [pow_two] using
      (tendsto_const_nhds.add (hToZero.mul tendsto_const_nhds)).sub
        ((hToZero.mul hToZero).mul tendsto_const_nhds)
  have hZero :
      Tendsto
        (fun n => linear + spacing n * quadratic - spacing n ^ 2 * cubic)
        atTop (nhds 0) := by
    convert tendsto_const_nhds using 1
    funext n
    exact hFactor n
  exact tendsto_nhds_unique hLimit hZero

/-- **Affine connection-dependent shrinking-spacing endpoint.**  At a fixed
invertible coframe, exact affine local connection equations along nonzero
shrinking spacings force `de + omega wedge e = 0` for the fixed first jet. -/
theorem finiteAffineCovariantPalatiniResidual_invertible_limit_torsionFree
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (spacing : Nat -> Real) (hNonzero : forall n, spacing n ≠ 0)
    (hToZero : Tendsto spacing atTop (nhds 0))
    (hResidual : forall n direction component,
      finiteAffineCovariantPalatiniResidual coframe connection velocity
        (spacing n) direction component = 0) :
    LinearizedCovariantTorsionFree coframe connection velocity := by
  rw [<- linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
    coframe inverseCoframe hLeft connection velocity]
  exact finiteAffineCovariantPalatiniResidual_scaled_limit coframe connection
    velocity spacing hNonzero hToZero hResidual

/-! ## Explicit nonvacuity family -/

/-- A coframe jet generated entirely by the supplied Lorentz connection has
zero covariant coframe velocity. -/
theorem covariantCoframeVelocity_connectionGenerated
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) :
    covariantCoframeVelocity coframe connection
        (fun direction => lorentzGenerator (connection direction) * coframe) =
      0 := by
  funext direction
  simp [covariantCoframeVelocity]

/-- The connection-generated jet is an explicit family satisfying all
connection-dependent Cartan torsion equations. -/
theorem connectionGeneratedVelocity_covariantTorsionFree
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) :
    LinearizedCovariantTorsionFree coframe connection
      (fun direction => lorentzGenerator (connection direction) * coframe) := by
  rw [show LinearizedCovariantTorsionFree coframe connection
        (fun direction => lorentzGenerator (connection direction) * coframe) =
      LinearizedTorsionFree
        (covariantCoframeVelocity coframe connection
          (fun direction =>
            lorentzGenerator (connection direction) * coframe)) by rfl]
  rw [covariantCoframeVelocity_connectionGenerated]
  intro internal first second
  simp [linearizedCartanTorsion]

/-- At every supplied invertible coframe, the connection-generated jet gives
an explicit solution of all twenty-four affine linearized Palatini equations.
-/
theorem connectionGeneratedVelocity_affineResidual_zero
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (connection : LorentzConnectionVelocity) :
    forall direction component,
      linearizedAffineCovariantPalatiniResidual coframe connection
        (fun backwardDirection =>
          lorentzGenerator (connection backwardDirection) * coframe)
        direction component = 0 := by
  rw [linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
    coframe inverseCoframe hLeft]
  exact connectionGeneratedVelocity_covariantTorsionFree coframe connection

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection.physicalPalatiniTransportTangent_kreinSkew' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physicalPalatiniTransportTangent_kreinSkew

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection.linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection.finiteAffineCovariantPalatiniResidual_scaled' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finiteAffineCovariantPalatiniResidual_scaled

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection.finiteAffineCovariantPalatiniResidual_invertible_limit_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finiteAffineCovariantPalatiniResidual_invertible_limit_torsionFree

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection.connectionGeneratedVelocity_affineResidual_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms connectionGeneratedVelocity_affineResidual_zero

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection

```

## Final instruction

Produce your review now, strictly in the Required output format specified above.
```

## Response stdout

```text
Credit balance is too low

```

## Response stderr

```text

```
