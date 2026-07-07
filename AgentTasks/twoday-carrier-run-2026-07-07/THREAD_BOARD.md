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
- **Status:** brick 1 **LANDED + guarded** (commit d7a7d8d - `NullNilpotentSquare`:
  `null_clifford_sq_zero`, `nullSoldered_square_offDiagonal`, `lone_edge_massless`;
  red-teamed clean). NEXT: brick 2 (the 2-complex + gauge-covariant `nabla_e` +
  plaquette holonomy defect - design fork queued for Fable call 01).

### W2a - Q_A and Q_T identification lemmas [Claude, day 2 gate]
- **Done:** kernel-checked `Q_A`-symbol-kernel = collinear locus tied to
  `nbody_aperture_massless_iff_collinear`; `Q_T = 0 iff massMatrix = 0` tied to
  `turnAmplitude_eq_zero_iff`; guarded; cross-reviewed. Statements Fable-RATIFIED
  before proof spend (call 02).
- **Status:** OPEN (statement drafting is a day-1 task).

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
- **Status:** OPEN.

### QC - the Q_C identification at leading order [Codex; THE Move-2 crux]
- **Done:** kernel-checked - the strong-coupling leading behavior of `<Q_C>` in
  the character expansion recovers the Z2 transfer gap `-log(tanh beta)`; scope
  EXPLICITLY leading-order-only; beyond-leading positivity flagged OPEN; guarded.
- **Status:** OPEN (statement design day 1, RATIFY call 03, prove day 2).

## Supporting threads

### PH - product-Haar RP core [Codex]
- **Done:** `reflForm_self_nonneg` in `ProductHaarConfig.lean` placeholder-free
  (job sm-product-haar ac751ecb IN-FLIGHT); integrated + guarded.
### CC - color commutant [Claude]
- **Done:** `color_commutant_eq_scalars` **LANDED + guarded** (commit d7a7d8d -
  `ColorCommutantScalar`; + `diagonal_mass_color_exact_iff`,
  `nonscalar_mass_not_color_exact`; red-teamed clean). STRETCH remains OPEN: the
  reducible internal-space commutant (multiplicity spaces = allowed Yukawa shape).
### AT - the A=T bridge [Claude]
- **Done:** kernel-checked `M^2 = |<12>|^2` on the two-edge sector, tied to
  `compositeMassSq_eq_sin_half` + `PluckerSpinorBridge`; docstring states the
  turn-amplitude reading with the spinor-helicity cite.
### TY-LINEAGE - audit the 0808.3442 dependency [Codex, small]
- **Done:** a written verdict in the ledger + affected docstrings: does our TY
  route depend on disputed decimation results, or only on the rigorous 1985 RP
  inequalities? Fix docstrings accordingly.
### KP - the Penrose-scheme crux [Codex, backstop]
- **Done:** `pairSum_le_expBound` proved via the partition-scheme telescoping
  identity, OR the honest reduction to one named combinatorial lemma + handoff.
  Rails: do not re-prove `kp_convergence_bound_false`; thread `hself` everywhere.
### NN-D - higher-d Nielsen-Ninomiya [either, stretch]
- **Done:** the discrete-Stokes degree theorem on `(ZMod N)^d` (facet-pairing
  telescoping), any d >= 2 beyond the landed 2D version; tie to overlap index if
  cheap.
### SPIN10-U5 - the flag-stabilizer rung [shared, stretch; Fable-gated]
- **Done:** Stab(pure-spinor line) = U(5) at the Lean level (or the honest
  finite-dimensional shadow); the full flag conjecture stays PARKED unless a
  Fable call promotes it.

## Standing meta-threads

- **AUDIT-POOL:** every landed flagship enters; Aristotle audit within ~6h
  (playbook sec 3).
- **SCORECARD:** consolidations at ~T+12/T+24/T+36/T+45 fold BANKED threads into
  `HONEST_SCORECARD.md` (the overnight-run copy remains the program dashboard).
- **FINAL_REPORT:** Claude drafts at T+48, Codex contributes C-lane sections;
  graded claims only; includes the lit-graph delta and the Fable-call decisions
  log.
