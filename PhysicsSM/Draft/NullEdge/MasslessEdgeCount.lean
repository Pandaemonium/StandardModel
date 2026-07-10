import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option grind.warning false

/-!
# Edge count is the mass classification (massless = 1 null edge, massive = 2)

A particle momentum is modelled as a real symmetric positive-semidefinite `2 × 2` matrix
`P` (the direction Gram / momentum bispinor).  A *null edge* is a rank-one PSD summand of
`P`, i.e. an outer product `v vᵀ = vecMulVec v v`.

We prove the exact dictionary between the mass class of `P` and its number of null edges,
where the edge count is literally the matrix rank:

* massless  ⟺  `det P = 0` (with `P ≠ 0`)  ⟺  `rank P = 1`  ⟺  exactly one null edge;
* massive   ⟺  `det P > 0`                 ⟺  `rank P = 2`  ⟺  two non-collinear null edges
  ⟺  `P` positive definite.

The squared mass `m² := det P` equals the squared Plücker "disagreement"
`(v₀ w₁ - v₁ w₀)²` of the two null edges in the massive case.
-/

namespace MasslessEdgeCount

open Matrix

/-- Real symmetric `2 × 2` momentum matrices. -/
abbrev Mat := Matrix (Fin 2) (Fin 2) ℝ

/-- A null edge built from a direction `v`: the rank-one PSD outer product `v vᵀ`. -/
def edge (v : Fin 2 → ℝ) : Mat := Matrix.vecMulVec v v

/-- The edge count of `P` is, by definition, its matrix rank. -/
noncomputable def edgeCount (P : Mat) : ℕ := P.rank

/-- `E` is a null edge iff it is an outer product `v vᵀ` (a rank-one PSD summand). -/
def IsNullEdge (E : Mat) : Prop := ∃ v : Fin 2 → ℝ, E = edge v

/-! ## Basic facts about single edges and rank -/

lemma edge_apply (v : Fin 2 → ℝ) (i j : Fin 2) : edge v i j = v i * v j := rfl

lemma rank_le_two (P : Mat) : P.rank ≤ 2 := by
  convert Matrix.rank_le_card_width P

lemma edge_posSemidef (v : Fin 2 → ℝ) : (edge v).PosSemidef := by
  constructor;
  · ext i j; simp +decide [ edge_apply, mul_comm ] ;
  · intro x
    simp [edge_apply];
    norm_num [ Finsupp.sum_fintype, Fin.sum_univ_two ];
    nlinarith [ sq_nonneg ( x 0 * v 0 + x 1 * v 1 ) ]

lemma edge_rank_le_one (v : Fin 2 → ℝ) : (edge v).rank ≤ 1 := by
  convert Matrix.rank_vecMulVec_le ( v ) v using 1

lemma edge_det (v : Fin 2 → ℝ) : (edge v).det = 0 := by
  unfold edge;
  norm_num [ Matrix.det_fin_two, vecMulVec ] ; ring!;

lemma isNullEdge_rank_le_one {E : Mat} (h : IsNullEdge E) : E.rank ≤ 1 := by
  obtain ⟨v, rfl⟩ := h; exact edge_rank_le_one v

/-
The determinant of a sum of two edges is the squared Plücker disagreement.
-/
lemma det_two_edges (v w : Fin 2 → ℝ) :
    (edge v + edge w).det = (v 0 * w 1 - v 1 * w 0) ^ 2 := by
      convert Matrix.det_fin_two ?_ using 1;
      simpa [ edge_apply ] using by ring;

/-! ## Rank ↔ determinant dictionary -/

lemma rank_eq_zero_iff_eq_zero (P : Mat) : P.rank = 0 ↔ P = 0 := by
  rw [ Matrix.rank ];
  constructor <;> intro h <;> simp_all +decide [ Submodule.eq_bot_iff ];
  exact Matrix.ext fun i j => by simpa using congr_fun ( h ( Pi.single j 1 ) ) i;

lemma rank_eq_two_iff_det_ne_zero (P : Mat) : P.rank = 2 ↔ P.det ≠ 0 := by
  constructor;
  · intro hP;
    contrapose! hP; have := Matrix.exists_mulVec_eq_zero_iff.mpr hP; simp_all +decide [ Matrix.rank ] ;
    have := LinearMap.finrank_range_add_finrank_ker ( mulVecLin P ) ; simp_all +decide ;
    linarith [ show 0 < Module.finrank ℝ ( LinearMap.ker ( mulVecLin P ) ) from Nat.pos_of_ne_zero ( by obtain ⟨ v, hv, hv' ⟩ := ‹∃ v : Fin 2 → ℝ, ¬v = 0 ∧ P *ᵥ v = 0›; exact ne_of_gt <| by exact Nat.pos_of_ne_zero <| by intro h; simp_all +decide [ Submodule.eq_bot_iff ] ) ];
  · intro h_det_ne_zero
    have h_inv : IsUnit P := by
      exact Matrix.isUnit_iff_isUnit_det _ |>.2 <| isUnit_iff_ne_zero.2 h_det_ne_zero;
    convert Matrix.rank_of_isUnit P h_inv

lemma rank_eq_one_iff (P : Mat) : P.rank = 1 ↔ P ≠ 0 ∧ P.det = 0 := by
  constructor <;> intro h;
  · exact ⟨ fun h' => by simp_all +decide, by simpa [ h ] using rank_eq_two_iff_det_ne_zero P |>.not.mp ( by aesop ) ⟩;
  · have := rank_eq_two_iff_det_ne_zero P;
    have := rank_le_two P; interval_cases _ : P.rank <;> simp_all +decide ;
    exact h.1 ( rank_eq_zero_iff_eq_zero P |>.1 ‹_› )

lemma posDef_iff_det_pos {P : Mat} (hP : P.PosSemidef) : P.PosDef ↔ 0 < P.det := by
  constructor;
  · exact fun a => PosDef.det_pos a;
  · intro h_pos;
    convert hP.posDef_iff_isUnit.mpr _;
    exact Matrix.isUnit_iff_isUnit_det _ |>.2 <| isUnit_iff_ne_zero.2 h_pos.ne'

/-! ## Existence of the edge decompositions (Cholesky-free, `IsSquare` witnesses) -/

/-- Every non-negative real is a square, via `IsSquare` (no analytic square-root function). -/
lemma exists_nonneg_sq {r : ℝ} (hr : 0 ≤ r) : ∃ k : ℝ, 0 ≤ k ∧ k * k = r := by
  obtain ⟨s, hs⟩ := Real.isSquare_iff.mpr hr
  exact ⟨|s|, abs_nonneg s, by rw [abs_mul_abs_self]; exact hs.symm⟩

/-- Every positive real is a square of a positive real (no analytic square-root function). -/
lemma exists_pos_sq {r : ℝ} (hr : 0 < r) : ∃ k : ℝ, 0 < k ∧ k * k = r := by
  obtain ⟨k, hk0, hk⟩ := exists_nonneg_sq hr.le
  refine ⟨k, ?_, hk⟩
  rcases hk0.lt_or_eq with h | h
  · exact h
  · subst h; simp at hk; exact absurd hk.symm hr.ne'

/-- A rank-one PSD matrix is a single non-zero null edge. -/
lemma psd_rank_one_exists_edge {P : Mat} (hP : P.PosSemidef) (h : P.rank = 1) :
    ∃ v : Fin 2 → ℝ, v ≠ 0 ∧ P = edge v := by
  have hdet : P.det = 0 := by rw [rank_eq_one_iff] at h; exact h.2
  have hne : P ≠ 0 := by rw [rank_eq_one_iff] at h; exact h.1
  have hsymm : P 1 0 = P 0 1 := by simpa using hP.1.apply 0 1
  have ha : 0 ≤ P 0 0 := hP.diag_nonneg
  have hc : 0 ≤ P 1 1 := hP.diag_nonneg
  have hac : P 0 0 * P 1 1 = P 0 1 * P 0 1 := by
    rw [Matrix.det_fin_two, hsymm] at hdet; linarith
  obtain ⟨k0, hk0nn, hk0⟩ := exists_nonneg_sq ha
  obtain ⟨k1, hk1nn, hk1⟩ := exists_nonneg_sq hc
  have hsq : (k0 * k1) * (k0 * k1) = |P 0 1| * |P 0 1| := by
    rw [abs_mul_abs_self, show (k0 * k1) * (k0 * k1) = (k0 * k0) * (k1 * k1) by ring,
      hk0, hk1, hac]
  have hkk : k0 * k1 = |P 0 1| := by
    rcases mul_self_eq_mul_self_iff.mp hsq with h | h
    · exact h
    · linarith [abs_nonneg (P 0 1), mul_nonneg hk0nn hk1nn]
  set vb : ℝ := if 0 ≤ P 0 1 then k1 else -k1 with hvb
  have e00 : P 0 0 = k0 * k0 := hk0.symm
  have e11 : P 1 1 = vb * vb := by
    rw [hvb]
    by_cases hb : 0 ≤ P 0 1
    · simp only [hb, if_true]; exact hk1.symm
    · simp only [hb, if_false]; rw [neg_mul_neg]; exact hk1.symm
  have e01 : P 0 1 = k0 * vb := by
    rw [hvb]; by_cases hb : 0 ≤ P 0 1 <;> simp only [hb, if_true, if_false]
    · rw [hkk, abs_of_nonneg hb]
    · push_neg at hb; have := abs_of_neg hb; linarith [hkk]
  have e10 : P 1 0 = k0 * vb := by rw [hsymm, e01]
  refine ⟨![k0, vb], ?_, ?_⟩
  · intro hv
    have e0 : k0 = 0 := by have := congr_fun hv 0; simpa using this
    have e1 : vb = 0 := by have := congr_fun hv 1; simpa using this
    apply hne
    have ha0 : P 0 0 = 0 := by rw [e00, e0]; ring
    have hc0 : P 1 1 = 0 := by rw [e11, e1]; ring
    have hb0 : P 0 1 = 0 := by rw [e01, e0]; ring
    ext i j; fin_cases i <;> fin_cases j <;> simp [ha0, hc0, hb0, hsymm]
  · ext i j; fin_cases i <;> fin_cases j <;>
      simp [edge, Matrix.vecMulVec_apply, e00, e01, e10, e11, mul_comm]

/-- A positive-determinant (positive-definite) PSD matrix splits into two
non-collinear null edges. -/
lemma psd_det_pos_exists_two {P : Mat} (hP : P.PosSemidef) (hdet : 0 < P.det) :
    ∃ v w : Fin 2 → ℝ, LinearIndependent ℝ ![v, w] ∧ P = edge v + edge w := by
      -- Let a = P 0 0, b = P 0 1, c = P 1 1. Since P PSD it is Hermitian, so P 1 0 = P 0 1 = b.
      set a := P 0 0
      set b := P 0 1
      set c := P 1 1
      have h_herm : P 1 0 = b := by
        exact hP.1.apply _ _ ▸ rfl;
      -- Since P is positive definite, a > 0 and det P = a*c - b*b > 0.
      have ha_pos : 0 < a := by
        contrapose! hdet; have := hP.2; simp_all +decide ;
        rw [ Matrix.det_fin_two ] ; have := this ( Finsupp.single 0 1 ) ; have := this ; simp_all +decide [ Finsupp.sum_single_index ] ;
        norm_num [ show P 0 0 = 0 by linarith ] at * ; nlinarith [ sq_nonneg ( P 0 1 ) ] ;
      have h_det_pos : 0 < a * c - b * b := by
        convert hdet using 1 ; rw [ Matrix.det_fin_two ] ; aesop;
      -- Let d = det P / a; since det P > 0 and a > 0, d > 0, and a*d = det P = a*c - b*b, so d = c - b*b/a.
      set d := (a * c - b * b) / a with hd
      have hd_pos : 0 < d := by
        exact div_pos h_det_pos ha_pos
      have hd_eq : d = c - b * b / a := by
        rw [ hd, sub_div, mul_div_cancel_left₀ _ ha_pos.ne' ];
      -- Cholesky factors k, ℓ with k*k = a and ℓ*ℓ = d, obtained via `exists_pos_sq`.
      obtain ⟨k, hk⟩ := exists_pos_sq ha_pos
      obtain ⟨ℓ, hℓ⟩ := exists_pos_sq hd_pos
      refine' ⟨ fun i => if i = 0 then k else b / k, fun i => if i = 0 then 0 else ℓ, _, _ ⟩ <;> simp_all +decide [ Fintype.linearIndependent_iff ];
      · intro g hg; have := congr_fun hg 0; have := congr_fun hg 1; simp_all +decide [ ne_of_gt ] ;
      · ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ *, edge_apply ] ; ring;
        · rw [ mul_div_cancel₀ _ hk.1.ne' ];
        · rw [ div_mul_cancel₀ _ hk.1.ne' ];
        · grind

/-! ## Lower/upper bounds for the number of edges -/

/-
Matrix rank is subadditive.
-/
lemma matrix_rank_add_le (A B : Mat) : (A + B).rank ≤ A.rank + B.rank := by
  rw [ Matrix.rank, Matrix.rank, Matrix.rank ];
  rw [ ← Submodule.finrank_sup_add_finrank_inf_eq ];
  exact le_add_right ( Submodule.finrank_mono <| by aesop_cat )

/-
Any representation of `P` as `n` null edges has `n ≥ rank P` (rank subadditivity).
-/
lemma rank_le_of_sum_edges (P : Mat) (n : ℕ) (e : Fin n → Mat)
    (he : ∀ i, IsNullEdge (e i)) (hsum : P = ∑ i, e i) : P.rank ≤ n := by
      subst P;
      induction' n with n ih;
      · norm_num +zetaDelta at *;
      · convert le_trans ( matrix_rank_add_le _ _ ) ( add_le_add ( ih _ fun i => he ( Fin.castSucc i ) ) ( isNullEdge_rank_le_one ( he ( Fin.last n ) ) ) ) using 1;
        rw [ Fin.sum_univ_castSucc ]

/-! ## Headline theorems -/

/-- **Massless = one null edge.** For a non-zero PSD momentum `P`:
`det P = 0` ⟺ `rank P = 1` ⟺ `P` is a single non-zero null edge `v vᵀ`. -/
theorem massless_iff_one_edge {P : Mat} (hP : P.PosSemidef) (hne : P ≠ 0) :
    (P.det = 0 ↔ P.rank = 1) ∧
      (P.rank = 1 ↔ ∃ v : Fin 2 → ℝ, v ≠ 0 ∧ P = edge v) := by
  constructor
  · rw [rank_eq_one_iff]
    exact ⟨fun h => ⟨hne, h⟩, fun h => h.2⟩
  · constructor
    · intro h; exact psd_rank_one_exists_edge hP h
    · rintro ⟨v, hv, rfl⟩
      rw [rank_eq_one_iff]
      refine ⟨by simpa using hne, edge_det v⟩

/-
**Massive = two non-collinear null edges.** For a PSD momentum `P`:
`0 < det P` ⟺ `rank P = 2` ⟺ `P = v vᵀ + w wᵀ` with `v, w` linearly independent ⟺
`P` positive definite.
-/
theorem massive_iff_two_edges {P : Mat} (hP : P.PosSemidef) :
    (0 < P.det ↔ P.rank = 2) ∧
      (P.rank = 2 ↔ ∃ v w : Fin 2 → ℝ, LinearIndependent ℝ ![v, w] ∧ P = edge v + edge w) ∧
      (P.rank = 2 ↔ P.PosDef) := by
        refine' ⟨ _, _, _ ⟩;
        · constructor <;> intro h;
          · grind +suggestions;
          · exact lt_of_le_of_ne ( hP.det_nonneg ) ( Ne.symm <| by intro H; have := rank_eq_two_iff_det_ne_zero P; aesop );
        · constructor;
          · intro h;
            convert psd_det_pos_exists_two hP _;
            exact lt_of_le_of_ne ( hP.det_nonneg ) ( Ne.symm <| by intro H; have := rank_eq_two_iff_det_ne_zero P; aesop );
          · intro h
            obtain ⟨v, w, h_lin_ind, h_eq⟩ := h
            have h_det_pos : 0 < P.det := by
              rw [ h_eq, det_two_edges ];
              contrapose! h_lin_ind;
              rw [ Fintype.not_linearIndependent_iff ];
              by_cases hv : v = 0 <;> by_cases hw : w = 0 <;> simp_all +decide [ funext_iff, Fin.forall_fin_two ];
              · exact ⟨ fun _ => 1, by norm_num ⟩;
              · exact ⟨ fun i => if i = 0 then 1 else 0, by simp +decide ⟩;
              · exact ⟨ fun i => if i = 0 then 0 else 1, by aesop ⟩;
              · by_cases hv0 : v 0 = 0 <;> by_cases hw0 : w 0 = 0 <;> simp_all +decide [ sub_eq_iff_eq_add ];
                · exact ⟨ fun i => if i = 0 then -w 1 else v 1, by simp +decide ; ring, by simp +decide [ hv, hw ] ⟩;
                · exact ⟨ fun i => if i = 0 then -w 0 else v 0, by simp +decide [ *, mul_comm ], by simp +decide [ * ] ⟩;
            grind +suggestions;
        · rw [ posDef_iff_det_pos hP, rank_eq_two_iff_det_ne_zero ];
          exact ⟨ fun h => lt_of_le_of_ne ( hP.det_nonneg ) ( Ne.symm h ), fun h => ne_of_gt h ⟩

/-
**Edge count is the rank, and it is the minimal number of null edges.**
`edgeCount P = rank P`; any decomposition into `n` null edges has `n ≥ rank P`; and the
value `rank P` is achieved by an explicit decomposition.
-/
theorem edge_count_eq_rank {P : Mat} (hP : P.PosSemidef) :
    edgeCount P = P.rank ∧
      (∀ (n : ℕ) (e : Fin n → Mat), (∀ i, IsNullEdge (e i)) → P = ∑ i, e i → P.rank ≤ n) ∧
      (∃ e : Fin P.rank → Mat, (∀ i, IsNullEdge (e i)) ∧ P = ∑ i, e i) := by
        refine' ⟨ rfl, rank_le_of_sum_edges P, _ ⟩;
        by_cases h : P.rank = 0;
        · rw [ rank_eq_zero_iff_eq_zero ] at h;
          use fun _ => 0; aesop;
        · by_cases h' : P.rank = 1;
          · obtain ⟨ v, hv ⟩ := psd_rank_one_exists_edge hP h';
            refine' ⟨ fun _ => edge v, _, _ ⟩ <;> simp_all +decide [ IsNullEdge ];
          · obtain ⟨ v, w, h₁, h₂ ⟩ := psd_det_pos_exists_two hP ( by
              grind +suggestions );
            have h_rank : P.rank = 2 := by
              exact le_antisymm ( rank_le_two P ) ( Nat.lt_of_le_of_ne ( Nat.pos_of_ne_zero h ) ( Ne.symm h' ) );
            rw [ h_rank ];
            exact ⟨ fun i => if i = 0 then edge v else edge w, fun i => by fin_cases i <;> [ exact ⟨ v, rfl ⟩ ; exact ⟨ w, rfl ⟩ ], by simp +decide [ Fin.sum_univ_two, h₂ ] ⟩

/-
**All mass comes from the null edges.** With `m² := det P`: it vanishes exactly when
`P` has at most one edge (massless / trivial), is positive exactly when `P` has two edges
(massive), and in the two-edge case equals the squared Plücker disagreement of the edges.
-/
theorem mass_from_edges {P : Mat} (hP : P.PosSemidef) :
    (P.det = 0 ↔ P.rank ≤ 1) ∧
      (0 < P.det ↔ P.rank = 2) ∧
      (∀ v w : Fin 2 → ℝ, P = edge v + edge w →
        P.det = (v 0 * w 1 - v 1 * w 0) ^ 2) := by
          grind +suggestions

/-! ## Mandatory non-degeneracy witnesses (explicit rationals) -/

/-
Massless witness `P = (1,0)(1,0)ᵀ = !![1,0;0,0]`: PSD, `det = 0`, `rank = 1`, one edge.
-/
theorem massless_witness :
    (!![(1:ℝ), 0; 0, 0]).PosSemidef ∧
      (!![(1:ℝ), 0; 0, 0]).det = 0 ∧
      (!![(1:ℝ), 0; 0, 0]).rank = 1 ∧
      (!![(1:ℝ), 0; 0, 0]) = edge ![1, 0] := by
        refine' ⟨ _, _, _, _ ⟩ <;> norm_num [ Matrix.det_fin_two, Matrix.rank ];
        · constructor;
          · ext i j ; fin_cases i <;> fin_cases j <;> rfl;
          · norm_num [ Finsupp.sum_fintype, Fin.sum_univ_succ ];
            exact fun x => mul_self_nonneg _;
        · -- The range of this matrix is spanned by the single vector (1, 0).
          have h_range : LinearMap.range (Matrix.mulVecLin !![1, 0; 0, 0]) = Submodule.span ℝ { ![1, 0] } := by
            ext x;
            simp +decide [ Submodule.mem_span_singleton, funext_iff, Fin.forall_fin_two ];
            exact fun h => ⟨ Matrix.vecCons ( x 0 ) 0, rfl ⟩;
          rw [ h_range, finrank_span_singleton ] ; norm_num;
        · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ edge ]

/-
Massive witness `v = (1,0)`, `w = (3/5, 4/5)`,
`P = !![34/25, 12/25; 12/25, 16/25]`: PSD, `det = 16/25 > 0`, `rank = 2`, two independent edges.
-/
theorem massive_witness :
    (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).PosSemidef ∧
      (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).det = 16/25 ∧
      0 < (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).det ∧
      (!![(34:ℝ)/25, 12/25; 12/25, 16/25]).rank = 2 ∧
      (!![(34:ℝ)/25, 12/25; 12/25, 16/25]) = edge ![1, 0] + edge ![3/5, 4/5] := by
        norm_num [ Matrix.det_fin_two ];
        constructor;
        · constructor;
          · ext i j ; fin_cases i <;> fin_cases j <;> rfl;
          · simp +decide [ Finsupp.sum_fintype, Fin.sum_univ_two ];
            exact fun x => by nlinarith [ sq_nonneg ( x 0 + x 1 ), sq_nonneg ( x 0 - x 1 ) ] ;
        · constructor;
          · convert rank_eq_two_iff_det_ne_zero _ |>.2 _ using 1 ; norm_num [ Matrix.det_fin_two ];
          · ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ edge ]

/-! ## Kernel-checked axiom footprints of the headline results -/

/-- info: 'MasslessEdgeCount.massless_iff_one_edge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_iff_one_edge

/-- info: 'MasslessEdgeCount.massive_iff_two_edges' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massive_iff_two_edges

/-- info: 'MasslessEdgeCount.edge_count_eq_rank' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms edge_count_eq_rank

/-- info: 'MasslessEdgeCount.mass_from_edges' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mass_from_edges

/-- info: 'MasslessEdgeCount.massless_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_witness

/-- info: 'MasslessEdgeCount.massive_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massive_witness

end MasslessEdgeCount
