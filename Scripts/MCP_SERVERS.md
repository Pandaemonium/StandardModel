# MCP servers (Lean tooling, literature search, Zotero, knowledge graph, local LLM)

This project wires up six Model Context Protocol (MCP) servers in
[`.mcp.json`](../.mcp.json) at the repo root. They give coding/research agents
Lean language-server access and mathlib search, literature search, a Zotero
writer, a Neo4j knowledge graph, and a local LLM.

These are developer/research tooling, not part of the Lean build.

## Servers

| Name | Purpose | Command | Source |
|---|---|---|---|
| `lean-lsp` | Live Lean LSP on this repo: goal states, diagnostics, hover, completions, build, plus LeanSearch / Loogle / Lean Finder / Lean Hammer / Lean State Search | `uvx lean-lsp-mcp` | [lean-lsp-mcp](https://github.com/oOo0oOo/lean-lsp-mcp) (PyPI) |
| `lean-explore` | Semantic search over Lean 4 declarations (Mathlib, **PhysLean** - package label `Physlib`, Batteries, Init, Lean, Std, ...), offline local index, models on the **Intel Arc A750 (XPU)** | `<tool-env python> Scripts/mcp/lean_explore_xpu.py` | [lean-explore](https://github.com/justincasher/lean-explore) (PyPI) |
| `scholarly` | Literature search across **Semantic Scholar, OpenAlex, arXiv, INSPIRE-HEP, Crossref, Europe PMC, Unpaywall** | `python .../scholarly_wrapper/src/server.py` | `C:/Projects/AutoLab/COGLab/infrastructure/mcp/scholarly_wrapper/src/server.py` |
| `zotero_write` | Write items into the Zotero library (user `19894138`) | `python .../zotero-writer/src/server.py` | `C:/Tools/mcp/zotero-writer/src/server.py` |
| `neo4j_graph` | Read/write a Neo4j knowledge graph | `cmd.exe /c .../neo4j_mcp/run.bat` | Go binary `neo4j-mcp.exe` |
| `local-qwen` | Local generative LLM via Ollama (summarize / distill / notation-map) | `python Scripts/oracle/local_mcp_bridge.py` | [`oracle/local_mcp_bridge.py`](oracle/local_mcp_bridge.py) |

### lean-lsp tools (added 2026-06-21)

`lean-lsp` runs `lake serve` in the repo root (`LEAN_PROJECT_PATH` in
`.mcp.json`) and exposes the Lean language server to agents. It directly serves
the AGENTS.md workflow rule "search existing mathlib and project declarations
before creating new ones," which previously had no tool.

- **Project introspection:** `lean_goal` (proof state at a position - the most
  important one), `lean_term_goal`, `lean_hover_info`, `lean_completions`,
  `lean_file_outline`, `lean_diagnostic_messages`, `lean_code_actions`,
  `lean_declaration_file`, `lean_references`, `lean_build`.
- **Mathlib search:** `lean_local_search` (verify a name exists before using
  it), `lean_leansearch` (natural language), `lean_loogle` (by type signature),
  `lean_leanfinder` (semantic; `version` defaults to **v4.28.0**, matching the
  project toolchain), plus a Lean Hammer / Lean State Search premise selector.

Install is via `uvx` (already cached locally with `uv tool install
lean-lsp-mcp`). First call cold-starts `lake serve`, so goal/diagnostic tools
lag until the project is built; the external search tools work immediately.
This complements Aristotle: the coding agent checks goal states and finds
existing lemmas *before* preparing a handoff, rather than churning.

`lean_local_search` is the only tool here that searches *this repo's own*
`PhysicsSM.*` declarations (not Mathlib/PhysLean - `lean-explore` does not index
our namespace), so it is the right tool for "does this lemma already exist
here?". Gotcha (verified 2026-06-22): it shells out to a real system `rg`
(ripgrep) binary on the server process's PATH and errors `ripgrep (rg) was not
found on your PATH` when absent. The harness `Grep`/`Glob` tools are unaffected
because they use a private bundled ripgrep exposed only as a shell *function*
(`rg`) inside the agent shell, which child processes like the MCP server cannot
see. Fix applied: `winget install -e --id BurntSushi.ripgrep.MSVC` plus a copy of
`rg.exe` into `C:/Users/Owner/.local/bin` (already on the persistent user PATH,
alongside `lean-lsp-mcp.exe`); winget's own `Links` alias symlink silently fails
without Windows Developer Mode, so the `.local/bin` copy is the reliable path. A
running session must `/mcp`-reconnect (or fully restart Claude Code) afterward:
the server caches the `rg` lookup at startup, so it will not see a newly
installed `rg` until re-spawned.

### lean-explore tools (added 2026-06-21, Arc/XPU 2026-06-21)

`lean-explore` is a semantic declaration search engine over a downloaded
offline index (`lean-explore data fetch`, one-time, ~3.8 GB: a 2.1 GB SQLite DB
plus a 1.7 GB FAISS index). Its indexed corpus includes **PhysLean**, which
overlaps this project's physics formalization goals - and is the main reason to
run it alongside `lean-lsp` (whose online LeanSearch/Loogle index Mathlib but
not PhysLean). Gotcha: the physics library is registered under the package label
`Physlib` (module prefix `Physlib.*`), not `PhysLean`. To scope a search pass
`packages=["Physlib"]`; `packages=["PhysLean"]` matches nothing and errors with
`max() iterable argument is empty`. Omit `packages` to search Mathlib and
Physlib together (the usual mode). Two ~1.2 GB models do the work:
`Qwen/Qwen3-Embedding-0.6B`
(retrieval) and `Qwen/Qwen3-Reranker-0.6B` (reranking). Both are pre-cached in
`~/.cache/huggingface/hub/`. The server is fully offline (no API key).

It runs on the **Intel Arc A750 (XPU)** via a launch wrapper,
[`mcp/lean_explore_xpu.py`](mcp/lean_explore_xpu.py), which `.mcp.json` invokes
with the tool-env interpreter. Verified end-to-end through the real `mcp` client
(`Scripts/mcp/_probe_mcp_client.py`): ~4.6 s for a cold reranked query, ~2.5 s
warm, vs ~30 s on CPU.

The wrapper exists because three things must be fixed, none editable upstream
without losing them on `uv tool` reinstall:

1. **Python 3.12 pin (required).** The server crashes on Python < 3.12 with
   `pydantic.errors.PydanticUserError: ... typing_extensions.TypedDict`. The
   tool env is installed with `uv tool install --python 3.12`. The torch build
   is `2.9.1+xpu` (the newest Windows XPU wheel; the env's default was
   `2.12.1+cpu`):
   `uv tool install --python 3.12 --index https://download.pytorch.org/whl/xpu --with "torch==2.9.1+xpu" "lean-explore[local]" --reinstall`.
   The downloaded index is independent of the Python/torch version, so this does
   not refetch it.

2. **Device + fp16.** lean-explore's `EmbeddingClient`/`RerankerClient`
   `_select_device()` only knows `cuda`/`mps`/`cpu`, so it would fall back to
   CPU. The wrapper patches both to prefer `xpu` and casts the models to fp16
   (~2.4 GB total vs ~4.8 GB - the Arc's 8 GB is shared with Ollama).

3. **The search hang (Intel XPU thread affinity).** The clients dispatch model
   inference to a thread pool via `loop.run_in_executor(...)`. On Intel XPU that
   moves the GPU work off the thread that owns the SYCL context and **deadlocks**
   - the search reaches the embedding step and never returns (this is why every
   `mcp_call`/native attempt hung at "BM25S Retrieve"). The wrapper patches
   `EmbeddingClient.embed` and `RerankerClient.rerank` to run inference INLINE
   (no executor) so all XPU work stays on the one FastMCP event-loop thread, and
   pre-warms the models synchronously at startup (also on that thread) so the
   first query is fast. It also sets `HF_HUB_OFFLINE=1`/`TRANSFORMERS_OFFLINE=1`
   (models are cached) and `TQDM_DISABLE=1`.

To verify out of session (initialize + list + a real reranked search through the
proper client):

```bash
"C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe" \
    Scripts/mcp/_probe_mcp_client.py
```

`Scripts/lit/test_lean_explore_search.py` exercises the search engine directly
(bypassing MCP) for timing/sanity. **Rollback to stock CPU** if needed: repoint
the `.mcp.json` `lean-explore` entry to
`uvx --python 3.12 --from lean-explore[local] lean-explore mcp serve --backend local`
and reinstall torch as `+cpu` - but note the upstream server still hangs on XPU
without the wrapper, and CPU search is ~30 s/query.

### Semantic Scholar API key (optional, free)

`scholarly` reads `SEMANTIC_SCHOLAR_API_KEY` (referenced in `.mcp.json`) and
runs unauthenticated when it is unset - which is the current state. A free key
(request at https://www.semanticscholar.org/product/api) only raises rate
limits on a backend already in use. Set it once at Windows User scope so every
spawned process inherits it:

```powershell
[Environment]::SetEnvironmentVariable('SEMANTIC_SCHOLAR_API_KEY', '<key>', 'User')
```

### scholarly tools
`search-arxiv`, `search-inspirehep`, `search-google-scholar` (local rerank over
INSPIRE + arXiv, not scraping), plus OpenAlex / Crossref / Europe PMC search and
Unpaywall open-access resolution. OpenAlex and Unpaywall are keyed via env;
Semantic Scholar runs unauthenticated unless `SEMANTIC_SCHOLAR_API_KEY` is set.

### zotero_write tools
`zotero_create_item` (raw item payload), `zotero_add_journal_article` (structured
metadata: title/authors/doi/abstract/tags/collection_key/...), and item-template
helpers.

### local-qwen
Backed by Ollama at `http://localhost:11434`. Model is set in
[`oracle/local_mcp_bridge.py`](oracle/local_mcp_bridge.py) via `MODEL_NAME`
(currently `gemma4:12b`, chosen for its 256k context when distilling large
literature result sets). It is a generative LLM with **no paper corpus and no
internet** — useful for summarizing/distilling search results or mapping
notation, not for search. For semantic search over the curated paper library, see
"Semantic vector search over papers (Neo4j)" below.

Note: `qwen3.5:9b-q4_K_M` (and its `-cpu` twin, same blob) is a **broken quant**
— it emits a degenerate all-zeros stream and never returns content. Do not use it
until it is removed and re-pulled. `qwen3:8b` works but has only a 40k context.

## Prerequisites / environment

- Secrets are read from **Windows User-scope** environment variables (inherited
  by any spawned process): `OPENALEX_API_KEY`, `UNPAYWALL_EMAIL`,
  `ZOTERO_API_KEY`, `NEO4J_URI`, `NEO4J_USERNAME`, `NEO4J_PASSWORD`,
  `NEO4J_DATABASE`. `SEMANTIC_SCHOLAR_API_KEY` is currently unset.
- `neo4j_graph` only connects when a Neo4j instance is **running** at
  `127.0.0.1:7687` (Bolt) / `7474` (HTTP). Otherwise it exits with
  "connection actively refused".
- `local-qwen` requires `ollama serve` running with the configured model pulled.

## Framing fix (2026-06-20)

`scholarly` and `zotero_write` originally failed with a 30s handshake timeout
(zero bytes). Root cause: their hand-rolled `read_message`/`write_message` used
LSP-style `Content-Length:` framing, but the MCP stdio transport that Claude
Code (and FastMCP, e.g. `local-qwen`) speaks is **newline-delimited JSON** (one
compact JSON object per line). The servers blocked waiting for a header that
never arrived.

Fix: rewrote `read_message`/`write_message` in both sources to newline-delimited
JSON and repointed `.mcp.json` from the stale PyInstaller `.exe` builds to
`python <src/server.py>` (both servers are stdlib-only — no venv). Timestamped
backups sit next to each source (`server.py.bak-YYYYMMDD-HHMMSS`).

Known leftovers:
- The `dist/*.exe` builds are still the old broken framing; they are no longer
  referenced by `.mcp.json`.
- [`../.codex/config.toml`](../.codex/config.toml) still points Codex at those
  broken `.exe` files; Codex needs the same repoint-to-python to use scholarly /
  zotero.

## Using the servers without a session reconnect

A running Claude Code (or Codex) session loads its MCP tools at **startup**, so
servers added or fixed mid-session do not appear until you restart the client or
use `/mcp` to reconnect. To verify or use a server immediately, drive it
directly with the helper:

```bash
# List a server's tools
python Scripts/mcp/mcp_call.py scholarly --list
python Scripts/mcp/mcp_call.py lean-lsp --list --timeout 150   # first call cold-starts lake serve

# Call a tool (arguments as JSON)
python Scripts/mcp/mcp_call.py scholarly search-arxiv --args '{"query":"Feynman checkerboard Dirac propagator","limit":10}'
python Scripts/mcp/mcp_call.py lean-lsp lean_loogle --args '{"query":"CliffordAlgebra _ _ -> _"}'
python Scripts/mcp/mcp_call.py lean-lsp lean_leansearch --args '{"query":"determinant of sum of rank one matrices"}'
python Scripts/mcp/mcp_call.py neo4j_graph --list
python Scripts/mcp/mcp_call.py zotero_write zotero_add_journal_article --args-file paper.json
```

The helper reads `.mcp.json`, expands `${VAR}` from the environment, spawns the
server, performs the `initialize` handshake, and runs one `tools/list` or
`tools/call`. See [`mcp/mcp_call.py`](mcp/mcp_call.py).

Health check across all servers:

```bash
claude mcp list
```

## Literature-search workflow and dedup convention (2026-06-20)

The null-edge causal-graph program (and similar literature work) uses this
pipeline: `scholarly` search -> local LLM relevance triage (`local-qwen`, backed
by `gemma4:12b`) -> `zotero_write` add -> `neo4j_graph` sync. Library: Zotero
collection `9W59V3K9`, Neo4j `coglab` graph.

A staging-only prototype of the search -> triage half of this pipeline lives in
[`lit_harness.py`](lit_harness.py) (docs: [`lit/README.md`](lit/README.md)). It
lets Gemma propose keywords and triage results while Python owns execution and
dedup, and writes ranked proposals to a staging file -- it makes no Zotero/Neo4j
writes. The approval/ingest step is intentionally separate and human-gated.

### Avoiding duplicate papers

Duplicate `Paper` nodes arise two ways; guard against both:

1. Key divergence: agents must use the canonical `paper_key` = bare Zotero item
   key (no `zotero:` prefix). Normalize `arxiv_id` (strip any `arXiv:` prefix and
   version suffix `vN`) and `doi` (lowercase, no `https://doi.org/`).
2. Same paper added twice: re-adding to Zotero mints a new item key -> a new node
   even with consistent keying. So dedup must gate the Zotero-add step, keyed on a
   stable external id (arxiv_id/doi), NOT the title or Zotero key.

Low-cost pre-add check (run before adding; skip the add if it returns a row):

```cypher
MATCH (p:Paper)
WHERE ($arxiv <> "" AND p.arxiv_id = $arxiv)
   OR ($doi   <> "" AND toLower(p.doi) = toLower($doi))
RETURN p.paper_key AS key, p.title AS title LIMIT 1
```

A Neo4j uniqueness constraint is a poor fit here: many `Paper` nodes legitimately
have `arxiv_id = ""`, and empty strings collide under a constraint.

Neo4j `Paper` convention: `paper_key` = Zotero item key, `source = "zotero"`,
`item_type = "preprint"`, `title_key` = lowercased-alphanumeric title; edges
`AUTHORED_BY` / `HAS_TAG` / `IN_COLLECTION`.

Known leftover: 5 pre-existing `zotero:`-prefixed duplicate nodes
(hep-th/0510161, 2203.08087, 1709.04891, 1409.7169, hep-th/0512091) are not yet
merged.

### Which search tool for which question (read first)

Several engines touch the literature; they are **not** interchangeable, and the
most common mistake is reaching for `neo4j_graph` Cypher to find papers "about" a
topic - it has no embedder and cannot rank by meaning.

- **Meaning-based search over papers** (concepts, "find work on X"): the Neo4j
  paper vector indexes, driven by [`lit/neo4j_paper_search.py`](lit/neo4j_paper_search.py),
  at two granularities:
  - `--query` ranks **abstracts** - which papers are relevant;
  - `--chunks` ranks **full body text** - where in a paper a lemma, derivation,
    or sign convention actually lives.
- **Exact graph queries over papers** (by arxiv_id / doi / title / tag / author /
  collection, traversal, counts, dedup pre-checks): the `neo4j_graph` MCP server
  with Cypher.
- **Meaning-based search over THIS repo's own docs + Lean**:
  [`lit/neo4j_doc_search.py`](lit/neo4j_doc_search.py)
  (`:NEDoc` / `:NEChunk`, index `ne_chunk_embedding`).
- **Lean / Mathlib / PhysLean declarations**: `lean-lsp` / `lean-explore`.
- **Discovering NEW papers** not yet in the library: `scholarly`.

Rule of thumb: "by meaning" -> a python vector script; "by exact field or
relationship" -> `neo4j_graph` Cypher. The three vector indexes are
`paper_embedding` (abstracts), `paper_chunk_embedding` (paper full text), and
`ne_chunk_embedding` (this repo's docs/Lean). Library scope: collection
`9W59V3K9`; a paper is only visible to scoped search if it has the
`IN_COLLECTION` edge.

### Semantic vector search over papers (Neo4j, 2026-06-21)

Papers are searchable by **meaning**, not just by id/title/tag. Each `Paper`
node carries a 1024-dim `embedding` of its `title + abstract`
(`Qwen/Qwen3-Embedding-0.6B`, the model lean-explore uses, run on the Arc GPU),
indexed by a native Neo4j `VECTOR INDEX` named `paper_embedding` (cosine).
Build/refresh and query with
[`lit/neo4j_paper_search.py`](lit/neo4j_paper_search.py), run with the
lean-explore tool-env interpreter (it carries `+xpu` torch,
`sentence-transformers`, the cached model, and the `neo4j` driver):

```bash
PY="C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
"$PY" Scripts/lit/neo4j_paper_search.py                       # embed new papers + ensure index
"$PY" Scripts/lit/neo4j_paper_search.py --query "celestial holography soft theorems"
"$PY" Scripts/lit/neo4j_paper_search.py --query "spin foam simplicity" --format markdown
```

Ingest is idempotent: a default run only embeds papers whose `embedding` is
`NULL`, so re-run it after adding papers (a natural last step of the
search -> Zotero -> Neo4j pipeline); `--reembed` redoes all. Query encodes with
the model's asymmetric "query" prompt and calls `db.index.vector.queryNodes`, so
semantic ranking is fused with the graph (authors, tags, claims, collections
stay attached). All 325 `Paper` nodes are embedded (the write keys on
`elementId(p)`, so nodes with null/duplicate `paper_key` persist too). Direct
Cypher: `CALL db.index.vector.queryNodes('paper_embedding', 10, $vec) YIELD node,
score`. The `neo4j` driver was `uv pip install`ed into the lean-explore tool env;
re-add it if that env is reinstalled.

Caveat - the graph is **shared across projects**: `Paper` nodes are mixed by
collection (yours: `9W59V3K9` "Null-Edge Causal Graph Program" + `null-edge-lit`;
AutoLab's: `M6SN2MC2` "AutoLab Sources", `GX2VZ4FV` "AutoLab SM Parameter
Benchmark"). The CLI now scopes query results to the two null-edge collections
by default; use `--all-projects` only when you intentionally want cross-project
paper recall. Use repeatable `--collection <key>` to override the scoped set.
Query output supports `--format text|json|markdown`.

### Full-text chunk search over papers (Neo4j, 2026-06-27)

Beyond the abstract-level `paper_embedding` index, paper **body text** is now
searchable. [`lit/lit_fulltext.py`](lit/lit_fulltext.py) fetches each paper's
source (arXiv LaTeX e-print first - cleaner than PDF: real sections, math intact,
no column/ligature garbage; `pymupdf` PDF->text only as a fallback for
source-less papers), de-LaTeXes to prose with section headings, splits into
section-aware ~600-word chunks (90-word overlap), embeds each chunk with the same
`Qwen3-Embedding-0.6B` model, and upserts:

    (:Paper)-[:HAS_CHUNK]->(:PaperChunk {chunk_key, paper_key, arxiv_id, ord,
                                         section, text, embedding})

under a dedicated `VECTOR INDEX paper_chunk_embedding` (cosine, 1024-dim). This
keeps "which paper" (abstracts) separate from "where in the paper" (chunks).

```bash
PY="C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
"$PY" Scripts/lit/lit_fulltext.py                      # null-edge collection, new papers only
"$PY" Scripts/lit/lit_fulltext.py --ids 1011.0761      # specific papers
"$PY" Scripts/lit/lit_fulltext.py --refresh            # re-chunk already-chunked papers
"$PY" Scripts/lit/lit_fulltext.py --dry-run --limit 3  # fetch + chunk, print counts, no writes
"$PY" Scripts/lit/neo4j_paper_search.py --chunks --query "flavored mass overlap from naive kernel"
```

Idempotent: skips papers that already have chunks (stable `chunk_key` =
`<arxiv_id>#<ord>`; `--refresh` replaces). Scoped to collection `9W59V3K9` by
default; `--ids` overrides. Direct Cypher for the vectors:
`CALL db.index.vector.queryNodes('paper_chunk_embedding', 10, $vec) YIELD node,
score` - but you still need the python path to embed the query string (the MCP
server cannot).

Caveat: de-LaTeX preserves prose and section structure but **degrades math
symbols** (subscripts/operators flatten to plain tokens), so chunk search is
strong on conceptual/derivational text and weak on pure-formula matching. Full
text lives only in Neo4j; no PDFs are stored in Zotero or the repo. The PDF
fallback uses `pymupdf` (`fitz`), `uv pip install`ed into the lean-explore tool
env (re-add with `uv pip install --python <tool-env python> pymupdf` if that env
is reinstalled). First null-edge pass (2026-06-27): 196/196 papers chunked into
5345 `PaperChunk` nodes.

### Semantic search over the repo's own docs + Lean (Neo4j, 2026-06-21)

The shared `coglab` graph's `Doc`/`LeanFile`/`Claim`/`Concept` nodes belong to
AutoLab, **not this repo**. So this repo's own documents were ingested under
**project-scoped labels** `:NEDoc` (a source file) and `:NEChunk` (a chunk), both
`project='null-edge'`, with a dedicated `VECTOR INDEX` `ne_chunk_embedding` - they
never touch AutoLab's nodes.

[`lit/neo4j_doc_search.py`](lit/neo4j_doc_search.py) ingests this repo's prose
(`Sources/`, `AgentTasks/`, `docs/`, top-level `*.md`) and Lean
(`PhysicsSM/**/*.lean`) straight from disk - full content, since the graph's
20k-char `Doc.body` cap does not apply. Markdown is chunked by heading, Lean by
declaration, then size-windowed (~1800 chars, 200 overlap); chunks are embedded
with `Qwen3-Embedding-0.6B` on the Arc. Currently 799 files / 12000 chunks. Run
with the lean-explore tool-env python:

```bash
PY="C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
"$PY" Scripts/lit/neo4j_doc_search.py --dry-run    # list files + chunk counts (no writes)
"$PY" Scripts/lit/neo4j_doc_search.py              # ingest CHANGED files + build index
"$PY" Scripts/lit/neo4j_doc_search.py --query "Dirac slash of bundle momentum squares to the Plucker scalar"
"$PY" Scripts/lit/neo4j_doc_search.py --query "Dirac slash" --format json
```

Ingest is idempotent (re-chunks a file only when its content `sha` changes), so
re-run it after editing docs/Lean. A query returns chunks with their parent file
plus heading (the Lean declaration name), spanning prose and source in one
ranking. It excludes build/extraction trees (`.lake`, `aristotle-submit`,
`aristotle-output`, `*extracted*`). Direct Cypher:
`CALL db.index.vector.queryNodes('ne_chunk_embedding', 10, $vec) YIELD node, score`.
Query output supports `--format text|json|markdown`. If direct shell use reports
missing `NEO4J_URI`, `NEO4J_USERNAME`, or `NEO4J_PASSWORD`, run it from a shell
that inherits the Windows user environment, or drive Neo4j through the MCP
session.

### Aristotle semantic context packs (2026-06-21)

Before submitting a nontrivial Aristotle job, generate a compact context pack
from the repo doc/Lean index and the scoped paper index:

```bash
PY="C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe"
"$PY" Scripts/aristotle/make_context_pack.py \
    --query "Dirac slash bundle momentum squares to Pluecker scalar" \
    --slug dirac-pluecker
```

The output goes to `AgentTasks/context-packs/` and should be included in the
submission package instead of broad duplicated context. Use this as context
selection evidence only; theorem statements, convention choices, and source
claims still need manual review.

### Known fixes / caveats

- `zotero_search_items` previously failed via MCP with "expected record, received
  array": `GET /items` returns a JSON array, but MCP `structuredContent` must be
  an object. Fixed in `C:/Tools/mcp/zotero-writer/src/server.py`
  `format_tool_result` (wraps non-dict results as `{"results": ...}`). A running
  session must `/mcp`-reconnect to pick it up.
- `local-qwen` (`gemma4:12b`) runs ~15 tok/s on CPU here, so non-trivial
  generations exceed the httpx timeout in `oracle/local_mcp_bridge.py`. Raise the
  timeout for batch distillation/triage. Quality is good; speed suits offline
  batch use, not interactive. Verify a server out-of-session with
  `python Scripts/mcp/mcp_call.py <server> <tool> --args-file <json>`.
