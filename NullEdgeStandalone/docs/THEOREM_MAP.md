# Theorem Map

This map is organized by scientific role, not by directory order.
For Gate C claim labels such as finite identity, no-go theorem, conditional
schema, reconstruction target, and physical non-claim, see
[`GATE_C_ASSUMPTION_LEDGER.md`](GATE_C_ASSUMPTION_LEDGER.md).

## Spine At A Glance

Load-bearing theorem spine:

1. Finite Pluecker mass: invariant mass as spinor-spread obstruction.
2. 1+1D checkerboard seed: mass as null-direction reversal amplitude.
3. Dual-soldered/super-Dirac square: finite operator algebra and mass-sign
   guardrail.
4. Gate C no-go: the bare 3+1D symbol is chirality-balanced.

Scaffolding:

- static slash bridge;
- Krein double;
- Schur complement;
- spectral mass-shell matching;
- frozen projected/Wilson release schemas.

## Kinematic Core: Finite Pluecker Mass

Module: `PhysicsSM.Spinor.PluckerMass`

- `det_rankOneHermitian_eq_zero`: one visible null edge is massless.
- `two_edge_plucker_mass_identity`: two-edge determinant equals squared wedge.
- `fin_bundle_plucker_mass_identity`: finite bundle mass equals total pairwise
  Pluecker spread.
- `fin_bundle_det_re_nonneg`: determinant mass has nonnegative real part.
- `fin_bundle_mass_zero_iff_common_direction`: zero mass iff all spinors share a
  common direction, given a nonzero base spinor.

Module: `PhysicsSM.Spinor.TwistorPluckerMass`

- `multi_twistor_momentum_det_eq_pairwiseMass`: twistor-chart version.
- `multiTwistorMassSqDetConvention_eq_zero_iff_common_pi_direction`: massless
  locus in the determinant convention.

## Dynamical Seed: 1+1D Checkerboard

Module: `PhysicsSM.Draft.Checkerboard1D`

- `checkerStep_eq`: one finite step is the two-by-two matrix with diagonal
  null-preserving amplitudes and off-diagonal reversal amplitude.
- `checkerStep_right_to_left`, `checkerStep_left_to_right`: the direction
  reversal entries are exactly the mass parameter.
- `massless_step_right`, `massless_step_left`: at zero mass, right-moving and
  left-moving null states decouple.
- `massFlip_right`, `massFlip_left`: the mass channel flips null direction.
- `edgeAmp_of_turn`, `edgeAmp_turn_symmetric`: every turn carries the mass
  amplitude, independent of turn orientation.
- `nullTransport_commutes_directionGrade`: massless transport preserves the
  direction grading.
- `massFlip_anticommutes_directionGrade`: the mass/reversal channel
  anticommutes with the direction grading.
- `checkerStep_sq`: two-step path expansion into preserve/reverse alternatives.
- `checkerStep_mulVec`, `checkerboard_recurrence_right`,
  `checkerboard_recurrence_left`, `checkerboard_recurrence`: two-component
  finite recurrence for one transfer step.
- `turnCount`: finite number of direction changes in a checkerboard path.
- `hasTurn_iff_turnCount_pos`: a path has a turn iff its turn count is
  positive.
- `turnCount_pos_of_hasTurn`, `hasTurn_of_turnCount_pos`: named directions of
  the turn-count equivalence.
- `turnCount_eq_zero_iff_not_hasTurn`: zero turn count is exactly no turn.
- `not_hasTurn_of_turnCount_eq_zero`, `turnCount_eq_zero_of_not_hasTurn`: named
  directions of the zero-turn equivalence.
- `turnCount_eq_zero_iff_isChain`: no turns iff all consecutive directions
  agree.
- `first_step_eq_of_turnCount_zero`: zero turn count forces the first edge to
  be straight.
- `pathAmp_zero_mass_of_hasTurn`: at zero mass, every finite path containing a
  direction reversal has zero amplitude.
- `pathAmp_zero_mass_of_turnCount_pos`: turn-count version of the same
  zero-mass obstruction theorem.
- `pathAmp_factor`: every finite path amplitude factors as the unit-mass path
  amplitude times `mu ^ turnCount path`.
- `pathAmpVec`: tuple-form path amplitude for fixed-length paths.
- `turnCountVec`: tuple-form turn count for fixed-length paths.
- `pathAmpVec_cons`: removing the first vertex multiplies in the leading edge
  amplitude.
- `turnCountVec_cons`: removing the first vertex adds the leading turn
  indicator.
- `pathAmpVec_factor`: tuple path amplitude factors by
  `mu ^ turnCountVec`.
- `turnCountVec_le_length`: a length-`n` tuple path has at most `n` turns.
- `pathAmpVec_unit_mass_isotropic`, `pathAmpVec_isotropic`: isotropic tuple
  path weights.
- `turnCount_snoc`, `turnCount_reverse`: appending one direction updates turn
  count by the final edge, and reversing a finite path preserves turn count.
- `pathAmpVec_eq_pathAmp_ofFn`, `turnCountVec_eq_turnCount_ofFn`: tuple paths
  built with `List.ofFn` agree with the list-path amplitude and turn-count API.
- `pathAmpVec_sum_succ`: endpoint-constrained path sums reindex by their first
  edge.
- `checkerStep_pow_apply`: each entry of `checkerStep ^ n` is the finite sum
  over length-`n` checkerboard paths with fixed endpoints.
- `checkerStep_pow_apply_factored`: matrix-power path sum with explicit
  `mu ^ turnCountVec` factors.
- `checkerStep_pow_apply_turnGrouped`: matrix-power path sum grouped by exact
  turn count.
- `checkerStep_pow_apply_isotropic`: isotropic checkerboard path-sum weights.
- `checkerStep_isotropic_unitary`: the isotropic transfer with
  `a = cos theta` and `mu = Complex.I * sin theta` is unitary.

Module: `PhysicsSM.Draft.CheckerboardContinuumScaffold`

- `outgoingRightCount`, `outgoingLeftCount`: endpoint bookkeeping for tuple
  paths under the explicit outgoing-edge convention.
- `outgoingRightCount_add_outgoingLeftCount`: every edge is counted exactly
  once as right-moving or left-moving.
- `outgoingDisplacement`: net lattice displacement associated to a tuple path.
- `isotropicStep`: named unitary checkerboard step.
- `reversal_sq`: the reversal generator squares to the identity.
- `isotropicStep_eq_cos_one_add_i_sin_reversal`: exact finite generator
  decomposition.
- `isotropicStep_zero`: zero angle gives the identity step.
- `reversal_commutes_isotropicStep`: reversal commutes with the isotropic step.
- `matrixL1Norm`: explicit entrywise L1 norm as a local scalar function, not a
  global typeclass instance.
- `isotropicStepFirstOrderRemainder_l1Norm_div_tendsto_zero`: scalar-norm
  small-angle quotient estimate for the packaged first-order remainder.
- `abs_cos_sub_one_le_half_sq`, `abs_sin_sub_le_sixth_cube`: scalar Taylor
  bounds used by the quantitative checkerboard product estimate.
- `isotropicStepFirstOrderRemainder_l1Norm_le_sq_add_cube`: explicit
  second/cubic-order L1 bound for the packaged first-order remainder.
- `isotropicStepFirstOrderRemainder_l1Norm_isBigO_sq`: BigO form of the
  packaged first-order remainder estimate at zero.
- `isotropicStepFirstOrderRemainder_l1Norm_isLittleO_id`: little-o form of the
  packaged first-order remainder estimate at zero.
- `isotropicStepFirstOrderRemainder_l1Norm_isLittleO_comp`: composed-filter
  little-o form for accumulated-angle maps.
- `CheckerboardContinuumScale`, `unitaryAngleHasMassScale`,
  `CheckerboardDiracLimitProblem`: typed scaffold for future analytic
  continuum statements, not continuum theorems.

Module: `PhysicsSM.Draft.CheckerboardContinuumNext`

- `isotropicStep_pow_eq`: the unitary isotropic step is a one-parameter group.
- `isotropicStep_pow_eq_one_add_scaled_generator_add_remainder`: exact
  product/remainder bridge for powers.
- `isotropicStep_pow_sub_linear_l1Norm_eq`: product error against the
  accumulated-angle first-order model equals the L1 norm of the packaged
  remainder.
- `isotropicStep_pow_sub_linear_l1Norm_eq_explicit`: explicit closed form for
  that product error.
- `isotropicStep_equal_subdivision_exact`: fixed-angle subdivision is exact.
- `isotropicStep_equal_subdivision_sub_linear_l1Norm_eq`: fixed-angle
  subdivision does not make the first-order linearization error vanish.
- `isotropicStep_pow_sub_linear_l1Norm_tendsto_zero_of_accumulated_tendsto_zero`:
  accumulated-angle smallness implies vanishing product error.
- `isotropicStep_pow_sub_linear_l1Norm_le_accumulated_sq_add_cube`:
  quantitative product-error bound in terms of the accumulated angle.
- `isotropicStep_sub_linear_l1Norm_isBigO_sq`: one-step operator-facing BigO
  linearization estimate at zero.
- `isotropicStep_sub_linear_l1Norm_isLittleO_id`: one-step operator-facing
  little-o linearization estimate at zero.
- `isotropicStep_pow_sub_linear_l1Norm_isLittleO_accumulated`: product error is
  little-o of the accumulated angle when that angle tends to zero.

Module: `PhysicsSM.Draft.CheckerboardDiracScaling`

- `CheckerboardDiracScalingData`: explicit scaling data for the
  topology-explicit checkerboard-to-Dirac design layer.
- `CheckerboardDiracScalingData.accumulatedAngle_eq_totalTime_mul_mass`:
  the accumulated mass angle equals total time times mass.
- `diracHamiltonianSymbol`, `diracEvolutionSymbol`: continuum momentum-space
  comparison objects for the 1+1D Dirac symbol.
- `nullShiftSymbol`, `momentumStepSymbol`, `momentumEvolution`: finite
  momentum-space checkerboard evolution objects.
- `momentumStepSymbolRaw`, `momentumStepFirstOrderModel`,
  `momentumStepFirstOrderRemainder`,
  `momentumStepFirstOrderDiscrepancy`: raw-parameter per-step expansion API.
- `continuumStepSymbol`, `continuumStepBridgeRemainder`,
  `continuumStepBridgeDiscrepancy`: one-step continuum exponential bridge API.
- `continuumStepBridgeDiscrepancy_nonneg`: nonnegativity of the bridge
  discrepancy.
- `momentumStepSymbol_eq_raw`: record-based and raw-parameter step symbols
  agree definitionally.
- `momentumStepFirstOrderDiscrepancy_nonneg`: nonnegativity of the per-step
  first-order discrepancy.
- `matrixL1Norm_one`: the local entrywise L1 norm of the identity is `2`, a
  guardrail for long-product stability arguments.
- `linftyOpNorm_one`, `linftyOpNorm_mul_le`,
  `linftyOpNorm_le_matrixL1Norm`: scoped Mathlib L-infinity operator-norm
  bridge, recording identity size `1`, submultiplicativity, and comparison with
  local entrywise L1.
- `linftyOpNorm_momentumStepFirstOrderRemainder_isBigO_sq`: operator-norm
  version of the finite-step first-order remainder estimate.
- `norm_expMat_sub_one_sub_self_le`: abstract second-order exponential
  remainder estimate in the scoped L-infinity operator norm.
- `linftyOpNorm_continuumStepBridgeRemainder_isBigO_sq`: scoped
  operator-norm second-order bound for the continuum one-step bridge.
- `linftyOpNorm_pow_sub_pow_le`: scoped operator-norm matrix-power stability
  estimate.
- `linftyOpNorm_exp_le`: scalar exponential bound for matrix exponentials in
  the scoped L-infinity operator norm.
- `linftyOpNorm_continuumStepSymbol_le_exp`: continuum one-step factor bound
  in the scoped L-infinity operator norm.
- `linftyOpNorm_nullShiftSymbol_le_one`: scoped L-infinity operator-norm bound
  for the diagonal null-transport phase.
- `linftyOpNorm_isotropicStep_le_abs_cos_add_abs_sin`: row-sum bound for the
  isotropic mass-mixing step.
- `linftyOpNorm_isotropicStep_le_one_add_abs`: simple first-order row-sum
  bound for the isotropic mass-mixing step.
- `linftyOpNorm_momentumStepSymbolRaw_le_one_add_abs`: scoped L-infinity
  operator-norm bound for the raw finite one-step checkerboard symbol.
- `linftyOpNorm_momentumStep_sub_continuumStep_isBigO_sq`: combined
  second-order bridge from the raw checkerboard step to the continuum
  one-step exponential in the scoped L-infinity operator norm.
- `l2OpNorm_one`, `l2OpNorm_mul_le`, `l2OpNorm_of_mem_unitaryGroup`: scoped
  L2 operator-norm identities and submultiplicativity facts.
- `nullShiftSymbol_mem_unitaryGroup`, `isotropicStep_mem_unitaryGroup`,
  `momentumStepSymbolRaw_mem_unitaryGroup`,
  `momentumStepSymbol_mem_unitaryGroup`: unitarity of the one-step factors and
  finite one-step checkerboard symbol.
- `l2OpNorm_momentumStepSymbolRaw`, `l2OpNorm_momentumStepSymbol`: exact
  L2 operator-norm normalization of the finite one-step symbol.
- `momentumStepSymbolRaw_zero`, `momentumStepFirstOrderModel_zero`,
  `momentumStepFirstOrderRemainder_zero`,
  `momentumStepFirstOrderDiscrepancy_zero`: zero-spacing sanity checks.
- `continuumStepSymbol_zero`, `continuumStepBridgeRemainder_zero`,
  `continuumStepBridgeDiscrepancy_zero`: zero-spacing sanity checks for the
  continuum-exponential bridge.
- `momentumStepFirstOrderRemainder_apply`: exact entrywise form of the
  momentum-step first-order remainder.
- `momentumStepFirstOrderDiscrepancy_le`: explicit second-order/cubic
  polynomial bound for the per-step discrepancy when `|p * eps| <= 1`.
- `momentumStepFirstOrderDiscrepancy_isBigO_sq`: pointwise per-step
  second-order BigO theorem in the lattice spacing.
- `momentumStepFirstOrderDiscrepancy_tendsto_zero_div_sq_bound`: explicit
  eventual-constant form of the per-step second-order estimate.
- `matrixL1Norm_mul_le`: submultiplicativity of the local matrix norm.
- `matrixL1Norm_pow_le`: positive-power bound for `matrixL1Norm`.
- `pow_succ_sub`: noncommutative telescoping identity for a difference of
  matrix powers.
- `matrixL1Norm_pow_sub_pow_le`: Trotter-style matrix-power stability estimate.
- `matrixL1Norm_neg`, `matrixL1Norm_smul_complex`,
  `matrixL1Norm_diracHamiltonianSymbol`, `matrixL1Norm_tsum_le`,
  `matrixExpSeries_summable`, `matrixExp_eq_tsum`,
  `matrixExp_sub_one_sub_self_eq_tsum`, `matrixL1Norm_tsum_expTail_le`,
  `real_exp_sub_one_sub_self_eq_tsum`,
  `matrixL1Norm_exp_sub_one_sub_self_le`,
  `real_exp_sub_one_sub_self_le_sq`, and
  `continuumStepBridgeDiscrepancy_le`: entrywise matrix-exponential bridge
  toolkit.
- `continuumStepBridgeDiscrepancy_isBigO_sq`: pointwise second-order BigO
  theorem for the continuum exponential bridge.
- `continuumStepBridgeDiscrepancy_tendsto_zero_div_sq_bound`: explicit
  eventual-constant form of the continuum bridge estimate.
- `latticeSite`, `sampleContinuum`, `MomentumWindow`: observation and future
  interpolation API.
- `momentumEvolution_mem_unitaryGroup`: the finite `N`-step momentum evolution
  is unitary.
- `l2OpNorm_momentumEvolution`: exact L2 operator-norm normalization of every
  finite `N`-step momentum evolution.
- `continuumStepSymbol_pow_eq_diracEvolutionSymbol`: powers of the continuum
  one-step symbol are exactly the Dirac evolution symbol at total time
  `N * eps`.
- `linftyOpNorm_momentumEvolution_sub_continuumPow_le`: concrete finite
  power-stability bound between `momentumEvolution` and the matching continuum
  one-step power.
- `linftyOpNorm_momentumEvolution_sub_diracEvolution_le`: concrete finite
  power-stability bound between `momentumEvolution` and the continuum Dirac
  evolution at `D.totalTime`.
- `momentumEvolutionDiscrepancy`: local `matrixL1Norm` discrepancy between the
  finite momentum evolution and continuum Dirac evolution.
- `momentumEvolutionDiscrepancy_nonneg`: nonnegativity of the local discrepancy.
- `CheckerboardDiracRefinement`: refinement-family data for the intended
  pointwise momentum convergence theorem.
- `CheckerboardDiracRefinement.timeStep_tendsto_zero`,
  `CheckerboardDiracRefinement.massAngle_tendsto_zero`,
  `CheckerboardDiracRefinement.accumulatedAngle_tendsto`: immediate derived
  scaling limits from the refinement data.

## Connective Tissue: Static Slash Bridge

Modules:

- `PhysicsSM.Draft.NullEdgeDiracSlashCore`
- `PhysicsSM.Draft.NullEdgeBundleDiracPluckerCore`
- `PhysicsSM.NullStrand.FiniteCore`

Key theorem:

- `finiteCore_staticMassSquareRoot`: the static chiral slash of the finite
  bundle momentum squares to the Pluecker mass.

## Operator Algebra: Dual-Soldered And Super-Dirac

Module: `PhysicsSM.NullStrand.DualSolder.DualSolderSymbolKinetic`

- `dualSymbol_reconstructs_covector`
- `dualSolder_commutator_exact`
- `dualSymbol_sq`
- `plueckerKinetic_not_zeroOrder_doc`
- `Tetrahedron.ell_isNull`
- `Tetrahedron.alpha_ell_delta`
- `Tetrahedron.tetra_resolution_id`

Module: `PhysicsSM.NullStrand.DualSolder.GradedSuperDiracSquare`

- `square_decomposition_quarter`
- `gammaPhi_sq`
- `mass_sign_flip`
- `superDirac_graded_square`

Module: `PhysicsSM.Draft.NullEdgeFiniteTetradPostulate`

- `frame_term_vanishes`
- `dirac_square_full_decomp`
- `dirac_square_full_of_tetrad`

## Linear-Algebra Scaffolding: Krein And Spectral APIs

Module: `PhysicsSM.NullStrand.DualSolder.FiniteKreinDoubled`

- `kreinAdjoint_involutive`
- `kreinAdjoint_mul`
- `retardedAdvancedDouble_isJSelfAdjoint`
- `retardedAdvancedDouble_sq_blockDiag`

Module: `PhysicsSM.NullStrand.DualSolder.SpectralSchur`

- `kernel_tensorDifference_eq_matchingEigenspaces`
- `massShellMultiplicity_eq_sum_matchingMultiplicities`
- `blockSystem_iff_schurComplement_of_invertible_hidden`
- `localDilation_effectiveOperator_eq_schurComplement`

## 3+1D Obstruction: Gate C No-Go

Claim label: **no-go theorem** for the bare symbol. The projected/Wilson files
below are **conditional schema** material until their data are derived from a
concrete operator.

Modules:

- `PhysicsSM.Draft.TetrahedralHighMomentumNullBranch`
- `PhysicsSM.Draft.NullEdgeSpectralGraphNodalSet`
- `PhysicsSM.Draft.NullEdgeActualCliffordSymbol`
- `PhysicsSM.Draft.NullEdgeHyperdiamondNoGo`
- `PhysicsSM.Draft.NullEdgeHyperdiamondBridge`
- `PhysicsSM.Draft.NullEdgeGateCGhostZeroSafety`
- `PhysicsSM.Draft.NullEdgeProjectedGateCRelease`
- `PhysicsSM.Draft.NullEdgeProjectedGateCWilsonRelease`

Central theorem:

- `no_full_symbol_single_chirality`: the bare high-momentum null branch kernel
  contains both spacetime chiralities, so the flat bare symbol cannot release a
  single chiral branch.
- `highMomentum_branch_nogo`: bundles nullity, nonzero symbol, nilpotency,
  opposite-chirality kernel modes, and the global single-sign no-go for all
  four high-momentum branches.
- `no_branch_single_sign`: per-branch no-go; no one `gamma5` sign describes an
  entire bare branch kernel.
- `bare_symbol_proof_cannot_fix_chirality`: every candidate branch sign is
  contradicted by a nonzero bare zero mode.
- `chiralProj_forces_alignment`, `chiralProj_cuts_kernel`: an explicit
  chirality projector is sufficient to select one mode, identifying extra data
  the bare symbol lacks without proving physical release.
- `hyperdiamond_crosswalk_exact`: exact frame/convention bridge between the
  Gate C tetrahedral dual frame and the complexified dual-soldered
  tetrahedral frame.
- `dualSolder_symbol_matches_gateC_symbol`: covector-level bridge from the
  real dual-soldered tetrahedral covector to the Gate C `pCov`, plus the
  corresponding symbol-square law.
- `gateC_symbol_sq_kinetic`, `dualSolder_and_gateC_share_square_law`: shared
  principal-symbol-square contract for the dual-soldered and Gate C symbol
  layers.
- `nielsenNinomiya_assumption_ledger`: represented-data ledger for the finite
  assumptions currently formalized; not an instance of the Nielsen-Ninomiya
  theorem.
- `chiralProj_idempotent`: structural sufficiency fact that the added
  chirality projector is idempotent; not physical projected-operator data.

Audit guardrails:

- Retardedness removes only coefficient-zero doublers; it does not remove
  determinant-zero null branches.
- A nonzero index is necessary but not sufficient; ghost-zero and Krein-sign
  audits remain separate obligations.
- The projected/Wilson release files are frozen conditional schemas until their
  predicates are connected to concrete projected operator data.

See [`GATE_C.md`](GATE_C.md) for the claim-boundary ledger.
