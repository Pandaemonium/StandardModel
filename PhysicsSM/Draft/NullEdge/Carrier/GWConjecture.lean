import Mathlib

/-!
# Carrier-level GW conjugation: positive group theorems

This module records the compiler-trust-free Lean part of the Q06 carrier-GW
generalization audit.

Assume a group element `G` is an involution and conjugates each transfer
generator to its inverse.  Then conjugating a product preserves the order of the
word, whereas inversion reverses the word.  Therefore the carrier-level claim
`G * T * G = T⁻¹` needs an extra hypothesis: either the word is palindromic
(the midpoint/symmetric convention) or the generator group is commutative.  The
literal "any retarded transfer" conjecture is killed by the explicit rational
`2 x 2` one-sided nonabelian counterexample below.

Provenance: Q06 audit/counterexample Aristotle project `5f3b8963`; follow-up
no-compiler-trust project `7a12dbbd`.
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

/-! ## Nonabelian one-sided counterexample -/

open Matrix

/-- The swap involution `G = [[0,1],[1,0]]`. -/
def Gc : Matrix (Fin 2) (Fin 2) ℚ :=
  !![0, 1; 1, 0]

/-- Nonabelian transport `a = diag(2, 1/2)`. -/
def ac : Matrix (Fin 2) (Fin 2) ℚ :=
  !![2, 0; 0, 1 / 2]

/-- The inverse witness `a^{-1} = diag(1/2, 2)`. -/
def aci : Matrix (Fin 2) (Fin 2) ℚ :=
  !![1 / 2, 0; 0, 2]

/-- Quarter turn `b = [[0,-1],[1,0]]`. -/
def bc : Matrix (Fin 2) (Fin 2) ℚ :=
  !![0, -1; 1, 0]

/-- The inverse witness `b^{-1} = [[0,1],[-1,0]]`. -/
def bci : Matrix (Fin 2) (Fin 2) ℚ :=
  !![0, 1; -1, 0]

/--
Counterexample to the literal carrier-level conjecture.  There are explicit
`2 x 2` rational matrices `G, a, b` with `G^2 = 1`, explicit two-sided inverse
witnesses `ai, bi`, and `G` conjugating `a` and `b` to those inverse witnesses,
but the one-sided transfer `a * b` is not inverted by `G`.

The last two conjuncts avoid relying on `Matrix.inv`: `bi * ai` is a genuine
left inverse for `a * b`, while `G * (a * b) * G` fails the same test.
-/
theorem nonabelian_oneSided_counterexample :
    ∃ G a b ai bi : Matrix (Fin 2) (Fin 2) ℚ,
      G * G = 1 ∧ a * ai = 1 ∧ ai * a = 1 ∧ b * bi = 1 ∧ bi * b = 1 ∧
      G * a * G = ai ∧ G * b * G = bi ∧ a * b ≠ b * a ∧
      (bi * ai) * (a * b) = 1 ∧ (G * (a * b) * G) * (a * b) ≠ 1 := by
  refine ⟨Gc, ac, bc, aci, bci, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_, ?_⟩
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Gc, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [ac, aci, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [ac, aci, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [bc, bci, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [bc, bci, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Gc, ac, aci, Matrix.mul_apply, Fin.sum_univ_two]
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [Gc, bc, bci, Matrix.mul_apply, Fin.sum_univ_two]
  · intro h
    have h01 := congr_fun (congr_fun h (0 : Fin 2)) (1 : Fin 2)
    norm_num [ac, bc, Matrix.mul_apply, Fin.sum_univ_two] at h01
  · ext i j
    fin_cases i <;> fin_cases j <;>
      norm_num [ac, aci, bc, bci, Matrix.mul_apply, Fin.sum_univ_two]
  · intro h
    have h00 := congr_fun (congr_fun h (0 : Fin 2)) (0 : Fin 2)
    norm_num [Gc, ac, bc, Matrix.mul_apply, Fin.sum_univ_two] at h00

end PhysicsSM.Draft.NullEdge.Carrier.GWConjecture
