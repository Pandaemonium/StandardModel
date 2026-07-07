# Literature log (two-day carrier run) - numbered rounds

Protocol: `LIT_NEO4J_PROTOCOL.md`. Each round: what was searched, what was
ingested (with Zotero keys), one-line relevance to a LIVE thread, and honest
"nothing new" when true. Chunks-search the graph BEFORE formalizing paper content;
cite keys in docstrings.

## Round 1 (pre-launch, overnight agent) - carrier citation coverage confirmed

Vector search (`neo4j_paper_search.py --query`) confirmed the graph already carries
the Move-1 Weitzenbock citations - the "reference existing Neo4j literature" the run
requires. Meta-search discovery was down this round (rate-limited); reliable local
vector search used instead.

- **hep-th/9503153 [BQJAG9TR]** "The generalized Lichnerowicz formula and analysis
  of Dirac operators" (1995), score 0.862 - THE continuum Weitzenbock/Lichnerowicz
  reference. **W1 docstrings must cite this** for `D^#D = ... + curvature` provenance.
- **0708.3707 [2DEG7MT2]** "First order approach and index theorems for discrete and
  metric graphs" (2007), 0.740 - the DISCRETE-graph Dirac/index analogue; the closest
  prior art for a discrete Weitzenbock on a 1-/2-complex. W1 brick-2 design reference.
- **2203.02782 [WW6TKVH8]** "Laplace and Dirac Operators on Graphs" (2022), 0.731 -
  discrete Dirac on graphs; secondary W1 reference.
- **1610.01142 [TN53N8J2]** "Spin on a 4D Feynman Checkerboard" (2016), 0.729 - the
  checkerboard-as-null-zigzag toy Fable flagged as the canonical 1+1d carrier model;
  relevant to the AT bridge + the E-slot.
- **hep-lat/9808010 [BEG87SU5]** Neuberger overlap locality - already a T-lane cite.
- Also surfaced: math-ph/0110001 (semi-Riemannian/NCG geometry - Krein `#` context),
  hep-th/9603202 (discrete Dirac).

Action items for the run: (1) W1 modules cite [BQJAG9TR] + [2DEG7MT2]; (2)
`--chunks` search [BQJAG9TR] for the exact Lichnerowicz curvature-term form before
stating the E-slot; (3) discovery meta-search still owes the reading-list ingest
(Osterwalder-Seiler, Witten PET, Loring) - retry with direct arxiv ids next round.

## Live rounds (append below)

## Round 2 (Claude, cycle 1) - NEW brick-2 scaffold: gauge networks

Search (`--chunks --query`): "discrete Weitzenbock Bochner formula lattice Dirac
operator Clifford covariant difference holonomy plaquette". Confirms Round-1 refs and
adds ONE genuinely new, high-value scaffold:

- **arXiv:1301.3480 - "Gauge networks in noncommutative geometry"** (Marcolli-van
  Suijlekom) [NEW; key TBD, resolve before docstring cite]. chunk 27 gives a FINITE
  GRAPH Dirac operator with edge holonomies `U_e` and continuum limit
  `holonomy = e^{...}(1 + l·nabla_e + O(l^2))` - essentially the carrier's discrete
  home `D = sum_e c(alpha_e) nabla_e` with `nabla_e` the covariant edge difference.
  **The cleanest existing scaffold for W1 brick 2 (minimal 2-complex + covariant
  nabla).** Cross-check Fable's call-01 structure against it.
- **hep-th/9503153 [BQJAG9TR]** re-confirmed (chunk 2): `D = c(nabla)` for a
  Clifford-module connection is the essential input to the generalized Lichnerowicz
  formula - the continuum backing where the curvature endomorphism = our `Q_C`.
- Lower priority (lattice Clifford/Dirac): Dirac-Kahler geometric discretization
  (arXiv:0706.4385), minimally doubled fermions (arXiv:1706.07104).

ACTION: cite 1301.3480 + [BQJAG9TR] in the brick-2 docstring; feed both into the
call-01 digest as ground truth to check Fable's proposed covariant-nabla structure.
Resolve the 1301.3480 Zotero key (ingest if not already keyed) before the cite.

## Round 3 (Codex, cycle 1) - OS1 finite-gauge route citations

Fable call-01 chose the OS1 first rung: finite-gauge character/polymer prototype
before SU(2) Haar. Searches:

- Neo4j exact DOI/title check for Osterwalder/Seiler records: no existing graph
  nodes for `10.1016/0003-4916(78)90039-8` or `10.1007/3-540-11559-5`.
- Chunk search (`--chunks`): "Osterwalder Seiler strong coupling expansion mass
  gap lattice gauge theory character expansion transfer matrix". The current
  null-edge full-text index does **not** contain the OS/Seiler classics, so no
  chunk-level theorem location is available yet.
- Abstract vector search: "strong coupling character expansion lattice gauge
  theory mass gap transfer matrix". Relevant existing graph hits: Tomboulis-Yaffe
  lineage [K9FIBTZC] 0808.3442, Shen-Zhu-Zhu [5NACST85] 2204.12737, rigorous
  large-N strong-coupling SO(N) [VF8RP8WQ] 1502.07719, plus Z2 Wilson-loop
  material [T2Z3STSB] 1811.09770.
- Crossref discovery found the missing priority citations:
  `10.1016/0003-4916(78)90039-8` ("Gauge field theories on a lattice") and
  `10.1007/3-540-11559-5` (Seiler, *Gauge Theories as a Problem of Constructive
  Quantum Field Theory and Statistical Mechanics*, LNP 159).

Ingested / graph delta:

- **SMH5768W** - Osterwalder-Seiler 1978, "Gauge field theories on a lattice",
  DOI `10.1016/0003-4916(78)90039-8`, Zotero + Neo4j `Paper`, collection
  `9W59V3K9`, tags `twoday-carrier`, `OS1`, `strong-coupling`, `no-fulltext`.
- **UARD9T5Q** - Seiler LNP 159 (1982), DOI `10.1007/3-540-11559-5`, Zotero +
  Neo4j `Paper`, collection `9W59V3K9`, same tags, marked `no_fulltext=true`.

Caution: I accidentally called the arXiv add path for already-present
Shen-Zhu-Zhu 2204.12737 and created duplicate Zotero item **75USBIZ8**. The graph
already uses canonical key **5NACST85**; do **not** cite or sync the duplicate.
Manual Zotero cleanup needed.

Action for OS1/QC modules: cite **SMH5768W** + **UARD9T5Q** for the classic
strong-coupling/constructive gauge-theory provenance, and **5NACST85** only as
the rejected functional-inequality route with explicit `|beta| < 1/(16(d-1))`
not chosen for the Lean first rung.

## Round 4 (Claude, cycle 2) - torus Q_C shift-exchange mechanism

Search (`--chunks`): "lattice gauge covariant finite difference commutator plaquette
curvature holonomy noncommutative torus shift operator". New torus-Q_C references
(both in-graph):

- **arXiv:hep-lat/0309120 - "Dirac-Kahler fermion with noncommutative differential
  forms on a lattice"** [key TBD]. chunk 1: the lattice difference `d(fg) =
  (partial_+ f) g(x+mu) dx + f partial_+ g dx` - the NON-LEIBNIZ rule is exactly the
  shift-exchange `T_a M(V) = M(V o tau_a) T_a` that Fable's torus Q_C path-difference
  lemma relies on; chunk 5: gauge field via Clifford product, `F = dA + A^2` 2-form
  curvature = the discrete plaquette Q_C. **The algebraic mechanism for the torus Q_C
  brick.**
- **arXiv:2212.05621 - "Dirac gauge theory for topological spinors in 3+1d networks"**
  chunk 8: square of the network Dirac operator = Laplacian matrices; anti/commutators
  nonzero in general - a discrete `D^2` decomposition precedent on a network.

ACTION: cite hep-lat/0309120 in the torus-Q_C module for the shift-exchange identity;
resolve its Zotero key before the cite.

## Round 5 (Claude, cycle 3) - Krein # structure + chirality grounding

Search (`--chunks`): "Krein space indefinite metric Dirac operator positive sector
physical subspace J-self-adjoint reflection positivity Osterwalder-Schrader". The
canonical framework for the Krein brick (`krein_square_form` + `positivity_transfer`)
AND for the Q_T brick's chirality Gamma - both in-graph:

- **arXiv:1210.6575 - "Temporal Lorentzian Spectral Triples"** [key TBD]. chunk 4:
  the Krein-adjoint `A^+` via the Krein product, Krein-self-adjointness `A=A^+`, and
  `A^+ = eta A* eta` (fundamental symmetry eta). **The exact `#`-adjoint structure**
  for `D^#D`; cite in the Krein brick.
- **arXiv:1812.00038 - "Semi-Riemannian NCG, Gauge Theory, and the SM" (thesis)**
  [key TBD]. chunks 75/79: the DEFINITION of an indefinite spectral triple
  `(A, K, D, Gamma, J)` on a Z2-graded spinor Krein space; **the chirality `Gamma`
  is a bounded involution `Gamma^2 = 1` with `Gamma^+ = (-1)^q Gamma`** - exactly the
  `hGammaSq`/`hGammaAnti` structure of my Q_T brick `CarrierPotentialTurn`. Grounds
  BOTH bricks; cite in Q_T (Gamma provenance) and the Krein brick.
- **arXiv:math-ph/0110001** (semi-Riemannian NCG) chunk 13: the fundamental-symmetry
  construction from the metric splitting; secondary Krein reference.

ACTION: cite 1210.6575 + 1812.00038 in the Krein brick and Q_T docstrings; these are
the honest home of the "no spectral positivity until kernel-checked" rail (the
positive physical sector is exactly the indefinite-spectral-triple positive-cone
question). Resolve both Zotero keys before the cites.

## Round 6 (Claude, cycle 3) - E-slot gap (Witten PET) + AT zig-zag refs

Search (`--chunks`): "Witten positive energy theorem spinor Dirac Weitzenbock boundary
term ADM mass Lichnerowicz curvature nonnegative".

- **GAP (honest null):** Witten's positive-energy theorem (CMP 80, 1981) - the E/gravity
  slot's continuum avatar (ADM mass = boundary term of a Dirac Weitzenbock identity) - is
  **NOT in the full-text graph**. No arXiv (predates arXiv). ACTION: when the E-slot brick
  is drafted, add Witten 1981 via Zotero by DOI, mark `[NO-FULLTEXT]`, and cite by
  reference in the docstring (the honest continuum backing for `E` = the gravity slot).
  The generalized Lichnerowicz formula [BQJAG9TR] hep-th/9503153 remains the in-graph
  backing for the curvature/`E` term.
- **NEW (AT/T-lane):** **arXiv:1107.4909 "The zig-zag road to reality"** chunk 9 - the
  massive Dirac equation in the Weyl rep as two coupled Weyl equations ("a massive Dirac
  electron = two Weyl spinors", Penrose zig-zag). The exact prior art for the AT bridge /
  T-mode (mass = flip rate between two null modes); cite in the AT thread + Q_T.
- **arXiv:1610.01142 "Spin on a 4D Feynman Checkerboard"** [BEG.../TN...] - the 4D null-
  face checkerboard; the canonical carrier toy model (already noted round 1).

ACTION: cite 1107.4909 in the AT-bridge module; ingest Witten 1981 (DOI, NO-FULLTEXT)
when the E-slot brick lands.

## Round 7 (Codex, cycle 3) - TY-lineage audit

Search / exact check:

- Web/Springer/Crossref-style discovery for Tomboulis-Yaffe 1985 identified
  **"Finite Temperature SU(2) Lattice Gauge Theory"**, Communications in
  Mathematical Physics 100, 313-341 (1985), DOI `10.1007/BF01206134`.
- Neo4j exact DOI/title check returned no existing node before ingest.
- Existing graph already had Kanazawa 0808.3442 as **K9FIBTZC**, the SU(N)
  generalization/notation layer used by the current TY modules.

Ingested / graph delta:

- **N7SIEMAC** - Tomboulis-Yaffe 1985, DOI `10.1007/BF01206134`, Zotero + Neo4j
  `Paper`, collection `9W59V3K9`, tags `twoday-carrier`, `TY-LINEAGE`,
  `reflection-positivity`, `no-fulltext`.

Audit verdict:

- Current `TYAreaLaw`, `TYAreaLawSUN`, and `TYTwistSystemZ2` use only the
  rigorous reflection-positivity / Cauchy-Schwarz inequality shape and finite
  center-twist algebra. Kanazawa [K9FIBTZC] is used for SU(N) generalization and
  notation. No current TY theorem depends on disputed decimation-based
  all-coupling confinement claims. Docstrings updated accordingly.

## Round 8 (Codex, cycle 5) - OS1 priority citation audit

Exact graph / literature check:

- Neo4j exact title/DOI check confirms **SMH5768W** is already present:
  Osterwalder-Seiler 1978, "Gauge field theories on a lattice", DOI
  `10.1016/0003-4916(78)90039-8`.
- Neo4j exact title/DOI check confirms **UARD9T5Q** is already present:
  Seiler LNP 159 (1982), "Gauge Theories as a Problem of Constructive Quantum
  Field Theory and Statistical Mechanics", DOI `10.1007/3-540-11559-5`.
- INSPIRE confirms the same OS 1978 metadata and Seiler 1982 title; Semantic
  Scholar-backed search returned HTTP 429, so no new metadata was trusted from
  that endpoint this round.

Graph delta: none.  The priority OS/Seiler ingests requested by the Codex goal
prompt are already complete; future OS1/QC docstrings should cite **SMH5768W** and
**UARD9T5Q** rather than re-ingesting.  `QCLeading.lean` now cites those keys plus
the TY lineage key **N7SIEMAC**.

## Round 9 (Codex, cycle 8) - lane-C generalized-symmetry reframing

Searches:

- `neo4j_paper_search.py --query "1-form center symmetry confinement lattice gauge
  theory center vortices Tomboulis Yaffe Wilson loops" --k 6`
- `neo4j_paper_search.py --query "DeGrand Toussaint lattice monopoles plaquette
  flux quantization H2 U(1) finite lattice gauge theory" --k 6`
- `neo4j_paper_search.py --chunks --query "Tomboulis Yaffe center twist reflection
  positivity 1-form center symmetry Wilson loop order parameter" --k 6`
- after ingest: `neo4j_paper_search.py --query "Generalized Global Symmetries
  one-form center symmetry Wilson loops confinement Gaiotto Kapustin Seiberg
  Willett" --k 6`

Graph delta:

- **AXAWAGGB** - Gaiotto, Kapustin, Seiberg, Willett, "Generalized Global
  Symmetries", arXiv:1412.5148, ingested into collection `9W59V3K9` with tags
  `twoday-carrier`, `generalized-symmetry`, `one-form-center-symmetry`.

Relevance to live C/QC threads:

- The pre-ingest scoped search surfaced the older center-vortex / TY-adjacent
  papers already in graph (`IB8F3BSP`, `T2Z3STSB`, `K9FIBTZC`) but not GKSW.
  After ingest, `AXAWAGGB` is the top paper-level hit for the modern one-form
  center-symmetry framing. The chunk search was noisy and did not give a clean
  formal lemma location, so this is **framing provenance only**, not a theorem
  source for the current Lean area-law/QC modules.
- `NULLEDGE_PROGRAM_AND_EXTENSIONS.md` now cites **AXAWAGGB** for Fable's
  suggested reframing of `H²(K,Z(G))` center-twist data as a 1-form
  center-symmetry background. No trusted Lean theorem was changed.

## Round 7 (Claude, cycle 8) - grounding the two Fable top-pick threads

Search (`--chunks`): teleparallel gravity + Pontryagin/Krein positivity (the G-TELE and
KREIN-POS threads seeded from Fable's extension guidance).

- **arXiv:1204.4339 - "Teleparallel Gravity as a Higher Gauge Theory"** [in-graph].
  chunk 19 [Torsion and the coframe field] + chunk 16 [teleparallel geometry / Poincare
  2-group]. Grounds G-TELE (torsion = coframe/tetrad gradient = the E-slot brick target
  `T_ef = nabla_e alpha_f - nabla_f alpha_e`) AND is a CONFLUENCE: it ties Fable's
  teleparallel-E reading to the higher-gauge-theory extension (doc sec 4.3/7.6) - the
  Poincare 2-group is the natural home of both. Cite in G-TELE.
- **arXiv:1505.01939 - "Krein spectral triples and the fermionic action"** [in-graph].
  chunk 4 [Krein spectral triples]. New reference for the Krein square + the fermionic
  (mass) action; complements 1210.6575 / math-ph/0110001 (Krein # structure). Cite in
  CarrierKreinSquare + KREIN-POS.
- **GAP (honest):** the Pontryagin-space invariant-subspace theorem (Pontryagin 1944;
  Krein-Langer) - the KREIN-POS top pick's FOUNDATIONAL result (J-self-adjoint operator on
  Pi_kappa has an invariant maximal non-negative subspace) - is NOT in the full-text graph.
  ACTION: ingest a Pontryagin/Krein-Langer reference (Bognar "Indefinite Inner Product
  Spaces", or Azizov-Iokhvidov) before the KREIN-POS brick; likely [NO-FULLTEXT], cite by
  reference. This is the finite-dim linear-algebra fact that upgrades the positivity crux.

## Round 10 (Codex, cycle 10) - C-1FORM partition-bridge grounding

Searches:

- `neo4j_paper_search.py --query "one-form center symmetry background H^2 Z(G)
  lattice gauge center twist Wilson loop" --k 6`
- `neo4j_paper_search.py --chunks --query "center twist partition function
  Z^[k] one-form symmetry background 't Hooft flux lattice gauge" --k 6`
- `neo4j_doc_search.py --query "CenterFluxSector TwistSystem configuration
  partition bridge one-form center symmetry" --k 8`
- `neo4j_paper_search.py --query "Generalized Global Symmetries one-form center
  symmetry Wilson loop confinement" --k 6`

Graph delta: none.

Findings:

- Paper-level search confirms **AXAWAGGB** (GKSW, arXiv:1412.5148) remains the
  relevant modern framing reference for one-form center symmetry, but chunk
  search was noisy for the exact finite partition-bridge lemma. This supports
  using GKSW only as terminology/framing in the current Lean layer.
- The exact TY/Kanazawa notation remains the already-cited `TYAreaLawSUN`
  lineage: **N7SIEMAC** for the rigorous Tomboulis-Yaffe RP-inequality lineage
  and **K9FIBTZC** for the SU(N) center-twist partition-ratio notation.
- Repo doc search pointed back to the corrected Aristotle C-1FORM strategy:
  the honest missing object is the configuration-to-partition bridge, not a new
  value-level `TwistSystem` constructor. This round therefore feeds the new
  `CenterOneFormTwistBridge.lean` contract: finite sums over configurations
  produce a `TwistSystem` once nonnegativity, periodic positivity, and `Z_le`
  are supplied; deriving `Z_le` from a real measure remains OPEN.

## Round 11 (Codex, cycle 11) - QC carrier-readout bridge grounding

Searches:

- `neo4j_doc_search.py --query "QCLeading QCCarrierBridge
  leadingClosureFluxCoeff carrier readout" --k 8`
- `neo4j_paper_search.py --query "Tomboulis Yaffe partition ratio Osterwalder
  Seiler transfer gap tanh beta" --k 6`

Graph delta: none.

Findings:

- The doc search mostly surfaced older null-edge readout work rather than a new
  `Q_C` bridge precedent. It does not change the QC bridge shape.
- The paper vector search was noisy and did not surface a cleaner theorem
  source than the already-audited OS/TY lineage. The new
  `QCCarrierBridge.lean` module therefore cites the same finite `Z2`
  scalar-normalization provenance as `QCLeading`: **SMH5768W**,
  **UARD9T5Q**, and **N7SIEMAC**.
- No new literature claim is introduced. The bridge is a parameterized
  carrier-readout contract over the landed scalar coefficient, not a measure,
  expectation, nonabelian, or beyond-leading positivity theorem.

## Round 12 (Codex, cycle 12) - QC torus attachment provenance / non-conflation rail

Searches:

- `neo4j_doc_search.py --query "QCCarrierTorusAttachment mZero_iff_commute
  plaquetteCurvature leading readout curvature scalar separation" --k 8`
- `neo4j_paper_search.py --query "gauge networks lattice Dirac operator
  plaquette holonomy curvature covariant difference" --k 6`
- `neo4j_paper_search.py --chunks --query "lattice covariant difference
  plaquette holonomy commutator path difference gauge networks" --k 6`

Graph delta: none.

Findings:

- Paper search pointed back to already-in-graph sources: **DCIW87IM**
  (Gauge networks in noncommutative geometry, arXiv:1301.3480),
  **GU9K5KKW** (Dirac-Kahler fermion with noncommutative differential forms on a
  lattice, arXiv:hep-lat/0309120), and **SMH5768W** (Osterwalder-Seiler 1978).
  No new ingest was needed.
- Chunk search for the torus-curvature side again surfaced gauge-network /
  quiver / lattice-covariant-difference context, not a scalar leading-readout
  theorem. This supports keeping `QCCarrierTorusAttachment.lean` as a
  bookkeeping instantiation plus scalar-free `mZero_iff_commute` re-export.
- Repo doc search reinforced the non-conflation rail: curvature depends on the
  chosen hidden/gauge transport, and older readout lemmas do not license a
  theorem deriving the scalar `leadingClosureFluxCoeff` from
  `plaquetteCurvature`. The new module therefore introduces no literature claim
  beyond the already-cited Carrier torus and `QCLeading` provenance.

## Round 13 (Codex, cycle 13) - OS1 two-plaquette finite fixture

Searches:

- `neo4j_doc_search.py --query "OS1 two plaquette KP condition positive area
  slice StrongCouplingPolymerMap plaquetteKPBound singletonBound zero coupling
  finite fixture" --k 8`
- `neo4j_paper_search.py --query "cluster expansion Kotecky Preiss polymer gas
  strong coupling lattice gauge finite plaquette expansion" --k 6`
- `neo4j_paper_search.py --chunks --query "Kotecky Preiss condition sum
  incompatible polymers exponential size bound singleton polymer activity
  cluster expansion" --k 8`
- `neo4j_paper_search.py --chunks --query "Penrose tree graph identity polymer
  model partition scheme Kotecky Preiss fiber factorial bound" --k 8`

Graph delta: none.

Findings:

- Repo doc search was noisy and did not surface a stronger OS1 precedent than
  the live `StrongCouplingPolymerMap` API itself.
- Paper search again identified the existing abstract polymer/cluster expansion
  spine: **SI5BD9GT** (Procacci 2006), **SU9UUNB6** (Procacci 2007),
  **254FV2U8** (Fernandez-Procacci proof), and **SMH5768W** (Osterwalder-Seiler
  1978). No new source is needed for the finite zero-coupling sanity check.
- Chunk searches were not useful for the exact two-plaquette Lean fixture. That
  supports keeping the new rung as finite bookkeeping only: zero coupling kills
  the Z2 coefficient, discharging the positive-area slice hypotheses without
  claiming volume-uniform KP convergence, SU(2), or a mass gap.

## Round 14 (Codex, cycle 14) - QC exact finite-cycle Z2 readout

Searches:

- Initial command typo: the scripts use `--k`, not `--top-k`; rerun with the
  correct flag.
- `neo4j_doc_search.py --query "Z2 transfer matrix plaquette expectation tanh
  beta finite torus error term QC leading readout" --k 5`
- `neo4j_paper_search.py --query "Z2 lattice gauge transfer matrix plaquette
  expectation tanh beta finite torus" --k 5`
- `neo4j_paper_search.py --chunks --query "Z2 lattice gauge theory plaquette
  expectation tanh beta transfer matrix finite volume" --k 5`
- `neo4j_paper_search.py --read T2Z3STSB --no-sections`

Graph delta: none.

Findings:

- Repo doc search was noisy and mostly surfaced unrelated Pauli/E8/null-edge
  chunks rather than a better QC finite-cycle theorem precedent.
- Paper search resurfaced **SMH5768W** (Osterwalder-Seiler 1978) and
  **T2Z3STSB** (Wilson loops in Ising lattice gauge theory, 2018), but the
  latter has no local full-text chunks. It is therefore not used as theorem
  support here.
- Chunk search was noisy and did not supply a reliable exact-formula passage.
  The new `QCTwoStateCycleReadout.lean` result is framed as a clean-room finite
  transfer calculation over the existing `TwoStateTransferZ2L1` definitions,
  with the existing OS/TY scalar-chain provenance inherited from `QCLeading`.
