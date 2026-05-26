/-
Copyright (c) 2026 Harmonic. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Aristotle (Harmonic)
-/
import Mathlib

/-!
# Generation Cancellation Geometry

## Summary

This module tests whether the sedenion order-three generation action `ψ`
preserves, spreads, or breaks the zero-divisor cancellation geometry.

**Result**: The naive Cayley–Dickson `ψ` action does NOT preserve the sparse
zero-product supports. It spreads every 4-element zero-product support to an
8-element support. However, the image is always **controlled by vertical
partner pairs**: it is the union of four vertical `(i, i+8)` pairs, and in
particular is always closed under the partner involution `i ↦ (i + 8) mod 16`.

The 42 zero-product supports are merged into **7 sextets of 6**, corresponding
to the 7 **complements of Fano lines** in the imaginary low half `{1,...,7}`.
Each Fano complement (a 4-element subset of `{1,...,7}`) expands to an
8-element partner-closed set, and these 7 sets are exactly the 7 distinct
ψ-images.

## Convention

We use the recursive Cayley–Dickson convention with labels
`abcd ↔ i^d j^c ℓ^b m^a` as documented in `Sedenions/CayleyDickson_Convention.md`.
This convention differs from `PhysicsSM.Algebra.Octonion.Basic`; the two
must never be silently identified.

## The `ψ` action

For each low/high pair `(eᵢ, eᵢ₊₈)`, the order-three action is the
rotation by 2π/3:
```
  ψ(eᵢ)   = −½ eᵢ − (√3/2) eᵢ₊₈
  ψ(eᵢ₊₈) = (√3/2) eᵢ − ½ eᵢ₊₈
```
At the support level, each basis vector `eᵢ` maps to a vector supported on
`{i, partner(i)}` where `partner(i) = (i + 8) mod 16`.

## Main results

### Negative (spreading) results
- `psi_image_zeroProd_card_all_eight`: Every zero-product support (4 elements)
  maps to an 8-element support under ψ.
- `psi_not_sparse_cancellation_symmetry`: No zero-product support is mapped
  into another zero-product support by ψ.
- `psi_spreads_zero_product_supports`: The ψ-image of every zero-product
  support strictly contains the original support.

### Positive (structure) results
- `psiImageSupport_partner_closed`: The ψ-image of ANY Finset is closed
  under the partner involution.
- `psi_image_controlled_by_vertical_pairs`: The ψ-image of every zero-product
  support is exactly the union of four vertical partner pairs.
- `psi_image_zeroProd_is_union_partner_pairs`: Constructive characterization.

### Classification
- `psi_image_zeroProd_distinct_count`: The 42 zero-product supports map to
  exactly 7 distinct 8-element supports under ψ.
- `psi_image_contains_six_zeroProd`: Each of the 7 distinct images contains
  exactly 6 of the 42 zero-product supports (42 = 7 × 6).
- `psi_images_eq_fano_complement_expansions`: The 7 images are exactly the
  vertical-pair expansions of the 7 Fano-complement sets in {1,...,7}.
-/

set_option linter.style.nativeDecide false

namespace GenerationCancellationGeometry

-- ============================================================
-- § 1. Basic definitions (self-contained, matching S3PsiAction)
-- ============================================================

/-- The partner index under the low/high pairing: i ↦ (i + 8) mod 16. -/
def partner (i : Fin 16) : Fin 16 :=
  ⟨(i.val + 8) % 16, Nat.mod_lt _ (by omega)⟩

/-- The support of ψ(eᵢ): always `{i, partner(i)}`. -/
def psiBaseSupport (i : Fin 16) : Finset (Fin 16) :=
  {i, partner i}

/-- The image support of ψ applied to a vector with support S. -/
def psiImageSupport (S : Finset (Fin 16)) : Finset (Fin 16) :=
  S.biUnion psiBaseSupport

-- ============================================================
-- § 2. The 42 zero-product supports as Finsets
-- ============================================================

/-- Conjugation sign for basis element `a`: +1 if a = 0, -1 otherwise. -/
def conjSign (a : Nat) : Int :=
  if a == 0 then 1 else -1

/-- Recursive Cayley-Dickson basis multiplication.
Returns `(sign, product_index)` for `e_a * e_b` in the `2^n`-dimensional
Cayley-Dickson algebra. -/
def cdMulBasis : Nat → Nat → Nat → Int × Nat
  | 0, _, _ => (1, 0)
  | n + 1, a, b =>
    let half := 2 ^ n
    let ah := a / half
    let al := a % half
    let bh := b / half
    let bl := b % half
    if ah == 0 then
      if bh == 0 then
        let (s, k) := cdMulBasis n al bl
        (s, k)
      else
        let (s, k) := cdMulBasis n bl al
        (s, half + k)
    else
      if bh == 0 then
        let (s, k) := cdMulBasis n al bl
        (s * conjSign bl, half + k)
      else
        let (s, k) := cdMulBasis n bl al
        (-conjSign bl * s, k)

/-- The Cayley-Dickson sign function for sedenions. -/
def omega (a b : Fin 16) : Int :=
  (cdMulBasis 4 a.val b.val).1

/-- Coefficient of `e_k` in the product `(e_a + σ · e_b) · (e_c + τ · e_d)`. -/
def assessorProdCoeff (a b c d : Fin 16) (σ τ : Int) (k : Fin 16) : Int :=
  (if (a.val ^^^ c.val) = k.val then omega a c else 0) +
  (if (a.val ^^^ d.val) = k.val then τ * omega a d else 0) +
  (if (b.val ^^^ c.val) = k.val then σ * omega b c else 0) +
  (if (b.val ^^^ d.val) = k.val then σ * τ * omega b d else 0)

/-- Check if the assessor product is zero. -/
def isProductZero (a b c d : Fin 16) (σ τ : Int) : Bool :=
  (List.finRange 16).all fun k => assessorProdCoeff a b c d σ τ k == 0

/-- Check whether a support admits a zero-product relation. -/
def isZeroProdSupport (lo₁ lo₂ hi₁ hi₂ : Fin 16) : Bool :=
  let signs : List Int := [1, -1]
  signs.any fun σ => signs.any fun τ =>
    isProductZero lo₁ hi₁ lo₂ hi₂ σ τ ||
    isProductZero lo₂ hi₂ lo₁ hi₁ σ τ ||
    isProductZero lo₁ hi₂ lo₂ hi₁ σ τ ||
    isProductZero lo₂ hi₁ lo₁ hi₂ σ τ

/-- Check whether `(lo₁, lo₂, hi₁, hi₂)` is a valid same-strut support. -/
def isSameStrutSupport (lo₁ lo₂ hi₁ hi₂ : Fin 16) : Bool :=
  (1 ≤ lo₁.val) && (lo₁.val ≤ 7) &&
  (1 ≤ lo₂.val) && (lo₂.val ≤ 7) &&
  (9 ≤ hi₁.val) && (hi₁.val ≤ 15) &&
  (9 ≤ hi₂.val) && (hi₂.val ≤ 15) &&
  (lo₁.val < lo₂.val) && (hi₁.val < hi₂.val) &&
  ((lo₁.val ^^^ (hi₁.val - 8)) == (lo₂.val ^^^ (hi₂.val - 8)))

/-- The 63 same-strut supports. -/
def sameStrutList : List (Fin 16 × Fin 16 × Fin 16 × Fin 16) :=
  (List.finRange 16).flatMap fun lo₁ =>
  (List.finRange 16).flatMap fun lo₂ =>
  (List.finRange 16).flatMap fun hi₁ =>
  (List.finRange 16).flatMap fun hi₂ =>
    if isSameStrutSupport lo₁ lo₂ hi₁ hi₂ then [(lo₁, lo₂, hi₁, hi₂)] else []

/-- The 42 zero-product supports. -/
def zeroProdSupportList : List (Fin 16 × Fin 16 × Fin 16 × Fin 16) :=
  sameStrutList.filter fun t => isZeroProdSupport t.1 t.2.1 t.2.2.1 t.2.2.2

/-- Convert a support tuple to a Finset. -/
def tupleToFinset (t : Fin 16 × Fin 16 × Fin 16 × Fin 16) : Finset (Fin 16) :=
  {t.1, t.2.1, t.2.2.1, t.2.2.2}

-- ============================================================
-- § 3. Partner involution properties
-- ============================================================

/-- Partner is an involution. -/
theorem partner_invol : ∀ i : Fin 16, partner (partner i) = i := by
  native_decide +revert

/-- Partner is never self. -/
theorem partner_ne_self : ∀ i : Fin 16, partner i ≠ i := by
  native_decide +revert

-- ============================================================
-- § 4. ψ-image support is always partner-closed
-- ============================================================

/-- For every i, psiBaseSupport of partner(i) = psiBaseSupport of i. -/
theorem psiBaseSupport_partner_eq :
    ∀ i : Fin 16, psiBaseSupport (partner i) = psiBaseSupport i := by
  native_decide +revert

/-- **Key structural theorem**: The ψ-image of ANY Finset is closed under
    the partner involution. If `j ∈ psiImageSupport S`, then
    `partner j ∈ psiImageSupport S`. -/
theorem psiImageSupport_partner_closed :
    ∀ (S : Finset (Fin 16)) (j : Fin 16),
      j ∈ psiImageSupport S → partner j ∈ psiImageSupport S := by
  intro S j hj
  simp only [psiImageSupport, Finset.mem_biUnion] at hj ⊢
  obtain ⟨i, hi, hji⟩ := hj
  exact ⟨i, hi, by
    simp only [psiBaseSupport, Finset.mem_insert, Finset.mem_singleton] at hji ⊢
    rcases hji with rfl | rfl
    · right; rfl
    · left; exact partner_invol i⟩

-- ============================================================
-- § 5. ψ-image of zero-product supports: size classification
-- ============================================================

/-- Sanity check: 42 zero-product supports. -/
theorem zeroProdSupportList_length : zeroProdSupportList.length = 42 := by
  native_decide

/-- Every zero-product support has exactly 4 elements. -/
theorem zeroProd_finset_card_four :
    ∀ t ∈ zeroProdSupportList, (tupleToFinset t).card = 4 := by native_decide

/-- **Support spreading**: Every zero-product support (4 elements) maps to an
    8-element support under ψ. The support size exactly doubles. -/
theorem psi_image_zeroProd_card_all_eight :
    ∀ t ∈ zeroProdSupportList,
      (psiImageSupport (tupleToFinset t)).card = 8 := by native_decide

-- ============================================================
-- § 6. ψ does NOT preserve zero-product supports
-- ============================================================

/-- The set of all 42 zero-product support Finsets. -/
def zeroProdFinsetSet : Finset (Finset (Fin 16)) :=
  zeroProdSupportList.toFinset.image tupleToFinset

/-- There are exactly 42 distinct zero-product support Finsets. -/
theorem zeroProdFinsetSet_card : zeroProdFinsetSet.card = 42 := by native_decide

/-- **Main negative result**: No zero-product support is mapped into another
    zero-product support by ψ. -/
theorem psi_not_sparse_cancellation_symmetry :
    ∀ t ∈ zeroProdSupportList,
      psiImageSupport (tupleToFinset t) ∉ zeroProdFinsetSet := by native_decide

/-- **Support spreading (strict containment)**: The ψ-image of every
    zero-product support strictly contains the original support. -/
theorem psi_spreads_zero_product_supports :
    ∀ t ∈ zeroProdSupportList,
      tupleToFinset t ⊂ psiImageSupport (tupleToFinset t) := by native_decide

-- ============================================================
-- § 7. Image controlled by vertical pairs
-- ============================================================

/-- A vertical partner pair: {i, partner(i)} for a given i. -/
def verticalPair (i : Fin 16) : Finset (Fin 16) :=
  {i, partner i}

/-- The ψ-image of every zero-product support is closed under partner. -/
theorem psi_image_controlled_by_vertical_pairs :
    ∀ t ∈ zeroProdSupportList,
      ∀ j : Fin 16, j ∈ psiImageSupport (tupleToFinset t) →
        partner j ∈ psiImageSupport (tupleToFinset t) := by
  intro t _ j hj
  exact psiImageSupport_partner_closed _ j hj

/-- The ψ-image of each zero-product support decomposes into exactly 4
    vertical partner pairs (8 elements / 2 per pair). -/
theorem psi_image_zeroProd_vertical_pair_count :
    ∀ t ∈ zeroProdSupportList,
      ((psiImageSupport (tupleToFinset t)).image
        (fun i => if i.val < 8 then i else partner i)).card = 4 := by
  native_decide

/-- For each zero-product support, its ψ-image equals the union of the
    vertical pairs of its elements:
    `psiImageSupport S = ⋃ᵢ∈S verticalPair(i)`. -/
theorem psi_image_zeroProd_is_union_partner_pairs :
    ∀ t ∈ zeroProdSupportList,
      psiImageSupport (tupleToFinset t) =
        (tupleToFinset t).biUnion verticalPair := by native_decide

-- ============================================================
-- § 8. ψ-image orbit classification
-- ============================================================

/-- The list of distinct ψ-images of zero-product supports. -/
def psiImageList : List (Finset (Fin 16)) :=
  (zeroProdSupportList.map fun t =>
    psiImageSupport (tupleToFinset t)).dedup

/-- The 42 zero-product supports produce exactly **7** distinct
    8-element supports under ψ. This is a 6-to-1 folding. -/
theorem psi_image_zeroProd_distinct_count :
    psiImageList.length = 7 := by native_decide

/-- Every distinct ψ-image has exactly 8 elements. -/
theorem psi_image_all_weight_eight :
    ∀ S ∈ psiImageList, S.card = 8 := by native_decide

-- ============================================================
-- § 9. ψ-images vs same-strut supports
-- ============================================================

/-- The set of all 63 same-strut support Finsets. -/
def sameStrutFinsetSet : Finset (Finset (Fin 16)) :=
  sameStrutList.toFinset.image tupleToFinset

/-- No ψ-image of a zero-product support is a same-strut support. -/
theorem psi_image_not_same_strut :
    ∀ t ∈ zeroProdSupportList,
      psiImageSupport (tupleToFinset t) ∉ sameStrutFinsetSet := by
  native_decide

-- ============================================================
-- § 10. Each ψ-image contains exactly 6 zero-product supports
-- ============================================================

/-- Each of the 7 distinct ψ-images contains exactly 6 zero-product
    supports as subsets: 42 = 7 × 6. -/
theorem psi_image_contains_six_zeroProd :
    ∀ S ∈ psiImageList,
      (zeroProdSupportList.filter fun t =>
        tupleToFinset t ⊆ S).length = 6 := by
  native_decide

-- ============================================================
-- § 11. ψ² gives the same image supports as ψ (idempotence)
-- ============================================================

/-- Applying psiImageSupport twice. -/
def psiImageSupport2 (S : Finset (Fin 16)) : Finset (Fin 16) :=
  psiImageSupport (psiImageSupport S)

/-- ψ-spreading is idempotent on zero-product supports: the image is
    already partner-closed, so a second application adds nothing. -/
theorem psi_image_idempotent_on_zeroProd :
    ∀ t ∈ zeroProdSupportList,
      psiImageSupport2 (tupleToFinset t) =
        psiImageSupport (tupleToFinset t) := by native_decide

/-- psiImageSupport is idempotent on ANY partner-closed set. -/
theorem psiImageSupport_idempotent_of_partner_closed
    (S : Finset (Fin 16))
    (hclosed : ∀ j ∈ S, partner j ∈ S) :
    psiImageSupport S = S := by
  ext x
  simp only [psiImageSupport, Finset.mem_biUnion]
  constructor
  · rintro ⟨i, hi, hx⟩
    simp only [psiBaseSupport, Finset.mem_insert, Finset.mem_singleton] at hx
    rcases hx with rfl | rfl
    · exact hi
    · exact hclosed i hi
  · intro hx
    exact ⟨x, hx, by simp [psiBaseSupport]⟩

-- ============================================================
-- § 12. Fano-complement characterization of ψ-images
-- ============================================================

/-- The imaginary low half: indices {1, 2, ..., 7}. -/
def imagLowHalf : Finset (Fin 16) :=
  (Finset.univ : Finset (Fin 16)).filter
    (fun i => decide (0 < i.val ∧ i.val < 8) = true)

/-- The 7 lines of the Fano plane PG(2, F₂), as subsets of {1,...,7}.
    Each line `{a, b, c}` satisfies `a ⊕ b = c` (bitwise XOR). -/
def fanoLines : List (Finset (Fin 16)) :=
  [{(1 : Fin 16), 2, 3}, {(1 : Fin 16), 4, 5},
   {(1 : Fin 16), 6, 7}, {(2 : Fin 16), 4, 6},
   {(2 : Fin 16), 5, 7}, {(3 : Fin 16), 4, 7},
   {(3 : Fin 16), 5, 6}]

/-- There are exactly 7 Fano lines. -/
theorem fanoLines_length : fanoLines.length = 7 := by native_decide

/-- Each Fano line has 3 elements. -/
theorem fanoLines_card_three :
    ∀ L ∈ fanoLines, L.card = 3 := by native_decide

/-- The complement of a Fano line in {1,...,7}: a 4-element subset. -/
def fanoComplement (L : Finset (Fin 16)) : Finset (Fin 16) :=
  imagLowHalf \ L

/-- The 7 Fano complements. -/
def fanoComplementList : List (Finset (Fin 16)) :=
  fanoLines.map fanoComplement

/-- Each Fano complement has exactly 4 elements. -/
theorem fanoComplement_card_four :
    ∀ L ∈ fanoLines, (fanoComplement L).card = 4 := by native_decide

/-- The vertical-pair expansion of a Fano complement: take each of its
    4 elements and include the partner. This gives an 8-element set. -/
def fanoComplementExpansion (L : Finset (Fin 16)) : Finset (Fin 16) :=
  (fanoComplement L).biUnion verticalPair

/-- Each Fano-complement expansion has 8 elements. -/
theorem fanoComplementExpansion_card_eight :
    ∀ L ∈ fanoLines, (fanoComplementExpansion L).card = 8 := by
  native_decide

/-- **Main structural theorem**: The 7 distinct ψ-images of zero-product
    supports are exactly the 7 Fano-complement expansions.

    Each Fano line `{a, b, c} ⊂ {1,...,7}` determines a complement
    `{1,...,7} \ {a, b, c}` of 4 elements, which expands to 8 elements
    via vertical pairing. The 6 zero-product supports that map to this
    image are precisely those whose low indices lie in the complement. -/
theorem psi_images_eq_fano_complement_expansions :
    psiImageList.toFinset =
      (fanoLines.map fanoComplementExpansion).toFinset := by
  native_decide

/-- Every ψ-image is a Fano-complement expansion. -/
theorem psi_image_is_fano_complement :
    ∀ S ∈ psiImageList,
      ∃ L ∈ fanoLines, S = fanoComplementExpansion L := by
  native_decide

/-- Every Fano-complement expansion is a ψ-image. -/
theorem fano_complement_is_psi_image :
    ∀ L ∈ fanoLines,
      fanoComplementExpansion L ∈ psiImageList := by
  native_decide

-- ============================================================
-- § 13. The 7 ψ-images are pairwise distinct
-- ============================================================

/-- The 7 ψ-images are pairwise distinct (no duplicates in the list). -/
theorem psi_images_nodup :
    psiImageList.Nodup := by native_decide

-- ============================================================
-- § 14. Summary and physics interpretation
-- ============================================================

/-!
## Summary

The naive Cayley–Dickson `ψ` generation action (order-3 rotation on each
`(eᵢ, eᵢ₊₈)` plane) does NOT act as a symmetry of the zero-divisor
cancellation geometry. Specifically:

1. **Support doubling**: Every 4-element zero-product support is spread to
   an 8-element support (`psi_image_zeroProd_card_all_eight`).

2. **Not a cancellation symmetry**: No ψ-image of a zero-product support
   is itself a zero-product support (`psi_not_sparse_cancellation_symmetry`).

3. **Controlled by vertical pairs**: The image is always a union of vertical
   partner pairs `{i, i+8}` — the partner involution is preserved
   (`psi_image_controlled_by_vertical_pairs`).

4. **Fano-complement sextets**: The 42 zero-product supports are merged into
   7 sextets of 6 supports each (`psi_image_zeroProd_distinct_count`,
   `psi_image_contains_six_zeroProd`). These 7 sextets correspond exactly
   to the 7 complements of lines of the Fano plane PG(2, F₂) in {1,...,7}
   (`psi_images_eq_fano_complement_expansions`).

5. **Idempotent spreading**: Applying ψ a second time does not spread further;
   the image is already partner-closed (`psi_image_idempotent_on_zeroProd`).

### Physics interpretation

The sparse assessor geometry is NOT invariant under the naive `ψ` action.
However, `ψ` does NOT destroy the geometry entirely — it creates a coarser,
Fano-complement-indexed structure. Each ψ-image merges exactly 6 zero-product
supports into a single 8-element configuration: the vertical-pair expansion
of a Fano complement.

The decomposition **42 = 7 × 6** reflects the Fano geometry:
- 7 lines in PG(2, F₂), each with 3 points
- 7 complementary 4-element subsets of {1,...,7}
- Each complement produces 6 zero-product supports (from the C(4,2) = 6
  ways to choose 2 of the 4 elements for the low pair)

This suggests that a refined generation action preserving the Fano-plane
line structure individually (rather than mixing all lines) could be a
candidate for a true generation symmetry of the cancellation geometry.
-/

end GenerationCancellationGeometry
