import PhysicsSM.Draft.NullEdge.VacuumWeylCurvatureTarget

noncomputable section

/-!
# Periodic vacuum-Weyl refinement: conformal-square no-go and escape class

This file audits the smallest varying-coframe enlargement of the live physical
`2 × 2` periodic square: the connection is unchanged and the identity coframe
is replaced, at each refinement level, by one nonzero global conformal scale.
The scale is allowed to vary with the refinement level, but not with the site
or internal/direction indices.

The two exact Euler responses are homogeneous with different degrees in that
scale: the link response is quadratic and the coframe response is linear.
Consequently a nonzero global scale cannot cancel either Euler sector.  The
existing static-square obstruction therefore extends to every such varying
conformal refinement.

Independently, the concrete unit vacuum-Weyl seed has nonzero diagonal entries
on four unordered face planes (`12`, `23`, `01`, and `03`).  Thus a one-face
square cannot realize that target even before stationarity is imposed.  The
smallest convention-faithful escape class must therefore activate at least
those four face planes and must leave the global-conformal coframe class.
No existence or Levi-Civita/torsion-free selection claim is made here.
-/

namespace PhysicsSM.Draft.NullEdge.VacuumWeylPeriodicRefinementAristotle

open Filter Topology
open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.ProperLorentzExponential
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniVaryingCoframeLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteEinsteinAudit
open PhysicsSM.Draft.NullEdge.VacuumWeylCurvatureTarget

/-- A site-independent conformal multiple of the convention-locked identity
coframe. -/
def globalConformalCoframe (Site : Type*) (scale : Real) : CoframeField Site :=
  fun _ => scale • (1 : Matrix (Fin 4) (Fin 4) Real)

/-- Its explicit inverse coframe. -/
def globalConformalInverseCoframe (Site : Type*) (scale : Real) :
    CoframeField Site :=
  fun _ => scale⁻¹ • (1 : Matrix (Fin 4) (Fin 4) Real)

/-- Every nonzero global conformal coframe has the displayed exact left
inverse. -/
theorem globalConformalCoframe_leftInverse
    (Site : Type*) {scale : Real} (hScale : scale ≠ 0) (site : Site) :
    globalConformalInverseCoframe Site scale site *
        globalConformalCoframe Site scale site = 1 := by
  simp [globalConformalInverseCoframe, globalConformalCoframe, hScale]

set_option maxHeartbeats 3000000 in
/-- The complementary Palatini face is quadratic under scalar coframe
rescaling. -/
theorem complementaryPalatiniFaceWeight_scale_identity
    (scale : Real) (a b : Fin 4) :
    LorentzCoframePalatiniFace.complementaryPalatiniFaceWeight
        (scale • (1 : Matrix (Fin 4) (Fin 4) Real)) a b =
      scale ^ 2 •
        LorentzCoframePalatiniFace.complementaryPalatiniFaceWeight
          (1 : Matrix (Fin 4) (Fin 4) Real) a b := by
  funext component
  fin_cases a <;> fin_cases b <;> fin_cases component <;>
    simp +decide [LorentzCoframePalatiniFace.complementaryPalatiniFaceWeight,
      LorentzCoframePalatiniFace.palatiniFaceWeight,
      LorentzCoframePalatiniFace.coframeWedge,
      transportApply,
      LorentzCoframePalatiniFace.lorentzHodgeStar,
      Fin.sum_univ_four, Fin.sum_univ_six] <;> ring

/-- Exact degree-two homogeneity of the complete link response under a global
conformal coframe rescaling. -/
theorem nonlinearLinkResponse_globalConformal
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (scale : Real)
    (variation : LinkVariation Site) :
    nonlinearCoframePlaquetteFirstResponse shift connection
        (globalConformalCoframe Site scale) variation =
      scale ^ 2 * nonlinearCoframePlaquetteFirstResponse shift connection
        (identityCoframeField Site) variation := by
  unfold nonlinearCoframePlaquetteFirstResponse
  unfold coframeFaceWeight globalConformalCoframe identityCoframeField
  simp_rw [complementaryPalatiniFaceWeight_scale_identity]
  simp [orderedPlaquetteActionFirstResponse,
    lorentzGenerator_smul, Matrix.trace_smul, Finset.mul_sum]
  ring

/-- The polarized wedge is symmetric in its two coframe arguments. -/
theorem coframeWedgeFirstVariation_comm
    (left right : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    coframeWedgeFirstVariation left right a b =
      coframeWedgeFirstVariation right left a b := by
  funext component
  simp [coframeWedgeFirstVariation]
  ring

/-- Polarization is symmetric in its two coframe arguments. -/
theorem complementaryPalatiniFaceWeightFirstVariation_comm
    (left right : Matrix (Fin 4) (Fin 4) Real) (a b : Fin 4) :
    complementaryPalatiniFaceWeightFirstVariation left right a b =
      complementaryPalatiniFaceWeightFirstVariation right left a b := by
  funext component
  unfold complementaryPalatiniFaceWeightFirstVariation
    palatiniFaceWeightFirstVariation
  simp_rw [coframeWedgeFirstVariation_comm left right]

/-- The polarized complementary face is linear in its base coframe when the
base is a scalar identity. -/
theorem complementaryPalatiniFaceWeightFirstVariation_scale_identity
    (scale : Real) (variation : Matrix (Fin 4) (Fin 4) Real)
    (a b : Fin 4) :
    complementaryPalatiniFaceWeightFirstVariation (scale • 1) variation a b =
      scale • complementaryPalatiniFaceWeightFirstVariation 1 variation a b := by
  rw [complementaryPalatiniFaceWeightFirstVariation_comm]
  rw [complementaryPalatiniFaceWeightFirstVariation_smul]
  rw [complementaryPalatiniFaceWeightFirstVariation_comm]

/-- Exact degree-one homogeneity of the complete coframe response under a
global conformal rescaling of its base coframe. -/
theorem nonlinearCoframeResponse_globalConformal
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) (scale : Real)
    (variation : CoframeField Site) :
    nonlinearCoframePlaquetteCoframeFirstResponse shift connection
        (globalConformalCoframe Site scale) variation =
      scale * nonlinearCoframePlaquetteCoframeFirstResponse shift connection
        (identityCoframeField Site) variation := by
  unfold nonlinearCoframePlaquetteCoframeFirstResponse
    coframeFaceWeightFirstVariation nonlinearFacePlaquetteAction
    globalConformalCoframe identityCoframeField
  simp_rw [complementaryPalatiniFaceWeightFirstVariation_scale_identity]
  simp [orderedPlaquetteActionTerm_smul_face, Finset.mul_sum]

/-- A nonzero global conformal factor does not change the six-component link
Euler solution set. -/
theorem connectionStationary_globalConformal_iff
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) {scale : Real}
    (hScale : scale ≠ 0) :
    NonlinearCoframePlaquetteConnectionStationary shift connection
        (globalConformalCoframe Site scale) ↔
      NonlinearCoframePlaquetteConnectionStationary shift connection
        (identityCoframeField Site) := by
  constructor <;> intro h variation
  · have hv := h variation
    rw [nonlinearLinkResponse_globalConformal] at hv
    exact (mul_eq_zero.mp hv).resolve_left (pow_ne_zero 2 hScale)
  · rw [nonlinearLinkResponse_globalConformal]
    rw [h variation, mul_zero]

/-- A nonzero global conformal factor does not change the sixteen-component
coframe Euler solution set. -/
theorem coframeStationary_globalConformal_iff
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) {scale : Real}
    (hScale : scale ≠ 0) :
    NonlinearCoframePlaquetteCoframeStationary shift connection
        (globalConformalCoframe Site scale) ↔
      NonlinearCoframePlaquetteCoframeStationary shift connection
        (identityCoframeField Site) := by
  constructor <;> intro h variation
  · have hv := h variation
    rw [nonlinearCoframeResponse_globalConformal] at hv
    exact (mul_eq_zero.mp hv).resolve_left hScale
  · rw [nonlinearCoframeResponse_globalConformal]
    rw [h variation, mul_zero]

/-- Hence global conformal variation cannot alter either part of the exact
`6 + 16` joint Euler system. -/
theorem jointStationary_globalConformal_iff
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : LinkConnection Site GL4) {scale : Real}
    (hScale : scale ≠ 0) :
    NonlinearCoframePlaquetteJointStationary shift connection
        (globalConformalCoframe Site scale) ↔
      NonlinearCoframePlaquetteJointStationary shift connection
        (identityCoframeField Site) := by
  exact and_congr
    (connectionStationary_globalConformal_iff shift connection hScale)
    (coframeStationary_globalConformal_iff shift connection hScale)

/-- **Varying-conformal-square no-go.**  At every level the coframe may have a
different nonzero global scale (and therefore an exact inverse), but no
nonzero square target can be jointly stationary along an eventually nonzero
shrinking-area refinement. -/
theorem nonzero_squareTarget_not_jointStationary_globalConformalCoframe
    (area scale : Nat -> Real) (target : Fiber 6)
    (hTarget : target ≠ 0)
    (hScale : forall n, scale n ≠ 0)
    (hAreaNe : ∀ᶠ n in atTop, area n ≠ 0)
    (hAreaZero : Tendsto area atTop (nhds 0)) :
    Not (forall n,
      NonlinearCoframePlaquetteJointStationary squareShift
        (squareLorentzConnection area target n)
        (globalConformalCoframe SquareSite (scale n))) := by
  intro hJoint
  apply nonzero_squareTarget_not_jointStationary_identityCoframe
    area target hTarget hAreaNe hAreaZero
  intro n
  exact (jointStationary_globalConformal_iff squareShift
    (squareLorentzConnection area target n) (hScale n)).mp (hJoint n)

/-- Predicate saying that a curvature field vanishes away from one unordered
spacetime face pair. -/
def SupportedOnOneFace
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) (p q : Fin 4) : Prop :=
  forall a b, (a ≠ p ∨ b ≠ q) -> (a ≠ q ∨ b ≠ p) -> curvature a b = 0

/-- The concrete unit vacuum-Weyl curvature is not supported on any single
unordered face pair.  This is a face-support obstruction, independent of the
Euler equations. -/
theorem unitVacuumWeylTarget_not_supportedOnOneFace (p q : Fin 4) :
    Not (SupportedOnOneFace unitVacuumWeylTarget.curvature p q) := by
  intro h
  by_cases hpq : (p = 0 ∧ q = 1) ∨ (p = 1 ∧ q = 0)
  · rcases hpq with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
    all_goals
      have hz := h 0 3 (by simp) (by simp)
      have hc := congrFun hz 5
      simp +decide [unitVacuumWeylTarget, diagonalVacuumWeylPackage,
        diagonalVacuumWeylCurvature, diagonalVacuumWeylCoordinates] at hc
  · have hforward : 0 ≠ p ∨ 1 ≠ q := by
      by_contra hn
      push_neg at hn
      exact hpq (Or.inl ⟨hn.1.symm, hn.2.symm⟩)
    have hreverse : 0 ≠ q ∨ 1 ≠ p := by
      by_contra hn
      push_neg at hn
      exact hpq (Or.inr ⟨hn.2.symm, hn.1.symm⟩)
    have hz := h 0 1 hforward hreverse
    have hc := congrFun hz 3
    simp +decide [unitVacuumWeylTarget, diagonalVacuumWeylPackage,
      diagonalVacuumWeylCurvature, diagonalVacuumWeylCoordinates] at hc

/-- Exact definition of the minimal escape class identified by the two
obstructions proved above.  It does not assert that this class is inhabited by
a jointly stationary refinement. -/
structure FourFaceNonconformalEscapeData (Site : Type*) [Fintype Site] where
  shift : Fin 4 -> Equiv Site Site
  shifts_commute : ShiftsCommute shift
  connection : Nat -> LinkConnection Site GL4
  coframe : Nat -> CoframeField Site
  inverseCoframe : Nat -> CoframeField Site
  area : Nat -> Real
  exact_left_inverse : forall n site,
    inverseCoframe n site * coframe n site = 1
  link_eta : forall n site direction,
    IsEtaLorentz (unitMatrix (connection n site direction))
  link_proper : forall n site direction,
    IsProperLorentz (unitMatrix (connection n site direction))
  area_ne_zero : ∀ᶠ n in atTop, area n ≠ 0
  area_tendsto_zero : Tendsto area atTop (nhds 0)
  target_relation : FaceWeight Site 6
  target_nonzero : target_relation ≠ 0
  target_antisymmetric : IsAntisymmetricFaceWeight target_relation
  first_order : forall site a b,
    ActionVisibleFirstOrderHolonomyLimit area
      (fun n => plaquetteUnit shift (connection n) site a b)
      (target_relation site a b)
  coframe_limit : CoframeRefinementLimit coframe inverseCoframe
    (identityCoframeField Site) (identityCoframeField Site)
  joint_stationary : forall n,
    NonlinearCoframePlaquetteJointStationary shift (connection n) (coframe n)
  target_has_unitWeyl_site : exists site,
    target_relation site = unitVacuumWeylTarget.curvature
  nonconformal : Not (exists scale : Nat -> Real, forall n,
    coframe n = globalConformalCoframe Site (scale n))

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.VacuumWeylPeriodicRefinementAristotle.nonzero_squareTarget_not_jointStationary_globalConformalCoframe' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonzero_squareTarget_not_jointStationary_globalConformalCoframe

/-- info: 'PhysicsSM.Draft.NullEdge.VacuumWeylPeriodicRefinementAristotle.unitVacuumWeylTarget_not_supportedOnOneFace' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms unitVacuumWeylTarget_not_supportedOnOneFace

end PhysicsSM.Draft.NullEdge.VacuumWeylPeriodicRefinementAristotle
