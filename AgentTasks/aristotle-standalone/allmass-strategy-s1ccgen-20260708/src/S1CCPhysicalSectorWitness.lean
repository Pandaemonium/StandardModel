/-
# S1-CC: an explicit physical-sector witness (MEMO → M for kill-condition K-B)

DRAFT (kernel-clean; no `s o r r y`). This file converts
the numeric-oracle kill condition **K-B** of `S1CC_RESOLUTION.md` (the `6×6`
witness with `sig(J Q_C|_{V'/N}) = (2,2,0)`, previously PASSED by
`probe_s1cc_balanced_inertia.py`) into a kernel-checked statement.

The carrier is `H = ℂ⁶ = (Fin 2) × (Fin 3)` (Clifford ⊗ color). Everything is
coordinate-aligned so that `V' = ker Q_G`, `N = range Q_G` and the coset
representatives `V'/N` are axis subspaces, and the induced Krein form on `V'/N`
is literally a `submatrix` of `J Q_C`.

Design and no-go analysis: `S1CC_MEMO_TO_M_STRATEGY.md`.
Abstract balance engine reused here: `S1CCBalancedInertia.lean`.

## Claim boundary

Finite explicit matrices. The abstract balance mechanism
(`hermitian_balanced_count_of_neg_charpoly`) is already M and is only *applied*
here. This file adds the concrete instantiation that was MEMO: an explicit
carrier realizing all hypotheses on the physical sector, with the compressed
form provably Hermitian, `b̄`-anticonjugated, nondegenerate and indefinite,
hence balanced with inertia `(2,2,0)` — never positive.
-/

import Mathlib
import PhysicsSM.Draft.NullEdge.GateYM.S1CCBalancedInertia

namespace PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness

open Matrix
open scoped Kronecker

noncomputable section

/-! ## The carrier and its operators -/

/-- Clifford `σx`. -/
def sx : Matrix (Fin 2) (Fin 2) ℂ := !![0,1;1,0]
/-- Clifford `σz` — the closure grading generator on the Clifford leg. -/
def sz : Matrix (Fin 2) (Fin 2) ℂ := !![1,0;0,-1]
/-- Single null covector `E₀₁` (the Gupta–Bleuler "half constraint"). -/
def c1 : Matrix (Fin 2) (Fin 2) ℂ := !![0,1;0,0]
/-- Closure commutator `K` on the color leg (skew-Hermitian). -/
def Kc : Matrix (Fin 3) (Fin 3) ℂ := !![0,1,0;-1,0,0;0,0,0]
/-- Gauss operator `G = diag(0,0,1)` (Hermitian). -/
def Gc : Matrix (Fin 3) (Fin 3) ℂ := !![0,0,0;0,0,0;0,0,1]

/-- Nilpotent Gauss charge `Q_G = c₁ ⊗ G`. -/
def QG : Matrix (Fin 2 × Fin 3) (Fin 2 × Fin 3) ℂ := c1 ⊗ₖ Gc
/-- Closure Krein form `J Q_C = (σx·σz) ⊗ K` on the full carrier (Hermitian). -/
def JQc : Matrix (Fin 2 × Fin 3) (Fin 2 × Fin 3) ℂ := (sx * sz) ⊗ₖ Kc
/-- Closure bivector grading `b = σz ⊗ 1`. -/
def bg : Matrix (Fin 2 × Fin 3) (Fin 2 × Fin 3) ℂ := sz ⊗ₖ (1 : Matrix (Fin 3) (Fin 3) ℂ)

/-! ## Structural facts on the full carrier -/

/-- `[G,K] = 0`: descent (Theorem 1 of the resolution) holds for this carrier. -/
theorem GK_comm : Gc * Kc = Kc * Gc := by
  unfold Gc Kc; ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_three]

/-- `Q_G² = 0`: the Gauss charge is nilpotent. -/
theorem QG_nilpotent : QG * QG = 0 := by
  unfold QG
  rw [← Matrix.mul_kronecker_mul]
  have : c1 * c1 = 0 := by
    unfold c1; ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two]
  rw [this, Matrix.zero_kronecker]

/-- `J Q_C` is Hermitian (skew ⊗ skew). -/
theorem JQc_hermitian : JQc.IsHermitian := by
  unfold Matrix.IsHermitian JQc
  rw [Matrix.conjTranspose_kronecker]
  have h1 : (sx * sz)ᴴ = -(sx*sz) := by
    unfold sx sz; ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.conjTranspose]
  have h2 : Kcᴴ = -Kc := by
    unfold Kc; ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.conjTranspose]
  rw [h1, h2]; ext ⟨a,i⟩ ⟨b,j⟩; simp [kroneckerMap]

/-- `b² = 1`, so `b` is an involution (hence invertible with `b⁻¹ = b`). -/
theorem bg_sq : bg * bg = 1 := by
  unfold bg
  rw [← Matrix.mul_kronecker_mul, Matrix.mul_one]
  have : sz * sz = 1 := by
    unfold sz; ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two]
  rw [this, Matrix.one_kronecker_one]

/-- **Full-carrier anticonjugation** `b⁻¹ (J Q_C) b = -(J Q_C)` (using `b⁻¹=b`). -/
theorem bg_anticonj : bg * JQc * bg = -JQc := by
  unfold bg JQc
  rw [← Matrix.mul_kronecker_mul, ← Matrix.mul_kronecker_mul, Matrix.one_mul,
    Matrix.mul_one]
  have h1 : sz * (sx*sz) * sz = -(sx*sz) := by
    unfold sx sz; ext i j; fin_cases i <;> fin_cases j <;>
      simp [Matrix.mul_apply, Fin.sum_univ_two]
  rw [h1]; ext ⟨a,i⟩ ⟨b,j⟩; simp [kroneckerMap]

/-- **Descent / radical fact.** The `N`-generator index `(0,2)` pairs trivially
with the whole carrier under `J Q_C` (row 2 and column 2 of `K` vanish). Hence
`N = range Q_G` lies in the radical of `J Q_C|_{V'}`, so the induced form on the
quotient `V'/N` is well-defined and equals the `submatrix` compression below. -/
theorem N_in_radical (p : Fin 2 × Fin 3) :
    JQc (0,2) p = 0 ∧ JQc p (0,2) = 0 := by
  constructor <;>
  · obtain ⟨b, j⟩ := p
    unfold JQc Kc; fin_cases b <;> fin_cases j <;>
      simp [kroneckerMap, Matrix.mul_apply, Fin.sum_univ_two]

/-! ## The compressed form on the physical sector `V'/N`

`V' = ker Q_G` and `N = range Q_G` are coordinate-aligned:
`Q_G = E_{(0,2),(1,2)}` (single matrix unit), so `V'` is all axes except
`(1,2)` (dim 5), `N = span e_{(0,2)}` (dim 1), and the coset representatives are
the four axes `(0,0),(0,1),(1,0),(1,1)` (= `ker G ⊕ ker G`).  -/

/-- Coset representatives of `V'/N`. -/
def r : Fin 4 → Fin 2 × Fin 3 := ![(0,0),(0,1),(1,0),(1,1)]

/-! ### The Gauss constraint `Q_G` is the matrix unit `E_{(0,2),(1,2)}`

These lemmas certify — at the vector and submodule level — that the physical
sector `V'` really is `ker Q_G` and the null direction `N` really is
`range Q_G`, closing the by-inspection gap in the coset construction above.
`Q_G = c₁ ⊗ Gc` with `c₁ = E_{01}` and `Gc = diag(0,0,1)`, so its only nonzero
entry is at row `(0,2)`, column `(1,2)`. -/

/-- **`Q_G` is the single matrix unit `E_{(0,2),(1,2)}`.** Its only nonzero entry
is a `1` at row `(0,2)`, column `(1,2)`. -/
theorem QG_apply (p q : Fin 2 × Fin 3) :
    QG p q =
      if p = ((0:Fin 2),(2:Fin 3)) ∧ q = ((1:Fin 2),(2:Fin 3)) then 1 else 0 := by
  obtain ⟨a, i⟩ := p; obtain ⟨b, j⟩ := q
  fin_cases a <;> fin_cases i <;> fin_cases b <;> fin_cases j <;>
    simp [QG, kroneckerMap, c1, Gc]

/-- The `q`-th column of `Q_G`: it is `e_{(0,2)}` when `q = (1,2)` and `0`
otherwise. -/
theorem QG_col_eq (q : Fin 2 × Fin 3) :
    QG.col q =
      if q = ((1:Fin 2),(2:Fin 3)) then Pi.single ((0:Fin 2),(2:Fin 3)) 1 else 0 := by
  ext p; obtain ⟨a, i⟩ := p
  fin_cases a <;> fin_cases i <;>
    simp [Matrix.col, QG_apply, Pi.single] <;>
    (obtain ⟨b, j⟩ := q; fin_cases b <;> fin_cases j <;> simp)

/-- Action of `Q_G` on any vector: it reads off the `(1,2)`-coordinate and
deposits it on the `(0,2)`-axis, `Q_G v = v_{(1,2)} · e_{(0,2)}`. -/
theorem QG_mulVec_eq (v : Fin 2 × Fin 3 → ℂ) :
    QG.mulVec v = Pi.single ((0:Fin 2),(2:Fin 3)) (v ((1:Fin 2),(2:Fin 3))) := by
  ext p; obtain ⟨a, i⟩ := p
  fin_cases a <;> fin_cases i <;>
    simp [Matrix.mulVec, dotProduct, QG_apply, Pi.single, Function.update]

/-- **Every coset representative lies in `V' = ker Q_G`.** For each `k : Fin 4`,
`Q_G · e_{r k} = 0`. -/
theorem QG_reps_mem_ker (k : Fin 4) : QG.mulVec (Pi.single (r k) 1) = 0 := by
  rw [Matrix.mulVec_single_one]
  ext p; fin_cases k <;> simp [Matrix.col, QG_apply, r]

/-- **The excluded axis `(1,2)` maps to the `N`-generator `(0,2)`.**
`Q_G · e_{(1,2)} = e_{(0,2)}`, so `range Q_G` is exactly the line
`span e_{(0,2)}`. -/
theorem QG_excluded_to_N :
    QG.mulVec (Pi.single ((1:Fin 2),(2:Fin 3)) 1)
      = Pi.single ((0:Fin 2),(2:Fin 3)) 1 := by
  rw [Matrix.mulVec_single_one]
  ext p; obtain ⟨a, i⟩ := p
  fin_cases a <;> fin_cases i <;>
    simp [Matrix.col, QG_apply, Pi.single]

/-- **`range Q_G = N`** as a submodule: the null direction is exactly the line
spanned by the `N`-generator `e_{(0,2)}`. -/
theorem QG_range_eq :
    (Matrix.mulVecLin QG).range
      = Submodule.span ℂ {Pi.single ((0:Fin 2),(2:Fin 3)) (1:ℂ)} := by
  rw [Matrix.range_mulVecLin]
  apply le_antisymm
  · rw [Submodule.span_le]
    rintro v ⟨q, rfl⟩
    rw [QG_col_eq]
    split
    · exact Submodule.subset_span rfl
    · exact Submodule.zero_mem _
  · rw [Submodule.span_le]
    rintro v rfl
    exact Submodule.subset_span ⟨((1:Fin 2),(2:Fin 3)), by rw [QG_col_eq]; simp⟩

/-- **`ker Q_G = V'`** as a submodule: the physical sector is exactly the span of
the axes `e_p` for `p ≠ (1,2)` (a 5-dimensional hyperplane). -/
theorem QG_ker_eq :
    LinearMap.ker (Matrix.mulVecLin QG)
      = Submodule.span ℂ
          ((fun p => Pi.single p (1:ℂ)) ''
            {p : Fin 2 × Fin 3 | p ≠ ((1:Fin 2),(2:Fin 3))}) := by
  apply le_antisymm
  · intro v hv
    rw [LinearMap.mem_ker, Matrix.mulVecLin_apply, QG_mulVec_eq] at hv
    have hv0 : v ((1:Fin 2),(2:Fin 3)) = 0 := by
      have := congrFun hv ((0:Fin 2),(2:Fin 3)); simpa using this
    rw [← Finset.univ_sum_single v]
    apply Submodule.sum_mem; intro p _
    by_cases hp : p = ((1:Fin 2),(2:Fin 3))
    · subst hp; rw [hv0]; simp
    · have heq : Pi.single p (v p) = (v p) • (Pi.single p 1 : Fin 2 × Fin 3 → ℂ) := by
        ext x; by_cases hx : x = p <;> simp [Pi.single_apply, hx]
      rw [heq]
      exact Submodule.smul_mem _ _ (Submodule.subset_span ⟨p, hp, rfl⟩)
  · rw [Submodule.span_le]; rintro _ ⟨p, hp, rfl⟩
    rw [SetLike.mem_coe, LinearMap.mem_ker, Matrix.mulVecLin_apply,
      Matrix.mulVec_single_one, QG_col_eq, if_neg hp]

/-- **Coset basis / enumeration.** `ker Q_G` is spanned by the four coset
representatives `e_{r k}` together with the `N`-generator `e_{(0,2)}`; i.e. `r`
enumerates the `V'/N` coset representatives and `(0,2)` is the extra null axis. -/
theorem QG_ker_reps_basis :
    LinearMap.ker (Matrix.mulVecLin QG)
      = Submodule.span ℂ
          (insert (Pi.single ((0:Fin 2),(2:Fin 3)) (1:ℂ))
            (Set.range (fun k => Pi.single (r k) (1:ℂ)))) := by
  rw [QG_ker_eq]; congr 1; ext w
  constructor
  · rintro ⟨p, hp, rfl⟩
    obtain ⟨a, i⟩ := p
    fin_cases a <;> fin_cases i <;> first
      | exact absurd rfl hp
      | exact Or.inl rfl
      | exact Or.inr ⟨0, rfl⟩
      | exact Or.inr ⟨1, rfl⟩
      | exact Or.inr ⟨2, rfl⟩
      | exact Or.inr ⟨3, rfl⟩
  · rintro (rfl | ⟨k, rfl⟩)
    · exact ⟨((0:Fin 2),(2:Fin 3)), by decide, rfl⟩
    · exact ⟨r k, by fin_cases k <;> decide, rfl⟩

/-- The induced Krein form on `V'/N`, as the compression (submatrix) of
`J Q_C` to the representatives. -/
def B : Matrix (Fin 4) (Fin 4) ℂ := JQc.submatrix r r

/-- Explicit value of the compressed form: `B = (σx·σz) ⊗ k` with
`k = !![0,1;-1,0]` the `ker G` block of `K`. -/
def Bexpl : Matrix (Fin 4) (Fin 4) ℂ :=
  !![0,0,0,-1; 0,0,1,0; 0,1,0,0; -1,0,0,0]

/-- The descended grading `b̄ = σz ⊗ 1₂ = diag(1,1,-1,-1)` on `V'/N`. -/
def bg4 : Matrix (Fin 4) (Fin 4) ℂ :=
  !![1,0,0,0; 0,1,0,0; 0,0,-1,0; 0,0,0,-1]

/-- The compression computes to the explicit matrix. -/
theorem B_eq_Bexpl : B = Bexpl := by
  unfold B Bexpl JQc r
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.submatrix, kroneckerMap, sx, sz, Kc, Matrix.mul_apply,
      Fin.sum_univ_two]

/-! ### Kernel facts on the compressed form -/

/-- `B` is Hermitian. -/
theorem B_isHermitian : B.IsHermitian := by
  rw [B_eq_Bexpl]
  unfold Matrix.IsHermitian Bexpl
  ext i j; fin_cases i <;> fin_cases j <;> simp [Matrix.conjTranspose]

/-- `B² = 1`: `B` is an involution, hence invertible with eigenvalues `±1`. -/
theorem B_sq : B * B = 1 := by
  rw [B_eq_Bexpl]; unfold Bexpl
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four]

/-- `tr B = 0`. -/
theorem B_trace : B.trace = 0 := by
  rw [B_eq_Bexpl]; unfold Bexpl
  simp [Matrix.trace, Matrix.diag, Fin.sum_univ_four]

/-- `b̄² = 1`. -/
theorem bg4_sq : bg4 * bg4 = 1 := by
  unfold bg4; ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four]

/-- **Compressed anticonjugation** `b̄ B b̄ = -B` (with `b̄⁻¹ = b̄`). -/
theorem bg4_anticonj : bg4 * B * bg4 = -B := by
  rw [B_eq_Bexpl]; unfold bg4 Bexpl
  ext i j; fin_cases i <;> fin_cases j <;>
    simp [Matrix.mul_apply, Fin.sum_univ_four]

/-- **Indefiniteness (the positivity refutation).** The Krein form on the
physical sector realizes both signs, so it is not positive (nor negative)
semidefinite. -/
theorem JQc_not_positive_on_sector :
    (∃ v : Fin 4 → ℂ, (star v ⬝ᵥ B.mulVec v).re < 0) ∧
    (∃ w : Fin 4 → ℂ, 0 < (star w ⬝ᵥ B.mulVec w).re) := by
  rw [B_eq_Bexpl]
  refine ⟨⟨![1,0,0,1], ?_⟩, ⟨![1,0,0,-1], ?_⟩⟩ <;>
    simp [Bexpl, Matrix.mulVec, dotProduct, Fin.sum_univ_four, star]

/-! ### Inertia `(2,2,0)` via the balance engine

`bg4_anticonj` + `S1CCBalancedInertia.anticonj_charpoly_eq` give
`(-B).charpoly = B.charpoly`; then
`S1CCBalancedInertia.hermitian_balanced_count_of_neg_charpoly` gives
`#pos = #neg`. `B_sq` gives `det B = ±1 ≠ 0`, hence no zero eigenvalue. Combined
with `Fintype.card (Fin 4) = 4` this yields the sharp inertia. -/

/-- `B` is invertible (from `B² = 1`). -/
theorem B_isUnit_det : IsUnit B.det := by
  have h : B.det * B.det = 1 := by
    have := congrArg Matrix.det B_sq
    rwa [Matrix.det_mul, Matrix.det_one] at this
  exact IsUnit.of_mul_eq_one _ h

/-- Charpoly symmetry on the sector, from the compressed anticonjugation. -/
theorem B_charpoly_symm : (-B).charpoly = B.charpoly := by
  haveI : Invertible bg4 := ⟨bg4, bg4_sq, bg4_sq⟩
  have hinv : (⅟ bg4 : Matrix (Fin 4) (Fin 4) ℂ) = bg4 := invOf_eq_right_inv bg4_sq
  have hAnti : ⅟ bg4 * B * bg4 = -B := by rw [hinv]; exact bg4_anticonj
  exact S1CCBalancedInertia.anticonj_charpoly_eq B bg4 hAnti

/-- **Balanced count on the physical sector**: as many positive as negative
Hermitian eigenvalues of `B`. -/
theorem B_balanced :
    (Finset.univ.filter (fun i => 0 < B_isHermitian.eigenvalues i)).card =
      (Finset.univ.filter (fun i => B_isHermitian.eigenvalues i < 0)).card :=
  S1CCBalancedInertia.hermitian_balanced_count_of_neg_charpoly B B_isHermitian
    B_charpoly_symm

/-
No zero eigenvalue (nondegeneracy from invertibility).
-/
theorem B_no_zero_eig :
    (Finset.univ.filter (fun i => B_isHermitian.eigenvalues i = 0)).card = 0 := by
  have h_det : B.det = ∏ i, (B_isHermitian.eigenvalues i : ℂ) := by
    convert Matrix.IsHermitian.det_eq_prod_eigenvalues B_isHermitian;
  have h_det_ne_zero : B.det ≠ 0 := by
    exact IsUnit.ne_zero ( B_isUnit_det );
  simp_all +decide [ Finset.prod_eq_zero_iff ]

/-
**`balanced_on_physical_sector`.** The closure Krein form on `V'/N` has
inertia `(2,2,0)`: two positive, two negative, no zero eigenvalues — balanced
(Krein signature zero), hence never positive. This is the kernel form of the
oracle result `sig(J Q_C|_{V'/N}) = (2,2,0)` (kill-condition K-B).
-/
theorem balanced_on_physical_sector :
    (Finset.univ.filter (fun i => 0 < B_isHermitian.eigenvalues i)).card = 2 ∧
    (Finset.univ.filter (fun i => B_isHermitian.eigenvalues i < 0)).card = 2 ∧
    (Finset.univ.filter (fun i => B_isHermitian.eigenvalues i = 0)).card = 0 := by
  refine' ⟨ _, _, _ ⟩;
  · have h_card : (Finset.univ.filter (fun i => 0 < B_isHermitian.eigenvalues i)).card + (Finset.univ.filter (fun i => B_isHermitian.eigenvalues i < 0)).card + (Finset.univ.filter (fun i => B_isHermitian.eigenvalues i = 0)).card = 4 := by
      rw [ Finset.card_filter, Finset.card_filter, Finset.card_filter ];
      rw [ ← Finset.sum_add_distrib, ← Finset.sum_add_distrib ];
      exact Eq.trans ( Finset.sum_congr rfl fun _ _ => by rcases lt_trichotomy ( B_isHermitian.eigenvalues _ ) 0 with h | h | h <;> split_ifs <;> first | linarith | aesop ) ( by norm_num );
    linarith [ B_balanced, B_no_zero_eig ];
  · have h_card : (Finset.univ.filter (fun i => 0 < B_isHermitian.eigenvalues i)).card + (Finset.univ.filter (fun i => B_isHermitian.eigenvalues i < 0)).card + (Finset.univ.filter (fun i => B_isHermitian.eigenvalues i = 0)).card = 4 := by
      rw [ Finset.card_filter, Finset.card_filter, Finset.card_filter ];
      rw [ ← Finset.sum_add_distrib, ← Finset.sum_add_distrib ];
      exact Eq.trans ( Finset.sum_congr rfl fun _ _ => by rcases lt_trichotomy ( B_isHermitian.eigenvalues _ ) 0 with h | h | h <;> split_ifs <;> first | linarith | aesop ) ( by norm_num );
    linarith [ B_balanced, B_no_zero_eig ];
  · convert B_no_zero_eig using 1

end

end PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness

/-! ## Build-enforced axiom pins (this file self-guards its flagships) -/

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness.balanced_on_physical_sector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness.balanced_on_physical_sector

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness.JQc_not_positive_on_sector' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness.JQc_not_positive_on_sector

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness.QG_ker_reps_basis' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness.QG_ker_reps_basis

/-- info: 'PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness.QG_range_eq' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms PhysicsSM.Draft.NullEdge.GateYM.S1CCPhysicalSectorWitness.QG_range_eq
