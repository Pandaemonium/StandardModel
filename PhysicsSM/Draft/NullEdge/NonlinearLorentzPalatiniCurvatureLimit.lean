import PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinResponse

noncomputable section

/-!
# Curvature limit of the nonlinear Lorentz Palatini extractor

The exact nonlinear Palatini action sees a plaquette holonomy only through
the six trace probes

`B |-> -1/2 tr(hat(B) (H - I))`.

This module packages those probes as a linear map from arbitrary real
`4 x 4` matrix increments to the ordered Lorentz-bivector fiber.  It proves
that the map is exactly the identity on generated Lorentz-algebra
coordinates, then uses continuity to connect a first-order group-holonomy
expansion to convergence of the precise curvature field entering the finite
Einstein equation.

The final theorem passes the finite mixed vacuum Einstein equation to the
curvature limit at a fixed invertible coframe.  This is a conditional
refinement theorem: it does not derive the refinement family, plaquette area,
coframe convergence, Levi-Civita transport, or the first-order holonomy
expansion from a bare null-edge graph.  It also does not assume or prove that
the supplied `GL4` links lie in the eta-Lorentz subgroup.  Claim labels:
finite identity and
conditional asymptotic theorem.  The trace-dual construction is standard
finite linear algebra `[import]`; its exact normalization and composition
with the project nonlinear Palatini equation are `[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit

open Filter Topology
open PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge

abbrev Matrix4R := Matrix (Fin 4) (Fin 4) Real

local instance : NormedAddCommGroup Matrix4R :=
  inferInstanceAs (NormedAddCommGroup (Fin 4 -> Fin 4 -> Real))

local instance : NormedSpace Real Matrix4R :=
  inferInstanceAs (NormedSpace Real (Fin 4 -> Fin 4 -> Real))

/-- The six Palatini trace probes, regarded as a linear map on an arbitrary
matrix increment.  No Lie-algebra hypothesis is imposed on the input. -/
def actionVisibleMatrixCurvature : Matrix4R →ₗ[Real] Fiber 6 where
  toFun increment := fun component =>
    splitSixSign component *
      (-(1 / 2 : Real) * Matrix.trace
        (lorentzGenerator (bivectorCoordinateProbe component) * increment))
  map_add' left right := by
    funext component
    simp [Matrix.mul_add, Matrix.trace_add]
    ring
  map_smul' scalar increment := by
    funext component
    simp [Matrix.trace_smul]
    ring

/-- On a generated Lorentz-algebra matrix, the action-visible extractor
recovers the original ordered six curvature coordinates exactly. -/
theorem actionVisibleMatrixCurvature_lorentzGenerator
    (curvature : Fiber 6) :
    actionVisibleMatrixCurvature (lorentzGenerator curvature) = curvature := by
  funext component
  change splitSixSign component *
      (-(1 / 2 : Real) * Matrix.trace
        (lorentzGenerator (bivectorCoordinateProbe component) *
          lorentzGenerator curvature)) = curvature component
  rw [normalizedTracePair_eq_kreinPair,
    kreinPair_bivectorCoordinateProbe]
  by_cases hPositive : component.val < 3 <;>
    simp [splitSixSign, hPositive]

/-- The exact group-holonomy curvature used by the nonlinear action is the
linear matrix extractor applied to `H-I`. -/
theorem orderedHolonomyCurvature_eq_actionVisibleMatrixCurvature
    (holonomy : GL4) :
    orderedHolonomyCurvature holonomy =
      actionVisibleMatrixCurvature (unitMatrix holonomy - 1) := by
  funext component
  rfl

/-- Finite-dimensionality upgrades the algebraic extractor to a continuous
linear map. -/
def actionVisibleMatrixCurvatureContinuous : Matrix4R →L[Real] Fiber 6 :=
  actionVisibleMatrixCurvature.toContinuousLinearMap

@[simp]
theorem actionVisibleMatrixCurvatureContinuous_apply (increment : Matrix4R) :
    actionVisibleMatrixCurvatureContinuous increment =
      actionVisibleMatrixCurvature increment := rfl

/-- A convergent sequence of matrix residuals has convergent action-visible
curvature residuals. -/
theorem actionVisibleMatrixCurvature_tendsto
    (residual : Nat -> Matrix4R) (target : Matrix4R)
    (hResidual : Tendsto residual atTop (nhds target)) :
    Tendsto (fun n => actionVisibleMatrixCurvature (residual n))
      atTop (nhds (actionVisibleMatrixCurvature target)) := by
  simpa only [actionVisibleMatrixCurvatureContinuous_apply] using
    (actionVisibleMatrixCurvatureContinuous.continuous.tendsto target).comp
      hResidual

/-! ## First-order exact-holonomy limit -/

/-- Area-normalized six-component curvature extracted from one sequence of
exact group holonomies. -/
def normalizedOrderedHolonomyCurvature
    (area : Nat -> Real) (holonomy : Nat -> GL4) (n : Nat) : Fiber 6 :=
  (area n)⁻¹ • orderedHolonomyCurvature (holonomy n)

/-- A first-order matrix expansion of exact group holonomies around the
identity, with the leading Lorentz-generator coefficient separated from an
arbitrary matrix residual.  The residual need not lie in the Lorentz Lie
algebra; only the Palatini-visible projection of it matters. -/
structure ActionVisibleFirstOrderHolonomyLimit
    (area : Nat -> Real) (holonomy : Nat -> GL4) (target : Fiber 6) where
  /-- Matrix-valued normalized first-order error. -/
  residual : Nat -> Matrix4R
  /-- Refined areas are eventually nonzero. -/
  area_ne_zero : ∀ᶠ n in atTop, area n ≠ 0
  /-- Refined plaquette areas shrink to zero. -/
  area_tendsto_zero : Tendsto area atTop (nhds 0)
  /-- Exact matrix expansion around the identity. -/
  expansion : ∀ᶠ n in atTop,
    unitMatrix (holonomy n) =
      1 + area n • (lorentzGenerator target + residual n)
  /-- The normalized matrix residual vanishes. -/
  residual_tendsto_zero : Tendsto residual atTop (nhds 0)

/-- One exact first-order matrix expansion gives the corresponding exact
first-order expansion of the six action-visible curvature coordinates. -/
theorem orderedHolonomyCurvature_of_firstOrderExpansion
    (holonomy : GL4) (area : Real) (target : Fiber 6)
    (residual : Matrix4R)
    (hExpansion : unitMatrix holonomy =
      1 + area • (lorentzGenerator target + residual)) :
    orderedHolonomyCurvature holonomy =
      area • (target + actionVisibleMatrixCurvature residual) := by
  rw [orderedHolonomyCurvature_eq_actionVisibleMatrixCurvature]
  have hIncrement :
      unitMatrix holonomy - 1 =
        area • (lorentzGenerator target + residual) := by
    rw [hExpansion]
    abel
  rw [hIncrement, map_smul, map_add,
    actionVisibleMatrixCurvature_lorentzGenerator]

/-- **Action-visible curvature convergence.**  A shrinking first-order
matrix expansion of exact plaquette holonomies converges, after area
normalization, to the same six-component Lorentz curvature coefficient seen
by the nonlinear Palatini action. -/
theorem actionVisibleFirstOrderHolonomyLimit_converges
    (area : Nat -> Real) (holonomy : Nat -> GL4) (target : Fiber 6)
    (h : ActionVisibleFirstOrderHolonomyLimit area holonomy target) :
    Tendsto area atTop (nhds 0) ∧
      Tendsto (normalizedOrderedHolonomyCurvature area holonomy)
        atTop (nhds target) := by
  refine ⟨h.area_tendsto_zero, ?_⟩
  have hResidual :
      Tendsto (fun n => actionVisibleMatrixCurvature (h.residual n))
        atTop (nhds 0) := by
    have hMapped := actionVisibleMatrixCurvature_tendsto
      h.residual 0 h.residual_tendsto_zero
    simpa using hMapped
  have hPoint : ∀ᶠ n in atTop,
      normalizedOrderedHolonomyCurvature area holonomy n =
        target + actionVisibleMatrixCurvature (h.residual n) := by
    filter_upwards [h.area_ne_zero, h.expansion] with n hArea hExpansion
    unfold normalizedOrderedHolonomyCurvature
    rw [orderedHolonomyCurvature_of_firstOrderExpansion
      (holonomy n) (area n) target (h.residual n) hExpansion]
    simp [hArea, smul_smul]
  have hSum : Tendsto
      (fun n => target + actionVisibleMatrixCurvature (h.residual n))
      atTop (nhds target) := by
    simpa using tendsto_const_nhds.add hResidual
  exact hSum.congr' (Filter.EventuallyEq.symm hPoint)

/-- Flat identity holonomies provide an explicit consistent witness for the
first-order action-visible limit interface. -/
def flatActionVisibleFirstOrderHolonomyLimit :
    ActionVisibleFirstOrderHolonomyLimit witnessArea
      (fun _ => (1 : GL4)) 0 where
  residual := fun _ => 0
  area_ne_zero := witnessFirstOrderHolonomyLimit.area_ne_zero
  area_tendsto_zero := witnessFirstOrderHolonomyLimit.area_tendsto_zero
  expansion := Filter.Eventually.of_forall (fun n => by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [unitMatrix, lorentzGenerator, bivectorMatrix,
        MinkowskiConvention.eta])
  residual_tendsto_zero := tendsto_const_nhds

/-- The explicit flat witness has zero normalized action-visible curvature
while its plaquette area shrinks to zero. -/
theorem flatActionVisibleFirstOrderHolonomyLimit_converges :
    Tendsto witnessArea atTop (nhds 0) ∧
      Tendsto
        (normalizedOrderedHolonomyCurvature witnessArea
          (fun _ => (1 : GL4)))
        atTop (nhds 0) :=
  actionVisibleFirstOrderHolonomyLimit_converges witnessArea
    (fun _ => (1 : GL4)) 0 flatActionVisibleFirstOrderHolonomyLimit

/-! ## Oriented plaquette-field refinement -/

/-- A fixed-chart refinement family whose exact ordered plaquette holonomies
have action-visible first-order limits.  The common target face field is
required to have the orientation antisymmetry expected of curvature. -/
structure ActionVisiblePlaquetteRefinement
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (connection : Nat -> LinkConnection Site GL4)
    (area : Nat -> Real) (target : FaceWeight Site 6) where
  /-- First-order expansion of every based ordered plaquette. -/
  firstOrder : forall site a b,
    ActionVisibleFirstOrderHolonomyLimit area
      (fun n => plaquetteUnit shift (connection n) site a b)
      (target site a b)
  /-- Orientation antisymmetry of the limiting curvature field. -/
  target_antisymmetric : IsAntisymmetricFaceWeight target

/-- The raw ordered curvature coordinates converge face by face under an
action-visible plaquette refinement. -/
theorem normalizedRawPlaquetteCurvature_tendsto
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (connection : Nat -> LinkConnection Site GL4)
    (area : Nat -> Real) (target : FaceWeight Site 6)
    (h : ActionVisiblePlaquetteRefinement shift connection area target)
    (site : Site) (a b : Fin 4) (component : Fin 6) :
    Tendsto
      (fun n => (area n)⁻¹ *
        rawPlaquetteCurvature shift (connection n) site a b component)
      atTop (nhds (target site a b component)) := by
  have hOrdered :=
    (actionVisibleFirstOrderHolonomyLimit_converges area
      (fun n => plaquetteUnit shift (connection n) site a b)
      (target site a b) (h.firstOrder site a b)).2
  have hComponent :=
    (continuous_apply component).continuousAt.tendsto.comp hOrdered
  simpa [normalizedOrderedHolonomyCurvature, rawPlaquetteCurvature,
    Pi.smul_apply, smul_eq_mul] using hComponent

/-- The antisymmetrized curvature field entering the nonlinear Palatini
action has the same area-normalized limit as the antisymmetric target field. -/
theorem normalizedExtractedPlaquetteCurvature_tendsto
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (connection : Nat -> LinkConnection Site GL4)
    (area : Nat -> Real) (target : FaceWeight Site 6)
    (h : ActionVisiblePlaquetteRefinement shift connection area target)
    (site : Site) (a b : Fin 4) (component : Fin 6) :
    Tendsto
      (fun n => (area n)⁻¹ *
        extractedPlaquetteCurvature shift (connection n)
          site a b component)
      atTop (nhds (target site a b component)) := by
  have hAB := normalizedRawPlaquetteCurvature_tendsto
    shift connection area target h site a b component
  have hBA := normalizedRawPlaquetteCurvature_tendsto
    shift connection area target h site b a component
  have hHalf : Tendsto
      (fun n => (1 / 2 : Real) *
        ((area n)⁻¹ *
            rawPlaquetteCurvature shift (connection n) site a b component -
          (area n)⁻¹ *
            rawPlaquetteCurvature shift (connection n) site b a component))
      atTop
      (nhds ((1 / 2 : Real) *
        (target site a b component - target site b a component))) :=
    tendsto_const_nhds.mul (hAB.sub hBA)
  have hTargetSwap :
      target site b a component = -target site a b component :=
    h.target_antisymmetric site b a component
  convert hHalf using 1
  · funext n
    unfold extractedPlaquetteCurvature antisymmetrizeFaceWeight
    ring
  · rw [hTargetSwap]
    ring

/-! ## Passage of the finite Einstein equation to the curvature limit -/

abbrev LocalCurvature := Fin 4 -> Fin 4 -> Fiber 6

/-- The bivector-to-matrix conversion is additive. -/
theorem bivectorMatrix_add (left right : Fiber 6) :
    bivectorMatrix (left + right) =
      bivectorMatrix left + bivectorMatrix right := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [bivectorMatrix] <;> ring

/-- The bivector-to-matrix conversion commutes with real scaling. -/
theorem bivectorMatrix_smul (scalar : Real) (curvature : Fiber 6) :
    bivectorMatrix (scalar • curvature) =
      scalar • bivectorMatrix curvature := by
  ext i j
  fin_cases i <;> fin_cases j <;> simp [bivectorMatrix]

/-- One mixed vacuum Einstein entry at a fixed inverse coframe. -/
def mixedVacuumEinsteinEntry
    (inverseCoframe : Matrix4R) (curvature : LocalCurvature)
    (coframeDirection raisedDirection : Fin 4) : Real :=
  2 * mixedRicciCurvature inverseCoframe curvature
      coframeDirection raisedDirection -
    (1 : Matrix4R) raisedDirection coframeDirection *
      inverseCoframeScalarCurvature inverseCoframe curvature

/-- At fixed inverse coframe, each mixed Einstein entry is a linear
functional of the curvature face field. -/
def mixedVacuumEinsteinEntryLinear
    (inverseCoframe : Matrix4R)
    (coframeDirection raisedDirection : Fin 4) :
    LocalCurvature →ₗ[Real] Real where
  toFun curvature := mixedVacuumEinsteinEntry inverseCoframe curvature
    coframeDirection raisedDirection
  map_add' left right := by
    unfold mixedVacuumEinsteinEntry mixedRicciCurvature
      inverseCoframeScalarCurvature
    simp_rw [Pi.add_apply, bivectorMatrix_add, Matrix.add_apply]
    simp only [mul_add, Finset.sum_add_distrib]
    ring
  map_smul' scalar curvature := by
    unfold mixedVacuumEinsteinEntry mixedRicciCurvature
      inverseCoframeScalarCurvature
    simp_rw [Pi.smul_apply, bivectorMatrix_smul, Matrix.smul_apply]
    simp only [smul_eq_mul, RingHom.id_apply, Fin.sum_univ_four]
    ring

/-- The fixed-coframe mixed Einstein functional is continuous on the finite
curvature component space. -/
def mixedVacuumEinsteinEntryContinuous
    (inverseCoframe : Matrix4R)
    (coframeDirection raisedDirection : Fin 4) :
    LocalCurvature →L[Real] Real :=
  (mixedVacuumEinsteinEntryLinear inverseCoframe
    coframeDirection raisedDirection).toContinuousLinearMap

@[simp]
theorem mixedVacuumEinsteinEntryContinuous_apply
    (inverseCoframe : Matrix4R) (curvature : LocalCurvature)
    (coframeDirection raisedDirection : Fin 4) :
    mixedVacuumEinsteinEntryContinuous inverseCoframe
        coframeDirection raisedDirection curvature =
      mixedVacuumEinsteinEntry inverseCoframe curvature
        coframeDirection raisedDirection := rfl

/-- Componentwise curvature convergence implies convergence of every fixed-
coframe mixed Einstein entry. -/
theorem mixedVacuumEinsteinEntry_tendsto
    (inverseCoframe : Matrix4R)
    (curvature : Nat -> LocalCurvature) (target : LocalCurvature)
    (hCurvature : forall a b component,
      Tendsto (fun n => curvature n a b component)
        atTop (nhds (target a b component)))
    (coframeDirection raisedDirection : Fin 4) :
    Tendsto
      (fun n => mixedVacuumEinsteinEntry inverseCoframe (curvature n)
        coframeDirection raisedDirection)
      atTop
      (nhds (mixedVacuumEinsteinEntry inverseCoframe target
        coframeDirection raisedDirection)) := by
  have hField : Tendsto curvature atTop (nhds target) := by
    apply tendsto_pi_nhds.mpr
    intro a
    apply tendsto_pi_nhds.mpr
    intro b
    apply tendsto_pi_nhds.mpr
    intro component
    exact hCurvature a b component
  simpa only [mixedVacuumEinsteinEntryContinuous_apply] using
    (mixedVacuumEinsteinEntryContinuous inverseCoframe
      coframeDirection raisedDirection).continuous.tendsto target |>.comp
        hField

/-- Area-normalized extracted curvature at one fixed chart site. -/
def normalizedExtractedCurvatureAt
    {Site : Type*} (area : Nat -> Real)
    (shift : Fin 4 -> Equiv Site Site)
    (connection : Nat -> LinkConnection Site GL4)
    (site : Site) (n : Nat) : LocalCurvature :=
  (area n)⁻¹ • extractedPlaquetteCurvature shift (connection n) site

/-- **Conditional continuum vacuum Einstein endpoint.**  Suppose a sequence
of exact group-valued null-edge link plaquettes has a common shrinking-area,
first-order action-visible curvature limit on a fixed chart, and suppose the
same coframe is stationary for the concrete nonlinear Palatini action at
every refinement.  Then the limiting curvature satisfies every mixed vacuum
Einstein equation at that coframe.

This theorem passes the already-derived finite equation through an explicit
curvature convergence interface.  It does not construct the refinement or
prove that the limiting target is the Riemann curvature of a Levi-Civita
connection. -/
theorem coframeStationary_refinementLimit_mixedVacuumEinstein
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : Nat -> LinkConnection Site GL4)
    (area : Nat -> Real) (target : FaceWeight Site 6)
    (hRefinement :
      ActionVisiblePlaquetteRefinement shift connection area target)
    (coframe inverseCoframe : CoframeField Site)
    (hLeft : forall site, inverseCoframe site * coframe site = 1)
    (hStationary : forall n,
      NonlinearCoframePlaquetteCoframeStationary
        shift (connection n) coframe) :
    forall site coframeDirection raisedDirection,
      mixedVacuumEinsteinEntry (inverseCoframe site) (target site)
        coframeDirection raisedDirection = 0 := by
  intro site coframeDirection raisedDirection
  let normalized : Nat -> LocalCurvature :=
    normalizedExtractedCurvatureAt area shift connection site
  have hNormalizedComponent : forall a b component,
      Tendsto (fun n => normalized n a b component)
        atTop (nhds (target site a b component)) := by
    intro a b component
    have hCurvature := normalizedExtractedPlaquetteCurvature_tendsto
      shift connection area target hRefinement site a b component
    simpa [normalized, normalizedExtractedCurvatureAt,
      Pi.smul_apply, smul_eq_mul] using hCurvature
  have hEinsteinLimit := mixedVacuumEinsteinEntry_tendsto
    (inverseCoframe site) normalized (target site)
    hNormalizedComponent coframeDirection raisedDirection
  have hNormalizedZero : forall n,
      mixedVacuumEinsteinEntry (inverseCoframe site) (normalized n)
        coframeDirection raisedDirection = 0 := by
    intro n
    have hFinite :=
      (nonlinearCoframePlaquetteCoframeStationary_iff_mixedEinstein
        shift (connection n) coframe inverseCoframe hLeft).mp
          (hStationary n)
    have hEntry := hFinite site coframeDirection raisedDirection
    change mixedVacuumEinsteinEntry (inverseCoframe site)
      (extractedPlaquetteCurvature shift (connection n) site)
      coframeDirection raisedDirection = 0 at hEntry
    change mixedVacuumEinsteinEntryLinear (inverseCoframe site)
      coframeDirection raisedDirection (normalized n) = 0
    unfold normalized normalizedExtractedCurvatureAt
    rw [map_smul]
    change (area n)⁻¹ *
      mixedVacuumEinsteinEntry (inverseCoframe site)
        (extractedPlaquetteCurvature shift (connection n) site)
        coframeDirection raisedDirection = 0
    rw [hEntry, mul_zero]
  have hZeroLimit : Tendsto
      (fun n => mixedVacuumEinsteinEntry
        (inverseCoframe site) (normalized n)
        coframeDirection raisedDirection)
      atTop (nhds 0) := by
    convert tendsto_const_nhds using 1
    funext n
    exact hNormalizedZero n
  exact tendsto_nhds_unique hEinsteinLimit hZeroLimit

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit.actionVisibleMatrixCurvature_lorentzGenerator' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms actionVisibleMatrixCurvature_lorentzGenerator

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit.actionVisibleFirstOrderHolonomyLimit_converges' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms actionVisibleFirstOrderHolonomyLimit_converges

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit.normalizedExtractedPlaquetteCurvature_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms normalizedExtractedPlaquetteCurvature_tendsto

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit.coframeStationary_refinementLimit_mixedVacuumEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms coframeStationary_refinementLimit_mixedVacuumEinstein

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
