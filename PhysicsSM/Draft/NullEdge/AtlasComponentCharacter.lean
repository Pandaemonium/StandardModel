import PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy

/-!
# Discrete component characters of finite atlas transitions

A Lorentz atlas has two component signs before a spin lift is considered:
spatial orientation and time orientation.  This module proves the generic
finite gluing theorem behind both signs.

Given any group-valued Cech transition field and any group homomorphism to
`Multiplicative (ZMod 2)`, applying the character edgewise:

* preserves the exact Cech transition laws;
* commutes with chart-gauge changes;
* maps path transport to the corresponding component product;
* gives a gauge-invariant sign on every closed nerve path.

For restricted Lorentz reconstruction, the intended two characters are the
determinant sign and the time-orientation sign.  Their concrete matrix proofs
are separate from this generic atlas algebra.  Nontrivial closed component
products diagnose failure to reduce the atlas structure group globally, not
connection curvature.

Claim grade: `M [orig/comp]`, finite group algebra only.
-/

namespace PhysicsSM.Draft.NullEdge.AtlasComponentCharacter

open PhysicsSM.Draft.NullEdge.AtlasTransitionHolonomy

/-- The two-element component group, written multiplicatively. -/
abbrev ComponentGroup := Multiplicative (ZMod 2)

/-- Apply a component character to every ordered chart transition. -/
def componentTransition {I G : Type*} [Group G]
    (character : MonoidHom G ComponentGroup)
    (T : TransitionField I G) : TransitionField I ComponentGroup :=
  fun i j => character (T i j)

/-- Apply a component character to a chart gauge. -/
def componentGauge {I G : Type*} [Group G]
    (character : MonoidHom G ComponentGroup)
    (h : ChartGauge I G) : ChartGauge I ComponentGroup :=
  fun i => character (h i)

/-- A group character sends exact Cech gluing data to exact component-sign
gluing data. -/
theorem componentTransition_isCech {I G : Type*} [Group G]
    {pairOverlap : I -> I -> Prop}
    {tripleOverlap : I -> I -> I -> Prop}
    {T : TransitionField I G}
    (S : IsCechTransition pairOverlap tripleOverlap T)
    (character : MonoidHom G ComponentGroup) :
    IsCechTransition pairOverlap tripleOverlap
      (componentTransition character T) := by
  refine {
    normalized := ?_
    inverse := ?_
    cocycle := ?_ }
  · intro i hi
    simp [componentTransition, S.normalized i hi]
  · intro i j hij
    rw [componentTransition, componentTransition, <- map_mul]
    simp [S.inverse i j hij]
  · intro i j k hijk
    rw [componentTransition, componentTransition, componentTransition,
      <- map_mul, S.cocycle i j k hijk]

/-- Taking a component character commutes exactly with chart-gauge change. -/
theorem componentTransition_gauge {I G : Type*} [Group G]
    (character : MonoidHom G ComponentGroup)
    (h : ChartGauge I G) (T : TransitionField I G) :
    componentTransition character (gaugeTransition h T) =
      gaugeTransition (componentGauge character h)
        (componentTransition character T) := by
  funext i j
  simp [componentTransition, componentGauge, gaugeTransition]

/-- Component transport along a nerve path is the character of the original
group-valued path transport. -/
theorem pathTransport_componentTransition {I G : Type*} [Group G]
    (character : MonoidHom G ComponentGroup)
    (T : TransitionField I G) (i : I) (js : List I) :
    pathTransport (componentTransition character T) i js =
      character (pathTransport T i js) := by
  induction js generalizing i with
  | nil => simp [pathTransport]
  | cons j js ih =>
      simp [pathTransport, componentTransition, ih]

/-- Because the component group is abelian, its product on a closed path is
unchanged by every chart-gauge choice. -/
theorem closed_componentTransport_gauge_invariant {I : Type*}
    (h : ChartGauge I ComponentGroup)
    (T : TransitionField I ComponentGroup)
    (i : I) (js : List I) (hclosed : finishFrom i js = i) :
    pathTransport (gaugeTransition h T) i js = pathTransport T i js := by
  rw [pathTransport_gauge_covariant, hclosed]
  simp [mul_comm]

/-- A nonidentity closed component product is an obstruction to gauging every
transition on that loop into the identity component. -/
theorem closed_componentTransport_ne_one_gauge_invariant {I : Type*}
    (h : ChartGauge I ComponentGroup)
    (T : TransitionField I ComponentGroup)
    (i : I) (js : List I) (hclosed : finishFrom i js = i)
    (hnontrivial : pathTransport T i js != 1) :
    pathTransport (gaugeTransition h T) i js != 1 := by
  rw [closed_componentTransport_gauge_invariant h T i js hclosed]
  exact hnontrivial

/-- On an occupied triple overlap, every component character of a valid Cech
transition has trivial triangular product. -/
theorem component_triangle_trivial {I G : Type*} [Group G]
    {pairOverlap : I -> I -> Prop}
    {tripleOverlap : I -> I -> I -> Prop}
    {T : TransitionField I G}
    (S : IsCechTransition pairOverlap tripleOverlap T)
    (character : MonoidHom G ComponentGroup)
    {i j k : I} (hijk : tripleOverlap i j k)
    (triple_implies_pair : tripleOverlap i j k -> pairOverlap i k) :
    triangleProduct (componentTransition character T) i j k = 1 := by
  apply cech_triangle_holonomy_trivial
    (componentTransition_isCech S character) hijk triple_implies_pair

end PhysicsSM.Draft.NullEdge.AtlasComponentCharacter

/-! ## Axiom audit -/

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasComponentCharacter.componentTransition_isCech' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasComponentCharacter.componentTransition_isCech

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasComponentCharacter.componentTransition_gauge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasComponentCharacter.componentTransition_gauge

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasComponentCharacter.closed_componentTransport_gauge_invariant' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasComponentCharacter.closed_componentTransport_gauge_invariant

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasComponentCharacter.component_triangle_trivial' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasComponentCharacter.component_triangle_trivial
