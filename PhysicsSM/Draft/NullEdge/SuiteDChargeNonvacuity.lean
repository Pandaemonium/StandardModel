import Mathlib
import PhysicsSM.Draft.NullEdge.ModularSelection
import PhysicsSM.Draft.NullEdge.SuiteCDNextRungs

/-!
# Suite D charge nonvacuity / false-shape guard

This module is a small audit guardrail for the Suite D channel-charge results in
`SuiteCDNextRungs`. It checks that the coordinate-basis channel charges
`Q_A, Q_C, Q_T, E` and the total generator `Bsum` are honest, distinct, nonzero
diagonal objects, so that the finite commutativity facts
(`channel_charges_pairwise_commute`, `channel_charges_commute_with_Bsum`) are
genuine finite diagonal facts rather than empty-index or all-zero artifacts.

Contents:

* `channel_charges_distinct`: the four charges are pairwise distinct.
* `channel_charges_nonzero`: none of the four charges is the zero matrix.
* `commuting_product_nonzero_witness`: a concrete commuting pair whose product is
  nonzero (so commutativity is not the trivial `0 = 0` fact).
* `bsum_noncentral_witness`: `Bsum` is nonzero and (since it is traceless) is not
  the central/scalar matrix `(tr Bsum / 5) • 1`.

These are finite, coordinate-basis, decidable-style facts only; no new physics.
-/

namespace SuiteDChargeNonvacuity

open ModularSelection

/-- The four coordinate-basis channel charges are pairwise distinct. -/
theorem channel_charges_distinct :
    QA ≠ QC ∧ QA ≠ QT ∧ QA ≠ EE ∧ QC ≠ QT ∧ QC ≠ EE ∧ QT ≠ EE := by
  refine ⟨?_, ?_, ?_, ?_, ?_, ?_⟩ <;> intro h
  · have := congr_fun (congr_fun h 0) 0
    simp [QA, QC, Matrix.diagonal] at this
  · have := congr_fun (congr_fun h 0) 0
    simp [QA, QT, Matrix.diagonal] at this
  · have := congr_fun (congr_fun h 0) 0
    simp [QA, EE, Matrix.diagonal] at this
  · have := congr_fun (congr_fun h 1) 1
    simp [QC, QT, Matrix.diagonal] at this
  · have := congr_fun (congr_fun h 1) 1
    simp [QC, EE, Matrix.diagonal] at this
  · have := congr_fun (congr_fun h 2) 2
    simp [QT, EE, Matrix.diagonal] at this

/-- None of the four coordinate-basis channel charges is the zero matrix. -/
theorem channel_charges_nonzero :
    QA ≠ 0 ∧ QC ≠ 0 ∧ QT ≠ 0 ∧ EE ≠ 0 := by
  refine ⟨?_, ?_, ?_, ?_⟩ <;> intro h
  · have := congr_fun (congr_fun h 0) 0
    simp [QA, Matrix.diagonal] at this
  · have := congr_fun (congr_fun h 1) 1
    simp [QC, Matrix.diagonal] at this
  · have := congr_fun (congr_fun h 2) 2
    simp [QT, Matrix.diagonal] at this
  · have := congr_fun (congr_fun h 3) 3
    simp [EE, Matrix.diagonal] at this

/-- A concrete commuting pair whose product is nonzero: `Q_A` and `Q_C` commute
and `Q_A * Q_C ≠ 0`. This shows the commutativity guardrail is a genuine finite
diagonal fact, not the trivial `0 = 0` identity. -/
theorem commuting_product_nonzero_witness :
    QA * QC = QC * QA ∧ QA * QC ≠ 0 := by
  refine ⟨?_, ?_⟩
  · ext i j
    fin_cases i <;> fin_cases j <;>
      simp [QA, QC, Matrix.mul_apply, Fin.sum_univ_five]
  · intro h
    have := congr_fun (congr_fun h 1) 1
    simp [QA, QC, Matrix.mul_apply, Fin.sum_univ_five] at this

/-- `Bsum` is nonzero and, being traceless, is not the central/scalar matrix
`(tr Bsum / 5) • 1`. -/
theorem bsum_noncentral_witness :
    Bsum ≠ 0 ∧ Bsum ≠ (Bsum.trace / 5) • (1 : Matrix (Fin 5) (Fin 5) ℂ) := by
  have htr : Bsum.trace = 0 := by
    simp [Bsum, QA, QC, QT, EE, Matrix.trace, Matrix.diag, Fin.sum_univ_five]
  refine ⟨?_, ?_⟩ <;> intro h
  · have := congr_fun (congr_fun h 0) 0
    simp [Bsum, QA, QC, QT, EE, Matrix.diagonal] at this
  · rw [htr] at h
    have := congr_fun (congr_fun h 0) 0
    simp [Bsum, QA, QC, QT, EE, Matrix.diagonal] at this

end SuiteDChargeNonvacuity

/-! ## Kernel-footprint guard -/

/-- info: 'SuiteDChargeNonvacuity.channel_charges_distinct' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteDChargeNonvacuity.channel_charges_distinct

/-- info: 'SuiteDChargeNonvacuity.channel_charges_nonzero' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteDChargeNonvacuity.channel_charges_nonzero

/-- info: 'SuiteDChargeNonvacuity.commuting_product_nonzero_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteDChargeNonvacuity.commuting_product_nonzero_witness

/-- info: 'SuiteDChargeNonvacuity.bsum_noncentral_witness' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms SuiteDChargeNonvacuity.bsum_noncentral_witness
