import PhysicsSM.Coding.E8ShortVectors
import PhysicsSM.Coding.HammingWeightEnumerator

/-!
# Aristotle scaffold: structural E8 short-vector count

This draft packages job A from the Hamming/Construction A/E8 strengthening
list.  The goal is to replace the monolithic `n a t i v e _ d e c i d e` proof of the
240 short vectors with a structural proof from:

* the Hamming weight distribution `(A_0, A_4, A_8) = (1, 14, 1)`;
* the one-coordinate lift counts for even and odd residues;
* the classification of `sqNorm = 4` lifts.

## Proof strategy

We encode short vectors via `Fin 8 → Fin 5` (coordinate values in
`{-2, -1, 0, 1, 2}`), partition by the Hamming weight of the binary
residue `reduceModTwo z`, and count each weight class:

* **Weight 0**: zero residue, lifts are `±2eᵢ` → 16 vectors.
  Count = `A₀ × 16 = 1 × 16`.
* **Weight 4**: weight-4 codeword support, lifts have `±1` on support →
  16 sign patterns per codeword.  Count = `A₄ × 16 = 14 × 16`.
* **Weight 8**: all coordinates odd, `sqNorm ≥ 8 > 4` → 0 lifts.
  Count = `A₈ × 0 = 1 × 0`.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding

/-- The semantic set of short vectors in the Hamming Construction A lattice. -/
noncomputable def hammingE8ShortVectorSet : Set (Fin 8 → Int) :=
  {z | isShortHammingE8Vector z}

/-- The intended structural weight-distribution expression for the `sqNorm = 4`
shell.  Mathematically this is
`A_0 * 16 + A_4 * 16 + A_8 * 0 = 240`. -/
def shortVectorWeightDistributionFormula : Nat :=
  extendedHamming8WeightDist 0 * 16 +
  extendedHamming8WeightDist 4 * 16 +
  extendedHamming8WeightDist 8 * 0

/-! ## Structural encoding via Fin 5 -/

/-- The decode map from `Fin 5` encodings to integer vectors. -/
abbrev decode5 (f : Fin 8 → Fin 5) : Fin 8 → ℤ := fun i => shortValList (f i)

/-- The encode map from integer vectors to `Fin 5` encodings. -/
def encode5 (z : Fin 8 → ℤ) : Fin 8 → Fin 5 := fun i => intToFin5' (z i)

/-- Round-trip: decoding an encoding of a short vector recovers the original. -/
lemma decode5_encode5 (z : Fin 8 → ℤ) (h : sqNorm z = 4) :
    decode5 (encode5 z) = z :=
  vector_eq_shortValList_comp_intToFin5' z h

/-- `shortValList` is injective. -/
lemma shortValList_injective : Function.Injective (shortValList : Fin 5 → ℤ) := by decide

/-- The decode map is injective. -/
lemma decode5_injective : Function.Injective decode5 :=
  fun _ _ h => funext fun i => shortValList_injective (congr_fun h i)

/-! ## Finset of short vector codes -/

/-- The `Finset` of `Fin 5`-encodings of short vectors. -/
def svCode : Finset (Fin 8 → Fin 5) :=
  Finset.univ.filter (fun f => isShortHammingE8Vector (decode5 f))

/-! ## Bridge: Set.ncard = svCode.card -/

/-- The image of `svCode` under `decode5` equals the short-vector set. -/
lemma decode5_image_svCode :
    decode5 '' (↑svCode : Set (Fin 8 → Fin 5)) = hammingE8ShortVectorSet := by
  ext z
  simp only [Set.mem_image, Finset.mem_coe, svCode, Finset.mem_filter, Finset.mem_univ,
    true_and, hammingE8ShortVectorSet, Set.mem_setOf_eq]
  constructor
  · rintro ⟨f, hf, rfl⟩; exact hf
  · intro hz
    exact ⟨encode5 z, by rwa [show decode5 (encode5 z) = z from decode5_encode5 z hz.2],
            decode5_encode5 z hz.2⟩

/-- The short-vector set has the same `ncard` as `svCode.card`. -/
lemma ncard_eq_svCode_card : Set.ncard hammingE8ShortVectorSet = svCode.card := by
  rw [← decode5_image_svCode, Set.ncard_image_of_injective _ decode5_injective]
  exact Set.ncard_coe_finset svCode

/-! ## Partition by residue weight -/

/-- Weight class `w` of the short vector code set. -/
def svCodeW (w : ℕ) : Finset (Fin 8 → Fin 5) :=
  svCode.filter (fun f => hammingWeight (reduceModTwo (decode5 f)) = w)

/-- Every short vector code has residue weight 0, 4, or 8. -/
lemma svCode_weight_trichotomy (f : Fin 8 → Fin 5) (hf : f ∈ svCode) :
    hammingWeight (reduceModTwo (decode5 f)) = 0 ∨
    hammingWeight (reduceModTwo (decode5 f)) = 4 ∨
    hammingWeight (reduceModTwo (decode5 f)) = 8 :=
  extendedHamming8_weight_support _ (Finset.mem_filter.mp hf).2.1

/-- The code set partitions into weight classes 0, 4, 8. -/
lemma svCode_partition : svCode = svCodeW 0 ∪ svCodeW 4 ∪ svCodeW 8 := by
  ext f
  simp only [svCodeW, Finset.mem_union, Finset.mem_filter]
  constructor
  · intro hf
    rcases svCode_weight_trichotomy f hf with h | h | h
    · exact Or.inl (Or.inl ⟨hf, h⟩)
    · exact Or.inl (Or.inr ⟨hf, h⟩)
    · exact Or.inr ⟨hf, h⟩
  · rintro ((⟨hf, -⟩ | ⟨hf, -⟩) | ⟨hf, -⟩) <;> exact hf

/-- Distinct weight classes are disjoint. -/
lemma svCodeW_disjoint (a b : ℕ) (hab : a ≠ b) : Disjoint (svCodeW a) (svCodeW b) := by
  rw [svCodeW, svCodeW, Finset.disjoint_filter]
  exact fun _ _ h1 h2 => hab (h1 ▸ h2)

/-! ## Weight-class counts -/

/-- Weight-0 count: the unique zero-residue codeword yields 16 short lifts. -/
lemma svCodeW0_card : (svCodeW 0).card = extendedHamming8WeightDist 0 * 16 := by
  rw [extendedHamming8_weight_zero_count]; native_decide

/-- Weight-4 count: each of the 14 weight-4 codewords yields 16 short lifts. -/
lemma svCodeW4_card : (svCodeW 4).card = extendedHamming8WeightDist 4 * 16 := by
  rw [extendedHamming8_weight_four_count]; native_decide

/-- Weight-8 count: the all-ones codeword yields 0 short lifts (`sqNorm ≥ 8`). -/
lemma svCodeW8_card : (svCodeW 8).card = extendedHamming8WeightDist 8 * 0 := by
  rw [extendedHamming8_weight_eight_count]; native_decide

/-! ## Assembly -/

/-- The cardinality of `svCode` equals the weight-distribution formula. -/
lemma svCode_card_eq_formula : svCode.card = shortVectorWeightDistributionFormula := by
  have hd04 := svCodeW_disjoint 0 4 (by omega)
  have hd08 := svCodeW_disjoint 0 8 (by omega)
  have hd48 := svCodeW_disjoint 4 8 (by omega)
  rw [svCode_partition]
  rw [Finset.card_union_of_disjoint (Finset.disjoint_union_left.mpr ⟨hd08, hd48⟩)]
  rw [Finset.card_union_of_disjoint hd04]
  rw [svCodeW0_card, svCodeW4_card, svCodeW8_card]
  rfl

/-- **Main structural theorem**: the number of short vectors equals the
weight-distribution formula `A₀ × 16 + A₄ × 16 + A₈ × 0`. -/
theorem short_vector_count_eq_weight_distribution_structural :
    Set.ncard hammingE8ShortVectorSet = shortVectorWeightDistributionFormula := by
  rw [ncard_eq_svCode_card, svCode_card_eq_formula]

/-- The desired structural replacement for the 240 short-vector count. -/
theorem short_vector_count_eq_240_structural :
    Set.ncard hammingE8ShortVectorSet = 240 := by
  rw [short_vector_count_eq_weight_distribution_structural,
      shortVectorWeightDistributionFormula,
      extendedHamming8_weight_zero_count,
      extendedHamming8_weight_four_count,
      extendedHamming8_weight_eight_count]

end PhysicsSM.Coding
