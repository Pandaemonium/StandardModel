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

/-- Plaquette polymers as finite supports plus labels.

`ConnectedSupport` is abstract on purpose.  Q7 needs to connect several
possible finite plaquette geometries to Q6's polymer interface, and the first
freeze should not hard-code a particular graph-connectedness API. -/
abbrev PlaquettePolymer (P Rlab : Type*) [Fintype P] [DecidableEq P]
    [Fintype Rlab] (ConnectedSupport : Finset P -> Prop)
    (NontrivialLabel : Rlab -> Prop) :=
  {x : Finset P × (P -> Rlab) //
    x.1.Nonempty /\ ConnectedSupport x.1 /\
      forall p : P, p ∈ x.1 -> NontrivialLabel (x.2 p)}

namespace PlaquettePolymer

variable {ConnectedSupport : Finset P -> Prop}
variable {NontrivialLabel : Rlab -> Prop}

noncomputable instance fintype :
    Fintype (PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) := by
  classical
  unfold PlaquettePolymer
  infer_instance

/-- Finite plaquette support of a polymer. -/
def support (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) :
    Finset P :=
  X.1.1

/-- Label assigned to a plaquette.  Only values on `X.support` are
semantically meaningful. -/
def label (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) :
    P -> Rlab :=
  X.1.2

theorem support_nonempty
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) :
    X.support.Nonempty :=
  X.2.1

theorem support_connected
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) :
    ConnectedSupport X.support :=
  X.2.2.1

theorem label_nontrivial
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel)
    {p : P} (hp : p ∈ X.support) :
    NontrivialLabel (X.label p) :=
  X.2.2.2 p hp

/-- Product of absolute normalized character coefficients over the support. -/
def coeffProduct (gammaAbs : Rlab -> Real)
    (X : PlaquettePolymer P Rlab ConnectedSupport NontrivialLabel) : Real :=
  X.support.prod (fun p => gammaAbs (X.label p))

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
    Finset.prod_const]

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
