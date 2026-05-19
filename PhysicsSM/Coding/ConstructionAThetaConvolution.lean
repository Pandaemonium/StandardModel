import PhysicsSM.Coding.ConstructionAConvolutionHelpers

/-!
# General Construction A theta/weight-enumerator convolution formula

This module promotes the 2026-05-15 Aristotle convolution result into the
project's trusted theta-series API.  It proves a structural formula expressing
Construction A shell counts as a convolution of one-dimensional even/odd lift
series, weighted by the Hamming weight distribution of the extended `[8,4,4]`
code.

The earlier Aristotle draft introduced local copies of `hammingCodewords`,
`evenLiftCoeff`, and `oddLiftCoeff`.  This integrated version reuses the
definitions from `PhysicsSM.Coding.ConstructionAThetaWeightBridge`, so later
theta-series work has one canonical vocabulary.

## Main results

* `residueShellCount_eq_weightContribConvolution` — for any binary vector `c`
  and norm `s`, the number of integer lifts with that residue and squared norm
  equals a product-of-sums convolution determined by `hammingWeight c`.

* `constructionAShellCount_eq_codeword_convolution` — the Construction A
  shell count equals the sum over codewords of the weight convolution.

* `constructionAShellCount_eq_weight_distribution_convolution` — the shell
  count equals `A₀ · f(0,s) + A₄ · f(4,s) + A₈ · f(8,s)`.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option linter.style.multiGoal false
set_option linter.style.nativeDecide false
set_option linter.style.refine false
set_option linter.style.whitespace false
set_option linter.unusedSimpArgs false
set_option linter.flexible false

namespace PhysicsSM.Coding

/-! ## Core definitions -/

/-- Coefficient formula for the product of one-dimensional lift series. -/
def weightContribConvolution (w s : Nat) : Nat :=
  (Finset.univ : Finset (Fin 8 → Fin (s + 1))).sum fun parts =>
    if (Finset.univ.sum fun i : Fin 8 => (parts i).val) = s then
      Finset.univ.prod fun i : Fin 8 =>
        if i.val < w then oddLiftCoeff (parts i).val
        else evenLiftCoeff (parts i).val
    else 0

/-- The full, unbounded residue shell. -/
noncomputable def residueShellSet (c : BinaryVector 8) (s : Nat) :
    Set (Fin 8 → Int) :=
  {z | sqNorm z = (s : Int) ∧ reduceModTwo z = c}

/-- The full, unbounded Construction A shell. -/
noncomputable def constructionAShellSet (s : Nat) : Set (Fin 8 → Int) :=
  {z | z ∈ e8IntLattice ∧ sqNorm z = (s : Int)}

/-! ## Membership helpers -/

theorem mem_hammingCodewords_iff (c : BinaryVector 8) :
    c ∈ hammingCodewords ↔ c ∈ extendedHamming8 := by
  simp [hammingCodewords, Finset.mem_filter, mem_extendedHamming8_iff]

/-! ## Finiteness -/

theorem coord_sq_le_of_sqNorm_eq {n : ℕ} (z : Fin n → ℤ) (s : ℕ)
    (hs : sqNorm z = (s : ℤ)) (i : Fin n) : z i ^ 2 ≤ s := by
  have : z i ^ 2 ≤ sqNorm z := by
    simp [sqNorm]
    exact Finset.single_le_sum (fun j _ => sq_nonneg (z j)) (Finset.mem_univ i)
  omega

theorem residueShellSet_finite (c : BinaryVector 8) (s : ℕ) :
    Set.Finite (residueShellSet c s) := by
  apply Set.Finite.subset (Set.Finite.pi (fun _ => Finset.finite_toSet _) :
    Set.Finite (Set.pi Set.univ (fun (_ : Fin 8) => ↑(Finset.Icc (-(s : ℤ)) s))))
  intro z ⟨hz_norm, _⟩ i _
  simp
  have hle := coord_sq_le_of_sqNorm_eq z s hz_norm i
  constructor <;> nlinarith [sq_abs (z i)]

theorem constructionAShellSet_finite (s : ℕ) :
    Set.Finite (constructionAShellSet s) := by
  apply Set.Finite.subset (Set.Finite.pi (fun _ => Finset.finite_toSet _) :
    Set.Finite (Set.pi Set.univ (fun (_ : Fin 8) => ↑(Finset.Icc (-(s : ℤ)) s))))
  intro z ⟨_, hz_norm⟩ i _
  simp
  have hle := coord_sq_le_of_sqNorm_eq z s hz_norm i
  constructor <;> nlinarith [sq_abs (z i)]

/-! ## Partition of Construction A shell by codeword residue -/

theorem constructionAShellSet_eq_biUnion (s : ℕ) :
    constructionAShellSet s =
      ⋃ c ∈ hammingCodewords, residueShellSet c s := by
  ext z
  simp only [constructionAShellSet, residueShellSet, Set.mem_setOf_eq,
    Set.mem_iUnion]
  constructor
  · intro ⟨hmem, hnorm⟩
    exact ⟨reduceModTwo z, (mem_hammingCodewords_iff _).mpr
      ((mem_e8IntLattice_iff z).mp hmem), hnorm, rfl⟩
  · intro ⟨c, hc, hnorm, hred⟩
    exact ⟨(mem_e8IntLattice_iff z).mpr (hred ▸ (mem_hammingCodewords_iff c).mp hc), hnorm⟩

theorem residueShellSet_pairwiseDisjoint (s : ℕ) :
    (hammingCodewords : Set (BinaryVector 8)).PairwiseDisjoint
      (fun c => residueShellSet c s) := by
  intro c₁ _ c₂ _ hne
  simp only [Function.onFun, Set.disjoint_left]
  intro z ⟨_, hz1⟩ ⟨_, hz2⟩
  exact hne (hz1.symm ▸ hz2)

theorem constructionAShellSet_ncard_eq_sum (s : ℕ) :
    Set.ncard (constructionAShellSet s) =
      hammingCodewords.sum (fun c => Set.ncard (residueShellSet c s)) := by
  rw [ show constructionAShellSet s = ⋃ c ∈ hammingCodewords, residueShellSet c s from ?_ ];
  · -- Apply the lemma that the cardinality of a finite union of pairwise disjoint finite sets is the sum of their cardinalities.
    have h_card_union : ∀ {t : Finset (BinaryVector 8)}, (∀ c ∈ t, Set.Finite (residueShellSet c s)) → (t : Set (BinaryVector 8)).PairwiseDisjoint (fun c => residueShellSet c s) → (⋃ c ∈ t, residueShellSet c s).ncard = ∑ c ∈ t, (residueShellSet c s).ncard := by
      intros t ht_finite ht_disjointjoint;
      convert Set.Finite.ncard_biUnion ( Set.toFinite t ) ht_finite ht_disjointjoint using 1;
      convert ( finsum_mem_coe_finset _ _ );
      convert rfl;
      convert finsum_mem_coe_finset _ _;
      convert finsum_mem_coe_finset _ _;
    exact h_card_union ( fun c hc => residueShellSet_finite c s ) ( residueShellSet_pairwiseDisjoint s );
  · -- Apply the equality we have just established to conclude the proof.
    apply constructionAShellSet_eq_biUnion

/-! ## Residue-specific convolution (uses actual codeword positions) -/

/-- Convolution using the actual codeword `c` to determine odd/even. -/
def residueConvolution (c : BinaryVector 8) (s : Nat) : Nat :=
  (Finset.univ : Finset (Fin 8 → Fin (s + 1))).sum fun parts =>
    if (Finset.univ.sum fun i : Fin 8 => (parts i).val) = s then
      Finset.univ.prod fun i : Fin 8 =>
        if c i ≠ 0 then oddLiftCoeff (parts i).val
        else evenLiftCoeff (parts i).val
    else 0

/-! ## Core counting: decomposition into helper lemmas -/

/-- The residue shell as a Finset (explicit finite version). -/
noncomputable def residueShellFinset (c : BinaryVector 8) (s : ℕ) : Finset (Fin 8 → ℤ) :=
  (Fintype.piFinset (fun _ : Fin 8 => Finset.Icc (-(s : ℤ)) s)).filter
    (fun z => ∑ i : Fin 8, z i ^ 2 = (↑s : ℤ) ∧ ∀ i, (z i : ZMod 2) = c i)

/-
Set.ncard of the residue shell Set equals card of the Finset.
-/
theorem residueShellSet_ncard_eq_finset_card (c : BinaryVector 8) (s : ℕ) :
    Set.ncard (residueShellSet c s) = (residueShellFinset c s).card := by
  nontriviality;
  rw [ ← Set.ncard_coe_finset ];
  congr;
  ext; simp [residueShellSet, residueShellFinset];
  constructor <;> intro h <;> simp_all +decide [ funext_iff, sqNorm, reduceModTwo ];
  exact fun i => ⟨ by nlinarith only [ h.1 ▸ Finset.single_le_sum ( fun a _ => sq_nonneg ( ‹Fin 8 → ℤ› a ) ) ( Finset.mem_univ i ) ], by nlinarith only [ h.1 ▸ Finset.single_le_sum ( fun a _ => sq_nonneg ( ‹Fin 8 → ℤ› a ) ) ( Finset.mem_univ i ) ] ⟩

/-- The square pattern map: for z in the residue shell, maps to the
    allocation of squared values. -/
noncomputable def sqPattern (s : ℕ) (z : Fin 8 → ℤ)
    (hz : ∑ i : Fin 8, z i ^ 2 = (↑s : ℤ)) : Fin 8 → Fin (s + 1) :=
  fun i => ⟨(z i).natAbs ^ 2, by
    have h1 : z i ^ 2 ≤ ↑s := by
      calc z i ^ 2 ≤ ∑ j : Fin 8, z j ^ 2 :=
            Finset.single_le_sum (fun j _ => sq_nonneg (z j)) (Finset.mem_univ i)
        _ = ↑s := hz
    have h2 : (z i).natAbs ^ 2 ≤ s := by
      exact_mod_cast show ((z i).natAbs ^ 2 : ℤ) ≤ s by
        rw [Int.natAbs_sq]; exact h1
    omega⟩

/-
Each fiber of the square pattern has cardinality = product of coordinate lift Finset cards.
-/
theorem fiber_card_eq_prod (c : BinaryVector 8) (s : ℕ)
    (p : Fin 8 → Fin (s + 1)) (hp : ∑ i : Fin 8, (p i).val = s) :
    ((residueShellFinset c s).filter
      (fun z => ∀ i, (z i).natAbs ^ 2 = (p i).val)).card =
    ∏ i : Fin 8, (coordLiftFinset (c i) (p i).val).card := by
  convert Set.ncard_coe_finset _ using 1;
  convert Set.ncard_coe_finset _ using 1;
  convert Set.ncard_coe_finset _ using 1;
  any_goals exact Finset.pi Finset.univ fun i => coordLiftFinset ( c i ) ( p i );
  · rw [ ← Set.ncard_coe_finset ];
    fapply Set.ncard_congr;
    use fun a ha i _ => a i;
    · simp +decide [ coordLiftFinset ];
      intro a ha ha' i; specialize ha' i; simp_all +decide [ ← Int.natCast_inj, Int.natAbs_sq ] ;
      exact ⟨ ⟨ by nlinarith only [ ha', Fin.is_lt ( p i ) ], by nlinarith only [ ha', Fin.is_lt ( p i ) ] ⟩, by simpa [ ← ha' ] using Finset.mem_filter.mp ha |>.2.2 i ⟩;
    · simp +contextual [ funext_iff ];
    · simp +decide [ residueShellFinset ];
      intro b hb; use fun i => b i ( Finset.mem_univ i ) ; simp_all +decide [ coordLiftFinset ] ;
      exact ⟨ ⟨ fun i => ⟨ by linarith [ hb i, Fin.is_lt ( p i ) ], by linarith [ hb i, Fin.is_lt ( p i ) ] ⟩, mod_cast hp ⟩, fun i => by simpa [ ← Int.natCast_inj ] using hb i |>.2.1 ⟩;
  · convert Set.ncard_coe_finset _ using 1;
  · convert Set.ncard_coe_finset _ using 1;
  · simp +decide [ Finset.card_univ, Finset.card_pi ]

/-
The Finset card equals the sum over valid patterns of fiber cards.
-/
theorem finset_card_eq_sum_fibers (c : BinaryVector 8) (s : ℕ) :
    (residueShellFinset c s).card =
      ∑ p ∈ (Finset.univ : Finset (Fin 8 → Fin (s + 1))),
        if ∑ i : Fin 8, (p i).val = s then
          ((residueShellFinset c s).filter
            (fun z => ∀ i, (z i).natAbs ^ 2 = (p i).val)).card
        else 0 := by
  rw [ ← Finset.sum_filter ];
  rw [ ← Finset.card_biUnion ];
  · congr with z ; simp +decide [ residueShellFinset ];
    constructor <;> intro h;
    · refine' ⟨ fun i => ⟨ ( z i |> Int.natAbs ) ^ 2, _ ⟩, _, _, _ ⟩ <;> norm_num;
      · nlinarith only [ abs_mul_abs_self ( z i ), h.2.1 ▸ Finset.single_le_sum ( fun a _ => sq_nonneg ( z a ) ) ( Finset.mem_univ i ) ];
      · zify;
        simpa using h.2.1;
      · tauto;
    · tauto;
  · intros a ha b hb hab; simp_all +decide [ Finset.disjoint_left ] ;
    exact fun z hz hz' => not_forall.mp fun h => hab <| funext fun i => Fin.ext <| h i

/-- The core counting theorem. -/
theorem residueShellSet_ncard_eq_residueConvolution
    (c : BinaryVector 8) (s : ℕ) :
    Set.ncard (residueShellSet c s) = residueConvolution c s := by
  rw [residueShellSet_ncard_eq_finset_card]
  rw [finset_card_eq_sum_fibers]
  unfold residueConvolution
  congr 1; ext p
  split_ifs with hp
  · rw [fiber_card_eq_prod c s p hp]
    congr 1; ext i
    rw [coordLiftFinset_card]
  · rfl

theorem residueConvolution_eq_weightContribConvolution
    (c : BinaryVector 8) (s : ℕ) :
    residueConvolution c s = weightContribConvolution (hammingWeight c) s := by
  by_contra h_contraolution;
  have h_symm : ∀ (σ : Equiv.Perm (Fin 8)), residueConvolution c s = residueConvolution (fun i => c (σ i)) s := by
    intro σ
    apply Finset.sum_bij (fun parts _ => parts ∘ σ);
    · simp;
    · exact fun a₁ _ a₂ _ h => funext fun i => by simpa using congr_fun h ( σ.symm i ) ;
    · exact fun b _ => ⟨ b ∘ σ.symm, Finset.mem_univ _, by ext; simp +decide ⟩;
    · intro a ha; simp +decide [ Finset.sum_apply, Finset.prod_apply, Equiv.sum_comp σ fun i => ( a i : ℕ ), Equiv.prod_comp σ fun i => if c i ≠ 0 then oddLiftCoeff ( a i : ℕ ) else evenLiftCoeff ( a i : ℕ ) ] ;
      exact if_congr Iff.rfl ( by rw [ ← Equiv.prod_comp σ ] ) rfl;
  -- Let's choose a permutation σ that maps the positions where c i is non-zero to the first w positions.
  obtain ⟨σ, hσ⟩ : ∃ σ : Equiv.Perm (Fin 8), ∀ i, c (σ i) ≠ 0 ↔ i.val < hammingWeight c := by
    have h_perm : ∃ σ : Fin 8 → Fin 8, Function.Injective σ ∧ ∀ i, c (σ i) ≠ 0 ↔ i.val < hammingWeight c := by
      have h_card : Finset.card (Finset.filter (fun i => c i ≠ 0) Finset.univ) = hammingWeight c := by
        rfl
      have h_perm : ∃ σ : Fin (hammingWeight c) → Fin 8, Function.Injective σ ∧ ∀ i, c (σ i) ≠ 0 := by
        exact ⟨ fun i => Finset.orderEmbOfFin _ ( by aesop ) i, by aesop_cat, fun i => Finset.mem_filter.mp ( Finset.orderEmbOfFin_mem ( Finset.filter ( fun i => c i ≠ 0 ) Finset.univ ) ( by aesop ) i ) |>.2 ⟩;
      have h_perm : ∃ σ : Fin (8 - hammingWeight c) → Fin 8, Function.Injective σ ∧ ∀ i, c (σ i) = 0 := by
        have h_perm : Finset.card (Finset.filter (fun i => c i = 0) Finset.univ) = 8 - hammingWeight c := by
          rw [ ← h_card, Finset.filter_not, Finset.card_sdiff ] ; norm_num;
          rw [ Nat.sub_sub_self ( le_trans ( Finset.card_le_univ _ ) ( by decide ) ) ];
        exact ⟨ fun i => Finset.orderEmbOfFin _ ( by aesop ) i, by aesop_cat, fun i => Finset.mem_filter.mp ( Finset.orderEmbOfFin_mem ( Finset.filter ( fun i => c i = 0 ) Finset.univ ) ( by aesop ) i ) |>.2 ⟩;
      obtain ⟨σ₁, hσ₁⟩ := ‹∃ σ : Fin (hammingWeight c) → Fin 8, Function.Injective σ ∧ ∀ i, c (σ i) ≠ 0›
      obtain ⟨σ₂, hσ₂⟩ := h_perm;
      use fun i => if hi : i.val < hammingWeight c then σ₁ ⟨i.val, hi⟩ else σ₂ ⟨i.val - hammingWeight c, by
        omega⟩
      generalize_proofs at *;
      refine' ⟨ _, _ ⟩;
      · intro i j hij;
        grind;
      · grind;
    exact ⟨ Equiv.ofBijective h_perm.choose ( ⟨ h_perm.choose_spec.1, Finite.injective_iff_surjective.mp h_perm.choose_spec.1 ⟩ ), h_perm.choose_spec.2 ⟩;
  refine' h_contraolution ( h_symm σ ▸ _ );
  exact Finset.sum_congr rfl fun x hx => by aesop;

/-! ## Hamming weight grouping

The previous version of the final convolution theorem grouped the 16 Hamming
codewords with a fresh finite search.  The lemmas in this section make that
last step structural: they use the already-proved support theorem for the
extended `[8,4,4]` code, namely that every codeword has Hamming weight `0`,
`4`, or `8`, and then reduce any sum depending only on the weight to the three
weight classes.

These lemmas came from Aristotle job
`38c802a4-5b9d-4637-a6b6-f818f8506452`, reviewed and promoted here so later
theta-series arguments can reuse the grouping theorem directly.
-/

/-- The public `hammingCodewords` finset and the public weight distribution
use the same underlying finite predicate. -/
theorem hammingCodewords_filter_weight_card (w : Nat) :
    (hammingCodewords.filter (fun c => hammingWeight c = w)).card =
      extendedHamming8WeightDist w := by
  congr 1 with c
  simp +decide [hammingCodewords, Finset.mem_filter]

/-- Helper: summing a weight-dependent function over a weight-constant filter
gives the cardinality of the filter times the constant value. -/
private theorem sum_filter_weight_eq (F : Nat → Nat) (w : Nat) :
    (hammingCodewords.filter (fun c => hammingWeight c = w)).sum
      (fun c => F (hammingWeight c)) =
    (hammingCodewords.filter (fun c => hammingWeight c = w)).card * F w := by
  rw [Finset.card_eq_sum_ones, Finset.sum_mul]
  exact Finset.sum_congr rfl fun x hx => by
    simp only [Finset.mem_filter] at hx
    rw [hx.2]
    ring

/-- Helper: every element of `hammingCodewords` has weight `0`, `4`, or `8`. -/
private theorem hammingCodewords_weight_trichotomy {c : BinaryVector 8}
    (hc : c ∈ hammingCodewords) :
    hammingWeight c = 0 ∨ hammingWeight c = 4 ∨ hammingWeight c = 8 := by
  exact extendedHamming8_weight_support c
    (Finset.mem_filter.mp hc).2

/-- Helper: the three weight filters partition `hammingCodewords`. -/
private theorem hammingCodewords_eq_weight_union :
    hammingCodewords =
      hammingCodewords.filter (fun c => hammingWeight c = 0) ∪
      hammingCodewords.filter (fun c => hammingWeight c = 4) ∪
      hammingCodewords.filter (fun c => hammingWeight c = 8) := by
  ext c
  simp only [Finset.mem_union, Finset.mem_filter]
  constructor
  · intro hc
    rcases hammingCodewords_weight_trichotomy hc with h | h | h
    · exact Or.inl (Or.inl ⟨hc, h⟩)
    · exact Or.inl (Or.inr ⟨hc, h⟩)
    · exact Or.inr ⟨hc, h⟩
  · rintro ((⟨hc, -⟩ | ⟨hc, -⟩) | ⟨hc, -⟩) <;> exact hc

/--
Pure Hamming weight grouping for sums over the extended `[8,4,4]` code.

If a summand depends on a codeword only through its Hamming weight, the sum
over all 16 codewords is the sum over the three possible weights `0`, `4`,
and `8`, weighted by the public weight-distribution function.  This is the
finite combinatorial bridge needed by the Construction A theta convolution:
it keeps the analytic-looking shell formula tied to the certified Hamming
weight enumerator instead of to a separate ad hoc enumeration.
-/
theorem hammingCodewords_sum_by_weight_classes (F : Nat → Nat) :
    hammingCodewords.sum (fun c => F (hammingWeight c)) =
      extendedHamming8WeightDist 0 * F 0 +
      extendedHamming8WeightDist 4 * F 4 +
      extendedHamming8WeightDist 8 * F 8 := by
  conv_lhs => rw [hammingCodewords_eq_weight_union]
  have d04 : Disjoint (hammingCodewords.filter (fun c => hammingWeight c = 0))
                       (hammingCodewords.filter (fun c => hammingWeight c = 4)) :=
    Finset.disjoint_filter.mpr fun _ _ h0 h4 => absurd (h0.symm.trans h4) (by omega)
  have d048 : Disjoint
    (hammingCodewords.filter (fun c => hammingWeight c = 0) ∪
     hammingCodewords.filter (fun c => hammingWeight c = 4))
    (hammingCodewords.filter (fun c => hammingWeight c = 8)) := by
    rw [Finset.disjoint_union_left]
    exact ⟨Finset.disjoint_filter.mpr fun _ _ h0 h8 =>
             absurd (h0.symm.trans h8) (by omega),
           Finset.disjoint_filter.mpr fun _ _ h4 h8 =>
             absurd (h4.symm.trans h8) (by omega)⟩
  rw [Finset.sum_union d048, Finset.sum_union d04,
      sum_filter_weight_eq, sum_filter_weight_eq, sum_filter_weight_eq,
      hammingCodewords_filter_weight_card, hammingCodewords_filter_weight_card,
      hammingCodewords_filter_weight_card]

/-! ## Main target theorems -/

theorem residueShellCount_eq_weightContribConvolution
    (c : BinaryVector 8) (s : Nat) :
    Set.ncard (residueShellSet c s) =
      weightContribConvolution (hammingWeight c) s := by
  rw [← residueConvolution_eq_weightContribConvolution]
  exact residueShellSet_ncard_eq_residueConvolution c s

theorem constructionAShellCount_eq_codeword_convolution (s : Nat) :
    Set.ncard (constructionAShellSet s) =
      hammingCodewords.sum
        (fun c => weightContribConvolution (hammingWeight c) s) := by
  rw [constructionAShellSet_ncard_eq_sum]
  congr 1
  ext c
  exact residueShellCount_eq_weightContribConvolution c s

theorem constructionAShellCount_eq_weight_distribution_convolution_grouped
    (s : Nat) :
    Set.ncard (constructionAShellSet s) =
      extendedHamming8WeightDist 0 * weightContribConvolution 0 s +
      extendedHamming8WeightDist 4 * weightContribConvolution 4 s +
      extendedHamming8WeightDist 8 * weightContribConvolution 8 s := by
  rw [constructionAShellCount_eq_codeword_convolution]
  exact hammingCodewords_sum_by_weight_classes
    (fun w => weightContribConvolution w s)

/--
Construction A shell counts are the Hamming weight-distribution convolution.

This stable public theorem is kept under its original name.  Its proof now
delegates the final Hamming-codeword grouping to
`constructionAShellCount_eq_weight_distribution_convolution_grouped`, so the
last step is a reusable structural lemma rather than a theorem-local finite
search.
-/
theorem constructionAShellCount_eq_weight_distribution_convolution (s : Nat) :
    Set.ncard (constructionAShellSet s) =
      extendedHamming8WeightDist 0 * weightContribConvolution 0 s +
      extendedHamming8WeightDist 4 * weightContribConvolution 4 s +
      extendedHamming8WeightDist 8 * weightContribConvolution 8 s :=
  constructionAShellCount_eq_weight_distribution_convolution_grouped s

end PhysicsSM.Coding
