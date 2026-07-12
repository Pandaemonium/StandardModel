# Literature and knowledge system

## 1. Ownership

The Archivist owns search, source verification, Zotero/Neo4j hygiene, semantic
index refresh, public Lean-package discovery, and source-debt reporting. The
Scientist decides how verified sources enter a claim; the Skeptic audits that
use.

## 2. Two search modes

Use the tool that matches the question:

- **Exact graph queries:** `neo4j_graph` MCP/Cypher for arXiv ID, DOI, title,
  author, collection, tag, citation/traversal, counts, and deduplication.
- **Semantic search:** `Scripts/lit/neo4j_paper_search.py` for papers,
  `--chunks` for full-text passages, and `neo4j_doc_search.py` for repository
  docs/Lean.

The paper graph cannot rank meaning through Cypher alone. Abstract search finds
candidate papers; full-text chunk search supports claims about internal
derivations, lemmas, and conventions.

## 3. Search-to-ingestion workflow

```text
question
-> broad multi-database discovery
-> exact arXiv/DOI dedup check
-> primary full-text retrieval
-> theorem/hypothesis/convention extraction
-> skeptical/contradictory-source search
-> Zotero add/update and collection placement
-> Neo4j paper/chunk linkage
-> literature memo and active-work disposition
-> semantic-index refresh
```

Before adding a paper:

- canonical `paper_key` is the bare Zotero item key;
- normalize arXiv ID and DOI;
- deduplicate by identifier, not fuzzy title alone;
- record open-access source and version;
- never log credentials.

## 4. Lean and software archive

Before local API invention, search:

- `lean-lsp` local/Mathlib search;
- `lean-explore` Mathlib and `packages=["Physlib"]`;
- reference packages recorded in the repository survey;
- exact local declarations and documentation map.

Record repository URL, commit/version, Lean version, license, module/file,
convention mismatch, and whether use is import, clean-room port, or idea only.

## 5. Cadence

### Daily

- search each executing work item's unresolved source question;
- triage new relevant papers;
- clear duplicate candidates and broken identifiers;
- append source consequences to the work item/ledger.

### Weekly

- refresh document and paper semantic indexes after meaningful changes;
- inspect uncited load-bearing manuscript claims;
- review retractions, corrections, and new versions;
- update nearest-work maps for release candidates;
- report Zotero/Neo4j health and source debt.

### Quarterly

- audit collection scope and orphan nodes;
- sample graph records against primary sources;
- archive superseded internal documents with status tags;
- review whether search practices are missing a field, language, or skeptical
  literature stream.

## 6. Knowledge graph quality metrics

- duplicate rate by arXiv/DOI;
- percentage of load-bearing claims with primary full-text anchors;
- orphan paper/chunk/document nodes;
- stale repository-document embeddings;
- source records missing conventions or licenses;
- time from new relevant paper to triage;
- rate at which nearest-work review changes a novelty claim.

## 7. Failure handling

If Neo4j, Zotero, scholarly search, or semantic indexes are unavailable, record
the degraded path and continue with direct primary-source search. Do not imply
the knowledge graph was updated. Repair jobs are lab-infrastructure work items,
not invisible maintenance.
