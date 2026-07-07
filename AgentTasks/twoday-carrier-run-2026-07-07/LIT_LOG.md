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
