# Next Theorems

This roadmap turns the post-Aristotle big picture into concrete Lean-facing
targets. It is intentionally conservative: every item is labeled by the kind of
claim it would establish.
For the Gate C claim-label vocabulary and represented-vs-missing assumption
ledger, see [`GATE_C_ASSUMPTION_LEDGER.md`](GATE_C_ASSUMPTION_LEDGER.md).

## A. Checkerboard Dynamics

Status: active finite seed.

Current module:

```text
PhysicsSM.Draft.Checkerboard1D
PhysicsSM.Draft.CheckerboardContinuumScaffold
```

Already checked:

- one-step transfer matrix;
- mass as null-direction reversal amplitude;
- massless left/right decoupling;
- finite path amplitude;
- turn count;
- zero-mass paths with a turn have zero amplitude;
- path amplitude factorization by `mu ^ turnCount path`;
- tuple-form path amplitudes for fixed path length;
- tuple turn count and tuple amplitude factorization;
- matrix powers of `checkerStep` as endpoint-constrained finite path sums;
- matrix-power path sums grouped by exact tuple turn count;
- isotropic path weights `mu ^ turns * a ^ straight_edges`;
- tuple/list bridge theorems for `List.ofFn` path amplitudes and turn counts;
- reverse-path turn-count invariance;
- unitary isotropic transfer for
  `a = cos theta`, `mu = Complex.I * sin theta`;
- endpoint/displacement bookkeeping scaffold for outgoing-edge convention;
- exact isotropic-step algebra `cos(theta) * 1 + i sin(theta) * reversal`;
- exact finite generator setup:
  `isotropicGenerator`, `isotropicGenerator_sq`,
  `isotropicStep_eq_cos_smul_one_add_sin_smul_generator`, and
  `isotropicStep_eq_one_add_sin_generator_add_cos_remainder`;
- exact packaged first-order remainder
  `isotropicStepFirstOrderRemainder` and
  `isotropicStep_eq_one_add_theta_generator_add_remainder`;
- zero-derivative check for the packaged first-order remainder
  `isotropicStepFirstOrderRemainder_hasDerivAt_zero`;
- quantitative quotient/asymptotic estimates:
  `sin_sub_id_div_tendsto_zero`, `cos_sub_one_div_tendsto_zero`,
  `sin_sub_id_isLittleO`, `cos_sub_one_isLittleO`, and
  `isotropicStepFirstOrderRemainder_div_tendsto_zero`;
- finite calculus bridge `isotropicStep_hasDerivAt_zero`, proving that the
  zero-angle derivative of the isotropic step is `isotropicGenerator`;
- arbitrary-angle finite derivative formula `hasDerivAt_isotropicStep`;
- generator/evolution commutation
  `isotropicGenerator_commutes_isotropicStep`;
- typed small-step/mass-scale analytic scaffold;
- two-component finite checkerboard recurrence.
- turn-count parity equals endpoint-velocity change;
- fixed initial/final velocity and exact turn count have binomial count
  `Nat.choose n k` when the parity matches and zero otherwise;
- the unitary isotropic step is a one-parameter group, with
  `isotropicStep theta ^ n = isotropicStep (n * theta)`.
- exact product/remainder bridge
  `isotropicStep_pow_eq_one_add_scaled_generator_add_remainder`.
- refined spacetime endpoint-count scaffold
  `spacetimeEndpointTurnClassCount`, including zero theorems for impossible
  right/left totals, parity mismatch, and too many turns.
- boundary formulas, marginalization, `runCount`, and the full
  Earle/Jacobson-Schulman closed form
  `spacetimeEndpointTurnClassCount_eq`;
- closed-form marginal consistency
  `spacetimeEndpointTurnClassCount_closed_form_sum_eq_choose`;
- direct closed-form marginalization to the velocity endpoint count
  `spacetimeEndpointTurnClassCount_closed_form_sum_eq_velocity`;
- range-specialized closed form
  `spacetimeEndpointTurnClassCount_eq_of_right_le_length`.
- proof-library and example lemmas:
  `runCount_eq_zero_of_lt`, `runCount_one_part`, `runCount_self`,
  over-count vanishing lemmas, and direct examples through length `3`.
- entrywise finite propagator bridges:
  `checkerStep_pow_apply_isotropic_velocityEndpoint` and
  `checkerStep_pow_apply_isotropic_spacetimeEndpoint`.
- packaged binomial-product propagator formula:
  `spacetimeEndpointTurnClassClosedForm`,
  `spacetimeEndpointTurnClassCount_eq_closedForm`, and
  `checkerStep_pow_apply_isotropic_spacetimeClosedForm`.

- explicit entrywise L1 matrix norm `matrixL1Norm` (a local scalar function,
  not a global instance) with `matrixL1Norm_nonneg`, `matrixL1Norm_zero`,
  `matrixL1Norm_eq_zero_iff`, `matrixL1Norm_smul_real`, `matrixL1Norm_add_le`,
  `continuous_matrixL1Norm`, and `matrixL1Norm_tendsto_zero`;
- scalar normed small-angle estimate
  `isotropicStepFirstOrderRemainder_l1Norm_div_tendsto_zero` and the closed form
  `matrixL1Norm_isotropicStepFirstOrderRemainder`;
- exact product/remainder norm identities
  `isotropicStep_pow_sub_linear_l1Norm_eq` and
  `isotropicStep_pow_sub_linear_l1Norm_eq_explicit`;
- fixed-time subdivision guardrails
  `isotropicStep_equal_subdivision_exact`,
  `isotropicStep_equal_subdivision_sub_linear_l1Norm_eq`, and
  `isotropicStep_equal_subdivision_sub_linear_l1Norm_eq_explicit`, showing that
  subdivision at fixed accumulated angle is exact and does not make the
  first-order linearization error vanish;
- accumulated-angle asymptotic theorem
  `isotropicStep_pow_sub_linear_l1Norm_tendsto_zero_of_accumulated_tendsto_zero`
  (see `CHECKERBOARD_NORMED_PRODUCT_BOUND.md`).
- quantitative accumulated-angle product-error bound
  `isotropicStep_pow_sub_linear_l1Norm_le_accumulated_sq_add_cube`
  (`<= (n*theta)^2 + (1/3)*|n*theta|^3`), with helper
  `isotropicStepFirstOrderRemainder_l1Norm_le_sq_add_cube` and scalar Taylor
  lemmas `abs_cos_sub_one_le_half_sq`, `sin_ge_sub_cube_of_nonneg`, and
  `abs_sin_sub_le_sixth_cube`.
- local BigO upgrades
  `isotropicStepFirstOrderRemainder_l1Norm_isBigO_sq` and
  `isotropicStep_sub_linear_l1Norm_isBigO_sq`.
- local little-o/filter-transport upgrades
  `isotropicStepFirstOrderRemainder_l1Norm_isLittleO_id`,
  `isotropicStepFirstOrderRemainder_l1Norm_isLittleO_comp`,
  `isotropicStep_sub_linear_l1Norm_isLittleO_id`, and
  `isotropicStep_pow_sub_linear_l1Norm_isLittleO_accumulated`.

Next finite targets:

1. `checkerboard_accumulated_angle_error_bound` - DONE (2026-07-02) as
   `isotropicStep_pow_sub_linear_l1Norm_le_accumulated_sq_add_cube`.
   Claim type: asymptotic theorem / quantitative analytic scaffold.
   Proved from the exact product/remainder identity plus scalar Taylor bounds.
   The fixed-time guardrail remains: subdivision at fixed `T` does not make the
   first-order linearization error vanish.

1b. `checkerboard_accumulated_angle_bigO` - DONE (2026-07-02) via
   `isotropicStepFirstOrderRemainder_l1Norm_isBigO_sq`,
   `isotropicStep_sub_linear_l1Norm_isBigO_sq`,
   `isotropicStepFirstOrderRemainder_l1Norm_isLittleO_id`,
   `isotropicStepFirstOrderRemainder_l1Norm_isLittleO_comp`,
   `isotropicStep_sub_linear_l1Norm_isLittleO_id`, and
   `isotropicStep_pow_sub_linear_l1Norm_isLittleO_accumulated`.
   Claim type: asymptotic theorem.
   The statement is explicitly in the `x -> 0` accumulated-angle regime, never
   an `N -> infinity` statement at fixed `T`.

Next analytic target:

2. `checkerboard_dirac_limit_statement`
   Claim type: theorem statement / analytic scaffold.
   State the scaling assumptions under which the finite recurrence converges to
   the 1+1D Dirac equation. Do not prove this until the required analysis is
   explicitly available.
   DESIGN DONE (2026-07-02): topology-explicit scaffold added in
   `PhysicsSM.Draft.CheckerboardDiracScaling`
   (`CheckerboardDiracScalingData`, `momentumStepSymbol`, `momentumEvolution`,
   `diracHamiltonianSymbol`, `diracEvolutionSymbol`,
   `momentumEvolutionDiscrepancy`, `CheckerboardDiracRefinement`). The intended
   convergence claim remains a labeled comment
   `checkerboard_dirac_limit_statement`, not a proof placeholder.
   Codex follow-up added the derived refinement limits
   `CheckerboardDiracRefinement.timeStep_tendsto_zero`,
   `CheckerboardDiracRefinement.massAngle_tendsto_zero`, and
   `CheckerboardDiracRefinement.accumulatedAngle_tendsto`, plus
   `momentumEvolutionDiscrepancy_nonneg`. It also added the raw per-step
   expansion API `momentumStepSymbolRaw`, `momentumStepFirstOrderModel`,
   `momentumStepFirstOrderRemainder`, and
   `momentumStepFirstOrderDiscrepancy`.
   Compared object: momentum-space step-symbol power versus Dirac evolution
   symbol; first topology: `matrixL1Norm`, pointwise in momentum. See
   `CHECKERBOARD_DIRAC_LIMIT_STATEMENT.md`.
   Remaining analytic work before promotion to a theorem: assemble the
   already-proved per-step bridges into an accumulated Trotter bound, identify
   powers of `continuumStepSymbol` with the corresponding continuum
   exponential at time `N * eps`, and transport the bound through
   `eps -> 0`, `totalTime -> T`.
   Aristotle follow-up completed (a) pointwise as
   `momentumStepFirstOrderDiscrepancy_isBigO_sq` and added the reusable
   Trotter-style toolkit `matrixL1Norm_mul_le`, `matrixL1Norm_pow_le`,
   `pow_succ_sub`, and `matrixL1Norm_pow_sub_pow_le`.
   Codex follow-up added `matrixL1Norm_one` as a guardrail: the current
   entrywise L1 norm gives size `2` to the identity, so it is excellent for
   finite error measurement but should not be treated as the final stable
   long-product norm without an additional argument.
   Codex also added the one-step exponential bridge API
   `continuumStepSymbol`, `continuumStepBridgeRemainder`, and
   `continuumStepBridgeDiscrepancy`.
   Cycle-07 local work identified Mathlib's scoped `Matrix.Norms.Operator`
   L-infinity operator norm as the likely stability norm and added
   `linftyOpNorm_one`, `linftyOpNorm_mul_le`, and
   `linftyOpNorm_le_matrixL1Norm`, then converted the existing finite-step
   estimate to `linftyOpNorm_momentumStepFirstOrderRemainder_isBigO_sq`.
   Aristotle follow-ups completed the one-step continuum-exponential bridge in
   both entrywise L1 and scoped L-infinity forms:
   `continuumStepBridgeDiscrepancy_isBigO_sq`,
   `continuumStepBridgeDiscrepancy_tendsto_zero_div_sq_bound`,
   `linftyOpNorm_continuumStepBridgeRemainder_isBigO_sq`,
   `linftyOpNorm_pow_sub_pow_le`, `linftyOpNorm_exp_le`,
   `linftyOpNorm_continuumStepSymbol_le_exp`,
   `linftyOpNorm_nullShiftSymbol_le_one`,
   `linftyOpNorm_isotropicStep_le_abs_cos_add_abs_sin`,
   `linftyOpNorm_isotropicStep_le_one_add_abs`,
   `linftyOpNorm_momentumStepSymbolRaw_le_one_add_abs`, and
   `linftyOpNorm_momentumStep_sub_continuumStep_isBigO_sq`.
   The L2 operator-norm route is also active and kernel-checked:
   `momentumStepSymbolRaw_mem_unitaryGroup`,
   `momentumStepSymbol_mem_unitaryGroup`,
   `l2OpNorm_momentumStepSymbolRaw`, `l2OpNorm_momentumStepSymbol`,
   `momentumEvolution_mem_unitaryGroup`, and
   `l2OpNorm_momentumEvolution`.
   Codex follow-up proved the continuum-product identity
   `continuumStepSymbol_pow_eq_diracEvolutionSymbol`, plus the concrete finite
   stability wrappers `linftyOpNorm_momentumEvolution_sub_continuumPow_le` and
   `linftyOpNorm_momentumEvolution_sub_diracEvolution_le`.
   Highest-value remaining Lean target: choose eventual `M` and `delta`
   constants from these factor/per-step bounds and complete the accumulated
   pointwise Trotter bound under fixed-time refinement.

## B. Hyperdiamond No-Go

Status: central 3+1D obstruction.

Current modules:

```text
PhysicsSM.Draft.TetrahedralHighMomentumNullBranch
PhysicsSM.Draft.NullEdgeSpectralGraphNodalSet
PhysicsSM.Draft.NullEdgeActualCliffordSymbol
PhysicsSM.Draft.NullEdgeHyperdiamondNoGo
PhysicsSM.Draft.NullEdgeHyperdiamondBridge
```

Already checked:

- finite corner classification;
- nonzero high-momentum null branches;
- determinant-zero branch lines;
- bare branch kernels contain both spacetime chiralities;
- the bare full symbol cannot force one chirality sign per branch.
- branch-by-branch no-go: no candidate `gamma5` sign describes an entire bare
  branch kernel.
- explicit chirality projection is sufficient extra data to select one mode,
  but it is not yet a physical projected operator.
- exact frame/convention bridge between the Gate C tetrahedral dual frame and
  the complexified dual-soldered tetrahedral frame.
- covector-level bridge from the dual-soldered tetrahedral covector to Gate C
  `pCov`, plus the shared principal-symbol-square contract.
- represented-data Nielsen-Ninomiya ledger and `chiralProj` idempotence audit.
- first-order tetrahedral stencil API with `GateCPrincipalCrosswalk`; if such a
  crosswalk holds, the stencil inherits the Gate C square law and the
  bare-symbol chirality no-go.
- concrete `gateCStencil`, proving that the Gate C Clifford symbol can be
  repackaged as a first-order stencil with exact `GateCPrincipalCrosswalk` and
  inherited bare-symbol no-go.
- `BoriciCreutzConventionData`, `BoriciCreutzNearestPrincipalCrosswalk`, and
  `boriciCreutzNearest_no_single_chirality`.
- fifth-vector truncation scaffold:
  `BoriciCreutzConventionData.RequiresFifthVector`,
  `BoriciCreutzConventionData.fullFirstOrderSymbol`,
  `HyperdiamondFirstOrderStencil.linearSymbol_zero`, and
  `boriciCreutz_fullSymbol_ne_nearest_of_requiresFifthVector`.
- source-side pole/excitation predicates:
  `FullFirstOrderSymbol`, `IsExcitation`, `RealizedByFourEdgeStencil`,
  `GenuineFifthVectorDependence`, and `PoleStructureNeedsFifthVector`.
- source-independent no-four-edge theorems:
  `not_realizedByFourEdgeStencil_of_genuineFifthVectorDependence`,
  `not_realizedByFourEdgeStencil_of_poleStructureNeedsFifthVector`,
  `boriciCreutz_fullSymbol_genuineFifthVectorDependence`, and
  `hyperdiamond_no_four_edge_pole_structure`.

Next targets:

1. `hyperdiamond_operator_crosswalk_exact`
   Claim type: reconstruction / equivalence.
   Instantiate `BoriciCreutzConventionData` with a concrete hyperdiamond or
   Borici-Creutz convention, then prove `BoriciCreutzNearestPrincipalCrosswalk`
   or a source-specific mismatch theorem. `gateCStencil` is only the Gate C
   symbol repackaged as a stencil, not a named-operator equivalence.

2. `hyperdiamond_fullSymbol_excitation_finite_identity`
   Claim type: finite identity.
   Once a source convention fixes gamma basis, phases, normalization,
   fifth-vector matrix, shifted onsite term, pole locations, and chirality
   convention, exhibit an explicit nonzero kernel vector at a source pole and a
   contrasting non-pole point. This discharges
   `PoleStructureNeedsFifthVector data.fullSymbol` and upgrades the abstract
   no-go to a named-operator pole-structure no-go.

3. `chiralProj_physical_audit`
   Claim type: structural guardrail.
   If `chiralProj` is used as a model projector, audit locality, gauge
   covariance, Krein sign, and whether its branch data are derived from an
   operator rather than hand-filled.

4. `nielsenNinomiya_assumption_instance`
   Claim type: no-go theorem or audit theorem.
   Promote the represented-data ledger to a real theorem instance only after
   locality/finite range, operator Hermiticity or Krein self-adjointness, exact
   chiral symmetry, index/anomaly transport, and gauge-covariance hypotheses
   have Lean referents for a concrete operator.

## C. Frozen Gate C Release Ledger

Status: frozen schema until concrete operator data exist.

Do not add more satisfiable release clauses. The only valuable theorem work in
this layer is:

1. `releasePredicates_mutually_minimal`
   Claim type: audit theorem.
   Show each existing release predicate rules out an independent bad case.

2. `projectedData_derived_from_operator`
   Claim type: construction prerequisite.
   Replace free bookkeeping fields with values derived from an explicit
   projected operator.

3. `ghostZeroSafety_independent_of_index`
   Claim type: structural guardrail.
   Keep the necessary-but-not-sufficient separation between nonzero index and
   physical release.

## D. Physical Operator Gate

Status: future work only.

Do not build a `D_phys` release theorem until the proposed operator supplies:

- concrete local action;
- branch/nodal control;
- projected kernel dimensions;
- projected chirality signs;
- Krein sign audit;
- gauge-covariance statement;
- locality or finite-range statement;
- anomaly/index transport plan.

Until then, the honest 3+1D result remains the no-go for the bare symbol.
