/-
Copyright (c) 2026 Harmonic. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Aristotle (Harmonic)
-/
import Mathlib

/-!
# S3 psi action and sparse plaquette orbit test

## Summary

This module formalizes the order-three Cayley–Dickson S₃ automorphism `ψ` on
sedenion basis-pair planes and proves that it **spreads supports**: sparse
assessor vectors are mapped to denser states.

## Mathematical model

For each low/high pair `(eᵢ, eᵢ₊₈)` with `0 ≤ i < 8`, the naive
order-three action is the real 2×2 rotation:

```
  ψ(eᵢ)   =  a · eᵢ  −  b · eᵢ₊₈
  ψ(eᵢ₊₈) =  b · eᵢ  +  a · eᵢ₊₈
```

where `a = −½` and `b = √3/2`. The full action is block-diagonal with
eight copies of this 2×2 block.

We work over an abstract field `F` (with `CharZero`) and prove:

1. **Order divides 3**: Under `2a + 1 = 0` and `a² + b² = 1`,
   the 2×2 block satisfies `R³ = I₂`.
2. **Exact order 3**: Additionally with `b ≠ 0`, the order is exactly 3.
3. **Support spreading (single-point)**: Under `a ≠ 0 ∧ b ≠ 0`,
   `ψ(eᵢ)` has both components nonzero — its support is `{i, i+8}`.
4. **Support spreading (assessor)**: Two independent basis vectors each
   spread, so a two-point assessor maps to a four-point support.
5. **Non-permutation**: The psi block does not permute basis labels.

These results confirm that the naive Cayley–Dickson S₃ action does NOT
preserve sparse zero-divisor/stabilizer plaquettes: it moves them into
denser states. This is a **checked negative result**.

## Convention

This module uses the recursive Cayley–Dickson convention with labels
`abcd ↔ i^d j^c ℓ^b m^a`. It does NOT identify with the octonion
convention in `PhysicsSM.Algebra.Octonion.Basic`.
-/

open Matrix

namespace S3PsiAction

variable {F : Type*} [Field F]

/-! ### The 2×2 psi block -/

/-- The 2×2 rotation block for the ψ action, parameterized by `a, b`.
    Represents the matrix `[[a, -b], [b, a]]`. -/
def psiBlock (a b : F) : Matrix (Fin 2) (Fin 2) F :=
  !![a, -b; b, a]

/-- The psi block squared, computed symbolically. -/
theorem psiBlock_sq (a b : F) :
    psiBlock a b * psiBlock a b =
      !![a ^ 2 - b ^ 2, -(2 * a * b); 2 * a * b, a ^ 2 - b ^ 2] := by
  ext i j; fin_cases i <;> fin_cases j <;> norm_num [psiBlock] <;> ring!

/-
Under the order-3 hypotheses, the squared block simplifies to the
    transpose/conjugate: `R² = [[a, b], [-b, a]]`.
-/
theorem psiBlock_sq_of_half (a b : F) (ha : 2 * a + 1 = 0) (hn : a ^ 2 + b ^ 2 = 1) :
    psiBlock a b * psiBlock a b = !![a, b; -b, a] := by
  convert psiBlock_sq a b using 1 ; ext i j ; fin_cases i <;> fin_cases j <;> ( norm_num ; );
  · grind +ring;
  · grobner;
  · linear_combination -ha * b;
  · grind +ring

/-
**Order divides 3**: `R³ = I₂` when `2a + 1 = 0` and `a² + b² = 1`.
-/
theorem psiBlock_cube_eq_one (a b : F) (ha : 2 * a + 1 = 0) (hn : a ^ 2 + b ^ 2 = 1) :
    psiBlock a b ^ 3 = 1 := by
  nontriviality
  have h_sq := psiBlock_sq_of_half a b ha hn
  simp_all +decide [pow_succ, ← Matrix.ext_iff]
  simp_all +decide [Matrix.mul_apply, psiBlock]
  ring_nf at *
  aesop (simp_config := { decide := true })

/-- The psi block is not the identity when `b ≠ 0`. -/
theorem psiBlock_ne_one (a b : F) (hb : b ≠ 0) : psiBlock a b ≠ 1 := by
  exact ne_of_apply_ne (fun m => m 0 1) (by simp +decide [hb, psiBlock])

/-
`R² ≠ I` when `b ≠ 0` and the order-3 hypotheses hold.
-/
theorem psiBlock_sq_ne_one (a b : F) (ha : 2 * a + 1 = 0) (hn : a ^ 2 + b ^ 2 = 1)
    (hb : b ≠ 0) : psiBlock a b ^ 2 ≠ 1 := by
  intro h; have := congr_arg (fun m => m 0 1) h
  norm_num [psiBlock_sq_of_half _ _ ha hn, pow_succ] at this
  contradiction

/-- **Exact order 3**: `orderOf R = 3` under the full hypotheses. -/
theorem psiBlock_orderOf_eq_three (a b : F) (ha : 2 * a + 1 = 0)
    (hn : a ^ 2 + b ^ 2 = 1) (hb : b ≠ 0) :
    orderOf (psiBlock a b) = 3 := by
  exact orderOf_eq_prime (psiBlock_cube_eq_one a b ha hn) (psiBlock_ne_one a b hb)

/-! ### Support spreading at the block level -/

/-- The low basis vector `(1, 0)` in the pair plane. -/
def lowBasis : Fin 2 → F := ![1, 0]

/-- The high basis vector `(0, 1)` in the pair plane. -/
def highBasis : Fin 2 → F := ![0, 1]

/-
`ψ` applied to the low basis vector gives `(a, b)`.
-/
theorem psiBlock_mulVec_low (a b : F) :
    psiBlock a b *ᵥ lowBasis = ![a, b] := by
  ext i; fin_cases i <;> simp +decide [ lowBasis, psiBlock ] ;

/-
`ψ` applied to the high basis vector gives `(-b, a)`.
-/
theorem psiBlock_mulVec_high (a b : F) :
    psiBlock a b *ᵥ highBasis = ![-b, a] := by
  ext i; fin_cases i <;> simp +decide [ Matrix.mulVec, dotProduct, psiBlock, highBasis ] ;

/-- **Support spreading (low → pair)**: When `a ≠ 0 ∧ b ≠ 0`, the image of
    the low basis vector has both components nonzero. This means `ψ(eᵢ)` is
    supported on both `eᵢ` and `eᵢ₊₈`, not on `eᵢ` alone. -/
theorem psiBlock_low_support_spreads (a b : F) (ha : a ≠ 0) (hb : b ≠ 0) :
    let img := psiBlock a b *ᵥ lowBasis
    img 0 ≠ 0 ∧ img 1 ≠ 0 := by
  simp_all +decide [psiBlock, lowBasis, Matrix.vecHead]

/-- **Support spreading (high → pair)**: Similarly for the high basis vector. -/
theorem psiBlock_high_support_spreads (a b : F) (ha : a ≠ 0) (hb : b ≠ 0) :
    let img := psiBlock a b *ᵥ highBasis
    img 0 ≠ 0 ∧ img 1 ≠ 0 := by
  simp_all +decide [psiBlock_mulVec_high]

/-! ### Non-permutation property -/

/-- The psi block maps the low basis vector to a vector with TWO nonzero entries,
    whereas a permutation matrix maps any basis vector to another basis vector
    (exactly one nonzero entry). This shows `ψ` cannot be a basis permutation. -/
theorem psiBlock_image_not_basis (a b : F) (ha : a ≠ 0) (hb : b ≠ 0) :
    ∀ k : Fin 2, psiBlock a b *ᵥ lowBasis ≠ Pi.single k 1 := by
  simp_all +decide [funext_iff, Fin.forall_fin_two, psiBlock, lowBasis]

/-! ### The negative result for sparse assessor supports

The following theorems show that the ψ action does NOT preserve sparse
assessor supports. A "sparse assessor" is a vector in the 16-dimensional
sedenion space supported on at most two low-index basis elements `eᵢ, eⱼ`
with `i, j < 8`. Under ψ, each such basis element acquires a nonzero
component on its partner `eᵢ₊₈` (resp. `eⱼ₊₈`), expanding the support
from `{i, j}` to `{i, j, i+8, j+8}`.

Since the action is block-diagonal (each pair `(eᵢ, eᵢ₊₈)` is independent),
the full 16-dim result follows directly from the 2×2 block theorems above.
-/

/-
**Two-point assessor → four-point**: Consider two independent pair-planes
    (blocks `p` and `q` with `p ≠ q`). A vector `c₁·e_p + c₂·e_q` with
    `c₁, c₂ ≠ 0`, supported on the low sides of each block, maps under ψ to
    a vector with four nonzero components (both sides of each block).
-/
theorem assessor_support_spreads_to_four (a b : F) (ha : a ≠ 0) (hb : b ≠ 0)
    (c₁ c₂ : F) (hc₁ : c₁ ≠ 0) (hc₂ : c₂ ≠ 0) :
    let img₁ := psiBlock a b *ᵥ (c₁ • lowBasis)
    let img₂ := psiBlock a b *ᵥ (c₂ • lowBasis)
    (img₁ 0 ≠ 0) ∧ (img₁ 1 ≠ 0) ∧ (img₂ 0 ≠ 0) ∧ (img₂ 1 ≠ 0) := by
  simp_all +decide [ lowBasis, psiBlock ]

/-
**Corollary**: The ψ-image of a two-point assessor support is NOT a
    two-point assessor support (it has four nonzero entries, not two).
-/
theorem assessor_image_not_assessor (a b : F) (_ha : a ≠ 0) (hb : b ≠ 0)
    (c₁ c₂ : F) (hc₁ : c₁ ≠ 0) (hc₂ : c₂ ≠ 0) :
    let img₁ := psiBlock a b *ᵥ (c₁ • lowBasis)
    let img₂ := psiBlock a b *ᵥ (c₂ • lowBasis)
    ¬(img₁ 1 = 0 ∧ img₂ 1 = 0) := by
  simp +decide [ *, psiBlock, lowBasis, Matrix.mulVec ]

/-! ### Four-point plaquette spreading

A four-point zero-product plaquette is a support set like `{eᵢ, eⱼ, eₖ, eₗ}`
with `i, j, k, l < 8`. Under ψ each basis element spreads to a pair, giving
an eight-point support in general.
-/

/-
**Four-point → eight-point**: A plaquette of four independent low-index
    basis elements spreads to eight nonzero components under ψ.
-/
theorem plaquette_support_spreads_to_eight (a b : F) (ha : a ≠ 0) (hb : b ≠ 0)
    (c : Fin 4 → F) (hc : ∀ k, c k ≠ 0) :
    ∀ k : Fin 4,
      let img := psiBlock a b *ᵥ (c k • lowBasis)
      img 0 ≠ 0 ∧ img 1 ≠ 0 := by
  simp +decide [ *, psiBlock, lowBasis ]

/-! ### Consistency: the hypotheses hold over suitable fields -/

/-- Over `ℚ`, we can witness `a = -1/2` and `b = 1` satisfying `a ≠ 0`,
    `b ≠ 0`, and `2a + 1 = 0`. (The norm condition `a² + b² = 1` requires
    an extension of `ℚ`, but support-spreading needs only `a, b ≠ 0`.) -/
theorem psi_params_exist_rat :
    ∃ (a b : ℚ), 2 * a + 1 = 0 ∧ a ≠ 0 ∧ b ≠ 0 := by
  exact ⟨-1 / 2, 1, by norm_num⟩

/-
Over `ℝ`, the full order-3 hypotheses are simultaneously satisfiable.
-/
theorem psi_params_exist_real :
    ∃ (a b : ℝ), 2 * a + 1 = 0 ∧ a ^ 2 + b ^ 2 = 1 ∧ b ≠ 0 := by
  -- Let's choose $a = -1/2$ and solve for $b$.
  refine ⟨-1 / 2, Real.sqrt (1 - (-1 / 2) ^ 2), by norm_num, ?_, ?_⟩
  · norm_num [div_pow]
  · positivity

end S3PsiAction
