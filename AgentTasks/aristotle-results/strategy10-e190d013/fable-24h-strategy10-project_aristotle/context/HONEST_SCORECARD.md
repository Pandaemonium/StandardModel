# Honest scorecard

Complete independently during the final 08:00-09:45 PDT audit. Each executor
signs, contests, or records a narrower grade.

| Claim/paper | Intended grade | Exact support | Witness/control | Overclaim audit | Codex | Fable | Final |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Paper A specialist flagship | near-ready |  |  |  |  |  |  |
| Paper B strict-QCA resource theorem | M/C |  |  |  |  |  |  |
| Paper C positional defect theorem | M/C |  |  |  |  |  |  |
| Paper D changing-lattice continuum | M/C |  |  |  |  |  |  |
| Paper E interacting CAR dynamics | M/C |  |  |  |  |  |  |
| Paper F negative classification | M/C |  |  |  |  |  |  |
| Paper F positive selector | C |  |  |  |  |  |  |
| Jordan flag stabilizer source/formalization | T/M target |  |  |  |  |  |  |
| Furey module as `exterior(V)` | M/C |  |  |  |  |  |  |
| Five-mode one-generation module | M/C |  |  |  |  |  |  |
| Representation-level `Z6` kernel | M/C |  |  |  |  |  |  |
| Local order parameter and field theory | C |  |  |  |  |  |  |
| Furey-Baez formalization paper | M/T|H |  |  |  |  |  |  |
| Reproducible artifact | M |  |  |  |  |  |  |

Required audit checklist:

- [ ] every abstract sentence has an exact anchor or visible interpretation;
- [ ] every cited Lean declaration was opened and inspected;
- [ ] every new flagship guard and build passed;
- [ ] trust-expanding proofs are listed explicitly;
- [ ] all external theorem claims were checked in primary sources;
- [ ] Jordan-flag external theorems are separated from local kernel results;
- [ ] both conjugate Furey ideals and charge conventions are audited;
- [ ] algebraic vacuum/degree language is not presented as QFT vacuum or
      constituent structure;
- [ ] strict QCA, Hamiltonian locality, circuit locality, and continuum limits
      are distinguished;
- [ ] fitted, imported, and held-out quantities are identified;
- [ ] user-owned release decisions are not fabricated.

---

## Mechanical claim-level layer (strategy4 Q3b design; pre-built 2026-07-11 by Fable)

Fill/verify at audit. Rules (violations fail the audit):

1. `kernel-clean` is INVALID unless the decl column is non-empty AND the
   footprint is standard (or `+eval` explicitly disclosed).
2. Every INDICATIVE claim sentence in a manuscript must map to a
   `kernel-clean` row; otherwise the sentence must be
   subjunctive/oracle-labeled (Trap 1: extract indicative claims from
   each .tex; cross-diff against this table).
3. `oracle-exact` / `PENDING-harvest` rows never appear as "done" in
   FINAL_REPORT.md.
4. At audit: `#print axioms` on EVERY kernel-clean decl (not only
   guarded flagships); repo-wide placeholder scan; statement-integrity
   diff vs freeze commit; guarded `#guard_msgs` blocks byte-unchanged
   (Trap 2).

Verifier runs (must agree): Run 1 `____` / Run 2 `____`.

### Paper A (FROZEN 07-11)

| ID | Claim | Decl(s) | Status |
|---|---|---|---|
| A-REST | rest-operator classification + verified chain | (open at audit from appendix list) | kernel-clean |
| A-PHASE | transported-phase 4x4 identity + zero locus + load-bearing control | PlueckerPhaseDefectSpectrum.* | kernel-clean |
| A-NOGO-STAT | degree-one stationary-amplitude no-go | StationaryAmplitudeNoGo.* | kernel-clean |
| A-ALIAS | all-coins even-parity alias theorem | FiniteWalkOnsiteEquivalenceObstruction.* | kernel-clean |
| A-GS | Gupta-Short non-involutory corollary | corollary of A-NOGO-STAT | kernel-clean; their eqs external |
| A-BENCH | high-momentum benchmark | Scripts/sim + manifest SHA-256 | sim/regression, NOT verified chain |
| A-RESTGEN | generalized rest operator B^3 = budget*B, rank-4 support, control | PlueckerRestOperatorGeneral.areaMatrix_cube/restOp_cube/restOp_support_projector/restOp_sq_two/controlZ_violates_cube | kernel-clean; LANDED 07-11, guard-pinned |

| A-SELECT | selection conjecture RESOLVED at block level; control suite complete (vanishing + equivariance + scalar collapse) | PairKickSelection.*; Selection2Repairs.scalar_gauge_collapse/equivariance_violating_control | kernel-clean; LANDED 07-11, guard-pinned; CAR-to-block reduction = definitional boundary |
| A-CHGBAL | 8-node charge census: +-1 charges, Floquet opposition, sum zero per gap | SplitStepChargeBalance.Jplus_det_charge; Jminus_det_charge; census_floquet_opposition; census_sum_zero | kernel-clean; LANDED 07-11, guard-pinned; Schur-reduction layer = run-record |

### Paper C (FROZEN 07-11)

| ID | Claim | Decl(s) | Status |
|---|---|---|---|
| C-POS | positional law | HalfPeriodInvariant.selfadj_iff_protected | kernel+eval (disclosed) |
| C-IFF | symbolic selfadj iff (sgn b0+sgn b2) sin th = 0 | ThetaFamilyCompletion.M13_selfadj_iff / M02_selfadj_iff | kernel-clean |
| C-ATLAS | all-theta atlas + persistent modes | ThetaFamilyCompletion.atlas_two_charts_family; ThetaFamilyProtection.modes_persist | kernel-clean |
| C-CGGSVWZ | translation-invariant index impossibility | CGGSVWZDictionary.no_periodic_index_reproduces_discriminator | kernel-clean (decide) |
| C-CENSUS | multiplicity census 2/4/0 singleton/block/control | CensusMultiplicity.census_rank_minus/_plus; census_multiplicity; census_blind_same_multiplicity | kernel+eval (disclosed); LANDED 07-11, guard-pinned |
| C-WIND2 | -+2 second-frame windings | none | oracle-exact, quarantined |

### Paper E (skeleton at freeze pace)

| ID | Claim | Decl(s) | Status |
|---|---|---|---|
| E-GEN | circle-group generator + corrected quarter-pulse | PlueckerPairGenerator.generator_hermitian/_cubed/group_law/halfpulse_*/naive_halfpulse_false | kernel-clean (in-file guards) |
| E-CONE | exact circuit cones / layer depth | PlueckerCausalCone.*; PlueckerLayerCone.* | kernel-clean |
| E-DISC | 4/5 vs 1 discriminator (fixture-scoped) | PlueckerPhaseObservable.* | kernel-clean |
| E-SPEC | 28x28 factorization + cubic (headline) | PairSpectrumFixture.* | PENDING-harvest 4d9642bf; prose oracle-tagged |
| E-MOM | momentum blocks (6,8,6,8) + annihilators + exact multiplicities + neutrality + symmetry breaking + charpoly product | PairMomentumBlocks (18 thms) | kernel+eval (two disclosed twin-layer native tokens); LANDED 07-11, guard-pinned; participation explicitly open |
| E-COMM | [H_free,K] != 0 four-mode witness | none | oracle-exact; ring witness inside E-MOM |
| E-HALF | window half-charge | none yet | HONEST-PENDING 102406b4: no indicative claim rides on it; non-landing costs nothing |

### FB paper

| ID | Claim | Decl(s) | Status |
|---|---|---|---|
| FB-SU3 | Aut_e111(O) ~= SU(3) | octonionMulAutFixingE111MulEquivSU3; su3Submonoid_eq_specialUnitaryGroup | kernel-clean (guarded); inverse transport disclosed |
| FB-DVT | two-sided action faithful + image iff | DVTTwoSidedActionKernelZ3Iff; DVTTwoSidedStabilizerMoonshot; DVTTwoSidedImageEquiv | kernel-clean (guarded); rename proposed to Codex |
| FB-GEN | one-generation package | fureyRealizesOneGenerationPackage | kernel-clean (guarded); RH singlets = conventional input |
| FB-BS | Baez-Schwahn three-part relation | kernel part = FB-SU3 + FB-DVT | external (source-verified) for BS content |
| FB-JC | bridge rungs | per gate matrix JC row | mixed; open rungs carry kill conditions |

### Program-track rows (3+1 memo; added 07-11 evening)

| ID | Claim | Decl(s) | Status |
|---|---|---|---|
| P-1D | two-band 1+1: zero-flow degeneracy + gapped fixture + forced pi-partner | TwoBandCrossingDoubling.unit_det_plus/minus_crossing_degenerate; U0c_gapped; U1c_double_crossing; U1c_zero_and_pi_sets | kernel-clean; LANDED 07-11, guard-pinned |
| P-ODDKICK | C4 dichotomy: FULL same-site odd no-go + two-parameter odd family + EXACT census with partner involution | GammaOddKickDichotomy.*; Selection2Repairs.no_odd_generator_on_full_samesite_block/G2_census_exact | kernel-clean; LANDED 07-11, guard-pinned; audit F9/F10 closed |
| P-1DFLOW | two-band flow-count hinge: jump law + periodicity => zero signed flow; no single crossing | TwoBandFlowCount.flowDiff_eq_zero_of_periodic_jumps; no_single_crossing; flowOne_hypotheses_nonvacuous | kernel-clean; LANDED 07-11, guard-pinned; analytic content in hypotheses (R2 design), R1 open |
| P-C3 | composed kick vectorizes protected sector (chi -4 -> 0); kick Gamma-even | none (oracle: c3_oracle2_out.txt) | oracle-exact; sharp negative, memo-recorded |
| P-CHG | Weyl-sector local charge design + 1D warm-up blueprint | (design memo 84f18f68; SU2LocalCrossingCharge is Codex's A1 fixture) | design + Codex kernel fixture |

### Codex-lane rows

(To be filled/co-signed by Codex at audit: B Laurent/flow, D convergence,
F Ward/graded-frame, JC modules.)
