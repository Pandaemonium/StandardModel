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

namespace MasslessEdgeCount

open Matrix

/-- An `edge` is the outer product (rank ≤ 1, PSD) `v vᵀ` of a real 2-vector with itself. -/
noncomputable def edge (v : Fin 2 → ℝ) : Matrix (Fin 2) (Fin 2) ℝ := Matrix.vecMulVec v v

/-! ## Basic facts about `edge` -/

/-- The outer product `v vᵀ` is positive semidefinite. -/
lemma edge_posSemidef (v : Fin 2 → ℝ) : (edge v).PosSemidef := by
  have h : edge v = (replicateCol Unit v) * (replicateCol Unit v)ᴴ := by
    rw [edge, Matrix.vecMulVec_eq Unit, Matrix.conjTranspose_replicateCol]
    simp
  rw [h]
  exact Matrix.posSemidef_self_mul_conjTranspose _

/-
The determinant of a sum of two edges is the squared "disagreement"
`(v₀ w₁ - v₁ w₀)²` (a Gram/cross-product determinant).
-/
lemma edge_add_det (v w : Fin 2 → ℝ) :
    (edge v + edge w).det = (v 0 * w 1 - v 1 * w 0) ^ 2 := by
  convert Matrix.det_fin_two _;
  unfold edge; norm_num [ Matrix.vecMulVec ] ; ring;

/-
An edge with nonzero generating vector is a nonzero matrix.
-/
lemma edge_ne_zero {v : Fin 2 → ℝ} (hv : v ≠ 0) : edge v ≠ 0 := by
  simp_all +decide [ funext_iff, Fin.forall_fin_two, edge ]

/-! ## Rank facts for real `2×2` matrices -/

/-
A `2×2` real matrix with nonzero determinant has full rank `2`.
-/
lemma rank_eq_two_of_det_ne {P : Matrix (Fin 2) (Fin 2) ℝ} (h : P.det ≠ 0) : P.rank = 2 := by
  convert Matrix.rank_of_isUnit P ?_;
  rw [ Matrix.isUnit_iff_isUnit_det ] ; simp +decide [ h ]

/-
A `2×2` real matrix with zero determinant has rank at most `1`.
-/
lemma rank_le_one_of_det_eq_zero {P : Matrix (Fin 2) (Fin 2) ℝ} (h : P.det = 0) :
    P.rank ≤ 1 := by
  by_contra! h_contra;
  -- Since $P$ is a $2 \times 2$ matrix with rank greater than $1$, it must have full rank.
  have h_full_rank : P.rank = 2 := by
    exact le_antisymm ( le_trans ( Matrix.rank_le_card_width _ ) ( by norm_num ) ) h_contra;
  rw [ Matrix.rank ] at h_full_rank;
  have := LinearMap.finrank_range_add_finrank_ker ( Matrix.mulVecLin P ) ; simp_all +decide;
  simp_all +decide [ Submodule.eq_bot_iff ];
  exact absurd ( Matrix.exists_mulVec_eq_zero_iff.mpr h ) ( by tauto )

/-
A nonzero matrix has positive rank.
-/
lemma rank_pos_of_ne_zero {P : Matrix (Fin 2) (Fin 2) ℝ} (h : P ≠ 0) : 1 ≤ P.rank := by
  by_contra! h' ; simp_all +decide [ Matrix.rank, Submodule.eq_bot_iff ];
  exact h ( Matrix.ext fun i j => by simpa using congr_fun ( h' ( Pi.single j 1 ) ) i )

/-- An edge with nonzero generating vector has rank exactly `1`. -/
lemma edge_rank_eq_one {v : Fin 2 → ℝ} (hv : v ≠ 0) : (edge v).rank = 1 := by
  have hle : (edge v).rank ≤ 1 := Matrix.rank_vecMulVec_le v v
  have hge : 1 ≤ (edge v).rank := rank_pos_of_ne_zero (edge_ne_zero hv)
  omega

/-
Concrete rank-one decomposition: a symmetric PSD-shaped `2×2` block of the form
`!![a,b;b,c]` with `a,c ≥ 0`, `b² = a c` and not all-zero is an `edge`.
-/
lemma exists_edge_of_entries (a b c : ℝ) (ha : 0 ≤ a) (hc : 0 ≤ c)
    (hbac : b ^ 2 = a * c) (hne : ¬ (a = 0 ∧ b = 0 ∧ c = 0)) :
    ∃ v : Fin 2 → ℝ, v ≠ 0 ∧ !![a, b; b, c] = edge v := by
  by_cases ha0 : a = 0;
  · simp_all +decide [ edge ];
    refine' ⟨ fun i => if i = 0 then 0 else Real.sqrt c, _, _ ⟩ <;> norm_num [ funext_iff, Fin.forall_fin_two, vecMulVec ];
    · positivity;
    · rw [ Real.mul_self_sqrt hc ];
  · refine' ⟨ fun i => if i = 0 then Real.sqrt a else b / Real.sqrt a, _, _ ⟩ <;> simp_all +decide [ funext_iff, Fin.forall_fin_two ];
    ext i j ; fin_cases i <;> fin_cases j <;> norm_num [ edge, Matrix.vecMulVec ] <;> ring_nf;
    · rw [ Real.sq_sqrt ha ];
    · rw [ mul_right_comm, mul_inv_cancel₀ ( ne_of_gt ( Real.sqrt_pos.mpr ( lt_of_le_of_ne ha ( Ne.symm ha0 ) ) ) ), one_mul ];
    · rw [ mul_assoc, mul_inv_cancel₀ ( ne_of_gt ( Real.sqrt_pos.mpr ( lt_of_le_of_ne ha ( Ne.symm ha0 ) ) ) ), mul_one ];
    · grind

/-
A rank-one PSD `2×2` matrix is an edge.
-/
lemma exists_edge_of_rank_one {P : Matrix (Fin 2) (Fin 2) ℝ} (hP : P.PosSemidef)
    (h : P.rank = 1) : ∃ v ≠ (0 : Fin 2 → ℝ), P = edge v := by
  -- Since P is a 2x2 symmetric matrix with rank 1, it must be of the form !![a,b;b,c] with a*c = b^2 and a,c ≥ 0.
  obtain ⟨a, b, c, ha, hb, hc, hbc⟩ : ∃ a b c : ℝ, P = !![a, b; b, c] ∧ 0 ≤ a ∧ 0 ≤ c ∧ b ^ 2 = a * c := by
    obtain ⟨a, b, c, ha, hb, hc⟩ : ∃ a b c : ℝ, P = !![a, b; b, c] ∧ 0 ≤ a ∧ 0 ≤ c := by
      use P 0 0, P 0 1, P 1 1;
      refine' ⟨ _, _, _ ⟩;
      · ext i j; fin_cases i <;> fin_cases j <;> norm_num;
        exact hP.1.apply 1 0 ▸ rfl;
      · exact PosSemidef.diag_nonneg hP
      · exact PosSemidef.diag_nonneg hP
    have h_det : P.det = 0 := by
      contrapose! h;
      rw [ rank_eq_two_of_det_ne h ] ; norm_num;
    exact ⟨ a, b, c, ha, hb, hc, by norm_num [ ha, Matrix.det_fin_two ] at h_det; linarith ⟩;
  by_cases h : a = 0 ∧ b = 0 ∧ c = 0;
  · simp_all +decide [ show P = 0 from by ext i j; fin_cases i <;> fin_cases j <;> aesop ];
  · exact ha ▸ exists_edge_of_entries a b c hb hc hbc h

/-! ## Main theorems -/

/-- One edge corresponds to rank `1`: a single nonzero edge has rank exactly `1`. -/
theorem edge_count_eq_rank {v : Fin 2 → ℝ} (hv : v ≠ 0) : (edge v).rank = 1 :=
  edge_rank_eq_one hv

/-- The mass-squared read off from a two-edge decomposition equals the determinant,
which is the squared disagreement `(v₀ w₁ - v₁ w₀)²`. -/
theorem mass_from_edges (v w : Fin 2 → ℝ) :
    (edge v + edge w).det = (v 0 * w 1 - v 1 * w 0) ^ 2 :=
  edge_add_det v w

/-- Massless ⟺ rank `1` ⟺ one (null) edge, for a nonzero PSD `2×2` matrix. -/
theorem massless_iff_one_edge {P : Matrix (Fin 2) (Fin 2) ℝ}
    (hP : P.PosSemidef) (hne : P ≠ 0) :
    (P.det = 0 ↔ P.rank = 1) ∧ (P.rank = 1 ↔ ∃ v ≠ (0 : Fin 2 → ℝ), P = edge v) := by
  refine ⟨⟨?_, ?_⟩, ?_, ?_⟩
  · intro hd
    have h1 := rank_le_one_of_det_eq_zero hd
    have h2 := rank_pos_of_ne_zero hne
    omega
  · intro hr
    by_contra hd
    have := rank_eq_two_of_det_ne hd
    omega
  · intro hr
    exact exists_edge_of_rank_one hP hr
  · rintro ⟨v, hv, rfl⟩
    exact edge_rank_eq_one hv

/-- Massive ⟺ rank `2` ⟺ positive definite, for a PSD `2×2` matrix; the mass-squared is
the (positive) determinant. -/
theorem massive_iff_two_edges {P : Matrix (Fin 2) (Fin 2) ℝ} (hP : P.PosSemidef) :
    (0 < P.det ↔ P.rank = 2) ∧ (0 < P.det ↔ P.PosDef) ∧ (P.rank = 2 ↔ P.PosDef) := by
  have hnn : 0 ≤ P.det := hP.det_nonneg
  have hdetPosDef : 0 < P.det ↔ P.PosDef := by
    constructor
    · intro hpos
      have hne : P.det ≠ 0 := ne_of_gt hpos
      have : IsUnit P := (Matrix.isUnit_iff_isUnit_det P).mpr (isUnit_iff_ne_zero.mpr hne)
      exact (hP.posDef_iff_isUnit).mpr this
    · intro hpd
      exact hpd.det_pos
  have hdetRank : 0 < P.det ↔ P.rank = 2 := by
    constructor
    · intro hpos
      exact rank_eq_two_of_det_ne (ne_of_gt hpos)
    · intro hr
      rcases lt_or_eq_of_le hnn with h | h
      · exact h
      · exfalso
        have := rank_le_one_of_det_eq_zero h.symm
        omega
  exact ⟨hdetRank, hdetPosDef, by rw [← hdetRank, hdetPosDef]⟩

/-! ## Non-degeneracy witnesses -/

/-- Massless witness: `!![1,0;0,0]` is PSD, singular (det `0`), rank `1`, and a single edge. -/
theorem massless_witness :
    let P0 : Matrix (Fin 2) (Fin 2) ℝ := !![1, 0; 0, 0]
    P0.PosSemidef ∧ P0.det = 0 ∧ P0.rank = 1 ∧ P0 = edge ![1, 0] := by
  intro P0
  have hdecomp : P0 = edge ![1, 0] := by
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [P0, edge, Matrix.vecMulVec]
  have hP0 : P0.PosSemidef := by rw [hdecomp]; exact edge_posSemidef _
  have hdet0 : P0.det = 0 := by simp [P0, Matrix.det_fin_two_of]
  have hne0 : P0 ≠ 0 := by
    intro h
    have : (P0 0 0 : ℝ) = 0 := by rw [h]; rfl
    simp [P0] at this
  have hrank : P0.rank = 1 := ((massless_iff_one_edge hP0 hne0).1).mp hdet0
  exact ⟨hP0, hdet0, hrank, hdecomp⟩

/-- Massive witness: `!![34/25,12/25;12/25,16/25]` is PSD, has positive det `16/25`,
rank `2`, and decomposes into two edges. -/
theorem massive_witness :
    let P1 : Matrix (Fin 2) (Fin 2) ℝ := !![34/25, 12/25; 12/25, 16/25]
    P1.PosSemidef ∧ P1.det = 16/25 ∧ 0 < P1.det ∧ P1.rank = 2 ∧
      P1 = edge ![1, 0] + edge ![3/5, 4/5] := by
  intro P1
  have hdecomp : P1 = edge ![1, 0] + edge ![3/5, 4/5] := by
    ext i j; fin_cases i <;> fin_cases j <;>
      simp [P1, edge, Matrix.vecMulVec] <;> norm_num
  have hP1 : P1.PosSemidef := by
    rw [hdecomp]; exact (edge_posSemidef _).add (edge_posSemidef _)
  have hdet : P1.det = 16/25 := by simp [P1, Matrix.det_fin_two_of]; norm_num
  have hdetpos : 0 < P1.det := by rw [hdet]; norm_num
  have hrank : P1.rank = 2 := ((massive_iff_two_edges hP1).1).mp hdetpos
  exact ⟨hP1, hdet, hdetpos, hrank, hdecomp⟩

/-! ## Axiom footprint pins -/

/-- info: 'MasslessEdgeCount.edge_count_eq_rank' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms edge_count_eq_rank

/-- info: 'MasslessEdgeCount.mass_from_edges' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms mass_from_edges

/-- info: 'MasslessEdgeCount.massless_iff_one_edge' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_iff_one_edge

/-- info: 'MasslessEdgeCount.massive_iff_two_edges' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massive_iff_two_edges

/-- info: 'MasslessEdgeCount.massless_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massless_witness

/-- info: 'MasslessEdgeCount.massive_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms massive_witness

end MasslessEdgeCount
