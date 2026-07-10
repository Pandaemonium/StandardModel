import Mathlib

open scoped BigOperators

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000

set_option relaxedAutoImplicit false
set_option autoImplicit false

/-!
# Mass is a compression cost: a finite Kraft bound on the null-direction message

Clean-room, Mathlib-only finite combinatorics/algebra port of the Kraft inequality
and the "entropy ≤ expected code length" reading, in the *style* of the `kraft`
Lean package (github: elazarg/kraft).  The `kraft` package is cited here only as a
reference / provenance for the general theorem; it is **not** imported.

Everything is kept rational (ℚ, ℕ, `Finset.sum`); no `Real.log`/`Real.exp`, no
transcendentals.  Compression cost is measured by the **linear entropy**
`Hlin p = 1 - ∑ pᵢ²` (the rational `mass²` invariant), not the log/Shannon entropy.
-/

namespace KraftCompressionMass

/-- Kraft sum of a length assignment `l : Fin n → ℕ`: `∑ᵢ (1/2)^{lᵢ}` (rational). -/
def K {n : ℕ} (l : Fin n → ℕ) : ℚ := ∑ i, (1 / 2 : ℚ) ^ (l i)

/-- Kraft sum of a concrete binary code `c : Fin n → List Bool`. -/
def codeK {n : ℕ} (c : Fin n → List Bool) : ℚ := ∑ i, (1 / 2 : ℚ) ^ ((c i).length)

/-- Linear entropy of a weight distribution `p : Fin n → ℚ`: `1 - ∑ᵢ pᵢ²`.
This is the (normalized) `mass²` invariant of the direction register. -/
def Hlin {n : ℕ} (p : Fin n → ℚ) : ℚ := 1 - ∑ i, (p i) ^ 2

/-- A code `c` is prefix-free (a prefix code): distinct symbols get codewords
neither of which is a prefix of the other. -/
def PrefixFree {n : ℕ} (c : Fin n → List Bool) : Prop :=
  ∀ i j : Fin n, i ≠ j → ¬ (c i).IsPrefix (c j)

/-! ## Target 1 — Kraft inequality (forward direction, general) -/

/-
**Kraft inequality (forward direction).**  Any prefix code satisfies the Kraft
bound `∑ᵢ (1/2)^{|cᵢ|} ≤ 1`.  This is the finitely-provable half of the Kraft
equivalence "a length assignment is realizable by a prefix code iff its Kraft sum
is `≤ 1`"; the general converse construction is referenced from the `kraft` package
and exhibited concretely below (`mixedCode`, `converse_construction`).
-/
theorem kraft_inequality {n : ℕ} (c : Fin n → List Bool) (hpf : PrefixFree c) :
    codeK c ≤ 1 := by
  -- Let $L := \max\{|c_i| \mid i \in \{0, \ldots, n-1\}\}$.
  set L := Finset.univ.sup (fun i => (c i).length) with hL_def;
  have hL : ∀ i, (c i).length ≤ L := by
    exact fun i => Finset.le_sup ( f := fun i => List.length ( c i ) ) ( Finset.mem_univ i );
  -- For each $i$, the set $S_i$ contains exactly $2^{L - (c i).length}$ elements.
  have hSi_card : ∀ i, (Finset.univ.filter (fun f : Fin L → Bool => (c i).IsPrefix (List.ofFn f))).card = 2 ^ (L - (c i).length) := by
    intro i;
    -- The set of functions $f : Fin L → Bool$ such that $c i$ is a prefix of $List.ofFn f$ is in bijection with the set of functions $g : Fin (L - (c i).length) → Bool$.
    have h_bij : {f : Fin L → Bool | (c i).IsPrefix (List.ofFn f)} ≃ (Fin (L - (c i).length) → Bool) := by
      refine' Equiv.ofBijective ( fun f => fun j => f.val ⟨ j + ( c i |> List.length ), by linarith [ Fin.is_lt j, Nat.sub_add_cancel ( hL i ) ] ⟩ ) ⟨ _, _ ⟩;
      · intro f g hfg;
        ext ⟨ j, hj ⟩ ; by_cases hj' : j < ( c i |> List.length ) <;> simp_all +decide [ funext_iff ] ;
        · grind +suggestions;
        · convert hfg ⟨ j - ( c i |> List.length ), by omega ⟩ using 1 <;> simp +decide [ Nat.sub_add_cancel hj' ];
      · intro g;
        -- Define the function $f$ such that $f(j) = c_i(j)$ for $j < (c_i).length$ and $f(j) = g(j - (c_i).length)$ for $j \geq (c_i).length$.
        obtain ⟨f, hf⟩ : ∃ f : Fin L → Bool, (List.ofFn f).take (c i).length = c i ∧ ∀ j : Fin (L - (c i).length), f ⟨j + (c i).length, by linarith [Fin.is_lt j, Nat.sub_add_cancel (hL i)]⟩ = g j := by
          use fun j => if h : j.val < (c i).length then (c i)[j.val]! else g ⟨j.val - (c i).length, by
            exact tsub_lt_tsub_iff_right ( le_of_not_gt h ) |>.2 j.2⟩
          generalize_proofs at *;
          refine' ⟨ _, _ ⟩;
          · refine' List.ext_get _ _ <;> aesop;
          · grind;
        exact ⟨ ⟨ f, by
          grind ⟩, funext fun j => hf.2 j ⟩;
    have := Fintype.card_congr h_bij; simp_all +decide [ Fintype.card_pi ] ;
    rw [ ← this, Fintype.card_subtype ];
  -- Since the sets $S_i$ are pairwise disjoint, we have $\sum_{i=0}^{n-1} |S_i| \leq 2^L$.
  have h_disjoint : ∑ i, (Finset.univ.filter (fun f : Fin L → Bool => (c i).IsPrefix (List.ofFn f))).card ≤ 2 ^ L := by
    have h_disjoint : ∀ i j, i ≠ j → Disjoint (Finset.univ.filter (fun f : Fin L → Bool => (c i).IsPrefix (List.ofFn f))) (Finset.univ.filter (fun f : Fin L → Bool => (c j).IsPrefix (List.ofFn f))) := by
      intros i j hij; rw [ Finset.disjoint_left ] ; intro f hf₁ hf₂; simp_all +decide [ PrefixFree ] ;
      grind +suggestions;
    rw [ ← Finset.card_biUnion ];
    · exact le_trans ( Finset.card_le_univ _ ) ( by norm_num [ Finset.card_univ ] );
    · exact fun i _ j _ hij => h_disjoint i j hij;
  -- Substitute the cardinality of $S_i$ into the inequality.
  have h_subst : ∑ i, (1 / 2 : ℚ) ^ ((c i).length) * 2 ^ L ≤ 2 ^ L := by
    convert h_disjoint using 2 ; norm_num [ hSi_card ];
    rw [ Finset.sum_congr rfl fun i hi => by rw [ show ( 1 / 2 : ℚ ) ^ ( c i |> List.length ) * 2 ^ L = 2 ^ ( L - ( c i |> List.length ) ) by rw [ div_pow, div_mul_eq_mul_div, div_eq_iff ] <;> norm_cast <;> ring_nf <;> simp +decide [ ← pow_add, hL i ] ] ] ; norm_cast;
  convert div_le_one_of_le₀ h_subst ( by positivity : ( 0 : ℚ ) ≤ 2 ^ L ) using 1 ; norm_num [ ← Finset.sum_mul _ _ _ ];
  rfl

/-! ## Target 2 — Shannon–Fano / expected length bound (rational) -/

/-
**Expected length bound (Kraft satisfied).**  For a Shannon–Fano dyadic code
where each length satisfies the lower bracket `(1/2)^{lᵢ} ≤ pᵢ`, the Kraft sum is
automatically `≤ 1`, since `∑ (1/2)^{lᵢ} ≤ ∑ pᵢ = 1`.
-/
theorem expected_length_bound {n : ℕ} (p : Fin n → ℚ) (l : Fin n → ℕ)
    (hp1 : ∑ i, p i = 1) (hbr : ∀ i, (1 / 2 : ℚ) ^ (l i) ≤ p i) :
    K l ≤ 1 := by
  exact le_trans ( Finset.sum_le_sum fun _ _ => hbr _ ) hp1.le

/-
**Per-symbol dyadic bracketing (rational log-analogue).**  If the code length
`lᵢ` is chosen by Shannon–Fano bracketing `(1/2)^{lᵢ} ≤ pᵢ < (1/2)^{lᵢ-1}`, then
`2^{lᵢ-1} ≤ 1/pᵢ < 2^{lᵢ}`, i.e. `lᵢ = ⌈log₂(1/pᵢ)⌉` — stated rationally with no
`Real.log`.  This is the sense in which the compression cost is controlled by the
weight distribution.
-/
theorem shannon_fano_bracket {n : ℕ} (p : Fin n → ℚ) (l : Fin n → ℕ) (i : Fin n)
    (hlo : (1 / 2 : ℚ) ^ (l i) ≤ p i) (hhi : p i < (1 / 2 : ℚ) ^ (l i - 1)) :
    1 ≤ p i * 2 ^ (l i) ∧ p i * 2 ^ (l i - 1) < 1 := by
  constructor;
  · convert mul_le_mul_of_nonneg_right hlo ( pow_nonneg zero_le_two ( l i ) ) using 1 ; norm_num [ ← mul_pow ];
  · convert mul_lt_mul_of_pos_right hhi ( pow_pos ( by norm_num : ( 0 : ℚ ) < 2 ) ( l i - 1 ) ) using 1 ; norm_num [ ← mul_pow ]

/-! ## Target 3 — Mass is compressibility -/

/-
**Mass reading.**  The linear entropy (= normalized `mass²`) vanishes iff the
message is a single pure direction (one symbol carries all the weight): pure /
massless.  Otherwise it is strictly positive: mixed / massive.
-/
theorem mass_is_compressibility {n : ℕ} (p : Fin n → ℚ)
    (hp0 : ∀ i, 0 ≤ p i) (hp1 : ∑ i, p i = 1) :
    Hlin p = 0 ↔ ∃ i, p i = 1 := by
  constructor;
  · intro h0
    have h_sum_zero : ∑ i, (p i - (p i)^2) = 0 := by
      unfold Hlin at h0; simp_all +decide [ Finset.sum_sub_distrib ] ;
    rw [ Finset.sum_eq_zero_iff_of_nonneg ] at h_sum_zero;
    · contrapose! hp1;
      exact ne_of_lt ( lt_of_le_of_lt ( Finset.sum_nonpos fun i _ => le_of_not_gt fun hi => hp1 i <| mul_left_cancel₀ ( ne_of_gt hi ) <| by nlinarith [ h_sum_zero i <| Finset.mem_univ i ] ) zero_lt_one );
    · exact fun i _ => sub_nonneg_of_le ( by nlinarith only [ hp0 i, hp1, Finset.single_le_sum ( fun a _ => hp0 a ) ( Finset.mem_univ i ) ] );
  · rintro ⟨ i, hi ⟩;
    simp_all +decide [ Hlin ];
    rw [ Finset.sum_eq_single i ] <;> simp_all +decide [ sq ];
    exact fun j hj => by rw [ Finset.sum_eq_add_sum_diff_singleton ( Finset.mem_univ i ) ] at hp1; linarith [ hp0 j, Finset.single_le_sum ( fun a _ => hp0 a ) ( Finset.mem_sdiff.mpr ⟨ Finset.mem_univ j, by aesop ⟩ : j ∈ Finset.univ \ { i } ) ] ;

/-! ## Non-degeneracy witnesses -/

/-- Pure witness `p = (1,0,0)`: massless, `Hlin = 0`. -/
theorem pure_witness_massless : Hlin (![1, 0, 0] : Fin 3 → ℚ) = 0 := by
  simp [Hlin, Fin.sum_univ_three]

/-- Pure witness is a normalized distribution. -/
theorem pure_witness_sum : (∑ i, (![1, 0, 0] : Fin 3 → ℚ) i) = 1 := by
  simp [Fin.sum_univ_three]

/-- Mixed witness `p = (1/2,1/4,1/4)`: `Hlin = 1 - (1/4+1/16+1/16) = 5/8`. -/
theorem mixed_witness_Hlin : Hlin (![1 / 2, 1 / 4, 1 / 4] : Fin 3 → ℚ) = 5 / 8 := by
  simp [Hlin, Fin.sum_univ_three]; norm_num

/-- Mixed witness is massive: `Hlin > 0`. -/
theorem mixed_witness_massive : 0 < Hlin (![1 / 2, 1 / 4, 1 / 4] : Fin 3 → ℚ) := by
  rw [mixed_witness_Hlin]; norm_num

/-- The concrete prefix code for the mixed witness: `0`, `10`, `11`. -/
def mixedCode : Fin 3 → List Bool := ![[false], [true, false], [true, true]]

/-- The mixed code is genuinely prefix-free. -/
theorem mixedCode_prefixFree : PrefixFree mixedCode := by
  unfold PrefixFree mixedCode; decide

/-- Lengths of the mixed code are `(1,2,2)`. -/
theorem mixedCode_lengths : ∀ i, (mixedCode i).length = (![1, 2, 2] : Fin 3 → ℕ) i := by
  decide

/-- Kraft sum of the mixed code is exactly `1/2 + 1/4 + 1/4 = 1`. -/
theorem mixed_kraft_eq : K (![1, 2, 2] : Fin 3 → ℕ) = 1 := by
  simp [K, Fin.sum_univ_three]; norm_num

/-- The mixed code satisfies the Kraft bound. -/
theorem mixed_kraft_le : codeK mixedCode ≤ 1 := by
  have : codeK mixedCode = K (![1, 2, 2] : Fin 3 → ℕ) := by
    simp only [codeK, K]
    apply Finset.sum_congr rfl
    intro i _
    rw [mixedCode_lengths i]
  rw [this, mixed_kraft_eq]

/-- **Converse construction (concrete).**  The Kraft-admissible length triple
`(1,2,2)` (with `K = 1 ≤ 1`) is realized by the explicit prefix code `mixedCode`. -/
theorem converse_construction :
    PrefixFree mixedCode ∧
      (∀ i, (mixedCode i).length = (![1, 2, 2] : Fin 3 → ℕ) i) ∧
      K (![1, 2, 2] : Fin 3 → ℕ) ≤ 1 := by
  refine ⟨mixedCode_prefixFree, mixedCode_lengths, ?_⟩
  rw [mixed_kraft_eq]

/-! ## Target 4 — Compression verdict (package) -/

/-- **Compression verdict.**  A massless mode is a single pure direction (zero linear
entropy = zero `mass²`); a massive mode is a mixed direction message with positive
linear entropy that needs a genuine (≥ 2 symbol) prefix code satisfying Kraft.
"Mass is the compression cost of the null-direction message." -/
theorem compression_verdict :
    -- massless: the pure direction has zero linear entropy and one full-weight symbol
    (Hlin (![1, 0, 0] : Fin 3 → ℚ) = 0 ∧ ∃ i, (![1, 0, 0] : Fin 3 → ℚ) i = 1) ∧
    -- massive: the mixed direction is positive-entropy, prefix-coded, Kraft-admissible
    (0 < Hlin (![1 / 2, 1 / 4, 1 / 4] : Fin 3 → ℚ) ∧
      PrefixFree mixedCode ∧ codeK mixedCode ≤ 1) := by
  refine ⟨⟨pure_witness_massless, ⟨0, by norm_num⟩⟩,
    ⟨mixed_witness_massive, mixedCode_prefixFree, mixed_kraft_le⟩⟩

/-! ## Kernel-checked axiom footprint of every headline

Each headline depends on exactly `[propext, Classical.choice, Quot.sound]` — no `sorry`,
no `admit`, no `native_decide`, no new axioms. -/

/-- info: 'KraftCompressionMass.kraft_inequality' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms kraft_inequality

/-- info: 'KraftCompressionMass.expected_length_bound' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms expected_length_bound

/-- info: 'KraftCompressionMass.shannon_fano_bracket' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms shannon_fano_bracket

/-- info: 'KraftCompressionMass.mass_is_compressibility' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mass_is_compressibility

/-- info: 'KraftCompressionMass.compression_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms compression_verdict

end KraftCompressionMass
