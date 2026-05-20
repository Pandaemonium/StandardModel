import CodeLatticeE8.Code.Equivalence
import CodeLatticeE8.Code.Hamming844Basic

/-!
# Structural classification of systematic `[8,4,4]` binary codes

This module contains the systematic-code classification used in the Hamming
uniqueness theorem.

For a systematic generator matrix `[I_4 | P]`, the minimum-distance condition
forces each row of the parity block `P` to be one of the four weight-three
vectors in `F_2^4`, with the four rows occurring in some order.  A permutation
of the last four coordinates then carries the systematic code to the canonical
extended Hamming code.

The argument is structural: it uses the minimum-distance hypothesis to force
the parity rows of `P`, then identifies the resulting code by a coordinate
permutation.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace CodeLatticeE8.Code

/-! ## Systematic generator matrices -/

/-- The `i`-th row of the systematic generator matrix `[I_4 | P]`.

The first four coordinates are the standard basis row `e_i`; the last four are
the row `P i` of the parity block.
-/
def mkSystematicRow (P : Matrix (Fin 4) (Fin 4) (ZMod 2)) (i : Fin 4) :
    BinaryVector 8 := fun j =>
  if h : j.val < 4 then
    (if (⟨j.val, h⟩ : Fin 4) = i then 1 else 0)
  else
    P i ⟨j.val - 4, by omega⟩

/-- A codeword of the systematic code `[I_4 | P]` with message `c`. -/
def systematicCW (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (c : Fin 4 → ZMod 2) : BinaryVector 8 :=
  fun j => ∑ i : Fin 4, c i * mkSystematicRow P i j

/-- The systematic code `[I_4 | P]` as a finite set of binary vectors. -/
def systematicCodeFinset (P : Matrix (Fin 4) (Fin 4) (ZMod 2)) :
    Finset (BinaryVector 8) :=
  Finset.univ.image (systematicCW P)

/-- `systematicCW P` as a linear map from message space to codeword space. -/
def systematicCWLinear (P : Matrix (Fin 4) (Fin 4) (ZMod 2)) :
    (Fin 4 → ZMod 2) →ₗ[ZMod 2] BinaryVector 8 where
  toFun := systematicCW P
  map_add' := by
    intro a b
    ext j
    simp [systematicCW, add_mul, Finset.sum_add_distrib]
  map_smul' := by
    intro c v
    ext j
    simp [systematicCW, Pi.smul_apply, smul_eq_mul, Finset.mul_sum, mul_assoc]

/-- The systematic code `[I_4 | P]` as a binary linear code. -/
def systematicSubmodule (P : Matrix (Fin 4) (Fin 4) (ZMod 2)) :
    BinaryLinearCode 8 :=
  LinearMap.range (systematicCWLinear P)

/-- Projection to the first four coordinates. -/
def projFirst4 : BinaryVector 8 →ₗ[ZMod 2] (Fin 4 → ZMod 2) where
  toFun v := fun i => v ⟨i.val, by omega⟩
  map_add' := by intro a b; ext i; simp [Pi.add_apply]
  map_smul' := by intro c v; ext i; simp [Pi.smul_apply]

/-- Projection recovers the message of a systematic codeword. -/
theorem projFirst4_systematicCW (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (c : Fin 4 → ZMod 2) :
    projFirst4 (systematicCW P c) = c := by
  unfold projFirst4 systematicCW
  ext i
  simp +decide [mkSystematicRow]

/-- The systematic encoding map is injective. -/
theorem systematicCW_injective (P : Matrix (Fin 4) (Fin 4) (ZMod 2)) :
    Function.Injective (systematicCW P) := by
  intro a b h
  have := congr_arg projFirst4 h
  rwa [projFirst4_systematicCW, projFirst4_systematicCW] at this

/-- Membership in the systematic submodule. -/
theorem mem_systematicSubmodule (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (v : BinaryVector 8) :
    v ∈ systematicSubmodule P ↔ ∃ c, systematicCW P c = v := by
  simp [systematicSubmodule, LinearMap.mem_range, systematicCWLinear]

/-- Finset/submodule bridge for systematic codes. -/
theorem mem_systematicCodeFinset_iff (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (v : BinaryVector 8) :
    v ∈ systematicCodeFinset P ↔ v ∈ systematicSubmodule P := by
  simp [systematicCodeFinset, Finset.mem_image, mem_systematicSubmodule]

/-- Permuting vectors in the systematic finite set matches `permuteCode`. -/
theorem mem_image_permute_systematicCodeFinset
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (sigma : Equiv.Perm (Fin 8)) (v : BinaryVector 8) :
    v ∈ (systematicCodeFinset P).image (permuteBinaryVector sigma) ↔
    v ∈ permuteCode sigma (systematicSubmodule P) := by
  rw [mem_permuteCode_iff]
  constructor
  · intro hv
    rcases Finset.mem_image.mp hv with ⟨w, hw, hσw⟩
    rw [mem_systematicCodeFinset_iff] at hw
    rw [← hσw]
    simpa using hw
  · intro hv
    rw [← mem_systematicCodeFinset_iff] at hv
    exact Finset.mem_image.mpr ⟨permuteBinaryVector sigma.symm v, hv, by simp⟩

/-- The parity block row `i` of a systematic generator matrix `[I_4 | P]`. -/
abbrev systematicParityRow (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (i : Fin 4) : BinaryVector 4 :=
  fun j => P i j

/-- The weight-three vector with the unique zero at coordinate `a`. -/
abbrev complementSingleZero (a : Fin 4) : BinaryVector 4 :=
  fun j => if j = a then 0 else 1

/-! ## Standard basis in `F_2^4` -/

/-- The standard basis vector in `Fin 4 -> ZMod 2`. -/
def stdBasis4 (i : Fin 4) : Fin 4 → ZMod 2 :=
  fun j => if j = i then 1 else 0

theorem stdBasis4_ne_zero (i : Fin 4) : stdBasis4 i ≠ 0 := by
  intro h
  have := congr_fun h i
  simp [stdBasis4] at this

theorem stdBasis4_pair_ne_zero (i j : Fin 4) (hij : i ≠ j) :
    stdBasis4 i + stdBasis4 j ≠ 0 := by
  intro h
  have := congr_fun h i
  simp [stdBasis4, hij] at this

/-! ## Single-bit and two-bit systematic codewords -/

/-- A standard-basis message produces the corresponding systematic row. -/
theorem systematicCW_stdBasis (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (i : Fin 4) :
    systematicCW P (stdBasis4 i) = mkSystematicRow P i := by
  ext j
  simp [systematicCW, stdBasis4]

/-- The Hamming weight of a vector in `Fin n -> ZMod 2` is at most `n`. -/
theorem hammingWeight_le (v : BinaryVector n) : hammingWeight v ≤ n := by
  unfold hammingWeight
  calc Finset.card (Finset.filter (fun i => v i ≠ 0) Finset.univ)
      ≤ Finset.card Finset.univ := Finset.card_filter_le _ _
    _ = n := Finset.card_fin n

/-- `mkSystematicRow` on the low positions. -/
private theorem mkSystematicRow_castAdd (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (i j : Fin 4) :
    mkSystematicRow P i (Fin.castAdd 4 j) = if j = i then 1 else 0 := by
  simp [mkSystematicRow, Fin.castAdd, Fin.ext_iff]

/-- `mkSystematicRow` on the high positions. -/
private theorem mkSystematicRow_natAdd (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (i j : Fin 4) :
    mkSystematicRow P i (Fin.natAdd 4 j) = P i j := by
  simp [mkSystematicRow, Fin.natAdd]

/-- The weight of a systematic row is `1 +` the weight of its parity row. -/
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

/-- The codeword for `e_i + e_j` is the sum of rows `i` and `j`. -/
theorem systematicCW_pair (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (i j : Fin 4) :
    systematicCW P (stdBasis4 i + stdBasis4 j) =
      mkSystematicRow P i + mkSystematicRow P j := by
  ext k
  simp only [systematicCW, stdBasis4, Pi.add_apply, add_mul, Finset.sum_add_distrib]
  simp only [mkSystematicRow]
  split <;> simp

/-- The low part of the pair-weight sum equals two when `i ≠ j`. -/
private theorem lo_pair_count (i j : Fin 4) (hij : i ≠ j) :
    (∑ x : Fin 4,
      if ((if x = i then (1 : ZMod 2) else 0) + if x = j then 1 else 0) ≠ 0
      then (1 : ℕ) else 0) = 2 := by
  decide +revert

/-- The weight of the sum of two systematic rows splits by the parity rows. -/
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

/-! ## Row constraints forced by minimum distance -/

/-- Every parity row has weight at least three. -/
theorem parityRow_weight_ge_three (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hmin : ∀ c : Fin 4 → ZMod 2, c ≠ 0 → 4 ≤ hammingWeight (systematicCW P c))
    (i : Fin 4) :
    3 ≤ hammingWeight (systematicParityRow P i) := by
  have h := hmin (stdBasis4 i) (stdBasis4_ne_zero i)
  rw [systematicCW_stdBasis, mkSystematicRow_weight] at h
  omega

/-- A weight-four vector plus any weight-at-least-three vector in `F_2^4`
has weight at most one. -/
theorem weight_four_sum_le_one (v w : BinaryVector 4)
    (hv : hammingWeight v = 4) (hw : 3 ≤ hammingWeight w) :
    hammingWeight (v + w) ≤ 1 := by
  decide +revert

/-- No parity row has weight four. -/
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

/-- Each parity row has Hamming weight exactly three. -/
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

/-! ## Classification of parity rows -/

/-- Every weight-three vector in `Fin 4 -> ZMod 2` is `complementSingleZero a`. -/
theorem weight_three_is_complement (v : BinaryVector 4)
    (hv : hammingWeight v = 3) :
    ∃ a : Fin 4, v = complementSingleZero a := by
  decide +revert

/-- Distinct systematic rows have distinct parity rows. -/
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

/-- The parity rows are the four complement vectors in some order. -/
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

/-! ## Permuting to the canonical Hamming systematic form -/

/-- A permutation on `Fin 8` that is identity on the first four coordinates and
`tau` on the last four coordinates. -/
def blockPerm (tau : Equiv.Perm (Fin 4)) : Equiv.Perm (Fin 8) :=
  finSumFinEquiv.symm.trans
    ((Equiv.sumCongr (Equiv.refl (Fin 4)) tau).trans finSumFinEquiv)

/-- The canonical parity matrix for the extended Hamming systematic form. -/
def canonicalP : Matrix (Fin 4) (Fin 4) (ZMod 2) :=
  fun i j => if j = i then 0 else 1

/-- The canonical systematic code equals the extended Hamming code. -/
theorem canonicalP_eq_hamming :
    systematicCodeFinset canonicalP = extendedHamming8Finset := by
  decide

/-- If `P` has complement rows indexed by `tau`, then parity-column permutation
by `tau` gives the canonical parity matrix. -/
theorem parity_permuted_eq_canonical (tau : Equiv.Perm (Fin 4))
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hP : ∀ i : Fin 4, systematicParityRow P i = complementSingleZero (tau i)) :
    ∀ i j : Fin 4, P i (tau j) = canonicalP i j := by
  intro i j
  have hrow := congr_fun (hP i) (tau j)
  simpa [systematicParityRow, complementSingleZero, canonicalP] using hrow

/-- Block-permuting a systematic codeword by `blockPerm tau.symm` permutes the
parity columns by `tau`. -/
theorem blockPerm_systematicCW (tau : Equiv.Perm (Fin 4))
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (c : Fin 4 → ZMod 2) :
    permuteBinaryVector (blockPerm tau.symm) (systematicCW P c) =
      systematicCW (fun i j => P i (tau j)) c := by
  ext jBinaryVector
  unfold permuteBinaryVector
  nontriviality
  unfold systematicCW
  unfold mkSystematicRow
  simp +decide only [mul_dite, mul_ite, mul_one, mul_zero,
    Finset.sum_dite_irrel, Finset.sum_ite_eq, Finset.mem_univ, ↓reduceIte,
    Function.comp_apply]
  unfold blockPerm
  simp +decide only [Nat.reduceAdd, Equiv.symm_trans_apply, Equiv.symm_symm,
    Equiv.sumCongr_symm, Equiv.refl_symm, Equiv.sumCongr_apply, Equiv.coe_refl]
  fin_cases jBinaryVector <;> simp +decide [finSumFinEquiv]
  all_goals simp +decide [Fin.addCases]

/-- If rows of `P` are complement vectors indexed by `tau`, then block
permuting the systematic code gives the extended Hamming code. -/
theorem systematic_code_perm_eq_hamming (tau : Equiv.Perm (Fin 4))
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hP : ∀ i : Fin 4, systematicParityRow P i = complementSingleZero (tau i)) :
    (systematicCodeFinset P).image (permuteBinaryVector (blockPerm tau.symm)) =
      extendedHamming8Finset := by
  have hP_canonical : ∀ i j : Fin 4, P i (tau j) = canonicalP i j :=
    parity_permuted_eq_canonical tau P hP
  have h_permuted_code :
      (systematicCodeFinset P).image (permuteBinaryVector (blockPerm tau.symm)) =
        systematicCodeFinset (fun i j => P i (tau j)) := by
    ext v
    simp [systematicCodeFinset, blockPerm_systematicCW]
  exact h_permuted_code.trans (by
    rw [show (fun i j => P i (tau j)) = canonicalP from
      funext fun i => funext fun j => hP_canonical i j]
    exact canonicalP_eq_hamming)

/-- Structural classification of systematic binary `[8,4,4]` codes. -/
theorem systematic_844_classification
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hmin : ∀ c : Fin 4 → ZMod 2,
      c ≠ 0 → 4 ≤ hammingWeight (systematicCW P c)) :
    ∃ sigma : Equiv.Perm (Fin 8),
      (systematicCodeFinset P).image (permuteBinaryVector sigma) =
        extendedHamming8Finset := by
  obtain ⟨tau, htau⟩ := systematic_min_distance_forces_complement_rows P hmin
  exact ⟨blockPerm tau.symm, systematic_code_perm_eq_hamming tau P htau⟩

end CodeLatticeE8.Code
