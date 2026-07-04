# Paper Unit Outline: Finite Reflection Positivity Stack

Date: 2026-07-04
Run: `AgentTasks/fourday-ym-run-2026-07-05`
Status: outline only; draft Lean inventory, not a promotion request.

## Working scope

This unit should present the finite, algebraic reflection-positivity stack for
GateYM. The safest current headline is:

> A kernel-checked draft stack for reflection geometry, reflection
> change-of-variables, positive Wilson local kernels, and a baseline doubled
> Wilson reflection-form theorem, with the full Wilson ensemble identification
> and OS/GNS transfer Hilbert-space construction still open.

Do not claim that RP-LINK is fully closed. The current T1 baseline theorem is
real progress, but the run ledger explicitly keeps ensemble-identification and
cut-plaquette strong-tier work open.

## Theorem inventory

Reflection geometry:

- `PhysicsSM/Draft/NullEdge/GateYM/ReflectionCore.lean`
  - `Reflection`
  - `positiveLink`, `negativeLink`, `cutLink`
  - `reflectE_positiveLink`, `reflectE_negativeLink`, `reflectE_cutLink`
  - `reflectLinkField`, `reflectLinkField_involutive`
  - `DependsOnPositiveSide`
  - `stepHol_reflectLinkField_fwd`
  - `stepHol_reflectLinkField_rev`
- `PhysicsSM/Draft/NullEdge/GateYM/ReflectionDouble.lean`
  - `doubleLattice`
  - `doubleReflection`
  - `doubleLinkFieldEquiv`
  - `reflectLinkField_doubleReflection_eq`

Reflection change of variables:

- `PhysicsSM/Draft/NullEdge/GateYM/ReflectionEnsemble.lean`
  - `reflectLinkFieldEquiv`
  - `sum_comp_reflectLinkField`
  - `partition_comp_reflectLinkField`
  - `numerator_comp_reflectLinkField`
  - `numerator_observable_comp_reflectLinkField_of_weight_invariant`
  - `expectation_observable_comp_reflectLinkField_of_weight_invariant`

Plaquette reflection:

- `PhysicsSM/Draft/NullEdge/GateYM/PlaquetteReflection.lean`
  - `mirrorPlaquette`
  - `mirrorPlaquette_walk`
  - `op_hol_reflectLinkField_mirrorPlaquette`
  - `localWeight_hol_reflectLinkField_mirrorPlaquette`
  - `productWeight_reflectLinkField_mirrorPlaquette`
  - `IsMirrorStableFamily`
  - `mirrorPairFamily_isMirrorStable`
  - `productWeight_reflectLinkField_of_mirrorStable`
  - `productWeight_reflectLinkField_of_mirrorPair`
- `PhysicsSM/Draft/NullEdge/GateYM/PlaquetteReflectionEnsemble.lean`
  - finite ensemble lifts for reflection-invariant plaquette-product weights.

Wilson local positivity:

- `PhysicsSM/Draft/NullEdge/GateYM/WilsonWeightPositivity.lean`
  - `reChar`, `wilsonKernel`
  - `rho_inv_eq_conjTranspose`
  - `reChar_inv_of_unitary`
  - `reCharGram_posSemidef`
  - `hadamard_posSemidef`, `hadamard_pow_posSemidef`
  - `wilsonKernel_posSemidef`
- `PhysicsSM/Draft/NullEdge/GateYM/WilsonLocalWeight.lean`
  - `wilsonLocalWeight`
  - `wilsonLocalWeight_class`
  - `wilsonLocalWeight_inv_of_unitary`
  - `wilsonWeight_gauge`
  - `wilsonExpectation_observable_comp_gauge`
  - `wilsonLocalWeight_pos`
  - `wilsonPartition_pos`
- `PhysicsSM/Draft/NullEdge/GateYM/WilsonReflectionCompatibility.lean`
  - `rhoOppositeInv`
  - `rhoOppositeInv_unitary`
  - `wilsonLocalWeight_rhoOppositeInv`
  - `wilsonOppositeKernel_posSemidef`
  - `localWeight_hol_reflectLinkField_mirrorPlaquette_wilson`
  - `productWeight_reflectLinkField_mirrorPlaquette_wilson`
  - `weight_reflectLinkField_mirrorPlaquette_wilson`
  - `wilsonLocalOppositeCompatibility_of_rhoOppositeInv`
  - mirror-stable and mirror-pair Wilson reflection theorems.

Reflection-positive kernel:

- `PhysicsSM/Draft/NullEdge/GateYM/ReflectionPositivityKernel.lean`
  - `reflectionForm`
  - `cutKernel`
  - `IsReflectionPositive`
  - `reflectionForm_eq_sum_dotProduct`
  - `reflectionForm_nonneg`
  - `cutKernel_posSemidef_of_factorized`
  - `cutKernel_posSemidef_of_mixture`
  - `reflectionForm_nonneg_of_factorized`
  - `reflectionForm_nonneg_of_mixture`

Baseline Wilson reflection positivity:

- `PhysicsSM/Draft/NullEdge/GateYM/WilsonReflectionPositivity.lean`
  - `liftStepPos`
  - `liftPlaquettePos`
  - `stepHol_liftStepPos`
  - `hol_liftPlaquettePos`
  - `mirrorPlaquette_liftPlaquettePos_hol`
  - `doubledWilsonWeight`
  - `doubled_wilson_reflectionForm_nonneg`

Transfer/Hilbert-space adjacent:

- `PhysicsSM/Draft/NullEdge/GateYM/TransferPositivity.lean`
  - `transferMatrix_posSemidef`
  - `compression_posSemidef`
  - `singleLinkWilsonKernel_diagCongruence_posSemidef`
- Q2 design thread in
  `AgentTasks/fourday-ym-run-2026-07-05/DISCUSSION.md`
  - proposed `reflectionPairing`, `rpBlockMatrix`, `rpHilbertSpace`, and
    abstract `compressedTransfer` route.
  - no `TransferHilbert.lean` statement file has been created yet.

## Verification record to cite

Use exact command records from the run ledger and task notes, not memory. Recent
known records include:

- T1 baseline ran `lake env lean` on `WilsonReflectionPositivity.lean`, an
  aggregate GateYM build, and a full `lake build`, all recorded green in the
  ledger.
- T14 ran `python Scripts/oracle/validate_lgt_core.py` and reached `44/44`,
  including the RP-KER complex-character guard.

Before drafting paper prose, rerun the relevant reflection files and aggregate
GateYM build, then record fresh command output here or in a task note.

## Provenance and source boundaries

- T12 verified bibliographic/abstract-level existence for Osterwalder-Seiler
  1978 and Menotti-Pelissetto 1987. Full source-internal convention comparison
  remains open.
- The current Lean stack should be described as this repo's finite algebraic
  formalization, not as a direct formalization of either paper's exact theorem.
- The RP-KER rows in `Scripts/oracle/validate_lgt_core.py` pin conventions but
  are not proof.

## Remaining gaps

- RP-LINK is not fully closed: the baseline doubled Wilson theorem does not yet
  identify the whole genuine two-plaquette mirror ensemble weight for the
  nonabelian Wilson action.
- Q2 transfer Hilbert space is design-proposed and review-requested, not
  frozen in Lean.
- The paper unit should not claim positivity, stability, spectrum, or physical
  Hilbert-space interpretation beyond the exact finite algebraic statements
  already kernel-checked.
- Novelty and historical positioning require T12 full-text review and a separate
  novelty sweep.
