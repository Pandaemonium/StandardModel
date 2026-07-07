# Literature + Neo4j protocol (two-day carrier run)

Literature work is a first-class cadence, not decoration: the carrier program is
DELIBERATELY standing on prior art (Weitzenbock/Lichnerowicz, Osterwalder-Seiler,
Penrose partition scheme, spinor-helicity, Witten's positive-energy proof), and
the run's rule is **read before you rebuild**. The Neo4j graph is both the memory
(reference it) and the deliverable (grow it).

## 1. Cadence and ownership

- **One lit round every 60-90 minutes**, alternating: Claude on odd hours, Codex
  on even hours. Each round is logged as a numbered entry in this run's
  `LIT_LOG.md` (same style as the overnight run's `LIT_SEARCH_LOG.md`: what was
  searched, what was ingested with Zotero keys, one-line relevance to a LIVE
  thread, and explicitly "nothing new" when true).
- A round is GENUINE only if it feeds a live thread (a statement, a route choice,
  a convention check) or honestly reports null results. A round that pastes
  abstracts nobody uses is theater.

## 2. The two access modes (pick by question, not habit)

- **Exact queries** (by arxiv_id / doi / title / tag / traversal / dedup):
  the `neo4j_graph` MCP server (Cypher). It has NO embedder - never use it for
  "what's relevant to X".
- **Meaning queries:** the vector scripts.
  - `Scripts/lit/neo4j_paper_search.py --query "..."` - ranks abstracts (WHICH
    papers matter).
  - `... --chunks` - ranks full-text body chunks (WHERE in a paper the lemma /
    constant / convention lives). **Whenever a formalization decision depends on
    a paper's internal content - a bound's exact form, a sign convention, a
    proof step - use `--chunks`, never trust the abstract.**
  - `Scripts/lit/neo4j_doc_search.py` - this repo's own docs + Lean (refresh it
    after meaningful doc edits).
- If Neo4j is down (connection refused), start it headless per the
  `neo4j-headless-start` memory note before falling back to web search.

## 3. Reading before building (the binding rule)

Before formalizing ANY statement derived from a paper:
1. `--chunks` search the graph for the exact lemma/inequality/convention.
2. If the paper is not in-graph, ingest it FIRST (sec 4), then chunks-search.
3. Record in the module docstring: the paper key(s) (bare Zotero key), the
   statement's location (section/eq. number if the chunks give it), and the
   convention delta between the paper and the repo.
A module that formalizes paper content with no key in its docstring fails
cross-review.

## 4. Ingest pipeline (adding to the graph)

```bash
PY="C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
"$PY" Scripts/lit/lit_ingest.py <arxiv_id> [<arxiv_id> ...] \
    --collection 9W59V3K9 --tag twoday-carrier
```

- Dedup is keyed on arxiv_id/doi (the script skips existing entries - "skipped"
  is success, not failure). Canonical `paper_key` = bare Zotero item key.
- Scoped search REQUIRES the `IN_COLLECTION` edge to `9W59V3K9` - always pass
  `--collection`.
- Non-arXiv items (books, CMP papers without arXiv): add via Zotero with DOI
  where possible; if the pipeline cannot ingest full text, log the reference in
  `LIT_LOG.md` with its citation data anyway and mark `[NO-FULLTEXT]` so the
  docstring cite is still exact.
- Meta-search for discovery: `python Scripts/mcp/mcp_call.py scholarly
  search-papers --args '{"query": "...", "limit": 6}'` (rate-limited - if a
  round hits the limit, do the ingest-and-cite half and defer discovery).

## 5. The run's priority reading list (pre-queued; ingest early, cite in modules)

Day 1 priorities (central citations of live threads):
- **Osterwalder-Seiler 1978** (Ann. Phys. 110) + **Seiler LNP 159** - OS1's
  source theorem. [NO-FULLTEXT likely; cite exactly anyway]
- **O. Penrose 1967** (partition scheme) + **Scott-Sokal** (in-graph:
  cond-mat/0309352) + **Faris 2010** - the KP crux route.
- **Witten 1981** (CMP 80, positive energy) - the E/gravity slot's continuum
  avatar; needed for honest E-slot interface docstrings.
- **Friedan 1982** (CMP 85) + **Banchoff 1967** - higher-d N-N / discrete degree.
- **Chelsea Edmonds, LLL AFP entry (Isabelle 2023)** - the formalized-LLL
  skeleton relevant to KP-via-LLL; log as reference (not ingestible as paper).
- Already in-graph, reference by key: Chamseddine-Connes 1004.0464 (8HGA475I),
  Shen-Zhu-Zhu 2204.12737 (5NACST85), AHH 1709.04891, Kanazawa 0808.3442,
  Luscher hep-lat/9802011, lattice index 1905.03963.

Day 2 / opportunistic:
- **Loring** finite-dim almost-commuting-matrices K-theory + Prodan-Schulz-Baldes
  (the finite-matrix index toolbox for NNIndexExact-in-d).
- **Jacobson-Schulman 1984** (checkerboard) - the canonical 1+1d toy for the
  carrier; **Penrose-Perjes-Hughston** two-twistor particles; **Pasterski-Shao-
  Strominger** (celestial - ApertureEntropy's home).
- **Cao-Park-Sheffield** random-surface Wilson loops + **Chatterjee** "YM for
  probabilists" - C-lane horizon-scanning.
- **Tomboulis-Yaffe 1985** (CMP 100, 313) - the rigorous RP inequalities; needed
  for Codex's lineage audit of the 0808.3442 route.

## 6. Search themes per thread (seed queries; refine from results)

- W1/W2: "Weitzenbock formula discrete/graph Dirac operator", "lattice Clifford
  Bochner", "Krein space Dirac operator indefinite metric mass".
- OS1/QC: "strong coupling expansion lattice gauge mass gap explicit radius",
  "character expansion Wilson action convergence bound", "transfer matrix
  spectral gap lattice gauge strong coupling".
- KP: "cluster expansion convergence tree equality Penrose", "abstract polymer
  model Fernandez Procacci improvement".
- AT/aperture: "massive spinor helicity bound state two null momenta little
  group", "celestial sphere massive conformal primary".
- B-lane: "noncommutative geometry finite spectral triple Yukawa internal Dirac",
  "octonions standard model color commutant".

## 7. Weekly-graph hygiene within the run

- No duplicate nodes: pre-add existence check keyed on arxiv_id/doi (never title).
- Tag everything `twoday-carrier` so the run's graph delta is queryable; the
  FINAL_REPORT lists the delta (papers added, keys, which modules cite them).
- If a paper turns out to be the WRONG reference (wrong convention, disputed
  result - e.g. decimation-lineage confinement claims), do not delete: tag the
  caution in `LIT_LOG.md` and the relevant docstring so nobody re-adopts it.
