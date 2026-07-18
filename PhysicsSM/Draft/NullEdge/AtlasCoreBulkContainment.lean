import PhysicsSM.Draft.NullEdge.AlexandrovAlgebraGerm

/-!
# Protected atlas cores lie in the independent order bulk

The Stage A3f-R2 packing benchmark defines its denominator before atlas
selection: an event is in the order bulk when it has at least `threshold`
predecessors and at least `threshold` successors. This module proves that
every protected core at the same inclusive count threshold lies in that bulk.

The proof is exact finite combinatorics. A core event's past open interval,
together with the candidate's bottom endpoint, injects into all predecessors
of the event; the future statement is dual. Consequently the union of any
finite family of protected cores is a subset of the independent bulk.

This theorem explains the benchmark factorization into global bulk fraction
and candidate-family saturation of that bulk. It does not prove that the
family saturates the bulk, establish a continuum limit, or open G2. Claim
grade: `M [orig]`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.AtlasCoreBulkContainment

open AlexandrovAlgebraGerm
open FiniteCausalOrderOperator

variable {V : Type*} [Fintype V]

/-- Number of strict predecessors of an event in the complete finite order. -/
def predecessorCount (C : FiniteCausalOrder V) (x : V) : Nat :=
  Fintype.card {y : V // C.before y x}

/-- Number of strict successors of an event in the complete finite order. -/
def successorCount (C : FiniteCausalOrder V) (x : V) : Nat :=
  Fintype.card {y : V // C.before x y}

/-- Atlas-independent two-sided count bulk. -/
def orderBulk
    (C : FiniteCausalOrder V) (threshold : Nat) (x : V) : Prop :=
  threshold <= predecessorCount C x ∧ threshold <= successorCount C x

/-- Add the lower endpoint to an open interval and embed the result into all
predecessors of the upper event. -/
def openIntervalWithBottomEmbedding
    (C : FiniteCausalOrder V) {bottom x : V}
    (hbefore : C.before bottom x) :
    Sum Unit (C.OpenInterval bottom x) ↪ {y : V // C.before y x} where
  toFun
    | Sum.inl _ => ⟨bottom, hbefore⟩
    | Sum.inr y => ⟨y.1, y.2.2⟩
  inj' := by
    intro left right heq
    cases left with
    | inl leftUnit =>
        cases right with
        | inl rightUnit =>
            simp
        | inr rightInterval =>
            exfalso
            have hvalue : bottom = rightInterval.1 :=
              congrArg Subtype.val heq
            exact C.irrefl bottom (by
              simpa [← hvalue] using rightInterval.2.1)
    | inr leftInterval =>
        cases right with
        | inl rightUnit =>
            exfalso
            have hvalue : leftInterval.1 = bottom :=
              congrArg Subtype.val heq
            exact C.irrefl bottom (by
              simpa [hvalue] using leftInterval.2.1)
        | inr rightInterval =>
            have hvalue : leftInterval.1 = rightInterval.1 := by
              change
                (⟨leftInterval.1, leftInterval.2.2⟩ :
                  {y : V // C.before y x}) =
                ⟨rightInterval.1, rightInterval.2.2⟩ at heq
              exact congrArg
                (fun y : {y : V // C.before y x} => y.1) heq
            exact congrArg Sum.inr (Subtype.ext hvalue)

/-- Add the upper endpoint to an open interval and embed the result into all
successors of the lower event. -/
def openIntervalWithTopEmbedding
    (C : FiniteCausalOrder V) {x top : V}
    (hbefore : C.before x top) :
    Sum (C.OpenInterval x top) Unit ↪ {y : V // C.before x y} where
  toFun
    | Sum.inl y => ⟨y.1, y.2.1⟩
    | Sum.inr _ => ⟨top, hbefore⟩
  inj' := by
    intro left right heq
    cases left with
    | inl leftInterval =>
        cases right with
        | inl rightInterval =>
            have hvalue : leftInterval.1 = rightInterval.1 := by
              change
                (⟨leftInterval.1, leftInterval.2.1⟩ :
                  {y : V // C.before x y}) =
                ⟨rightInterval.1, rightInterval.2.1⟩ at heq
              exact congrArg
                (fun y : {y : V // C.before x y} => y.1) heq
            exact congrArg Sum.inl (Subtype.ext hvalue)
        | inr rightUnit =>
            exfalso
            have hvalue : leftInterval.1 = top :=
              congrArg Subtype.val heq
            exact C.irrefl top (by
              simpa [hvalue] using leftInterval.2.2)
    | inr leftUnit =>
        cases right with
        | inl rightInterval =>
            exfalso
            have hvalue : top = rightInterval.1 :=
              congrArg Subtype.val heq
            exact C.irrefl top (by
              simpa [← hvalue] using rightInterval.2.2)
        | inr rightUnit =>
            simp

/-- Inclusive interval depth from one displayed predecessor is no larger than
the complete predecessor count. -/
theorem openIntervalCount_add_one_le_predecessorCount
    (C : FiniteCausalOrder V) {bottom x : V}
    (hbefore : C.before bottom x) :
    C.openIntervalCount bottom x + 1 <= predecessorCount C x := by
  have hcard :
      Fintype.card (Sum Unit (C.OpenInterval bottom x)) <=
        Fintype.card {y : V // C.before y x} :=
    Fintype.card_le_of_injective
      (openIntervalWithBottomEmbedding C hbefore)
      (openIntervalWithBottomEmbedding C hbefore).injective
  simpa [FiniteCausalOrder.openIntervalCount, predecessorCount,
    Nat.add_comm] using hcard

/-- Inclusive interval depth to one displayed successor is no larger than the
complete successor count. -/
theorem openIntervalCount_add_one_le_successorCount
    (C : FiniteCausalOrder V) {x top : V}
    (hbefore : C.before x top) :
    C.openIntervalCount x top + 1 <= successorCount C x := by
  have hcard :
      Fintype.card (Sum (C.OpenInterval x top) Unit) <=
        Fintype.card {y : V // C.before x y} :=
    Fintype.card_le_of_injective
      (openIntervalWithTopEmbedding C hbefore)
      (openIntervalWithTopEmbedding C hbefore).injective
  simpa [FiniteCausalOrder.openIntervalCount, successorCount,
    Nat.add_comm] using hcard

/-- Every protected core is contained in the independently defined order
bulk at the same inclusive count threshold. -/
theorem protectedCore_subset_orderBulk
    {C : FiniteCausalOrder V} (A : MarkedDiamond C)
    (threshold : Nat) (x : V) (hx : A.protectedCore threshold x) :
    orderBulk C threshold x := by
  have hdepth :
      threshold <= C.openIntervalCount A.bottom x + 1 ∧
        threshold <= C.openIntervalCount x A.top + 1 := by
    rw [MarkedDiamond.protectedCore, MarkedDiamond.boundaryDepth,
      le_min_iff] at hx
    exact hx.2
  exact ⟨
    hdepth.1.trans
      (openIntervalCount_add_one_le_predecessorCount C hx.1.1),
    hdepth.2.trans
      (openIntervalCount_add_one_le_successorCount C hx.1.2)⟩

/-- Membership in the union of any finite protected-core family implies
membership in the atlas-independent order bulk. -/
theorem protectedCore_family_union_subset_orderBulk
    {C : FiniteCausalOrder V} (family : Finset (MarkedDiamond C))
    (threshold : Nat) (x : V)
    (hx : exists A, A ∈ family ∧ A.protectedCore threshold x) :
    orderBulk C threshold x := by
  rcases hx with ⟨A, _hA, hxA⟩
  exact protectedCore_subset_orderBulk A threshold x hxA

end PhysicsSM.Draft.NullEdge.AtlasCoreBulkContainment

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasCoreBulkContainment.protectedCore_subset_orderBulk' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasCoreBulkContainment.protectedCore_subset_orderBulk

/-- info: 'PhysicsSM.Draft.NullEdge.AtlasCoreBulkContainment.protectedCore_family_union_subset_orderBulk' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AtlasCoreBulkContainment.protectedCore_family_union_subset_orderBulk
