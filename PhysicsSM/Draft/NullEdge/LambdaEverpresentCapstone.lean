import Mathlib
import PhysicsSM.Draft.NullEdge.LambdaUnimodular
import PhysicsSM.Draft.NullEdge.LambdaSusceptibility
import PhysicsSM.Draft.NullEdge.LambdaCountDichotomy
import PhysicsSM.Draft.NullEdge.LambdaConjugacy
import PhysicsSM.Draft.NullEdge.LambdaMomentHierarchy
import PhysicsSM.Draft.NullEdge.LambdaTwoRegionCovariance
import PhysicsSM.Draft.NullEdge.VacuumSequestering
import PhysicsSM.Draft.NullEdge.LambdaEdgeCount
import PhysicsSM.Draft.NullEdge.LambdaThreeSplit
import PhysicsSM.Draft.NullEdge.LambdaFrameConstraint

/-!

PRECISION (structural audit, Opus 2026-07-21). Three theorems in this module -
`lambda_everpresent_sequestering_verdict`, `lambda_frame_blindness_capstone`, and
`lambda_sequestering_branch_capstone` - have proofs that are ANONYMOUS CONSTRUCTORS
bundling already-proved results. They are **build-enforced integration pins**, not new
mathematical content: they add no information beyond the conjunction of their components,
and nothing in them could fail that was not already provable. That is a legitimate and
useful engineering role, but "capstone" and "verdict" must not be read as a culminating
result. Quote the components, not the bundle.

An earlier physical gloss of the frame-blindness result - that invariance forbids
hyperuniform suppression, and that this blocks the everpresent-`Lambda` escape route -
was WITHDRAWN on 2026-07-21 after a literature check (Torquato, arXiv:1801.06924:
disordered hyperuniform systems are statistically isotropic by definition) and after a
companion Lean job refuted the successor claim too (`HyperuniformityRankDichotomy`: rank
two admits `I - J/N`, so hyperuniformity is never obstructed - only regional quiet is).
Nothing here derives the value, sign, or magnitude of `Lambda`. Binding gloss:
`AgentTasks/lambda-harvest-governance-2026-07-21.md`.
# The finite cosmological-Λ everpresent/sequestering capstone

This file composes the finite, kernel-checked Λ modules of `PhysicsSM.Draft.NullEdge`
into three branch capstones and one headline verdict.

**Honest semantic scope.**  Everything here is a *finite structural* statement over
rational matrices, finite counts, and finite covariance/variance.  It is **not** a
derivation of the measured value (or physical sign) of the cosmological constant.
The package establishes, in the kernel:

* uniform vacuum shifts (`c • 1`) are removed by the traceless / unimodular /
  sequestering dynamics;
* the surviving observable Λ handle is a count/variance branch;
* a frame-blind (permutation-invariant) finite covariance can suppress *at most* the
  uniform grand-total mode, while hyperuniform suppression of a regional non-uniform
  mode necessarily breaks frame-blindness.

Because the source `_verdict`/`_witness` results are Lean *theorems* (proof terms),
they cannot be placed directly in a `∧` in the object position.  We therefore package
each branch's payload as a `Prop`-valued definition (`*_stmt`), give the requested
`theorem` a proof by anonymous constructor bundling the source verdicts, and let the
headline conjoin the three branch `Prop`s.  Parameterized source theorems in the count
branch (`everpresent_verdict`, `susceptibility_reading`, `dichotomy_criterion`) are
instantiated at the explicit nondegenerate witnesses requested (`N = 100`, `δN = 10`,
etc.) or kept in their `∀`-quantified form.
-/

open Matrix

namespace LambdaEverpresentCapstone

/-! ## Branch 1 : sequestering / unimodular removal of uniform Λ shifts -/

/-- Payload `Prop` bundled by `lambda_sequestering_branch_capstone`. -/
def seqBranchStmt : Prop :=
  -- `LambdaUnimodular.unimodular_verdict`
  ((∀ (Aop : LambdaUnimodular.Mat), Aop.IsSymm → ∀ (c : ℚ) (x : LambdaUnimodular.Vec), x ≠ 0 →
        (LambdaUnimodular.Stationary Aop c x ↔ ∃ Λ : ℚ, Aop *ᵥ x + c • x = Λ • x)) ∧
      (∀ (Aop : LambdaUnimodular.Mat) (c δ v0 : ℚ) (x : LambdaUnimodular.Vec),
          LambdaUnimodular.Vol x = v0 →
          LambdaUnimodular.S Aop (c + δ) x = LambdaUnimodular.S Aop c x + δ * v0) ∧
      (∀ (Aop : LambdaUnimodular.Mat) (c δ Λ : ℚ) (x : LambdaUnimodular.Vec),
          Aop *ᵥ x + c • x = Λ • x → Aop *ᵥ x + (c + δ) • x = (Λ + δ) • x) ∧
      (∀ (a0 : ℚ) (D P : LambdaUnimodular.Mat),
          LambdaUnimodular.order0Term a0 (D + P) = LambdaUnimodular.order0Term a0 D) ∧
      Matrix.trace (1 : LambdaUnimodular.Mat) = (LambdaUnimodular.n : ℚ) ∧
      (LambdaUnimodular.Stationary LambdaUnimodular.A 0 (![0, 1, 0] : LambdaUnimodular.Vec) ∧
        LambdaUnimodular.Vol (![0, 1, 0] : LambdaUnimodular.Vec) = 1 ∧
        LambdaUnimodular.A *ᵥ (![0, 1, 0] : LambdaUnimodular.Vec) + (0 : ℚ) • ![0, 1, 0]
            = (2 : ℚ) • ![0, 1, 0] ∧
        LambdaUnimodular.A *ᵥ (![0, 1, 0] : LambdaUnimodular.Vec) + (0 + 5 : ℚ) • ![0, 1, 0]
            = (2 + 5 : ℚ) • ![0, 1, 0] ∧
        ¬ LambdaUnimodular.Stationary LambdaUnimodular.A 0 (![1, 1, 0] : LambdaUnimodular.Vec))) ∧
  -- `VacuumSequestering.sequestering_verdict`
  ((∀ (A : VacuumSequestering.Sq) (x : VacuumSequestering.Vec) (L c : ℚ), A.mulVec x = L • x →
        (A + c • (1 : VacuumSequestering.Sq)).mulVec x = (L + c) • x) ∧
    (∀ (A : VacuumSequestering.Sq) (x : VacuumSequestering.Vec) (a0 : ℚ),
        VacuumSequestering.Action (A + a0 • (1 : VacuumSequestering.Sq)) x
          = VacuumSequestering.Action A x + a0 * VacuumSequestering.Vol x) ∧
    (∀ (A A' : VacuumSequestering.Sq) (c c' N deltaN : ℚ),
        VacuumSequestering.physicalLambda A c N deltaN
          = VacuumSequestering.physicalLambda A' c' N deltaN)) ∧
  -- `VacuumSequestering.sequestering_nondegeneracy`
  (VacuumSequestering.A0.mulVec VacuumSequestering.x0 = (1 : ℚ) • VacuumSequestering.x0 ∧
    VacuumSequestering.Vol VacuumSequestering.x0 = 1 ∧
    (VacuumSequestering.A0 + (10 ^ 6 : ℚ) • (1 : VacuumSequestering.Sq)).mulVec VacuumSequestering.x0
        = ((1 : ℚ) + 10 ^ 6) • VacuumSequestering.x0 ∧
    VacuumSequestering.physicalLambda VacuumSequestering.A0 (10 ^ 6) 100 10 = 1 / 10 ∧
    VacuumSequestering.physicalLambda
        (VacuumSequestering.A0 + (10 ^ 6 : ℚ) • (1 : VacuumSequestering.Sq)) (10 ^ 6) 100 10
      = 1 / 10) ∧
  -- `LambdaThreeSplit.three_lambda_verdict`
  ((LambdaThreeSplit.Lambda_naive 1 1 ≠ LambdaThreeSplit.Lambda_naive 2 3) ∧
    (∀ (H : LambdaThreeSplit.M) (c : ℚ),
        LambdaThreeSplit.seq (H + c • (1 : LambdaThreeSplit.M)) = LambdaThreeSplit.seq H) ∧
    (∀ (lb g : ℚ), LambdaThreeSplit.seq
        (LambdaThreeSplit.H0 + lb • (1 : LambdaThreeSplit.M) + g • LambdaThreeSplit.Hmat)
      = LambdaThreeSplit.seq (LambdaThreeSplit.H0 + g • LambdaThreeSplit.Hmat)) ∧
    (∀ N lb g lb' g' : ℚ, LambdaThreeSplit.Lambda_obs N lb g = LambdaThreeSplit.Lambda_obs N lb' g') ∧
    (LambdaThreeSplit.Lambda_count 3 ≠ LambdaThreeSplit.Lambda_count 5)) ∧
  -- `LambdaThreeSplit.sequestering_witness`
  (LambdaThreeSplit.Lambda_naive 1 1 ≠ LambdaThreeSplit.Lambda_naive 2 1 ∧
    LambdaThreeSplit.seq
        (LambdaThreeSplit.H0 + (1 : ℚ) • (1 : LambdaThreeSplit.M) + (1 : ℚ) • LambdaThreeSplit.Hmat)
      = LambdaThreeSplit.seq
        (LambdaThreeSplit.H0 + (2 : ℚ) • (1 : LambdaThreeSplit.M) + (1 : ℚ) • LambdaThreeSplit.Hmat)) ∧
  -- `LambdaThreeSplit.data_nondegenerate`
  (LambdaThreeSplit.H0 ≠ 0 ∧ LambdaThreeSplit.Hmat ≠ 0 ∧ LambdaThreeSplit.H0 ≠ LambdaThreeSplit.Hmat)

/-- **Sequestering / unimodular branch capstone.**  Bundles `unimodular_verdict`,
`sequestering_verdict`, `sequestering_nondegeneracy`, `three_lambda_verdict`,
`sequestering_witness`, and `data_nondegenerate`. -/
theorem lambda_sequestering_branch_capstone : seqBranchStmt :=
  ⟨LambdaUnimodular.unimodular_verdict,
   VacuumSequestering.sequestering_verdict,
   VacuumSequestering.sequestering_nondegeneracy,
   LambdaThreeSplit.three_lambda_verdict,
   LambdaThreeSplit.sequestering_witness,
   LambdaThreeSplit.data_nondegenerate⟩

/-! ## Branch 2 : the surviving Λ handle is count / variance data -/

/-- Payload `Prop` bundled by `lambda_count_branch_capstone`.  Parameterized source
theorems are instantiated at the explicit nondegenerate witnesses (`N = 100`,
`δN = 10`) or kept `∀`-quantified. -/
def countBranchStmt : Prop :=
  -- `LambdaEdgeCount.everpresent_verdict` at `δN = 10, N = 100`
  ((LambdaEdgeCount.lambdaOf 10 100) ^ 2 = 1 / 100 ∧
      Real.sqrt ((100 : ℝ) / 100 ^ 2) = 1 / Real.sqrt 100) ∧
  -- `LambdaEdgeCount.nondeg_secondMoment_N100`
  ((LambdaEdgeCount.lambdaOf 10 100) ^ 2 = 1 / 100) ∧
  -- `LambdaEdgeCount.nondeg_rms_N100`
  (Real.sqrt ((100 : ℝ) / 100 ^ 2) = 1 / 10) ∧
  -- `LambdaEdgeCount.nondeg_extensive`
  (LambdaEdgeCount.edgeCount (({0, 1, 2} : Finset ℕ) ∪ {3, 4}) =
      LambdaEdgeCount.edgeCount ({0, 1, 2} : Finset ℕ) + LambdaEdgeCount.edgeCount ({3, 4} : Finset ℕ)) ∧
  -- `LambdaSusceptibility.susceptibility_reading`
  (∀ {m : ℕ} (p : Fin m → ℚ) (j : Fin m) (a b : ℚ),
      LambdaSusceptibility.meanCount (Function.update p j a)
        - LambdaSusceptibility.meanCount (Function.update p j b) = a - b) ∧
  -- `LambdaSusceptibility.mean_witness`
  (LambdaSusceptibility.meanCount (n := 3) ![1 / 2, 1 / 3, 1 / 4] = 13 / 12) ∧
  -- `LambdaSusceptibility.var_witness`
  (LambdaSusceptibility.varCount (n := 3) ![1 / 2, 1 / 3, 1 / 4] = 95 / 144) ∧
  -- `LambdaCountDichotomy.dichotomy_criterion`
  (∀ (p wt : ℚ), 0 < p → p < 1 → 0 ≤ wt → wt ≤ 1 →
      LambdaCountDichotomy.Extensive (LambdaCountDichotomy.freeVarSeq p) ∧
        LambdaCountDichotomy.Subextensive LambdaCountDichotomy.hardVarSeq ∧
        LambdaCountDichotomy.Subextensive (LambdaCountDichotomy.softVarSeq wt)) ∧
  -- `LambdaCountDichotomy.free_witness`
  (LambdaCountDichotomy.E (LambdaCountDichotomy.freeW 3 (1 / 2)) (LambdaCountDichotomy.edgeCount 3) = 3 / 2 ∧
    LambdaCountDichotomy.Var (LambdaCountDichotomy.freeW 3 (1 / 2)) (LambdaCountDichotomy.edgeCount 3) = 3 / 4 ∧
    LambdaCountDichotomy.Var (LambdaCountDichotomy.freeW 3 (1 / 2)) (LambdaCountDichotomy.edgeCount 3) / (3 : ℚ)
      = 1 / 4) ∧
  -- `LambdaCountDichotomy.hard_witness`
  (LambdaCountDichotomy.E (LambdaCountDichotomy.hardW 3 2) (LambdaCountDichotomy.hardN 3 2) = 2 ∧
    LambdaCountDichotomy.Var (LambdaCountDichotomy.hardW 3 2) (LambdaCountDichotomy.hardN 3 2) = 0) ∧
  -- `LambdaCountDichotomy.tworeg_witness`
  (LambdaCountDichotomy.Var (LambdaCountDichotomy.tworegW 3 (1 / 2) 3 2) (LambdaCountDichotomy.tworegCharge 3 3 2) = 0 ∧
    LambdaCountDichotomy.Var (LambdaCountDichotomy.tworegW 3 (1 / 2) 3 2) (LambdaCountDichotomy.tworegEdge 3 3 2) = 3 / 4)

/-- **Count / variance branch capstone.**  Bundles `everpresent_verdict` on the
explicit `N = 100` nondegenerate count witness together with the `N = 100`
nondegeneracy checks, the susceptibility reading and its mean/variance witnesses,
and the count dichotomy criterion with its free/hard/two-register witnesses. -/
theorem lambda_count_branch_capstone : countBranchStmt :=
  ⟨LambdaEdgeCount.everpresent_verdict 10 100 100 (by norm_num) (by norm_num) (by norm_num),
   LambdaEdgeCount.nondeg_secondMoment_N100,
   LambdaEdgeCount.nondeg_rms_N100,
   LambdaEdgeCount.nondeg_extensive,
   fun {m} p j a b => LambdaSusceptibility.susceptibility_reading p j a b,
   LambdaSusceptibility.mean_witness,
   LambdaSusceptibility.var_witness,
   fun p wt h0 h1 h2 h3 => LambdaCountDichotomy.dichotomy_criterion p wt h0 h1 h2 h3,
   LambdaCountDichotomy.free_witness,
   LambdaCountDichotomy.hard_witness,
   LambdaCountDichotomy.tworeg_witness⟩

/-! ## Branch 3 : frame-blindness only permits the uniform suppressed mode -/

/-- Payload `Prop` bundled by `lambda_frame_blindness_capstone`. -/
def frameBranchStmt : Prop :=
  -- `LambdaFrameConstraint.frame_blind_everpresent_verdict`
  (((∀ (C : Matrix (Fin 3) (Fin 3) ℚ), C.IsSymm → LambdaFrameConstraint.FrameBlind C →
        ∀ a b : ℚ, C = a • (1 : Matrix (Fin 3) (Fin 3) ℚ) + b • LambdaFrameConstraint.Jm → a ≠ 0 →
          ∀ v : Fin 3 → ℚ, C.mulVec v = 0 → v ≠ 0 → ∃ c : ℚ, c ≠ 0 ∧ v = fun _ => c) ∧
    (∃ C' : Matrix (Fin 3) (Fin 3) ℚ,
        C'.IsSymm ∧ C'.PosSemidef ∧ C'.mulVec ![1, -1, 0] = 0 ∧ ¬ LambdaFrameConstraint.FrameBlind C'))) ∧
  -- `LambdaFrameConstraint.uniform_suppressed_witness`
  ((1 + 3 * (-1 / 3 : ℚ) = 0) ∧
    ((1 : ℚ) • (1 : Matrix (Fin 3) (Fin 3) ℚ) + (-1 / 3 : ℚ) • LambdaFrameConstraint.Jm).mulVec
        LambdaFrameConstraint.ones = 0) ∧
  -- `LambdaFrameConstraint.nonuniform_suppression_breaks_symmetry`
  (∃ C' : Matrix (Fin 3) (Fin 3) ℚ,
      C'.IsSymm ∧ C'.PosSemidef ∧ C'.mulVec ![1, -1, 0] = 0 ∧
      ¬ LambdaFrameConstraint.FrameBlind C' ∧
      ¬ ∃ a b : ℚ, C' = a • (1 : Matrix (Fin 3) (Fin 3) ℚ) + b • LambdaFrameConstraint.Jm) ∧
  -- `LambdaTwoRegionCovariance.distinguisher_verdict`
  ((∀ a b c : ℚ, LambdaTwoRegionCovariance.var a b c LambdaTwoRegionCovariance.N1 = a + b ∧
        LambdaTwoRegionCovariance.var a b c LambdaTwoRegionCovariance.N2 = b + c ∧
        LambdaTwoRegionCovariance.cov a b c LambdaTwoRegionCovariance.N1 LambdaTwoRegionCovariance.N2 = b)
      ∧ (∀ a b c m1 m2 : ℚ, m1 ≠ 0 → m2 ≠ 0 →
          LambdaTwoRegionCovariance.cov a b c (LambdaTwoRegionCovariance.Lambda1 m1)
            (LambdaTwoRegionCovariance.Lambda2 m2) = b / (m1 * m2))
      ∧ (∀ b : ℚ, 0 < b → LambdaTwoRegionCovariance.corr 0 b 0 = 1)
      ∧ (∀ a c : ℚ, LambdaTwoRegionCovariance.corr a 0 c = 0)) ∧
  -- `LambdaTwoRegionCovariance.nested_witness`
  (LambdaTwoRegionCovariance.cov 1 98 1 LambdaTwoRegionCovariance.N1 LambdaTwoRegionCovariance.N2 = 98 ∧
    LambdaTwoRegionCovariance.corr 1 98 1 = 98 / 99) ∧
  -- `LambdaTwoRegionCovariance.decoupled_witness`
  (LambdaTwoRegionCovariance.cov 50 1 50 LambdaTwoRegionCovariance.N1 LambdaTwoRegionCovariance.N2 = 1 ∧
    LambdaTwoRegionCovariance.corr 50 1 50 = 1 / 51) ∧
  -- `LambdaMomentHierarchy.hierarchy_verdict`
  ((∀ (a0 : ℚ) {m : ℕ} (Dop Pert : Matrix (Fin m) (Fin m) ℚ),
        LambdaMomentHierarchy.order0 a0 (Dop + Pert) = LambdaMomentHierarchy.order0 a0 Dop) ∧
    (∀ (a0 a2 a4 : ℚ), LambdaMomentHierarchy.S a0 a2 a4 LambdaMomentHierarchy.D
        = LambdaMomentHierarchy.order0 a0 LambdaMomentHierarchy.D
          + LambdaMomentHierarchy.order2 a2 LambdaMomentHierarchy.D
          + LambdaMomentHierarchy.order4 a4 LambdaMomentHierarchy.D) ∧
    ((LambdaMomentHierarchy.D + LambdaMomentHierarchy.Pert) ^ 2).trace
        ≠ (LambdaMomentHierarchy.D ^ 2).trace ∧
    ((LambdaMomentHierarchy.D + LambdaMomentHierarchy.Pert) ^ 4).trace
        ≠ (LambdaMomentHierarchy.D ^ 4).trace) ∧
  -- `LambdaConjugacy.conjugacy_verdict`
  ((∀ N0 k : ZMod 4, Complex.normSq (LambdaConjugacy.dft (LambdaConjugacy.delta N0) k) = 1) ∧
    (∀ k : ZMod 4, LambdaConjugacy.dft LambdaConjugacy.uniform k = if k = 0 then 4 else 0) ∧
    (∀ f : ZMod 4 → ℂ, f ≠ 0 →
      4 ≤ (LambdaConjugacy.supp f).card * (LambdaConjugacy.supp (LambdaConjugacy.dft f)).card))

/-- **Frame-blindness branch capstone.**  Bundles `frame_blind_everpresent_verdict`,
`uniform_suppressed_witness`, `nonuniform_suppression_breaks_symmetry`, the two-region
`distinguisher_verdict` with its nested/decoupled witnesses, the moment
`hierarchy_verdict`, and the `conjugacy_verdict`. -/
theorem lambda_frame_blindness_capstone : frameBranchStmt :=
  ⟨LambdaFrameConstraint.frame_blind_everpresent_verdict,
   LambdaFrameConstraint.uniform_suppressed_witness,
   LambdaFrameConstraint.nonuniform_suppression_breaks_symmetry,
   LambdaTwoRegionCovariance.distinguisher_verdict,
   LambdaTwoRegionCovariance.nested_witness,
   LambdaTwoRegionCovariance.decoupled_witness,
   LambdaMomentHierarchy.hierarchy_verdict,
   LambdaConjugacy.conjugacy_verdict⟩

/-! ## Headline : the finite everpresent / sequestering verdict -/

/-- **Headline finite verdict.**  The three branch capstones hold simultaneously:

* uniform vacuum shifts are removed by the sequestering / unimodular dynamics
  (`seqBranchStmt`);
* the remaining Λ handle is count / variance data (`countBranchStmt`);
* a frame-blind finite covariance suppresses at most the uniform grand-total mode,
  and hyperuniform suppression of a regional non-uniform mode breaks frame-blindness
  (`frameBranchStmt`).

Honest scope: this is finite structural Λ support (rational matrices, finite counts,
finite covariance), **not** a derivation of the measured value or physical sign of
the cosmological constant. -/
theorem lambda_everpresent_sequestering_verdict :
    seqBranchStmt ∧ countBranchStmt ∧ frameBranchStmt :=
  ⟨lambda_sequestering_branch_capstone,
   lambda_count_branch_capstone,
   lambda_frame_blindness_capstone⟩

/-! ## Axiom footprint of every headline -/

/-- info: 'LambdaEverpresentCapstone.lambda_sequestering_branch_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms lambda_sequestering_branch_capstone

/-- info: 'LambdaEverpresentCapstone.lambda_count_branch_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms lambda_count_branch_capstone

/-- info: 'LambdaEverpresentCapstone.lambda_frame_blindness_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms lambda_frame_blindness_capstone

/-- info: 'LambdaEverpresentCapstone.lambda_everpresent_sequestering_verdict' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms lambda_everpresent_sequestering_verdict

end LambdaEverpresentCapstone
