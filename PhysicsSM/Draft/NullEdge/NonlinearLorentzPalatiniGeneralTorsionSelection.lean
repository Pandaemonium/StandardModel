import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection

noncomputable section

/-!
# General-tetrad linearized torsion selection

This module removes the identity-tetrad restriction from the local
linearized Palatini connection theorem.  The reduction is algebraic.  The
ordinary exterior-square action of an internal basis change is conjugated by
the fixed Lorentz Hodge matrix, producing the transport seen by the Palatini
face coefficients.  A supplied inverse coframe then carries an arbitrary
nondegenerate background to the identity, where the exact twenty-four
component theorem is already available.

The principal result says that, at every coframe with a supplied two-sided
inverse, all twenty-four linearized connection coefficients vanish if and
only if the linearized Cartan torsion vanishes.  The finite-spacing and
changing-carrier consequences retain the exact quadratic defect from the
identity-background predecessor.

This is a finite algebraic identity and a conditional first-jet limit.  It
does not treat a nonidentity background link connection, prove nonlinear
Levi-Civita uniqueness, derive metric dual-cell weights or a graph
refinement, control varying coframe jets, or identify the selected transport
with continuum Levi-Civita holonomy.

Provenance: clean-room finite implementation of the standard nondegenerate
tetrad step in the Palatini implication `D(e wedge e) = 0 => T = 0`, using the
repository's mostly-minus metric, orientation `0123`, and ordered bivector
basis `(12,13,23,01,02,03)`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection

open Filter Topology
open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection

/-! ## Arbitrary internal-basis covariance -/

/-- The exterior-square transport conjugated into the Hodge-dual Palatini
face coordinates.  For proper Lorentz matrices this reduces to the ordinary
bivector transport, but the conjugated expression is meaningful for every
real internal basis change. -/
def palatiniBivectorTransport
    (matrix : Matrix (Fin 4) (Fin 4) Real) :
    Matrix (Fin 6) (Fin 6) Real :=
  -(lorentzHodgeStar * wedgeTwoTransport matrix * lorentzHodgeStar)

/-- Conjugation by the Lorentz Hodge matrix converts the exterior-square
action into the action on Hodge-dualized Palatini faces. -/
theorem palatiniBivectorTransport_mul_lorentzHodgeStar
    (matrix : Matrix (Fin 4) (Fin 4) Real) :
    palatiniBivectorTransport matrix * lorentzHodgeStar =
      lorentzHodgeStar * wedgeTwoTransport matrix := by
  unfold palatiniBivectorTransport
  calc
    -(lorentzHodgeStar * wedgeTwoTransport matrix * lorentzHodgeStar) *
          lorentzHodgeStar =
        -(lorentzHodgeStar * wedgeTwoTransport matrix *
          (lorentzHodgeStar * lorentzHodgeStar)) := by
            simp only [neg_mul, Matrix.mul_assoc]
    _ = -(lorentzHodgeStar * wedgeTwoTransport matrix *
          (-(1 : Matrix (Fin 6) (Fin 6) Real))) := by
            rw [lorentzHodgeStar_sq]
    _ = lorentzHodgeStar * wedgeTwoTransport matrix := by simp

/-- On a proper eta-Lorentz basis change the conjugated Palatini transport is
exactly the repository's ordinary exterior-square bivector transport. -/
theorem palatiniBivectorTransport_eq_wedgeTwoTransport
    (matrix : Matrix (Fin 4) (Fin 4) Real)
    (hLorentz : IsEtaLorentz matrix) (hProper : matrix.det = 1) :
    palatiniBivectorTransport matrix = wedgeTwoTransport matrix := by
  have hCommute := wedgeTwoTransport_commutes_lorentzHodgeStar
    matrix hLorentz hProper
  unfold palatiniBivectorTransport
  rw [hCommute.symm, Matrix.mul_assoc, lorentzHodgeStar_sq]
  simp

set_option maxHeartbeats 2000000 in
/-- Polarizing the coframe wedge commutes with an arbitrary internal basis
change through the exterior-square representation. -/
theorem coframeWedgeFirstVariation_mul
    (matrix coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    coframeWedgeFirstVariation (matrix * coframe) (matrix * variation)
        first second =
      transportApply (wedgeTwoTransport matrix)
        (coframeWedgeFirstVariation coframe variation first second) := by
  funext component
  fin_cases component <;>
    simp +decide [coframeWedgeFirstVariation, transportApply,
      wedgeTwoTransport, Matrix.mul_apply, bivectorFirst, bivectorSecond,
      Fin.sum_univ_four, Fin.sum_univ_six] <;>
    ring

/-- The polarized Hodge-dual Palatini face is covariant under every internal
basis change when transported by `palatiniBivectorTransport`. -/
theorem palatiniFaceWeightFirstVariation_mul
    (matrix coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    palatiniFaceWeightFirstVariation (matrix * coframe) (matrix * variation)
        first second =
      transportApply (palatiniBivectorTransport matrix)
        (palatiniFaceWeightFirstVariation coframe variation first second) := by
  unfold palatiniFaceWeightFirstVariation
  rw [coframeWedgeFirstVariation_mul]
  simp only [transportApply_eq_mulVec, Matrix.mulVec_mulVec]
  rw [palatiniBivectorTransport_mul_lorentzHodgeStar]

/-- Matrix transport commutes with a doubly indexed weighted finite sum of
fiber fields. -/
theorem transportApply_weightedDoubleSum_fin4
    (matrix : Matrix (Fin 6) (Fin 6) Real)
    (weight : Fin 4 -> Fin 4 -> Real)
    (field : Fin 4 -> Fin 4 -> Fiber 6) :
    transportApply matrix (fun component =>
        Finset.sum Finset.univ (fun first =>
          Finset.sum Finset.univ (fun second =>
            weight first second * field first second component))) =
      fun component =>
        Finset.sum Finset.univ (fun first =>
          Finset.sum Finset.univ (fun second =>
            weight first second *
              transportApply matrix (field first second) component)) := by
  rw [transportApply_sum_fin4]
  funext component
  apply Finset.sum_congr rfl
  intro first _
  rw [transportApply_sum_fin4]
  apply Finset.sum_congr rfl
  intro second _
  rw [transportApply_scale]

/-- Weighted-double-sum form of the polarized complementary Palatini face. -/
theorem complementaryPalatiniFaceWeightFirstVariation_eq_weightedDoubleSum
    (coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    complementaryPalatiniFaceWeightFirstVariation coframe variation
        first second =
      fun component =>
        Finset.sum Finset.univ (fun left =>
          Finset.sum Finset.univ (fun right =>
            ((1 / 2 : Real) *
                spacetimeAlternatingSymbol left right first second) *
              palatiniFaceWeightFirstVariation coframe variation
                left right component)) := by
  funext component
  unfold complementaryPalatiniFaceWeightFirstVariation
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro left _
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro right _
  ring

/-- The polarized complementary Palatini face has the same arbitrary-basis
covariance as each Hodge-dualized coframe face. -/
theorem complementaryPalatiniFaceWeightFirstVariation_mul
    (matrix coframe variation : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    complementaryPalatiniFaceWeightFirstVariation
        (matrix * coframe) (matrix * variation) first second =
      transportApply (palatiniBivectorTransport matrix)
        (complementaryPalatiniFaceWeightFirstVariation
          coframe variation first second) := by
  rw [complementaryPalatiniFaceWeightFirstVariation_eq_weightedDoubleSum,
    complementaryPalatiniFaceWeightFirstVariation_eq_weightedDoubleSum]
  simp_rw [palatiniFaceWeightFirstVariation_mul]
  exact (transportApply_weightedDoubleSum_fin4
    (palatiniBivectorTransport matrix)
    (fun left right => (1 / 2 : Real) *
      spacetimeAlternatingSymbol left right first second)
    (fun left right =>
      palatiniFaceWeightFirstVariation coframe variation left right)).symm

/-- The full twenty-four-component linearized connection residual is
covariant under every internal basis change. -/
theorem linearizedPalatiniConnectionResidual_mul
    (matrix coframe : Matrix (Fin 4) (Fin 4) Real)
    (velocity : CoframeVelocity) (direction : Fin 4) :
    linearizedPalatiniConnectionResidual (matrix * coframe)
        (fun backwardDirection => matrix * velocity backwardDirection)
        direction =
      transportApply (palatiniBivectorTransport matrix)
        (linearizedPalatiniConnectionResidual coframe velocity direction) := by
  unfold linearizedPalatiniConnectionResidual
  simp_rw [complementaryPalatiniFaceWeightFirstVariation_mul]
  exact (transportApply_sum_fin4
    (palatiniBivectorTransport matrix)
    (fun backwardDirection =>
      complementaryPalatiniFaceWeightFirstVariation coframe
        (velocity backwardDirection) direction backwardDirection)).symm

/-! ## Torsion covariance and arbitrary-tetrad selection -/

/-- The four internal components of linearized torsion for one ordered pair
of derivative directions. -/
def linearizedTorsionFiber
    (velocity : CoframeVelocity) (first second : Fin 4) : Fin 4 -> Real :=
  fun internal => linearizedCartanTorsion velocity internal first second

/-- Internal basis change acts on the internal index of Cartan torsion by
ordinary matrix-vector multiplication. -/
theorem linearizedTorsionFiber_mul
    (matrix : Matrix (Fin 4) (Fin 4) Real)
    (velocity : CoframeVelocity) (first second : Fin 4) :
    linearizedTorsionFiber
        (fun direction => matrix * velocity direction) first second =
      Matrix.mulVec matrix (linearizedTorsionFiber velocity first second) := by
  funext internal
  simp [linearizedTorsionFiber, linearizedCartanTorsion,
    Matrix.mul_apply, Matrix.mulVec, dotProduct, Fin.sum_univ_four]
  ring

/-- **General-tetrad Palatini connection equation equals zero torsion.**
For a coframe with a supplied inverse, the twenty-four linearized connection
equations vanish exactly when all Cartan torsion components vanish. -/
theorem linearizedPalatiniConnectionResidual_invertible_iff_torsionFree
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (velocity : CoframeVelocity) :
    (forall direction component,
      linearizedPalatiniConnectionResidual coframe velocity
        direction component = 0) <->
      LinearizedTorsionFree velocity := by
  have hRight : coframe * inverseCoframe = 1 := mul_eq_one_comm.2 hLeft
  constructor
  · intro hResidual
    have hIdentityResidual : forall direction component,
        linearizedPalatiniConnectionResidual 1
          (fun backwardDirection =>
            inverseCoframe * velocity backwardDirection)
          direction component = 0 := by
      intro direction component
      rw [<- hLeft]
      rw [linearizedPalatiniConnectionResidual_mul]
      unfold transportApply
      simp [hResidual]
    have hTransformedTorsion :
        LinearizedTorsionFree (fun direction =>
          inverseCoframe * velocity direction) :=
      (linearizedPalatiniConnectionResidual_identity_iff_torsionFree
        (fun direction => inverseCoframe * velocity direction)).mp
          hIdentityResidual
    intro internal first second
    have hZero : Matrix.mulVec inverseCoframe
        (linearizedTorsionFiber velocity first second) = 0 := by
      rw [<- linearizedTorsionFiber_mul]
      funext transformedInternal
      exact hTransformedTorsion transformedInternal first second
    have hRecover := congrArg (Matrix.mulVec coframe) hZero
    simp only [Matrix.mulVec_mulVec, hRight, Matrix.one_mulVec,
      Matrix.mulVec_zero] at hRecover
    exact congrFun hRecover internal
  · intro hTorsion
    have hTransformedTorsion :
        LinearizedTorsionFree (fun direction =>
          inverseCoframe * velocity direction) := by
      intro internal first second
      have hFiber := linearizedTorsionFiber_mul inverseCoframe velocity
        first second
      have hZero : linearizedTorsionFiber velocity first second = 0 := by
        funext sourceInternal
        exact hTorsion sourceInternal first second
      change linearizedTorsionFiber
        (fun direction => inverseCoframe * velocity direction)
          first second internal = 0
      rw [hFiber, hZero, Matrix.mulVec_zero]
      rfl
    have hIdentityResidual : forall direction component,
        linearizedPalatiniConnectionResidual 1
          (fun backwardDirection =>
            inverseCoframe * velocity backwardDirection)
          direction component = 0 :=
      (linearizedPalatiniConnectionResidual_identity_iff_torsionFree
        (fun direction => inverseCoframe * velocity direction)).mpr
          hTransformedTorsion
    have hVelocity :
        (fun direction =>
          coframe * (inverseCoframe * velocity direction)) = velocity := by
      funext direction
      rw [<- Matrix.mul_assoc, hRight]
      simp
    intro direction component
    have hCovariance := linearizedPalatiniConnectionResidual_mul coframe 1
      (fun backwardDirection => inverseCoframe * velocity backwardDirection)
      direction
    simp only [Matrix.mul_one] at hCovariance
    rw [hVelocity] at hCovariance
    rw [hCovariance]
    unfold transportApply
    simp [hIdentityResidual]

/-! ## Explicit nonidentity background control -/

/-- A simple nonidentity anisotropic coframe used to witness that the general
selection theorem is genuinely beyond the identity background. -/
def anisotropicCoframe : Matrix (Fin 4) (Fin 4) Real :=
  !![2, 0, 0, 0;
     0, 3, 0, 0;
     0, 0, 5, 0;
     0, 0, 0, 7]

/-- The displayed two-sided inverse candidate for `anisotropicCoframe`. -/
def anisotropicInverseCoframe : Matrix (Fin 4) (Fin 4) Real :=
  !![1 / 2, 0, 0, 0;
     0, 1 / 3, 0, 0;
     0, 0, 1 / 5, 0;
     0, 0, 0, 1 / 7]

/-- The anisotropic control has the displayed inverse and is not the identity
coframe. -/
theorem anisotropicCoframe_inverse_and_nonidentity :
    anisotropicInverseCoframe * anisotropicCoframe = 1 ∧
      anisotropicCoframe ≠ 1 := by
  constructor
  · ext row column
    fin_cases row <;> fin_cases column <;>
      simp +decide [anisotropicInverseCoframe, anisotropicCoframe,
        Matrix.mul_apply, Fin.sum_univ_four]
  · intro hIdentity
    have hEntry := congrFun (congrFun hIdentity (0 : Fin 4)) (0 : Fin 4)
    norm_num [anisotropicCoframe, Matrix.one_apply] at hEntry

/-- On the explicit nonidentity anisotropic background, all twenty-four
linearized Palatini connection equations vanish exactly when Cartan torsion
vanishes. -/
theorem anisotropicCoframe_connectionResidual_iff_torsionFree
    (velocity : CoframeVelocity) :
    (forall direction component,
      linearizedPalatiniConnectionResidual anisotropicCoframe velocity
        direction component = 0) <->
      LinearizedTorsionFree velocity :=
  linearizedPalatiniConnectionResidual_invertible_iff_torsionFree
    anisotropicCoframe anisotropicInverseCoframe
      anisotropicCoframe_inverse_and_nonidentity.1 velocity

/-! ## Finite-spacing and changing-carrier consequences -/

/-- At any fixed invertible background tetrad, exact finite local connection
equations at nonzero shrinking spacings force the fixed first coframe jet to
be torsion-free. -/
theorem finitePalatiniConnectionResidual_invertible_limit_torsionFree
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (velocity : CoframeVelocity) (spacing : Nat -> Real)
    (hNonzero : forall n, spacing n ≠ 0)
    (hToZero : Tendsto spacing atTop (nhds 0))
    (hResidual : forall n direction component,
      finitePalatiniConnectionResidual coframe
        (fun backwardDirection => spacing n • velocity backwardDirection)
        direction component = 0) :
    LinearizedTorsionFree velocity := by
  rw [<- linearizedPalatiniConnectionResidual_invertible_iff_torsionFree
    coframe inverseCoframe hLeft]
  exact finitePalatiniConnectionResidual_scaled_limit coframe velocity spacing
    hNonzero hToZero hResidual

/-- **Conditional general-background changing-carrier endpoint.**  The finite
carrier may vary with refinement.  If its distinguished center has one fixed
invertible coframe, its four predecessor coframes have one fixed first jet,
and every identity-link action is connection stationary, then shrinking
nonzero spacing forces that jet to be torsion-free. -/
theorem identityConnectionStationary_refinement_invertible_linearizedTorsionFree
    {Site : Nat -> Type*} [forall n, Fintype (Site n)]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (coframeField : (n : Nat) -> CoframeField (Site n))
    (site : (n : Nat) -> Site n)
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (velocity : CoframeVelocity) (spacing : Nat -> Real)
    (hNonzero : forall n, spacing n ≠ 0)
    (hToZero : Tendsto spacing atTop (nhds 0))
    (hCenter : forall n, coframeField n (site n) = coframe)
    (hPredecessor : forall n direction,
      coframeField n ((shift n direction).symm (site n)) =
        coframe + spacing n • velocity direction)
    (hStationary : forall n,
      NonlinearCoframePlaquetteConnectionStationary (shift n)
        (identityConnection (Site n)) (coframeField n)) :
    LinearizedTorsionFree velocity := by
  apply finitePalatiniConnectionResidual_invertible_limit_torsionFree
    coframe inverseCoframe hLeft velocity spacing hNonzero hToZero
  intro n direction component
  have hLocal :=
    identityConnectionStationary_finitePalatiniConnectionResidual
      (shift n) (coframeField n) (hStationary n) (site n) direction component
  rw [hCenter n] at hLocal
  have hIncrement :
      (fun backwardDirection =>
        coframeField n ((shift n backwardDirection).symm (site n)) - coframe) =
        fun backwardDirection => spacing n • velocity backwardDirection := by
    funext backwardDirection
    rw [hPredecessor n backwardDirection]
    module
  rw [hIncrement] at hLocal
  exact hLocal

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection.palatiniFaceWeightFirstVariation_mul' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms palatiniFaceWeightFirstVariation_mul

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection.linearizedPalatiniConnectionResidual_invertible_iff_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linearizedPalatiniConnectionResidual_invertible_iff_torsionFree

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection.anisotropicCoframe_connectionResidual_iff_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms anisotropicCoframe_connectionResidual_iff_torsionFree

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection.finitePalatiniConnectionResidual_invertible_limit_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finitePalatiniConnectionResidual_invertible_limit_torsionFree

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection.identityConnectionStationary_refinement_invertible_linearizedTorsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms identityConnectionStationary_refinement_invertible_linearizedTorsionFree

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection
