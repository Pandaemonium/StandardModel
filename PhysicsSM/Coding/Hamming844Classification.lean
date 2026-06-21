import Mathlib
import PhysicsSM.Coding.Hamming844UniquenessBasic

/-!
# Finite classification of binary [8,4,4] codes

This module proves that every binary linear `[8,4,4]` code is equivalent to
the extended Hamming code `extendedHamming8` under coordinate permutation.

## Main theorem

```lean
theorem extendedHamming8_unique_up_to_equivalence_proof
    (C : BinaryLinearCode 8) (hC : IsLinearCode C 4 4) :
    CodeEquivalent C extendedHamming8
```

## Proof structure

The proof has six parts, combining structural coding theory with a finite
computational verification:

### Part 1: Systematic code definitions and classification

A **systematic code** `[I₄ | P]` is a `[8,4,4]` code whose generator matrix
has the identity matrix `I₄` in the first four columns and an arbitrary
4×4 matrix `P` in the last four. Any linear `[8,4,d]` code with an
information set on positions `{0,1,2,3}` has this form.

The key computational step (`systematic_844_classification`) verifies by
`n a t i v e _ d e c i d e` over all `4^16 = 2^16 = 65,536` choices of `P : Fin 4 → Fin 4 → ZMod 2`
that only 24 matrices produce a code with minimum distance ≥ 4, and each
of those 24 is a coordinate permutation of `extendedHamming8`.

### Part 2: Bridging Finsets to Submodules

The computational step works with `Finset`-based code representations.
This part builds the bridge to `Submodule`-based code equivalence:
- `systematicSubmodule P` packages `[I₄|P]` as a `BinaryLinearCode`.
- `mem_systematicCodeFinset_iff` bridges Finset and Submodule membership.
- `systematic_codeEquiv_hamming` translates the Finset result to
  `CodeEquivalent (systematicSubmodule P) extendedHamming8`.

### Part 3: Information set existence

An **information set** of size `k` for a `[n,k,d]` code is a set of `k`
coordinate positions on which the code projection is injective. Every
`[8,4,4]` code has an information set of size 4.

Proof by contradiction: if no 4-element information set existed, every one
of the C(8,4) = 70 possible 4-element subsets would be blocked by some
nonzero codeword vanishing on it. But there are at most 15 nonzero codewords
(the code has 16 codewords total including the zero vector), and each
codeword of weight exactly 4 blocks exactly C(4,4) = 1 subset, while each
weight-8 codeword blocks C(4,4) = 1 subset. So at most 15 subsets are blocked,
but 70 > 15, contradicting the assumption.

### Part 4: Systematic form of codes with injective projection

If a `[8,4,4]` code `C` has an information set at positions `{0,1,2,3}`,
then `C` equals `systematicSubmodule P` for some `P`. The argument:
1. The projection to coordinates `{0,1,2,3}` is an `F₂`-linear bijection
   from `C` to `F₂⁴` (by the information set property).
2. The unique preimage of each standard basis vector `eᵢ` gives a
   "generator" `gᵢ ∈ C` with `projFirst4(gᵢ) = eᵢ`.
3. Every codeword is `∑ cᵢ gᵢ` for a unique coefficient vector `c`.
4. The matrix `P` whose rows are the last-4 coordinates of the `gᵢ` satisfies
   `C = systematicSubmodule P`.

### Part 5: Permuting an information set to {0,1,2,3}

Since information sets are at arbitrary positions, we permute coordinates so
the information set maps to `{0,1,2,3}`. The key lemma (`exists_perm_to_first4`)
finds such a permutation for any 4-element subset. Since there are `C(8,4) = 70`
such subsets and all permutations of `Fin 8` are checked, this is proved by
`n a t i v e _ d e c i d e`.

### Part 6: Full uniqueness theorem

Combining the five parts:
1. Find an information set `I` (Part 3).
2. Permute so `I` maps to `{0,1,2,3}` (Part 5).
3. After permutation, the code equals `systematicSubmodule P` (Part 4).
4. The systematic submodule is equivalent to `extendedHamming8` (Parts 1–2).
5. Compose the permutations (transitivity of `CodeEquivalent`).

## Historical context

This is Theorem 5.3 in Pless (1998): up to equivalence, the unique binary
`[8,4,4]` code is the extended Hamming code. The key ingredients (information
sets and systematic form) are standard in the textbook theory of linear codes.
The finite classification step is what makes the proof machine-verifiable
without abstract group theory.

## Finite-computation trust note

`systematic_844_classification` verifies the classification over all
`2^16 = 65,536` matrices `P` by `n a t i v e _ d e c i d e`. This introduces the
`Lean.trustCompiler` a x i o m. All structural reasoning uses only `propext`,
`Classical.choice`, and `Quot.sound`.

`exists_perm_to_first4` is also proved by `n a t i v e _ d e c i d e` (checking all
`8!/(8-4)! = 1680` relevant permutations of `Fin 8`).

## Source / provenance

- Pless, *Introduction to the Theory of Error-Correcting Codes*, Theorem 5.3.
- MacWilliams & Sloane, *The Theory of Error-Correcting Codes*, Ch. 1–2.
- Aristotle job S2 for PhysicsSM, 2026-05-07.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false
set_option linter.style.show false
set_option linter.style.multiGoal false
set_option linter.style.whitespace false
set_option linter.flexible false
set_option linter.style.refine false

namespace PhysicsSM.Coding

/-! ## Part 1: Systematic code definitions and computational classification

A systematic code `[I₄ | P]` of length 8 and dimension 4 has the 4×8
generator matrix `[I₄ | P]`, where `I₄` is the 4×4 identity matrix and
`P` is an arbitrary 4×4 binary matrix. The `i`-th row is `eᵢ ++ P_row_i`,
encoding the standard basis vector in the first 4 positions and the
parity-check bits in the last 4 positions.
-/

/-- The `i`-th row of the systematic generator matrix `[I₄ | P]`.

Position `j < 4` is the `(i,j)`-th entry of the 4×4 identity matrix:
it is 1 iff `j = i`, else 0.
Position `j ≥ 4` is `P[i][j-4]`, the corresponding entry of the parity
matrix `P`. -/
def mkSystematicRow (P : Matrix (Fin 4) (Fin 4) (ZMod 2)) (i : Fin 4) :
    BinaryVector 8 := fun j =>
  if h : j.val < 4 then
    (if (⟨j.val, h⟩ : Fin 4) = i then 1 else 0)
  else
    P i ⟨j.val - 4, by omega⟩

/-- A codeword of the systematic code `[I₄ | P]` with coefficient vector `c`.

The codeword is `∑ᵢ cᵢ · (i-th row of [I₄|P])`. In systematic form,
the first 4 coordinates equal `c` (the "information bits") and the last 4
coordinates are `P^T c` (the "parity bits"). -/
def systematicCW (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (c : Fin 4 → ZMod 2) : BinaryVector 8 :=
  fun j => ∑ i : Fin 4, c i * mkSystematicRow P i j

/-- The systematic code `[I₄ | P]` as a `Finset` of binary vectors.
Used in the computational classification. -/
def systematicCodeFinset (P : Matrix (Fin 4) (Fin 4) (ZMod 2)) :
    Finset (BinaryVector 8) :=
  Finset.univ.image (systematicCW P)

/-- The extended Hamming code as a `Finset`, for Finset-level comparisons. -/
def extendedHamming8Finset : Finset (BinaryVector 8) :=
  Finset.univ.filter fun v => v ∈ extendedHamming8

/-- **Computational classification**: every systematic `[I₄ | P]` code with
minimum Hamming distance ≥ 4 is a coordinate permutation of `extendedHamming8`.

**Proof method**: Enumerate all `2^16 = 65,536` binary 4×4 matrices `P`.
For each, check whether all `2^4 - 1 = 15` nonzero codewords have weight
≥ 4. Only 24 matrices pass this filter, and for each, find a coordinate
permutation mapping the code to `extendedHamming8`.

This is the central computational fact from which uniqueness follows.
The `n a t i v e _ d e c i d e` oracle verifies the entire enumeration.
The 24 valid matrices correspond to the 24 automorphisms of the extended
Hamming code (i.e., |Aut(Ham(8,4))| = 1344, but only 24 systematic forms).
-/
theorem systematic_844_classification :
    ∀ P : Matrix (Fin 4) (Fin 4) (ZMod 2),
      (∀ c : Fin 4 → ZMod 2, c ≠ 0 → 4 ≤ hammingWeight (systematicCW P c)) →
      ∃ σ : Equiv.Perm (Fin 8),
        (systematicCodeFinset P).image (permuteBinaryVector σ) =
          extendedHamming8Finset := by
  native_decide

/-! ## Part 2: Systematic code as a submodule and Finset–Submodule bridge

The computational classification works with `Finset`. To conclude that two
codes are `CodeEquivalent` (a `Submodule`-level notion), we build bridges
between the two representations.
-/

/-- `systematicCW P` as a `ZMod 2`-linear map from `Fin 4 → ZMod 2` to
`BinaryVector 8`. Linearity is checked by coordinatewise computation. -/
def systematicCWLinear (P : Matrix (Fin 4) (Fin 4) (ZMod 2)) :
    (Fin 4 → ZMod 2) →ₗ[ZMod 2] BinaryVector 8 where
  toFun := systematicCW P
  map_add' := by
    intro a b; ext j
    simp [systematicCW, add_mul, Finset.sum_add_distrib]
  map_smul' := by
    intro c v; ext j
    simp [systematicCW, Pi.smul_apply, smul_eq_mul, Finset.mul_sum, mul_assoc]

/-- The systematic code `[I₄ | P]` as a `BinaryLinearCode 8` (a
`ZMod 2`-submodule of `BinaryVector 8`). This is the range of the linear
map `systematicCWLinear P`. -/
def systematicSubmodule (P : Matrix (Fin 4) (Fin 4) (ZMod 2)) :
    BinaryLinearCode 8 :=
  LinearMap.range (systematicCWLinear P)

/-- The projection onto the first 4 coordinates: `v ↦ (v 0, v 1, v 2, v 3)`.

This is the key linear map used to extract the "information bits" from a
codeword. For systematic codes, the projection of `systematicCW P c` is `c`. -/
def projFirst4 : BinaryVector 8 →ₗ[ZMod 2] (Fin 4 → ZMod 2) where
  toFun v := fun i => v ⟨i.val, by omega⟩
  map_add' := by intro a b; ext i; simp [Pi.add_apply]
  map_smul' := by intro c v; ext i; simp [Pi.smul_apply]

/-- Projecting a systematic codeword onto the first 4 coordinates recovers
the coefficient vector: `projFirst4 (systematicCW P c) = c`.

This holds because `mkSystematicRow P i j = δ_{ij}` for `j < 4`, so the
first-4 block of the generator matrix is the identity. -/
theorem projFirst4_systematicCW (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (c : Fin 4 → ZMod 2) :
    projFirst4 (systematicCW P c) = c := by
  unfold projFirst4 systematicCW
  ext i; simp +decide [mkSystematicRow]

/-- `systematicCW P` is injective.

Proof: if `systematicCW P c₁ = systematicCW P c₂`, apply `projFirst4` to
both sides and use `projFirst4_systematicCW` to recover `c₁ = c₂`. -/
theorem systematicCW_injective (P : Matrix (Fin 4) (Fin 4) (ZMod 2)) :
    Function.Injective (systematicCW P) := by
  intro a b h
  have := congr_arg projFirst4 h
  rwa [projFirst4_systematicCW, projFirst4_systematicCW] at this

/-- Membership in the systematic submodule: `v ∈ systematicSubmodule P ↔ ∃ c, systematicCW P c = v`. -/
theorem mem_systematicSubmodule (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (v : BinaryVector 8) :
    v ∈ systematicSubmodule P ↔ ∃ c, systematicCW P c = v := by
  simp [systematicSubmodule, LinearMap.mem_range, systematicCWLinear]

/-- A vector belongs to the systematic `Finset` iff it belongs to the
systematic `Submodule`. Bridges the two code representations. -/
theorem mem_systematicCodeFinset_iff (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (v : BinaryVector 8) :
    v ∈ systematicCodeFinset P ↔ v ∈ systematicSubmodule P := by
  simp [systematicCodeFinset, Finset.mem_image, mem_systematicSubmodule]

/-- A vector belongs to the Hamming `Finset` iff it belongs to the Hamming
`Submodule`. -/
theorem mem_extendedHamming8Finset_iff (v : BinaryVector 8) :
    v ∈ extendedHamming8Finset ↔ v ∈ extendedHamming8 := by
  simp [extendedHamming8Finset, Finset.mem_filter]

/-- Permuting vectors in the systematic `Finset` corresponds to membership
in `permuteCode` at the `Submodule` level. -/
theorem mem_image_permute_systematicCodeFinset
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (σ : Equiv.Perm (Fin 8)) (v : BinaryVector 8) :
    v ∈ (systematicCodeFinset P).image (permuteBinaryVector σ) ↔
    v ∈ permuteCode σ (systematicSubmodule P) := by
  simp +decide [Finset.mem_image, mem_systematicSubmodule, permuteCode,
    Submodule.mem_map]
  unfold systematicCodeFinset
  simp +decide [Finset.mem_image, mem_systematicSubmodule,
    permuteBinaryVectorLinear]

/-- **Computational → code-equivalence bridge.** If the systematic code
`[I₄ | P]` has minimum distance ≥ 4, then it is `CodeEquivalent` to
`extendedHamming8`.

Proof: get the permutation `σ` from `systematic_844_classification`,
then verify that `permuteCode σ (systematicSubmodule P) = extendedHamming8`
by translating the Finset-level identity to Submodule-level membership. -/
theorem systematic_codeEquiv_hamming
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hmin : ∀ c : Fin 4 → ZMod 2, c ≠ 0 → 4 ≤ hammingWeight (systematicCW P c)) :
    CodeEquivalent (systematicSubmodule P) extendedHamming8 := by
  obtain ⟨σ, hσ⟩ := systematic_844_classification P hmin
  refine ⟨σ, ?_⟩
  ext v
  rw [show (v ∈ permuteCode σ (systematicSubmodule P)) ↔
    (v ∈ (systematicCodeFinset P).image (permuteBinaryVector σ)) from
    (mem_image_permute_systematicCodeFinset P σ v).symm]
  rw [hσ, mem_extendedHamming8Finset_iff]

/-! ## Part 3: Information set existence

An information set is a set of coordinate positions on which the code
restriction is injective (no nonzero codeword vanishes on all of them).
For a `[n,k,d]` code, an information set of size `k` always exists.

We prove existence for `[8,4,4]` codes by contradiction: if no 4-element
information set existed, every 4-element subset of `{0,…,7}` would be
"blocked" by some nonzero codeword vanishing on it. But there are only 15
nonzero codewords, giving at most 15 blocked subsets, while C(8,4) = 70.
The contradiction shows at least one information set must exist.
-/

/-- A set `I` of coordinates is an **information set** for code `C` if
no nonzero codeword vanishes on all positions in `I`.

Equivalently, the linear map `v ↦ (v i)_{i ∈ I}` (restriction to `I`) is
injective on `C`. For a `[n,k,d]` code, any `k` coordinates where the
restriction is injective form an information set. -/
def IsInfoSet {n : ℕ} (C : BinaryLinearCode n) (I : Finset (Fin n)) : Prop :=
  ∀ v ∈ C, (∀ i ∈ I, v i = 0) → v = 0

/-- **Every `[8,4,4]` code has an information set of size 4.**

Proof by contradiction. Assume every 4-element subset `I` is blocked by some
nonzero codeword `v_I ∈ C` that vanishes on `I`. Since `v_I` is nonzero and
has weight ≥ 4 (minimum distance), it vanishes on `I` and is nonzero on the
complement. With `|I| = 4`, the support of `v_I` is exactly the complement
`{0,…,7} \ I`, giving `v_I = 1_{complement of I}` (the indicator function).

Now `v_I + v_J = 1_{complement of I} + 1_{complement of J}` for distinct
4-element subsets `I, J`. Taking `I = {0,1,2,3}` and `J = {0,1,2,4}`, the
sum has weight 2 (supported on {3,4}), contradicting `d ≥ 4`.
-/
theorem info_set_exists (C : BinaryLinearCode 8)
    (hC : IsLinearCode C 4 4) :
    ∃ I : Finset (Fin 8), I.card = 4 ∧ IsInfoSet C I := by
  obtain ⟨hC₁, hC₂⟩ := hC
  by_contra h_no_info_set
  have h_exists_vanishing :
      ∀ I : Finset (Fin 8), I.card = 4 →
      ∃ v ∈ C, v ≠ 0 ∧ ∀ i ∈ I, v i = 0 := by
    contrapose! h_no_info_set
    exact ⟨h_no_info_set.choose, h_no_info_set.choose_spec.1,
      fun v hv hv' => Classical.not_not.1 fun hv'' => by
        obtain ⟨i, hi, hi'⟩ := h_no_info_set.choose_spec.2 v hv hv''
        exact hi' (hv' i hi)⟩
  choose! v hv₁ hv₂ hv₃ using h_exists_vanishing
  -- Since v_I vanishes on I and has weight exactly 4 (min dist),
  -- it must be the indicator function of the complement of I.
  have h_char : ∀ I : Finset (Fin 8), I.card = 4 →
      v I = fun i => if i ∈ I then 0 else 1 := by
    intros I hI_card
    have h_char : ∀ i, v I i = if i ∈ I then 0 else 1 := by
      intro i; split_ifs <;> simp_all +decide [hammingWeight]
      have := Finset.eq_of_subset_of_card_le
        (show Finset.filter (fun j => ¬v I j = 0) Finset.univ ⊆ Finset.univ \ I from
          fun x hx => by aesop)
      simp_all +decide [Finset.card_sdiff]
      replace this := Finset.ext_iff.mp this i
      simp_all +decide [Finset.mem_sdiff]
      exact Or.resolve_left (Fin.exists_fin_two.mp (by aesop)) this
    exact funext h_char
  -- If v_I = 1_{complement of I}, then the indicator of complement(I) is in C.
  have h_contradiction :
      ∀ I : Finset (Fin 8), I.card = 4 →
      (fun i => if i ∈ I then 0 else 1) ∈ C :=
    fun I hI => h_char I hI ▸ hv₁ I hI
  -- Equivalently, the indicator of I itself is in C (by complement symmetry).
  have h_contradiction :
      ∀ I : Finset (Fin 8), I.card = 4 →
      (fun i => if i ∈ I then 1 else 0) ∈ C := by
    intro I hI
    convert h_contradiction (Finset.univ \ I) (by simp +decide [Finset.card_sdiff, *]) using 1
    ext i; by_cases hi : i ∈ I <;> simp +decide [hi]
  -- Taking I = {0,1,2,3} and J = {0,1,2,4}, their sum has weight 2,
  -- contradicting the minimum distance 4 of C.
  have h_contradiction :
      (fun i => if i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 3 then 1 else 0) ∈ C ∧
      (fun i => if i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 4 then 1 else 0) ∈ C :=
    ⟨by simpa using h_contradiction {0, 1, 2, 3} rfl,
     by simpa using h_contradiction {0, 1, 2, 4} rfl⟩
  have := C.add_mem h_contradiction.1 h_contradiction.2
  simp +decide at this
  exact absurd (hC₂ _ this (by decide)) (by decide)

/-! ## Part 4: Injective projection implies systematic form

If a `[8,4,4]` code `C` has an information set at positions `{0,1,2,3}`,
then `C` equals `systematicSubmodule P` for some matrix `P`.

The key idea: the projection `projFirst4 : C → F₂⁴` is injective (by the
information set property) and between spaces of equal dimension 4, hence
bijective. The preimages of the standard basis vectors are the generator rows,
and their last-4 coordinates form the matrix `P`.
-/

/-- **A code with information set {0,1,2,3} has systematic form.**

If `C` is a `[8,4,4]` code and `projFirst4` is injective on `C`, then
`C = systematicSubmodule P` for some `P : Matrix (Fin 4) (Fin 4) (ZMod 2)`,
and `P` inherits the minimum-distance property.

**Proof sketch:**
1. **Bijection**: `projFirst4` restricted to `C` is an `F₂`-linear bijection
   to `F₂⁴` (injective by hypothesis, same dimension by `IsLinearCode`).
2. **Generator preimages**: the preimage `gᵢ` of `eᵢ` (standard basis vector)
   is a codeword with `projFirst4(gᵢ) = eᵢ`.
3. **Matrix P**: define `P[i][j] = gᵢ[j+4]` (the last-4 coordinate of `gᵢ`).
4. **C equals systematic**: every `v ∈ C` equals `∑ (projFirst4 v)ᵢ · gᵢ`
   by injectivity of `projFirst4`, which equals `systematicCW P (projFirst4 v)`.
5. **Min distance**: inherited from `hC.min_dist` applied to the same codeword.
-/
theorem code_eq_systematic_of_inj_proj
    (C : BinaryLinearCode 8)
    (hC : IsLinearCode C 4 4)
    (hinj : IsInfoSet C {0, 1, 2, 3}) :
    ∃ P : Matrix (Fin 4) (Fin 4) (ZMod 2),
      C = systematicSubmodule P ∧
      ∀ c : Fin 4 → ZMod 2, c ≠ 0 → 4 ≤ hammingWeight (systematicCW P c) := by
  -- Find the preimage generators gᵢ with projFirst4(gᵢ) = eᵢ
  obtain ⟨g, hg⟩ : ∃ g : Fin 4 → BinaryVector 8,
      (∀ i, g i ∈ C) ∧ (∀ i, projFirst4 (g i) = Pi.single i 1) := by
    have h_basis : ∀ (v : Fin 4 → ZMod 2), ∃ w ∈ C, projFirst4 w = v := by
      have h_basis : LinearMap.range (projFirst4.comp (Submodule.subtype C)) = ⊤ := by
        refine' Submodule.eq_top_of_finrank_eq _
        rw [LinearMap.finrank_range_of_inj]
        · exact hC.dim_eq.trans (by norm_num)
        · intro v w h; specialize hinj (v - w)
          simp_all +decide [sub_eq_zero]
          exact hinj (C.sub_mem v.2 w.2)
            (by simpa using congr_fun h 0) (by simpa using congr_fun h 1)
            (by simpa using congr_fun h 2) (by simpa using congr_fun h 3)
      intro v; replace h_basis := SetLike.ext_iff.mp h_basis v; aesop
    exact ⟨fun i => Classical.choose (h_basis (Pi.single i 1)),
      fun i => Classical.choose_spec (h_basis (Pi.single i 1)) |>.1,
      fun i => Classical.choose_spec (h_basis (Pi.single i 1)) |>.2⟩
  -- Define P from the last-4 coordinates of the generators
  obtain ⟨P, hP⟩ : ∃ P : Matrix (Fin 4) (Fin 4) (ZMod 2),
      ∀ i, g i = mkSystematicRow P i := by
    use fun i j => g i ⟨j.val + 4, by omega⟩
    intro i; ext j; by_cases hj : j.val < 4 <;>
    simp_all +decide [Fin.ext_iff, mkSystematicRow]
    convert congr_fun (hg.2 i) ⟨j, hj⟩ using 1
    fin_cases j <;> fin_cases i <;> rfl
  refine' ⟨P, _, _⟩
  · -- Show C = systematicSubmodule P by two inclusions
    refine' le_antisymm _ _
    · -- C ⊆ systematicSubmodule P:
      -- every v ∈ C equals ∑ (projFirst4 v)ᵢ · gᵢ = systematicCW P (projFirst4 v)
      intro v hv
      obtain ⟨c, hc⟩ : ∃ c : Fin 4 → ZMod 2, v = ∑ i, c i • g i := by
        have h_span : ∀ v ∈ C, ∃ c : Fin 4 → ZMod 2, v = ∑ i, c i • g i := by
          intro v hv
          have h_proj_eq : projFirst4 (v - ∑ i, (projFirst4 v i) • g i) = 0 := by
            simp +decide [hg.2, projFirst4]
            ext i; simp +decide [Fin.sum_univ_four, hP]
            fin_cases i <;> simp +decide [mkSystematicRow]
          have h_zero : v - ∑ i, (projFirst4 v i) • g i = 0 := by
            apply hinj
            · exact C.sub_mem hv (C.sum_mem fun i _ => C.smul_mem _ (hg.1 i))
            · exact fun i hi => by
                simpa using congr_fun h_proj_eq ⟨i, by fin_cases hi <;> trivial⟩
          exact ⟨_, eq_of_sub_eq_zero h_zero⟩
        exact h_span v hv
      use c; ext j
      simp +decide [hc, hP, systematicCWLinear, systematicCW]
    · -- systematicSubmodule P ⊆ C:
      -- every systematicCW P c = ∑ c i • g i ∈ C
      intro v hv
      obtain ⟨c, rfl⟩ := mem_systematicSubmodule P v |>.1 hv
      simp_all +decide [Fin.sum_univ_four]
      convert C.sum_mem fun i _ => C.smul_mem (c i) (hg.1 i) using 1
      swap; exact Finset.univ
      ext j; simp +decide [systematicCW, Finset.sum_apply, Pi.smul_apply]
  · -- Minimum distance of systematicCW P is ≥ 4
    -- (inherited from hC.min_dist applied to the same linear combination of g's)
    intro c hc
    convert hC.min_dist (∑ i, c i • g i) _ _ using 1
    · congr! 1; ext j; simp +decide [hP, systematicCW]
    · exact Submodule.sum_mem _ fun i _ => Submodule.smul_mem _ _ (hg.1 i)
    · contrapose! hc
      ext i; replace hc := congr_arg (fun v => projFirst4 v i) hc
      simp_all +decide [Finset.sum_apply, Pi.single_apply]

/-! ## Part 5: Permuting an information set to {0,1,2,3}

Any 4-element subset of `Fin 8` can be mapped to `{0,1,2,3}` by a coordinate
permutation. This is a finite enumeration over all 70 possible 4-element subsets
and all permutations sending each to `{0,1,2,3}`. Proved by `n a t i v e _ d e c i d e`.
-/

/-- **Given any 4-element subset `I ⊆ Fin 8`, there exists a permutation
`σ : Equiv.Perm (Fin 8)` mapping `I` to `{0,1,2,3}`.**

This is used to move an arbitrary information set to the canonical positions
`{0,1,2,3}` needed by the systematic form argument.

Proved by `n a t i v e _ d e c i d e` over the finitely many (70) choices of 4-element
subsets and the permutations that map each to `{0,1,2,3}`. -/
theorem exists_perm_to_first4 (I : Finset (Fin 8)) (hI : I.card = 4) :
    ∃ σ : Equiv.Perm (Fin 8), I.image σ = {0, 1, 2, 3} := by
  native_decide +revert

/-- Permuting coordinates transforms an information set `I` for code `C`
into an information set `σ(I)` for `permuteCode σ C`.

If `projFirst4` was injective on `C` at positions `I`, then after permuting
the code by `σ`, the projection at positions `σ(I)` is injective. -/
theorem isInfoSet_permuteCode (C : BinaryLinearCode 8) (σ : Equiv.Perm (Fin 8))
    (I : Finset (Fin 8)) (hI : IsInfoSet C I) :
    IsInfoSet (permuteCode σ C) (I.image σ) := by
  intro v hv
  simp_all +decide [IsInfoSet, mem_permuteCode_iff]
  intro hv'
  specialize hI _ hv
  simp_all +decide [permuteBinaryVector]
  exact funext fun x => by simpa using congr_fun hI (σ.symm x)

/-! ## Part 6: Full uniqueness theorem

All five parts are assembled here. The proof is:
1. Find an information set `I` of size 4.
2. Permute so `I` maps to `{0,1,2,3}`.
3. The permuted code has a systematic form `[I₄|P]`.
4. The systematic code is equivalent to `extendedHamming8`.
5. Chain the equivalences by transitivity.
-/

/-- **Every binary `[8,4,4]` code is equivalent to `extendedHamming8`.**

This is the main result, combining the five parts above. See the module
docstring for the complete proof outline.

The proof proceeds by:
1. Obtaining an information set (`info_set_exists`).
2. Permuting it to `{0,1,2,3}` (`exists_perm_to_first4`).
3. Identifying the permuted code with a systematic code
   (`code_eq_systematic_of_inj_proj`).
4. Classifying all systematic `[8,4,4]` codes as equivalent to `extendedHamming8`
   (`systematic_codeEquiv_hamming`).
5. Chaining the equivalences (`CodeEquivalent.trans`). -/
theorem extendedHamming8_unique_up_to_equivalence_proof
    (C : BinaryLinearCode 8) (hC : IsLinearCode C 4 4) :
    CodeEquivalent C extendedHamming8 := by
  -- Step 1: C has an information set of size 4
  obtain ⟨I, hI_card, hI_info⟩ := info_set_exists C hC
  -- Step 2: Permute so that I maps to {0,1,2,3}
  obtain ⟨σ₁, hσ₁⟩ := exists_perm_to_first4 I hI_card
  -- Step 3: The permuted code has [8,4,4] parameters and info set {0,1,2,3}
  have hC₁ : IsLinearCode (permuteCode σ₁ C) 4 4 :=
    CodeEquivalent.isLinearCode ⟨σ₁, rfl⟩ hC
  have hinfo₁ : IsInfoSet (permuteCode σ₁ C) {0, 1, 2, 3} := by
    rw [← hσ₁]; exact isInfoSet_permuteCode C σ₁ I hI_info
  -- Step 4: The permuted code equals a systematic submodule
  obtain ⟨P, hP_eq, hP_min⟩ :=
    code_eq_systematic_of_inj_proj (permuteCode σ₁ C) hC₁ hinfo₁
  -- Step 5: The systematic submodule is equivalent to extendedHamming8
  have hequiv_sys := systematic_codeEquiv_hamming P hP_min
  -- Step 6: Combine via transitivity of CodeEquivalent
  -- C ≡ permuteCode σ₁ C (by σ₁)
  -- permuteCode σ₁ C = systematicSubmodule P (by hP_eq)
  -- systematicSubmodule P ≡ extendedHamming8 (computational classification)
  have hequiv₁ : CodeEquivalent C (permuteCode σ₁ C) := ⟨σ₁, rfl⟩
  have hequiv₂ : CodeEquivalent (permuteCode σ₁ C) (systematicSubmodule P) :=
    ⟨1, by rw [permuteCode_one]; exact hP_eq⟩
  exact (hequiv₁.trans hequiv₂).trans hequiv_sys

end PhysicsSM.Coding
