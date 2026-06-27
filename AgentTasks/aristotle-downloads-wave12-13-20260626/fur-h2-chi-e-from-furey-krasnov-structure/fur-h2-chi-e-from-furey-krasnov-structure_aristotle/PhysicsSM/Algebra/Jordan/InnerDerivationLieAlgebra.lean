import Mathlib
import PhysicsSM.Algebra.Jordan.InnerDerivation

/-!
# Algebra.Jordan.InnerDerivationLieAlgebra

The inner derivations of `h₃(𝕆)` form a Lie subalgebra of `Der(h₃(𝕆))`.

## Overview

The commutator bracket of two inner derivations `D_{a,b}` and `D_{c,d}`
satisfies:

```text
[D_{a,b}, D_{c,d}] = D_{D_{a,b}(c), d} + D_{c, D_{a,b}(d)}
```

This formula shows that the bracket of inner derivations is again a sum
of inner derivations, establishing that the span of inner derivations is
a Lie subalgebra of `Der(h₃(𝕆))`.

The proof uses only the Leibniz rule (derivation property) and linearity
of `D_{a,b}`, with no further appeal to the Jordan identity — all Jordan
identity usage is encapsulated in the proof that `D_{a,b}` is a derivation.

## Main results

- `innerDerivation_commutator_formula` — the explicit bracket formula.
- `innerDerivation_bracket_closure` — the bracket of two inner derivations
  is a sum of inner derivations (Lie subalgebra closure).

## Claim boundary

This file proves closure under the bracket. It does not prove:
- That inner derivations generate all of `Der(h₃(𝕆))`.
- The identification of the inner derivation Lie algebra with `𝔣₄`.
- Any dimension counting or simplicity arguments.

## Status

Trusted module — no `s o r r y`.
-/

namespace PhysicsSM.Algebra.Jordan.H3O

open PhysicsSM.Algebra.Jordan.Derivation
open PhysicsSM.Algebra.Jordan.H3OJordan

local infixl:70 " ○ " => jordanProduct

/-! ## Right-side linearity of inner derivations

These follow from antisymmetry and left-side linearity. -/

/-
`D_{a, b₁ + b₂} = D_{a, b₁} + D_{a, b₂}`.
-/
theorem innerDerivation_add_right (a b₁ b₂ : H3O) :
    innerDerivation a (b₁ + b₂) =
      innerDerivation a b₁ + innerDerivation a b₂ := by
  convert congr_arg Neg.neg ( innerDerivation_add_left b₁ b₂ a ) using 1;
  · exact innerDerivation_antisymm a (b₁ + b₂);
  · convert congr_arg₂ ( · + · ) ( innerDerivation_antisymm a b₁ ) ( innerDerivation_antisymm a b₂ ) using 1 ; abel1

/-
`D_{a, r • b} = r • D_{a, b}`.
-/
theorem innerDerivation_smul_right (r : ℝ) (a b : H3O) :
    innerDerivation a (r • b) = r • innerDerivation a b := by
  convert innerDerivation_antisymm a ( r • b ) using 1;
  rw [ innerDerivation_smul_left ];
  rw [ ← smul_neg, ← innerDerivation_antisymm ]

/-
`D_{a₁ - a₂, b} = D_{a₁, b} - D_{a₂, b}`.
-/
theorem innerDerivation_sub_left (a₁ a₂ b : H3O) :
    innerDerivation (a₁ - a₂) b =
      innerDerivation a₁ b - innerDerivation a₂ b := by
  exact H3ODerivation.ext fun x => by
    have := innerDerivation_add_right a₂ (-a₂) b
    have := congr_arg ( fun f => f x ) this; simp_all +decide [ sub_eq_add_neg, jordanProduct_add_left, jordanProduct_add_right ] ;
    simp +decide [ jordanProduct_neg_left, jordanProduct_neg_right ] ; abel

/-
`D_{a, b₁ - b₂} = D_{a, b₁} - D_{a, b₂}`.
-/
theorem innerDerivation_sub_right (a b₁ b₂ : H3O) :
    innerDerivation a (b₁ - b₂) =
      innerDerivation a b₁ - innerDerivation a b₂ := by
  grind +suggestions

/-
`D_{a, -b} = -D_{a, b}`.
-/
theorem innerDerivation_neg_right (a b : H3O) :
    innerDerivation a (-b) = -(innerDerivation a b) := by
  convert innerDerivation_smul_right ( -1 ) a b using 1 <;> norm_num

/-
`D_{-a, b} = -D_{a, b}`.
-/
theorem innerDerivation_neg_left (a b : H3O) :
    innerDerivation (-a) b = -(innerDerivation a b) := by
  grind +suggestions

/-! ## The commutator formula for inner derivations -/

/-
**Commutator formula for inner derivations.**

The bracket of two inner derivations is a sum of inner derivations:
`[D_{a,b}, D_{c,d}] = D_{D_{a,b}(c), d} + D_{c, D_{a,b}(d)}`.

This follows from the Leibniz rule and linearity of `D_{a,b}`.
The proof expands `[D_{a,b}, D_{c,d}](x) = D_{a,b}(D_{c,d}(x)) - D_{c,d}(D_{a,b}(x))`,
applies the Leibniz rule of `D_{a,b}` to each Jordan product in `D_{c,d}(x)`,
and observes that the terms involving `D_{a,b}(x)` cancel with `D_{c,d}(D_{a,b}(x))`.
-/
theorem innerDerivation_commutator_formula (a b c d : H3O) :
    ⁅innerDerivation a b, innerDerivation c d⁆ =
      innerDerivation ((innerDerivation a b) c) d +
      innerDerivation c ((innerDerivation a b) d) := by
  convert innerDerivation_leibniz a b c d using 1;
  constructor <;> intro h <;> simp_all +decide [ H3ODerivation.ext_iff ];
  · convert innerDerivation_leibniz a b c d using 1;
  · grind +suggestions

/-! ## Lie subalgebra closure -/

/-- The bracket of two inner derivations is a sum of two inner derivations.
    This is the Lie subalgebra closure property for the span of inner
    derivations. -/
theorem innerDerivation_bracket_closure (a b c d : H3O) :
    ∃ e f g h : H3O,
      ⁅innerDerivation a b, innerDerivation c d⁆ =
        innerDerivation e f + innerDerivation g h := by
  exact ⟨(innerDerivation a b) c, d, c, (innerDerivation a b) d,
    innerDerivation_commutator_formula a b c d⟩

end PhysicsSM.Algebra.Jordan.H3O
