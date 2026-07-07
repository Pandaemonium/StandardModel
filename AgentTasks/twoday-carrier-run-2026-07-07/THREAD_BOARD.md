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
  `carrier_krein_square_selfAdjoint` prove the `D^#D` mass-form decomposition,
  with positivity still explicitly OPEN. Backfill: brick **2a'** (char-free,
  drop Field/h2 - call-01 audit). **Cite in W1 docstrings:**
  [BQJAG9TR] hep-th/9503153 (generalized Lichnerowicz) + arXiv:1301.3480 (gauge
  networks, brick-2 scaffold) + [2DEG7MT2] 0708.3707; in-graph, LIT_LOG rounds 1-2.

### W2a - Q_A and Q_T identification lemmas [Claude, day 2 gate]
- **Done:** kernel-checked `Q_A`-symbol-kernel = collinear locus tied to
  `nbody_aperture_massless_iff_collinear`; `Q_T = 0 iff massMatrix = 0` tied to
  `turnAmplitude_eq_zero_iff`; guarded; cross-reviewed. Statements Fable-RATIFIED
  before proof spend (call 02).
- **Status:** OPEN. Claude commit `66c0051` added
  `CarrierApertureIdentification.lean` as a Q_A statement/proof-handoff file,
  but both headline theorems are still draft placeholders and the file is not a
  banked/kernel-checked identification. Codex review flagged the docstring as
  ahead of the kernel until those placeholders are removed.

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
  sum bound and smallness hypothesis explicit.

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
  ratification.

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
  deferred configuration-to-`TwistSystem` partition bridge and any honest
  `H^2(K,Z(G))` background object.
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
- **Status:** OPEN; Aristotle task `e1f4172d` exceeded the 2-hour rule and was
  canceled. A concise handoff-only continuation was requested in project
  `c8468d57`; no result has been harvested yet.
### NN-D - higher-d Nielsen-Ninomiya [either, stretch]
- **Done:** the discrete-Stokes degree theorem on `(ZMod N)^d` (facet-pairing
  telescoping), any d >= 2 beyond the landed 2D version; tie to overlap index if
  cheap.
### SPIN10-U5 - the flag-stabilizer rung [shared, stretch; Fable-gated]
- **Done:** Stab(pure-spinor line) = U(5) at the Lean level (or the honest
  finite-dimensional shadow); the full flag conjecture stays PARKED unless a
  Fable call promotes it.

## Standing meta-threads

- **AUDIT-POOL:** every landed flagship enters; Aristotle audit fired EVENT-DRIVEN
  after every 2-4 integrated proofs, 2-3 audit jobs in flight (playbook sec 3).
- **SCORECARD:** consolidations at ~T+12/T+24/T+36/T+45 fold BANKED threads into
  `HONEST_SCORECARD.md` (the overnight-run copy remains the program dashboard).
- **FINAL_REPORT:** Claude drafts at T+48, Codex contributes C-lane sections;
  graded claims only; includes the lit-graph delta and the Fable-call decisions
  log.
