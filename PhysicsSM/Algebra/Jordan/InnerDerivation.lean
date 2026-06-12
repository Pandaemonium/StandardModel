import Mathlib
import PhysicsSM.Algebra.Jordan.Derivation
import PhysicsSM.Algebra.Jordan.H3OJordan
import PhysicsSM.Algebra.Jordan.TraceForm

/-!
# Algebra.Jordan.InnerDerivation

Inner derivations of the exceptional Jordan algebra h₃(𝕆).

## Overview

The inner derivation associated to a pair `(a, b)` in `h₃(𝕆)` is the map

```text
D_{a,b}(c) = [Lₐ, L_b](c) = a ○ (b ○ c) − b ○ (a ○ c)
```

where `Lₐ(c) = a ○ c` denotes left multiplication. These are derivations
of the Jordan algebra (they satisfy the Leibniz rule with respect to `○`),
and they span the Lie algebra of inner derivations, which is the compact
real form of `𝔣₄ = Der(h₃(𝕆))`.

## Note on the formula

Some references write the inner derivation as
`D_{a,b}(c) = (a ○ b) ○ c − b ○ (a ○ c) − a ○ (b ○ c)`, but this
expression is symmetric in `(a, b)` (using commutativity of `○`) and
therefore cannot be antisymmetric. The correct antisymmetric inner
derivation is `[Lₐ, L_b](c) = a ○ (b ○ c) − b ○ (a ○ c)`.

## Proof strategy

The derivation property (Leibniz rule) is established by:

1. **First linearization** of the Jordan identity: replacing `a` by
   `a ± c` in `(a ○ b) ○ (a ○ a) = a ○ (b ○ (a ○ a))` and simplifying.

2. **Second linearization**: further replacing `a` by `a + d` in the
   first linearization to obtain the fully multilinear identity
   `[Lₐ, L_{c○d}] + [L_c, L_{a○d}] + [L_d, L_{a○c}] = 0`.

3. **Derivation property**: applying the linearized identity with
   appropriate substitutions and using commutativity to cancel cross
   terms.

## Main definitions

- `innerDerivation a b : H3ODerivation` — the inner derivation
  `[Lₐ, L_b]`.

## Main results

- `innerDerivation_antisymm` — `D_{a,b} = −D_{b,a}`.
- `innerDerivation_self` — `D_{a,a} = 0`.
- `innerDerivation_add_left` — additivity in the first argument.
- `innerDerivation_smul_left` — scalar homogeneity in the first argument.
- `innerDerivation_zero_left`, `innerDerivation_zero_right` — zero cases.
- `innerDerivation_jordanProduct` — the derivation (Leibniz) property.

## Claim boundary

This file defines inner derivations and proves their basic properties.
It does **not** prove that the inner derivations generate all of
`Der(h₃(𝕆))`, that the Lie algebra of inner derivations is `𝔣₄`, or
the isomorphism `Aut(h₃(𝕆)) ≅ F₄`.

## Status

Trusted module — no `sorry`.
-/

namespace PhysicsSM.Algebra.Jordan.H3O

open PhysicsSM.Algebra.Jordan.Derivation
open PhysicsSM.Algebra.Jordan.H3OJordan

local infixl:70 " ○ " => jordanProduct

/-! ## First linearization of the Jordan identity

The Jordan identity `(a ○ b) ○ (a ○ a) = a ○ (b ○ (a ○ a))` is cubic
in `a`. Replacing `a` by `a ± c`, subtracting the original JI instances,
and simplifying yields the first linearization:

```text
2(a ○ b) ○ (a ○ c) + (c ○ b) ○ (a ○ a)
  = 2 a ○ (b ○ (a ○ c)) + c ○ (b ○ (a ○ a))
```

This is quadratic in `a` and linear in `c`.
-/

/-- First linearization of the Jordan identity. -/
theorem jordanIdentity_firstLinearization (a b c : H3O) :
    (2 : ℝ) • ((a ○ b) ○ (a ○ c)) + (c ○ b) ○ (a ○ a) =
    (2 : ℝ) • (a ○ (b ○ (a ○ c))) + c ○ (b ○ (a ○ a)) := by
  have h_ac := jordanIdentity_H3O (a + c) b
  simp_all +decide [jordanProduct_add_left, jordanProduct_add_right,
    jordanProduct_comm]
  have h_a := jordanIdentity_H3O a b
  have h_c := jordanIdentity_H3O c b
  simp_all +decide [jordanProduct_add_left, jordanProduct_add_right,
    jordanProduct_comm]
  have h_neg := jordanIdentity_H3O (a + -c) b
  simp_all +decide [jordanProduct_add_left, jordanProduct_add_right,
    jordanProduct_comm]
  simp_all +decide [jordanProduct_neg_left, jordanProduct_neg_right,
    jordanProduct_comm]
  simp_all +decide [← eq_sub_iff_add_eq', ← sub_eq_iff_eq_add]
  abel_nf at *
  simp_all +decide [← eq_sub_iff_add_eq', ← add_assoc]
  convert congr_arg (fun x => (1 / 2 : ℝ) • x) h_ac using 1 <;>
    norm_num [two_smul, smul_add, smul_sub]
  ring
  all_goals module

/-! ## Full linearization of the Jordan identity

Replacing `a` by `a + d` in the first linearization and simplifying
gives the fully multilinear identity:

```text
(a ○ b) ○ (c ○ d) + (c ○ b) ○ (a ○ d) + (d ○ b) ○ (a ○ c)
  = a ○ (b ○ (c ○ d)) + c ○ (b ○ (a ○ d)) + d ○ (b ○ (a ○ c))
```
-/

/-- Fully linearized Jordan identity. -/
theorem jordanIdentity_linearized (a b c d : H3O) :
    (a ○ b) ○ (c ○ d) + (c ○ b) ○ (a ○ d) +
      (d ○ b) ○ (a ○ c) =
    a ○ (b ○ (c ○ d)) + c ○ (b ○ (a ○ d)) +
      d ○ (b ○ (a ○ c)) := by
  have h_ad := jordanIdentity_firstLinearization (a + d) b c
  simp_all +decide [jordanProduct_comm, ← add_assoc]
  have twoSmulEq : (2 : ℝ) • ((a ○ b) ○ (c ○ d) +
      (a ○ d) ○ (b ○ c) + (a ○ c) ○ (b ○ d)) =
    (2 : ℝ) • (a ○ (b ○ (c ○ d)) +
      c ○ (b ○ (a ○ d)) + d ○ (b ○ (a ○ c))) := by
    have h_a := jordanIdentity_firstLinearization a b c
    have h_d := jordanIdentity_firstLinearization d b c
    simp_all +decide [two_smul, add_smul]
    grind +suggestions
  convert congr_arg (fun x => (1 / 2 : ℝ) • x) twoSmulEq using 1 <;>
    module

/-! ## Expansion formula -/

/-- Expansion formula for `a ○ (b ○ (x ○ y))` using the linearized
    Jordan identity. -/
theorem jordan_expansion (a b x y : H3O) :
    a ○ (b ○ (x ○ y)) =
    (a ○ b) ○ (x ○ y) - x ○ (b ○ (a ○ y)) +
      (a ○ y) ○ (b ○ x) -
    y ○ (b ○ (a ○ x)) + (a ○ x) ○ (b ○ y) := by
  have := @jordanIdentity_linearized
  have h_comm : ∀ u v : H3O, u ○ v = v ○ u :=
    fun u v => jordanProduct_comm u v
  grind

/-! ## Inner derivation: Leibniz rule -/

/-- The inner derivation `[Lₐ, L_b]` satisfies the Jordan Leibniz
    rule. -/
theorem innerDerivation_leibniz (a b x y : H3O) :
    a ○ (b ○ (x ○ y)) - b ○ (a ○ (x ○ y)) =
    (a ○ (b ○ x) - b ○ (a ○ x)) ○ y +
      x ○ (a ○ (b ○ y) - b ○ (a ○ y)) := by
  have lhs_dist := jordan_expansion a b x y
  simp only [jordanProduct_comm, jordanProduct_sub_right] at lhs_dist ⊢
  have lhs_dist' := jordan_expansion b a x y
  simp only [jordanProduct_comm] at lhs_dist' ⊢
  grind

/-! ## Inner derivation definition -/

/-- The inner derivation associated to a pair `(a, b)` in `h₃(𝕆)`:
    `D_{a,b}(c) = [Lₐ, L_b](c) = a ○ (b ○ c) − b ○ (a ○ c)`.

    This is a derivation of the Jordan algebra: it satisfies
    `D(x ○ y) = D(x) ○ y + x ○ D(y)`. -/
noncomputable def innerDerivation (a b : H3O) : H3ODerivation where
  toFun c := a ○ (b ○ c) - b ○ (a ○ c)
  map_add' u v := by
    simp only [jordanProduct_add_right]
    abel
  map_smul' r u := by
    simp only [jordanProduct_smul_right, smul_sub]
  leibniz' x y := innerDerivation_leibniz a b x y

/-! ## Basic properties -/

@[simp]
theorem innerDerivation_apply (a b c : H3O) :
    (innerDerivation a b) c = a ○ (b ○ c) - b ○ (a ○ c) := rfl

/-- `D_{a,b}` is antisymmetric: `D_{a,b} = −D_{b,a}`. -/
theorem innerDerivation_antisymm (a b : H3O) :
    innerDerivation a b = -(innerDerivation b a) := by
  apply H3ODerivation.ext; intro c
  simp only [innerDerivation_apply, H3ODerivation.neg_apply]
  abel

/-- `D_{a,a} = 0`. -/
theorem innerDerivation_self (a : H3O) :
    innerDerivation a a = 0 := by
  apply H3ODerivation.ext; intro c
  simp only [innerDerivation_apply, H3ODerivation.zero_apply,
    sub_self]

/-- `D_{a,b}` is additive in `a`. -/
theorem innerDerivation_add_left (a₁ a₂ b : H3O) :
    innerDerivation (a₁ + a₂) b =
      innerDerivation a₁ b + innerDerivation a₂ b := by
  apply H3ODerivation.ext; intro c
  simp only [innerDerivation_apply, H3ODerivation.add_apply,
    jordanProduct_add_left, jordanProduct_add_right]
  abel

/-- `D_{a,b}` is real-linear in `a`. -/
theorem innerDerivation_smul_left (r : ℝ) (a b : H3O) :
    innerDerivation (r • a) b = r • innerDerivation a b := by
  apply H3ODerivation.ext; intro c
  simp only [innerDerivation_apply, H3ODerivation.smul_apply,
    jordanProduct_smul_left, jordanProduct_smul_right, smul_sub]

/-- `D_{0,b} = 0`. -/
theorem innerDerivation_zero_left (b : H3O) :
    innerDerivation 0 b = 0 := by
  apply H3ODerivation.ext; intro c
  simp only [innerDerivation_apply, H3ODerivation.zero_apply,
    jordanProduct_zero_left, jordanProduct_zero_right, sub_self]

/-- `D_{a,0} = 0`. -/
theorem innerDerivation_zero_right (a : H3O) :
    innerDerivation a 0 = 0 := by
  apply H3ODerivation.ext; intro c
  simp only [innerDerivation_apply, H3ODerivation.zero_apply,
    jordanProduct_zero_left, jordanProduct_zero_right, sub_self]

/-- `D_{a,b}` satisfies the Jordan derivation law:
    `D_{a,b}(x ○ y) = D_{a,b}(x) ○ y + x ○ D_{a,b}(y)`. -/
theorem innerDerivation_jordanProduct (a b x y : H3O) :
    (innerDerivation a b).toFun (jordanProduct x y) =
      jordanProduct ((innerDerivation a b).toFun x) y +
      jordanProduct x ((innerDerivation a b).toFun y) :=
  (innerDerivation a b).leibniz' x y

end PhysicsSM.Algebra.Jordan.H3O
