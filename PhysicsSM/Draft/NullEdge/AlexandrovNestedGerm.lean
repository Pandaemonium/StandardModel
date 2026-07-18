import PhysicsSM.Draft.NullEdge.AlexandrovGermInternalOperator

/-!
# Nested Alexandrov carriers

This module isolates the exact finite-order content used by the buffered-germ
experiments. A genuinely nested pair has both inner endpoints strictly inside
the outer marked diamond. Transitivity then puts the complete closed inner
carrier in the strict outer interior. The resulting subtype map preserves the
induced causal relation and every open-interval count exactly. A strengthened
structure records a two-sided endpoint count buffer.

An inner field may be extended by zero through the outer carrier, and every
layered causal operator then agrees with direct evaluation on the inner
carrier. A cardinality injection also transports protected-core depth: an
inner threshold `t` becomes the outer threshold `buffer + t`. The operator
identity assumes zero extension and is not independence from arbitrary outer
fields.

These statements do not select an outer regulator, prove typical-event
coverage, supply a physical scale, or establish continuum locality. Claim
grade: `M [orig]`.

Provenance: program-internal exact counterpart of the Stage A3e nested-carrier
audit in
`AgentTasks/null-edge-causal-nested-regulator-germ-stage-a3e-2026-07-16.json`.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.AlexandrovNestedGerm

open AlexandrovAlgebraGerm
open AlexandrovGermPacking
open AlexandrovGermInternalOperator
open FiniteCausalOrderOperator

variable {V : Type*} [Fintype V]

/-- An inner marked diamond with both endpoints strictly buffered inside an
outer marked diamond. -/
structure NestedMarkedDiamond (C : FiniteCausalOrder V) where
  outer : MarkedDiamond C
  inner : MarkedDiamond C
  pastBuffer : C.before outer.bottom inner.bottom
  futureBuffer : C.before inner.top outer.top

/-- A nested marked diamond carrying a lower bound on both endpoint count
buffers. The strict nesting and the numerical buffer are supplied data. -/
structure CountBufferedNestedDiamond
    (C : FiniteCausalOrder V) (buffer : Nat)
    extends NestedMarkedDiamond C where
  pastCountBuffer :
    buffer <= C.openIntervalCount outer.bottom inner.bottom + 1
  futureCountBuffer :
    buffer <= C.openIntervalCount inner.top outer.top + 1

/-- Every event of the closed inner carrier lies in the strict outer
interior. -/
theorem inner_inOpen_outer
    {C : FiniteCausalOrder V} (N : NestedMarkedDiamond C)
    {x : V} (hx : inClosed N.inner x) :
    N.outer.inOpen x := by
  rcases hx with rfl | rfl | hx
  · exact And.intro N.pastBuffer
      (C.trans N.inner.bottom_before_top N.futureBuffer)
  · exact And.intro (C.trans N.pastBuffer N.inner.bottom_before_top)
      N.futureBuffer
  · exact And.intro (C.trans N.pastBuffer hx.1)
      (C.trans hx.2 N.futureBuffer)

/-- The closed inner carrier is contained in the closed outer carrier. -/
theorem inner_inClosed_outer
    {C : FiniteCausalOrder V} (N : NestedMarkedDiamond C)
    {x : V} (hx : inClosed N.inner x) :
    inClosed N.outer x :=
  Or.inr (Or.inr (inner_inOpen_outer N hx))

/-- Canonical inclusion of a nested closed carrier into its outer carrier. -/
def innerToOuter
    {C : FiniteCausalOrder V} (N : NestedMarkedDiamond C) :
    ClosedCarrier N.inner -> ClosedCarrier N.outer :=
  fun x => Subtype.mk x.1 (inner_inClosed_outer N x.2)

/-- Canonical embedding of the closed inner carrier into its outer carrier. -/
def innerToOuterEmbedding
    {C : FiniteCausalOrder V} (N : NestedMarkedDiamond C) :
    ClosedCarrier N.inner ↪ ClosedCarrier N.outer where
  toFun := innerToOuter N
  inj' := by
    intro x y hxy
    apply Subtype.ext
    exact congrArg (fun z : ClosedCarrier N.outer => z.1) hxy

@[simp] theorem innerToOuter_val
    {C : FiniteCausalOrder V} (N : NestedMarkedDiamond C)
    (x : ClosedCarrier N.inner) :
    (innerToOuter N x).1 = x.1 :=
  rfl

/-- Nested-carrier inclusion preserves and reflects the induced strict causal
relation. -/
theorem innerToOuter_before_iff
    {C : FiniteCausalOrder V} (N : NestedMarkedDiamond C)
    (x y : ClosedCarrier N.inner) :
    (inducedOrder N.outer).before (innerToOuter N x) (innerToOuter N y) <->
      (inducedOrder N.inner).before x y := by
  rfl

/-- Open-interval counts between inner events are identical whether computed
in the inner induced order or in the buffered outer induced order. -/
theorem nested_induced_openIntervalCount_eq
    {C : FiniteCausalOrder V} (N : NestedMarkedDiamond C)
    (x y : ClosedCarrier N.inner) :
    (inducedOrder N.outer).openIntervalCount
        (innerToOuter N x) (innerToOuter N y) =
      (inducedOrder N.inner).openIntervalCount x y := by
  rw [induced_openIntervalCount_eq, induced_openIntervalCount_eq]
  rfl

/-! ## Nested zero extension and operator compatibility -/

/-- Extend an inner-carrier field by zero to a second closed carrier. Nesting
is used by the compatibility theorem rather than this definition. -/
def nestedZeroExtendField
    {C : FiniteCausalOrder V} {inner outer : MarkedDiamond C}
    (field : ClosedCarrier inner -> Real) :
    ClosedCarrier outer -> Real :=
  fun x => if hx : inClosed inner x.1 then field ⟨x.1, hx⟩ else 0

/-- Extending first through a nested outer carrier and then to the ambient
order equals direct zero extension from the inner carrier. -/
theorem zeroExtendField_nested
    {C : FiniteCausalOrder V} (N : NestedMarkedDiamond C)
    (field : ClosedCarrier N.inner -> Real) :
    zeroExtendField N.outer
        (nestedZeroExtendField (outer := N.outer) field) =
      zeroExtendField N.inner field := by
  funext x
  by_cases hx : inClosed N.inner x
  · have houter : inClosed N.outer x := inner_inClosed_outer N hx
    simp [zeroExtendField, nestedZeroExtendField, hx, houter]
  · simp [zeroExtendField, nestedZeroExtendField, hx]

/-- Every layered causal operator agrees across a nested carrier when the
inner field is zero-extended through the outer carrier. -/
theorem layeredOperator_nested_eq_zeroExtend
    {C : FiniteCausalOrder V} (N : NestedMarkedDiamond C)
    (prefactor diagonal : Real) (coefficient : Nat -> Real)
    (field : ClosedCarrier N.inner -> Real)
    (x : ClosedCarrier N.inner) :
    (inducedOrder N.inner).layeredOperator
        prefactor diagonal coefficient field x =
      (inducedOrder N.outer).layeredOperator
        prefactor diagonal coefficient
        (nestedZeroExtendField (outer := N.outer) field)
        (innerToOuter N x) := by
  rw [layeredOperator_induced_eq_zeroExtend,
    layeredOperator_induced_eq_zeroExtend,
    zeroExtendField_nested N]
  rfl

/-! ## Count-buffer transport -/

/-- Concatenate the interval from `a` to `b`, the event `b`, and the interval
from `b` to `c` inside the interval from `a` to `c`. -/
def intervalConcatEmbedding
    (C : FiniteCausalOrder V) {a b c : V}
    (hab : C.before a b) (hbc : C.before b c) :
    C.OpenInterval a b ⊕ Option (C.OpenInterval b c) ↪
      C.OpenInterval a c where
  toFun z := match z with
    | Sum.inl x => ⟨x.1, x.2.1, C.trans x.2.2 hbc⟩
    | Sum.inr none => ⟨b, hab, hbc⟩
    | Sum.inr (some x) => ⟨x.1, C.trans hab x.2.1, x.2.2⟩
  inj' := by
    intro x y hxy
    have hval := congrArg (fun z : C.OpenInterval a c => z.1) hxy
    rcases x with x | (_ | x) <;> rcases y with y | (_ | y)
    all_goals simp only at hval
    · exact congrArg Sum.inl (Subtype.ext hval)
    · have hirr := x.2.2
      rw [hval] at hirr
      exact (C.irrefl b hirr).elim
    · have hlt : C.before x.1 y.1 := C.trans x.2.2 y.2.1
      rw [hval] at hlt
      exact (C.irrefl y.1 hlt).elim
    · have hirr := y.2.2
      rw [← hval] at hirr
      exact (C.irrefl b hirr).elim
    · rfl
    · have hirr := y.2.1
      rw [← hval] at hirr
      exact (C.irrefl b hirr).elim
    · have hlt : C.before y.1 x.1 := C.trans y.2.2 x.2.1
      rw [hval] at hlt
      exact (C.irrefl y.1 hlt).elim
    · have hirr := x.2.1
      rw [hval] at hirr
      exact (C.irrefl b hirr).elim
    · exact congrArg (fun z => Sum.inr (some z)) (Subtype.ext hval)

/-- Open-interval cardinalities are superadditive across one comparable
intermediate event. -/
theorem openIntervalCount_concat_le
    (C : FiniteCausalOrder V) {a b c : V}
    (hab : C.before a b) (hbc : C.before b c) :
    C.openIntervalCount a b + 1 + C.openIntervalCount b c <=
      C.openIntervalCount a c := by
  have hcard := Fintype.card_le_of_injective
    (intervalConcatEmbedding C hab hbc)
    (intervalConcatEmbedding C hab hbc).injective
  change Fintype.card (C.OpenInterval a b) + 1 +
      Fintype.card (C.OpenInterval b c) <=
    Fintype.card (C.OpenInterval a c)
  simp only [Fintype.card_sum, Fintype.card_option] at hcard
  omega

/-- An inner protected core inherits the complete endpoint count buffer when
viewed in the outer diamond. -/
theorem CountBufferedNestedDiamond.protectedCore_outer
    {C : FiniteCausalOrder V} {buffer threshold : Nat}
    (N : CountBufferedNestedDiamond C buffer) {x : V}
    (hx : N.inner.protectedCore threshold x) :
    N.outer.protectedCore (buffer + threshold) x := by
  rcases hx with ⟨hxopen, hxdepth⟩
  have hopen : N.outer.inOpen x :=
    inner_inOpen_outer N.toNestedMarkedDiamond (Or.inr (Or.inr hxopen))
  have hpast := openIntervalCount_concat_le C
    N.pastBuffer hxopen.1
  have hfuture := openIntervalCount_concat_le C
    hxopen.2 N.futureBuffer
  have hpastBuffer := N.pastCountBuffer
  have hfutureBuffer := N.futureCountBuffer
  have hthresholdPast :
      threshold <= C.openIntervalCount N.inner.bottom x + 1 := by
    exact hxdepth.trans (Nat.min_le_left _ _)
  have hthresholdFuture :
      threshold <= C.openIntervalCount x N.inner.top + 1 := by
    exact hxdepth.trans (Nat.min_le_right _ _)
  constructor
  · exact hopen
  · rw [MarkedDiamond.boundaryDepth]
    rw [Nat.le_min]
    constructor
    · omega
    · omega

/-! ## Nonvacuous five-event chain control -/

/-- Strict five-event chain used to witness genuine nesting. -/
def fiveChainOrder : FiniteCausalOrder (Fin 5) where
  before i j := i < j
  decidableBefore := fun _ _ => inferInstance
  irrefl := lt_irrefl
  trans := lt_trans

/-- Outer interval spanning the five-event chain. -/
def fiveChainOuter : MarkedDiamond fiveChainOrder where
  bottom := 0
  top := 4
  bottom_before_top := by decide

/-- Inner interval with one event between its buffered endpoints. -/
def fiveChainInner : MarkedDiamond fiveChainOrder where
  bottom := 1
  top := 3
  bottom_before_top := by decide

/-- The five-event chain contains a genuinely nested marked diamond. -/
def fiveChainNested : NestedMarkedDiamond fiveChainOrder where
  outer := fiveChainOuter
  inner := fiveChainInner
  pastBuffer := by decide
  futureBuffer := by decide

/-- The strict endpoint gaps supply one positive count-depth unit on each
side of the inner diamond. -/
def fiveChainCountBuffered :
    CountBufferedNestedDiamond fiveChainOrder 1 where
  toNestedMarkedDiamond := fiveChainNested
  pastCountBuffer := by
    change 1 <= fiveChainOrder.openIntervalCount 0 1 + 1
    decide
  futureCountBuffer := by
    change 1 <= fiveChainOrder.openIntervalCount 3 4 + 1
    decide

/-- The middle chain event belongs to the inner carrier and maps to the same
ambient event in the outer carrier. -/
theorem fiveChain_middle_maps_to_middle :
    (innerToOuter fiveChainNested
      (Subtype.mk 2 (Or.inr (Or.inr (by decide))) :
        ClosedCarrier fiveChainInner)).1 = 2 :=
  rfl

/-- The middle event witnesses nonempty protected cores and gains exactly the
displayed positive buffer in the outer depth threshold. -/
theorem fiveChain_protectedCore_nonvacuous :
    fiveChainInner.protectedCore 1 (2 : Fin 5) ∧
      fiveChainOuter.protectedCore 2 (2 : Fin 5) := by
  have hinner : fiveChainInner.protectedCore 1 (2 : Fin 5) := by
    change fiveChainInner.inOpen 2 ∧
      1 <= fiveChainInner.boundaryDepth 2
    decide
  exact ⟨hinner, fiveChainCountBuffered.protectedCore_outer hinner⟩

/-! ## Build-enforced assumption-footprint guards -/

/-- info: 'PhysicsSM.Draft.NullEdge.AlexandrovNestedGerm.inner_inOpen_outer' depends on axioms: [propext, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AlexandrovNestedGerm.inner_inOpen_outer

/-- info: 'PhysicsSM.Draft.NullEdge.AlexandrovNestedGerm.nested_induced_openIntervalCount_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AlexandrovNestedGerm.nested_induced_openIntervalCount_eq

/-- info: 'PhysicsSM.Draft.NullEdge.AlexandrovNestedGerm.layeredOperator_nested_eq_zeroExtend' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AlexandrovNestedGerm.layeredOperator_nested_eq_zeroExtend

/-- info: 'PhysicsSM.Draft.NullEdge.AlexandrovNestedGerm.CountBufferedNestedDiamond.protectedCore_outer' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AlexandrovNestedGerm.CountBufferedNestedDiamond.protectedCore_outer

/-- info: 'PhysicsSM.Draft.NullEdge.AlexandrovNestedGerm.fiveChain_middle_maps_to_middle' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AlexandrovNestedGerm.fiveChain_middle_maps_to_middle

/-- info: 'PhysicsSM.Draft.NullEdge.AlexandrovNestedGerm.fiveChain_protectedCore_nonvacuous' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.AlexandrovNestedGerm.fiveChain_protectedCore_nonvacuous

end PhysicsSM.Draft.NullEdge.AlexandrovNestedGerm
