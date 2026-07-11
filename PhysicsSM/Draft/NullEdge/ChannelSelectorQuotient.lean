import Mathlib

/-!
# Selector-preserving quotient of a channel ambiguity group

For a supplied additive selector `sigma : H ->+ S`, this module defines the
exact ambiguity quotient `H / ker sigma` and identifies it canonically with the
selector range. Two directions represent the same quotient class exactly when
the selector gives them the same value.

This is standard first-isomorphism infrastructure, not a new physical selector.
The quotient becomes a physical equivalence only after `sigma` is justified by
dynamics, locality, positivity, measurement, or an information principle.

Provenance: theorem statements and proofs from Aristotle project
`24d6b0ef-6de2-424c-90fc-349efa0f0dfe`, rebuilt under Lean 4.28.0.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace PhysicsSM.Draft.NullEdge.ChannelSelectorQuotient

variable {H S : Type*} [AddCommGroup H] [AddCommGroup S]

abbrev SelectorQuotient (sigma : H →+ S) := H ⧸ sigma.ker

/-- Additive first isomorphism theorem for the selector-resolved quotient. -/
noncomputable def quotientEquivRange (sigma : H →+ S) :
    SelectorQuotient sigma ≃+ sigma.range :=
  QuotientAddGroup.quotientKerEquivRange sigma

def classOf (sigma : H →+ S) (h : H) : SelectorQuotient sigma :=
  QuotientAddGroup.mk' sigma.ker h

/-- Two ambiguity directions represent the same selector-resolved class
exactly when the supplied selector cannot distinguish them. -/
theorem classOf_eq_iff (sigma : H →+ S) (h k : H) :
    classOf sigma h = classOf sigma k ↔ sigma h = sigma k := by
  rw [classOf, classOf, QuotientAddGroup.mk'_eq_mk']
  simp only [AddMonoidHom.mem_ker]
  constructor
  · rintro ⟨g, hg, hgk⟩
    have hmapped : sigma (h + g) = sigma k := by rw [hgk]
    rw [map_add, hg, add_zero] at hmapped
    exact hmapped
  · intro hhk
    refine ⟨-h + k, ?_, by abel⟩
    rw [map_add, map_neg, hhk, neg_add_cancel]

theorem classOf_eq_zero_iff (sigma : H →+ S) (h : H) :
    classOf sigma h = 0 ↔ sigma h = 0 := by
  convert QuotientAddGroup.eq_zero_iff _

/-- The quotient is trivial exactly when the selector itself is zero. -/
theorem subsingleton_quotient_iff (sigma : H →+ S) :
    Subsingleton (SelectorQuotient sigma) ↔ sigma = 0 := by
  constructor
  · intro hsub
    ext x
    have hclasses := hsub.elim (classOf sigma x) 0
    simpa [classOf_eq_zero_iff] using hclasses
  · intro hsigma
    refine ⟨fun x y => ?_⟩
    obtain ⟨x, rfl⟩ := QuotientAddGroup.mk_surjective x
    obtain ⟨y, rfl⟩ := QuotientAddGroup.mk_surjective y
    change QuotientAddGroup.mk' sigma.ker x =
      QuotientAddGroup.mk' sigma.ker y
    rw [QuotientAddGroup.mk'_eq_mk']
    refine ⟨-x + y, ?_, by abel⟩
    subst hsigma
    simp

theorem quotient_nontrivial_of_selector_ne_zero (sigma : H →+ S)
    (hsigma : sigma ≠ 0) : Nontrivial (SelectorQuotient sigma) := by
  obtain ⟨h, hh⟩ : ∃ h : H, sigma h ≠ 0 := by
    exact not_forall.mp fun h => hsigma <| AddMonoidHom.ext h
  have hne : classOf sigma h ≠ 0 := by
    exact fun hzero => hh <| (classOf_eq_zero_iff sigma h).1 hzero
  exact ⟨classOf sigma h, 0, hne⟩

/-- A selector is injective exactly when its kernel is trivial. -/
theorem injective_iff_ker_bot (sigma : H →+ S) :
    Function.Injective sigma ↔ sigma.ker = ⊥ :=
  (AddMonoidHom.ker_eq_bot_iff sigma).symm

/-! ## Build-enforced assumption-footprint pins -/

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelSelectorQuotient.classOf_eq_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms classOf_eq_iff

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelSelectorQuotient.subsingleton_quotient_iff' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms subsingleton_quotient_iff

/-- info: 'PhysicsSM.Draft.NullEdge.ChannelSelectorQuotient.quotient_nontrivial_of_selector_ne_zero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms quotient_nontrivial_of_selector_ne_zero

end PhysicsSM.Draft.NullEdge.ChannelSelectorQuotient
