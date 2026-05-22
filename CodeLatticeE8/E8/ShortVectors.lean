import CodeLatticeE8.E8.HammingConstruction
import CodeLatticeE8.Code.Hamming844WeightEnumerator
import CodeLatticeE8.ConstructionA.Even

/-!
# Short vectors of the Hamming Construction A lattice

The **short shell** of the Hamming Construction A integer model consists of
vectors of unscaled squared norm four.  This module proves that the short shell
has cardinality exactly **240**.

## Mathematical content

The proof partitions the short shell by the Hamming weight of the binary
residue `reduceModTwo z`.  Since `z ∈ hammingConstructionA`, the residue is a
Hamming codeword, which must have weight 0, 4, or 8.

| Weight `w` | Count | Reason |
|:---:|:---:|---|
| 0 | 16 | all coordinates even → one is `±2`, rest `0` → 8 × 2 = 16 |
| 4 | 224 | four odd coords each `±1`, four even coords `0` → 14 × 16 = 224 |
| 8 | 0 | all coordinates odd → `sqNorm ≥ 8 > 4`, impossible |

Total: 16 + 224 + 0 = **240**.

## Normalizations

`sqNorm z = ∑ i, (z i)^2` is the **unscaled** squared norm.  The short
condition `sqNorm z = 4` corresponds to scaled squared norm `2` under the
`1/√2` normalization that converts the Construction A model to E8.

## Counting strategy

The final count is proved by private finite parametrizations rather than by
native-code evaluation.  The weight-0 class is identified with
`Fin 8 × Bool`: choose the unique coordinate equal to `±2`.  The weight-4
class is identified with the disjoint union over the fourteen weight-4 Hamming
codewords, each contributing sixteen sign patterns on its support.

## Sources

- Conway & Sloane, *Sphere Packings, Lattices and Groups*, Ch. 7–8.
-/

set_option linter.style.longLine false

namespace CodeLatticeE8.E8

open CodeLatticeE8.Code
open CodeLatticeE8.ConstructionA

/-! ## The short shell -/

/-- The short shell: vectors in the Hamming Construction A lattice with
unscaled squared norm four.  Under the `1/√2` scaling these become the
E8 root vectors with squared norm two. -/
def hammingE8ShortShell : Set (Fin 8 → ℤ) :=
  {z | z ∈ hammingConstructionA ∧ sqNorm z = 4}

@[simp]
theorem mem_shortShell_iff (z : Fin 8 → ℤ) :
    z ∈ hammingE8ShortShell ↔ z ∈ hammingConstructionA ∧ sqNorm z = 4 :=
  Iff.rfl

theorem mem_shortShell_iff_parityCheck (z : Fin 8 → ℤ) :
    z ∈ hammingE8ShortShell ↔
      Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo z) = 0 ∧ sqNorm z = 4 := by
  simp [mem_shortShell_iff, mem_hammingConstructionA_iff_parityCheck]

/-! ## Coordinate bound -/

/-- Every coordinate of a short shell vector satisfies `|z i| ≤ 2`. -/
theorem coordinate_abs_le_two_of_short {z : Fin 8 → ℤ}
    (hz : z ∈ hammingE8ShortShell) (i : Fin 8) : |z i| ≤ 2 := by
  have h4 : (z i) ^ 2 ≤ 4 := by
    have hle := Finset.single_le_sum (f := fun j => (z j) ^ 2)
      (fun j _ => sq_nonneg _) (Finset.mem_univ i)
    simpa [sqNorm] using hle.trans hz.2.le
  nlinarith [sq_abs (z i)]

/-! ## Weight-8 class is empty -/

/-- A Hamming Construction A vector whose binary residue has Hamming weight 8
has `sqNorm ≥ 8` and therefore cannot lie in the short shell. -/
theorem not_short_of_weight8 {z : Fin 8 → ℤ}
    (_hmem : z ∈ hammingConstructionA)
    (hw : hammingWeight (reduceModTwo z) = 8) :
    ¬ (sqNorm z = 4) := by
  intro hsq
  have hge : (8 : ℤ) ≤ sqNorm z := by
    have hbase := sqNorm_ge_weight z
    have : (hammingWeight (reduceModTwo z) : ℤ) = 8 := by exact_mod_cast hw
    linarith
  linarith

/-! ## Finite encoding

Every short vector has all coordinates in `{-2, -1, 0, 1, 2}`, so it is
captured by a function `Fin 8 → Fin 5`.  We use the parity-check
characterization of `hammingConstructionA` to make membership decidable.
-/

/-- The five integer coordinate values for short vectors. -/
private abbrev shortCoordVals : Fin 5 → ℤ := ![-2, -1, 0, 1, 2]

/-- Encode an integer in `{-2, -1, 0, 1, 2}` as its `Fin 5` index. -/
private def encodeCoord (a : ℤ) : Fin 5 :=
  if a = -2 then 0 else if a = -1 then 1 else if a = 0 then 2
  else if a = 1 then 3 else 4

private theorem shortCoordVals_encodeCoord {a : ℤ} (ha : |a| ≤ 2) :
    shortCoordVals (encodeCoord a) = a := by
  rcases abs_le.mp ha with ⟨h₁, h₂⟩
  interval_cases a <;> simp [shortCoordVals, encodeCoord]

private theorem encodeCoord_shortCoordVals (v : Fin 5) :
    encodeCoord (shortCoordVals v) = v := by
  fin_cases v <;> simp [shortCoordVals, encodeCoord]

/-- Encode a short shell vector as a `Fin 5`-valued coordinate function. -/
private def encodeShort (z : Fin 8 → ℤ) : Fin 8 → Fin 5 :=
  fun i => encodeCoord (z i)

private theorem decode_encodeShort {z : Fin 8 → ℤ}
    (hz : z ∈ hammingE8ShortShell) :
    (fun i => shortCoordVals (encodeShort z i)) = z :=
  funext fun i => shortCoordVals_encodeCoord (coordinate_abs_le_two_of_short hz i)

private theorem encodeShort_injOn :
    Set.InjOn encodeShort hammingE8ShortShell := by
  intro z hz z' hz' heq
  funext i
  have hei : encodeCoord (z i) = encodeCoord (z' i) := congr_fun heq i
  calc z i
      = shortCoordVals (encodeCoord (z i))  := (shortCoordVals_encodeCoord (coordinate_abs_le_two_of_short hz i)).symm
    _ = shortCoordVals (encodeCoord (z' i)) := by rw [hei]
    _ = z' i                                := shortCoordVals_encodeCoord (coordinate_abs_le_two_of_short hz' i)

/-! ## Finsets for each weight class -/

/-- All encoded short vectors, as a `Finset`. -/
private def shortShellFinset : Finset (Fin 8 → Fin 5) :=
  Finset.univ.filter fun f =>
    Matrix.mulVec extendedHamming8ParityCheck
      (reduceModTwo (fun i => shortCoordVals (f i))) = 0 ∧
    sqNorm (fun i => shortCoordVals (f i)) = 4

/-- Encoded short vectors of residue weight `w`. -/
private def shortShellByWeight (w : ℕ) : Finset (Fin 8 → Fin 5) :=
  Finset.univ.filter fun f =>
    let z := fun i => shortCoordVals (f i)
    Matrix.mulVec extendedHamming8ParityCheck (reduceModTwo z) = 0 ∧
    sqNorm z = 4 ∧
    hammingWeight (reduceModTwo z) = w

private theorem shortShellFinset_eq_union :
    shortShellFinset =
      shortShellByWeight 0 ∪ shortShellByWeight 4 ∪ shortShellByWeight 8 := by
  ext f
  simp only [shortShellFinset, shortShellByWeight, Finset.mem_filter, Finset.mem_univ,
    true_and, Finset.mem_union]
  constructor
  · intro ⟨hmem, hsq⟩
    have hcode : (fun i => shortCoordVals (f i)) ∈ hammingConstructionA :=
      (mem_hammingConstructionA_iff_parityCheck _).mpr hmem
    rcases extendedHamming8_weight_support _ hcode with h | h | h
    · exact Or.inl (Or.inl ⟨hmem, hsq, h⟩)
    · exact Or.inl (Or.inr ⟨hmem, hsq, h⟩)
    · exact Or.inr ⟨hmem, hsq, h⟩
  · rintro ((⟨h, hs, -⟩ | ⟨h, hs, -⟩) | ⟨h, hs, -⟩) <;> exact ⟨h, hs⟩

private theorem shortShellByWeight_disjoint (a b : ℕ) (hab : a ≠ b) :
    Disjoint (shortShellByWeight a) (shortShellByWeight b) := by
  simp only [shortShellByWeight, Finset.disjoint_filter]
  exact fun _ _ ⟨_, _, h1⟩ ⟨_, _, h2⟩ => hab (h1 ▸ h2)

private theorem shortShellByWeight8_empty : shortShellByWeight 8 = ∅ := by
  ext f
  simp only [shortShellByWeight, Finset.mem_filter, Finset.mem_univ, true_and]
  constructor
  · rintro ⟨hmem, hsq, hw⟩
    exact absurd hsq
      (not_short_of_weight8 ((mem_hammingConstructionA_iff_parityCheck _).mpr hmem) hw)
  · simp

/-- The weight-0 short vector with coordinate `p.1` set to `±2`. -/
private def weight0Map (p : Fin 8 × Bool) : Fin 8 → Fin 5 :=
  fun j => if j = p.1 then (if p.2 then 4 else 0) else 2

private theorem weight0Map_mem (p : Fin 8 × Bool) :
    weight0Map p ∈ shortShellByWeight 0 := by
  simp only [shortShellByWeight, Finset.mem_filter, Finset.mem_univ, true_and]
  revert p
  decide

private theorem weight0Map_injective : Function.Injective weight0Map := by
  decide

-- This private finite classification unfolds the encoded search space and then
-- lets the arithmetic tactics prove the single-nonzero-coordinate shape.
set_option linter.flexible false in
set_option linter.unusedSimpArgs false in
private theorem shortShellByWeight0_subset_image :
    ∀ f ∈ shortShellByWeight 0,
      f ∈ Finset.image weight0Map Finset.univ := by
  intro f hf
  simp [shortShellByWeight] at hf
  have h_even : ∀ i, f i = 0 ∨ f i = 2 ∨ f i = 4 := by
    intro i
    have h_even : (shortCoordVals (f i) : ZMod 2) = 0 := by
      simp_all +decide [funext_iff, hammingWeight]
    have : f i = 0 ∨ f i = 1 ∨ f i = 2 ∨ f i = 3 ∨ f i = 4 := by
      omega
    rcases this with h | h | h | h | h <;> simp +decide [h] at h_even ⊢
  obtain ⟨i, hi⟩ : ∃ i, f i ≠ 2 := by
    contrapose! hf
    simp_all +decide [sqNorm]
  have h_sum : ∑ j, (shortCoordVals (f j)) ^ 2 = 4 := by
    exact hf.2.1
  have h_unique : ∀ j, j ≠ i → f j = 2 := by
    intro j hj_ne_i
    by_contra h_contra
    have h_sum_gt : ∑ j, (shortCoordVals (f j)) ^ 2 > 4 := by
      have h_pair_gt : ∑ j ∈ ({i, j} : Finset (Fin 8)),
          (shortCoordVals (f j)) ^ 2 > 4 := by
        rw [Finset.sum_pair hj_ne_i.symm]
        rcases h_even i with ha | ha | ha <;>
          rcases h_even j with hb | hb | hb <;>
          simp +decide only [ha, hb] at hi h_contra ⊢
      exact h_pair_gt.trans_le
        (Finset.sum_le_sum_of_subset_of_nonneg (Finset.subset_univ _)
          fun _ _ _ => sq_nonneg _)
    linarith
  rw [Finset.mem_image]
  use (i, f i = 4)
  simp +decide
  grind +locals

/-- The weight-0 class has 16 elements: one coordinate `±2`, rest `0`. -/
private theorem shortShellByWeight0_card :
    (shortShellByWeight 0).card = 16 := by
  have heq : shortShellByWeight 0 = Finset.image weight0Map Finset.univ := by
    ext f
    constructor
    · exact fun hf => shortShellByWeight0_subset_image f hf
    · intro hf
      simp only [Finset.mem_image, Finset.mem_univ, true_and] at hf
      obtain ⟨p, rfl⟩ := hf
      exact weight0Map_mem p
  rw [heq, Finset.card_image_of_injective _ weight0Map_injective, Finset.card_univ,
    Fintype.card_prod, Fintype.card_fin, Fintype.card_bool]

/-! ## Structural counting: weight-4 class

A weight-4 Hamming codeword gives the support of the four odd coordinates.
Each of the fourteen such codewords contributes `2^4 = 16` choices of signs.
-/

/-- The weight-4 short vector attached to a message and a sign pattern. -/
private def weight4Map (msg : Fin 4 → ZMod 2) (signs : Fin 8 → Bool) :
    Fin 8 → Fin 5 :=
  fun i => if (codewordOfMsg msg) i = 0 then 2
           else if signs i then 3 else 1

/-- The messages whose Hamming codewords have weight four. -/
private def wt4Msgs : Finset (Fin 4 → ZMod 2) :=
  Finset.univ.filter fun msg => hammingWeight (codewordOfMsg msg) = 4

/-- All sign-pattern vectors supported on a fixed weight-4 codeword. -/
private def signSets (msg : Fin 4 → ZMod 2) : Finset (Fin 8 → Fin 5) :=
  Finset.image (weight4Map msg) Finset.univ

set_option maxRecDepth 8192 in
set_option maxHeartbeats 800000 in
-- Kernel reduction over the finite message/sign space verifies membership
-- for the explicit parametrization.
private theorem weight4Map_mem (msg : Fin 4 → ZMod 2) (signs : Fin 8 → Bool) :
    hammingWeight (codewordOfMsg msg) = 4 →
    weight4Map msg signs ∈ shortShellByWeight 4 := by
  intro hw
  simp only [shortShellByWeight, Finset.mem_filter, Finset.mem_univ, true_and]
  revert msg signs
  decide

set_option maxRecDepth 8192 in
set_option maxHeartbeats 1600000 in
-- Kernel reduction checks that only the four support coordinates affect the
-- image, giving exactly sixteen sign-pattern vectors for each weight-4 word.
private theorem signSets_card (msg : Fin 4 → ZMod 2) :
    hammingWeight (codewordOfMsg msg) = 4 →
    (signSets msg).card = 16 := by
  revert msg
  decide

-- The disjointness proof reduces two different messages to a coordinate where
-- their codewords differ.
set_option linter.flexible false in
private theorem signSets_disjoint {msg₁ msg₂ : Fin 4 → ZMod 2}
    (_hw₁ : hammingWeight (codewordOfMsg msg₁) = 4)
    (_hw₂ : hammingWeight (codewordOfMsg msg₂) = 4)
    (hne : msg₁ ≠ msg₂) :
    Disjoint (signSets msg₁) (signSets msg₂) := by
  simp +decide [Finset.disjoint_left, signSets]
  have h_codeword_diff : ∃ i, codewordOfMsg msg₁ i ≠ codewordOfMsg msg₂ i := by
    exact Function.ne_iff.mp (fun h => hne (codewordOfMsg_injective h))
  intro a x h
  obtain ⟨i, hi⟩ := h_codeword_diff
  have := congr_fun h i
  simp_all +decide [weight4Map]
  cases Fin.exists_fin_two.mp ⟨codewordOfMsg msg₁ i, rfl⟩ <;>
    cases Fin.exists_fin_two.mp ⟨codewordOfMsg msg₂ i, rfl⟩ <;>
    simp_all +decide only
  · grind
  · split_ifs at this <;> contradiction

-- The reverse inclusion from the semantic filter to the parametrized union is
-- a finite support/sign reconstruction, so the private proof deliberately uses
-- finite simplification after the structural witnesses are chosen.
set_option linter.flexible false in
set_option linter.unusedSimpArgs false in
private theorem shortShellByWeight4_subset_biUnion :
    ∀ f ∈ shortShellByWeight 4,
      f ∈ Finset.biUnion wt4Msgs signSets := by
  unfold shortShellByWeight
  intro f hf
  simp_all +decide [Finset.mem_biUnion, Finset.mem_image, wt4Msgs, signSets]
  refine ⟨msgOfCodeword (reduceModTwo fun i => shortCoordVals (f i)), ?_,
    fun i => (f i == 3), ?_⟩
  · rw [codeword_msg_right_inv _ hf.1]
    aesop
  · ext i
    simp +decide [weight4Map]
    split_ifs <;> simp_all +decide [codeword_msg_right_inv]
    · have h_zero_sum : ∑ j ∈ Finset.univ.filter
          (fun j => (reduceModTwo fun i => shortCoordVals (f i)) j = 0),
          (shortCoordVals (f j)) ^ 2 = 0 := by
        have h_total : ∑ j ∈ Finset.univ.filter
              (fun j => (reduceModTwo fun i => shortCoordVals (f i)) j = 0),
              (shortCoordVals (f j)) ^ 2 +
            ∑ j ∈ Finset.univ.filter
              (fun j => (reduceModTwo fun i => shortCoordVals (f i)) j ≠ 0),
              (shortCoordVals (f j)) ^ 2 = 4 := by
          rw [← hf.2.1, Finset.sum_filter_add_sum_filter_not]
          rfl
        have h_odd_part : ∑ j ∈ Finset.univ.filter
              (fun j => (reduceModTwo fun i => shortCoordVals (f i)) j ≠ 0),
              (shortCoordVals (f j)) ^ 2 ≥ 4 := by
          have h_each : ∀ j ∈ Finset.univ.filter
              (fun j => (reduceModTwo fun i => shortCoordVals (f i)) j ≠ 0),
              (shortCoordVals (f j)) ^ 2 ≥ 1 := by
            intro j hj
            contrapose! hj
            simp_all +decide [abs_eq_zero]
          refine le_trans ?_ (Finset.sum_le_sum h_each)
          simp_all +decide [hammingWeight]
        linarith [show
          ∑ j with (reduceModTwo fun i => shortCoordVals (f i)) j = 0,
            (shortCoordVals (f j)) ^ 2 ≥ 0
          from Finset.sum_nonneg fun _ _ => sq_nonneg _]
      rw [Finset.sum_eq_zero_iff_of_nonneg fun _ _ => sq_nonneg _] at h_zero_sum
      specialize h_zero_sum i
      simp_all +decide [reduceModTwo]
      all_goals rcases h : f _ with _ | _ | _ | _ | _ | _ <;> simp_all +decide
    · rcases h : f i with _ | _ | _ | _ | _ | _ <;> simp_all +decide

/-- The number of Hamming messages with codeword weight four is fourteen. -/
private theorem wt4Msgs_card : wt4Msgs.card = 14 := by
  change (Finset.univ.filter fun msg : Fin 4 → ZMod 2 =>
    hammingWeight (codewordOfMsg msg) = 4).card = 14
  decide

/-- The weight-4 class has 224 elements: 14 codewords times 16 sign patterns. -/
private theorem shortShellByWeight4_card :
    (shortShellByWeight 4).card = 224 := by
  have heq : shortShellByWeight 4 = Finset.biUnion wt4Msgs signSets := by
    ext f
    constructor
    · exact fun hf => shortShellByWeight4_subset_biUnion f hf
    · intro hf
      simp only [Finset.mem_biUnion] at hf
      obtain ⟨msg, hmsg, hf⟩ := hf
      simp only [wt4Msgs, Finset.mem_filter, Finset.mem_univ, true_and] at hmsg
      simp only [signSets, Finset.mem_image, Finset.mem_univ, true_and] at hf
      obtain ⟨signs, rfl⟩ := hf
      exact weight4Map_mem msg signs hmsg
  rw [heq]
  have hpw : Set.PairwiseDisjoint (wt4Msgs : Set _) signSets := by
    intro msg hm msg' hm' hne
    simp only [wt4Msgs, Finset.mem_coe, Finset.mem_filter, Finset.mem_univ,
      true_and] at hm hm'
    exact signSets_disjoint hm hm' hne
  rw [Finset.card_biUnion hpw]
  suffices h : ∀ msg ∈ wt4Msgs, (signSets msg).card = 16 by
    simp only [Finset.sum_congr rfl h, Finset.sum_const, smul_eq_mul, wt4Msgs_card]
  intro msg hmsg
  simp only [wt4Msgs, Finset.mem_filter, Finset.mem_univ, true_and] at hmsg
  exact signSets_card msg hmsg

private theorem shortShellFinset_card : shortShellFinset.card = 240 := by
  rw [shortShellFinset_eq_union]
  have d04 := shortShellByWeight_disjoint 0 4 (by omega)
  have d08 := shortShellByWeight_disjoint 0 8 (by omega)
  have d48 := shortShellByWeight_disjoint 4 8 (by omega)
  rw [Finset.card_union_of_disjoint (Finset.disjoint_union_left.mpr ⟨d08, d48⟩)]
  rw [Finset.card_union_of_disjoint d04]
  simp [shortShellByWeight0_card, shortShellByWeight4_card, shortShellByWeight8_empty]

/-! ## Bijection with the semantic short shell -/

private theorem encodeShort_mem_shortShellFinset {z : Fin 8 → ℤ}
    (hz : z ∈ hammingE8ShortShell) :
    encodeShort z ∈ shortShellFinset := by
  simp only [shortShellFinset, Finset.mem_filter, Finset.mem_univ, true_and]
  rw [show (fun i => shortCoordVals (encodeShort z i)) = z from decode_encodeShort hz]
  exact ⟨(mem_hammingConstructionA_iff_parityCheck _).mp hz.1, hz.2⟩

private theorem encodeShort_surjOn_shortShellFinset :
    ∀ f ∈ shortShellFinset, f ∈ encodeShort '' hammingE8ShortShell := by
  intro f hf
  simp only [shortShellFinset, Finset.mem_filter, Finset.mem_univ, true_and] at hf
  refine ⟨fun i => shortCoordVals (f i), ⟨?_, ?_⟩, ?_⟩
  · rw [mem_hammingConstructionA_iff_parityCheck]; exact hf.1
  · exact hf.2
  · funext i; simp [encodeShort, encodeCoord_shortCoordVals]

private theorem shortShell_ncard_eq_shortShellFinset_card :
    Set.ncard hammingE8ShortShell = shortShellFinset.card := by
  have heq : encodeShort '' hammingE8ShortShell = ↑shortShellFinset := by
    ext f
    constructor
    · rintro ⟨z, hz, rfl⟩
      exact Finset.mem_coe.mpr (encodeShort_mem_shortShellFinset hz)
    · intro hf
      obtain ⟨z, hz, henc⟩ := encodeShort_surjOn_shortShellFinset f (Finset.mem_coe.mp hf)
      exact ⟨z, hz, henc⟩
  calc Set.ncard hammingE8ShortShell
      = Set.ncard (encodeShort '' hammingE8ShortShell) := encodeShort_injOn.ncard_image.symm
    _ = Set.ncard (↑shortShellFinset : Set _)          := by rw [heq]
    _ = shortShellFinset.card                          := Set.ncard_coe_finset _

/-! ## Main theorem -/

/-- **Main theorem**: the short shell of the Hamming Construction A lattice
has exactly 240 elements.

These are the pre-images of the 240 E8 root vectors under the `1/√2` scaling.
They split as:
- 16 from the zero Hamming codeword: one coordinate `±2`, rest `0`.
- 224 from the fourteen weight-4 Hamming codewords: four coordinates each `±1`.
- 0 from the all-ones Hamming codeword: `sqNorm ≥ 8 > 4`.
-/
theorem hammingConstructionA_short_vector_count :
    Set.ncard hammingE8ShortShell = 240 := by
  rw [shortShell_ncard_eq_shortShellFinset_card, shortShellFinset_card]

end CodeLatticeE8.E8
