import Mathlib
import PhysicsSM.Draft.NullEdge.GateC1.ProjectorPersistence

/-!
# C232 — the `branchKernel_chiralIndex_zero` bridge (geometry-free core)

This module discharges the *mathematical core* of the C226 bridge proposal
`branchKernel_chiralIndex_zero` in a form that **typechecks in the live repo
today**, without the absent `PhysicsSM.Draft.TetrahedralNullBranch` /
`PhysicsSM.Draft.TetrahedralHighMomentumNullBranch` geometry modules.

## Why this file exists / dependency note

The intended bridge connects two stacks:

* `GateC1.chiralIndex` / `GateC1.chiralIndex_zero_of_trace_zero` (from
  `ProjectorPersistence.lean`, which is self-contained and builds), and
* the actual C21 Clifford symbol `cliffordSymbol`, `gamma5`, `branchP` (from
  `NullEdgeActualCliffordSymbol.lean`).

`NullEdgeActualCliffordSymbol.lean` does **not** currently build: it `import`s
`PhysicsSM.Draft.NullEdgeFlavoredChirality` (wrong module prefix — the lakefile
exposes flat module names) and transitively opens
`PhysicsSM.Draft.TetrahedralNullBranch`, a module that is **absent** from the
repo.  Only the geometry inputs `mink`, `pCov`, `cornerU`, `qform`,
`cornerCount`, `pSq_mink_eq_qform`, `threePi_null`, `threePi_pCov_ne_zero` are
missing; the *symbol algebra itself* (`gamma5`, `blockA`, `blockB`,
`cliffordSymbol`) needs none of them.

So here we reproduce the **convention-locked** symbol data verbatim (same Weyl /
chiral gamma basis — *not* a new convention) together with a local Minkowski
square `mink`, and prove the bridge for an *arbitrary nonzero null covector*.
The per-branch theorem `branchKernel_chiralIndex_zero` is then a one-line
specialization once the geometry module is restored:

```
theorem branchKernel_chiralIndex_zero (a : Fin 4) (P : CMat4)
    (hP : IsIdempotentElem P) (hcom : Commute gamma5 P)
    (hran : ∀ v : Spin → ℂ, P *ᵥ v = v ↔ cliffordSymbol (branchP a) *ᵥ v = 0) :
    chiralIndex gamma5 P = 0 :=
  nullBranch_chiralIndex_zero (branchP a) (branchP_ne_zero a) (branchP_mink_zero a)
    P hP hcom hran
```

(Here `branchP_ne_zero`/`branchP_mink_zero` are the two facts in
`NullEdgeActualCliffordSymbol.lean` that consume the absent geometry.)

## Obstruction preserved (honest scope)

This is **not** a Weyl release.  The conclusion is `chiralIndex = 0`: the bare
symbol's per-branch kernel is chirality-balanced (one right-handed `γ₅ = +1`
mode and one left-handed `γ₅ = -1` mode), exactly the C21 zero-index
obstruction.  The bridge says that obstruction survives for **every** idempotent
`γ₅`-commuting projector whose fixed space is the symbol kernel.
-/

noncomputable section

namespace BranchKernelBridge

open Matrix
open GateC1

/-! ## Convention-locked symbol data (mirror of `NullEdgeActualCliffordSymbol`) -/

/-- Spinor index `Fin 2 ⊕ Fin 2`: right-handed (`inl`) ⊕ left-handed (`inr`). -/
abbrev Spin := Fin 2 ⊕ Fin 2

/-- 4×4 complex matrices on the spinor space. -/
abbrev CMat4 := Matrix Spin Spin ℂ

/-- Spacetime chirality `γ₅ = [[I,0],[0,-I]]`. -/
def gamma5 : CMat4 := Matrix.fromBlocks 1 0 0 (-1)

/-- Upper-right Weyl block `A(p) = p₀ I + pⁱσⁱ`. -/
def blockA (p : Fin 4 → ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![p 0 + p 3, p 1 - Complex.I * p 2; p 1 + Complex.I * p 2, p 0 - p 3]

/-- Lower-left Weyl block `B(p) = p₀ I - pⁱσⁱ`. -/
def blockB (p : Fin 4 → ℂ) : Matrix (Fin 2) (Fin 2) ℂ :=
  !![p 0 - p 3, -(p 1) + Complex.I * p 2; -(p 1) - Complex.I * p 2, p 0 + p 3]

/-- The flat tetrahedral Clifford symbol `c(p) = [[0, A(p)],[B(p), 0]]`. -/
def cliffordSymbol (p : Fin 4 → ℂ) : CMat4 :=
  Matrix.fromBlocks 0 (blockA p) (blockB p) 0

/-- Mostly-minus Minkowski square `mink p = p₀² - p₁² - p₂² - p₃²` (the local
copy of `PhysicsSM.Draft.TetrahedralNullBranch.mink`). -/
def mink (p : Fin 4 → ℂ) : ℂ := (p 0)^2 - (p 1)^2 - (p 2)^2 - (p 3)^2

/-! ## Block algebra (proofs mirror `NullEdgeActualCliffordSymbol`) -/

theorem blockA_mul_blockB (p : Fin 4 → ℂ) :
    blockA p * blockB p = (mink p) • 1 := by
  ext i j; fin_cases i <;> fin_cases j <;>
    simp +decide [ blockA, blockB, Matrix.mul_apply ] <;> ring;
  all_goals unfold mink; norm_num; ring

theorem blockB_mul_blockA (p : Fin 4 → ℂ) :
    blockB p * blockA p = (mink p) • 1 := by
  convert blockA_mul_blockB p using 1;
  unfold blockA blockB; ext i j; fin_cases i <;> fin_cases j <;>
    norm_num [ Matrix.mul_apply, Fin.sum_univ_succ ] <;> ring

theorem blockA_det (p : Fin 4 → ℂ) : (blockA p).det = mink p := by
  unfold mink; unfold blockA; norm_num [ Fin.sum_univ_succ ]; ring; norm_num; ring

theorem blockB_det (p : Fin 4 → ℂ) : (blockB p).det = mink p := by
  unfold blockB mink; norm_num [ Fin.sum_univ_four ]; ring; norm_num; ring

theorem blockA_ne_zero (p : Fin 4 → ℂ) (hp : p ≠ 0) : blockA p ≠ 0 := by
  intro H;
  simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ];
  simp_all +decide [ blockA ];
  exact hp ( by ext i; fin_cases i <;> norm_num <;>
    norm_num [ Complex.ext_iff ] at * <;> constructor <;> linarith! )

theorem blockB_ne_zero (p : Fin 4 → ℂ) (hp : p ≠ 0) : blockB p ≠ 0 := by
  contrapose! hp;
  ext i; fin_cases i <;> simp_all +decide [ funext_iff, Fin.forall_fin_succ ];
  · simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ];
    unfold blockB at hp; norm_num at hp; norm_num [ Complex.ext_iff ] at *; constructor <;> linarith;
  · unfold blockB at hp; simp_all +decide [ ← Matrix.ext_iff ];
    norm_num [ Complex.ext_iff ] at *; constructor <;> linarith;
  · unfold blockB at hp; simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ];
    norm_num [ Complex.ext_iff ] at *; constructor <;> linarith;
  · unfold blockB at hp; simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ];
    grind

theorem cliffordSymbol_sq (p : Fin 4 → ℂ) :
    cliffordSymbol p * cliffordSymbol p = (mink p) • (1 : CMat4) := by
  unfold cliffordSymbol;
  rw [ fromBlocks_multiply ]; simp +decide [ blockA_mul_blockB, blockB_mul_blockA ];
  ext i j; fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.one_apply ]

theorem cliffordSymbol_sq_zero (p : Fin 4 → ℂ) (h : mink p = 0) :
    cliffordSymbol p * cliffordSymbol p = 0 := by
  rw [cliffordSymbol_sq, h, zero_smul]

/-! ## `γ₅` is an involution -/

theorem gamma5_involution : IsInvolution (gamma5 : CMat4) := by
  unfold IsInvolution gamma5;
  convert Matrix.fromBlocks_multiply _ _ _ _ _ _ _ _ ; norm_num

/-! ## Consequences of the range hypothesis `hran`

`hran : ∀ v, P *ᵥ v = v ↔ cliffordSymbol p *ᵥ v = 0` says the fixed space of the
idempotent `P` is exactly the symbol kernel.  From this plus `c² = 0` and
idempotency we get the two operator identities `P · c = c` and `c · P = 0`. -/

theorem P_mul_cliffordSymbol_eq (p : Fin 4 → ℂ) (h : mink p = 0) (P : CMat4)
    (hran : ∀ v : Spin → ℂ, P *ᵥ v = v ↔ cliffordSymbol p *ᵥ v = 0) :
    P * cliffordSymbol p = cliffordSymbol p := by
  -- By definition of matrix multiplication and the hypothesis `hran`, we can show that for any vector `v`, `P * (cliffordSymbol p * v) = cliffordSymbol p * v`.
  have h_mul : ∀ v : Spin → ℂ, P *ᵥ (cliffordSymbol p *ᵥ v) = cliffordSymbol p *ᵥ v := by
    intro v
    have h_cliffordSymbol_sq_zero : cliffordSymbol p *ᵥ (cliffordSymbol p *ᵥ v) = 0 := by
      simp +decide [ ← Matrix.mul_assoc, ← Matrix.mulVec_smul, h, cliffordSymbol_sq_zero ];
    exact hran _ |>.2 h_cliffordSymbol_sq_zero;
  exact Matrix.ext fun i j => by simpa using congr_fun ( h_mul ( Pi.single j 1 ) ) i;

theorem cliffordSymbol_mul_P_eq (p : Fin 4 → ℂ) (P : CMat4)
    (hP : IsIdempotentElem P)
    (hran : ∀ v : Spin → ℂ, P *ᵥ v = v ↔ cliffordSymbol p *ᵥ v = 0) :
    cliffordSymbol p * P = 0 := by
  -- By definition of matrix multiplication and the properties of idempotents, we can show that for any vector v, cliffordSymbol p *ᵥ (P *ᵥ v) = 0.
  have h_mul_zero : ∀ v : Spin → ℂ, cliffordSymbol p *ᵥ (P *ᵥ v) = 0 := by
    intro v
    have hPv : P *ᵥ (P *ᵥ v) = P *ᵥ v := by
      simp +decide [ ← Matrix.mul_assoc, hP.eq ]
    have hcv : cliffordSymbol p *ᵥ (P *ᵥ v) = 0 := by
      exact hran _ |>.1 hPv
    exact hcv;
  exact Matrix.ext fun i j => by simpa using congr_fun ( h_mul_zero ( Pi.single j 1 ) ) i;

/-! ## Rank-one Weyl blocks and the generic block-balance lemma -/

/-
Both Weyl blocks of a nonzero null covector have rank one: each is nonzero
(`blockA_ne_zero`/`blockB_ne_zero`) and singular (`det = mink p = 0`), and
`A · B = 0` forces `rank A + rank B ≤ 2`.
-/
theorem blockA_blockB_rank_one (p : Fin 4 → ℂ) (hp : p ≠ 0) (h : mink p = 0) :
    (blockA p).rank = 1 ∧ (blockB p).rank = 1 := by
  have h_rank_A : 1 ≤ (blockA p).rank := by
    by_contra h_contra;
    simp_all +decide [ Matrix.rank, Submodule.eq_bot_iff ];
    exact blockA_ne_zero p hp ( Matrix.ext fun i j => by simpa using congr_fun ( h_contra ( Pi.single j 1 ) ) i )
  have h_rank_B : 1 ≤ (blockB p).rank := by
    simp_all +decide [ Matrix.rank, Submodule.eq_bot_iff ];
    exact not_forall.mp fun h' => blockB_ne_zero p hp <| Matrix.ext fun i j => by simpa using congr_fun ( h' <| Pi.single j 1 ) i;
  have h_rank_sum : (blockA p).rank + (blockB p).rank ≤ 2 := by
    have h_rank_sum : Matrix.rank (blockA p) + Matrix.rank (blockB p) ≤ 2 := by
      have h_mul : blockA p * blockB p = 0 := by
        rw [ blockA_mul_blockB, h, zero_smul ]
      apply Matrix.rank_add_rank_le_card_of_mul_eq_zero h_mul
    exact h_rank_sum
  exact ⟨by linarith, by linarith⟩

/-
**Generic block-balance.**  A block `Q` squeezed as `range A ⊆ range Q ⊆
ker B` between rank-one blocks (`Q * A = A` and `B * Q = 0`) has rank one:
`1 = rank A ≤ rank Q` and `rank Q ≤ 2 - rank B = 1`.
-/
theorem block_rank_one_of_relations (Q A B : Matrix (Fin 2) (Fin 2) ℂ)
    (hQA : Q * A = A) (hBQ : B * Q = 0)
    (hrA : A.rank = 1) (hrB : B.rank = 1) : Q.rank = 1 := by
  have h_rank_Q : Matrix.rank Q ≥ Matrix.rank A := by
    have := Matrix.rank_mul_le_left Q A; aesop;
  have := Matrix.rank_add_rank_le_card_of_mul_eq_zero hBQ; simp_all +decide ;
  linarith

/-! ## The trace-zero core: `(γ₅ · P).trace = 0` -/

/-
**Core balance.**  For a nonzero null covector `p`, any idempotent `P` that
commutes with `γ₅` and whose fixed space is `ker (cliffordSymbol p)` has
vanishing chirality trace.  This is the honest two-dimensional / chirality
balanced kernel computation: the `+1` and `-1` blocks of `P` both have rank one.
-/
set_option maxHeartbeats 2000000 in
theorem gamma5_P_trace_zero (p : Fin 4 → ℂ) (hp : p ≠ 0) (h : mink p = 0)
    (P : CMat4) (hP : IsIdempotentElem P) (hcom : Commute gamma5 P)
    (hran : ∀ v : Spin → ℂ, P *ᵥ v = v ↔ cliffordSymbol p *ᵥ v = 0) :
    (gamma5 * P).trace = 0 := by
  -- Step A: P is block diagonal.
  have hPdiag : ∃ P11 P22 : Matrix (Fin 2) (Fin 2) ℂ, P = Matrix.fromBlocks P11 0 0 P22 := by
    have hP_diag : P.toBlocks₁₂ = 0 ∧ P.toBlocks₂₁ = 0 := by
      have := congr_arg ( fun m => m.toBlocks₁₂ ) hcom; norm_num [ Matrix.toBlocks₁₂, Matrix.toBlocks₂₁ ] at this ⊢;
      have := congr_arg ( fun m => m.toBlocks₂₁ ) hcom; norm_num [ Matrix.toBlocks₁₂, Matrix.toBlocks₂₁ ] at this; simp_all +decide [ funext_iff, Matrix.mul_apply, gamma5 ] ;
      exact ⟨ by ext i j; fin_cases i <;> fin_cases j <;> norm_num <;> norm_num [ Complex.ext_iff ] at * <;> constructor <;> linarith !, by ext i j; fin_cases i <;> fin_cases j <;> norm_num <;> norm_num [ Complex.ext_iff ] at * <;> constructor <;> linarith ! ⟩;
    exact ⟨ P.toBlocks₁₁, P.toBlocks₂₂, by simpa [ hP_diag ] using P.fromBlocks_toBlocks.symm ⟩;
  obtain ⟨P11, P22, hPdiag⟩ := hPdiag;
  have hP11 : IsIdempotentElem P11 := by
    simp_all +decide [ IsIdempotentElem, Matrix.fromBlocks_multiply ];
  have hP22 : IsIdempotentElem P22 := by
    simp_all +decide [ IsIdempotentElem ];
    simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply ];
  have hP11_blockA : P11 * blockA p = blockA p := by
    have := P_mul_cliffordSymbol_eq p h P hran; simp_all +decide [ Matrix.fromBlocks_multiply ] ;
    simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply, blockA, blockB, cliffordSymbol ];
  have hP22_blockB : P22 * blockB p = blockB p := by
    have := P_mul_cliffordSymbol_eq p h P hran; simp_all +decide [ Matrix.fromBlocks_multiply ] ;
    simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply, cliffordSymbol ];
  have hblockA_P22 : blockA p * P22 = 0 := by
    have := cliffordSymbol_mul_P_eq p P hP hran; simp_all +decide [ Matrix.fromBlocks_multiply ] ;
    simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply, Matrix.fromBlocks_multiply ];
    simp_all +decide [ cliffordSymbol ];
  have hblockB_P11 : blockB p * P11 = 0 := by
    have := cliffordSymbol_mul_P_eq p P hP hran; simp_all +decide [ Matrix.fromBlocks_multiply ] ;
    simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ, Matrix.mul_apply, cliffordSymbol ];
  have hP11_rank : P11.rank = 1 := by
    apply block_rank_one_of_relations P11 (blockA p) (blockB p) hP11_blockA hblockB_P11 (blockA_blockB_rank_one p hp h).left (blockA_blockB_rank_one p hp h).right;
  have hP22_rank : P22.rank = 1 := by
    apply block_rank_one_of_relations P22 (blockB p) (blockA p);
    · exact hP22_blockB;
    · exact hblockA_P22;
    · exact blockA_blockB_rank_one p hp h |>.2;
    · exact blockA_blockB_rank_one p hp h |>.1;
  have hP11_trace : P11.trace = 1 := by
    have := trace_eq_rank_of_idem P11 hP11; aesop;;
  have hP22_trace : P22.trace = 1 := by
    rw [ ← GateC1.trace_eq_rank_of_idem P22 hP22 ] ; aesop;
  simp_all +decide [ gamma5, Matrix.trace ];
  simp_all +decide [ Matrix.mul_apply, fromBlocks ];
  linear_combination' -hP22_trace

/-! ## The bridge -/

/-- **Generic null-branch chiral-index bridge (C232).**  For every nonzero null
covector `p`, any idempotent projector `P` commuting with `γ₅` whose fixed space
is exactly the symbol kernel `ker (cliffordSymbol p)` has zero chiral index.

Specializing `p := branchP a` (with `branchP_ne_zero a`, `branchP_mink_zero a`)
gives the C226 target `branchKernel_chiralIndex_zero` once the geometry module
`PhysicsSM.Draft.TetrahedralNullBranch` is restored. -/
theorem nullBranch_chiralIndex_zero (p : Fin 4 → ℂ) (hp : p ≠ 0) (h : mink p = 0)
    (P : CMat4) (hP : IsIdempotentElem P) (hcom : Commute gamma5 P)
    (hran : ∀ v : Spin → ℂ, P *ᵥ v = v ↔ cliffordSymbol p *ᵥ v = 0) :
    chiralIndex gamma5 P = 0 :=
  chiralIndex_zero_of_trace_zero gamma5 P gamma5_involution hcom hP
    (gamma5_P_trace_zero p hp h P hP hcom hran)

end BranchKernelBridge
