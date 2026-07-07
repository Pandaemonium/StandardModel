# Thread board (two-day carrier run) - the work queue with done-conditions

Every thread: owner, done-condition (crisp - the loop banks a thread the moment it
holds), route, status. Update status lines in place (this file is the ONE run doc
that is edit-in-place rather than append-only; claim it in the ledger for scrubs).
Status vocabulary: OPEN / IN-FLIGHT (job ids) / LANDED (commit) / BANKED (guarded +
cross-reviewed) / STALLED (escalation step) / PARKED (reason).

## Critical path

### W1 - Move 1: the discrete Weitzenbock theorem [Claude]
- **Done:** `D^#D = Q_A + Q_C + Q_T + E` kernel-checked on a finite 2-complex,
  `E`'s vanishing hypotheses explicit, axiom-guarded in `CarrierAxiomGuard`,
  cross-reviewed.
- **Route:** bricks - (1) null-nilpotency + zero-edge-diagonal [IN-FLIGHT
  sm-weitzenbock-brick c6af1315]; (2) the 2-complex + gauge-covariant `nabla_e` +
  plaquette holonomy defect (the Wilson-line common-basepoint dressing as its own
  lemma); (3) the Krein `#` and the gamma-parity split of cross terms; (4) assembly.
- **Honesty rails:** no spectral claims (Krein positivity is OPEN); `E` is the
  gravity INTERFACE, not a gravity theorem.
- **Status:** bricks 1 + **2a LANDED + guarded** (`NullNilpotentSquare`,
  `SolderedSquareGram`: Q_A pinned exactly; Q_C=0 under commuting weights). Brick
  **2b IN-FLIGHT** (`weitzenbock_master`, the abstract Move-1 master identity
  `4•D0^2 = Q_A + Q_C` in one algebra B with hcl+hcomm; Aristotle 60894574; statement
  committed 425c9ad + verified route). Design **CRACKED by Fable call-01**. NEXT
  sub-bricks (post-2b): torus Q_C (Z2xZ2 gauge torus, path-difference form,
  double-shift T_aT_b); **corrected Q_T** (`Phi = Gamma·phi`, NOT gamma-even -
  call-01 caught the gamma-even cancellation is FALSE, kills commutator not
  anticommutator); `E` def + vanishing-at-constant-soldering; then the assembly
  `D^2 = Q_A+Q_C+Q_T+E`. Krein-square upgrade **BANKED + guarded + Codex-reviewed**
  in commit `5e0c5c8`: `carrier_krein_square` and
  `carrier_krein_square_selfAdjoint` prove the algebraic involution-square
  mass-form identity. The physical Krein reading remains pending a pinned
  `kreinSharp (J = rho Gamma)` restatement plus the M4 `kappa = 2` witness, and
  no single four-slot `D^#D = Q_A + Q_C + Q_T + E` theorem has landed yet.
  Positivity remains explicitly OPEN. Backfill: brick **2a'** (char-free,
  drop Field/h2 - call-01 audit). **Cite in W1 docstrings:**
  [BQJAG9TR] hep-th/9503153 (generalized Lichnerowicz) + arXiv:1301.3480 (gauge
  networks, brick-2 scaffold) + [2DEG7MT2] 0708.3707; in-graph, LIT_LOG rounds 1-2.

### W2a - Q_A and Q_T identification lemmas [Claude, day 2 gate]
- **Done:** kernel-checked `Q_A`-symbol-kernel = collinear locus tied to
  `nbody_aperture_massless_iff_collinear`; `Q_T = 0 iff massMatrix = 0` tied to
  `turnAmplitude_eq_zero_iff`; guarded; cross-reviewed. Statements Fable-RATIFIED
  before proof spend (call 02).
- **Status:** PARTIAL BANKED. Claude commit `49f8847` proved and guarded the
  abstract `Q_A` identification lemmas `Q_A_eq_totalSq` and
  `Q_A_zero_iff_totalSq_zero`; Codex reviewed the diff in commit `220451b`.
  Still OPEN for the W2a done-condition: the concrete Minkowski/collinearity
  tie and the `Q_T` identification layer.

### W2b - graded irreducibility (the upgraded no_common_carrier) [Claude]
- **Done:** the bigraded-slot theorem (order x Clifford-degree x gamma-parity;
  slots non-interconvertible), stated as the honest successor of
  `MassCommonCarrier.no_common_carrier_via_turn`; guarded; cross-reviewed.
- **Status:** OPEN (Fable RATIFY at call 06).

### W2c - relative exhaustiveness [Claude]
- **Done:** flat soldering + closed complex + vacuum Phi => exactly the three
  slots; stated at OPERATOR-TERM level (the [H1] rail: never particle-spectrum);
  each dropped hypothesis's extra term named in the docstring; guarded.
- **Status:** OPEN.

### CAPSTONE - the AND->+ upgrade [Claude, day 2]
- **Done:** `CarrierCapstone.lean` conjoining W1+W2a-c with the existing lane
  representatives, docstring scrupulous (identity of graded summands, NOT a
  spectral/physical-mass claim); guarded; Fable-audited (call 15); in
  FINAL_REPORT.
- **Status:** OPEN.

### OS1 - Move 3: strong-coupling SU(2) gap, explicit beta_0 [Codex]
- **Done:** kernel-checked exponential clustering / gap for SU(2) fixed-spacing
  strong coupling with EXPLICIT beta_0 (Osterwalder-Seiler mechanized), OR the
  honest furthest rung + documented handoff; all-beta explicitly OPEN in the
  docstring; guarded in `SlabAxiomGuard`; cross-reviewed.
- **Route:** decide at Fable call 01 - (a) character/polymer expansion standing on
  `charCoeff_abs_le_dim_mul_trivCoeff` + `StrongCouplingAreaLaw` + the Z2
  `SlabGapAssembly` template, vs (b) Shen-Zhu-Zhu functional-inequality route
  (2204.12737, explicit `|beta| < 1/(16(d-1))`). Codex prepares the comparison
  packet cycle 1.
- **Status:** OPEN; finite-gauge route started. Codex cycle 2 added the
  one-plaquette Z2 character/polymer prototype
  `onePlaquetteZ2_kpCondition_and_selfIncompatible_alpha_one_of_abs_tanh_le_exp_neg_one`:
  the corrected KP/self-incompatibility input pair at `alpha = 1` under the
  explicit coefficient threshold `|tanh beta| <= exp(-1)`. This is a finite
  rung only; volume-uniform KP convergence and SU(2) remain OPEN. Aristotle
  OS1 task `7a3c2d21` exceeded the 2-hour rule and was canceled; a concise
  handoff-only continuation in project `5e39556a` completed. Verdict: the
  one-plaquette theorem is non-vacuous and honestly scoped. Next useful rung is
  a multi-plaquette finite fixture using
  `plaquetteKPBound_of_singletonBound_positiveAreaBounds`; volume-uniform KP
  still needs an area-decay/rooted-cluster bound and remains OPEN. Codex landed
  the first conditional two-plaquette rung
  `twoPlaquetteZ2_kpCondition_and_selfIncompatible_positiveAreaSlice`: concrete
  two-site adjacency and degree bound `D = 2`, with the positive-area rooted
  sum bound and smallness hypothesis explicit. Codex then landed the
  zero-coupling two-plaquette sanity check
  `twoPlaquetteZ2_kpCondition_and_selfIncompatible_beta_zero`, which discharges
  those explicit area/smallness hypotheses only at `beta = 0`. Volume-uniform
  KP convergence and SU(2) remain OPEN. Aristotle grand-strategy review
  `cd8a094f`/`618b48c3` marks the zero-coupling ladder as saturated: no more
  `beta = 0` rungs unless explicitly requested for QA. Next OS1 proof spend
  should be either the volume-uniform KP fiber-injection route or a genuine
  small-`beta` interval rung, and the existing `beta_zero` fixture still needs
  Claude red-team review before stacking more OS1 integrations. Aristotle audit
  `2ed6afbb`/`424e815f` found no blocking issue; Codex removed the redundant
  `hBsum_nonneg` hypothesis from the two-plaquette positive-area wrapper by
  deriving it internally from `hArea`. Codex then landed the genuine
  small-coupling two-plaquette rung: exact finite enumeration computes
  `twoPlaquetteZ2_anchor_area_sum`, discharges the area-slice hypotheses with
  `twoPlaquetteZ2_plaquetteKPBound_positiveAreaSlice_of_smallness`, and proves
  the corrected KP/self-incompatibility pair at `alpha = 1` under
  `|tanh beta| <= (1 / 4) * exp (-1)`. This is still finite and
  volume-dependent; volume-uniform KP convergence and `SU(2)` remain OPEN.

### QC - the Q_C identification at leading order [Codex; THE Move-2 crux]
- **Done:** kernel-checked - the strong-coupling leading behavior of `<Q_C>` in
  the character expansion recovers the Z2 transfer gap `-log(tanh beta)`; scope
  EXPLICITLY leading-order-only; beyond-leading positivity flagged OPEN; guarded.
- **Status:** OPEN; finite-leading normalization bridge added by Codex cycle 5:
  `QCLeading.leadingClosureFluxCoeff` names the one-plaquette `Z2` leading
  closure-flux coefficient and `z2LeadingQCReadout` proves it is the same scalar
  as the TY partition ratio and OS contraction factor `exp(-gap) = tanh beta`.
  This is only a finite leading-coefficient read-off, not a carrier `Q_C`
  expectation theorem or beyond-leading positivity claim. Aristotle focused
  strategy job `86f7f9d4`/`4197d799` completed: add the scalar interval fact
  `leadingClosureFluxCoeff_mem_Ioo` and scalar monotonicity
  `leadingClosureFluxCoeff_strictMono`, both guarded. Next bridge should be a
  parameterized `QCCarrierBridge.LeadingQCCarrierContract`, queued for Fable
  call 03 ratification before heavier proof spend. Claude's Carrier-side torus
  flatness theorem landed in commit `4a779c0`; use it only after contract
  ratification. Codex landed the parameterized bridge contract in
  `QCCarrierBridge.lean`: an externally supplied observable/readout with a
  distinguished observable whose readout is exactly
  `QCLeading.leadingClosureFluxCoeff beta`, plus imported consequences
  `= tanh beta`, `= exp(-gap)`, and membership in `(0,1)`. This remains a
  leading scalar/readout contract, not a carrier expectation theorem, not
  beyond-leading positivity, and not a nonabelian result. Aristotle QC
  attachment strategy job `f4e21d1c`/`8068bd6e` ratified the next step as pure
  bookkeeping only; Codex landed `QCCarrierTorusAttachment.lean`, instantiating
  the bridge over the concrete Carrier torus gauge-configuration type and
  re-exporting `mZero_iff_commute` as the scalar-free curvature axis. Still
  OPEN: any curvature-to-scalar derivation, gauge measure, `Q_C` expectation,
  nonabelian result, or beyond-leading positivity theorem. Aristotle QC bridge
  audit `3b4e47a0` / `3428311b` found no blocking issue; Codex fixed the minor
  guard-coverage gap for the scalar exp-gap/tanh headline restatements.
  Aristotle grand-strategy review says to freeze further QC bookkeeping:
  current grade is PROVED-as-contract and OPEN-as-identification. Fable call
  03's upgraded exact Z2 two-torus theorem/error-term route is the next real
  QC direction, not another bridge wrapper. Codex landed the first exact
  finite-cycle version in `QCTwoStateCycleReadout.lean`: the two-step periodic
  Z2 transfer readout is exactly `tanh (2 * beta)`, equivalently the
  QC-leading coefficient at doubled coupling, and equals the OS contraction
  factor at doubled coupling. The leading-plus-correction split is now
  explicitly only definitional bookkeeping, while
  `twoStepPlaquetteReadout_eq_leading_plus_explicitCorrection` gives the
  non-bookkeeping closed-form finite-cycle correction
  `tanh beta * (1 - tanh beta ^ 2) / (1 + tanh beta ^ 2)`, directly guarded in
  `SlabAxiomGuard`. Scope remains finite transfer calculation only; no carrier
  expectation, measure theorem, nonabelian result, or infinite-volume limit is
  claimed. Aristotle audit `2ed6afbb`/`424e815f` found no blocking issue and
  Codex added a direct guard for the doubled-coupling identity.

## Supporting threads

### PH - product-Haar RP core [Codex]
- **Done:** `reflForm_self_nonneg` in `ProductHaarConfig.lean` placeholder-free
  (job sm-product-haar ac751ecb IN-FLIGHT); integrated + guarded.
- **Status:** BANKED by Codex cycle 1 + Claude c2 review: bare product-Haar
  `reflForm_self_nonneg` and `su_reflForm_self_nonneg` are placeholder-free,
  guarded in `QMF/AxiomGuard`, and cross-reviewed clean. Interacting
  Wilson-measure RP remains explicitly OPEN.
### CC - color commutant [Claude]
- **Done:** `color_commutant_eq_scalars` **LANDED + guarded** (commit d7a7d8d -
  `ColorCommutantScalar`; + `diagonal_mass_color_exact_iff`,
  `nonscalar_mass_not_color_exact`; red-teamed clean). STRETCH remains OPEN: the
  reducible internal-space commutant (multiplicity spaces = allowed Yukawa shape).
### AT - the A=T bridge [Claude]
- **Done:** kernel-checked `M^2 = |<12>|^2` on the two-edge sector, tied to
  `compositeMassSq_eq_sin_half` + `PluckerSpinorBridge`; docstring states the
  turn-amplitude reading with the spinor-helicity cite.
### KPON - Krein/Pontryagin physical-sector theorem [Codex strategy, shared]
- **Done:** a Fable/Aristotle-ratified finite-dimensional theorem statement
  proving (or sharply refuting) the invariant maximal nonnegative subspace route
  for `J`-self-adjoint carrier squares, plus a handoff deciding whether this is
  a standalone Mathlib-adjacent proof job or project-local Krein infrastructure.
- **Status:** STRATEGY COMPLETE / SHADOW LANDED. Aristotle job
  `ce99501a`/`3078e24d` returned the decisive audit: the weak invariant maximal
  nonnegative theorem is true in finite Pontryagin space, but the sector can be
  degenerate, so it is not a positive-definite physical Hilbert sector without
  extra definitizability/naturality hypotheses. Codex landed the cheap finite
  identity shadow in `NullEdgeSuperDiracKreinCore`:
  `kreinSharp_kreinSharp`, `kreinSharp_mul`,
  `isKreinSelfAdjoint_iff_kreinSharp_eq_self`, and
  `kreinSharp_mul_self_isKreinSelfAdjoint`. Latest Fable guidance keeps this as
  the top near-term positivity route, but the degenerate-sector rail remains
  binding. Next: Fable ratifies the exact positive-sector hypothesis before any
  headline theorem proof spend.

### M4-WIT - Pauli/Pontryagin concrete carrier witness [Codex handoff, Claude-owned integration]
- **Done:** a corrected M4(C) Pauli witness under the physical Krein sharp
  `J = Gamma`, with inertia `(2,2)` / `kappa = 2`, corrected gamma/metric signs,
  and simultaneous nonzero `Q_A`, `Q_C`, and `Q_T`; no Carrier-owned source
  touched by Codex.
- **Status:** HANDOFF BANKED. Aristotle project
  `578f32e6-efb8-4cab-abd8-325b02034685` / task
  `873b2c8c-4c49-4c77-a50d-ab2e2074e848` produced a standalone Mathlib-only
  skeleton plus report. Tracked handoff:
  `M4_PAULI_PONTRYAGIN_WITNESS_HANDOFF_2026-07-07.md`. Corrected model:
  `gamma = i * Pauli`, `g e e = -2`, real scalar `phi = c * I`,
  `J = diag(1,1,-1,-1)`, `Q_A = -8 * I`,
  `Q_C = +8 * (sigma_z tensor sigma_z)`, `Q_T = c^2 * I`.
  Claude review `2026-07-07-031041-m4-pontryagin-witness-review.md` found the
  algebra coherent but asked for an explicit rank/inertia certificate beyond
  trace zero; Codex added the Mathlib-only
  `M4_PauliPontryaginInertiaCertificate.lean` with
  `Jc_inertia_two_two`.
  Carrier-owned next move: a `kreinSharp J` restatement of
  `carrier_krein_square`, or a `M4Krein` star synonym, then instantiate this
  witness. The old `WITNESS_SATISFIABILITY.md` ordinary-star model is now
  explicitly marked superseded for the physical Krein reading.

### G-TP - teleparallel gravity slot [shared, Fable-gated]
- **Done:** exact Lean statement for discrete torsion
  `T(e,f) = nabla_e alpha_f - nabla_f alpha_e` and an `E`-slot Clifford
  contraction theorem, with TEGR/positive-energy provenance documented; proof
  job only after statement ratification.
- **Status:** OPEN; Fable guidance identifies the `E`-slot as discrete null
  teleparallelism, not a loose gravity analogy. Carrier code remains
  Claude-owned; Codex may help with strategy/context packs. Latest Fable
  guidance promotes the near target: define discrete torsion and prove the
  `E`-slot is its Clifford contraction, with TEGR/positive-energy provenance.
  Codex submitted Aristotle strategy project `7ad651e7` / task `5aa6d83b` to
  ratify the smallest honest Lean API before any proof spend. Aristotle
  sharpened the target: current `E` is the contraction of covariant
  soldering-difference `[nabla_e, gamma_f]`; antisymmetric torsion supplies only
  one half, with proposed split `2 * E = Contract(T) + Contract(S)`. Next
  Carrier-owned move: `DiscreteTorsion` bookkeeping module plus a small split
  proof job, while the geometric teleparallel naming stays Fable-gated.
### C-1FORM - finite one-form center-symmetry framing [Codex strategy]
- **Done:** an Aristotle/Fable-ratified Lean statement layer connecting the
  existing `CenterFluxSector` finite center-shift/electric-sector API and the
  `TYAreaLawSUN` twist system to honest finite one-form center-symmetry
  language, with explicit non-claims about confinement, continuum Ward
  identities, anomalies, spontaneous breaking, and cohomology.
- **Status:** FIRST PROOF TARGET BANKED. Corrected Aristotle report
  `f8cdf5c2`/`87f5a0e1` retracts the false missing-`TYAreaLaw.lean` staging
  artifact, confirms the charged-line API as the first target, and requires
  ordered `List.prod` (not `Finset.prod`) for nonabelian Wilson lines. Codex
  landed `CenterOneFormLine.lean` with `xLineHol`/`yLineHol`,
  charge/neutrality lemmas, and opposite-shift pair triviality; `AxiomGuard`
  pins the line-charge lemmas plus the center-shift action laws. Codex then
  landed the generic nonzero trivial-sector witness
  `ShiftSystem.one_inElectricSector_nonzero` and the x/y shift commutation law
  `xFluxShift_yFluxShift_comm`, both guarded. Codex then landed the minimal
  nontrivial-character witness `ShiftSystem.boolSign_nontrivialElectricSector`
  on a two-point flip system, guarded. Aristotle audit found no blocking issue
  and one guard gap; Codex added guards for
  `xLineHol_xFluxShift_pair` and `yLineHol_yFluxShift_pair`. Still OPEN: the
  full derived configuration-to-`TwistSystem` partition bridge and any honest
  `H^2(K,Z(G))` background object. First bridge contract landed:
  `CenterOneFormTwistBridge.lean` defines finite twisted partition sums and a
  `FiniteCenterTwistBridge.toTwistSystem` constructor with `Z_le` still an
  explicit hypothesis, not a derived RP theorem. Codex then added
  `twistedPartition_le_of_sector_subset` and
  `FiniteCenterTwistBridge.ofSectorSubset`, deriving `Z_le` only under the
  explicit finite-sector inclusion hypothesis `twistSector k x -> twistSector 0 x`.
  Aristotle audit `2ed6afbb`/`424e815f` found no blocking issue but flagged that
  this inclusion is low-distance for genuine disjoint partition sectors: for
  nonzero labels it forces the twisted sector empty. Codex downgraded the
  docstrings accordingly. The honest RP/measure derivation remains OPEN.
### PBW-EXH - exhaustiveness as a PBW/rewriting theorem [Claude-led, Fable-gated]
- **Done:** W2c/graded-exhaustiveness restated as a finite normal-form theorem:
  the free carrier algebra on `{gamma_e, nabla_e, phi}`, modulo the stated
  Clifford, transport, and chirality relations, has `D^#D` components only in
  the ranked slot bidegrees `(2,0)`, `(0,2)`, `(0,0)`, and `(1,1)`; every
  relaxed relation adds exactly the named extra normal-form family.
- **Status:** PARKED as the post-Move-1 framing for W2c. Do not spend proof
  effort before the concrete carrier glue/identification layer lands; use this
  as the statement-shape rail when W2c is drafted.
### MS-INDEX - McKean-Singer / spectral-action carrier frame [shared, parked]
- **Done:** a finite-dimensional McKean-Singer shadow for the carrier is stated
  honestly (`Str exp(-t D^#D)` constant in `t` and equal to an index under
  explicit grading hypotheses), with no continuum spectral-action conclusion
  claimed; used only as an ambient dictionary for later coefficient work.
- **Status:** PARKED behind the carrier capstone. Fable ranks it as high-level
  synthesis, not a day-1/day-2 proof lane unless a later call promotes it.
### SPIN-AP - spin as the next aperture invariant [shared, stretch]
- **Done:** a ratified finite linear-algebra statement for the two-null-edge
  aperture sector: single edge gives a helicity-style invariant, two-edge
  aperture carries the massive little-group `SU(2)`/Pauli-Lubanski shadow; the
  spin-statistics theorem remains explicitly out of scope.
- **Status:** PARKED stretch. This is the preferred next non-mass invariant after
  the carrier mass capstone, because it builds on the proved aperture mass
  theorem; no current proof spend until critical-path threads are banked.
### CHARGE-Q - finite charge quantization and center background [Codex, stretch]
- **Done:** finite charge quantization is isolated as a cohomology/integrality
  target on a finite 2-complex, connected to the one-form center-symmetry lane
  without claiming a continuum Ward identity, anomaly, spontaneous breaking, or
  derived gauge group.
- **Status:** PARKED behind C-1FORM's non-vacuous electric-sector witness. The
  near target is a precise `H^2(K, Z) -> H^2(K, U(1))`/plaquette-flux integrality
  statement, not a physical charge-spectrum theorem.
### DDV-CONT - interacting light-cone lattice control case [research, parked]
- **Done:** Destri-de Vega light-cone lattice is recorded as the interacting
  1+1d continuum-control case for null-line dynamics, to be used for literature
  grounding and future statement design.
- **Status:** PARKED research. Do not route Lean proof time here during the
  carrier run unless a Fable call explicitly promotes it.
### TY-LINEAGE - audit the 0808.3442 dependency [Codex, small]
- **Done:** a written verdict in the ledger + affected docstrings: does our TY
  route depend on disputed decimation results, or only on the rigorous 1985 RP
  inequalities? Fix docstrings accordingly.
- **Status:** BANKED by Codex cycle 3: Tomboulis-Yaffe 1985 ingested as
  [N7SIEMAC]; TY docstrings now state the route uses rigorous
  reflection-positivity / Cauchy-Schwarz inequality lineage plus Kanazawa
  [K9FIBTZC] for SU(N) notation/generalization, with no dependence on
  decimation-based all-coupling confinement claims.
### KP - the Penrose-scheme crux [Codex, backstop]
- **Done:** `pairSum_le_expBound` proved via the partition-scheme telescoping
  identity, OR the honest reduction to one named combinatorial lemma + handoff.
  Rails: do not re-prove `kp_convergence_bound_false`; thread `hself` everywhere.
- **Status:** OPEN / HANDOFF HARVESTED. Aristotle task `e1f4172d` exceeded the
  2-hour rule and was canceled. Handoff-only continuation
  `c8468d57`/`8cf60b9c` completed: `pairSum_le_expBound` appears true and not
  misstated, but the remaining blocker is the canonical-root
  classification/regrouping map for fibers. Reuse the already-proved in-file
  lemmas `perPair_absWeight_bound`, `fiber_value_bound`,
  `fiber_card_mul_le_factorial`, `absWeight_eq_root_mul_blocks`,
  `exists_canonical_root`, `treeRootChildren_poly_mem_nbhd`, and
  `rhs_forest_expand`. Focused Aristotle strategy job `53109f20`/`a363505b`
  sharpened the route: the next Lean target is the canonical-root
  child-forest well-formedness/`MapsTo` lemma, tentatively
  `classify_child_forest_wf`, proving child count/size bounds, neighborhood
  membership, touch witnesses, and the restricted-subgraph relation from the
  existing block lemmas. Codex landed the stronger reusable version
  `root_child_forest_wf` plus three local helper lemmas in
  `PolymerKPConclusion.lean`; the next exact blocker is the concrete
  fixed-forest fiber injection feeding `fiber_card_mul_le_factorial`. After
  that, `pairSum_le_expBound` reduces to fiberwise-sum bookkeeping. Codex
  submitted Aristotle project `6b8dcebd` / task `3a9be2e2` on that exact
  fixed-forest injection and locally banked the small cardinal/weight
  bookkeeping lemmas `restrictCluster_childBlock_n_eq`,
  `sum_restrictCluster_childBlock_n`, and
  `restrictCluster_childBlock_absWeight_eq`, reducing future assembly casts.
  Leave the documented intentionally false/refuted KP statements alone.
### NN-D - higher-d Nielsen-Ninomiya [either, stretch]
- **Done:** the discrete-Stokes degree theorem on `(ZMod N)^d` (facet-pairing
  telescoping), any d >= 2 beyond the landed 2D version; tie to overlap index if
  cheap.
### SPIN10-U5 - the flag-stabilizer rung [shared, stretch; Fable-gated]
- **Done:** Stab(pure-spinor line) = U(5) at the Lean level (or the honest
  finite-dimensional shadow); the full flag conjecture stays PARKED unless a
  Fable call promotes it.

### GB-QUOTIENT - the finite Gupta-Bleuler layer [Claude; TOP PRIORITY post-Q01]
- **Done:** Q01 ladder L1 (perp-signature), L2 (finite GB: isotropic Gamma' of
  dim kappa -> nonneg on perp, radical = Gamma', positive-definite quotient),
  L4 (descent under D-invariance), and the HEADLINE L5:
  `dim(V'/N) = dim M_+ - dim M_- = ind(D)` wired to CarrierIndexProtection.
  Then the 2+1 spatial-torus witness: first kernel-checked nonvacuous physical
  sector (one polarization per mode). Statements at working rigor in
  `AgentTasks/fable_parallel/Q01_answer.md` secs 1-2, 5; executor-verified.
- **Guards:** O2/O3 land as counterexample certificates alongside.
### DISPERSION - the dispersion polynomial and doubling ledger [Claude]
- **Done:** Q03-L1 `det sigma(k) = sum_{e<f} z_e z_f |psi_e wedge psi_f|^2`
  (one-line bilinear extension of Layer K); Q03-L3 two-edge doubler exhibit
  (lines of zeros, certifies F2); Q03-L4 cover lemma WITH the per-cell
  balanced-grading hypothesis pinned (executor flag); optional Q03-L2 emergent
  metric bound. Feeds charter U3/U4.
### QC-GRAM - the closure factorization check [proposal to Codex; QC lane]
- **Done:** decide `Q_C =? sum_p (1 - U_p)^# (1 - U_p)` in the repo
  normalization (Q01 S-C). If TRUE: exact unitary-regime closure positivity,
  superseding beyond-leading in that regime. If FALSE: the cross-term is the
  sharp statement of open problem #3. Either branch is a landing.
- **Status:** FIRST NORMALIZATION VERDICT LANDED (Codex). `QCClosureGramCheck.lean`
  proves the exact scalar unitary normalization:
  `(1 - u)^* (1 - u) = 2 - u - u^*`. Thus a raw linear closure defect
  `1 - U` is not itself the Gram square unless the `Q_C` slot uses the
  Hermitian Laplacian normalization. In the finite `Z2` specialization,
  `(1 - s)^2 = 2 * (1 - s)`, so the half-normalized Gram square equals the
  linear defect. Codex then added the operator/matrix version:
  `(1 - U)^* (1 - U) = 2I - U - U^*` for finite unitary matrices, plus the
  self-adjoint-involution corollary `(1 - U)^* (1 - U) = 2(1 - U)`.
  Guarded in `SlabAxiomGuard`. Still OPEN: the Carrier-side nonabelian/operator
  `Q_C` factorization in the concrete Weitzenbock normalization.
### E-TELESCOPE - corrected telescoping + P-probe [Claude; replaces the killed Tr E conjecture]
- **Done:** numeric P-probe script FIRST (ten lines); then Q02-L1 pointwise
  splitting (tr_0 E = Phi + divergence), Q02-L2 closed telescoping + kill
  certificate (torsion = 0, sum Phi > 0 on the probe), Q02-L3 disc/GHY flux
  form; polyhedral Gauss-Bonnet as the standalone classical cross-check.
  Lemma 0 (redecoration invariance of Tr f(D^#D)) as the one-liner opener.
### JR-SIGNS - real-structure candidate on the witness [Claude, cheap]
- **Done:** Q03-L8: J_R = edge-reversal compose antilinear conjugation; sign
  table (J_R^2, J_R c(alpha) J_R^{-1}, J_R Gamma) on the kappa=2 witness;
  either a Lorentzian-side sign table (quadrupling never afflicts us) or a
  publishable obstruction.

### STRAND-FOCK - the pentad fiber and the anomaly identity [Claude; post-Q04]
- **Done:** Q04-L1 the supertrace/anomaly identity
  `sum_k (-1)^k tr(Lambda^k g) = det(1 - g)` + the finite-difference corollary
  (anomaly rows of a generation are identities of rank >= 4 strand fibers) -
  elementary-symmetric-function machinery, likely the cheapest spectacular
  target in the queue; Q04-L2 pentad commutant C^6 + turn census (1 bare
  Majorana + 4 Yukawa channels) as finite linear algebra on 16 dimensions;
  Q04-L3 hypercharge rigidity + Z_6 congruence. Then Q04-L4: the convention
  isomorphism Lambda(C^3) = (C (x) O, fixed unit) through the XOR-Fano basis -
  our octonion kernel asset IS the color Fock space up to this bridge.
  Stretch: Q04-L0 R(G)-valued McKean-Singer upgrade; the order-condition
  check on the vacuum-Majorana turn (arbitrates Chamseddine-Connes-van
  Suijlekom vs Boyle-Farnsworth from outside NCG - standalone publishable).
- **Guard rails:** the C8 seam (internal top-form pairing vs the # slot;
  sesquilinear/bilinear bookkeeping) is the flagged risk; transcribe with
  care and kernel-check the coherence before any C8-dependent claim.

### TRIALITY-MONODROMY - three generations as an index [Claude; post-Q05]
- **Done, in order:** Q05-L0 the EQUIVARIANT McKean-Singer upgrade (per-isotypic
  rank symmetry + ind_chi; port the existing kernel proof sector-wise -
  demanded independently by Q04 AND Q05, load-bearing for both); Q05-L1 cover
  multiplicativity ind(C[Z/k] (x) block) = k ind(block); Q05-L2 TOY-A: the
  triangle complex with Z/3 holonomy over the kernel-checked (2,1) block -
  ind = 3, ker D_+ carries the regular Z/3 action (transitive family basis),
  connectivity iff ord(holonomy) = 3 (the anti-hand-tuning clause); Q05-L5
  no-four orbit lemma; the Distler-Garibaldi translation lemma
  (self-conjugate charge-module => per-sector ind = 0). Then the octonionic
  seed: Q05-L4a cyclicity Re((xy)z) = Re((yz)x) on the XOR-Fano basis
  (512 monomials, near-free); L4b tau on O^3 commutes with diagonal
  der(O)/su(3); L4c Springer-Veldkamp local triality (LOAD-BEARING; brute
  Fano transcription).
- **Registered kills to check early:** the chirality-solder audit (if Gamma is
  forced to couple to internal chirality, per-sector index degrades 3 -> 1);
  Krein audit (tau, deck, rho J-unitary, # restricts to sectors); the
  registered probe orders (ind rigid at all eps; commutant 3 -> 1 at generic
  eps; theta_23 - pi/4 = O(eps^2)).

### CHECKERBOARD-GW - the exact GW structure of retarded transfer [Claude; post-Q06]
- **Done:** GW-1 (involution conjugating transfer to inverse => GW with R=1/2,
  + Luscher deformed involution Ghat = G V with D Ghat = -G D exactly, +
  gamma5-Hermiticity analog) and the 8x8 GW-2 kill-check with the grading =
  chirality compose spatial reflection (= EDGE-ORIENTATION REVERSAL - the
  same operation as the OS theta-selector and the J_R ingredient: three
  threads, one operation). ARISTOTLE IN FLIGHT: 4043f341. Then R1 (the exact
  "retardedness IS the Wilson term" dispersion identity), R4 telescoping, R0
  path-sum = transfer power. Carrier-level conjecture (registered): G =
  Gamma compose edge-reversal inverts any retarded transfer on
  reversal-closed complexes; kill = nonabelian counterexample <= dim 8.
### EQUIPARTITION-GATE - the first physical number [Claude; post-Q07; GATE M-KOIDE]
- **Done:** F2 equipartition sum rule (tr M^2 = (2/V)(tr M)^2 under turn-power
  = hop-power; Q = 2/V; pointwise companion with Cauchy-Schwarz bound) +
  triangle instance. ARISTOTLE IN FLIGHT: 43a7f979. Then F5 T-SOLDER
  definition + degree formula (K_4 witness Q = 1/2), F4 Brannen form +
  massless-boundary lemma ("electron lightness = phase proximity"), F0/F1
  (Lagrange 2x2 + path-telescope: the hierarchy mechanism as one identity),
  F3 circulant cross-ratio (first number = 2 on the 4-cycle; golden ratio at
  N=5), F6 rigidity no-go. LOAD-BEARING NON-LEAN ITEM (K2): derive or refute
  kappa = 1 in T-SOLDER from carrier axioms (edge-subdivision naturality) -
  the mechanism becomes theorem or dies there. GATE M-KOIDE pre-registered
  per the memo (P1 retrodiction, K1-K4 kills, P2 oracle drift check).
- **K2 ATTACKED (2026-07-07, `TSOLDER_KAPPA_ANALYSIS.md`):** kappa = 1 <=>
  tetrahedral corner angle (cos = -1/3) under bookkeeping B2; numeric oracle
  green; dimension-discriminating dictionary registered (1+1 -> 1/3, 2+1 ->
  5/9, 3+1 tetrahedral -> 2/3 = observed). DECIDER = probe P1: the explicit
  carrier-to-leg reduction on the Z_3 tetrahedral cycle, corner convention
  pinned by the palindromic theorem in GWRetardedTransfer.lean. Next
  concrete action on this thread; kills pre-registered in the note.
### FOCK-GB - second quantization commutes with the quotient [Claude; post-Q08]
- **Done, in order:** L-Q8-1 finite Kugo-Ojima landed in
  `PhysicsSM/Draft/NullEdge/Carrier/KugoOjima.lean` from Aristotle
  38eeb1a6: for nilpotent Krein-self-adjoint `Q`,
  `range Q <= ker Q`, `ker Q inf orthoB(ker Q) = range Q`, and the quotient
  form is nondegenerate; L-Q8-2 `(ker A)^perp_J = range A#` is the workhorse
  theorem `orthoB_ker_eq_range`; `descent_unitary` covers the representative
  T-U1 preservation chain. CarrierAxiomGuard now pins `finite_kugo_ojima` and
  `descent_unitary`. L-Q8-3 is now landed in
  `PhysicsSM/Draft/NullEdge/Carrier/DGammaSquare.lean`:
  `dGamma_sq_identity` proves the finite decomposable exterior-algebra identity
  `dGamma(D)^2 = dGamma(D^2) + 2 dGammaTwo(D)`, with
  `double_sum_split` as the combinatorial core. The earlier
  `FockSecondQuantization.lean` two-mode diagonal theorem remains as a sanity
  check.
- **Next:** L-Q8-4 the L=4 two-particle checkerboard determinant identity in
  Q[m]; L-Q8-5 the FLAGSHIP rad(Lambda h) = ideal(N),
  Fock(V')/rad = Fock(V'/N) using the Aristotle `4929366f` strategy:
  first build `pairingDual` as a perfect pairing / linear equivalence, then the
  quotient factorization. Positivity of the physical quotient stays Q1/OPEN.
  Registered conjecture C-Q8-SS: positivity selects Lambda over Sym (finite
  Pauli); kill = a Sym-quantized checkerboard with positive invariant
  quotient. Positivity of the Kugo-Ojima quotient itself remains OPEN.
### RG-SCHUR - the thesis as an RG fact [Claude; post-Q06+Q08 convergence]
- **Done:** T-R1 Schur-complement decimation (det factorization; Berezin
  layer as needed) + RG-stability of {Krein-self-adjoint, Gamma-odd} + the
  INSTABILITY of per-edge null nilpotency ("mass terms are what null
  microstructure Schur-complements to") - converging with Q06-V4
  (coarse-graining generates Q_A by Layer K: sums of nulls are timelike
  unless collinear). Numeric-first probes (pre-registered): O1 uniform-
  majorant 3-level drift test; O2 tetrahedral point-group invariant-operator
  count at dim <= 4 (kill = excess over O(3) forces fine-tuning). New named
  gate UM (uniform majorant, the finite HSSC shadow) adopted.

### HORIZON-SCREEN-AREA - Q09 relational area theorem [Codex solo; new Q09 lane]
- **Done:** Q09-L1 kernel-ready area nucleus landed in
  `PhysicsSM/Draft/NullEdge/GateI1/ScreenArea.lean`: `screenAdj P =
  trace(P) I - P`, `screenArea P N = trace(screenAdj P * N)`, determinant
  polarization `screenArea P N = det(P + N) - det P - det N`, finite additivity
  over pierced momentum blocks, null-screen wedge formula, and nonnegative real
  part for `screenArea (finBundleMomentum psi) (rankOne chi)`.
- **Status:** PROVED finite kinematic identity only. This supports Q09's
  "area is relational like mass" statement. Entropy, BW-cut, Jacobson, ANEC,
  universal coefficient, and continuum/horizon interpretations remain MEMO or
  OPEN until their finite hypotheses are stated and checked.

### DIM-SIG-SELECTION - Q10 stable order and dimension reconstruction [Codex solo; new Q10 lane]
- **Done:** Q10-L1/L2/L4/L5 finite obstructions landed in
  `PhysicsSM/Draft/NullEdge/GateI1/SignatureSelection.lean`: the explicit
  Euclidean obstruction `euclideanQ_eq_zero_iff`; the `Z^(2,2)` null triple for
  the `(+,+,-,-)` form, pairings `(3, 4, -1)`, and
  `split22_frustrated_triple_no_coloring`; and the Q10-L4 seed
  `split22_orthogonal_null_pair` plus rational non-collinearity, the finite
  split-signature witness that null-orthogonality rigidity fails. Q10-L5 has
  the explicit real-split rank-one witness: two determinant-zero constituents
  whose sum has determinant `-1`, now strengthened by
  `PhysicsSM/Draft/NullEdge/GateI1/SplitSignatureMass.lean`:
  `det_outerSum` proves the full split determinant/wedge identity for arbitrary
  finite rank-one sums. The headline theorems are guard pinned with footprint
  `[propext, Classical.choice, Quot.sound]`.
- **Status:** PROVED finite obstruction only. It supports Q10's stable-order
  signature rail, not the full Lorentzian uniqueness theorem yet. The next
  exact rungs are L3 Lorentzian positive-pairing transitivity and L6
  same-chirality scalar-amplitude census.
- **Aristotle:** active named lanes opened for Q10-L3 (`dbe113e5`), Q10-L5
  (`3a66e413`), and Q10-L6 (`7fd8a9bf`); see
  `ARISTOTLE_LANE_DOCKET_2026-07-07.md`.
- **Claim boundary:** never phrase this as "retardation on one finite complex
  implies Lorentzian" or "3+1 follows from consistency alone." Q10's boundary is
  signature from stable order; dimension from chirality plus scalar-amplitude
  reconstruction.

### G2-PARITY-CHIRALITY-SOLDER - Q12 algebra core and operator gates [Codex solo; new Q12 lane]
- **Done:** Aristotle audit `0a6239d5` completed. Codex integrated the
  kernel-checkable algebra core as
  `PhysicsSM/Draft/NullEdge/GateI1/G2Parity.lean`: for
  `Idx = Fin 3 -> ZMod 2`, every diagonal XOR/Fano character `phi c` is
  multiplicative for arbitrary structure constants `sigma`, the linear maps
  form the diagonal `(Z/2)^3` character group (`phiL_zero`,
  `phiL_selfInverse`, `phiL_comp`), and strand parity `c = ![1,1,1]` has
  balanced `4+4` eigenspaces (`parity_fixed_card`, `parity_odd_card`).
- **Status:** PROVED algebraic T1-T4 only. This confirms the G2-parity defusal
  at the XOR/Fano algebra level and removes sign-convention risk from the
  automorphism claim.
- **Next:** T5/T6/T7 require explicit triality intertwiners and their
  G2-equivariance; T8 requires the convention bridge
  `(-1)^F_c = B phi B^{-1}` between the ladder/Furey basis and XOR/Fano basis;
  T9/E4 requires constraint equivariance `tau Gamma' = Gamma'` before any
  per-sector physical quotient count. Failure of T8 is a C8-seam escalation, not
  a patch.
- **Claim boundary:** do not claim `[P,tau]=0` downstairs, per-sector index
  preservation, anomaly cancellation, or a physical chirality result from this
  theorem alone.

### JR-REAL-STRUCTURE - Q11 fiber real structure, KO, and unimodularity seam [new Q11 lane]
- **Status:** Q11 answer harvested into the goal prompt and Aristotle queue. It
  says the explicit top-form-duality `J_R` on `Lambda(C^5)` is the seam object:
  `J_R^2 = +1`, internal `B` is positive, fiber KO signs are `(+, +, -)`,
  total Lorentzian architecture lands in KO dimension 4, and unimodularity is
  forced by the named antilinear covariance axiom RC0, not by Krein closure.
- **Next:** kernelize the finite ladder: sign tables, parity anticommutation,
  `B(e_S,e_T)=delta_ST`, charge-conjugation master identity
  `J_R Q J_R^{-1} = trace(Q) 1 - Q`, RC0 iff determinant one, B-L counterexample,
  C3 Majorana identity, and the order-condition scalar identities.
- **Aristotle:** named audit/strategy lane `65a9d42d`
  (`ne-q11-jr-real-structure-ko-unimodularity-audit-20260707`) is running.
- **Claim boundary:** do not say unimodularity follows from Krein/sesquilinear
  closure. RC0 is an axiom unless/until separately derived.

## Standing meta-threads

- **AUDIT-POOL:** every landed flagship enters; Aristotle audit fired EVENT-DRIVEN
  after every 2-4 integrated proofs, 2-3 audit jobs in flight (playbook sec 3).
  Codex closed Aristotle grand-strategy caveat F1 locally at 01:57 by running
  `lake env lean` on all four guard surfaces: Carrier, Slab, QMF, and GateYM.
  2026-07-07 Codex loaded nine new named StandardModel projects
  (`ne-q10-l3-lorentzian-transitivity-20260707`, `ne-q10-l5-split-tachyon-witness-20260707`,
  `ne-q10-l6-scalar-amplitude-census-20260707`, `ne-q12-g2-parity-chirality-solder-audit-20260707`,
  `ne-q12-psa-equivariant-ms-audit-20260707`, `ne-q08-fock-exterior-quotient-strategy-20260707`,
  `ne-q08-dgamma-square-identity-20260707`, `ne-q09-entropy-horizon-audit-20260707`,
  `ne-q06-carrier-gw-generalization-audit-20260707`) so Aristotle has about
  twelve active StandardModel-relevant lanes including the existing
  Koide/perp/KP jobs. Q11 then added
  `ne-q11-jr-real-structure-ko-unimodularity-audit-20260707` as a thirteenth
  active StandardModel lane. Mapping and deliverables live in
  `ARISTOTLE_LANE_DOCKET_2026-07-07.md`.
- **SCORECARD:** consolidations at ~T+12/T+24/T+36/T+45 fold BANKED threads into
  `HONEST_SCORECARD.md` (the overnight-run copy remains the program dashboard).
- **FINAL_REPORT:** Claude drafts at T+48, Codex contributes C-lane sections;
  graded claims only; includes the lit-graph delta and the Fable-call decisions
  log.
