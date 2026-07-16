# Archive maintenance report: deterministic repository retrieval

## Metadata

- Work item: `ARCHIVE-BASELINE-001`
- Archivist/model: Codex
- Date: 2026-07-12
- Search topic or collection: active Null-Edge manuscript and formal anchors
- Related projects: `LAB-INFRA`, `NE-CONTINUUM`, Paper A

## Search record

- Exact question: Can the repository knowledge graph deterministically return
  the active LaTeX manuscript and named canonical Lean declarations, without
  relying on semantic-vector rank?
- Databases and indexes searched: Neo4j `NEDoc` / `NEChunk` document graph and
  vector index `ne_chunk_embedding`.
- Queries: exact path for the active Area-to-Dirac-gap manuscript; exact
  declaration for `massOperator_sq_eq_momentum_det`; exact declaration for
  `positionErrorLp_norm_tendsto_zero`.
- Date range and stopping rule: current worktree on 2026-07-12; stop after all
  three preregistered known answers return uniquely or one fails after a
  targeted refresh.
- Abstract search performed: no; this rung concerns repository artifacts.
- Full-text/chunk search performed: yes, exact document and declaration chunks.

## Sources added or updated

No paper or Zotero source was added or modified. The repository document graph
was extended to ingest LaTeX and refreshed for two exact current artifacts.

| Canonical key | DOI/arXiv ID | Zotero action | Neo4j action | Full text | Convention note |
|---|---|---|---|---|---|
| `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex` | n/a | none | 104 chunks ingested | yes | Manuscript claim labels and conventions retained verbatim. |
| `PhysicsSM/Draft/NullEdge/ChangingCellFourierL2.lean` | n/a | none | 18 chunks ingested | yes | Fourier-domain Euclidean bridge remains distinct from the repository `Momentum3` sup norm. |

## Deduplication and provenance

- Duplicate candidates inspected: the existing `1709.04891` duplicate remains
  `5J5XDKMN` versus `SZJE69PE` / legacy graph key `zotero:SZJE69PE`.
- Merges or rejected additions: no merge and no addition; destructive Zotero
  deduplication was outside this bounded rung.
- Claims whose source support changed: none.
- Missing primary sources: the ten exact graph gaps listed in
  `ARCHIVE-BASELINE-001_inventory_2026-07-12.md` remain open.
- License or access concerns: none introduced; only repository-owned text was
  indexed.

## Index health

- Zotero records sampled: service health and title-search samples from the
  baseline report; no write performed.
- Neo4j paper nodes sampled: exact arXiv coverage from the baseline report; no
  paper-node write performed.
- Broken identifiers or links: one prefixed legacy `paper_key` and ten missing
  exact arXiv links remain.
- Missing chunk embeddings: the flagship LaTeX manuscript was wholly absent
  before this repair; it now has 104 chunks. The continuum capstone now has 18.
- Document index refresh command/result:

  ```powershell
  $env:PYTHONUTF8 = '1'
  & 'C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe' `
    Scripts/lit/neo4j_doc_search.py `
    --path Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex `
    --path PhysicsSM/Draft/NullEdge/ChangingCellFourierL2.lean
  ```

  Result: 2 files and 122 chunks ingested; vector index ensured.
- Paper index refresh command/result: not run; paper deduplication and canonical
  linkage remain a separate mutation rung.

## Retrieval check

The new exact mode is deterministic and does not load the embedding model.
Each expected artifact returned as the sole result.

| Query | Expected source | Rank | Pass |
|---|---|---:|---|
| `--exact-path Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex` | active Paper A LaTeX source | 1 | yes |
| `--exact-path PhysicsSM/Draft/NullEdge/PluckerMassOperator.lean --exact-declaration massOperator_sq_eq_momentum_det` | canonical mass-operator identity | 1 | yes |
| `--exact-path PhysicsSM/Draft/NullEdge/ChangingCellFourierL2.lean --exact-declaration positionErrorLp_norm_tendsto_zero` | continuum F1 position-space convergence capstone | 1 | yes |

Network-free parser and exact-query tests:

```text
python -m unittest Scripts.lit.test_neo4j_doc_search
Ran 8 tests ... OK
```

## Source debt and next actions

- Highest-risk unsupported or secondary-only claim: the current source-debt
  registry still contains 26 `NEEDS-VERIFY` markers; these require claim-level
  primary-text checks, not merely metadata repair.
- Next literature pass: resolve the nine remaining manuscript arXiv gaps after
  linking Zotero item `8RZQA73D` to `2404.09840`.
- Maintenance issue requiring escalation: select and merge the canonical
  Zotero item for `1709.04891`, then remove the invalid prefixed graph key under
  the documented dedup protocol.

## Completion gate

- [x] Canonical identifiers were checked before adding records.
- [ ] Load-bearing claims were checked against primary full text.
- [x] Convention mismatches for the refreshed formal anchor were recorded.
- [ ] Zotero and Neo4j records agree on canonical identity.
- [x] Search and maintenance actions are reproducible from this report.

This report completes the deterministic repository-retrieval rung. It does not
complete `ARCHIVE-BASELINE-001`, whose stronger portfolio-wide source and dedup
criteria remain open.
