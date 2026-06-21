import PhysicsSM.Draft.E8ShortVectorsStructuralAristotle
import PhysicsSM.Draft.HammingWeightEnumeratorNoNativeAristotle

/-!
# Aristotle target: no-native structural short-vector count

This file targets the remaining `n a t i v e _ d e c i d e` pieces in
`PhysicsSM.Draft.E8ShortVectorsStructuralAristotle`.

The current structural draft already reduces the 240 short-vector count to
three weight-class counts.  Those three lemmas still use finite evaluation:

* `svCodeW0_card`;
* `svCodeW4_card`;
* `svCodeW8_card`.

The goal here is to prove replacement lemmas by direct structure:

* weight 0: exactly one nonzero even coordinate `+-2`, so `8 * 2 = 16`;
* weight 4: exactly the four odd support coordinates, each `+-1`, so `2^4`;
* weight 8: all coordinates odd, so `sqNorm >= 8`, impossible for `sqNorm = 4`.

The Hamming weight distribution may be supplied by the no-native replacement
theorems in `HammingWeightEnumeratorNoNativeAristotle`.
-/

set_option linter.style.longLine false
set_option linter.style.nativeDecide false

namespace PhysicsSM.Coding

/-! ## Weight 8: all coordinates odd, sqNorm ≥ 8 > 4, so no lifts -/

/-- The weight-8 class of the short-vector code is empty. -/
lemma svCodeW8_empty : svCodeW 8 = ∅ := by
  ext f
  simp [svCodeW]
  intro hf
  have h_sqNorm : sqNorm (decode5 f) = 4 :=
    (Finset.mem_filter.mp hf).2.2
  exact ne_of_lt (lt_of_le_of_lt
    (show hammingWeight (reduceModTwo (decode5 f)) ≤ 4 by
      exact_mod_cast h_sqNorm ▸ sqNorm_ge_weight (decode5 f))
    (by decide))

/-- No-native replacement for the weight-eight short-vector code count. -/
lemma svCodeW8_card_no_native :
    (svCodeW 8).card = extendedHamming8WeightDist 8 * 0 := by
  simp [svCodeW8_empty]

/-! ## Coordinate-level facts about shortValList encoding -/

lemma shortValList_even_iff (v : Fin 5) :
    ((shortValList v : ℤ) : ZMod 2) = 0 ↔ (v = 0 ∨ v = 2 ∨ v = 4) := by
  fin_cases v <;> simp +decide

lemma shortValList_odd_iff (v : Fin 5) :
    ((shortValList v : ℤ) : ZMod 2) ≠ 0 ↔ (v = 1 ∨ v = 3) := by
  fin_cases v <;> simp +decide

lemma shortValList_sq_even (v : Fin 5) (hv : v = 0 ∨ v = 2 ∨ v = 4) :
    (shortValList v : ℤ) ^ 2 = if v = 2 then 0 else 4 := by
  rcases hv with rfl | rfl | rfl <;> decide

lemma shortValList_sq_odd (v : Fin 5) (hv : v = 1 ∨ v = 3) :
    (shortValList v : ℤ) ^ 2 = 1 := by
  fin_cases v <;> trivial

/-! ## Weight 0: all coordinates even, one ±2 and rest 0 -/

/-- The encoding map for weight-0 lifts: position `i`, sign `s ∈ Fin 2`. -/
def w0Encode (p : Fin 8 × Fin 2) : Fin 8 → Fin 5 :=
  fun j => if j = p.1 then (if p.2 = 0 then (0 : Fin 5) else 4) else 2

lemma w0Encode_injective : Function.Injective w0Encode := by
  intro ⟨i₁, s₁⟩ ⟨i₂, s₂⟩ h
  have h1 := congr_fun h i₁
  simp only [w0Encode, ite_true] at h1
  by_cases hi : i₁ = i₂
  · subst hi; ext1; · rfl
    · fin_cases s₁ <;> fin_cases s₂ <;> simp_all
  · exfalso; simp only [hi, ite_false] at h1; fin_cases s₁ <;> simp_all

lemma w0Encode_mem_svCodeW0 (p : Fin 8 × Fin 2) : w0Encode p ∈ svCodeW 0 := by
  unfold svCodeW svCode isShortHammingE8Vector; simp +decide [w0Encode]
  fin_cases p <;> simp +decide [decode5, reduceModTwo, w0Encode]
  all_goals exact (by rw [mem_e8IntLattice_iff]; simp +decide [mem_extendedHamming8_iff])

lemma svCodeW0_coords_even (f : Fin 8 → Fin 5) (hf : f ∈ svCodeW 0)
    (i : Fin 8) : f i = 0 ∨ f i = 2 ∨ f i = 4 := by
  have h_even : ∀ i, (shortValList (f i) : ZMod 2) = 0 := by
    unfold svCodeW at hf; unfold hammingWeight at hf; aesop
  exact (shortValList_even_iff (f i)).mp (h_even i)

lemma svCodeW0_exactly_one_nonzero (f : Fin 8 → Fin 5) (hf : f ∈ svCodeW 0) :
    ∃! i : Fin 8, f i ≠ 2 := by
  -- By definition of $svCodeW$, we know that $sqNorm (decode5 f) = 4$.
  have h_sqNorm : sqNorm (decode5 f) = 4 := by
    exact Finset.mem_filter.mp hf |>.2 |> fun h => Finset.mem_filter.mp ( Finset.mem_filter.mp hf |>.1 ) |>.2 |> fun h' => h' |>.2;
  -- By definition of $sqNorm$, we know that $sqNorm (decode5 f) = \sum_{i=0}^{7} (decode5 f i)^2$.
  have h_sqNorm_def : sqNorm (decode5 f) = ∑ i, (if f i = 2 then 0 else 4) := by
    refine' Finset.sum_congr rfl fun i _ => _;
    convert shortValList_sq_even ( f i ) ( svCodeW0_coords_even f hf i ) using 1 ;
  simp_all +decide [ Finset.sum_ite ];
  exact?

lemma w0Encode_surj (f : Fin 8 → Fin 5) (hf : f ∈ svCodeW 0) :
    ∃ p : Fin 8 × Fin 2, w0Encode p = f := by
  -- By definition of $w0Encode$, there exists a unique $i$ such that $f i \neq 2$.
  obtain ⟨i, hi⟩ : ∃! i : Fin 8, f i ≠ 2 := by
    exact?;
  -- Since $f i \neq 2$ and $f i$ is even, we have $f i = 0$ or $f i = 4$.
  have h_f_i : f i = 0 ∨ f i = 4 := by
    have := svCodeW0_coords_even f hf i; aesop;
  cases' h_f_i with h h <;> [ refine' ⟨ ⟨ i, 0 ⟩, _ ⟩ ; refine' ⟨ ⟨ i, 1 ⟩, _ ⟩ ] <;> ext j <;> by_cases hj : j = i <;> simp_all +decide [ w0Encode ];
  · grind;
  · specialize hi j ; aesop

lemma svCodeW0_eq_image : svCodeW 0 = Finset.univ.image w0Encode := by
  ext f
  simp only [Finset.mem_image, Finset.mem_univ, true_and]
  exact ⟨fun hf => w0Encode_surj f hf, fun ⟨p, hp⟩ => hp ▸ w0Encode_mem_svCodeW0 p⟩

/-- No-native replacement for the weight-zero short-vector code count. -/
lemma svCodeW0_card_no_native :
    (svCodeW 0).card = extendedHamming8WeightDist 0 * 16 := by
  rw [extendedHamming8_weight_zero_count_no_native, one_mul,
    svCodeW0_eq_image, Finset.card_image_of_injective _ w0Encode_injective]
  decide

/-! ## Weight 4: structural helpers -/

/-- The sign-lift encoding for a weight-4 codeword. -/
def w4Lift (c : BinaryVector 8) (s : Fin 8 → Fin 2) : Fin 8 → Fin 5 :=
  fun i => if c i = 0 then 2 else (if s i = 0 then (1 : Fin 5) else 3)

/-
The mod-2 residue of decode5 of w4Lift c s equals c.
-/
lemma reduceModTwo_decode5_w4Lift (c : BinaryVector 8) (s : Fin 8 → Fin 2) :
    reduceModTwo (decode5 (w4Lift c s)) = c := by
  ext i
  change ((shortValList (if c i = 0 then 2 else if s i = 0 then 1 else 3) : ℤ) : ZMod 2) = c i
  have hc : c i = 0 ∨ c i = 1 := by rcases (c i) with ⟨v, hv⟩; interval_cases v <;> simp
  have hs : s i = 0 ∨ s i = 1 := by rcases (s i) with ⟨v, hv⟩; interval_cases v <;> simp
  rcases hc with hc | hc <;> rcases hs with hs | hs <;> simp_all [shortValList]

/-
The sqNorm of decode5 of w4Lift c s equals hammingWeight c (as ℤ).
-/
lemma sqNorm_decode5_w4Lift (c : BinaryVector 8) (s : Fin 8 → Fin 2) :
    sqNorm (decode5 (w4Lift c s)) = hammingWeight c := by
  simp only [sqNorm, decode5, w4Lift, hammingWeight]
  have h_term : ∀ i : Fin 8,
      (shortValList (if c i = 0 then (2 : Fin 5) else if s i = 0 then 1 else 3) : ℤ) ^ 2 =
      if c i = 0 then 0 else 1 := by
    intro i
    have hs : s i = 0 ∨ s i = 1 := by rcases (s i) with ⟨v, hv⟩; interval_cases v <;> simp
    by_cases hc : c i = 0 <;> rcases hs with hs | hs <;> simp_all [shortValList]
  simp_rw [h_term]
  simp [Finset.sum_ite, Finset.sum_const]

/-
f ∈ svCodeW 4 implies f is a w4Lift of its residue.
-/
lemma svCodeW4_is_w4Lift (f : Fin 8 → Fin 5) (hf : f ∈ svCodeW 4) :
    ∃ s : Fin 8 → Fin 2,
      f = w4Lift (reduceModTwo (decode5 f)) s := by
  refine' ⟨ fun i => if f i = 1 then 0 else 1, _ ⟩;
  ext i;
  have h_even_sq : ∑ i, (if (f i = 1 ∨ f i = 3) then 0 else (shortValList (f i) : ℤ) ^ 2) = 0 := by
    -- Since the sum of the squares of the odd coordinates is exactly 4, the sum of the squares of the even coordinates must be zero.
    have h_even_sq : ∑ i, (if (f i = 1 ∨ f i = 3) then 0 else (shortValList (f i) : ℤ) ^ 2) = 4 - ∑ i, (if (f i = 1 ∨ f i = 3) then (shortValList (f i) : ℤ) ^ 2 else 0) := by
      have h_even_sq : ∑ i, (shortValList (f i) : ℤ) ^ 2 = 4 := by
        have h_even_sq : isShortHammingE8Vector (decode5 f) := by
          exact Finset.mem_filter.mp ( Finset.mem_filter.mp hf |>.1 ) |>.2;
        convert h_even_sq.2 using 1;
      exact eq_tsub_of_add_eq ( by rw [ ← h_even_sq ] ; rw [ ← Finset.sum_add_distrib ] ; congr ; ext i ; aesop );
    have h_odd_sq : ∑ i, (if (f i = 1 ∨ f i = 3) then (shortValList (f i) : ℤ) ^ 2 else 0) = ∑ i ∈ Finset.univ.filter (fun i => (f i = 1 ∨ f i = 3)), 1 := by
      rw [ Finset.sum_filter ] ; congr ; ext i ; aesop;
    have h_card : Finset.card (Finset.univ.filter (fun i => (f i = 1 ∨ f i = 3))) = hammingWeight (reduceModTwo (decode5 f)) := by
      have h_card : ∀ i, (f i = 1 ∨ f i = 3) ↔ (reduceModTwo (decode5 f) i ≠ 0) := by
        grind +suggestions;
      exact congr_arg Finset.card ( Finset.ext fun x => by aesop );
    unfold svCodeW at hf; aesop;
  rw [ Finset.sum_eq_zero_iff_of_nonneg ] at h_even_sq <;> simp_all +decide [ Finset.sum_ite ];
  · by_cases hi1 : f i = 1 <;> by_cases hi3 : f i = 3 <;> simp_all +decide [ w4Lift ];
    · unfold decode5; simp +decide [ hi1 ] ;
    · unfold decode5; simp +decide [ hi3 ] ;
    · specialize h_even_sq i hi1 hi3; fin_cases i <;> simp_all +decide ;
      all_goals rcases h : f _ with ( _ | _ | _ | _ | _ | _ ) <;> simp_all +decide ;
  · exact fun i => by split_ifs <;> positivity;

/-- Two sign functions agreeing on supp(c) produce the same w4Lift. -/
lemma w4Lift_eq_of_agree_on_support (c : BinaryVector 8) (s₁ s₂ : Fin 8 → Fin 2)
    (h : ∀ i, c i ≠ 0 → s₁ i = s₂ i) :
    w4Lift c s₁ = w4Lift c s₂ := by
  exact funext fun i => by unfold w4Lift; aesop

/-- The w4Lift of a codeword lands in svCodeW 4. -/
lemma w4Lift_mem_svCodeW4 (c : BinaryVector 8) (s : Fin 8 → Fin 2)
    (hc : c ∈ extendedHamming8) (hw : hammingWeight c = 4) :
    w4Lift c s ∈ svCodeW 4 := by
  simp only [svCodeW, svCode, Finset.mem_filter, Finset.mem_univ, true_and,
    isShortHammingE8Vector]
  exact ⟨⟨by rw [mem_e8IntLattice_iff, reduceModTwo_decode5_w4Lift]; exact hc,
          by rw [sqNorm_decode5_w4Lift]; exact_mod_cast hw⟩,
         by rw [reduceModTwo_decode5_w4Lift]; exact hw⟩

/-
The image of w4Lift c has exactly 16 elements (for weight-4 c).
-/
/-- The "padded" set: sign functions that are 0 on the complement of supp(c). -/
def paddedSet (c : BinaryVector 8) : Finset (Fin 8 → Fin 2) :=
  Finset.univ.filter (fun s => ∀ i, c i = 0 → s i = 0)

/-
The image of w4Lift c over Finset.univ equals its image over paddedSet c.
-/
lemma w4Lift_image_eq_padded (c : BinaryVector 8) :
    Finset.univ.image (w4Lift c) = (paddedSet c).image (w4Lift c) := by
  -- For any $s \in \text{Finset.univ}$, there exists a padded $s' \in \text{paddedSet } c$ such that $\text{w4Lift } c s = \text{w4Lift } c s'$.
  have h_padded : ∀ s : Fin 8 → Fin 2, ∃ s' ∈ paddedSet c, w4Lift c s = w4Lift c s' := by
    intro s
    use fun i => if c i = 0 then 0 else s i;
    unfold paddedSet w4Lift; aesop;
  ext; simp [h_padded];
  exact ⟨ fun ⟨ s, hs ⟩ => by obtain ⟨ s', hs', hs'' ⟩ := h_padded s; exact ⟨ s', hs', hs''.symm ▸ hs ⟩, fun ⟨ s, hs, hs' ⟩ => ⟨ s, hs' ⟩ ⟩

/-
w4Lift c is injective on paddedSet c.
-/
lemma w4Lift_injOn_padded (c : BinaryVector 8) :
    Set.InjOn (w4Lift c) ↑(paddedSet c) := by
  -- By definition of w4Lift, if w4Lift c s₁ = w4Lift c s₂, then for all i, s₁ i = s₂ i whenever c i ≠ 0.
  intros s₁ hs₁ s₂ hs₂ h_eq
  ext i
  by_cases hci : c i = 0;
  · unfold paddedSet at hs₁ hs₂; aesop;
  · replace h_eq := congr_fun h_eq i; simp_all +decide [ w4Lift ] ;
    cases Fin.exists_fin_two.mp ⟨ s₁ i, rfl ⟩ <;> cases Fin.exists_fin_two.mp ⟨ s₂ i, rfl ⟩ <;> simp_all +decide only

/-
The padded set has 2^(hammingWeight c) elements.
-/
set_option maxRecDepth 2000 in
set_option maxHeartbeats 1600000 in -- paddedSet is a filter on Fin 8 → Fin 2 (256 elements)
lemma paddedSet_card (c : BinaryVector 8) (hw : hammingWeight c = 4) :
    (paddedSet c).card = 16 := by
  revert hw; revert c; decide

lemma w4Lift_image_card (c : BinaryVector 8)
    (hc : c ∈ extendedHamming8) (hw : hammingWeight c = 4) :
    (Finset.univ.image (w4Lift c)).card = 16 := by
  rw [w4Lift_image_eq_padded, Finset.card_image_of_injOn (w4Lift_injOn_padded c), paddedSet_card c hw]

/-- `svCodeW 4` decomposes as a biUnion over weight-4 codewords. -/
lemma svCodeW4_eq_biUnion :
    svCodeW 4 = (Finset.univ.filter (fun c : BinaryVector 8 =>
      c ∈ extendedHamming8 ∧ hammingWeight c = 4)).biUnion
        (fun c => Finset.univ.image (w4Lift c)) := by
  ext f
  simp only [svCodeW, svCode, Finset.mem_filter, Finset.mem_univ, true_and,
    isShortHammingE8Vector, Finset.mem_biUnion, Finset.mem_image]
  constructor
  · intro ⟨⟨hm, hsq⟩, hw⟩
    obtain ⟨s, hs⟩ := svCodeW4_is_w4Lift f
      (Finset.mem_filter.mpr ⟨Finset.mem_filter.mpr ⟨Finset.mem_univ _, hm, hsq⟩, hw⟩)
    exact ⟨reduceModTwo (decode5 f), ⟨hm, hw⟩, s, hs.symm⟩
  · rintro ⟨c, ⟨hc, hw⟩, s, rfl⟩
    exact ⟨⟨by rw [mem_e8IntLattice_iff, reduceModTwo_decode5_w4Lift]; exact hc,
            by rw [sqNorm_decode5_w4Lift]; exact_mod_cast hw⟩,
           by rw [reduceModTwo_decode5_w4Lift]; exact hw⟩

/-
w4Lift images for distinct codewords are disjoint.
-/
lemma w4Lift_images_disjoint :
    Set.PairwiseDisjoint
      (↑(Finset.univ.filter (fun c : BinaryVector 8 =>
        c ∈ extendedHamming8 ∧ hammingWeight c = 4)))
      (fun c => Finset.univ.image (w4Lift c)) := by
  intros c hc d hd hcd;
  simp +decide [ Finset.disjoint_left, Function.onFun ];
  intro a x h; have := congr_arg ( fun f => reduceModTwo ( decode5 f ) ) h; simp +decide [ reduceModTwo_decode5_w4Lift ] at this;
  exact hcd this.symm

/-
No-native replacement for the weight-four short-vector code count.
-/
lemma svCodeW4_card_no_native :
    (svCodeW 4).card = extendedHamming8WeightDist 4 * 16 := by
  rw [svCodeW4_eq_biUnion]
  rw [Finset.card_biUnion (fun c hc d hd hcd =>
    w4Lift_images_disjoint (Finset.mem_coe.mpr hc) (Finset.mem_coe.mpr hd) hcd)]
  have hfilt : (Finset.univ.filter (fun c : BinaryVector 8 =>
      c ∈ extendedHamming8 ∧ hammingWeight c = 4)) =
    (Finset.univ.filter (fun v : BinaryVector 8 =>
      Matrix.mulVec extendedHamming8ParityCheck v = 0 ∧ hammingWeight v = 4)) := by
    ext v; simp [mem_extendedHamming8_iff]
  conv_rhs => rw [extendedHamming8WeightDist]
  rw [Finset.sum_congr hfilt (fun c hc => by
    have hm := (Finset.mem_filter.mp hc).2
    exact w4Lift_image_card c hm.1 hm.2)]
  simp [Finset.sum_const]

/-! ## Assembly -/

/-- No-native replacement for the structural formula for `svCode.card`. -/
lemma svCode_card_eq_formula_no_native :
    svCode.card = shortVectorWeightDistributionFormula := by
  have hd04 := svCodeW_disjoint 0 4 (by omega)
  have hd08 := svCodeW_disjoint 0 8 (by omega)
  have hd48 := svCodeW_disjoint 4 8 (by omega)
  rw [svCode_partition]
  rw [Finset.card_union_of_disjoint (Finset.disjoint_union_left.mpr ⟨hd08, hd48⟩)]
  rw [Finset.card_union_of_disjoint hd04]
  rw [svCodeW0_card_no_native, svCodeW4_card_no_native, svCodeW8_card_no_native]
  rfl

/-- No-native replacement for the 240 short-vector count. -/
theorem short_vector_count_eq_240_structural_no_native :
    Set.ncard hammingE8ShortVectorSet = 240 := by
  rw [ncard_eq_svCode_card, svCode_card_eq_formula_no_native,
    shortVectorWeightDistributionFormula,
    extendedHamming8_weight_zero_count_no_native,
    extendedHamming8_weight_four_count_no_native,
    extendedHamming8_weight_eight_count_no_native]

end PhysicsSM.Coding
