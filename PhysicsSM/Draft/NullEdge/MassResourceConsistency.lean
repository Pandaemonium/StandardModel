import Mathlib
import PhysicsSM.Draft.NullEdge.ModularSelection
import PhysicsSM.Draft.NullEdge.MassResourceModularAudit
import PhysicsSM.Draft.NullEdge.GateI1.MassEntropyMonotone
import PhysicsSM.Draft.NullEdge.SuiteCDNextRungs

/-!
# Suite D mass-resource consistency suite

This draft module composes the landed Suite D guardrails into one small
finite consistency theorem suite. Nothing new is assumed: every field is a
direct re-export of an already landed result from

* `PhysicsSM.Draft.NullEdge.ModularSelection`
  (the four coordinate-basis channel charges `QA`, `QC`, `QT`, `EE` and their
  sum `Bsum`),
* `PhysicsSM.Draft.NullEdge.MassResourceModularAudit`
  (the central-shift generator/operator pair),
* `PhysicsSM.Draft.NullEdge.GateI1.MassEntropyMonotone`
  (the faithful mass-entropy resource measure), and
* `PhysicsSM.Draft.NullEdge.SuiteCDNextRungs`
  (the Gibbs-Duhem sum rule, the nondegeneracy gate, and the finite
  commutativity/conservation guardrails).

## Claim discipline

This is a finite consistency / guardrail suite, not a physical derivation. In
particular:

* The channel charges `QA`, `QC`, `QT`, `EE` are fixed `5 x 5`
  coordinate-basis diagonal matrices. Their tracelessness and linear
  independence, pairwise commutativity, and commutation with `Bsum` are honest
  finite linear-algebra facts about that specific basis; they are not a claim
  that a generalized Gibbs ensemble, a KMS/modular generator, or a thermodynamic
  limit has been physically derived.
* The central-shift results are algebraic guardrails: as a commutator
  derivation the central shift cancels (`centralShiftGeneratorInvariant`),
  while the raw operator equality is false for a nonzero shift
  (`centralShiftOperatorNotEqual`). This is a bookkeeping distinction between
  two objects, not a statement about modular dynamics.
* The entropy field records only that the packaged mass-entropy measure is
  faithful (vanishes exactly on null momenta); it makes no thermodynamic-limit
  claim.
-/

namespace MassResourceConsistencyBundle

open MassResourceModularAudit ModularSelection SuiteCDNextRungs
open PhysicsSM.Draft.NullEdge.GateI1

/-- Bundle of the landed Suite D consistency guardrails.

Every field is a coordinate-basis / algebraic finite fact, not a physical
derivation (see the module docstring for the claim discipline). -/
structure MassResourceConsistency : Prop where
  /-- Gibbs-Duhem sum rule: each coordinate-basis channel charge, and their sum
  `Bsum`, is traceless. -/
  traceless :
    QA.trace = 0 ∧ QC.trace = 0 ∧ QT.trace = 0 ∧ EE.trace = 0 ∧ Bsum.trace = 0
  /-- Nondegeneracy gate: the four coordinate-basis channel charges are linearly
  independent, so the parameter span is not collapsed. -/
  independent : LinearIndependent ℂ ![QA, QC, QT, EE]
  /-- Pairwise commutativity of the four coordinate-basis channel charges. -/
  commuting :
    Commute QA QC ∧ Commute QA QT ∧ Commute QA EE ∧
      Commute QC QT ∧ Commute QC EE ∧ Commute QT EE
  /-- Each coordinate-basis channel charge commutes with the total generator
  `Bsum`. -/
  conservedByBsum :
    Commute QA Bsum ∧ Commute QC Bsum ∧ Commute QT Bsum ∧ Commute EE Bsum
  /-- Central-shift invariance of the commutator derivation: adding a central
  scalar multiple of the identity does not change `ad B`. -/
  centralShiftGeneratorInvariant :
    ∀ (B A : Matrix (Fin 2) (Fin 2) ℂ) (c : ℂ),
      (c • (1 : Matrix (Fin 2) (Fin 2) ℂ) + B) * A
          - A * (c • (1 : Matrix (Fin 2) (Fin 2) ℂ) + B)
        = B * A - A * B
  /-- False-shape guard: the raw operator equality is false for a nonzero
  central shift, even though the derivation is unchanged. -/
  centralShiftOperatorNotEqual :
    ∀ (c : ℂ), c ≠ 0 → ∀ (B : Matrix (Fin 2) (Fin 2) ℂ),
      c • (1 : Matrix (Fin 2) (Fin 2) ℂ) + B ≠ B
  /-- Faithfulness of the packaged mass-entropy resource measure: it vanishes
  exactly on the null (massless) momenta. -/
  entropyFaithful :
    ∀ P : MassEntropyMonotone.FutureConeMomentum,
      MassEntropyMonotone.massEntropyMonotone.free P
        ↔ MassEntropyMonotone.massEntropyMonotone.value P = 0

/-- The Suite D consistency suite holds. Each field is discharged by the
corresponding landed guardrail. -/
theorem mass_resource_consistency : MassResourceConsistency where
  traceless := channel_charges_traceless
  independent := channel_charges_independent
  commuting := channel_charges_pairwise_commute
  conservedByBsum := channel_charges_commute_with_Bsum
  centralShiftGeneratorInvariant := fun B A c => modular_generator_matrix B A c
  centralShiftOperatorNotEqual := fun c hc B => modular_shift_operator_ne c hc B
  entropyFaithful := MassEntropyMonotone.massEntropyMonotone.free_iff_value_zero

/-- Conjunction form of the same suite, for callers who prefer a flat term. -/
theorem mass_resource_consistency_conj :
    (QA.trace = 0 ∧ QC.trace = 0 ∧ QT.trace = 0 ∧ EE.trace = 0 ∧ Bsum.trace = 0)
      ∧ LinearIndependent ℂ ![QA, QC, QT, EE]
      ∧ (Commute QA QC ∧ Commute QA QT ∧ Commute QA EE ∧
          Commute QC QT ∧ Commute QC EE ∧ Commute QT EE)
      ∧ (Commute QA Bsum ∧ Commute QC Bsum ∧ Commute QT Bsum ∧ Commute EE Bsum)
      ∧ (∀ (B A : Matrix (Fin 2) (Fin 2) ℂ) (c : ℂ),
          (c • (1 : Matrix (Fin 2) (Fin 2) ℂ) + B) * A
              - A * (c • (1 : Matrix (Fin 2) (Fin 2) ℂ) + B)
            = B * A - A * B)
      ∧ (∀ (c : ℂ), c ≠ 0 → ∀ (B : Matrix (Fin 2) (Fin 2) ℂ),
          c • (1 : Matrix (Fin 2) (Fin 2) ℂ) + B ≠ B) := by
  refine ⟨mass_resource_consistency.traceless,
    mass_resource_consistency.independent,
    mass_resource_consistency.commuting,
    mass_resource_consistency.conservedByBsum,
    mass_resource_consistency.centralShiftGeneratorInvariant,
    mass_resource_consistency.centralShiftOperatorNotEqual⟩

end MassResourceConsistencyBundle

/-! ## Kernel-footprint guard pins -/

/-- info: 'MassResourceConsistencyBundle.mass_resource_consistency' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MassResourceConsistencyBundle.mass_resource_consistency

/-- info: 'MassResourceConsistencyBundle.mass_resource_consistency_conj' depends on axioms: [propext, Classical.choice, Quot.sound] -/
#guard_msgs (whitespace := lax) in
#print axioms MassResourceConsistencyBundle.mass_resource_consistency_conj
