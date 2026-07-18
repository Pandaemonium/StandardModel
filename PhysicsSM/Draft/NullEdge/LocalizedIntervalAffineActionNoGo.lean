import PhysicsSM.Draft.NullEdge.LocalEinsteinEquationVariation

/-!
# Affine-action obstruction for the localized interval model

`LocalizedIntervalActionMetric` proves that event-local layer coefficients can
reach every symmetric metric variation and that, in an eleven-event chain, the
interval action descends exactly to the reconstructed metric. Those are
kinematic successes. They do not make the displayed action an
Einstein-Hilbert action.

The reason is exact: with the event measure, boundary term, and cosmological
term held fixed, the action is affine in the layer coefficients. Its first
derivative is independent of the base point. Stationarity therefore forces the
entire bulk-response functional to vanish. The explicit rank-ten chain does
not satisfy that degeneracy: an all-ones row has response `10`. Its descended
metric action likewise has no stationary point.

Thus the present linear interval action cannot supply the dynamical premise of
`LocalEinsteinEquationVariation`. A viable next action must add genuine
nonlinearity, with metric-dependent volume and curvature the continuum-guided
sources.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.LocalizedIntervalAffineActionNoGo

open scoped BigOperators
open FiniteCausalOrderOperator
open EinsteinEquationVariation
open RelaxedCausalMetricVariationBridge
open LocalizedIntervalActionMetric

variable {V : Type*} [Fintype V]

/-- For the fixed-measure localized interval action, parameter stationarity is
equivalent to vanishing of the bulk response in every coefficient direction.
The criterion is independent of the chosen base coefficient. -/
theorem eventLocalIntervalAction_stationary_iff_bulkResponse_zero
    (C : FiniteCausalOrder V) (bulkWeight : V -> Real) (K : Nat)
    (baseCoefficient : V -> Fin K -> Real)
    (boundary cosmological : Real) :
    ParameterStationary
        (fun coefficient => eventLocalIntervalAction C bulkWeight K coefficient
          boundary cosmological)
        baseCoefficient <->
      forall direction : V -> Fin K -> Real,
        eventLocalIntervalBulkResponse C bulkWeight K direction = 0 := by
  constructor
  · intro hStationary direction
    exact
      (eventLocalIntervalAction_directionalDerivative C bulkWeight K
        baseCoefficient direction boundary cosmological).unique
        (hStationary direction)
  · intro hResponse direction
    have hDerivative :=
      eventLocalIntervalAction_directionalDerivative C bulkWeight K
        baseCoefficient direction boundary cosmological
    rw [hResponse direction] at hDerivative
    exact hDerivative

/-- Put the constant row `1` at the top of the eleven-event chain. -/
def elevenChainAllOnesDirection : Fin 11 -> Fin 10 -> Real :=
  elevenChainTopCoefficient 1

/-- The all-ones coefficient direction has a nonzero bulk response, exactly
the number of represented interval layers. -/
theorem elevenChain_allOnes_bulkResponse :
    eventLocalIntervalBulkResponse elevenChainOrder elevenChainTopWeight 10
      elevenChainAllOnesDirection = 10 := by
  unfold eventLocalIntervalBulkResponse elevenChainAllOnesDirection
  rw [elevenChain_bulkAction_eq_sum]
  norm_num [Fin.sum_univ_succ]

/-- **Coefficient-space affine no-go.** No base coefficient is stationary for
the fixed-measure eleven-event interval action, regardless of the held-fixed
boundary and cosmological constants. -/
theorem elevenChain_eventLocalIntervalAction_not_stationary
    (baseCoefficient : Fin 11 -> Fin 10 -> Real)
    (boundary cosmological : Real) :
    Not (ParameterStationary
      (fun coefficient => eventLocalIntervalAction elevenChainOrder
        elevenChainTopWeight 10 coefficient boundary cosmological)
      baseCoefficient) := by
  intro hStationary
  have hZero :=
    (eventLocalIntervalAction_stationary_iff_bulkResponse_zero
      elevenChainOrder elevenChainTopWeight 10 baseCoefficient boundary
      cosmological).mp hStationary elevenChainAllOnesDirection
  rw [elevenChain_allOnes_bulkResponse] at hZero
  norm_num at hZero

/-! ## The descended metric action is affine too -/

/-- The descended rank-ten metric action is linear along every affine metric
line. -/
theorem elevenChainMetricAction_directionalDerivative
    (baseMetric variation : Tensor (I := Fin 4)) :
    HasDerivAt
      (fun t : Real => elevenChainMetricAction (baseMetric + t • variation))
      (elevenChainMetricAction variation) 0 := by
  have hDerivative : HasDerivAt
      (fun t : Real => elevenChainMetricAction baseMetric +
        t * elevenChainMetricAction variation)
      (elevenChainMetricAction variation) 0 := by
    simpa using
      ((hasDerivAt_id (𝕜 := Real) 0).mul_const
        (elevenChainMetricAction variation)).const_add
          (elevenChainMetricAction baseMetric)
  convert hDerivative using 1
  funext t
  simp [elevenChainMetricAction, tenMomentRightInverse, Fin.sum_univ_succ]
  ring

/-- The symmetric metric direction synthesized from the all-ones row has
descended action response `10`. -/
theorem elevenChainMetricAction_allOnes :
    elevenChainMetricAction (tenMomentMetric (1 : Fin 10 -> Real)) = 10 := by
  unfold elevenChainMetricAction
  rw [tenMomentRightInverse_leftInverse]
  norm_num [Fin.sum_univ_succ]

/-- **Metric-space affine no-go.** Exact descent through the full rank-ten
metric map does not rescue stationarity: the descended metric action has no
stationary point. -/
theorem elevenChainMetricAction_not_stationary
    (baseMetric : Tensor (I := Fin 4)) :
    Not (ActionMetricStationary elevenChainMetricAction baseMetric) := by
  intro hStationary
  let variation : Tensor (I := Fin 4) := tenMomentMetric (1 : Fin 10 -> Real)
  have hSymmetric : variation.IsSymm := tenMomentMetric_isSymm 1
  have hActual :=
    elevenChainMetricAction_directionalDerivative baseMetric variation
  have hZero := hStationary variation hSymmetric
  have hImpossible := hActual.unique hZero
  change elevenChainMetricAction variation = 0 at hImpossible
  rw [show variation = tenMomentMetric (1 : Fin 10 -> Real) by rfl,
    elevenChainMetricAction_allOnes] at hImpossible
  norm_num at hImpossible

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.LocalizedIntervalAffineActionNoGo.eventLocalIntervalAction_stationary_iff_bulkResponse_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms eventLocalIntervalAction_stationary_iff_bulkResponse_zero

/-- info: 'PhysicsSM.Draft.NullEdge.LocalizedIntervalAffineActionNoGo.elevenChain_eventLocalIntervalAction_not_stationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms elevenChain_eventLocalIntervalAction_not_stationary

/-- info: 'PhysicsSM.Draft.NullEdge.LocalizedIntervalAffineActionNoGo.elevenChainMetricAction_not_stationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms elevenChainMetricAction_not_stationary

end PhysicsSM.Draft.NullEdge.LocalizedIntervalAffineActionNoGo
