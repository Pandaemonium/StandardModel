import PhysicsSM.Draft.E8Root240NoNative

/-!
# Completeness of the structural E8 root set

This file builds on `E8Root240NoNative.lean`, where the `240` E8 roots are given as an explicit
`Finset (Fin 8 → ℚ)` `E8RootSet := intRoots ∪ halfRoots` and shown to have exactly `240` distinct
elements, each of squared length `2`.

Here we prove **completeness**: `E8RootSet` is *exactly* the set of E8-lattice vectors of squared
length `2`.  Concretely:

* `E8RootSet_norm_sq` : every element of `E8RootSet` has squared length `2` (re-export of the
  structural fact);
* `E8_completeness` : conversely, any vector `v` in the E8 lattice with `∑ i, v i ^ 2 = 2`
  lies in `E8RootSet`;
* `E8RootSet_eq_lattice_norm2` : the two combine to the exact characterisation
  `v ∈ E8RootSet ↔ E8Lattice v ∧ ∑ i, v i ^ 2 = 2`.

Here the **E8 lattice** is the standard `D8⁺` description: a vector all of whose coordinates are
integers, or all of whose coordinates are half-odd-integers, whose coordinate sum is even.

No proof uses `native_decide`; the axiom footprint of every result is exactly
`[propext, Classical.choice, Quot.sound]` (verified with `#print axioms` at the bottom).
-/

open scoped BigOperators

namespace PhysicsSM.Draft.E8Root240Complete

open PhysicsSM.Draft.E8Root240NoNative

set_option maxRecDepth 10000

/-! ## The E8 lattice -/

/-- A rational vector all of whose coordinates are integers. -/
def IsIntVec (v : Fin 8 → ℚ) : Prop := ∀ i, ∃ n : ℤ, v i = (n : ℚ)

/-- A rational vector all of whose coordinates are half-odd-integers (`ℤ + ½`). -/
def IsHalfVec (v : Fin 8 → ℚ) : Prop := ∀ i, ∃ n : ℤ, v i = (n : ℚ) + 1 / 2

/-- The coordinate sum of `v` is an even integer. -/
def SumEven (v : Fin 8 → ℚ) : Prop := ∃ m : ℤ, (∑ i, v i) = 2 * (m : ℚ)

/-- Membership in the E8 lattice (`D8⁺`): all-integer or all-half-integer coordinates, with an
even coordinate sum. -/
def E8Lattice (v : Fin 8 → ℚ) : Prop := (IsIntVec v ∨ IsHalfVec v) ∧ SumEven v

/-! ## (a) Every root has squared length 2 -/

/-- **Every E8 root has squared length `2`** (re-export). -/
theorem E8RootSet_norm_sq : ∀ r ∈ E8RootSet, ∑ i, r i ^ 2 = 2 := E8RootSet_sq_norm

/-- **The E8 root set has exactly `240` (distinct) elements** (re-export). -/
theorem E8RootSet_card_eq : E8RootSet.card = 240 := E8RootSet_card

/-! ## Membership characterisations of the two families -/

/-
Membership in `intRoots` unfolded to an existential over index/sign parameters.
-/
lemma mem_intRoots_iff (r : Fin 8 → ℚ) :
    r ∈ intRoots ↔ ∃ i j : Fin 8, ∃ a b : Bool, i < j ∧ r = intRootVec i j a b := by
  simp +decide [ intRoots, intParams ];
  grind

/-
Membership in `halfRoots` unfolded to an existential over sign parameters.
-/
lemma mem_halfRoots_iff (r : Fin 8 → ℚ) :
    r ∈ halfRoots ↔ ∃ s : Fin 7 → Bool, r = halfRootVec s := by
  simp +decide [ halfRoots, eq_comm ]

/-! ## (b) Completeness: the integer case -/

/-
An integer-coordinate vector of squared length `2` is one of the `112` integer roots.
-/
lemma int_case (v : Fin 8 → ℚ) (hint : IsIntVec v) (hnorm : ∑ i, v i ^ 2 = 2) :
    v ∈ intRoots := by
  obtain ⟨a, b, hab⟩ : ∃ a b : Fin 8, a < b ∧ v a ≠ 0 ∧ v b ≠ 0 ∧ ∀ i, i ≠ a ∧ i ≠ b → v i = 0 := by
    -- Since there are exactly two non-zero coordinates, let's denote their indices by `a` and `b`.
    obtain ⟨a, b, hab⟩ : ∃ a b : Fin 8, a ≠ b ∧ v a ≠ 0 ∧ v b ≠ 0 ∧ ∀ i, i ≠ a ∧ i ≠ b → v i = 0 := by
      have h_two_nonzero : Finset.card (Finset.filter (fun i => v i ≠ 0) Finset.univ) = 2 := by
        -- Since $v$ is integer-valued, each $v_i$ is either $0$, $1$, or $-1$.
        have h_values : ∀ i, v i = 0 ∨ v i = 1 ∨ v i = -1 := by
          intro i
          obtain ⟨n, hn⟩ := ‹∀ i, ∃ n : ℤ, v i = n› i
          have h_sq_le_two : n ^ 2 ≤ 2 := by
            exact_mod_cast ( by rw [ ← hn ] ; exact hnorm ▸ Finset.single_le_sum ( fun a _ => sq_nonneg ( v a ) ) ( Finset.mem_univ i ) : ( n : ℚ ) ^ 2 ≤ 2 );
          have : n ≤ 1 := Int.le_of_lt_add_one ( by nlinarith ) ; ( have : n ≥ -1 := Int.le_of_lt_add_one ( by nlinarith ) ; interval_cases n <;> simp_all +decide ; );
        have h_card : ∑ i, (if v i = 0 then 0 else 1) = 2 := by
          have h_card : ∑ i, (v i) ^ 2 = ∑ i, (if v i = 0 then 0 else 1) := by
            exact Finset.sum_congr rfl fun i _ => by rcases h_values i with ( h | h | h ) <;> norm_num [ h ] ;
          exact_mod_cast h_card.symm.trans hnorm;
        simpa [ Finset.sum_ite ] using h_card
      rw [ Finset.card_eq_two ] at h_two_nonzero;
      obtain ⟨ a, b, hab, h ⟩ := h_two_nonzero; exact ⟨ a, b, hab, by simpa using Finset.ext_iff.mp h a, by simpa using Finset.ext_iff.mp h b, fun i hi => by simpa [ hi ] using Finset.ext_iff.mp h i ⟩ ;
    cases lt_or_gt_of_ne hab.1 <;> [ exact ⟨ a, b, ‹_›, hab.2.1, hab.2.2.1, hab.2.2.2 ⟩ ; exact ⟨ b, a, ‹_›, hab.2.2.1, hab.2.1, fun i hi => hab.2.2.2 i ⟨ by tauto, by tauto ⟩ ⟩ ];
  have hv_eq : v a ^ 2 = 1 ∧ v b ^ 2 = 1 := by
    have hv_eq : v a ^ 2 + v b ^ 2 = 2 := by
      rw [ ← hnorm, Finset.sum_eq_add ] <;> aesop;
    obtain ⟨ n, hn ⟩ := ‹IsIntVec v› a; obtain ⟨ m, hm ⟩ := ‹IsIntVec v› b; norm_num [ hn, hm ] at hv_eq ⊢;
    norm_cast at hv_eq; have : n ≤ 1 := Int.le_of_lt_add_one ( by nlinarith only [ hv_eq ] ) ; have : n ≥ -1 := Int.le_of_lt_add_one ( by nlinarith only [ hv_eq ] ) ; have : m ≤ 1 := Int.le_of_lt_add_one ( by nlinarith only [ hv_eq ] ) ; have : m ≥ -1 := Int.le_of_lt_add_one ( by nlinarith only [ hv_eq ] ) ; interval_cases n <;> interval_cases m <;> trivial;
  convert mem_intRoots_iff v |>.2 ⟨ a, b, if v a = 1 then Bool.true else Bool.false, if v b = 1 then Bool.true else Bool.false, hab.1, _ ⟩ using 1;
  unfold intRootVec; aesop;

/-! ## (b) Completeness: the half-integer case -/

/-
A half-integer-coordinate vector of squared length `2` with even coordinate sum is one of the
`128` half-integer roots.
-/
lemma half_case (v : Fin 8 → ℚ) (hhalf : IsHalfVec v) (hsum : SumEven v)
    (hnorm : ∑ i, v i ^ 2 = 2) : v ∈ halfRoots := by
  -- From `hhalf`, v i = nᵢ + 1/2 for integers nᵢ. Then v i^2 = (nᵢ + 1/2)^2 = ((2nᵢ+1)/2)^2, so ∑ (2nᵢ+1)^2 = 4 * ∑ v i^2 = 8.
  have h_sum_sq : ∑ i, (2 * (hhalf i).choose + 1) ^ 2 = 8 := by
    convert congr_arg ( fun x : ℚ => x * 4 ) hnorm using 1;
    rw [ Finset.sum_congr rfl fun i hi => show v i ^ 2 = ( ( hhalf i |> Exists.choose ) + 1 / 2 ) ^ 2 by rw [ ← hhalf i |> Exists.choose_spec ] ] ; norm_num [ Finset.sum_add_distrib, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, mul_pow ] ; ring_nf;
    norm_cast;
  -- Each (2nᵢ+1)² is an odd perfect square ≥ 1. A sum of 8 terms each ≥ 1 equalling 8 forces every term = 1, i.e. 2nᵢ+1 = ±1, i.e. nᵢ ∈ {0,-1}, i.e. v i = 1/2 or v i = -1/2.
  have h_coords : ∀ i, v i = 1 / 2 ∨ v i = -1 / 2 := by
    have h_coords : ∀ i, (2 * (hhalf i).choose + 1) ^ 2 = 1 := by
      have h_coords : ∀ i, (2 * (hhalf i).choose + 1) ^ 2 ≥ 1 := by
        intro i; by_contra h_contra; have := hhalf i; obtain ⟨ n, hn ⟩ := this; norm_num [ hn ] at h_contra;
        linarith [ show n = -1 by linarith ];
      exact fun i => le_antisymm ( by exact le_of_not_gt fun hi => by have := Finset.sum_lt_sum ( fun a _ => h_coords a ) ( show ∃ a, a ∈ Finset.univ ∧ ( 2 * ( hhalf a |> Exists.choose ) + 1 ) ^ 2 > 1 from ⟨ i, Finset.mem_univ _, hi ⟩ ) ; simp_all +decide ) ( h_coords i );
    intro i; specialize h_coords i; have := hhalf i; rcases this with ⟨ n, hn ⟩ ; norm_num [ hn ] at h_coords ⊢;
    exact Or.imp id ( fun h => by norm_num [ show n = -1 by linarith ] ) h_coords;
  -- So each v i = ±1/2, i.e. v i = sgn (bit i) / 2 where bit i := (v i = 1/2 : Bool).
  obtain ⟨s, hs⟩ : ∃ s : Fin 8 → Bool, ∀ i, v i = sgn (s i) / 2 := by
    use fun i => v i = 1 / 2;
    intro i; specialize h_coords i; rcases h_coords with ( h | h ) <;> norm_num [ h, sgn ] ;
  -- The eighth-coordinate parity bit 7 = parityLast s = bit0 ^^ … ^^ bit6 is forced by the even-sum hypothesis: ∑ v i = (number of + signs − number of − signs)/2 = (2t−8)/2 = t−4 where t = number of i with v i = 1/2. `SumEven` says this is an even integer, forcing t even, equivalently the XOR of all 8 bits is false, i.e. bit 7 = XOR of the first 7 bits = parityLast s.
  have h_parity : s 7 = parityLast (fun i => s i.castSucc) := by
    have h_parity : (∑ i, v i) = (∑ i, (if s i then 1 else -1)) / 2 := by
      rw [ Finset.sum_div _ _ _, Finset.sum_congr rfl ] ; aesop;
    have h_parity : (∑ i, (if s i then 1 else -1)) % 4 = 0 := by
      obtain ⟨ m, hm ⟩ := hsum;
      exact Int.emod_eq_zero_of_dvd ⟨ m, by push_cast [ ← @Int.cast_inj ℚ ] ; linarith ⟩;
    simp +decide [ Fin.sum_univ_eight, parityLast ] at h_parity ⊢;
    cases h : s 0 <;> cases h' : s 1 <;> cases h'' : s 2 <;> cases h''' : s 3 <;> cases h'''' : s 4 <;> cases h''''' : s 5 <;> cases h'''''' : s 6 <;> cases h''''''' : s 7 <;> simp +decide [ h, h', h'', h''', h'''', h''''', h'''''', h''''''' ] at h_parity ⊢;
  convert mem_halfRoots_iff v |>.2 ⟨ fun i => s i.castSucc, _ ⟩;
  ext i; simp +decide [ hs, halfRootVec, halfSign ] ;
  fin_cases i <;> simp +decide [ h_parity ]

/-! ## (b) Completeness -/

/-- **Completeness of the E8 root set.** Any vector of the E8 lattice with squared length `2`
belongs to `E8RootSet`. -/
theorem E8_completeness (v : Fin 8 → ℚ) (hlat : E8Lattice v)
    (hnorm : ∑ i, v i ^ 2 = 2) : v ∈ E8RootSet := by
  obtain ⟨htype, hsum⟩ := hlat
  rw [E8RootSet, Finset.mem_union]
  rcases htype with hint | hhalf
  · exact Or.inl (int_case v hint hnorm)
  · exact Or.inr (half_case v hhalf hsum hnorm)

/-- Each integer root lies in the E8 lattice. -/
lemma intRoots_subset_lattice : ∀ r ∈ intRoots, E8Lattice r := by
  intro r hr
  obtain ⟨i, j, a, b, hij, rfl⟩ := (mem_intRoots_iff r).1 hr
  refine ⟨Or.inl ?_, ?_⟩
  · intro k
    refine ⟨if k = i then (if a then 1 else -1) else if k = j then (if b then 1 else -1) else 0, ?_⟩
    simp only [intRootVec, sgn]
    split_ifs <;> norm_num
  · have hsum : ∑ k, intRootVec i j a b k = sgn a + sgn b := by
      rw [Finset.sum_eq_add_of_mem i j (Finset.mem_univ i) (Finset.mem_univ j) (ne_of_lt hij)]
      · rw [show intRootVec i j a b i = sgn a by simp [intRootVec],
            show intRootVec i j a b j = sgn b by simp [intRootVec, (ne_of_lt hij).symm]]
      · intro k _ hk
        simp only [intRootVec]
        rw [if_neg hk.1, if_neg hk.2]
    refine ⟨(if a then 1 else 0) + (if b then 1 else 0) - 1, ?_⟩
    rw [hsum]
    cases a <;> cases b <;> simp [sgn] <;> norm_num

/-- Each half-integer root lies in the E8 lattice. -/
lemma halfRoots_subset_lattice : ∀ r ∈ halfRoots, E8Lattice r := by
  intro r hr
  obtain ⟨s, rfl⟩ := (mem_halfRoots_iff r).mp hr
  refine ⟨Or.inr ?_, ?_⟩
  · intro k
    cases h : halfSign s k
    · exact ⟨-1, by simp only [halfRootVec, sgn, h]; norm_num⟩
    · exact ⟨0, by simp only [halfRootVec, sgn, h]; norm_num⟩
  · -- The sum of the eight ±½ coordinates is an even integer, forced by the parity constraint.
    have hdvd : (4 : ℤ) ∣ ∑ k : Fin 8, (if halfSign s k then (1 : ℤ) else -1) := by
      simp only [Fin.sum_univ_eight, halfSign, parityLast, Fin.isValue]
      rcases hs0 : s 0 with _ | _ <;> rcases hs1 : s 1 with _ | _ <;>
        rcases hs2 : s 2 with _ | _ <;> rcases hs3 : s 3 with _ | _ <;>
        rcases hs4 : s 4 with _ | _ <;> rcases hs5 : s 5 with _ | _ <;>
        rcases hs6 : s 6 with _ | _ <;> simp_all
    obtain ⟨m, hm⟩ := hdvd
    refine ⟨m, ?_⟩
    have hexp : ∑ k, halfRootVec s k
        = ((∑ k : Fin 8, (if halfSign s k then (1 : ℤ) else -1) : ℤ) : ℚ) / 2 := by
      push_cast
      rw [Finset.sum_div]
      apply Finset.sum_congr rfl
      intro k _
      simp only [halfRootVec, sgn]
    rw [hexp, hm]
    push_cast
    ring

/-- Every E8 root lies in the E8 lattice. -/
lemma E8RootSet_subset_lattice : ∀ r ∈ E8RootSet, E8Lattice r := by
  intro r hr
  rw [E8RootSet, Finset.mem_union] at hr
  rcases hr with hr | hr
  · exact intRoots_subset_lattice r hr
  · exact halfRoots_subset_lattice r hr

/-- **Exact characterisation.** `E8RootSet` is precisely the set of E8-lattice vectors of squared
length `2`. -/
theorem E8RootSet_eq_lattice_norm2 (v : Fin 8 → ℚ) :
    v ∈ E8RootSet ↔ E8Lattice v ∧ ∑ i, v i ^ 2 = 2 := by
  constructor
  · intro hv
    exact ⟨E8RootSet_subset_lattice v hv, E8RootSet_norm_sq v hv⟩
  · intro ⟨hlat, hnorm⟩
    exact E8_completeness v hlat hnorm

/-! ## Axiom footprint -/

#print axioms E8RootSet_norm_sq
#print axioms E8RootSet_card_eq
#print axioms int_case
#print axioms half_case
#print axioms E8RootSet_subset_lattice
#print axioms E8_completeness
#print axioms E8RootSet_eq_lattice_norm2

end PhysicsSM.Draft.E8Root240Complete
