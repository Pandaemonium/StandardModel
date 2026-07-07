import Mathlib

/-!
# Carrier-level GW conjugation: positive group theorems

This module records the compiler-trust-free positive part of the Q06
carrier-GW generalization audit.

Assume a group element `G` is an involution and conjugates each transfer
generator to its inverse.  Then conjugating a product preserves the order of the
word, whereas inversion reverses the word.  Therefore the carrier-level claim
`G * T * G = T⁻¹` needs an extra hypothesis: either the word is palindromic
(the midpoint/symmetric convention) or the generator group is commutative.

The nonabelian one-sided counterexample from the audit is not landed here,
because the first Aristotle artifact used compiler evaluation for that finite
witness.  A no-compiler-trust follow-up job is open.

Provenance: Q06 audit/counterexample Aristotle project `5f3b8963`; follow-up
no-native project `7a12dbbd`.
-/

namespace PhysicsSM.Draft.NullEdge.Carrier.GWConjecture

/-! ## General group facts -/

variable {A : Type*} [Group A]

/--
If `G` is an involution and conjugates every generator in `L` to its inverse,
then it conjugates the ordered product to the product of inverses in the same
order.  Conjugation preserves word order.
-/
theorem conj_prod_forward (G : A) (hG : G * G = 1) (L : List A)
    (hL : ∀ x ∈ L, G * x * G = x⁻¹) :
    G * L.prod * G = (L.map (·⁻¹)).prod := by
  induction' L with x L ih <;> simp_all +decide [mul_assoc]
  grind

/--
Positive carrier-level theorem: if the generator word is palindromic, then the
order-preserving conjugated inverse word is the genuine inverse word.
-/
theorem palindrome_conj_inv (G : A) (hG : G * G = 1) (L : List A)
    (hL : ∀ x ∈ L, G * x * G = x⁻¹) (hpal : L = L.reverse) :
    G * L.prod * G = (L.prod)⁻¹ := by
  have hf : G * L.prod * G = (L.map (·⁻¹)).prod := by
    convert conj_prod_forward G hG L hL
  have h_rev : (L.map (·⁻¹)).prod = (L.reverse.map (·⁻¹)).prod := by
    rw [← hpal]
  rw [hf, h_rev, List.prod_inv_reverse]
  rw [List.map_reverse]

/--
Abelian escape: in a commutative group, order no longer matters, so the same
carrier hypotheses invert any ordered product.
-/
theorem abelian_conj_inv {B : Type*} [CommGroup B] (G : B) (hG : G * G = 1)
    (L : List B) (hL : ∀ x ∈ L, G * x * G = x⁻¹) :
    G * L.prod * G = (L.prod)⁻¹ := by
  induction' L with x L ih
  · aesop
  · simp_all +decide [mul_assoc, List.prod_cons]
    grind +qlia

end PhysicsSM.Draft.NullEdge.Carrier.GWConjecture
