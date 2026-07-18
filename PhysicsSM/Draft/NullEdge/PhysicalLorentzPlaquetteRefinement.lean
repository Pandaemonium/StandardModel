import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniVaryingCoframeLimit
import Mathlib.Analysis.Calculus.Deriv.Slope

noncomputable section

open scoped Matrix.Norms.Frobenius

/-!
# Physical Lorentz plaquette refinement

The action-visible Einstein-limit interface accepts invertible real link
matrices.  This module constructs a nonflat refinement whose links satisfy the
stronger physical predicates used by the project: every link preserves the
mostly-minus metric and has determinant `+1`.

The construction has two layers.  First, for any six-component Lorentz
curvature `F`, the exact group element `exp(A_n hat(F))` is proved to have the
first-order action-visible limit `F`.  Second, a `2 x 2` periodic square uses
identity horizontal links and a vertical exponential link on one column.
The two horizontal columns then have exact plaquette holonomies
`exp(+A_n hat(F))` and `exp(-A_n hat(F))`.  All other ordered plaquettes are
flat.  No Baker-Campbell-Hausdorff truncation is used.

This supplies a genuine nonzero proper eta-Lorentz refinement witness, not a
derivation of refinement from a bare graph.  It also does not prove
stationarity of the witness or identify its target with Levi-Civita Riemann
curvature.  Claim labels: finite identity and conditional asymptotic theorem.
The matrix-exponential derivative is standard `[import]`; the periodic square
realization and its composition with the action-visible interface are
`[orig/comp]`.
-/

namespace PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement

open Filter Topology
open NormedSpace
open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.CurvatureConvergenceInterface
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniVaryingCoframeLimit

abbrev Matrix4R := Matrix (Fin 4) (Fin 4) Real

/-! ## Exact exponential first-order limit -/

/-- Exact proper-Lorentz exponential holonomy at one refinement level. -/
def exponentialHolonomy
    (area : Nat -> Real) (target : Fiber 6) (n : Nat) : GL4 :=
  matrixExponentialUnit (area n • lorentzGenerator target)

/-- Normalized matrix remainder after subtracting the Lorentz generator. -/
def exponentialResidual
    (area : Nat -> Real) (target : Fiber 6) (n : Nat) : Matrix4R :=
  (area n)⁻¹ •
      (NormedSpace.exp (area n • lorentzGenerator target) - 1) -
    lorentzGenerator target

/-- The exponential is exactly identity plus area times generator and the
normalized remainder whenever the area is nonzero. -/
theorem exponentialHolonomy_expansion
    (area : Nat -> Real) (target : Fiber 6) (n : Nat)
    (hArea : area n ≠ 0) :
    unitMatrix (exponentialHolonomy area target n) =
      1 + area n •
        (lorentzGenerator target + exponentialResidual area target n) := by
  rw [exponentialHolonomy, unitMatrix_matrixExponentialUnit]
  unfold exponentialResidual
  rw [show lorentzGenerator target +
      ((area n)⁻¹ •
          (NormedSpace.exp (area n • lorentzGenerator target) - 1) -
        lorentzGenerator target) =
      (area n)⁻¹ •
        (NormedSpace.exp (area n • lorentzGenerator target) - 1) by abel]
  rw [smul_smul]
  simp [hArea]

/-- The normalized exponential remainder tends to zero for every shrinking,
eventually nonzero area sequence. -/
theorem exponentialResidual_tendsto_zero
    (area : Nat -> Real) (target : Fiber 6)
    (hAreaNe : ∀ᶠ n in atTop, area n ≠ 0)
    (hAreaZero : Tendsto area atTop (nhds 0)) :
    Tendsto (exponentialResidual area target) atTop (nhds 0) := by
  let generator := lorentzGenerator target
  have hDerivative : HasDerivAt
      (fun t : Real => NormedSpace.exp (t • generator)) generator 0 := by
    simpa [generator] using
      hasDerivAt_exp_smul_const (𝕂 := Real) generator 0
  have hAreaWithin : Tendsto area atTop (nhdsWithin 0 ({0} : Set Real)ᶜ) :=
    tendsto_nhdsWithin_of_tendsto_nhds_of_eventually_within area hAreaZero
      (hAreaNe.mono fun n hn => by simpa using hn)
  have hQuotient : Tendsto
      (fun n => (area n)⁻¹ •
        (NormedSpace.exp (area n • generator) - 1))
      atTop (nhds generator) := by
    simpa using hDerivative.tendsto_slope_zero.comp hAreaWithin
  have hRemainder := hQuotient.sub_const generator
  simpa [exponentialResidual, generator] using hRemainder

/-- Every exact exponential link in the family is proper eta-Lorentz. -/
theorem exponentialHolonomy_isProperEtaLorentz
    (area : Nat -> Real) (target : Fiber 6) (n : Nat) :
    IsEtaLorentz (unitMatrix (exponentialHolonomy area target n)) ∧
      IsProperLorentz (unitMatrix (exponentialHolonomy area target n)) := by
  exact matrixExponentialUnit_isProperEtaLorentz target (area n)

/-- Proper eta-Lorentz exponentials instantiate the exact action-visible
first-order holonomy interface for an arbitrary target curvature. -/
def exponentialActionVisibleFirstOrderHolonomyLimit
    (area : Nat -> Real) (target : Fiber 6)
    (hAreaNe : ∀ᶠ n in atTop, area n ≠ 0)
    (hAreaZero : Tendsto area atTop (nhds 0)) :
    ActionVisibleFirstOrderHolonomyLimit area
      (exponentialHolonomy area target) target where
  residual := exponentialResidual area target
  area_ne_zero := hAreaNe
  area_tendsto_zero := hAreaZero
  expansion := hAreaNe.mono fun n hn =>
    exponentialHolonomy_expansion area target n hn
  residual_tendsto_zero :=
    exponentialResidual_tendsto_zero area target hAreaNe hAreaZero

/-- The exponential unit at zero generator is the identity. -/
@[simp]
theorem exponentialHolonomy_zero
    (area : Nat -> Real) (n : Nat) :
    exponentialHolonomy area 0 n = 1 := by
  apply Units.ext
  change unitMatrix (exponentialHolonomy area 0 n) = unitMatrix (1 : GL4)
  rw [exponentialHolonomy, unitMatrix_matrixExponentialUnit, unitMatrix_one]
  have hGenerator : lorentzGenerator (0 : Fiber 6) = 0 := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [lorentzGenerator, bivectorMatrix, Matrix.mul_apply,
        MinkowskiConvention.eta, Fin.sum_univ_four]
  rw [hGenerator]
  simp

/-- The Lorentz generator is odd in its six-component coordinate. -/
theorem lorentzGenerator_neg (target : Fiber 6) :
    lorentzGenerator (-target) = -lorentzGenerator target := by
  ext i j
  fin_cases i <;> fin_cases j <;>
    simp [lorentzGenerator, bivectorMatrix, Matrix.mul_apply,
      MinkowskiConvention.eta, Fin.sum_univ_four]

/-- Negating the target inverts the exact exponential holonomy. -/
@[simp]
theorem exponentialHolonomy_neg
    (area : Nat -> Real) (target : Fiber 6) (n : Nat) :
    exponentialHolonomy area (-target) n =
      (exponentialHolonomy area target n)⁻¹ := by
  let generator := area n • lorentzGenerator target
  have hCancel :
      exponentialHolonomy area (-target) n *
          exponentialHolonomy area target n = 1 := by
    apply Units.ext
    change unitMatrix
        (exponentialHolonomy area (-target) n *
          exponentialHolonomy area target n) = unitMatrix (1 : GL4)
    rw [unitMatrix_mul, exponentialHolonomy, exponentialHolonomy,
      unitMatrix_matrixExponentialUnit,
      unitMatrix_matrixExponentialUnit, unitMatrix_one]
    have hNeg : area n • lorentzGenerator (-target) = -generator := by
      simp [generator, lorentzGenerator_neg]
    rw [hNeg]
    simpa using
      (Matrix.exp_add_of_commute (-generator) generator
        (Commute.refl generator).neg_left).symm
  calc
    exponentialHolonomy area (-target) n =
        (exponentialHolonomy area (-target) n *
            exponentialHolonomy area target n) *
          (exponentialHolonomy area target n)⁻¹ := by simp
    _ = (exponentialHolonomy area target n)⁻¹ := by rw [hCancel]; simp

/-! ## A physical periodic-square connection -/

/-- Four vertices of a minimal periodic square. -/
abbrev SquareSite := Fin 2 × Fin 2

/-- Toggle the two points of one periodic coordinate. -/
def toggleFinTwo : Equiv (Fin 2) (Fin 2) := Equiv.swap 0 1

/-- Horizontal periodic translation. -/
def horizontalShift : Equiv SquareSite SquareSite :=
  Equiv.prodCongr toggleFinTwo (Equiv.refl _)

/-- Vertical periodic translation. -/
def verticalShift : Equiv SquareSite SquareSite :=
  Equiv.prodCongr (Equiv.refl _) toggleFinTwo

/-- Four commuting chart shifts; the last two directions are inactive. -/
def squareShift : Fin 4 -> Equiv SquareSite SquareSite :=
  ![horizontalShift, verticalShift, Equiv.refl _, Equiv.refl _]

/-- The four displayed periodic-square shifts commute. -/
theorem squareShift_commute : ShiftsCommute squareShift := by
  intro site a b
  rcases site with ⟨x, y⟩
  fin_cases x <;> fin_cases y <;> fin_cases a <;> fin_cases b <;>
    simp [squareShift, horizontalShift, verticalShift, toggleFinTwo]

/-- A column-dependent physical link field.  Horizontal and inactive links
are identities.  The vertical link on column one is `exp(area * hat(F))`. -/
def squareLorentzConnection
    (area : Nat -> Real) (target : Fiber 6) (n : Nat) :
    LinkConnection SquareSite GL4 :=
  fun site direction =>
    if direction = 1 ∧ site.1 = 1 then exponentialHolonomy area target n
    else 1

/-- The oriented target field: `+F` and `-F` on the two horizontal columns,
with the reverse plaquette orientation carrying the opposite sign. -/
def squareCurvatureTarget (target : Fiber 6) : FaceWeight SquareSite 6 :=
  fun site a b =>
    if a = 0 ∧ b = 1 then
      if site.1 = 0 then target else -target
    else if a = 1 ∧ b = 0 then
      if site.1 = 0 then -target else target
    else 0

/-- The displayed target is antisymmetric in its ordered plaquette
directions. -/
theorem squareCurvatureTarget_antisymmetric (target : Fiber 6) :
    IsAntisymmetricFaceWeight (squareCurvatureTarget target) := by
  intro site a b component
  rcases site with ⟨x, y⟩
  fin_cases x <;> fin_cases y <;> fin_cases a <;> fin_cases b <;>
    simp [squareCurvatureTarget]

/-- Every link of the periodic-square connection is proper eta-Lorentz. -/
theorem squareLorentzConnection_isProperEtaLorentz
    (area : Nat -> Real) (target : Fiber 6) (n : Nat)
    (site : SquareSite) (direction : Fin 4) :
    IsEtaLorentz
        (unitMatrix (squareLorentzConnection area target n site direction)) ∧
      IsProperLorentz
        (unitMatrix (squareLorentzConnection area target n site direction)) := by
  unfold squareLorentzConnection
  split
  · exact exponentialHolonomy_isProperEtaLorentz area target n
  · constructor
    · simp [IsEtaLorentz]
    · simp [IsProperLorentz]

/-- Every ordered square plaquette is exactly the exponential of its signed
target curvature. -/
theorem squarePlaquetteHolonomy_eq_exponential
    (area : Nat -> Real) (target : Fiber 6) (n : Nat)
    (site : SquareSite) (a b : Fin 4) :
    plaquetteUnit squareShift (squareLorentzConnection area target n)
        site a b =
      exponentialHolonomy area (squareCurvatureTarget target site a b) n := by
  rcases site with ⟨x, y⟩
  fin_cases x <;> fin_cases y <;> fin_cases a <;> fin_cases b <;>
    simp [plaquetteUnit, plaquetteHolonomy, twoStepTransport,
      squareLorentzConnection, squareShift, horizontalShift, verticalShift,
      toggleFinTwo, squareCurvatureTarget, mul_assoc]

/-! ## Physical refinement packet and Einstein specialization -/

/-- An action-visible plaquette refinement whose underlying links are all
proper eta-Lorentz matrices. -/
structure PhysicalActionVisiblePlaquetteRefinement
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (connection : Nat -> LinkConnection Site GL4)
    (area : Nat -> Real) (target : FaceWeight Site 6)
    extends ActionVisiblePlaquetteRefinement shift connection area target where
  /-- The periodic chart shifts commute. -/
  shifts_commute : ShiftsCommute shift
  /-- Every finite link preserves the mostly-minus metric. -/
  link_eta : forall n site direction,
    IsEtaLorentz (unitMatrix (connection n site direction))
  /-- Every finite link has determinant `+1`. -/
  link_proper : forall n site direction,
    IsProperLorentz (unitMatrix (connection n site direction))

/-- The periodic-square connection gives a proper eta-Lorentz
action-visible refinement for any shrinking, eventually nonzero area scale. -/
def physicalSquarePlaquetteRefinement
    (area : Nat -> Real) (target : Fiber 6)
    (hAreaNe : ∀ᶠ n in atTop, area n ≠ 0)
    (hAreaZero : Tendsto area atTop (nhds 0)) :
    PhysicalActionVisiblePlaquetteRefinement squareShift
      (squareLorentzConnection area target) area
      (squareCurvatureTarget target) where
  shifts_commute := squareShift_commute
  firstOrder := by
    intro site a b
    simpa only [squarePlaquetteHolonomy_eq_exponential] using
      exponentialActionVisibleFirstOrderHolonomyLimit area
        (squareCurvatureTarget target site a b) hAreaNe hAreaZero
  target_antisymmetric := squareCurvatureTarget_antisymmetric target
  link_eta := fun n site direction =>
    (squareLorentzConnection_isProperEtaLorentz
      area target n site direction).1
  link_proper := fun n site direction =>
    (squareLorentzConnection_isProperEtaLorentz
      area target n site direction).2

/-- A nonzero six-component input gives a genuinely nonzero periodic-square
curvature target field. -/
theorem squareCurvatureTarget_ne_zero
    (target : Fiber 6) (hTarget : target ≠ 0) :
    squareCurvatureTarget target ≠ 0 := by
  intro hField
  have hFace := congrFun
    (congrFun (congrFun hField ((0, 0) : SquareSite)) 0) 1
  apply hTarget
  simpa [squareCurvatureTarget] using hFace

/-- **Nonflat physical refinement witness.**  Every nonzero Lorentz curvature
coordinate gives a nonzero target field carried by exact proper eta-Lorentz
links and genuine periodic plaquette holonomies. -/
theorem nonzero_physicalSquarePlaquetteRefinement
    (target : Fiber 6) (hTarget : target ≠ 0) :
    squareCurvatureTarget target ≠ 0 ∧
      Nonempty (PhysicalActionVisiblePlaquetteRefinement squareShift
        (squareLorentzConnection witnessArea target) witnessArea
        (squareCurvatureTarget target)) := by
  refine ⟨squareCurvatureTarget_ne_zero target hTarget, ⟨?_⟩⟩
  exact physicalSquarePlaquetteRefinement witnessArea target
    witnessFirstOrderHolonomyLimit.area_ne_zero
    witnessFirstOrderHolonomyLimit.area_tendsto_zero

/-- The varying-coframe Einstein endpoint remains valid with the stronger
physical-link refinement hypothesis. -/
theorem coframeStationary_physicalVaryingRefinementLimit
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connection : Nat -> LinkConnection Site GL4)
    (area : Nat -> Real) (target : FaceWeight Site 6)
    (hPlaquette : PhysicalActionVisiblePlaquetteRefinement
      shift connection area target)
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
          coframeDirection raisedDirection = 0 :=
  coframeStationary_varyingRefinementLimit shift connection area target
    hPlaquette.toActionVisiblePlaquetteRefinement coframe inverseCoframe
      targetCoframe targetInverseCoframe hCoframe hStationary

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement.exponentialActionVisibleFirstOrderHolonomyLimit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms exponentialActionVisibleFirstOrderHolonomyLimit

/-- info: 'PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement.physicalSquarePlaquetteRefinement' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physicalSquarePlaquetteRefinement

/-- info: 'PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement.nonzero_physicalSquarePlaquetteRefinement' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonzero_physicalSquarePlaquetteRefinement

/-- info: 'PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement.coframeStationary_physicalVaryingRefinementLimit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms coframeStationary_physicalVaryingRefinementLimit

end PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement
