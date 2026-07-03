# Overnight NERD run 2026-07-02/03: morning report

**Status: DRAFT (Claude side final ~03:55; Codex I1/D/review extension updated 03:14).**
Claude-lane results below are complete and verified. Codex's later I1/D
additions are confirmed from the shared ledger/discussion and targeted checks,
but remain uncommitted staging/draft work pending morning port/review. The whole
report still needs final cross-review before 07:30 per the RUN_PLAN. Report
faithfully: negatives and exploratory probes are recorded as such.

## 1. Executive summary

- **Gate C1 SYMBOL-LEVEL CHIRAL RELEASE COMPLETE** (draft-trust) - the flagship
  payoff. Beyond the free-operator half (coercive gap, self-adjointness, symbol
  Hermiticity, no zero modes), the actual overlap / Ginsparg-Wilson chiral
  release now lands at the symbol level: `H(k)^2 = coeff(k).I` (Clifford scalar
  square) makes the sign ELEMENTARY (`eps = coeff^{-1/2} H`, an explicit
  self-adjoint involution - no functional calculus), giving the GW relation
  `gamma5 Dov + Dov gamma5 = Dov gamma5 Dov` and idempotent Weyl projectors.
  `TetraSymbolOverlapGW.lean`, all kernel-checked, clean axioms. This is the
  whole point of Gate C1. **Adversarially validated**: an Aristotle red-team
  (feae0495) confirmed the release is FAITHFUL - the elementary sign genuinely
  equals the spectral `H(H^2)^{-1/2}`, "scalar square makes the sign elementary"
  is a real shortcut not sleight of hand - with honesty caveats folded into the
  docstring. And now **lifted to the FULL OPERATOR LEVEL**: the two-sided Fourier
  isomorphism (`TetraFourierInverse.lean`), `sign(Hfree)` proved a self-adjoint
  involution (`signHfree_involutive` + `signHfree_selfAdjoint`), and the
  real-space overlap Dirac operator `DovOp = 1 + Gamma5.signHfree` satisfying the
  **operator-level Ginsparg-Wilson relation** (`TetraOperatorOverlapGW.lean`,
  `operator_ginsparg_wilson`: `Gamma5 Dov + Dov Gamma5 = Dov Gamma5 Dov` as
  real-space operators, via the Fourier-transport pattern), plus real-space Weyl
  projectors (`TetraOperatorWeylProjectors.lean`) with `P+ + P- = 1`,
  `P+ - P- = signHfree`, idempotency, and the `+1` eigenspace theorem. This is
  the complete free (no-gauge) chiral fermion release on the tetrahedral
  regulator, kernel-checked at both the per-momentum symbol level and the
  real-space operator level.
- **Full `lake build` green** (8295 jobs) including the operator-level chain
  (`TetraFourierInverse` + `TetraOperatorOverlapGW`); confirmed post-integration
  at 2026-07-03. Codex's later staging additions have targeted checks; any
  additions after this build should be re-confirmed with a full build.
- **Gate I1/P2 staging stack** kernel-checked through I1.1-I1.9, I2 finite
  faithfulness iff strict future-timelikeness, finite A1 boost algebra, A2
  determinant/reverse-Cauchy/square-root mass superadditivity, I3.5
  determinant-line clock algebra, and a conditional finite `U(2)` spin-clock
  split algebra.
- **Gate D finite stack** kernel-checked through D1 product-marginal
  subadditivity, D2 finite first-law/Gibbs/fixed-modular-energy stationarity,
  D3.0 finite no-proper-shrink skeleton, and D6 classical checkerboard
  Bernoulli turn weights with fixed mean turn count.
- **Gate L0.1** no-go argument corrected via an Aristotle red-team (Palm
  marginalization + proximality + first-moment dichotomy) - the original sketch
  was refuted and repaired.
- **Gate Q2** numerics (FOUR validated results): massless c=1 CFT calibration,
  massive area-law saturation, the **D3.1 modular defect** (modular Hamiltonian
  commutes with the parabolic BW boost, defect ~1/L^2 - the "time is modular" /
  F-M2 datum), and the **lattice first law** dS = d<K> (ratio -> 1, the
  numerical bridge to the kernel-checked Gate D2 identity `finite_first_law`).
- Aristotle used as a genuine partner: 3 Claude strategy/red-team jobs (L0
  correction; C1 gap red-team; C1 GW-release validation) that materially
  improved and hardened the results.
- ~30 verified commits (Claude), all prefixed `overnight-20260702:`, green tree.

## 2. Theorems landed (Claude, kernel-checked, axioms = propext/Classical.choice/Quot.sound)

| Theorem | File | Meaning | Commit |
|---|---|---|---|
| `tetraFreeOperator_gap_equalN` | `PhysicsSM/Draft/NullEdge/GateC1/TetraFreeOperatorGapEqualN.lean` | coercive inverse-propagator gap `Hfree^*Hfree >= gamma` | 6acb549 / 92c6aa2 |
| `Hfree_ker_trivial` | same file | no zero modes (`Hfree Psi=0 -> Psi=0`) | f6404cf |
| `H_symbol_hermitian` | `.../TetraSymbolHermitian.lean` | momentum-symbol Hermiticity from gamma5-Herm + `{gamma5,Q}=0` | 52de79d |
| `Hfree_selfAdjoint`, `fourierUnitary_inner_siteN` | `.../TetraFreeOperatorSelfAdjoint.lean` | real-space self-adjointness + sesquilinear Parseval | 93929ab |
| `H_symbol_sq`, `signSymbol_sq/_star`, `symbol_ginsparg_wilson`, Weyl projectors | `.../TetraSymbolOverlapGW.lean` | **symbol-level chiral release**: Clifford scalar square -> elementary sign involution -> GW relation -> Weyl projectors | 191d3f8 / 6dd97ae |
| `fourierUnitaryInv_fourierUnitary`, `fourierUnitary_fourierUnitaryInv`, `fourierChar_row_orthogonality` | `.../TetraFourierInverse.lean` | two-sided finite Fourier isomorphism (both round-trips) - the operator-level GW infra | 4db38f8 / af0e6ef |
| `signHfree_involutive`, `signHfree_selfAdjoint`, `fourierUnitary_DovOp`, `operator_ginsparg_wilson` | `.../TetraOperatorOverlapGW.lean` | **operator-level chiral release**: `sign(Hfree)` a self-adjoint involution -> real-space overlap `DovOp` -> operator GW `Gamma5 Dov + Dov Gamma5 = Dov Gamma5 Dov` | c9902ac / 5b31126 |
| `weylProjOp_add`, `weylProjOp_sub_eq_signHfree`, `weylProjOpPlus/Minus_idem`, `signHfree_weylProjOpPlus` | `.../TetraOperatorWeylProjectors.lean` | **operator Weyl projectors** (capstone of the free release): spectral resolution `P+/P- = (1 +/- signHfree)/2`; `P+ + P- = 1`, `P+ - P- = signHfree`, idempotents, and `signHfree(P+ Psi) = P+ Psi` (`+1` chirality eigenspace = chiral fermions at the operator level) | ac48b87 |
| `finite_first_law`, `relEntropy_nonneg` | `PhysicsSM/Draft/NullEdge/GateD/FiniteFirstLaw.lean` | exact first-law identity + Gibbs (q>0) | 8c86467 |

Verification for each Claude row: `lake build <module>` + `#print axioms`
(clean); the full-tree `lake build` (8295 jobs) passed after Claude's integrated
batch.

## 2b. Theorems landed (Codex, targeted kernel checks)

All Codex rows are draft/staging. Axiom audits reported
`[propext, Classical.choice, Quot.sound]` unless noted.

| Cluster | File | Main names | Verification |
|---|---|---|---|
| I1.1-I1.6 kinematic core | `AgentTasks/aristotle-standalone/gate-i1-kinematic-core-20260702/GateI1KinematicCore/Core.lean` | `i1_1_soldering_det`, `i1_2_minkHerm_posSemidef_iff_futureCone`, `i1_2_minkHerm_eigenvalues_nonneg_iff_futureCone`, `i1_3_rank_one_rank_dichotomy`, `i1_4_rank_one_factorization`, `i1_5_cauchy_binet_mass_identity`, `i1_6_kinematic_cross_check` | `lake env lean ...\Core.lean` |
| I1.8-I1.9 + I3.5 | same | `det_normalizedMinkHerm_sub_smul_one`, `normalizedMinkHerm_spectralPlus_det_zero`, `normalizedMinkHerm_spectralMinus_det_zero`, `normalizedMinkHerm_posSemidef_of_futureCone`, `normalizedMinkHerm_faithful_of_futureTimelike`, `det_normalizedMinkHerm`, `trace_normalizedMinkHerm_sq`, `linearEntropy_normalizedMinkHerm`, `i1_9_minkHerm_mul_bar_eq_minkowskiSq`, `i1_9_bar_mul_minkHerm_eq_minkowskiSq`, `i3_5_clock_projector_invariant`, `i3_5_clock_det` | same |
| I2 finite faithfulness shadow | same | `faithful2_det_ne_zero`, `i2_rankOne_not_faithful`, `i2_null_not_faithful`, `i2_minkHerm_faithful_of_futureTimelike`, `i2_minkHerm_faithful_iff_futureTimelike` | same |
| A1 finite boost algebra | same | `a1_spatialPauli_sq`, `a1_boost_minkHerm_form`, `a1_boost_minkowskiSq`, `a1_boost_eigenvalue_ratio`, `a1_boost_faithful` | same |
| A2 determinant spine | same | `spatialDot_sq_le`, `minkowskiSq_add`, `a2_det_minkHerm_add`, `minkowskiInner_nonneg_of_futureCone`, `minkowskiInner_sq_ge_mul_minkowskiSq_of_futureCone`, `sqrt_minkowskiSq_mul_le_minkowskiInner_of_futureCone`, `a2_minkowskiSq_add_ge_of_futureCone`, `a2_sqrt_minkowskiSq_add_ge_of_futureCone` | same |
| U(2) spin-clock split algebra | same | `phase_smul_specialUnitary2_det`, `phase_smul_specialUnitary2_unitary`, `u2_phase_su_decomposition`, `spinClock_kernel_square_one`, `spinClock_kernel_suPart`, `complex_sq_eq_one_iff` | same |
| D1 finite product-marginal subadditivity | `PhysicsSM/Draft/NullEdge/GateD/FiniteBernoulliMaxEntropy.lean` | `crossEntropy_productOfMarginals`, `d1_joint_entropy_subadditivity` | `lake build PhysicsSM.Draft.NullEdge.GateD.FiniteBernoulliMaxEntropy` |
| D2 fixed modular-energy stationarity | `PhysicsSM/Draft/NullEdge/GateD/FiniteFirstLaw.lean` | `entropy_gap_eq_relEntropy_of_fixed_crossEntropy`, `d2_shannon_le_of_fixed_crossEntropy` | `lake build PhysicsSM.Draft.NullEdge.GateD.FiniteFirstLaw` |
| D3.0 finite no-proper-shrink skeleton | `PhysicsSM/Draft/NullEdge/GateD/FiniteHalfSidedInclusion.lean` | `permImage_eq_of_subset`, `permImage_pow_eq_of_halfSided`, `subspaceImage_eq_of_le`, `subspaceImage_pow_eq_of_halfSided` | `lake build PhysicsSM.Draft.NullEdge.GateD.FiniteHalfSidedInclusion` |
| D6 classical checkerboard turns | `PhysicsSM/Draft/NullEdge/GateD/FiniteCheckerboardTurns.lean` | `bernoulliTurnWeight_nonneg`, `bernoulliTurnWeight_sum`, `bernoulliTurnWeight_marginal_turn`, `bernoulliTurnWeight_turnCountReal_mean`, `d6_classical_growth_is_bernoulli`, `classicalCheckerboardGrowthWeight_sum`, `classicalCheckerboardGrowthWeight_turnCountReal_mean` | `lake build PhysicsSM.Draft.NullEdge.GateD.FiniteCheckerboardTurns` |

## 3. Aristotle registry (final)

Submitted tonight (both COMPLETE + harvested, summaries in gitignored
`AgentTasks/aristotle-output/<id>/REPORT_SUMMARY.md`):
- `495df59e` overnight-l0-nogo-audit - corrected the L0.1 argument.
- `ffed1801` overnight-c1-gap-redteam - validated the gap milestone, gave the
  self-adjointness recipe (rungs 5a/5b, both now discharged).
- `6434c938` (Codex) gate-i1-psd-eigenvalue-char - I1.2, merged.
- `feae0495` overnight-c1-gw-redteam - adversarially VALIDATED the symbol-level
  chiral release as faithful (Claude, 3rd strategy job).
Pre-run checkerboard backlog (8 projects) dry-run-inspected by Codex/T0; the
older gate-c1-* backlog was found already integrated (harvest-first win: zero
duplicate submissions). Total new Aristotle proof jobs submitted: 1 (Codex I1.2)
+ 2 Claude strategy jobs - deliberately few and sharp per the postmortem.

## 4. Integration debt

None outstanding on the Claude side: every theorem is committed, verified, and
the full tree built after that batch. Codex's I1/P2 work lives in the standalone
staging file (kernel-checked) and is not yet ported into the main `PhysicsSM`
tree. Codex's new Gate D draft files are targeted-build green but uncommitted.
That port/commit + semantic cross-review is the main open integration item for
the morning.
Checkerboard T1b harvest (8 IDLE projects) remains un-integrated (dry-run clean;
deferred, not on the critical path).

## 5. Decisions + review outcomes

- `review:c1-gap-equalN` ACCEPTED (Codex); wording refined to "coercive
  inverse-propagator gap".
- `review:c1-selfadjoint` ACCEPTED (Codex); docstring precision fix applied.
- `review:c1-symbol-gw` ACCEPTED (Codex); scalar-square shortcut judged
  semantically honest at symbol/per-momentum scope.
- `review:c1-operator-gw` ACCEPTED (Codex); Fourier transport judged
  semantically honest for `signHfree_selfAdjoint` and
  `operator_ginsparg_wilson` as real-space operator identities.
- Operator Weyl projectors ACCEPTED (Codex quick review); add/sub/idempotent and
  `+1` eigenspace laws judged semantically aligned with the free/no-gauge
  operator-level release.
- `review:gate-d-firstlaw` ACCEPTED (Codex); D1 handed to Codex.
- Harvest division agreed (Claude gate-c1-*, Codex checkerboard).
- No disagreements parked for the user.

## 6. Build + hygiene

- Full `lake build`: 8295 jobs, "Build completed successfully" after Claude's
  integrated batch. Not rerun after Codex's later uncommitted I2/A1/A2/U2/D6/D2
  stationarity staging additions and I2 iff tightening.
- Codex targeted checks run: `lake env lean ...\Core.lean`, `lake build
  PhysicsSM.Draft.NullEdge.GateD.FiniteFirstLaw`, `lake build
  PhysicsSM.Draft.NullEdge.GateD.FiniteBernoulliMaxEntropy`, `lake build
  PhysicsSM.Draft.NullEdge.GateD.FiniteHalfSidedInclusion`, `lake build
  PhysicsSM.Draft.NullEdge.GateD.FiniteCheckerboardTurns`; diff/trailing
  whitespace scans clean. `pre-commit run --files` still needed before commit.
- Axiom audits: all trusted-track theorems `[propext, Classical.choice,
  Quot.sound]`; no `s o r r y`, no `n a t i v e _ d e c i d e` in any committed
  Lean this run.
- All results are DRAFT-trust (draft modules), per the no-trusted-promotion
  guardrail. Promotion to trusted is a morning-review decision.

## 7. Ideas raised, out of scope tonight

- C1 next layer: symbol-level and operator-level free GW release are both
  kernel-checked and reviewed, and the operator Weyl projector capstone is
  reviewed. Remaining out-of-scope-next work is Gate C2 scoping for gauge-link
  backgrounds, admissible-sign/GW transport, finite index facade, and anomaly
  bridge.
- D3.1 modular defect: DONE and validated (commit 511ed49). The discrete QNEC
  deficit (null-cut 2nd difference of entropy) remains the next Q2 rung.
- L0 Lean sub-lemmas (CP^1 no-finite-invariant-subset, 3-point stabilizer,
  boost north-south) - need Mobius/homogeneous-space Lean infrastructure.
- L0-paper literature ingest (Palm calculus, Zimmer amenability, proximal
  dynamics, Douady-Earle) - logged in `LIT_LOG.md`, not ingested.

## 8. Recommended next three actions

1. Port/commit Codex's I1/P2 and Gate D staging cluster into the main
   `PhysicsSM` tree, then run pre-commit, targeted builds, full `lake build`,
   and semantic cross-review.
2. Scope Gate C2 with an explicit strategy/red-team packet before gauge
   construction: gauge-link covariance and admissible-sign interface first,
   finite index density/anomaly bridge after that facade is pinned.
3. Decide draft->trusted promotions for the reviewed C1 and Gate D theorems
   after the morning semantic pass.

## 9. Literature log summary

No dedicated lit cycle spent (C1 was the critical path; the Lean work was
assembly/derivation needing no new sources). The L0.1 audit surfaced
load-bearing math literature (Palm calculus, Zimmer amenability of PSL(2,C) on
CP^1, proximal north-south dynamics, Douady-Earle barycenter, BHS
gr-qc/0605006) - logged in `LIT_LOG.md` for the L0-paper ingest pass. Standing
Q2/C1/GateD backlog lit-checks remain open.
