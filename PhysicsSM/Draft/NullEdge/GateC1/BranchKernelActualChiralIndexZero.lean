import Mathlib
import PhysicsSM.Draft.NullEdgeActualCliffordSymbol
import PhysicsSM.Draft.NullEdge.GateC1.ProjectorPersistence

/-!
# Gate C1 bridge: the actual C21 branch kernel has zero chiral index (C235)

This module is the **obstruction bridge** requested in C226/C232/C235.  It connects

* the *actual* flat tetrahedral Clifford symbol `cliffordSymbol` and its locked Weyl
  gamma convention from `PhysicsSM.Draft.NullEdgeActualCliffordSymbol`, and
* the C226 GateC1 projector-obstruction vocabulary
  (`GateC1.chiralIndex`, `GateC1.chiralIndex_zero_of_trace_zero`) from
  `PhysicsSM.Draft.NullEdge.GateC1.ProjectorPersistence`.

## Main statement

`branchKernel_chiralIndex_zero` : if `P` is an idempotent on the spinor space that
commutes with the spacetime chirality `gamma5` and whose fixed space is *exactly* the
kernel of the actual branch symbol `cliffordSymbol (branchP a)`, then its chiral index
in the GateC1 projector vocabulary vanishes:

```
chiralIndex gamma5 P = 0.
```

## Why this is an obstruction, not a release

The branch kernel of the bare symbol is two-dimensional and chirality balanced (one
`gamma5 = +1` right-handed mode, one `gamma5 = -1` left-handed mode), exactly as
computed in `null_kernel_both_chiralities` / `branchKernel_chirality_sign`.  Therefore
*any* projector onto that kernel which commutes with `gamma5` carries chiral index `0`.

This is an **obstruction theorem**: it says the bare branch kernel cannot produce a
nonzero chiral index, mirroring `no_full_symbol_single_chirality`.  It is emphatically
**not** a chiral release: a nonzero chiral index would require an additional
energy/Krein/Weyl projection (`OperatorForcesAlignmentAfterProjection`) that cuts each
two-dimensional branch kernel down to a single chirality.  Nothing here supplies that.

## Proof skeleton

The chirality structure is block diagonal in the Weyl basis: `gamma5 = diag(1,1,-1,-1)`
splits the spinor space into the right-handed block `inl` and the left-handed block
`inr`.  Because `P` commutes with `gamma5`, `P` is block diagonal `fromBlocks P₁ 0 0 P₂`,
and the fixed-space hypothesis forces `range P₁ = ker (blockB)` and
`range P₂ = ker (blockA)`.  Since both Weyl blocks are nonzero `2×2` matrices of
determinant `mink (branchP a) = 0`, each has rank one, so each kernel is one
dimensional.  Hence `trace P₁ = trace P₂` and therefore
`trace (gamma5 * P) = trace P₁ - trace P₂ = 0`, and `chiralIndex_zero_of_trace_zero`
closes the goal.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdge.GateC1.BranchKernel

open Matrix
open PhysicsSM.Draft.NullEdgeActualCliffordSymbol
open PhysicsSM.Draft.TetrahedralNullBranch

/-! ## The chirality involution -/

/-
`gamma5` is a genuine chirality involution `gamma5 * gamma5 = 1`.
-/
theorem gamma5_involution : GateC1.IsInvolution gamma5 := by
  unfold gamma5;
  simp +decide [ GateC1.IsInvolution, fromBlocks_multiply ]

/-! ## Rank of the Weyl blocks on a null nonzero covector -/

/-
For a nonzero null covector the lower-left Weyl block has rank one: it is nonzero
(`blockB_ne_zero`) but its determinant `mink p` vanishes (`blockB_det`).
-/
theorem blockB_rank_one (p : Fin 4 → ℂ) (hnull : mink p = 0) (hp : p ≠ 0) :
    (blockB p).rank = 1 := by
  -- Since $blockB p$ is non-zero and its determinant is zero, it cannot befull rank, hence its rank is at most 1.
  have h_rank_le_one : Matrix.rank (blockB p) ≤ 1 := by
    have h_rank_le_one : Matrix.det (blockB p) = 0 := by
      rw [ ← hnull, blockB_det ];
    have h_rank_le_one : LinearMap.ker (Matrix.mulVecLin (blockB p)) ≠ ⊥ := by
      simp_all +decide [ Submodule.eq_bot_iff ];
      have := Matrix.exists_mulVec_eq_zero_iff.mpr h_rank_le_one; tauto;
    have := LinearMap.finrank_range_add_finrank_ker ( Matrix.mulVecLin ( blockB p ) ) ; simp_all +decide [ Matrix.rank ] ;
    linarith [ show Module.finrank ℂ ( LinearMap.ker ( Matrix.mulVecLin ( blockB p ) ) ) ≥ 1 from Nat.pos_of_ne_zero ( by aesop ) ];
  interval_cases _ : Matrix.rank ( blockB p ) <;> simp_all +decide [ Matrix.rank, Submodule.eq_bot_iff ];
  exact absurd ( blockB_ne_zero p hp ) ( by rw [ show blockB p = 0 from Matrix.ext fun i j => by simpa using congr_fun ( ‹∀ a : Fin 2 → ℂ, blockB p *ᵥ a = 0› ( Pi.single j 1 ) ) i ] ; norm_num )

/-
For a nonzero null covector the upper-right Weyl block has rank one.
-/
theorem blockA_rank_one (p : Fin 4 → ℂ) (hnull : mink p = 0) (hp : p ≠ 0) :
    (blockA p).rank = 1 := by
  obtain ⟨v, hv⟩ : ∃ v : Fin 2 → ℂ, v ≠ 0 ∧ blockA p *ᵥ v = 0 := by
    convert Matrix.exists_mulVec_eq_zero_iff.mpr ( show Matrix.det ( blockA p ) = 0 from ?_ ) using 1;
    rw [ blockA_det, hnull ];
  have h_rank_le_one : Matrix.rank (blockA p) ≤ 1 := by
    have h_rank_le_one : LinearMap.ker (Matrix.mulVecLin (blockA p)) ≠ ⊥ := by
      simp_all +decide [ Submodule.eq_bot_iff ];
      exact ⟨ v, hv.2, hv.1 ⟩;
    have := LinearMap.finrank_range_add_finrank_ker ( Matrix.mulVecLin ( blockA p ) ) ; simp_all +decide [ Matrix.rank ] ;
    linarith [ show Module.finrank ℂ ( LinearMap.ker ( Matrix.mulVecLin ( blockA p ) ) ) ≥ 1 from Nat.pos_of_ne_zero ( by aesop ) ];
  interval_cases _ : Matrix.rank ( blockA p ) <;> simp_all +decide [ Matrix.rank, Submodule.eq_bot_iff ];
  exact blockA_ne_zero p hp ( Matrix.ext fun i j => by simpa using congr_fun ( ‹∀ a : Fin 2 → ℂ, blockA p *ᵥ a = 0› ( Pi.single j 1 ) ) i )

/-! ## Block-diagonalization under the chirality commutation -/

/-
A matrix commuting with `gamma5 = fromBlocks 1 0 0 (-1)` is block diagonal: its
off-diagonal Weyl blocks vanish.
-/
theorem toBlocks_offdiag_zero (P : CMat4) (hcom : Commute gamma5 P) :
    P.toBlocks₁₂ = 0 ∧ P.toBlocks₂₁ = 0 := by
  constructor;
  · ext i j; have := congr_fun ( congr_fun hcom ( Sum.inl i ) ) ( Sum.inr j ) ; simp_all +decide [ Matrix.mul_apply, Finset.sum_add_distrib ] ;
    unfold gamma5 at this; fin_cases i <;> fin_cases j <;> simp_all +decide [ Matrix.one_apply ] ;
    · exact eq_of_sub_eq_zero ( by norm_num [ toBlocks₁₂ ] ; linear_combination' this / 2 );
    · exact eq_of_sub_eq_zero ( by norm_num [ toBlocks₁₂ ] ; linear_combination' this / 2 );
    · exact eq_of_sub_eq_zero ( by norm_num [ toBlocks₁₂ ] ; linear_combination' this / 2 );
    · exact eq_of_sub_eq_zero ( by norm_num [ toBlocks₁₂ ] ; linear_combination' this / 2 );
  · ext i j; have := congr_fun ( congr_fun hcom ( Sum.inr i ) ) ( Sum.inl j ) ; simp_all +decide [ Matrix.mul_apply, gamma5 ] ;
    fin_cases i <;> fin_cases j <;> simp_all +decide [ Matrix.one_apply ];
    · rw [ neg_eq_iff_add_eq_zero ] at this ; aesop;
    · exact neg_eq_iff_add_eq_zero.mp this |> fun h => by simpa [ toBlocks₂₁ ] using h;
    · rw [ neg_eq_iff_add_eq_zero ] at this ; aesop;
    · exact neg_eq_iff_add_eq_zero.mp this |> fun h => by simpa [ toBlocks₂₁ ] using h;

/-
Trace identity: `trace (gamma5 * P) = trace P₁₁ - trace P₂₂` for any `P`.
-/
theorem trace_gamma5_mul (P : CMat4) :
    (gamma5 * P).trace = P.toBlocks₁₁.trace - P.toBlocks₂₂.trace := by
  unfold CMat4 gamma5; norm_num [ Matrix.trace ] ; ring;
  simp +decide [ Matrix.mul_apply, fromBlocks ];
  ring!

/-! ## A general rank identity: idempotent whose range is a given kernel -/

/-
If `Q` is an idempotent matrix whose fixed space `{x | Q *ᵥ x = x}` is exactly the
kernel `{x | M *ᵥ x = 0}` of another matrix `M`, then `Q.rank + M.rank = card`.
This is the rank–nullity bridge: the range of the idempotent `Q` equals the kernel of
`M`, and rank–nullity for `M` then balances the two ranks against the ambient
dimension.
-/
theorem idem_rank_add_rank_eq_card {ι : Type*} [Fintype ι] [DecidableEq ι]
    {Q M : Matrix ι ι ℂ} (hQ : IsIdempotentElem Q)
    (h : ∀ x : ι → ℂ, Q *ᵥ x = x ↔ M *ᵥ x = 0) :
    Q.rank + M.rank = Fintype.card ι := by
  have h_range_ker : LinearMap.range (Matrix.mulVecLin Q) = LinearMap.ker (Matrix.mulVecLin M) := by
    ext x;
    constructor <;> intro hx <;> specialize h x <;> simp_all +decide [ Matrix.mulVecLin_apply ];
    · obtain ⟨ y, rfl ⟩ := hx; simp_all +decide [ IsIdempotentElem ] ;
    · use x;
  have := LinearMap.finrank_range_add_finrank_ker ( Matrix.mulVecLin M ) ; simp_all +decide [ Matrix.rank ] ;
  rw [ ← this, h_range_ker, add_comm ]

/-! ## The chiral trace vanishes on a branch kernel projector -/

/-- Block-diagonal form of a chirality-commuting projector. -/
theorem block_diag_of_commute (P : CMat4) (hcom : Commute gamma5 P) :
    P = Matrix.fromBlocks P.toBlocks₁₁ 0 0 P.toBlocks₂₂ := by
  obtain ⟨h12, h21⟩ := toBlocks_offdiag_zero P hcom
  conv_lhs => rw [← Matrix.fromBlocks_toBlocks P]
  rw [h12, h21]

/-
The upper-left Weyl block of the projector is idempotent.
-/
theorem toBlocks₁₁_idem (P : CMat4) (hP : IsIdempotentElem P) (hcom : Commute gamma5 P) :
    IsIdempotentElem P.toBlocks₁₁ := by
  unfold IsIdempotentElem at *;
  convert congr_arg Matrix.toBlocks₁₁ hP using 1;
  rw [ block_diag_of_commute P hcom ] ; norm_num [ Matrix.fromBlocks_multiply ] ;

/-
The lower-right Weyl block of the projector is idempotent.
-/
theorem toBlocks₂₂_idem (P : CMat4) (hP : IsIdempotentElem P) (hcom : Commute gamma5 P) :
    IsIdempotentElem P.toBlocks₂₂ := by
  obtain ⟨A, B, C, D, hP⟩ : ∃ A B C D, P = Matrix.fromBlocks A B C D ∧ B = 0 ∧ C = 0 := by
    have := block_diag_of_commute P hcom;
    exact ⟨ _, _, _, _, this, rfl, rfl ⟩;
  simp_all +decide [ IsIdempotentElem ];
  simp_all +decide [ ← Matrix.ext_iff, Fin.forall_fin_two, Matrix.mul_apply ]

/-
The fixed space of the upper-left block is the kernel of the lower-left Weyl block
`blockB`.
-/
theorem toBlocks₁₁_fixed_iff (a : Fin 4) (P : CMat4) (hcom : Commute gamma5 P)
    (hran : ∀ v : Spin → ℂ, P *ᵥ v = v ↔ cliffordSymbol (branchP a) *ᵥ v = 0) :
    ∀ x : Fin 2 → ℂ, P.toBlocks₁₁ *ᵥ x = x ↔ blockB (branchP a) *ᵥ x = 0 := by
  intro x;
  convert hran ( Sum.elim x 0 ) using 1;
  · rw [ block_diag_of_commute P hcom ];
    simp +decide [ funext_iff, Fin.forall_fin_two, Matrix.mulVec, dotProduct ];
  · simp +decide [ funext_iff, Matrix.mulVec, dotProduct ];
    simp +decide [ blockB, cliffordSymbol ]

/-
The fixed space of the lower-right block is the kernel of the upper-right Weyl block
`blockA`.
-/
theorem toBlocks₂₂_fixed_iff (a : Fin 4) (P : CMat4) (hcom : Commute gamma5 P)
    (hran : ∀ v : Spin → ℂ, P *ᵥ v = v ↔ cliffordSymbol (branchP a) *ᵥ v = 0) :
    ∀ y : Fin 2 → ℂ, P.toBlocks₂₂ *ᵥ y = y ↔ blockA (branchP a) *ᵥ y = 0 := by
  intros y
  have := hran;
  convert this ( Sum.elim 0 y ) using 1;
  · rw [ block_diag_of_commute P hcom ];
    simp +decide [ funext_iff, Matrix.mulVec, dotProduct ];
  · simp +decide [ funext_iff, Matrix.mulVec, dotProduct ];
    simp +decide [ blockA, blockB, cliffordSymbol ]

/--
**Chiral trace zero.**  An idempotent projector `P` that commutes with `gamma5` and
whose fixed space is exactly the kernel of the actual branch symbol has vanishing
chirality trace `trace (gamma5 * P) = 0`.
-/
theorem branchKernel_chiralTrace_zero (a : Fin 4) (P : CMat4)
    (hP : IsIdempotentElem P) (hcom : Commute gamma5 P)
    (hran : ∀ v : Spin → ℂ,
      P *ᵥ v = v ↔ cliffordSymbol (branchP a) *ᵥ v = 0) :
    (gamma5 * P).trace = 0 := by
  have hP1_idem := toBlocks₁₁_idem P hP hcom
  have hP2_idem := toBlocks₂₂_idem P hP hcom
  have hr1 : P.toBlocks₁₁.rank + (blockB (branchP a)).rank = Fintype.card (Fin 2) :=
    idem_rank_add_rank_eq_card hP1_idem (toBlocks₁₁_fixed_iff a P hcom hran)
  have hr2 : P.toBlocks₂₂.rank + (blockA (branchP a)).rank = Fintype.card (Fin 2) :=
    idem_rank_add_rank_eq_card hP2_idem (toBlocks₂₂_fixed_iff a P hcom hran)
  have hB : (blockB (branchP a)).rank = 1 :=
    blockB_rank_one (branchP a) (branchP_mink_zero a) (branchP_ne_zero a)
  have hA : (blockA (branchP a)).rank = 1 :=
    blockA_rank_one (branchP a) (branchP_mink_zero a) (branchP_ne_zero a)
  have hcard : Fintype.card (Fin 2) = 2 := by simp
  have hrank1 : P.toBlocks₁₁.rank = 1 := by omega
  have hrank2 : P.toBlocks₂₂.rank = 1 := by omega
  rw [trace_gamma5_mul]
  rw [← GateC1.trace_eq_rank_of_idem _ hP1_idem, ← GateC1.trace_eq_rank_of_idem _ hP2_idem,
    hrank1, hrank2]
  ring

/-! ## The bridge theorem -/

/-- **Branch kernel chiral index zero (C235 obstruction bridge).**

The actual C21 branch kernel has zero chiral index in the GateC1 projector vocabulary:
any idempotent `P` commuting with the spacetime chirality `gamma5` whose fixed space is
exactly the kernel of the branch symbol `cliffordSymbol (branchP a)` has
`chiralIndex gamma5 P = 0`.

This is an obstruction theorem (no chiral release): the bare branch kernel is
chirality balanced, so it cannot generate a nonzero chiral index. -/
theorem branchKernel_chiralIndex_zero (a : Fin 4) (P : CMat4)
    (hP : IsIdempotentElem P)
    (hcom : Commute gamma5 P)
    (hran : ∀ v : Spin → ℂ,
      P *ᵥ v = v ↔ cliffordSymbol (branchP a) *ᵥ v = 0) :
    GateC1.chiralIndex gamma5 P = 0 :=
  GateC1.chiralIndex_zero_of_trace_zero gamma5 P gamma5_involution hcom hP
    (branchKernel_chiralTrace_zero a P hP hcom hran)

end PhysicsSM.Draft.NullEdge.GateC1.BranchKernel
