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
  `kreinSharp_mul_self_isKreinSelfAdjoint`. Q13 red-team `7f273e71`
  reinforces this boundary: flat-sector mass-form positivity is Hilbert
  positivity on the positive-chirality half, not an indefinite/Pontryagin
  positivity theorem, and the balanced `(2,2)` witness cannot certify a nonzero
  physical sector. Aristotle Q01 job `ec1ad7d5` has now landed the finite
  unbalanced seed in
  `PhysicsSM/Draft/NullEdge/Carrier/KreinPositiveSectorWitness.lean`: the same
  nilpotent Kugo-Ojima charge gives a nonvacuous positive quotient for inertia
  `(2,1)` and a same-charge negative no-go for inertia `(1,2)`. Still OPEN:
  wiring the model's closure/Gauss operators and Ward invariance to a carrier
  theorem `dim(physical sector) = ind(D)`.

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
- **Done:** L-Q8-1 finite Kugo-Ojima nondegeneracy remains guard-pinned in
  `PhysicsSM/Draft/NullEdge/Carrier/KugoOjima.lean`. Aristotle Q01 job
  `ec1ad7d5` is now harvested into
  `PhysicsSM/Draft/NullEdge/Carrier/KreinPositiveSectorWitness.lean` and
  guard-pinned in `CarrierAxiomGuard`: `nonvacuous_positive_sector` proves an
  explicit `(2,1)` finite positive quotient witness, while
  `nondegenerate_but_indefinite_no_go` proves a same-charge `(1,2)` model where
  Kugo-Ojima nondegeneracy holds but positivity fails.
- **Claim boundary:** this closes the finite witness/no-go separation, not the
  full physical-sector theorem.  The Q01 ladder's carrier-level headline
  `dim(V'/N) = dim M_+ - dim M_- = ind(D)` still needs the actual
  closure/Gauss constraint span, `D`-invariance/Ward condition, and
  constraint-completeness hypotheses wired to a decorated carrier model. The
  balanced `(2,2)` M4/Pontryagin witness remains a flat mass-form witness and
  is vacuous as a physical state-sector certificate.
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
- **Done / scoped:** Q04-L1 has the finite exterior-supertrace backbone
  (`PSA.superTrace_eq_det_one_sub`) and the later charge-resolution
  bookkeeping; Q04/Q11 now also has the C3 Majorana turn census.  The
  Spin(10) / `Lambda(C^5)` bridge in the repo is genuine finite algebra, but it
  is not the `Lambda(C^3)` color-octonion bridge.
- **Audit boundary:** Aristotle audit `dbe3850c` found a HIGH false-shape risk:
  the proved octonion/Fock bridge is `Lambda(C^5)` / Spin(10), not the
  8-dimensional `Lambda(C^3) ~ (C (x) O, fixed unit)` color bridge.  Q04-L4 is
  OPEN, not landed.  `ConventionBridge` correctness is comment-only; Furey
  ladder signs remain oracle/M-grade until a kernel theorem replaces the
  comment.  `Q12Triality.octSgn` and `Basic.lookupSign` disagree on 18/64
  ordered pairs and need a diagonal sign-gauge lemma before transfer.
- **Next:** L4a sign-gauge reconciliation between `octSgn` and
  `Basic.lookupSign`; L4b `ConventionBridge` line/product preservation over the
  project XOR-Fano table; L4c the actual operator-valued
  `Lambda(C^3) ~ (C (x) O, fixed unit)` color bridge using left-multiplication
  operators, not raw octonion products.  Stretch: Q04-L0 `R(G)`-valued
  McKean-Singer upgrade and the order-condition check on the vacuum-Majorana
  turn.
- **Guard rails:** the C8 seam (internal top-form pairing vs the # slot;
  sesquilinear/bilinear bookkeeping), fixed-imaginary-unit choice, and
  nonassociativity are the flagged risks; transcribe with care and
  kernel-check coherence before any C8- or Furey-dependent claim.

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
  threads, one operation). Q06 carrier-level audit `5f3b8963` has now landed
  the compiler-trust-free positive group theorems in
  `PhysicsSM/Draft/NullEdge/Carrier/GWConjecture.lean`:
  `conj_prod_forward` says conjugation preserves word order,
  `palindrome_conj_inv` proves the midpoint/palindromic convention gives
  `G T G = T^{-1}` without commutativity, and `abelian_conj_inv` proves the
  abelian escape for arbitrary ordering. Codex then added the explicit
  compiler-trust-free witness `nonabelian_oneSided_counterexample`, a `2 x 2`
  rational matrix counterexample to the one-sided nonabelian ordering.
  Aristotle project `ed700b2a` has now landed
  `PhysicsSM/Draft/NullEdge/Carrier/GWWilsonSymbol.lean`: the exact `2 x 2`
  transfer-symbol determinant, unitarity, trace/Hermitian-part identity,
  Wilson scalar identity, scalar nonnegativity/zone-edge value, and
  edge-reversal GW-symbol conjugation.  `CarrierAxiomGuard` pins
  `transferSymbol_det`, `wilson_term`, and `gw_symbol`.
  Aristotle follow-up `a1534a69` has now landed
  `PhysicsSM/Draft/NullEdge/Carrier/GWEdgeReversalBridge.lean`: B1
  `holonomy_reverseEdges` proves decorated-edge reversal gives the genuine
  holonomy inverse; B3 `conj_inv_iff` isolates the exact word-order gap; B4
  `conj_pow_inv` proves the nonabelian homogeneous transfer-power case; and B5
  `gw_relation_transfer_power` feeds that bridge into the one-step GW theorem.
  `CarrierAxiomGuard` pins all four bridge theorems.
- **Status:** RESOLVED boundary. The literal carrier conjecture "any retarded
  transfer is inverted" is false in the nonabelian one-sided case. The live Lean
  theorem now proves both the palindromic/abelian positive cases and the
  explicit one-sided nonabelian kill witness, plus the homogeneous
  transfer-power bridge. Q13 red-team `7f273e71` sharpened the wording: exact
  GW is a symmetric/midpoint-palindromic or transfer-power convention theorem,
  not a theorem that arbitrary one-sided retardation by itself supplies
  `G T G = T^{-1}`.
  The Wilson-symbol landing is exact finite momentum algebra for the displayed
  retarded/palindromic symbol, not a general carrier-dynamics derivation.  The
  redundant follow-up job `7a12dbbd` was canceled after the local landing.
- **Next:** R4 telescoping and the full path-sum-to-transfer-power layer.  Any
  follow-up Q06 Aristotle job should target multi-edge path-sum assembly, not
  resubmit the landed symbol identity or homogeneous transfer-power bridge.
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
  `dGamma(D)^2 = dGamma(D^2) + 2 dGammaTwo(Lambda^2 D)`, where
  `dGammaTwo` means the pair kernel applying `D` in both selected slots, with
  `double_sum_split` as the combinatorial core. The earlier
  `FockSecondQuantization.lean` two-mode diagonal theorem remains as a sanity
  check. Aristotle follow-up `97417bb8` is now harvested into the same module:
  `dGammaOp` is a genuine derivation on all of `ExteriorAlgebra R V`, and
  `dGamma_sq_identity_operator` proves that the operator square on a
  decomposable state agrees with the tuple identity above. Codex then added
  the particle-number sanity check `dGammaOp_id_wedge`: the second
  quantization of the identity acts by scalar `k` on a decomposable
  `k`-particle wedge, plus `dGammaTwo_id_pair_count`: the identity two-body
  combinatorial term is the scalar count of strict pair slots. These Q08
  theorems are guard-pinned in
  `CarrierAxiomGuard`.
- **Done:** L-Q8-4 has now landed in
  `PhysicsSM/Draft/NullEdge/Carrier/CheckerboardTwoParticle.lean` from
  Aristotle project `6b63230e`.  `kParticle_amplitude_eq_det` proves the
  general determinant formula for exterior-power amplitudes,
  `T_sq_word_expansion` gives the four length-2 checkerboard words,
  `checkerboard_twoParticle_amplitude_eq_det` specializes the determinant to the
  concrete L=4 transfer matrix, and `checkerboard_amplitude_ratQ` reads the
  headline instance in Q[m].  The crossing cancellation in this minimal example
  is honestly vacuous: the two output supports are disjoint
  (`col_supports_disjoint`, `checkerboard_no_crossing`).
- **Done:** L-Q8-4+ nonvacuous same-parity crossing has now landed in
  `PhysicsSM/Draft/NullEdge/Carrier/CheckerboardCrossingNonvacuous.lean` from
  Aristotle project `26fa682c`.  It proves `twoParticle_amplitude_eq_det_general`
  for arbitrary inputs, the same-parity support-overlap witness
  `output_a1_in_both_supports`, both direct and crossing families nonzero
  (`crossing_family_nonzero`), the explicit amplitude
  `twoAmpGen_nonvacuous : X^3 - X`, and the negative result
  `naive_LGV_reduction_false`.  This kills the naive T-P3 claim on the
  pre-registered checkerboard transfer model: the crossing term survives
  because the crossing happens at a mid-edge light-cone point, not a shared
  lattice vertex for the standard LGV involution.
- **Done:** L-Q8-5 degree-by-degree quotient bridge has now landed in
  `PhysicsSM/Draft/NullEdge/Carrier/FockQuotientPairing.lean` from Aristotle
  project `5bdce729`.  `pairingDual_bijective` proves the finite
  exterior-power perfect-pairing bridge, `exteriorForm_nondegenerate` propagates
  nondegeneracy to exterior powers, `fockQuotientEquiv` and
  `fockQuotient_isometry` give the fixed-particle-number quotient/isometry, and
  `exteriorForm_radical_eq` proves
  `ker(exteriorForm n h) = ker(Λ^n mkQ_N)` for a symmetric form and its radical
  quotient.  These Q08 quotient theorems are guard-pinned in
  `CarrierAxiomGuard`.
- **Next:** the literal graded `rad(Lambda h) = ideal(N)` statement still needs
  the kernel-span theorem for decomposables with an `N` factor plus assembly
  across all particle numbers.  Q01 has now landed a finite positive
  Kugo-Ojima witness/no-go, but positivity for the actual exterior physical
  quotient remains open until the model-specific constraint and Ward hypotheses
  are supplied.
  T-P3 is now re-scoped: a true nonvacuous LGV theorem needs a corrected
  scattering-vertex / brick-wall DAG where crossing is represented as shared
  vertex data plus a swap involution, or a certified LGV-compatible
  source/sink hypothesis.  It is not a corollary of T-P2 on the unmodified site
  lattice.  Registered conjecture C-Q8-SS: positivity selects Lambda over Sym
  (finite Pauli); kill = a Sym-quantized checkerboard with positive invariant
  quotient. A global two-body exterior operator and model-level positivity of
  the Kugo-Ojima quotient remain OPEN. Aristotle audit `e4f1cedb` found no
  high/medium semantic issue in the globalization landing; its only code-facing
  fix was the doc clarification that `dGammaTwo` encodes the `Lambda^2 D` pair
  kernel, not an abstract one-slot `D`.
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
  part for `screenArea (finBundleMomentum psi) (rankOne chi)`. Aristotle audit
  `2ed38421` also landed the finite modular no-go in
  `PhysicsSM/Draft/NullEdge/GateI1/ModularNoGo.lean`:
  `borchers_positive_generator_vanishes` proves a positive semidefinite finite
  generator satisfying the differentiated Borchers commutation relation must
  vanish. Aristotle follow-up `f1fecdb9` landed
  `PhysicsSM/Draft/NullEdge/GateI1/TorusBWCutLocality.lean`: `bwResidual` /
  `BWCutExact`, `locDefect` / `MatrixLocal`, `locDefect_smul`,
  `matrixLocal_smul_iff`, `bwCut_localTransfer`, and
  `bwCutLocalityPass_iff` give finite pass/kill scoring algebra for the torus
  BW-cut locality test. Aristotle audit `d32e8150` has now been harvested as a
  report-only claim-grade audit: `ModularNoGo` and `TorusBWCutLocality` were
  reproduced in the lightweight pack; `ScreenArea` was not reproducible in that
  pack because `Core` was omitted, so its grade rests on the local full-repo
  build, which Codex reran successfully during integration.
- **Status:** PROVED finite kinematic identity only, with audit boundaries now
  explicit.  Aristotle follow-up `7de21ba8` completed the finite A9.1 nucleus:
  `screenArea_finBundleMomentum_rankOne_eq_zero_iff` proves the degeneracy iff,
  `spinorWedge_mulVec` proves wedge covariance, and
  `screenArea_finBundleMomentum_rankOne_sl2c_invariant` proves simultaneous
  determinant-one invariance.  The finite Reeh-Schlieder well-posedness gate
  remains OPEN.  The BW-cut scoring algebra is PROVED, but no concrete L7 torus
  witness has been fed into the rubric, so the test has not run.  A9.4 does not
  forbid the BW-cut test because the cut boost generator is indefinite, while
  A9.4 kills positive semidefinite null-translation generators. Entropy,
  Jacobson, ANEC, universal coefficient, and continuum/horizon interpretations
  remain MEMO or OPEN until their finite hypotheses are stated and checked; a
  cross-complex universal `1/4` coefficient is already false-shape by the
  species problem.
- **Next:** land the finite Reeh-Schlieder well-posedness gate, then run the
  doubler volume-law scan and a
  concrete L7 BW-cut locality witness before any entropy headline.  L4
  Klein/Schmidt bookkeeping is a good finite theorem target, but only becomes
  physically load-bearing after L7 has a witness.

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
  finite rank-one sums. Q10-L6 has a finite substitute in
  `MassAmplitudeCensus.lean`: `eps2_SL2_invariant` gives the positive
  rank-two corner, `weyl_not_symmetric_d6/10` give the weight-parity
  obstructions, and `charpoly_negSymmetric_of_invariant_form` is the bridge
  from invariant bilinear form to negation-symmetric characteristic polynomial.
  Q10-L3 has now landed in
  `PhysicsSM/Draft/NullEdge/GateI1/LorentzianTransitivity.lean`:
  `lorentzian_pos_pairing_trans` proves positive null-pairing transitivity in
  signature `(1,m)`, and `lorentzian_pos_pairing_rigidity` proves the zero
  boundary is exactly projective collinearity. The headline theorems are guard
  pinned with footprint `[propext, Classical.choice, Quot.sound]`. Aristotle
  follow-up `825853b9` was harvested into
  `PhysicsSM/Draft/NullEdge/GateI1/MultiTimeEmbedding.lean`:
  `sigDot_coord4` embeds the split `(2,2)` witness into any diagonal signature
  with four distinct `+,+,-,-` coordinates, `multitime_frustrated_triple`
  produces a null triple with pairings `(+,+,-)`, and
  `multitime_no_retarded_coloring` proves no retarded/advanced two-coloring can
  satisfy those three constraints.  Aristotle follow-up `9d61e305` is now
  harvested into
  `PhysicsSM/Draft/NullEdge/GateI1/SylvesterInertiaBridge.lean`:
  `bilin_frustrated_triple` gives a basis-free symmetric-bilinear-form version
  from an orthogonal `(+,+,-,-)` block,
  `quadraticForm_frustrated_of_equivalent` transports the obstruction across a
  Sylvester equivalence, and `sigDot_frustrated_triple` recovers the diagonal
  witness.
- **Status:** PROVED finite Lorentzian half plus finite general multi-time
  obstruction stack. This now closes the finite stable-order signature rail at
  the diagonal-signature and Sylvester-equivalent levels: Lorentzian `(1,m)` has
  positive-pairing transitivity, while a form carrying a `(+,+,-,-)` orthogonal
  block has a frustrated triple. The remaining algebraic cleanup is the fully
  intrinsic numerical-index theorem phrased directly as `p >= 2` and `q >= 2`.
  Any dimension-selection claim still needs separate chirality and
  scalar-amplitude reconstruction. L6 still
  needs the full Spin/Weyl representation stack before it can be stated as a
  representation-theoretic
  `Hom_Spin(S tensor S, 1)` classification.
- **Aristotle:** harvested named lanes Q10-L3 (`dbe113e5`), Q10-L5
  (`3a66e413`), Q10-L6 (`7fd8a9bf`), Q10 multi-time embedding
  (`825853b9`), and Q10 Sylvester-inertia bridge (`9d61e305`); see
  `ARISTOTLE_LANE_DOCKET_2026-07-07.md`.
- **Claim boundary:** never phrase this as "retardation on one finite complex
  implies Lorentzian" or "3+1 follows from consistency alone." The new theorem
  assumes either a diagonalized sign-vector model or the explicit Sylvester
  equivalence/orthogonal-block hypotheses. Q10's boundary is signature from
  stable order; dimension from chirality plus scalar-amplitude reconstruction.

### G2-PARITY-CHIRALITY-SOLDER - Q12 algebra core and operator gates [Codex solo; new Q12 lane]
- **Done:** Aristotle audit `0a6239d5` completed. Codex integrated the
  kernel-checkable algebra core as
  `PhysicsSM/Draft/NullEdge/GateI1/G2Parity.lean`: for
  `Idx = Fin 3 -> ZMod 2`, every diagonal XOR/Fano character `phi c` is
  multiplicative for arbitrary structure constants `sigma`, the linear maps
  form the diagonal `(Z/2)^3` character group (`phiL_zero`,
  `phiL_selfInverse`, `phiL_comp`), and strand parity `c = ![1,1,1]` has
  balanced `4+4` eigenspaces (`parity_fixed_card`, `parity_odd_card`). PSA-1
  also landed in `PhysicsSM/Draft/NullEdge/GateI1/PSA.lean`:
  `superTrace_eq_det_one_sub` proves the finite exterior-supertrace identity
  `superTrace g = det(1 - g)`, and `det_one_sub_permMatrix_eq_zero` proves the
  permutation-matrix order-`m` vanishing. Codex then added the finite
  charge/sector bookkeeping theorem `sum_sectorContribution_eq_total`: summing
  label-resolved sector contributions recovers the total finite contribution.
  Aristotle follow-up `c2e23b53` was harvested into
  `PhysicsSM/Draft/NullEdge/GateI1/ChargeResolution.lean`, which proves the
  stronger finite charge-resolution package: `superTrace_eq_sum_sector`,
  `superTrace_eq_zero_of_sectors`, `sector_failure_not_hidden`,
  `sdim_eq_sum_chargeIndex`, `chargeIndex_failure_not_hidden`, and
  `superTrace_blockDiagonal'`. Aristotle follow-up `85a73a6d` was harvested
  into `PhysicsSM/Draft/NullEdge/GateI1/Q12Triality.lean`, proving the finite
  T5-T8 operator gates: `octSgn_alternative`, `octSgn_nonassoc`,
  `parity_triple`, `trialityTriple_conj`, `parity_commutes_tau`,
  `bridge_via_perm`, `bridge_trace_necessary`, and
  `bridge_kill_of_unbalanced`. Aristotle follow-up `11184eac` was harvested
  into `PhysicsSM/Draft/NullEdge/GateI1/Q12GammaPrimeQuotient.lean`, proving
  the finite physical-quotient descent interface: `physDescend`,
  `physDescend_comp`, `physDescend_cube_eq_id`,
  `physDescend_commutes_iff`, `map_eq_of_invariant_of_injective`,
  `E4_commutator_can_fail`, and `E4_healing`.
- **Status:** PROVED algebraic T1-T8 finite core plus finite PSA-1 and
  sector-additivity accounting identities only.
  This confirms the G2-parity defusal at the XOR/Fano algebra level and removes
  sign-convention risk from the automorphism claim; PSA-1 gives the per-sector
  determinant/supertrace check; ChargeResolution gives finite
  partition-by-label and direct-sum bookkeeping; Q12Triality gives finite
  diagonal-character/parity commutation and abstract bridge/kill criteria;
  Q12GammaPrimeQuotient gives the finite quotient-descent gate. Q13 red-team
  `7f273e71` downgraded the word "triality" here: the landed
  `parity_triple` is the all-equal diagonal `(Z/2)^3` character case, generic
  in `sigma`, not a genuine order-3 Spin(8)/octonion triality theorem. These
  results do not prove an analytic/equivariant index theorem behind a physical
  anomaly statement. Aristotle C8 audit `cdba6caa` confirmed the finite algebra
  is kernel-clean, but raised the same load-bearing gates: the Q11 fiber
  grading and Q12 strand parity live on different spaces with no proved
  non-permutation bridge; `eps'` for KO placement is not formalized; PSA and
  ChargeResolution are accounting identities, not equivariant
  McKean-Singer.
- **Next:** T8 still needs the *specific repo* ladder/Furey bridge matrix `B`
  checked entry-wise against the actual ladder ordering/signs; the landed
  theorem only proves the benign permutation case and trace/signature kill
  condition. Aristotle audit `1bd78359` sharpened the boundary: an existential
  bridge is vacuous because the relevant gradings have the same `4+4`
  spectrum; the real Furey ladder bridge is a concrete complex change of basis,
  not a permutation. The next certificate must pin the ordering/cochain, prove
  convention equivalence, define the concrete `Bfur`, check unitary/non-
  permutation status, discharge the 64 entrywise intertwining equations, and
  promote the result to a G2/XOR-character statement. T9/E4 now has a proved
  finite interface: an operator descends only when it preserves both `V'` and
  `N`, and descended `tau` commutes with descended `Gamma` iff
  `[tau, Gamma] V' <= N`; upstairs noncommutation can heal on the quotient.
  The remaining PSA gap is now the analytic or operator-level equivariant
  McKean-Singer theorem plus model-specific verification of the descent
  hypotheses, not finite additivity. Failure of the specific-`B` bridge is a
  C8-seam escalation, not a patch.  The C8 audit's explicit gates are:
  involution descent for `Gamma`, equivariant McKean-Singer, `J_R`-induced
  sector conjugation `omega <-> omega_bar`, the concrete non-permutation Furey
  bridge plus 64 repo-`sigma` identities, PSA-2/PSA-3 determinant-line phases,
  and the missing `eps'` operator relation.
- **Claim boundary:** do not claim `[P,tau]=0` downstairs, per-sector index
  preservation, anomaly cancellation, or a physical chirality result from this
  theorem alone.

### JR-REAL-STRUCTURE - Q11 fiber real structure, KO, and unimodularity seam [new Q11 lane]
- **Done:** Q11 L1/L2-core landed in
  `PhysicsSM/Draft/NullEdge/GateI1/Q11RealStructure.lean`: the top-form-duality
  sign `sigmaSign` is defined from the genuine wedge/interleaving parity and
  proved equal to the closed formula; `JR_involutive` proves `J_R^2 = +1`;
  `JR_parity_anticomm` proves the odd-fiber parity anticommutation;
  `Btop_eq_Bstd` proves the internal top-form-duality form is the standard
  positive Hermitian metric; `JR_num_particle_hole` and `JR_charge_master` prove
  the finite Cartan arithmetic `J_R Q J_R = trace(Q) 1 - Q`; and
  `even_dim_breaks_JR_sq` gives the dimension-four contrast witness. Aristotle
  follow-up `e2df3555` was harvested into
  `PhysicsSM/Draft/NullEdge/GateI1/Q11BLDictionary.lean`, proving the finite
  B-L dictionary `B-L = 1 + (4 / 5)Y - (2 / 5)F`, the six-entry SM table,
  Cartan `RC0_iff_traceless`, hypercharge/number/B-L trace facts, and
  `freed_direction`: `Y + c F` is RC0-admissible iff `c = 0`.
- **Status:** PROVED finite fiber sign table, Cartan/unimodularity arithmetic,
  and B-L/total-number dictionary only. The result refutes any "Krein closure
  implies unimodularity" slogan: the sesquilinear form is determinant-blind,
  while determinant/traceless information lives in the antilinear `J_R` layer.
- **Next:** group-level RC0 should now focus on the Jacobi complementary-minor
  lemma, Cauchy-Binet/functoriality cleanup, and removing the draft
  compiler-eval step from the returned `Q11GroupAction` scaffold.  The
  order-condition scalar identities have a finite sector-level landing; the
  chirality-solder flag remains a standing obligation for later architecture
  checks.
- **Aristotle:** harvested named audit/strategy lane `65a9d42d`
  (`ne-q11-jr-real-structure-ko-unimodularity-audit-20260707`) and follow-up
  finite-check lane `e2df3555`
  (`ne-q11-bl-dictionary-finite-check-20260707`).  Project `e3f3ae61`
  (`ne-q11-c3-majorana-turn-census-proof-20260707`) has now landed
  `PhysicsSM/Draft/NullEdge/GateI1/Q11C3Majorana.lean`: `JR_turn_invariant`,
  `turn_pairing`, `deltaBL_turn`, `invariant_sector_iff`, `census_card_two`,
  and the RC0 first/second-order scalar identities.  Project `f962cbe7`
  (`ne-q11-rc0-det-cocycle-strategy-20260707`) returned a useful draft
  `Q11GroupAction.lean` and strategy: define the exterior functor
  `lambdaAction`, top-duality `Cmap`, conjugation `Kmap`, and prove the master
  identity `J_R Lambda(g) J_R = conj(det g) Lambda(g)` for unitary `g`, yielding
  `RC0 iff det g = 1`.  The returned Lean is not a trusted landing: it contains
  documented proof holes for Jacobi complementary minors and Cauchy-Binet plus a
  draft compiler-eval step, so the next proof job should isolate those matrix
  lemmas before importing any headline theorem.
- **Claim boundary:** do not say unimodularity follows from Krein/sesquilinear
  closure. This is a Cartan-level RC0/dictionary theorem; the group-level
  determinant cocycle remains open.

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
  `ARISTOTLE_LANE_DOCKET_2026-07-07.md`. Q13 red-team follow-up `7f273e71`
  was harvested: strongest corrective actions are to demote Q12
  order-3/triality wording unless a genuine non-diagonal order-3 triple over
  `octSgn` is proved, keep Q01 flat-sector positivity separate from indefinite
  positive-sector certification, treat exact GW as palindromic/midpoint rather
  than one-sided retarded, and re-audit the absent Q02 E-slot, `(2,1)`
  index-protection, and Q04 color-commutant sources before signing those
  headlines.  After the Q08 checkerboard/Q10 Sylvester harvest, Codex submitted
  seven fresh unique-name jobs: Q08 LGV generalization (`26fa682c`), Q10
  inertia-index bridge (`bcf263f0`), Q09 entropy/horizon kill audit
  (`d32e8150`), Q12 C8/G2 real-structure audit (`cdba6caa`), RG-Schur stability
  (`9af1d5fb`), Q04 octonion/Fock bridge audit (`dbe3850c`), and P1
  claim-grade audit (`2170a1f9`). The returned `5bdce729`, `e3f3ae61`,
  `d32e8150`, `ed700b2a`, `2170a1f9`, `dbe3850c`, `cdba6caa`, and `f962cbe7`
  harvests are now integrated, recorded, or acted on.  Current poll shows
  `bcf263f0`, `9af1d5fb`, and `ec1ad7d5` still running; `26fa682c` has now
  been harvested into the Q08 LGV obstruction.  Refill wave submitted after
  that harvest: `aa4e48f6` Q11 Jacobi/Cauchy-Binet, `7b99f3b8` Q04 sign-gauge,
  `b6b128d4` Q04 ConventionBridge, `2c7ddcf1` Q08 scattering-DAG,
  `7de21ba8` Q09 Reeh/ScreenArea, `a1534a69` Q06 symbol-to-carrier,
  `381cc4cf` Q12 genuine-triality audit, `1b3c2203` Q12 C8 bridge gates, and
  `bd50e825` manuscript post-fix regression audit.  With the three older
  running projects, Aristotle is back to roughly twelve active
  StandardModel-relevant lanes.
- **SCORECARD:** consolidations at ~T+12/T+24/T+36/T+45 fold BANKED threads into
  `HONEST_SCORECARD.md` (the overnight-run copy remains the program dashboard).
- **FINAL_REPORT:** Claude drafts at T+48, Codex contributes C-lane sections;
  graded claims only; includes the lit-graph delta and the Fable-call decisions
  log.
