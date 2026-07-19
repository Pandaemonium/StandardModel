import Mathlib.Analysis.Calculus.FDeriv.Equiv
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerChangingCarrierTorsion

noncomputable section

/-!
# Sampled coframe jets in the changing-carrier Cartan limit

The changing-carrier connection theorem samples a continuous Lorentz
connection on a shrinking pointed stencil, but its first version keeps the
backward coframe jet fixed by hypothesis.  A smooth tetrad should instead
produce that jet as a scaled predecessor difference quotient.

This module closes that interface in three steps:

1. package the identity-background affine Palatini residual as a continuous
   linear map of the center connection and coframe velocity;
2. allow both local jets to vary componentwise and converge while the
   identity-background first variations of the exact nonlinear Euler
   coefficients tend to zero;
3. use `HasFDerivAt.lim` to derive the coframe-velocity limit from a
   differentiable tetrad sampled at affine predecessor points.

The pointed chart, inverse-spacing sequence, predecessor tangent vectors, and
finite carrier embeddings remain explicit data.  The theorem does not derive
them from causal order, identify the limiting chart derivative with a global
Levi-Civita connection, leave the identity background, or prove the coframe
Einstein equation.

Claim labels: conditional changing-carrier asymptotic theorem and sampled
differentiable-tetrad consistency theorem.  Originality tag: `[orig]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection

open Filter Topology
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection

/-! ## Continuity of the affine covariant Palatini residual -/

/-- The ordinary linearized Palatini residual is additive in the coframe
velocity at fixed background coframe. -/
theorem linearizedPalatiniConnectionResidual_add_velocity
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (left right : CoframeVelocity) (direction : Fin 4) :
    linearizedPalatiniConnectionResidual coframe (left + right) direction =
      linearizedPalatiniConnectionResidual coframe left direction +
        linearizedPalatiniConnectionResidual coframe right direction := by
  funext component
  unfold linearizedPalatiniConnectionResidual
  simp_rw [Pi.add_apply,
    complementaryPalatiniFaceWeightFirstVariation_add]
  exact Finset.sum_add_distrib

/-- The ordinary linearized Palatini residual is homogeneous in the coframe
velocity at fixed background coframe. -/
theorem linearizedPalatiniConnectionResidual_smul_velocity
    (coframe : Matrix (Fin 4) (Fin 4) Real) (scalar : Real)
    (velocity : CoframeVelocity) (direction : Fin 4) :
    linearizedPalatiniConnectionResidual coframe (scalar • velocity)
        direction =
      scalar • linearizedPalatiniConnectionResidual coframe velocity
        direction := by
  funext component
  unfold linearizedPalatiniConnectionResidual
  simp_rw [Pi.smul_apply,
    complementaryPalatiniFaceWeightFirstVariation_smul]
  simp only [Finset.smul_sum, Pi.smul_apply]

/-- The covariant coframe velocity is additive in the simultaneous connection
and ordinary-velocity inputs. -/
theorem covariantCoframeVelocity_add_inputs
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (leftConnection rightConnection : LorentzConnectionVelocity)
    (leftVelocity rightVelocity : CoframeVelocity) :
    covariantCoframeVelocity coframe
        (leftConnection + rightConnection) (leftVelocity + rightVelocity) =
      covariantCoframeVelocity coframe leftConnection leftVelocity +
        covariantCoframeVelocity coframe rightConnection rightVelocity := by
  funext direction row column
  simp only [covariantCoframeVelocity, Pi.add_apply, Matrix.sub_apply,
    Matrix.add_apply]
  rw [lorentzGenerator_add, Matrix.add_mul]
  simp only [Matrix.add_apply]
  ring

/-- The covariant coframe velocity is homogeneous in the simultaneous
connection and ordinary-velocity inputs. -/
theorem covariantCoframeVelocity_smul_inputs
    (coframe : Matrix (Fin 4) (Fin 4) Real) (scalar : Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity) :
    covariantCoframeVelocity coframe (scalar • connection)
        (scalar • velocity) =
      scalar • covariantCoframeVelocity coframe connection velocity := by
  funext direction row column
  simp only [covariantCoframeVelocity, Pi.smul_apply, Matrix.sub_apply,
    Matrix.smul_apply]
  rw [lorentzGenerator_smul, Matrix.smul_mul]
  simp only [Matrix.smul_apply, smul_eq_mul]
  ring

/-- The affine covariant residual is additive in its simultaneous center
connection and coframe-velocity inputs. -/
theorem linearizedAffineCovariantPalatiniResidual_add_inputs
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (leftConnection rightConnection : LorentzConnectionVelocity)
    (leftVelocity rightVelocity : CoframeVelocity) (direction : Fin 4) :
    linearizedAffineCovariantPalatiniResidual coframe
        (leftConnection + rightConnection) (leftVelocity + rightVelocity)
        direction =
      linearizedAffineCovariantPalatiniResidual coframe
          leftConnection leftVelocity direction +
        linearizedAffineCovariantPalatiniResidual coframe
          rightConnection rightVelocity direction := by
  simp_rw [linearizedAffineCovariantPalatiniResidual_eq]
  rw [covariantCoframeVelocity_add_inputs,
    linearizedPalatiniConnectionResidual_add_velocity]

/-- The affine covariant residual is homogeneous in its simultaneous center
connection and coframe-velocity inputs. -/
theorem linearizedAffineCovariantPalatiniResidual_smul_inputs
    (coframe : Matrix (Fin 4) (Fin 4) Real) (scalar : Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (direction : Fin 4) :
    linearizedAffineCovariantPalatiniResidual coframe
        (scalar • connection) (scalar • velocity) direction =
      scalar • linearizedAffineCovariantPalatiniResidual coframe
        connection velocity direction := by
  simp_rw [linearizedAffineCovariantPalatiniResidual_eq]
  rw [covariantCoframeVelocity_smul_inputs,
    linearizedPalatiniConnectionResidual_smul_velocity]

/-- One direction of the affine covariant residual as a linear map of the
connection/coframe-velocity pair. -/
def affineCovariantPalatiniResidualLinear
    (coframe : Matrix (Fin 4) (Fin 4) Real) (direction : Fin 4) :
    (LorentzConnectionVelocity × CoframeVelocity) →ₗ[Real] Fiber 6 where
  toFun inputs := linearizedAffineCovariantPalatiniResidual coframe
    inputs.1 inputs.2 direction
  map_add' left right := by
    exact linearizedAffineCovariantPalatiniResidual_add_inputs coframe
      left.1 right.1 left.2 right.2 direction
  map_smul' scalar inputs := by
    exact linearizedAffineCovariantPalatiniResidual_smul_inputs coframe scalar
      inputs.1 inputs.2 direction

/-- Finite-dimensionality makes the affine residual continuous in both local
jet inputs. -/
def affineCovariantPalatiniResidualContinuous
    (coframe : Matrix (Fin 4) (Fin 4) Real) (direction : Fin 4) :
    (LorentzConnectionVelocity × CoframeVelocity) →L[Real] Fiber 6 :=
  (affineCovariantPalatiniResidualLinear coframe direction).toContinuousLinearMap

@[simp]
theorem affineCovariantPalatiniResidualContinuous_apply
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (direction : Fin 4) :
    affineCovariantPalatiniResidualContinuous coframe direction
        (connection, velocity) =
      linearizedAffineCovariantPalatiniResidual coframe connection velocity
        direction :=
  rfl

/-- Componentwise convergence of the center connection and coframe velocity
implies convergence of every affine Palatini residual direction. -/
theorem linearizedAffineCovariantPalatiniResidual_tendsto
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : Nat -> LorentzConnectionVelocity)
    (targetConnection : LorentzConnectionVelocity)
    (velocity : Nat -> CoframeVelocity) (targetVelocity : CoframeVelocity)
    (hConnection : forall direction component,
      Tendsto (fun n => connection n direction component) atTop
        (nhds (targetConnection direction component)))
    (hVelocity : forall direction row column,
      Tendsto (fun n => velocity n direction row column) atTop
        (nhds (targetVelocity direction row column)))
    (direction : Fin 4) :
    Tendsto
      (fun n => linearizedAffineCovariantPalatiniResidual coframe
        (connection n) (velocity n) direction)
      atTop
      (nhds (linearizedAffineCovariantPalatiniResidual coframe
        targetConnection targetVelocity direction)) := by
  have hConnectionField : Tendsto connection atTop (nhds targetConnection) := by
    apply tendsto_pi_nhds.mpr
    intro inputDirection
    apply tendsto_pi_nhds.mpr
    exact hConnection inputDirection
  have hVelocityField : Tendsto velocity atTop (nhds targetVelocity) := by
    apply tendsto_pi_nhds.mpr
    intro inputDirection
    apply tendsto_pi_nhds.mpr
    intro row
    apply tendsto_pi_nhds.mpr
    exact hVelocity inputDirection row
  have hInputs : Tendsto (fun n => (connection n, velocity n)) atTop
      (nhds (targetConnection, targetVelocity)) :=
    hConnectionField.prodMk_nhds hVelocityField
  simpa only [affineCovariantPalatiniResidualContinuous_apply] using
    (affineCovariantPalatiniResidualContinuous coframe direction).continuous
      |>.tendsto (targetConnection, targetVelocity) |>.comp hInputs

/-! ## Changing-carrier Cartan selection for convergent local jets -/

/-- **Convergent-jet changing-carrier Cartan selection.**  The center
connection and backward coframe velocity may both vary with the finite carrier.
If they converge componentwise, the exact neighbor defect vanishes, and the
identity-background first variations of the exact nonlinear link-Euler
coefficients tend to zero, then the limiting local jets obey the covariant
Cartan equation at that background. -/
theorem
    nonlinearLinkEulerCoefficient_changingCarrier_torsionFree_of_jets_tendsto
    {Site : Nat -> Type*} [forall n, Fintype (Site n)]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (linkVariation : (n : Nat) -> LinkVariation (Site n))
    (coframeVariation : (n : Nat) -> CoframeField (Site n))
    (center : (n : Nat) -> Site n)
    (targetConnection : LorentzConnectionVelocity)
    (targetVelocity : CoframeVelocity)
    (hConnection : forall direction component,
      Tendsto (fun n => linkVariation n (center n) direction component)
        atTop (nhds (targetConnection direction component)))
    (hVelocity : forall direction row column,
      Tendsto
        (fun n => backwardCoframeVelocity (shift n) (coframeVariation n)
          (center n) direction row column)
        atTop (nhds (targetVelocity direction row column)))
    (hConsistent :
      ChangingCarrierNeighborConsistent shift linkVariation center)
    (hAsymptoticallyStationary : forall direction component,
      Tendsto
        (fun n => deriv (fun t => nonlinearLinkEulerCoefficient (shift n)
          (exponentialLinkCurve (identityConnection (Site n))
            (linkVariation n) t)
          (coframeLine (identityCoframeField (Site n))
            (coframeVariation n) t)
          (center n) direction component) 0)
        atTop (nhds 0)) :
    LinearizedCovariantTorsionFree
      (1 : Matrix (Fin 4) (Fin 4) Real) targetConnection targetVelocity := by
  apply (linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
    (1 : Matrix (Fin 4) (Fin 4) Real) 1 (by simp)
    targetConnection targetVelocity).mp
  intro direction component
  have hResidual := linearizedAffineCovariantPalatiniResidual_tendsto
    (1 : Matrix (Fin 4) (Fin 4) Real)
    (fun n connectionDirection =>
      linkVariation n (center n) connectionDirection)
    targetConnection
    (fun n => backwardCoframeVelocity (shift n) (coframeVariation n)
      (center n))
    targetVelocity hConnection hVelocity direction
  have hTransported : Tendsto
      (fun n => transportApply lorentzBivectorFundamentalSymmetry.matrix
        (linearizedAffineCovariantPalatiniResidual
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (fun connectionDirection =>
            linkVariation n (center n) connectionDirection)
          (backwardCoframeVelocity (shift n) (coframeVariation n) (center n))
          direction))
      atTop
      (nhds (transportApply lorentzBivectorFundamentalSymmetry.matrix
        (linearizedAffineCovariantPalatiniResidual
          (1 : Matrix (Fin 4) (Fin 4) Real) targetConnection targetVelocity
          direction))) := by
    simpa only [transportApply_eq_mulVec, Matrix.mulVecLin_apply] using
      (lorentzBivectorFundamentalSymmetry.matrix.mulVecLin.toContinuousLinearMap
        |>.continuous.tendsto _ |>.comp hResidual)
  have hRaisedVectorZero :
      transportApply lorentzBivectorFundamentalSymmetry.matrix
        (linearizedAffineCovariantPalatiniResidual
          (1 : Matrix (Fin 4) (Fin 4) Real) targetConnection targetVelocity
          direction) = 0 := by
    funext index
    have hRaised := tendsto_pi_nhds.mp hTransported index
    let defectSequence : Nat -> Real := fun n =>
      nonuniformConnectionDefect (shift n) (linkVariation n) (center n)
        direction index
    let derivativeSequence : Nat -> Real := fun n =>
      deriv (fun t => nonlinearLinkEulerCoefficient (shift n)
        (exponentialLinkCurve (identityConnection (Site n))
          (linkVariation n) t)
        (coframeLine (identityCoframeField (Site n))
          (coframeVariation n) t)
        (center n) direction index) 0
    have hDefect : Tendsto defectSequence atTop (nhds 0) :=
      nonuniformConnectionDefect_tendsto_zero_of_changingCarrier_consistent
        shift linkVariation center hConsistent direction index
    have hDerivative : Tendsto derivativeSequence atTop (nhds 0) :=
      hAsymptoticallyStationary direction index
    have hDifference : Tendsto
        (fun n => defectSequence n - derivativeSequence n)
        atTop (nhds 0) := by
      simpa using hDefect.sub hDerivative
    have hDifferenceEq :
        (fun n => defectSequence n - derivativeSequence n) =
          fun n => 2 * transportApply
            lorentzBivectorFundamentalSymmetry.matrix
            (linearizedAffineCovariantPalatiniResidual
              (1 : Matrix (Fin 4) (Fin 4) Real)
              (fun connectionDirection =>
                linkVariation n (center n) connectionDirection)
              (backwardCoframeVelocity (shift n) (coframeVariation n)
                (center n)) direction) index := by
      funext n
      have hDerivativeAt :=
        (hasDerivAt_nonlinearLinkEulerCoefficient_eq_covariantResidual_add_defect
          (shift n) (linkVariation n) (coframeVariation n) (center n)
          direction index).deriv
      dsimp only [defectSequence, derivativeSequence]
      rw [hDerivativeAt]
      linarith
    rw [hDifferenceEq] at hDifference
    have hTwiceRaised : Tendsto
        (fun n => 2 * transportApply lorentzBivectorFundamentalSymmetry.matrix
          (linearizedAffineCovariantPalatiniResidual
            (1 : Matrix (Fin 4) (Fin 4) Real)
            (fun connectionDirection =>
              linkVariation n (center n) connectionDirection)
            (backwardCoframeVelocity (shift n) (coframeVariation n) (center n))
            direction) index)
        atTop
        (nhds (2 * transportApply lorentzBivectorFundamentalSymmetry.matrix
          (linearizedAffineCovariantPalatiniResidual
            (1 : Matrix (Fin 4) (Fin 4) Real) targetConnection targetVelocity
            direction) index)) := by
      simpa using tendsto_const_nhds.mul hRaised
    have hTargetZero :
        2 * transportApply lorentzBivectorFundamentalSymmetry.matrix
          (linearizedAffineCovariantPalatiniResidual
            (1 : Matrix (Fin 4) (Fin 4) Real) targetConnection targetVelocity
            direction) index = 0 :=
      tendsto_nhds_unique hTwiceRaised hDifference
    have hRaisedZero :
        transportApply lorentzBivectorFundamentalSymmetry.matrix
          (linearizedAffineCovariantPalatiniResidual
            (1 : Matrix (Fin 4) (Fin 4) Real) targetConnection targetVelocity
            direction) index = 0 :=
      (mul_eq_zero.mp hTargetZero).resolve_left (by norm_num)
    simpa only [Pi.zero_apply] using hRaisedZero
  exact congrFun
    ((transportApply_fundamentalSymmetry_eq_zero_iff _).mp hRaisedVectorZero)
    component

/-! ## Differentiable tetrads sampled on affine predecessor stencils -/

/-- Scale a sampled tetrad displacement by the inverse mesh spacing.  The
center value is subtracted before scaling, so a pointed center sample is zero. -/
def sampledScaledCoframeVariation
    {Site : Nat -> Type*} {Chart : Type*}
    [AddCommGroup Chart] [Module Real Chart]
    (inverseSpacing : Nat -> Real)
    (tetrad : Chart -> Matrix (Fin 4) (Fin 4) Real)
    (position : (n : Nat) -> Site n -> Chart) (point : Chart)
    (n : Nat) : CoframeField (Site n) :=
  fun site => inverseSpacing n • (tetrad (position n site) - tetrad point)

/-- A pointed stencil whose predecessor sites lie on specified affine rays at
inverse-spacing parameter.  Physical backward directions normally use tangent
vectors with the corresponding minus sign. -/
structure PointedAffinePredecessorStencil
    {Site : Nat -> Type*} {Chart : Type*}
    [NormedAddCommGroup Chart] [NormedSpace Real Chart]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (position : (n : Nat) -> Site n -> Chart)
    (center : (n : Nat) -> Site n) (point : Chart)
    (inverseSpacing : Nat -> Real) (tangent : Fin 4 -> Chart) : Prop where
  toPointed : PointedChangingCarrierStencil shift position center point
  predecessor_eq : forall n direction,
    position n ((shift n direction).symm (center n)) =
      point + (inverseSpacing n)⁻¹ • tangent direction

/-- Limit coframe velocity supplied by the Frechet derivative of the tetrad
along the four predecessor tangent vectors. -/
def sampledCoframeVelocityLimit
    {Chart : Type*} [NormedAddCommGroup Chart] [NormedSpace Real Chart]
    (tetradDerivative : Chart →L[Real] Matrix (Fin 4) (Fin 4) Real)
    (tangent : Fin 4 -> Chart) : CoframeVelocity :=
  fun direction => tetradDerivative (tangent direction)

/-- A differentiable tetrad sampled on affine predecessor rays produces the
componentwise backward coframe-velocity limit used by the Cartan theorem. -/
theorem sampledScaledCoframeVariation_backward_tendsto
    {Site : Nat -> Type*} {Chart : Type*}
    [NormedAddCommGroup Chart] [NormedSpace Real Chart]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (position : (n : Nat) -> Site n -> Chart)
    (center : (n : Nat) -> Site n) (point : Chart)
    (inverseSpacing : Nat -> Real) (tangent : Fin 4 -> Chart)
    (tetrad : Chart -> Matrix (Fin 4) (Fin 4) Real)
    (tetradDerivative : Chart →L[Real] Matrix (Fin 4) (Fin 4) Real)
    (hTetrad : HasFDerivAt tetrad tetradDerivative point)
    (hInverseSpacing : Tendsto (fun n => ‖inverseSpacing n‖) atTop atTop)
    (hStencil : PointedAffinePredecessorStencil shift position center point
      inverseSpacing tangent)
    (direction : Fin 4) :
    Tendsto
      (fun n => backwardCoframeVelocity (shift n)
        (sampledScaledCoframeVariation inverseSpacing tetrad position point n)
        (center n) direction)
      atTop
      (nhds (sampledCoframeVelocityLimit tetradDerivative tangent direction)) := by
  have hDifferenceQuotient :=
    hTetrad.lim (tangent direction) hInverseSpacing
  simpa only [backwardCoframeVelocity, sampledScaledCoframeVariation,
      hStencil.predecessor_eq, hStencil.toPointed.center_eq,
      sub_self, smul_zero, sub_zero, sampledCoframeVelocityLimit] using
    hDifferenceQuotient

/-! ## Joint sampled connection/coframe Cartan endpoint -/

/-- **Differentiable sampled-tetrad Cartan endpoint.**  On changing finite
carriers embedded in a supplied pointed chart, sample a continuous Lorentz
connection and a differentiable tetrad.  If predecessor sites follow the
displayed affine inverse-spacing rays and the identity-background first
variations of the exact nonlinear link-Euler coefficients tend to zero, then
the point connection and the Frechet derivative of the tetrad satisfy the
linearized covariant Cartan equation at that background. -/
theorem
    nonlinearLinkEulerCoefficient_sampledConnectionCoframe_torsionFree
    {Site : Nat -> Type*} [forall n, Fintype (Site n)]
    {Chart : Type*} [NormedAddCommGroup Chart] [NormedSpace Real Chart]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (position : (n : Nat) -> Site n -> Chart)
    (center : (n : Nat) -> Site n) (point : Chart)
    (inverseSpacing : Nat -> Real) (tangent : Fin 4 -> Chart)
    (connectionField : Chart -> LorentzConnectionVelocity)
    (tetrad : Chart -> Matrix (Fin 4) (Fin 4) Real)
    (tetradDerivative : Chart →L[Real] Matrix (Fin 4) (Fin 4) Real)
    (hConnectionField : ContinuousAt connectionField point)
    (hTetrad : HasFDerivAt tetrad tetradDerivative point)
    (hInverseSpacing : Tendsto (fun n => ‖inverseSpacing n‖) atTop atTop)
    (hStencil : PointedAffinePredecessorStencil shift position center point
      inverseSpacing tangent)
    (hAsymptoticallyStationary : forall direction component,
      Tendsto
        (fun n => deriv (fun t => nonlinearLinkEulerCoefficient (shift n)
          (exponentialLinkCurve (identityConnection (Site n))
            (sampledLinkVariation connectionField position n) t)
          (coframeLine (identityCoframeField (Site n))
            (sampledScaledCoframeVariation inverseSpacing tetrad position
              point n) t)
          (center n) direction component) 0)
        atTop (nhds 0)) :
    LinearizedCovariantTorsionFree
      (1 : Matrix (Fin 4) (Fin 4) Real) (connectionField point)
      (sampledCoframeVelocityLimit tetradDerivative tangent) := by
  apply nonlinearLinkEulerCoefficient_changingCarrier_torsionFree_of_jets_tendsto
    shift (sampledLinkVariation connectionField position)
      (sampledScaledCoframeVariation inverseSpacing tetrad position point)
      center (connectionField point)
      (sampledCoframeVelocityLimit tetradDerivative tangent)
  · intro direction component
    have hCenter :
        (fun n => sampledLinkVariation connectionField position n (center n)
          direction component) =
          fun _ => connectionField point direction component := by
      funext n
      simp only [sampledLinkVariation, hStencil.toPointed.center_eq]
    rw [hCenter]
    exact tendsto_const_nhds
  · intro direction row column
    exact tendsto_pi_nhds.mp
      (tendsto_pi_nhds.mp
        (sampledScaledCoframeVariation_backward_tendsto shift position center
          point inverseSpacing tangent tetrad tetradDerivative hTetrad
          hInverseSpacing hStencil direction) row) column
  · exact sampledLinkVariation_changingCarrierNeighborConsistent
      shift position center point connectionField hConnectionField
      hStencil.toPointed
  · exact hAsymptoticallyStationary

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.linearizedAffineCovariantPalatiniResidual_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linearizedAffineCovariantPalatiniResidual_tendsto

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.nonlinearLinkEulerCoefficient_changingCarrier_torsionFree_of_jets_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearLinkEulerCoefficient_changingCarrier_torsionFree_of_jets_tendsto

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.sampledScaledCoframeVariation_backward_tendsto' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms sampledScaledCoframeVariation_backward_tendsto

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.nonlinearLinkEulerCoefficient_sampledConnectionCoframe_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearLinkEulerCoefficient_sampledConnectionCoframe_torsionFree

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection
