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
