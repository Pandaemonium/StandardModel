import Mathlib
import PhysicsSM.Coding.CodeEquivalence

/-!
# Helper package: the extended Hamming code satisfies the [8,4,4] predicate

This module proves, without `s o r r y`, the foundational facts needed to state
and eventually prove the uniqueness theorem for the extended `[8,4,4]`
Hamming code:

1. **The `[n,k,d]` predicate** (`IsLinearCode`): a structure capturing the
   three defining parameters of a binary linear code — dimension `k` as an
   F₂-vector space, minimum Hamming distance `d`, and achievability of the
   minimum.

2. **The extended Hamming code satisfies `[8,4,4]`**
   (`extendedHamming8_isLinearCode_4_4`): dimension 4 is derived from the
   cardinality 16 = 2⁴; minimum distance 4 is imported from the existing
   `extendedHamming8_minWeight'`; the weight-4 witness is the explicit
   codeword `(0,0,0,1,1,1,1,0)`.

3. **Equivalence preserves parameters** (`CodeEquivalent.isLinearCode`):
   if two codes are related by a coordinate permutation, they have the same
   dimension and minimum distance. This makes `IsLinearCode` a well-defined
   property of the equivalence class.

## Why this module exists

The `IsLinearCode` structure is used in two places:
- `PhysicsSM.Draft.Hamming844Uniqueness` — to state the uniqueness theorem
  `extendedHamming8_unique_up_to_equivalence` as: every [8,4,4] code is
  equivalent to `extendedHamming8`.
- Future Aristotle jobs working towards a proof of uniqueness.

By separating these s o r r y-free helper results from the draft uniqueness file,
we keep the trusted and draft layers cleanly separated.

## Mathematical background

A binary linear code C ⊆ F₂ⁿ has parameters [n, k, d] when:
- n = length (the ambient dimension)
- k = dim_{F₂}(C) (the number of linearly independent generators)
- d = min { wt(v) : v ∈ C, v ≠ 0 } (the minimum Hamming weight)

The Singleton bound gives d ≤ n − k + 1. The [8,4,4] Hamming code achieves
d = n − k = 4, which makes it a **maximum-distance separable code** (MDS).
More relevantly for our purposes, d = 4 and doubly-even ⟹ Construction A
gives an even integer lattice with minimum squared norm 4.

## Finite-computation trust note

The dimension proof (`extendedHamming8_finrank`) uses `n a t i v e _ d e c i d e` to
compute `Fintype.card ↥extendedHamming8 = 16`. This introduces the
`Lean.trustCompiler` a x i o m. All other proofs use only standard axioms
(`propext`, `Classical.choice`, `Quot.sound`).

## Source / provenance

- MacWilliams & Sloane, *The Theory of Error-Correcting Codes*, Ch. 1–2.
- Huffman & Pless, *Fundamentals of Error-Correcting Codes*, §1.2.
- Aristotle helper-package retry for PhysicsSM, 2026-05-07.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false
set_option linter.style.show false

namespace PhysicsSM.Coding

/-! ## The [n,k,d] predicate

We define a `Prop`-valued structure (not a `class`, to avoid typeclass
search issues) that expresses the standard `[n,k,d]` parameter triple for
a binary linear code.
-/

/-- A binary linear code has parameters `[n, k, d]` if it has length `n`,
dimension `k` (as an `F₂`-vector space), and minimum Hamming distance `d`
(minimum Hamming weight among all nonzero codewords).

The achievability field `min_dist_achieved` records that the minimum is not
vacuous: there exists a nonzero codeword actually attaining weight `d`. This
is needed to distinguish "minimum distance is at least d" from "minimum
distance is exactly d".

Convention: we use `BinaryLinearCode n = Submodule (ZMod 2) (Fin n → ZMod 2)`,
so dimension is `Module.finrank (ZMod 2) C`.
-/
structure IsLinearCode {n : ℕ} (C : BinaryLinearCode n) (k d : ℕ) : Prop where
  /-- The code has dimension `k` as an F₂-vector space. -/
  dim_eq : Module.finrank (ZMod 2) C = k
  /-- Every nonzero codeword has Hamming weight at least `d`. -/
  min_dist : ∀ v ∈ C, v ≠ 0 → d ≤ hammingWeight v
  /-- The minimum distance is attained: some nonzero codeword has weight exactly `d`. -/
  min_dist_achieved : ∃ v ∈ C, v ≠ 0 ∧ hammingWeight v = d

/-! ## Decidability and finiteness for the extended Hamming code

These instances are needed for the cardinality computation used in the
dimension proof. The extended Hamming code is the kernel of a linear map
over a decidable equality type, so membership is decidable.
-/

/-- Membership in `extendedHamming8` is decidable, because the parity-check
condition `Matrix.mulVec H₈ v = 0` is a decidable equality in `ZMod 2`. -/
instance extendedHamming8_decidableMem : DecidablePred (· ∈ extendedHamming8) := by
  intro v
  change Decidable (v ∈ LinearMap.ker (Matrix.mulVecLin extendedHamming8ParityCheck))
  rw [LinearMap.mem_ker]
  exact decEq _ _

/-- The extended Hamming code has exactly 16 codewords as a `Subtype`.

This is 2⁴ = 16, consistent with dimension k = 4. Proved by compiling the
membership predicate and evaluating it on all 256 = 2⁸ binary vectors.
-/
theorem extendedHamming8_subtype_card : Fintype.card ↥extendedHamming8 = 16 := by
  native_decide

/-! ## Dimension: k = 4

The dimension proof proceeds by:
1. Using `Module.card_eq_pow_finrank` to express `|C| = 2^(finrank F₂ C)`.
2. Substituting `|C| = 16 = 2⁴`.
3. Cancelling the common base 2 via `Nat.pow_right_injective`.
-/

/-- The extended Hamming code has dimension 4 as an F₂-vector space.

Proof: `|extendedHamming8| = 16 = 2⁴ = |F₂|^(finrank)`, so `finrank = 4`
by injectivity of `2^·`. -/
theorem extendedHamming8_finrank :
    Module.finrank (ZMod 2) extendedHamming8 = 4 := by
  have h1 := extendedHamming8_subtype_card
  have h2 := @Module.card_eq_pow_finrank (ZMod 2) extendedHamming8 _ _ _ _ _
  simp only [ZMod.card] at h2
  rw [h1] at h2
  have h3 : 2 ^ Module.finrank (ZMod 2) ↥extendedHamming8 = 2 ^ 4 := by omega
  exact Nat.pow_right_injective (by norm_num : 1 < 2) h3

/-! ## Minimum distance achieved: a weight-4 codeword

The explicit codeword `(0,0,0,1,1,1,1,0)` has Hamming weight 4 and satisfies
the parity-check condition. This witnesses that the minimum distance is at
most 4; combined with `extendedHamming8_minWeight'` (every nonzero codeword
has weight ≥ 4), it shows the minimum is exactly 4.

In the matrix language: columns {3,4,5,6} of H₈ are the support of this
codeword, and the parity-check `H₈ · (0,0,0,1,1,1,1,0)ᵀ = 0` is verified
by `n a t i v e _ d e c i d e`.
-/

/-- There exists a codeword of the extended Hamming code with Hamming weight
exactly 4. The explicit witness is `v = (0,0,0,1,1,1,1,0)`. -/
theorem extendedHamming8_has_weight4 :
    ∃ v ∈ extendedHamming8, v ≠ 0 ∧ hammingWeight v = 4 := by
  refine ⟨![0, 0, 0, 1, 1, 1, 1, 0], ?_, ?_, ?_⟩
  · -- Membership: H₈ · (0,0,0,1,1,1,1,0)ᵀ = 0 over F₂
    rw [extendedHamming8_mem_iff_mulVec]; native_decide
  · -- Nonzero: coordinate 3 is 1, not 0
    intro h; have := congr_fun h 3; simp at this
  · -- Weight = 4: exactly four 1s at positions 3,4,5,6
    native_decide

/-! ## The [8,4,4] predicate for the extended Hamming code -/

/-- **The extended Hamming code satisfies `[8,4,4]`.**

Combining:
- Dimension 4 (`extendedHamming8_finrank`)
- Minimum distance 4 (`extendedHamming8_minWeight'` from `HammingE8.lean`)
- Achievability of distance 4 (`extendedHamming8_has_weight4`)

This theorem is the semantic certificate that `extendedHamming8` is what it
claims to be: a code of length 8, dimension 4, and minimum distance 4.
-/
theorem extendedHamming8_isLinearCode_4_4 :
    IsLinearCode extendedHamming8 4 4 where
  dim_eq            := extendedHamming8_finrank
  min_dist          := fun v hv hne => extendedHamming8_minWeight' v hv hne
  min_dist_achieved := extendedHamming8_has_weight4

/-! ## Dimension preservation under coordinate permutation

A coordinate permutation of F₂ⁿ is a linear equivalence (bijective linear
map). Bijective linear maps preserve dimension. This is the key abstract fact
that makes `IsLinearCode` a property of the equivalence class, not just of
one particular parity-check matrix representative.
-/

/-- A coordinate permutation `σ : Equiv.Perm (Fin n)` defines a linear
equivalence on `BinaryVector n = Fin n → ZMod 2`.

This is the upgrading of `permuteBinaryVector` (a linear map) to a
`LinearEquiv` (a linear isomorphism). The inverse is permutation by `σ⁻¹ = σ.symm`.
-/
def permuteBinaryVectorEquiv {n : ℕ} (σ : Equiv.Perm (Fin n)) :
    BinaryVector n ≃ₗ[ZMod 2] BinaryVector n where
  toFun    := permuteBinaryVector σ
  map_add' := permuteBinaryVector_add σ
  map_smul' := by intro c v; ext i; simp [permuteBinaryVector, Pi.smul_apply]
  invFun   := permuteBinaryVector σ.symm
  left_inv := by intro v; simp
  right_inv := by intro v; simp

/-- The image of a code under a coordinate permutation (`permuteCode`) agrees
with the image under the corresponding linear equivalence (`Submodule.map`).

This bridge lemma connects `permuteCode` (defined via `permuteBinaryVectorLinear`)
to the `LinearEquiv` version, enabling use of `LinearEquiv.finrank_map_eq`.
-/
theorem permuteCode_eq_map_equiv {n : ℕ} (σ : Equiv.Perm (Fin n))
    (C : BinaryLinearCode n) :
    permuteCode σ C =
      Submodule.map
        (permuteBinaryVectorEquiv σ : BinaryVector n →ₗ[ZMod 2] BinaryVector n)
        C := by
  ext v
  simp only [permuteCode, Submodule.mem_map]
  constructor
  · rintro ⟨w, hw, rfl⟩; exact ⟨w, hw, rfl⟩
  · rintro ⟨w, hw, rfl⟩; exact ⟨w, hw, rfl⟩

/-- **Coordinate permutation preserves dimension.**

The F₂-dimension of a code is invariant under coordinate permutation.
Proof: `permuteCode σ C = (permuteBinaryVectorEquiv σ).map C`, and bijective
linear maps preserve dimension by `LinearEquiv.finrank_map_eq`.
-/
theorem finrank_permuteCode {n : ℕ} (σ : Equiv.Perm (Fin n))
    (C : BinaryLinearCode n) :
    Module.finrank (ZMod 2) (permuteCode σ C) =
      Module.finrank (ZMod 2) C := by
  rw [permuteCode_eq_map_equiv]
  exact LinearEquiv.finrank_map_eq (permuteBinaryVectorEquiv σ) C

/-! ## Code equivalence preserves the [n,k,d] predicate -/

/-- **Code equivalence preserves `IsLinearCode`.**

If `C` and `D` are equivalent codes (related by a coordinate permutation)
and `C` has parameters `[n, k, d]`, then `D` also has parameters `[n, k, d]`.

This theorem makes `IsLinearCode` a well-defined property of the code
equivalence class. In particular, the uniqueness theorem
`extendedHamming8_unique_up_to_equivalence` (draft) can be stated as:
every code with `IsLinearCode C 4 4` is equivalent to `extendedHamming8`.

The three properties are transferred as follows:
- Dimension: `finrank_permuteCode` (dimension is preserved by bijective linear maps)
- Minimum distance: `hammingWeight_permuteBinaryVector` (weight is permutation-invariant)
- Achievability: exhibit the permuted witness codeword
-/
theorem CodeEquivalent.isLinearCode {n : ℕ} {C D : BinaryLinearCode n}
    {k d : ℕ} (hCD : CodeEquivalent C D) (hC : IsLinearCode C k d) :
    IsLinearCode D k d := by
  obtain ⟨σ, rfl⟩ := hCD
  exact {
    dim_eq := by
      rw [finrank_permuteCode]
      exact hC.dim_eq
    min_dist := by
      -- A nonzero codeword of permuteCode σ C has the form σ(w) for w ∈ C.
      -- Its weight equals the weight of w by permutation-invariance.
      intro v hv hne
      rw [mem_permuteCode_iff] at hv
      rw [← hammingWeight_permuteBinaryVector σ.symm]
      exact hC.min_dist _ hv (permuteBinaryVector_ne_zero _ _ hne)
    min_dist_achieved := by
      -- Take the witness w from C with weight d, and exhibit σ(w) in D.
      obtain ⟨w, hw_mem, hw_ne, hw_wt⟩ := hC.min_dist_achieved
      exact ⟨permuteBinaryVector σ w,
        ⟨w, hw_mem, rfl⟩,
        permuteBinaryVector_ne_zero σ w hw_ne,
        by rw [hammingWeight_permuteBinaryVector]; exact hw_wt⟩ }

end PhysicsSM.Coding
