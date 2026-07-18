import PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement

noncomputable section

/-!
# Einstein and stationarity audit of the physical square refinement

This module tests the exact proper eta-Lorentz periodic-square refinement
against both Euler sectors of the nonlinear Palatini action.

At the identity coframe, the mixed vacuum Einstein equation kills five of the
six coordinates of the one-face curvature target.  It leaves only the
internal `23` rotation on the spacetime `01` plaquette.  That surviving mode is
not a Levi-Civita Riemann tensor: it violates exchange symmetry between the
spacetime and internal index pairs.

The link equation removes the apparent loophole.  One exact local link Euler
coefficient is an explicit polynomial in the exponential transport and its
inverse.  Dividing that coefficient by the plaquette area gives the nonzero
limit `2 * amplitude`.  Hence every shrinking nonzero-area refinement with a
nonzero surviving amplitude eventually fails connection stationarity.

Combining the coframe and link statements proves that the present nonflat
square family cannot be jointly stationary at every refinement level while
the coframe is held at the identity.  This is a no-go for that ansatz, not a
no-go for the null-edge GR program: a nonflat solution must use a genuinely
varying coframe and a richer curvature pattern.  Pair exchange is introduced
only as an audit predicate; no Levi-Civita selection theorem is claimed.

All results are exact finite identities or asymptotic theorems under displayed
shrinking-area hypotheses.  The coefficient layout was first checked by a
project-local symbolic calculation and is proved here from the live Lean
definitions.  Claim labels: finite identity and conditional asymptotic no-go.
-/

namespace PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteEinsteinAudit

open Filter Topology
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurvatureLimit
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniVaryingCoframeLimit
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement

/-! ## The mixed Einstein equation on the square target -/

/-- The limiting square target satisfies the complete mixed vacuum Einstein
system at the identity inverse coframe. -/
def SquareIdentityMixedVacuum (target : Fiber 6) : Prop :=
  forall site coframeDirection raisedDirection,
    mixedVacuumEinsteinEntry
      (1 : Matrix (Fin 4) (Fin 4) Real)
      (squareCurvatureTarget target site)
      coframeDirection raisedDirection = 0

/-- At one positive-orientation square site, the mixed vacuum Einstein system
kills exactly components `0`, `1`, `3`, `4`, and `5`.  Component `2`, the
internal `23` plane complementary to the spacetime `01` plaquette, does not
enter the Ricci contraction. -/
theorem squareIdentityMixedVacuum_at_zero_iff
    (target : Fiber 6) :
    (forall coframeDirection raisedDirection,
      mixedVacuumEinsteinEntry
        (1 : Matrix (Fin 4) (Fin 4) Real)
        (squareCurvatureTarget target ((0, 0) : SquareSite))
        coframeDirection raisedDirection = 0) <->
      target 0 = 0 /\ target 1 = 0 /\ target 3 = 0 /\
        target 4 = 0 /\ target 5 = 0 := by
  constructor
  · intro h
    have h02 := h 0 2
    have h03 := h 0 3
    have h22 := h 2 2
    have h12 := h 1 2
    have h13 := h 1 3
    simp +decide [mixedVacuumEinsteinEntry, mixedRicciCurvature,
      inverseCoframeScalarCurvature, squareCurvatureTarget, bivectorMatrix,
      Matrix.one_apply, Fin.sum_univ_four] at h02 h03 h22 h12 h13
    exact ⟨by linarith, by linarith, by linarith, by linarith, by linarith⟩
  · rintro ⟨h0, h1, h3, h4, h5⟩ coframeDirection raisedDirection
    fin_cases coframeDirection <;> fin_cases raisedDirection <;>
      simp +decide [mixedVacuumEinsteinEntry, mixedRicciCurvature,
        inverseCoframeScalarCurvature, squareCurvatureTarget, bivectorMatrix,
        Matrix.one_apply, Fin.sum_univ_four, h0, h1, h3, h4, h5]

set_option maxHeartbeats 2000000 in
/-- The classification is unchanged on the negative-orientation column and
therefore characterizes the complete periodic-square target field. -/
theorem squareIdentityMixedVacuum_iff (target : Fiber 6) :
    SquareIdentityMixedVacuum target <->
      target 0 = 0 /\ target 1 = 0 /\ target 3 = 0 /\
        target 4 = 0 /\ target 5 = 0 := by
  constructor
  · intro h
    exact (squareIdentityMixedVacuum_at_zero_iff target).mp
      (fun coframeDirection raisedDirection =>
        h ((0, 0) : SquareSite) coframeDirection raisedDirection)
  · rintro ⟨h0, h1, h3, h4, h5⟩ site
      coframeDirection raisedDirection
    rcases site with ⟨x, y⟩
    fin_cases x <;> fin_cases y <;>
      fin_cases coframeDirection <;> fin_cases raisedDirection <;>
      simp +decide [mixedVacuumEinsteinEntry,
        mixedRicciCurvature, inverseCoframeScalarCurvature,
        squareCurvatureTarget, bivectorMatrix, Matrix.one_apply,
        Fin.sum_univ_four, h0, h1, h3, h4, h5]

/-- The only coordinate family left by the square's identity-coframe Einstein
equation: an internal `23` rotation on the spacetime `01` plaquette. -/
def complementaryRotationTarget (amplitude : Real) : Fiber 6 :=
  Pi.single 2 amplitude

/-- A nonzero amplitude gives a nonzero six-component target. -/
theorem complementaryRotationTarget_ne_zero
    {amplitude : Real} (hAmplitude : amplitude ≠ 0) :
    complementaryRotationTarget amplitude ≠ 0 := by
  intro hTarget
  have hComponent := congrFun hTarget 2
  simpa [complementaryRotationTarget, Pi.single_apply] using
    hAmplitude hComponent

/-- The complementary rotation family satisfies all mixed vacuum Einstein
entries at the identity inverse coframe, even when its amplitude is nonzero.
This is an algebraic Ricci-flat statement, not a Riemann-curvature claim. -/
theorem complementaryRotationTarget_mixedVacuum
    (amplitude : Real) :
    SquareIdentityMixedVacuum (complementaryRotationTarget amplitude) := by
  rw [squareIdentityMixedVacuum_iff]
  simp [complementaryRotationTarget]

/-! ## Pair-exchange audit -/

/-- Lower both internal indices of a curvature bivector with the mostly-minus
metric. -/
def loweredBivectorMatrix (bivector : Fiber 6) :
    Matrix (Fin 4) (Fin 4) Real :=
  MinkowskiConvention.eta * bivectorMatrix bivector *
    MinkowskiConvention.eta

/-- Because eta is diagonal, lowering both bivector indices multiplies one
entry by the two corresponding diagonal signs. -/
@[simp]
theorem loweredBivectorMatrix_apply
    (bivector : Fiber 6) (i j : Fin 4) :
    loweredBivectorMatrix bivector i j =
      MinkowskiConvention.eta i i * bivectorMatrix bivector i j *
        MinkowskiConvention.eta j j := by
  fin_cases i <;> fin_cases j <;>
    simp [loweredBivectorMatrix, MinkowskiConvention.eta, Matrix.mul_apply,
      Matrix.vecMul, dotProduct, Fin.sum_univ_four]

/-- Exchange symmetry between the spacetime face pair and the two lowered
internal indices, written in the identity-coframe convention. -/
def CurvaturePairExchangeSymmetric
    (curvature : Fin 4 -> Fin 4 -> Fiber 6) : Prop :=
  forall a b i j,
    loweredBivectorMatrix (curvature a b) i j =
      loweredBivectorMatrix (curvature i j) a b

/-- The nonzero complementary square mode violates pair exchange: its
`F_01^23` entry has no corresponding `F_23^01` entry.  Thus the mode that the
Ricci equation alone leaves free is outside the Levi-Civita Riemann sector. -/
theorem complementaryRotationTarget_not_pairExchange
    {amplitude : Real} (hAmplitude : amplitude ≠ 0) :
    Not (forall site,
      CurvaturePairExchangeSymmetric
        (squareCurvatureTarget (complementaryRotationTarget amplitude) site)) := by
  intro hSymmetric
  have hEntry := hSymmetric ((0, 0) : SquareSite) 0 1 2 3
  apply hAmplitude
  simpa +decide [CurvaturePairExchangeSymmetric, loweredBivectorMatrix,
    squareCurvatureTarget, complementaryRotationTarget, bivectorMatrix,
    MinkowskiConvention.eta, Matrix.mul_apply, Fin.sum_univ_four,
    Pi.single_apply] using hEntry

/-! ## Exact link-Euler obstruction -/

/-- The four matrix entries that remain in one local link Euler coefficient
after evaluating the square connection and identity coframe. -/
def rotationEulerObstruction (transport : GL4) : Real :=
  let U := unitMatrix transport
  let V := unitMatrix transport⁻¹
  U 2 1 * V 3 1 - U 2 3 * V 1 1 -
    U 1 1 * V 3 2 + U 1 3 * V 1 2

set_option maxHeartbeats 3000000 in
/-- Exact evaluation of the direction-`2`, component-`1` link Euler
coefficient at the positive vertical-link column. -/
theorem complementaryRotation_linkEulerCoefficient
    (area : Nat -> Real) (amplitude : Real) (n : Nat) :
    nonlinearLinkEulerCoefficient squareShift
        (squareLorentzConnection area
          (complementaryRotationTarget amplitude) n)
        (identityCoframeField SquareSite) ((1, 0) : SquareSite) 2 1 =
      rotationEulerObstruction
        (exponentialHolonomy area
          (complementaryRotationTarget amplitude) n) := by
  simp +decide [nonlinearLinkEulerCoefficient, nonlinearLinkEulerFunctional,
    nonlinearWeightedAdjointFaceResponse, orderedPlaquetteActionFirstResponse,
    identityCoframeField, coframeFaceWeight,
    complementaryPalatiniFaceWeight, palatiniFaceWeight, coframeWedge,
    spacetimeAlternatingSymbol, lorentzHodgeStar, transportApply,
    lorentzAdjoint, lorentzGenerator, bivectorMatrix,
    bivectorFirst, bivectorSecond,
    MinkowskiConvention.eta, Matrix.mul_apply, Matrix.trace,
    Matrix.vecMul, dotProduct, Matrix.of_apply,
    Matrix.one_apply, Fin.sum_univ_six, Fin.sum_univ_four,
    plaquetteUnit, plaquetteHolonomy, twoStepUnit, twoStepTransport,
    squareLorentzConnection, squareShift, horizontalShift, verticalShift,
    toggleFinTwo, complementaryRotationTarget, rotationEulerObstruction,
    unitMatrix, mul_assoc]; ring

/-- Exact normalized obstruction formula obtained by inserting the positive-
and negative-generator exponential remainder expansions. -/
theorem normalized_rotationEulerObstruction_eq
    (area : Nat -> Real) (amplitude : Real) (n : Nat)
    (hArea : area n ≠ 0) :
    (area n)⁻¹ *
        rotationEulerObstruction
          (exponentialHolonomy area
            (complementaryRotationTarget amplitude) n) =
      area n *
          exponentialResidual area
            (complementaryRotationTarget amplitude) n 2 1 *
          exponentialResidual area
            (-complementaryRotationTarget amplitude) n 3 1 -
        (-amplitude +
            exponentialResidual area
              (complementaryRotationTarget amplitude) n 2 3) *
          (1 + area n *
            exponentialResidual area
              (-complementaryRotationTarget amplitude) n 1 1) -
        (1 + area n *
            exponentialResidual area
              (complementaryRotationTarget amplitude) n 1 1) *
          (-amplitude +
            exponentialResidual area
              (-complementaryRotationTarget amplitude) n 3 2) +
        area n *
          exponentialResidual area
            (complementaryRotationTarget amplitude) n 1 3 *
          exponentialResidual area
            (-complementaryRotationTarget amplitude) n 1 2 := by
  have hU := exponentialHolonomy_expansion area
    (complementaryRotationTarget amplitude) n hArea
  have hV :
      unitMatrix
          (exponentialHolonomy area
            (complementaryRotationTarget amplitude) n)⁻¹ =
        1 + area n •
          (lorentzGenerator (-complementaryRotationTarget amplitude) +
            exponentialResidual area
              (-complementaryRotationTarget amplitude) n) := by
    rw [<- exponentialHolonomy_neg]
    exact exponentialHolonomy_expansion area
      (-complementaryRotationTarget amplitude) n hArea
  rw [rotationEulerObstruction, hU, hV]
  simp +decide [complementaryRotationTarget, lorentzGenerator, bivectorMatrix,
    MinkowskiConvention.eta, Matrix.add_apply, Matrix.smul_apply]
  field_simp [hArea]

/-- The exact obstruction divided by plaquette area converges to twice the
surviving rotation amplitude. -/
theorem normalized_rotationEulerObstruction_tendsto
    (area : Nat -> Real) (amplitude : Real)
    (hAreaNe : ∀ᶠ n in atTop, area n ≠ 0)
    (hAreaZero : Tendsto area atTop (nhds 0)) :
    Tendsto
      (fun n => (area n)⁻¹ *
        rotationEulerObstruction
          (exponentialHolonomy area
            (complementaryRotationTarget amplitude) n))
      atTop (nhds (2 * amplitude)) := by
  let positiveResidual :=
    exponentialResidual area (complementaryRotationTarget amplitude)
  let negativeResidual :=
    exponentialResidual area (-complementaryRotationTarget amplitude)
  have hPositiveMatrix : Tendsto positiveResidual atTop (nhds 0) :=
    exponentialResidual_tendsto_zero area
      (complementaryRotationTarget amplitude) hAreaNe hAreaZero
  have hNegativeMatrix : Tendsto negativeResidual atTop (nhds 0) :=
    exponentialResidual_tendsto_zero area
      (-complementaryRotationTarget amplitude) hAreaNe hAreaZero
  have hPositive (i j : Fin 4) :
      Tendsto (fun n => positiveResidual n i j) atTop (nhds 0) :=
    tendsto_pi_nhds.1 (tendsto_pi_nhds.1 hPositiveMatrix i) j
  have hNegative (i j : Fin 4) :
      Tendsto (fun n => negativeResidual n i j) atTop (nhds 0) :=
    tendsto_pi_nhds.1 (tendsto_pi_nhds.1 hNegativeMatrix i) j
  have hNegAmplitude :
      Tendsto (fun _ : Nat => -amplitude) atTop (nhds (-amplitude)) :=
    tendsto_const_nhds
  have hOne : Tendsto (fun _ : Nat => (1 : Real)) atTop (nhds 1) :=
    tendsto_const_nhds
  have hFirst :=
    (hAreaZero.mul (hPositive 2 1)).mul (hNegative 3 1)
  have hSecond :=
    (hNegAmplitude.add (hPositive 2 3)).mul
      (hOne.add (hAreaZero.mul (hNegative 1 1)))
  have hThird :=
    (hOne.add (hAreaZero.mul (hPositive 1 1))).mul
      (hNegAmplitude.add (hNegative 3 2))
  have hFourth :=
    (hAreaZero.mul (hPositive 1 3)).mul (hNegative 1 2)
  have hPolynomial := ((hFirst.sub hSecond).sub hThird).add hFourth
  have hPolynomial' : Tendsto
      (fun n =>
        area n * positiveResidual n 2 1 * negativeResidual n 3 1 -
          (-amplitude + positiveResidual n 2 3) *
            (1 + area n * negativeResidual n 1 1) -
          (1 + area n * positiveResidual n 1 1) *
            (-amplitude + negativeResidual n 3 2) +
          area n * positiveResidual n 1 3 * negativeResidual n 1 2)
      atTop (nhds (2 * amplitude)) := by
    convert hPolynomial using 1
    all_goals ring_nf
  apply hPolynomial'.congr'
  filter_upwards [hAreaNe] with n hn
  symm
  simpa [positiveResidual, negativeResidual] using
    normalized_rotationEulerObstruction_eq area amplitude n hn

/-- A nonzero complementary rotation amplitude eventually violates the exact
connection Euler equation at the identity coframe. -/
theorem complementaryRotation_eventually_not_connectionStationary
    (area : Nat -> Real) (amplitude : Real)
    (hAmplitude : amplitude ≠ 0)
    (hAreaNe : ∀ᶠ n in atTop, area n ≠ 0)
    (hAreaZero : Tendsto area atTop (nhds 0)) :
    ∀ᶠ n in atTop,
      Not (NonlinearCoframePlaquetteConnectionStationary squareShift
        (squareLorentzConnection area
          (complementaryRotationTarget amplitude) n)
        (identityCoframeField SquareSite)) := by
  have hLimit := normalized_rotationEulerObstruction_tendsto
    area amplitude hAreaNe hAreaZero
  have hLimitNe : 2 * amplitude ≠ 0 := mul_ne_zero (by norm_num) hAmplitude
  have hEventuallyNe := hLimit.eventually_ne hLimitNe
  filter_upwards [hEventuallyNe] with n hn
  intro hStationary
  have hCoefficient :=
    (nonlinearCoframePlaquetteConnectionStationary_iff_coefficients
      squareShift
      (squareLorentzConnection area
        (complementaryRotationTarget amplitude) n)
      (identityCoframeField SquareSite)).mp hStationary
      ((1, 0) : SquareSite) 2 1
  rw [complementaryRotation_linkEulerCoefficient] at hCoefficient
  exact hn (by rw [hCoefficient, mul_zero])

/-! ## Combined no-go for the static identity-coframe ansatz -/

/-- The constant identity coframe and inverse form a valid coframe refinement
limit packet. -/
def identityCoframeRefinementLimit (Site : Type*) :
    CoframeRefinementLimit
      (fun _ => identityCoframeField Site)
      (fun _ => identityCoframeField Site)
      (identityCoframeField Site) (identityCoframeField Site) where
  leftInverse := by
    intro n site
    simp [identityCoframeField]
  coframe_tendsto := by
    intro site i j
    exact tendsto_const_nhds
  inverseCoframe_tendsto := by
    intro site i j
    exact tendsto_const_nhds

/-- **Static-square joint-stationarity no-go.**  For every nonzero target and
every shrinking eventually nonzero area sequence, the exact physical square
connection cannot be jointly link- and coframe-stationary at every refinement
level while the coframe is held at the identity.

The coframe equation first restricts any hypothetical target to the single
complementary rotation component.  The asymptotic link coefficient then rules
out that final nonzero component. -/
theorem nonzero_squareTarget_not_jointStationary_identityCoframe
    (area : Nat -> Real) (target : Fiber 6)
    (hTarget : target ≠ 0)
    (hAreaNe : ∀ᶠ n in atTop, area n ≠ 0)
    (hAreaZero : Tendsto area atTop (nhds 0)) :
    Not (forall n,
      NonlinearCoframePlaquetteJointStationary squareShift
        (squareLorentzConnection area target n)
        (identityCoframeField SquareSite)) := by
  intro hJoint
  have hEndpoint := coframeStationary_physicalVaryingRefinementLimit
    squareShift (squareLorentzConnection area target) area
    (squareCurvatureTarget target)
    (physicalSquarePlaquetteRefinement area target hAreaNe hAreaZero)
    (fun _ => identityCoframeField SquareSite)
    (fun _ => identityCoframeField SquareSite)
    (identityCoframeField SquareSite) (identityCoframeField SquareSite)
    (identityCoframeRefinementLimit SquareSite)
    (fun n => (hJoint n).2)
  have hComponents :=
    (squareIdentityMixedVacuum_iff target).mp hEndpoint.2
  rcases hComponents with ⟨h0, h1, h3, h4, h5⟩
  have hAmplitude : target 2 ≠ 0 := by
    intro h2
    apply hTarget
    funext component
    fin_cases component <;> simp [h0, h1, h2, h3, h4, h5]
  have hTargetEq : target = complementaryRotationTarget (target 2) := by
    funext component
    fin_cases component <;>
      simp [complementaryRotationTarget,
        h0, h1, h3, h4, h5]
  have hEventually :=
    complementaryRotation_eventually_not_connectionStationary
      area (target 2) hAmplitude hAreaNe hAreaZero
  rcases hEventually.exists with ⟨n, hn⟩
  apply hn
  have hConnection := (hJoint n).1
  rw [hTargetEq] at hConnection
  exact hConnection

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteEinsteinAudit.squareIdentityMixedVacuum_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms squareIdentityMixedVacuum_iff

/-- info: 'PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteEinsteinAudit.complementaryRotation_eventually_not_connectionStationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms complementaryRotation_eventually_not_connectionStationary

/-- info: 'PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteEinsteinAudit.nonzero_squareTarget_not_jointStationary_identityCoframe' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonzero_squareTarget_not_jointStationary_identityCoframe

end PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteEinsteinAudit
