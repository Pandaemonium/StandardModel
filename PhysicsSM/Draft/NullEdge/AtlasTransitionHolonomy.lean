import Mathlib

/-!
# Atlas transition cocycles versus connection holonomy

This module isolates the finite group algebra needed between a growing
protected-core atlas and any tetrad/spin reconstruction. There are two
different group-valued objects:

* a Cech transition field glues chart representatives and obeys an exact
  cocycle on every occupied triple overlap;
* a connection field transports states along nerve edges and need not obey the
  Cech cocycle. Its closed-path product can therefore carry curvature.

The distinction matters physically: a nontrivial triangular Bargmann phase
cannot be the failure of a valid chart-transition cocycle. It can instead be a
gauge-invariant observable of connection transport. These results are finite
algebra only. They do not construct an atlas, Lorentz frames, a spin lift,
curvature convergence, or Einstein dynamics from a graph.

Conventions: transition composition is `T i j * T j k = T i k`; a chart-gauge
change acts by `T' i j = h(i)^(-1) T i j h(j)`. Path products use the same
left-to-right convention.

Provenance: program-internal finite group formalization. Proofs were returned
by Aristotle project `58922023-5727-41fb-af75-684e8944efe6` and checked
locally without statement changes.
-/

namespace PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy

/-- Group-valued data attached to ordered pairs of chart indices. -/
abbrev TransitionField (I G : Type*) := I -> I -> G

/-- A change of representative in every chart. -/
abbrev ChartGauge (I G : Type*) := I -> G

/-- Endpoint action of chart gauges on transition or connection data. -/
def gaugeTransition {I G : Type*} [Group G]
    (h : ChartGauge I G) (T : TransitionField I G) : TransitionField I G :=
  fun i j => (h i)⁻¹ * T i j * h j

/-- Exact finite Cech transition conditions on occupied overlaps. -/
structure IsCechTransition {I G : Type*} [Group G]
    (pairOverlap : I -> I -> Prop) (tripleOverlap : I -> I -> I -> Prop)
    (T : TransitionField I G) : Prop where
  normalized : forall i, pairOverlap i i -> T i i = 1
  inverse : forall i j, pairOverlap i j -> T i j * T j i = 1
  cocycle : forall i j k, tripleOverlap i j k -> T i j * T j k = T i k

/-- Chart-gauge changes preserve normalization, inverse compatibility, and
the exact Cech cocycle. -/
theorem cech_cocycle_gauge_preserved {I G : Type*} [Group G]
    {pairOverlap : I -> I -> Prop} {tripleOverlap : I -> I -> I -> Prop}
    {T : TransitionField I G}
    (S : IsCechTransition pairOverlap tripleOverlap T)
    (h : ChartGauge I G) :
    IsCechTransition pairOverlap tripleOverlap (gaugeTransition h T) := by
  refine' ⟨_, _, _⟩
  · intro i hi
    simp [gaugeTransition, S.normalized i hi]
  · intro i j hij
    have := S.inverse i j hij
    simp_all +decide [← mul_assoc, gaugeTransition]
    simp +decide [mul_assoc, this]
  · intro i j k hijk
    have := S.cocycle i j k hijk
    simp_all +decide [gaugeTransition, mul_assoc]
    rw [← mul_assoc, this]

/-- Ordered product around a triangular nerve loop. -/
def triangleProduct {I G : Type*} [Mul G]
    (T : TransitionField I G) (i j k : I) : G :=
  T i j * T j k * T k i

/-- A valid Cech transition field has trivial product around every occupied
triple overlap. Nontrivial triangle holonomy must therefore live in separate
connection data, not in the bundle-gluing cocycle. -/
theorem cech_triangle_holonomy_trivial {I G : Type*} [Group G]
    {pairOverlap : I -> I -> Prop} {tripleOverlap : I -> I -> I -> Prop}
    {T : TransitionField I G}
    (S : IsCechTransition pairOverlap tripleOverlap T)
    {i j k : I} (hijk : tripleOverlap i j k)
    (triple_implies_pair :
      tripleOverlap i j k -> pairOverlap i k) :
    triangleProduct T i j k = 1 := by
  calc
    triangleProduct T i j k = T i k * T k i := by
      rw [triangleProduct, S.cocycle i j k hijk]
    _ = 1 := S.inverse i k (triple_implies_pair hijk)

/-- Last chart reached by a start chart followed by a list of chart indices. -/
def finishFrom {I : Type*} : I -> List I -> I
  | i, [] => i
  | _, j :: js => finishFrom j js

/-- Ordered transport along a finite nerve path. Unlike a Cech transition
field, a connection field supplied here has no cocycle hypothesis. -/
def pathTransport {I G : Type*} [Monoid G]
    (U : TransitionField I G) : I -> List I -> G
  | _, [] => 1
  | i, j :: js => U i j * pathTransport U j js

/-- Open-path connection transport is gauge covariant only at its endpoints. -/
theorem pathTransport_gauge_covariant {I G : Type*} [Group G]
    (h : ChartGauge I G) (U : TransitionField I G)
    (i : I) (js : List I) :
    pathTransport (gaugeTransition h U) i js =
      (h i)⁻¹ * pathTransport U i js * h (finishFrom i js) := by
  induction' js with j js ih generalizing i <;>
    simp_all +decide [pathTransport]
  · exact Eq.symm (inv_mul_cancel _)
  · simp +decide [gaugeTransition, mul_assoc]
    rfl

/-- A class function is insensitive to conjugation in the convention used by
`gaugeTransition`. -/
def IsClassFunction {G A : Type*} [Group G] (F : G -> A) : Prop :=
  forall h x, F (h⁻¹ * x * h) = F x

/-- Every class-function observable of a closed nerve-path holonomy is exactly
gauge invariant. -/
theorem closed_observable_gauge_invariant {I G A : Type*} [Group G]
    (F : G -> A) (hclass : IsClassFunction F)
    (h : ChartGauge I G) (U : TransitionField I G)
    (i : I) (js : List I) (hclosed : finishFrom i js = i) :
    F (pathTransport (gaugeTransition h U) i js) =
      F (pathTransport U i js) := by
  convert hclass _ _ using 2
  rw [pathTransport_gauge_covariant]
  aesop (simp_config := { singlePass := true })

/-! ## Nonvacuity control -/

/-- The two-element additive group, read multiplicatively. -/
abbrev SignGroup := Multiplicative (ZMod 2)

/-- A connection with one nontrivial edge on a three-chart loop. -/
def signConnection : TransitionField (Fin 3) SignGroup :=
  fun i j =>
    if i = 0 ∧ j = 1 then Multiplicative.ofAdd 1 else 1

/-- Connection data are not forced to have trivial triangular holonomy. This
contrasts with `cech_triangle_holonomy_trivial`. -/
theorem connection_nontrivial_triangle_witness :
    pathTransport signConnection (0 : Fin 3) [1, 2, 0] =
        Multiplicative.ofAdd (1 : ZMod 2) ∧
      pathTransport signConnection (0 : Fin 3) [1, 2, 0] ≠ 1 := by
  decide

/-- Finite separation verdict: Cech gluing is gauge stable and triangle-flat,
while connection transport is endpoint covariant, gives gauge-invariant closed
observables, and admits a nontrivial triangular witness. -/
theorem transition_connection_separation_verdict :
    (forall (I G : Type*) [Group G]
        (pairOverlap : I -> I -> Prop)
        (tripleOverlap : I -> I -> I -> Prop)
        (T : TransitionField I G)
        (S : IsCechTransition pairOverlap tripleOverlap T)
        (h : ChartGauge I G),
      IsCechTransition pairOverlap tripleOverlap (gaugeTransition h T)) ∧
    (forall (I G : Type*) [Group G]
        (h : ChartGauge I G) (U : TransitionField I G)
        (i : I) (js : List I),
      pathTransport (gaugeTransition h U) i js =
        (h i)⁻¹ * pathTransport U i js * h (finishFrom i js)) ∧
    pathTransport signConnection (0 : Fin 3) [1, 2, 0] ≠ 1 := by
  refine' ⟨_, _, _⟩
  · intro I G _ pairOverlap tripleOverlap T hT h
    exact cech_cocycle_gauge_preserved hT h
  · intro I G _ h U i js
    exact pathTransport_gauge_covariant h U i js
  · exact connection_nontrivial_triangle_witness.2

end PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy.cech_cocycle_gauge_preserved' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy.cech_cocycle_gauge_preserved

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy.cech_triangle_holonomy_trivial' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy.cech_triangle_holonomy_trivial

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy.pathTransport_gauge_covariant' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy.pathTransport_gauge_covariant

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy.closed_observable_gauge_invariant' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy.closed_observable_gauge_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy.connection_nontrivial_triangle_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy.connection_nontrivial_triangle_witness

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy.transition_connection_separation_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy.transition_connection_separation_verdict
