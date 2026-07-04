# Four-day YM run: literature log

Append-only verification notes for claim language, source provenance, and
attribution debt. Web lookups are evidence for bibliographic existence and
abstract-level scope only; theorem hypotheses still need source-internal review
before they support a formal statement.

## 2026-07-04 11:18 - Codex - RP/KP source verification slice

### Menotti/Pelissetto Wilson-action OS positivity source

Status: VERIFIED EXISTENCE AND ABSTRACT-LEVEL SCOPE.

Sources checked:

- Springer: P. Menotti and A. Pelissetto, "General proof of
  Osterwalder-Schrader positivity for the Wilson action", Communications in
  Mathematical Physics 113, 369-373 (1987), DOI `10.1007/BF01221251`,
  https://link.springer.com/article/10.1007/BF01221251
- OSTI/ETDE record with matching title/authors/volume/pages/date:
  https://www.osti.gov/etdeweb/biblio/6021032

Finding:

The source exists and is the likely "Menotti-style" source mentioned in the
external review. Its abstract says it extends Osterwalder-Seiler reflection
positivity for lattice gauge theories with fermions to reflection planes
containing sites, applies to all observables, relies on the Wilson action, and
gives positivity for gauge-invariant `F`.

Claim boundary:

This can support a future statement such as "Menotti and Pelissetto prove an
Osterwalder-Schrader positivity result for Wilson-action lattice gauge theories
with fermions, extending Osterwalder-Seiler to site-containing reflection
planes." It should NOT yet be used as direct support for this repo's exact
finite-group, pure-gauge, link-reflection, mirror-coordinate formalization
until the paper's internal reflection convention is checked against
`ReflectionPositivityKernel` / RP-KER.

### Osterwalder-Seiler lattice gauge source

Status: VERIFIED EXISTENCE AND ABSTRACT-LEVEL SCOPE.

Sources checked:

- ScienceDirect: K. Osterwalder and E. Seiler, "Gauge field theories on a
  lattice", Annals of Physics 110(2), 440-471 (1978), DOI
  `10.1016/0003-4916(78)90039-8`,
  https://www.sciencedirect.com/science/article/pii/0003491678900398
- INSPIRE bibliographic record:
  https://inspirehep.net/literature/120117

Finding:

The source exists. The abstract says it discusses lattice approximation of
Yang-Mills and fermion fields in Euclidean setup, verifies physical positivity
for the Schwinger functions of these approximations, and implies a positive
self-adjoint transfer matrix.

Claim boundary:

This supports Osterwalder-Seiler as the primary historical source for lattice
gauge physical/reflection positivity and transfer-matrix positivity. Before any
paper-unit claim says our formalization follows their exact theorem, inspect
the paper's internal definitions: reflection plane, gauge group scope, fermion
treatment, transfer-matrix construction, and whether the positivity notion is
link- or site-reflection in this repo's terms.

### Kotecky-Preiss abstract polymer source

Status: VERIFIED EXISTENCE, DOI, AND ABSTRACT-LEVEL SCOPE.

Sources checked:

- Springer: R. Kotecky and D. Preiss, "Cluster expansion for abstract polymer
  models", Communications in Mathematical Physics 103, 491-498 (1986), DOI
  `10.1007/BF01211762`,
  https://link.springer.com/article/10.1007/BF01211762
- Project Euclid landing/PDF metadata found by search:
  https://projecteuclid.org/journals/communications-in-mathematical-physics/volume-103/issue-3/Cluster-expansion-for-abstract-polymer-models/cmp/1104114796.pdf

Finding:

The primary source exists with the expected journal, pages, and DOI. Its
abstract says it gives a direct proof of convergence of cluster expansions for
abstract polymer/contour models, and notes that considered clusters contain
each polymer at most once. That "at most once" phrase is relevant to Q6's
cluster-encoding decision and should be checked against the full text before
choosing between sequences with repetitions, multisets, or finite sets.

Claim boundary:

The bibliographic citation is safe. The exact Lean theorem statement is not yet
safe: Q6 should wait for the Aristotle strategy job and/or full-text review
before freezing the conclusion, especially around repeated-polymer clusters,
Mayer/Ursell normalization, and the exponential tail hypotheses.

### Fernandez-Procacci modern tree-graph source

Status: VERIFIED EXISTENCE AND ABSTRACT-LEVEL SCOPE.

Sources checked:

- arXiv: Roberto Fernandez and Aldo Procacci, "Cluster expansion for abstract
  polymer models. New bounds from an old approach", arXiv `math-ph/0605041`,
  https://arxiv.org/abs/math-ph/0605041

Finding:

The arXiv abstract explicitly says the paper revisits cluster expansions based
on tree graphs and establishes a convergence condition improving Kotecky-Preiss
and Dobrushin. This is a suitable modern source for the tree-graph-bound route
being considered in Q6, but its conditions are not identical to the original KP
statement.

Claim boundary:

Use this as a modern proof-plan source for a tree-graph-bound formalization, not
as evidence that the original Kotecky-Preiss theorem itself was tree-graph based.

### Tooling notes

- `mcp__scholarly.search_papers` hit an HTTP 429 from Semantic Scholar for the
  Menotti/Pelissetto query, so the slice used web search plus primary publisher
  and bibliographic records.
- INSPIRE's Menotti/Pelissetto page requires JavaScript in the fetched view, but
  the search result still matched the Springer title and bibliographic data.

## 2026-07-04 11:17 - Codex - graph/ingest and source-internal access addendum

Status: INGEST DEBT IDENTIFIED; ONE MODERN FULL-TEXT SOURCE ACCESSIBLE.

Graph pre-add checks:

- Direct Neo4j driver checks by stable id returned no existing `Paper` rows for
  Menotti/Pelissetto `10.1007/BF01221251`, Osterwalder-Seiler
  `10.1016/0003-4916(78)90039-8`, Kotecky-Preiss
  `10.1007/BF01211762`, or Fernandez-Procacci `math-ph/0605041`.
- `Scripts/lit/lit_ingest.py math-ph/0605041 --dry-run` returned
  `would-add` for Fernandez-Procacci, confirming that the arXiv paper is
  eligible for the normal ingest path.
- Actual ingest was not attempted: this Codex session's `.mcp.json` exposes
  only `lean-lsp` and `lean-explore`, and those entries point at
  `C:/Projects/EisensteinGoldbach`, so the Zotero writer server needed by
  `lit_ingest.py` is unavailable here. This is tooling debt, not a source
  judgment.

Source-internal access:

- Project Euclid PDF URLs for Kotecky-Preiss and Menotti/Pelissetto returned
  Incapsula anti-bot HTML when fetched from the shell, so they were not treated
  as source-internal evidence.
- Springer DOI PDF endpoints redirected to article-preview pages. The preview
  pages are adequate for bibliographic and abstract-level scope only; they do
  not expose the full proof text without institutional/purchase access.
- The Fernandez-Procacci author PDF is accessible. Its text confirms the
  intended modern route more strongly than the abstract alone: it frames
  polymer gases via an incompatibility graph, defines clusters using connected
  incompatible subgraphs, states absolute/uniform convergence consequences,
  and gives a later tree-bound proposition using rooted-tree expansions. It
  should be used as the modern tree-graph proof-plan source, not as a claim
  that Kotecky-Preiss itself used tree combinatorics.

Claim boundary update:

The run may cite the CMP and Annals papers by title/DOI and abstract-level
scope, but should not say the current Lean statements implement their exact
theorems until full text is obtained and checked. For Q6 statement design,
Fernandez-Procacci supports a tree-graph lemma DAG and KP-comparison language;
the original Kotecky-Preiss exact hypotheses remain a full-text review item.
