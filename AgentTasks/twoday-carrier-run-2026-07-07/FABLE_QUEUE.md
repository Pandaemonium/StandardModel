# Fable queue (two-day carrier run) - the standing escalation channel

Both agents append conceptual blockers, design forks, suspected-false statements,
and red flags the moment they occur. Claude triages this queue into every
2-hourly call (`FABLE_CALL_PROTOCOL.md` sec 5). Mark answered items
`[ANSWERED call-NN] <one-line decision>` - do not delete them.

Format:
```
- [QUEUE HH:MM agent] problem (one line); statement/file:line; tried; what kind
  of answer unblocks (decision / decomposition / verdict-false / reference)
```

## Seeded items (run start)

- [QUEUE T+0 setup] OS1 route fork: character/polymer expansion (stands on landed
  CharacterExpansion + StrongCouplingAreaLaw + the Z2 SlabGapAssembly template)
  vs Shen-Zhu-Zhu functional-inequality route (2204.12737; explicit
  |beta| < 1/(16(d-1)) but imports Langevin/log-Sobolev machinery with thin
  Mathlib support). Codex prepares the comparison; unblock = DECISION at call 01.
- [QUEUE T+0 setup] Move-1 2-complex design: minimal viable 2-complex for the
  Weitzenbock assembly - reuse NSBB causal-diamond cells verbatim, or a purpose-
  built 2-plaquette complex mirroring WilsonSlabConnected? Tension: NSBB reuse
  buys the Krein structure but drags imports; purpose-built is standalone but
  duplicates `#`-structure lemmas. Unblock = DECISION at call 01 (affects every
  W1 brick statement).
- [QUEUE T+0 setup] The Krein positivity domain [CRUX, standing]: on which
  physical-sector does `D^#D` restrict to a genuine nonneg form? NSBB's
  <lambda, lambda-tilde> pairing is the prior infrastructure. NOT blocking W1
  (forms, not spectra) - queued so Fable can chip at it across calls; any partial
  characterization upgrades W2c. Unblock = decomposition.
- [QUEUE T+0 setup] The closure statistical-positivity [CRUX, standing]: beyond
  leading order, `<Q_C> >= 0` in the gauge measure. Not this run's target (QC is
  leading-order-only) - queued for horizon guidance: what is the weakest
  beyond-leading statement worth attempting next run? Unblock = reference /
  decomposition.

## Live entries (append below)

- [QUEUE 21:34 Codex QC] Leading-order `Q_C` identification statement shape.
  Candidate: in the finite Z2/one-link strong-coupling shadow, identify the
  leading closure-flux coefficient with the already-landed contraction factor
  `exp(-gap) = tanh beta` (`SlabTransferGap.neU4_exp_neg_closure_gap_eq_tanh`,
  `TYAreaLaw.partitionRatio_eq_tanh`, `SlabGapAssembly.gap_value`), and state
  the `Q_C` expectation only as a leading-order/character-coefficient read-off.
  Trap: do NOT claim beyond-leading `<Q_C> >= 0`, and do NOT conflate the three
  objects in `SlabGapAssembly` (transfer matrix, OS Hamiltonian gap, normalized
  two-state transfer). Unblock = ratify exact object/normalization and whether
  the first Lean theorem should live in `GateYM/QCLeading.lean`,
  `TYAreaLaw.lean`, or a Carrier/GateYM bridge after Claude lands torus `Q_C`.
- [QUEUE 22:18 Codex QC/Aristotle] Focused Aristotle strategy says the landed
  `QCLeading` file should remain a scalar normalization layer; the next bridge
  should be a parameterized `QCCarrierBridge.LeadingQCCarrierContract`, with the
  carrier observable supplied as a parameter and no measure/expectation claim.
  Update 22:45: Claude has landed the Carrier flatness theorem in commit
  `4a779c0`, so call 03 should RATIFY the contract fields, normalization
  direction, and exact use of that theorem before any bridge proof spend.
  Update 23:55 Codex: proposed ratification shape is a tiny structure, not an
  expectation theorem:
  `LeadingQCCarrierContract (beta : R) (hbeta : 0 < beta) (Obs : Type*)`
  should take as parameters a carrier-side closure observable/readout
  `qCLeadingReadout : Obs -> R` and a distinguished observable `qC0 : Obs`, then
  require exactly `qCLeadingReadout qC0 = leadingClosureFluxCoeff beta`, plus
  imported scalar consequences from `QCLeading` (`= tanh beta`, `= exp(-gap)`,
  and membership in `(0,1)`). Optional second layer only after ratification:
  attach `qC0` to `Carrier.Torus.plaquetteCurvature` /
  `Carrier.Torus.mZero_iff_commute`. This avoids claiming a measure, expectation,
  beyond-leading positivity, or nonabelian result. Update 00:42 Codex: this
  parameterized contract has landed in `QCCarrierBridge.lean`, with theorem
  guards in `SlabAxiomGuard.lean`. The optional concrete Carrier attachment is
  still Fable-gated and should not be treated as part of the landed contract.
  Update 01:08 Codex/Aristotle: focused strategy job
  `f4e21d1c`/`8068bd6e` says to code the concrete attachment now, but only as
  pure bookkeeping: instantiate `Obs` with the Carrier torus configuration type,
  pin `qC0` to a chosen `U`, and re-export `mZero_iff_commute` without any
  curvature-to-scalar lemma. Codex landed this as `QCCarrierTorusAttachment.lean`.
  Anything deriving the scalar from curvature remains Fable-gated.
- [QUEUE 22:55 Codex/Fable] Teleparallel G-slot framing. Fable says the
  `E`-slot should be treated as discrete null teleparallelism: flat transport
  with non-covariantly-constant soldering, gravity carried by torsion. Near
  target: define discrete torsion
  `T(e,f) = nabla_e alpha_f - nabla_f alpha_e` and prove `E` is its Clifford
  contraction. Unblock = RATIFY exact Lean statement shape, ownership, and the
  TEGR/Nester/Maluf/Witten provenance notes to cite before proof spend. Update
  01:31 Codex/Aristotle: strategy job `7ad651e7` / `5aa6d83b` sharpens this.
  In current `CarrierESlot.lean`, `E` contracts the covariant soldering
  difference `[nabla_e, gamma_f]`, not hypothesis-free antisymmetric torsion.
  The honest algebraic target is `2 * E = Contract(T) + Contract(S)`, with `T`
  antisymmetric and `S` symmetric. Fable should ratify when this algebraic API
  may be called geometric/discrete-null-teleparallel torsion; Carrier code is
  Claude-owned, so Codex leaves this as handoff.
- [QUEUE 22:55 Codex/Fable] Krein positivity reframed as finite Pontryagin
  linear algebra. Fable's near target: for a finite Pontryagin/Krein space and
  a `J`-self-adjoint operator such as `D^#D`, prove existence of an invariant
  maximal nonnegative subspace; then the physical question becomes naturality
  (gauge-invariant/local/grading-compatible), not existence. Unblock =
  RATIFY the smallest standalone theorem statement and whether to push it as
  Mathlib-adjacent infrastructure. Update 23:07 Codex/Aristotle: audit says the
  weak maximal-nonnegative theorem is true but can be degenerate; it does not
  give a positive-definite physical Hilbert sector. Fable should ratify the
  exact extra hypothesis (`definitizable`, `J`-orthonormal eigenbasis, or
  another physical input) before any headline positive-sector theorem.
- [QUEUE 23:07 Codex C-lane] One-form center-symmetry phrasing for GateYM.
  Existing Lean has finite center flux shifts, electric sectors, plaquette
  invariance, and TY twist ratios, but no explicit background-field/cohomology
  object. Initial Aristotle strategy job `f8cdf5c2`/`987a9882` returned useful
  charged-line guidance but had one false stale-check caused by an incomplete
  staged package (`TYAreaLaw.lean` was omitted); local TY checks and full
  `lake build` pass. Correction task `87f5a0e1` retracts the build-blocker and
  says the first proof target should be ordered `List.prod` charged-line
  operators. Codex banked that finite API in `CenterOneFormLine.lean`. Unblock =
  RATIFY whether the next step should be a non-vacuous electric-sector witness
  or the larger configuration-to-`TwistSystem` partition bridge; do not claim an
  honest `H^2(K,Z(G))` background object yet.
- [QUEUE 01:57 Codex/Aristotle grand-strategy] Whole-project strategy review
  says the next high-value Carrier move is a single concrete torus witness with
  `Q_A`, `Q_C`, and `Q_T` simultaneously nonzero before any capstone upgrade.
  It also says Codex should stop zero-coupling OS1 rungs, freeze QC bookkeeping,
  and either attack volume-uniform KP by fiber injection or move OS1 genuinely
  off `beta = 0`. Fable call 03 supersedes the immediate Codex priority toward
  the M4 Pauli/Pontryagin witness (`kreinStar (J = rho Gamma)`, `kappa = 2`),
  then the exact Z2 two-torus `Q_C` theorem/error term. Unblock for next call:
  RATIFY whether the KP fiber-injection route remains the right OS1 fallback
  after the Pontryagin witness, and whether the concrete torus witness must
  precede every capstone/prose upgrade.
- [QUEUE 03:25 Codex/Aristotle grand-strategy] 03:00 strategy review flags
  the live Krein-risk rail: current Carrier square theorems are algebraic
  involution-square identities until `kreinSharp (J = rho Gamma)` and the M4
  `kappa = 2` witness are instantiated. It also asks Fable to ratify the exact
  definitizability/positive-sector hypothesis before any headline positivity
  theorem beyond the flat-sector identity, and to re-confirm KP fiber injection
  as the OS1 fallback now that Aristotle returned the first support lemma
  target. Unblock = decision on positive-sector hypothesis and OS1/KP priority.

## Answered by call 01
- [ANSWERED call-01] OS1 route fork -> character/polymer on a FINITE gauge group is far
  more Mathlib-formalizable than Shen-Zhu-Zhu (no log-Sobolev in Mathlib). Codex: finite
  group first, before SU(2) Haar. Revisit at call 03 with Codex gate status.
- [ANSWERED call-01] 2-complex design fork -> purpose-built Z2xZ2 gauge torus (commuting
  shifts = add_comm, no boundary partiality); prose bridge to WilsonSlabConnected, not a
  bridge theorem. Beats causal-diamond reuse and the raw slab.
- [QUEUE 2026-07-07 Claude, from Sources/Ontology_extensions.md sec 2b] OS/theta-
  reflection selector for the positivity crux [pre-registered conjecture]: null
  edges give a canonical causal reflection theta across a cut; the form
  <theta x, x> from the Krein structure is positive semidefinite on the
  reflection-symmetric sector and D^#D descends positively to the OS quotient.
  Payoff: OS1-lane reflection positivity and carrier-lane Krein positivity become
  ONE theorem used twice. Witness-checkable sub-claim: J = Gamma IS the causal
  reflection (chirality = direction of motion), so "OS form = Krein form on the
  symmetric sector" is a finite computation on the kappa=2 witness. Unblock =
  ratify the theta definition on our complexes + whether this selector, the
  Gupta-Bleuler constraint kernel, and retardedness pick the SAME quotient
  (compare in one finite framework; Aristotle job 4338f235 asked the
  constraint-kernel half - reconcile on harvest).
- [QUEUE 2026-07-07 Claude, from Sources/Ontology_extensions.md sec 2c] Discrete
  ANEC/modular reading of positivity [standing deep target, SPECULATIVE]: null
  transport = modular flow for (Krein structure + null cut) (Borchers-Wiesbrock
  shape); physical positivity = discrete ANEC = relative-entropy positivity
  across a null cut. All ingredients finite. Not blocking anything; chip at it
  across calls. Unblock = decomposition into finite lemmas (first candidate: the
  finite-dim modular operator of a cut subalgebra vs the Krein form).
- [QUEUE 2026-07-07 Claude, from Sources/Ontology_extensions.md secs 5-6] Two
  cheap near targets proposed: (i) koide_iff_angle - the Koide combination
  Q = 2/3 iff the sqrt-mass vector makes a 45-degree angle with (1,1,1) (Foot),
  as a pure finite identity (sqrt-m are the aperture slot's native variables;
  no physics claim in the Lean); (ii) Dirac charge quantization on the finite
  complex = integrality of the plaquette flux cocycle (DeGrand-Toussaint;
  H^2(K,Z) -> H^2(K,U(1))) on the existing torus complex - adds the flux class
  as a fourth integer to the index-trinity frame. Unblock = ownership + ratify
  statements (both are candidates for idle-cycle work, not critical path).

## Answered by the Q01-Q03 parallel memos (2026-07-07, AgentTasks/fable_parallel/)
- [ANSWERED Q01] The Krein positivity domain [was CRUX, standing since T+0] ->
  SOLVED to its exact boundary: Theorem A (state positivity = Witt geometry of
  the constraint span: isotropy + count kappa + finite Ward identity
  D Gamma' <= Gamma'); counterexample ladder O1-O5; the single repair
  hypothesis (H*) = constraint completeness. Definitizability STRUCK (vacuous
  in finite dim; the invariant is the sign characteristic). Two-theorem
  structure: state positivity (Theorem A) vs mass-form positivity (Weitzenboeck
  channel decomposition AFTER descent). Headline kernel target:
  dim(V'/N) = ind(D). Positive-sector hypothesis question (03:25 grand-strategy
  item) thereby RESOLVED.
- [ANSWERED Q01] Retardedness role -> orientation of the invariant-null-ray
  selection per constraint plane (decidable 2x2 trichotomy); NOT the source of
  positivity. KILL registered: real-split constraint planes = genuine ghosts,
  no first-class positive sector.
- [ANSWERED Q02] Teleparallel G-slot framing [22:55 item] -> Tr E "pure
  torsion" conjecture KILLED (P-probe: T = 0, drift > 0; plus convention
  vacuity); survivor = corrected telescoping (Phi = torsion + pair-mass drift
  + Leibniz remainders; boundary flux = discrete GHY); Lemma 0: only the TOTAL
  trace is redecoration-invariant - block-trace language ill-posed; TEGR
  coefficients become a finite derivation (M-ladder).
- [ANSWERED Q03] No-go audit -> charter U0-U5 adopted
  (`Sources/Null_Edge_Program_Charter_2026-07-07.md`): losses declared (no
  coupling unification, no rep-content claim pending a replacement axiom),
  WW/Marolf redundancy obligation, GW descent load-bearing, CM as output.

## Live entries (post-memo, append below)
- [QUEUE 2026-07-07 Claude] OS/theta-reflection selector NOT adjudicated by
  Q01 (it settles Gauss-covector V' and retardedness; theta untested). Keep
  queued; reconcile with Aristotle 4338f235 on harvest and with Q08 if run.
- [QUEUE 2026-07-07 Claude] Q03 cover lemma L4 as stated needs its hypothesis
  pinned (per-cell balanced grading / full-spinor fiber) - executor
  verification flag; formalize with the hypothesis displayed.
- [QUEUE 2026-07-07 Claude] Q02 S-sector trichotomy (decouple/gap/propagate
  under refinement) and the stencil dilemma (telescoping vs doublers) both
  point at the GW layer - candidate future Fable/strategy question when the
  E-TELESCOPE thread lands its first rungs.
- [ANSWERED Q04] SM selection: the naked (ind, kappa, inertia)+abstract-
  commutant target is PROVABLY insufficient (B-L twist counterexample);
  repaired data = equivariant index + graded kappa + channel inertia +
  commutant-with-action + TURN CENSUS (KO-decorated). Candidate selection
  theorem under the internal null-strand principle: n = 5 forced, degeneracy
  exactly {(3,2) = SM generation, (4,1)}; bit (F) = "electromagnetism exists"
  selects (3,2); hypercharge + Z_6 DERIVED (Majorana-exactness + Krein
  closure). Base minimality is SM-blind (rose V=1,E=2,F=1 suffices).
- [QUEUE 2026-07-07 Claude, Q04 risks] (i) C8 seam: coherence of the internal
  Hodge/top-form pairing with the Layer-D # antiautomorphism - "the seam most
  likely to bite"; kernel-check before any unimodularity-derivation claim.
  (ii) Enumeration kill: verify no fifth n=5 configuration survives (A)-(D)
  (finite check). (iii) Look for an already-kernel-checked constraint that
  deletes the (4,1) competitor outright - would upgrade the selection theorem
  by removing the one IR bit.
- [ANSWERED Q05] Three generations -> mechanism taxonomy ranked; WINNER =
  triality-as-monodromy (3 forced by D4's order-3 OUTER automorphism -
  unique among simple Lie algebras; charge identity via Fix(tau) = G2;
  multiplicity menu exactly {1,3}); Fano-lines mechanism KILLED (inner to
  color = gauge-vacuous) with the adopted rail "generation symmetries must be
  gauge-outer"; naive E8 packaging killed via the Distler-Garibaldi index
  translation (cheap kernel lemma). V_H (x) V_O factorization DERIVED -
  dovetails with Q04's strand fiber. CKM-small/PMNS-large = Z/3 rep theory
  (End commutes vs Sym^2 maximally rotated; theta_23 = 45 deg; registered
  tension theta_12; mu-tau-reflection delta_CP = +/- pi/2 falsifiable soon).
  Koide = (beta = sqrt2 alpha) in mechanism coordinates - neither prediction
  nor kill.
- [QUEUE 2026-07-07 Claude, Q05 risks] (i) CHIRALITY-SOLDER audit - the most
  dangerous internal check: does any admissible carrier force [Gamma, tau]
  != 0 (per-sector index would degrade 3 -> 1)? Run on TOY-A (x) TOY-B before
  any generation-mechanism prose hardens. (ii) L4c Springer-Veldkamp local
  triality is the load-bearing transcription risk. (iii) Ibanez-Ross discrete
  anomaly check for the gauged deck symmetry (linear condition passes:
  0+1+2 = 0 mod 3; full check queued).
- [ANALYSIS 2026-07-07 Claude] C8 seam SHARPENED: Q04's unimodularity row
  needs an ANTILINEAR identification conj(Lambda^k) = Lambda^{5-k} (x)
  det^{-1}; the top-form pairing alone is bilinear, so the sesquilinear Krein
  form requires exactly the J_R candidate of Q03-L8 (edge-reversal compose
  conjugation). THE TWO FLAGGED GAPS ARE ONE OBJECT. Coherence checks, all
  finite on 32 dims: (i) B(x,y) := top-coefficient of (J_R x) wedge y is
  Hermitian up to a per-degree sign table; (ii) its graded inertia (feeds the
  kappa row C9); (iii) the B-adjoint on decoration operators coincides with
  the Layer-D # slot. Building J_R closes C8, the NCG contact gap, AND the
  quadrupling question in one file. -> folded into round-2 packet Q11.
- [ANALYSIS 2026-07-07 Claude] CHIRALITY-SOLDER audit partially DEFUSED by
  architecture analysis: in the composed model (strand pentad (x) family
  factor C[Z/3], tau = shift), (-1)^F lives on the strand factor and tau on
  the family factor - [Gamma_total, 1 (x) tau] = 0 BY CONSTRUCTION (and
  equivariant phi/transports commute with tau, so the GW-descended grading
  Gamma' = Gamma(1 - aD) also commutes at eps = 0; breaking makes sectors
  approximate exactly like real-world flavor while total ind stays rigid).
  The danger is LIVE only for the pure Spin(8)-internal variant (families =
  8v/8s/8c inside ONE module, tau cycling internal half-spinor parities) -
  which the gauge-outer rail and the Distler-Garibaldi self-conjugacy lemma
  already disfavor. Kernel target: the trivial-but-certifying commutation
  lemma on TOY-A (x) strand fiber. -> folded into round-2 packet Q12 for
  adversarial confirmation.
