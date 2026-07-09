import Mathlib

/-!
# Are generations a *representation* problem? A finite family-index no-go.

## Setting (self-contained toy model)

We formalize the "family-index / null-coherence module" question from the strategy
prompt in an elementary, fully rigorous finite model, and read off an honest verdict
on whether the finite carrier category *forces* exactly three generations.

**Carrier / external data.** We fix a carrier whose internal Clifford/null data is a
finite bundle of `n` interchangeable *null strands* (`n : ℕ` is the carrier's
*strand rank*). The external charge/strand *pattern* — the occupancy that all three
leptons of a generation column share — is held fixed; what varies between candidate
generations is only how the null-direction bundle is *completed* into a positive
sector.

**Positive-sector completion.** A raw completion assigns to each of the `n` null
strands a positive/negative orientation:

    Completion n := Fin n → Bool

(`true` = strand lies in the positive coherence sector, `false` = negative sector).

**Gauge / inequivalence.** The `n` strands carry no external label — they are pure
internal gauge data — so relabelling them is a gauge symmetry. Two completions count
as *the same generation* iff they differ by such a relabelling, i.e. by a permutation
of the strand index:

    GaugeRel n c₁ c₂ := ∃ σ : Equiv.Perm (Fin n), c₂ = c₁ ∘ σ

A **module** (an inequivalent positive-sector completion / a candidate "generation")
is a gauge-equivalence class:

    Module n := Quotient (gaugeSetoid n)

## Results

* `distinguishing_invariant` : the *coherence index* `idx c` (the number of strands in
  the positive sector) is a **complete gauge invariant**:
  `GaugeRel n c₁ c₂ ↔ idx c₁ = idx c₂`. This is the dimensionless, within-category
  structural invariant distinguishing modules — an integer count (equivalently the
  ratio `idx/n`), explicitly NOT an absolute mass.
* `moduleEquiv : Module n ≃ Fin (n + 1)` and `count_completions :
  Fintype.card (Module n) = n + 1`.
* `three_for_rank_two : Fintype.card (Module 2) = 3`.
* `three_iff_rank_two : Fintype.card (Module n) = 3 ↔ n = 2`.
* `three_not_forced : ∃ n, Fintype.card (Module n) ≠ 3`.

## Verdict

The number of inequivalent positive-sector completions is exactly `n + 1`, a function
of the free strand rank `n`. It equals three **iff** the rank is pinned to `n = 2`.
Nothing in the finite-carrier data pins the rank, so *three generations is NOT forced*:
the missing axiom is precisely a rank-fixing axiom (`n = 2`). See `ARISTOTLE_SUMMARY.md`.
-/

open scoped BigOperators
open scoped Classical

set_option maxHeartbeats 1600000

namespace FamilyIndex

/-- A raw positive-sector completion of a rank-`n` carrier: each of the `n`
interchangeable null strands is oriented into the positive (`true`) or negative
(`false`) coherence sector. -/
abbrev Completion (n : ℕ) : Type := Fin n → Bool

/-- The **coherence index** of a completion: the number of strands lying in the
positive coherence sector. This is the candidate dimensionless invariant. -/
def idx {n : ℕ} (c : Completion n) : ℕ :=
  (Finset.univ.filter (fun i => c i = true)).card

/-
The coherence index never exceeds the strand rank.
-/
lemma idx_le {n : ℕ} (c : Completion n) : idx c ≤ n := by
  exact le_trans ( Finset.card_le_univ _ ) ( by simp )

/-- **Gauge relation.** Two completions are gauge-equivalent (the same "generation")
iff they differ by a relabelling of the strands. -/
def GaugeRel (n : ℕ) (c₁ c₂ : Completion n) : Prop :=
  ∃ σ : Equiv.Perm (Fin n), c₂ = c₁ ∘ σ

lemma gauge_refl {n : ℕ} (c : Completion n) : GaugeRel n c c := by
  -- The identity permutation satisfies the condition, so GaugeRel n c c holds.
  use Equiv.refl (Fin n)
  simp

lemma gauge_symm {n : ℕ} {c₁ c₂ : Completion n} (h : GaugeRel n c₁ c₂) :
    GaugeRel n c₂ c₁ := by
  obtain ⟨ σ, rfl ⟩ := h; exact ⟨ σ.symm, by aesop ⟩ ;

lemma gauge_trans {n : ℕ} {c₁ c₂ c₃ : Completion n}
    (h₁ : GaugeRel n c₁ c₂) (h₂ : GaugeRel n c₂ c₃) : GaugeRel n c₁ c₃ := by
  -- By combining the permutations from h₁ and h₂, we can show that the composition of the permutations works.
  obtain ⟨σ, hσ⟩ := h₁
  obtain ⟨τ, hτ⟩ := h₂
  use τ.trans σ;
  aesop

/-- The gauge relation as a `Setoid`. -/
def gaugeSetoid (n : ℕ) : Setoid (Completion n) where
  r := GaugeRel n
  iseqv := ⟨gauge_refl, gauge_symm, gauge_trans⟩

/-
The coherence index is a gauge invariant.
-/
lemma idx_gauge_invariant {n : ℕ} {c₁ c₂ : Completion n}
    (h : GaugeRel n c₁ c₂) : idx c₁ = idx c₂ := by
  obtain ⟨σ, hσ⟩ := h;
  simp +decide [ hσ, idx ];
  rw [ Finset.card_filter, Finset.card_filter ];
  conv_lhs => rw [ ← Equiv.sum_comp σ ] ;

/-
Completeness of the invariant: equal coherence index implies gauge equivalence.
Constructed by pairing a bijection between the two positive-sector strand sets with a
bijection between their complements (both of equal cardinality since the indices and
the ambient rank agree).
-/
lemma gauge_of_idx_eq {n : ℕ} {c₁ c₂ : Completion n}
    (h : idx c₁ = idx c₂) : GaugeRel n c₁ c₂ := by
  obtain ⟨σ₁, σ₂, hσ⟩ : ∃ σ₁ : {i : Fin n // c₁ i = true} ≃ {i : Fin n // c₂ i = true}, ∃ σ₂ : {i : Fin n // ¬c₁ i = true} ≃ {i : Fin n // ¬c₂ i = true}, True := by
    refine' ⟨ Fintype.equivOfCardEq _, Fintype.equivOfCardEq _, trivial ⟩;
    · simp_all +decide [ Fintype.card_subtype, idx ];
    · simp_all +decide [ Fintype.card_subtype, idx ];
      have := Finset.card_add_card_compl ( Finset.filter ( fun x => c₁ x = true ) Finset.univ ) ; have := Finset.card_add_card_compl ( Finset.filter ( fun x => c₂ x = true ) Finset.univ ) ; simp_all +decide ;
      grind;
  obtain ⟨σ, hσ⟩ : ∃ σ : Fin n ≃ Fin n, ∀ i, c₂ (σ i) = c₁ i := by
    refine' ⟨ Equiv.ofBijective ( fun i => if hi : c₁ i = true then σ₁ ⟨ i, hi ⟩ else σ₂ ⟨ i, hi ⟩ ) ⟨ _, _ ⟩, _ ⟩;
    all_goals simp +decide [ Function.Injective, Function.Surjective ];
    · intro a₁ a₂ h; split_ifs at h <;> simp_all +decide [ Fin.ext_iff ] ;
      · have := σ₁.injective ( Subtype.ext <| Fin.ext h ) ; aesop;
      · grind +extAll;
      · grind +suggestions;
      · have := σ₂.injective ( Subtype.ext <| Fin.ext h ) ; aesop;
    · intro b;
      by_cases hb : c₂ b = true;
      · obtain ⟨ a, ha ⟩ := σ₁.surjective ⟨ b, hb ⟩;
        grind;
      · obtain ⟨ a, ha ⟩ := σ₂.surjective ⟨ b, hb ⟩;
        grind;
    · grind;
  exact ⟨ σ.symm, funext fun i => by simpa using hσ ( σ.symm i ) ⟩

/-- **The distinguishing invariant.** The coherence index is a *complete* gauge
invariant: two positive-sector completions are the same generation iff they have the
same coherence index. -/
theorem distinguishing_invariant {n : ℕ} (c₁ c₂ : Completion n) :
    GaugeRel n c₁ c₂ ↔ idx c₁ = idx c₂ :=
  ⟨idx_gauge_invariant, gauge_of_idx_eq⟩

/-- A **module**: an inequivalent positive-sector completion, i.e. a gauge class. -/
def Module (n : ℕ) : Type := Quotient (gaugeSetoid n)

/-- The canonical completion with exactly `k` positively-oriented strands
(`k` capped implicitly by the `Fin`-comparison). -/
def canonical (n : ℕ) (k : Fin (n + 1)) : Completion n :=
  fun i => decide (i.val < k.val)

lemma idx_canonical {n : ℕ} (k : Fin (n + 1)) : idx (canonical n k) = k.val := by
  convert Finset.card_range k.val using 2;
  refine' Finset.card_bij ( fun i hi => i ) _ _ _ <;> simp +decide [ canonical ];
  · exact fun a₁ ha₁ a₂ ha₂ h => Fin.ext h;
  · exact fun b hb => ⟨ ⟨ b, by linarith [ Fin.is_lt k ] ⟩, hb, rfl ⟩

/-- The coherence index descends to modules and lands in `Fin (n+1)`. -/
def moduleIndex {n : ℕ} : Module n → Fin (n + 1) :=
  Quotient.lift (fun c => ⟨idx c, Nat.lt_succ_of_le (idx_le c)⟩)
    (fun a b h => by
      apply Fin.ext
      exact idx_gauge_invariant h)

lemma moduleEquiv_left_inv {n : ℕ} (m : Module n) :
    Quotient.mk (gaugeSetoid n) (canonical n (moduleIndex m)) = m := by
  obtain ⟨ c, rfl ⟩ := Quotient.exists_rep m;
  exact Quotient.sound ( distinguishing_invariant _ _ |>.2 ( by rw [ idx_canonical ] ; exact rfl ) )

lemma moduleEquiv_right_inv {n : ℕ} (k : Fin (n + 1)) :
    moduleIndex (Quotient.mk (gaugeSetoid n) (canonical n k)) = k := by
  exact Fin.ext ( idx_canonical k )

/-- **Classification of modules.** The gauge classes of positive-sector completions of
a rank-`n` carrier are in canonical bijection with `{0, 1, …, n}` (the possible
coherence indices). -/
def moduleEquiv (n : ℕ) : Module n ≃ Fin (n + 1) where
  toFun := moduleIndex
  invFun := fun k => Quotient.mk (gaugeSetoid n) (canonical n k)
  left_inv := moduleEquiv_left_inv
  right_inv := moduleEquiv_right_inv

noncomputable instance instFintypeModule (n : ℕ) : Fintype (Module n) :=
  Fintype.ofEquiv _ (moduleEquiv n).symm

/-- **The count.** There are exactly `n + 1` inequivalent positive-sector completions
of a rank-`n` carrier. -/
theorem count_completions (n : ℕ) : Fintype.card (Module n) = n + 1 := by
  rw [Fintype.card_congr (moduleEquiv n), Fintype.card_fin]

/-- For strand rank two, there are exactly three modules. -/
theorem three_for_rank_two : Fintype.card (Module 2) = 3 := by
  rw [count_completions]

/-- **Exactly three is equivalent to rank two.** Three generations is forced *iff* the
carrier strand rank is pinned to `n = 2`. -/
theorem three_iff_rank_two (n : ℕ) : Fintype.card (Module n) = 3 ↔ n = 2 := by
  rw [count_completions]
  omega

/-- **No-go / honest verdict.** The count is not identically three: it depends on the
free strand rank `n`. Hence the finite carrier category does NOT force three
generations without an extra rank-fixing axiom. -/
theorem three_not_forced : ∃ n : ℕ, Fintype.card (Module n) ≠ 3 := by
  refine ⟨0, ?_⟩
  rw [count_completions]
  omega

/-- The **dimensionless structural ratio** distinguishing modules: coherence index
over strand rank. This is a within-category ratio, explicitly NOT an absolute mass; a
cross-carrier scale map would be needed to turn it into a physical mass ratio. -/
noncomputable def coherenceRatio {n : ℕ} (m : Module n) : ℚ :=
  (moduleIndex m : ℚ) / (n : ℚ)

end FamilyIndex

#print axioms FamilyIndex.count_completions
#print axioms FamilyIndex.distinguishing_invariant
#print axioms FamilyIndex.three_iff_rank_two
#print axioms FamilyIndex.three_not_forced
#print axioms FamilyIndex.three_for_rank_two
