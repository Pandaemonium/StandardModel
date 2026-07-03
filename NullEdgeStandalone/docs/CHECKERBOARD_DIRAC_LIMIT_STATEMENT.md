# Checkerboard-To-Dirac Limit Statement Design

Date: 2026-07-02
Status: design layer added and kernel-checked. No continuum limit is proved.

This note records the topology-explicit boundary for the first honest
checkerboard-to-Dirac theorem. The Lean scaffold lives in
`PhysicsSM/Draft/CheckerboardDiracScaling.lean`, namespace
`PhysicsSM.Draft.CheckerboardDiracScaling`.

## What Was Added

The new module adds a statement-free design API:

- `CheckerboardDiracScalingData`: lattice spacing `eps`, step count `N`,
  mass `m`, momentum half-width `pMax`, and proofs that `eps > 0` and
  `pMax >= 0`.
- Derived scales: `timeStep`, `totalTime`, `massAngle`, `accumulatedAngle`, and
  `accumulatedAngle_eq_totalTime_mul_mass`.
- Continuum symbols: `diracHamiltonianSymbol` and `diracEvolutionSymbol`.
- Finite momentum-space symbols: `nullShiftSymbol`, `momentumStepSymbol`, and
  `momentumEvolution`.
- Raw per-step expansion API: `momentumStepSymbolRaw`,
  `momentumStepFirstOrderModel`, `momentumStepFirstOrderRemainder`,
  `momentumStepFirstOrderDiscrepancy`, and
  `momentumStepFirstOrderDiscrepancy_nonneg`.
- one-step continuum-exponential bridge API: `continuumStepSymbol`,
  `continuumStepBridgeRemainder`, `continuumStepBridgeDiscrepancy`, and
  `continuumStepBridgeDiscrepancy_nonneg`.
- local norm/stability guardrail: `matrixL1Norm_one`, which records that the
  entrywise L1 norm of the identity is `2`, so this norm is an error-measuring
  tool rather than the final long-product stability norm.
- scoped Mathlib operator-norm bridge:
  `linftyOpNorm_one`, `linftyOpNorm_mul_le`, and
  `linftyOpNorm_le_matrixL1Norm`. These show that Mathlib's scoped
  `Matrix.Norms.Operator` L-infinity operator norm has identity size `1`, is
  submultiplicative, and is bounded by the local entrywise L1 norm.
- operator-norm per-step error conversion:
  `linftyOpNorm_momentumStepFirstOrderRemainder_isBigO_sq`.
- L-infinity operator-norm continuum bridge:
  `norm_expMat_sub_one_sub_self_le`,
  `linftyOpNorm_continuumStepBridgeRemainder_isBigO_sq`,
  `linftyOpNorm_pow_sub_pow_le`, `linftyOpNorm_exp_le`,
  `linftyOpNorm_continuumStepSymbol_le_exp`,
  `linftyOpNorm_nullShiftSymbol_le_one`,
  `linftyOpNorm_isotropicStep_le_abs_cos_add_abs_sin`,
  `linftyOpNorm_isotropicStep_le_one_add_abs`,
  `linftyOpNorm_momentumStepSymbolRaw_le_one_add_abs`, and
  `linftyOpNorm_momentumStep_sub_continuumStep_isBigO_sq`.
- scoped L2 operator-norm/unitarity bridge:
  `l2OpNorm_one`, `l2OpNorm_mul_le`,
  `l2OpNorm_of_mem_unitaryGroup`, `nullShiftSymbol_mem_unitaryGroup`,
  `isotropicStep_mem_unitaryGroup`,
  `momentumStepSymbolRaw_mem_unitaryGroup`,
  `momentumStepSymbol_mem_unitaryGroup`,
  `l2OpNorm_momentumStepSymbolRaw`, and
  `l2OpNorm_momentumStepSymbol`.
- zero-spacing sanity checks:
  `momentumStepSymbolRaw_zero`, `momentumStepFirstOrderModel_zero`,
  `momentumStepFirstOrderRemainder_zero`, and
  `momentumStepFirstOrderDiscrepancy_zero`, plus
  `continuumStepSymbol_zero`, `continuumStepBridgeRemainder_zero`, and
  `continuumStepBridgeDiscrepancy_zero`.
- per-step second-order estimates:
  `momentumStepFirstOrderRemainder_apply`,
  `momentumStepFirstOrderDiscrepancy_le`,
  `momentumStepFirstOrderDiscrepancy_isBigO_sq`, and
  `momentumStepFirstOrderDiscrepancy_tendsto_zero_div_sq_bound`.
- matrix-power/Trotter toolkit:
  `matrixL1Norm_mul_le`, `matrixL1Norm_pow_le`, `pow_succ_sub`, and
  `matrixL1Norm_pow_sub_pow_le`.
- entrywise matrix-exponential bridge:
  `matrixL1Norm_neg`, `matrixL1Norm_smul_complex`,
  `matrixL1Norm_diracHamiltonianSymbol`, `matrixL1Norm_tsum_le`,
  `matrixExpSeries_summable`, `matrixExp_eq_tsum`,
  `matrixExp_sub_one_sub_self_eq_tsum`, `matrixL1Norm_tsum_expTail_le`,
  `real_exp_sub_one_sub_self_eq_tsum`,
  `matrixL1Norm_exp_sub_one_sub_self_le`,
  `real_exp_sub_one_sub_self_le_sq`,
  `continuumStepBridgeDiscrepancy_le`,
  `continuumStepBridgeDiscrepancy_isBigO_sq`, and
  `continuumStepBridgeDiscrepancy_tendsto_zero_div_sq_bound`.
- Observation API: `latticeSite`, `sampleContinuum`, `MomentumWindow`, and
  `momentumEvolutionDiscrepancy`.
- finite-product unitarity and normalization:
  `momentumEvolution_mem_unitaryGroup` and
  `l2OpNorm_momentumEvolution`.
- continuum-product identity:
  `continuumStepSymbol_pow_eq_diracEvolutionSymbol`.
- concrete finite-step-to-finite-product stability:
  `linftyOpNorm_momentumEvolution_sub_continuumPow_le` and
  `linftyOpNorm_momentumEvolution_sub_diracEvolution_le`.
- `CheckerboardDiracRefinement`: a family with `eps -> 0`, `totalTime -> T`,
  and fixed mass/window data.
- refinement helper lemmas:
  `CheckerboardDiracRefinement.timeStep_tendsto_zero`,
  `CheckerboardDiracRefinement.massAngle_tendsto_zero`, and
  `CheckerboardDiracRefinement.accumulatedAngle_tendsto`.
- `momentumEvolutionDiscrepancy_nonneg`.

The intended theorem `checkerboard_dirac_limit_statement` is recorded only as a
comment. It is not yet a theorem because the needed analytic estimates are not
in Lean.

## Design Answers

1. Finite evolution object:
   `momentumEvolution D p = (nullShiftSymbol D.eps p * isotropicStep D.massAngle) ^ D.N`.
   This compares the full momentum-space step, including null transport, not
   the false fixed-time linearization `1 + T * generator`.

2. Observation map:
   the first theorem should be pointwise in momentum, using
   `MomentumWindow D p`. Position-space sampling exists as `latticeSite` and
   `sampleContinuum`, but interpolation and `L2` upgrades are deferred.

3. Norm/topology:
   use the local scalar `matrixL1Norm` on the finite `2 x 2` complex matrix,
   pointwise in momentum. This avoids a premature global norm instance and
   avoids committing to distributional or `L2` infrastructure too early.

4. Scaling parameters:
   `eps`, `N`, `m`, `pMax`, plus derived `totalTime = N * eps`,
   `massAngle = eps * m`, and `accumulatedAngle = N * eps * m`.
   The refinement regime is `eps -> 0`, `totalTime -> T`, fixed `m`, and fixed
   momentum window.

5. Dependencies already available:
   `isotropicStep`, `isotropicGenerator`,
   `isotropicStep_eq_one_add_theta_generator_add_remainder`,
   `isotropicStepFirstOrderRemainder`, `matrixL1Norm`, and the
   accumulated-angle product-error estimates in
   `PhysicsSM.Draft.CheckerboardContinuumNext`.

6. Smallest honest next statement:
   for `R : CheckerboardDiracRefinement` and a fixed observed momentum `p`,
   show
   `momentumEvolutionDiscrepancy (R.data k) p -> 0`.
   This is a pointwise finite-matrix asymptotic theorem, not a full
   position-space continuum theorem.

## Missing Analytic Lemmas

Before the intended comment can become a theorem, the project still needs:

1. Uniform/eventual choices of `M` and `delta` in
   `linftyOpNorm_momentumEvolution_sub_diracEvolution_le`. The needed finite
   L-infinity factor bounds now exist for the null phase, isotropic mass step,
   raw checkerboard step, and continuum exponential step.
2. The refinement-limit argument needed for the pointwise
   `checkerboard_dirac_limit_statement`.

## Semantic Review

The scaffold is deliberately modest. It compares a concrete finite matrix power
with a concrete continuum matrix exponential. The mass-term sign in
`diracHamiltonianSymbol` is chosen to match the first-order expansion of the
finite step in this convention: the transport phase contributes the
`p * directionGrade` term and `isotropicStep` contributes the mass/reversal
term with the opposite sign in the Hamiltonian.

The fixed-time subdivision guardrail remains load-bearing. The theorem boundary
uses a refinement limit with `eps -> 0` and `N * eps -> T`; it does not claim
that subdividing `isotropicStep T` makes the first-order linearization error
vanish.

## Ranked Next Steps

1. Accumulated pointwise Trotter bound.
   Claim type: asymptotic theorem. Combine the scoped per-step bridge,
   finite-product L2 normalization, and matrix-power telescoping into an
   `N * O(eps^2)` estimate under fixed-time refinement.
2. Interpolation/observation API for lattice spinors.
   Claim type: reconstruction theorem. This should come after the pointwise
   momentum theorem.
3. Source-faithful path-sum asymptotics from checkerboard counts.
   Claim type: asymptotic theorem. This is an independent cross-check using
   the closed-form propagator formulas.
4. Scheduler/relativistic-clock abstraction.
   Claim type: consistency check. Useful for physical interpretation, but lower
   priority than the Trotter estimate.
5. Hyperdiamond pole-structure lane.
   Claim type: finite identity/no-go theorem. Important, but independent of
   the 1+1D checkerboard limit boundary.

## Provenance

This is a Lean-facing design scaffold informed by the checkerboard and quantum
walk literature reviewed in `CHECKERBOARD_LITERATURE_REVIEW.md` and
`AgentTasks/null-edge-cycle-04-literature-2026-07-02.md`, especially Strauch,
Arrighi-Forets-Nesme, and Skopenkov-Ustinov. It does not copy external code or
claim that any source theorem is already formalized here.
