import Mathlib
import PhysicsSM.Algebra.Octonion.E8RootCompleteness

set_option linter.style.longLine false
set_option linter.style.setOption false
set_option linter.style.emptyLine false
set_option linter.style.refine false
set_option linter.style.whitespace false
set_option linter.unusedSimpArgs false
set_option linter.flexible false
set_option maxHeartbeats 800000

namespace PhysicsSM.Algebra.Octonion.E8Root

/-- Semantic type-I E8 root in doubled coordinates: two coordinates are
`+2` or `-2`, all others are zero. -/
def IsType1RootD (v : Fin 8 → Int) : Prop :=
  ∃ i j : Fin 8, i < j ∧
    ∃ si sj : Int,
      (si = 2 ∨ si = -2) ∧
      (sj = 2 ∨ sj = -2) ∧
      v = fun k => if k = i then si else if k = j then sj else 0

/-- Semantic type-II E8 root in doubled coordinates: all coordinates are
`+1` or `-1`, and the doubled-coordinate sum is congruent to `0` modulo `4`. -/
def IsType2RootD (v : Fin 8 → Int) : Prop :=
  (∀ i : Fin 8, v i = 1 ∨ v i = -1) ∧
  (Finset.univ.sum (fun i : Fin 8 => v i)) % 4 = 0

/-! ## Coordinate value lemmas -/

/-
An integer with |z| ≤ 2 and z even is in {-2, 0, 2}.
-/
lemma even_coord_values (z : ℤ) (habs : |z| ≤ 2) (heven : z % 2 = 0) :
    z = -2 ∨ z = 0 ∨ z = 2 := by
  rcases abs_le.mp habs with ⟨ h₁, h₂ ⟩ ; interval_cases z <;> trivial

/-
An integer with |z| ≤ 2 and z odd (z % 2 = 1) is in {-1, 1}.
-/
lemma odd_coord_values (z : ℤ) (habs : |z| ≤ 2) (hodd : z % 2 = 1) :
    z = -1 ∨ z = 1 := by
  rcases abs_le.mp habs with ⟨ h₁, h₂ ⟩ ; interval_cases z <;> trivial;

/-! ## Backward direction: Type1 or Type2 → IsE8RootD -/

/-
A type-1 root satisfies IsE8RootD.
-/
lemma type1_implies_isE8RootD (v : Fin 8 → ℤ) (h : IsType1RootD v) :
    IsE8RootD v := by
  obtain ⟨i, j, hij, si, sj, hsi, hsj, hv⟩ := h ; unfold IsE8RootD; simp_all +decide [ Finset.sum_ite ] ;
  rcases hsi with ( rfl | rfl ) <;> rcases hsj with ( rfl | rfl ) <;> simp +decide [ Finset.filter_eq', Finset.filter_ne' ];
  · fin_cases i <;> fin_cases j <;> simp +decide at hij ⊢;
  · fin_cases i <;> fin_cases j <;> trivial;
  · fin_cases i <;> fin_cases j <;> trivial;
  · fin_cases i <;> fin_cases j <;> trivial

/-
A type-2 root satisfies IsE8RootD.
-/
lemma type2_implies_isE8RootD (v : Fin 8 → ℤ) (h : IsType2RootD v) :
    IsE8RootD v := by
  refine' ⟨ _, _, _ ⟩ <;> simp_all +decide [ IsType2RootD ];
  · -- Since each component of v is either 1 or -1, squaring each component gives 1. Therefore, the sum of the squares is 8.
    have h_sq : ∀ i, v i ^ 2 = 1 := by
      exact fun i => by rcases h.1 i with ( h | h ) <;> norm_num [ h ] ;
    exact Eq.trans ( Finset.sum_congr rfl fun _ _ => h_sq _ ) ( by decide );
  · exact Or.inr fun i => by rcases h.1 i with ( h | h ) <;> norm_num [ h ] ;

/-! ## Forward direction helpers -/

/-
All-odd case of forward direction.
-/
lemma isE8RootD_all_odd_implies_type2 (v : Fin 8 → ℤ)
    (hnorm : normSqD v = 8)
    (hodd : ∀ i : Fin 8, v i % 2 = 1)
    (hmod : (∑ i : Fin 8, v i) % 4 = 0) :
    IsType2RootD v := by
  exact ⟨ fun i => by rcases odd_coord_values _ ( coordinate_abs_le_two_of_normSqD_eq_8 _ hnorm _ ) ( hodd i ) with h | h <;> simp +decide [ h ], hmod ⟩

/-! ## All-even case -/

/-
The number of nonzero coordinates equals 2 when all coords are in {-2,0,2}
    and the sum of squares is 8.
-/
lemma card_nonzero_eq_two (v : Fin 8 → ℤ)
    (hvals : ∀ i : Fin 8, v i = -2 ∨ v i = 0 ∨ v i = 2)
    (hnorm : normSqD v = 8) :
    (Finset.univ.filter (fun i : Fin 8 => v i ≠ 0)).card = 2 := by
  -- Since each nonzero coordinate contributes 4 to the sum, we can express the sum of squares as 4 times the number of nonzero coordinates.
  have hsum_eq : ∑ i, (v i) ^ 2 = 4 * (Finset.univ.filter (fun i => v i ≠ 0)).card := by
    rw [ Finset.card_filter ];
    push_cast [ Finset.mul_sum _ _ _ ] ; exact Finset.sum_congr rfl fun i hi => by rcases hvals i with h | h | h <;> norm_num [ h ] ;
  exact_mod_cast ( by linarith! : ( Finset.card ( Finset.filter ( fun i => v i ≠ 0 ) Finset.univ ) : ℤ ) = 2 )

/-
Given a 2-element subset of Fin 8, extract i < j with the rest zero.
-/
lemma exists_two_indices_from_filter (v : Fin 8 → ℤ)
    (hcard : (Finset.univ.filter (fun i : Fin 8 => v i ≠ 0)).card = 2) :
    ∃ i j : Fin 8, i < j ∧
      v i ≠ 0 ∧ v j ≠ 0 ∧
      ∀ k : Fin 8, k ≠ i → k ≠ j → v k = 0 := by
  have := Finset.card_eq_two.mp hcard;
  obtain ⟨ x, y, hxy, h ⟩ := this; cases lt_trichotomy x y <;> simp_all +decide [ Finset.ext_iff ] ;
  · exact ⟨ x, y, by assumption, Or.inl rfl, Or.inr rfl, fun k hk₁ hk₂ => by specialize h k; aesop ⟩;
  · grind

/-
All-even case of forward direction.
-/
lemma isE8RootD_all_even_implies_type1 (v : Fin 8 → ℤ)
    (hnorm : normSqD v = 8)
    (heven : ∀ i : Fin 8, v i % 2 = 0)
    (_hmod : (∑ i : Fin 8, v i) % 4 = 0) :
    IsType1RootD v := by
  have hv_nonzero : ∃ i j, i < j ∧ v i ≠ 0 ∧ v j ≠ 0 ∧ ∀ k, k ≠ i → k ≠ j → v k = 0 := by
    apply exists_two_indices_from_filter;
    apply card_nonzero_eq_two;
    · exact fun i => even_coord_values ( v i ) ( coordinate_abs_le_two_of_normSqD_eq_8 v hnorm i ) ( heven i );
    · exact hnorm;
  obtain ⟨ i, j, hij, hi, hj, hk ⟩ := hv_nonzero;
  use i, j, hij, v i, v j;
  have hv_values : ∀ k, v k = -2 ∨ v k = 0 ∨ v k = 2 := by
    exact fun k => even_coord_values ( v k ) ( coordinate_abs_le_two_of_normSqD_eq_8 v hnorm k ) ( heven k );
  grind

/-! ## Main theorem -/

/-
Forward direction of the semantic classification.
-/
lemma isE8RootD_implies_type1_or_type2 (v : Fin 8 → ℤ)
    (h : IsE8RootD v) :
    IsType1RootD v ∨ IsType2RootD v := by
  obtain ⟨hnorm, hparity⟩ := h
  rcases hparity.1 with h | h <;> [ left; right ] <;> [ exact isE8RootD_all_even_implies_type1 v hnorm h hparity.2; exact isE8RootD_all_odd_implies_type2 v hnorm h hparity.2 ]

/-
Backward direction.
-/
lemma type1_or_type2_implies_isE8RootD (v : Fin 8 → ℤ)
    (h : IsType1RootD v ∨ IsType2RootD v) :
    IsE8RootD v := by
  rcases h with h | h
  · exact type1_implies_isE8RootD v h
  · exact type2_implies_isE8RootD v h

end PhysicsSM.Algebra.Octonion.E8Root
