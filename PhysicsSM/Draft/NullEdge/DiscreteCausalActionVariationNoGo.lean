import PhysicsSM.Draft.NullEdge.EinsteinEquationVariation

/-!
# No infinitesimal metric variation on a discrete graph space

The selected null-edge gravity proposal assigns an interval-count action to an
unweighted finite causal configuration. Such configurations form a discrete
space. This module proves the resulting calculus obstruction:

* every continuous real-parameter path into a discrete configuration space is
  locally constant;
* every real-valued graph action therefore has derivative zero along that
  path;
* a nonzero Einstein-matter first variation cannot be realized by directly
  differentiating the unweighted graph configuration.

This is not a no-go for causal-set dynamics. It identifies data that a genuine
variational bridge must add: continuously varying edge or kernel weights, a
differentiable ensemble/measure parameter, a graph-changing finite-difference
calculus with a proved continuum limit, or a reconstruction map whose
refinement variation converges to metric variation. The theorem does not
select among those routes.
-/

namespace PhysicsSM.Draft.NullEdge.DiscreteCausalActionVariationNoGo

open Filter
open EinsteinEquationVariation

section DiscretePaths

variable {X : Type*} [TopologicalSpace X] [DiscreteTopology X]

/-- A continuous path into a discrete space is eventually equal to its value
at the base point. -/
theorem continuousAt_eventuallyEq_const
    (path : Real -> X) (hPath : ContinuousAt path 0) :
    path =ᶠ[nhds 0] fun _ => path 0 := by
  rw [ContinuousAt, nhds_discrete X, tendsto_pure] at hPath
  filter_upwards [hPath] with t ht
  exact ht

/-- Every real-valued action on a discrete configuration space has zero
derivative along a continuous configuration path. No regularity assumption on
the action itself is needed because the path is locally constant. -/
theorem graphAction_hasDerivAt_zero
    (action : X -> Real) (path : Real -> X)
    (hPath : ContinuousAt path 0) :
    HasDerivAt (fun t : Real => action (path t)) 0 0 := by
  have hPathEq := continuousAt_eventuallyEq_const path hPath
  have hActionEq :
      (fun t : Real => action (path t)) =ᶠ[nhds 0]
        fun _ : Real => action (path 0) := by
    filter_upwards [hPathEq] with t ht
    rw [ht]
  exact (hasDerivAt_const (x := 0) (c := action (path 0))).congr_of_eventuallyEq
    hActionEq

/-- Any derivative assigned to a graph action along a continuous discrete path
is forced to be zero by uniqueness of derivatives. -/
theorem graphAction_derivative_eq_zero
    (action : X -> Real) (path : Real -> X)
    (hPath : ContinuousAt path 0) (response : Real)
    (hDerivative : HasDerivAt (fun t : Real => action (path t)) response 0) :
    response = 0 := by
  exact hDerivative.unique (graphAction_hasDerivAt_zero action path hPath)

/-- A continuous path through unweighted discrete graphs cannot realize a
prescribed nonzero first variation. -/
theorem graphAction_cannot_have_nonzero_derivative
    (action : X -> Real) (path : Real -> X)
    (hPath : ContinuousAt path 0) (response : Real)
    (hResponse : Not (response = 0)) :
    Not (HasDerivAt (fun t : Real => action (path t)) response 0) := by
  intro hDerivative
  exact hResponse
    (graphAction_derivative_eq_zero action path hPath response hDerivative)

/-- Stationarity tested only by continuous paths in the discrete graph space. -/
def ContinuouslyGraphStationary (action : X -> Real) (baseGraph : X) : Prop :=
  forall path : Real -> X, path 0 = baseGraph -> ContinuousAt path 0 ->
    HasDerivAt (fun t : Real => action (path t)) 0 0

/-- **Vacuity theorem.** Every action on a discrete graph space is stationary
at every graph when stationarity is tested only by continuous real-parameter
paths in that space. Thus this notion cannot select the Einstein equation. -/
theorem everyGraphAction_continuouslyStationary
    (action : X -> Real) (baseGraph : X) :
    ContinuouslyGraphStationary action baseGraph := by
  intro path _ hPath
  exact graphAction_hasDerivAt_zero action path hPath

end DiscretePaths

/-! ## Einstein-variation consequence -/

section EinsteinVariation

variable {I X : Type*} [Fintype I]
  [TopologicalSpace X] [DiscreteTopology X]

/-- **Discrete graph variation obstruction.** If the normalized
Einstein-matter response is nonzero in some direction, no continuous
path in an unweighted discrete graph space can give an action derivative equal
to that response. Thus `HasEinsteinMetricFirstVariation` cannot be discharged
by directly treating the finite graph itself as a differentiable variable. -/
theorem no_nonzero_einsteinVariation_from_discreteGraphPath
    (action : X -> Real) (path : Real -> X)
    (hPath : ContinuousAt path 0)
    (kappa : Real) (einstein stress variation : Tensor (I := I))
    (hResponse : Not
      (totalMetricFirstVariation kappa einstein stress variation = 0)) :
    Not (HasDerivAt (fun t : Real => action (path t))
      (totalMetricFirstVariation kappa einstein stress variation) 0) :=
  graphAction_cannot_have_nonzero_derivative action path hPath
    (totalMetricFirstVariation kappa einstein stress variation) hResponse

end EinsteinVariation

/-! ## Nonvacuous two-configuration witness -/

/-- A nonconstant action on two discrete graph labels. -/
def twoGraphAction (state : Bool) : Real :=
  if state then 1 else 0

/-- A continuous path that remains at the first graph label. -/
def fixedGraphPath : Real -> Bool :=
  fun _ => false

/-- The obstruction is nonvacuous: the graph action distinguishes the two
configurations, but every continuous path through the displayed base graph has
zero derivative and in particular cannot have unit derivative. -/
theorem twoGraph_nonzeroAction_zeroDerivative_witness :
    Not (twoGraphAction false = twoGraphAction true) /\
      ContinuouslyGraphStationary twoGraphAction false /\
      HasDerivAt (fun t : Real => twoGraphAction (fixedGraphPath t)) 0 0 /\
      Not (HasDerivAt
        (fun t : Real => twoGraphAction (fixedGraphPath t)) 1 0) := by
  refine ⟨by norm_num [twoGraphAction],
    everyGraphAction_continuouslyStationary twoGraphAction false, ?_, ?_⟩
  · exact graphAction_hasDerivAt_zero twoGraphAction fixedGraphPath
      continuousAt_const
  · exact graphAction_cannot_have_nonzero_derivative
      twoGraphAction fixedGraphPath continuousAt_const 1 (by norm_num)

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.DiscreteCausalActionVariationNoGo.graphAction_cannot_have_nonzero_derivative' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DiscreteCausalActionVariationNoGo.graphAction_cannot_have_nonzero_derivative

/-- info: 'PhysicsSM.Draft.NullEdge.DiscreteCausalActionVariationNoGo.everyGraphAction_continuouslyStationary' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DiscreteCausalActionVariationNoGo.everyGraphAction_continuouslyStationary

/-- info: 'PhysicsSM.Draft.NullEdge.DiscreteCausalActionVariationNoGo.no_nonzero_einsteinVariation_from_discreteGraphPath' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DiscreteCausalActionVariationNoGo.no_nonzero_einsteinVariation_from_discreteGraphPath

/-- info: 'PhysicsSM.Draft.NullEdge.DiscreteCausalActionVariationNoGo.twoGraph_nonzeroAction_zeroDerivative_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.DiscreteCausalActionVariationNoGo.twoGraph_nonzeroAction_zeroDerivative_witness

end PhysicsSM.Draft.NullEdge.DiscreteCausalActionVariationNoGo
