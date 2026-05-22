import CodeLatticeE8.Code.Hamming844
import CodeLatticeE8.Code.Hamming844Permutation
import CodeLatticeE8.Code.Hamming844Systematic

/-!
# Uniqueness of the binary extended Hamming `[8,4,4]` code

This module gives the clean publication theorem that every binary linear
`[8,4,4]` code is equivalent, under coordinate permutation, to the concrete
extended Hamming code.

The proof follows the standard coding-theory outline:

1. find an information set of size four;
2. permute it to the first four coordinates;
3. put the code in systematic form `[I_4 | P]`;
4. classify such systematic forms structurally;
5. compose the coordinate equivalences.

The proof is structural throughout.  The coordinate-normalization and
systematic-code classification steps are proved in `Hamming844Permutation`
and `Hamming844Systematic`.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.Code

/-! ## Information sets -/

/-- A set of coordinates is an information set if no nonzero codeword vanishes
on all those coordinates. -/
def IsInfoSet {n : ℕ} (C : BinaryLinearCode n) (I : Finset (Fin n)) : Prop :=
  ∀ v ∈ C, (∀ i ∈ I, v i = 0) → v = 0

set_option linter.flexible false in
/-- Every binary `[8,4,4]` code has an information set of size four. -/
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
  have h_char : ∀ I : Finset (Fin 8), I.card = 4 →
      v I = fun i => if i ∈ I then 0 else 1 := by
    intros I hI_card
    have h_char : ∀ i, v I i = if i ∈ I then 0 else 1 := by
      intro i
      split_ifs <;> simp_all +decide [hammingWeight]
      have := Finset.eq_of_subset_of_card_le
        (show Finset.filter (fun j => ¬ v I j = 0) Finset.univ ⊆ Finset.univ \ I from
          fun x hx => by aesop)
      simp_all +decide [Finset.card_sdiff]
      replace this := Finset.ext_iff.mp this i
      simp_all +decide [Finset.mem_sdiff]
      exact Or.resolve_left (Fin.exists_fin_two.mp (by aesop)) this
    exact funext h_char
  have h_complement_indicators :
      ∀ I : Finset (Fin 8), I.card = 4 →
      (fun i => if i ∈ I then 0 else 1) ∈ C :=
    fun I hI => h_char I hI ▸ hv₁ I hI
  have h_indicators :
      ∀ I : Finset (Fin 8), I.card = 4 →
      (fun i => if i ∈ I then 1 else 0) ∈ C := by
    intro I hI
    convert h_complement_indicators (Finset.univ \ I)
      (by simp +decide [Finset.card_sdiff, *]) using 1
    ext i
    by_cases hi : i ∈ I <;> simp +decide [hi]
  have h_pair :
      (fun i => if i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 3 then 1 else 0) ∈ C ∧
      (fun i => if i = 0 ∨ i = 1 ∨ i = 2 ∨ i = 4 then 1 else 0) ∈ C :=
    ⟨by simpa using h_indicators {0, 1, 2, 3} rfl,
     by simpa using h_indicators {0, 1, 2, 4} rfl⟩
  have hsum := C.add_mem h_pair.1 h_pair.2
  simp +decide at hsum
  exact absurd (hC₂ _ hsum (by decide)) (by decide)

set_option linter.flexible false in
/-- Coordinate permutation carries information sets to information sets. -/
theorem isInfoSet_permuteCode (C : BinaryLinearCode 8) (sigma : Equiv.Perm (Fin 8))
    (I : Finset (Fin 8)) (hI : IsInfoSet C I) :
    IsInfoSet (permuteCode sigma C) (I.image sigma) := by
  intro v hv
  simp_all +decide [IsInfoSet, mem_permuteCode_iff]
  intro hv'
  specialize hI _ hv
  simp_all +decide [permuteBinaryVector]
  exact funext fun x => by simpa using congr_fun hI (sigma.symm x)

/-! ## Information sets give systematic form -/

set_option linter.flexible false in
set_option linter.unusedSimpArgs false in
set_option linter.style.refine false in
set_option linter.style.multiGoal false in
/-- A code with information set `{0,1,2,3}` is equal to a systematic code. -/
theorem code_eq_systematic_of_inj_proj
    (C : BinaryLinearCode 8)
    (hC : IsLinearCode C 4 4)
    (hinj : IsInfoSet C {0, 1, 2, 3}) :
    ∃ P : Matrix (Fin 4) (Fin 4) (ZMod 2),
      C = systematicSubmodule P ∧
      ∀ c : Fin 4 → ZMod 2, c ≠ 0 → 4 ≤ hammingWeight (systematicCW P c) := by
  obtain ⟨g, hg⟩ : ∃ g : Fin 4 → BinaryVector 8,
      (∀ i, g i ∈ C) ∧ (∀ i, projFirst4 (g i) = Pi.single i 1) := by
    have h_basis : ∀ (v : Fin 4 → ZMod 2), ∃ w ∈ C, projFirst4 w = v := by
      have h_basis : LinearMap.range (projFirst4.comp (Submodule.subtype C)) = ⊤ := by
        refine' Submodule.eq_top_of_finrank_eq _
        rw [LinearMap.finrank_range_of_inj]
        · exact hC.dim_eq.trans (by norm_num)
        · intro v w h
          specialize hinj (v - w)
          simp_all +decide [sub_eq_zero]
          exact hinj (C.sub_mem v.2 w.2)
            (by simpa using congr_fun h 0) (by simpa using congr_fun h 1)
            (by simpa using congr_fun h 2) (by simpa using congr_fun h 3)
      intro v
      replace h_basis := SetLike.ext_iff.mp h_basis v
      aesop
    exact ⟨fun i => Classical.choose (h_basis (Pi.single i 1)),
      fun i => Classical.choose_spec (h_basis (Pi.single i 1)) |>.1,
      fun i => Classical.choose_spec (h_basis (Pi.single i 1)) |>.2⟩
  obtain ⟨P, hP⟩ : ∃ P : Matrix (Fin 4) (Fin 4) (ZMod 2),
      ∀ i, g i = mkSystematicRow P i := by
    use fun i j => g i ⟨j.val + 4, by omega⟩
    intro i
    ext j
    by_cases hj : j.val < 4 <;>
      simp_all +decide [Fin.ext_iff, mkSystematicRow]
    convert congr_fun (hg.2 i) ⟨j, hj⟩ using 1
    fin_cases j <;> fin_cases i <;> rfl
  refine' ⟨P, _, _⟩
  · refine' le_antisymm _ _
    · intro v hv
      obtain ⟨c, hc⟩ : ∃ c : Fin 4 → ZMod 2, v = ∑ i, c i • g i := by
        have h_span : ∀ v ∈ C, ∃ c : Fin 4 → ZMod 2, v = ∑ i, c i • g i := by
          intro v hv
          have h_proj_eq : projFirst4 (v - ∑ i, (projFirst4 v i) • g i) = 0 := by
            simp +decide [hg.2, projFirst4]
            ext i
            simp +decide [Fin.sum_univ_four, hP]
            fin_cases i <;> simp +decide [mkSystematicRow]
          have h_zero : v - ∑ i, (projFirst4 v i) • g i = 0 := by
            apply hinj
            · exact C.sub_mem hv (C.sum_mem fun i _ => C.smul_mem _ (hg.1 i))
            · exact fun i hi => by
                simpa using congr_fun h_proj_eq ⟨i, by fin_cases hi <;> trivial⟩
          exact ⟨_, eq_of_sub_eq_zero h_zero⟩
        exact h_span v hv
      use c
      ext j
      simp +decide [hc, hP, systematicCWLinear, systematicCW]
    · intro v hv
      obtain ⟨c, rfl⟩ := mem_systematicSubmodule P v |>.1 hv
      simp_all +decide [Fin.sum_univ_four]
      convert C.sum_mem fun i _ => C.smul_mem (c i) (hg.1 i) using 1
      swap
      exact Finset.univ
      ext j
      simp +decide [systematicCW, Finset.sum_apply, Pi.smul_apply]
  · intro c hc
    convert hC.min_dist (∑ i, c i • g i) _ _ using 1
    · congr! 1
      ext j
      simp +decide [hP, systematicCW]
    · exact Submodule.sum_mem _ fun i _ => Submodule.smul_mem _ _ (hg.1 i)
    · contrapose! hc
      ext i
      replace hc := congr_arg (fun v => projFirst4 v i) hc
      simp_all +decide [Finset.sum_apply, Pi.single_apply]

/-- Systematic `[8,4,4]` codes are equivalent to the extended Hamming code. -/
theorem systematic_codeEquiv_hamming
    (P : Matrix (Fin 4) (Fin 4) (ZMod 2))
    (hmin : forall c : Fin 4 → ZMod 2,
      c ≠ 0 → 4 ≤ hammingWeight (systematicCW P c)) :
    CodeEquivalent (systematicSubmodule P) extendedHamming8 := by
  obtain ⟨sigma, hsigma⟩ := systematic_844_classification P hmin
  refine ⟨sigma, ?_⟩
  ext v
  rw [show (v ∈ permuteCode sigma (systematicSubmodule P)) ↔
      (v ∈ (systematicCodeFinset P).image (permuteBinaryVector sigma)) from
      (mem_image_permute_systematicCodeFinset P sigma v).symm]
  rw [hsigma, mem_extendedHamming8Finset_iff]

/--
Every binary linear `[8,4,4]` code is coordinate-equivalent to the concrete
extended Hamming code.
-/
theorem extendedHamming8_unique_up_to_equivalence
    (C : BinaryLinearCode 8) (hC : IsLinearCode C 4 4) :
    CodeEquivalent C extendedHamming8 := by
  obtain ⟨I, hI_card, hI_info⟩ := info_set_exists C hC
  obtain ⟨sigma1, hsigma1⟩ := exists_perm_to_first4 I hI_card
  have hC1 : IsLinearCode (permuteCode sigma1 C) 4 4 :=
    CodeEquivalent.isLinearCode ⟨sigma1, rfl⟩ hC
  have hinfo1 : IsInfoSet (permuteCode sigma1 C) {0, 1, 2, 3} := by
    rw [← hsigma1]
    exact isInfoSet_permuteCode C sigma1 I hI_info
  obtain ⟨P, hP_eq, hP_min⟩ :=
    code_eq_systematic_of_inj_proj (permuteCode sigma1 C) hC1 hinfo1
  have hequiv1 : CodeEquivalent C (permuteCode sigma1 C) := ⟨sigma1, rfl⟩
  have hequiv2 : CodeEquivalent (permuteCode sigma1 C) (systematicSubmodule P) :=
    ⟨1, by rw [permuteCode_one]; exact hP_eq⟩
  exact (hequiv1.trans hequiv2).trans
    (systematic_codeEquiv_hamming P hP_min)

end CodeLatticeE8.Code
