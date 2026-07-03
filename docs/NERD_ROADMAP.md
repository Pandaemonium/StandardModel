# NERD / NRQG program roadmap (post-v2.1)

This is the consolidated guide for the Null-Edge Relativistic Dynamics /
Null-Edge Relational Quantum Geometry program after the v2.1 revision. It
exists so that agents and task files pull from one ladder, one claim
discipline, and one track assignment instead of re-deriving them from the
four source treatises.

Source documents, in reading order:

- `Sources/NERD_1.md` - v1 treatise: null-edge ontology, overlap/GW release
  architecture, gates C1-C3 and G1-G2, failure modes F1-F10.
- `Sources/NERD_2.md` - v2 informational reformulation: Cauchy-Binet mass
  identity, mass as entanglement, geometry as sufficient statistic, gravity
  from entropy monotonicity, QEC reading of Ginsparg-Wilson, gates I1/I2 and
  Lambda1, failure modes F-M1..F-L1.
- `Sources/NERD_3.md` - round 3: boost-Gibbs form (A1), Minkowski determinant
  dictionary (A2), discrete QNEC protocol (A3), lattice prior-art positioning
  (A4), publication portfolio P1-P9, phased research plan.
- `Sources/NERD_4.md` - v2.1 revision after external review: disposition
  ledger, Gate C0 conventions, determinant-line clock (I3), Lorentz-ensemble
  viability (L0), relative-cohomology Lambda fix, revised ladder, explicit
  non-claims.
- `Sources/Null_Edge_Dynamics_Gate_D.md` - Gate D dynamics proposal
  (2026-07-02, in-repo development): the maximum-entropy equilibrium route,
  the modular-generation route (Borchers-Wiesbrock), coin-decorated
  sequential growth, the X1-X3 consistency triangle, gates D0-D8, failure
  modes F-D1..F-D6.

When a statement here conflicts with an earlier NERD document, v2.1
(`NERD_4`) wins; the Gate D document extends v2.1 without overriding it.

## The two structural revisions every task must respect

1. **Ontology revision (L0).** The tetrahedral/finite-valency null-direction
   lattice is a gauge-fixed regulator, not the ontology. Exact
   Lorentz-invariance claims for any finite-valency null graph are withdrawn
   pending Gate L0. In ontology statements, "null edges" means the link
   structure (covering relation) of a Poisson-sprinkled causal order,
   Lorentz-invariant in distribution, and every dynamical use of links must
   factor through a damped, layered transport kernel (Benincasa-Dowker type).
   Gate C1 is unaffected as mathematics but is a regulator-level statement.

2. **Clock revision (I3).** The de Broglie/internal clock is provably NOT the
   modular flow of the momentum state (trivial at rest). The theorem-shaped
   clock is the determinant line of the minimal null split: free Dirac
   evolution rotates `det L` at angular frequency `2m` (zitterbewegung), and
   the minimal-split gauge group factorizes as `U(2) = (SU(2) x U(1))/Z_2`
   with `SU(2)` = spin frame (massive little group) and `U(1)` = internal
   clock. "Proper time = det-line holonomy / 2m" remains a labeled postulate.

## Claim discipline

Two label systems are in force; use both where relevant.

- Manuscript/task-note claim labels (locked in `docs/CONVENTIONS.md`):
  representation, reconstruction, structural theorem, prediction.
- NERD theory-document status labels (from `NERD_4`): THEOREM (finite math,
  proof included or one line from standard results), IMPORT (real literature
  theorem whose hypotheses we have not reproduced), PROPOSAL (checkable
  theory development), SPECULATIVE (labeled).

Standing non-claims (from `NERD_4` section 14; do not drift back):

- Gravity has not been derived. The exact finite content of the "gravity is
  DPI" slogan is Q1 (positivity and monotonicity of vacuum-subtracted
  relative entropy along nested cuts); the QNEC content is the second
  difference (Q2) and is open. Jacobson-style equation-of-state derivations
  are IMPORT.
- No exact Lorentz invariance of any finite-valency structure.
- The de Broglie clock is not derived from modular flow (it provably is not).
- SMG erasure is not guaranteed by anomaly freedom; anomaly freedom is
  necessary, sufficiency only in exhibited models.
- The spectral action is a consistency gate (G1'.4), not evidence.

C1 paper framing (pre-registered): if the gap is proved, the result is a
machine-checked doubling-free exotic-kernel construction with a null
interpretation, positioned against the hyperdiamond/minimal-doubling no-go
literature (Bedaque et al.; Kimura-Misumi; Creutz-Kimura-Misumi as nearest
prior art). If the gap fails, the obstruction result is itself the paper.
Both outcomes publish without narrative rewrites.

## The gate ladder (v2.1 order)

| # | Gate | Content | Status (2026-07-02) | Track |
|---|------|---------|---------------------|-------|
| 0 | C0 | Three-J table; grading split; convention audit | Conventions recorded in `docs/CONVENTIONS.md`; audit of existing super-Dirac statements pending | day (cheap, do before any Krein/gamma_5 formalization) |
| 1 | I1 | Plucker mass identity build order (soldering det -> PSD cone -> rank/null -> 2xn Cauchy-Binet -> cross-check) | DRAFT CORE PORTED (2026-07-03), `PhysicsSM/Draft/NullEdge/GateI1/Core.lean` + aggregate `GateI1.lean`; kernel-checked with axiom footprint propext/Classical.choice/Quot.sound. Covers soldering determinant, future-cone PSD/eigenvalue characterization, rank/null and rank-one factorization shadow, 2-edge Pluecker mass identity, and kinematic cross-check. Plan/map: `AgentTasks/nerd-gate-i1-kinematic-core-lean-plan-2026-07-02.md` | night |
| 2 | I1.7 | Stiefel splitting; little group = minimal-split gauge | Partial finite `U(2)` phase/SU split algebra ported in GateI1 core; full Stiefel theorem and quotient-isomorphism packaging remain open | night |
| 3 | I1.8 | Normalized dictionary (det rho = m^2/4E^2, concurrence = m/E, entropy-velocity) | Draft determinant/purity/faithfulness dictionary ported in GateI1 core; binary-entropy and eigenvalue-ordering package remain open | night |
| 4 | I1.9 | First-order bridge `(gamma . P)^2 = det(P) 1` | Draft first-order Weyl-block bridge ported and kernel-checked in GateI1 core | night |
| 5 | I2 | Finite modular faithfulness (timelike iff faithful iff finite modular Hamiltonian; null iff pure: "null edges do not age") | Draft finite matrix-support/timelike-faithful shadow ported; full Tomita/logarithm modular theory remains open | night |
| 6 | I3 | Determinant-line clock; Prop I3.5 (frequency 2m); U(2) = spin x clock | Draft determinant-line clock and finite spin-clock split algebra ported; proper-time holonomy remains a labeled prose postulate | night |
| 7 | L0 | Lorentz ensemble: prove L0.1 no-go; links + damped kernel; tetrahedral = regulator | Plan: `AgentTasks/nerd-gate-l0-lorentz-ensemble-nogo-plan-2026-07-02.md` | paper-level |
| 8 | C1 | Tetrahedral operator gap -> self-adjointness -> sign/GW release | OPERATOR-LEVEL CHIRAL RELEASE DONE (draft-trust, 2026-07-03; all kernel-checked, axioms propext/Classical.choice/Quot.sound). Free-operator half: coercive gap `tetraFreeOperator_gap_equalN`, self-adjointness `Hfree_selfAdjoint`, symbol Hermiticity `H_symbol_hermitian`, no-zero-modes `Hfree_ker_trivial`. Symbol chiral release (`TetraSymbolOverlapGW.lean`, red-team-VALIDATED feae0495): `H_symbol_sq` (Clifford scalar square H^2=coeff.I bypasses functional calculus), `signSymbol_sq/_star`, `symbol_ginsparg_wilson`, Weyl projectors. Two-sided Fourier iso (`TetraFourierInverse.lean`). OPERATOR release (`TetraOperatorOverlapGW.lean`): `sign(Hfree)` a self-adjoint involution (`signHfree_involutive`+`signHfree_selfAdjoint`), `DovOp`, `operator_ginsparg_wilson`. OPERATOR Weyl projectors (`TetraOperatorWeylProjectors.lean`): spectral resolution `P+/P- = (1 +/- signHfree)/2`, `weylProjOp_add` (`P+ + P- = 1`), `weylProjOp_sub_eq_signHfree` (`P+ - P- = signHfree`), idempotents, and `signHfree_weylProjOpPlus` (`P+` image is the `+1` chirality eigenspace) - the operator statement that the regulator carries chiral (Weyl) fermions. FREE (no-gauge) CHIRAL RELEASE COMPLETE. SUCCESSOR = Gate C2 (gauge backgrounds, index, anomaly). `PhysicsSM/Draft/NullEdge/GateC1/` | day |
| 9 | Q1 | Finite DPI (Uhlmann/Petz) on nested algebras | Check Lean-QuantumInfo/PhysLean for existing DPI before building | night |
| 10 | Q2 | Discrete QNEC, Peschel-exact ladder on checkerboard null cuts | Protocol: `AgentTasks/nerd-gate-q2-discrete-qnec-protocol-2026-07-02.md` | paper-level (numerics) |
| 11 | Lambda1' | Relative Hodge decomposition; Lambda = harmonic representative of `H^4(D, boundary D)` volume class | Formulated; finite linear algebra | night (after I1) |
| 12 | S1 | Mirror erasure, Fidkowski-Kitaev Z_8 instance | Formulated; finite, decidable; not scheduled | queue |
| 13 | M1'/G1' | Metric as principal symbol of the invariant kernel; emergent geometry | After L0 and Q2 | queue |
| 14 | D1-D2 | Dynamics, equilibrium route: finite max-ent shadow; exact first-law identity `Delta S = Delta<K> - S_rel` | Lean-ready; source: `Sources/Null_Edge_Dynamics_Gate_D.md` | night |
| 15 | D3 | Finite half-sided-modular-inclusion triviality no-go; modular defect functionals and their scaling | No-go theorem-shaped (Lean-medium); defect numerics share the Q2 code | night + paper-level |
| 16 | D4/D6 | Checkerboard decorated-growth dictionary; toy equilibrium = stationarity cross-check | Lean-light on the existing `NullEdgeStandalone` checkerboard stack | night |
| 17 | D5/D7/D8 | Coin rigidity (little-group covariance fixes coins); growth realizes modular translation; positivity probe | Formulated; D8 is a numerics afternoon | queue |

Gate C2 (gauge backgrounds) follows C1 on the day track, with the added
J_K-covariance audit and two-grading discipline from C0. **C2 OPENED
(2026-07-03, draft-trust, kernel-checked, dependency footprint
propext/Classical.choice/Quot.sound), `PhysicsSM/Draft/NullEdge/GateC2/`:**

- Index ALGEBRA already existed in `GateC1.OverlapIndexToy` (`overlapIndex =
  (1/2)(Tr gamma5 - Tr eps)`, zero-index-if-anticomm, Fin 2 witnesses).
- `OverlapIndexIntegrality.lean` (`overlapIndex_isInteger`): the finite overlap
  index is an INTEGER for any involutions - it equals a difference of
  eigenprojector ranks (trace of idempotent = finrank via `LinearMap.IsProj.trace`
  + `Matrix.trace_toLin'_eq`); needs only involution, not Hermiticity.
- `OverlapIndexEndIntegrality.lean` (`overlapIndexEnd_isInteger`): the same
  integrality theorem at the finite `Module.End ℂ V` level, so operator indices
  can be stated without first choosing matrices. `trace_ghatEnd` proves the same
  End-level index is the trace of the Luscher modified chirality
  `f * (1 - (1/2) Dov)`.
- `OverlapIndexEigenspace.lean` (`specProjEnd_range_eq_eigenspace`,
  `overlapIndexEnd_eq_eigenspace_dim_sub`, `trace_involution_eq_signature`,
  `overlapIndexEnd_eq_half_signature_sub`): the operator overlap index is the
  difference of the `+1` eigenspace dimensions of the two involutions, and
  equivalently `(1/2)(sig f - sig g)` via the trace-as-signature theorem.
- `OverlapIndexMatrixSignature.lean` (`matrix_trace_eq_signature`,
  `overlapIndex_eq_half_signature`): transports the End signature formula through
  `Matrix.toLin'`, so explicit matrix witnesses and future gauge Wilson matrices
  get the same concrete `(1/2)(sig gamma5 - sig eps)` index formula.
- `TetraFreeIndexZero.lean` (`tetraFreeOverlapIndex_eq_zero`): the free
  benchmark - the free tetrahedral overlap index is 0 for traceless chirality
  (`Tr(gamma5.Q)=0` from `{gamma5,Q}=0` + cyclicity, `Tr gamma5 = 0`).
- `TetraFreeIndexDensity.lean` (`freeIndexDensity_eq_zero`): the free local
  index-density benchmark - `signHfree` is expanded as a real-space kernel, its
  diagonal is translation-invariant, the free sign symbol is traceless at each
  momentum, and the local density vanishes site-wise. Free/no-gauge; not an
  anomaly theorem.
- `OverlapIndexWindingWitness.lean` (`overlapIndex_gamma5WQ_epsWQ_eq`): the C2a
  bridge - a block-stacked graded involution family (2-site Wilson line unit,
  one-site signature defect) with overlap index EXACTLY Q, realizing every winding
  charge and defeating the free-zero benchmark.
- `OverlapSignCertificate.lean` (`certifiedSign_unique`): the C2b backbone - for a
  gapped Hermitian H, an involution with `[eps,H]=0` and `eps.H` PSD is
  UNIQUE (= sign(H)), proved via PSD-sqrt uniqueness (no functional calculus, no
  eigendecomposition). `SignCertificate.dov_ginspargWilson`: a certified sign gives
  a GW overlap. This is the uniqueness half of the abstract admissible-sign
  interface for gauge overlap.
- `OverlapSignExistence.lean` (`certifiedSign_exists`, `certifiedSign_eq_epsCFC`):
  the C2b existence closure - for every gapped Hermitian `H`,
  `epsCFC = CFC.sqrt(H^2) * H^-1` is a `SignCertificate`; by uniqueness every
  certificate equals this explicit sign.
- `OverlapSignHermitian.lean` (`signCertificate_isHermitian`,
  `epsCFC_isSelfAdjoint_involution`): the C2b self-consistency closure - for an
  invertible Hermitian `H`, every certified sign is automatically
  Hermitian/self-adjoint, and the explicit `epsCFC` sign is a self-adjoint
  involution.
- `GaugeOverlapInterface.lean` (`gaugeOverlap_index_isInteger`,
  `gaugeOverlap_ginspargWilson`, `gaugeOverlap_index_certificate_independent`,
  `gaugeOverlap_index_signature_form`):
  any gapped Hermitian gauge/Wilson operator plugs into the certified-sign
  interface to give a well-defined integer index, GW overlap, and
  certificate-choice-independent index value, with matrix-signature form.
- `GaugeIndexInertiaForm.lean` (`gaugeOverlap_index_trace_form`,
  `epsCFC_trace_eq_inertia`, `gaugeOverlap_index_eigenvalue_count_form`): the
  gauge-overlap index is computable directly from the eigenvalue signs of the
  gapped Hermitian gauge/Wilson operator `H`, namely
  `(1/2)(sig gamma5 - (n_+ - n_-))`. The sign-trace/inertia spectral bridge was
  harvested from Aristotle job `25f0b738`.
- `OverlapWindingSignJoin.lean` (`signCertificate_HU_epsW`, `signCertificate_HU_unique`):
  joins C2a to C2b - the winding involution `epsW` is a genuine certified sign of an
  explicit gapped mass-defect (domain-wall) operator `HU = diag(-2,-3,-1,5)`, and
  every certified sign of `HU` equals `epsW`, so the index 1 is a real
  sign-of-operator index.
- `OverlapIndexGaugeInvariance.lean` (`overlapIndex_conj`, `SignCertificate.conj`):
  the overlap index is INVARIANT under unitary conjugation and the certificate
  transports covariantly - the guardrail that a nonzero index cannot come from a
  gauge/basis conjugation, only a genuine signature change.
- `OverlapHoppingSignWitness.lean` (`signCertificate_HU2_epsW`,
  `HU2_isHermitian`, `signCertificate_HU2_unique`): strengthens the join from a
  diagonal domain wall to a genuinely NON-diagonal hopping operator
  `HU2 = epsW.(C^H C)` (PSD for free; `HU2_offDiagonal` witnesses
  non-diagonality).  The operator is now explicitly gapped/Hermitian and has
  unique certified sign `epsW`, so the certificate is not special to diagonal
  operators. Caveat: `C` is real (flat connection, no holonomy).
- `FlagshipOperatorIndex.lean` (`flagship_operatorIndex_isInteger`): the C1<->C2
  KEYSTONE - bundles the C1 flagship `sign(Hfree)` and chirality `Gamma5op` as
  finite `ℂ`-linear endomorphisms (new `signHfree_add/_smul` linearity +
  `matrixFieldAction` add/smul/comp/one), each an End-involution, and instantiates
  the End-integrality so the free tetrahedral chiral OPERATOR overlap index is a
  well-defined integer.  Connects the two gates end to end.
- `FlagshipOperatorIndexZero.lean` (`flagship_operatorIndex_eq_zero`): the exact
  VALUE - the flagship operator index equals 0 (traceless chirality, Wilson band).
  End-trace = site-sum of kernel-diagonal spin-traces (`trace_signHfreeL` via
  `Pi.basis` + the kernel representation; `trace_Gamma5opL = card.Tr gamma5`),
  each diagonal block traceless.  The free benchmark now holds at all three
  levels: symbol, certified-integer, operator value. `operatorIndex_eq_sum_density`
  is the finite structural sum rule: operator index = site-sum of local density.
- `FluxOverlapIndex.lean` (`plaquette_gauge_invariant`, `overlapIndex_flux`,
  `overlapIndex_noflux`, `flux_shifts_index`,
  `flux_is_nonzero_integer_witness`): Aristotle job `f3296d38`, ported. A
  `pi`-flux triangle has gauge-invariant holonomy `-1`, a certified rational
  sign for its gapped hopping Hamiltonian, overlap index `-1`, zero-flux
  triangle index `+1`, and `Delta=-2` response to flux insertion. Honest scope:
  the odd 3-cycle has a parity index at every flux, so this is a genuine flux
  response witness, not yet the even-lattice zero-to-nonzero index.

Design brief (Aristotle c36ea1a8): index `= -(1/2) sig(eps_U)`, so a NONZERO index
needs a genuine signature change (Wilson mass across zero), not a flat/tree
connection. The first genuine nonzero-FLUX witness is now the `pi`-flux triangle.
SUCCESSOR: an even-lattice / 2D-torus Wilson-Dirac flux model with a
zero-to-nonzero index, then the anomaly/index-density bridge. The tracked oracle
`Scripts/oracle/validate_flux2d_wilson_dirac.py` pins the current finite target
(`L=4,m=-1,Q=1`, total flux `4`, index `4`, four `8 x 8` blocks of signature
`-2`) as design evidence, not proof. The `H^2=coeff.I` scalar-square shortcut
breaks under such a background - the certified-sign interface
(`SignCertificate`) is how `sign(H_U)` is pinned without a functional calculus.

## Tracks

- **Day track (critical path):** finish `TetraFreeOperatorGap_equalN` ->
  full Fourier diagonalization -> finite/free operator gap ->
  self-adjointness -> only then the sign/GW layer. No new active-proof scope.
  All new ideas queue behind this. Aristotle-driven per `docs/ARISTOTLE.md`.
- **Night/slack track (Lean, zero C1 interference):** the I1 stack, then I2,
  then the Gate D finite stack (D1, D2, D6, then D3.0), then Lambda1'.1-2.
  All finite matrix algebra, Mathlib-only Aristotle packages. Output =
  papers P2 and the D-note.
- **Paper-level track (no Lean dependency):** L0.1 no-go proof attempt; Q2
  massless calibration numerics (now including the D3.1 modular-defect
  measurement as a fourth deliverable); the Q2 literature check; the D8
  positivity probe.
- **Community track:** one contact email to PhysLean maintainers offering P2;
  establish arXiv endorsement route; small Mathlib/PhysLean PRs as calling
  cards.

## Decision points and kill conditions

- **C1 gap fails:** switch to the pre-registered obstruction-paper framing
  (joins the Bedaque et al. no-go genre). Not a program failure.
- **L0.1 proves false** (a Lorentz-invariant finite-valency ensemble exists):
  pleasant shock; revisit the ontology revision. The proof attempt is cheap
  either way.
- **Lambda1' projection fails** (bookkeeping cochain's harmonic part does not
  project onto the relative volume class under Dirichlet boundary
  conditions): the Lambda story dies cleanly. This is the designed kill test.
- **Q2 finds a finite-spacing QNEC violation:** publishable discovery about
  discretization, not a failure. All three Q2 outcomes are papers.
- **P9 moonshot (verified first law -> Einstein equation of state):** attempt
  only if the Q2/P3 Gaussian theorem lands AND the type I / type III
  continuum-limit problem (F-M2) shows a tractable handle. Otherwise it stays
  a named target.

## Publication mapping (short)

| Paper | Content | Gate dependency | Sequence |
|-------|---------|-----------------|----------|
| P2 | Verified kinematic dictionary + I3.5 + U(2) factorization | I1, I1.7-I1.9, I2, A2, I3 | first (wedge) |
| P8 | Expository companion (matrix-analysis kinematics) | P2 content | with/after P2 |
| P5 | Semantic auditing of AI-generated Lean physics | existing toolkit | opportunistic |
| P1 | Verified chiral lattice fermion (or obstruction) | C1 | flagship |
| P3 | Discrete QNEC | Q2 (+ Q1 formalized) | after P2 code exists |
| P6 | Discrete (relative) Hodge + Lambda note | Lambda1' | after wedge |
| D-note | "The first law is an identity; the content is universality" + modular defect | D1-D3 | after wedge; on-ramp to P9 |
| P4 | Program paper (hardened v2.1 treatise) | P1 + P2 landed | last |
| P9 | Verified first law -> Einstein (moonshot) | P3 theorem + F-M2 progress | gated, unscheduled |

## Watch items

- **Slogan drift.** The informational slogans (time is modular, gravity is
  DPI, mass is entanglement) are postulates or IMPORTs unless the named gate
  is closed. Every physics sentence in a task note should be traceable to a
  gate and a claim label.
- **Terminology audit.** Pre-v2.1 files (including Gate C1 Lean docstrings
  and release plans) may still speak v1 language ("null edges" as primitive
  finite adjacency, exact invariance). When touching such a file, align its
  claims with this roadmap; do not mass-rewrite otherwise.
- **F-M2 (type I vs type III)** is the program's hard analytic problem.
  Nothing on the current ladder touches it except Q2's Gaussian theorem
  attempt. Keep it visible; do not let program papers imply it is solved.
- **Unnormalized vs normalized.** Mass-invariance statements live at the
  level of unnormalized `P` (`det P = m^2`); normalized states know only
  `m/E`. Language: "Plucker norm / unnormalized concurrence". Never claim
  frame invariance for `det rho`.

## One-line priority

C1 critical path by day; Gate I1 in Lean by night; one email to PhysLean;
buy the two cheap insurance policies (C0 audit, L0.1 attempt) this month.
