import PhysicsSM.Draft.NullEdgeActualCliffordSymbol

/-!
# Hyperdiamond no-go: sharpened bare-symbol chirality obstruction (C22)

This module sharpens the central Gate C no-go
`PhysicsSM.Draft.NullEdgeActualCliffordSymbol.no_full_symbol_single_chirality`
into the lattice-fermion "doubling obstruction" form recommended by the
2026-07-01 Aristotle evaluation (`docs/ARISTOTLE_EVALUATION.md`) and the
`docs/HYPERDIAMOND_CROSSWALK.md` crosswalk.

All results here are no-go / balance content about the **bare** flat
tetrahedral Clifford symbol `cliffordSymbol` on the four high-momentum null
branches `branchP a`. Nothing weakens any existing statement; nothing adds a
release clause to the frozen ledger. In particular, this module does not claim
equivalence to the Borici-Creutz operator: no such Lean definition exists in
this package, so no such theorem is stated.

## What is proved here

1. `highMomentum_branch_nogo` bundles, for all four branches `a : Fin 4`, the
   four branch facts: nullity, nonzero symbol, nilpotency, and a
   linearly-independent pair of opposite-chirality kernel modes, together with
   `no_full_symbol_single_chirality`.

2. `no_branch_single_sign` is the per-branch strengthening: for every branch
   `a`, not only `a = 0`, no single `gamma5` sign describes the whole bare
   kernel. Equivalently, any argument using only the bare symbol on branch `a`
   cannot derive one chirality sign (`bare_symbol_proof_cannot_fix_chirality`).

3. `chiralProj` and `chiralProj_forces_alignment` identify sufficient extra
   data: the chirality-selecting projector
   `P a v = (1 / 2) * (v + (g5 a) * gamma5 v)` discharges
   `OperatorForcesAlignmentAfterProjection`. This shows what data the bare
   symbol lacks; it is not a physical release theorem.

4. `chiralProj_cuts_kernel` shows that this projector genuinely breaks the
   balance: on each branch it keeps one chirality kernel mode and annihilates
   the linearly-independent opposite one.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeHyperdiamondNoGo

open Matrix
open PhysicsSM.Draft.TetrahedralNullBranch
open PhysicsSM.Draft.NullEdgeFlavoredChirality
open PhysicsSM.Draft.NullEdgeActualCliffordSymbol

/-! ## Helper facts about the spacetime chirality `gamma5` -/

/-- `gamma5 * gamma5 = 1`. -/
theorem gamma5_sq : gamma5 * gamma5 = 1 := by
  unfold gamma5
  rw [Matrix.fromBlocks_multiply]
  simp [Matrix.fromBlocks_one]

/-- `gamma5` is an involution on spinors. -/
theorem gamma5_mulVec_involutive (v : Spin → ℂ) :
    gamma5 *ᵥ (gamma5 *ᵥ v) = v := by
  rw [Matrix.mulVec_mulVec, gamma5_sq, Matrix.one_mulVec]

/-- The model chirality sign squares to one: `(g5 a)^2 = 1`. -/
theorem g5_sq_one (a : Fin 4) : ((g5 a : ℝ) : ℂ) * ((g5 a : ℝ) : ℂ) = 1 := by
  fin_cases a <;> simp [g5]

/-! ## 1. Bundled high-momentum branch no-go -/

/-- **All four branches, bundled with the no-go.** For every high-momentum null
branch `a`, the bare symbol is null and nonzero, nilpotent, and its kernel
contains a linearly-independent pair of opposite-`gamma5` zero modes. The final
conjunct records that the bare family cannot force a single chirality sign. -/
theorem highMomentum_branch_nogo :
    (∀ a : Fin 4,
      mink (branchP a) = 0 ∧
      branchP a ≠ 0 ∧
      cliffordSymbol (branchP a) ≠ 0 ∧
      cliffordSymbol (branchP a) * cliffordSymbol (branchP a) = 0 ∧
      (∃ vplus vminus : Spin → ℂ,
        (vplus ≠ 0 ∧ cliffordSymbol (branchP a) *ᵥ vplus = 0 ∧
          gamma5 *ᵥ vplus = vplus) ∧
        (vminus ≠ 0 ∧ cliffordSymbol (branchP a) *ᵥ vminus = 0 ∧
          gamma5 *ᵥ vminus = -vminus) ∧
        LinearIndependent ℂ ![vplus, vminus])) ∧
    ¬ ∃ ε : Fin 4 → ℂ, BareOperatorAssignsSingleSign ε := by
  refine ⟨fun a => ⟨branchP_mink_zero a, branchP_ne_zero a,
    branch_cliffordSymbol_ne_zero a, branch_cliffordSymbol_sq_zero a,
    branchKernel_chirality_sign a⟩, no_full_symbol_single_chirality⟩

/-! ## 2. Per-branch strengthening -/

/-- The bare symbol on branch `a` assigns a single `gamma5` sign `s` iff every
nonzero zero mode of `c(branchP a)` is a `gamma5` eigenvector with eigenvalue
`s`. -/
def BranchAssignsSingleSign (a : Fin 4) (s : ℂ) : Prop :=
  ∀ v : Spin → ℂ, v ≠ 0 → cliffordSymbol (branchP a) *ᵥ v = 0 →
    gamma5 *ᵥ v = s • v

/-- **Per-branch no-go.** For every high-momentum null branch `a`, the bare
symbol kernel is not monochromatic: no single `gamma5` sign describes it,
because it contains both a `+1` and a `-1` mode. -/
theorem no_branch_single_sign (a : Fin 4) :
    ¬ ∃ s : ℂ, BranchAssignsSingleSign a s := by
  obtain ⟨vplus, hvplus⟩ := branchKernel_chirality_sign a
  contrapose! hvplus
  simp_all +decide [BranchAssignsSingleSign]
  obtain ⟨s, hs⟩ := hvplus
  have := hs vplus
  simp_all +decide [funext_iff]
  grind +splitImp

/-- Any bare-symbol-only proof cannot fix a chirality sign on branch `a`.
For every candidate sign `s`, there is a nonzero zero mode of the bare symbol
whose `gamma5` action is not multiplication by `s`. -/
theorem bare_symbol_proof_cannot_fix_chirality (a : Fin 4) (s : ℂ) :
    ∃ v : Spin → ℂ, v ≠ 0 ∧ cliffordSymbol (branchP a) *ᵥ v = 0 ∧
      gamma5 *ᵥ v ≠ s • v := by
  by_contra! h
  exact no_branch_single_sign a ⟨s, h⟩

/-! ## 3. The extra projection data that breaks the balance -/

/-- The chirality-selecting projector on branch `a`:
`P a v = (1 / 2) * (v + (g5 a) * gamma5 v)`. This is an explicit realization
of the projection data referenced by `OperatorForcesAlignmentAfterProjection`;
it projects onto the `gamma5 = g5 a` eigenspace. -/
def chiralProj (a : Fin 4) (v : Spin → ℂ) : Spin → ℂ :=
  (1/2 : ℂ) • (v + ((g5 a : ℝ) : ℂ) • (gamma5 *ᵥ v))

/-- `chiralProj a v` lands in the `gamma5 = g5 a` eigenspace. -/
theorem gamma5_chiralProj (a : Fin 4) (v : Spin → ℂ) :
    gamma5 *ᵥ (chiralProj a v) = ((g5 a : ℝ) : ℂ) • (chiralProj a v) := by
  ext x
  simp +decide [chiralProj, Matrix.mulVec, dotProduct]
  fin_cases x <;> simp +decide [gamma5] <;> ring_nf!
  all_goals fin_cases a <;> norm_num [g5]

/-- **The extra data forces alignment.** The chirality-selecting projector
`chiralProj` discharges `OperatorForcesAlignmentAfterProjection`: after this
projection each branch kernel carries the single `gamma5` sign `g5 a`.
This identifies sufficient additional projection data; it is not a physical
release theorem. -/
theorem chiralProj_forces_alignment :
    OperatorForcesAlignmentAfterProjection chiralProj := by
  intro a v _ _ _
  exact gamma5_chiralProj a v

/-! ## 4. The projector genuinely breaks the balanced kernel -/

/-- `chiralProj` acts as the scalar `(1 / 2) * (1 + (g5 a) * e)` on a
`gamma5` eigenvector of eigenvalue `e`. -/
theorem chiralProj_on_eigen (a : Fin 4) (v : Spin → ℂ) (e : ℂ)
    (h : gamma5 *ᵥ v = e • v) :
    chiralProj a v = ((1/2 : ℂ) * (1 + ((g5 a : ℝ) : ℂ) * e)) • v := by
  ext x
  simp [chiralProj, h]
  ring

/-- **The projection cuts the balanced kernel.** On each high-momentum null
branch there are two linearly-independent zero modes of the bare symbol such
that `chiralProj` keeps one and annihilates the other. Hence the
two-dimensional chirality-balanced bare kernel is cut down to a selected
one-dimensional subspace by extra projection data. -/
theorem chiralProj_cuts_kernel (a : Fin 4) :
    ∃ vkeep vkill : Spin → ℂ,
      cliffordSymbol (branchP a) *ᵥ vkeep = 0 ∧
      cliffordSymbol (branchP a) *ᵥ vkill = 0 ∧
      LinearIndependent ℂ ![vkeep, vkill] ∧
      chiralProj a vkeep ≠ 0 ∧
      chiralProj a vkill = 0 := by
  by_cases h_g5 : (g5 a : ℝ) = 1
  · obtain ⟨vplus, vminus, hvplus, hvminus, hlinind⟩ :=
      branchKernel_chirality_sign a
    refine' ⟨vplus, vminus, hvplus.2.1, hvminus.2.1, hlinind, _, _⟩ <;>
      simp_all +decide [chiralProj]
    simp_all +decide [← two_smul ℂ]
  · obtain ⟨vplus, vminus, hvplus, hvminus, hv⟩ := branchKernel_chirality_sign a
    refine' ⟨vminus, vplus, _, _, _, _, _⟩ <;> simp_all +decide
    · rw [Fintype.linearIndependent_iff] at *
      intro g hg i
      specialize hv (fun j => g (1 - j))
      simp_all +decide [Fin.sum_univ_succ]
      fin_cases i <;> simp_all +decide [add_comm]
    · unfold chiralProj
      simp_all +decide [funext_iff, Fin.forall_fin_succ]
      fin_cases a <;> simp_all +decide [g5]
    · convert chiralProj_on_eigen a vplus 1 _ using 1 <;> norm_num [hvplus]
      fin_cases a <;> simp +decide [g5] at h_g5 ⊢

end PhysicsSM.Draft.NullEdgeHyperdiamondNoGo
