import PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion

/-!
# Gate YM4/Q7: strong-coupling polymer map statement layer

This module freezes the first finite strong-coupling polymer-map interface used
by Q7.  It deliberately stays one layer above representation theory: a polymer
is a nonempty connected finite plaquette support together with nontrivial labels
on that support, and the coefficient assigned to a label is an explicit input
`gammaAbs`.

The conservative incompatibility relation used here is overlap-or-touching of
plaquette supports.  This matches the run's v0.3 oracle fixture for the finite
Z2 connected-plaquette gas; if a later character-expansion map only needs
overlap, that should be a separately named weaker system with a comparison
lemma.

Draft-trust: statement/definition freeze only.  The definitions feed the Q6
`PolymerSystem`/`KPCondition` interface, but no volume-uniform KP proof is
claimed here.

## Support-indexed labels (Q7 redesign)

`PlaquettePolymer` carries a support-indexed label
`label : {p : P // p ∈ support} -> Rlab`, so off-support values can no longer
create distinct Lean values for the same physical polymer.  A physical
extensionality theorem `PlaquettePolymer.ext_of_support_label` records this
identity, and decidability instances are provided for the three support
relations so that a downstream Q6/Q8 layer can state a `KPCondition` sum on this
system.  No volume-uniform KP theorem is proved here.
-/

noncomputable section

namespace PhysicsSM
namespace Draft
namespace NullEdge
namespace GateYM
namespace StrongCouplingPolymerMap

open scoped BigOperators
open PolymerKPCriterion

variable {P Rlab : Type*} [Fintype P] [DecidableEq P] [Fintype Rlab]

/-- Symmetric plaquette adjacency used to define touching-support
incompatibility.  The relation need not be reflexive: support overlap is
handled separately and always makes two polymers incompatible. -/
structure PlaquetteAdjacency (P : Type*) where
  touch : P -> P -> Prop
  touch_symm : forall p q, touch p q -> touch q p

/-- Plaquette polymers as finite supports plus support-indexed labels.

`ConnectedSupport` is abstract on purpose.  Q7 needs to connect several
possible finite plaquette geometries to Q6's polymer interface, and the first
freeze should not hard-code a particular graph-connectedness API.

The label is a function on the subtype `{p : P // p ∈ support}`, so that a
polymer has physical identity: labels outside the support simply do not exist
and cannot inflate a downstream `KPCondition` sum by a volume-dependent
factor. -/
structure PlaquettePolymer (P Rlab : Type*) [Fintype P] [DecidableEq P]
    [Fintype Rlab] (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop) where
  /-- Finite plaquette support of the polymer. -/
  support : Finset P
  /-- The support of a polymer is nonempty. -/
  support_nonempty : support.Nonempty
  /-- The support of a polymer is connected. -/
  support_connected : ConnectedSupport support
  /-- Label assigned to each plaquette in the support. -/
  label : {p : P // p ∈ support} -> Rlab
  /-- Every support label is nontrivial. -/
  label_nontrivial : forall p : {p : P // p ∈ support}, NontrivialLabel (label p)

namespace PlaquettePolymer

variable {ConnectedSupport : Finset P -> Prop}
variable {NontrivialLabel : Rlab -> Prop}

/-- The finite type of plaquette polymers.

A polymer is equivalent to a dependent pair of a support together with a
support-indexed label, cut out by the three defining predicates; both sides are
finite, so the polymer type is finite. -/
noncomputable instance fintype :
    Fintype (PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) := by
  classical
  let σ := Σ s : Finset P, ({p : P // p ∈ s} -> Rlab)
  let pred : σ -> Prop := fun x =>
    x.1.Nonempty /\ ConnectedSupport x.1 /\
      forall p : {p : P // p ∈ x.1}, NontrivialLabel (x.2 p)
  have e : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel ≃
      {x : σ // pred x} :=
    { toFun := fun X =>
        ⟨⟨X.support, X.label⟩,
          X.support_nonempty, X.support_connected, X.label_nontrivial⟩
      invFun := fun x => ⟨x.1.1, x.2.1, x.2.2.1, x.1.2, x.2.2.2⟩
      left_inv := fun X => rfl
      right_inv := fun x => rfl }
  exact Fintype.ofEquiv {x : σ // pred x} e.symm

/-- Physical extensionality for support-indexed plaquette polymers. -/
theorem ext_of_support_label
    {X Y : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel}
    (hs : X.support = Y.support)
    (hl : forall (p : P) (hpX : p ∈ X.support) (hpY : p ∈ Y.support),
      X.label ⟨p, hpX⟩ = Y.label ⟨p, hpY⟩) :
    X = Y := by
  obtain ⟨sX, hneX, hcX, lX, hntX⟩ := X
  obtain ⟨sY, hneY, hcY, lY, hntY⟩ := Y
  subst hs
  simp only [PlaquettePolymer.mk.injEq, heq_eq_eq, true_and]
  exact funext fun p => hl p p.2 p.2

/-- Product of absolute normalized character coefficients over the support. -/
def coeffProduct (gammaAbs : Rlab -> Real)
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) : Real :=
  X.support.attach.prod (fun p => gammaAbs (X.label p))

theorem coeffProduct_nonneg (gammaAbs : Rlab -> Real)
    (hgamma : forall r, 0 <= gammaAbs r)
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) :
    0 <= X.coeffProduct gammaAbs := by
  exact Finset.prod_nonneg (fun p _hp => hgamma (X.label p))

/-- Every plaquette polymer has support-cardinality at least one. -/
theorem one_le_support_card
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) :
    1 <= X.support.card := by
  exact Finset.card_pos.mpr X.support_nonempty

end PlaquettePolymer

/-- Supports overlap if they share a plaquette. -/
def SupportsOverlap (A B : Finset P) : Prop :=
  exists p : P, p ∈ A /\ p ∈ B

/-- Supports touch if some plaquette of one support touches a plaquette of the
other support in the chosen plaquette adjacency graph. -/
def SupportsTouch (Adj : PlaquetteAdjacency P) (A B : Finset P) : Prop :=
  exists p : P, p ∈ A /\ exists q : P, q ∈ B /\ Adj.touch p q

/-- Conservative strong-coupling polymer incompatibility:
supports either overlap or touch. -/
def SupportsOverlapOrTouch (Adj : PlaquetteAdjacency P) (A B : Finset P) :
    Prop :=
  SupportsOverlap A B \/ SupportsTouch Adj A B

/-- Overlap of finite supports is decidable. -/
instance SupportsOverlap.instDecidable (A B : Finset P) :
    Decidable (SupportsOverlap A B) := by
  unfold SupportsOverlap
  infer_instance

/-- Touching of finite supports is decidable once the plaquette-adjacency
relation is decidable. -/
instance SupportsTouch.instDecidable (Adj : PlaquetteAdjacency P)
    [DecidableRel Adj.touch] (A B : Finset P) :
    Decidable (SupportsTouch Adj A B) := by
  unfold SupportsTouch
  infer_instance

/-- The conservative overlap-or-touch incompatibility is decidable once the
plaquette-adjacency relation is decidable. -/
instance SupportsOverlapOrTouch.instDecidable (Adj : PlaquetteAdjacency P)
    [DecidableRel Adj.touch] (A B : Finset P) :
    Decidable (SupportsOverlapOrTouch Adj A B) := by
  unfold SupportsOverlapOrTouch
  infer_instance

omit [Fintype P] [DecidableEq P] in
theorem SupportsOverlap.symm {A B : Finset P} :
    SupportsOverlap A B -> SupportsOverlap B A := by
  intro h
  rcases h with ⟨p, hpA, hpB⟩
  exact ⟨p, hpB, hpA⟩

omit [Fintype P] [DecidableEq P] in
theorem SupportsTouch.symm (Adj : PlaquetteAdjacency P) {A B : Finset P} :
    SupportsTouch Adj A B -> SupportsTouch Adj B A := by
  intro h
  rcases h with ⟨p, hpA, q, hqB, hpq⟩
  exact ⟨q, hqB, p, hpA, Adj.touch_symm p q hpq⟩

omit [Fintype P] [DecidableEq P] in
theorem SupportsOverlapOrTouch.symm (Adj : PlaquetteAdjacency P)
    {A B : Finset P} :
    SupportsOverlapOrTouch Adj A B -> SupportsOverlapOrTouch Adj B A := by
  intro h
  cases h with
  | inl h => exact Or.inl (SupportsOverlap.symm h)
  | inr h => exact Or.inr (SupportsTouch.symm Adj h)

omit [Fintype P] [DecidableEq P] in
/-- Overlap is a special case of the conservative overlap-or-touch relation.
This is the support-level half of the comparison between the overlap-only and
the overlap-or-touch polymer systems; the full second system is left for a
later freeze. -/
theorem SupportsOverlap.orTouch (Adj : PlaquetteAdjacency P) {A B : Finset P} :
    SupportsOverlap A B -> SupportsOverlapOrTouch Adj A B :=
  Or.inl

omit [Fintype P] [DecidableEq P] in
/-- Touching is a special case of the conservative overlap-or-touch relation. -/
theorem SupportsTouch.orTouch (Adj : PlaquetteAdjacency P) {A B : Finset P} :
    SupportsTouch Adj A B -> SupportsOverlapOrTouch Adj A B :=
  Or.inr

/-- Closed touch-neighborhood of a finite support: the support itself plus all
plaquettes touching it.  This is the first anchor set used by finite counting
arguments for overlap-or-touch incompatible polymers. -/
def closedTouchNeighborhood (Adj : PlaquetteAdjacency P)
    [DecidableRel Adj.touch] (A : Finset P) : Finset P :=
  Finset.univ.filter fun q => q ∈ A \/ exists p : P, p ∈ A /\ Adj.touch p q

theorem mem_closedTouchNeighborhood_iff (Adj : PlaquetteAdjacency P)
    [DecidableRel Adj.touch] {A : Finset P} {q : P} :
    q ∈ closedTouchNeighborhood Adj A <->
      q ∈ A \/ exists p : P, p ∈ A /\ Adj.touch p q := by
  simp [closedTouchNeighborhood]

omit [Fintype Rlab] in
/-- The closed touch-neighborhood of the empty support is empty. -/
theorem closedTouchNeighborhood_empty (Adj : PlaquetteAdjacency P)
    [DecidableRel Adj.touch] :
    closedTouchNeighborhood Adj (∅ : Finset P) = ∅ := by
  ext q
  simp [closedTouchNeighborhood]

omit [Fintype Rlab] in
/-- A support is contained in its closed touch-neighborhood. -/
theorem subset_closedTouchNeighborhood (Adj : PlaquetteAdjacency P)
    [DecidableRel Adj.touch] (A : Finset P) :
    A ⊆ closedTouchNeighborhood Adj A := by
  intro q hq
  exact (mem_closedTouchNeighborhood_iff Adj).2 (Or.inl hq)

omit [Fintype Rlab] in
/-- Every member of a support lies in that support's closed touch-neighborhood. -/
theorem mem_closedTouchNeighborhood_self (Adj : PlaquetteAdjacency P)
    [DecidableRel Adj.touch] {A : Finset P} {q : P} (hq : q ∈ A) :
    q ∈ closedTouchNeighborhood Adj A :=
  subset_closedTouchNeighborhood Adj A hq

omit [Fintype Rlab] in
/-- A nonempty support has a nonempty closed touch-neighborhood. -/
theorem closedTouchNeighborhood_nonempty (Adj : PlaquetteAdjacency P)
    [DecidableRel Adj.touch] {A : Finset P} (hA : A.Nonempty) :
    (closedTouchNeighborhood Adj A).Nonempty := by
  rcases hA with ⟨q, hq⟩
  exact ⟨q, mem_closedTouchNeighborhood_self Adj hq⟩

omit [Fintype Rlab] in
/-- The closed touch-neighborhood is at least as large as the support. -/
theorem card_le_card_closedTouchNeighborhood (Adj : PlaquetteAdjacency P)
    [DecidableRel Adj.touch] (A : Finset P) :
    A.card <= (closedTouchNeighborhood Adj A).card :=
  Finset.card_le_card (subset_closedTouchNeighborhood Adj A)

omit [Fintype Rlab] in
/-- Closed touch-neighborhoods are monotone in the support. -/
theorem closedTouchNeighborhood_mono (Adj : PlaquetteAdjacency P)
    [DecidableRel Adj.touch] {A B : Finset P} (hAB : A ⊆ B) :
    closedTouchNeighborhood Adj A ⊆ closedTouchNeighborhood Adj B := by
  intro q hq
  rcases (mem_closedTouchNeighborhood_iff Adj).1 hq with hqA | hTouch
  · exact (mem_closedTouchNeighborhood_iff Adj).2 (Or.inl (hAB hqA))
  · rcases hTouch with ⟨p, hpA, hpq⟩
    exact (mem_closedTouchNeighborhood_iff Adj).2
      (Or.inr ⟨p, hAB hpA, hpq⟩)

omit [Fintype Rlab] in
/-- Closed touch-neighborhood of a union is contained in the union of the
closed touch-neighborhoods. -/
theorem closedTouchNeighborhood_union_subset (Adj : PlaquetteAdjacency P)
    [DecidableRel Adj.touch] (A B : Finset P) :
    closedTouchNeighborhood Adj (A ∪ B)
      ⊆ closedTouchNeighborhood Adj A ∪ closedTouchNeighborhood Adj B := by
  intro q hq
  rcases (mem_closedTouchNeighborhood_iff Adj).1 hq with hqAB | hTouch
  · rcases Finset.mem_union.1 hqAB with hqA | hqB
    · exact Finset.mem_union.2
        (Or.inl ((mem_closedTouchNeighborhood_iff Adj).2 (Or.inl hqA)))
    · exact Finset.mem_union.2
        (Or.inr ((mem_closedTouchNeighborhood_iff Adj).2 (Or.inl hqB)))
  · rcases hTouch with ⟨p, hpAB, hpq⟩
    rcases Finset.mem_union.1 hpAB with hpA | hpB
    · exact Finset.mem_union.2
        (Or.inl ((mem_closedTouchNeighborhood_iff Adj).2
          (Or.inr ⟨p, hpA, hpq⟩)))
    · exact Finset.mem_union.2
        (Or.inr ((mem_closedTouchNeighborhood_iff Adj).2
          (Or.inr ⟨p, hpB, hpq⟩)))

omit [Fintype Rlab] in
/-- Closed touch-neighborhood distributes over finite union. This exact form
lets later counting arguments split a root support into anchor pieces. -/
theorem closedTouchNeighborhood_union (Adj : PlaquetteAdjacency P)
    [DecidableRel Adj.touch] (A B : Finset P) :
    closedTouchNeighborhood Adj (A ∪ B)
      = closedTouchNeighborhood Adj A ∪ closedTouchNeighborhood Adj B := by
  apply Finset.Subset.antisymm
  · exact closedTouchNeighborhood_union_subset Adj A B
  · intro q hq
    rcases Finset.mem_union.1 hq with hqA | hqB
    · exact closedTouchNeighborhood_mono Adj (Finset.subset_union_left) hqA
    · exact closedTouchNeighborhood_mono Adj (Finset.subset_union_right) hqB

omit [Fintype Rlab] in
/-- A support's closed touch-neighborhood is the union of the closed
touch-neighborhoods of its singleton plaquettes. This is the exact support API
underlying later degree-style cardinality estimates. -/
theorem closedTouchNeighborhood_eq_biUnion_singleton
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch] (A : Finset P) :
    closedTouchNeighborhood Adj A =
      A.biUnion (fun p => closedTouchNeighborhood Adj ({p} : Finset P)) := by
  ext q
  constructor
  · intro hq
    rcases (mem_closedTouchNeighborhood_iff Adj).1 hq with hqA | hTouch
    · exact Finset.mem_biUnion.2
        ⟨q, hqA, (mem_closedTouchNeighborhood_iff Adj).2
          (Or.inl (by simp))⟩
    · rcases hTouch with ⟨p, hpA, hpq⟩
      exact Finset.mem_biUnion.2
        ⟨p, hpA, (mem_closedTouchNeighborhood_iff Adj).2
          (Or.inr ⟨p, by simp, hpq⟩)⟩
  · intro hq
    rcases Finset.mem_biUnion.1 hq with ⟨p, hpA, hqN⟩
    rcases (mem_closedTouchNeighborhood_iff Adj).1 hqN with hqSing | hTouch
    · have hqp : q = p := by simpa using hqSing
      subst q
      exact (mem_closedTouchNeighborhood_iff Adj).2 (Or.inl hpA)
    · rcases hTouch with ⟨r, hrSing, hrq⟩
      have hrp : r = p := by simpa using hrSing
      subst r
      exact (mem_closedTouchNeighborhood_iff Adj).2
        (Or.inr ⟨p, hpA, hrq⟩)

omit [Fintype Rlab] in
/-- Cardinality overcount by singleton closed touch-neighborhoods. This is the
geometry-free part of later degree-bound estimates. -/
theorem card_closedTouchNeighborhood_le_sum_singletons
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch] (A : Finset P) :
    (closedTouchNeighborhood Adj A).card
      <= A.sum (fun p => (closedTouchNeighborhood Adj ({p} : Finset P)).card) := by
  rw [closedTouchNeighborhood_eq_biUnion_singleton]
  exact Finset.card_biUnion_le

omit [Fintype Rlab] in
/-- Uniform singleton-neighborhood cardinality bound.  If every singleton
closed touch-neighborhood has at most `D` plaquettes, then the closed
touch-neighborhood of a root support `A` has at most `A.card * D` plaquettes.

This is still geometry-free: a concrete lattice must supply the value of `D`. -/
theorem card_closedTouchNeighborhood_le_card_mul_singletonBound
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (A : Finset P) (D : Nat)
    (hD : forall p : P,
      (closedTouchNeighborhood Adj ({p} : Finset P)).card <= D) :
    (closedTouchNeighborhood Adj A).card <= A.card * D := by
  calc
    (closedTouchNeighborhood Adj A).card
        <= A.sum (fun p => (closedTouchNeighborhood Adj ({p} : Finset P)).card) :=
          card_closedTouchNeighborhood_le_sum_singletons Adj A
    _ <= A.sum (fun _p => D) := by
          exact Finset.sum_le_sum (fun p _hp => hD p)
    _ = A.card * D := by
          simp [Finset.sum_const]

omit [Fintype Rlab] in
/-- A uniform pointwise bound over the closed touch-neighborhood bounds the
whole neighborhood sum by cardinality times the same bound.  No nonnegativity
assumption is needed for this upper-bound direction. -/
theorem sum_closedTouchNeighborhood_le_card_mul_bound
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (A : Finset P) (F : P -> Real) (B : Real)
    (hB : forall q : P, q ∈ closedTouchNeighborhood Adj A -> F q <= B) :
    (closedTouchNeighborhood Adj A).sum F
      <= ((closedTouchNeighborhood Adj A).card : Real) * B := by
  calc
    (closedTouchNeighborhood Adj A).sum F
        <= (closedTouchNeighborhood Adj A).sum (fun _q => B) := by
          exact Finset.sum_le_sum (fun q hq => hB q hq)
    _ = ((closedTouchNeighborhood Adj A).card : Real) * B := by
          simp [Finset.sum_const, nsmul_eq_mul]

omit [Fintype Rlab] in
/-- If `B` is overlap-or-touch incompatible with `A`, then `B` contains an
anchor plaquette in the closed touch-neighborhood of `A`.  This is the support
localization fact needed before any area-by-area counting bound. -/
theorem SupportsOverlapOrTouch.exists_right_mem_closedTouchNeighborhood
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    {A B : Finset P} :
    SupportsOverlapOrTouch Adj A B ->
      exists q : P, q ∈ B /\ q ∈ closedTouchNeighborhood Adj A := by
  intro h
  cases h with
  | inl hOverlap =>
      rcases hOverlap with ⟨q, hqA, hqB⟩
      exact ⟨q, hqB, (mem_closedTouchNeighborhood_iff Adj).2 (Or.inl hqA)⟩
  | inr hTouch =>
      rcases hTouch with ⟨p, hpA, q, hqB, hpq⟩
      exact ⟨q, hqB,
        (mem_closedTouchNeighborhood_iff Adj).2 (Or.inr ⟨p, hpA, hpq⟩)⟩

omit [Fintype Rlab] in
/-- Converse support-localization: a plaquette of `B` in the closed
touch-neighborhood of `A` exactly witnesses overlap-or-touch incompatibility. -/
theorem SupportsOverlapOrTouch.of_exists_right_mem_closedTouchNeighborhood
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    {A B : Finset P} :
    (exists q : P, q ∈ B /\ q ∈ closedTouchNeighborhood Adj A) ->
      SupportsOverlapOrTouch Adj A B := by
  intro h
  rcases h with ⟨q, hqB, hqN⟩
  rcases (mem_closedTouchNeighborhood_iff Adj).1 hqN with hqA | hTouch
  · exact Or.inl ⟨q, hqA, hqB⟩
  · rcases hTouch with ⟨p, hpA, hpq⟩
    exact Or.inr ⟨p, hpA, q, hqB, hpq⟩

omit [Fintype Rlab] in
/-- Exact support-localization form of conservative incompatibility.  Future
counting bounds can filter candidate polymers by whether their support meets
this finite closed neighborhood of the root support. -/
theorem SupportsOverlapOrTouch.iff_exists_right_mem_closedTouchNeighborhood
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    {A B : Finset P} :
    SupportsOverlapOrTouch Adj A B <->
      exists q : P, q ∈ B /\ q ∈ closedTouchNeighborhood Adj A := by
  constructor
  · exact SupportsOverlapOrTouch.exists_right_mem_closedTouchNeighborhood Adj
  · exact SupportsOverlapOrTouch.of_exists_right_mem_closedTouchNeighborhood Adj

omit [Fintype Rlab] in
/-- Finset-filter form of support localization: incompatible right supports are
exactly those whose intersection with the root closed neighborhood is nonempty.
This is often the most convenient shape for counting arguments. -/
theorem SupportsOverlapOrTouch.iff_inter_closedTouchNeighborhood_nonempty
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    {A B : Finset P} :
    SupportsOverlapOrTouch Adj A B <->
      (B ∩ closedTouchNeighborhood Adj A).Nonempty := by
  rw [SupportsOverlapOrTouch.iff_exists_right_mem_closedTouchNeighborhood Adj]
  constructor
  · rintro ⟨q, hqB, hqN⟩
    exact ⟨q, (Finset.mem_inter.2 ⟨hqB, hqN⟩)⟩
  · rintro ⟨q, hq⟩
    exact ⟨q, (Finset.mem_inter.1 hq).1, (Finset.mem_inter.1 hq).2⟩

omit [Fintype Rlab] in
/-- Cardinality form of support localization: incompatibility is equivalent to
the intersection with the closed touch-neighborhood having positive cardinality.
This avoids unpacking existential witnesses in later finite counting sums. -/
theorem SupportsOverlapOrTouch.iff_card_inter_closedTouchNeighborhood_pos
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    {A B : Finset P} :
    SupportsOverlapOrTouch Adj A B <->
      0 < (B ∩ closedTouchNeighborhood Adj A).card := by
  rw [SupportsOverlapOrTouch.iff_inter_closedTouchNeighborhood_nonempty Adj]
  exact Iff.symm Finset.card_pos

omit [Fintype Rlab] in
/--
Anchor overcount for future support-counting estimates.

For any finite family of objects with plaquette supports and nonnegative
weights, the total weight of objects incompatible with a root support `A` is
bounded by summing over anchor plaquettes in the closed touch-neighborhood of
`A`, then over all objects containing that anchor.  Objects with multiple
anchors are intentionally overcounted; that is the useful direction for later
finite KP bounds.
-/
theorem sum_supportsOverlapOrTouch_le_sum_closedTouchNeighborhood_anchors
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    {I : Type*} [Fintype I]
    (A : Finset P) (supportOf : I -> Finset P) (f : I -> Real)
    (hf : forall i, 0 <= f i) :
    (Finset.univ.filter (fun i : I =>
        decide (SupportsOverlapOrTouch Adj A (supportOf i)) = true)).sum f
      <= (closedTouchNeighborhood Adj A).sum (fun q =>
        (Finset.univ.filter (fun i : I =>
          decide (q ∈ supportOf i) = true)).sum f) := by
  classical
  let N := closedTouchNeighborhood Adj A
  calc
    (Finset.univ.filter (fun i : I =>
        decide (SupportsOverlapOrTouch Adj A (supportOf i)) = true)).sum f
        <= (Finset.univ.filter (fun i : I =>
            decide (SupportsOverlapOrTouch Adj A (supportOf i)) = true)).sum
              (fun i => (N.filter (fun q => q ∈ supportOf i)).sum
                (fun _ => f i)) := by
          apply Finset.sum_le_sum
          intro i hi
          have hInc : SupportsOverlapOrTouch Adj A (supportOf i) :=
            of_decide_eq_true (Finset.mem_filter.1 hi).2
          rcases
              (SupportsOverlapOrTouch.iff_inter_closedTouchNeighborhood_nonempty
                Adj).1 hInc with
            ⟨q, hq⟩
          have hqN : q ∈ N := by
            simpa [N] using (Finset.mem_inter.1 hq).2
          have hqS : q ∈ supportOf i := (Finset.mem_inter.1 hq).1
          exact Finset.single_le_sum (fun _ _ => hf i)
            (Finset.mem_filter.2 ⟨hqN, hqS⟩)
    _ <= Finset.univ.sum (fun i : I =>
        (N.filter (fun q => q ∈ supportOf i)).sum (fun _ => f i)) := by
          exact Finset.sum_le_sum_of_subset_of_nonneg
            (Finset.filter_subset _ _)
            (by
              intro i _hi _hnot
              exact Finset.sum_nonneg (fun _ _ => hf i))
    _ = N.sum (fun q =>
        (Finset.univ.filter (fun i : I =>
          decide (q ∈ supportOf i) = true)).sum f) := by
          simp [N, Finset.sum_comm, Finset.sum_filter,
            Finset.filter_mem_eq_inter]

omit [Fintype Rlab] in
/-- Contrapositive support-localization form: if every plaquette of `B` lies
outside the closed touch-neighborhood of `A`, then `A` and `B` are compatible
for the conservative overlap-or-touch relation. -/
theorem not_supportsOverlapOrTouch_of_forall_not_mem_closedTouchNeighborhood
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    {A B : Finset P}
    (hB : forall q : P, q ∈ B -> q ∉ closedTouchNeighborhood Adj A) :
    ¬ SupportsOverlapOrTouch Adj A B := by
  intro h
  rcases SupportsOverlapOrTouch.exists_right_mem_closedTouchNeighborhood
      Adj h with ⟨q, hqB, hqN⟩
  exact hB q hqB hqN

/-- The conservative finite plaquette-polymer system used by the Q7 statement
freeze.  `alpha * support.card` is the KP energy, and `gammaAbs` supplies the
absolute normalized label coefficient. -/
def plaquettePolymerSystem
    (Adj : PlaquetteAdjacency P)
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real)
    (alpha : Real) (halpha : 0 <= alpha) :
    PolymerSystem
      (PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) where
  incompatible X Y :=
    SupportsOverlapOrTouch Adj X.support Y.support
  incompatible_symm := by
    intro X Y h
    exact SupportsOverlapOrTouch.symm Adj h
  weight X := X.coeffProduct gammaAbs
  energy X := alpha * (X.support.card : Real)
  energy_nonneg := by
    intro X
    exact mul_nonneg halpha (Nat.cast_nonneg _)

theorem plaquettePolymerSystem_weight
    (Adj : PlaquetteAdjacency P)
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real)
    (alpha : Real) (halpha : 0 <= alpha)
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) :
    (plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha).weight X = X.coeffProduct gammaAbs :=
  rfl

theorem plaquettePolymerSystem_energy
    (Adj : PlaquetteAdjacency P)
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real)
    (alpha : Real) (halpha : 0 <= alpha)
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) :
    (plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha).energy X =
      alpha * (X.support.card : Real) :=
  rfl

theorem plaquettePolymerSystem_self_incompatible
    (Adj : PlaquetteAdjacency P)
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real)
    (alpha : Real) (halpha : 0 <= alpha)
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) :
    (plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha).incompatible X X := by
  left
  rcases X.support_nonempty with ⟨p, hp⟩
  exact ⟨p, hp, hp⟩

/-- The KP weight of every polymer is nonnegative when the label coefficient
`gammaAbs` is nonnegative.  KP consumes `|weight|`, so this lets a downstream
KP instantiation drop the absolute value on the weight. -/
theorem plaquettePolymerSystem_weight_nonneg
    (Adj : PlaquetteAdjacency P)
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) :
    0 <= (plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha).weight X := by
  rw [plaquettePolymerSystem_weight]
  exact X.coeffProduct_nonneg gammaAbs hgamma

/-- The canonical decidability witness for the conservative plaquette-polymer
incompatibility relation.  Downstream KP wrappers use this witness so the
finite sum in `KPCondition` has a stable, named decidability argument. -/
def plaquettePolymerIncompatibleDecidable
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real)
    (alpha : Real) (halpha : 0 <= alpha) :
    forall X Y : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel,
      Decidable ((plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
        gammaAbs alpha halpha).incompatible X Y) := by
  intro X Y
  unfold plaquettePolymerSystem
  infer_instance

/-- The explicit finite KP sum for the conservative plaquette-polymer system,
written in the physical nonnegative-weight form.  The hard strong-coupling
estimate is precisely to bound this quantity uniformly in volume for a chosen
plaquette geometry and coefficient system. -/
def plaquetteKPSum
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real)
    (alpha : Real) (halpha : 0 <= alpha)
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) : Real :=
  ∑ Y ∈ Finset.univ.filter
      (fun Y : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel =>
        @Decidable.decide _
          (plaquettePolymerIncompatibleDecidable Adj ConnectedSupport
            NontrivialLabel gammaAbs alpha halpha X Y) = true),
    Y.coeffProduct gammaAbs * Real.exp (alpha * (Y.support.card : Real))

/-- The explicit rooted plaquette-polymer KP sum is nonnegative when all label
coefficients are nonnegative. -/
theorem plaquetteKPSum_nonneg
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) :
    0 <= plaquetteKPSum Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha X := by
  unfold plaquetteKPSum
  exact Finset.sum_nonneg (fun Y _hY =>
    mul_nonneg (Y.coeffProduct_nonneg gammaAbs hgamma)
      (le_of_lt (Real.exp_pos _)))

/--
Anchor overcount specialized to the explicit plaquette KP sum.

The incompatible-polymer KP sum rooted at `X` is bounded by first choosing an
anchor plaquette in the closed touch-neighborhood of `X.support`, then summing
over all polymers whose support contains that anchor.  This is a localization
step only; it does not estimate the anchored sums.
-/
theorem plaquetteKPSum_le_sum_closedTouchNeighborhood_anchors
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) :
    plaquetteKPSum Adj ConnectedSupport NontrivialLabel gammaAbs alpha halpha X
      <= (closedTouchNeighborhood Adj X.support).sum (fun q =>
        (Finset.univ.filter
          (fun Y : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel =>
            decide (q ∈ Y.support) = true)).sum
          (fun Y =>
            Y.coeffProduct gammaAbs *
              Real.exp (alpha * (Y.support.card : Real)))) := by
  simpa [plaquetteKPSum, plaquettePolymerIncompatibleDecidable,
    plaquettePolymerSystem]
    using
      sum_supportsOverlapOrTouch_le_sum_closedTouchNeighborhood_anchors
        Adj X.support
        (fun Y : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel =>
          Y.support)
        (fun Y =>
          Y.coeffProduct gammaAbs *
            Real.exp (alpha * (Y.support.card : Real)))
        (by
          intro Y
          exact mul_nonneg (Y.coeffProduct_nonneg gammaAbs hgamma)
            (le_of_lt (Real.exp_pos _)))

/-- The anchored plaquette-polymer contribution at a plaquette `q`, restricted
to polymers whose support has cardinality `k`.

This is pure finite bookkeeping for later support-counting estimates.  No
connected-support count or strong-coupling smallness bound is asserted here. -/
def anchoredPlaquettePolymerAreaSum
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real)
    (alpha : Real)
    (q : P) (k : Nat) : Real :=
  (Finset.univ.filter
    (fun Y : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel =>
      decide (q ∈ Y.support) = true ∧ Y.support.card = k)).sum
    (fun Y =>
      Y.coeffProduct gammaAbs *
        Real.exp (alpha * (Y.support.card : Real)))

/-- Each anchored support-cardinality slice is nonnegative when all label
coefficients are nonnegative. -/
theorem anchoredPlaquettePolymerAreaSum_nonneg
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real)
    (q : P) (k : Nat) :
    0 <= anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
      gammaAbs alpha q k := by
  unfold anchoredPlaquettePolymerAreaSum
  exact Finset.sum_nonneg (fun Y _hY =>
    mul_nonneg (Y.coeffProduct_nonneg gammaAbs hgamma)
      (le_of_lt (Real.exp_pos _)))

/-- The zero-cardinality anchored slice vanishes, since plaquette polymers have
nonempty support. -/
theorem anchoredPlaquettePolymerAreaSum_zero
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real)
    (alpha : Real) (q : P) :
    anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
      gammaAbs alpha q 0 = 0 := by
  unfold anchoredPlaquettePolymerAreaSum
  apply Finset.sum_eq_zero
  intro Y hY
  rcases Finset.mem_filter.1 hY with ⟨_hUniv, _hYq, hYcard⟩
  have hpos : 0 < Y.support.card :=
    Finset.card_pos.2 Y.support_nonempty
  exact False.elim ((Nat.ne_of_gt hpos) hYcard)

/-- Area slices larger than the finite plaquette universe vanish. -/
theorem anchoredPlaquettePolymerAreaSum_eq_zero_of_card_lt
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real)
    (alpha : Real) (q : P) (k : Nat)
    (hk : Fintype.card P < k) :
    anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
      gammaAbs alpha q k = 0 := by
  unfold anchoredPlaquettePolymerAreaSum
  apply Finset.sum_eq_zero
  intro Y hY
  rcases Finset.mem_filter.1 hY with ⟨_hUniv, _hYq, hYcard⟩
  have hle : Y.support.card <= Fintype.card P :=
    Finset.card_le_univ Y.support
  have hlt : Y.support.card < k := lt_of_le_of_lt hle hk
  exact False.elim ((Nat.ne_of_lt hlt) hYcard)

/-- The full anchored plaquette-polymer contribution at a plaquette `q`. -/
def anchoredPlaquettePolymerSum
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real)
    (alpha : Real)
    (q : P) : Real :=
  (Finset.univ.filter
    (fun Y : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel =>
      decide (q ∈ Y.support) = true)).sum
    (fun Y =>
      Y.coeffProduct gammaAbs *
        Real.exp (alpha * (Y.support.card : Real)))

/-- The full anchored contribution is nonnegative when all label coefficients
are nonnegative. -/
theorem anchoredPlaquettePolymerSum_nonneg
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real)
    (q : P) :
    0 <= anchoredPlaquettePolymerSum ConnectedSupport NontrivialLabel
      gammaAbs alpha q := by
  unfold anchoredPlaquettePolymerSum
  exact Finset.sum_nonneg (fun Y _hY =>
    mul_nonneg (Y.coeffProduct_nonneg gammaAbs hgamma)
      (le_of_lt (Real.exp_pos _)))

/-- Each fixed-cardinality anchored slice is bounded by the full anchored
contribution when all label coefficients are nonnegative.  This is the
one-slice version of the finite area decomposition below. -/
theorem anchoredPlaquettePolymerAreaSum_le_anchoredPlaquettePolymerSum
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real)
    (q : P) (k : Nat) :
    anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
      gammaAbs alpha q k
      <= anchoredPlaquettePolymerSum ConnectedSupport NontrivialLabel
        gammaAbs alpha q := by
  classical
  unfold anchoredPlaquettePolymerAreaSum anchoredPlaquettePolymerSum
  exact Finset.sum_le_sum_of_subset_of_nonneg
    (by
      intro Y hY
      rcases Finset.mem_filter.1 hY with ⟨_hUniv, hYq, _hYcard⟩
      exact Finset.mem_filter.2 ⟨Finset.mem_univ Y, hYq⟩)
    (by
      intro Y _hY _hNot
      exact mul_nonneg (Y.coeffProduct_nonneg gammaAbs hgamma)
        (le_of_lt (Real.exp_pos _)))

/-- The full anchored contribution is the finite sum of its support-cardinality
slices.  The range stops at `Fintype.card P`, since every polymer support is a
finset of plaquettes in `P`. -/
theorem anchoredPlaquettePolymerSum_eq_sum_areaSlices
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real)
    (alpha : Real) (q : P) :
    anchoredPlaquettePolymerSum ConnectedSupport NontrivialLabel gammaAbs
      alpha q =
      (Finset.range (Fintype.card P + 1)).sum (fun k =>
        anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
          gammaAbs alpha q k) := by
  classical
  unfold anchoredPlaquettePolymerSum anchoredPlaquettePolymerAreaSum
  simp only [Finset.sum_filter]
  rw [Finset.sum_comm]
  apply Eq.symm
  apply Finset.sum_congr rfl
  intro Y _hY
  by_cases hq : decide (q ∈ Y.support) = true
  · have hcard : Y.support.card ∈ Finset.range (Fintype.card P + 1) := by
      rw [Finset.mem_range]
      exact Nat.lt_succ_of_le (Finset.card_le_univ Y.support)
    rw [if_pos hq]
    have hsingle :
        (Finset.range (Fintype.card P + 1)).sum
          (fun k =>
            if decide (q ∈ Y.support) = true ∧ Y.support.card = k then
              Y.coeffProduct gammaAbs *
                Real.exp (alpha * (Y.support.card : Real))
            else
              0) =
          Y.coeffProduct gammaAbs *
            Real.exp (alpha * (Y.support.card : Real)) := by
      rw [Finset.sum_eq_single Y.support.card]
      · simp [hq]
      · intro b _hb hne
        have hne' : Y.support.card ≠ b := fun h => hne h.symm
        simp [hne']
      · intro hnot
        exact False.elim (hnot hcard)
    simpa using hsingle
  · rw [if_neg hq]
    apply Finset.sum_eq_zero
    intro k _hk
    simp [hq]

/-- The full anchored contribution is equivalently the finite sum over
positive support cardinalities `1, ..., Fintype.card P`.  The zero slice is
absent because polymers have nonempty support. -/
theorem anchoredPlaquettePolymerSum_eq_sum_positiveAreaSlices
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real)
    (alpha : Real) (q : P) :
    anchoredPlaquettePolymerSum ConnectedSupport NontrivialLabel gammaAbs
      alpha q =
      (Finset.Icc 1 (Fintype.card P)).sum (fun k =>
        anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
          gammaAbs alpha q k) := by
  classical
  rw [anchoredPlaquettePolymerSum_eq_sum_areaSlices]
  let f : Nat -> Real := fun k =>
    anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
      gammaAbs alpha q k
  have hErase :
      (Finset.range (Fintype.card P + 1)).erase 0 =
        Finset.Icc 1 (Fintype.card P) := by
    ext k
    simp
    omega
  have h0 : f 0 = 0 := by
    exact anchoredPlaquettePolymerAreaSum_zero ConnectedSupport
      NontrivialLabel gammaAbs alpha q
  have h0mem : 0 ∈ Finset.range (Fintype.card P + 1) := by
    simp
  calc
    (Finset.range (Fintype.card P + 1)).sum (fun k =>
        anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
          gammaAbs alpha q k)
        = ((Finset.range (Fintype.card P + 1)).erase 0).sum f := by
          have h := Finset.sum_erase_add
            (Finset.range (Fintype.card P + 1)) f h0mem
          rw [h0, add_zero] at h
          exact h.symm
    _ = (Finset.Icc 1 (Fintype.card P)).sum f := by
          rw [hErase]
    _ = (Finset.Icc 1 (Fintype.card P)).sum (fun k =>
        anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
          gammaAbs alpha q k) := by
          rfl

/-- If every anchored support-cardinality slice is bounded by `B k`, then the
full anchored contribution is bounded by the sum of those slice bounds.

This is the exact insertion point for a future connected-support counting
estimate; the theorem itself proves no such count. -/
theorem anchoredPlaquettePolymerSum_le_sum_areaBounds
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real)
    (alpha : Real) (q : P) (B : Nat -> Real)
    (hB : forall k : Nat, k ∈ Finset.range (Fintype.card P + 1) ->
      anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
        gammaAbs alpha q k <= B k) :
    anchoredPlaquettePolymerSum ConnectedSupport NontrivialLabel gammaAbs
      alpha q <=
      (Finset.range (Fintype.card P + 1)).sum B := by
  rw [anchoredPlaquettePolymerSum_eq_sum_areaSlices]
  exact Finset.sum_le_sum hB

/-- Positive-area version of `anchoredPlaquettePolymerSum_le_sum_areaBounds`.
Only support sizes `1, ..., Fintype.card P` have to be bounded. -/
theorem anchoredPlaquettePolymerSum_le_sum_positiveAreaBounds
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real)
    (alpha : Real) (q : P) (B : Nat -> Real)
    (hB : forall k : Nat, k ∈ Finset.Icc 1 (Fintype.card P) ->
      anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
        gammaAbs alpha q k <= B k) :
    anchoredPlaquettePolymerSum ConnectedSupport NontrivialLabel gammaAbs
      alpha q <=
      (Finset.Icc 1 (Fintype.card P)).sum B := by
  rw [anchoredPlaquettePolymerSum_eq_sum_positiveAreaSlices]
  exact Finset.sum_le_sum hB

/-- Area-sliced version of the anchored overcount for the explicit plaquette KP
sum.  Bounding each area slice of every anchor in the closed touch-neighborhood
is enough to bound the rooted KP sum by the corresponding neighborhood sum of
area-bound totals. -/
theorem plaquetteKPSum_le_sum_closedTouchNeighborhood_areaBounds
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel)
    (B : Nat -> Real)
    (hB : forall q : P, q ∈ closedTouchNeighborhood Adj X.support ->
      forall k : Nat, k ∈ Finset.range (Fintype.card P + 1) ->
        anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
          gammaAbs alpha q k <= B k) :
    plaquetteKPSum Adj ConnectedSupport NontrivialLabel gammaAbs alpha halpha X
      <= (closedTouchNeighborhood Adj X.support).sum
          (fun _q => (Finset.range (Fintype.card P + 1)).sum B) := by
  have hAnchors :=
    plaquetteKPSum_le_sum_closedTouchNeighborhood_anchors Adj
      ConnectedSupport NontrivialLabel gammaAbs hgamma alpha halpha X
  refine hAnchors.trans ?_
  apply Finset.sum_le_sum
  intro q hq
  exact anchoredPlaquettePolymerSum_le_sum_areaBounds
    ConnectedSupport NontrivialLabel gammaAbs alpha q B (hB q hq)

/-- Positive-area version of
`plaquetteKPSum_le_sum_closedTouchNeighborhood_areaBounds`.  The per-anchor
slice hypotheses only range over support cardinalities
`1, ..., Fintype.card P`. -/
theorem plaquetteKPSum_le_sum_closedTouchNeighborhood_positiveAreaBounds
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel)
    (B : Nat -> Real)
    (hB : forall q : P, q ∈ closedTouchNeighborhood Adj X.support ->
      forall k : Nat, k ∈ Finset.Icc 1 (Fintype.card P) ->
        anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
          gammaAbs alpha q k <= B k) :
    plaquetteKPSum Adj ConnectedSupport NontrivialLabel gammaAbs alpha halpha X
      <= (closedTouchNeighborhood Adj X.support).sum
          (fun _q => (Finset.Icc 1 (Fintype.card P)).sum B) := by
  have hAnchors :=
    plaquetteKPSum_le_sum_closedTouchNeighborhood_anchors Adj
      ConnectedSupport NontrivialLabel gammaAbs hgamma alpha halpha X
  refine hAnchors.trans ?_
  apply Finset.sum_le_sum
  intro q hq
  exact anchoredPlaquettePolymerSum_le_sum_positiveAreaBounds
    ConnectedSupport NontrivialLabel gammaAbs alpha q B (hB q hq)

/-- Cardinality form of the area-sliced anchored overcount. -/
theorem plaquetteKPSum_le_card_closedTouchNeighborhood_mul_sum_areaBounds
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel)
    (B : Nat -> Real)
    (hB : forall q : P, q ∈ closedTouchNeighborhood Adj X.support ->
      forall k : Nat, k ∈ Finset.range (Fintype.card P + 1) ->
        anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
          gammaAbs alpha q k <= B k) :
    plaquetteKPSum Adj ConnectedSupport NontrivialLabel gammaAbs alpha halpha X
      <= ((closedTouchNeighborhood Adj X.support).card : Real) *
          (Finset.range (Fintype.card P + 1)).sum B := by
  calc
    plaquetteKPSum Adj ConnectedSupport NontrivialLabel gammaAbs alpha halpha X
        <= (closedTouchNeighborhood Adj X.support).sum
            (fun _q => (Finset.range (Fintype.card P + 1)).sum B) :=
          plaquetteKPSum_le_sum_closedTouchNeighborhood_areaBounds Adj
            ConnectedSupport NontrivialLabel gammaAbs hgamma alpha halpha X B hB
    _ = ((closedTouchNeighborhood Adj X.support).card : Real) *
          (Finset.range (Fintype.card P + 1)).sum B := by
          simp [Finset.sum_const, nsmul_eq_mul]

/-- Cardinality form of the positive-area anchored overcount. -/
theorem plaquetteKPSum_le_card_closedTouchNeighborhood_mul_sum_positiveAreaBounds
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel)
    (B : Nat -> Real)
    (hB : forall q : P, q ∈ closedTouchNeighborhood Adj X.support ->
      forall k : Nat, k ∈ Finset.Icc 1 (Fintype.card P) ->
        anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
          gammaAbs alpha q k <= B k) :
    plaquetteKPSum Adj ConnectedSupport NontrivialLabel gammaAbs alpha halpha X
      <= ((closedTouchNeighborhood Adj X.support).card : Real) *
          (Finset.Icc 1 (Fintype.card P)).sum B := by
  calc
    plaquetteKPSum Adj ConnectedSupport NontrivialLabel gammaAbs alpha halpha X
        <= (closedTouchNeighborhood Adj X.support).sum
            (fun _q => (Finset.Icc 1 (Fintype.card P)).sum B) :=
          plaquetteKPSum_le_sum_closedTouchNeighborhood_positiveAreaBounds Adj
            ConnectedSupport NontrivialLabel gammaAbs hgamma alpha halpha X B
            hB
    _ = ((closedTouchNeighborhood Adj X.support).card : Real) *
          (Finset.Icc 1 (Fintype.card P)).sum B := by
          simp [Finset.sum_const, nsmul_eq_mul]

/-- If every anchored polymer sum over supports containing a fixed plaquette is
bounded by `B` on the closed touch-neighborhood of `X.support`, then the
localized KP overcount is bounded by the size of that neighborhood times `B`.

This is still geometry-free: the theorem does not choose a singleton-degree
constant or estimate the anchored sums. -/
theorem plaquetteKPSum_le_card_closedTouchNeighborhood_mul_anchorBound
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel)
    (B : Real)
    (hB : forall q : P, q ∈ closedTouchNeighborhood Adj X.support ->
      (Finset.univ.filter
        (fun Y : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel =>
          decide (q ∈ Y.support) = true)).sum
        (fun Y =>
          Y.coeffProduct gammaAbs *
            Real.exp (alpha * (Y.support.card : Real))) <= B) :
    plaquetteKPSum Adj ConnectedSupport NontrivialLabel gammaAbs alpha halpha X
      <= ((closedTouchNeighborhood Adj X.support).card : Real) * B := by
  exact
    (plaquetteKPSum_le_sum_closedTouchNeighborhood_anchors Adj
      ConnectedSupport NontrivialLabel gammaAbs hgamma alpha halpha X).trans
      (sum_closedTouchNeighborhood_le_card_mul_bound Adj X.support
        (fun q =>
          (Finset.univ.filter
            (fun Y : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel =>
              decide (q ∈ Y.support) = true)).sum
            (fun Y =>
              Y.coeffProduct gammaAbs *
                Real.exp (alpha * (Y.support.card : Real))))
        B hB)

/-- Combining a uniform singleton-neighborhood degree bound with a uniform
anchored polymer-sum bound gives the standard product-form Q7 overcount:
root-support size times degree times anchored bound.

Concrete lattice geometry still has to prove the singleton-degree hypothesis,
and strong-coupling estimates still have to prove the anchored bound. -/
theorem plaquetteKPSum_le_card_mul_singletonBound_mul_anchorBound
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel)
    (D : Nat) (B : Real) (hB_nonneg : 0 <= B)
    (hD : forall p : P,
      (closedTouchNeighborhood Adj ({p} : Finset P)).card <= D)
    (hB : forall q : P, q ∈ closedTouchNeighborhood Adj X.support ->
      (Finset.univ.filter
        (fun Y : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel =>
          decide (q ∈ Y.support) = true)).sum
        (fun Y =>
          Y.coeffProduct gammaAbs *
            Real.exp (alpha * (Y.support.card : Real))) <= B) :
    plaquetteKPSum Adj ConnectedSupport NontrivialLabel gammaAbs alpha halpha X
      <= ((X.support.card * D : Nat) : Real) * B := by
  have hKP :=
    plaquetteKPSum_le_card_closedTouchNeighborhood_mul_anchorBound Adj
      ConnectedSupport NontrivialLabel gammaAbs hgamma alpha halpha X B hB
  have hCard :
      (closedTouchNeighborhood Adj X.support).card <= X.support.card * D :=
    card_closedTouchNeighborhood_le_card_mul_singletonBound Adj X.support D hD
  exact hKP.trans
    (mul_le_mul_of_nonneg_right (Nat.cast_le.mpr hCard) hB_nonneg)

/-- A finite plaquette-polymer KP bound: the explicit incompatible-polymer
sum rooted at each polymer is bounded by its energy `alpha * area`. -/
def PlaquetteKPBound
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real)
    (alpha : Real) (halpha : 0 <= alpha) : Prop :=
  forall X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel,
    plaquetteKPSum Adj ConnectedSupport NontrivialLabel gammaAbs alpha
      halpha X <= alpha * (X.support.card : Real)

/-- A uniform rooted KP-sum bound by `alpha` is enough to prove the
area-scaled finite plaquette-polymer KP bound, because every polymer support
has cardinality at least one. -/
theorem plaquetteKPBound_of_uniform_alpha_bound
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real)
    (alpha : Real) (halpha : 0 <= alpha)
    (hBound : forall X : PlaquettePolymer P Rlab ConnectedSupport
        NontrivialLabel,
      plaquetteKPSum Adj ConnectedSupport NontrivialLabel gammaAbs alpha
        halpha X <= alpha) :
    PlaquetteKPBound Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha := by
  intro X
  have hCard : (1 : Real) <= (X.support.card : Real) := by
    exact_mod_cast PlaquettePolymer.one_le_support_card X
  have hScale : alpha <= alpha * (X.support.card : Real) := by
    calc
      alpha = alpha * 1 := by ring
      _ <= alpha * (X.support.card : Real) := by
          exact mul_le_mul_of_nonneg_left hCard halpha
  exact (hBound X).trans hScale

/-- A reusable sufficient condition for the explicit finite plaquette-polymer
KP bound using a root-dependent closed-neighborhood cardinality estimate.

This is the geometry-independent connector just before choosing a lattice
degree constant: if all anchored polymer sums are bounded by `B`, and each
root support has enough KP energy to pay for its closed touch-neighborhood
overcount, then `PlaquetteKPBound` follows. -/
theorem plaquetteKPBound_of_closedTouchNeighborhood_anchorBound
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (B : Real)
    (hB : forall X : PlaquettePolymer P Rlab ConnectedSupport
        NontrivialLabel,
      forall q : P, q ∈ closedTouchNeighborhood Adj X.support ->
        (Finset.univ.filter
          (fun Y : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel =>
            decide (q ∈ Y.support) = true)).sum
          (fun Y =>
            Y.coeffProduct gammaAbs *
              Real.exp (alpha * (Y.support.card : Real))) <= B)
    (hScale : forall X : PlaquettePolymer P Rlab ConnectedSupport
        NontrivialLabel,
      ((closedTouchNeighborhood Adj X.support).card : Real) * B <=
        alpha * (X.support.card : Real)) :
    PlaquetteKPBound Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha := by
  intro X
  exact
    (plaquetteKPSum_le_card_closedTouchNeighborhood_mul_anchorBound Adj
      ConnectedSupport NontrivialLabel gammaAbs hgamma alpha halpha X B
      (hB X)).trans
      (hScale X)

/-- A reusable sufficient condition for the explicit finite plaquette-polymer
KP bound using area-sliced anchored estimates.

This is the landing pad for support-counting: if each anchored
support-cardinality slice is bounded by `B k`, and each root has enough energy
to pay for its closed-neighborhood count times the sum of those slice bounds,
then the explicit `PlaquetteKPBound` follows. -/
theorem plaquetteKPBound_of_closedTouchNeighborhood_areaBounds
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (B : Nat -> Real)
    (hB : forall X : PlaquettePolymer P Rlab ConnectedSupport
        NontrivialLabel,
      forall q : P, q ∈ closedTouchNeighborhood Adj X.support ->
        forall k : Nat, k ∈ Finset.range (Fintype.card P + 1) ->
          anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
            gammaAbs alpha q k <= B k)
    (hScale : forall X : PlaquettePolymer P Rlab ConnectedSupport
        NontrivialLabel,
      ((closedTouchNeighborhood Adj X.support).card : Real) *
          (Finset.range (Fintype.card P + 1)).sum B <=
        alpha * (X.support.card : Real)) :
    PlaquetteKPBound Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha := by
  intro X
  exact
    (plaquetteKPSum_le_card_closedTouchNeighborhood_mul_sum_areaBounds Adj
      ConnectedSupport NontrivialLabel gammaAbs hgamma alpha halpha X B
      (hB X)).trans
      (hScale X)

/-- Positive-area version of
`plaquetteKPBound_of_closedTouchNeighborhood_areaBounds`.

The sufficient per-area hypotheses range only over support sizes
`1, ..., Fintype.card P`. -/
theorem plaquetteKPBound_of_closedTouchNeighborhood_positiveAreaBounds
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (B : Nat -> Real)
    (hB : forall X : PlaquettePolymer P Rlab ConnectedSupport
        NontrivialLabel,
      forall q : P, q ∈ closedTouchNeighborhood Adj X.support ->
        forall k : Nat, k ∈ Finset.Icc 1 (Fintype.card P) ->
          anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
            gammaAbs alpha q k <= B k)
    (hScale : forall X : PlaquettePolymer P Rlab ConnectedSupport
        NontrivialLabel,
      ((closedTouchNeighborhood Adj X.support).card : Real) *
          (Finset.Icc 1 (Fintype.card P)).sum B <=
        alpha * (X.support.card : Real)) :
    PlaquetteKPBound Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha := by
  intro X
  exact
    (plaquetteKPSum_le_card_closedTouchNeighborhood_mul_sum_positiveAreaBounds
      Adj ConnectedSupport NontrivialLabel gammaAbs hgamma alpha halpha X B
      (hB X)).trans
      (hScale X)

/-- A real-valued growth-constant version of
`plaquetteKPBound_of_closedTouchNeighborhood_areaBounds`.

This is useful once a concrete plaquette geometry proves
`card N(A) <= C * card A`, while support counting supplies the per-area slice
bound `B`.  The theorem is still conditional and proves no small-coupling
estimate by itself. -/
theorem plaquetteKPBound_of_realClosedNeighborhood_areaBounds
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (C : Real) (B : Nat -> Real)
    (hBsum_nonneg : 0 <= (Finset.range (Fintype.card P + 1)).sum B)
    (hCard : forall X : PlaquettePolymer P Rlab ConnectedSupport
        NontrivialLabel,
      ((closedTouchNeighborhood Adj X.support).card : Real) <=
        C * (X.support.card : Real))
    (hArea : forall X : PlaquettePolymer P Rlab ConnectedSupport
        NontrivialLabel,
      forall q : P, q ∈ closedTouchNeighborhood Adj X.support ->
        forall k : Nat, k ∈ Finset.range (Fintype.card P + 1) ->
          anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
            gammaAbs alpha q k <= B k)
    (hsmall : C * (Finset.range (Fintype.card P + 1)).sum B <= alpha) :
    PlaquetteKPBound Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha := by
  refine
    plaquetteKPBound_of_closedTouchNeighborhood_areaBounds Adj
      ConnectedSupport NontrivialLabel gammaAbs hgamma alpha halpha B
      hArea ?_
  intro X
  have hSupport_nonneg : 0 <= (X.support.card : Real) := by
    exact_mod_cast Nat.zero_le X.support.card
  calc
    ((closedTouchNeighborhood Adj X.support).card : Real) *
        (Finset.range (Fintype.card P + 1)).sum B
        <= (C * (X.support.card : Real)) *
            (Finset.range (Fintype.card P + 1)).sum B := by
          exact mul_le_mul_of_nonneg_right (hCard X) hBsum_nonneg
    _ = (X.support.card : Real) *
          (C * (Finset.range (Fintype.card P + 1)).sum B) := by
          ring
    _ <= (X.support.card : Real) * alpha := by
          exact mul_le_mul_of_nonneg_left hsmall hSupport_nonneg
    _ = alpha * (X.support.card : Real) := by
          ring

/-- Positive-area version of
`plaquetteKPBound_of_realClosedNeighborhood_areaBounds`.  The support-counting
input only has to bound the positive support-cardinality slices. -/
theorem plaquetteKPBound_of_realClosedNeighborhood_positiveAreaBounds
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (C : Real) (B : Nat -> Real)
    (hBsum_nonneg : 0 <= (Finset.Icc 1 (Fintype.card P)).sum B)
    (hCard : forall X : PlaquettePolymer P Rlab ConnectedSupport
        NontrivialLabel,
      ((closedTouchNeighborhood Adj X.support).card : Real) <=
        C * (X.support.card : Real))
    (hArea : forall X : PlaquettePolymer P Rlab ConnectedSupport
        NontrivialLabel,
      forall q : P, q ∈ closedTouchNeighborhood Adj X.support ->
        forall k : Nat, k ∈ Finset.Icc 1 (Fintype.card P) ->
          anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
            gammaAbs alpha q k <= B k)
    (hsmall : C * (Finset.Icc 1 (Fintype.card P)).sum B <= alpha) :
    PlaquetteKPBound Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha := by
  refine
    plaquetteKPBound_of_closedTouchNeighborhood_positiveAreaBounds Adj
      ConnectedSupport NontrivialLabel gammaAbs hgamma alpha halpha B
      hArea ?_
  intro X
  have hSupport_nonneg : 0 <= (X.support.card : Real) := by
    exact_mod_cast Nat.zero_le X.support.card
  calc
    ((closedTouchNeighborhood Adj X.support).card : Real) *
        (Finset.Icc 1 (Fintype.card P)).sum B
        <= (C * (X.support.card : Real)) *
            (Finset.Icc 1 (Fintype.card P)).sum B := by
          exact mul_le_mul_of_nonneg_right (hCard X) hBsum_nonneg
    _ = (X.support.card : Real) *
          (C * (Finset.Icc 1 (Fintype.card P)).sum B) := by
          ring
    _ <= (X.support.card : Real) * alpha := by
          exact mul_le_mul_of_nonneg_left hsmall hSupport_nonneg
    _ = alpha * (X.support.card : Real) := by
          ring

/-- A real-valued growth-constant version of
`plaquetteKPBound_of_closedTouchNeighborhood_anchorBound`.

This is useful when a concrete plaquette geometry proves the closed
touch-neighborhood estimate directly as
`card N(A) <= C * card A`, rather than through a natural-number singleton
degree.  The theorem remains conditional: it assumes the anchored polymer-sum
bound `B` and the scalar smallness inequality `C * B <= alpha`. -/
theorem plaquetteKPBound_of_realClosedNeighborhood_anchorBound
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (C B : Real) (hB_nonneg : 0 <= B)
    (hCard : forall X : PlaquettePolymer P Rlab ConnectedSupport
        NontrivialLabel,
      ((closedTouchNeighborhood Adj X.support).card : Real) <=
        C * (X.support.card : Real))
    (hAnchor : forall X : PlaquettePolymer P Rlab ConnectedSupport
        NontrivialLabel,
      forall q : P, q ∈ closedTouchNeighborhood Adj X.support ->
        (Finset.univ.filter
          (fun Y : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel =>
            decide (q ∈ Y.support) = true)).sum
          (fun Y =>
            Y.coeffProduct gammaAbs *
              Real.exp (alpha * (Y.support.card : Real))) <= B)
    (hsmall : C * B <= alpha) :
    PlaquetteKPBound Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha := by
  refine
    plaquetteKPBound_of_closedTouchNeighborhood_anchorBound Adj
      ConnectedSupport NontrivialLabel gammaAbs hgamma alpha halpha B
      hAnchor ?_
  intro X
  have hSupport_nonneg : 0 <= (X.support.card : Real) := by
    exact_mod_cast Nat.zero_le X.support.card
  calc
    ((closedTouchNeighborhood Adj X.support).card : Real) * B
        <= (C * (X.support.card : Real)) * B := by
          exact mul_le_mul_of_nonneg_right (hCard X) hB_nonneg
    _ = (X.support.card : Real) * (C * B) := by ring
    _ <= (X.support.card : Real) * alpha := by
          exact mul_le_mul_of_nonneg_left hsmall hSupport_nonneg
    _ = alpha * (X.support.card : Real) := by ring

/-- A reusable sufficient condition for the explicit finite plaquette-polymer
KP bound.

If every singleton closed touch-neighborhood has degree at most `D`, every
anchored polymer sum is at most `B`, and `(D : Real) * B <= alpha`, then the
localized overcount proves `PlaquetteKPBound`.  This is still conditional:
the theorem does not choose a geometry-specific `D` or prove the anchored
strong-coupling estimate `B`. -/
theorem plaquetteKPBound_of_singletonBound_anchorBound
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (D : Nat) (B : Real) (hB_nonneg : 0 <= B)
    (hD : forall p : P,
      (closedTouchNeighborhood Adj ({p} : Finset P)).card <= D)
    (hAnchor : forall q : P,
      (Finset.univ.filter
        (fun Y : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel =>
          decide (q ∈ Y.support) = true)).sum
        (fun Y =>
          Y.coeffProduct gammaAbs *
            Real.exp (alpha * (Y.support.card : Real))) <= B)
    (hsmall : (D : Real) * B <= alpha) :
    PlaquetteKPBound Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha := by
  intro X
  have hProduct :=
    plaquetteKPSum_le_card_mul_singletonBound_mul_anchorBound Adj
      ConnectedSupport NontrivialLabel gammaAbs hgamma alpha halpha X
      D B hB_nonneg hD (fun q _hq => hAnchor q)
  have hScale :
      ((X.support.card * D : Nat) : Real) * B
        <= alpha * (X.support.card : Real) := by
    calc
      ((X.support.card * D : Nat) : Real) * B
          = (X.support.card : Real) * ((D : Real) * B) := by
            norm_num [Nat.cast_mul]
            ring
      _ <= (X.support.card : Real) * alpha := by
            exact mul_le_mul_of_nonneg_left hsmall (Nat.cast_nonneg _)
      _ = alpha * (X.support.card : Real) := by
            ring
  exact hProduct.trans hScale

/-- A singleton-degree version of the area-sliced KP-bound adapter.

If every singleton closed touch-neighborhood has degree at most `D`, and the
uniform per-area anchored-slice bounds have total smallness
`D * sum_k B k <= alpha`, then `PlaquetteKPBound` follows. -/
theorem plaquetteKPBound_of_singletonBound_areaBounds
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (D : Nat) (B : Nat -> Real)
    (hBsum_nonneg : 0 <= (Finset.range (Fintype.card P + 1)).sum B)
    (hD : forall p : P,
      (closedTouchNeighborhood Adj ({p} : Finset P)).card <= D)
    (hArea : forall q : P,
      forall k : Nat, k ∈ Finset.range (Fintype.card P + 1) ->
        anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
          gammaAbs alpha q k <= B k)
    (hsmall : (D : Real) * (Finset.range (Fintype.card P + 1)).sum B
      <= alpha) :
    PlaquetteKPBound Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha := by
  refine
    plaquetteKPBound_of_realClosedNeighborhood_areaBounds Adj
      ConnectedSupport NontrivialLabel gammaAbs hgamma alpha halpha
      (D : Real) B hBsum_nonneg ?_ ?_ hsmall
  · intro X
    have hCard :
        (closedTouchNeighborhood Adj X.support).card <= X.support.card * D :=
      card_closedTouchNeighborhood_le_card_mul_singletonBound Adj
        X.support D hD
    calc
      ((closedTouchNeighborhood Adj X.support).card : Real)
          <= ((X.support.card * D : Nat) : Real) := by
            exact_mod_cast hCard
      _ = (D : Real) * (X.support.card : Real) := by
            norm_num [Nat.cast_mul]
            ring
  · intro _X q _hq k hk
    exact hArea q k hk

/-- Singleton-degree version of the positive-area KP-bound adapter. -/
theorem plaquetteKPBound_of_singletonBound_positiveAreaBounds
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (D : Nat) (B : Nat -> Real)
    (hBsum_nonneg : 0 <= (Finset.Icc 1 (Fintype.card P)).sum B)
    (hD : forall p : P,
      (closedTouchNeighborhood Adj ({p} : Finset P)).card <= D)
    (hArea : forall q : P,
      forall k : Nat, k ∈ Finset.Icc 1 (Fintype.card P) ->
        anchoredPlaquettePolymerAreaSum ConnectedSupport NontrivialLabel
          gammaAbs alpha q k <= B k)
    (hsmall : (D : Real) * (Finset.Icc 1 (Fintype.card P)).sum B
      <= alpha) :
    PlaquetteKPBound Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha := by
  refine
    plaquetteKPBound_of_realClosedNeighborhood_positiveAreaBounds Adj
      ConnectedSupport NontrivialLabel gammaAbs hgamma alpha halpha
      (D : Real) B hBsum_nonneg ?_ ?_ hsmall
  · intro X
    have hCard :
        (closedTouchNeighborhood Adj X.support).card <= X.support.card * D :=
      card_closedTouchNeighborhood_le_card_mul_singletonBound Adj
        X.support D hD
    calc
      ((closedTouchNeighborhood Adj X.support).card : Real)
          <= ((X.support.card * D : Nat) : Real) := by
            exact_mod_cast hCard
      _ = (D : Real) * (X.support.card : Real) := by
            norm_num [Nat.cast_mul]
            ring
  · intro _X q _hq k hk
    exact hArea q k hk

/-- An explicit finite plaquette-polymer KP bound implies the abstract
`KPCondition` for the conservative Q7 polymer system.

This is only an adapter theorem: it does not prove the finite sum bound, and
therefore does not claim any volume-uniform strong-coupling constants. -/
theorem kpCondition_of_plaquetteKPBound
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (hBound : PlaquetteKPBound Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha) :
    KPCondition
      (plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
        gammaAbs alpha halpha)
      (plaquettePolymerIncompatibleDecidable Adj ConnectedSupport
        NontrivialLabel gammaAbs alpha halpha) := by
  intro X
  calc
    (∑ Y ∈ Finset.univ.filter
        (fun Y =>
          @Decidable.decide _
            (plaquettePolymerIncompatibleDecidable Adj ConnectedSupport
              NontrivialLabel gammaAbs alpha halpha X Y) = true),
      |(plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
        gammaAbs alpha halpha).weight Y| *
        Real.exp ((plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
          gammaAbs alpha halpha).energy Y))
        = plaquetteKPSum Adj ConnectedSupport NontrivialLabel
            gammaAbs alpha halpha X := by
          apply Finset.sum_congr rfl
          intro Y _hY
          rw [plaquettePolymerSystem_weight,
            abs_of_nonneg (Y.coeffProduct_nonneg gammaAbs hgamma),
            plaquettePolymerSystem_energy]
    _ <= alpha * (X.support.card : Real) := hBound X
    _ = (plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
          gammaAbs alpha halpha).energy X := by
        rw [plaquettePolymerSystem_energy]

/-- The Q7 polymer system supplies the exact input pair expected by the
corrected Q6 convergence interface: a conditional `KPCondition` and the
self-incompatibility convention for the conservative overlap-or-touch system.

This remains conditional on the explicit finite bound `hBound`; it does not
prove a concrete finite or volume-uniform KP estimate. -/
theorem kpCondition_and_selfIncompatible_of_plaquetteKPBound
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (hBound : PlaquetteKPBound Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha) :
    KPCondition
        (plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
          gammaAbs alpha halpha)
        (plaquettePolymerIncompatibleDecidable Adj ConnectedSupport
          NontrivialLabel gammaAbs alpha halpha)
      /\ (forall X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel,
        (plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
          gammaAbs alpha halpha).incompatible X X) :=
  ⟨kpCondition_of_plaquetteKPBound Adj ConnectedSupport NontrivialLabel
      gammaAbs hgamma alpha halpha hBound,
    fun X => plaquettePolymerSystem_self_incompatible Adj ConnectedSupport
      NontrivialLabel gammaAbs alpha halpha X⟩

/-- Conditional Q7-to-Q6 convergence connector.

An explicit finite plaquette-polymer KP bound gives the abstract
`KPCondition`, and the conservative overlap-or-touch system is
self-incompatible because every polymer has nonempty support.  Therefore the
corrected Q6 convergence statement applies to this Q7 polymer system.

Draft boundary: this theorem is only as complete as
`PolymerKPConclusion.kp_convergence_bound_of_selfIncompatible`, which is still
the parked Q6 cluster-expansion theorem.  It records the interface wiring; it
does not prove the cluster-expansion estimate itself. -/
theorem plaquetteKP_convergence_bound_of_plaquetteKPBound
    (Adj : PlaquetteAdjacency P) [DecidableRel Adj.touch]
    (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop)
    (gammaAbs : Rlab -> Real) (hgamma : forall r, 0 <= gammaAbs r)
    (alpha : Real) (halpha : 0 <= alpha)
    (hBound : PlaquetteKPBound Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha)
    (D : PolymerKPConclusion.ClusterCoeffData
      (plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
        gammaAbs alpha halpha)
      (plaquettePolymerIncompatibleDecidable Adj ConnectedSupport
        NontrivialLabel gammaAbs alpha halpha))
    (X0 : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) :
    (tsum (fun X : {X : PolymerKPConclusion.Cluster
        (plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
          gammaAbs alpha halpha) //
        X.Connected
          (plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
            gammaAbs alpha halpha)
          (plaquettePolymerIncompatibleDecidable Adj ConnectedSupport
            NontrivialLabel gammaAbs alpha halpha) /\
        X.Touches
          (plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
            gammaAbs alpha halpha) X0} =>
      |D.coeff X.1| *
        X.1.absWeight
          (plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
            gammaAbs alpha halpha) *
        Real.exp
          (X.1.energyOf
            (plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
              gammaAbs alpha halpha))))
      <= (plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
        gammaAbs alpha halpha).energy X0 := by
  exact PolymerKPConclusion.kp_convergence_bound_of_selfIncompatible
    (plaquettePolymerSystem Adj ConnectedSupport NontrivialLabel
      gammaAbs alpha halpha)
    (plaquettePolymerIncompatibleDecidable Adj ConnectedSupport
      NontrivialLabel gammaAbs alpha halpha)
    (plaquettePolymerSystem_self_incompatible Adj ConnectedSupport
      NontrivialLabel gammaAbs alpha halpha)
    D
    (kpCondition_of_plaquetteKPBound Adj ConnectedSupport NontrivialLabel
      gammaAbs hgamma alpha halpha hBound)
    X0

/-- Z2 strong-coupling coefficient used by the oracle fixture:
`|tanh beta|` for the unique nontrivial label. -/
def z2GammaAbs (beta : Real) (_ : PUnit) : Real :=
  |Real.tanh beta|

theorem z2GammaAbs_nonneg (beta : Real) (u : PUnit) :
    0 <= z2GammaAbs beta u := by
  exact abs_nonneg _

/-- Z2 specialization: the polymer weight is `|tanh beta| ^ area`. -/
theorem z2_plaquettePolymer_weight_eq_abs_tanh_area
    (Adj : PlaquetteAdjacency P)
    (ConnectedSupport : Finset P -> Prop)
    (beta alpha : Real) (halpha : 0 <= alpha)
    (X : PlaquettePolymer P PUnit ConnectedSupport (fun _ => True)) :
    (plaquettePolymerSystem Adj ConnectedSupport (fun _ : PUnit => True)
      (z2GammaAbs beta) alpha halpha).weight X =
      |Real.tanh beta| ^ X.support.card := by
  simp [plaquettePolymerSystem, PlaquettePolymer.coeffProduct, z2GammaAbs,
    Finset.prod_const, Finset.card_attach]

/-- For `0 <= beta`, `tanh beta` is nonnegative, so `|tanh beta| = tanh beta`. -/
theorem tanh_nonneg_of_nonneg {beta : Real} (hbeta : 0 <= beta) :
    0 <= Real.tanh beta := by
  rw [Real.tanh_eq_sinh_div_cosh]
  exact div_nonneg (Real.sinh_nonneg_iff.mpr hbeta)
    (le_of_lt (Real.cosh_pos beta))

/-- Z2 specialization at `0 <= beta`: the polymer weight is
`tanh beta ^ area`, with no absolute value.  This is the honest KP weight
statement in the physical regime `beta >= 0`, where the character coefficient
is already nonnegative. -/
theorem z2_plaquettePolymer_weight_eq_tanh_area
    (Adj : PlaquetteAdjacency P)
    (ConnectedSupport : Finset P -> Prop)
    (beta alpha : Real) (halpha : 0 <= alpha) (hbeta : 0 <= beta)
    (X : PlaquettePolymer P PUnit ConnectedSupport (fun _ => True)) :
    (plaquettePolymerSystem Adj ConnectedSupport (fun _ : PUnit => True)
      (z2GammaAbs beta) alpha halpha).weight X =
      Real.tanh beta ^ X.support.card := by
  rw [z2_plaquettePolymer_weight_eq_abs_tanh_area,
    abs_of_nonneg (tanh_nonneg_of_nonneg hbeta)]

/-- Z2 specialization: the KP energy is `alpha * area`. -/
theorem z2_plaquettePolymer_energy_eq_alpha_area
    (Adj : PlaquetteAdjacency P)
    (ConnectedSupport : Finset P -> Prop)
    (beta alpha : Real) (halpha : 0 <= alpha)
    (X : PlaquettePolymer P PUnit ConnectedSupport (fun _ => True)) :
    (plaquettePolymerSystem Adj ConnectedSupport (fun _ : PUnit => True)
      (z2GammaAbs beta) alpha halpha).energy X =
      alpha * (X.support.card : Real) :=
  rfl

/-- The one-plaquette Z2 fixture has no distinct touching neighbors.  This is a
finite sanity model for the Q7 KP adapters, not a volume-uniform lattice
estimate. -/
def onePlaquetteAdj : PlaquetteAdjacency PUnit where
  touch := fun _ _ => False
  touch_symm := by
    intro p q h
    exact False.elim h

omit [Fintype P] [DecidableEq P] [Fintype Rlab] in
/-- Decidability for the no-touch one-plaquette adjacency. -/
instance onePlaquetteAdj_decidableRel : DecidableRel onePlaquetteAdj.touch := by
  intro p q
  exact isFalse (fun h => h)

/-- All nonempty supports in the one-plaquette fixture are connected. -/
def onePlaquetteConnectedSupport (_ : Finset PUnit) : Prop := True

/-- The unique Z2 nontrivial label in the one-plaquette fixture. -/
def onePlaquetteNontrivialLabel (_ : PUnit) : Prop := True

/-- The unique plaquette polymer in the one-plaquette Z2 fixture. -/
def onePlaquettePolymer :
    PlaquettePolymer PUnit PUnit onePlaquetteConnectedSupport
      onePlaquetteNontrivialLabel where
  support := Finset.univ
  support_nonempty := by
    exact ⟨PUnit.unit, by simp⟩
  support_connected := trivial
  label := fun _ => PUnit.unit
  label_nontrivial := fun _ => trivial

/-- Every polymer in the one-plaquette fixture uses the whole one-point support. -/
theorem onePlaquette_support_eq_univ
    (X : PlaquettePolymer PUnit PUnit onePlaquetteConnectedSupport
      onePlaquetteNontrivialLabel) :
    X.support = Finset.univ := by
  ext p
  constructor
  · intro _hp
    simp
  · intro _hp
    rcases X.support_nonempty with ⟨q, hq⟩
    cases p
    cases q
    exact hq

/-- The one-plaquette fixture has exactly one polymer. -/
theorem onePlaquettePolymer_eq
    (X : PlaquettePolymer PUnit PUnit onePlaquetteConnectedSupport
      onePlaquetteNontrivialLabel) :
    X = onePlaquettePolymer := by
  apply PlaquettePolymer.ext_of_support_label
  · exact onePlaquette_support_eq_univ X
  · intro p hpX _hpY
    cases p
    cases X.label ⟨PUnit.unit, hpX⟩
    rfl

/-- Every polymer in the one-plaquette fixture has support-cardinality one. -/
theorem onePlaquette_support_card_eq_one
    (X : PlaquettePolymer PUnit PUnit onePlaquetteConnectedSupport
      onePlaquetteNontrivialLabel) :
    X.support.card = 1 := by
  rw [onePlaquette_support_eq_univ X]
  simp

/-- The closed touch-neighborhood of the unique plaquette has cardinality one. -/
theorem onePlaquette_closedTouchNeighborhood_card_le_one (p : PUnit) :
    (closedTouchNeighborhood onePlaquetteAdj ({p} : Finset PUnit)).card <= 1 := by
  have hset :
      closedTouchNeighborhood onePlaquetteAdj ({p} : Finset PUnit) = {p} := by
    ext q
    cases p
    cases q
    simp [closedTouchNeighborhood, onePlaquetteAdj]
  rw [hset]
  simp

/-- The anchored Z2 polymer sum in the one-plaquette fixture is the single
weight `|tanh beta| * exp alpha`. -/
theorem onePlaquetteZ2_anchor_sum
    (beta alpha : Real) (q : PUnit) :
    (Finset.univ.filter
      (fun Y : PlaquettePolymer PUnit PUnit onePlaquetteConnectedSupport
        onePlaquetteNontrivialLabel =>
        decide (q ∈ Y.support) = true)).sum
      (fun Y =>
        Y.coeffProduct (z2GammaAbs beta) *
          Real.exp (alpha * (Y.support.card : Real))) =
      |Real.tanh beta| * Real.exp alpha := by
  let Y0 := onePlaquettePolymer
  rw [Finset.sum_eq_single Y0]
  · simp [Y0, onePlaquettePolymer, PlaquettePolymer.coeffProduct,
      z2GammaAbs]
  · intro Y _hY hne
    exact False.elim (hne (onePlaquettePolymer_eq Y))
  · intro hnot
    exfalso
    apply hnot
    simp [Y0, onePlaquettePolymer]

/-- The one-plaquette Z2 area slice is supported only in area one. -/
theorem onePlaquetteZ2_anchor_area_sum
    (beta alpha : Real) (q : PUnit) (k : Nat) :
    anchoredPlaquettePolymerAreaSum onePlaquetteConnectedSupport
      onePlaquetteNontrivialLabel (z2GammaAbs beta) alpha q k =
      if k = 1 then |Real.tanh beta| * Real.exp alpha else 0 := by
  by_cases hk : k = 1
  · subst k
    let Y0 := onePlaquettePolymer
    unfold anchoredPlaquettePolymerAreaSum
    rw [Finset.sum_eq_single Y0]
    · simp [Y0, onePlaquettePolymer, PlaquettePolymer.coeffProduct,
        z2GammaAbs]
    · intro Y _hY hne
      exact False.elim (hne (onePlaquettePolymer_eq Y))
    · intro hnot
      exfalso
      apply hnot
      simp [Y0, onePlaquettePolymer]
  · unfold anchoredPlaquettePolymerAreaSum
    rw [if_neg hk]
    apply Finset.sum_eq_zero
    intro Y hY
    rcases (Finset.mem_filter.1 hY).2 with ⟨_hq, hcard⟩
    have hcard_one : Y.support.card = 1 :=
      onePlaquette_support_card_eq_one Y
    rw [hcard] at hcard_one
    exact False.elim (hk hcard_one)

/-- In the one-plaquette Z2 fixture, the explicit rooted KP sum has exactly one
term. -/
theorem onePlaquetteZ2_plaquetteKPSum
    (beta alpha : Real) (halpha : 0 <= alpha)
    (X : PlaquettePolymer PUnit PUnit onePlaquetteConnectedSupport
      onePlaquetteNontrivialLabel) :
    plaquetteKPSum onePlaquetteAdj onePlaquetteConnectedSupport
      onePlaquetteNontrivialLabel (z2GammaAbs beta) alpha halpha X =
      |Real.tanh beta| * Real.exp alpha := by
  let Y0 := onePlaquettePolymer
  rw [plaquetteKPSum, Finset.sum_eq_single Y0]
  · simp [Y0, onePlaquettePolymer, PlaquettePolymer.coeffProduct,
      z2GammaAbs]
  · intro Y _hY hne
    exact False.elim (hne (onePlaquettePolymer_eq Y))
  · intro hnot
    exfalso
    have hP : PUnit.unit ∈ X.support := by
      rw [onePlaquette_support_eq_univ X]
      simp
    have hInc : SupportsOverlapOrTouch onePlaquetteAdj X.support Y0.support := by
      exact Or.inl ⟨PUnit.unit, hP, by simp [Y0, onePlaquettePolymer]⟩
    apply hnot
    simp [Y0, plaquettePolymerSystem, hInc]

/-- Concrete one-plaquette Z2 KP fixture.

If the single scalar contribution `|tanh beta| * exp alpha` is at most
`alpha`, then the explicit Q7 `PlaquetteKPBound` holds for the one-plaquette
system.  This is a finite sanity check for the adapter theorem, not a
volume-uniform strong-coupling estimate. -/
theorem onePlaquetteZ2_plaquetteKPBound
    (beta alpha : Real) (halpha : 0 <= alpha)
    (hsmall : |Real.tanh beta| * Real.exp alpha <= alpha) :
    PlaquetteKPBound onePlaquetteAdj onePlaquetteConnectedSupport
      onePlaquetteNontrivialLabel (z2GammaAbs beta) alpha halpha := by
  have hB_nonneg : 0 <= |Real.tanh beta| * Real.exp alpha :=
    mul_nonneg (abs_nonneg _) (le_of_lt (Real.exp_pos _))
  have hsmall' :
      ((1 : Nat) : Real) * (|Real.tanh beta| * Real.exp alpha) <= alpha := by
    simpa using hsmall
  exact
    plaquetteKPBound_of_singletonBound_anchorBound onePlaquetteAdj
      onePlaquetteConnectedSupport onePlaquetteNontrivialLabel
      (z2GammaAbs beta) (z2GammaAbs_nonneg beta) alpha halpha
      1 (|Real.tanh beta| * Real.exp alpha) hB_nonneg
      (fun p => onePlaquette_closedTouchNeighborhood_card_le_one p)
      (fun q => by
        rw [onePlaquetteZ2_anchor_sum beta alpha q])
      hsmall'

/-- Concrete one-plaquette Z2 KP fixture through the area-slice adapter.

This is propositionally the same scalar smallness statement as
`onePlaquetteZ2_plaquetteKPBound`, but it exercises the support-cardinality
slice route used by later support-counting estimates. -/
theorem onePlaquetteZ2_plaquetteKPBound_areaSlice
    (beta alpha : Real) (halpha : 0 <= alpha)
    (hsmall : |Real.tanh beta| * Real.exp alpha <= alpha) :
    PlaquetteKPBound onePlaquetteAdj onePlaquetteConnectedSupport
      onePlaquetteNontrivialLabel (z2GammaAbs beta) alpha halpha := by
  let B : Nat -> Real :=
    fun k => if k = 1 then |Real.tanh beta| * Real.exp alpha else 0
  have hBsum :
      (Finset.range (Fintype.card PUnit + 1)).sum B =
        |Real.tanh beta| * Real.exp alpha := by
    simp [B]
  have hBsum_nonneg :
      0 <= (Finset.range (Fintype.card PUnit + 1)).sum B := by
    rw [hBsum]
    exact mul_nonneg (abs_nonneg _) (le_of_lt (Real.exp_pos _))
  have hsmall' :
      ((1 : Nat) : Real) *
          (Finset.range (Fintype.card PUnit + 1)).sum B <= alpha := by
    rw [hBsum]
    simpa using hsmall
  exact
    plaquetteKPBound_of_singletonBound_areaBounds onePlaquetteAdj
      onePlaquetteConnectedSupport onePlaquetteNontrivialLabel
      (z2GammaAbs beta) (z2GammaAbs_nonneg beta) alpha halpha
      1 B hBsum_nonneg
      (fun p => onePlaquette_closedTouchNeighborhood_card_le_one p)
      (fun q k _hk => by
        rw [onePlaquetteZ2_anchor_area_sum beta alpha q k])
      hsmall'

/-- One-plaquette Z2 KP fixture through the positive-area slice adapter.

This exercises the `Finset.Icc 1 (Fintype.card P)` support-counting surface
used by the current Q7 landing pad. -/
theorem onePlaquetteZ2_plaquetteKPBound_positiveAreaSlice
    (beta alpha : Real) (halpha : 0 <= alpha)
    (hsmall : |Real.tanh beta| * Real.exp alpha <= alpha) :
    PlaquetteKPBound onePlaquetteAdj onePlaquetteConnectedSupport
      onePlaquetteNontrivialLabel (z2GammaAbs beta) alpha halpha := by
  let B : Nat -> Real :=
    fun k => if k = 1 then |Real.tanh beta| * Real.exp alpha else 0
  have hBsum :
      (Finset.Icc 1 (Fintype.card PUnit)).sum B =
        |Real.tanh beta| * Real.exp alpha := by
    simp [B]
  have hBsum_nonneg :
      0 <= (Finset.Icc 1 (Fintype.card PUnit)).sum B := by
    rw [hBsum]
    exact mul_nonneg (abs_nonneg _) (le_of_lt (Real.exp_pos _))
  have hsmall' :
      ((1 : Nat) : Real) *
          (Finset.Icc 1 (Fintype.card PUnit)).sum B <= alpha := by
    rw [hBsum]
    simpa using hsmall
  exact
    plaquetteKPBound_of_singletonBound_positiveAreaBounds onePlaquetteAdj
      onePlaquetteConnectedSupport onePlaquetteNontrivialLabel
      (z2GammaAbs beta) (z2GammaAbs_nonneg beta) alpha halpha
      1 B hBsum_nonneg
      (fun p => onePlaquette_closedTouchNeighborhood_card_le_one p)
      (fun q k _hk => by
        rw [onePlaquetteZ2_anchor_area_sum beta alpha q k])
      hsmall'

/-- A more usable one-plaquette smallness threshold: bounding the Z2
coefficient by `alpha * exp(-alpha)` implies the scalar KP smallness condition
used by `onePlaquetteZ2_plaquetteKPBound`. -/
theorem onePlaquetteZ2_smallness_of_abs_tanh_le
    (beta alpha : Real)
    (hsmall : |Real.tanh beta| <= alpha * Real.exp (-alpha)) :
    |Real.tanh beta| * Real.exp alpha <= alpha := by
  calc
    |Real.tanh beta| * Real.exp alpha
        <= (alpha * Real.exp (-alpha)) * Real.exp alpha := by
          exact mul_le_mul_of_nonneg_right hsmall
            (le_of_lt (Real.exp_pos alpha))
    _ = alpha := by
          rw [Real.exp_neg, mul_assoc,
            inv_mul_cancel₀ (Real.exp_pos alpha).ne', mul_one]

/-- One-plaquette Z2 KP fixture under the explicit threshold
`|tanh beta| <= alpha * exp(-alpha)`. -/
theorem onePlaquetteZ2_plaquetteKPBound_of_abs_tanh_le
    (beta alpha : Real) (halpha : 0 <= alpha)
    (hsmall : |Real.tanh beta| <= alpha * Real.exp (-alpha)) :
    PlaquetteKPBound onePlaquetteAdj onePlaquetteConnectedSupport
      onePlaquetteNontrivialLabel (z2GammaAbs beta) alpha halpha := by
  exact onePlaquetteZ2_plaquetteKPBound beta alpha halpha
    (onePlaquetteZ2_smallness_of_abs_tanh_le beta alpha hsmall)

/-- One-plaquette Z2 positive-area-slice fixture under the explicit threshold
`|tanh beta| <= alpha * exp(-alpha)`. -/
theorem onePlaquetteZ2_plaquetteKPBound_positiveAreaSlice_of_abs_tanh_le
    (beta alpha : Real) (halpha : 0 <= alpha)
    (hsmall : |Real.tanh beta| <= alpha * Real.exp (-alpha)) :
    PlaquetteKPBound onePlaquetteAdj onePlaquetteConnectedSupport
      onePlaquetteNontrivialLabel (z2GammaAbs beta) alpha halpha := by
  exact onePlaquetteZ2_plaquetteKPBound_positiveAreaSlice beta alpha halpha
    (onePlaquetteZ2_smallness_of_abs_tanh_le beta alpha hsmall)

/-- The one-plaquette Z2 fixture supplies an abstract `KPCondition` under the
same scalar smallness hypothesis.  This is the no-Q6 wrapper around
`onePlaquetteZ2_plaquetteKPBound`. -/
theorem onePlaquetteZ2_kpCondition
    (beta alpha : Real) (halpha : 0 <= alpha)
    (hsmall : |Real.tanh beta| * Real.exp alpha <= alpha) :
    KPCondition
      (plaquettePolymerSystem onePlaquetteAdj onePlaquetteConnectedSupport
        onePlaquetteNontrivialLabel (z2GammaAbs beta) alpha halpha)
      (plaquettePolymerIncompatibleDecidable onePlaquetteAdj
        onePlaquetteConnectedSupport onePlaquetteNontrivialLabel
        (z2GammaAbs beta) alpha halpha) := by
  exact
    kpCondition_of_plaquetteKPBound onePlaquetteAdj
      onePlaquetteConnectedSupport onePlaquetteNontrivialLabel
      (z2GammaAbs beta) (z2GammaAbs_nonneg beta) alpha halpha
      (onePlaquetteZ2_plaquetteKPBound beta alpha halpha hsmall)

/-- One-plaquette Z2 `KPCondition` under the explicit threshold
`|tanh beta| <= alpha * exp(-alpha)`. -/
theorem onePlaquetteZ2_kpCondition_of_abs_tanh_le
    (beta alpha : Real) (halpha : 0 <= alpha)
    (hsmall : |Real.tanh beta| <= alpha * Real.exp (-alpha)) :
    KPCondition
      (plaquettePolymerSystem onePlaquetteAdj onePlaquetteConnectedSupport
        onePlaquetteNontrivialLabel (z2GammaAbs beta) alpha halpha)
      (plaquettePolymerIncompatibleDecidable onePlaquetteAdj
        onePlaquetteConnectedSupport onePlaquetteNontrivialLabel
        (z2GammaAbs beta) alpha halpha) := by
  exact onePlaquetteZ2_kpCondition beta alpha halpha
    (onePlaquetteZ2_smallness_of_abs_tanh_le beta alpha hsmall)

/-- The one-plaquette Z2 fixture supplies the corrected Q6 input pair:
`KPCondition` plus self-incompatibility.  It still does not invoke the Q6
cluster-expansion conclusion. -/
theorem onePlaquetteZ2_kpCondition_and_selfIncompatible
    (beta alpha : Real) (halpha : 0 <= alpha)
    (hsmall : |Real.tanh beta| * Real.exp alpha <= alpha) :
    KPCondition
        (plaquettePolymerSystem onePlaquetteAdj onePlaquetteConnectedSupport
          onePlaquetteNontrivialLabel (z2GammaAbs beta) alpha halpha)
        (plaquettePolymerIncompatibleDecidable onePlaquetteAdj
          onePlaquetteConnectedSupport onePlaquetteNontrivialLabel
          (z2GammaAbs beta) alpha halpha)
      /\ (forall X : PlaquettePolymer PUnit PUnit onePlaquetteConnectedSupport
        onePlaquetteNontrivialLabel,
        (plaquettePolymerSystem onePlaquetteAdj onePlaquetteConnectedSupport
          onePlaquetteNontrivialLabel (z2GammaAbs beta) alpha halpha).incompatible
          X X) := by
  constructor
  · exact onePlaquetteZ2_kpCondition beta alpha halpha hsmall
  · intro X
    exact plaquettePolymerSystem_self_incompatible onePlaquetteAdj
      onePlaquetteConnectedSupport onePlaquetteNontrivialLabel
      (z2GammaAbs beta) alpha halpha X

/-- One-plaquette Z2 corrected Q6 input pair under the explicit threshold
`|tanh beta| <= alpha * exp(-alpha)`. -/
theorem onePlaquetteZ2_kpCondition_and_selfIncompatible_of_abs_tanh_le
    (beta alpha : Real) (halpha : 0 <= alpha)
    (hsmall : |Real.tanh beta| <= alpha * Real.exp (-alpha)) :
    KPCondition
        (plaquettePolymerSystem onePlaquetteAdj onePlaquetteConnectedSupport
          onePlaquetteNontrivialLabel (z2GammaAbs beta) alpha halpha)
        (plaquettePolymerIncompatibleDecidable onePlaquetteAdj
          onePlaquetteConnectedSupport onePlaquetteNontrivialLabel
          (z2GammaAbs beta) alpha halpha)
      /\ (forall X : PlaquettePolymer PUnit PUnit onePlaquetteConnectedSupport
        onePlaquetteNontrivialLabel,
        (plaquettePolymerSystem onePlaquetteAdj onePlaquetteConnectedSupport
          onePlaquetteNontrivialLabel (z2GammaAbs beta) alpha halpha).incompatible
          X X) := by
  exact onePlaquetteZ2_kpCondition_and_selfIncompatible beta alpha halpha
    (onePlaquetteZ2_smallness_of_abs_tanh_le beta alpha hsmall)

/-- One-plaquette Z2 corrected Q6 input pair through the positive-area-slice
fixture under the explicit threshold `|tanh beta| <= alpha * exp(-alpha)`.

This exposes the same finite sanity check as
`onePlaquetteZ2_kpCondition_and_selfIncompatible_of_abs_tanh_le`, but routes the
bound through the positive-area support-counting adapter surface. -/
theorem
    onePlaquetteZ2_kpCondition_and_selfIncompatible_positiveAreaSlice_of_abs_tanh_le
    (beta alpha : Real) (halpha : 0 <= alpha)
    (hsmall : |Real.tanh beta| <= alpha * Real.exp (-alpha)) :
    KPCondition
        (plaquettePolymerSystem onePlaquetteAdj onePlaquetteConnectedSupport
          onePlaquetteNontrivialLabel (z2GammaAbs beta) alpha halpha)
        (plaquettePolymerIncompatibleDecidable onePlaquetteAdj
          onePlaquetteConnectedSupport onePlaquetteNontrivialLabel
          (z2GammaAbs beta) alpha halpha)
      /\ (forall X : PlaquettePolymer PUnit PUnit onePlaquetteConnectedSupport
        onePlaquetteNontrivialLabel,
        (plaquettePolymerSystem onePlaquetteAdj onePlaquetteConnectedSupport
          onePlaquetteNontrivialLabel (z2GammaAbs beta) alpha halpha).incompatible
          X X) := by
  constructor
  · exact
      kpCondition_of_plaquetteKPBound onePlaquetteAdj
        onePlaquetteConnectedSupport onePlaquetteNontrivialLabel
        (z2GammaAbs beta) (z2GammaAbs_nonneg beta) alpha halpha
        (onePlaquetteZ2_plaquetteKPBound_positiveAreaSlice_of_abs_tanh_le
          beta alpha halpha hsmall)
  · intro X
    exact plaquettePolymerSystem_self_incompatible onePlaquetteAdj
      onePlaquetteConnectedSupport onePlaquetteNontrivialLabel
      (z2GammaAbs beta) alpha halpha X

/-- Nonnegativity witness for the explicit `alpha = 1` one-plaquette threshold. -/
def onePlaquetteZ2_alphaOne_nonneg : (0 : Real) <= 1 := by
  norm_num

/-- Concrete finite-Z2 strong-coupling prototype: if the unique nontrivial
character coefficient satisfies `|tanh beta| <= exp(-1)`, then the
one-plaquette polymer gas satisfies the corrected Q6 input pair at `alpha = 1`.

This is deliberately a finite one-plaquette rung.  It records the explicit
character/polymer smallness threshold selected by the OS1 finite-gauge route,
without claiming volume-uniform KP convergence or any SU(2) gap theorem. -/
theorem
    onePlaquetteZ2_kpCondition_and_selfIncompatible_alpha_one_of_abs_tanh_le_exp_neg_one
    (beta : Real)
    (hsmall : |Real.tanh beta| <= Real.exp (-1)) :
    KPCondition
        (plaquettePolymerSystem onePlaquetteAdj onePlaquetteConnectedSupport
          onePlaquetteNontrivialLabel (z2GammaAbs beta) 1
          onePlaquetteZ2_alphaOne_nonneg)
        (plaquettePolymerIncompatibleDecidable onePlaquetteAdj
          onePlaquetteConnectedSupport onePlaquetteNontrivialLabel
          (z2GammaAbs beta) 1 onePlaquetteZ2_alphaOne_nonneg)
      /\ (forall X : PlaquettePolymer PUnit PUnit onePlaquetteConnectedSupport
        onePlaquetteNontrivialLabel,
        (plaquettePolymerSystem onePlaquetteAdj onePlaquetteConnectedSupport
          onePlaquetteNontrivialLabel (z2GammaAbs beta) 1
          onePlaquetteZ2_alphaOne_nonneg).incompatible X X) := by
  have hsmall' : |Real.tanh beta| <= (1 : Real) * Real.exp (-(1 : Real)) := by
    simpa using hsmall
  exact
    onePlaquetteZ2_kpCondition_and_selfIncompatible_positiveAreaSlice_of_abs_tanh_le
      beta 1 onePlaquetteZ2_alphaOne_nonneg hsmall'

/-- At zero coupling, the one-plaquette Z2 scalar smallness condition is
automatic for every nonnegative `alpha`. -/
theorem onePlaquetteZ2_smallness_beta_zero
    (alpha : Real) (halpha : 0 <= alpha) :
    |Real.tanh 0| * Real.exp alpha <= alpha := by
  simpa [Real.tanh_eq_sinh_div_cosh] using halpha

/-- At zero coupling, the one-plaquette Z2 rooted KP sum is zero. -/
theorem onePlaquetteZ2_plaquetteKPSum_beta_zero
    (alpha : Real) (halpha : 0 <= alpha)
    (X : PlaquettePolymer PUnit PUnit onePlaquetteConnectedSupport
      onePlaquetteNontrivialLabel) :
    plaquetteKPSum onePlaquetteAdj onePlaquetteConnectedSupport
      onePlaquetteNontrivialLabel (z2GammaAbs 0) alpha halpha X = 0 := by
  rw [onePlaquetteZ2_plaquetteKPSum 0 alpha halpha X]
  simp [Real.tanh_eq_sinh_div_cosh]

/-- Zero-coupling concrete one-plaquette Z2 `PlaquetteKPBound`. -/
theorem onePlaquetteZ2_plaquetteKPBound_beta_zero
    (alpha : Real) (halpha : 0 <= alpha) :
    PlaquetteKPBound onePlaquetteAdj onePlaquetteConnectedSupport
      onePlaquetteNontrivialLabel (z2GammaAbs 0) alpha halpha := by
  exact onePlaquetteZ2_plaquetteKPBound 0 alpha halpha
    (onePlaquetteZ2_smallness_beta_zero alpha halpha)

/-- Zero-coupling concrete one-plaquette Z2 `KPCondition`. -/
theorem onePlaquetteZ2_kpCondition_beta_zero
    (alpha : Real) (halpha : 0 <= alpha) :
    KPCondition
      (plaquettePolymerSystem onePlaquetteAdj onePlaquetteConnectedSupport
        onePlaquetteNontrivialLabel (z2GammaAbs 0) alpha halpha)
      (plaquettePolymerIncompatibleDecidable onePlaquetteAdj
        onePlaquetteConnectedSupport onePlaquetteNontrivialLabel
        (z2GammaAbs 0) alpha halpha) := by
  exact onePlaquetteZ2_kpCondition 0 alpha halpha
    (onePlaquetteZ2_smallness_beta_zero alpha halpha)

/-- Zero-coupling concrete one-plaquette Z2 corrected Q6 input pair. -/
theorem onePlaquetteZ2_kpCondition_and_selfIncompatible_beta_zero
    (alpha : Real) (halpha : 0 <= alpha) :
    KPCondition
        (plaquettePolymerSystem onePlaquetteAdj onePlaquetteConnectedSupport
          onePlaquetteNontrivialLabel (z2GammaAbs 0) alpha halpha)
        (plaquettePolymerIncompatibleDecidable onePlaquetteAdj
          onePlaquetteConnectedSupport onePlaquetteNontrivialLabel
          (z2GammaAbs 0) alpha halpha)
      /\ (forall X : PlaquettePolymer PUnit PUnit onePlaquetteConnectedSupport
        onePlaquetteNontrivialLabel,
        (plaquettePolymerSystem onePlaquetteAdj onePlaquetteConnectedSupport
          onePlaquetteNontrivialLabel (z2GammaAbs 0) alpha halpha).incompatible
          X X) := by
  exact onePlaquetteZ2_kpCondition_and_selfIncompatible 0 alpha halpha
    (onePlaquetteZ2_smallness_beta_zero alpha halpha)

end StrongCouplingPolymerMap
end GateYM
end NullEdge
end Draft
end PhysicsSM
