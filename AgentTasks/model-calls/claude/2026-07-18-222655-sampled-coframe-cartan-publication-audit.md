# Claude model call log

## Metadata

- Provider: `Claude CLI`
- Model: `opus`
- Status: `failed`
- Dry run: `False`
- Started: `2026-07-18T22:26:47`
- Finished: `2026-07-18T22:26:55`
- Timeout seconds: `600`
- Max budget USD: `2.50`
- Return code: `1`

## Command

```text
claude -p --bare --model opus --max-budget-usd 2.50 --output-format text --add-dir 'C:\Projects\StandardModel' --tools default --permission-mode bypassPermissions --disallowed-tools 'Edit Write NotebookEdit mcp__neo4j_graph__write-cypher mcp__zotero_write' --mcp-config 'C:\Projects\StandardModel\Scripts\autonomous_loop\review.mcp.json' --strict-mcp-config
```

## Prompt

```text
You are reviewing a Lean 4 result in the PhysicsSM null-edge general-relativity program. The long-term objective is to derive the Einstein equation from null edges. The immediate result is a changing-carrier Cartan/torsion-selection theorem whose connection is sampled from a continuous Lorentz-connection field and whose coframe velocity is derived from a differentiable tetrad by scaled predecessor differences.

Intended mathematical reading:
- finite carriers may change with n;
- a supplied pointed chart embeds only the local stencil read by the nonlinear Euler coefficient;
- predecessor sites lie on supplied affine rays point + c_n^{-1} v_a with |c_n| -> infinity;
- link variations sample a continuous Lorentz-connection field;
- coframe variations are c_n times sampled tetrad displacement from the center;
- actual derivatives of the exact nonlinear finite link-Euler coefficients tend to zero;
- then the limiting point connection and Frechet derivative of the tetrad satisfy the identity-background linearized covariant Cartan equation, hence torsion freedom under the previously proved residual equivalence.

Audit the embedded source, especially nonlinearLinkEulerCoefficient_changingCarrier_torsionFree_of_jets_tendsto, sampledScaledCoframeVariation_backward_tendsto, and nonlinearLinkEulerCoefficient_sampledConnectionCoframe_torsionFree.

Return:
1. Any semantic mismatch, false-shape theorem, vacuity, hidden assumption, sign/scaling problem, or proof that does not establish the intended reading.
2. Whether the asymptotic stationarity hypothesis is a legitimate dynamical premise or merely a disguised restatement of the conclusion.
3. The strongest defensible publication claim and exact caveats.
4. Rank this result against two competing GR-lane candidates: (a) exact finite nonlinear Palatini coframe/link Euler identities plus conditional coframe Einstein limit, and (b) exact periodic vacuum-curvature realizations and joint-stationarity no-go theorems.
5. The smallest next theorem that would most increase publishability.

Be skeptical and precise. Distinguish kernel correctness from physics significance. Do not edit files.

## Verbatim source artifacts under review

These are the ACTUAL files. Base every finding on the real statements and definitions below, not on any paraphrase above. For each theorem under review, explicitly check whether the Lean matches its intended reading, and flag every mismatch.

### PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEulerSampledCoframeTorsion.lean (501 lines)

```lean
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
2. allow both local jets to vary componentwise and converge while the exact
   nonlinear Euler derivatives become stationary;
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
actual nonlinear link-Euler derivatives tend to zero, then the limiting local
jets obey the identity-background covariant Cartan equation. -/
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
displayed affine inverse-spacing rays and the actual nonlinear link-Euler
derivatives tend to zero, then the point connection and the Frechet derivative
of the tetrad satisfy the identity-background linearized covariant Cartan
equation. -/
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

```

### PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEulerChangingCarrierTorsion.lean (756 lines)

```lean
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerNeighborDefect

noncomputable section

/-!
# Changing-carrier Cartan selection from sampled connection fields

The finite nonlinear link-Euler first jet is the covariant Cartan residual plus
an explicit neighboring-link defect.  The preceding fixed-carrier endpoint
made that defect small by multiplying one prescribed neighbor mode by a scalar.
This module replaces that special family by a local changing-carrier sampling
interface.

Only the finite stencil actually read by the Euler coefficient is controlled:
forward neighbors, predecessors, and translated predecessors of a pointed
center.  If their sampled connection values approach the center value, the
exact nonuniform defect tends to zero even when the finite site type changes at
every level.  Stationarity of the actual nonlinear link-Euler derivatives then
forces the limiting center data to obey the linearized Cartan equation.

The final theorem derives the required neighbor consistency from a continuous
Lorentz-connection field sampled on a pointed chart stencil whose sites all
approach one continuum point.  The chart positions and their convergence are
explicit inputs: no bare graph is claimed to canonically supply an embedding,
coframe, spacing, or smooth connection.

Claim labels: conditional changing-carrier asymptotic theorem and sampled-chart
consistency theorem.  Originality tag: `[orig]`.
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
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction

/-! ## Continuity of one identity-background response branch -/

/-- The three varying inputs of one identity-background face response: face,
transport, and holonomy variations. -/
abbrev GeneratorFaceVariations := Fiber 6 × (Fiber 6 × Fiber 6)

/-- One response branch is linear in its three first-order inputs when the
background face and link probe are fixed. -/
def linearizedGeneratorFaceResponseLinear (face probe : Fiber 6) :
    GeneratorFaceVariations →ₗ[Real] Real where
  toFun variations :=
    linearizedGeneratorFaceResponse face variations.1 variations.2.1
      probe variations.2.2
  map_add' left right := by
    exact linearizedGeneratorFaceResponse_add_variations
      face left.1 right.1 left.2.1 right.2.1 probe left.2.2 right.2.2
  map_smul' scalar variations := by
    simpa using linearizedGeneratorFaceResponse_smul_variations
      face variations.1 variations.2.1 probe variations.2.2 scalar

/-- Finite-dimensionality makes one response branch a continuous linear
functional of its first-order inputs. -/
def linearizedGeneratorFaceResponseContinuous (face probe : Fiber 6) :
    GeneratorFaceVariations →L[Real] Real :=
  (linearizedGeneratorFaceResponseLinear face probe).toContinuousLinearMap

@[simp]
theorem linearizedGeneratorFaceResponseContinuous_apply
    (face faceVariation transportVariation probe holonomyVariation : Fiber 6) :
    linearizedGeneratorFaceResponseContinuous face probe
        (faceVariation, transportVariation, holonomyVariation) =
      linearizedGeneratorFaceResponse face faceVariation transportVariation
        probe holonomyVariation :=
  rfl

/-- Componentwise convergence of all three first-order inputs to zero forces
one exact response branch to vanish. -/
theorem linearizedGeneratorFaceResponse_tendsto_zero
    (face probe : Fiber 6)
    (faceVariation transportVariation holonomyVariation : Nat -> Fiber 6)
    (hFace : forall component,
      Tendsto (fun n => faceVariation n component) atTop (nhds 0))
    (hTransport : forall component,
      Tendsto (fun n => transportVariation n component) atTop (nhds 0))
    (hHolonomy : forall component,
      Tendsto (fun n => holonomyVariation n component) atTop (nhds 0)) :
    Tendsto
      (fun n => linearizedGeneratorFaceResponse face (faceVariation n)
        (transportVariation n) probe (holonomyVariation n))
      atTop (nhds 0) := by
  have hFaceField : Tendsto faceVariation atTop (nhds 0) := by
    apply tendsto_pi_nhds.mpr
    exact hFace
  have hTransportField : Tendsto transportVariation atTop (nhds 0) := by
    apply tendsto_pi_nhds.mpr
    exact hTransport
  have hHolonomyField : Tendsto holonomyVariation atTop (nhds 0) := by
    apply tendsto_pi_nhds.mpr
    exact hHolonomy
  have hInputs : Tendsto
      (fun n => (faceVariation n, transportVariation n,
        holonomyVariation n)) atTop
      (nhds (0 : GeneratorFaceVariations)) :=
    hFaceField.prodMk_nhds
      (hTransportField.prodMk_nhds hHolonomyField)
  simpa only [linearizedGeneratorFaceResponseContinuous_apply, map_zero] using
    (linearizedGeneratorFaceResponseContinuous face probe).continuous
      |>.tendsto (0 : GeneratorFaceVariations) |>.comp hInputs

/-! ## Local consistency on changing finite carriers -/

/-- The exact local consistency data needed by the neighbor defect.  Only the
three classes of stencil sites appearing in `nonuniformConnectionDefect` are
required to approach the center connection value.  No condition is imposed at
unrelated sites of the changing carrier. -/
structure ChangingCarrierNeighborConsistent
    {Site : Nat -> Type*}
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (linkVariation : (n : Nat) -> LinkVariation (Site n))
    (center : (n : Nat) -> Site n) : Prop where
  forward : forall first direction component,
    Tendsto
      (fun n => linkNeighborDifference (linkVariation n) (center n)
        (shift n first (center n)) direction component)
      atTop (nhds 0)
  predecessor : forall first direction component,
    Tendsto
      (fun n => linkNeighborDifference (linkVariation n) (center n)
        ((shift n first).symm (center n)) direction component)
      atTop (nhds 0)
  translatedPredecessor : forall first second direction component,
    Tendsto
      (fun n => linkNeighborDifference (linkVariation n) (center n)
        (shift n second ((shift n first).symm (center n)))
        direction component)
      atTop (nhds 0)

/-- Forward-neighbor consistency packaged as convergence of the full
six-component connection value. -/
theorem ChangingCarrierNeighborConsistent.forwardFiber
    {Site : Nat -> Type*}
    {shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n)}
    {linkVariation : (n : Nat) -> LinkVariation (Site n)}
    {center : (n : Nat) -> Site n}
    (h : ChangingCarrierNeighborConsistent shift linkVariation center)
    (first direction : Fin 4) :
    Tendsto
      (fun n => linkNeighborDifference (linkVariation n) (center n)
        (shift n first (center n)) direction)
      atTop (nhds 0) := by
  apply tendsto_pi_nhds.mpr
  exact h.forward first direction

/-- Predecessor consistency packaged as convergence of the full
six-component connection value. -/
theorem ChangingCarrierNeighborConsistent.predecessorFiber
    {Site : Nat -> Type*}
    {shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n)}
    {linkVariation : (n : Nat) -> LinkVariation (Site n)}
    {center : (n : Nat) -> Site n}
    (h : ChangingCarrierNeighborConsistent shift linkVariation center)
    (first direction : Fin 4) :
    Tendsto
      (fun n => linkNeighborDifference (linkVariation n) (center n)
        ((shift n first).symm (center n)) direction)
      atTop (nhds 0) := by
  apply tendsto_pi_nhds.mpr
  exact h.predecessor first direction

/-- Translated-predecessor consistency packaged as convergence of the full
six-component connection value. -/
theorem ChangingCarrierNeighborConsistent.translatedPredecessorFiber
    {Site : Nat -> Type*}
    {shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n)}
    {linkVariation : (n : Nat) -> LinkVariation (Site n)}
    {center : (n : Nat) -> Site n}
    (h : ChangingCarrierNeighborConsistent shift linkVariation center)
    (first second direction : Fin 4) :
    Tendsto
      (fun n => linkNeighborDifference (linkVariation n) (center n)
        (shift n second ((shift n first).symm (center n))) direction)
      atTop (nhds 0) := by
  apply tendsto_pi_nhds.mpr
  exact h.translatedPredecessor first second direction

/-- **Changing-carrier defect convergence.**  Local consistency on exactly the
finite Euler stencil forces every component of the explicit neighboring-link
defect to vanish, with no common finite site type required. -/
theorem nonuniformConnectionDefect_tendsto_zero_of_changingCarrier_consistent
    {Site : Nat -> Type*} [forall n, Fintype (Site n)]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (linkVariation : (n : Nat) -> LinkVariation (Site n))
    (center : (n : Nat) -> Site n)
    (hConsistent :
      ChangingCarrierNeighborConsistent shift linkVariation center)
    (direction : Fin 4) (component : Fin 6) :
    Tendsto
      (fun n => nonuniformConnectionDefect (shift n) (linkVariation n)
        (center n) direction component)
      atTop (nhds 0) := by
  let probe : Fiber 6 := Pi.single component (1 : Real)
  have hFirst : Tendsto
      (fun n => Finset.sum Finset.univ (fun b =>
        linearizedGeneratorFaceResponse
          (identityPalatiniFaceCoordinates direction b) 0 0 probe
          (linkNeighborDifference (linkVariation n) (center n)
              (shift n direction (center n)) b -
            linkNeighborDifference (linkVariation n) (center n)
              (shift n b (center n)) direction)))
      atTop (nhds 0) := by
    have hTerm (b : Fin 4) : Tendsto
        (fun n => linearizedGeneratorFaceResponse
          (identityPalatiniFaceCoordinates direction b) 0 0 probe
          (linkNeighborDifference (linkVariation n) (center n)
              (shift n direction (center n)) b -
            linkNeighborDifference (linkVariation n) (center n)
              (shift n b (center n)) direction))
        atTop (nhds 0) := by
      apply linearizedGeneratorFaceResponse_tendsto_zero
        (identityPalatiniFaceCoordinates direction b) probe
        (fun _ => 0) (fun _ => 0)
        (fun n =>
          linkNeighborDifference (linkVariation n) (center n)
              (shift n direction (center n)) b -
            linkNeighborDifference (linkVariation n) (center n)
              (shift n b (center n)) direction)
      · intro inputComponent
        exact tendsto_const_nhds
      · intro inputComponent
        exact tendsto_const_nhds
      · intro inputComponent
        simpa using
          (hConsistent.forward direction b inputComponent).sub
            (hConsistent.forward b direction inputComponent)
    simpa using tendsto_finset_sum Finset.univ (fun b _ => hTerm b)
  have hSecond : Tendsto
      (fun n => Finset.sum Finset.univ (fun a =>
        linearizedGeneratorFaceResponse
          (identityPalatiniFaceCoordinates a direction) 0
          (linkNeighborDifference (linkVariation n) (center n)
            ((shift n a).symm (center n)) a)
          probe
          (linkNeighborDifference (linkVariation n) (center n)
              ((shift n a).symm (center n)) a -
            linkNeighborDifference (linkVariation n) (center n)
              ((shift n a).symm (center n)) direction -
            linkNeighborDifference (linkVariation n) (center n)
              (shift n direction ((shift n a).symm (center n))) a)))
      atTop (nhds 0) := by
    have hTerm (a : Fin 4) : Tendsto
        (fun n => linearizedGeneratorFaceResponse
          (identityPalatiniFaceCoordinates a direction) 0
          (linkNeighborDifference (linkVariation n) (center n)
            ((shift n a).symm (center n)) a)
          probe
          (linkNeighborDifference (linkVariation n) (center n)
              ((shift n a).symm (center n)) a -
            linkNeighborDifference (linkVariation n) (center n)
              ((shift n a).symm (center n)) direction -
            linkNeighborDifference (linkVariation n) (center n)
              (shift n direction ((shift n a).symm (center n))) a))
        atTop (nhds 0) := by
      apply linearizedGeneratorFaceResponse_tendsto_zero
        (identityPalatiniFaceCoordinates a direction) probe
        (fun _ => 0)
        (fun n => linkNeighborDifference (linkVariation n) (center n)
          ((shift n a).symm (center n)) a)
        (fun n =>
          linkNeighborDifference (linkVariation n) (center n)
              ((shift n a).symm (center n)) a -
            linkNeighborDifference (linkVariation n) (center n)
              ((shift n a).symm (center n)) direction -
            linkNeighborDifference (linkVariation n) (center n)
              (shift n direction ((shift n a).symm (center n))) a)
      · intro inputComponent
        exact tendsto_const_nhds
      · exact hConsistent.predecessor a a
      · intro inputComponent
        simpa using
          ((hConsistent.predecessor a a inputComponent).sub
            (hConsistent.predecessor a direction inputComponent)).sub
            (hConsistent.translatedPredecessor a direction a inputComponent)
    simpa using tendsto_finset_sum Finset.univ (fun a _ => hTerm a)
  have hThird : Tendsto
      (fun n => Finset.sum Finset.univ (fun a =>
        let curl :=
          linkNeighborDifference (linkVariation n) (center n)
              (shift n a (center n)) direction -
            linkNeighborDifference (linkVariation n) (center n)
              (shift n direction (center n)) a
        linearizedGeneratorFaceResponse
          (identityPalatiniFaceCoordinates a direction) 0 curl probe curl))
      atTop (nhds 0) := by
    have hTerm (a : Fin 4) : Tendsto
        (fun n =>
          let curl :=
            linkNeighborDifference (linkVariation n) (center n)
                (shift n a (center n)) direction -
              linkNeighborDifference (linkVariation n) (center n)
                (shift n direction (center n)) a
          linearizedGeneratorFaceResponse
            (identityPalatiniFaceCoordinates a direction) 0 curl probe curl)
        atTop (nhds 0) := by
      apply linearizedGeneratorFaceResponse_tendsto_zero
        (identityPalatiniFaceCoordinates a direction) probe
        (fun _ => 0)
        (fun n =>
          linkNeighborDifference (linkVariation n) (center n)
              (shift n a (center n)) direction -
            linkNeighborDifference (linkVariation n) (center n)
              (shift n direction (center n)) a)
        (fun n =>
          linkNeighborDifference (linkVariation n) (center n)
              (shift n a (center n)) direction -
            linkNeighborDifference (linkVariation n) (center n)
              (shift n direction (center n)) a)
      · intro inputComponent
        exact tendsto_const_nhds
      · intro inputComponent
        simpa using
          (hConsistent.forward a direction inputComponent).sub
            (hConsistent.forward direction a inputComponent)
      · intro inputComponent
        simpa using
          (hConsistent.forward a direction inputComponent).sub
            (hConsistent.forward direction a inputComponent)
    simpa using tendsto_finset_sum Finset.univ (fun a _ => hTerm a)
  have hFourth : Tendsto
      (fun n => Finset.sum Finset.univ (fun b =>
        let predecessor := (shift n b).symm (center n)
        let transport :=
          linkNeighborDifference (linkVariation n) (center n)
              predecessor direction +
            linkNeighborDifference (linkVariation n) (center n)
              (shift n direction predecessor) b
        linearizedGeneratorFaceResponse
          (identityPalatiniFaceCoordinates direction b) 0 transport probe
          (transport - linkNeighborDifference (linkVariation n) (center n)
            predecessor b)))
      atTop (nhds 0) := by
    have hTerm (b : Fin 4) : Tendsto
        (fun n =>
          let predecessor := (shift n b).symm (center n)
          let transport :=
            linkNeighborDifference (linkVariation n) (center n)
                predecessor direction +
              linkNeighborDifference (linkVariation n) (center n)
                (shift n direction predecessor) b
          linearizedGeneratorFaceResponse
            (identityPalatiniFaceCoordinates direction b) 0 transport probe
            (transport - linkNeighborDifference (linkVariation n) (center n)
              predecessor b))
        atTop (nhds 0) := by
      apply linearizedGeneratorFaceResponse_tendsto_zero
        (identityPalatiniFaceCoordinates direction b) probe
        (fun _ => 0)
        (fun n =>
          linkNeighborDifference (linkVariation n) (center n)
              ((shift n b).symm (center n)) direction +
            linkNeighborDifference (linkVariation n) (center n)
              (shift n direction ((shift n b).symm (center n))) b)
        (fun n =>
          linkNeighborDifference (linkVariation n) (center n)
                ((shift n b).symm (center n)) direction +
              linkNeighborDifference (linkVariation n) (center n)
                (shift n direction ((shift n b).symm (center n))) b -
            linkNeighborDifference (linkVariation n) (center n)
              ((shift n b).symm (center n)) b)
      · intro inputComponent
        exact tendsto_const_nhds
      · intro inputComponent
        simpa using
          (hConsistent.predecessor b direction inputComponent).add
            (hConsistent.translatedPredecessor b direction b inputComponent)
      · intro inputComponent
        simpa using
          ((hConsistent.predecessor b direction inputComponent).add
            (hConsistent.translatedPredecessor b direction b inputComponent)).sub
            (hConsistent.predecessor b b inputComponent)
    simpa using tendsto_finset_sum Finset.univ (fun b _ => hTerm b)
  simpa only [nonuniformConnectionDefect,
      coframeFaceWeight_identity_eq_coordinates, zero_add, sub_zero] using
    ((hFirst.add hSecond).sub hThird).sub hFourth

/-! ## Actual-action Cartan selection on changing carriers -/

/-- **Asymptotic changing-carrier torsion selection.**  The finite carriers
and all off-center connection samples may vary with the refinement level.  If
the center connection value and backward coframe jet are fixed, the exact local
neighbor stencil is asymptotically consistent, and every actual nonlinear link
Euler derivative tends to zero, then the fixed center data obey the linearized
covariant Cartan equation. -/
theorem
    nonlinearLinkEulerCoefficient_changingCarrier_torsionFree_of_deriv_tendsto_zero
    {Site : Nat -> Type*} [forall n, Fintype (Site n)]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (linkVariation : (n : Nat) -> LinkVariation (Site n))
    (coframeVariation : (n : Nat) -> CoframeField (Site n))
    (center : (n : Nat) -> Site n)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (hCenter : forall n direction,
      linkVariation n (center n) direction = connection direction)
    (hVelocity : forall n,
      backwardCoframeVelocity (shift n) (coframeVariation n) (center n) =
        velocity)
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
      (1 : Matrix (Fin 4) (Fin 4) Real) connection velocity := by
  apply (linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
    (1 : Matrix (Fin 4) (Fin 4) Real) 1 (by simp)
    connection velocity).mp
  intro direction component
  have hRaised :
      transportApply lorentzBivectorFundamentalSymmetry.matrix
        (linearizedAffineCovariantPalatiniResidual
          (1 : Matrix (Fin 4) (Fin 4) Real) connection velocity direction) =
        0 := by
    funext index
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
    have hDefect : Tendsto defectSequence atTop (nhds 0) := by
      exact nonuniformConnectionDefect_tendsto_zero_of_changingCarrier_consistent
        shift linkVariation center hConsistent direction index
    have hDerivative : Tendsto derivativeSequence atTop (nhds 0) :=
      hAsymptoticallyStationary direction index
    have hDifference : Tendsto
        (fun n => defectSequence n - derivativeSequence n)
        atTop (nhds 0) := by
      simpa using hDefect.sub hDerivative
    have hDifferenceEq : (fun n => defectSequence n - derivativeSequence n) =
        fun _ =>
        2 * transportApply lorentzBivectorFundamentalSymmetry.matrix
          (linearizedAffineCovariantPalatiniResidual
            (1 : Matrix (Fin 4) (Fin 4) Real) connection velocity direction)
          index := by
      funext n
      have hDerivativeAt :=
        (hasDerivAt_nonlinearLinkEulerCoefficient_eq_covariantResidual_add_defect
          (shift n) (linkVariation n) (coframeVariation n) (center n)
          direction index).deriv
      have hCenterFunction :
          (fun connectionDirection =>
            linkVariation n (center n) connectionDirection) = connection := by
        funext connectionDirection
        exact hCenter n connectionDirection
      rw [hCenterFunction, hVelocity n] at hDerivativeAt
      dsimp only [defectSequence, derivativeSequence]
      rw [hDerivativeAt]
      linarith
    rw [hDifferenceEq] at hDifference
    have hTwiceZero :
        2 * transportApply lorentzBivectorFundamentalSymmetry.matrix
          (linearizedAffineCovariantPalatiniResidual
            (1 : Matrix (Fin 4) (Fin 4) Real) connection velocity direction)
          index = 0 :=
      tendsto_nhds_unique tendsto_const_nhds hDifference
    simp only [Pi.zero_apply]
    linarith
  exact congrFun
    ((transportApply_fundamentalSymmetry_eq_zero_iff _).mp hRaised)
    component

/-- Exact stationarity at every refinement level is a special case of the
asymptotic changing-carrier theorem. -/
theorem nonlinearLinkEulerCoefficient_changingCarrier_torsionFree
    {Site : Nat -> Type*} [forall n, Fintype (Site n)]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (linkVariation : (n : Nat) -> LinkVariation (Site n))
    (coframeVariation : (n : Nat) -> CoframeField (Site n))
    (center : (n : Nat) -> Site n)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (hCenter : forall n direction,
      linkVariation n (center n) direction = connection direction)
    (hVelocity : forall n,
      backwardCoframeVelocity (shift n) (coframeVariation n) (center n) =
        velocity)
    (hConsistent :
      ChangingCarrierNeighborConsistent shift linkVariation center)
    (hStationary : forall n direction component,
      deriv (fun t => nonlinearLinkEulerCoefficient (shift n)
        (exponentialLinkCurve (identityConnection (Site n))
          (linkVariation n) t)
        (coframeLine (identityCoframeField (Site n))
          (coframeVariation n) t)
        (center n) direction component) 0 = 0) :
    LinearizedCovariantTorsionFree
      (1 : Matrix (Fin 4) (Fin 4) Real) connection velocity := by
  apply
    nonlinearLinkEulerCoefficient_changingCarrier_torsionFree_of_deriv_tendsto_zero
      shift linkVariation coframeVariation center connection velocity hCenter
      hVelocity hConsistent
  intro direction component
  have hSequence :
      (fun n => deriv (fun t => nonlinearLinkEulerCoefficient (shift n)
        (exponentialLinkCurve (identityConnection (Site n))
          (linkVariation n) t)
        (coframeLine (identityCoframeField (Site n))
          (coframeVariation n) t)
        (center n) direction component) 0) = fun _ => 0 := by
    funext n
    exact hStationary n direction component
  rw [hSequence]
  exact tendsto_const_nhds

/-! ## Continuous connection fields sampled on a pointed chart stencil -/

/-- Sample a continuum Lorentz-connection field at the chart position assigned
to each site of a changing finite carrier. -/
def sampledLinkVariation
    {Site : Nat -> Type*} {Chart : Type*}
    (connectionField : Chart -> LorentzConnectionVelocity)
    (position : (n : Nat) -> Site n -> Chart)
    (n : Nat) : LinkVariation (Site n) :=
  fun site => connectionField (position n site)

/-- Pointed chart refinement data for exactly the stencil read by one link
Euler coefficient.  The distinguished center is represented by the same chart
point at every level, while all relevant neighboring sites converge to it. -/
structure PointedChangingCarrierStencil
    {Site : Nat -> Type*} {Chart : Type*} [TopologicalSpace Chart]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (position : (n : Nat) -> Site n -> Chart)
    (center : (n : Nat) -> Site n) (point : Chart) : Prop where
  center_eq : forall n, position n (center n) = point
  forward : forall first,
    Tendsto (fun n => position n (shift n first (center n)))
      atTop (nhds point)
  predecessor : forall first,
    Tendsto (fun n => position n ((shift n first).symm (center n)))
      atTop (nhds point)
  translatedPredecessor : forall first second,
    Tendsto
      (fun n => position n
        (shift n second ((shift n first).symm (center n))))
      atTop (nhds point)

/-- Assign every site of every carrier to one chart point.  This is a logical
nonvacuity witness for the pointed-stencil interface, not a nondegenerate
geometric refinement. -/
def constantChartPosition
    {Site : Nat -> Type*} {Chart : Type*} (point : Chart) :
    (n : Nat) -> Site n -> Chart :=
  fun _ _ => point

/-- The pointed-stencil hypotheses are satisfiable for arbitrary changing
finite types and arbitrary shift permutations.  Nondegenerate applications
should instead supply a chart embedding with distinct finite-level sites. -/
theorem pointedChangingCarrierStencil_constantPosition
    {Site : Nat -> Type*} {Chart : Type*} [TopologicalSpace Chart]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (center : (n : Nat) -> Site n) (point : Chart) :
    PointedChangingCarrierStencil shift (constantChartPosition point)
      center point := by
  constructor
  · intro n
    rfl
  · intro first
    exact tendsto_const_nhds
  · intro first
    exact tendsto_const_nhds
  · intro first second
    exact tendsto_const_nhds

/-- Sampling a connection field continuous at the pointed limit produces the
exact local neighbor consistency required by the changing-carrier defect
theorem. -/
theorem sampledLinkVariation_changingCarrierNeighborConsistent
    {Site : Nat -> Type*} {Chart : Type*} [TopologicalSpace Chart]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (position : (n : Nat) -> Site n -> Chart)
    (center : (n : Nat) -> Site n) (point : Chart)
    (connectionField : Chart -> LorentzConnectionVelocity)
    (hField : ContinuousAt connectionField point)
    (hStencil : PointedChangingCarrierStencil shift position center point) :
    ChangingCarrierNeighborConsistent shift
      (sampledLinkVariation connectionField position) center := by
  have hCenterPosition : Tendsto (fun n => position n (center n))
      atTop (nhds point) := by
    convert tendsto_const_nhds using 1
    funext n
    exact hStencil.center_eq n
  have hSample
      (siteSequence : (n : Nat) -> Site n)
      (hPosition : Tendsto (fun n => position n (siteSequence n))
        atTop (nhds point))
      (direction : Fin 4) (component : Fin 6) :
      Tendsto
        (fun n => sampledLinkVariation connectionField position n
          (siteSequence n) direction component)
        atTop (nhds (connectionField point direction component)) := by
    have hConnection : Tendsto
        (fun n => connectionField (position n (siteSequence n)))
        atTop (nhds (connectionField point)) :=
      hField.tendsto.comp hPosition
    exact tendsto_pi_nhds.mp
      (tendsto_pi_nhds.mp hConnection direction) component
  constructor
  · intro first direction component
    simpa only [sampledLinkVariation, linkNeighborDifference,
        sub_self] using
      (hSample (fun n => shift n first (center n))
        (hStencil.forward first) direction component).sub
      (hSample center hCenterPosition direction component)
  · intro first direction component
    simpa only [sampledLinkVariation, linkNeighborDifference,
        sub_self] using
      (hSample (fun n => (shift n first).symm (center n))
        (hStencil.predecessor first) direction component).sub
      (hSample center hCenterPosition direction component)
  · intro first second direction component
    simpa only [sampledLinkVariation, linkNeighborDifference,
        sub_self] using
      (hSample
        (fun n => shift n second ((shift n first).symm (center n)))
        (hStencil.translatedPredecessor first second)
        direction component).sub
      (hSample center hCenterPosition direction component)

/-- **Asymptotic sampled-chart Cartan endpoint.**  Let changing null-edge carriers be
embedded in a pointed chart so that the complete local Euler stencil shrinks to
one point, and sample a Lorentz connection continuous at that point.  If the
backward coframe jet is fixed and every actual nonlinear link-Euler derivative
tends to zero, then the sampled continuum connection and coframe jet satisfy
the linearized covariant Cartan equation at the point.

The theorem derives neighbor-defect convergence from chart sampling.  It does
not construct the chart embedding from causal order, treat a nonidentity
background, or identify the coframe jet with a derivative of a sampled smooth
tetrad. -/
theorem
    nonlinearLinkEulerCoefficient_sampled_changingCarrier_torsionFree_of_deriv_tendsto_zero
    {Site : Nat -> Type*} [forall n, Fintype (Site n)]
    {Chart : Type*} [TopologicalSpace Chart]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (position : (n : Nat) -> Site n -> Chart)
    (center : (n : Nat) -> Site n) (point : Chart)
    (connectionField : Chart -> LorentzConnectionVelocity)
    (coframeVariation : (n : Nat) -> CoframeField (Site n))
    (velocity : CoframeVelocity)
    (hField : ContinuousAt connectionField point)
    (hStencil : PointedChangingCarrierStencil shift position center point)
    (hVelocity : forall n,
      backwardCoframeVelocity (shift n) (coframeVariation n) (center n) =
        velocity)
    (hAsymptoticallyStationary : forall direction component,
      Tendsto
        (fun n => deriv (fun t => nonlinearLinkEulerCoefficient (shift n)
          (exponentialLinkCurve (identityConnection (Site n))
            (sampledLinkVariation connectionField position n) t)
          (coframeLine (identityCoframeField (Site n))
            (coframeVariation n) t)
          (center n) direction component) 0)
        atTop (nhds 0)) :
    LinearizedCovariantTorsionFree
      (1 : Matrix (Fin 4) (Fin 4) Real) (connectionField point) velocity := by
  apply
    nonlinearLinkEulerCoefficient_changingCarrier_torsionFree_of_deriv_tendsto_zero
    shift (sampledLinkVariation connectionField position) coframeVariation
      center (connectionField point) velocity
  · intro n direction
    simp only [sampledLinkVariation, hStencil.center_eq n]
  · exact hVelocity
  · exact sampledLinkVariation_changingCarrierNeighborConsistent
      shift position center point connectionField hField hStencil
  · exact hAsymptoticallyStationary

/-- Exact sampled-chart stationarity at every refinement level is a special
case of the asymptotic sampled-chart Cartan endpoint. -/
theorem nonlinearLinkEulerCoefficient_sampled_changingCarrier_torsionFree
    {Site : Nat -> Type*} [forall n, Fintype (Site n)]
    {Chart : Type*} [TopologicalSpace Chart]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (position : (n : Nat) -> Site n -> Chart)
    (center : (n : Nat) -> Site n) (point : Chart)
    (connectionField : Chart -> LorentzConnectionVelocity)
    (coframeVariation : (n : Nat) -> CoframeField (Site n))
    (velocity : CoframeVelocity)
    (hField : ContinuousAt connectionField point)
    (hStencil : PointedChangingCarrierStencil shift position center point)
    (hVelocity : forall n,
      backwardCoframeVelocity (shift n) (coframeVariation n) (center n) =
        velocity)
    (hStationary : forall n direction component,
      deriv (fun t => nonlinearLinkEulerCoefficient (shift n)
        (exponentialLinkCurve (identityConnection (Site n))
          (sampledLinkVariation connectionField position n) t)
        (coframeLine (identityCoframeField (Site n))
          (coframeVariation n) t)
        (center n) direction component) 0 = 0) :
    LinearizedCovariantTorsionFree
      (1 : Matrix (Fin 4) (Fin 4) Real) (connectionField point) velocity := by
  apply
    nonlinearLinkEulerCoefficient_sampled_changingCarrier_torsionFree_of_deriv_tendsto_zero
      shift position center point connectionField coframeVariation velocity
      hField hStencil hVelocity
  intro direction component
  have hSequence :
      (fun n => deriv (fun t => nonlinearLinkEulerCoefficient (shift n)
        (exponentialLinkCurve (identityConnection (Site n))
          (sampledLinkVariation connectionField position n) t)
        (coframeLine (identityCoframeField (Site n))
          (coframeVariation n) t)
        (center n) direction component) 0) = fun _ => 0 := by
    funext n
    exact hStationary n direction component
  rw [hSequence]
  exact tendsto_const_nhds

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.nonuniformConnectionDefect_tendsto_zero_of_changingCarrier_consistent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonuniformConnectionDefect_tendsto_zero_of_changingCarrier_consistent

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.nonlinearLinkEulerCoefficient_changingCarrier_torsionFree_of_deriv_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearLinkEulerCoefficient_changingCarrier_torsionFree_of_deriv_tendsto_zero

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.nonlinearLinkEulerCoefficient_changingCarrier_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearLinkEulerCoefficient_changingCarrier_torsionFree

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.nonlinearLinkEulerCoefficient_sampled_changingCarrier_torsionFree_of_deriv_tendsto_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearLinkEulerCoefficient_sampled_changingCarrier_torsionFree_of_deriv_tendsto_zero

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.nonlinearLinkEulerCoefficient_sampled_changingCarrier_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearLinkEulerCoefficient_sampled_changingCarrier_torsionFree

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection

```

### PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEulerNeighborDefect.lean (816 lines)

```lean
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelectionCapstone

noncomputable section

/-!
# Nonuniform neighbor defect in the nonlinear link-Euler first jet

The actual nonlinear link-Euler torsion theorem is exact for a site-uniform
connection variation.  This successor removes that hypothesis from the first
jet by displaying the term that survives for a general site-dependent
variation.

At a chosen center site, split the connection variation into its constant
extension from that site and a fluctuation that vanishes there.  The constant
part gives the covariant Cartan residual by the preceding theorem.  The
fluctuation gives the explicit four-corner `nonuniformConnectionDefect` below.
Its formula contains only neighboring-minus-center connection values; it is
independent of the coframe variation and vanishes on every site-uniform
connection jet.

This is an exact identity at the identity coframe and connection.  It does not
yet prove that the defect is small on a graph refinement.  A successor must
equip sampled smooth connection fields with a spacing normalization and prove
the corresponding finite-difference bound before claiming continuum torsion
selection.

Claim label: finite first-jet identity.  Originality tag: `[orig]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection

open Filter Topology
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylNullWave
open PhysicsSM.Draft.NullEdge.PhysicalLorentzPlaquetteRefinement

/-! ## Center extension and neighbor differences -/

/-- Extend the connection variation at one site constantly over the carrier. -/
def constantLinkVariationAt {Site : Type*}
    (linkVariation : LinkVariation Site) (center : Site) :
    LinkVariation Site :=
  fun _ => linkVariation center

/-- Connection value at a site minus the value in the same direction at a
chosen center site. -/
def linkNeighborDifference {Site : Type*}
    (linkVariation : LinkVariation Site) (center site : Site)
    (direction : Fin 4) : Fiber 6 :=
  linkVariation site direction - linkVariation center direction

/-- The connection fluctuation around the constant extension of its value at
the chosen center. -/
def centeredLinkVariation {Site : Type*}
    (linkVariation : LinkVariation Site) (center : Site) :
    LinkVariation Site :=
  fun site direction =>
    linkNeighborDifference linkVariation center site direction

@[simp]
theorem centeredLinkVariation_apply {Site : Type*}
    (linkVariation : LinkVariation Site) (center site : Site)
    (direction : Fin 4) :
    centeredLinkVariation linkVariation center site direction =
      linkNeighborDifference linkVariation center site direction :=
  rfl

@[simp]
theorem constantLinkVariationAt_apply {Site : Type*}
    (linkVariation : LinkVariation Site) (center site : Site)
    (direction : Fin 4) :
    constantLinkVariationAt linkVariation center site direction =
      linkVariation center direction :=
  rfl

@[simp]
theorem linkNeighborDifference_center {Site : Type*}
    (linkVariation : LinkVariation Site) (center : Site)
    (direction : Fin 4) :
    linkNeighborDifference linkVariation center center direction = 0 := by
  simp [linkNeighborDifference]

@[simp]
theorem centeredLinkVariation_center {Site : Type*}
    (linkVariation : LinkVariation Site) (center : Site)
    (direction : Fin 4) :
    centeredLinkVariation linkVariation center center direction = 0 :=
  linkNeighborDifference_center linkVariation center direction

/-- The center extension plus the centered fluctuation recovers the original
connection variation pointwise. -/
theorem constant_add_centeredLinkVariation {Site : Type*}
    (linkVariation : LinkVariation Site) (center : Site) :
    constantLinkVariationAt linkVariation center +
        centeredLinkVariation linkVariation center =
      linkVariation := by
  funext site direction component
  simp [constantLinkVariationAt, centeredLinkVariation,
    linkNeighborDifference]

/-- A site-uniform connection variation has zero centered fluctuation. -/
theorem centeredLinkVariation_eq_zero_of_constant {Site : Type*}
    (linkVariation : LinkVariation Site) (center : Site)
    (hLinkConstant : forall site, linkVariation site = linkVariation center) :
    centeredLinkVariation linkVariation center = 0 := by
  funext site direction component
  change linkVariation site direction component -
    linkVariation center direction component = 0
  rw [show linkVariation site direction component =
      linkVariation center direction component by
    exact congrFun (congrFun (hLinkConstant site) direction) component]
  ring

/-! ## Linearity of the identity-background first jet -/

/-- One coordinate response is additive when all first-order inputs are
added.  The background face and link probe remain fixed. -/
theorem linearizedGeneratorFaceResponse_add_variations
    (face leftFace rightFace leftTransport rightTransport probe
      leftHolonomy rightHolonomy : Fiber 6) :
    linearizedGeneratorFaceResponse face (leftFace + rightFace)
        (leftTransport + rightTransport) probe
        (leftHolonomy + rightHolonomy) =
      linearizedGeneratorFaceResponse face leftFace leftTransport probe
          leftHolonomy +
        linearizedGeneratorFaceResponse face rightFace rightTransport probe
          rightHolonomy := by
  unfold linearizedGeneratorFaceResponse
  rw [lorentzGenerator_add, lorentzGenerator_add, lorentzGenerator_add]
  simp only [Matrix.add_mul, Matrix.mul_add, Matrix.mul_sub, Matrix.trace_add,
    Matrix.trace_sub]
  ring

/-- Additivity when a transport variation is itself the sum of two link
contributions.  The regrouping keeps both left-field contributions together
and both right-field contributions together. -/
theorem linearizedGeneratorFaceResponse_add_twoStepVariations
    (face leftFace rightFace
      leftTransportOne rightTransportOne leftTransportTwo rightTransportTwo
      probe leftHolonomy rightHolonomy : Fiber 6) :
    linearizedGeneratorFaceResponse face (leftFace + rightFace)
        ((leftTransportOne + rightTransportOne) +
          (leftTransportTwo + rightTransportTwo))
        probe (leftHolonomy + rightHolonomy) =
      linearizedGeneratorFaceResponse face leftFace
          (leftTransportOne + leftTransportTwo) probe leftHolonomy +
        linearizedGeneratorFaceResponse face rightFace
          (rightTransportOne + rightTransportTwo) probe rightHolonomy := by
  rw [show (leftTransportOne + rightTransportOne) +
      (leftTransportTwo + rightTransportTwo) =
      (leftTransportOne + leftTransportTwo) +
        (rightTransportOne + rightTransportTwo) by abel]
  exact linearizedGeneratorFaceResponse_add_variations
    face leftFace rightFace
      (leftTransportOne + leftTransportTwo)
      (rightTransportOne + rightTransportTwo)
      probe leftHolonomy rightHolonomy

/-- The additive plaquette curl is additive in its link field. -/
theorem additivePlaquetteCurl_add_local {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site)
    (left right : LinkVariation Site) (site : Site) (a b : Fin 4) :
    additivePlaquetteCurl shift (left + right) site a b =
      additivePlaquetteCurl shift left site a b +
        additivePlaquetteCurl shift right site a b := by
  funext component
  simp [additivePlaquetteCurl]
  ring

/-- The pointwise complementary-face first variation is additive in its
coframe field variation. -/
theorem coframeFaceWeightFirstVariation_add_local {Site : Type*}
    (coframe left right : CoframeField Site) (site : Site) (a b : Fin 4) :
    coframeFaceWeightFirstVariation coframe (left + right) site a b =
      coframeFaceWeightFirstVariation coframe left site a b +
        coframeFaceWeightFirstVariation coframe right site a b := by
  exact complementaryPalatiniFaceWeightFirstVariation_add
    (coframe site) (left site) (right site) a b

@[simp]
theorem coframeFaceWeightFirstVariation_zero_local {Site : Type*}
    (coframe : CoframeField Site) (site : Site) (a b : Fin 4) :
    coframeFaceWeightFirstVariation coframe 0 site a b = 0 := by
  have hAdd := coframeFaceWeightFirstVariation_add_local
    coframe 0 0 site a b
  funext component
  change coframeFaceWeightFirstVariation coframe 0 site a b component =
    (0 : Real)
  have hComponent := congrFun hAdd component
  simp only [zero_add, Pi.add_apply] at hComponent
  linarith

/-- The complete identity-background link Euler first jet is additive in the
simultaneous connection and coframe variations. -/
theorem linearizedLinkEulerFunctional_add
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (leftLink rightLink : LinkVariation Site)
    (leftCoframe rightCoframe : CoframeField Site)
    (site : Site) (direction : Fin 4) (probe : Fiber 6) :
    linearizedLinkEulerFunctional shift (leftLink + rightLink)
        (leftCoframe + rightCoframe) site direction probe =
      linearizedLinkEulerFunctional shift leftLink leftCoframe
          site direction probe +
        linearizedLinkEulerFunctional shift rightLink rightCoframe
          site direction probe := by
  simp_rw [linearizedLinkEulerFunctional_eq_coordinates]
  unfold linearizedLinkEulerFunctionalCoordinates
  simp_rw [coframeFaceWeightFirstVariation_add_local,
    additivePlaquetteCurl_add_local]
  simp only [Pi.add_apply]
  simp_rw [linearizedGeneratorFaceResponse_add_twoStepVariations]
  simp_rw [linearizedGeneratorFaceResponse_add_variations]
  simp only [Finset.sum_add_distrib]
  ring

/-- Coordinate coefficients inherit simultaneous first-jet additivity. -/
theorem linearizedLinkEulerCoefficient_add
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (leftLink rightLink : LinkVariation Site)
    (leftCoframe rightCoframe : CoframeField Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) :
    linearizedLinkEulerCoefficient shift (leftLink + rightLink)
        (leftCoframe + rightCoframe) site direction component =
      linearizedLinkEulerCoefficient shift leftLink leftCoframe
          site direction component +
        linearizedLinkEulerCoefficient shift rightLink rightCoframe
          site direction component :=
  linearizedLinkEulerFunctional_add shift leftLink rightLink
    leftCoframe rightCoframe site direction _

/-- One coordinate response scales when all first-order inputs are scaled.
The background face and link probe remain fixed. -/
theorem linearizedGeneratorFaceResponse_smul_variations
    (face faceVariation transportVariation probe holonomyVariation : Fiber 6)
    (scalar : Real) :
    linearizedGeneratorFaceResponse face (scalar • faceVariation)
        (scalar • transportVariation) probe
        (scalar • holonomyVariation) =
      scalar * linearizedGeneratorFaceResponse face faceVariation
        transportVariation probe holonomyVariation := by
  unfold linearizedGeneratorFaceResponse
  rw [lorentzGenerator_smul, lorentzGenerator_smul, lorentzGenerator_smul]
  simp only [Matrix.smul_mul, Matrix.mul_smul]
  rw [<- smul_sub, <- smul_add, Matrix.mul_smul, <- smul_add,
    Matrix.trace_smul]
  simp only [smul_eq_mul]
  ring

/-- The additive plaquette curl respects scalar multiplication of its link
field. -/
theorem additivePlaquetteCurl_smul_local {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site) (scalar : Real)
    (linkVariation : LinkVariation Site) (site : Site) (a b : Fin 4) :
    additivePlaquetteCurl shift (scalar • linkVariation) site a b =
      scalar • additivePlaquetteCurl shift linkVariation site a b := by
  funext component
  simp [additivePlaquetteCurl]
  ring

/-- The pointwise complementary-face first variation respects scalar
multiplication of its coframe field variation. -/
theorem coframeFaceWeightFirstVariation_smul_local {Site : Type*}
    (coframe : CoframeField Site) (scalar : Real)
    (variation : CoframeField Site) (site : Site) (a b : Fin 4) :
    coframeFaceWeightFirstVariation coframe (scalar • variation) site a b =
      scalar • coframeFaceWeightFirstVariation coframe variation site a b := by
  exact complementaryPalatiniFaceWeightFirstVariation_smul
    (coframe site) (variation site) scalar a b

/-- The complete identity-background link Euler first jet respects
simultaneous real scaling of the connection and coframe variations. -/
theorem linearizedLinkEulerFunctional_smul
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (scalar : Real)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (direction : Fin 4) (probe : Fiber 6) :
    linearizedLinkEulerFunctional shift (scalar • linkVariation)
        (scalar • coframeVariation) site direction probe =
      scalar * linearizedLinkEulerFunctional shift linkVariation
        coframeVariation site direction probe := by
  simp_rw [linearizedLinkEulerFunctional_eq_coordinates]
  unfold linearizedLinkEulerFunctionalCoordinates
  simp_rw [coframeFaceWeightFirstVariation_smul_local,
    additivePlaquetteCurl_smul_local]
  simp only [Pi.smul_apply]
  simp_rw [<- smul_add]
  simp_rw [linearizedGeneratorFaceResponse_smul_variations]
  simp_rw [<- Finset.mul_sum]
  ring

/-- Coordinate coefficients inherit simultaneous first-jet homogeneity. -/
theorem linearizedLinkEulerCoefficient_smul
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (scalar : Real)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) :
    linearizedLinkEulerCoefficient shift (scalar • linkVariation)
        (scalar • coframeVariation) site direction component =
      scalar * linearizedLinkEulerCoefficient shift linkVariation
        coframeVariation site direction component :=
  linearizedLinkEulerFunctional_smul shift scalar linkVariation
    coframeVariation site direction _

/-- Centering commutes with real scaling of a connection variation. -/
theorem centeredLinkVariation_smul {Site : Type*}
    (scalar : Real) (linkVariation : LinkVariation Site) (center : Site) :
    centeredLinkVariation (scalar • linkVariation) center =
      scalar • centeredLinkVariation linkVariation center := by
  funext site direction component
  simp [centeredLinkVariation, linkNeighborDifference]
  ring

/-! ## Explicit nonuniform connection defect -/

/-- The exact four-corner correction produced by neighboring-minus-center
connection values.  Every occurrence of `delta` is a literal finite
difference from the selected center site. -/
def nonuniformConnectionDefect
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) : Real :=
  let identityCoframe := identityCoframeField Site
  let delta := linkNeighborDifference linkVariation site
  let probe : Fiber 6 := Pi.single component (1 : Real)
  Finset.sum Finset.univ (fun b =>
      linearizedGeneratorFaceResponse
        (coframeFaceWeight identityCoframe site direction b)
        0 0 probe
        (delta (shift direction site) b -
          delta (shift b site) direction)) +
    Finset.sum Finset.univ (fun a =>
      let predecessor := (shift a).symm site
      linearizedGeneratorFaceResponse
        (coframeFaceWeight identityCoframe predecessor a direction)
        0 (delta predecessor a) probe
        (delta predecessor a - delta predecessor direction -
          delta (shift direction predecessor) a)) -
    Finset.sum Finset.univ (fun a =>
      let curl := delta (shift a site) direction -
        delta (shift direction site) a
      linearizedGeneratorFaceResponse
        (coframeFaceWeight identityCoframe site a direction)
        0 curl probe curl) -
    Finset.sum Finset.univ (fun b =>
      let predecessor := (shift b).symm site
      let transport := delta predecessor direction +
        delta (shift direction predecessor) b
      linearizedGeneratorFaceResponse
        (coframeFaceWeight identityCoframe predecessor direction b)
        0 transport probe (transport - delta predecessor b))

/-- Curl of the centered fluctuation at its center. -/
theorem additivePlaquetteCurl_centered_center
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site) (site : Site) (a b : Fin 4) :
    additivePlaquetteCurl shift (centeredLinkVariation linkVariation site)
        site a b =
      linkNeighborDifference linkVariation site (shift a site) b -
        linkNeighborDifference linkVariation site (shift b site) a := by
  funext component
  simp [additivePlaquetteCurl, centeredLinkVariation,
    linkNeighborDifference]

/-- Curl of the centered fluctuation at a predecessor in its first
direction. -/
theorem additivePlaquetteCurl_centered_firstPredecessor
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site) (site : Site) (a b : Fin 4) :
    additivePlaquetteCurl shift (centeredLinkVariation linkVariation site)
        ((shift a).symm site) a b =
      linkNeighborDifference linkVariation site ((shift a).symm site) a -
        linkNeighborDifference linkVariation site ((shift a).symm site) b -
        linkNeighborDifference linkVariation site
          (shift b ((shift a).symm site)) a := by
  funext component
  simp [additivePlaquetteCurl, centeredLinkVariation,
    linkNeighborDifference]

/-- Curl of the centered fluctuation at a predecessor in its second
direction. -/
theorem additivePlaquetteCurl_centered_secondPredecessor
    {Site : Type*} (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site) (site : Site) (a b : Fin 4) :
    additivePlaquetteCurl shift (centeredLinkVariation linkVariation site)
        ((shift b).symm site) a b =
      linkNeighborDifference linkVariation site ((shift b).symm site) a +
        linkNeighborDifference linkVariation site
          (shift a ((shift b).symm site)) b -
        linkNeighborDifference linkVariation site ((shift b).symm site) b := by
  funext component
  simp [additivePlaquetteCurl, centeredLinkVariation,
    linkNeighborDifference]

/-- The expanded neighbor formula is exactly the link-Euler response to the
centered connection fluctuation with zero coframe variation. -/
theorem linearizedLinkEulerCoefficient_centered_eq_nonuniformDefect
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) :
    linearizedLinkEulerCoefficient shift
        (centeredLinkVariation linkVariation site) 0
        site direction component =
      nonuniformConnectionDefect shift linkVariation site direction
        component := by
  unfold linearizedLinkEulerCoefficient
  rw [linearizedLinkEulerFunctional_eq_coordinates]
  unfold linearizedLinkEulerFunctionalCoordinates
    nonuniformConnectionDefect
  simp_rw [coframeFaceWeightFirstVariation_zero_local]
  simp_rw [additivePlaquetteCurl_centered_firstPredecessor,
    additivePlaquetteCurl_centered_center,
    additivePlaquetteCurl_centered_secondPredecessor,
    centeredLinkVariation_apply]
  simp only [Equiv.apply_symm_apply,
    linkNeighborDifference_center, add_zero]

/-- **General first-jet decomposition.**  The identity-background link Euler
coefficient is the covariant Cartan residual evaluated at the center-site
connection value, plus the explicit nonuniform neighboring-link defect. -/
theorem linearizedLinkEulerCoefficient_eq_covariantResidual_add_defect
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) :
    linearizedLinkEulerCoefficient shift linkVariation coframeVariation
        site direction component =
      -2 * transportApply lorentzBivectorFundamentalSymmetry.matrix
        (linearizedAffineCovariantPalatiniResidual
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (fun connectionDirection =>
            linkVariation site connectionDirection)
          (backwardCoframeVelocity shift coframeVariation site)
          direction) component +
        nonuniformConnectionDefect shift linkVariation site direction
          component := by
  have hLink := constant_add_centeredLinkVariation linkVariation site
  calc
    linearizedLinkEulerCoefficient shift linkVariation coframeVariation
        site direction component =
      linearizedLinkEulerCoefficient shift
          (constantLinkVariationAt linkVariation site +
            centeredLinkVariation linkVariation site)
          (coframeVariation + 0) site direction component := by
        rw [hLink, add_zero]
    _ = linearizedLinkEulerCoefficient shift
          (constantLinkVariationAt linkVariation site) coframeVariation
          site direction component +
        linearizedLinkEulerCoefficient shift
          (centeredLinkVariation linkVariation site) 0
          site direction component :=
      linearizedLinkEulerCoefficient_add shift
        (constantLinkVariationAt linkVariation site)
        (centeredLinkVariation linkVariation site) coframeVariation 0
        site direction component
    _ = _ := by
      rw [linearizedLinkEulerCoefficient_eq_covariantPalatiniResidual
        shift (constantLinkVariationAt linkVariation site) coframeVariation
        site (fun _ => rfl) direction component,
        linearizedLinkEulerCoefficient_centered_eq_nonuniformDefect]
      rfl

/-- The derivative of the actual nonlinear Euler coefficient has the same
Cartan-plus-neighbor-defect decomposition for every site-dependent connection
variation. -/
theorem hasDerivAt_nonlinearLinkEulerCoefficient_eq_covariantResidual_add_defect
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) :
    HasDerivAt
      (fun t => nonlinearLinkEulerCoefficient shift
        (exponentialLinkCurve (identityConnection Site) linkVariation t)
        (coframeLine (identityCoframeField Site) coframeVariation t)
        site direction component)
      (-2 * transportApply lorentzBivectorFundamentalSymmetry.matrix
        (linearizedAffineCovariantPalatiniResidual
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (fun connectionDirection =>
            linkVariation site connectionDirection)
          (backwardCoframeVelocity shift coframeVariation site)
          direction) component +
        nonuniformConnectionDefect shift linkVariation site direction
          component) 0 := by
  exact (hasDerivAt_nonlinearLinkEulerCoefficient_identity shift
    linkVariation coframeVariation site direction component).congr_deriv
      (linearizedLinkEulerCoefficient_eq_covariantResidual_add_defect
        shift linkVariation coframeVariation site direction component)

/-- The nonuniform defect vanishes identically on site-uniform connection
variations. -/
theorem nonuniformConnectionDefect_eq_zero_of_constant
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site) (site : Site)
    (hLinkConstant : forall x, linkVariation x = linkVariation site)
    (direction : Fin 4) (component : Fin 6) :
    nonuniformConnectionDefect shift linkVariation site direction component =
      0 := by
  have hDelta (x : Site) (a : Fin 4) :
      linkNeighborDifference linkVariation site x a = 0 := by
    funext index
    change linkVariation x a index - linkVariation site a index = 0
    rw [show linkVariation x a index = linkVariation site a index by
      exact congrFun (congrFun (hLinkConstant x) a) index]
    ring
  unfold nonuniformConnectionDefect
  simp_rw [hDelta]
  have hGeneratorZero :
      lorentzGenerator (0 : Fiber 6) = 0 := by
    simpa using lorentzGenerator_smul (0 : Real) (0 : Fiber 6)
  simp [linearizedGeneratorFaceResponse, hGeneratorZero]

/-- Adding a globally constant connection mode does not change any
neighbor-minus-center difference. -/
theorem linkNeighborDifference_add_constant
    {Site : Type*} (linkVariation offset : LinkVariation Site)
    (center site : Site) (direction : Fin 4) :
    linkNeighborDifference
        (linkVariation + constantLinkVariationAt offset center)
        center site direction =
      linkNeighborDifference linkVariation center site direction := by
  funext component
  simp [linkNeighborDifference, constantLinkVariationAt]

/-- The finite defect depends only on nonuniform connection differences: it
is invariant under addition of any site-independent connection mode. -/
theorem nonuniformConnectionDefect_add_constant
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation offset : LinkVariation Site) (site : Site)
    (direction : Fin 4) (component : Fin 6) :
    nonuniformConnectionDefect shift
        (linkVariation + constantLinkVariationAt offset site)
        site direction component =
      nonuniformConnectionDefect shift linkVariation site direction
        component := by
  unfold nonuniformConnectionDefect
  simp_rw [linkNeighborDifference_add_constant]

/-- The nonuniform defect is exactly homogeneous in the amplitude of the
connection variation. -/
theorem nonuniformConnectionDefect_smul
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (scalar : Real)
    (linkVariation : LinkVariation Site) (site : Site)
    (direction : Fin 4) (component : Fin 6) :
    nonuniformConnectionDefect shift (scalar • linkVariation)
        site direction component =
      scalar * nonuniformConnectionDefect shift linkVariation
        site direction component := by
  calc
    nonuniformConnectionDefect shift (scalar • linkVariation)
        site direction component =
      linearizedLinkEulerCoefficient shift
        (centeredLinkVariation (scalar • linkVariation) site) 0
        site direction component :=
      (linearizedLinkEulerCoefficient_centered_eq_nonuniformDefect
        shift (scalar • linkVariation) site direction component).symm
    _ = linearizedLinkEulerCoefficient shift
        (scalar • centeredLinkVariation linkVariation site) 0
        site direction component := by rw [centeredLinkVariation_smul]
    _ = scalar * linearizedLinkEulerCoefficient shift
        (centeredLinkVariation linkVariation site) 0
        site direction component := by
      simpa using linearizedLinkEulerCoefficient_smul shift scalar
        (centeredLinkVariation linkVariation site) 0
        site direction component
    _ = scalar * nonuniformConnectionDefect shift linkVariation
        site direction component := by
      rw [linearizedLinkEulerCoefficient_centered_eq_nonuniformDefect]

/-- A global connection mode plus a scaled nonuniform fluctuation has exactly
the scaled defect of that fluctuation. -/
theorem nonuniformConnectionDefect_constant_add_scaled
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (scalar : Real)
    (linkVariation offset : LinkVariation Site) (site : Site)
    (direction : Fin 4) (component : Fin 6) :
    nonuniformConnectionDefect shift
        (scalar • linkVariation + constantLinkVariationAt offset site)
        site direction component =
      scalar * nonuniformConnectionDefect shift linkVariation
        site direction component := by
  rw [nonuniformConnectionDefect_add_constant,
    nonuniformConnectionDefect_smul]

/-- **Conditional shrinking-nonuniformity endpoint.**  If the amplitude of a
fixed nonuniform connection mode tends to zero, every component of its exact
finite neighbor defect tends to zero.  This theorem supplies the analytic
interface but does not derive the amplitude law from smooth graph sampling. -/
theorem nonuniformConnectionDefect_tendsto_zero_of_scale
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (scale : Nat -> Real) (hScale : Tendsto scale atTop (nhds 0))
    (linkVariation : LinkVariation Site) (site : Site)
    (direction : Fin 4) (component : Fin 6) :
    Tendsto
      (fun n => nonuniformConnectionDefect shift
        (scale n • linkVariation) site direction component)
      atTop (nhds 0) := by
  simp_rw [nonuniformConnectionDefect_smul]
  simpa using hScale.mul_const
    (nonuniformConnectionDefect shift linkVariation site direction component)

/-! ## Shrinking-neighbor torsion selection -/

/-- A prescribed local refinement family: keep the connection value at the
selected center fixed and scale an arbitrary centered neighboring mode. -/
def shrinkingNeighborLinkVariation {Site : Type*}
    (connectionVariation neighborVariation : LinkVariation Site)
    (site : Site) (scalar : Real) : LinkVariation Site :=
  scalar • centeredLinkVariation neighborVariation site +
    constantLinkVariationAt connectionVariation site

@[simp]
theorem shrinkingNeighborLinkVariation_center {Site : Type*}
    (connectionVariation neighborVariation : LinkVariation Site)
    (site : Site) (scalar : Real) (direction : Fin 4) :
    shrinkingNeighborLinkVariation connectionVariation neighborVariation
        site scalar site direction =
      connectionVariation site direction := by
  simp [shrinkingNeighborLinkVariation]

/-- The exact defect of the prescribed local refinement family is the scale
times the defect of its centered neighboring mode. -/
theorem nonuniformConnectionDefect_shrinkingNeighbor
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (connectionVariation neighborVariation : LinkVariation Site)
    (site : Site) (scalar : Real) (direction : Fin 4) (component : Fin 6) :
    nonuniformConnectionDefect shift
        (shrinkingNeighborLinkVariation connectionVariation
          neighborVariation site scalar)
        site direction component =
      scalar * nonuniformConnectionDefect shift
        (centeredLinkVariation neighborVariation site)
        site direction component := by
  unfold shrinkingNeighborLinkVariation
  rw [nonuniformConnectionDefect_add_constant,
    nonuniformConnectionDefect_smul]

/-- The prescribed local refinement defect tends to zero whenever its scale
does. -/
theorem nonuniformConnectionDefect_shrinkingNeighbor_tendsto_zero
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (scale : Nat -> Real) (hScale : Tendsto scale atTop (nhds 0))
    (connectionVariation neighborVariation : LinkVariation Site)
    (site : Site) (direction : Fin 4) (component : Fin 6) :
    Tendsto
      (fun n => nonuniformConnectionDefect shift
        (shrinkingNeighborLinkVariation connectionVariation
          neighborVariation site (scale n))
        site direction component)
      atTop (nhds 0) := by
  simp_rw [nonuniformConnectionDefect_shrinkingNeighbor]
  simpa using hScale.mul_const
    (nonuniformConnectionDefect shift
      (centeredLinkVariation neighborVariation site)
      site direction component)

/-- **Actual-action shrinking-neighbor torsion selection.**  Keep the
connection value and backward coframe jet fixed at one center site, while an
arbitrary centered neighboring connection mode is multiplied by a scale that
tends to zero.  If every actual nonlinear link-Euler derivative is stationary
along that family, the center data obey the linearized covariant Cartan
torsion equation.

This theorem removes exact site uniformity but assumes the displayed
shrinking-neighbor family and stationarity at every refinement level.  It does
not derive such a family from sampled smooth null-edge geometry. -/
theorem nonlinearLinkEulerCoefficient_shrinkingNeighbor_torsionFree
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (scale : Nat -> Real) (hScale : Tendsto scale atTop (nhds 0))
    (connectionVariation neighborVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site) (site : Site)
    (hStationary : forall n direction component,
      deriv (fun t => nonlinearLinkEulerCoefficient shift
        (exponentialLinkCurve (identityConnection Site)
          (shrinkingNeighborLinkVariation connectionVariation
            neighborVariation site (scale n)) t)
        (coframeLine (identityCoframeField Site) coframeVariation t)
        site direction component) 0 = 0) :
    LinearizedCovariantTorsionFree
      (1 : Matrix (Fin 4) (Fin 4) Real)
      (fun connectionDirection =>
        connectionVariation site connectionDirection)
      (backwardCoframeVelocity shift coframeVariation site) := by
  apply (linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
    (1 : Matrix (Fin 4) (Fin 4) Real) 1 (by simp)
    (fun connectionDirection =>
      connectionVariation site connectionDirection)
    (backwardCoframeVelocity shift coframeVariation site)).mp
  intro direction component
  have hRaised :
      transportApply lorentzBivectorFundamentalSymmetry.matrix
        (linearizedAffineCovariantPalatiniResidual
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (fun connectionDirection =>
            connectionVariation site connectionDirection)
          (backwardCoframeVelocity shift coframeVariation site)
          direction) = 0 := by
    funext index
    let defectSequence : Nat -> Real := fun n =>
      nonuniformConnectionDefect shift
        (shrinkingNeighborLinkVariation connectionVariation
          neighborVariation site (scale n))
        site direction index
    have hDefect : Tendsto defectSequence atTop (nhds 0) := by
      exact nonuniformConnectionDefect_shrinkingNeighbor_tendsto_zero
        shift scale hScale connectionVariation neighborVariation site
          direction index
    have hDefectEq : defectSequence = fun _ =>
        2 * transportApply lorentzBivectorFundamentalSymmetry.matrix
          (linearizedAffineCovariantPalatiniResidual
            (1 : Matrix (Fin 4) (Fin 4) Real)
            (fun connectionDirection =>
              connectionVariation site connectionDirection)
            (backwardCoframeVelocity shift coframeVariation site)
            direction) index := by
      funext n
      have hDerivative :=
        (hasDerivAt_nonlinearLinkEulerCoefficient_eq_covariantResidual_add_defect
          shift
          (shrinkingNeighborLinkVariation connectionVariation
            neighborVariation site (scale n))
          coframeVariation site direction index).deriv
      have hStationaryAt := hStationary n direction index
      rw [hDerivative] at hStationaryAt
      simp only [shrinkingNeighborLinkVariation_center] at hStationaryAt
      dsimp only [defectSequence]
      linarith
    rw [hDefectEq] at hDefect
    have hTwiceZero :
        2 * transportApply lorentzBivectorFundamentalSymmetry.matrix
          (linearizedAffineCovariantPalatiniResidual
            (1 : Matrix (Fin 4) (Fin 4) Real)
            (fun connectionDirection =>
              connectionVariation site connectionDirection)
            (backwardCoframeVelocity shift coframeVariation site)
            direction) index = 0 :=
      tendsto_nhds_unique tendsto_const_nhds hDefect
    simp only [Pi.zero_apply]
    linarith
  exact congrFun
    ((transportApply_fundamentalSymmetry_eq_zero_iff _).mp hRaised)
    component

/-! ## Nonzero finite-spacing witness -/

/-- A single noncentral connection component on the period-two null-wave
carrier.  Its value at the selected center site `0` is zero. -/
def nonuniformDefectWitness : LinkVariation NullWaveSite :=
  fun site direction =>
    if site = 1 ∧ direction = 0 then
      Pi.single 0 (1 : Real)
    else
      0

/-- The neighboring-link correction is genuinely nonzero.  For the sparse
period-two witness, one exact Euler component equals `2`. -/
theorem nonuniformConnectionDefect_witness :
    nonuniformConnectionDefect nullWaveShift nonuniformDefectWitness
        0 1 4 = 2 := by
  unfold nonuniformConnectionDefect
  simp_rw [linearizedGeneratorFaceResponse_eq_pairs,
    coframeFaceWeight_identity_eq_coordinates]
  simp +decide [linkNeighborDifference, nonuniformDefectWitness,
    nullWaveShift, toggleFinTwo, identityPalatiniFaceCoordinates,
    lorentzTriplePair, kreinPair,
    lorentzBivectorFundamentalSymmetry_matrix, splitSixMatrix,
    Fin.sum_univ_four]
  ring

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.linearizedLinkEulerCoefficient_eq_covariantResidual_add_defect' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linearizedLinkEulerCoefficient_eq_covariantResidual_add_defect

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.hasDerivAt_nonlinearLinkEulerCoefficient_eq_covariantResidual_add_defect' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms hasDerivAt_nonlinearLinkEulerCoefficient_eq_covariantResidual_add_defect

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.nonuniformConnectionDefect_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonuniformConnectionDefect_witness

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection.nonlinearLinkEulerCoefficient_shrinkingNeighbor_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms nonlinearLinkEulerCoefficient_shrinkingNeighbor_torsionFree

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection

```

### PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEulerTorsionCancellation.lean (147 lines)

```lean
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection

noncomputable section

/-!
# Nonlinear link-Euler first-jet cancellation

This module performs the finite twenty-four component cancellation that
identifies the actual nonlinear link-Euler derivative with the covariant
Palatini residual for a site-uniform connection jet.  Without that hypothesis
the fixed-spacing nonlinear coefficient retains differences of connection
jets at neighboring sites.  It is separated from the curve-derivative
construction so the two large kernel-checked calculations compile
independently.

Claim label: finite first-jet identity.  Originality tag: `[orig]`.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection

open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCurveDerivative
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEinsteinBridge
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEuler
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection
open PhysicsSM.Draft.NullEdge.PeriodicVacuumWeylLinearizedBackreaction

/-- Predecessor-minus-center coframe jet seen by the backward face difference
at one site. -/
def backwardCoframeVelocity {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site) (coframeVariation : CoframeField Site)
    (site : Site) : CoframeVelocity :=
  fun direction =>
    coframeVariation ((shift direction).symm site) - coframeVariation site

set_option maxHeartbeats 50000000 in
/-- **Nonlinear Euler first jet equals covariant Palatini residual.**  The
four nonlinear link-corner families cancel every first-order plaquette
holonomy term for a site-uniform connection jet, leaving minus twice the
Krein-raised covariant residual. -/
theorem linearizedLinkEulerCoefficient_eq_covariantPalatiniResidual
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site)
    (hLinkConstant : forall x, linkVariation x = linkVariation site)
    (direction : Fin 4) (component : Fin 6) :
    linearizedLinkEulerCoefficient shift linkVariation coframeVariation
        site direction component =
      -2 * transportApply lorentzBivectorFundamentalSymmetry.matrix
        (linearizedAffineCovariantPalatiniResidual
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (fun connectionDirection =>
            linkVariation site connectionDirection)
          (backwardCoframeVelocity shift coframeVariation site)
          direction) component := by
  have hLinkField : linkVariation = fun _ => linkVariation site := by
    funext x
    exact hLinkConstant x
  rw [hLinkField]
  unfold linearizedLinkEulerCoefficient
  rw [linearizedLinkEulerFunctional_eq_coordinates]
  unfold linearizedLinkEulerFunctionalCoordinates
  simp_rw [linearizedGeneratorFaceResponse_eq_pairs]
  simp_rw [coframeFaceWeight_identity_eq_coordinates]
  simp_rw [lorentzBivectorFundamentalSymmetry_matrix]
  fin_cases direction <;> fin_cases component <;>
    simp +decide [backwardCoframeVelocity,
      linearizedAffineCovariantPalatiniResidual,
      identityPalatiniFaceCoordinates, lorentzTriplePair,
      explicitPhysicalPalatiniTransportTangent,
      physicalPalatiniTransportTangent_eq_explicit,
      coframeFaceWeightFirstVariation, identityCoframeField,
      complementaryPalatiniFaceWeight,
      complementaryPalatiniFaceWeightFirstVariation,
      palatiniFaceWeight, palatiniFaceWeightFirstVariation,
      coframeWedge, coframeWedgeFirstVariation,
      spacetimeAlternatingSymbol, lorentzHodgeStar,
      additivePlaquetteCurl, splitSixMatrix, splitSixSign,
      kreinPair, transportApply, fiberPair,
      lorentzBivectorFundamentalSymmetry_matrix,
      LorentzBivectorKreinBridge.bivectorFirst,
      LorentzBivectorKreinBridge.bivectorSecond,
      Matrix.one_apply,
      Fin.sum_univ_four, Fin.sum_univ_six] <;>
    ring

/-- The actual nonlinear Euler coefficient has the covariant Palatini
residual as its derivative along simultaneous exact exponential-link and
coframe curves. -/
theorem hasDerivAt_nonlinearLinkEulerCoefficient_eq_covariantPalatiniResidual
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site)
    (linkVariation : LinkVariation Site)
    (coframeVariation : CoframeField Site)
    (site : Site)
    (hLinkConstant : forall x, linkVariation x = linkVariation site)
    (direction : Fin 4) (component : Fin 6) :
    HasDerivAt
      (fun t => nonlinearLinkEulerCoefficient shift
        (exponentialLinkCurve (identityConnection Site) linkVariation t)
        (coframeLine (identityCoframeField Site) coframeVariation t)
        site direction component)
      (-2 * transportApply lorentzBivectorFundamentalSymmetry.matrix
        (linearizedAffineCovariantPalatiniResidual
          (1 : Matrix (Fin 4) (Fin 4) Real)
          (fun connectionDirection =>
            linkVariation site connectionDirection)
          (backwardCoframeVelocity shift coframeVariation site)
          direction) component) 0 := by
  exact (hasDerivAt_nonlinearLinkEulerCoefficient_identity shift
    linkVariation coframeVariation site direction component).congr_deriv
      (linearizedLinkEulerCoefficient_eq_covariantPalatiniResidual shift
        linkVariation coframeVariation site hLinkConstant direction component)

/-- The split-six fundamental symmetry has trivial kernel. -/
theorem transportApply_fundamentalSymmetry_eq_zero_iff
    (field : Fiber 6) :
    transportApply lorentzBivectorFundamentalSymmetry.matrix field = 0 <->
      field = 0 := by
  constructor
  · intro hField
    have hInvolutive := lorentzBivectorFundamentalSymmetry.involutive field
    rw [hField] at hInvolutive
    have hZero :
        transportApply lorentzBivectorFundamentalSymmetry.matrix 0 = 0 := by
      funext component
      simp [transportApply]
    rw [hZero] at hInvolutive
    exact hInvolutive.symm
  · intro hField
    rw [hField]
    funext component
    simp [transportApply]

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniEulerTorsionSelection

```

### PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniAffineConnectionTorsionSelection.lean (662 lines)

```lean
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection

noncomputable section

/-!
# Connection-dependent torsion selection from an affine Lorentz-link tangent

This module introduces the first connection-dependent torsion theorem in the
null-edge Palatini chain.  A six-component Lorentz connection velocity
`omega_b` supplies an infinitesimal four-vector generator and, through the
exterior-square/Hodge transport, an infinitesimal Palatini-face transport.
The Krein adjoint reverses the sign of that generator.  Consequently the
linear coefficient of the backward transported face difference is the
ordinary Palatini coframe response evaluated on

`V_b - lorentzGenerator(omega_b) * e`.

With predecessor increments `V_b = -partial_b e`, vanishing of the resulting
Cartan torsion is the usual equation `de + omega wedge e = 0` up to one overall
sign.  At every coframe with a supplied inverse, the twenty-four affine
connection equations therefore vanish exactly when this connection-dependent
torsion vanishes.

The exact finite affine residual has terms through order three in the spacing:

`h * linear + h^2 * quadratic - h^3 * cubic`.

This is a finite affine-tangent identity and a conditional shrinking-spacing
theorem.  The affine six-fiber transport is not yet an exact exponential
Lorentz link, and this module does not prove equivalence with the full
nonidentity nonlinear link Euler coefficients, nonlinear Levi-Civita
uniqueness, metric compatibility at finite spacing, graph refinement, or a
continuum limit.

Provenance: clean-room finite implementation of the standard first-order
Palatini connection equation `D(e wedge e) = 0 => de + omega wedge e = 0`,
with Kur and Glasser, *Discrete Gravity with Local Lorentz Invariance*
(arXiv:2202.02486, especially their continuum equation (14) and discrete
connection equations (28)-(29)), as the closest action/Euler-equation
comparator.  The definitions are specialized to the repository's
mostly-minus, orientation-`0123`, ordered-bivector, and
predecessor-difference conventions; no source implementation text is copied.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection

open Filter Topology
open PhysicsSM.Draft.NullEdge.CarrierProbeRestrictedLorentzTransition
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzBivectorLieAlgebraBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniGeneralTorsionSelection
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection

/-! ## Infinitesimal Palatini transport -/

/-- Polarized first variation at the identity of the quadratic Palatini
bivector transport. -/
def palatiniBivectorTransportFirstVariation
    (generator : Matrix (Fin 4) (Fin 4) Real) :
    Matrix (Fin 6) (Fin 6) Real :=
  palatiniBivectorTransport (1 + generator) -
    palatiniBivectorTransport 1 - palatiniBivectorTransport generator

/-- Polarized first variation at the identity of the exterior-square
four-vector transport. -/
def wedgeTwoTransportFirstVariation
    (generator : Matrix (Fin 4) (Fin 4) Real) :
    Matrix (Fin 6) (Fin 6) Real :=
  wedgeTwoTransport (1 + generator) -
    wedgeTwoTransport 1 - wedgeTwoTransport generator

/-- Hodge conjugation commutes with taking the polarized first variation. -/
theorem palatiniBivectorTransportFirstVariation_eq_hodgeConjugate
    (generator : Matrix (Fin 4) (Fin 4) Real) :
    palatiniBivectorTransportFirstVariation generator =
      -(lorentzHodgeStar * wedgeTwoTransportFirstVariation generator *
        lorentzHodgeStar) := by
  unfold palatiniBivectorTransportFirstVariation
    wedgeTwoTransportFirstVariation palatiniBivectorTransport
  noncomm_ring

/-- The conjugated Palatini transport of the identity matrix is the identity
on the six-component face fiber. -/
theorem palatiniBivectorTransport_one :
    palatiniBivectorTransport (1 : Matrix (Fin 4) (Fin 4) Real) = 1 := by
  have hWedge :
      wedgeTwoTransport (1 : Matrix (Fin 4) (Fin 4) Real) = 1 := by
    ext row column
    fin_cases row <;> fin_cases column <;>
      simp +decide [wedgeTwoTransport, bivectorFirst, bivectorSecond]
  unfold palatiniBivectorTransport
  rw [hWedge, Matrix.mul_one, lorentzHodgeStar_sq]
  simp

/-- Transport is linear in its matrix argument. -/
theorem transportApply_matrix_sub
    (left right : Matrix (Fin 6) (Fin 6) Real) (field : Fiber 6) :
    transportApply (left - right) field =
      transportApply left field - transportApply right field := by
  funext component
  simp [transportApply, Finset.sum_sub_distrib, sub_mul]

/-- Arbitrary internal basis covariance of an unpolarized Hodge-dual
Palatini face. -/
theorem palatiniFaceWeight_mul_arbitrary
    (matrix coframe : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    palatiniFaceWeight (matrix * coframe) first second =
      transportApply (palatiniBivectorTransport matrix)
        (palatiniFaceWeight coframe first second) := by
  unfold palatiniFaceWeight
  rw [coframeWedge_mul]
  simp only [transportApply_eq_mulVec, Matrix.mulVec_mulVec]
  rw [palatiniBivectorTransport_mul_lorentzHodgeStar]

/-- Arbitrary internal basis covariance of the complementary Palatini face. -/
theorem complementaryPalatiniFaceWeight_mul_arbitrary
    (matrix coframe : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    complementaryPalatiniFaceWeight (matrix * coframe) first second =
      transportApply (palatiniBivectorTransport matrix)
        (complementaryPalatiniFaceWeight coframe first second) := by
  rw [complementaryPalatiniFaceWeight_eq_double_sum,
    complementaryPalatiniFaceWeight_eq_double_sum]
  simp_rw [palatiniFaceWeight_mul_arbitrary]
  exact (transportApply_weightedDoubleSum_fin4
    (palatiniBivectorTransport matrix)
    (fun left right => (1 / 2 : Real) *
      spacetimeAlternatingSymbol left right first second)
    (fun left right => palatiniFaceWeight coframe left right)).symm

/-- The infinitesimal Palatini transport acting on a background face equals
the polarized face response generated by the corresponding internal coframe
change. -/
theorem transportApply_palatiniBivectorTransportFirstVariation
    (generator coframe : Matrix (Fin 4) (Fin 4) Real)
    (first second : Fin 4) :
    transportApply (palatiniBivectorTransportFirstVariation generator)
        (complementaryPalatiniFaceWeight coframe first second) =
      complementaryPalatiniFaceWeightFirstVariation coframe
        (generator * coframe) first second := by
  unfold palatiniBivectorTransportFirstVariation
  rw [transportApply_matrix_sub, transportApply_matrix_sub]
  rw [<- complementaryPalatiniFaceWeight_mul_arbitrary,
    <- complementaryPalatiniFaceWeight_mul_arbitrary,
    <- complementaryPalatiniFaceWeight_mul_arbitrary]
  have hMatrix :
      ((1 : Matrix (Fin 4) (Fin 4) Real) + generator) * coframe =
        coframe + generator * coframe := by
    simp [Matrix.add_mul]
  rw [hMatrix, Matrix.one_mul]
  have hLine := complementaryPalatiniFaceWeight_line coframe
    (generator * coframe) first second 1
  norm_num at hLine
  rw [hLine]
  module

/-- A first connection jet: one six-component Lorentz generator coordinate
for each null-edge direction. -/
abbrev LorentzConnectionVelocity := Fin 4 -> Fiber 6

/-- Physical infinitesimal action of one Lorentz connection coordinate on
the Hodge-dual Palatini face fiber. -/
def physicalPalatiniTransportTangent (connection : Fiber 6) :
    Matrix (Fin 6) (Fin 6) Real :=
  palatiniBivectorTransportFirstVariation (lorentzGenerator connection)

/-- Explicit matrix of the infinitesimal Palatini-face representation in the
ordered rotation-then-boost basis.  Displaying this matrix makes the physical
connection convention and every sign in the Krein audit reviewable. -/
def explicitPhysicalPalatiniTransportTangent (connection : Fiber 6) :
    Matrix (Fin 6) (Fin 6) Real :=
  !![0, -connection 2, connection 1, connection 4, -connection 3, 0;
     connection 2, 0, -connection 0, connection 5, 0, -connection 3;
     -connection 1, connection 0, 0, 0, connection 5, -connection 4;
     connection 4, connection 5, 0, 0, -connection 0, -connection 1;
     -connection 3, 0, connection 5, connection 0, 0, -connection 2;
     0, -connection 3, -connection 4, connection 1, connection 2, 0]

/-- The first variation of the exterior-square transport at a physical
Lorentz generator is the displayed six-dimensional generator. -/
theorem wedgeTwoTransportFirstVariation_lorentzGenerator
    (connection : Fiber 6) :
    wedgeTwoTransportFirstVariation (lorentzGenerator connection) =
      explicitPhysicalPalatiniTransportTangent connection := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp +decide [wedgeTwoTransportFirstVariation,
      explicitPhysicalPalatiniTransportTangent, lorentzGenerator,
      bivectorMatrix, wedgeTwoTransport,
      bivectorFirst, bivectorSecond, MinkowskiConvention.eta]

set_option maxHeartbeats 1000000 in
/-- The displayed six-dimensional Lorentz generator commutes with the
Lorentzian Hodge star. -/
theorem lorentzHodgeStar_mul_explicitPhysicalPalatiniTransportTangent
    (connection : Fiber 6) :
    lorentzHodgeStar * explicitPhysicalPalatiniTransportTangent connection =
      explicitPhysicalPalatiniTransportTangent connection * lorentzHodgeStar := by
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp +decide [explicitPhysicalPalatiniTransportTangent,
      lorentzHodgeStar]

/-- The transport tangent obtained by polarizing the quadratic Hodge/exterior
square construction is exactly the displayed Lorentz-algebra matrix. -/
theorem physicalPalatiniTransportTangent_eq_explicit
    (connection : Fiber 6) :
    physicalPalatiniTransportTangent connection =
      explicitPhysicalPalatiniTransportTangent connection := by
  unfold physicalPalatiniTransportTangent
  rw [palatiniBivectorTransportFirstVariation_eq_hodgeConjugate,
    wedgeTwoTransportFirstVariation_lorentzGenerator]
  rw [lorentzHodgeStar_mul_explicitPhysicalPalatiniTransportTangent,
    Matrix.mul_assoc, lorentzHodgeStar_sq]
  simp

/-- The physical Palatini transport tangent is skew for the derived Krein
metric.  This pins the minus sign in the backward adjoint connection term. -/
theorem physicalPalatiniTransportTangent_kreinSkew
    (connection : Fiber 6) :
    lorentzBivectorFundamentalSymmetry.matrix *
        (physicalPalatiniTransportTangent connection).transpose *
          lorentzBivectorFundamentalSymmetry.matrix =
      -physicalPalatiniTransportTangent connection := by
  rw [lorentzBivectorFundamentalSymmetry_matrix,
    physicalPalatiniTransportTangent_eq_explicit]
  ext row column
  fin_cases row <;> fin_cases column <;>
    simp +decide [explicitPhysicalPalatiniTransportTangent,
      splitSixMatrix, splitSixSign, Matrix.mul_apply,
      Matrix.transpose_apply, Fin.sum_univ_six]

/-- The Krein adjoint of an affine physical transport has the opposite
infinitesimal generator. -/
theorem kreinAdjointApply_one_add_physicalTangent
    (connection : Fiber 6) (spacing : Real) (field : Fiber 6) :
    kreinAdjointApply lorentzBivectorFundamentalSymmetry
        (1 + spacing • physicalPalatiniTransportTangent connection) field =
      field - spacing •
        transportApply (physicalPalatiniTransportTangent connection) field := by
  have hMatrix :
      lorentzBivectorFundamentalSymmetry.matrix *
          (1 + spacing • physicalPalatiniTransportTangent connection).transpose *
            lorentzBivectorFundamentalSymmetry.matrix =
        1 - spacing • physicalPalatiniTransportTangent connection := by
    rw [Matrix.transpose_add, Matrix.transpose_one, Matrix.transpose_smul]
    simp only [Matrix.add_mul, Matrix.mul_add, Matrix.smul_mul,
      Matrix.mul_smul]
    rw [show lorentzBivectorFundamentalSymmetry.matrix *
          (1 : Matrix (Fin 6) (Fin 6) Real) *
            lorentzBivectorFundamentalSymmetry.matrix = 1 by
      simp only [Matrix.mul_one]
      rw [lorentzBivectorFundamentalSymmetry_matrix,
        splitSixMatrix_mul_self]]
    rw [physicalPalatiniTransportTangent_kreinSkew]
    module
  unfold kreinAdjointApply
  rw [transportApply_eq_mulVec, transportAdjointApply_eq_transpose_mulVec,
    transportApply_eq_mulVec]
  simp only [Matrix.mulVec_mulVec]
  rw [<- Matrix.mul_assoc]
  rw [hMatrix, Matrix.sub_mulVec, Matrix.one_mulVec, Matrix.smul_mulVec]
  rfl

/-! ## Connection-dependent linear residual and torsion -/

/-- Coframe first jet after subtracting the infinitesimal forward Lorentz
transport.  With predecessor increments this is minus the usual covariant
coframe derivative. -/
def covariantCoframeVelocity
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity) :
    CoframeVelocity :=
  fun direction =>
    velocity direction - lorentzGenerator (connection direction) * coframe

/-- Cartan torsion including the first-order Lorentz connection term. -/
def linearizedCovariantCartanTorsion
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (internal first second : Fin 4) : Real :=
  linearizedCartanTorsion
    (covariantCoframeVelocity coframe connection velocity)
      internal first second

/-- Every component of the connection-dependent linearized Cartan torsion
vanishes. -/
def LinearizedCovariantTorsionFree
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity)
    (velocity : CoframeVelocity) : Prop :=
  forall internal first second,
    linearizedCovariantCartanTorsion coframe connection velocity
      internal first second = 0

/-- Explicit component shape of `de + omega wedge e`, with the overall sign
fixed by predecessor rather than forward coframe increments. -/
theorem linearizedCovariantCartanTorsion_eq
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (internal first second : Fin 4) :
    linearizedCovariantCartanTorsion coframe connection velocity
        internal first second =
      velocity first internal second - velocity second internal first -
        (lorentzGenerator (connection first) * coframe) internal second +
          (lorentzGenerator (connection second) * coframe) internal first := by
  unfold linearizedCovariantCartanTorsion covariantCoframeVelocity
    linearizedCartanTorsion
  simp only [Matrix.sub_apply]
  ring

/-- Linear coefficient of the affine Krein-backward Palatini residual. -/
def linearizedAffineCovariantPalatiniResidual
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      complementaryPalatiniFaceWeightFirstVariation coframe
          (velocity backwardDirection) direction backwardDirection component -
        transportApply
          (physicalPalatiniTransportTangent (connection backwardDirection))
          (complementaryPalatiniFaceWeight coframe direction backwardDirection)
          component)

/-- The connection term combines with the coframe first jet into the ordinary
Palatini residual of the covariant coframe velocity. -/
theorem linearizedAffineCovariantPalatiniResidual_eq
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (direction : Fin 4) :
    linearizedAffineCovariantPalatiniResidual coframe connection velocity
        direction =
      linearizedPalatiniConnectionResidual coframe
        (covariantCoframeVelocity coframe connection velocity) direction := by
  funext component
  unfold linearizedAffineCovariantPalatiniResidual
    linearizedPalatiniConnectionResidual covariantCoframeVelocity
  apply Finset.sum_congr rfl
  intro backwardDirection _
  unfold physicalPalatiniTransportTangent
  rw [transportApply_palatiniBivectorTransportFirstVariation]
  rw [show velocity backwardDirection -
          lorentzGenerator (connection backwardDirection) * coframe =
        velocity backwardDirection +
          (-1 : Real) •
            (lorentzGenerator (connection backwardDirection) * coframe) by
      module]
  rw [complementaryPalatiniFaceWeightFirstVariation_add,
    complementaryPalatiniFaceWeightFirstVariation_smul]
  simp
  ring

/-- **Affine connection-dependent Palatini equation equals zero torsion.**
At every coframe with a supplied inverse, all twenty-four first-order
Krein-backward connection coefficients vanish exactly when
`de + omega wedge e` vanishes. -/
theorem linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity) :
    (forall direction component,
      linearizedAffineCovariantPalatiniResidual coframe connection velocity
        direction component = 0) <->
      LinearizedCovariantTorsionFree coframe connection velocity := by
  rw [show LinearizedCovariantTorsionFree coframe connection velocity =
      LinearizedTorsionFree
        (covariantCoframeVelocity coframe connection velocity) by rfl]
  simp_rw [linearizedAffineCovariantPalatiniResidual_eq]
  exact linearizedPalatiniConnectionResidual_invertible_iff_torsionFree
    coframe inverseCoframe hLeft
      (covariantCoframeVelocity coframe connection velocity)

/-! ## Exact affine finite-spacing residual -/

/-- Quadratic coefficient in the affine-link finite residual.  Its second
term is the mixed action of the connection tangent on the polarized coframe
face. -/
def quadraticAffineCovariantPalatiniResidual
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      complementaryPalatiniFaceWeight (velocity backwardDirection)
          direction backwardDirection component -
        transportApply
          (physicalPalatiniTransportTangent (connection backwardDirection))
          (complementaryPalatiniFaceWeightFirstVariation coframe
            (velocity backwardDirection) direction backwardDirection)
          component)

/-- Cubic coefficient in the affine-link finite residual.  This is the
connection tangent acting on the face quadratic in the coframe jet. -/
def cubicAffineCovariantPalatiniResidual
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      transportApply
        (physicalPalatiniTransportTangent (connection backwardDirection))
        (complementaryPalatiniFaceWeight (velocity backwardDirection)
          direction backwardDirection) component)

/-- Exact local backward Palatini residual for affine physical link transport
`1 + h A(omega_b)` and predecessor coframe `e + h V_b`. -/
def finiteAffineCovariantPalatiniResidual
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (spacing : Real) (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      kreinAdjointApply lorentzBivectorFundamentalSymmetry
          (1 + spacing • physicalPalatiniTransportTangent
            (connection backwardDirection))
          (complementaryPalatiniFaceWeight
            (coframe + spacing • velocity backwardDirection)
            direction backwardDirection) component -
        complementaryPalatiniFaceWeight coframe direction backwardDirection
          component)

/-- One transported predecessor face has an exact cubic expansion. -/
theorem affineTransportedComplementaryFace_scaled
    (coframe velocity : Matrix (Fin 4) (Fin 4) Real)
    (connection : Fiber 6) (spacing : Real) (first second : Fin 4) :
    kreinAdjointApply lorentzBivectorFundamentalSymmetry
          (1 + spacing • physicalPalatiniTransportTangent connection)
          (complementaryPalatiniFaceWeight
            (coframe + spacing • velocity) first second) -
        complementaryPalatiniFaceWeight coframe first second =
      spacing •
          (complementaryPalatiniFaceWeightFirstVariation coframe velocity
              first second -
            transportApply (physicalPalatiniTransportTangent connection)
              (complementaryPalatiniFaceWeight coframe first second)) +
        spacing ^ 2 •
          (complementaryPalatiniFaceWeight velocity first second -
            transportApply (physicalPalatiniTransportTangent connection)
              (complementaryPalatiniFaceWeightFirstVariation coframe velocity
                first second)) -
        spacing ^ 3 •
          transportApply (physicalPalatiniTransportTangent connection)
            (complementaryPalatiniFaceWeight velocity first second) := by
  rw [kreinAdjointApply_one_add_physicalTangent,
    complementaryPalatiniFaceWeight_line]
  rw [transportApply_add_local, transportApply_add_local,
    transportApply_smul_local, transportApply_smul_local]
  funext component
  simp only [Pi.add_apply, Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
  ring

/-- Exact affine lattice product rule.  Simultaneously varying the quadratic
coframe face and the affine link produces linear, quadratic, and cubic
spacing coefficients and no higher terms. -/
theorem finiteAffineCovariantPalatiniResidual_scaled
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (spacing : Real) (direction : Fin 4) :
    finiteAffineCovariantPalatiniResidual coframe connection velocity spacing
        direction =
      spacing • linearizedAffineCovariantPalatiniResidual coframe connection
          velocity direction +
        spacing ^ 2 • quadraticAffineCovariantPalatiniResidual coframe
          connection velocity direction -
        spacing ^ 3 • cubicAffineCovariantPalatiniResidual connection velocity
          direction := by
  funext component
  unfold finiteAffineCovariantPalatiniResidual
    linearizedAffineCovariantPalatiniResidual
    quadraticAffineCovariantPalatiniResidual
    cubicAffineCovariantPalatiniResidual
  have hTerm (backwardDirection : Fin 4) :
      kreinAdjointApply lorentzBivectorFundamentalSymmetry
            (1 + spacing • physicalPalatiniTransportTangent
              (connection backwardDirection))
            (complementaryPalatiniFaceWeight
              (coframe + spacing • velocity backwardDirection)
              direction backwardDirection) component -
          complementaryPalatiniFaceWeight coframe direction backwardDirection
            component =
        spacing *
            (complementaryPalatiniFaceWeightFirstVariation coframe
                (velocity backwardDirection) direction backwardDirection
                  component -
              transportApply
                (physicalPalatiniTransportTangent
                  (connection backwardDirection))
                (complementaryPalatiniFaceWeight coframe direction
                  backwardDirection) component) +
          spacing ^ 2 *
            (complementaryPalatiniFaceWeight (velocity backwardDirection)
                direction backwardDirection component -
              transportApply
                (physicalPalatiniTransportTangent
                  (connection backwardDirection))
                (complementaryPalatiniFaceWeightFirstVariation coframe
                  (velocity backwardDirection) direction backwardDirection)
                component) -
          spacing ^ 3 *
            transportApply
              (physicalPalatiniTransportTangent
                (connection backwardDirection))
              (complementaryPalatiniFaceWeight (velocity backwardDirection)
                direction backwardDirection) component := by
    have hFace := congrFun
      (affineTransportedComplementaryFace_scaled coframe
      (velocity backwardDirection) (connection backwardDirection) spacing
        direction backwardDirection) component
    simpa only [Pi.add_apply, Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
      using hFace
  simp_rw [hTerm]
  simp only [Pi.add_apply, Pi.sub_apply, Pi.smul_apply, smul_eq_mul]
  simp only [Finset.sum_add_distrib, Finset.sum_sub_distrib]
  simp_rw [<- Finset.mul_sum]
  simp only [Finset.sum_sub_distrib]

/-- Exact affine residuals vanishing along nonzero spacings tending to zero
force the connection-dependent linear coefficient to vanish. -/
theorem finiteAffineCovariantPalatiniResidual_scaled_limit
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (spacing : Nat -> Real) (hNonzero : forall n, spacing n ≠ 0)
    (hToZero : Tendsto spacing atTop (nhds 0))
    (hResidual : forall n direction component,
      finiteAffineCovariantPalatiniResidual coframe connection velocity
        (spacing n) direction component = 0) :
    forall direction component,
      linearizedAffineCovariantPalatiniResidual coframe connection velocity
        direction component = 0 := by
  intro direction component
  let linear := linearizedAffineCovariantPalatiniResidual coframe connection
    velocity direction component
  let quadratic := quadraticAffineCovariantPalatiniResidual coframe connection
    velocity direction component
  let cubic := cubicAffineCovariantPalatiniResidual connection velocity
    direction component
  have hFactor (n : Nat) :
      linear + spacing n * quadratic - spacing n ^ 2 * cubic = 0 := by
    have h := hResidual n direction component
    rw [finiteAffineCovariantPalatiniResidual_scaled] at h
    change spacing n * linear + spacing n ^ 2 * quadratic -
      spacing n ^ 3 * cubic = 0 at h
    have hProduct :
        spacing n *
            (linear + spacing n * quadratic - spacing n ^ 2 * cubic) = 0 := by
      calc
        spacing n *
            (linear + spacing n * quadratic - spacing n ^ 2 * cubic) =
          spacing n * linear + spacing n ^ 2 * quadratic -
            spacing n ^ 3 * cubic := by ring
        _ = 0 := h
    exact (mul_eq_zero.mp hProduct).resolve_left (hNonzero n)
  have hLimit :
      Tendsto
        (fun n => linear + spacing n * quadratic - spacing n ^ 2 * cubic)
        atTop (nhds linear) := by
    simpa [pow_two] using
      (tendsto_const_nhds.add (hToZero.mul tendsto_const_nhds)).sub
        ((hToZero.mul hToZero).mul tendsto_const_nhds)
  have hZero :
      Tendsto
        (fun n => linear + spacing n * quadratic - spacing n ^ 2 * cubic)
        atTop (nhds 0) := by
    convert tendsto_const_nhds using 1
    funext n
    exact hFactor n
  exact tendsto_nhds_unique hLimit hZero

/-- **Affine connection-dependent shrinking-spacing endpoint.**  At a fixed
invertible coframe, exact affine local connection equations along nonzero
shrinking spacings force `de + omega wedge e = 0` for the fixed first jet. -/
theorem finiteAffineCovariantPalatiniResidual_invertible_limit_torsionFree
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (connection : LorentzConnectionVelocity) (velocity : CoframeVelocity)
    (spacing : Nat -> Real) (hNonzero : forall n, spacing n ≠ 0)
    (hToZero : Tendsto spacing atTop (nhds 0))
    (hResidual : forall n direction component,
      finiteAffineCovariantPalatiniResidual coframe connection velocity
        (spacing n) direction component = 0) :
    LinearizedCovariantTorsionFree coframe connection velocity := by
  rw [<- linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
    coframe inverseCoframe hLeft connection velocity]
  exact finiteAffineCovariantPalatiniResidual_scaled_limit coframe connection
    velocity spacing hNonzero hToZero hResidual

/-! ## Explicit nonvacuity family -/

/-- A coframe jet generated entirely by the supplied Lorentz connection has
zero covariant coframe velocity. -/
theorem covariantCoframeVelocity_connectionGenerated
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) :
    covariantCoframeVelocity coframe connection
        (fun direction => lorentzGenerator (connection direction) * coframe) =
      0 := by
  funext direction
  simp [covariantCoframeVelocity]

/-- The connection-generated jet is an explicit family satisfying all
connection-dependent Cartan torsion equations. -/
theorem connectionGeneratedVelocity_covariantTorsionFree
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (connection : LorentzConnectionVelocity) :
    LinearizedCovariantTorsionFree coframe connection
      (fun direction => lorentzGenerator (connection direction) * coframe) := by
  rw [show LinearizedCovariantTorsionFree coframe connection
        (fun direction => lorentzGenerator (connection direction) * coframe) =
      LinearizedTorsionFree
        (covariantCoframeVelocity coframe connection
          (fun direction =>
            lorentzGenerator (connection direction) * coframe)) by rfl]
  rw [covariantCoframeVelocity_connectionGenerated]
  intro internal first second
  simp [linearizedCartanTorsion]

/-- At every supplied invertible coframe, the connection-generated jet gives
an explicit solution of all twenty-four affine linearized Palatini equations.
-/
theorem connectionGeneratedVelocity_affineResidual_zero
    (coframe inverseCoframe : Matrix (Fin 4) (Fin 4) Real)
    (hLeft : inverseCoframe * coframe = 1)
    (connection : LorentzConnectionVelocity) :
    forall direction component,
      linearizedAffineCovariantPalatiniResidual coframe connection
        (fun backwardDirection =>
          lorentzGenerator (connection backwardDirection) * coframe)
        direction component = 0 := by
  rw [linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree
    coframe inverseCoframe hLeft]
  exact connectionGeneratedVelocity_covariantTorsionFree coframe connection

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection.physicalPalatiniTransportTangent_kreinSkew' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms physicalPalatiniTransportTangent_kreinSkew

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection.linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linearizedAffineCovariantPalatiniResidual_invertible_iff_torsionFree

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection.finiteAffineCovariantPalatiniResidual_scaled' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finiteAffineCovariantPalatiniResidual_scaled

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection.finiteAffineCovariantPalatiniResidual_invertible_limit_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finiteAffineCovariantPalatiniResidual_invertible_limit_torsionFree

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection.connectionGeneratedVelocity_affineResidual_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms connectionGeneratedVelocity_affineResidual_zero

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAffineConnectionTorsionSelection

```

### PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniLinearizedTorsionSelection.lean (423 lines)

```lean
import PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniWeakEinsteinLimit

noncomputable section

/-!
# Linearized torsion selection from the null-edge Palatini link equation

The nonlinear null-edge Palatini action has two independent Euler sectors.
The coframe equation is the finite mixed Einstein equation.  The connection
equation is the covariant backward divergence of the complementary coframe
face, the discrete counterpart of `D(e wedge e) = 0`.  This module proves the
missing local torsion content of that second equation at the identity tetrad.

For an arbitrary four-direction coframe velocity, the twenty-four
identity-tetrad linearized Palatini connection coefficients vanish if and only
if all twenty-four independent Cartan torsion components vanish.  The proof is
an exact convention-locked calculation in the project ordering
`(12,13,23,01,02,03)`.

Because the finite residual uses predecessor increments, `velocity direction`
represents the negative continuum directional derivative.  This reverses the
overall sign of the displayed linearized torsion relative to the usual
continuum convention, but leaves its zero locus unchanged.

The exact finite face increment contains one further, quadratic term.  For a
spacing `h` it is

`h * linearized_connection_residual + h^2 * quadratic_defect`.

Consequently, if the exact local equation holds along nonzero spacings tending
to zero with a fixed first coframe jet, that jet is torsion-free.  A final
composition connects this local residual to identity-link stationarity on a
changing family of finite carriers.

This is a finite identity plus a conditional asymptotic theorem.  It does not
prove nonlinear Levi-Civita uniqueness, treat a nonidentity background
connection, construct a graph refinement, control a varying first jet, or
identify the selected links with continuum Levi-Civita transport.

Provenance: clean-room finite implementation of the standard Palatini
connection equation `D(e wedge e) = 0 => T = 0` for a nondegenerate tetrad,
specialized to the repository's mostly-minus metric, orientation `0123`, and
ordered Lorentz-bivector conventions.  The explicit quadratic defect is the
lattice product-rule correction and is project-original.
-/

namespace PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection

open Filter Topology
open PhysicsSM.Draft.NullEdge.FinitePeriodicCoframeKreinPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicCovariantLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkAdjoint
open PhysicsSM.Draft.NullEdge.FinitePeriodicKreinLinkPalatiniVariation
open PhysicsSM.Draft.NullEdge.FinitePeriodicLinkConnection
open PhysicsSM.Draft.NullEdge.LorentzBivectorKreinBridge
open PhysicsSM.Draft.NullEdge.LorentzCoframePalatiniFace
open PhysicsSM.Draft.NullEdge.LorentzPlaquetteTangent
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniAction
open PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniCoframeVariation

/-- A first coframe jet: one internal-by-coordinate matrix for each of the
four null-edge directions. -/
abbrev CoframeVelocity :=
  Fin 4 -> Matrix (Fin 4) (Fin 4) Real

/-- Linearized Cartan torsion of a coframe velocity.  The first index is
internal; the last two are the antisymmetric derivative/coframe directions.
For predecessor increments this is the negative of the usual continuum
linearized torsion, with the same vanishing condition. -/
def linearizedCartanTorsion
    (velocity : CoframeVelocity) (internal first second : Fin 4) : Real :=
  velocity first internal second - velocity second internal first

/-- Every component of the linearized Cartan torsion vanishes. -/
def LinearizedTorsionFree (velocity : CoframeVelocity) : Prop :=
  forall internal first second,
    linearizedCartanTorsion velocity internal first second = 0

/-- Linearized complementary-face divergence at one point.  At the identity
tetrad this is the twenty-four-component Palatini connection equation. -/
def linearizedPalatiniConnectionResidual
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (velocity : CoframeVelocity) (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      complementaryPalatiniFaceWeightFirstVariation coframe
        (velocity backwardDirection) direction backwardDirection component)

/-- The twenty-four independent torsion coordinates in the project bivector
ordering. -/
def linearizedTorsionCoordinate
    (velocity : CoframeVelocity) (internal : Fin 4) (component : Fin 6) : Real :=
  linearizedCartanTorsion velocity internal
    (bivectorFirst component) (bivectorSecond component)

/-- Explicit convention bridge from the twenty-four Cartan torsion
coordinates to the twenty-four identity-tetrad Palatini link coefficients. -/
def identityPalatiniTorsionResidual
    (velocity : CoframeVelocity) : Matrix (Fin 4) (Fin 6) Real :=
  !![-linearizedTorsionCoordinate velocity 0 0,
     -linearizedTorsionCoordinate velocity 0 1,
     -linearizedTorsionCoordinate velocity 0 2,
      linearizedTorsionCoordinate velocity 2 0 +
        linearizedTorsionCoordinate velocity 3 1,
     -linearizedTorsionCoordinate velocity 1 0 +
        linearizedTorsionCoordinate velocity 3 2,
     -linearizedTorsionCoordinate velocity 1 1 -
        linearizedTorsionCoordinate velocity 2 2;
      linearizedTorsionCoordinate velocity 0 4 -
        linearizedTorsionCoordinate velocity 3 2,
      linearizedTorsionCoordinate velocity 0 5 +
        linearizedTorsionCoordinate velocity 2 2,
     -linearizedTorsionCoordinate velocity 1 2,
     -linearizedTorsionCoordinate velocity 2 4 -
        linearizedTorsionCoordinate velocity 3 5,
      linearizedTorsionCoordinate velocity 1 4,
      linearizedTorsionCoordinate velocity 1 5;
     -linearizedTorsionCoordinate velocity 0 3 +
        linearizedTorsionCoordinate velocity 3 1,
     -linearizedTorsionCoordinate velocity 2 1,
      linearizedTorsionCoordinate velocity 0 5 +
        linearizedTorsionCoordinate velocity 1 1,
      linearizedTorsionCoordinate velocity 2 3,
     -linearizedTorsionCoordinate velocity 1 3 -
        linearizedTorsionCoordinate velocity 3 5,
      linearizedTorsionCoordinate velocity 2 5;
     -linearizedTorsionCoordinate velocity 3 0,
     -linearizedTorsionCoordinate velocity 0 3 +
        linearizedTorsionCoordinate velocity 2 0,
     -linearizedTorsionCoordinate velocity 0 4 -
        linearizedTorsionCoordinate velocity 1 0,
      linearizedTorsionCoordinate velocity 3 3,
      linearizedTorsionCoordinate velocity 3 4,
     -linearizedTorsionCoordinate velocity 1 3 -
        linearizedTorsionCoordinate velocity 2 4]

set_option maxHeartbeats 2000000 in
/-- The displayed torsion-coordinate bridge is exactly the project Palatini
coefficient at the identity tetrad. -/
theorem linearizedPalatiniConnectionResidual_identity_eq_torsionResidual
    (velocity : CoframeVelocity) (direction : Fin 4) (component : Fin 6) :
    linearizedPalatiniConnectionResidual 1 velocity direction component =
      identityPalatiniTorsionResidual velocity direction component := by
  fin_cases direction <;> fin_cases component <;>
    simp +decide [linearizedPalatiniConnectionResidual,
      identityPalatiniTorsionResidual, linearizedTorsionCoordinate,
      linearizedCartanTorsion,
      complementaryPalatiniFaceWeightFirstVariation,
      palatiniFaceWeightFirstVariation, coframeWedgeFirstVariation,
      LorentzBivectorKreinBridge.bivectorFirst,
      LorentzBivectorKreinBridge.bivectorSecond,
      spacetimeAlternatingSymbol, lorentzHodgeStar, transportApply,
      Matrix.one_apply, Fin.sum_univ_four, Fin.sum_univ_six] <;>
    ring

/-- **Identity-tetrad Palatini connection equation equals zero torsion.**
The twenty-four linearized link equations are equivalent to the twenty-four
independent Cartan torsion equations. -/
theorem linearizedPalatiniConnectionResidual_identity_iff_torsionFree
    (velocity : CoframeVelocity) :
    (forall direction component,
      linearizedPalatiniConnectionResidual 1 velocity direction component = 0) <->
      LinearizedTorsionFree velocity := by
  classical
  constructor
  · intro hResidual
    have hCoordinate (direction : Fin 4) (component : Fin 6) :
        identityPalatiniTorsionResidual velocity direction component = 0 := by
      rw [<- linearizedPalatiniConnectionResidual_identity_eq_torsionResidual]
      exact hResidual direction component
    have h00 := hCoordinate (0 : Fin 4) (0 : Fin 6)
    have h01 := hCoordinate (0 : Fin 4) (1 : Fin 6)
    have h02 := hCoordinate (0 : Fin 4) (2 : Fin 6)
    have h03 := hCoordinate (0 : Fin 4) (3 : Fin 6)
    have h04 := hCoordinate (0 : Fin 4) (4 : Fin 6)
    have h05 := hCoordinate (0 : Fin 4) (5 : Fin 6)
    have h10 := hCoordinate (1 : Fin 4) (0 : Fin 6)
    have h11 := hCoordinate (1 : Fin 4) (1 : Fin 6)
    have h12 := hCoordinate (1 : Fin 4) (2 : Fin 6)
    have h13 := hCoordinate (1 : Fin 4) (3 : Fin 6)
    have h14 := hCoordinate (1 : Fin 4) (4 : Fin 6)
    have h15 := hCoordinate (1 : Fin 4) (5 : Fin 6)
    have h20 := hCoordinate (2 : Fin 4) (0 : Fin 6)
    have h21 := hCoordinate (2 : Fin 4) (1 : Fin 6)
    have h22 := hCoordinate (2 : Fin 4) (2 : Fin 6)
    have h23 := hCoordinate (2 : Fin 4) (3 : Fin 6)
    have h24 := hCoordinate (2 : Fin 4) (4 : Fin 6)
    have h25 := hCoordinate (2 : Fin 4) (5 : Fin 6)
    have h30 := hCoordinate (3 : Fin 4) (0 : Fin 6)
    have h31 := hCoordinate (3 : Fin 4) (1 : Fin 6)
    have h32 := hCoordinate (3 : Fin 4) (2 : Fin 6)
    have h33 := hCoordinate (3 : Fin 4) (3 : Fin 6)
    have h34 := hCoordinate (3 : Fin 4) (4 : Fin 6)
    have h35 := hCoordinate (3 : Fin 4) (5 : Fin 6)
    simp +decide [identityPalatiniTorsionResidual,
      linearizedTorsionCoordinate, linearizedCartanTorsion,
      LorentzBivectorKreinBridge.bivectorFirst,
      LorentzBivectorKreinBridge.bivectorSecond] at h00 h01 h02 h03 h04 h05 h10 h11 h12 h13 h14 h15 h20 h21 h22 h23 h24 h25 h30 h31 h32 h33 h34 h35
    intro internal first second
    fin_cases internal <;> fin_cases first <;> fin_cases second <;>
      simp [linearizedCartanTorsion] <;> linarith
  · intro hTorsion direction component
    rw [linearizedPalatiniConnectionResidual_identity_eq_torsionResidual]
    simp only [LinearizedTorsionFree] at hTorsion
    fin_cases direction <;> fin_cases component <;>
      simp +decide [identityPalatiniTorsionResidual,
        linearizedTorsionCoordinate, hTorsion]

/-! ## Exact finite defect and shrinking-spacing selection -/

/-- Quadratic product-rule defect in the finite complementary-face
divergence. -/
def quadraticPalatiniConnectionResidual
    (velocity : CoframeVelocity) (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      complementaryPalatiniFaceWeight (velocity backwardDirection)
        direction backwardDirection component)

/-- Exact finite complementary-face increment for four predecessor coframes. -/
def finitePalatiniConnectionResidual
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (increment : CoframeVelocity) (direction : Fin 4) : Fiber 6 :=
  fun component =>
    Finset.sum Finset.univ (fun backwardDirection =>
      complementaryPalatiniFaceWeight
          (coframe + increment backwardDirection)
          direction backwardDirection component -
        complementaryPalatiniFaceWeight coframe
          direction backwardDirection component)

/-- Exact lattice product rule: the finite Palatini connection residual along
a scaled coframe jet is linear in the spacing plus an explicit quadratic
defect. -/
theorem finitePalatiniConnectionResidual_scaled
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (velocity : CoframeVelocity) (spacing : Real) (direction : Fin 4) :
    finitePalatiniConnectionResidual coframe
        (fun backwardDirection => spacing • velocity backwardDirection)
        direction =
      spacing • linearizedPalatiniConnectionResidual coframe velocity direction +
        spacing ^ 2 • quadraticPalatiniConnectionResidual velocity direction := by
  funext component
  unfold finitePalatiniConnectionResidual
    linearizedPalatiniConnectionResidual
    quadraticPalatiniConnectionResidual
  simp_rw [complementaryPalatiniFaceWeight_line]
  simp only [Pi.add_apply, Pi.smul_apply, smul_eq_mul]
  have hTerm (backwardDirection : Fin 4) :
      complementaryPalatiniFaceWeight coframe direction backwardDirection component +
            spacing * complementaryPalatiniFaceWeightFirstVariation coframe
              (velocity backwardDirection) direction backwardDirection component +
          spacing ^ 2 * complementaryPalatiniFaceWeight
            (velocity backwardDirection) direction backwardDirection component -
        complementaryPalatiniFaceWeight coframe direction backwardDirection component =
      spacing * complementaryPalatiniFaceWeightFirstVariation coframe
          (velocity backwardDirection) direction backwardDirection component +
        spacing ^ 2 * complementaryPalatiniFaceWeight
          (velocity backwardDirection) direction backwardDirection component := by
    ring
  simp_rw [hTerm]
  rw [Finset.sum_add_distrib, Finset.mul_sum, Finset.mul_sum]

/-- If the exact finite local connection equation holds along nonzero
spacings tending to zero for one fixed first coframe jet, its linearized
Palatini residual vanishes. -/
theorem finitePalatiniConnectionResidual_scaled_limit
    (coframe : Matrix (Fin 4) (Fin 4) Real)
    (velocity : CoframeVelocity) (spacing : Nat -> Real)
    (hNonzero : forall n, spacing n ≠ 0)
    (hToZero : Tendsto spacing atTop (nhds 0))
    (hResidual : forall n direction component,
      finitePalatiniConnectionResidual coframe
        (fun backwardDirection => spacing n • velocity backwardDirection)
        direction component = 0) :
    forall direction component,
      linearizedPalatiniConnectionResidual coframe velocity direction component = 0 := by
  intro direction component
  let linear :=
    linearizedPalatiniConnectionResidual coframe velocity direction component
  let quadratic :=
    quadraticPalatiniConnectionResidual velocity direction component
  have hFactor (n : Nat) : linear + spacing n * quadratic = 0 := by
    have h := hResidual n direction component
    rw [finitePalatiniConnectionResidual_scaled] at h
    change spacing n * linear + spacing n ^ 2 * quadratic = 0 at h
    have hProduct : spacing n * (linear + spacing n * quadratic) = 0 := by
      calc
        spacing n * (linear + spacing n * quadratic) =
            spacing n * linear + spacing n ^ 2 * quadratic := by ring
        _ = 0 := h
    exact (mul_eq_zero.mp hProduct).resolve_left (hNonzero n)
  have hLimit : Tendsto (fun n => linear + spacing n * quadratic)
      atTop (nhds linear) := by
    simpa using tendsto_const_nhds.add (hToZero.mul tendsto_const_nhds)
  have hZero : Tendsto (fun n => linear + spacing n * quadratic)
      atTop (nhds 0) := by
    convert tendsto_const_nhds using 1
    funext n
    exact hFactor n
  exact tendsto_nhds_unique hLimit hZero

/-- At the identity tetrad, the shrinking-spacing local connection equation
selects a torsion-free first coframe jet. -/
theorem finitePalatiniConnectionResidual_identity_limit_torsionFree
    (velocity : CoframeVelocity) (spacing : Nat -> Real)
    (hNonzero : forall n, spacing n ≠ 0)
    (hToZero : Tendsto spacing atTop (nhds 0))
    (hResidual : forall n direction component,
      finitePalatiniConnectionResidual 1
        (fun backwardDirection => spacing n • velocity backwardDirection)
        direction component = 0) :
    LinearizedTorsionFree velocity := by
  rw [<- linearizedPalatiniConnectionResidual_identity_iff_torsionFree]
  exact finitePalatiniConnectionResidual_scaled_limit 1 velocity spacing
    hNonzero hToZero hResidual

/-! ## Link-equation composition -/

/-- Under identity bivector transport, the exact backward face divergence is
the finite Palatini residual built from predecessor coframe increments. -/
theorem identityTransport_divergence_eq_finitePalatiniConnectionResidual
    {Site : Type*}
    (shift : Fin 4 -> Equiv Site Site) (coframe : CoframeField Site)
    (site : Site) (direction : Fin 4) :
    kreinFaceBackwardDivergence lorentzBivectorFundamentalSymmetry shift
        identityLinkTransport (coframeFaceWeight coframe) site direction =
      finitePalatiniConnectionResidual (coframe site)
        (fun backwardDirection =>
          coframe ((shift backwardDirection).symm site) - coframe site)
        direction := by
  classical
  funext component
  unfold kreinFaceBackwardDivergence finitePalatiniConnectionResidual
    kreinCovariantBackwardAdjoint identityLinkTransport coframeFaceWeight
  simp_rw [kreinAdjointApply_one]
  apply Finset.sum_congr rfl
  intro backwardDirection _
  congr 1
  congr 1
  module

/-- Identity-link stationarity supplies the exact finite local Palatini
residual equation at every site. -/
theorem identityConnectionStationary_finitePalatiniConnectionResidual
    {Site : Type*} [Fintype Site]
    (shift : Fin 4 -> Equiv Site Site) (coframe : CoframeField Site)
    (hStationary : NonlinearCoframePlaquetteConnectionStationary shift
      (identityConnection Site) coframe) :
    forall site direction component,
      finitePalatiniConnectionResidual (coframe site)
        (fun backwardDirection =>
          coframe ((shift backwardDirection).symm site) - coframe site)
        direction component = 0 := by
  have hDivergence :=
    (nonlinearCoframePlaquetteConnectionStationary_identity_iff_divergence
      shift coframe).mp hStationary
  intro site direction component
  rw [<- identityTransport_divergence_eq_finitePalatiniConnectionResidual]
  exact hDivergence site direction component

/-- **Conditional changing-carrier torsion-selection endpoint.**  Let the
carrier, shifts, coframe, and distinguished site vary with the refinement
level.  If every identity-link null-edge Palatini action is connection
stationary and the four predecessor coframes have one fixed first jet at the
distinguished site, then shrinking nonzero spacing forces that jet to be
Cartan torsion-free.

The fixed-jet premise is deliberately explicit.  Proving compactness and
convergence for a varying graph-derived jet remains a separate gate. -/
theorem identityConnectionStationary_refinement_linearizedTorsionFree
    {Site : Nat -> Type*} [forall n, Fintype (Site n)]
    (shift : (n : Nat) -> Fin 4 -> Equiv (Site n) (Site n))
    (coframe : (n : Nat) -> CoframeField (Site n))
    (site : (n : Nat) -> Site n)
    (velocity : CoframeVelocity) (spacing : Nat -> Real)
    (hNonzero : forall n, spacing n ≠ 0)
    (hToZero : Tendsto spacing atTop (nhds 0))
    (hCenter : forall n, coframe n (site n) = 1)
    (hPredecessor : forall n direction,
      coframe n ((shift n direction).symm (site n)) =
        1 + spacing n • velocity direction)
    (hStationary : forall n,
      NonlinearCoframePlaquetteConnectionStationary (shift n)
        (identityConnection (Site n)) (coframe n)) :
    LinearizedTorsionFree velocity := by
  apply finitePalatiniConnectionResidual_identity_limit_torsionFree
    velocity spacing hNonzero hToZero
  intro n direction component
  have hLocal :=
    identityConnectionStationary_finitePalatiniConnectionResidual
      (shift n) (coframe n) (hStationary n) (site n) direction component
  rw [hCenter n] at hLocal
  have hIncrement :
      (fun backwardDirection =>
        coframe n ((shift n backwardDirection).symm (site n)) - 1) =
        fun backwardDirection => spacing n • velocity backwardDirection := by
    funext backwardDirection
    rw [hPredecessor n backwardDirection]
    module
  rw [hIncrement] at hLocal
  exact hLocal

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection.linearizedPalatiniConnectionResidual_identity_iff_torsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms linearizedPalatiniConnectionResidual_identity_iff_torsionFree

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection.finitePalatiniConnectionResidual_scaled_limit' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms finitePalatiniConnectionResidual_scaled_limit

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection.identityConnectionStationary_finitePalatiniConnectionResidual' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms identityConnectionStationary_finitePalatiniConnectionResidual

/-- info: 'PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection.identityConnectionStationary_refinement_linearizedTorsionFree' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms identityConnectionStationary_refinement_linearizedTorsionFree

end PhysicsSM.Draft.NullEdge.NonlinearLorentzPalatiniLinearizedTorsionSelection

```

## Final instruction

Produce your review now, strictly in the Required output format specified above.
```

## Response stdout

```text
Credit balance is too low

```

## Response stderr

```text

```
