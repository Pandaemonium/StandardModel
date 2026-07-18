import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit

noncomputable section

/-!
# Varying-coframe limit of the nonlinear Lorentz Palatini equation

`NonlinearLorentzPalatiniCurvatureLimit` passes the finite coframe Euler
equation to a curvature limit while holding the coframe fixed.  This module
removes that restriction.  The mixed Einstein entry is a finite polynomial
in the inverse coframe and the six-component curvature field, hence is jointly
continuous when both fields converge componentwise.

A coframe refinement records coframes and supplied inverses at every finite
stage, together with componentwise limits of both.  The exact left-inverse
relation is proved to survive the limit.  Combining this fact with the
action-visible plaquette refinement gives a conditional endpoint in which
both the tetrad and curvature may vary with refinement.

This remains a reconstruction theorem, not a graph-generation theorem.  It
does not derive the refinement family, prove convergence, select a
Levi-Civita connection, or identify the limiting six-component field with
continuum Riemann curvature.  Claim labels: finite identity and conditional
asymptotic theorem.  The continuity argument is standard finite-dimensional
analysis `[import]`; its composition with the exact null-edge Palatini Euler
equation is `[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniVaryingCoframeLimit

open Filter Topology
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
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge

abbrev Matrix4R := Matrix (Fin 4) (Fin 4) Real

abbrev LocalCurvature := Fin 4 -> Fin 4 -> Fiber 6

local instance : NormedAddCommGroup Matrix4R :=
  inferInstanceAs (NormedAddCommGroup (Fin 4 -> Fin 4 -> Real))

local instance : NormedSpace Real Matrix4R :=
  inferInstanceAs (NormedSpace Real (Fin 4 -> Fin 4 -> Real))

/-! ## Joint continuity of the Einstein polynomial -/

/-- The internal bivector matrix is a linear function of its six ordered
coordinates. -/
def bivectorMatrixLinear : Fiber 6 →ₗ[Real] Matrix4R where
  toFun := bivectorMatrix
  map_add' := bivectorMatrix_add
  map_smul' := bivectorMatrix_smul

/-- Finite-dimensionality makes the bivector matrix conversion continuous. -/
def bivectorMatrixContinuous : Fiber 6 →L[Real] Matrix4R :=
  bivectorMatrixLinear.toContinuousLinearMap

@[simp]
theorem bivectorMatrixContinuous_apply (curvature : Fiber 6) :
    bivectorMatrixContinuous curvature = bivectorMatrix curvature := rfl

/-- Componentwise convergence of a local six-component curvature field gives
matrix convergence after the internal bivector conversion. -/
theorem curvatureBivectorMatrix_tendsto
    (curvature : Nat -> LocalCurvature) (target : LocalCurvature)
    (hCurvature : forall a b component,
      Tendsto (fun n => curvature n a b component)
        atTop (nhds (target a b component)))
    (a b : Fin 4) :
    Tendsto (fun n => bivectorMatrix (curvature n a b))
      atTop (nhds (bivectorMatrix (target a b))) := by
  have hFace : Tendsto (fun n => curvature n a b)
      atTop (nhds (target a b)) := by
    apply tendsto_pi_nhds.mpr
    intro component
    exact hCurvature a b component
  simpa only [bivectorMatrixContinuous_apply] using
    (bivectorMatrixContinuous.continuous.tendsto (target a b)).comp hFace

/-- Joint componentwise convergence of inverse coframes and curvature implies
convergence of the inverse-coframe scalar curvature. -/
theorem inverseCoframeScalarCurvature_tendsto_joint
    (inverseCoframe : Nat -> Matrix4R) (targetInverse : Matrix4R)
    (curvature : Nat -> LocalCurvature) (target : LocalCurvature)
    (hInverse : forall i j,
      Tendsto (fun n => inverseCoframe n i j)
        atTop (nhds (targetInverse i j)))
    (hCurvature : forall a b component,
      Tendsto (fun n => curvature n a b component)
        atTop (nhds (target a b component))) :
    Tendsto
      (fun n => inverseCoframeScalarCurvature
        (inverseCoframe n) (curvature n))
      atTop
      (nhds (inverseCoframeScalarCurvature targetInverse target)) := by
  unfold inverseCoframeScalarCurvature
  refine tendsto_finset_sum Finset.univ (fun a _ => ?_)
  refine tendsto_finset_sum Finset.univ (fun b _ => ?_)
  refine tendsto_finset_sum Finset.univ (fun i _ => ?_)
  refine tendsto_finset_sum Finset.univ (fun j _ => ?_)
  have hMatrix := curvatureBivectorMatrix_tendsto
    curvature target hCurvature a b
  have hEntry : Tendsto
      (fun n => bivectorMatrix (curvature n a b) i j)
      atTop (nhds (bivectorMatrix (target a b) i j)) := by
    have hEvaluation : Continuous (fun matrix : Matrix4R => matrix i j) :=
      (continuous_apply j).comp (continuous_apply i)
    exact hEvaluation.continuousAt.tendsto.comp hMatrix
  exact ((hInverse a i).mul (hInverse b j)).mul hEntry

/-- Joint componentwise convergence of inverse coframes and curvature implies
convergence of every mixed Ricci entry. -/
theorem mixedRicciCurvature_tendsto_joint
    (inverseCoframe : Nat -> Matrix4R) (targetInverse : Matrix4R)
    (curvature : Nat -> LocalCurvature) (target : LocalCurvature)
    (hInverse : forall i j,
      Tendsto (fun n => inverseCoframe n i j)
        atTop (nhds (targetInverse i j)))
    (hCurvature : forall a b component,
      Tendsto (fun n => curvature n a b component)
        atTop (nhds (target a b component)))
    (coframeDirection raisedDirection : Fin 4) :
    Tendsto
      (fun n => mixedRicciCurvature (inverseCoframe n) (curvature n)
        coframeDirection raisedDirection)
      atTop
      (nhds (mixedRicciCurvature targetInverse target
        coframeDirection raisedDirection)) := by
  unfold mixedRicciCurvature
  refine tendsto_finset_sum Finset.univ (fun i _ => ?_)
  refine tendsto_finset_sum Finset.univ (fun b _ => ?_)
  refine tendsto_finset_sum Finset.univ (fun j _ => ?_)
  have hMatrix := curvatureBivectorMatrix_tendsto
    curvature target hCurvature coframeDirection b
  have hEntry : Tendsto
      (fun n => bivectorMatrix (curvature n coframeDirection b) i j)
      atTop (nhds (bivectorMatrix (target coframeDirection b) i j)) := by
    have hEvaluation : Continuous (fun matrix : Matrix4R => matrix i j) :=
      (continuous_apply j).comp (continuous_apply i)
    exact hEvaluation.continuousAt.tendsto.comp hMatrix
  exact ((hInverse raisedDirection i).mul (hInverse b j)).mul hEntry

/-- Every mixed vacuum Einstein entry is jointly continuous in the inverse
coframe and curvature field. -/
theorem mixedVacuumEinsteinEntry_tendsto_joint
    (inverseCoframe : Nat -> Matrix4R) (targetInverse : Matrix4R)
    (curvature : Nat -> LocalCurvature) (target : LocalCurvature)
    (hInverse : forall i j,
      Tendsto (fun n => inverseCoframe n i j)
        atTop (nhds (targetInverse i j)))
    (hCurvature : forall a b component,
      Tendsto (fun n => curvature n a b component)
        atTop (nhds (target a b component)))
    (coframeDirection raisedDirection : Fin 4) :
    Tendsto
      (fun n => mixedVacuumEinsteinEntry (inverseCoframe n) (curvature n)
        coframeDirection raisedDirection)
      atTop
      (nhds (mixedVacuumEinsteinEntry targetInverse target
        coframeDirection raisedDirection)) := by
  have hRicci := mixedRicciCurvature_tendsto_joint
    inverseCoframe targetInverse curvature target hInverse hCurvature
      coframeDirection raisedDirection
  have hScalar := inverseCoframeScalarCurvature_tendsto_joint
    inverseCoframe targetInverse curvature target hInverse hCurvature
  unfold mixedVacuumEinsteinEntry
  exact (tendsto_const_nhds.mul hRicci).sub
    (tendsto_const_nhds.mul hScalar)

/-! ## Coframe refinement and inverse survival -/

/-- A sequence of finite coframes and supplied left inverses converging
componentwise to a limiting coframe pair.  Requiring convergence of the
inverses explicitly excludes a hidden degeneration at the limit. -/
structure CoframeRefinementLimit
    {Site : Type*}
    (coframe inverseCoframe : Nat -> CoframeField Site)
    (targetCoframe targetInverseCoframe : CoframeField Site) where
  /-- Every finite inverse is an exact left inverse. -/
  leftInverse : forall n site,
    inverseCoframe n site * coframe n site = 1
  /-- The coframe converges componentwise at every chart site. -/
  coframe_tendsto : forall site i j,
    Tendsto (fun n => coframe n site i j)
      atTop (nhds (targetCoframe site i j))
  /-- The supplied inverse coframe also converges componentwise. -/
  inverseCoframe_tendsto : forall site i j,
    Tendsto (fun n => inverseCoframe n site i j)
      atTop (nhds (targetInverseCoframe site i j))

/-- The exact finite left-inverse equations survive simultaneous coframe and
inverse-coframe convergence. -/
theorem CoframeRefinementLimit.target_leftInverse
    {Site : Type*}
    {coframe inverseCoframe : Nat -> CoframeField Site}
    {targetCoframe targetInverseCoframe : CoframeField Site}
    (h : CoframeRefinementLimit coframe inverseCoframe
      targetCoframe targetInverseCoframe) :
    forall site,
      targetInverseCoframe site * targetCoframe site = 1 := by
  intro site
  ext i j
  have hProduct : Tendsto
      (fun n => (inverseCoframe n site * coframe n site) i j)
      atTop
      (nhds ((targetInverseCoframe site * targetCoframe site) i j)) := by
    simpa only [Matrix.mul_apply] using
      tendsto_finset_sum Finset.univ (fun k _ =>
        (h.inverseCoframe_tendsto site i k).mul
          (h.coframe_tendsto site k j))
  have hIdentity : Tendsto
      (fun n => (inverseCoframe n site * coframe n site) i j)
      atTop (nhds ((1 : Matrix4R) i j)) := by
    convert tendsto_const_nhds using 1
    funext n
    rw [h.leftInverse n site]
  exact tendsto_nhds_unique hProduct hIdentity

/-! ## Varying-coframe Einstein endpoint -/

/-- Area-normalized extracted curvature at one fixed chart site. -/
def normalizedExtractedCurvatureAt
    {Site : Type*} (area : Nat -> Real)
    (shift : Fin 4 -> Equiv Site Site)
    (connection : Nat -> LinkConnection Site GL4)
    (site : Site) (n : Nat) : LocalCurvature :=
  (area n)⁻¹ • extractedPlaquetteCurvature shift (connection n) site

/-- **Conditional varying-tetrad vacuum Einstein endpoint.**  Suppose exact
group-valued null-edge plaquettes have a common shrinking-area first-order
action-visible curvature limit.  Let the coframe and its exact finite inverse
vary with refinement and converge componentwise, and suppose the concrete
nonlinear Palatini action is coframe-stationary at every stage.  Then the
limiting coframe pair remains inverse and the limiting curvature satisfies
all mixed vacuum Einstein equations.

This theorem removes the fixed-coframe restriction from the earlier limit
theorem.  It still assumes, rather than derives, the two refinement limits and
does not identify the limiting curvature with Levi-Civita Riemann curvature. -/
theorem coframeStationary_varyingRefinementLimit
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : Nat -> LinkConnection Site GL4)
    (area : Nat -> Real) (target : FaceWeight Site 6)
    (hPlaquette :
      ActionVisiblePlaquetteRefinement shift connection area target)
    (coframe inverseCoframe : Nat -> CoframeField Site)
    (targetCoframe targetInverseCoframe : CoframeField Site)
    (hCoframe : CoframeRefinementLimit coframe inverseCoframe
      targetCoframe targetInverseCoframe)
    (hStationary : forall n,
      NonlinearCoframePlaquetteCoframeStationary
        shift (connection n) (coframe n)) :
    (forall site,
      targetInverseCoframe site * targetCoframe site = 1) ∧
      forall site coframeDirection raisedDirection,
        mixedVacuumEinsteinEntry (targetInverseCoframe site) (target site)
          coframeDirection raisedDirection = 0 := by
  refine ⟨hCoframe.target_leftInverse, ?_⟩
  intro site coframeDirection raisedDirection
  let normalized : Nat -> LocalCurvature :=
    normalizedExtractedCurvatureAt area shift connection site
  have hNormalizedComponent : forall a b component,
      Tendsto (fun n => normalized n a b component)
        atTop (nhds (target site a b component)) := by
    intro a b component
    have hCurvature := normalizedExtractedPlaquetteCurvature_tendsto
      shift connection area target hPlaquette site a b component
    simpa [normalized, normalizedExtractedCurvatureAt,
      Pi.smul_apply, smul_eq_mul] using hCurvature
  have hEinsteinLimit := mixedVacuumEinsteinEntry_tendsto_joint
    (fun n => inverseCoframe n site) (targetInverseCoframe site)
    normalized (target site) (hCoframe.inverseCoframe_tendsto site)
    hNormalizedComponent coframeDirection raisedDirection
  have hNormalizedZero : forall n,
      mixedVacuumEinsteinEntry (inverseCoframe n site) (normalized n)
        coframeDirection raisedDirection = 0 := by
    intro n
    have hFinite :=
      (nonlinearCoframePlaquetteCoframeStationary_iff_mixedEinstein
        shift (connection n) (coframe n) (inverseCoframe n)
          (hCoframe.leftInverse n)).mp (hStationary n)
    have hEntry := hFinite site coframeDirection raisedDirection
    change mixedVacuumEinsteinEntry (inverseCoframe n site)
      (extractedPlaquetteCurvature shift (connection n) site)
      coframeDirection raisedDirection = 0 at hEntry
    change mixedVacuumEinsteinEntryLinear (inverseCoframe n site)
      coframeDirection raisedDirection (normalized n) = 0
    unfold normalized normalizedExtractedCurvatureAt
    rw [map_smul]
    change (area n)⁻¹ *
      mixedVacuumEinsteinEntry (inverseCoframe n site)
        (extractedPlaquetteCurvature shift (connection n) site)
        coframeDirection raisedDirection = 0
    rw [hEntry, mul_zero]
  have hZeroLimit : Tendsto
      (fun n => mixedVacuumEinsteinEntry
        (inverseCoframe n site) (normalized n)
        coframeDirection raisedDirection)
      atTop (nhds 0) := by
    convert tendsto_const_nhds using 1
    funext n
    exact hNormalizedZero n
  exact tendsto_nhds_unique hEinsteinLimit hZeroLimit

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniVaryingCoframeLimit.mixedVacuumEinsteinEntry_tendsto_joint' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mixedVacuumEinsteinEntry_tendsto_joint

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniVaryingCoframeLimit.CoframeRefinementLimit.target_leftInverse' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms CoframeRefinementLimit.target_leftInverse

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniVaryingCoframeLimit.coframeStationary_varyingRefinementLimit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms coframeStationary_varyingRefinementLimit

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniVaryingCoframeLimit
