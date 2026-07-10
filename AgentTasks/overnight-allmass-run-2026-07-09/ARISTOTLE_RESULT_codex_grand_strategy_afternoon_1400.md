# Grand strategy — null-edge all-mass, afternoon 2026-07-09

Report only. No Lean files were edited in this job. Inputs read: RUN_PLAN.md
(secs 0–10), LEDGER.md, `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md`,
`Sources/Null_Edge_Future_Directions.md`, `Sources/Null_Edge_References.md`,
`AgentTasks/solo-run-2026-07-08/HARVEST_LOG.md`, the semantic context pack, and
a direct scan of the `PhysicsSM/Draft/NullEdge` module tree (capstone bodies
inspected). Grades used are the manuscript's own T / M / MEMO / C calculus.

---

## 1. The single unifying object

**The object is one finite positive-semidefinite Hermitian form — the null-edge
Gram `P = M Mᴴ = Σᵢ ψᵢ ψᵢᴴ` — and its single scalar invariant, the spectral
rank-defect measured on the Krein-positive sector (quantitatively `det P`, via
Cauchy–Binet).** Everything the program calls a "face" is a functional of this
one form; the four flagship suites are four readings of *the same PSD matrix and
its least positive eigenvalue*.

Why this is the right primitive rather than "the carrier Dirac operator `D`":
`D` is *a construction of `P`*, not a peer of it. The kernel already proves the
reduction both ways — `free_mass_operator_eq_plucker` (`P · adj P = det P • 1`)
and `GroundMassDetFamilyLaw` (`det P = μ₋·(tr − μ₋)`, exact over the whole
`(λ,κ)` family) — so `D#D`'s physical content collapses onto a spectral
statement about `P`. Choosing `P` as the primitive is what lets the five faces
be *theorems about one object* instead of five analogies.

How the one invariant subsumes each face:

- **Kinematic.** `P` is the little-group spinor momentum matrix; Cauchy–Binet is
  literally `det P = Σᵢ<ⱼ |ψᵢ ∧ ψⱼ|²` (`fin_bundle_plucker_mass_identity`).
  `mass² = det P`, `massless ⇔ rank 1 ⇔ det 0`. The invariant is *area opened in
  spinor space*; `DetPUniqueness` shows the determinant is the unique
  null-vanishing quadratic form, so the choice is forced, not aesthetic.
- **Path-sum / dynamics.** The carrier compression is the block `B(λ,κ)` whose
  least eigenvalue is `λ−κ` (`B_least_eigenvalue`), i.e. the same rank-defect
  read spectrally; unitary evolution `exp(−itB)` and the rational RG flow
  `R(λ,κ)` act on the *coordinates* of `P`'s compression, and the massless
  critical line `|κ|=λ` is exactly rank collapse of the compressed `P`.
- **Information.** The spinor `P` *is* an (unnormalized) qubit density matrix, so
  the identical determinant reads as `4 det P = C²` (Wootters concurrence),
  `det P = (G/n)ⁿ` (G-concurrence), and `S_lin = 2 det` (linear entropy). "Mass"
  and "retained which-null-direction information" are the same number.
- **Gravity / resource.** Resource-free states are the rank-1 Grams (`det P=0`);
  mass is the rank-defect = resource/compression cost. Gravity enters as the
  *gradient of the map `M` that builds `P` from null edges*: the soldering-gradient
  defect `E` (`weitzenbock_master_varying`) measures non-constancy of that
  build, which is why it is a genuinely different block from the matter channels.

So the deepest invariant to foreground is **rank(`P`) / `det P`: mass is the
squared volume a bundle of null directions opens in spinor space, equivalently
the least eigenvalue of the Krein-positive compression of the null-edge Gram.**
Recommend the manuscript state this once, early, as "one form, five readings,"
and derive §3a/§4/§6/§7 as corollaries rather than as parallel developments.

---

## 2. Five missing theorems, ranked by (impact × feasibility)

Ranking rule: each converts a *named grade-C or MEMO headline into M*, or removes
a load-bearing gap in the spine of §1. Declarations are sketches for handoff.

### T1. Path-sum = kernel (checkerboard combinatorial identity), exact in `ℚ(i)`
- **Statement.** `∑_{h : histories A→B} amp h = K A B`, where
  `amp h = (i·ε·m)^(corners h)` and `K` is the landed closed-form kernel; plus
  the one-step tie to the discrete Dirac recursion. Corollary "turn verdict":
  `m = 0 ⇒ support = straight histories only`.
- **Seed imports.** `CheckerboardKernelClosedFormsAristotle`,
  `CheckerboardCornerPolynomialAristotle`, `CheckerboardSpinorRecursionAristotle`,
  `CheckerboardCarrierBridge`; represent `ℚ(i)` as `Zsqrtd (-1)` localized (no
  analytic `Complex`).
- **Nondegenerate witness.** `t = 3` lattice point with ≥1 corner; kernel entry
  computed both ways, nonzero, visibly `m`-dependent; the `m=0` collapse witness.
- **Kill.** Any lattice point where the history sum ≠ the closed-form kernel.
- **Grade.** M for the finite identity; the Feynman/Jacobson–Schulman *reading*
  stays `[import]`. **This is the single highest-value buildable theorem**: it
  turns "the propagator IS the sum over null histories" from analogy into a
  kernel theorem and gives the turn channel its exact phase face.

### T2. Concrete carrier rigidity — the four-block split is a property of the object
- **Statement.** Instantiate `GradedDecompUniqueness.decomposition_unique` on the
  concrete Cl(4) carrier: the split `2(D#D) = Q_A + Q_C + 2E_# + 2Q_T` is the
  unique grade-typed decomposition of the carrier's own square under the stated
  interface hypotheses — or exhibit a distinct split satisfying them, promoting
  `split_not_forced`.
- **Seed imports.** `CarrierRigidity` (type-count forced, no fifth block),
  `GradedDecompUniqueness`, `UnifiedMassBudget`, `CliffordAssembly`,
  GateYM guard files.
- **Nondegenerate witness.** The `(2,1)` Cl(4)⊗ℂ³ carrier with its verbatim
  `J(Q_A+Q_C)` form; the four blocks carry distinct even/odd Krein grades.
- **Kill.** A genuinely distinct split obeying all interface properties.
- **Grade.** M (uniqueness on the concrete carrier) OR a sharpened no-go. Either
  outcome upgrades "unification is decomposition" from the *type-count* standard
  the manuscript currently qualifies to (§4) to an *object-property* standard.

### T3. Interacting binding invariant `Δ` — the §3↔§4 tie across the whole family
- **Statement.** Define `Δ` as the exact drop of `leastEigenvalue(D#D)` below
  `det P` for interacting carriers and prove it is a closure-controlled,
  off-diagonal finite invariant: on the carrier block, `Δ_block(λ,κ) = −κ`, and
  the general interacting bound `leastEig = det P − Δ` with `Δ ≥ 0`, `Δ` a
  function of the off-diagonal (closure) data alone.
- **Seed imports.** `GroundMassDetFamilyLaw`, `BindingDefect`
  (`blockBindingDefect_eq_neg_kappa`), `BindingEntanglementDeficit`
  (`Δ = C(ρ)·λ`), `FreeMassBridge`.
- **Nondegenerate witness.** A carrier with `κ ≠ 0` where `Δ > 0` strictly and a
  free control (`κ = 0`) where `Δ = 0` and `leastEig = det P`.
- **Kill.** An interacting carrier where the eigenvalue exceeds `det P` (binding
  becomes anti-binding) or `Δ` depends on diagonal/aperture data.
- **Grade.** M. Closes the last named grade-C item on the kinematic↔dynamic
  bridge (§4 rail 3, §10 crux); makes the "one invariant" thesis of §1 exact for
  interacting carriers, not just free ones.

### T4. Finite Higgs mechanism as a dichotomy (WAY constructive half)
- **Statement.** Exhibit a dim-≥2 charge-coherent ancilla and an explicit
  unitary (in `ℚ` or `ℚ(i)`) implementing the chirality-flip gate with *exact*
  isospin conservation on system+ancilla; conclude the turn channel operates iff
  coupled to a charge-coherent reservoir (with `WAYTurnNoGo.way_nogo` as the
  negative half).
- **Seed imports.** `WAYTurnNoGo` (`way_nogo`,
  `chirality_requires_nontrivial_ancilla`), `ChiralProjectorsDirac`.
- **Nondegenerate witness.** The explicit reservoir unitary with a chirality
  flip and `[U, Q_total] = 0` verified as a matrix identity; a control showing a
  trivial (dim-1) ancilla fails.
- **Kill.** No finite-dim ancilla achieves exact conservation (⇒ strengthened
  no-go, also publishable).
- **Grade.** M. Upgrades §5's Higgs channel from MEMO to a structural theorem —
  the one MEMO in the manuscript spine.

### T5. Mass = failure of the chirality and energy splits to commute
- **Statement.** For the covariant Dirac operator, `[P_L, Λ±] ≠ 0 ⇔ m ≠ 0`, with
  the exact limit form `2m·[P_L, Λ+] = [P_L, p̸]`.
- **Seed imports.** `ChiralProjectorsDirac`, the mass-shell projectors module
  (`Λ± = (p̸ ± m)/2m`, N0 harvest), `DiracGammaPhysLean`.
- **Nondegenerate witness.** A single rational 4×4 momentum with `m ≠ 0` giving a
  nonzero commutator entry, and the `m = 0` vanishing control.
- **Kill.** The commutator vanishes for some `m ≠ 0`, or is nonzero at `m = 0`.
- **Grade.** M. Cheapest of the five; an elegant one-line addition to the
  kinematic spine ("mass is exactly the obstruction to simultaneously splitting
  chirality and energy"), complementing `mass = {γ5, D}` already landed.

**If only one is funded: T1.** If two: T1 + T3 (they make §1's unifying claim
both dynamical and exact). T2, T4, T5 are the next tier.

---

## 3. Capstones that are composition interfaces vs. genuine payload

The tree has ~30 `*Capstone`/`*Flagship`/`*Mesh` modules. Inspected bodies show
most are **conjunctions (`∧`) of already-proved imported theorems** — valuable as
"one file that states the whole story builds together," but they are *interfaces,
not new mathematics*, and must not be cited as headline theorems.

- **Pure composition interfaces (do not headline).**
  `AllMassMasterCapstone`, `AllMassGrandMeshCapstone`
  ("strong composition theorem, not a new physics claim" — its own docstring),
  `GrandMassCapstone` (contains `True` marker conjuncts — a smell; strip these),
  `GravityUnificationCapstone`, `ParticleMassMechanismMasterCapstone`,
  `SuiteCDMasterCapstone`, `LambdaGravityResourceMasterCapstone`,
  `KMC3FlagshipCapstone`, `CarrierDynamicsRGInformationCapstone`,
  `GoalIVReconciliationCapstone`, `HolographicResourceCapstone`,
  `UnifiedActionCapstone`, `MassPhaseRGCapstone`, `GrandMassCapstoneUnconditional`.
  These prove `A ∧ B ∧ …` where each conjunct is discharged by an existing lemma;
  their epistemic weight equals the *weakest* conjunct, which is often only
  witness-level. Keep them as build-integration smoke tests; cite the underlying
  lemmas, never the mesh.

- **Genuine mathematical payload (the real spine).**
  - Kinematic: `PluckerMass` family (`two_edge_plucker_mass_identity`,
    `fin_bundle_plucker_mass_identity`), `MassNullDecomposition` (converse),
    `DetPUniqueness`, `RankCeiling`, `MassMonogamy`.
  - Organizing square: `carrier_krein_square` and `CarrierRigidity`
    (four-block, no fifth) — genuine; but read at the type-count standard until T2.
  - Positivity keystone: `sector_ground_mass` (finite Rayleigh–Ritz) and its
    instantiation `T2_positive_mass` — the linchpin that makes the budget a mass.
  - Phase diagram: `MassGapWitness` (`B_least_eigenvalue`, `B_posDef_iff`,
    `B_spectrum`, `B_massless_iff_of_pos`) — a complete, exactly-solvable
    three-phase theorem; the strongest single dynamical result.
  - Bridges that are payload, not conjunction: `free_mass_operator_eq_plucker`,
    `GroundMassDetFamilyLaw`, `BindingDefect`.
  - Reconstruction rungs with content: `SignatureForcing`, `RPSelectsLorentzian`,
    `DivisionDimensionSelection`, `SpectralDistance`, `FiniteCPT`.
  - Suite-C payload: `ConfinementPositivity`, `WindingLowModes`, `chiralindex`,
    `IncidenceCorank` (general-N corank `(N-1)(N-2)/2`), `FiniteKMCP`
    (N=2 no-go + exact N=3 Jarlskog witness).
  - No-gos (payload as negatives): `FamilyIndexNoGo`, `FamilyRankNoGo`.
  - `KMFlagship.physicalPhases_eq_incidence_corank` is a *borderline* case: it is
    stated as a flagship but contains a real identification (phase count = graph
    corank), so cite the identity, not the summary bundle.

**Action.** For the P-A paper, cite only the payload list; relabel every
`*Capstone`/`*Mesh` in the anchor table as "build-integration bundle
(composition of cited lemmas)" so no referee reads a conjunction as a theorem.

---

## 4. Strongest honest framing

**Title.** *Mass as a Spectral Rank-Defect: A Finite, Machine-Verified Theorem
that Every Mass is the Disagreement of Massless Edges.*

**Abstract thesis (one paragraph, all M).** For any finite bundle of light-speed
degrees of freedom, the invariant mass squared equals the determinant of the
null-edge Gram `P = Σ ψᵢψᵢᴴ`, which by Cauchy–Binet is the total pairwise
disagreement of their directions; this correspondence is bidirectional (every
timelike momentum decomposes into null edges) and the determinant is the unique
null-vanishing invariant. A single finite Krein-adjoint square `4 D#D` decomposes
into exactly four grade-typed channels (no fifth block), and on an explicit Cl(4)
carrier a finite Rayleigh–Ritz theorem turns the aperture–closure block into a
genuine positive squared mass with an exactly-solvable three-phase diagram
(massive / massless-critical / over-closure) whose gap is `λ−κ`. All statements
are kernel-checked in Lean 4 under a pinned toolchain with audited axiom
footprints. Identification of the four channels with the Standard Model's mass
mechanisms is stated as a pre-registered conjecture with explicit kill
conditions and is *not* claimed.

**Six-section spine.**
1. **One form, five readings.** `P`, `det P`, the rank-defect invariant; the
   "mass is trapped disagreeing light" picture stated once and made the organizing
   object (§1 of this report).
2. **The kinematic theorem (T/M).** Cauchy–Binet identity, bidirectionality,
   `DetPUniqueness`, rank-2 ceiling; the information re-reading (concurrence /
   entropy) as corollaries of the *same* determinant.
3. **The carrier square (M).** `carrier_krein_square`, four-block rigidity
   (type-count; object-property pending T2), the honest "chosen grouping"
   caveat.
4. **From form to mass (M).** Rayleigh–Ritz keystone + `T2_positive_mass`; the
   phase diagram `B(λ,κ)`; the `det P = μ₋(tr−μ₋)` family-law tie and the binding
   defect (T3).
5. **Reconstruction rungs and no-gos (M / no-go).** Signature, RP-selects-one-time,
   division-algebra→d=4, finite CPT; the general-N CP corank and the
   *three-generations-not-forced* no-go, reported with equal prominence.
6. **Outlook: the reconstruction program (C).** Suites A–D, the channel-name
   conjecture, the continuum decision point, and the event horizon (no absolute
   mass scale, no Born rule, no edge count) stated verbatim.

Sections 1–5 are the defensible paper; section 6 is explicitly conjectural and
carries nothing into the title or abstract.

---

## 5. Three overclaim risks most likely to survive into LaTeX

1. **"Unification is decomposition" read as canonical/unique.** The kernel proves
   only *type-count forcing* (four blocks, no fifth), and full uniqueness is
   *refuted* without an extra axiom (`CarrierRigidity` no-go). A LaTeX sentence
   like "the four forces are the four summands of the one square" will be read as
   canonical. **Repair:** every occurrence must say "four channel *types* are the
   only ones the square admits (a chosen grade projection, normalization factors
   not algebra-fixed); the split is not unique without a further axiom." Land T2
   to strengthen; until then, do not drop the qualifier.

2. **Channel names presented as physics.** `Q_C` = "QCD", `Q_T` = "Higgs",
   `E` = "gravity" are grade-C structural analogies; under `hCov` the turn block
   is indistinguishable from a constant Dirac mass, and no continuum reduction is
   proved. The names will read as identifications in prose. **Repair:** in the
   paper (as opposed to the program document) use neutral coordinates
   `A, C, T, E` in all theorem statements and figures; introduce the physical
   names once, explicitly flagged C, in the outlook only. The kill condition
   (T1/N3 dispersion) must be printed next to the first physical name.

3. **`det P = mass²` overreach beyond rank 2 / beyond the spinor `P`.** Three
   traps the audit already flagged but that migrate easily into a headline: (a)
   `P` is the little-group *spinor* matrix, not the Lorentzian Gram of the two
   null 4-vectors (whose determinant has the wrong sign and dimension); (b) the
   determinant reading is intrinsically rank ≤ 2 — at spin ≥ 3/2 the invariant is
   the pairwise `pᵢ·pⱼ`, not one determinant (`RankCeiling.rank3_det_ne_pairwise`);
   (c) `det P` is phase-blind, so CP/Majorana phases and `θ_QCD` live outside it.
   **Repair:** state "spinor/PSD `P`, rank ≤ 2, modulus only" as a standing
   hypothesis banner on the kinematic theorem, and keep the neutrino/CP bullets
   labeled *structural*, never *predictive*.

Secondary watch item: `GrandMassCapstone`'s `True` conjuncts and the `*Mesh`
bundles must not appear as cited theorems (see §3).

---

## 6. Decision: finite theorem, reconstruction program, or conditional model?

**Present it primarily as a finite theorem, with the reconstruction program as an
explicitly-labeled outlook, and the conditional physical model excluded from the
headline entirely.** Reasoning:

- The *conditional physical model* framing (leading with "the Standard Model's
  masses come from null-edge channels") is grade C throughout; by the paper's own
  rule "a title graded C is an error," so it cannot lead. It also invites exactly
  the three overclaim risks of §5.
- The *reconstruction program* framing (Suites A–D as the deliverable) overclaims
  by construction: Suite A's full Lorentzian recovery, Suite B's continuum
  universality, Suite C's generation forcing, and Suite D's full resource theory
  are all unproved, and the event horizon guarantees several never close. Selling
  the program as the result would be the largest honesty violation available.
- The *finite theorem* framing is what the grades license: a self-contained,
  kernel-checked result — mass is a spectral rank-defect of the null-edge Gram;
  every mass decomposes into massless edges; one finite square splits into four
  forced channel types; a finite Rayleigh–Ritz theorem makes the budget a
  positive mass with an exactly-solvable phase diagram. This is a genuine,
  defensible, priority-worthy artifact (cf. the machine-verified-QFT moment the
  run plan cites), and it stands independently of any physics identification.

Concretely: ship **P-A as the finite-theorem paper** (RUN_PLAN N1), keep
`Null_Edge_All_Mass_Manuscript` as the program document that hosts the
reconstruction outlook and the conjectures, and let the conditional physical
model live only inside clearly-fenced grade-C discussion. The single sentence the
program is allowed to aspire to — "spacetime, particles, forces, and mass are the
decodable geometry, codewords, defects, and compression costs of finite null
information" — belongs in the outlook, at grade C, and nowhere near the abstract.

---

### One-line summary
Foreground the null-edge Gram `P` and its rank-defect `det P` as the single object
all five faces compute; ship the finite theorem (P-A), cite payload lemmas not
capstone conjunctions, land T1 (path-sum = kernel) and T3 (interacting binding
invariant) first, and keep every channel-name and reconstruction claim fenced at
grade C.
