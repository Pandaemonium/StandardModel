import PhysicsSM.Draft.NullEdge.ChannelRefinementTorsor

/-!
# A naturality no-go for channel selectors

The type-only fixed-total channel refinements form an additive torsor. This
module proves the corresponding selector obstruction: a score or predicate
invariant under every residual zero-sum translation cannot distinguish any two
refinements. In particular, if the ambiguity group has a nonzero direction,
no fully translation-invariant predicate can select a unique refinement.

This is deliberately a boundary theorem. It does not say that physical or
information-theoretic selectors are impossible. It says that a successful
selector must break the full type-only translation symmetry, or first quotient
by a smaller equivalence relation justified by additional structure.

Provenance: elementary torsor algebra, motivated by the Paper F classification
program and the selector-circularity warning from Aristotle project
`d4dfeb30-0871-473c-b1ae-a4ea14bb4b31`.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace PhysicsSM.Draft.NullEdge.ChannelNaturalityNoGo

open ChannelRefinementTorsor

/-- A function invariant under every translation of a torsor is constant. -/
theorem invariant_selector_constant
    {G P A : Type*} [AddGroup G] [AddTorsor G P]
    (selector : P -> A)
    (hinv : forall (g : G) (p : P), selector (g +ᵥ p) = selector p) :
    forall p q, selector p = selector q := by
  intro p q
  have h := hinv (p -ᵥ q) q
  simpa using h

/-- A translation-invariant predicate on a nontrivial torsor cannot have a
unique witness. -/
theorem no_unique_invariant_preferred
    {G P : Type*} [AddGroup G] [AddTorsor G P]
    (g : G) (hg : g ≠ 0)
    (preferred : P -> Prop)
    (hinv : forall (h : G) (p : P), preferred (h +ᵥ p) <-> preferred p) :
    ¬ (Exists fun p => preferred p /\ forall q, preferred q -> q = p) := by
  rintro ⟨p, hp, huniq⟩
  have hgp : preferred (g +ᵥ p) := (hinv g p).2 hp
  have heq : g +ᵥ p = p := huniq (g +ᵥ p) hgp
  apply hg
  have h := congrArg (fun q : P => q -ᵥ p) heq
  simpa using h

/-- If the retained type space has a nonzero direction, no predicate invariant
under all zero-sum channel shifts uniquely selects a fixed-total refinement. -/
theorem no_unique_type_invariant_refinement
    {V : Type*} [AddCommGroup V] {S : V}
    (v : V) (hv : v ≠ 0)
    (preferred : Refinement S -> Prop)
    (hinv : forall (h : ZeroSumShift V) (p : Refinement S),
      preferred (h +ᵥ p) <-> preferred p) :
    ¬ (Exists fun p => preferred p /\ forall q, preferred q -> q = p) := by
  obtain ⟨h, hh⟩ := nontrivial_shift_of_nonzero v hv
  exact no_unique_invariant_preferred h hh preferred hinv

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelNaturalityNoGo.invariant_selector_constant' does not depend on any axioms -/
#guard_msgs (whitespace := lax) in
#print axioms invariant_selector_constant

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelNaturalityNoGo.no_unique_invariant_preferred' depends on axioms: [propext] -/
#guard_msgs (whitespace := lax) in
#print axioms no_unique_invariant_preferred

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelNaturalityNoGo.no_unique_type_invariant_refinement' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms no_unique_type_invariant_refinement

end PhysicsSM.Draft.NullEdge.ChannelNaturalityNoGo
