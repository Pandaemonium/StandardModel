import PhysicsSM.Draft.NullEdge.DiscreteCausalActionVariationNoGo

/-!
# Relaxed causal parameters to full metric variation

`DiscreteCausalActionVariationNoGo` proves that ordinary continuous variation
inside an unweighted finite graph space is vacuous. This module states the
replacement architecture for a continuously relaxed null-edge model.

A parameter space `P` may encode continuous edge weights, kernel coefficients,
ensemble probabilities, or another differentiable relaxation. Its linearized
metric reconstruction is a linear map

```text
dMetric : P -> symmetric rank-two tensors.
```

Two conditions are required:

1. the pulled-back action derivative equals the Einstein-matter pairing on
   `dMetric direction`;
2. `dMetric` reaches every symmetric metric variation.

Under those hypotheses, stationarity in relaxed causal parameters is
equivalent to the full finite Einstein equation. Without the second condition,
only the response on reachable variations vanishes. The module proves this
exact distinction but does not construct the relaxation or metric derivative
from null-edge data.
-/

namespace PhysicsSM.Draft.NullEdge.RelaxedCausalMetricVariationBridge

open EinsteinEquationVariation

section Pullback

variable {I P : Type*} [Fintype I] [AddCommGroup P] [Module Real P]

/-- Stationarity of an actual action along all affine directions in a relaxed
causal parameter space. -/
def ParameterStationary
    (action : P -> Real) (baseParameter : P) : Prop :=
  forall direction : P,
    HasDerivAt
      (fun t : Real => action (baseParameter + t • direction)) 0 0

/-- The action derivative pulled back through the linearized metric
reconstruction equals the normalized Einstein-matter response. -/
def HasPulledBackEinsteinFirstVariation
    (action : P -> Real) (baseParameter : P)
    (metricDerivative : P →ₗ[Real] Tensor (I := I))
    (kappa : Real) (einstein stress : Tensor (I := I)) : Prop :=
  forall direction : P,
    HasDerivAt
      (fun t : Real => action (baseParameter + t • direction))
      (totalMetricFirstVariation kappa einstein stress
        (metricDerivative direction)) 0

/-- The metric derivative has exactly the coverage needed by metric
variation: its image is symmetric and it reaches every symmetric tensor. -/
def IsFullSymmetricMetricDerivative
    (metricDerivative : P →ₗ[Real] Tensor (I := I)) : Prop :=
  (forall direction : P, (metricDerivative direction).IsSymm) /\
    (forall variation : Tensor (I := I), variation.IsSymm ->
      exists direction : P, metricDerivative direction = variation)

/-- Parameter stationarity always kills the Einstein-matter response on every
variation reached by the metric derivative, even without a full-rank
hypothesis. This is the projected field equation available to a deficient
relaxation. -/
theorem reachableVariation_response_zero
    (action : P -> Real) (baseParameter : P)
    (metricDerivative : P →ₗ[Real] Tensor (I := I))
    (kappa : Real) (einstein stress : Tensor (I := I))
    (hFirstVariation : HasPulledBackEinsteinFirstVariation action baseParameter
      metricDerivative kappa einstein stress)
    (hStationary : ParameterStationary action baseParameter)
    (direction : P) :
    totalMetricFirstVariation kappa einstein stress
      (metricDerivative direction) = 0 := by
  exact (hFirstVariation direction).unique (hStationary direction)

/-- Full symmetric reach upgrades relaxed-parameter stationarity to ordinary
metric stationarity, and conversely. -/
theorem parameterStationary_iff_metricStationary
    (action : P -> Real) (baseParameter : P)
    (metricDerivative : P →ₗ[Real] Tensor (I := I))
    (kappa : Real) (einstein stress : Tensor (I := I))
    (hFirstVariation : HasPulledBackEinsteinFirstVariation action baseParameter
      metricDerivative kappa einstein stress)
    (hFull : IsFullSymmetricMetricDerivative metricDerivative) :
    ParameterStationary action baseParameter <->
      MetricStationary kappa einstein stress := by
  constructor
  · intro hStationary variation hVariation
    obtain ⟨direction, hDirection⟩ := hFull.2 variation hVariation
    rw [← hDirection]
    exact reachableVariation_response_zero action baseParameter
      metricDerivative kappa einstein stress hFirstVariation hStationary
      direction
  · intro hMetricStationary direction
    have hDerivative := hFirstVariation direction
    have hResponseZero :=
      hMetricStationary (metricDerivative direction) (hFull.1 direction)
    rw [hResponseZero] at hDerivative
    exact hDerivative

/-- **Relaxed null-edge parameter bridge.** If the action variation pulls back
to the Einstein-matter pairing and the reconstructed metric derivative reaches
every symmetric variation, relaxed-parameter stationarity is equivalent to the
full finite Einstein equation. -/
theorem parameterStationary_iff_finiteEinsteinEquation
    (action : P -> Real) (baseParameter : P)
    (metricDerivative : P →ₗ[Real] Tensor (I := I))
    (kappa : Real) (ricci : Tensor (I := I)) (scalarCurvature : Real)
    (metric : Tensor (I := I)) (cosmologicalConstant : Real)
    (stress : Tensor (I := I))
    (hFirstVariation : HasPulledBackEinsteinFirstVariation action baseParameter
      metricDerivative kappa
      (finiteEinsteinLHS ricci scalarCurvature metric cosmologicalConstant)
      stress)
    (hFull : IsFullSymmetricMetricDerivative metricDerivative)
    (hRicci : ricci.IsSymm) (hMetric : metric.IsSymm)
    (hStress : stress.IsSymm) (hKappa : Not (kappa = 0)) :
    ParameterStationary action baseParameter <->
      FiniteEinsteinEquation kappa ricci scalarCurvature metric
        cosmologicalConstant stress :=
  (parameterStationary_iff_metricStationary action baseParameter
    metricDerivative kappa
    (finiteEinsteinLHS ricci scalarCurvature metric cosmologicalConstant)
    stress hFirstVariation hFull).trans
      (metricStationary_iff_finiteEinsteinEquation kappa ricci scalarCurvature
        metric cosmologicalConstant stress hRicci hMetric hStress hKappa)

end Pullback

/-! ## Full-rank witness -/

section SymmetricTensorWitness

variable {I : Type*}

/-- Symmetric real matrices form the model parameter space in which every
symmetric metric direction is manifestly available. -/
def symmetricTensorSubmodule :
    Submodule Real (Tensor (I := I)) where
  carrier := {variation | variation.IsSymm}
  zero_mem' := Matrix.isSymm_zero
  add_mem' := fun hA hB => hA.add hB
  smul_mem' := fun scalar _ hA => hA.smul scalar

/-- Inclusion of the symmetric-tensor parameter space into all matrices. -/
def symmetricTensorInclusion :
    symmetricTensorSubmodule (I := I) →ₗ[Real] Tensor (I := I) :=
  (symmetricTensorSubmodule (I := I)).subtype

/-- The full-symmetric-variation hypothesis has an explicit model: the
inclusion of symmetric tensors reaches exactly every allowed variation. -/
theorem symmetricTensorInclusion_isFull :
    IsFullSymmetricMetricDerivative
      (symmetricTensorInclusion (I := I)) := by
  constructor
  · intro direction
    change (direction : Tensor (I := I)).IsSymm
    exact direction.property
  · intro variation hVariation
    refine ⟨⟨variation, ?_⟩, rfl⟩
    change variation.IsSymm
    exact hVariation

end SymmetricTensorWitness

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.RelaxedCausalMetricVariationBridge.reachableVariation_response_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RelaxedCausalMetricVariationBridge.reachableVariation_response_zero

/-- info: 'PhysicsSM.Draft.NullEdge.RelaxedCausalMetricVariationBridge.parameterStationary_iff_finiteEinsteinEquation' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RelaxedCausalMetricVariationBridge.parameterStationary_iff_finiteEinsteinEquation

/-- info: 'PhysicsSM.Draft.NullEdge.RelaxedCausalMetricVariationBridge.symmetricTensorInclusion_isFull' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.RelaxedCausalMetricVariationBridge.symmetricTensorInclusion_isFull

end PhysicsSM.Draft.NullEdge.RelaxedCausalMetricVariationBridge
