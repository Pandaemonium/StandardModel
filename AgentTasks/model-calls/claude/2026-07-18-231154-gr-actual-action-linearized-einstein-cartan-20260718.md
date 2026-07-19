# Claude model call log

## Metadata

- Provider: `Claude CLI`
- Model: `opus`
- Status: `failed`
- Dry run: `False`
- Started: `2026-07-18T23:11:45`
- Finished: `2026-07-18T23:11:54`
- Timeout seconds: `600`
- Max budget USD: `2.50`
- Return code: `1`

## Command

```text
claude -p --bare --model opus --max-budget-usd 2.50 --output-format text --add-dir 'C:\Projects\StandardModel' --tools default --permission-mode bypassPermissions --disallowed-tools 'Edit Write NotebookEdit mcp__neo4j_graph__write-cypher mcp__zotero_write' --mcp-config 'C:\Projects\StandardModel\Scripts\autonomous_loop\review.mcp.json' --strict-mcp-config
```

## Prompt

```text
Hostile semantic audit of a flagship Draft Lean result in a null-edge discrete Palatini gravity program. The intended reading is: both formal identity-background linearized Euler sectors are derivatives of the nonlinear Euler maps of one concrete scalar finite Palatini action along the same simultaneous exponential-link/affine-coframe curve; on a supplied two-sided affine changing-carrier refinement, exact vanishing of those actual derivatives at every level implies the limiting exterior-derivative curvature satisfies the identity-background mixed vacuum Einstein equation and the limiting sampled coframe jet satisfies the covariant Cartan torsion equation. Audit the exact declarations and dependencies verbatim. Check especially: (1) whether nonlinearLinkEulerCoefficient and nonlinearCoframeEulerCoefficient are truly partial Euler maps of the same scalar action; (2) whether the new coframe derivative theorem has the correct perturbative order and does not silently discard a first-order coframe term; (3) whether ActualActionLinearizedJointStationary is equivalent to the existing joint Hessian system without vacuity; (4) whether scaling and Tendsto arguments in sampledLinearizedJointStationary_einstein_and_cartan prove the displayed conclusion; (5) vacuity, hollow telescoping, docstring-outruns-kernel, false shape, hidden assumptions, convention drift, and missing nontrivial witnesses. Do not edit files. Return findings first, ordered by severity with exact declaration names and line references; then a verdict on the strongest defensible claim; then smallest required fixes before commit/publication.

## Verbatim source artifacts under review

These are the ACTUAL files. Base every finding on the real statements and definitions below, not on any paraphrase above. For each theorem under review, explicitly check whether the Lean matches its intended reading, and flag every mismatch.

### PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniLinearizedEinsteinCartanLimit.lean (550 lines)

```lean
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerSampledCoframeTorsion
import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction

noncomputable section

open scoped Matrix.Norms.Frobenius

/-!
# Joint sampled linearized Einstein-Cartan limit

The nonlinear null-edge Palatini action has two independent Euler sectors.  Its
coframe equation is an exact finite mixed Einstein equation, while the first
variation of its link equation selects Cartan torsion at the identity
connection/coframe background.  Earlier changing-carrier limits treated these
sectors separately and at different perturbative orders.

This module gives one order-consistent composition.  A differentiable Lorentz
connection and tetrad are sampled on the same changing finite carriers.  Exact
forward affine rays turn the inverse-spacing-normalized additive plaquette curl
into the exterior derivative of the connection.  Exact predecessor affine rays
turn scaled tetrad differences into the signed coframe jet used by the Cartan
equation.  Both linearized Euler sectors are proved to be derivatives of the
same nonlinear finite action's Euler maps along one simultaneous field curve.
If those derivatives vanish at every refinement level, then the limiting data
obey both the identity-background linearized vacuum Einstein equation and the
covariant Cartan torsion equation.

The result is a local consistency theorem, not a derivation from bare causal
order.  The chart, two-sided affine stencil, inverse spacing, tangent frame,
differentiable fields, and finite linearized stationarity remain hypotheses.
The curvature is `dA`, not the nonlinear `dA + A wedge A`; the background
coframe and links are the identity; no propagation, compactness, stability, or
nonlinear Levi-Civita uniqueness theorem is claimed.

Claim label: conditional changing-carrier linearized Einstein-Cartan
consistency theorem.  Originality tag: `[orig]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedEinsteinCartanLimit

open Filter Topology
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction

/-! ## Actual-action bridge for the linearized coframe equation -/

/-- The polarized coframe wedge is symmetric in its two matrix arguments. -/
theorem coframeWedgeFirstVariation_comm_local
    (left right : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    coframeWedgeFirstVariation left right a b =
      coframeWedgeFirstVariation right left a b := by
  funext component
  simp only [coframeWedgeFirstVariation]
  ring

/-- The Hodge-dualized polarized face is symmetric in its two coframe
arguments. -/
theorem palatiniFaceWeightFirstVariation_comm_local
    (left right : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    palatiniFaceWeightFirstVariation left right a b =
      palatiniFaceWeightFirstVariation right left a b := by
  unfold palatiniFaceWeightFirstVariation
  rw [coframeWedgeFirstVariation_comm_local]

/-- The complementary polarized Palatini face is symmetric in its two
coframe arguments. -/
theorem complementaryPalatiniFaceWeightFirstVariation_comm_local
    (left right : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    complementaryPalatiniFaceWeightFirstVariation left right a b =
      complementaryPalatiniFaceWeightFirstVariation right left a b := by
  funext component
  unfold complementaryPalatiniFaceWeightFirstVariation
  simp_rw [palatiniFaceWeightFirstVariation_comm_local]

/-- At fixed coframe probe, the polarized complementary face varies affinely
with its background coframe. -/
theorem hasDerivAt_complementaryPalatiniFaceWeightFirstVariation_line_local
    (coframe variation probe : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) :
    HasDerivAt
      (fun t : Real => complementaryPalatiniFaceWeightFirstVariation
        (coframe + t • variation) probe a b)
      (complementaryPalatiniFaceWeightFirstVariation variation probe a b) 0 := by
  have hAffine : (fun t : Real =>
      complementaryPalatiniFaceWeightFirstVariation
        (coframe + t • variation) probe a b) =
      fun t => complementaryPalatiniFaceWeightFirstVariation coframe probe a b +
        t • complementaryPalatiniFaceWeightFirstVariation variation probe a b := by
    funext t
    rw [complementaryPalatiniFaceWeightFirstVariation_comm_local]
    rw [complementaryPalatiniFaceWeightFirstVariation_add]
    rw [complementaryPalatiniFaceWeightFirstVariation_smul]
    rw [complementaryPalatiniFaceWeightFirstVariation_comm_local
      probe coframe]
    rw [complementaryPalatiniFaceWeightFirstVariation_comm_local
      probe variation]
  have hDerivative : HasDerivAt
      (fun t : Real => complementaryPalatiniFaceWeightFirstVariation
          coframe probe a b +
        t • complementaryPalatiniFaceWeightFirstVariation variation probe a b)
      (complementaryPalatiniFaceWeightFirstVariation variation probe a b) 0 := by
    simpa using
      ((hasDerivAt_id (𝕜 := Real) 0).smul_const
        (complementaryPalatiniFaceWeightFirstVariation variation probe a b)).const_add
          (complementaryPalatiniFaceWeightFirstVariation coframe probe a b)
  apply hDerivative.congr_of_eventuallyEq
  filter_upwards with t
  exact congrFun hAffine t

/-- When the plaquette holonomy is the identity at the expansion point, the
derivative of a varying-face ordered action term depends only on the base face
and the holonomy tangent.  The face derivative multiplies `H - I = 0`. -/
theorem hasDerivAt_orderedPlaquetteActionTerm_varyingFace_identity
    (faceCurve : Real -> (Fin 6 -> Real)) (faceVariation : Fin 6 -> Real)
    (holonomyCurve : Real -> GL4)
    (holonomyVariation : Matrix (Fin 4) (Fin 4) Real)
    (hFace : HasDerivAt faceCurve faceVariation 0)
    (hHolonomyZero : holonomyCurve 0 = 1)
    (hHolonomy : HasDerivAt (fun t => unitMatrix (holonomyCurve t))
      holonomyVariation 0) :
    HasDerivAt
      (fun t => orderedPlaquetteActionTerm (faceCurve t) (holonomyCurve t))
      (orderedPlaquetteActionFirstResponse (faceCurve 0) holonomyVariation) 0 := by
  have hFaceGenerator := hasDerivAt_lorentzGenerator
    faceCurve faceVariation hFace
  have hHolonomyDifference := hHolonomy.sub_const
    (1 : Matrix (Fin 4) (Fin 4) Real)
  have hProduct := hFaceGenerator.mul hHolonomyDifference
  have hTrace := hasDerivAt_matrixTrace _ _ 0 hProduct
  have hResponse := hTrace.const_mul (-(1 / 2 : Real))
  simpa [orderedPlaquetteActionTerm, orderedPlaquetteActionFirstResponse,
    hHolonomyZero, unitMatrix] using hResponse

/-- Every coordinate of the formal linearized coframe equation is the actual
derivative of the corresponding nonlinear coframe Euler coefficient along the
same simultaneous exponential-link and affine-coframe curve used by the link
equation. -/
theorem hasDerivAt_nonlinearCoframeEulerCoefficient_identity
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (internal direction : Fin 4) :
    HasDerivAt
      (fun t => nonlinearCoframeEulerCoefficient shift
        (exponentialLinkCurve (identityConnection Site) linkVariation t)
        (coframeLine (identityCoframeField Site) coframeVariation t)
        site internal direction)
      (linearizedCoframeEulerCoefficient shift linkVariation
        site internal direction) 0 := by
  let linkCurve := exponentialLinkCurve
    (identityConnection Site) linkVariation
  let coframeCurve := coframeLine
    (identityCoframeField Site) coframeVariation
  let probe := Matrix.single internal direction (1 : Real)
  have hCurveZero : linkCurve 0 = identityConnection Site := by
    simp [linkCurve]
  have hCoframeZero : coframeCurve 0 = identityCoframeField Site := by
    funext x
    simp [coframeCurve, coframeLine]
  have hPlaquetteZero (a b : Fin 4) :
      plaquetteUnit shift (linkCurve 0) site a b = 1 := by
    rw [hCurveZero]
    simp [plaquetteUnit, plaquetteHolonomy, twoStepTransport,
      identityConnection]
  have hLink (x : Site) (a : Fin 4) :
      HasDerivAt (fun t => unitMatrix (linkCurve t x a))
        (linkMatrixVariation (identityConnection Site) linkVariation x a) 0 := by
    simpa [linkCurve] using hasDerivAt_exponentialLinkCurve
      (identityConnection Site) linkVariation x a
  have hPlaquette (a b : Fin 4) :
      HasDerivAt (fun t => unitMatrix
        (plaquetteUnit shift (linkCurve t) site a b))
        (plaquetteMatrixVariation shift (identityConnection Site)
          linkVariation site a b) 0 :=
    hasDerivAt_plaquetteUnit_curve shift linkCurve (identityConnection Site)
      linkVariation hCurveZero hLink site a b
  have hFace (a b : Fin 4) : HasDerivAt
      (fun t => complementaryPalatiniFaceWeightFirstVariation
        (coframeCurve t site) probe a b)
      (complementaryPalatiniFaceWeightFirstVariation
        (coframeVariation site) probe a b) 0 := by
    simpa [coframeCurve, coframeLine] using
      hasDerivAt_complementaryPalatiniFaceWeightFirstVariation_line_local
        ((identityCoframeField Site) site) (coframeVariation site) probe a b
  have hTerm (a b : Fin 4) :=
    hasDerivAt_orderedPlaquetteActionTerm_varyingFace_identity
      (fun t => complementaryPalatiniFaceWeightFirstVariation
        (coframeCurve t site) probe a b)
      (complementaryPalatiniFaceWeightFirstVariation
        (coframeVariation site) probe a b)
      (fun t => plaquetteUnit shift (linkCurve t) site a b)
      (plaquetteMatrixVariation shift (identityConnection Site)
        linkVariation site a b)
      (hFace a b) (hPlaquetteZero a b) (hPlaquette a b)
  have hInner (a : Fin 4) := HasDerivAt.sum (u := Finset.univ) fun b _ =>
    hTerm a b
  have hTotal := HasDerivAt.sum (u := Finset.univ) fun a _ => hInner a
  simpa [linkCurve, coframeCurve, probe, nonlinearCoframeEulerCoefficient,
    nonlinearCoframeLocalEulerLinearMap, nonlinearCoframeLocalEulerFunctional,
    linearizedCoframeEulerCoefficient, linearizedCoframeEulerFunctional,
    hCoframeZero] using hTotal

/-- Vanishing first derivatives of both nonlinear Euler maps along one
identity-background perturbation of the concrete finite Palatini action. -/
def ActualActionLinearizedJointStationary
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site) : Prop :=
  (forall site direction component,
    deriv (fun t => nonlinearLinkEulerCoefficient shift
      (exponentialLinkCurve (identityConnection Site) linkVariation t)
      (coframeLine (identityCoframeField Site) coframeVariation t)
      site direction component) 0 = 0) /\
  (forall site internal direction,
    deriv (fun t => nonlinearCoframeEulerCoefficient shift
      (exponentialLinkCurve (identityConnection Site) linkVariation t)
      (coframeLine (identityCoframeField Site) coframeVariation t)
      site internal direction) 0 = 0)

/-- Actual-action derivative stationarity is exactly the existing formal
linearized joint Euler system. -/
theorem actualActionLinearizedJointStationary_iff
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site) :
    ActualActionLinearizedJointStationary shift linkVariation coframeVariation <->
      LinearizedJointStationary shift linkVariation coframeVariation := by
  constructor
  · intro hActual
    constructor
    · intro site direction component
      rw [<- (hasDerivAt_nonlinearLinkEulerCoefficient_identity shift
        linkVariation coframeVariation site direction component).deriv]
      exact hActual.1 site direction component
    · intro site internal direction
      rw [<- (hasDerivAt_nonlinearCoframeEulerCoefficient_identity shift
        linkVariation coframeVariation site internal direction).deriv]
      exact hActual.2 site internal direction
  · intro hLinearized
    constructor
    · intro site direction component
      rw [(hasDerivAt_nonlinearLinkEulerCoefficient_identity shift
        linkVariation coframeVariation site direction component).deriv]
      exact hLinearized.1 site direction component
    · intro site internal direction
      rw [(hasDerivAt_nonlinearCoframeEulerCoefficient_identity shift
        linkVariation coframeVariation site internal direction).deriv]
      exact hLinearized.2 site internal direction

/-! ## Linearized coframe equation as the vacuum Einstein equation -/

/-- At the identity coframe, one coordinate of the linearized coframe Euler
equation is exactly the corresponding coframe-index mixed Einstein coefficient
of the additive plaquette curvature. -/
theorem linearizedCoframeEulerCoefficient_eq_mixedEinstein
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (linkVariation : LinkVariation Site)
    (site : Site) (internal direction : Fin 4) :
    linearizedCoframeEulerCoefficient shift linkVariation site internal direction =
      mixedEinsteinCoframeCoefficient
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (additivePlaquetteCurl shift linkVariation site) internal direction := by
  unfold linearizedCoframeEulerCoefficient
  rw [linearizedCoframeEulerFunctional_eq_palatiniDensityFirstVariation]
  rw [palatiniDensityFirstVariation_eq_det_mul_mixedEinstein
    (inverseCoframe := (1 : Matrix (Fin 4) (Fin 4) Real))]
  · simp only [Matrix.det_one, one_mul]
    fin_cases internal <;> fin_cases direction <;>
      simp +decide [Fin.sum_univ_four, Matrix.single_apply]
  · simp
  · exact additivePlaquetteCurl_antisymmetric_local shift linkVariation site

/-- Vanishing of all linearized coframe Euler coefficients is exactly the
identity-background mixed vacuum Einstein equation for the additive plaquette
curvature. -/
theorem linearizedCoframeStationary_iff_mixedVacuumEinstein
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (linkVariation : LinkVariation Site) :
    LinearizedCoframeStationary shift linkVariation <->
      forall site coframeDirection raisedDirection,
        mixedVacuumEinsteinEntry
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (additivePlaquetteCurl shift linkVariation site)
          coframeDirection raisedDirection = 0 := by
  constructor
  · intro hStationary site
    have hCoefficient : forall internal direction,
        mixedEinsteinCoframeCoefficient
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (additivePlaquetteCurl shift linkVariation site)
          internal direction = 0 := by
      intro internal direction
      rw [<- linearizedCoframeEulerCoefficient_eq_mixedEinstein]
      exact hStationary site internal direction
    have hMixed :=
      (mixedEinsteinCoframeCoefficient_vanish_iff
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (additivePlaquetteCurl shift linkVariation site)
        (by simp) (by simp)).mp hCoefficient
    intro coframeDirection raisedDirection
    simpa only [mixedVacuumEinsteinEntry] using
      hMixed coframeDirection raisedDirection
  · intro hEinstein site internal direction
    rw [linearizedCoframeEulerCoefficient_eq_mixedEinstein]
    apply (mixedEinsteinCoframeCoefficient_vanish_iff
      (1 : Matrix (Fin 4) (Fin 4) Real)
      (1 : Matrix (Fin 4) (Fin 4) Real)
      (additivePlaquetteCurl shift linkVariation site)
      (by simp) (by simp)).mpr
    intro coframeDirection raisedDirection
    simpa only [mixedVacuumEinsteinEntry] using
      hEinstein site coframeDirection raisedDirection

/-! ## Two-sided affine sampling and linearized curvature -/

/-- The inverse-spacing-normalized additive curl of a sampled Lorentz
connection on one changing carrier. -/
def sampledNormalizedAdditiveCurvature
    {Site : Nat -> Type*} {Chart : Type*}
    [NormedAddCommGroup Chart] [NormedSpace Real Chart]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (position : (n : Nat) -> Site n -> Chart) (center : (n : Nat) -> Site n)
    (inverseSpacing : Nat -> Real)
    (connectionField : Chart -> LorentzConnectionVelocity)
    (n : Nat) : LocalCurvature :=
  fun a b => inverseSpacing n •
    additivePlaquetteCurl (shift n)
      (sampledLinkVariation connectionField position n) (center n) a b

/-- Linearized continuum curvature `dA` evaluated on the supplied tangent
frame.  The quadratic `A wedge A` term is absent because the finite equations
are linearized at the identity connection. -/
def sampledLinearizedCurvatureLimit
    {Chart : Type*} [NormedAddCommGroup Chart] [NormedSpace Real Chart]
    (connectionDerivative :
      Chart →L[Real] LorentzConnectionVelocity)
    (tangent : Fin 4 -> Chart) : LocalCurvature :=
  fun a b => connectionDerivative (tangent a) b -
    connectionDerivative (tangent b) a

/-- The limiting exterior-derivative curvature is antisymmetric in its two
tangent-frame directions. -/
theorem sampledLinearizedCurvatureLimit_antisymmetric
    {Chart : Type*} [NormedAddCommGroup Chart] [NormedSpace Real Chart]
    (connectionDerivative : Chart →L[Real] LorentzConnectionVelocity)
    (tangent : Fin 4 -> Chart) (a b : Fin 4) (component : Fin 6) :
    sampledLinearizedCurvatureLimit connectionDerivative tangent a b component =
      -sampledLinearizedCurvatureLimit connectionDerivative tangent b a
        component := by
  simp only [sampledLinearizedCurvatureLimit, Pi.sub_apply]
  ring

/-- A pointed affine stencil with predecessor samples along `-v_a` and
forward samples along `v_a`.  The inherited pointed-stencil data also control
the translated predecessor sites read by the link Euler equation. -/
structure PointedAffineTwoSidedStencil
    {Site : Nat -> Type*} {Chart : Type*}
    [NormedAddCommGroup Chart] [NormedSpace Real Chart]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (position : (n : Nat) -> Site n -> Chart)
    (center : (n : Nat) -> Site n) (point : Chart)
    (inverseSpacing : Nat -> Real) (tangent : Fin 4 -> Chart) : Prop where
  toPredecessor : PointedAffinePredecessorStencil shift position center point
    inverseSpacing (fun direction => -tangent direction)
  forward_eq : forall n direction,
    position n (shift n direction (center n)) =
      point + (inverseSpacing n)⁻¹ • tangent direction

/-- Differentiability of the sampled connection turns the normalized additive
plaquette curl into the exterior derivative `dA` on every tangent-frame face. -/
theorem sampledNormalizedAdditiveCurvature_tendsto
    {Site : Nat -> Type*} {Chart : Type*}
    [NormedAddCommGroup Chart] [NormedSpace Real Chart]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (position : (n : Nat) -> Site n -> Chart)
    (center : (n : Nat) -> Site n) (point : Chart)
    (inverseSpacing : Nat -> Real) (tangent : Fin 4 -> Chart)
    (connectionField : Chart -> LorentzConnectionVelocity)
    (connectionDerivative : Chart →L[Real] LorentzConnectionVelocity)
    (hConnection : HasFDerivAt connectionField connectionDerivative point)
    (hInverseSpacing : Tendsto (fun n => ‖inverseSpacing n‖) atTop atTop)
    (hStencil : PointedAffineTwoSidedStencil shift position center point
      inverseSpacing tangent)
    (a b : Fin 4) (component : Fin 6) :
    Tendsto
      (fun n => sampledNormalizedAdditiveCurvature shift position center
        inverseSpacing connectionField n a b component)
      atTop
      (nhds (sampledLinearizedCurvatureLimit connectionDerivative tangent
        a b component)) := by
  have hAlongAField := hConnection.lim (tangent a) hInverseSpacing
  have hAlongA := tendsto_pi_nhds.mp
    (tendsto_pi_nhds.mp hAlongAField b) component
  have hAlongBField := hConnection.lim (tangent b) hInverseSpacing
  have hAlongB := tendsto_pi_nhds.mp
    (tendsto_pi_nhds.mp hAlongBField a) component
  have hDifference := hAlongA.sub hAlongB
  convert hDifference using 1
  · funext n
    simp only [sampledNormalizedAdditiveCurvature, sampledLinkVariation,
      additivePlaquetteCurl, hStencil.forward_eq,
      hStencil.toPredecessor.toPointed.center_eq, Pi.smul_apply,
      Pi.sub_apply, smul_eq_mul]
    ring

/-! ## Joint sampled Einstein-Cartan endpoint -/

/-- **Joint sampled linearized Einstein-Cartan consistency.**  Sample one
differentiable Lorentz connection and tetrad on a common changing-carrier
two-sided affine stencil.  If the first derivatives of both Euler maps of the
same finite Palatini action vanish at every level, then the exterior derivative
of the connection satisfies the identity-background linearized vacuum Einstein
equation and the sampled connection/tetrad jet satisfies the covariant Cartan
torsion equation. -/
theorem sampledLinearizedJointStationary_einstein_and_cartan
    {Site : Nat -> Type*} [forall n, Fintype (Site n)]
    {Chart : Type*} [NormedAddCommGroup Chart] [NormedSpace Real Chart]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (position : (n : Nat) -> Site n -> Chart)
    (center : (n : Nat) -> Site n) (point : Chart)
    (inverseSpacing : Nat -> Real) (tangent : Fin 4 -> Chart)
    (connectionField : Chart -> LorentzConnectionVelocity)
    (connectionDerivative : Chart →L[Real] LorentzConnectionVelocity)
    (tetrad : Chart -> Matrix (Fin 4) (Fin 4) Real)
    (tetradDerivative : Chart →L[Real] Matrix (Fin 4) (Fin 4) Real)
    (hConnection : HasFDerivAt connectionField connectionDerivative point)
    (hTetrad : HasFDerivAt tetrad tetradDerivative point)
    (hInverseSpacing : Tendsto (fun n => ‖inverseSpacing n‖) atTop atTop)
    (hStencil : PointedAffineTwoSidedStencil shift position center point
      inverseSpacing tangent)
    (hJointStationary : forall n,
      ActualActionLinearizedJointStationary (shift n)
        (sampledLinkVariation connectionField position n)
        (sampledScaledCoframeVariation inverseSpacing tetrad position point n)) :
    (forall coframeDirection raisedDirection,
      mixedVacuumEinsteinEntry
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (sampledLinearizedCurvatureLimit connectionDerivative tangent)
        coframeDirection raisedDirection = 0) /\
    LinearizedCovariantTorsionFree
      (1 : Matrix (Fin 4) (Fin 4) Real) (connectionField point)
      (sampledCoframeVelocityLimit tetradDerivative
        (fun direction => -tangent direction)) := by
  constructor
  · intro coframeDirection raisedDirection
    have hCurvature := sampledNormalizedAdditiveCurvature_tendsto
      shift position center point inverseSpacing tangent connectionField
      connectionDerivative hConnection hInverseSpacing hStencil
    have hEinsteinLimit := mixedVacuumEinsteinEntry_tendsto
      (1 : Matrix (Fin 4) (Fin 4) Real)
      (sampledNormalizedAdditiveCurvature shift position center inverseSpacing
        connectionField)
      (sampledLinearizedCurvatureLimit connectionDerivative tangent)
      hCurvature coframeDirection raisedDirection
    have hEinsteinZero : Tendsto
        (fun n => mixedVacuumEinsteinEntry
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (sampledNormalizedAdditiveCurvature shift position center
            inverseSpacing connectionField n)
          coframeDirection raisedDirection)
        atTop (nhds 0) := by
      convert tendsto_const_nhds using 1
      funext n
      have hUnscaled :=
        (linearizedCoframeStationary_iff_mixedVacuumEinstein
          (shift n) (sampledLinkVariation connectionField position n)).mp
          ((actualActionLinearizedJointStationary_iff
            (shift n) (sampledLinkVariation connectionField position n)
            (sampledScaledCoframeVariation inverseSpacing tetrad position
              point n)).mp (hJointStationary n)).2
          (center n) coframeDirection raisedDirection
      change mixedVacuumEinsteinEntryLinear
        (1 : Matrix (Fin 4) (Fin 4) Real)
        coframeDirection raisedDirection
        (sampledNormalizedAdditiveCurvature shift position center
          inverseSpacing connectionField n) = 0
      unfold sampledNormalizedAdditiveCurvature
      change mixedVacuumEinsteinEntryLinear
        (1 : Matrix (Fin 4) (Fin 4) Real)
        coframeDirection raisedDirection
        (inverseSpacing n • additivePlaquetteCurl (shift n)
          (sampledLinkVariation connectionField position n) (center n)) = 0
      rw [map_smul]
      change mixedVacuumEinsteinEntryLinear
        (1 : Matrix (Fin 4) (Fin 4) Real)
        coframeDirection raisedDirection
        (additivePlaquetteCurl (shift n)
          (sampledLinkVariation connectionField position n) (center n)) = 0
        at hUnscaled
      rw [hUnscaled, smul_zero]
    exact tendsto_nhds_unique hEinsteinLimit hEinsteinZero
  · apply nonlinearLinkEulerCoefficient_sampledConnectionCoframe_torsionFree
      shift position center point inverseSpacing
        (fun direction => -tangent direction)
      connectionField tetrad tetradDerivative hConnection.continuousAt hTetrad
      hInverseSpacing hStencil.toPredecessor
    intro direction component
    have hSequence :
        (fun n => deriv (fun t => nonlinearLinkEulerCoefficient (shift n)
          (exponentialLinkCurve (identityConnection (Site n))
            (sampledLinkVariation connectionField position n) t)
          (coframeLine (identityCoframeField (Site n))
            (sampledScaledCoframeVariation inverseSpacing tetrad position
              point n) t)
          (center n) direction component) 0) =
        fun _ => 0 := by
      funext n
      exact (hJointStationary n).1 (center n) direction component
    rw [hSequence]
    exact tendsto_const_nhds

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedEinsteinCartanLimit.hasDerivAt_nonlinearCoframeEulerCoefficient_identity' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_nonlinearCoframeEulerCoefficient_identity

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedEinsteinCartanLimit.actualActionLinearizedJointStationary_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms actualActionLinearizedJointStationary_iff

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedEinsteinCartanLimit.linearizedCoframeStationary_iff_mixedVacuumEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linearizedCoframeStationary_iff_mixedVacuumEinstein

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedEinsteinCartanLimit.sampledNormalizedAdditiveCurvature_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sampledNormalizedAdditiveCurvature_tendsto

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedEinsteinCartanLimit.sampledLinearizedJointStationary_einstein_and_cartan' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sampledLinearizedJointStationary_einstein_and_cartan

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedEinsteinCartanLimit

```

### PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniCoframeVariation.lean (683 lines)

```lean
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler

noncomputable section

/-!
# Coframe variation of the nonlinear Lorentz Palatini action

The nonlinear ordered-holonomy action already has an exact connection
derivative.  This module differentiates the same scalar action in its coframe
argument.  Since the complementary Palatini face is quadratic in the coframe,
the line `e + t delta e` gives the exact expansion

`S(e + t delta e, U) = S(e,U) + t delta_e S + t^2 S(delta e,U)`.

Consequently the displayed first response is an ordinary derivative, not a
renamed formal functional.  The response is reorganized sitewise, expanded in
the sixteen matrix-entry probes of each local tetrad, and combined with the
six link Euler coefficients from the connection variation.

## Scope and provenance

This is an exact finite first-order Palatini identity for the concrete
coframe/holonomy action.  It supplies both partial Euler systems of one action.
It does not yet identify the sixteen tetrad coefficients with a reconstructed
Einstein tensor; that requires the curvature-contraction bridge and an
invertible coframe.  The quadratic tetrad variation is standard `[import]`;
the finite ordered-face coefficient extraction is `[orig/comp]`.  Claim label:
finite identity.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation

open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler

/-- A weighted finite double sum distributes over addition. -/
theorem weightedDoubleSum_add
    {I J : Type*} [Fintype I] [Fintype J]
    (weight left right : I -> J -> Real) :
    Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
        weight i j * (left i j + right i j))) =
      Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
        weight i j * left i j)) +
      Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
        weight i j * right i j)) := by
  simp only [mul_add, Finset.sum_add_distrib]

/-- A weighted finite double sum commutes with real scaling. -/
theorem weightedDoubleSum_smul
    {I J : Type*} [Fintype I] [Fintype J]
    (weight field : I -> J -> Real) (scalar : Real) :
    Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
        weight i j * (scalar * field i j))) =
      scalar * Finset.sum Finset.univ (fun i =>
        Finset.sum Finset.univ (fun j => weight i j * field i j)) := by
  calc
    _ = Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
          scalar * (weight i j * field i j))) := by
      apply Finset.sum_congr rfl
      intro i _
      apply Finset.sum_congr rfl
      intro j _
      ring
    _ = _ := by simp only [Finset.mul_sum]

/-- Exact quadratic-line expansion under a weighted finite double sum. -/
theorem weightedDoubleSum_line
    {I J : Type*} [Fintype I] [Fintype J]
    (weight base response quadratic : I -> J -> Real) (t : Real) :
    Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
        weight i j *
          (base i j + t * response i j + t ^ 2 * quadratic i j))) =
      Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
        weight i j * base i j)) +
      t * Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
        weight i j * response i j)) +
      t ^ 2 * Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
        weight i j * quadratic i j)) := by
  calc
    _ = Finset.sum Finset.univ (fun i => Finset.sum Finset.univ (fun j =>
          weight i j * base i j +
            t * (weight i j * response i j) +
            t ^ 2 * (weight i j * quadratic i j))) := by
      apply Finset.sum_congr rfl
      intro i _
      apply Finset.sum_congr rfl
      intro j _
      ring
    _ = _ := by simp only [Finset.sum_add_distrib, Finset.mul_sum]

/-- Polarized first variation of the internal bivector formed by two coframe
columns. -/
def coframeWedgeFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber 6 :=
  fun component =>
    variation (bivectorFirst component) a *
        coframe (bivectorSecond component) b +
      coframe (bivectorFirst component) a *
        variation (bivectorSecond component) b -
      variation (bivectorFirst component) b *
        coframe (bivectorSecond component) a -
      coframe (bivectorFirst component) b *
        variation (bivectorSecond component) a

/-- Exact quadratic expansion of one coframe wedge along an affine line. -/
theorem coframeWedge_line
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) (t : Real) :
    coframeWedge (coframe + t • variation) a b =
      coframeWedge coframe a b +
        t • coframeWedgeFirstVariation coframe variation a b +
        t ^ 2 • coframeWedge variation a b := by
  funext component
  simp [coframeWedge, coframeWedgeFirstVariation]
  ring

/-- The polarized coframe wedge is additive in its variation. -/
theorem coframeWedgeFirstVariation_add
    (coframe left right : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    coframeWedgeFirstVariation coframe (left + right) a b =
      coframeWedgeFirstVariation coframe left a b +
        coframeWedgeFirstVariation coframe right a b := by
  funext component
  simp [coframeWedgeFirstVariation]
  ring

/-- The polarized coframe wedge respects scaling of its variation. -/
theorem coframeWedgeFirstVariation_smul
    (coframe probe : Matrix (Fin 4) (Fin 4) Real) (scalar : Real)
    (a b : Fin 4) :
    coframeWedgeFirstVariation coframe (scalar • probe) a b =
      scalar • coframeWedgeFirstVariation coframe probe a b := by
  funext component
  simp [coframeWedgeFirstVariation]
  ring

/-- Hodge-dualized first variation of one internal coframe face. -/
def palatiniFaceWeightFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber 6 :=
  transportApply lorentzHodgeStar
    (coframeWedgeFirstVariation coframe variation a b)

/-- Matrix transport is additive in the transported fiber. -/
theorem transportApply_add_local
    (transport : Matrix (Fin 6) (Fin 6) Real) (left right : Fiber 6) :
    transportApply transport (left + right) =
      transportApply transport left + transportApply transport right := by
  funext component
  simp [transportApply, Finset.sum_add_distrib, mul_add]

/-- Matrix transport respects real scalar multiplication of a fiber. -/
theorem transportApply_smul_local
    (transport : Matrix (Fin 6) (Fin 6) Real)
    (scalar : Real) (field : Fiber 6) :
    transportApply transport (scalar • field) =
      scalar • transportApply transport field := by
  funext component
  simp only [transportApply, Pi.smul_apply, smul_eq_mul]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro index _
  ring

/-- Hodge-dualized face variation is additive in its coframe probe. -/
theorem palatiniFaceWeightFirstVariation_add
    (coframe left right : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    palatiniFaceWeightFirstVariation coframe (left + right) a b =
      palatiniFaceWeightFirstVariation coframe left a b +
        palatiniFaceWeightFirstVariation coframe right a b := by
  unfold palatiniFaceWeightFirstVariation
  rw [coframeWedgeFirstVariation_add, transportApply_add_local]

/-- Hodge-dualized face variation respects scaling of its coframe probe. -/
theorem palatiniFaceWeightFirstVariation_smul
    (coframe probe : Matrix (Fin 4) (Fin 4) Real) (scalar : Real)
    (a b : Fin 4) :
    palatiniFaceWeightFirstVariation coframe (scalar • probe) a b =
      scalar • palatiniFaceWeightFirstVariation coframe probe a b := by
  unfold palatiniFaceWeightFirstVariation
  rw [coframeWedgeFirstVariation_smul, transportApply_smul_local]

/-- Exact quadratic expansion survives the linear internal Hodge star. -/
theorem palatiniFaceWeight_line
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) (t : Real) :
    palatiniFaceWeight (coframe + t • variation) a b =
      palatiniFaceWeight coframe a b +
        t • palatiniFaceWeightFirstVariation coframe variation a b +
        t ^ 2 • palatiniFaceWeight variation a b := by
  unfold palatiniFaceWeight palatiniFaceWeightFirstVariation
  rw [coframeWedge_line, transportApply_add_local,
    transportApply_add_local, transportApply_smul_local,
    transportApply_smul_local]

/-- Polarized first variation of the complementary curvature-face
coefficient. -/
noncomputable def complementaryPalatiniFaceWeightFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) : Fiber 6 :=
  fun component =>
    (1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
      Finset.sum Finset.univ (fun d =>
        spacetimeAlternatingSymbol c d a b *
          palatiniFaceWeightFirstVariation coframe variation c d component))

/-- Reversing the curvature plaquette reverses the polarized complementary
coframe coefficient. -/
theorem complementaryPalatiniFaceWeightFirstVariation_swap
    (coframe variation : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    complementaryPalatiniFaceWeightFirstVariation coframe variation b a =
      fun component =>
        -complementaryPalatiniFaceWeightFirstVariation
          coframe variation a b component := by
  funext component
  unfold complementaryPalatiniFaceWeightFirstVariation
  have hSum :
      Finset.sum Finset.univ (fun c =>
          Finset.sum Finset.univ (fun d =>
            spacetimeAlternatingSymbol c d b a *
              palatiniFaceWeightFirstVariation
                coframe variation c d component)) =
        -Finset.sum Finset.univ (fun c =>
          Finset.sum Finset.univ (fun d =>
            spacetimeAlternatingSymbol c d a b *
              palatiniFaceWeightFirstVariation
                coframe variation c d component)) := by
    rw [← Finset.sum_neg_distrib]
    apply Finset.sum_congr rfl
    intro c _
    rw [← Finset.sum_neg_distrib]
    apply Finset.sum_congr rfl
    intro d _
    rw [spacetimeAlternatingSymbol_swap_last c d a b]
    ring
  rw [hSum]
  ring

/-- The complementary face has the same exact quadratic line expansion. -/
theorem complementaryPalatiniFaceWeight_line
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) (t : Real) :
    complementaryPalatiniFaceWeight (coframe + t • variation) a b =
      complementaryPalatiniFaceWeight coframe a b +
        t • complementaryPalatiniFaceWeightFirstVariation coframe variation a b +
        t ^ 2 • complementaryPalatiniFaceWeight variation a b := by
  funext component
  unfold complementaryPalatiniFaceWeight
    complementaryPalatiniFaceWeightFirstVariation
  simp_rw [palatiniFaceWeight_line]
  simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  rw [weightedDoubleSum_line]
  ring

/-- Pointwise complementary-face first variation of a coframe field. -/
def coframeFaceWeightFirstVariation
    {Site : Type*} (coframe variation : CoframeField Site) :
    FaceWeight Site 6 :=
  fun site a b => complementaryPalatiniFaceWeightFirstVariation
    (coframe site) (variation site) a b

/-- The pointwise polarized complementary coframe field is antisymmetric in
its ordered plaquette directions. -/
theorem coframeFaceWeightFirstVariation_isAntisymmetric
    {Site : Type*} (coframe variation : CoframeField Site) :
    IsAntisymmetricFaceWeight
      (coframeFaceWeightFirstVariation coframe variation) := by
  intro site a b component
  exact congrFun
    (complementaryPalatiniFaceWeightFirstVariation_swap
      (coframe site) (variation site) b a) component

/-- Affine coframe line used for the ordinary directional derivative. -/
def coframeLine {Site : Type*}
    (coframe variation : CoframeField Site) (t : Real) : CoframeField Site :=
  fun site => coframe site + t • variation site

/-- The pointwise coframe face field has an exact quadratic line expansion. -/
theorem coframeFaceWeight_line
    {Site : Type*} (coframe variation : CoframeField Site) (t : Real) :
    coframeFaceWeight (coframeLine coframe variation t) =
      coframeFaceWeight coframe +
        t • coframeFaceWeightFirstVariation coframe variation +
        t ^ 2 • coframeFaceWeight variation := by
  funext site a b
  exact complementaryPalatiniFaceWeight_line
    (coframe site) (variation site) a b t

/-- One ordered action term is additive in its face coefficient. -/
theorem orderedPlaquetteActionTerm_add_face
    (left right : Fiber 6) (holonomy : GL4) :
    orderedPlaquetteActionTerm (left + right) holonomy =
      orderedPlaquetteActionTerm left holonomy +
        orderedPlaquetteActionTerm right holonomy := by
  simp [orderedPlaquetteActionTerm, lorentzGenerator_add,
    Matrix.add_mul, Matrix.trace_add]
  ring

/-- One ordered action term respects scalar multiplication of its face. -/
theorem orderedPlaquetteActionTerm_smul_face
    (scalar : Real) (face : Fiber 6) (holonomy : GL4) :
    orderedPlaquetteActionTerm (scalar • face) holonomy =
      scalar * orderedPlaquetteActionTerm face holonomy := by
  simp [orderedPlaquetteActionTerm, lorentzGenerator_smul,
    Matrix.trace_smul]
  ring

/-- Exact face-line expansion of one ordered action term. -/
theorem orderedPlaquetteActionTerm_face_line
    (face response quadratic : Fiber 6) (holonomy : GL4) (t : Real) :
    orderedPlaquetteActionTerm
        (face + t • response + t ^ 2 • quadratic) holonomy =
      orderedPlaquetteActionTerm face holonomy +
        t * orderedPlaquetteActionTerm response holonomy +
        t ^ 2 * orderedPlaquetteActionTerm quadratic holonomy := by
  rw [orderedPlaquetteActionTerm_add_face,
    orderedPlaquetteActionTerm_add_face,
    orderedPlaquetteActionTerm_smul_face,
    orderedPlaquetteActionTerm_smul_face]

/-- Coframe partial response of the concrete nonlinear scalar action. -/
def nonlinearCoframePlaquetteCoframeFirstResponse
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe variation : CoframeField Site) : Real :=
  nonlinearFacePlaquetteAction shift connection
    (coframeFaceWeightFirstVariation coframe variation)

/-- Exact quadratic expansion of the complete action along a coframe line. -/
theorem nonlinearCoframePlaquetteAction_coframeLine
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe variation : CoframeField Site) (t : Real) :
    nonlinearCoframePlaquetteAction shift connection
        (coframeLine coframe variation t) =
      nonlinearCoframePlaquetteAction shift connection coframe +
        t * nonlinearCoframePlaquetteCoframeFirstResponse
          shift connection coframe variation +
        t ^ 2 * nonlinearCoframePlaquetteAction shift connection variation := by
  unfold nonlinearCoframePlaquetteAction
    nonlinearCoframePlaquetteCoframeFirstResponse
    nonlinearFacePlaquetteAction
  simp_rw [coframeFaceWeight_line, Pi.add_apply, Pi.smul_apply,
    orderedPlaquetteActionTerm_face_line]
  simp only [Finset.sum_add_distrib, Finset.mul_sum]

/-- The displayed coframe response is the ordinary derivative of the same
nonlinear holonomy action. -/
theorem hasDerivAt_nonlinearCoframePlaquetteAction_coframeLine
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe variation : CoframeField Site) :
    HasDerivAt
      (fun t => nonlinearCoframePlaquetteAction shift connection
        (coframeLine coframe variation t))
      (nonlinearCoframePlaquetteCoframeFirstResponse
        shift connection coframe variation) 0 := by
  let base := nonlinearCoframePlaquetteAction shift connection coframe
  let response := nonlinearCoframePlaquetteCoframeFirstResponse
    shift connection coframe variation
  let quadratic := nonlinearCoframePlaquetteAction shift connection variation
  have hId : HasDerivAt (fun t : Real => t) 1 0 := hasDerivAt_id 0
  have hPolynomial : HasDerivAt
      (fun t : Real => base + t * response + t ^ 2 * quadratic)
      response 0 := by
    convert ((hasDerivAt_const (x := 0) base).add
      ((hId.mul_const response).add ((hId.pow 2).mul_const quadratic))) using 1
    · funext t
      simp
      ring
    · norm_num
  apply hPolynomial.congr_of_eventuallyEq
  filter_upwards with t
  simpa [base, response, quadratic] using
    nonlinearCoframePlaquetteAction_coframeLine
      shift connection coframe variation t

/-- Local coframe response at one site. -/
def nonlinearCoframeLocalEulerFunctional
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (probe : Matrix (Fin 4) (Fin 4) Real) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      orderedPlaquetteActionTerm
        (complementaryPalatiniFaceWeightFirstVariation
          (coframe site) probe a b)
        (plaquetteUnit shift connection site a b)))

/-- The global coframe response is the sum of its site-local functionals. -/
theorem nonlinearCoframePlaquetteCoframeFirstResponse_eq_localEuler
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe variation : CoframeField Site) :
    nonlinearCoframePlaquetteCoframeFirstResponse
        shift connection coframe variation =
      Finset.sum Finset.univ (fun site =>
        nonlinearCoframeLocalEulerFunctional shift connection coframe site
          (variation site)) := by
  unfold nonlinearCoframePlaquetteCoframeFirstResponse
    nonlinearFacePlaquetteAction nonlinearCoframeLocalEulerFunctional
    coframeFaceWeightFirstVariation
  exact sum_direction_direction_site_cycle _

/-- The polarized complementary face is additive in its coframe probe. -/
theorem complementaryPalatiniFaceWeightFirstVariation_add
    (coframe left right : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    complementaryPalatiniFaceWeightFirstVariation
        coframe (left + right) a b =
      complementaryPalatiniFaceWeightFirstVariation coframe left a b +
        complementaryPalatiniFaceWeightFirstVariation coframe right a b := by
  funext component
  unfold complementaryPalatiniFaceWeightFirstVariation
  simp_rw [palatiniFaceWeightFirstVariation_add, Pi.add_apply]
  rw [weightedDoubleSum_add]
  ring

/-- The polarized complementary face respects scalar multiplication of its
coframe probe. -/
theorem complementaryPalatiniFaceWeightFirstVariation_smul
    (coframe probe : Matrix (Fin 4) (Fin 4) Real) (scalar : Real)
    (a b : Fin 4) :
    complementaryPalatiniFaceWeightFirstVariation
        coframe (scalar • probe) a b =
      scalar • complementaryPalatiniFaceWeightFirstVariation
        coframe probe a b := by
  funext component
  unfold complementaryPalatiniFaceWeightFirstVariation
  simp_rw [palatiniFaceWeightFirstVariation_smul, Pi.smul_apply]
  simp only [smul_eq_mul]
  rw [weightedDoubleSum_smul]
  ring

/-- The site-local coframe response is additive in its matrix probe. -/
theorem nonlinearCoframeLocalEulerFunctional_add
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (left right : Matrix (Fin 4) (Fin 4) Real) :
    nonlinearCoframeLocalEulerFunctional shift connection coframe site
        (left + right) =
      nonlinearCoframeLocalEulerFunctional shift connection coframe site left +
        nonlinearCoframeLocalEulerFunctional shift connection coframe site right := by
  unfold nonlinearCoframeLocalEulerFunctional
  simp_rw [complementaryPalatiniFaceWeightFirstVariation_add,
    orderedPlaquetteActionTerm_add_face]
  simp [Finset.sum_add_distrib]

/-- The site-local coframe response respects real scalar multiplication. -/
theorem nonlinearCoframeLocalEulerFunctional_smul
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (scalar : Real)
    (probe : Matrix (Fin 4) (Fin 4) Real) :
    nonlinearCoframeLocalEulerFunctional shift connection coframe site
        (scalar • probe) =
      scalar * nonlinearCoframeLocalEulerFunctional
        shift connection coframe site probe := by
  unfold nonlinearCoframeLocalEulerFunctional
  simp_rw [complementaryPalatiniFaceWeightFirstVariation_smul,
    orderedPlaquetteActionTerm_smul_face]
  simp [Finset.mul_sum]

/-- Site-local coframe response as a real linear map on tetrad matrices. -/
def nonlinearCoframeLocalEulerLinearMap
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) :
    Matrix (Fin 4) (Fin 4) Real →ₗ[Real] Real where
  toFun := nonlinearCoframeLocalEulerFunctional
    shift connection coframe site
  map_add' := nonlinearCoframeLocalEulerFunctional_add
    shift connection coframe site
  map_smul' := nonlinearCoframeLocalEulerFunctional_smul
    shift connection coframe site

/-- One of the sixteen explicit local tetrad Euler coefficients. -/
def nonlinearCoframeEulerCoefficient
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (internal direction : Fin 4) : Real :=
  nonlinearCoframeLocalEulerLinearMap shift connection coframe site
    (Matrix.single internal direction 1)

/-- The local coframe functional is the coordinate pairing with its sixteen
Euler coefficients. -/
theorem nonlinearCoframeLocalEulerFunctional_eq_coordinateSum
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (probe : Matrix (Fin 4) (Fin 4) Real) :
    nonlinearCoframeLocalEulerFunctional shift connection coframe site probe =
      Finset.sum Finset.univ (fun internal =>
        Finset.sum Finset.univ (fun direction =>
          nonlinearCoframeEulerCoefficient shift connection coframe site
            internal direction * probe internal direction)) := by
  let localMap := nonlinearCoframeLocalEulerLinearMap
    shift connection coframe site
  calc
    nonlinearCoframeLocalEulerFunctional shift connection coframe site probe =
        localMap probe := rfl
    _ = localMap (Finset.sum Finset.univ (fun internal =>
          Finset.sum Finset.univ (fun direction =>
            Matrix.single internal direction (probe internal direction)))) := by
      rw [<- Matrix.matrix_eq_sum_single probe]
    _ = Finset.sum Finset.univ (fun internal =>
          Finset.sum Finset.univ (fun direction =>
            localMap (Matrix.single internal direction
              (probe internal direction)))) := by
      rw [map_sum]
      apply Finset.sum_congr rfl
      intro internal _
      rw [map_sum]
    _ = Finset.sum Finset.univ (fun internal =>
          Finset.sum Finset.univ (fun direction =>
            nonlinearCoframeEulerCoefficient shift connection coframe site
              internal direction * probe internal direction)) := by
      apply Finset.sum_congr rfl
      intro internal _
      apply Finset.sum_congr rfl
      intro direction _
      have hSingle :
          Matrix.single internal direction (probe internal direction) =
            probe internal direction •
              Matrix.single internal direction (1 : Real) := by
        simp
      rw [hSingle, map_smul]
      change probe internal direction *
          nonlinearCoframeEulerCoefficient shift connection coframe site
            internal direction = _
      ring

/-- Coframe variation supported on one site and one tetrad entry. -/
def nonlinearCoframeComponentProbe
    {Site : Type*} [DecidableEq Site]
    (site : Site) (internal direction : Fin 4) : CoframeField Site :=
  Pi.single site (Matrix.single internal direction 1)

/-- A supported coframe probe extracts one local tetrad Euler coefficient. -/
theorem nonlinearCoframePlaquetteCoframeFirstResponse_componentProbe
    {Site : Type*} [Fintype Site] [DecidableEq Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site)
    (site : Site) (internal direction : Fin 4) :
    nonlinearCoframePlaquetteCoframeFirstResponse shift connection coframe
        (nonlinearCoframeComponentProbe site internal direction) =
      nonlinearCoframeEulerCoefficient shift connection coframe site
        internal direction := by
  rw [nonlinearCoframePlaquetteCoframeFirstResponse_eq_localEuler]
  rw [Fintype.sum_eq_single site]
  · change nonlinearCoframeLocalEulerLinearMap shift connection coframe site
      (nonlinearCoframeComponentProbe site internal direction site) = _
    simp [nonlinearCoframeComponentProbe, nonlinearCoframeEulerCoefficient]
  · intro otherSite hOther
    change nonlinearCoframeLocalEulerLinearMap shift connection coframe
      otherSite (nonlinearCoframeComponentProbe site internal direction
        otherSite) = 0
    simp [nonlinearCoframeComponentProbe, hOther]

/-- Formal coframe stationarity of the nonlinear plaquette action. -/
def NonlinearCoframePlaquetteCoframeStationary
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) : Prop :=
  forall variation,
    nonlinearCoframePlaquetteCoframeFirstResponse
      shift connection coframe variation = 0

/-- Coframe stationarity is exactly vanishing of all sixteen local tetrad
Euler coefficients. -/
theorem nonlinearCoframePlaquetteCoframeStationary_iff_coefficients
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    NonlinearCoframePlaquetteCoframeStationary shift connection coframe <->
      forall site internal direction,
        nonlinearCoframeEulerCoefficient shift connection coframe site
          internal direction = 0 := by
  classical
  constructor
  · intro hStationary site internal direction
    rw [<- nonlinearCoframePlaquetteCoframeFirstResponse_componentProbe]
    exact hStationary _
  · intro hCoefficients variation
    rw [nonlinearCoframePlaquetteCoframeFirstResponse_eq_localEuler]
    apply Finset.sum_eq_zero
    intro site _
    rw [nonlinearCoframeLocalEulerFunctional_eq_coordinateSum]
    apply Finset.sum_eq_zero
    intro internal _
    apply Finset.sum_eq_zero
    intro direction _
    rw [hCoefficients site internal direction, zero_mul]

/-- Ordinary derivative stationarity along all affine coframe lines is
equivalent to the sixteen local tetrad Euler equations. -/
theorem nonlinearCoframePlaquetteCoframeDerivativeStationary_iff_coefficients
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    (forall variation,
      deriv (fun t => nonlinearCoframePlaquetteAction shift connection
        (coframeLine coframe variation t)) 0 = 0) <->
      forall site internal direction,
        nonlinearCoframeEulerCoefficient shift connection coframe site
          internal direction = 0 := by
  rw [<- nonlinearCoframePlaquetteCoframeStationary_iff_coefficients]
  constructor
  · intro hDerivative variation
    rw [<-
      (hasDerivAt_nonlinearCoframePlaquetteAction_coframeLine
        shift connection coframe variation).deriv]
    exact hDerivative variation
  · intro hStationary variation
    rw [(hasDerivAt_nonlinearCoframePlaquetteAction_coframeLine
      shift connection coframe variation).deriv]
    exact hStationary variation

/-- Both partial stationarity conditions of the same nonlinear coframe/link
action. -/
def NonlinearCoframePlaquetteJointStationary
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) : Prop :=
  NonlinearCoframePlaquetteConnectionStationary shift connection coframe /\
    NonlinearCoframePlaquetteCoframeStationary shift connection coframe

/-- Joint stationarity is the combined six-component link and sixteen-entry
tetrad Euler system of one concrete action. -/
theorem nonlinearCoframePlaquetteJointStationary_iff_coefficients
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (coframe : CoframeField Site) :
    NonlinearCoframePlaquetteJointStationary shift connection coframe <->
      (forall site direction component,
        nonlinearLinkEulerCoefficient shift connection coframe site direction
          component = 0) /\
      (forall site internal direction,
        nonlinearCoframeEulerCoefficient shift connection coframe site
          internal direction = 0) := by
  exact and_congr
    (nonlinearCoframePlaquetteConnectionStationary_iff_coefficients
      shift connection coframe)
    (nonlinearCoframePlaquetteCoframeStationary_iff_coefficients
      shift connection coframe)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation.nonlinearCoframePlaquetteAction_coframeLine' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteAction_coframeLine

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation.hasDerivAt_nonlinearCoframePlaquetteAction_coframeLine' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_nonlinearCoframePlaquetteAction_coframeLine

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation.nonlinearCoframePlaquetteCoframeStationary_iff_coefficients' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteCoframeStationary_iff_coefficients

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation.nonlinearCoframePlaquetteJointStationary_iff_coefficients' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteJointStationary_iff_coefficients

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation

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

### PhysicsSM/Draft/NullEdge/PeriodicVacuumWeylLinearizedBackreaction.lean (1289 lines)

```lean
import PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWaveJointNoGo

noncomputable section

/-!
# Linearized link/coframe backreaction of the periodic vacuum null wave

The fixed proper-Lorentz null-wave links have no invertible jointly stationary
coframe at nonzero area.  This module therefore linearizes both independent
Euler sectors simultaneously at the identity connection and identity coframe.
The link perturbation is a six-component Lorentz-algebra field and the coframe
perturbation is an arbitrary tetrad matrix field.

Two explicit coupled perturbations solve all forty-eight link equations and
all thirty-two coframe equations while carrying independent nonzero additive
curvatures modulo the injective twelve-parameter infinitesimal local Lorentz
orbit.  They are finite two-site analogues of the plus and cross null-wave
polarizations.  This is a kernel-checked linearized existence theorem, not yet
a nonlinear jointly stationary branch, Levi-Civita selection, gauge-reduced
degree-of-freedom count, or continuum-limit theorem.

The standard linearized Palatini architecture is `[import]`; the exact
two-site witnesses and convention-locked finite verification are
`[orig/comp]`.  Claim label: finite linearized existence theorem.
-/

namespace PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction

open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement

/-- First variation, at identity transport and holonomy, of one weighted
adjoint face response.  The four terms respectively vary the face, the left
transport, its inverse, and the plaquette holonomy. -/
def linearizedWeightedAdjointFaceResponse
    (face faceVariation : Fiber 6)
    (transportVariation : Matrix (Fin 4) (Fin 4) Real)
    (probe : Fiber 6)
    (holonomyVariation : Matrix (Fin 4) (Fin 4) Real) : Real :=
  -(1 / 2 : Real) * Matrix.trace
    (lorentzGenerator faceVariation * lorentzGenerator probe +
      lorentzGenerator face *
        (transportVariation * lorentzGenerator probe -
          lorentzGenerator probe * transportVariation +
          lorentzGenerator probe * holonomyVariation))

/-- First-order local link Euler functional for simultaneous Lorentz-link and
coframe perturbations around identity fields. -/
def linearizedLinkEulerFunctional
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (direction : Fin 4) (probe : Fiber 6) : Real :=
  let identityLinks := identityConnection Site
  let identityCoframe := identityCoframeField Site
  Finset.sum Finset.univ (fun b =>
      linearizedWeightedAdjointFaceResponse
        (coframeFaceWeight identityCoframe site direction b)
        (coframeFaceWeightFirstVariation
          identityCoframe coframeVariation site direction b)
        (linkMatrixVariation identityLinks linkVariation site direction)
        probe
        (plaquetteMatrixVariation shift identityLinks linkVariation
          site direction b)) +
    Finset.sum Finset.univ (fun a =>
      let predecessor := (shift a).symm site
      linearizedWeightedAdjointFaceResponse
        (coframeFaceWeight identityCoframe predecessor a direction)
        (coframeFaceWeightFirstVariation
          identityCoframe coframeVariation predecessor a direction)
        (twoStepMatrixVariation shift identityLinks linkVariation
          predecessor a direction)
        probe
        (plaquetteMatrixVariation shift identityLinks linkVariation
          predecessor a direction)) -
    Finset.sum Finset.univ (fun a =>
      linearizedWeightedAdjointFaceResponse
        (coframeFaceWeight identityCoframe site a direction)
        (coframeFaceWeightFirstVariation
          identityCoframe coframeVariation site a direction)
        (plaquetteMatrixVariation shift identityLinks linkVariation
            site a direction +
          linkMatrixVariation identityLinks linkVariation site direction)
        probe
        (plaquetteMatrixVariation shift identityLinks linkVariation
          site a direction)) -
    Finset.sum Finset.univ (fun b =>
      let predecessor := (shift b).symm site
      linearizedWeightedAdjointFaceResponse
        (coframeFaceWeight identityCoframe predecessor direction b)
        (coframeFaceWeightFirstVariation
          identityCoframe coframeVariation predecessor direction b)
        (twoStepMatrixVariation shift identityLinks linkVariation
          predecessor direction b)
        probe
        (plaquetteMatrixVariation shift identityLinks linkVariation
          predecessor direction b))

/-- Forty-eight coordinate coefficients of the linearized link equation. -/
def linearizedLinkEulerCoefficient
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) : Real :=
  linearizedLinkEulerFunctional shift linkVariation coframeVariation
    site direction (Pi.single component (1 : Real))

/-- First-order local coframe Euler functional around the identity fields.
The variation of the coframe coefficient itself multiplies the zero identity
plaquette action and therefore drops out; only the additive plaquette tangent
remains. -/
def linearizedCoframeEulerFunctional
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (site : Site) (probe : Matrix (Fin 4) (Fin 4) Real) : Real :=
  Finset.sum Finset.univ (fun a =>
    Finset.sum Finset.univ (fun b =>
      orderedPlaquetteActionFirstResponse
        (complementaryPalatiniFaceWeightFirstVariation
          (1 : Matrix (Fin 4) (Fin 4) Real) probe a b)
        (plaquetteMatrixVariation shift (identityConnection Site)
          linkVariation site a b)))

/-- Thirty-two coordinate coefficients of the linearized coframe equation. -/
def linearizedCoframeEulerCoefficient
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (site : Site) (internal direction : Fin 4) : Real :=
  linearizedCoframeEulerFunctional shift linkVariation site
    (Matrix.single internal direction 1)

/-- Vanishing of all linearized connection equations. -/
def LinearizedLinkStationary
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site) : Prop :=
  forall site direction component,
    linearizedLinkEulerCoefficient shift linkVariation coframeVariation
      site direction component = 0

/-- Vanishing of all linearized coframe/Einstein equations. -/
def LinearizedCoframeStationary
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site) : Prop :=
  forall site internal direction,
    linearizedCoframeEulerCoefficient shift linkVariation
      site internal direction = 0

/-- Simultaneous first-order stationarity of both independent Palatini
variables. -/
def LinearizedJointStationary
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site) : Prop :=
  LinearizedLinkStationary shift linkVariation coframeVariation /\
    LinearizedCoframeStationary shift linkVariation

/-- Link tangent induced at the identity by a site-local infinitesimal
Lorentz gauge parameter. -/
def infinitesimalGaugeLinkVariation
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (parameter : Site -> Fiber 6) : LinkVariation Site :=
  fun site direction => parameter site - parameter (shift direction site)

/-- Coframe tangent induced at the identity by the same site-local
infinitesimal Lorentz gauge parameter. -/
def infinitesimalGaugeCoframeVariation
    {Site : Type*} (parameter : Site -> Fiber 6) : CoframeField Site :=
  fun site => lorentzGenerator (parameter site)

/-- Commuting carrier shifts make every infinitesimal gauge-link tangent
additively flat. -/
theorem additivePlaquetteCurl_infinitesimalGaugeLinkVariation
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (hCommute : ShiftsCommute shift) (parameter : Site -> Fiber 6)
    (site : Site) (a b : Fin 4) :
    additivePlaquetteCurl shift
        (infinitesimalGaugeLinkVariation shift parameter) site a b = 0 := by
  funext component
  unfold additivePlaquetteCurl infinitesimalGaugeLinkVariation
  simp only [Pi.sub_apply, Pi.zero_apply]
  rw [hCommute site a b]
  ring

/-- Reversing an ordered face negates every additive plaquette curl. -/
theorem additivePlaquetteCurl_antisymmetric_local
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (variation : LinkVariation Site) (site : Site)
    (a b : Fin 4) (component : Fin 6) :
    additivePlaquetteCurl shift variation site a b component =
      -additivePlaquetteCurl shift variation site b a component := by
  unfold additivePlaquetteCurl
  ring

/-- Plus-like link perturbation selected by the exact joint Hessian. -/
def plusBackreactionLinkVariation : LinkVariation NullWaveSite :=
  fun site direction =>
    if direction = 1 then
      (-nullWaveAmplitude site) • nullWavePolarizationOne
    else if direction = 2 then
      (-nullWaveAmplitude site) • nullWavePolarizationTwo
    else 0

/-- Plus-like transverse diagonal shear, supported at site zero. -/
def plusBackreactionCoframeVariation : CoframeField NullWaveSite :=
  fun site =>
    if site = 0 then
      !![0, 0, 0, 0;
         0, -1, 0, 0;
         0, 0, 1, 0;
         0, 0, 0, 0]
    else 0

/-- Integer-scaled cross-like link perturbation selected by the exact joint
Hessian. -/
def crossBackreactionLinkVariation : LinkVariation NullWaveSite :=
  fun site direction =>
    if direction = 0 then
      nullWaveAmplitude site • ![-1, 0, 0, 0, 0, 0]
    else if direction = 1 then
      (-nullWaveAmplitude site) • nullWavePolarizationTwo
    else if direction = 2 then
      nullWaveAmplitude site • nullWavePolarizationOne
    else
      nullWaveAmplitude site • ![-1, 0, 0, 0, 0, 0]

/-- Integer-scaled cross-like transverse shear, supported at site zero. -/
def crossBackreactionCoframeVariation : CoframeField NullWaveSite :=
  fun site =>
    if site = 0 then
      !![0, 0, 0, 0;
         0, 0, 2, 0;
         0, 0, 0, 0;
         0, 0, 0, 0]
    else 0

/-- Explicit cross-polarized curvature carried by the integer-scaled cross
backreaction mode. -/
def crossBackreactionCurvature :
    NullWaveSite -> Fin 4 -> Fin 4 -> Fiber 6 :=
  fun site a b component =>
    2 * nullWaveAmplitude site *
      (nullWaveFaceOne a b * nullWavePolarizationTwo component -
        nullWaveFaceTwo a b * nullWavePolarizationOne component)

/-- Linear combination of the two curved link modes. -/
def plusCrossLinkCombination (plusScale crossScale : Real) :
    LinkVariation NullWaveSite :=
  plusScale • plusBackreactionLinkVariation +
    crossScale • crossBackreactionLinkVariation

/-- Linear combination of the matching coframe modes. -/
def plusCrossCoframeCombination (plusScale crossScale : Real) :
    CoframeField NullWaveSite :=
  plusScale • plusBackreactionCoframeVariation +
    crossScale • crossBackreactionCoframeVariation

/-- At identity links, the linearized coframe equation is exactly the first
Palatini coframe response paired with the additive plaquette curl. -/
theorem linearizedCoframeEulerFunctional_eq_palatiniDensityFirstVariation
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (site : Site) (probe : Matrix (Fin 4) (Fin 4) Real) :
    linearizedCoframeEulerFunctional shift linkVariation site probe =
      palatiniDensityFirstVariation 1 probe
        (additivePlaquetteCurl shift linkVariation site) := by
  unfold linearizedCoframeEulerFunctional palatiniDensityFirstVariation
    orderedPlaquetteActionFirstResponse
  simp_rw [plaquetteMatrixVariation_identity,
    normalizedTracePair_eq_kreinPair]

/-- Additive flatness makes every infinitesimal gauge-link tangent satisfy the
linearized coframe/Einstein sector. -/
theorem infinitesimalGauge_coframeStationary
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (hCommute : ShiftsCommute shift)
    (parameter : Site -> Fiber 6) :
    LinearizedCoframeStationary shift
      (infinitesimalGaugeLinkVariation shift parameter) := by
  intro site internal direction
  unfold linearizedCoframeEulerCoefficient
  rw [linearizedCoframeEulerFunctional_eq_palatiniDensityFirstVariation]
  have hCurl :
      additivePlaquetteCurl shift
          (infinitesimalGaugeLinkVariation shift parameter) site = 0 := by
    funext a b
    exact additivePlaquetteCurl_infinitesimalGaugeLinkVariation
      shift hCommute parameter site a b
  rw [hCurl]
  simp [palatiniDensityFirstVariation,
    kreinPair_lorentzBivector_eq_explicit]

set_option maxHeartbeats 1000000 in
/-- The plus-like link perturbation carries exactly twice the previously
verified periodic vacuum-Weyl curvature. -/
theorem additivePlaquetteCurl_plusBackreactionLinkVariation
    (site : NullWaveSite) (a b : Fin 4) :
    additivePlaquetteCurl nullWaveShift plusBackreactionLinkVariation
        site a b =
      (2 : Real) • nullWaveCurvature site a b := by
  funext component
  fin_cases site <;> fin_cases a <;> fin_cases b <;>
    simp [additivePlaquetteCurl, plusBackreactionLinkVariation,
      nullWaveCurvature, nullWaveShift, toggleFinTwo,
      nullWaveAmplitude, nullWavePotential, nullWaveFaceOne,
      nullWaveFaceTwo, nullWavePolarizationOne,
      nullWavePolarizationTwo] <;>
    ring

set_option maxHeartbeats 1000000 in
/-- The cross-like link perturbation realizes the displayed cross-polarized
curvature exactly. -/
theorem additivePlaquetteCurl_crossBackreactionLinkVariation
    (site : NullWaveSite) (a b : Fin 4) :
    additivePlaquetteCurl nullWaveShift crossBackreactionLinkVariation
        site a b =
      crossBackreactionCurvature site a b := by
  funext component
  fin_cases site <;> fin_cases a <;> fin_cases b <;>
    simp [additivePlaquetteCurl, crossBackreactionLinkVariation,
      crossBackreactionCurvature, nullWaveShift, toggleFinTwo,
      nullWaveAmplitude, nullWavePotential, nullWaveFaceOne,
      nullWaveFaceTwo, nullWavePolarizationOne,
      nullWavePolarizationTwo] <;>
    ring

/-- Face reversal negates the cross-polarized curvature. -/
theorem crossBackreactionCurvature_antisymmetric (site : NullWaveSite) :
    forall a b component,
      crossBackreactionCurvature site a b component =
        -crossBackreactionCurvature site b a component := by
  intro a b component
  fin_cases a <;> fin_cases b <;>
    simp [crossBackreactionCurvature, nullWaveFaceOne,
      nullWaveFaceTwo]

/-- Matrix conversion of the cross-polarized curvature. -/
theorem bivectorMatrix_crossBackreactionCurvature
    (site : NullWaveSite) (a b i j : Fin 4) :
    bivectorMatrix (crossBackreactionCurvature site a b) i j =
      2 * nullWaveAmplitude site *
        (nullWaveFaceOne a b *
            bivectorMatrix nullWavePolarizationTwo i j -
          nullWaveFaceTwo a b *
            bivectorMatrix nullWavePolarizationOne i j) := by
  fin_cases i <;> fin_cases j <;>
    simp +decide [crossBackreactionCurvature, bivectorMatrix,
      nullWavePolarizationOne, nullWavePolarizationTwo]

/-- The quarter-turned null polarizations cancel under Ricci contraction. -/
theorem crossBackreactionRicciContraction_cancel
    (coframeDirection raisedDirection : Fin 4) :
    Finset.sum Finset.univ (fun b =>
      nullWaveFaceOne coframeDirection b *
          bivectorMatrix nullWavePolarizationTwo raisedDirection b -
        nullWaveFaceTwo coframeDirection b *
          bivectorMatrix nullWavePolarizationOne raisedDirection b) = 0 := by
  fin_cases coframeDirection <;> fin_cases raisedDirection <;>
    simp +decide [nullWaveFaceOne, nullWaveFaceTwo,
      nullWavePolarizationOne, nullWavePolarizationTwo, bivectorMatrix,
      Fin.sum_univ_four]

/-- Every mixed Ricci entry of the cross-polarized curvature vanishes at the
identity inverse coframe. -/
theorem crossBackreactionCurvature_mixedRicci_zero
    (site : NullWaveSite) (coframeDirection raisedDirection : Fin 4) :
    mixedRicciCurvature (1 : Matrix (Fin 4) (Fin 4) Real)
        (crossBackreactionCurvature site)
        coframeDirection raisedDirection = 0 := by
  rw [mixedRicciCurvature_identity]
  simp_rw [bivectorMatrix_crossBackreactionCurvature]
  rw [<- Finset.mul_sum,
    crossBackreactionRicciContraction_cancel]
  ring

/-- The cross-polarized scalar curvature vanishes at the identity inverse
coframe. -/
theorem crossBackreactionCurvature_scalar_zero (site : NullWaveSite) :
    inverseCoframeScalarCurvature
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (crossBackreactionCurvature site) = 0 := by
  rw [show inverseCoframeScalarCurvature
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (crossBackreactionCurvature site) =
      Finset.sum Finset.univ (fun direction =>
        mixedRicciCurvature (1 : Matrix (Fin 4) (Fin 4) Real)
          (crossBackreactionCurvature site) direction direction) by
    simp [inverseCoframeScalarCurvature, mixedRicciCurvature,
      Matrix.one_apply, Fin.sum_univ_four]]
  simp [crossBackreactionCurvature_mixedRicci_zero]

/-- All mixed vacuum Einstein entries of the cross-polarized curvature vanish
pointwise. -/
theorem crossBackreactionCurvature_mixedVacuum
    (site : NullWaveSite) (coframeDirection raisedDirection : Fin 4) :
    mixedVacuumEinsteinEntry
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (crossBackreactionCurvature site)
        coframeDirection raisedDirection = 0 := by
  rw [mixedVacuumEinsteinEntry,
    crossBackreactionCurvature_mixedRicci_zero,
    crossBackreactionCurvature_scalar_zero]
  ring

/-- The plus-like link perturbation satisfies all thirty-two linearized
coframe/Einstein equations. -/
theorem plusBackreaction_coframeStationary :
    LinearizedCoframeStationary nullWaveShift
      plusBackreactionLinkVariation := by
  intro site internal direction
  unfold linearizedCoframeEulerCoefficient
  rw [linearizedCoframeEulerFunctional_eq_palatiniDensityFirstVariation]
  have hCurl :
      additivePlaquetteCurl nullWaveShift plusBackreactionLinkVariation site =
        (2 : Real) • nullWaveCurvature site := by
    funext a b
    exact additivePlaquetteCurl_plusBackreactionLinkVariation site a b
  rw [hCurl]
  rw [palatiniDensityFirstVariation_eq_det_mul_mixedEinstein
    (inverseCoframe := (1 : Matrix (Fin 4) (Fin 4) Real))]
  · have hMixed : forall coframeDirection raisedDirection,
        2 * mixedRicciCurvature (1 : Matrix (Fin 4) (Fin 4) Real)
              ((2 : Real) • nullWaveCurvature site)
              coframeDirection raisedDirection -
            (1 : Matrix (Fin 4) (Fin 4) Real)
                raisedDirection coframeDirection *
              inverseCoframeScalarCurvature
                (1 : Matrix (Fin 4) (Fin 4) Real)
                ((2 : Real) • nullWaveCurvature site) = 0 := by
      intro coframeDirection raisedDirection
      change mixedVacuumEinsteinEntry
          (1 : Matrix (Fin 4) (Fin 4) Real)
          ((2 : Real) • nullWaveCurvature site)
          coframeDirection raisedDirection = 0
      change mixedVacuumEinsteinEntryLinear
          (1 : Matrix (Fin 4) (Fin 4) Real)
          coframeDirection raisedDirection
          ((2 : Real) • nullWaveCurvature site) = 0
      rw [map_smul]
      change (2 : Real) * mixedVacuumEinsteinEntry
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (nullWaveCurvature site) coframeDirection raisedDirection = 0
      rw [nullWaveCurvature_mixedVacuum]
      ring
    have hCoefficient :=
      (mixedEinsteinCoframeCoefficient_vanish_iff
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (1 : Matrix (Fin 4) (Fin 4) Real)
        ((2 : Real) • nullWaveCurvature site)
        (by simp) (by simp)).2 hMixed
    simp only [Matrix.det_one, one_mul]
    apply Finset.sum_eq_zero
    intro coefficientInternal _
    apply Finset.sum_eq_zero
    intro coefficientDirection _
    rw [hCoefficient coefficientInternal coefficientDirection]
    ring
  · simp
  · intro a b component
    simp only [Pi.smul_apply, smul_eq_mul]
    rw [nullWaveCurvature_antisymmetric site a b component]
    ring

/-- The cross-like link perturbation satisfies all thirty-two linearized
coframe/Einstein equations. -/
theorem crossBackreaction_coframeStationary :
    LinearizedCoframeStationary nullWaveShift
      crossBackreactionLinkVariation := by
  intro site internal direction
  unfold linearizedCoframeEulerCoefficient
  rw [linearizedCoframeEulerFunctional_eq_palatiniDensityFirstVariation]
  have hCurl :
      additivePlaquetteCurl nullWaveShift crossBackreactionLinkVariation site =
        crossBackreactionCurvature site := by
    funext a b
    exact additivePlaquetteCurl_crossBackreactionLinkVariation site a b
  rw [hCurl]
  rw [palatiniDensityFirstVariation_eq_det_mul_mixedEinstein
    (inverseCoframe := (1 : Matrix (Fin 4) (Fin 4) Real))]
  · have hMixed : forall coframeDirection raisedDirection,
        2 * mixedRicciCurvature (1 : Matrix (Fin 4) (Fin 4) Real)
              (crossBackreactionCurvature site)
              coframeDirection raisedDirection -
            (1 : Matrix (Fin 4) (Fin 4) Real)
                raisedDirection coframeDirection *
              inverseCoframeScalarCurvature
                (1 : Matrix (Fin 4) (Fin 4) Real)
                (crossBackreactionCurvature site) = 0 := by
      intro coframeDirection raisedDirection
      simpa [mixedVacuumEinsteinEntry] using
        crossBackreactionCurvature_mixedVacuum
          site coframeDirection raisedDirection
    have hCoefficient :=
      (mixedEinsteinCoframeCoefficient_vanish_iff
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (crossBackreactionCurvature site)
        (by simp) (by simp)).2 hMixed
    simp only [Matrix.det_one, one_mul]
    apply Finset.sum_eq_zero
    intro coefficientInternal _
    apply Finset.sum_eq_zero
    intro coefficientDirection _
    rw [hCoefficient coefficientInternal coefficientDirection]
    ring
  · simp
  · exact crossBackreactionCurvature_antisymmetric site

/-- The Lorentz-generator coordinate map is additive. -/
theorem lorentzGenerator_add_local (left right : Fiber 6) :
    lorentzGenerator (left + right) =
      lorentzGenerator left + lorentzGenerator right := by
  unfold lorentzGenerator
  rw [bivectorMatrix_add, Matrix.add_mul]

/-- Six-vector coordinates of the Lorentz Lie bracket in the fixed bivector
basis. -/
def lorentzBracketCoordinates (left right : Fiber 6) : Fiber 6 :=
  ![
    left 1 * right 2 - left 2 * right 1 - left 3 * right 4 +
      left 4 * right 3,
    -left 0 * right 2 + left 2 * right 0 - left 3 * right 5 +
      left 5 * right 3,
    left 0 * right 1 - left 1 * right 0 - left 4 * right 5 +
      left 5 * right 4,
    -left 0 * right 4 - left 1 * right 5 + left 4 * right 0 +
      left 5 * right 1,
    left 0 * right 3 - left 2 * right 5 - left 3 * right 0 +
      left 5 * right 2,
    left 1 * right 3 + left 2 * right 4 - left 3 * right 1 -
      left 4 * right 2
  ]

/-- A right-trivialized link tangent at the identity is its Lorentz
generator. -/
theorem linkMatrixVariation_identity_local
    {Site : Type*} (variation : LinkVariation Site)
    (site : Site) (direction : Fin 4) :
    linkMatrixVariation (identityConnection Site) variation site direction =
      lorentzGenerator (variation site direction) := by
  simp [linkMatrixVariation, identityConnection, unitMatrix]

/-- A two-link tangent at the identity is the generator of the sum of its
two six-vector tangents. -/
theorem twoStepMatrixVariation_identity_local
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (variation : LinkVariation Site) (site : Site) (a b : Fin 4) :
    twoStepMatrixVariation shift (identityConnection Site) variation
        site a b =
      lorentzGenerator
        (variation site a + variation (shift a site) b) := by
  rw [lorentzGenerator_add_local]
  simp [twoStepMatrixVariation, linkMatrixVariation,
    identityConnection, unitMatrix]

/-- Six-vector form of one identity-background response branch. -/
def linearizedGeneratorFaceResponse
    (face faceVariation transportVariation probe holonomyVariation : Fiber 6) :
    Real :=
  -(1 / 2 : Real) * Matrix.trace
    (lorentzGenerator faceVariation * lorentzGenerator probe +
      lorentzGenerator face *
        (lorentzGenerator transportVariation * lorentzGenerator probe -
          lorentzGenerator probe * lorentzGenerator transportVariation +
          lorentzGenerator probe * lorentzGenerator holonomyVariation))

/-- Convention-locked cubic trace invariant of three Lorentz bivectors. -/
def lorentzTriplePair (left middle right : Fiber 6) : Real :=
  (1 / 2 : Real) *
    (left 0 * middle 1 * right 2 - left 0 * middle 2 * right 1 -
      left 0 * middle 3 * right 4 + left 0 * middle 4 * right 3 -
      left 1 * middle 0 * right 2 + left 1 * middle 2 * right 0 -
      left 1 * middle 3 * right 5 + left 1 * middle 5 * right 3 +
      left 2 * middle 0 * right 1 - left 2 * middle 1 * right 0 -
      left 2 * middle 4 * right 5 + left 2 * middle 5 * right 4 +
      left 3 * middle 0 * right 4 + left 3 * middle 1 * right 5 -
      left 3 * middle 4 * right 0 - left 3 * middle 5 * right 1 -
      left 4 * middle 0 * right 3 + left 4 * middle 2 * right 5 +
      left 4 * middle 3 * right 0 - left 4 * middle 5 * right 2 -
      left 5 * middle 1 * right 3 - left 5 * middle 2 * right 4 +
      left 5 * middle 3 * right 1 + left 5 * middle 4 * right 2)

/-- The cubic coordinate formula is exactly the normalized trace of three
Lorentz generators in the fixed mostly-minus convention. -/
theorem normalizedTraceTriple_eq_lorentzTriplePair
    (left middle right : Fiber 6) :
    -(1 / 2 : Real) * Matrix.trace
        (lorentzGenerator left * lorentzGenerator middle *
          lorentzGenerator right) =
      lorentzTriplePair left middle right := by
  simp [lorentzTriplePair, Matrix.trace, lorentzGenerator,
    bivectorMatrix, MinkowskiConvention.eta, Fin.sum_univ_four]
  ring

/-- Closed six-coordinate formula for one linearized response branch. -/
theorem linearizedGeneratorFaceResponse_eq_pairs
    (face faceVariation transportVariation probe holonomyVariation : Fiber 6) :
    linearizedGeneratorFaceResponse face faceVariation transportVariation
        probe holonomyVariation =
      kreinPair lorentzBivectorFundamentalSymmetry faceVariation probe +
        lorentzTriplePair face transportVariation probe -
        lorentzTriplePair face probe transportVariation +
        lorentzTriplePair face probe holonomyVariation := by
  unfold linearizedGeneratorFaceResponse
  simp only [Matrix.mul_add, Matrix.mul_sub, Matrix.trace_add,
    Matrix.trace_sub]
  simp_rw [<- Matrix.mul_assoc]
  calc
    _ = -(1 / 2 : Real) * Matrix.trace
          (lorentzGenerator faceVariation * lorentzGenerator probe) +
        (-(1 / 2 : Real) * Matrix.trace
          (lorentzGenerator face * lorentzGenerator transportVariation *
            lorentzGenerator probe)) -
        (-(1 / 2 : Real) * Matrix.trace
          (lorentzGenerator face * lorentzGenerator probe *
            lorentzGenerator transportVariation)) +
        (-(1 / 2 : Real) * Matrix.trace
          (lorentzGenerator face * lorentzGenerator probe *
            lorentzGenerator holonomyVariation)) := by ring
    _ = _ := by
      rw [normalizedTracePair_eq_kreinPair,
        normalizedTraceTriple_eq_lorentzTriplePair,
        normalizedTraceTriple_eq_lorentzTriplePair,
        normalizedTraceTriple_eq_lorentzTriplePair]

/-- Coordinate-only form of the identity-background linearized link Euler
functional. -/
def linearizedLinkEulerFunctionalCoordinates
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (direction : Fin 4) (probe : Fiber 6) : Real :=
  let identityCoframe := identityCoframeField Site
  Finset.sum Finset.univ (fun b =>
      linearizedGeneratorFaceResponse
        (coframeFaceWeight identityCoframe site direction b)
        (coframeFaceWeightFirstVariation
          identityCoframe coframeVariation site direction b)
        (linkVariation site direction) probe
        (additivePlaquetteCurl shift linkVariation site direction b)) +
    Finset.sum Finset.univ (fun a =>
      let predecessor := (shift a).symm site
      linearizedGeneratorFaceResponse
        (coframeFaceWeight identityCoframe predecessor a direction)
        (coframeFaceWeightFirstVariation
          identityCoframe coframeVariation predecessor a direction)
        (linkVariation predecessor a +
          linkVariation (shift a predecessor) direction)
        probe
        (additivePlaquetteCurl shift linkVariation predecessor a direction)) -
    Finset.sum Finset.univ (fun a =>
      linearizedGeneratorFaceResponse
        (coframeFaceWeight identityCoframe site a direction)
        (coframeFaceWeightFirstVariation
          identityCoframe coframeVariation site a direction)
        (additivePlaquetteCurl shift linkVariation site a direction +
          linkVariation site direction)
        probe
        (additivePlaquetteCurl shift linkVariation site a direction)) -
    Finset.sum Finset.univ (fun b =>
      let predecessor := (shift b).symm site
      linearizedGeneratorFaceResponse
        (coframeFaceWeight identityCoframe predecessor direction b)
        (coframeFaceWeightFirstVariation
          identityCoframe coframeVariation predecessor direction b)
        (linkVariation predecessor direction +
          linkVariation (shift direction predecessor) b)
        probe
        (additivePlaquetteCurl shift linkVariation predecessor direction b))

/-- The matrix-valued linearized link equation at identity is exactly its
six-vector coordinate form. -/
theorem linearizedLinkEulerFunctional_eq_coordinates
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (direction : Fin 4) (probe : Fiber 6) :
    linearizedLinkEulerFunctional shift linkVariation coframeVariation
        site direction probe =
      linearizedLinkEulerFunctionalCoordinates shift linkVariation
        coframeVariation site direction probe := by
  unfold linearizedLinkEulerFunctional
    linearizedLinkEulerFunctionalCoordinates
    linearizedWeightedAdjointFaceResponse
    linearizedGeneratorFaceResponse
  simp_rw [linkMatrixVariation_identity_local,
    twoStepMatrixVariation_identity_local,
    plaquetteMatrixVariation_identity,
    <- lorentzGenerator_add_local]

/-- Sparse six-vector table of the complementary face weights at the identity
coframe. -/
def identityPalatiniFaceCoordinates : Fin 4 -> Fin 4 -> Fiber 6 :=
  ![
    ![0, ![0, 0, 0, 1, 0, 0], ![0, 0, 0, 0, 1, 0],
      ![0, 0, 0, 0, 0, 1]],
    ![![0, 0, 0, -1, 0, 0], 0, ![-1, 0, 0, 0, 0, 0],
      ![0, -1, 0, 0, 0, 0]],
    ![![0, 0, 0, 0, -1, 0], ![1, 0, 0, 0, 0, 0], 0,
      ![0, 0, -1, 0, 0, 0]],
    ![![0, 0, 0, 0, 0, -1], ![0, 1, 0, 0, 0, 0],
      ![0, 0, 1, 0, 0, 0], 0]
  ]

/-- Sparse six-vector table of the plus shear's complementary face first
variation at its supported site. -/
def plusBackreactionFaceVariationCoordinates :
    NullWaveSite -> Fin 4 -> Fin 4 -> Fiber 6 :=
  fun site =>
    if site = 0 then
      ![
        ![0, ![0, 0, 0, 1, 0, 0], ![0, 0, 0, 0, -1, 0], 0],
        ![![0, 0, 0, -1, 0, 0], 0, 0, ![0, -1, 0, 0, 0, 0]],
        ![![0, 0, 0, 0, 1, 0], 0, 0, ![0, 0, 1, 0, 0, 0]],
        ![0, ![0, 1, 0, 0, 0, 0], ![0, 0, -1, 0, 0, 0], 0]
      ]
    else 0

/-- Sparse six-vector table of the cross shear's complementary face first
variation at its supported site. -/
def crossBackreactionFaceVariationCoordinates :
    NullWaveSite -> Fin 4 -> Fin 4 -> Fiber 6 :=
  fun site =>
    if site = 0 then
      ![
        ![0, ![0, 0, 0, 0, -2, 0], 0, 0],
        ![![0, 0, 0, 0, 2, 0], 0, 0, ![0, 0, 2, 0, 0, 0]],
        ![0, 0, 0, 0],
        ![0, ![0, 0, -2, 0, 0, 0], 0, 0]
      ]
    else 0

set_option maxHeartbeats 1000000 in
/-- The displayed identity-face table is exact. -/
theorem coframeFaceWeight_identity_eq_coordinates
    {Site : Type*} (site : Site) (a b : Fin 4) :
    coframeFaceWeight (identityCoframeField Site) site a b =
      identityPalatiniFaceCoordinates a b := by
  funext component
  fin_cases a <;> fin_cases b <;> fin_cases component <;>
    simp +decide [coframeFaceWeight, identityCoframeField,
      identityPalatiniFaceCoordinates,
      complementaryPalatiniFaceWeight, palatiniFaceWeight, coframeWedge,
      LorentzBivectorKreinBridge.bivectorFirst,
      LorentzBivectorKreinBridge.bivectorSecond,
      spacetimeAlternatingSymbol, lorentzHodgeStar, transportApply,
      Matrix.one_apply, Fin.sum_univ_four, Fin.sum_univ_six] <;>
    ring

set_option maxHeartbeats 2000000 in
/-- The first variation of an identity-coframe face along an infinitesimal
Lorentz gauge orbit is the Lorentz bracket with that face. -/
theorem coframeFaceWeightFirstVariation_gauge_eq_bracket
    {Site : Type*} (parameter : Site -> Fiber 6)
    (site : Site) (a b : Fin 4) :
    coframeFaceWeightFirstVariation
        (identityCoframeField Site)
        (infinitesimalGaugeCoframeVariation parameter) site a b =
      lorentzBracketCoordinates (parameter site)
        (identityPalatiniFaceCoordinates a b) := by
  funext component
  fin_cases a <;> fin_cases b <;> fin_cases component <;>
    simp +decide [coframeFaceWeightFirstVariation, identityCoframeField,
      infinitesimalGaugeCoframeVariation,
      identityPalatiniFaceCoordinates, lorentzBracketCoordinates,
      complementaryPalatiniFaceWeightFirstVariation,
      palatiniFaceWeightFirstVariation, coframeWedgeFirstVariation,
      lorentzGenerator, bivectorMatrix, MinkowskiConvention.eta,
      LorentzBivectorKreinBridge.bivectorFirst,
      LorentzBivectorKreinBridge.bivectorSecond,
      spacetimeAlternatingSymbol, lorentzHodgeStar, transportApply,
      Matrix.mul_apply, Matrix.one_apply,
      Fin.sum_univ_four, Fin.sum_univ_six] <;>
    ring

set_option maxHeartbeats 2000000 in
/-- The displayed plus-shear face-variation table is exact. -/
theorem coframeFaceWeightFirstVariation_plus_eq_coordinates
    (site : NullWaveSite) (a b : Fin 4) :
    coframeFaceWeightFirstVariation
        (identityCoframeField NullWaveSite)
        plusBackreactionCoframeVariation site a b =
      plusBackreactionFaceVariationCoordinates site a b := by
  funext component
  fin_cases site <;> fin_cases a <;> fin_cases b <;> fin_cases component <;>
    simp +decide [coframeFaceWeightFirstVariation, identityCoframeField,
      plusBackreactionCoframeVariation,
      plusBackreactionFaceVariationCoordinates,
      complementaryPalatiniFaceWeightFirstVariation,
      palatiniFaceWeightFirstVariation, coframeWedgeFirstVariation,
      LorentzBivectorKreinBridge.bivectorFirst,
      LorentzBivectorKreinBridge.bivectorSecond,
      spacetimeAlternatingSymbol, lorentzHodgeStar, transportApply,
      Matrix.one_apply, Fin.sum_univ_four, Fin.sum_univ_six] <;>
    ring

set_option maxHeartbeats 2000000 in
/-- The displayed cross-shear face-variation table is exact. -/
theorem coframeFaceWeightFirstVariation_cross_eq_coordinates
    (site : NullWaveSite) (a b : Fin 4) :
    coframeFaceWeightFirstVariation
        (identityCoframeField NullWaveSite)
        crossBackreactionCoframeVariation site a b =
      crossBackreactionFaceVariationCoordinates site a b := by
  funext component
  fin_cases site <;> fin_cases a <;> fin_cases b <;> fin_cases component <;>
    simp +decide [coframeFaceWeightFirstVariation, identityCoframeField,
      crossBackreactionCoframeVariation,
      crossBackreactionFaceVariationCoordinates,
      complementaryPalatiniFaceWeightFirstVariation,
      palatiniFaceWeightFirstVariation, coframeWedgeFirstVariation,
      LorentzBivectorKreinBridge.bivectorFirst,
      LorentzBivectorKreinBridge.bivectorSecond,
      spacetimeAlternatingSymbol, lorentzHodgeStar, transportApply,
      Matrix.one_apply, Fin.sum_univ_four, Fin.sum_univ_six] <;>
    ring

/-- The combined plus/cross coframe mode has the corresponding linear
combination of the two sparse face-variation tables. -/
theorem coframeFaceWeightFirstVariation_plusCross_eq_coordinates
    (plusScale crossScale : Real) (site : NullWaveSite) (a b : Fin 4) :
    coframeFaceWeightFirstVariation
        (identityCoframeField NullWaveSite)
        (plusCrossCoframeCombination plusScale crossScale) site a b =
      plusScale • plusBackreactionFaceVariationCoordinates site a b +
        crossScale • crossBackreactionFaceVariationCoordinates site a b := by
  unfold plusCrossCoframeCombination coframeFaceWeightFirstVariation
  simp only [Pi.add_apply, Pi.smul_apply]
  rw [complementaryPalatiniFaceWeightFirstVariation_add,
    complementaryPalatiniFaceWeightFirstVariation_smul,
    complementaryPalatiniFaceWeightFirstVariation_smul]
  change plusScale •
        coframeFaceWeightFirstVariation
          (identityCoframeField NullWaveSite)
          plusBackreactionCoframeVariation site a b +
      crossScale •
        coframeFaceWeightFirstVariation
          (identityCoframeField NullWaveSite)
          crossBackreactionCoframeVariation site a b = _
  rw [coframeFaceWeightFirstVariation_plus_eq_coordinates,
    coframeFaceWeightFirstVariation_cross_eq_coordinates]

set_option maxHeartbeats 5000000 in
/-- The plus-like link/coframe pair satisfies all forty-eight linearized
connection equations. -/
theorem plusBackreaction_linkStationary :
    LinearizedLinkStationary nullWaveShift plusBackreactionLinkVariation
      plusBackreactionCoframeVariation := by
  intro site direction component
  unfold linearizedLinkEulerCoefficient
  rw [linearizedLinkEulerFunctional_eq_coordinates]
  unfold linearizedLinkEulerFunctionalCoordinates
  simp_rw [linearizedGeneratorFaceResponse_eq_pairs]
  simp_rw [coframeFaceWeight_identity_eq_coordinates,
    coframeFaceWeightFirstVariation_plus_eq_coordinates]
  fin_cases site <;> fin_cases direction <;> fin_cases component <;>
    simp +decide [lorentzTriplePair, plusBackreactionLinkVariation,
      identityPalatiniFaceCoordinates,
      plusBackreactionFaceVariationCoordinates,
      additivePlaquetteCurl, nullWaveShift, toggleFinTwo, nullWaveAmplitude,
      nullWavePotential, nullWavePolarizationOne,
      nullWavePolarizationTwo,
      kreinPair_lorentzBivector_eq_explicit,
      Fin.sum_univ_four] <;>
    ring

set_option maxHeartbeats 5000000 in
/-- The cross-like link/coframe pair satisfies all forty-eight linearized
connection equations. -/
theorem crossBackreaction_linkStationary :
    LinearizedLinkStationary nullWaveShift crossBackreactionLinkVariation
      crossBackreactionCoframeVariation := by
  intro site direction component
  unfold linearizedLinkEulerCoefficient
  rw [linearizedLinkEulerFunctional_eq_coordinates]
  unfold linearizedLinkEulerFunctionalCoordinates
  simp_rw [linearizedGeneratorFaceResponse_eq_pairs]
  simp_rw [coframeFaceWeight_identity_eq_coordinates,
    coframeFaceWeightFirstVariation_cross_eq_coordinates]
  fin_cases site <;> fin_cases direction <;> fin_cases component <;>
    simp +decide [lorentzTriplePair, crossBackreactionLinkVariation,
      identityPalatiniFaceCoordinates,
      crossBackreactionFaceVariationCoordinates,
      additivePlaquetteCurl, nullWaveShift, toggleFinTwo, nullWaveAmplitude,
      nullWavePotential, nullWavePolarizationOne,
      nullWavePolarizationTwo,
      kreinPair_lorentzBivector_eq_explicit,
      Fin.sum_univ_four] <;>
    ring

set_option maxHeartbeats 5000000 in
/-- Every real plus/cross combination satisfies all forty-eight linearized
connection equations. -/
theorem plusCrossCombination_linkStationary
    (plusScale crossScale : Real) :
    LinearizedLinkStationary nullWaveShift
      (plusCrossLinkCombination plusScale crossScale)
      (plusCrossCoframeCombination plusScale crossScale) := by
  intro site direction component
  unfold linearizedLinkEulerCoefficient
  rw [linearizedLinkEulerFunctional_eq_coordinates]
  unfold linearizedLinkEulerFunctionalCoordinates
  simp_rw [linearizedGeneratorFaceResponse_eq_pairs]
  simp_rw [coframeFaceWeight_identity_eq_coordinates,
    coframeFaceWeightFirstVariation_plusCross_eq_coordinates]
  fin_cases site <;> fin_cases direction <;> fin_cases component <;>
    simp +decide [lorentzTriplePair, plusCrossLinkCombination,
      plusBackreactionLinkVariation, crossBackreactionLinkVariation,
      identityPalatiniFaceCoordinates,
      plusBackreactionFaceVariationCoordinates,
      crossBackreactionFaceVariationCoordinates,
      additivePlaquetteCurl, nullWaveShift, toggleFinTwo, nullWaveAmplitude,
      nullWavePotential, nullWavePolarizationOne,
      nullWavePolarizationTwo,
      kreinPair_lorentzBivector_eq_explicit,
      Fin.sum_univ_four] <;>
    ring

set_option maxHeartbeats 5000000 in
/-- Every site-local infinitesimal Lorentz gauge parameter on the two-site
carrier lies in the linearized connection-equation kernel. -/
theorem nullWave_infinitesimalGauge_linkStationary
    (parameter : NullWaveSite -> Fiber 6) :
    LinearizedLinkStationary nullWaveShift
      (infinitesimalGaugeLinkVariation nullWaveShift parameter)
      (infinitesimalGaugeCoframeVariation parameter) := by
  intro site direction component
  unfold linearizedLinkEulerCoefficient
  rw [linearizedLinkEulerFunctional_eq_coordinates]
  unfold linearizedLinkEulerFunctionalCoordinates
  simp_rw [linearizedGeneratorFaceResponse_eq_pairs,
    coframeFaceWeight_identity_eq_coordinates,
    coframeFaceWeightFirstVariation_gauge_eq_bracket,
    additivePlaquetteCurl_infinitesimalGaugeLinkVariation
      nullWaveShift nullWaveShift_commute parameter]
  fin_cases site <;> fin_cases direction <;> fin_cases component <;>
    simp +decide [lorentzTriplePair, lorentzBracketCoordinates,
      infinitesimalGaugeLinkVariation, identityPalatiniFaceCoordinates,
      nullWaveShift, toggleFinTwo,
      kreinPair_lorentzBivector_eq_explicit, Fin.sum_univ_four] <;>
    ring

/-- Every site-local infinitesimal Lorentz gauge parameter on the two-site
carrier lies in the full joint Hessian kernel. -/
theorem nullWave_infinitesimalGauge_jointStationary
    (parameter : NullWaveSite -> Fiber 6) :
    LinearizedJointStationary nullWaveShift
      (infinitesimalGaugeLinkVariation nullWaveShift parameter)
      (infinitesimalGaugeCoframeVariation parameter) :=
  ⟨nullWave_infinitesimalGauge_linkStationary parameter,
    infinitesimalGauge_coframeStationary
      nullWaveShift nullWaveShift_commute parameter⟩

/-- Combined link/coframe tangent of the infinitesimal gauge orbit. -/
def nullWaveInfinitesimalGaugePair
    (parameter : NullWaveSite -> Fiber 6) :
    LinkVariation NullWaveSite × CoframeField NullWaveSite :=
  (infinitesimalGaugeLinkVariation nullWaveShift parameter,
    infinitesimalGaugeCoframeVariation parameter)

/-- The coframe component makes the twelve-parameter infinitesimal gauge
family injective, so none of its parameter directions is silently lost. -/
theorem nullWaveInfinitesimalGaugePair_injective :
    Function.Injective nullWaveInfinitesimalGaugePair := by
  intro left right hPair
  have hCoframe :
      infinitesimalGaugeCoframeVariation left =
        infinitesimalGaugeCoframeVariation right :=
    congrArg Prod.snd hPair
  funext site
  apply lorentzGenerator_injective
  exact congrFun hCoframe site

/-- The plus-like link perturbation has nonzero additive curvature at both
sites. -/
theorem plusBackreaction_curvature_ne_zero (site : NullWaveSite) :
    additivePlaquetteCurl nullWaveShift plusBackreactionLinkVariation site ≠
      0 := by
  have hCurl :
      additivePlaquetteCurl nullWaveShift plusBackreactionLinkVariation site =
        (2 : Real) • nullWaveCurvature site := by
    funext a b
    exact additivePlaquetteCurl_plusBackreactionLinkVariation site a b
  rw [hCurl]
  exact smul_ne_zero (by norm_num) (nullWaveCurvature_ne_zero site)

/-- The cross-like link perturbation has nonzero additive curvature at both
sites. -/
theorem crossBackreaction_curvature_ne_zero (site : NullWaveSite) :
    additivePlaquetteCurl nullWaveShift crossBackreactionLinkVariation site ≠
      0 := by
  have hCurl :
      additivePlaquetteCurl nullWaveShift crossBackreactionLinkVariation site =
        crossBackreactionCurvature site := by
    funext a b
    exact additivePlaquetteCurl_crossBackreactionLinkVariation site a b
  rw [hCurl]
  intro hZero
  have hEntry := congrFun (congrFun (congrFun hZero 0) 1) 2
  fin_cases site <;>
    norm_num [crossBackreactionCurvature, nullWaveAmplitude,
      nullWavePotential, toggleFinTwo, nullWaveFaceOne,
      nullWaveFaceTwo, nullWavePolarizationOne,
      nullWavePolarizationTwo] at hEntry
  all_goals simp at hEntry

/-- The explicit plus-like pair is a jointly stationary, curved solution of
the identity-background linearized Palatini equations. -/
theorem plusBackreaction_jointStationary :
    LinearizedJointStationary nullWaveShift plusBackreactionLinkVariation
      plusBackreactionCoframeVariation :=
  ⟨plusBackreaction_linkStationary,
    plusBackreaction_coframeStationary⟩

/-- The explicit cross-like pair is a jointly stationary, curved solution of
the identity-background linearized Palatini equations. -/
theorem crossBackreaction_jointStationary :
    LinearizedJointStationary nullWaveShift crossBackreactionLinkVariation
      crossBackreactionCoframeVariation :=
  ⟨crossBackreaction_linkStationary,
    crossBackreaction_coframeStationary⟩

/-- The additive curvature map takes the combined link mode to the matching
combination of plus and cross curvatures. -/
theorem additivePlaquetteCurl_plusCrossLinkCombination
    (plusScale crossScale : Real) (site : NullWaveSite) :
    additivePlaquetteCurl nullWaveShift
        (plusCrossLinkCombination plusScale crossScale) site =
      plusScale •
          additivePlaquetteCurl nullWaveShift
            plusBackreactionLinkVariation site +
        crossScale •
          additivePlaquetteCurl nullWaveShift
            crossBackreactionLinkVariation site := by
  funext a b component
  simp [plusCrossLinkCombination, additivePlaquetteCurl]
  ring

/-- Every plus/cross curvature combination satisfies the mixed vacuum Einstein
equation at the identity inverse coframe. -/
theorem plusCrossCombinationCurvature_mixedVacuum
    (plusScale crossScale : Real) (site : NullWaveSite)
    (coframeDirection raisedDirection : Fin 4) :
    mixedVacuumEinsteinEntry
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (additivePlaquetteCurl nullWaveShift
          (plusCrossLinkCombination plusScale crossScale) site)
        coframeDirection raisedDirection = 0 := by
  rw [additivePlaquetteCurl_plusCrossLinkCombination]
  change mixedVacuumEinsteinEntryLinear
      (1 : Matrix (Fin 4) (Fin 4) Real)
      coframeDirection raisedDirection
      (plusScale •
          additivePlaquetteCurl nullWaveShift
            plusBackreactionLinkVariation site +
        crossScale •
          additivePlaquetteCurl nullWaveShift
            crossBackreactionLinkVariation site) = 0
  rw [map_add, map_smul, map_smul]
  have hPlusCurl :
      additivePlaquetteCurl nullWaveShift plusBackreactionLinkVariation site =
        (2 : Real) • nullWaveCurvature site := by
    funext a b
    exact additivePlaquetteCurl_plusBackreactionLinkVariation site a b
  have hCrossCurl :
      additivePlaquetteCurl nullWaveShift crossBackreactionLinkVariation site =
        crossBackreactionCurvature site := by
    funext a b
    exact additivePlaquetteCurl_crossBackreactionLinkVariation site a b
  rw [hPlusCurl, hCrossCurl]
  change plusScale *
        (mixedVacuumEinsteinEntryLinear
          (1 : Matrix (Fin 4) (Fin 4) Real)
          coframeDirection raisedDirection
          ((2 : Real) • nullWaveCurvature site)) +
      crossScale * mixedVacuumEinsteinEntry
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (crossBackreactionCurvature site)
        coframeDirection raisedDirection = 0
  rw [map_smul]
  change plusScale *
        ((2 : Real) * mixedVacuumEinsteinEntry
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (nullWaveCurvature site)
          coframeDirection raisedDirection) +
      crossScale * mixedVacuumEinsteinEntry
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (crossBackreactionCurvature site)
        coframeDirection raisedDirection = 0
  rw [nullWaveCurvature_mixedVacuum,
    crossBackreactionCurvature_mixedVacuum]
  ring

/-- Every real plus/cross combination satisfies all thirty-two linearized
coframe/Einstein equations. -/
theorem plusCrossCombination_coframeStationary
    (plusScale crossScale : Real) :
    LinearizedCoframeStationary nullWaveShift
      (plusCrossLinkCombination plusScale crossScale) := by
  intro site internal direction
  unfold linearizedCoframeEulerCoefficient
  rw [linearizedCoframeEulerFunctional_eq_palatiniDensityFirstVariation]
  rw [palatiniDensityFirstVariation_eq_det_mul_mixedEinstein
    (inverseCoframe := (1 : Matrix (Fin 4) (Fin 4) Real))]
  · have hMixed : forall coframeDirection raisedDirection,
        2 * mixedRicciCurvature (1 : Matrix (Fin 4) (Fin 4) Real)
              (additivePlaquetteCurl nullWaveShift
                (plusCrossLinkCombination plusScale crossScale) site)
              coframeDirection raisedDirection -
            (1 : Matrix (Fin 4) (Fin 4) Real)
                raisedDirection coframeDirection *
              inverseCoframeScalarCurvature
                (1 : Matrix (Fin 4) (Fin 4) Real)
                (additivePlaquetteCurl nullWaveShift
                  (plusCrossLinkCombination plusScale crossScale) site) = 0 := by
      intro coframeDirection raisedDirection
      simpa [mixedVacuumEinsteinEntry] using
        plusCrossCombinationCurvature_mixedVacuum
          plusScale crossScale site coframeDirection raisedDirection
    have hCoefficient :=
      (mixedEinsteinCoframeCoefficient_vanish_iff
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (additivePlaquetteCurl nullWaveShift
          (plusCrossLinkCombination plusScale crossScale) site)
        (by simp) (by simp)).2 hMixed
    simp only [Matrix.det_one, one_mul]
    apply Finset.sum_eq_zero
    intro coefficientInternal _
    apply Finset.sum_eq_zero
    intro coefficientDirection _
    rw [hCoefficient coefficientInternal coefficientDirection]
    ring
  · simp
  · exact additivePlaquetteCurl_antisymmetric_local
      nullWaveShift (plusCrossLinkCombination plusScale crossScale) site

/-- The plus/cross span is a two-parameter family in the full joint
linearized Palatini kernel. -/
theorem plusCrossCombination_jointStationary
    (plusScale crossScale : Real) :
    LinearizedJointStationary nullWaveShift
      (plusCrossLinkCombination plusScale crossScale)
      (plusCrossCoframeCombination plusScale crossScale) :=
  ⟨plusCrossCombination_linkStationary plusScale crossScale,
    plusCrossCombination_coframeStationary plusScale crossScale⟩

/-- At site zero, the plus and cross curvatures have independent coordinate
projections, so a zero combination has zero coefficients. -/
theorem plusCrossCurvature_coefficients_zero
    (plusScale crossScale : Real)
    (hZero :
      plusScale •
          additivePlaquetteCurl nullWaveShift
            plusBackreactionLinkVariation 0 +
        crossScale •
          additivePlaquetteCurl nullWaveShift
            crossBackreactionLinkVariation 0 = 0) :
    plusScale = 0 ∧ crossScale = 0 := by
  have hPlus := congrFun (congrFun (congrFun hZero 0) 1) 1
  have hCross := congrFun (congrFun (congrFun hZero 0) 1) 2
  simp +decide [additivePlaquetteCurl, plusBackreactionLinkVariation,
    crossBackreactionLinkVariation, nullWaveShift, toggleFinTwo,
    nullWaveAmplitude, nullWavePotential, nullWavePolarizationOne,
    nullWavePolarizationTwo] at hPlus hCross
  norm_num at hPlus
  exact ⟨hPlus, hCross⟩

/-- No nonzero plus/cross curvature combination belongs to the flat
infinitesimal local Lorentz orbit. This is the exact gauge-quotient
independence statement for the two displayed polarizations. -/
theorem plusCrossCombination_not_infinitesimalGauge
    (plusScale crossScale : Real)
    (hNonzero : plusScale ≠ 0 ∨ crossScale ≠ 0)
    (parameter : NullWaveSite -> Fiber 6) :
    nullWaveInfinitesimalGaugePair parameter ≠
      (plusCrossLinkCombination plusScale crossScale,
        plusCrossCoframeCombination plusScale crossScale) := by
  intro hPair
  have hLink :
      infinitesimalGaugeLinkVariation nullWaveShift parameter =
        plusCrossLinkCombination plusScale crossScale :=
    congrArg Prod.fst hPair
  have hGaugeCurl :
      additivePlaquetteCurl nullWaveShift
          (infinitesimalGaugeLinkVariation nullWaveShift parameter) 0 = 0 := by
    funext a b
    exact additivePlaquetteCurl_infinitesimalGaugeLinkVariation
      nullWaveShift nullWaveShift_commute parameter 0 a b
  have hCombinationCurl :
      additivePlaquetteCurl nullWaveShift
          (plusCrossLinkCombination plusScale crossScale) 0 = 0 := by
    rw [<- hLink]
    exact hGaugeCurl
  rw [additivePlaquetteCurl_plusCrossLinkCombination] at hCombinationCurl
  have hCoefficients := plusCrossCurvature_coefficients_zero
    plusScale crossScale hCombinationCurl
  exact hNonzero.elim (fun h => h hCoefficients.1)
    (fun h => h hCoefficients.2)

/-- The curved plus-like stationary mode survives quotienting by the
infinitesimal local Lorentz orbit. -/
theorem plusBackreaction_not_infinitesimalGauge
    (parameter : NullWaveSite -> Fiber 6) :
    nullWaveInfinitesimalGaugePair parameter ≠
      (plusBackreactionLinkVariation,
        plusBackreactionCoframeVariation) := by
  intro hPair
  have hLink :
      infinitesimalGaugeLinkVariation nullWaveShift parameter =
        plusBackreactionLinkVariation :=
    congrArg Prod.fst hPair
  have hGaugeCurl :
      additivePlaquetteCurl nullWaveShift
          (infinitesimalGaugeLinkVariation nullWaveShift parameter) 0 = 0 := by
    funext a b
    exact additivePlaquetteCurl_infinitesimalGaugeLinkVariation
      nullWaveShift nullWaveShift_commute parameter 0 a b
  have hPlusCurl :
      additivePlaquetteCurl nullWaveShift
          plusBackreactionLinkVariation 0 = 0 := by
    rw [<- hLink]
    exact hGaugeCurl
  exact plusBackreaction_curvature_ne_zero 0 hPlusCurl

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.plusBackreaction_curvature_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plusBackreaction_curvature_ne_zero

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.plusBackreaction_jointStationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plusBackreaction_jointStationary

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.nullWave_infinitesimalGauge_jointStationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWave_infinitesimalGauge_jointStationary

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.nullWaveInfinitesimalGaugePair_injective' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nullWaveInfinitesimalGaugePair_injective

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.plusBackreaction_not_infinitesimalGauge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plusBackreaction_not_infinitesimalGauge

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.crossBackreactionCurvature_mixedVacuum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms crossBackreactionCurvature_mixedVacuum

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.crossBackreaction_jointStationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms crossBackreaction_jointStationary

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.plusCrossCombination_not_infinitesimalGauge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plusCrossCombination_not_infinitesimalGauge

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction.plusCrossCombination_jointStationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms plusCrossCombination_jointStationary

end PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction

```

### PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEinsteinResponse.lean (1027 lines)

```lean
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge

noncomputable section

/-!
# Exact coframe response of the nonlinear Lorentz Palatini density

This module closes the local algebraic response gate left by
`NonlinearLorentzPalatiniEinsteinBridge`.  For an invertible coframe and a
curvature face antisymmetric in its two spacetime directions, it proves that
the ordinary coframe first response is the oriented determinant times the
coframe-index mixed Einstein coefficient paired with the arbitrary coframe
variation.

The proof factors through the exterior-square action of elementary coframe
column operations.  The determinant trace gives the scalar-curvature term;
the two cofactor insertions agree by face antisymmetry and give twice the mixed
Ricci term.  These are exact finite identities.  They do not identify the
extracted plaquette field with continuum Riemann curvature, derive
Levi-Civita selection, or supply dual-cell volume weights.  Claim label:
finite identity.  The tetradic response formula is standard `[import]`; its
normalization in the project bivector/Hodge/Krein convention is `[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge

open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler

set_option maxHeartbeats 3000000

namespace ResponseProof

private lemma responseAlternatingWedge
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a b i j : Fin 4) :
    (1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
      Finset.sum Finset.univ (fun d =>
        spacetimeAlternatingSymbol c d a b *
          (coframe i c * coframe j d -
            coframe i d * coframe j c))) =
      Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          spacetimeAlternatingSymbol c d a b *
            coframe i c * coframe j d)) := by
  fin_cases a <;> fin_cases b <;>
    simp [spacetimeAlternatingSymbol, Fin.sum_univ_four] <;> ring

theorem det_mul_inverse_pair
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (a b i j : Fin 4) :
    coframe.det *
        (inverseCoframe a i * inverseCoframe b j -
          inverseCoframe a j * inverseCoframe b i) =
      (1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          Finset.sum Finset.univ (fun k =>
            Finset.sum Finset.univ (fun l =>
              spacetimeAlternatingSymbol a b c d *
                spacetimeAlternatingSymbol i j k l *
                coframe k c * coframe l d)))) := by
  have hInner : forall k l : Fin 4,
      Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          spacetimeAlternatingSymbol a b c d *
            coframe k c * coframe l d)) =
        coframe.det * Finset.sum Finset.univ (fun p =>
          Finset.sum Finset.univ (fun q =>
            spacetimeAlternatingSymbol k l p q *
              inverseCoframe a p * inverseCoframe b q)) := by
    intro k l
    have h := alternating_coframe_two_minor
      coframe inverseCoframe hLeft a b k l
    rw [responseAlternatingWedge] at h
    have hSymbol : forall c d : Fin 4,
        spacetimeAlternatingSymbol c d a b =
          spacetimeAlternatingSymbol a b c d := by
      intro c d
      unfold spacetimeAlternatingSymbol
      ring
    simpa only [hSymbol] using h
  have hInversePair :
      inverseCoframe a i * inverseCoframe b j -
          inverseCoframe a j * inverseCoframe b i =
        (1 / 2 : Real) * Finset.sum Finset.univ (fun k =>
          Finset.sum Finset.univ (fun l =>
            spacetimeAlternatingSymbol i j k l *
              Finset.sum Finset.univ (fun p =>
                Finset.sum Finset.univ (fun q =>
                  spacetimeAlternatingSymbol k l p q *
                    inverseCoframe a p * inverseCoframe b q)))) := by
    fin_cases i <;> fin_cases j <;>
      simp +decide [spacetimeAlternatingSymbol, Fin.sum_univ_four] <;> ring
  rw [hInversePair]
  calc
    coframe.det *
          ((1 / 2 : Real) * Finset.sum Finset.univ (fun k =>
            Finset.sum Finset.univ (fun l =>
              spacetimeAlternatingSymbol i j k l *
                Finset.sum Finset.univ (fun p =>
                  Finset.sum Finset.univ (fun q =>
                    spacetimeAlternatingSymbol k l p q *
                      inverseCoframe a p * inverseCoframe b q))))) =
        (1 / 2 : Real) *
          (coframe.det * Finset.sum Finset.univ (fun k =>
            Finset.sum Finset.univ (fun l =>
              spacetimeAlternatingSymbol i j k l *
                Finset.sum Finset.univ (fun p =>
                  Finset.sum Finset.univ (fun q =>
                    spacetimeAlternatingSymbol k l p q *
                      inverseCoframe a p * inverseCoframe b q))))) := by ring
    _ = _ := by
      congr 1
      calc
        coframe.det * Finset.sum Finset.univ (fun k =>
              Finset.sum Finset.univ (fun l =>
                spacetimeAlternatingSymbol i j k l *
                  Finset.sum Finset.univ (fun p =>
                    Finset.sum Finset.univ (fun q =>
                      spacetimeAlternatingSymbol k l p q *
                        inverseCoframe a p * inverseCoframe b q)))) =
            Finset.sum Finset.univ (fun k =>
              Finset.sum Finset.univ (fun l =>
                coframe.det *
                  (spacetimeAlternatingSymbol i j k l *
                    Finset.sum Finset.univ (fun p =>
                      Finset.sum Finset.univ (fun q =>
                        spacetimeAlternatingSymbol k l p q *
                          inverseCoframe a p * inverseCoframe b q))))) := by
            simp only [Finset.mul_sum]
        _ = Finset.sum Finset.univ (fun k =>
              Finset.sum Finset.univ (fun l =>
                spacetimeAlternatingSymbol i j k l *
                  Finset.sum Finset.univ (fun c =>
                    Finset.sum Finset.univ (fun d =>
                      spacetimeAlternatingSymbol a b c d *
                        coframe k c * coframe l d)))) := by
            apply Finset.sum_congr rfl
            intro k _
            apply Finset.sum_congr rfl
            intro l _
            rw [hInner k l]
            ring
        _ = Finset.sum Finset.univ (fun k =>
              Finset.sum Finset.univ (fun l =>
                Finset.sum Finset.univ (fun c =>
                  Finset.sum Finset.univ (fun d =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                        coframe k c * coframe l d)))) := by
            apply Finset.sum_congr rfl
            intro k _
            apply Finset.sum_congr rfl
            intro l _
            simp only [Finset.mul_sum]
            apply Finset.sum_congr rfl
            intro c _
            apply Finset.sum_congr rfl
            intro d _
            ring
        _ = Finset.sum Finset.univ (fun k =>
              Finset.sum Finset.univ (fun c =>
                Finset.sum Finset.univ (fun l =>
                  Finset.sum Finset.univ (fun d =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                        coframe k c * coframe l d)))) := by
            apply Finset.sum_congr rfl
            intro k _
            rw [Finset.sum_comm]
        _ = Finset.sum Finset.univ (fun c =>
              Finset.sum Finset.univ (fun k =>
                Finset.sum Finset.univ (fun l =>
                  Finset.sum Finset.univ (fun d =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                        coframe k c * coframe l d)))) := by
            rw [Finset.sum_comm]
        _ = Finset.sum Finset.univ (fun c =>
              Finset.sum Finset.univ (fun k =>
                Finset.sum Finset.univ (fun d =>
                  Finset.sum Finset.univ (fun l =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                        coframe k c * coframe l d)))) := by
            apply Finset.sum_congr rfl
            intro c _
            apply Finset.sum_congr rfl
            intro k _
            rw [Finset.sum_comm]
        _ = _ := by
            apply Finset.sum_congr rfl
            intro c _
            rw [Finset.sum_comm]

set_option maxHeartbeats 3000000 in
set_option maxRecDepth 10000 in
theorem palatiniDensityFirstVariation_eq_epsilon
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) :
    palatiniDensityFirstVariation coframe variation curvature =
      -(1 / 4 : Real) * Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          Finset.sum Finset.univ (fun c =>
            Finset.sum Finset.univ (fun d =>
              Finset.sum Finset.univ (fun i =>
                Finset.sum Finset.univ (fun j =>
                  Finset.sum Finset.univ (fun k =>
                    Finset.sum Finset.univ (fun l =>
                      spacetimeAlternatingSymbol a b c d *
                        spacetimeAlternatingSymbol i j k l *
                        (variation k c * coframe l d +
                          coframe k c * variation l d) *
                        bivectorMatrix (curvature a b) i j)))))))) := by
  unfold palatiniDensityFirstVariation
    complementaryPalatiniFaceWeightFirstVariation
    palatiniFaceWeightFirstVariation coframeWedgeFirstVariation
  simp_rw [kreinPair_lorentzBivector_eq_explicit]
  simp +decide [transportApply, lorentzHodgeStar,
    spacetimeAlternatingSymbol, bivectorMatrix, bivectorFirst,
    bivectorSecond, Fin.sum_univ_six, Fin.sum_univ_four]
  ring

theorem det_mul_inverse_bivectorContraction
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) :
    coframe.det * Finset.sum Finset.univ (fun i =>
      Finset.sum Finset.univ (fun j =>
        inverseCoframe a i * inverseCoframe b j *
          bivectorMatrix curvature i j)) =
      (1 / 2 : Real) * Finset.sum Finset.univ (fun i =>
        Finset.sum Finset.univ (fun j =>
          coframe.det *
            (inverseCoframe a i * inverseCoframe b j -
              inverseCoframe a j * inverseCoframe b i) *
            bivectorMatrix curvature i j)) := by
  simp +decide [Fin.sum_univ_four, bivectorMatrix]
  ring

theorem det_mul_inverse_bivectorContraction_eq_epsilon
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (hLeft : inverseCoframe * coframe = 1)
    (a b : Fin 4) :
    coframe.det * Finset.sum Finset.univ (fun i =>
      Finset.sum Finset.univ (fun j =>
        inverseCoframe a i * inverseCoframe b j *
          bivectorMatrix curvature i j)) =
      (1 / 4 : Real) * Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          Finset.sum Finset.univ (fun i =>
            Finset.sum Finset.univ (fun j =>
              Finset.sum Finset.univ (fun k =>
                Finset.sum Finset.univ (fun l =>
                  spacetimeAlternatingSymbol a b c d *
                    spacetimeAlternatingSymbol i j k l *
                    coframe k c * coframe l d *
                    bivectorMatrix curvature i j)))))) := by
  rw [det_mul_inverse_bivectorContraction]
  calc
    (1 / 2 : Real) * Finset.sum Finset.univ (fun i =>
          Finset.sum Finset.univ (fun j =>
            coframe.det *
              (inverseCoframe a i * inverseCoframe b j -
                inverseCoframe a j * inverseCoframe b i) *
              bivectorMatrix curvature i j)) =
        (1 / 2 : Real) * Finset.sum Finset.univ (fun i =>
          Finset.sum Finset.univ (fun j =>
            ((1 / 2 : Real) * Finset.sum Finset.univ (fun c =>
              Finset.sum Finset.univ (fun d =>
                Finset.sum Finset.univ (fun k =>
                  Finset.sum Finset.univ (fun l =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                      coframe k c * coframe l d)))) *
              bivectorMatrix curvature i j))) := by
          congr 1
          apply Finset.sum_congr rfl
          intro i _
          apply Finset.sum_congr rfl
          intro j _
          rw [det_mul_inverse_pair
            coframe inverseCoframe hLeft a b i j]
    _ = (1 / 4 : Real) * Finset.sum Finset.univ (fun i =>
          Finset.sum Finset.univ (fun j =>
            Finset.sum Finset.univ (fun c =>
              Finset.sum Finset.univ (fun d =>
                Finset.sum Finset.univ (fun k =>
                  Finset.sum Finset.univ (fun l =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                      coframe k c * coframe l d *
                      bivectorMatrix curvature i j)))))) := by
          simp only [Finset.mul_sum, Finset.sum_mul]
          apply Finset.sum_congr rfl
          intro i _
          apply Finset.sum_congr rfl
          intro j _
          apply Finset.sum_congr rfl
          intro c _
          apply Finset.sum_congr rfl
          intro d _
          apply Finset.sum_congr rfl
          intro k _
          apply Finset.sum_congr rfl
          intro l _
          ring
    _ = (1 / 4 : Real) * Finset.sum Finset.univ (fun i =>
          Finset.sum Finset.univ (fun c =>
            Finset.sum Finset.univ (fun j =>
              Finset.sum Finset.univ (fun d =>
                Finset.sum Finset.univ (fun k =>
                  Finset.sum Finset.univ (fun l =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                      coframe k c * coframe l d *
                      bivectorMatrix curvature i j)))))) := by
          congr 1
          apply Finset.sum_congr rfl
          intro i _
          rw [Finset.sum_comm]
    _ = (1 / 4 : Real) * Finset.sum Finset.univ (fun c =>
          Finset.sum Finset.univ (fun i =>
            Finset.sum Finset.univ (fun j =>
              Finset.sum Finset.univ (fun d =>
                Finset.sum Finset.univ (fun k =>
                  Finset.sum Finset.univ (fun l =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                      coframe k c * coframe l d *
                      bivectorMatrix curvature i j)))))) := by
          congr 1
          rw [Finset.sum_comm]
    _ = (1 / 4 : Real) * Finset.sum Finset.univ (fun c =>
          Finset.sum Finset.univ (fun i =>
            Finset.sum Finset.univ (fun d =>
              Finset.sum Finset.univ (fun j =>
                Finset.sum Finset.univ (fun k =>
                  Finset.sum Finset.univ (fun l =>
                    spacetimeAlternatingSymbol a b c d *
                      spacetimeAlternatingSymbol i j k l *
                      coframe k c * coframe l d *
                      bivectorMatrix curvature i j)))))) := by
          congr 1
          apply Finset.sum_congr rfl
          intro c _
          apply Finset.sum_congr rfl
          intro i _
          rw [Finset.sum_comm]
    _ = _ := by
          congr 1
          apply Finset.sum_congr rfl
          intro c _
          rw [Finset.sum_comm]

def responseSpacetimeCoframeMinor
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (a b k l : Fin 4) : Real :=
  Finset.sum Finset.univ (fun c =>
    Finset.sum Finset.univ (fun d =>
      spacetimeAlternatingSymbol a b c d *
        coframe k c * coframe l d))

def responseSpacetimeCoframeMinorFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (a b k l : Fin 4) : Real :=
  Finset.sum Finset.univ (fun c =>
    Finset.sum Finset.univ (fun d =>
      spacetimeAlternatingSymbol a b c d *
        (variation k c * coframe l d +
          coframe k c * variation l d)))

private theorem responseAlternatingSymbol_swap_first
    (a b c d : Fin 4) :
    spacetimeAlternatingSymbol b a c d =
      -spacetimeAlternatingSymbol a b c d := by
  unfold spacetimeAlternatingSymbol
  ring

theorem spacetimeCoframeMinor_swap
    (coframe : Matrix (Fin 4) (Fin 4) Real) (a b k l : Fin 4) :
    responseSpacetimeCoframeMinor coframe b a k l =
      -responseSpacetimeCoframeMinor coframe a b k l := by
  unfold responseSpacetimeCoframeMinor
  rw [← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro c _
  rw [← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro d _
  rw [responseAlternatingSymbol_swap_first a b c d]
  ring

set_option maxHeartbeats 3000000 in
theorem spacetimeCoframeMinorFirstVariation_mul_single
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (a b c d k l : Fin 4) :
    responseSpacetimeCoframeMinorFirstVariation coframe
        (coframe * Matrix.single c d 1) a b k l =
      (if c = d then responseSpacetimeCoframeMinor coframe a b k l else 0) -
        (if a = c then responseSpacetimeCoframeMinor coframe d b k l else 0) -
        (if b = c then responseSpacetimeCoframeMinor coframe a d k l else 0) := by
  fin_cases a <;> fin_cases b <;> fin_cases c <;> fin_cases d <;>
    simp +decide [responseSpacetimeCoframeMinorFirstVariation,
      responseSpacetimeCoframeMinor, Matrix.mul_apply,
      Matrix.single_apply, spacetimeAlternatingSymbol, Fin.sum_univ_four] <;>
    ring

def responseCoframeBivectorCofactor
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) : Real :=
  (1 / 4 : Real) * Finset.sum Finset.univ (fun i =>
    Finset.sum Finset.univ (fun j =>
      Finset.sum Finset.univ (fun k =>
        Finset.sum Finset.univ (fun l =>
          spacetimeAlternatingSymbol i j k l *
            responseSpacetimeCoframeMinor coframe a b k l *
            bivectorMatrix curvature i j))))

def responseCoframeBivectorCofactorFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) : Real :=
  (1 / 4 : Real) * Finset.sum Finset.univ (fun i =>
    Finset.sum Finset.univ (fun j =>
      Finset.sum Finset.univ (fun k =>
        Finset.sum Finset.univ (fun l =>
          spacetimeAlternatingSymbol i j k l *
            responseSpacetimeCoframeMinorFirstVariation
              coframe variation a b k l *
            bivectorMatrix curvature i j))))

theorem coframeBivectorCofactor_swap
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) :
    responseCoframeBivectorCofactor coframe curvature b a =
      -responseCoframeBivectorCofactor coframe curvature a b := by
  unfold responseCoframeBivectorCofactor
  simp_rw [spacetimeCoframeMinor_swap coframe a b]
  simp only [mul_neg, neg_mul, Finset.sum_neg_distrib]

theorem coframeBivectorCofactor_neg
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) :
    responseCoframeBivectorCofactor coframe
        (fun component => -curvature component) a b =
      -responseCoframeBivectorCofactor coframe curvature a b := by
  have hMatrix :
      bivectorMatrix (fun component => -curvature component) =
        -bivectorMatrix curvature := by
    ext i j
    fin_cases i <;> fin_cases j <;> simp [bivectorMatrix]
  unfold responseCoframeBivectorCofactor
  rw [hMatrix]
  simp only [Matrix.neg_apply, mul_neg, Finset.sum_neg_distrib]

theorem coframeBivectorCofactorFirstVariation_mul_single
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b c d : Fin 4) :
    responseCoframeBivectorCofactorFirstVariation coframe
        (coframe * Matrix.single c d 1) curvature a b =
      (if c = d then
        responseCoframeBivectorCofactor coframe curvature a b else 0) -
        (if a = c then
          responseCoframeBivectorCofactor coframe curvature d b else 0) -
        (if b = c then
          responseCoframeBivectorCofactor coframe curvature a d else 0) := by
  unfold responseCoframeBivectorCofactorFirstVariation
    responseCoframeBivectorCofactor
  simp_rw [spacetimeCoframeMinorFirstVariation_mul_single]
  by_cases hcd : c = d
  · subst d
    by_cases hac : a = c <;> by_cases hbc : b = c <;>
      simp_all [Finset.sum_sub_distrib, Finset.mul_sum, Finset.sum_mul] <;> ring
  · have hSwap := spacetimeCoframeMinor_swap coframe d c
    by_cases hac : a = c <;> by_cases hbc : b = c <;>
      simp_all [Finset.sum_sub_distrib, Finset.mul_sum, Finset.sum_mul, hSwap] <;>
      ring

set_option maxHeartbeats 3000000 in
theorem coframeBivectorCofactorFirstVariation_eq_expanded
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) :
    responseCoframeBivectorCofactorFirstVariation
        coframe variation curvature a b =
      (1 / 4 : Real) * Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          Finset.sum Finset.univ (fun i =>
            Finset.sum Finset.univ (fun j =>
              Finset.sum Finset.univ (fun k =>
                Finset.sum Finset.univ (fun l =>
                  spacetimeAlternatingSymbol a b c d *
                    spacetimeAlternatingSymbol i j k l *
                    (variation k c * coframe l d +
                      coframe k c * variation l d) *
                    bivectorMatrix curvature i j)))))) := by
  fin_cases a <;> fin_cases b <;>
    simp +decide [responseCoframeBivectorCofactorFirstVariation,
      responseSpacetimeCoframeMinorFirstVariation,
      spacetimeAlternatingSymbol, Fin.sum_univ_four] <;>
    ring

set_option maxHeartbeats 3000000 in
theorem coframeBivectorCofactor_eq_expanded
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (a b : Fin 4) :
    responseCoframeBivectorCofactor coframe curvature a b =
      (1 / 4 : Real) * Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          Finset.sum Finset.univ (fun i =>
            Finset.sum Finset.univ (fun j =>
              Finset.sum Finset.univ (fun k =>
                Finset.sum Finset.univ (fun l =>
                  spacetimeAlternatingSymbol a b c d *
                    spacetimeAlternatingSymbol i j k l *
                    coframe k c * coframe l d *
                    bivectorMatrix curvature i j)))))) := by
  fin_cases a <;> fin_cases b <;>
    simp +decide [responseCoframeBivectorCofactor,
      responseSpacetimeCoframeMinor,
      spacetimeAlternatingSymbol, Fin.sum_univ_four] <;>
    ring

theorem coframeBivectorCofactor_eq_det_mul_inverseContraction
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fiber 6) (hLeft : inverseCoframe * coframe = 1)
    (a b : Fin 4) :
    responseCoframeBivectorCofactor coframe curvature a b =
      coframe.det * Finset.sum Finset.univ (fun i =>
        Finset.sum Finset.univ (fun j =>
          inverseCoframe a i * inverseCoframe b j *
            bivectorMatrix curvature i j)) := by
  rw [coframeBivectorCofactor_eq_expanded]
  exact (det_mul_inverse_bivectorContraction_eq_epsilon
    coframe inverseCoframe curvature hLeft a b).symm

theorem palatiniDensityFirstVariation_eq_neg_sum_cofactorFirstVariation
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) :
    palatiniDensityFirstVariation coframe variation curvature =
      -Finset.sum Finset.univ (fun a =>
        Finset.sum Finset.univ (fun b =>
          responseCoframeBivectorCofactorFirstVariation
            coframe variation (curvature a b) a b)) := by
  rw [palatiniDensityFirstVariation_eq_epsilon]
  rw [Finset.mul_sum, ← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro a _
  rw [Finset.mul_sum, ← Finset.sum_neg_distrib]
  apply Finset.sum_congr rfl
  intro b _
  rw [coframeBivectorCofactorFirstVariation_eq_expanded]
  ring

set_option maxHeartbeats 3000000 in
set_option maxRecDepth 10000 in
theorem palatiniDensityFirstVariation_mul_single_eq_cofactorEinstein
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (hAntisymmetric : forall a b,
      curvature b a = fun component => -curvature a b component)
    (c d : Fin 4) :
    palatiniDensityFirstVariation coframe
        (coframe * Matrix.single c d 1) curvature =
      2 * Finset.sum Finset.univ (fun b =>
        responseCoframeBivectorCofactor coframe
          (curvature c b) d b) -
        (if c = d then
          Finset.sum Finset.univ (fun a =>
            Finset.sum Finset.univ (fun b =>
              responseCoframeBivectorCofactor coframe
                (curvature a b) a b))
         else 0) := by
  rw [palatiniDensityFirstVariation_eq_neg_sum_cofactorFirstVariation]
  simp_rw [coframeBivectorCofactorFirstVariation_mul_single]
  have hFace : forall a,
      curvature a c = fun component => -curvature c a component := by
    intro a
    exact hAntisymmetric c a
  have hSecondRicci :
      Finset.sum Finset.univ (fun a =>
          responseCoframeBivectorCofactor coframe
            (curvature a c) a d) =
        Finset.sum Finset.univ (fun b =>
          responseCoframeBivectorCofactor coframe
            (curvature c b) d b) := by
    apply Finset.sum_congr rfl
    intro a _
    calc
      responseCoframeBivectorCofactor coframe
          (curvature a c) a d =
        responseCoframeBivectorCofactor coframe
          (fun component => -curvature c a component) a d := by
            rw [hFace a]
      _ = -responseCoframeBivectorCofactor coframe
          (curvature c a) a d := by
            rw [coframeBivectorCofactor_neg]
      _ = responseCoframeBivectorCofactor coframe
          (curvature c a) d a := by
            exact (coframeBivectorCofactor_swap
              coframe (curvature c a) a d).symm
  have hTraceSum :
      Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun b =>
            if c = d then
              responseCoframeBivectorCofactor coframe
                (curvature a b) a b
            else 0)) =
        if c = d then
          Finset.sum Finset.univ (fun a =>
            Finset.sum Finset.univ (fun b =>
              responseCoframeBivectorCofactor coframe
                (curvature a b) a b))
        else 0 := by
    by_cases hcd : c = d <;> simp [hcd]
  have hFirstRicciSum :
      Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun b =>
            if a = c then
              responseCoframeBivectorCofactor coframe
                (curvature a b) d b
            else 0)) =
        Finset.sum Finset.univ (fun b =>
          responseCoframeBivectorCofactor coframe
            (curvature c b) d b) := by
    simp
  have hSecondRicciSum :
      Finset.sum Finset.univ (fun a =>
          Finset.sum Finset.univ (fun b =>
            if b = c then
              responseCoframeBivectorCofactor coframe
                (curvature a b) a d
            else 0)) =
        Finset.sum Finset.univ (fun a =>
          responseCoframeBivectorCofactor coframe
            (curvature a c) a d) := by
    simp
  simp only [Finset.sum_sub_distrib]
  rw [hTraceSum, hFirstRicciSum, hSecondRicciSum, hSecondRicci]
  ring

theorem palatiniDensityFirstVariation_mul_single_eq_det_coefficient
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (hLeft : inverseCoframe * coframe = 1)
    (hAntisymmetric : forall a b,
      curvature b a = fun component => -curvature a b component)
    (c d : Fin 4) :
    palatiniDensityFirstVariation coframe
        (coframe * Matrix.single c d 1) curvature =
      coframe.det *
        (2 * Finset.sum Finset.univ (fun i =>
          Finset.sum Finset.univ (fun b =>
            Finset.sum Finset.univ (fun j =>
              inverseCoframe d i * inverseCoframe b j *
                bivectorMatrix (curvature c b) i j))) -
          (if c = d then
            inverseCoframeScalarCurvature inverseCoframe curvature
           else 0)) := by
  rw [palatiniDensityFirstVariation_mul_single_eq_cofactorEinstein
    coframe curvature hAntisymmetric c d]
  simp_rw [coframeBivectorCofactor_eq_det_mul_inverseContraction
    coframe inverseCoframe _ hLeft]
  unfold inverseCoframeScalarCurvature
  by_cases hcd : c = d
  · simp only [hcd, if_true]
    simp only [← Finset.mul_sum]
    rw [Finset.sum_comm]
    ring
  · simp only [hcd, if_false]
    simp only [← Finset.mul_sum]
    rw [Finset.sum_comm]
    ring

theorem palatiniDensityFirstVariation_add
    (coframe left right : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) :
    palatiniDensityFirstVariation coframe (left + right) curvature =
      palatiniDensityFirstVariation coframe left curvature +
        palatiniDensityFirstVariation coframe right curvature := by
  unfold palatiniDensityFirstVariation
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro a _
  rw [← Finset.sum_add_distrib]
  apply Finset.sum_congr rfl
  intro b _
  rw [complementaryPalatiniFaceWeightFirstVariation_add]
  simp_rw [kreinPair_lorentzBivector_eq_explicit]
  simp only [Pi.add_apply]
  ring

theorem palatiniDensityFirstVariation_smul
    (coframe probe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) (scalar : Real) :
    palatiniDensityFirstVariation coframe (scalar • probe) curvature =
      scalar * palatiniDensityFirstVariation coframe probe curvature := by
  unfold palatiniDensityFirstVariation
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro a _
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro b _
  rw [complementaryPalatiniFaceWeightFirstVariation_smul]
  simp_rw [kreinPair_lorentzBivector_eq_explicit]
  simp only [Pi.smul_apply, smul_eq_mul]
  ring

def responsePalatiniDensityGeneratorLinearMap
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) :
    Matrix (Fin 4) (Fin 4) Real →ₗ[Real] Real where
  toFun := fun generator =>
    palatiniDensityFirstVariation coframe (coframe * generator) curvature
  map_add' := by
    intro left right
    rw [Matrix.mul_add,
      palatiniDensityFirstVariation_add]
  map_smul' := by
    intro scalar generator
    have hMul : coframe * (scalar • generator) =
        scalar • (coframe * generator) := by
      ext i j
      simp only [Matrix.mul_apply, Matrix.smul_apply, smul_eq_mul]
      rw [Finset.mul_sum]
      apply Finset.sum_congr rfl
      intro k _
      ring
    rw [hMul, palatiniDensityFirstVariation_smul]
    rfl

theorem palatiniDensityFirstVariation_mul_eq_coordinateSum
    (coframe generator : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) :
    palatiniDensityFirstVariation coframe (coframe * generator) curvature =
      Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          palatiniDensityFirstVariation coframe
              (coframe * Matrix.single c d 1) curvature *
            generator c d)) := by
  let responseMap :=
    responsePalatiniDensityGeneratorLinearMap coframe curvature
  calc
    palatiniDensityFirstVariation coframe (coframe * generator) curvature =
        responseMap generator := rfl
    _ = responseMap (Finset.sum Finset.univ (fun c =>
          Finset.sum Finset.univ (fun d =>
            Matrix.single c d (generator c d)))) := by
      rw [← Matrix.matrix_eq_sum_single generator]
    _ = Finset.sum Finset.univ (fun c =>
          Finset.sum Finset.univ (fun d =>
            responseMap (Matrix.single c d (generator c d)))) := by
      rw [map_sum]
      apply Finset.sum_congr rfl
      intro c _
      rw [map_sum]
    _ = Finset.sum Finset.univ (fun c =>
          Finset.sum Finset.univ (fun d =>
            palatiniDensityFirstVariation coframe
                (coframe * Matrix.single c d 1) curvature *
              generator c d)) := by
      apply Finset.sum_congr rfl
      intro c _
      apply Finset.sum_congr rfl
      intro d _
      have hSingle : Matrix.single c d (generator c d) =
          generator c d • Matrix.single c d (1 : Real) := by
        simp
      rw [hSingle, map_smul]
      change generator c d *
          palatiniDensityFirstVariation coframe
            (coframe * Matrix.single c d 1) curvature = _
      ring

theorem palatiniDensityFirstVariation_mul_core
    (coframe inverseCoframe generator : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (hLeft : inverseCoframe * coframe = 1)
    (hAntisymmetric : forall a b,
      curvature b a = fun component => -curvature a b component) :
    palatiniDensityFirstVariation coframe (coframe * generator) curvature =
      coframe.det * Finset.sum Finset.univ (fun c =>
        Finset.sum Finset.univ (fun d =>
          (2 * Finset.sum Finset.univ (fun i =>
            Finset.sum Finset.univ (fun b =>
              Finset.sum Finset.univ (fun j =>
                inverseCoframe d i * inverseCoframe b j *
                  bivectorMatrix (curvature c b) i j))) -
            (if c = d then
              inverseCoframeScalarCurvature inverseCoframe curvature
             else 0)) * generator c d)) := by
  rw [palatiniDensityFirstVariation_mul_eq_coordinateSum]
  simp_rw [palatiniDensityFirstVariation_mul_single_eq_det_coefficient
    coframe inverseCoframe curvature hLeft hAntisymmetric]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro c _
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro d _
  ring

theorem palatiniDensityFirstVariation_eq_det_mul_mixedEinstein_of_function_antisymmetric
    (coframe inverseCoframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (hLeft : inverseCoframe * coframe = 1)
    (hAntisymmetric : forall a b,
      curvature b a = fun component => -curvature a b component) :
    palatiniDensityFirstVariation coframe variation curvature =
      coframe.det * Finset.sum Finset.univ (fun internal =>
        Finset.sum Finset.univ (fun direction =>
          mixedEinsteinCoframeCoefficient inverseCoframe curvature
            internal direction * variation internal direction)) := by
  have hRight : coframe * inverseCoframe = 1 := mul_eq_one_comm.2 hLeft
  have hGenerator :
      palatiniDensityFirstVariation coframe variation curvature =
        palatiniDensityFirstVariation coframe
          (coframe * (inverseCoframe * variation)) curvature := by
    rw [← Matrix.mul_assoc, hRight, Matrix.one_mul]
  rw [hGenerator]
  rw [palatiniDensityFirstVariation_mul_core
    coframe inverseCoframe (inverseCoframe * variation)
      curvature hLeft hAntisymmetric]
  congr 1
  simp +decide [Matrix.mul_apply, Finset.mul_sum _ _ _,
    Finset.sum_mul, mul_assoc, mul_left_comm,
    Finset.sum_sub_distrib, sub_mul, mul_sub]
  unfold mixedEinsteinCoframeCoefficient inverseCoframeScalarCurvature
  simp +decide [Finset.mul_sum _ _ _, Finset.sum_mul,
    mul_assoc, mul_left_comm, sub_mul, Finset.sum_sub_distrib]
  refine congrArg₂ _ ?_ ?_
  · simp +decide only [← Finset.sum_product']
    apply Finset.sum_bij
      (fun x _ =>
        (x.2.2.1, x.2.1, x.1, x.2.2.2.1,
          x.2.2.2.2.1, x.2.2.2.2.2))
    · simp +contextual
    · grind
    · simp +zetaDelta at *
    · grind
  · simp +decide only [← Finset.sum_product']
    apply Finset.sum_bij
      (fun x _ =>
        (x.2.1, x.1, x.2.2.1, x.2.2.2.1,
          x.2.2.2.2.1, x.2.2.2.2.2))
    · simp +zetaDelta at *
    · grind
    · simp +zetaDelta at *
    · simp +decide [mul_comm]

end ResponseProof

/-- The exact first response of the ordered Palatini density is the oriented
coframe determinant times the coframe-index mixed Einstein coefficient paired
with the arbitrary coframe variation.  Face antisymmetry is the only curvature
symmetry used by this local algebraic identity. -/
theorem palatiniDensityFirstVariation_eq_det_mul_mixedEinstein
    (coframe inverseCoframe variation : Matrix (Fin 4) (Fin 4) Real)
    (curvature : Fin 4 -> Fin 4 -> Fiber 6)
    (hLeft : inverseCoframe * coframe = 1)
    (hAntisymmetric : forall a b component,
      curvature a b component = -curvature b a component) :
    palatiniDensityFirstVariation coframe variation curvature =
      coframe.det * Finset.sum Finset.univ (fun internal =>
        Finset.sum Finset.univ (fun direction =>
          mixedEinsteinCoframeCoefficient inverseCoframe curvature
            internal direction * variation internal direction)) := by
  apply ResponseProof.palatiniDensityFirstVariation_eq_det_mul_mixedEinstein_of_function_antisymmetric
    coframe inverseCoframe variation curvature hLeft
  intro a b
  funext component
  exact hAntisymmetric b a component

/-- Each of the sixteen local tetrad Euler coefficients of the concrete
nonlinear plaquette action is the oriented coframe determinant times the
corresponding mixed Einstein coframe coefficient of the extracted curvature. -/
theorem nonlinearCoframeEulerCoefficient_eq_det_mul_mixedEinstein
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe inverseCoframe : CoframeField Site)
    (hLeft : forall site, inverseCoframe site * coframe site = 1)
    (site : Site) (internal direction : Fin 4) :
    nonlinearCoframeEulerCoefficient shift connection coframe site
        internal direction =
      (coframe site).det *
        mixedEinsteinCoframeCoefficient (inverseCoframe site)
          (extractedPlaquetteCurvature shift connection site)
          internal direction := by
  change nonlinearCoframeLocalEulerFunctional
      shift connection coframe site (Matrix.single internal direction 1) = _
  rw [nonlinearCoframeLocalEulerFunctional_eq_palatiniDensityFirstVariation]
  rw [palatiniDensityFirstVariation_eq_det_mul_mixedEinstein
    (hLeft := hLeft site)]
  · congr 1
    fin_cases internal <;> fin_cases direction <;>
      simp +decide [Fin.sum_univ_four, Matrix.single_apply]
  · exact extractedPlaquetteCurvature_isAntisymmetric
      shift connection site

/-- At one site, vanishing of all sixteen tetrad Euler coefficients is
equivalent to the determinant-free mixed vacuum Einstein equations for the
extracted curvature. -/
theorem nonlinearCoframeEulerCoefficients_vanish_iff_mixedEinstein
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe inverseCoframe : CoframeField Site)
    (hLeft : forall site, inverseCoframe site * coframe site = 1)
    (site : Site) :
    (forall internal direction,
      nonlinearCoframeEulerCoefficient shift connection coframe site
        internal direction = 0) ↔
    (forall coframeDirection raisedDirection,
      2 * mixedRicciCurvature (inverseCoframe site)
          (extractedPlaquetteCurvature shift connection site)
          coframeDirection raisedDirection -
        (1 : Matrix (Fin 4) (Fin 4) Real)
            raisedDirection coframeDirection *
          inverseCoframeScalarCurvature (inverseCoframe site)
            (extractedPlaquetteCurvature shift connection site) = 0) := by
  have hRight : coframe site * inverseCoframe site = 1 :=
    mul_eq_one_comm.2 (hLeft site)
  have hDet : (coframe site).det ≠ 0 :=
    Matrix.det_ne_zero_of_left_inverse (hLeft site)
  calc
    (forall internal direction,
        nonlinearCoframeEulerCoefficient shift connection coframe site
          internal direction = 0) ↔
        (forall internal direction,
          mixedEinsteinCoframeCoefficient (inverseCoframe site)
            (extractedPlaquetteCurvature shift connection site)
            internal direction = 0) := by
          constructor
          · intro hEuler internal direction
            have h := hEuler internal direction
            rw [nonlinearCoframeEulerCoefficient_eq_det_mul_mixedEinstein
              shift connection coframe inverseCoframe hLeft] at h
            exact (mul_eq_zero.mp h).resolve_left hDet
          · intro hEinstein internal direction
            rw [nonlinearCoframeEulerCoefficient_eq_det_mul_mixedEinstein
              shift connection coframe inverseCoframe hLeft,
              hEinstein internal direction, mul_zero]
    _ ↔ _ := mixedEinsteinCoframeCoefficient_vanish_iff
      (coframe site) (inverseCoframe site)
      (extractedPlaquetteCurvature shift connection site)
      (hLeft site) hRight

/-- Formal coframe stationarity of the concrete nonlinear plaquette action is
exactly the pointwise finite mixed vacuum Einstein system. -/
theorem nonlinearCoframePlaquetteCoframeStationary_iff_mixedEinstein
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe inverseCoframe : CoframeField Site)
    (hLeft : forall site, inverseCoframe site * coframe site = 1) :
    NonlinearCoframePlaquetteCoframeStationary shift connection coframe ↔
      forall site coframeDirection raisedDirection,
        2 * mixedRicciCurvature (inverseCoframe site)
            (extractedPlaquetteCurvature shift connection site)
            coframeDirection raisedDirection -
          (1 : Matrix (Fin 4) (Fin 4) Real)
              raisedDirection coframeDirection *
            inverseCoframeScalarCurvature (inverseCoframe site)
              (extractedPlaquetteCurvature shift connection site) = 0 := by
  rw [nonlinearCoframePlaquetteCoframeStationary_iff_coefficients]
  constructor
  · intro hEuler site
    exact (nonlinearCoframeEulerCoefficients_vanish_iff_mixedEinstein
      shift connection coframe inverseCoframe hLeft site).mp (hEuler site)
  · intro hEinstein site
    exact (nonlinearCoframeEulerCoefficients_vanish_iff_mixedEinstein
      shift connection coframe inverseCoframe hLeft site).mpr
        (hEinstein site)

/-- Joint stationarity is exactly the six-component link Euler system together
with the pointwise finite mixed vacuum Einstein equations.  This theorem does
not identify the link equation with Levi-Civita selection. -/
theorem nonlinearCoframePlaquetteJointStationary_iff_linkEuler_and_mixedEinstein
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe inverseCoframe : CoframeField Site)
    (hLeft : forall site, inverseCoframe site * coframe site = 1) :
    NonlinearCoframePlaquetteJointStationary shift connection coframe ↔
      (forall site direction component,
        nonlinearLinkEulerCoefficient shift connection coframe site direction
          component = 0) ∧
      (forall site coframeDirection raisedDirection,
        2 * mixedRicciCurvature (inverseCoframe site)
            (extractedPlaquetteCurvature shift connection site)
            coframeDirection raisedDirection -
          (1 : Matrix (Fin 4) (Fin 4) Real)
              raisedDirection coframeDirection *
            inverseCoframeScalarCurvature (inverseCoframe site)
              (extractedPlaquetteCurvature shift connection site) = 0) := by
  rw [nonlinearCoframePlaquetteJointStationary_iff_coefficients]
  exact and_congr Iff.rfl
    (by
      constructor
      · intro hEuler site
        exact (nonlinearCoframeEulerCoefficients_vanish_iff_mixedEinstein
          shift connection coframe inverseCoframe hLeft site).mp (hEuler site)
      · intro hEinstein site
        exact (nonlinearCoframeEulerCoefficients_vanish_iff_mixedEinstein
          shift connection coframe inverseCoframe hLeft site).mpr
            (hEinstein site))

/-! ## Build-enforced assumption-footprint guard -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge.palatiniDensityFirstVariation_eq_det_mul_mixedEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms palatiniDensityFirstVariation_eq_det_mul_mixedEinstein

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge.nonlinearCoframePlaquetteJointStationary_iff_linkEuler_and_mixedEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearCoframePlaquetteJointStationary_iff_linkEuler_and_mixedEinstein

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge

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
