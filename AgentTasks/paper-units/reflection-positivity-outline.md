# Paper Unit Outline: Finite Reflection Positivity Stack

Date: 2026-07-04
Run: `AgentTasks/fourday-ym-run-2026-07-05`
Status: outline only; draft Lean inventory, not a promotion request.

## Working scope

This unit should present the finite, algebraic reflection-positivity stack for
GateYM after the N3 mirror-holonomy redesign, the zero-cut Wilson
ensemble-identification tier, the cut-kernel product/Schur connector lemmas,
the abstract Wilson cut-factor PSD bridge, and a minimal concrete
cut-plaquette one-factor RP example. The safest current headline is:

> A kernel-checked draft stack for reflection geometry, reflection
> change-of-variables, positive Wilson local kernels, and a doubled Wilson
> reflection-form theorem for which the genuine two-plaquette ensemble
> weight IS now identified (for the zero-cut construction, at
> mirror-coordinate configurations), plus finite cut-kernel product closure
> lemmas, the single-factor Wilson cut-kernel bridge, and a four-edge
> cut-plaquette example whose holonomy has the required mirror-coordinate
> factor form and whose singleton plaquette ensemble weight is reflection
> positive even after multiplying by a factorized side contribution, plus a
> mixed product theorem for factorized positive/mirror weights times finite
> Wilson cut factors, plus finite Q2/Q3 Z2 electric-sector product
> decomposition and finrank bookkeeping - with concrete finite cut-ensemble
> instantiation still open and the Q2 OS/GNS range model present only as
> finite algebraic infrastructure.

Do not claim that RP-LINK is fully closed: the zero-cut doubled-lattice
construction is a well-definedness/consistency instance of reflection
positivity, not the case with actual cut plaquettes (Osterwalder-Seiler's
genuinely nontrivial content). The T1 zero-cut tier (baseline AND
ensemble-identification) is now closed; cut-plaquette strong/shocking-tier
work remains open at the finite product/general reflection-family layer.

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
  - `cutKernel_mul`
  - `complex_hadamard_posSemidef`
  - `cutKernel_mul_posSemidef`
  - `reflectionForm_nonneg_of_mul_posSemidef`
  - `cutKernel_finset_prod_posSemidef`
  - `reflectionForm_nonneg_of_finset_prod_posSemidef`

Wilson cut-factor kernel bridge:

- `PhysicsSM/Draft/NullEdge/GateYM/WilsonCutPlaquettePositivity.lean`
  - `posSemidef_map_ofReal`
  - `cutKernel_posSemidef_of_wilsonFactor`
  - `reflectionForm_nonneg_of_wilsonFactor`
  - `reflectionForm_nonneg_of_wilsonFactor_prod`
  - `reflectionForm_nonneg_of_factorized_mul_wilsonFactor_prod`
  This is the kernel-algebra half of the cut-plaquette target: each
  factorized Wilson cut factor is a principal submatrix of the Wilson
  one-plaquette kernel, finite products follow through the existing
  Schur/product closure, and factorized positive/mirror contributions can be
  multiplied in. It does not construct a concrete finite cut-bearing ensemble.

Wilson cut-plaquette ensemble bridge:

- `PhysicsSM/Draft/NullEdge/GateYM/WilsonCutPlaquetteEnsemble.lean`
  - `weight_mirrorConfig_eq_wilsonKernel_prod_of_hol_factorization`
  - `reflectionPositive_of_hol_factorization`
  - `factorized_mul_reflectionPositive_of_hol_factorization`
  This is the conditional assembly bridge from geometry to RP-KER: once a
  finite plaquette family has mirror-coordinate holonomies of the form
  `e k c a * (e k c b)^-1`, its genuine Wilson
  `PlaquetteEnsemble.weight` is the finite product of Wilson cut kernels and
  is reflection positive, optionally with factorized side weights. It does not
  construct the mirror-coordinate equivalence or prove the holonomy
  factorization for a large cut-bearing lattice.

Minimal concrete cut-plaquette example:

- `PhysicsSM/Draft/NullEdge/GateYM/ReflectionCutPlaquetteExample.lean`
  - `cutPlaqLattice`
  - `cutPlaqReflection`
  - `cutPlaquette`
  - `cutMirrorCoord`
  - `cutPlaquette_hol_mirrorConfig`
  - `cutPlaquette_hol_cutMirrorCoord`
  - `cutPlaquette_wilsonFactor_reflectionPositive`
  - `cutPlaquette_weight_mirrorConfig_eq_wilsonKernel`
  - `cutPlaquette_ensemble_reflectionPositive`
  - `factorized_mul_cutPlaquette_ensemble_reflectionPositive`
  - `indexedCutPlaquette_weight_mirrorConfig_eq_wilsonKernel_prod`
  - `indexedCutPlaquette_ensemble_reflectionPositive`
  - `factorized_mul_indexedCutPlaquette_ensemble_reflectionPositive`
  This is the first concrete straddling plaquette with the required read-off
  shape. It proves the holonomy factorization, identifies the singleton
  `PlaquetteEnsemble.weight`, and specializes the Wilson cut-factor RP-KER
  theorem to a concrete one-plaquette ensemble, including a factorized
  positive/mirror side contribution. It now also proves the finite product
  theorem for indexed copies of that same minimal cut plaquette. It is not yet
  a multi-cut finite ensemble theorem over geometrically distinct plaquettes.

Concrete finite disconnected cut-plaquette family:

- `PhysicsSM/Draft/NullEdge/GateYM/ReflectionCutPlaquetteFamily.lean`
  - `indexedCutPlaqLattice`
  - `indexedCutPlaqReflection`
  - `cutPlaquetteAt`
  - `familyMirrorConfig`
  - `familyMirrorCoord`
  - `familyMirrorCoord_symm_mk`
  - `cutPlaquetteAt_hol_familyMirrorConfig`
  - `cutPlaquetteAt_hol_familyMirrorCoord`
  - `family_weight_mirrorConfig_eq_wilsonKernel_prod`
  - `family_ensemble_reflectionPositive`
  - `factorized_mul_family_ensemble_reflectionPositive`
  This is a genuine finite cut-bearing lattice family with geometrically
  distinct plaquettes, obtained as a disjoint `K`-indexed sum of the minimal
  cut plaquette. It proves the Wilson `PlaquetteEnsemble.weight` is RP in
  mirror coordinates, with optional factorized side weights. It is not yet the
  connected Wilson slab.

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
  - `doubled_wilson_ensembleWeight_reflectionForm_nonneg`: named corollary
    stating the zero-cut RP inequality directly for the genuine two-plaquette
    ensemble weight at `mirrorConfig`.

Transfer/Hilbert-space adjacent:

- `PhysicsSM/Draft/NullEdge/GateYM/HermitianFromRealQuadraticForm.lean`
  - `hermitian_of_forall_dotProduct_real`
  - `posSemidef_of_forall_dotProduct_real_nonneg`
- `PhysicsSM/Draft/NullEdge/GateYM/TransferHilbert.lean`
  - finite OS/GNS range model `rpHilbertSpace = range (CFC.sqrt K)`
  - shift-covariant range preservation and OS-form transfer atoms.
- `PhysicsSM/Draft/NullEdge/GateYM/TransferHilbertBlock.lean`
  - `rpBlockMatrix`
  - pairing bridge to `reflectionForm`
  - PSD/range nonnegativity from `IsReflectionPositive`.
- `PhysicsSM/Draft/NullEdge/GateYM/TransferHilbertBlockShift.lean`
  - block-shift covariance for `rpBlockMatrix` and the OS range.
- `PhysicsSM/Draft/NullEdge/GateYM/TransferHilbertZ2Electric.lean`
  - concrete Z2 electric-shift adapter for plaquette-bit-field block weights.
  - `iSup_rpBlockElectricSector_eq_rpHilbertSpace`
  - `rpBlockElectricSectorProduct`
  - `rpHilbertSpaceBlockElectricDecomposition`
  - `rpHilbertSpaceBlockElectricReconstruction`
  - `rpHilbertSpaceBlockElectricReconstruction_decomposition`
  - `rpHilbertSpaceBlockElectricDecomposition_reconstruction`
  - `rpHilbertSpaceBlockElectricLinearEquiv`
  - `finrank_rpHilbertSpace_eq_sum_finrank_rpBlockElectricSector`
  - `finrank_rpBlockElectricSector_le_finrank_rpHilbertSpace`
  - `finrank_rpHilbertSpace_pos_iff_exists_finrank_rpBlockElectricSector_pos`
  - `finrank_rpHilbertSpace_eq_finrank_selected_add_finrank_other`
  - `finrank_rpHilbertSpace_pos_iff_finrank_selected_pos_or_finrank_other_pos`
  - `finrank_rpHilbertSpace_eq_zero_iff_finrank_selected_eq_zero_and_finrank_other_eq_zero`
  These are finite algebraic sector-decomposition facts for the Z2 electric
  block OS range, not a physical transfer matrix or gap statement.
- `PhysicsSM/Draft/NullEdge/GateYM/TransferPositivity.lean`
  - `transferMatrix_posSemidef`
  - `compression_posSemidef`
  - `singleLinkWilsonKernel_diagCongruence_posSemidef`
  The Q2 stack is finite algebraic infrastructure. It is not yet a physical
  transfer matrix, Hamiltonian, or gap theorem.

## Verification record to cite

Use exact command records from the run ledger and task notes, not memory. Recent
known records include:

- T1 baseline ran `lake env lean` on `WilsonReflectionPositivity.lean`, an
  aggregate GateYM build, and a full `lake build`, all recorded green in the
  ledger.
- Codex later ran direct/targeted/aggregate checks for the cut-kernel
  product/Schur connector lemmas and the red-team corollary
  `doubled_wilson_ensembleWeight_reflectionForm_nonneg`; use the ledger
  entries around `1.16:47`-`1.17:48` for exact commands.
- Codex integrated Aristotle `8271a64b` as
  `WilsonCutPlaquettePositivity.lean`; use ledger entry `1.22:08` and the
  task note `AgentTasks/ym-q1-cut-plaquette-assembly-strategy-aristotle-2026-07-04.md`
  for exact direct/targeted/aggregate checks and dependency footprint.
- Codex added `ReflectionCutPlaquetteExample.lean`; use ledger entry
  `1.22:25` plus follow-up `1.22:38`, and discussion note
  `note:t1-minimal-cut-plaquette-example`, for exact direct/targeted/aggregate
  checks and dependency footprints.
- Codex added the mixed product theorem in `WilsonCutPlaquettePositivity.lean`;
  use ledger entry `1.22:50` and discussion note
  `note:t1-mixed-product-kernel-assembly`.
- Q2 `TransferHilbert*` modules and `TransferHilbertZ2Electric.lean` have
  their own direct/targeted/aggregate check records in the ledger; cite those
  exact entries rather than this outline. For the latest Z2 electric-sector
  product/finrank facts, use ledger entries `2.02:45`, `2.10:35`,
  `2.17:04`, `2.17:20`, and `6.08:10`.
- T14 ran `python Scripts/oracle/validate_lgt_core.py` and reached `44/44`,
  including the RP-KER complex-character guard.

Before drafting paper prose, rerun the relevant reflection files and aggregate
GateYM build, then record fresh command output here or in a task note.

## Provenance and source boundaries

- T12 verified bibliographic details for Osterwalder-Seiler 1978 and
  Menotti-Pelissetto 1987. A parseable Menotti-Pelissetto mirror supports the
  LINK-vs-SITE reflection-plane distinction; full Osterwalder-Seiler proof text
  remains open.
- The current Lean stack should be described as this repo's finite algebraic
  formalization, not as a direct formalization of either paper's exact theorem
  or of the full Wilson-fermion setting.
- The RP-KER rows in `Scripts/oracle/validate_lgt_core.py` pin conventions but
  are not proof.

## Remaining gaps

- RP-LINK is not fully closed: the zero-cut doubled-lattice construction (now
  including genuine ensemble-weight identification, per `e6e46e9f`) is a
  well-definedness/consistency instance of reflection positivity, not the
  case with actual cut plaquettes - Osterwalder-Seiler's genuinely
  nontrivial content. Aristotle `8271a64b` closes the abstract factorized
  Wilson cut-kernel bridge, and `ReflectionCutPlaquetteExample.lean` supplies
  a minimal concrete cut-plaquette holonomy factorization plus singleton
  `PlaquetteEnsemble.weight` RP, while the mixed product theorem supplies the
  expected algebraic assembly shape. Concrete finite cut-ensemble
  instantiation and the general abstract reflection-family theorem are still
  open.
- Q2/Q3 transfer Hilbert space and Z2 electric-sector decomposition are finite
  algebraic infrastructure only. The concrete Wilson slab/physical transfer
  matrix, Hamiltonian, and gap interpretation remain open.
- The paper unit should not claim positivity, stability, spectrum, or physical
  Hilbert-space interpretation beyond the exact finite algebraic statements
  already kernel-checked.
- Novelty remains unproved. T12 quick search found nearby Lean OS/QFT
  formalizations but no verified Wilson lattice-gauge RP formalization matching
  this finite RP-LINK target in that limited pass.
