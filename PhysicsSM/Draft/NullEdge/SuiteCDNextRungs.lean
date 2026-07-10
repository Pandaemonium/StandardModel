import Mathlib
import PhysicsSM.Draft.NullEdge.FiniteKMCP
import PhysicsSM.Draft.NullEdge.WindingLowModes
import PhysicsSM.Draft.NullEdge.ModularSelection

/-!
# Next-rung landings for Goal II, Suite C3, and Suite D

This module collects the cheapest killable next rungs identified by the
grand-strategy pass `codex-grand-strategy-suiteCD-0009-20260709`, built directly
on the current seed modules `FiniteKMCP`, `WindingLowModes`, and
`ModularSelection`. Each theorem is a self-contained composition of already
landed results and introduces no new global assumption.

Contents:

* Goal II, finite KM, toward rung C. `uN_parameter_count` proves the exact
  U(N) parameter-count decomposition `angles + physical phases + rephasing =
  N^2`, tying `FiniteKM.physicalPhases` to the standard counting argument.
* Suite C3, index = anomaly. `c3_index_anomaly` states the exact relative index
  `Index(D_w) - Index(D_0) = w` for the winding closure operator.
* Suite D kills / nondegeneracy. `channel_charges_traceless` is the Gibbs-Duhem
  consistency check, and `channel_charges_independent` is the mandatory
  nondegeneracy gate: the four coordinate-basis channel charges are linearly
  independent. `channel_charges_pairwise_commute` and
  `channel_charges_commute_with_Bsum` add the finite diagonal-charge
  commutativity/conservation guardrails. This proves noncollapse and
  commutativity of the parameter span only; it does not derive a physical
  GGE/modular dynamics.
-/

namespace SuiteCDNextRungs

open scoped BigOperators

/-! ## Goal II: U(N) parameter count -/

/-- Number of real mixing angles of a `U(N)` mixing matrix, `N(N-1)/2`. -/
def numAngles (N : ℕ) : ℕ := N * (N - 1) / 2

/-- Goal II parameter-count decomposition. For `N ≥ 1`, the `N^2` real
parameters of a `U(N)` mixing matrix split exactly as
`(mixing angles) + (physical CP phases) + (rephasing directions removed)`,
i.e. `N(N-1)/2 + (N-1)(N-2)/2 + (2N-1) = N^2`. -/
theorem uN_parameter_count (N : ℕ) (hN : 1 ≤ N) :
    numAngles N + FiniteKM.physicalPhases N + (2 * N - 1) = N ^ 2 := by
  rcases N with (_ | _ | N) <;> simp_all +arith +decide [numAngles, FiniteKM.physicalPhases]
  linarith [
    Nat.div_mul_cancel
      (show 2 ∣ (N + 1) * N from
        Nat.dvd_of_mod_eq_zero (by norm_num [Nat.add_mod, Nat.mod_two_of_bodd])),
    Nat.div_mul_cancel
      (show 2 ∣ (N + 2) * (N + 1) from
        Nat.dvd_of_mod_eq_zero (by norm_num [Nat.add_mod, Nat.mod_two_of_bodd]))]

/-! ## Suite C3: index = anomaly -/

open F4Winding in
/-- Suite C3 finite headline, `Index(D_K) - Index(D_0) = Wind(K)`. The finite
relative-index/anomaly identity is built on `windingDirac_index`. -/
theorem c3_index_anomaly (N w : ℕ) :
    (((Module.finrank ℂ (LinearMap.ker (windingDirac N w)) : ℤ)
        - Module.finrank ℂ ((Fin N → ℂ) ⧸ LinearMap.range (windingDirac N w)))
      - ((Module.finrank ℂ (LinearMap.ker (windingDirac N 0)) : ℤ)
        - Module.finrank ℂ ((Fin N → ℂ) ⧸ LinearMap.range (windingDirac N 0))))
      = (w : ℤ) := by
  rw [windingDirac_index, windingDirac_index]
  simp

/-! ## Suite D: Gibbs-Duhem sum rule and nondegeneracy gate -/

open ModularSelection in
/-- Gibbs-Duhem consistency. Each channel charge is traceless and so is their
sum `B`; the `sum_X chi_XY = 0` sum rule holds, so the corresponding kill does
not fire. -/
theorem channel_charges_traceless :
    QA.trace = 0 ∧ QC.trace = 0 ∧ QT.trace = 0 ∧ EE.trace = 0 ∧ Bsum.trace = 0 := by
  refine ⟨?_, ?_, ?_, ?_, ?_⟩ <;>
    simp [Bsum, QA, QC, QT, EE, Matrix.trace, Matrix.diag, Fin.sum_univ_five]

open ModularSelection in
/-- Nondegeneracy gate for the channel-charge parameter span. The four
coordinate-basis channel charges `Q_A, Q_C, Q_T, E` are linearly independent.
This is a finite linear-algebra fact only; a physical GGE/modular claim would
also require commutativity, conservation, and dynamics hypotheses not proved in
this module. -/
theorem channel_charges_independent :
    LinearIndependent ℂ ![QA, QC, QT, EE] := by
  refine Fintype.linearIndependent_iff.2 ?_
  simp_all +decide [Fin.forall_fin_succ, Fin.sum_univ_succ]
  intro g hg
  have := congr_fun (congr_fun hg 0) 0
  have := congr_fun (congr_fun hg 1) 1
  have := congr_fun (congr_fun hg 2) 2
  have := congr_fun (congr_fun hg 3) 3
  simp_all +decide [QA, QC, QT, EE]

open ModularSelection in
/-- Pairwise commutativity of the four coordinate-basis channel charges. This is
the finite diagonal-matrix commutativity guardrail needed before any stronger
GGE/modular language can be considered. It is not a conservation or dynamics
claim by itself. -/
theorem channel_charges_pairwise_commute :
    Commute QA QC ∧ Commute QA QT ∧ Commute QA EE ∧
      Commute QC QT ∧ Commute QC EE ∧ Commute QT EE := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩
  all_goals
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [QA, QC, QT, EE, Matrix.mul_apply, Fin.sum_univ_five]

open ModularSelection in
/-- Each coordinate-basis channel charge commutes with the total channel
generator `Bsum`. This is the finite algebraic conservation guardrail for the
toy diagonal generator. It is still not a thermodynamic-limit or physical KMS
claim. -/
theorem channel_charges_commute_with_Bsum :
    Commute QA Bsum ∧ Commute QC Bsum ∧ Commute QT Bsum ∧ Commute EE Bsum := by
  refine ⟨?_, ?_, ?_, ?_⟩
  all_goals
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [Bsum, QA, QC, QT, EE, Matrix.mul_apply, Fin.sum_univ_five]

end SuiteCDNextRungs

/-! ## Kernel-footprint guard -/

/-- info: 'SuiteCDNextRungs.uN_parameter_count' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteCDNextRungs.uN_parameter_count

/-- info: 'SuiteCDNextRungs.c3_index_anomaly' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteCDNextRungs.c3_index_anomaly

/-- info: 'SuiteCDNextRungs.channel_charges_traceless' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteCDNextRungs.channel_charges_traceless

/-- info: 'SuiteCDNextRungs.channel_charges_independent' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteCDNextRungs.channel_charges_independent

/-- info: 'SuiteCDNextRungs.channel_charges_pairwise_commute' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteCDNextRungs.channel_charges_pairwise_commute

/-- info: 'SuiteCDNextRungs.channel_charges_commute_with_Bsum' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteCDNextRungs.channel_charges_commute_with_Bsum
