import Mathlib
import PhysicsSM.Draft.NullEdgeGateCReleaseCriterion
import PhysicsSM.Draft.KreinDoubleAndCounterexamples

/-!
# C22: branch projectors, branch chirality, and branch Krein signatures (Gate C)

This module is the C22 deliverable building the strongest *finite* algebra
package presently possible around the Gate C branch data, supporting C21.

## Provenance and non-duplication

* The four high-momentum null branches (`{0,π}^4` corners with exactly three
  `π` edges) and their Lorentzian classification come from
  `PhysicsSM.Draft.TetrahedralNullBranch`.
* The per-branch null projectors `Pbranch a`, the modeled spacetime chirality
  `GammaS`, the null projector `Pnull`, the modeled Krein metric `kreinJ`, the
  chirality pattern `g5`, and the operator-built flavored chirality
  `GammaFlavOp` / index `flavoredOp_index` come from
  `PhysicsSM.Draft.NullEdgeFlavoredChirality` and
  `PhysicsSM.Draft.NullEdgeGateCReleaseCriterion`.  **We do not duplicate them.**
* The "Krein `J`-self-adjointness is not stability" counterexamples come from
  `PhysicsSM.Draft.KreinDoubleAndCounterexamples`; here we only re-export them
  into the branch context as an explicit overclaim guard.

## What this module adds (the C22 tasks)

1. **Branch-projector algebra** (Task 1): the per-branch projectors are
   idempotent (`Pbranch_idem`), mutually orthogonal (`Pbranch_orthogonal`),
   symmetric (`Pbranch_symm`), rank-one (`Pbranch_trace`), and complete over the
   branch sector (`Pbranch_completeness` : `∑_a P_a = P_null`).

2. **Projector-based flavored chirality** (Task 2): reuses
   `GammaFlavOp s = Σ_a s a • (P_a Γ_s P_a)` and the per-branch reduction
   `P_a Γ_s P_a = g5 a • P_a`.

3. **Connection to the C19 index criterion** (Task 3):
   `branchChirality a := tr(Γ_s P_a) = g5 a` (`branchChirality_eq`), so the
   flavored index `tr(GammaFlavOp s · P_null) = Σ_a s a · branchChirality a`
   (`flavoredOp_index_branchChirality`).

4. **Branch Krein signatures** (Task 4): for the *modeled* Krein metric `kreinJ`
   the per-branch Krein signature is
   `branchKreinSig a := tr(J P_a) = (-1)^a` (`branchKreinSig_eq`), giving the
   pattern `(+,-,+,-)` (`branchKreinSig_values`).  The branch sector is
   Krein-**indefinite**: its signature sums to zero (`branchKreinSig_sum_zero`)
   and Krein-negative branch modes exist (`exists_krein_negative_branch`).

5. **Overclaim guards** (Task 5):
   * `kreinSig_ne_chirality`: the Krein signature pattern `(+,-,+,-)` is **not**
     the chirality pattern `(+,+,-,-)`; chirality alignment does **not** entail
     Krein positivity.
   * `modeled_release_not_kreinPositive`: even though the modeled branch
     chirality is aligned (`s = g5`, releasing the flavored index), the modeled
     branches are **not** all Krein-positive — so the release is not a
     positive-definite physical sector.
   * `branch_krein_no_stability_guard`: re-export of the finite counterexample
     showing Krein `J`-self-adjointness does not imply spectral stability.

## Honest scope and verdict

Everything here is proved for the **modeled** gradings `GammaS`, `kreinJ` of the
Wave-8 finite model, *not* derived from the actual flat tetrahedral Clifford
symbol.  The actual `4×4` Clifford symbol, its per-branch kernels, and the
chirality / Krein eigenvalue on each kernel are **not** formalized in the
current tree (only the scalar quadratic form `qform` and its null corners are).
The conditional API `ReleasesKreinPositive` and the residual obligations record
exactly what C21 must supply.

**Verdict: CONDITIONAL.**  A complete finite branch-projector + Krein-signature
package is available *for the modeled gradings*, and it already shows that
chirality-aligned release is *not* automatically Krein-positive (Krein-negative
branch modes are present).  Promotion to a forced Gate C statement remains
PENDING on C21 supplying the actual operator eigenspaces and their Krein
eigenvalues; only then can `ReleasesKreinPositive` be evaluated on real data.
-/

noncomputable section

namespace PhysicsSM.Draft.NullEdgeBranchKreinSignatures

open Matrix
open PhysicsSM.Draft.NullEdgeFlavoredChirality
open PhysicsSM.Draft.NullEdgeGateCReleaseCriterion

/-! ## Task 1: branch-projector algebra -/

/-
Each per-branch projector is idempotent: `P_a² = P_a`.
-/
theorem Pbranch_idem (a : Fin 4) : Pbranch a * Pbranch a = Pbranch a := by
  ext ⟨ i, j ⟩ ⟨ k, l ⟩ ; simp +decide [ Pbranch ] ;
  rw [ diagonal_apply ] ; aesop

/-
Distinct per-branch projectors are orthogonal: `P_a P_b = 0` for `a ≠ b`.
-/
theorem Pbranch_orthogonal {a b : Fin 4} (h : a ≠ b) :
    Pbranch a * Pbranch b = 0 := by
  unfold Pbranch;
  ext i j; by_cases hi : i = j <;> aesop;

/-
Each per-branch projector is symmetric (a real orthogonal projector).
-/
theorem Pbranch_symm (a : Fin 4) : (Pbranch a)ᵀ = Pbranch a := by
  -- Since Pbranch a is a diagonal matrix, its transpose is itself.
  ext i j; simp [Pbranch];
  by_cases hi : i = j <;> simp +decide [ hi ];
  exact if_neg ( by aesop )

/-
Each per-branch projector is rank one: `tr(P_a) = 1`.
-/
theorem Pbranch_trace (a : Fin 4) : (Pbranch a).trace = 1 := by
  unfold Pbranch;
  fin_cases a <;> simp +decide

/-- **Completeness over the branch sector.**  The four per-branch projectors sum
to the null projector: `Σ_a P_a = P_null`.  (Restatement of
`Pnull_eq_sum_Pbranch`.) -/
theorem Pbranch_completeness : (∑ a, Pbranch a) = Pnull :=
  (Pnull_eq_sum_Pbranch).symm

/-! ## Task 3: branch chirality and the C19 index criterion -/

/-- The spacetime-chirality eigenvalue read off branch `a`:
`branchChirality a := tr(Γ_s P_a)`. -/
def branchChirality (a : Fin 4) : ℝ := (GammaS * Pbranch a).trace

/-
The branch chirality equals the modeled chirality pattern `g5 a`.
-/
theorem branchChirality_eq (a : Fin 4) : branchChirality a = g5 a := by
  fin_cases a <;> simp +decide [ branchChirality, GammaS, Pbranch ];
  · rw [ Finset.sum_eq_single ( 0, 0 ) ] <;> aesop;
  · rw [ Finset.sum_eq_single ( 1, 1 ) ] <;> aesop;
  · rw [ Finset.sum_eq_single ( 2, 2 ) ] <;> aesop;
  · rw [ Finset.sum_eq_single ( 3, 3 ) ] <;> aesop

/-
**Connection to the C19 flavored index.**  The operator flavored index is the
branch-sign weighted sum of the branch chiralities:
`tr(GammaFlavOp s · P_null) = Σ_a s a · branchChirality a`.
-/
theorem flavoredOp_index_branchChirality (s : Fin 4 → ℝ) :
    (GammaFlavOp s * Pnull).trace = ∑ a, s a * branchChirality a := by
  convert flavoredOp_index s using 1;
  exact Finset.sum_congr rfl fun _ _ => by rw [ branchChirality_eq ] ;

/-! ## Task 4: branch Krein signatures (for the modeled Krein metric `kreinJ`) -/

/-- The Krein signature of branch `a` for the modeled fundamental symmetry
`kreinJ`: the `J`-norm of the (rank-one) branch eigenspace,
`branchKreinSig a := tr(J P_a)`. -/
def branchKreinSig (a : Fin 4) : ℝ := (kreinJ * Pbranch a).trace

/-
Closed form of the branch Krein signature: `tr(J P_a) = (-1)^a`, i.e.
`+1` for even branches and `-1` for odd branches.
-/
theorem branchKreinSig_eq (a : Fin 4) :
    branchKreinSig a = if a.val % 2 = 0 then 1 else -1 := by
  fin_cases a <;> simp +decide [ branchKreinSig, kreinJ, Pbranch, Matrix.diagonal_mul_diagonal,
    Matrix.trace_diagonal ]; all_goals norm_cast

/-
The branch Krein signatures form the pattern `(+,-,+,-)`.
-/
theorem branchKreinSig_values :
    (fun a => branchKreinSig a) = ![1, -1, 1, -1] := by
  funext a; fin_cases a <;> simp +decide [ branchKreinSig_eq ] ;

/-
**The branch sector is Krein-indefinite.**  The Krein signatures sum to zero
(signature `(2,2)`): two Krein-positive and two Krein-negative branch modes.
-/
theorem branchKreinSig_sum_zero : (∑ a, branchKreinSig a) = 0 := by
  rw [ Finset.sum_congr rfl fun _ _ => branchKreinSig_eq _ ] ; norm_cast

/-
**Krein-negative branch modes exist.**  At least one branch carries Krein
signature `-1`.
-/
theorem exists_krein_negative_branch : ∃ a, branchKreinSig a = -1 := by
  exact ⟨ 1, by rw [ branchKreinSig_eq ] ; norm_num ⟩

/-! ## Task 5: overclaim guards -/

/-
**Chirality alignment is not Krein positivity.**  The branch Krein signature
pattern `(+,-,+,-)` is not the chirality pattern `(+,+,-,-)`: aligning the
flavored chirality to release the index says nothing about Krein positivity.
-/
theorem kreinSig_ne_chirality :
    (fun a => branchKreinSig a) ≠ (fun a => branchChirality a) := by
  simp_all +decide [ branchKreinSig_eq, branchChirality_eq, funext_iff, Fin.forall_fin_succ ];
  unfold g5; norm_num;

/-- A conditional predicate isolating what a *Krein-positive* Gate C release
would require: the branch chirality is aligned (`chir = g5`, releasing the
flavored index) **and** every branch is Krein-positive (`krein a = 1`).  This is
the data C21's actual operator must provide to upgrade a flavored-index release
to a positive-definite physical sector. -/
def ReleasesKreinPositive (chir krein : Fin 4 → ℝ) : Prop :=
  chir = g5 ∧ (∀ a, krein a = 1)

/-
**The modeled release is not Krein-positive.**  Although the modeled branch
chirality is aligned (`branchChirality = g5`), the modeled branch Krein
signatures are not all `+1`; hence the modeled chirality-aligned release does
*not* yield a positive-definite Krein sector.
-/
theorem modeled_release_not_kreinPositive :
    ¬ ReleasesKreinPositive branchChirality branchKreinSig := by
  -- The second conjunct fails: branch 1 has Krein signature -1 ≠ 1.
  rintro ⟨-, h2⟩
  have := h2 1
  rw [branchKreinSig_eq] at this
  norm_num at this

/-- **Overclaim guard (re-export).**  Krein `J`-self-adjointness does not imply
spectral stability: there is a finite `J`-self-adjoint operator with an
eigenvalue of positive real part (a growing mode).  This is
`PhysicsSM.Draft.jselfadj_not_stable` carried into the branch context. -/
theorem branch_krein_no_stability_guard :
    PhysicsSM.Draft.sharp PhysicsSM.Draft.J2 PhysicsSM.Draft.A2 = PhysicsSM.Draft.A2 ∧
      ∃ (μ : ℂ) (v : Fin 2 → ℂ),
        v ≠ 0 ∧ PhysicsSM.Draft.A2.mulVec v = μ • v ∧ 0 < μ.re :=
  PhysicsSM.Draft.jselfadj_not_stable

/-- **C22 summary.**  The finite branch-projector + Krein package:
the projectors are a complete orthogonal idempotent family over the branch
sector; the flavored index is the branch-chirality weighted sum; and for the
modeled Krein metric the branch sector is Krein-indefinite, so a
chirality-aligned flavored-index release is **not** automatically Krein-positive
(Krein-negative branch modes exist), while Krein self-adjointness alone never
implies stability. -/
theorem c22_branch_krein_summary :
    (∀ a, Pbranch a * Pbranch a = Pbranch a) ∧
    ((∑ a, Pbranch a) = Pnull) ∧
    (∀ s : Fin 4 → ℝ,
      (GammaFlavOp s * Pnull).trace = ∑ a, s a * branchChirality a) ∧
    ((∑ a, branchKreinSig a) = 0) ∧
    (∃ a, branchKreinSig a = -1) ∧
    (¬ ReleasesKreinPositive branchChirality branchKreinSig) :=
  ⟨Pbranch_idem, Pbranch_completeness, flavoredOp_index_branchChirality,
    branchKreinSig_sum_zero, exists_krein_negative_branch,
    modeled_release_not_kreinPositive⟩

end PhysicsSM.Draft.NullEdgeBranchKreinSignatures
