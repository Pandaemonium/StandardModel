import PhysicsSM.Draft.NullEdge.VacuumWeylCurvatureTarget

noncomputable section

/-!
# Periodic mean obstruction for a vacuum-Weyl link realization

The algebraic vacuum-Weyl target is a legitimate nonzero local curvature
tensor.  This module asks whether the same tensor can be placed at every site
of a finite periodic carrier and arise as the first-order curl of a globally
defined Lorentz-link potential.

It cannot.  Every component of an additive plaquette curl has zero total over
a finite periodic carrier because each shifted site sum is a reindexing of the
unshifted sum.  Consequently a site-independent additive curvature is zero on
every nonempty finite carrier.  In particular, the nonzero unit vacuum-Weyl
target cannot be realized site-independently in the periodic trivialization.

This is a linearized periodic-exactness obstruction, not a no-go theorem for
curved null-edge gravity.  It identifies the degrees of freedom the next
construction must use: a site-decorated curvature related by varying coframes,
a carrier with boundary, a twisted/nontrivial bundle sector, or a genuinely
nonlinear scaling whose leading curvature is not a global additive curl.

The finite reindexing argument is discrete Stokes on a closed periodic carrier
`[import]`; its application to the convention-locked null-edge vacuum-Weyl
target is `[orig/comp]`.  Claim label: finite no-go identity.
-/

namespace PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylMeanObstruction

open Filter Topology
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement
open PhysicsSM.Draft.NullEdge.VacuumWeylCurvatureTarget

/-- A site-dependent curvature field is exactly the additive plaquette curl
of a globally defined six-component periodic link potential. -/
def HasPeriodicAdditiveLinkRealization
    {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site)
    (curvature : Site -> Fin 4 -> Fin 4 -> Fiber 6) : Prop :=
  exists variation : LinkVariation Site,
    forall site a b,
      additivePlaquetteCurl shift variation site a b = curvature site a b

/-- Each component of an additive plaquette curl has zero site sum on a finite
periodic carrier.  Commutativity of distinct shifts is not needed for this
necessary condition: each shifted term cancels by permutation reindexing. -/
theorem sum_additivePlaquetteCurl_eq_zero
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (variation : LinkVariation Site)
    (a b : Fin 4) (component : Fin 6) :
    Finset.sum Finset.univ (fun site =>
        additivePlaquetteCurl shift variation site a b component) = 0 := by
  have hShiftA :
      Finset.sum Finset.univ (fun site =>
          variation (shift a site) b component) =
        Finset.sum Finset.univ (fun site => variation site b component) := by
    simpa using Equiv.sum_comp (shift a)
      (fun site => variation site b component)
  have hShiftB :
      Finset.sum Finset.univ (fun site =>
          variation (shift b site) a component) =
        Finset.sum Finset.univ (fun site => variation site a component) := by
    simpa using Equiv.sum_comp (shift b)
      (fun site => variation site a component)
  simp only [additivePlaquetteCurl, Finset.sum_add_distrib,
    Finset.sum_sub_distrib]
  rw [hShiftA, hShiftB]
  ring

/-- Every periodically realized additive curvature has zero mean in each
ordered face and internal bivector component. -/
theorem periodicAdditiveLinkRealization_face_sum_zero
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (curvature : Site -> Fin 4 -> Fin 4 -> Fiber 6)
    (hRealized : HasPeriodicAdditiveLinkRealization shift curvature)
    (a b : Fin 4) (component : Fin 6) :
    Finset.sum Finset.univ (fun site => curvature site a b component) = 0 := by
  rcases hRealized with ⟨variation, hVariation⟩
  calc
    Finset.sum Finset.univ (fun site => curvature site a b component) =
        Finset.sum Finset.univ (fun site =>
          additivePlaquetteCurl shift variation site a b component) := by
      apply Finset.sum_congr rfl
      intro site _
      exact congrFun (hVariation site a b).symm component
    _ = 0 := sum_additivePlaquetteCurl_eq_zero
      shift variation a b component

/-- The additive curl obeys the exact three-direction discrete Bianchi
identity whenever the carrier shifts commute. -/
theorem additivePlaquetteCurl_bianchi
    {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site) (hCommute : ShiftsCommute shift)
    (variation : LinkVariation Site) (site : Site)
    (a b c : Fin 4) (component : Fin 6) :
    (additivePlaquetteCurl shift variation (shift a site) b c component -
        additivePlaquetteCurl shift variation site b c component) +
      (additivePlaquetteCurl shift variation (shift b site) c a component -
        additivePlaquetteCurl shift variation site c a component) +
      (additivePlaquetteCurl shift variation (shift c site) a b component -
        additivePlaquetteCurl shift variation site a b component) = 0 := by
  simp only [additivePlaquetteCurl]
  rw [hCommute site a b, hCommute site b c, hCommute site c a]
  ring

/-- Every realized additive curvature inherits the discrete Bianchi identity.
-/
theorem periodicAdditiveLinkRealization_bianchi
    {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site) (hCommute : ShiftsCommute shift)
    (curvature : Site -> Fin 4 -> Fin 4 -> Fiber 6)
    (hRealized : HasPeriodicAdditiveLinkRealization shift curvature)
    (site : Site) (a b c : Fin 4) (component : Fin 6) :
    (curvature (shift a site) b c component -
        curvature site b c component) +
      (curvature (shift b site) c a component -
        curvature site c a component) +
      (curvature (shift c site) a b component -
        curvature site a b component) = 0 := by
  rcases hRealized with ⟨variation, hVariation⟩
  simpa only [← congrFun (hVariation (shift a site) b c) component,
    ← congrFun (hVariation site b c) component,
    ← congrFun (hVariation (shift b site) c a) component,
    ← congrFun (hVariation site c a) component,
    ← congrFun (hVariation (shift c site) a b) component,
    ← congrFun (hVariation site a b) component] using
      additivePlaquetteCurl_bianchi
        shift hCommute variation site a b c component

/-- A site-independent additive curvature on a nonempty finite periodic
carrier must vanish identically. -/
theorem siteIndependent_periodicAdditiveLinkRealization_eq_zero
    {Site : Type*} [Finite Site] [Nonempty Site]
    (shift : Fin 4 -> Equiv Site Site)
    (target : Fin 4 -> Fin 4 -> Fiber 6)
    (hRealized : HasPeriodicAdditiveLinkRealization shift (fun _ => target)) :
    target = 0 := by
  letI := Fintype.ofFinite Site
  funext a b component
  have hSum := periodicAdditiveLinkRealization_face_sum_zero
    shift (fun _ => target) hRealized a b component
  simp only [Finset.sum_const, Finset.card_univ, nsmul_eq_mul] at hSum
  have hCard : (Fintype.card Site : Real) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero
  exact (mul_eq_zero.mp hSum).resolve_left hCard

/-- A sequence of periodically exact additive curvatures on one fixed carrier
converges componentwise at every site to a site-independent target. -/
def HasFixedCarrierPeriodicAdditiveLimit
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (target : Fin 4 -> Fin 4 -> Fiber 6) : Prop :=
  exists curvature : Nat -> Site -> Fin 4 -> Fin 4 -> Fiber 6,
    (forall n, HasPeriodicAdditiveLinkRealization shift (curvature n)) /\
      forall site a b component,
        Tendsto (fun n => curvature n site a b component)
          atTop (nhds (target a b component))

/-- Even an asymptotic site-independent limit of periodic additive curls on a
fixed nonempty finite carrier must be zero. -/
theorem fixedCarrier_periodicAdditiveLimit_eq_zero
    {Site : Type*} [Fintype Site] [Nonempty Site]
    (shift : Fin 4 -> Equiv Site Site)
    (target : Fin 4 -> Fin 4 -> Fiber 6)
    (hLimit : HasFixedCarrierPeriodicAdditiveLimit shift target) :
    target = 0 := by
  rcases hLimit with ⟨curvature, hRealized, hConverges⟩
  funext a b component
  have hSumLimit :
      Tendsto
        (fun n => Finset.sum Finset.univ (fun site =>
          curvature n site a b component)) atTop
        (nhds (Finset.sum Finset.univ (fun _ : Site =>
          target a b component))) := by
    exact tendsto_finset_sum Finset.univ (fun site _ =>
      hConverges site a b component)
  have hSequenceZero :
      (fun n => Finset.sum Finset.univ (fun site =>
        curvature n site a b component)) = (fun _ => 0) := by
    funext n
    exact periodicAdditiveLinkRealization_face_sum_zero
      shift (curvature n) (hRealized n) a b component
  rw [hSequenceZero] at hSumLimit
  have hTargetSum :
      Finset.sum Finset.univ (fun _ : Site => target a b component) = 0 :=
    tendsto_nhds_unique hSumLimit tendsto_const_nhds
  simp only [Finset.sum_const, Finset.card_univ, nsmul_eq_mul] at hTargetSum
  have hCard : (Fintype.card Site : Real) ≠ 0 := by
    exact_mod_cast Fintype.card_ne_zero
  exact (mul_eq_zero.mp hTargetSum).resolve_left hCard

/-! ## Why a common checkerboard Weyl amplitude is not enough -/

/-- Allow both parameters of the diagonal algebraic vacuum-Weyl family to
vary from site to site without rotating its six bivector eigenplanes. -/
def siteDecoratedDiagonalVacuumWeyl
    {Site : Type*} (x y : Site -> Real) :
    Site -> Fin 4 -> Fin 4 -> Fiber 6 :=
  fun site => diagonalVacuumWeylCurvature (x site) (y site)

/-- Every site of the two-parameter decorated field still satisfies the local
mixed vacuum Einstein equation. -/
theorem siteDecoratedDiagonalVacuumWeyl_mixedVacuum
    {Site : Type*} (x y : Site -> Real)
    (site : Site) (coframeDirection raisedDirection : Fin 4) :
    mixedVacuumEinsteinEntry
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (siteDecoratedDiagonalVacuumWeyl x y site)
        coframeDirection raisedDirection = 0 :=
  diagonalVacuumWeylCurvature_mixedVacuum
    (x site) (y site) coframeDirection raisedDirection

/-- If a site-decorated diagonal vacuum-Weyl field is an additive periodic
curl, discrete Bianchi freezes both diagonal Weyl parameters along every
carrier shift.  Escaping periodic exactness therefore requires rotations or
mixing of the bivector eigenplanes, not merely varying the two eigenvalues. -/
theorem siteDecoratedDiagonalVacuumWeyl_realization_parametersShiftInvariant
    {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site) (hCommute : ShiftsCommute shift)
    (x y : Site -> Real)
    (hRealized : HasPeriodicAdditiveLinkRealization shift
      (siteDecoratedDiagonalVacuumWeyl x y)) :
    forall site direction,
      x (shift direction site) = x site /\
        y (shift direction site) = y site := by
  intro site direction
  fin_cases direction
  · constructor
    · have hBianchi := periodicAdditiveLinkRealization_bianchi
        shift hCommute (siteDecoratedDiagonalVacuumWeyl x y)
        hRealized site 0 2 3 2
      simp +decide [siteDecoratedDiagonalVacuumWeyl,
        diagonalVacuumWeylCurvature,
        diagonalVacuumWeylCoordinates] at hBianchi
      change x (shift 0 site) = x site
      exact sub_eq_zero.mp hBianchi
    · have hBianchi := periodicAdditiveLinkRealization_bianchi
        shift hCommute (siteDecoratedDiagonalVacuumWeyl x y)
        hRealized site 0 1 3 1
      simp +decide [siteDecoratedDiagonalVacuumWeyl,
        diagonalVacuumWeylCurvature,
        diagonalVacuumWeylCoordinates] at hBianchi
      change y (shift 0 site) = y site
      exact sub_eq_zero.mp hBianchi
  · constructor
    · have hBianchi := periodicAdditiveLinkRealization_bianchi
        shift hCommute (siteDecoratedDiagonalVacuumWeyl x y)
        hRealized site 1 2 3 2
      simp +decide [siteDecoratedDiagonalVacuumWeyl,
        diagonalVacuumWeylCurvature,
        diagonalVacuumWeylCoordinates] at hBianchi
      change x (shift 1 site) = x site
      exact sub_eq_zero.mp hBianchi
    · have hBianchi := periodicAdditiveLinkRealization_bianchi
        shift hCommute (siteDecoratedDiagonalVacuumWeyl x y)
        hRealized site 1 0 2 4
      simp +decide [siteDecoratedDiagonalVacuumWeyl,
        diagonalVacuumWeylCurvature,
        diagonalVacuumWeylCoordinates] at hBianchi
      change y (shift 1 site) = y site
      exact sub_eq_zero.mp hBianchi
  · constructor
    · have hBianchi := periodicAdditiveLinkRealization_bianchi
        shift hCommute (siteDecoratedDiagonalVacuumWeyl x y)
        hRealized site 2 0 1 3
      simp +decide [siteDecoratedDiagonalVacuumWeyl,
        diagonalVacuumWeylCurvature,
        diagonalVacuumWeylCoordinates] at hBianchi
      change x (shift 2 site) = x site
      exact sub_eq_zero.mp hBianchi
    · have hBianchi := periodicAdditiveLinkRealization_bianchi
        shift hCommute (siteDecoratedDiagonalVacuumWeyl x y)
        hRealized site 2 1 3 1
      simp +decide [siteDecoratedDiagonalVacuumWeyl,
        diagonalVacuumWeylCurvature,
        diagonalVacuumWeylCoordinates] at hBianchi
      change y (shift 2 site) = y site
      exact sub_eq_zero.mp hBianchi
  · constructor
    · have hBianchi := periodicAdditiveLinkRealization_bianchi
        shift hCommute (siteDecoratedDiagonalVacuumWeyl x y)
        hRealized site 3 0 1 3
      simp +decide [siteDecoratedDiagonalVacuumWeyl,
        diagonalVacuumWeylCurvature,
        diagonalVacuumWeylCoordinates] at hBianchi
      change x (shift 3 site) = x site
      exact sub_eq_zero.mp hBianchi
    · have hBianchi := periodicAdditiveLinkRealization_bianchi
        shift hCommute (siteDecoratedDiagonalVacuumWeyl x y)
        hRealized site 3 0 2 4
      simp +decide [siteDecoratedDiagonalVacuumWeyl,
        diagonalVacuumWeylCurvature,
        diagonalVacuumWeylCoordinates] at hBianchi
      change y (shift 3 site) = y site
      exact sub_eq_zero.mp hBianchi

/-- The simplest site decoration of the unit Weyl tensor: replace its unit
amplitude by one real scalar at each site while retaining the same diagonal
algebraic curvature shape. -/
def scalarDecoratedUnitVacuumWeyl
    {Site : Type*} (amplitude : Site -> Real) :
    Site -> Fin 4 -> Fin 4 -> Fiber 6 :=
  siteDecoratedDiagonalVacuumWeyl amplitude (fun _ => 0)

/-- Every site of the scalar-decorated field still satisfies the local mixed
vacuum Einstein equation. -/
theorem scalarDecoratedUnitVacuumWeyl_mixedVacuum
    {Site : Type*} (amplitude : Site -> Real)
    (site : Site) (coframeDirection raisedDirection : Fin 4) :
    mixedVacuumEinsteinEntry
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (scalarDecoratedUnitVacuumWeyl amplitude site)
        coframeDirection raisedDirection = 0 :=
  diagonalVacuumWeylCurvature_mixedVacuum
    (amplitude site) 0 coframeDirection raisedDirection

/-- Discrete Bianchi forces a periodically realized common Weyl amplitude to
be invariant under every carrier shift.  Thus a checkerboard sign cannot be
the additive curl of globally periodic link data, even though it has zero
mean and is pointwise Ricci-flat. -/
theorem scalarDecoratedUnitVacuumWeyl_realization_shiftInvariant
    {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site) (hCommute : ShiftsCommute shift)
    (amplitude : Site -> Real)
    (hRealized : HasPeriodicAdditiveLinkRealization shift
      (scalarDecoratedUnitVacuumWeyl amplitude)) :
    forall site direction,
      amplitude (shift direction site) = amplitude site := by
  have hParameters :=
    siteDecoratedDiagonalVacuumWeyl_realization_parametersShiftInvariant
      shift hCommute amplitude (fun _ => 0) hRealized
  exact fun site direction => (hParameters site direction).1

/-- Alternating unit amplitudes on the two horizontal columns of the minimal
periodic square. -/
def squareWeylCheckerboardAmplitude (site : SquareSite) : Real :=
  if site.1 = 0 then 1 else -1

/-- The square checkerboard clears the componentwise mean obstruction. -/
theorem squareWeylCheckerboardAmplitude_sum_zero :
    Finset.sum Finset.univ squareWeylCheckerboardAmplitude = 0 := by
  norm_num [squareWeylCheckerboardAmplitude, Fintype.sum_prod_type,
    Fin.sum_univ_two]

/-- Nevertheless the pointwise vacuum-Weyl checkerboard is not a periodic
additive link curvature: it flips under the horizontal shift, while discrete
Bianchi would force a common Weyl amplitude to be shift invariant. -/
theorem squareWeylCheckerboard_not_periodicAdditive :
    Not (HasPeriodicAdditiveLinkRealization squareShift
      (scalarDecoratedUnitVacuumWeyl squareWeylCheckerboardAmplitude)) := by
  intro hRealized
  have hInvariant :=
    scalarDecoratedUnitVacuumWeyl_realization_shiftInvariant
      squareShift squareShift_commute squareWeylCheckerboardAmplitude
      hRealized ((0, 0) : SquareSite) 0
  norm_num [squareWeylCheckerboardAmplitude, squareShift,
    horizontalShift, toggleFinTwo] at hInvariant

/-- The concrete nonzero unit vacuum-Weyl tensor cannot be the same additive
plaquette curl at every site of a nonempty finite periodic carrier. -/
theorem unitVacuumWeylTarget_not_siteIndependent_periodicAdditive
    {Site : Type*} [Finite Site] [Nonempty Site]
    (shift : Fin 4 -> Equiv Site Site) :
    Not (HasPeriodicAdditiveLinkRealization shift
      (fun _ => unitVacuumWeylTarget.curvature)) := by
  intro hRealized
  exact unitVacuumWeylTarget.nonzero
    (siteIndependent_periodicAdditiveLinkRealization_eq_zero
      shift unitVacuumWeylTarget.curvature hRealized)

/-- The unit vacuum-Weyl tensor also cannot arise as a site-independent
componentwise limit of periodic additive curls on one fixed carrier. -/
theorem unitVacuumWeylTarget_not_fixedCarrier_periodicAdditiveLimit
    {Site : Type*} [Fintype Site] [Nonempty Site]
    (shift : Fin 4 -> Equiv Site Site) :
    Not (HasFixedCarrierPeriodicAdditiveLimit shift
      unitVacuumWeylTarget.curvature) := by
  intro hLimit
  exact unitVacuumWeylTarget.nonzero
    (fixedCarrier_periodicAdditiveLimit_eq_zero
      shift unitVacuumWeylTarget.curvature hLimit)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylMeanObstruction.sum_additivePlaquetteCurl_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sum_additivePlaquetteCurl_eq_zero

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylMeanObstruction.unitVacuumWeylTarget_not_siteIndependent_periodicAdditive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms unitVacuumWeylTarget_not_siteIndependent_periodicAdditive

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylMeanObstruction.unitVacuumWeylTarget_not_fixedCarrier_periodicAdditiveLimit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms unitVacuumWeylTarget_not_fixedCarrier_periodicAdditiveLimit

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylMeanObstruction.siteDecoratedDiagonalVacuumWeyl_realization_parametersShiftInvariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms siteDecoratedDiagonalVacuumWeyl_realization_parametersShiftInvariant

/-- info: 'PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylMeanObstruction.squareWeylCheckerboard_not_periodicAdditive' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms squareWeylCheckerboard_not_periodicAdditive

end PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylMeanObstruction
