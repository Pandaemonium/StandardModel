# Paper Unit Outline: Finite Reflection Positivity Stack

Date: 2026-07-04
Run: `AgentTasks/fourday-ym-run-2026-07-05`
Status: outline only; draft Lean inventory, not a promotion request.

## Working scope

**UPDATED 1.16:25 (post Aristotle `e6e46e9f` harvest, N3 redesign):** this
outline predates a convention correction and is partially stale - see the
declaration-list notes below marked "REMOVED"/"RENAMED". This unit should
present the finite, algebraic reflection-positivity stack for GateYM. The
safest current headline is:

> A kernel-checked draft stack for reflection geometry, reflection
> change-of-variables, positive Wilson local kernels, and a doubled Wilson
> reflection-form theorem for which the genuine two-plaquette ensemble
> weight IS now identified (for the zero-cut construction, at
> mirror-coordinate configurations) - with cut-plaquette (shocking tier)
> reflection positivity and the OS/GNS transfer Hilbert-space construction
> still open.

Do not claim that RP-LINK is fully closed: the zero-cut doubled-lattice
construction is a well-definedness/consistency instance of reflection
positivity, not the case with actual cut plaquettes (Osterwalder-Seiler's
genuinely nontrivial content). The T1 zero-cut tier (baseline AND
ensemble-identification) is now closed; cut-plaquette strong/shocking-tier
work remains open.

## Theorem inventory

Reflection geometry:

- `PhysicsSM/Draft/NullEdge/GateYM/ReflectionCore.lean`
  - `Reflection`
  - `positiveLink`, `negativeLink`, `cutLink`
  - `reflectE_positiveLink`, `reflectE_negativeLink`, `reflectE_cutLink`
  - `reflectLinkField`, `reflectLinkField_involutive` - **RENAMED CONVENTION
    1.16:25**: `reflectLinkField` now includes a group inverse
    (`(theta U) e = (U (reflectE e))^-1`, N3 fix, Route B); the old
    inverse-free pullback was refuted by `MirrorHolonomyConjugation.lean`.
  - `DependsOnPositiveSide`
  - `stepHol_reflectLinkField_fwd`, `stepHol_reflectLinkField_rev` -
    fwd/rev roles swapped on the RHS under the corrected convention.
- `PhysicsSM/Draft/NullEdge/GateYM/MirrorHolonomyConjugation.lean` (NEW,
  N3 negative result): `mirrorConj_counterexample`, `mirrorConj_not_always`,
  `mirrorHol_eq_p0Hol_of_comm`, `ordinaryReversal_eq_p0Hol_inv` - proves the
  raw (old-convention) mirror holonomy is NOT generally conjugate to the
  original or its inverse (S3 counterexample).
- `PhysicsSM/Draft/NullEdge/GateYM/MirrorHolonomyResolution.lean` (NEW, N3
  resolution): `liftStepPos`, `liftPlaquettePos`, `hol_liftPlaquettePos`,
  `mirrorConfig`, `hol_mirrorPlaquette_mirrorConfig`,
  `mirrorPlaquette_wilsonWeight_eq` - the general (independent-configuration)
  Wilson-weight identity the old convention could not deliver.
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
  - `hol_mirrorPlaquette_eq_inv` (RENAMED 1.16:25, was
    `op_hol_reflectLinkField_mirrorPlaquette`; now a same-group identity,
    no `MulOpposite`)
  - `localWeight_hol_mirrorPlaquette` (RENAMED, was
    `localWeight_hol_reflectLinkField_mirrorPlaquette`; hypothesis is now
    plain inversion-invariance `hinv`, not opposite-group compatibility)
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
  - **REMOVED 1.16:25**: `rhoOppositeInv`, `rhoOppositeInv_unitary`,
    `wilsonLocalWeight_rhoOppositeInv`, `wilsonOppositeKernel_posSemidef`,
    `wilsonLocalOppositeCompatibility_of_rhoOppositeInv` - the entire
    `MulOpposite`/opposite-representation bridge was a workaround for the
    old, N3-refuted convention and is no longer needed.
  - `localWeight_hol_reflectLinkField_mirrorPlaquette_wilson`
  - `productWeight_reflectLinkField_mirrorPlaquette_wilson`
  - `weight_reflectLinkField_mirrorPlaquette_wilson`
  - mirror-stable and mirror-pair Wilson reflection theorems (now take a
    direct inversion-invariance hypothesis, not opposite-group
    compatibility).

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
  - `liftPlaquettePos`, `hol_liftPlaquettePos` (now imported from
    `MirrorHolonomyResolution.lean`, not duplicated locally)
  - `mirrorPlaquette_liftPlaquettePos_hol` (RESTATED 1.16:25: now the
    GENERAL independent-configuration identity via `mirrorConfig a b`, not
    just reflection-derived configurations)
  - `doubledWilsonWeight`
  - `doubled_wilson_reflectionForm_nonneg`
  - `mirrorPair`, `doubledWilsonWeight_eq_ensembleWeight_mirrorConfig` (NEW
    1.16:25): identifies `doubledWilsonWeight` with the GENUINE
    `PlaquetteEnsemble.weight` of the two-plaquette family at
    `mirrorConfig a b` - closes the ensemble-identification gap this
    outline previously listed as open.

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

- RP-LINK is not fully closed: the zero-cut doubled-lattice construction (now
  including genuine ensemble-weight identification, per `e6e46e9f`) is a
  well-definedness/consistency instance of reflection positivity, not the
  case with actual cut plaquettes - Osterwalder-Seiler's genuinely
  nontrivial content, needing `ReflectionPositivityKernel.cutKernel_posSemidef_of_mixture`
  (Q1 shocking tier, not attempted).
- Q2 transfer Hilbert space: `TransferHilbert.lean` has landed (Aristotle
  `6f8903cc`); check the ledger/DISCUSSION.md for current status before
  citing, this outline predates that file.
- The paper unit should not claim positivity, stability, spectrum, or physical
  Hilbert-space interpretation beyond the exact finite algebraic statements
  already kernel-checked.
- Novelty and historical positioning require T12 full-text review and a separate
  novelty sweep.
