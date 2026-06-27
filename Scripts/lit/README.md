# Literature-search harness (Option 2, staging-only)

`Scripts/lit_harness.py` runs the search -> triage pipeline described in
[`../MCP_SERVERS.md`](../MCP_SERVERS.md) and
[`../../Sources/Null_Edge_Causal_Graph_Research_Plan.md`](../../Sources/Null_Edge_Causal_Graph_Research_Plan.md).

Python owns the control flow. The local LLM (Gemma via Ollama) is used only as a
text function for two steps -- keyword generation and relevance triage. It does
NOT execute searches or write to the corpus. The harness makes **no writes to
Zotero or Neo4j** (Neo4j is read-only, for dedup); it only appends ranked
proposals to a staging file for a human/strong-model approval pass.

## Pipeline

1. Gemma proposes plain keyword sets for the topic (no boolean operators).
2. Each keyword is searched via the `scholarly` MCP server (deterministic).
3. Results are round-robin merged (so narrow keywords are not starved by broad
   ones) and deduped within the batch by normalized arxiv_id/doi/title.
4. Candidates are deduped against the live Neo4j graph (read-only existence check
   on arxiv_id/doi -- the convention in `../MCP_SERVERS.md`).
5. Gemma triages the *new* candidates (INCLUDE / SKIP + reason).
6. Proposals are appended to `staging.jsonl`. Nothing is committed.

## Usage

```bash
# fast plumbing test (skip the slow Gemma steps):
python Scripts/lit_harness.py --topic "two-twistor massive particle" \
    --no-gemma-keywords --no-triage

# full run on one topic:
python Scripts/lit_harness.py --topic "Tsirelson bound from quantum measure theory"

# overnight batch from a queue (one topic per line, # comments ok, or a JSON list):
python Scripts/lit_harness.py --topics-file Scripts/lit/topics.txt
```

Useful flags: `--backend` (search-inspirehep | search-arxiv | search-openalex |
search-papers), `--limit` (per keyword), `--keywords` (sets per topic),
`--max-per-topic`, `--sleep` (politeness delay), `--model`, `--gemma-timeout`,
`--no-dedup`, `--staging <path>`.

Requires: `ollama serve` with the model pulled (default `gemma4:12b`), and the
`scholarly` + `neo4j_graph` servers configured in `../../.mcp.json` with their
env vars set (see `../MCP_SERVERS.md`).

## Output schema (`staging.jsonl`, one JSON object per line)

`topic, ts, title, year, arxiv_id, doi, url, backend, query, citation_count,
in_library, decision (INCLUDE|SKIP|REVIEW), rank, reason, suggested_collection,
suggested_tags, abstract`.

`sample_staging.jsonl` is an example run (Pillar 9 topic). Real `staging*.jsonl`
outputs are generated and git-ignored.

## Known characteristics (from testing 2026-06-20)

- Gemma triages with good recall but over-includes on lexical overlap (e.g. it
  has tagged an ML "belief propagation / generalized probabilistic" paper as
  relevant to GPT physics). This is why the harness is **propose-only**; a human
  or strong model must approve before anything reaches Zotero/Neo4j.
- gemma4:12b runs ~15 tok/s on CPU here, so a full topic (keyword gen + triage)
  takes a few minutes. Suited to offline/overnight batch use, not interactive.
- Approval/ingest is a separate step, `lit_ingest.py` (see **Ingest** below).
  Keep concept/claim graph edges human-curated; do not let the harness write them.
- Embed step (wired in): after any ingest adds `Paper` nodes to Neo4j, run the
  idempotent embedder so new papers are semantically searchable. It is cheap when
  nothing is new (it skips the model load). `lit_ingest.py` (below) already calls
  `neo4j_paper_search.ensure_embeddings()` as its final step, so a normal ingest
  needs no separate embed run.

  ```bash
  PY="C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
  "$PY" Scripts/lit/neo4j_paper_search.py        # embed new papers + ensure index
  ```

  See [`../MCP_SERVERS.md`](../MCP_SERVERS.md) -> "Semantic vector search over
  papers" for the model, index, and query usage.

## Ingest (`lit_ingest.py`)

Adds approved papers to Zotero **and** the Neo4j paper graph, then embeds them.
Run it with the lean-explore tool-env interpreter (it carries the `neo4j` driver
and the embedding stack); credentials come from the environment (`ZOTERO_API_KEY`,
`NEO4J_URI`/`NEO4J_USERNAME`/`NEO4J_PASSWORD`).

```bash
PY="C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
"$PY" Scripts/lit/lit_ingest.py 2502.16500 2312.08526 1502.04683
"$PY" Scripts/lit/lit_ingest.py --from-staging Scripts/lit/staging.jsonl
"$PY" Scripts/lit/lit_ingest.py 1502.04683 --dry-run    # dedup check only, no writes
```

Per paper it: (1) dedup-checks Neo4j on normalized `arxiv_id`/`doi` and skips
anything already present; (2) adds the item to Zotero via the `zotero_write` MCP
server (driven through `Scripts/mcp/mcp_call.py`; idempotent); (3) upserts a
canonical `:Paper` node with `IN_COLLECTION` (default collection `9W59V3K9` =
null-edge-lit) + `AUTHORED_BY` + `HAS_TAG` edges -- the `IN_COLLECTION` edge is
**required** for the paper to appear in the default null-edge-scoped vector
search. Finally it calls `neo4j_paper_search.ensure_embeddings()` once. Flags:
`--collection`, `--tag` (repeatable), `--from-staging`, `--dry-run`, `--no-embed`,
`--force`. The Gemma triage over-includes, so keep a human/strong-model glance on
the `INCLUDE` rows before ingesting.

## Semantic repo and paper search

Two Neo4j-backed semantic search helpers are available when using the
lean-explore tool-env Python:

```bash
PY="C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
"$PY" Scripts/lit/neo4j_doc_search.py --query "Dirac slash Pluecker scalar" --format markdown
"$PY" Scripts/lit/neo4j_paper_search.py --query "spin foam simplicity" --format json
```

`neo4j_doc_search.py` searches this repo's own docs and Lean chunks under the
isolated `:NEDoc` / `:NEChunk` labels. `neo4j_paper_search.py` searches papers
and scopes query results to the null-edge collections (`9W59V3K9`,
`null-edge-lit`) by default; pass `--all-projects` only when cross-project paper
recall is intentional.

### Full text: search the chunks, then read the whole paper

Paper **body text** is in the graph as embedded `:PaperChunk` nodes (see
[`../MCP_SERVERS.md`](../MCP_SERVERS.md) -> "Full-text chunk search over papers").
There are two distinct moves, and you usually want both:

```bash
PY="C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
# 1. semantic search over chunks: WHERE in the corpus a lemma/derivation/convention lives
"$PY" Scripts/lit/neo4j_paper_search.py --chunks --query "flavored mass overlap from naive kernel"
# 2. read a whole paper end to end (de-overlapped, section headings restored)
"$PY" Scripts/lit/neo4j_paper_search.py --list-fulltext          # which papers have full text
"$PY" Scripts/lit/neo4j_paper_search.py --read 1011.0761         # arXiv id or Zotero paper_key
"$PY" Scripts/lit/neo4j_paper_search.py --read 1011.0761 --save scratch/paper.md
```

Use `--chunks` to locate; use `--read` to audit a paper in full instead of
stitching chunks by hand. `--read` reconstructs from the stored chunks, so it
carries the same de-LaTeX caveat (faithful prose, degraded math symbols) - go to
the arXiv/PDF for verbatim equations. A paper with no chunks is abstract-only;
add body text with `lit_fulltext.py --ids <arxiv_id>`.

Before submitting a nontrivial Aristotle job, create a compact context pack:

```bash
"$PY" Scripts/aristotle/make_context_pack.py \
    --query "target theorem or research branch" \
    --slug short-target-name
```

The generated `AgentTasks/context-packs/*.md` file is meant to travel with the
Aristotle submission so proof jobs get targeted context without large duplicated
repo snapshots.
