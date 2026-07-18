import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniVaryingCoframeLimit

noncomputable section

/-!
# Weak Einstein limit on changing null-edge carriers

The existing nonlinear null-edge Palatini chain proves an exact pointwise
mixed vacuum Einstein equation and passes it to a componentwise curvature
limit when the finite site type is fixed.  A genuine mesh refinement need not
have the same finite carrier at every level.  This module supplies the missing
weak interface for that situation.

First, it proves the finite fundamental lemma: vanishing of the Einstein
residual against every finite test tensor is equivalent to pointwise
vanishing.  It then composes this equivalence with the exact coframe variation
of the nonlinear plaquette action.  Finally, it allows the site type to depend
on the refinement index.  If the weighted residual pairings converge to a
limiting functional and every finite action is coframe-stationary, that limit
functional vanishes on every test.

The theorem does not prove the weak-convergence hypothesis, construct a
refinement family, identify a continuum test-function space, select a
Levi-Civita connection, or upgrade weak convergence to pointwise convergence.
It isolates those obligations without assuming a fixed carrier.  Claim labels:
finite identity and conditional asymptotic theorem.

Provenance: the weak-curvature target is informed by Gawlik-Neunteufel,
arXiv:2310.18802 and arXiv:2301.02159, and the weak Cartan framing by
Gawlik-McKee, arXiv:2510.25027.  The formalization is a clean-room composition
with the repository's convention-locked finite Palatini equation.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniWeakEinsteinLimit

open Filter Topology
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureExtraction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge

abbrev EinsteinTestField (Site : Type*) :=
  Site -> Fin 4 -> Fin 4 -> Real

/-! ## Finite weak Einstein equation -/

/-- Pair a finite mixed Einstein residual with a test tensor. -/
def weakEinsteinPairing
    {Site : Type*} [Fintype Site]
    (inverseCoframe : CoframeField Site)
    (curvature : Site -> LocalCurvature)
    (test : EinsteinTestField Site) : Real :=
  ∑ site, ∑ coframeDirection, ∑ raisedDirection,
    test site coframeDirection raisedDirection *
      mixedVacuumEinsteinEntry (inverseCoframe site) (curvature site)
        coframeDirection raisedDirection

/-- The finite weak vacuum Einstein equation: the mixed residual pairs to zero
with every test tensor. -/
def FiniteWeakVacuumEinstein
    {Site : Type*} [Fintype Site]
    (inverseCoframe : CoframeField Site)
    (curvature : Site -> LocalCurvature) : Prop :=
  forall test, weakEinsteinPairing inverseCoframe curvature test = 0

/-- Delta test tensor supported at one site and one mixed index pair. -/
def pointEinsteinTest
    {Site : Type*} [DecidableEq Site]
    (site : Site) (coframeDirection raisedDirection : Fin 4) :
    EinsteinTestField Site :=
  Pi.single site (Matrix.single coframeDirection raisedDirection 1)

/-- A delta test extracts exactly one mixed Einstein entry. -/
theorem weakEinsteinPairing_pointEinsteinTest
    {Site : Type*} [Fintype Site] [DecidableEq Site]
    (inverseCoframe : CoframeField Site)
    (curvature : Site -> LocalCurvature)
    (site : Site) (coframeDirection raisedDirection : Fin 4) :
    weakEinsteinPairing inverseCoframe curvature
        (pointEinsteinTest site coframeDirection raisedDirection) =
      mixedVacuumEinsteinEntry (inverseCoframe site) (curvature site)
        coframeDirection raisedDirection := by
  classical
  unfold weakEinsteinPairing
  rw [Fintype.sum_eq_single site]
  · rw [Fintype.sum_eq_single coframeDirection]
    · rw [Fintype.sum_eq_single raisedDirection]
      · simp [pointEinsteinTest]
      · intro otherRaised hOther
        simp [pointEinsteinTest, hOther.symm]
    · intro otherDirection hOther
      apply Finset.sum_eq_zero
      intro otherRaised _
      simp [pointEinsteinTest, hOther.symm]
  · intro otherSite hOther
    apply Finset.sum_eq_zero
    intro otherDirection _
    apply Finset.sum_eq_zero
    intro otherRaised _
    simp [pointEinsteinTest, hOther]

/-- **Finite fundamental lemma for the mixed Einstein residual.**  Testing
against every finite tensor is equivalent to all pointwise mixed equations. -/
theorem finiteWeakVacuumEinstein_iff_pointwise
    {Site : Type*} [Fintype Site]
    (inverseCoframe : CoframeField Site)
    (curvature : Site -> LocalCurvature) :
    FiniteWeakVacuumEinstein inverseCoframe curvature <->
      forall site coframeDirection raisedDirection,
        mixedVacuumEinsteinEntry (inverseCoframe site) (curvature site)
          coframeDirection raisedDirection = 0 := by
  classical
  constructor
  · intro hWeak site coframeDirection raisedDirection
    rw [<- weakEinsteinPairing_pointEinsteinTest]
    exact hWeak _
  · intro hPointwise test
    simp [weakEinsteinPairing, hPointwise]

/-- The exact coframe variation of the nonlinear null-edge Palatini action is
equivalent to the finite weak vacuum Einstein equation for its extracted
plaquette curvature. -/
theorem coframeStationary_iff_finiteWeakVacuumEinstein
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe inverseCoframe : CoframeField Site)
    (hLeft : forall site, inverseCoframe site * coframe site = 1) :
    NonlinearCoframePlaquetteCoframeStationary shift connection coframe <->
      FiniteWeakVacuumEinstein inverseCoframe
        (fun site => extractedPlaquetteCurvature shift connection site) := by
  rw [finiteWeakVacuumEinstein_iff_pointwise]
  rw [nonlinearCoframePlaquetteCoframeStationary_iff_mixedEinstein
    shift connection coframe inverseCoframe hLeft]
  rfl

/-! ## Weighted tests and changing-carrier refinement -/

/-- Pair the finite Einstein residual with a test tensor and a site-volume
weight.  The weights are explicit data; no metric dual volume is smuggled in. -/
def weightedWeakEinsteinPairing
    {Site : Type*} [Fintype Site]
    (volume : Site -> Real)
    (inverseCoframe : CoframeField Site)
    (curvature : Site -> LocalCurvature)
    (test : EinsteinTestField Site) : Real :=
  ∑ site, ∑ coframeDirection, ∑ raisedDirection,
    volume site * test site coframeDirection raisedDirection *
      mixedVacuumEinsteinEntry (inverseCoframe site) (curvature site)
        coframeDirection raisedDirection

/-- A delta test extracts one volume-weighted mixed Einstein entry. -/
theorem weightedWeakEinsteinPairing_pointEinsteinTest
    {Site : Type*} [Fintype Site] [DecidableEq Site]
    (volume : Site -> Real)
    (inverseCoframe : CoframeField Site)
    (curvature : Site -> LocalCurvature)
    (site : Site) (coframeDirection raisedDirection : Fin 4) :
    weightedWeakEinsteinPairing volume inverseCoframe curvature
        (pointEinsteinTest site coframeDirection raisedDirection) =
      volume site *
        mixedVacuumEinsteinEntry (inverseCoframe site) (curvature site)
          coframeDirection raisedDirection := by
  classical
  unfold weightedWeakEinsteinPairing
  rw [Fintype.sum_eq_single site]
  · rw [Fintype.sum_eq_single coframeDirection]
    · rw [Fintype.sum_eq_single raisedDirection]
      · simp [pointEinsteinTest]
      · intro otherRaised hOther
        simp [pointEinsteinTest, hOther.symm]
    · intro otherDirection hOther
      apply Finset.sum_eq_zero
      intro otherRaised _
      simp [pointEinsteinTest, hOther.symm]
  · intro otherSite hOther
    apply Finset.sum_eq_zero
    intro otherDirection _
    apply Finset.sum_eq_zero
    intro otherRaised _
    simp [pointEinsteinTest, hOther]

/-- With nonzero site volumes, weighted weak testing remains equivalent to
pointwise vanishing. -/
theorem weightedWeakEinsteinPairing_all_zero_iff_pointwise
    {Site : Type*} [Fintype Site]
    (volume : Site -> Real) (hVolume : forall site, volume site ≠ 0)
    (inverseCoframe : CoframeField Site)
    (curvature : Site -> LocalCurvature) :
    (forall test,
      weightedWeakEinsteinPairing volume inverseCoframe curvature test = 0) <->
      forall site coframeDirection raisedDirection,
        mixedVacuumEinsteinEntry (inverseCoframe site) (curvature site)
          coframeDirection raisedDirection = 0 := by
  classical
  constructor
  · intro hWeak site coframeDirection raisedDirection
    have h := hWeak (pointEinsteinTest site coframeDirection raisedDirection)
    have hProduct : volume site *
        mixedVacuumEinsteinEntry (inverseCoframe site) (curvature site)
          coframeDirection raisedDirection = 0 := by
      rw [weightedWeakEinsteinPairing_pointEinsteinTest] at h
      exact h
    exact (mul_eq_zero.mp hProduct).resolve_left (hVolume site)
  · intro hPointwise test
    simp [weightedWeakEinsteinPairing, hPointwise]

/-- With nonzero site volumes, exact coframe stationarity is equivalent to the
volume-weighted finite weak vacuum Einstein equation. -/
theorem coframeStationary_iff_weightedWeakVacuumEinstein
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4)
    (coframe inverseCoframe : CoframeField Site)
    (volume : Site -> Real) (hVolume : forall site, volume site ≠ 0)
    (hLeft : forall site, inverseCoframe site * coframe site = 1) :
    NonlinearCoframePlaquetteCoframeStationary shift connection coframe <->
      forall test,
        weightedWeakEinsteinPairing volume inverseCoframe
          (fun site => extractedPlaquetteCurvature shift connection site)
          test = 0 := by
  rw [weightedWeakEinsteinPairing_all_zero_iff_pointwise
    volume hVolume inverseCoframe]
  rw [nonlinearCoframePlaquetteCoframeStationary_iff_mixedEinstein
    shift connection coframe inverseCoframe hLeft]
  rfl

/-- Area-normalized action-visible curvature on a carrier whose site type may
depend on the refinement level. -/
def changingCarrierNormalizedCurvature
    {Site : Nat -> Type*}
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (connection : (n : Nat) -> LinkConnection (Site n) GL4)
    (area : Nat -> Real) (n : Nat) (site : Site n) : LocalCurvature :=
  (area n)⁻¹ • extractedPlaquetteCurvature (shift n) (connection n) site

/-- Weighted weak Einstein pairing at one changing-carrier refinement level. -/
def changingCarrierWeakEinsteinPairing
    {Site : Nat -> Type*} [forall n, Fintype (Site n)]
    {Test : Type*}
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (connection : (n : Nat) -> LinkConnection (Site n) GL4)
    (area : Nat -> Real)
    (volume : (n : Nat) -> Site n -> Real)
    (inverseCoframe : (n : Nat) -> CoframeField (Site n))
    (sample : (n : Nat) -> Test -> EinsteinTestField (Site n))
    (test : Test) (n : Nat) : Real :=
  weightedWeakEinsteinPairing (volume n) (inverseCoframe n)
    (changingCarrierNormalizedCurvature shift connection area n)
    (sample n test)

/-- Finite coframe stationarity forces every changing-carrier weighted pairing
to vanish, independently of the chosen quadrature weights and test sampler. -/
theorem changingCarrierWeakEinsteinPairing_eq_zero_of_stationary
    {Site : Nat -> Type*} [forall n, Fintype (Site n)]
    {Test : Type*}
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (connection : (n : Nat) -> LinkConnection (Site n) GL4)
    (area : Nat -> Real)
    (volume : (n : Nat) -> Site n -> Real)
    (coframe inverseCoframe : (n : Nat) -> CoframeField (Site n))
    (sample : (n : Nat) -> Test -> EinsteinTestField (Site n))
    (hLeft : forall n site,
      inverseCoframe n site * coframe n site = 1)
    (hStationary : forall n,
      NonlinearCoframePlaquetteCoframeStationary
        (shift n) (connection n) (coframe n))
    (test : Test) (n : Nat) :
    changingCarrierWeakEinsteinPairing shift connection area volume
      inverseCoframe sample test n = 0 := by
  classical
  unfold changingCarrierWeakEinsteinPairing weightedWeakEinsteinPairing
  apply Finset.sum_eq_zero
  intro site _
  apply Finset.sum_eq_zero
  intro coframeDirection _
  apply Finset.sum_eq_zero
  intro raisedDirection _
  have hFinite :=
    (nonlinearCoframePlaquetteCoframeStationary_iff_mixedEinstein
      (shift n) (connection n) (coframe n) (inverseCoframe n)
        (hLeft n)).mp (hStationary n)
  have hEntry := hFinite site coframeDirection raisedDirection
  change mixedVacuumEinsteinEntry (inverseCoframe n site)
    (extractedPlaquetteCurvature (shift n) (connection n) site)
    coframeDirection raisedDirection = 0 at hEntry
  have hNormalized :
      mixedVacuumEinsteinEntry (inverseCoframe n site)
        (changingCarrierNormalizedCurvature shift connection area n site)
        coframeDirection raisedDirection = 0 := by
    change mixedVacuumEinsteinEntryLinear (inverseCoframe n site)
      coframeDirection raisedDirection
      (changingCarrierNormalizedCurvature shift connection area n site) = 0
    unfold changingCarrierNormalizedCurvature
    rw [map_smul]
    change (area n)⁻¹ *
      mixedVacuumEinsteinEntry (inverseCoframe n site)
        (extractedPlaquetteCurvature (shift n) (connection n) site)
        coframeDirection raisedDirection = 0
    rw [hEntry, mul_zero]
  rw [hNormalized, mul_zero]

/-- **Conditional changing-carrier weak vacuum Einstein endpoint.**  Suppose
the weighted finite residual pairings converge to a limiting functional on an
abstract test space.  If every finite null-edge Palatini action is
coframe-stationary, the limiting functional vanishes on every test.

Unlike the earlier componentwise endpoint, the finite site type may change at
every refinement level.  The theorem deliberately leaves the continuum test
space, sampling maps, volume weights, and convergence proof explicit. -/
theorem coframeStationary_changingCarrier_weakEinsteinLimit
    {Site : Nat -> Type*} [forall n, Fintype (Site n)]
    {Test : Type*}
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (connection : (n : Nat) -> LinkConnection (Site n) GL4)
    (area : Nat -> Real)
    (volume : (n : Nat) -> Site n -> Real)
    (coframe inverseCoframe : (n : Nat) -> CoframeField (Site n))
    (sample : (n : Nat) -> Test -> EinsteinTestField (Site n))
    (limitPairing : Test -> Real)
    (hLeft : forall n site,
      inverseCoframe n site * coframe n site = 1)
    (hStationary : forall n,
      NonlinearCoframePlaquetteCoframeStationary
        (shift n) (connection n) (coframe n))
    (hWeakConvergence : forall test,
      Tendsto
        (changingCarrierWeakEinsteinPairing shift connection area volume
          inverseCoframe sample test)
        atTop (nhds (limitPairing test))) :
    forall test, limitPairing test = 0 := by
  intro test
  have hZero : Tendsto
      (changingCarrierWeakEinsteinPairing shift connection area volume
        inverseCoframe sample test)
      atTop (nhds 0) := by
    convert tendsto_const_nhds using 1
    funext n
    exact changingCarrierWeakEinsteinPairing_eq_zero_of_stationary
      shift connection area volume coframe inverseCoframe sample hLeft
        hStationary test n
  exact tendsto_nhds_unique (hWeakConvergence test) hZero

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniWeakEinsteinLimit.finiteWeakVacuumEinstein_iff_pointwise' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finiteWeakVacuumEinstein_iff_pointwise

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniWeakEinsteinLimit.coframeStationary_iff_finiteWeakVacuumEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms coframeStationary_iff_finiteWeakVacuumEinstein

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniWeakEinsteinLimit.coframeStationary_iff_weightedWeakVacuumEinstein' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms coframeStationary_iff_weightedWeakVacuumEinstein

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniWeakEinsteinLimit.coframeStationary_changingCarrier_weakEinsteinLimit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms coframeStationary_changingCarrier_weakEinsteinLimit

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniWeakEinsteinLimit
