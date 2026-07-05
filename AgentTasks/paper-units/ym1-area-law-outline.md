# Paper Unit Outline: Finite-Group Lattice Gauge Area Law

Date: 2026-07-04
Run: `AgentTasks/fourday-ym-run-2026-07-05`
Status: outline only; draft Lean inventory, not a promotion request.

## Working scope

This unit presents the finite-group lattice gauge theory ladder that currently
proves an exact area-law identity in the draft GateYM tree. The safest headline
is:

> A kernel-checked draft formalization of finite-group lattice gauge identities
> leading to an exact independent-plaquette area law and a concrete rectangular
> tree-gauge bridge, with the tree-slice boundary-lasso identity and the
> rectangular boundary-circuit expectation theorem proved.

Do not use novelty language yet. T12 has not cleared source-internal historical
or novelty review.

## Theorem inventory

Gauge core:

- `PhysicsSM/Draft/NullEdge/GateYM/Z2GaugeCore.lean`
  - `hol_gauge`, `hol_gauge_closed`, `plaq_gauge`
  - `gauge_comp`, `gauge_invol`, `plaqSpins_gauge`
- `PhysicsSM/Draft/NullEdge/GateYM/ElitzurCore.lean`
  - `abstract_elitzur_bound`
- `PhysicsSM/Draft/NullEdge/GateYM/ElitzurLattice.lean`
  - `flipAt_involutive`, `plaqSpins_flipAt_invariant`
  - `sourceTerm_flipAt`, `abs_K_le_card`, `elitzur_bound`

Z2 torus exact counting:

- `PhysicsSM/Draft/NullEdge/GateYM/TorusEvenCover.lean`
  - `zeroBoundary_iff_eq_empty_or_univ`
  - `eq_or_compl_of_sameBoundary`
  - `sum_zeroBoundary_weights`
  - `sum_sameBoundary_weights`
  - `ratio_sameBoundary_zeroBoundary_weights`
  - `ratio_rectInside`

Finite-group fusion:

- `PhysicsSM/Draft/NullEdge/GateYM/FusionConvolution.lean`
  - `lemma2a_fusion_convolution`
  - `iterConv_character_fusion_cross`
  - `iterConv_eigen`, `iterConv_eigen_at_one`

Wilson area-law scalar:

- `PhysicsSM/Draft/NullEdge/GateYM/Theorem2AreaLaw.lean`
  - `wilsonPlaquetteSum_pos`, `wilsonPlaquetteSumC_ne_zero`
  - `wilsonLocalWeightC_class`, `wilsonLocalWeightC_inv_of_unitary`
  - `wilson_gamma`
  - `wilson_iterConv_eigen_at_one`
  - `wilson_iterConv_normalized_at_one`
  - `wilson_iterConv_normalizedGamma_at_one`
  - `wilson_iterConv_normalizedGamma_cross_at_one`

Independent plaquette ensemble:

- `PhysicsSM/Draft/NullEdge/GateYM/IndependentPlaquetteEnsemble.lean`
  - `sum_weight_orderedProdInv_eq_iterConv`
  - `sum_weight_orderedProd_eq_iterConv_of_inv`
  - `partition_eq_pow`
  - `loopNumerator_factor`, `loopNumerator_eq_iterConv`
  - `loopExpectation_eq_iterConv_div`
  - `wilson_loop_expectation_area_law`
  - `norm_wilson_loop_expectation`

Tree-gauge bridge:

- `PhysicsSM/Draft/NullEdge/GateYM/TreeGaugeBridge.lean`
  - `PlaquetteCoordinatization`
  - `linkPartition_eq`, `linkNumerator_eq`
  - `linkExpectation_eq_loopExpectation`
  - `wilson_link_loop_expectation_area_law`
- `PhysicsSM/Draft/NullEdge/GateYM/RectTreeGauge.lean`
  - `rectLattice`, `rectPlaquette`
  - `rectPlaquette_hol_formula`
  - `rectCoordinatization`
  - `rect_wilson_loop_expectation_area_law`
- `PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryLasso.lean`
  - `rectBoundaryWalk`
  - `rectBoundary_hol_formula`
  - `rectBoundary_hol_eq_reversedRowMajorPlaquetteProd_of_treeSlice`
  - `rectBoundary_chi_eq_chi_reversedRowMajorPlaquetteProd_of_treeSlice`
- `PhysicsSM/Draft/NullEdge/GateYM/RectBoundaryExpectation.lean`
  - `combGaugeField`
  - `bSummand_gauge_inv`
  - `treeSlice_sum_indep_t`
  - `treeSlice_summand_eq`
  - `linkNumerator_boundary_eq`
  - `linkExpectation_boundary_eq`
  - `rect_boundary_wilson_loop_expectation_area_law`

Spectrum/gap-adjacent support:

- `PhysicsSM/Draft/NullEdge/GateYM/FDRepUnitarizable.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/FusionTransferSpectrum.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/WilsonVacuumDominance.lean`
  - unconditional unitarizability-backed vacuum dominance and real ordered
    normalized Wilson fusion scalars, per the aggregator and T4/T5 notes.

## Verification record to cite

Use exact command records from the run ledger and task notes, not memory. Recent
known records include:

- `lake build PhysicsSM.Draft.NullEdge.GateYM` passed during T11 after
  `RectBoundaryLasso.lean` was wired into the aggregator and again after the
  lasso proof was harvested/integrated.
- `RectBoundaryExpectation.lean` was harvested from Aristotle project
  `acedaea2`; cite the integration ledger entry for exact local command output.
- `python Scripts/oracle/validate_lgt_core.py` passed at `44/44` after the T14
  v0.3 fixtures.

Before drafting paper prose, rerun the targeted Lean checks and a fresh aggregate
GateYM build, then record the new command output in the paper-unit note.

## Provenance and source boundaries

- The formal area-law stack is a draft repo artifact built from the program
  notes and local Lean development.
- T12 verified bibliographic/abstract-level source status for historical RP/KP
  references and later strengthened the RP attribution chain. It did not clear
  novelty claims for YM1.
- The oracle file is a convention-pinning and regression tool, not proof.

## Remaining gaps

- The exact relationship between finite draft theorem names and any final paper
  theorem numbering needs a fresh cross-review.
- This outline deliberately avoids infinite-volume and physical mass-gap claims.
