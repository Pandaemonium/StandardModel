# Gemini model call log

## Metadata

- Provider: `Gemini REST API`
- Model: `gemini-3.1-pro-preview`
- Status: `completed`
- Dry run: `False`
- Started: `2026-07-18T22:27:13`
- Finished: `2026-07-18T22:28:48`
- Timeout seconds: `600`
- Max output tokens: `12000`

## Endpoint

```text
https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-pro-preview:generateContent
```

The API key is intentionally not logged.

## Prompt

```text
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


The packet is a failed Claude review log. Ignore its failed Response stdout/stderr; perform the requested Lean semantic and publication audit yourself from the embedded prompt and verbatim sources. Do not edit files.
```

## Extracted response text

```text
**1. Semantic Mismatch, Hidden Assumptions, and Proof Audit**
*   **Kernel Correctness:** The Lean code is mathematically sound and faithfully implements the intended reading. The scaling of the coframe variation by the inverse spacing $c_n$ (`sampledScaledCoframeVariation`) is a clever and correct way to extract the directional derivative (the Frechet derivative), perfectly balancing the dimensions with the order-1 connection samples. The defect term (`nonuniformConnectionDefect`) is correctly shown to be of order $\mathcal{O}(c_n^{-1})$ and vanishes in the limit.
*   **Hidden Assumption (Linearization):** The theorem evaluates the *derivative* of the nonlinear Euler coefficient at $t=0$ around the identity background (`identityConnection`, `identityCoframeField`). This means it only establishes the *linearized* (weak-field) Cartan torsion-free condition, not the full nonlinear connection equation. The prompt's phrase "actual derivatives of the exact nonlinear finite link-Euler coefficients" is technically accurate but risks masking the fact that this is strictly a linearized weak-field limit.
*   **Lattice Embedding:** The `PointedAffinePredecessorStencil` assumes the predecessor sites lie exactly on straight affine rays $point + c_n^{-1} v_a$. This is a rigid geometric assumption, though standard and acceptable for local consistency proofs.
*   **Sign Convention:** As documented in the source, using predecessor differences yields $-(\partial_\mu e + \omega_\mu e) = 0$. This reverses the overall sign relative to the standard continuum equation $de + \omega \wedge e = 0$, but correctly leaves the zero locus unchanged.

**2. Legitimacy of the Asymptotic Stationarity Hypothesis**
It is a legitimate dynamical premise for a *consistency* theorem. In numerical analysis and discrete physics, assuming that the discrete operator evaluated on smooth samples tends to zero (i.e., the truncation error vanishes) is the standard definition of consistency. It implies that the continuum operator evaluated on those same samples must be zero. It is not a disguised restatement of the conclusion, but rather the standard, rigorous bridge proving that the discrete equations faithfully represent the continuum equations in the limit.

**3. Strongest Defensible Publication Claim and Caveats**

```

## Raw response JSON

```json
{
  "candidates": [
    {
      "content": {
        "parts": [
          {
            "text": "**1. Semantic Mismatch, Hidden Assumptions, and Proof Audit**\n*   **Kernel Correctness:** The Lean code is mathematically sound and faithfully implements the intended reading. The scaling of the coframe variation by the inverse spacing $c_n$ (`sampledScaledCoframeVariation`) is a clever and correct way to extract the directional derivative (the Frechet derivative), perfectly balancing the dimensions with the order-1 connection samples. The defect term (`nonuniformConnectionDefect`) is correctly shown to be of order $\\mathcal{O}(c_n^{-1})$ and vanishes in the limit.\n*   **Hidden Assumption (Linearization):** The theorem evaluates the *derivative* of the nonlinear Euler coefficient at $t=0$ around the identity background (`identityConnection`, `identityCoframeField`). This means it only establishes the *linearized* (weak-field) Cartan torsion-free condition, not the full nonlinear connection equation. The prompt's phrase \"actual derivatives of the exact nonlinear finite link-Euler coefficients\" is technically accurate but risks masking the fact that this is strictly a linearized weak-field limit.\n*   **Lattice Embedding:** The `PointedAffinePredecessorStencil` assumes the predecessor sites lie exactly on straight affine rays $point + c_n^{-1} v_a$. This is a rigid geometric assumption, though standard and acceptable for local consistency proofs.\n*   **Sign Convention:** As documented in the source, using predecessor differences yields $-(\\partial_\\mu e + \\omega_\\mu e) = 0$. This reverses the overall sign relative to the standard continuum equation $de + \\omega \\wedge e = 0$, but correctly leaves the zero locus unchanged.\n\n**2. Legitimacy of the Asymptotic Stationarity Hypothesis**\nIt is a legitimate dynamical premise for a *consistency* theorem. In numerical analysis and discrete physics, assuming that the discrete operator evaluated on smooth samples tends to zero (i.e., the truncation error vanishes) is the standard definition of consistency. It implies that the continuum operator evaluated on those same samples must be zero. It is not a disguised restatement of the conclusion, but rather the standard, rigorous bridge proving that the discrete equations faithfully represent the continuum equations in the limit.\n\n**3. Strongest Defensible Publication Claim and Caveats**\n",
            "thoughtSignature": "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"
          }
        ],
        "role": "model"
      },
      "finishReason": "MAX_TOKENS",
      "index": 0
    }
  ],
  "usageMetadata": {
    "promptTokenCount": 41899,
    "candidatesTokenCount": 477,
    "totalTokenCount": 53895,
    "promptTokensDetails": [
      {
        "modality": "TEXT",
        "tokenCount": 41899
      }
    ],
    "thoughtsTokenCount": 11519,
    "serviceTier": "standard"
  },
  "modelVersion": "gemini-3.1-pro-preview",
  "responseId": "LWBcap_uCeqt-8YPqra2kAU"
}
```

## Error

```text

```
