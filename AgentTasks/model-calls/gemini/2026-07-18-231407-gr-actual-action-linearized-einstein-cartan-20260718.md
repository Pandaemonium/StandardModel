# Gemini model call log

## Metadata

- Provider: `Gemini REST API`
- Model: `gemini-3.1-pro-preview`
- Status: `completed`
- Dry run: `False`
- Started: `2026-07-18T23:12:21`
- Finished: `2026-07-18T23:14:07`
- Timeout seconds: `600`
- Max output tokens: `8000`

## Endpoint

```text
https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview:generateContent
```

The API key is intentionally not logged.

## Prompt

```text
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


The embedded Claude call failed for lack of credit. Ignore its empty response and perform the requested hostile semantic review yourself. Do not edit files. Findings first by severity, then strongest defensible claim, then smallest required fixes.
```

## Extracted response text

```text
An audit of the provided Lean 4 files reveals several issues, ranging from a critical missing theorem application to minor naming and structural inconsistencies. 

Here are the findings, ordered by severity:

### 1. Missing `LinearMap` Coercion / False Shape in `sampledLinearizedJointStationary_einstein_and_cartan`
**Severity: High (Kernel/Type-checker failure)**
**File:** `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniLinearizedEinsteinCartanLimit.lean`
**Line:** 375-380
```lean
      change mixedVacuumEinsteinEntryLinear
        (1 : Matrix (Fin 4) (Fin 4) Real)
        coframeDirection raisedDirection
        (sampledNormalizedAdditiveCurvature shift position center
          inverseSpacing connectionField n) = 0
```
**Finding:** The proof attempts to use `change` to replace `mixedVacuumEinsteinEntry` with `mixedVacuumEinsteinEntryLinear`, and then uses `rw [map_smul]` on it. However, if `mixedVacuumEinsteinEntryLinear` is a bundled `LinearMap` (which it must be for `map_smul` to work), its application syntax in Lean 4 requires either a coercion to function or explicit application. The `change` tactic will fail with a type mismatch because `mixedVacuumEinsteinEntryLinear (...)` evaluates to a `LinearMap`, not a `Real`, unless it is fully applied to the curvature argument. The correct
```

## Raw response JSON

```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "An audit of the provided Lean 4 files reveals several issues, ranging from a critical missing theorem application to minor naming and structural inconsistencies. \n\nHere are the findings, ordered by severity:\n\n### 1. Missing `LinearMap` Coercion / False Shape in `sampledLinearizedJointStationary_einstein_and_cartan`\n**Severity: High (Kernel/Type-checker failure)**\n**File:** `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniLinearizedEinsteinCartanLimit.lean`\n**Line:** 375-380\n```lean\n      change mixedVacuumEinsteinEntryLinear\n        (1 : Matrix (Fin 4) (Fin 4) Real)\n        coframeDirection raisedDirection\n        (sampledNormalizedAdditiveCurvature shift position center\n          inverseSpacing connectionField n) = 0\n```\n**Finding:** The proof attempts to use `change` to replace `mixedVacuumEinsteinEntry` with `mixedVacuumEinsteinEntryLinear`, and then uses `rw [map_smul]` on it. However, if `mixedVacuumEinsteinEntryLinear` is a bundled `LinearMap` (which it must be for `map_smul` to work), its application syntax in Lean 4 requires either a coercion to function or explicit application. The `change` tactic will fail with a type mismatch because `mixedVacuumEinsteinEntryLinear (...)` evaluates to a `LinearMap`, not a `Real`, unless it is fully applied to the curvature argument. The correct",
            "thoughtSignature": "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"
          }
        ],
        "role": "model"
      },
      "finishReason": "MAX_TOKENS",
      "index": 0
    }
  ],
  "usageMetadata": {
    "promptTokenCount": 49942,
    "candidatesTokenCount": 319,
    "totalTokenCount": 65619,
    "cachedContentTokenCount": 42583,
    "promptTokensDetails": [
      {
        "modality": "TEXT",
        "tokenCount": 49942
      }
    ],
    "cacheTokensDetails": [
      {
        "modality": "TEXT",
        "tokenCount": 42583
      }
    ],
    "thoughtsTokenCount": 15358,
    "serviceTier": "standard"
  },
  "modelVersion": "gemini-3.1-pro-preview",
  "responseId": "wWpcauXkB-a01MkPzpyY2Aw"
}
```

## Error

```text

```
