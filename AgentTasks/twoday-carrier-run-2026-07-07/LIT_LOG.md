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
