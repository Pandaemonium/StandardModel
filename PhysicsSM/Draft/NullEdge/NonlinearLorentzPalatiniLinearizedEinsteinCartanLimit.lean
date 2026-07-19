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
