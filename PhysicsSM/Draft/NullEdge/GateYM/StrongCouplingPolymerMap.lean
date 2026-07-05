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

end StrongCouplingPolymerMap
end GateYM
end NullEdge
end Draft
end PhysicsSM
