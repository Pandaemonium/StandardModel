# Archivist Baseline: Active Manuscripts and Research Indexes

Date: 2026-07-12
Role activation: `role-20260712-224012-6ef0ebe6`
Work item: `ARCHIVE-BASELINE-001`
Operator: Codex Archivist

## Scope

This is a read-only baseline of the active publication artifacts and the
Neo4j/Zotero retrieval path. It does not promote manuscript claims, modify
Zotero, merge graph nodes, or assert that a citation supports a claim merely
because a matching record exists.

Active artifacts inspected:

- `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex`
- `Sources/Null_Edge_Cosmological_Constant_Manuscript_Draft_2026-07-12.tex`
- `Sources/Null_Edge_Program_Overview_Packet_2026-07-12.tex`
- `Sources/Null_Edge_General_Audience_Manuscript_2026-07-09.tex`
- `Sources/Null_Edge_References.md`

## Bibliography Inventory

| Artifact | Bibliography status | Immediate finding |
| --- | --- | --- |
| Area-to-Dirac-gap manuscript | 23 `bibitem` keys and 23 cited keys | No missing or unused keys in the LaTeX source. |
| Cosmological-constant manuscript | Manual reference list | No `bibitem`/`cite` key system to audit mechanically. |
| Program overview packet | Manual reference list | No `bibitem`/`cite` key system to audit mechanically. |
| General-audience manuscript | 12 `bibitem` keys | 2 keys are cited and 10 are currently unused. |
| `Null_Edge_References.md` | Source-debt registry | 78 `TBD-`, 24 `KEYED-LOCAL`, 39 `ID-ONLY`, and 26 `NEEDS-VERIFY` markers. |

The flagship paper's bibliography is syntactically coherent. This does not yet
make it source-complete: canonical identifiers, graph records, and
claim-to-source support still require a semantic audit.

## Neo4j and Zotero Coverage

The Area-to-Dirac-gap manuscript contains 17 arXiv-backed bibliography items.
Exact Neo4j lookup found seven identifiers:

| arXiv ID | Graph/Zotero key | Note |
| --- | --- | --- |
| `1303.1199` | `9QPIHJEW` | Exact graph hit. |
| `1406.1021` | `2FI8JCDW` | Exact graph hit. |
| `1601.04832` | `BVJBTK8J` | Exact graph hit. |
| `1709.04891` | `5J5XDKMN`, `zotero:SZJE69PE` | Duplicate records; the prefixed legacy form is not a valid canonical bare `paper_key`. |
| `1802.03910` | `K87E7K68` | Exact graph hit. |
| `2601.15885` | `U58ZFXGR` | Exact graph hit. |
| `hep-ph/9805445` | `986CC8CS` | Exact graph hit. |

The following manuscript identifiers had no exact graph record in this pass:

`1308.1697`, `1212.2839`, `1509.08851`, `2404.09840`, `0910.3675`,
`1608.04696`, `2006.04204`, `1912.08854`, `2405.08863`, and `2603.15770`.

Zotero title search found *Dirac quantum walk on tetrahedra* under bare item key
`8RZQA73D`, DOI `10.1103/physreva.110.042418`. Thus the `2404.09840` gap is a
graph-linkage/indexing gap, not necessarily a missing Zotero item. Zotero title
search also confirmed two actual items, `SZJE69PE` and `5J5XDKMN`, for
*Scattering Amplitudes For All Masses and Spins* (`1709.04891`). No deduplication
was attempted during this read-only activation.

Raw arXiv-ID text searches in Zotero did not reliably retrieve known items.
Known-answer lookup should use normalized metadata fields or title search until
the canonical-ID path is repaired.

## Retrieval Checks

- Neo4j exact access is live and returned 103,959 nodes in a service-health
  query.
- Semantic abstract search ranked the exact fermion-doubling paper
  (`2601.15885`) first for a corresponding query, score 0.867.
- Full-text chunk search returned the relevant Gupta/Short discussion and the
  section describing a family of Dirac walks with nonzero stay-put
  probability.
- Repository semantic search for the Pluecker identity returned related older
  task documents before the canonical Lean module. This is a known-answer
  failure for declaration retrieval and indicates a stale or noisy document
  index.
- On Windows, repository vector search needs `PYTHONUTF8=1`; without it, a
  result containing `psi` as a Unicode symbol failed under the default cp1252
  console encoding.
- A full document-index refresh exceeded the previous bounded execution window.
  The current index remains queryable but should be treated as stale until a
  successful refresh is logged.

## Service and Workflow Policy

Neo4j and Zotero are healthy through the repo's out-of-session MCP client after
the user's restart. The already-running Codex session retained a stale direct
Zotero transport; reconnecting its MCP clients is a session concern, not a
database outage.

The active lab workflow uses interactive Claude Code only. The historical
Claude model-call directory remains provenance, but the Claude API/review
wrapper is not an active lab execution path and must not be invoked.

## Repair Queue

1. Choose the canonical bare Zotero item key for `1709.04891`, merge or retire
   the duplicate according to Zotero policy, and remove the invalid
   `zotero:`-prefixed graph key.
2. Link Zotero item `8RZQA73D` to normalized arXiv ID `2404.09840` in Neo4j,
   preserving its DOI.
3. Run the documented arXiv/DOI pre-add existence check for the remaining nine
   exact-record gaps, then link existing Zotero items or ingest only genuinely
   absent papers.
4. Refresh the repository document index with `PYTHONUTF8=1` after current Lean
   and manuscript edits settle.
5. Add known-answer retrieval checks for the canonical Pluecker mass module,
   the continuum capstone, and one exact manuscript citation.
6. Convert the cosmological and overview manual lists to canonical citation
   keys when those manuscripts enter submission preparation.
7. Decide whether the ten unused general-audience bibliography items support
   planned prose or should be removed at the final editorial pass.
8. Work down `Sources/Null_Edge_References.md` debt in the order
   `NEEDS-VERIFY`, `ID-ONLY`, `TBD-`, recording claim-level support rather than
   metadata presence alone.

## Archivist Verdict

The research services are operational, and the flagship bibliography is
internally consistent. The source infrastructure is not yet submission-grade:
ten exact arXiv records are absent from the graph, one paper is duplicated in
Zotero/Neo4j, and repository semantic retrieval does not reliably privilege
canonical Lean declarations. These are bounded infrastructure repairs, not
evidence against the manuscript's mathematics, but no claim should be promoted
on the strength of the incomplete index.
