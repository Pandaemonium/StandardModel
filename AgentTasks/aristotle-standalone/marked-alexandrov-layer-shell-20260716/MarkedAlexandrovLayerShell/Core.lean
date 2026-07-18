import Mathlib

/-!
# Marked Alexandrov immediate-predecessor shell

Focused Mathlib-only package for the exact order-theoretic shell gates in the
marked-Alexandrov `1+3` proposal.

The zero-open-interval past layer of an event consists of its immediate
predecessors. The targets prove that this layer is an antichain, is disjoint
from every differently numbered layer, and is transported exactly by finite
causal-order isomorphisms.

These are finite order identities. They do not select three spatial modes,
recover a metric, prove Lorentz invariance, or establish a continuum limit.
-/

noncomputable section

namespace MarkedAlexandrovLayerShell

/-- Minimal finite strict causal order used by the focused package. -/
structure FiniteCausalOrder (V : Type*) [Fintype V] where
  before : V -> V -> Prop
  decidableBefore : DecidableRel before
  irrefl : forall x, Not (before x x)
  trans : forall {x y z}, before x y -> before y z -> before x z

instance {V : Type*} [Fintype V] (C : FiniteCausalOrder V) :
    DecidableRel C.before :=
  C.decidableBefore

variable {V W : Type*} [Fintype V] [Fintype W]

/-- Events strictly between two endpoints. -/
def FiniteCausalOrder.OpenInterval
    (C : FiniteCausalOrder V) (y x : V) :=
  {z : V // C.before y z ∧ C.before z x}

instance (C : FiniteCausalOrder V) (y x : V) :
    Fintype (C.OpenInterval y x) := by
  unfold FiniteCausalOrder.OpenInterval
  infer_instance

/-- Number of events in a strict open interval. -/
def FiniteCausalOrder.openIntervalCount
    (C : FiniteCausalOrder V) (y x : V) : Nat :=
  Fintype.card (C.OpenInterval y x)

/-- The `n`th past layer of `x`. -/
def FiniteCausalOrder.pastLayer
    (C : FiniteCausalOrder V) (x : V) (n : Nat) : Finset V :=
  Finset.univ.filter fun y =>
    C.before y x ∧ C.openIntervalCount y x = n

/-- A finite set is an antichain when no ordered pair of its elements is
causally related. Quantifying over all ordered pairs includes both directions. -/
def FiniteCausalOrder.IsAntichain
    (C : FiniteCausalOrder V) (S : Finset V) : Prop :=
  forall y, y ∈ S -> forall z, z ∈ S -> Not (C.before y z)

/-- Two elements of the zero-open-interval past layer cannot be related. -/
theorem pastLayer_zero_no_before
    (C : FiniteCausalOrder V) (x y z : V)
    (hy : y ∈ C.pastLayer x 0) (hz : z ∈ C.pastLayer x 0) :
    Not (C.before y z) := by
  sorry

/-- The immediate-predecessor shell is an exact antichain. -/
theorem pastLayer_zero_isAntichain
    (C : FiniteCausalOrder V) (x : V) :
    C.IsAntichain (C.pastLayer x 0) := by
  sorry

/-- Distinct interval-count layers are disjoint. -/
theorem pastLayer_disjoint_of_ne
    (C : FiniteCausalOrder V) (x : V) {m n : Nat} (hmn : m ≠ n) :
    Disjoint (C.pastLayer x m) (C.pastLayer x n) := by
  sorry

/-- The negative immediate-predecessor shell is disjoint from the proposed
positive radial support on layers one and three. -/
theorem pastLayer_zero_disjoint_one_union_three
    [DecidableEq V] (C : FiniteCausalOrder V) (x : V) :
    Disjoint (C.pastLayer x 0)
      (C.pastLayer x 1 ∪ C.pastLayer x 3) := by
  sorry

/-- Isomorphism of finite strict causal orders. -/
structure OrderIso (C : FiniteCausalOrder V) (D : FiniteCausalOrder W) where
  toEquiv : V ≃ W
  map_before_iff : forall x y,
    D.before (toEquiv x) (toEquiv y) ↔ C.before x y

/-- An order isomorphism transports each open interval bijectively. -/
def OrderIso.openIntervalEquiv
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (y x : V) :
    C.OpenInterval y x ≃
      D.OpenInterval (e.toEquiv y) (e.toEquiv x) := by
  sorry

/-- Open-interval count is invariant under causal relabeling. -/
theorem OrderIso.openIntervalCount_eq
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (y x : V) :
    D.openIntervalCount (e.toEquiv y) (e.toEquiv x) =
      C.openIntervalCount y x := by
  sorry

/-- Membership in every past layer is exactly equivariant under relabeling. -/
theorem OrderIso.mem_pastLayer_iff
    {C : FiniteCausalOrder V} {D : FiniteCausalOrder W}
    (e : OrderIso C D) (x y : V) (n : Nat) :
    e.toEquiv y ∈ D.pastLayer (e.toEquiv x) n ↔
      y ∈ C.pastLayer x n := by
  sorry

end MarkedAlexandrovLayerShell
