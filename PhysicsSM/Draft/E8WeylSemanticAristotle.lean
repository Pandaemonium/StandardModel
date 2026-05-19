import PhysicsSM.Algebra.Octonion.E8WeylBasic
import PhysicsSM.Draft.E8RootSemanticAristotle
import Mathlib

/-!
# Aristotle scaffold: semantic preservation of E8 roots by Weyl reflections

This draft packages job C from the Hamming/Construction A/E8 strengthening
list.  The trusted closure theorem `reflectD_mem_rootList` is currently a
finite `native_decide` check over all `240 * 240` root pairs.  The target here
is the semantic theorem: if `r` and `v` satisfy the doubled-coordinate E8 root
predicate, then `reflectD r v` also satisfies it.
-/

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option maxHeartbeats 800000

namespace PhysicsSM.Algebra.Octonion.E8Root

/-! ## Helper lemmas for the reflection preservation proof -/

/-
When both `r` and `v` are E8 roots, the dot product `dotD v r` is divisible by 4.
This is the integrality condition ensuring reflections stay in the lattice.

Proof idea: case-split on root types using `isE8RootD_iff_type1_or_type2_structural`.
- Type1 × Type1: each entry is in {-2,0,2}, so each product v_i * r_i is divisible by 4.
- Type1 × Type2 (or vice versa): type1 has exactly 2 nonzero entries ±2, type2 has all ±1,
  so dotD = ±2*(±1) + ±2*(±1) ∈ {-4, 0, 4}.
- Type2 × Type2: write v_i = 1-2a_i, r_i = 1-2b_i with a_i,b_i ∈ {0,1}.
  Then dotD = 8 - 2∑a - 2∑b + 4∑(a*b). Since ∑v ≡ 0 mod 4 forces ∑a even,
  and similarly ∑b even, each term is ≡ 0 mod 4.

dotD divisibility when both roots are type 1. Each product v_i * r_i is 0 or ±4.
-/
lemma dotD_div4_type1_type1 (r v : Fin 8 → ℤ)
    (hr : IsType1RootD r) (hv : IsType1RootD v) : 4 ∣ dotD v r := by
  -- By definition of `IsType1RootD`, there exist indices `i1, j1` such that `r` has non-zero entries at these indices and zeros elsewhere, and similarly for `v` with indices `i2, j2`.
  obtain ⟨i1, j1, hij1, si1, sj1, hsi1, hsj1, v_eq⟩ := hv
  obtain ⟨i2, j2, hij2, si2, sj2, hsi2, hsj2, r_eq⟩ := hr;
  -- Substitute the expressions for `v` and `r` into the dot product formula.
  simp [v_eq, r_eq, dotD];
  simp_all +decide [ Finset.sum_ite, Finset.filter_eq', Finset.filter_ne' ];
  grind +qlia

/-
dotD divisibility when v is type 1 and r is type 2.
  Type1 v has exactly 2 nonzero entries ±2, type2 r has all ±1.
  So dotD = v_i*r_i + v_j*r_j = ±2*(±1) + ±2*(±1) ∈ {-4,0,4}.
-/
lemma dotD_div4_type1_type2 (r v : Fin 8 → ℤ)
    (hr : IsType2RootD r) (hv : IsType1RootD v) : 4 ∣ dotD v r := by
  obtain ⟨ i, j, hij, si, sj, hsi, hsj, rfl ⟩ := hv;
  unfold dotD;
  rw [ Finset.sum_eq_add ( i ) ( j ) ] <;> simp +decide [ *, Finset.sum_ite ];
  · rcases hsi with ( rfl | rfl ) <;> rcases hsj with ( rfl | rfl ) <;> rw [ if_neg hij.ne' ] <;> rcases hr.1 i with ha | ha <;> rcases hr.1 j with hb | hb <;> rw [ ha, hb ] <;> decide;
  · exact ne_of_lt hij;
  · aesop

/-
dotD divisibility when v is type 2 and r is type 1.
-/
lemma dotD_div4_type2_type1 (r v : Fin 8 → ℤ)
    (hr : IsType1RootD r) (hv : IsType2RootD v) : 4 ∣ dotD v r := by
  rcases hr with ⟨ i, j, hij, si, sj, hsi, hsj, rfl ⟩;
  -- Since $v$ is type2, all $v k$ are either $1$ or $-1$.
  have h_v_values : ∀ k, v k = 1 ∨ v k = -1 := by
    exact hv.1;
  unfold dotD;
  rcases hsi with ( rfl | rfl ) <;> rcases hsj with ( rfl | rfl ) <;> simp +decide [ Finset.sum_ite, Finset.filter_eq', Finset.filter_ne', hij.ne, hij.ne.symm ];
  · cases h_v_values i <;> cases h_v_values j <;> simp +decide only [*];
  · cases h_v_values i <;> cases h_v_values j <;> simp +decide only [*];
  · cases h_v_values i <;> cases h_v_values j <;> simp +decide [ * ];
  · cases h_v_values i <;> cases h_v_values j <;> simp +decide [ * ]

/-
dotD divisibility when both roots are type 2.
  Write v_i = 1-2a_i, r_i = 1-2b_i. Then
  dotD = 8 - 2∑a - 2∑b + 4∑(a*b) ≡ 0 mod 4
  since ∑v ≡ 0 mod 4 forces ∑a even (so 2∑a ≡ 0 mod 4), similarly for b.
-/
lemma dotD_div4_type2_type2 (r v : Fin 8 → ℤ)
    (hr : IsType2RootD r) (hv : IsType2RootD v) : 4 ∣ dotD v r := by
  -- By definition of `IsType2RootD`, we know that `v` and `r` are type 2 roots.
  obtain ⟨hv1, hv2⟩ := hv
  obtain ⟨hr1, hr2⟩ := hr;
  -- Since $v$ and $r$ are type 2 roots, we know that $v_i * r_i \equiv 1 \pmod{4}$ for all $i$.
  have h_dot_mod : (∑ i, v i * r i) % 4 = (∑ i, (v i + r i - 1)) % 4 := by
    exact Int.ModEq.sum fun i _ => Int.modEq_of_dvd <| by rcases hv1 i with ha | ha <;> rcases hr1 i with hb | hb <;> rw [ ha, hb ] <;> decide; ;
  simp_all +decide [ Finset.sum_add_distrib, Finset.sum_sub_distrib ];
  exact Int.dvd_of_emod_eq_zero ( h_dot_mod.trans ( Int.emod_eq_zero_of_dvd ( by exact dvd_sub ( dvd_add hv2 hr2 ) ( by decide ) ) ) )

lemma dotD_div4_of_isE8RootD (r v : Fin 8 → ℤ) (hr : IsE8RootD r) (hv : IsE8RootD v) :
    4 ∣ dotD v r := by
  rw [isE8RootD_iff_type1_or_type2_structural] at hr hv
  rcases hr with hr | hr <;> rcases hv with hv | hv
  · exact dotD_div4_type1_type1 r v hr hv
  · exact dotD_div4_type2_type1 r v hr hv
  · exact dotD_div4_type1_type2 r v hr hv
  · exact dotD_div4_type2_type2 r v hr hv

/-
Norm preservation under Weyl reflection: `normSqD (reflectD r v) = normSqD v`
whenever `normSqD r = 8` and `4 ∣ dotD v r`.

Proof: let c = dotD v r / 4.  Then
  normSqD (reflectD r v) = ∑ (v_i - c * r_i)²
    = normSqD v - 2c · dotD v r + c² · normSqD r
    = normSqD v - 2c · 4c + c² · 8
    = normSqD v - 8c² + 8c² = normSqD v.
-/
lemma normSqD_reflectD_eq (r v : Fin 8 → ℤ)
    (hnr : normSqD r = 8) (hd : 4 ∣ dotD v r) :
    normSqD (reflectD r v) = normSqD v := by
  unfold reflectD normSqD dotD at *;
  simp +decide only [mul_comm, sub_sq, Finset.sum_add_distrib, Finset.sum_sub_distrib];
  simp_all +decide [ mul_pow, ← Finset.mul_sum _ _ _, ← Finset.sum_mul, mul_assoc, mul_comm, mul_left_comm ];
  simp_all +decide [ ← mul_assoc, ← Finset.sum_mul _ _ _ ];
  cases hd ; simp_all +decide [ mul_assoc, mul_comm, mul_left_comm ];
  ring

/-
The sum of coordinates of `reflectD r v` satisfies the mod-4 condition.
Since `∑ v ≡ 0 mod 4` and `∑ r ≡ 0 mod 4`, and c = dotD v r / 4 is an integer,
we get `∑(v_i - c*r_i) = ∑v - c*∑r ≡ 0 - c*0 ≡ 0 mod 4`.
-/
lemma reflectD_sum_mod4 (r v : Fin 8 → ℤ)
    (hv_sum : (∑ i : Fin 8, v i) % 4 = 0)
    (hr_sum : (∑ i : Fin 8, r i) % 4 = 0)
    (hd : 4 ∣ dotD v r) :
    (∑ i : Fin 8, reflectD r v i) % 4 = 0 := by
  obtain ⟨ k, hk ⟩ := hd;
  unfold reflectD;
  unfold dotD; norm_num [ Finset.sum_add_distrib, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, hk ] ;
  exact dvd_sub ( Int.dvd_of_emod_eq_zero hv_sum ) ( by rw [ ← Finset.mul_sum _ _ _ ] ; exact dvd_mul_of_dvd_right ( Int.dvd_of_emod_eq_zero hr_sum ) _ )

/-
Parity preservation: if `r` and `v` both have uniform coordinate parity
(all even or all odd), then `reflectD r v` also has uniform coordinate parity.

Proof: let c = dotD v r / 4. Since r has uniform parity p_r, c*r_i all have the
same parity (= c*p_r mod 2). Then v_i - c*r_i all have the same parity since
v has uniform parity p_v.
-/
lemma reflectD_same_parity (r v : Fin 8 → ℤ)
    (hr_par : (∀ i : Fin 8, r i % 2 = 0) ∨ (∀ i : Fin 8, r i % 2 = 1))
    (hv_par : (∀ i : Fin 8, v i % 2 = 0) ∨ (∀ i : Fin 8, v i % 2 = 1))
    (hd : 4 ∣ dotD v r) :
    (∀ i : Fin 8, reflectD r v i % 2 = 0) ∨ (∀ i : Fin 8, reflectD r v i % 2 = 1) := by
  unfold reflectD;
  cases hr_par <;> cases hv_par <;> simp +decide [ *, Int.add_emod, Int.sub_emod, Int.mul_emod ];
  · grind +splitIndPred;
  · omega

/-! ## Main theorems -/

/-- **Main theorem**: Weyl reflection preserves the E8 root predicate.
Proved semantically from norm preservation, parity, and mod-4 sum conditions,
without using `reflectD_mem_rootList`, `reflectD_involutive_on_rootList`,
or `rootList.Forall` finite checks. -/
theorem reflectD_preserves_IsE8RootD_structural
    (r v : Fin 8 → Int) (hr : IsE8RootD r) (hv : IsE8RootD v) :
    IsE8RootD (reflectD r v) := by
  have hd : 4 ∣ dotD v r := dotD_div4_of_isE8RootD r v hr hv
  refine ⟨?_, ?_, ?_⟩
  · rw [normSqD_reflectD_eq r v hr.1 hd]; exact hv.1
  · exact reflectD_same_parity r v hr.2.1 hv.2.1 hd
  · exact reflectD_sum_mod4 r v hv.2.2 hr.2.2 hd

/-- List-level closure as a consequence of the semantic preservation theorem. -/
theorem reflectD_mem_rootList_structural
    (r v : Fin 8 → Int) (hr : r ∈ rootList) (hv : v ∈ rootList) :
    reflectD r v ∈ rootList := by
  exact (mem_rootList_iff_isE8RootD (reflectD r v)).2
    (reflectD_preserves_IsE8RootD_structural r v
      ((mem_rootList_iff_isE8RootD r).1 hr)
      ((mem_rootList_iff_isE8RootD v).1 hv))

end PhysicsSM.Algebra.Octonion.E8Root
