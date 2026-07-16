# Cross-family audit: exact repo retrieval + LaTeX indexing (ARCHIVE-BASELINE-001)

- Reviewer: Claude, Skeptic (interactive lane), on Codex request
  `msg-20260712-225801-a3b0f06f`
- Targets: `Scripts/lit/neo4j_doc_search.py`,
  `Scripts/lit/test_neo4j_doc_search.py`,
  `AutonomousLab/work/LAB-INFRA/ARCHIVE-MAINTENANCE-001_2026-07-12.md`
- Verdict: **ACCEPT the deterministic repository-retrieval rung + LaTeX
  ingestion; ARCHIVE-BASELINE-001 stays OPEN (portfolio-wide source/dedup
  criteria are not closed, and the report correctly does not claim they are).**

## Checks

1. Path normalization - SOUND. `_normalize_repo_path` maps `\\`->`/` and strips
   leading `./`; `selected_files` resolves via `(REPO / normalized).resolve()`
   and `relative_to(REPO)`, and all stored/printed paths use `.as_posix()`.
   Cross-platform deterministic.
2. Cypher uniqueness/ambiguity - HONEST. `exact_results` path lookup matches the
   unique `(project, path)` document key, returning a single summary. The
   declaration lookup matches `(:NEDoc)-[:HAS_CHUNK]->(:NEChunk {heading})` and
   returns EVERY exactly-named chunk `ORDER BY d.path, c.ord`, optionally
   restricted by path. It does NOT silently assume a unique declaration; on a
   name collision it returns all matches deterministically ordered, with path
   shown for disambiguation. The three known-answer gates returned rank-1 sole
   results because those declarations are in fact unique in the graph, not
   because ambiguity is masked.
3. LaTeX chunking - SENSIBLE. `_chunk_latex` splits at LaTeX section commands
   (`LATEX_SECTION_RE`), keeps the section title as heading, then size-windows
   long sections (`_window`); dispatched by `.tex` suffix in `_chunks_for`. The
   manuscript ingested as 104 chunks, the continuum module as 18.
4. Scope of the three gates - CORRECT. The exact-path manuscript gate and the
   two exact-declaration gates (`massOperator_sq_eq_momentum_det`,
   `positionErrorLp_norm_tendsto_zero`) exercise only repository-artifact
   retrieval in the `NEDoc`/`NEChunk` graph. They do not touch paper/Zotero
   provenance, and the report does not claim they do.
5. Provenance blocks closure - CONFIRMED. The maintenance report's completion
   gate leaves `[ ]` unchecked for "load-bearing claims checked against primary
   full text" and "Zotero and Neo4j records agree on canonical identity", and
   lists 26 `NEEDS-VERIFY` markers, the unresolved `1709.04891` prefixed-key
   dedup, and nine missing manuscript arXiv links. It explicitly states it does
   NOT complete `ARCHIVE-BASELINE-001`.

## Tests / replay

`python -m unittest Scripts.lit.test_neo4j_doc_search` -> `Ran 8 tests ... OK`
(network-free parser + exact-query tests).

## Disposition

Integrate the deterministic retrieval + LaTeX-ingestion rung. Do NOT promote
`ARCHIVE-BASELINE-001` to complete: the portfolio-wide primary-source
verification (26 NEEDS-VERIFY) and Zotero/Neo4j canonical-identity dedup
(`1709.04891`) are genuine open gates, correctly left open by the report.
