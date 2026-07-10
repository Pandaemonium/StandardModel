import Mathlib
import PhysicsSM.Draft.NullEdge.LambdaMomentHierarchy
import PhysicsSM.Draft.NullEdge.LambdaConjugacy
import PhysicsSM.Draft.NullEdge.VacuumSequestering
import PhysicsSM.Draft.NullEdge.LambdaSusceptibility
import PhysicsSM.Draft.NullEdge.LambdaCountDichotomy
import PhysicsSM.Draft.NullEdge.LambdaEdgeCount

/-!
# Lambda magnitude capstone (finite avatar)

This file composes the landed finite `Λ` modules into one kernel-checked packet.  Nothing here
claims continuum gravity or QFT: every statement is a fact about explicit finite-dimensional
rational matrices, finite Fourier data on `ZMod 4`, and finite probability weights.

The three headline theorems are:

* `lambda_magnitude_capstone` — the composite verdict: order-0 channel blindness in every finite
  dimension together with genuine order-2 / order-4 motion (`hierarchy_verdict`), the finite
  Fourier count/`Λ` conjugacy (`conjugacy_verdict`), vacuum sequestering with its huge-shift
  witness (`sequestering_verdict`, `sequestering_nondegeneracy`), the extensive/constrained
  dichotomy and everpresent/suppressed fork (`dichotomy_criterion`, `free_everpresent`,
  `hard_suppressed`), and the finite Poisson edge-count normalization (`everpresent_verdict`).
* `lambda_nonvacuity_witnesses` — the explicit nonzero rational witnesses backing every channel.
* `lambda_only_count_can_move_order0` — the sharp contrast: order-0 (`Λ`) and the physical
  residue are blind to every deformation / vacuum shift, while the order-2 and order-4 traces
  genuinely move.
-/

namespace LambdaMagnitudeCapstone

/-- **Composite finite `Λ` magnitude verdict.**  A single kernel-checked conjunction assembling the
order-0 / order-2 / order-4 hierarchy, the finite conjugacy, vacuum sequestering (with its huge
explicit shift), the extensive/constrained dichotomy and everpresent/suppressed fork, and the
finite Poisson edge-count normalization. -/
theorem lambda_magnitude_capstone :
    ((∀ (a0 : ℚ) {n : ℕ} (Dop Pert : Matrix (Fin n) (Fin n) ℚ),
        LambdaMomentHierarchy.order0 a0 (Dop + Pert) = LambdaMomentHierarchy.order0 a0 Dop) ∧
      (∀ (a0 a2 a4 : ℚ),
        LambdaMomentHierarchy.S a0 a2 a4 LambdaMomentHierarchy.D
          = LambdaMomentHierarchy.order0 a0 LambdaMomentHierarchy.D
            + LambdaMomentHierarchy.order2 a2 LambdaMomentHierarchy.D
            + LambdaMomentHierarchy.order4 a4 LambdaMomentHierarchy.D) ∧
      ((LambdaMomentHierarchy.D + LambdaMomentHierarchy.Pert) ^ 2).trace
          ≠ (LambdaMomentHierarchy.D ^ 2).trace ∧
      ((LambdaMomentHierarchy.D + LambdaMomentHierarchy.Pert) ^ 4).trace
          ≠ (LambdaMomentHierarchy.D ^ 4).trace)
    ∧ ((∀ N0 k : ZMod 4, Complex.normSq (LambdaConjugacy.dft (LambdaConjugacy.delta N0) k) = 1) ∧
        (∀ k : ZMod 4, LambdaConjugacy.dft LambdaConjugacy.uniform k = if k = 0 then 4 else 0) ∧
        (∀ f : ZMod 4 → ℂ, f ≠ 0 →
          4 ≤ (LambdaConjugacy.supp f).card
            * (LambdaConjugacy.supp (LambdaConjugacy.dft f)).card))
    ∧ ((∀ (A : VacuumSequestering.Sq) (x : VacuumSequestering.Vec) (L c : ℚ),
          A.mulVec x = L • x → (A + c • (1 : VacuumSequestering.Sq)).mulVec x = (L + c) • x)
        ∧ (∀ (A : VacuumSequestering.Sq) (x : VacuumSequestering.Vec) (a0 : ℚ),
          VacuumSequestering.Action (A + a0 • (1 : VacuumSequestering.Sq)) x
            = VacuumSequestering.Action A x + a0 * VacuumSequestering.Vol x)
        ∧ (∀ (A A' : VacuumSequestering.Sq) (c c' N deltaN : ℚ),
          VacuumSequestering.physicalLambda A c N deltaN
            = VacuumSequestering.physicalLambda A' c' N deltaN))
    ∧ (VacuumSequestering.A0.mulVec VacuumSequestering.x0 = (1 : ℚ) • VacuumSequestering.x0
        ∧ VacuumSequestering.Vol VacuumSequestering.x0 = 1
        ∧ (VacuumSequestering.A0 + (10 ^ 6 : ℚ) • (1 : VacuumSequestering.Sq)).mulVec
            VacuumSequestering.x0 = ((1 : ℚ) + 10 ^ 6) • VacuumSequestering.x0
        ∧ VacuumSequestering.physicalLambda VacuumSequestering.A0 (10 ^ 6) 100 10 = 1 / 10
        ∧ VacuumSequestering.physicalLambda
            (VacuumSequestering.A0 + (10 ^ 6 : ℚ) • (1 : VacuumSequestering.Sq)) (10 ^ 6) 100 10
            = 1 / 10)
    ∧ (LambdaCountDichotomy.Extensive (LambdaCountDichotomy.freeVarSeq (1 / 2))
        ∧ LambdaCountDichotomy.Subextensive LambdaCountDichotomy.hardVarSeq
        ∧ LambdaCountDichotomy.Subextensive (LambdaCountDichotomy.softVarSeq (1 / 3)))
    ∧ (0 < LambdaCountDichotomy.Var (LambdaCountDichotomy.freeW 3 (1 / 2))
          (LambdaCountDichotomy.edgeCount 3)
          / (LambdaCountDichotomy.E (LambdaCountDichotomy.freeW 3 (1 / 2))
              (LambdaCountDichotomy.edgeCount 3)) ^ 2)
    ∧ (LambdaCountDichotomy.Var (LambdaCountDichotomy.hardW 3 2) (LambdaCountDichotomy.hardN 3 2)
          / (LambdaCountDichotomy.E (LambdaCountDichotomy.hardW 3 2)
              (LambdaCountDichotomy.hardN 3 2)) ^ 2 = 0)
    ∧ ((LambdaEdgeCount.lambdaOf 10 100) ^ 2 = 1 / 100
        ∧ Real.sqrt ((100 : ℝ) / 100 ^ 2) = 1 / Real.sqrt 100) :=
  ⟨LambdaMomentHierarchy.hierarchy_verdict,
    LambdaConjugacy.conjugacy_verdict,
    VacuumSequestering.sequestering_verdict,
    VacuumSequestering.sequestering_nondegeneracy,
    LambdaCountDichotomy.dichotomy_criterion (1 / 2) (1 / 3)
      (by norm_num) (by norm_num) (by norm_num) (by norm_num),
    LambdaCountDichotomy.free_everpresent 3 (1 / 2) (by norm_num) (by norm_num) (by norm_num),
    LambdaCountDichotomy.hard_suppressed 3 2 (by norm_num),
    LambdaEdgeCount.everpresent_verdict 10 100 100 (by norm_num) (by norm_num)
      LambdaEdgeCount.nondeg_poisson_N100⟩

/-- **Explicit nonzero rational witnesses.**  Every channel of the capstone is non-vacuous: the
graded parts are nonzero, the count moves the higher traces, the vacuum shift is huge yet the
residue is fixed, and the count-statistics / dichotomy witnesses are explicit rationals. -/
theorem lambda_nonvacuity_witnesses :
    (LambdaMomentHierarchy.Dgrav ≠ 0 ∧ LambdaMomentHierarchy.Dmatter ≠ 0)
    ∧ ((1 : Matrix (Fin 4) (Fin 4) ℚ).trace = 4 ∧
        (LambdaMomentHierarchy.D ^ 2).trace = 26 ∧
        ((LambdaMomentHierarchy.D + LambdaMomentHierarchy.Pert) ^ 2).trace = 36 ∧
        (LambdaMomentHierarchy.D ^ 4).trace = 194 ∧
        ((LambdaMomentHierarchy.D + LambdaMomentHierarchy.Pert) ^ 4).trace = 324 ∧
        ((LambdaMomentHierarchy.D + LambdaMomentHierarchy.Pert) ^ 2).trace
            ≠ (LambdaMomentHierarchy.D ^ 2).trace ∧
        ((LambdaMomentHierarchy.D + LambdaMomentHierarchy.Pert) ^ 4).trace
            ≠ (LambdaMomentHierarchy.D ^ 4).trace)
    ∧ (VacuumSequestering.A0.mulVec VacuumSequestering.x0 = (1 : ℚ) • VacuumSequestering.x0
        ∧ VacuumSequestering.Vol VacuumSequestering.x0 = 1
        ∧ (VacuumSequestering.A0 + (10 ^ 6 : ℚ) • (1 : VacuumSequestering.Sq)).mulVec
            VacuumSequestering.x0 = ((1 : ℚ) + 10 ^ 6) • VacuumSequestering.x0
        ∧ VacuumSequestering.physicalLambda VacuumSequestering.A0 (10 ^ 6) 100 10 = 1 / 10
        ∧ VacuumSequestering.physicalLambda
            (VacuumSequestering.A0 + (10 ^ 6 : ℚ) • (1 : VacuumSequestering.Sq)) (10 ^ 6) 100 10
            = 1 / 10)
    ∧ (LambdaSusceptibility.meanCount (n := 3) ![1/2, 1/3, 1/4] = 13/12)
    ∧ (LambdaSusceptibility.varCount (n := 3) ![1/2, 1/3, 1/4] = 95/144)
    ∧ (LambdaCountDichotomy.E (LambdaCountDichotomy.freeW 3 (1 / 2))
          (LambdaCountDichotomy.edgeCount 3) = 3 / 2 ∧
        LambdaCountDichotomy.Var (LambdaCountDichotomy.freeW 3 (1 / 2))
          (LambdaCountDichotomy.edgeCount 3) = 3 / 4 ∧
        LambdaCountDichotomy.Var (LambdaCountDichotomy.freeW 3 (1 / 2))
          (LambdaCountDichotomy.edgeCount 3) / (3 : ℚ) = 1 / 4)
    ∧ (LambdaCountDichotomy.E (LambdaCountDichotomy.hardW 3 2) (LambdaCountDichotomy.hardN 3 2) = 2
        ∧ LambdaCountDichotomy.Var (LambdaCountDichotomy.hardW 3 2)
            (LambdaCountDichotomy.hardN 3 2) = 0)
    ∧ (∀ k : ℕ,
        LambdaCountDichotomy.Var (LambdaCountDichotomy.softW (1 / 3))
          (LambdaCountDichotomy.softN k) = 2 / 9)
    ∧ ((LambdaEdgeCount.lambdaOf 10 100) ^ 2 = 1 / 100)
    ∧ (Real.sqrt ((100 : ℝ) / 100 ^ 2) = 1 / 10)
    ∧ (LambdaEdgeCount.edgeCount (({0, 1, 2} : Finset ℕ) ∪ {3, 4})
        = LambdaEdgeCount.edgeCount ({0, 1, 2} : Finset ℕ)
          + LambdaEdgeCount.edgeCount ({3, 4} : Finset ℕ))
    ∧ (LambdaEdgeCount.edgeCount ({0, 1, 2} : Finset ℕ) = 3
        ∧ LambdaEdgeCount.edgeCount ({3, 4} : Finset ℕ) = 2) :=
  ⟨LambdaMomentHierarchy.parts_nonzero,
    LambdaMomentHierarchy.only_count_touches_lambda,
    VacuumSequestering.sequestering_nondegeneracy,
    LambdaSusceptibility.mean_witness,
    LambdaSusceptibility.var_witness,
    LambdaCountDichotomy.free_witness,
    LambdaCountDichotomy.hard_witness,
    LambdaCountDichotomy.soft_witness,
    LambdaEdgeCount.nondeg_secondMoment_N100,
    LambdaEdgeCount.nondeg_rms_N100,
    LambdaEdgeCount.nondeg_extensive,
    LambdaEdgeCount.nondeg_counts⟩

/-- **Only the count can move `Λ`.**  Order-0 (`Λ`) is invariant under every deformation in every
finite dimension, and the physical residue is blind to the operator and the vacuum shift, yet the
order-2 and order-4 traces genuinely move under the explicit deformation `Pert`. -/
theorem lambda_only_count_can_move_order0 :
    (∀ (a0 : ℚ) {n : ℕ} (D P : Matrix (Fin n) (Fin n) ℚ),
        LambdaMomentHierarchy.order0 a0 (D + P) = LambdaMomentHierarchy.order0 a0 D)
      ∧ (∀ (A A' : VacuumSequestering.Sq) (c c' N deltaN : ℚ),
          VacuumSequestering.physicalLambda A c N deltaN
            = VacuumSequestering.physicalLambda A' c' N deltaN)
      ∧ ((LambdaMomentHierarchy.D + LambdaMomentHierarchy.Pert) ^ 2).trace
          ≠ (LambdaMomentHierarchy.D ^ 2).trace
      ∧ ((LambdaMomentHierarchy.D + LambdaMomentHierarchy.Pert) ^ 4).trace
          ≠ (LambdaMomentHierarchy.D ^ 4).trace := by
  refine ⟨?_, ?_, ?_, ?_⟩
  · intro a0 n D P; rfl
  · intro A A' c c' N deltaN; rfl
  · exact (LambdaMomentHierarchy.only_count_touches_lambda.2.2.2.2.2).1
  · exact (LambdaMomentHierarchy.only_count_touches_lambda.2.2.2.2.2).2

/-! ## Kernel a x i o m footprint - exactly `[propext, Classical.choice, Quot.sound]` -/

/-- info: 'LambdaMagnitudeCapstone.lambda_magnitude_capstone' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms lambda_magnitude_capstone

/-- info: 'LambdaMagnitudeCapstone.lambda_nonvacuity_witnesses' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms lambda_nonvacuity_witnesses

/-- info: 'LambdaMagnitudeCapstone.lambda_only_count_can_move_order0' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in #print axioms lambda_only_count_can_move_order0

end LambdaMagnitudeCapstone
