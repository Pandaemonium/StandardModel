import Mathlib
import PhysicsSM.Coding.Hamming844Classification

/-!
# Aristotle target: structural `[8,4,4]` systematic classification

This file isolates the main finite classification currently proved by
`native_decide` in `PhysicsSM.Coding.Hamming844Classification`.

For a systematic generator matrix `[I_4 | P]`, the minimum-distance condition
forces the rows of `P` to be exactly the four weight-three vectors in `F_2^4`,
up to a permutation of the last four coordinates.

Please do not use `systematic_844_classification` or `native_decide` as proof
ingredients.
-/

set_option linter.style.longLine false

namespace PhysicsSM.Coding

/-- The parity block row `i` of a systematic generator matrix `[I_4 | P]`. -/
abbrev systematicParityRow (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (i : Fin 4) : BinaryVector 4 :=
  fun j => P i j

/-- The weight-three vector with the unique zero at coordinate `a`. -/
abbrev complementSingleZero (a : Fin 4) : BinaryVector 4 :=
  fun j => if j = a then 0 else 1

/-! ## Standard basis in F₂⁴ -/

/-- The standard basis vector in `Fin 4 → ZMod 2`. -/
def stdBasis4 (i : Fin 4) : Fin 4 → ZMod 2 :=
  fun j => if j = i then 1 else 0

theorem stdBasis4_ne_zero (i : Fin 4) : stdBasis4 i ≠ 0 := by
  intro h; have := congr_fun h i; simp [stdBasis4] at this

theorem stdBasis4_pair_ne_zero (i j : Fin 4) (hij : i ≠ j) :
    stdBasis4 i + stdBasis4 j ≠ 0 := by
  intro h; have := congr_fun h i; simp [stdBasis4, hij] at this

/-! ## Key identity: single-bit codeword = systematic row -/

/-- For a standard basis message `e_i`, the codeword equals the i-th row
of the systematic generator matrix. -/
theorem systematicCW_stdBasis (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (i : Fin 4) :
    systematicCW P (stdBasis4 i) = mkSystematicRow P i := by
  ext j; simp [systematicCW, stdBasis4]

/-- The Hamming weight of a vector in `Fin n → ZMod 2` is at most `n`. -/
theorem hammingWeight_le (v : BinaryVector n) : hammingWeight v ≤ n := by
  unfold hammingWeight
  calc Finset.card (Finset.filter (fun i => v i ≠ 0) Finset.univ)
      ≤ Finset.card Finset.univ := Finset.card_filter_le _ _
    _ = n := Finset.card_fin n

/-! ## Weight decomposition via Fin.sum_univ_add -/

/-- `mkSystematicRow` on the low positions (first 4 coordinates). -/
private theorem mkSystematicRow_castAdd (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (i j : Fin 4) :
    mkSystematicRow P i (Fin.castAdd 4 j) = if j = i then 1 else 0 := by
  simp [mkSystematicRow, Fin.castAdd, Fin.ext_iff]

/-- `mkSystematicRow` on the high positions (last 4 coordinates). -/
private theorem mkSystematicRow_natAdd (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (i j : Fin 4) :
    mkSystematicRow P i (Fin.natAdd 4 j) = P i j := by
  simp [mkSystematicRow, Fin.natAdd]

/-- The weight of `mkSystematicRow P i` equals
`1 + hammingWeight (systematicParityRow P i)`.

Proof: split `Fin 8 = Fin 4 + Fin 4` via `Fin.sum_univ_add`. On the first 4,
exactly position `i` is nonzero (contributing 1). On the last 4, each position
matches the parity row.
-/
theorem mkSystematicRow_weight (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (i : Fin 4) :
    hammingWeight (mkSystematicRow P i) =
      1 + hammingWeight (systematicParityRow P i) := by
  simp only [hammingWeight, Finset.card_filter]
  change ∑ j : Fin (4 + 4), _ = 1 + ∑ j : Fin 4, _
  rw [Fin.sum_univ_add]
  simp only [mkSystematicRow_castAdd, mkSystematicRow_natAdd]
  congr 1
  simp [Finset.sum_ite_eq', Finset.mem_univ]

/-! ## Two-bit codeword weight -/

/-- The codeword for `e_i + e_j` equals the sum of the two systematic rows. -/
theorem systematicCW_pair (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (i j : Fin 4) :
    systematicCW P (stdBasis4 i + stdBasis4 j) =
      mkSystematicRow P i + mkSystematicRow P j := by
  ext k; simp only [systematicCW, stdBasis4, Pi.add_apply, add_mul, Finset.sum_add_distrib]
  simp only [mkSystematicRow]; split <;> simp [Fin.sum_univ_four] <;> ring

/-- Helper: the lo part of the pair weight sum equals 2 when i ≠ j. -/
private theorem lo_pair_count (i j : Fin 4) (hij : i ≠ j) :
    (∑ x : Fin 4, if ((if x = i then (1 : ZMod 2) else 0) + if x = j then 1 else 0) ≠ 0
      then (1 : ℕ) else 0) = 2 := by
  fin_cases i <;> fin_cases j <;> simp_all <;> decide

/-- The weight of `mkSystematicRow P i + mkSystematicRow P j` for `i ≠ j`
equals `2 + hammingWeight (row_i + row_j)`. -/
theorem mkSystematicRow_pair_weight (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (i j : Fin 4) (hij : i ≠ j) :
    hammingWeight (mkSystematicRow P i + mkSystematicRow P j) =
      2 + hammingWeight (fun k : Fin 4 => P i k + P j k) := by
  simp only [hammingWeight, Finset.card_filter]
  change ∑ k : Fin (4 + 4), _ = 2 + ∑ k : Fin 4, _
  rw [Fin.sum_univ_add]
  simp only [Pi.add_apply, mkSystematicRow_castAdd, mkSystematicRow_natAdd]
  congr 1
  exact lo_pair_count i j hij

/-! ## Row weight constraints -/

/-- Every parity row has weight at least 3, from the single-bit codeword constraint. -/
theorem parityRow_weight_ge_three (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hmin : ∀ c : Fin 4 → ZMod 2, c ≠ 0 → 4 ≤ hammingWeight (systematicCW P c))
    (i : Fin 4) :
    3 ≤ hammingWeight (systematicParityRow P i) := by
  have h := hmin (stdBasis4 i) (stdBasis4_ne_zero i)
  rw [systematicCW_stdBasis, mkSystematicRow_weight] at h
  omega

/-- The sum of a weight-4 vector with any weight-≥3 vector in F₂⁴ has weight ≤ 1. -/
theorem weight_four_sum_le_one (v w : BinaryVector 4)
    (hv : hammingWeight v = 4) (hw : 3 ≤ hammingWeight w) :
    hammingWeight (v + w) ≤ 1 := by
  decide +revert

/-- No parity row has weight 4. -/
theorem parityRow_weight_ne_four (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hmin : ∀ c : Fin 4 → ZMod 2, c ≠ 0 → 4 ≤ hammingWeight (systematicCW P c))
    (i : Fin 4) :
    hammingWeight (systematicParityRow P i) ≠ 4 := by
  intro hfour
  have ⟨j, hji⟩ : ∃ j : Fin 4, j ≠ i := by
    fin_cases i
    · exact ⟨1, by decide⟩
    · exact ⟨0, by decide⟩
    · exact ⟨0, by decide⟩
    · exact ⟨0, by decide⟩
  have hpair := hmin (stdBasis4 i + stdBasis4 j) (stdBasis4_pair_ne_zero i j hji.symm)
  rw [systematicCW_pair, mkSystematicRow_pair_weight P i j hji.symm] at hpair
  have hge_j := parityRow_weight_ge_three P hmin j
  have hsum_le : hammingWeight (fun k : Fin 4 => P i k + P j k) ≤ 1 :=
    weight_four_sum_le_one (systematicParityRow P i) (systematicParityRow P j) hfour hge_j
  omega

/-- Each parity row must have Hamming weight exactly three. -/
theorem systematic_min_distance_forces_row_weight_three
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hmin : ∀ c : Fin 4 → ZMod 2,
      c ≠ 0 → 4 ≤ hammingWeight (systematicCW P c))
    (i : Fin 4) :
    hammingWeight (systematicParityRow P i) = 3 := by
  have hge := parityRow_weight_ge_three P hmin i
  have hne := parityRow_weight_ne_four P hmin i
  have hle := hammingWeight_le (systematicParityRow P i)
  omega

/-! ## Classification of weight-3 vectors in F₂⁴ -/

/-- Every weight-3 vector in `Fin 4 → ZMod 2` is `complementSingleZero a`. -/
theorem weight_three_is_complement (v : BinaryVector 4)
    (hv : hammingWeight v = 3) :
    ∃ a : Fin 4, v = complementSingleZero a := by
  decide +revert

/-- Distinct parity rows. -/
theorem parityRows_distinct (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hmin : ∀ c : Fin 4 → ZMod 2, c ≠ 0 → 4 ≤ hammingWeight (systematicCW P c))
    (i j : Fin 4) (hij : i ≠ j) :
    systematicParityRow P i ≠ systematicParityRow P j := by
  intro heq
  have hpair := hmin (stdBasis4 i + stdBasis4 j) (stdBasis4_pair_ne_zero i j hij)
  rw [systematicCW_pair, mkSystematicRow_pair_weight P i j hij] at hpair
  have hzero : (fun k : Fin 4 => P i k + P j k) = 0 := by
    ext k
    have : P i k = P j k := congr_fun heq k
    simp [this, CharTwo.add_self_eq_zero]
  rw [hzero] at hpair
  simp [hammingWeight] at hpair

/-! ## Main structural classification -/

/--
The structural core: parity rows are the four complement vectors in some order.
-/
theorem systematic_min_distance_forces_complement_rows
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hmin : ∀ c : Fin 4 → ZMod 2,
      c ≠ 0 → 4 ≤ hammingWeight (systematicCW P c)) :
    ∃ tau : Equiv.Perm (Fin 4),
      ∀ i : Fin 4, systematicParityRow P i = complementSingleZero (tau i) := by
  have hwt : ∀ i, hammingWeight (systematicParityRow P i) = 3 :=
    systematic_min_distance_forces_row_weight_three P hmin
  have hcompl : ∀ i, ∃ a, systematicParityRow P i = complementSingleZero a :=
    fun i => weight_three_is_complement _ (hwt i)
  choose tau htau using hcompl
  have htau_inj : Function.Injective tau := by
    intro a b hab
    by_contra hne
    exact parityRows_distinct P hmin a b hne (by rw [htau a, htau b, hab])
  exact ⟨Equiv.ofBijective tau ⟨htau_inj, Finite.surjective_of_injective htau_inj⟩,
    fun i => by simp [htau i, Equiv.ofBijective_apply]⟩

/-- A permutation on Fin 8 that is identity on first 4 coords and `tau` on last 4. -/
def blockPerm (tau : Equiv.Perm (Fin 4)) : Equiv.Perm (Fin 8) :=
  finSumFinEquiv.symm.trans
    ((Equiv.sumCongr (Equiv.refl (Fin 4)) tau).trans finSumFinEquiv)

/-- The canonical parity matrix: `canonicalP i j = if j = i then 0 else 1`. -/
def canonicalP : Matrix (Fin 4) (Fin 4) (ZMod 2) :=
  fun i j => if j = i then 0 else 1

/-- The canonical systematic code equals the extended Hamming code. -/
theorem canonicalP_eq_hamming :
    systematicCodeFinset canonicalP = extendedHamming8Finset := by
  decide

/-
If `P i j = complementSingleZero (tau i) j` then permuting columns by `tau`
gives the canonical parity matrix.
-/
theorem parity_permuted_eq_canonical (tau : Equiv.Perm (Fin 4))
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hP : ∀ i : Fin 4, systematicParityRow P i = complementSingleZero (tau i)) :
    ∀ i j : Fin 4, P i (tau j) = canonicalP i j := by
  simp_all +decide [ funext_iff, Fin.forall_fin_succ ];
  fin_cases tau <;> simp +decide [ systematicParityRow, complementSingleZero ] at hP ⊢;
  all_goals simp +decide [ hP, Equiv.swap_apply_def ] ;

/-
Block-permuting a systematic codeword by `blockPerm tau.symm` permutes the
parity columns by `tau`.
-/
theorem blockPerm_systematicCW (tau : Equiv.Perm (Fin 4))
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (c : Fin 4 → ZMod 2) :
    permuteBinaryVector (blockPerm tau.symm) (systematicCW P c) =
      systematicCW (fun i j => P i (tau j)) c := by
  ext jBinaryVector blockPerm systematicCW;
  unfold permuteBinaryVector;
  nontriviality;
  unfold systematicCW;
  unfold mkSystematicRow; simp +decide [ Finset.sum_ite ] ;
  unfold blockPerm; simp +decide [ Equiv.symm_apply_eq ] ;
  fin_cases jBinaryVector <;> simp +decide [ finSumFinEquiv ];
  all_goals simp +decide [ Fin.addCases ]

/-
If rows of P are complement vectors indexed by tau, then
`systematicCodeFinset P` permuted by `blockPerm tau.symm` equals
`extendedHamming8Finset`.
-/
theorem systematic_code_perm_eq_hamming (tau : Equiv.Perm (Fin 4))
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hP : ∀ i : Fin 4, systematicParityRow P i = complementSingleZero (tau i)) :
    (systematicCodeFinset P).image (permuteBinaryVector (blockPerm tau.symm)) =
      extendedHamming8Finset := by
  have hP_canonical : ∀ i j : Fin 4, P i (tau j) = canonicalP i j :=
    parity_permuted_eq_canonical tau P hP
  have h_permuted_code : (systematicCodeFinset P).image (permuteBinaryVector (blockPerm tau.symm)) = systematicCodeFinset (fun i j => P i (tau j)) := by
    ext v
    simp [systematicCodeFinset, blockPerm_systematicCW];
  exact h_permuted_code.trans ( by rw [ show ( fun i j => P i ( tau j ) ) = canonicalP from funext fun i => funext fun j => hP_canonical i j ] ; exact canonicalP_eq_hamming )

/--
No-native replacement target for `systematic_844_classification`.
-/
theorem systematic_844_classification_structural
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hmin : ∀ c : Fin 4 → ZMod 2,
      c ≠ 0 → 4 ≤ hammingWeight (systematicCW P c)) :
    ∃ sigma : Equiv.Perm (Fin 8),
      (systematicCodeFinset P).image (permuteBinaryVector sigma) =
        extendedHamming8Finset := by
  obtain ⟨tau, htau⟩ := systematic_min_distance_forces_complement_rows P hmin
  exact ⟨blockPerm tau.symm, systematic_code_perm_eq_hamming tau P htau⟩

end PhysicsSM.Coding
