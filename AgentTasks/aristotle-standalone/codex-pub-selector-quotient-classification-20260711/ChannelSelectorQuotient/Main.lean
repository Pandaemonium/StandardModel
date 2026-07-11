import Mathlib

/-!
# Selector-preserving quotient of a channel ambiguity group

Focused Paper F target. This defines the exact quotient resolved by a supplied
additive selector and identifies it with the selector range.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace ChannelSelectorQuotient

variable {H S : Type*} [AddCommGroup H] [AddCommGroup S]

abbrev SelectorQuotient (sigma : H →+ S) := H ⧸ sigma.ker

noncomputable def quotientEquivRange (sigma : H →+ S) :
    SelectorQuotient sigma ≃+ sigma.range :=
  QuotientAddGroup.quotientKerEquivRange sigma

def classOf (sigma : H →+ S) (h : H) : SelectorQuotient sigma :=
  QuotientAddGroup.mk' sigma.ker h

/-- Two ambiguity directions represent the same selector-resolved class
exactly when the supplied selector cannot distinguish them. -/
theorem classOf_eq_iff (sigma : H →+ S) (h k : H) :
    classOf sigma h = classOf sigma k ↔ sigma h = sigma k := by
  sorry

theorem classOf_eq_zero_iff (sigma : H →+ S) (h : H) :
    classOf sigma h = 0 ↔ sigma h = 0 := by
  sorry

/-- The quotient is trivial exactly when the selector itself is zero. -/
theorem subsingleton_quotient_iff (sigma : H →+ S) :
    Subsingleton (SelectorQuotient sigma) ↔ sigma = 0 := by
  sorry

theorem quotient_nontrivial_of_selector_ne_zero (sigma : H →+ S)
    (hsigma : sigma ≠ 0) : Nontrivial (SelectorQuotient sigma) := by
  sorry

/-- A selector is injective exactly when its selector-resolved quotient forgets
nothing. -/
theorem injective_iff_ker_bot (sigma : H →+ S) :
    Function.Injective sigma ↔ sigma.ker = ⊥ := by
  sorry

end ChannelSelectorQuotient
