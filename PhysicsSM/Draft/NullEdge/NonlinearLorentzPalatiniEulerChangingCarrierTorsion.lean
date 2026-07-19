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
