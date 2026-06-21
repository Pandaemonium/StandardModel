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
| `lean-explore` | Semantic search over Lean 4 declarations (Mathlib, **PhysLean**, Batteries, Init, Lean, Std, ...), offline local index | `uvx --python 3.12 --from lean-explore[local] lean-explore mcp serve --backend local` | [lean-explore](https://github.com/justincasher/lean-explore) (PyPI) |
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

### lean-explore tools (added 2026-06-21)

`lean-explore` is a semantic declaration search engine over a downloaded
offline index (`lean-explore data fetch`, one-time, ~3.8 GB: a 2.1 GB SQLite DB
plus a 1.7 GB FAISS index). Its indexed corpus includes **PhysLean**, which
overlaps this project's physics formalization goals. The `[local]` extra pulls
`torch` + `sentence-transformers` + `faiss-cpu`, so the first install is heavy;
the running server is then fully offline and needs no API key. (A lightweight
`--backend api` mode exists but requires a free `LEANEXPLORE_API_KEY` from
leanexplore.com.)

**Python 3.12 pin (required).** The MCP server crashes on Python < 3.12 with
`pydantic.errors.PydanticUserError: Please use typing_extensions.TypedDict
instead of typing.TypedDict`. The tool env and the `.mcp.json` launch are
therefore pinned to 3.12 (`uv tool install --python 3.12 "lean-explore[local]"`
and `uvx --python 3.12 ...`). The downloaded index is independent of the Python
version, so re-pinning does not refetch it.

**Two Qwen models must be pre-cached (or searches hang).** The local backend
uses `Qwen/Qwen3-Embedding-0.6B` to encode the query (retrieval) and
`Qwen/Qwen3-Reranker-0.6B` to rerank candidates. Both are ~1.2 GB and download
*lazily inside the first search request*. Under the MCP client watchdog a cold
download overruns, the request is killed mid-download, and the partial
HuggingFace cache re-downloads next time - so the first searches appear to hang
forever (this affects `rerank_top: 0` too, since retrieval still needs the
embedding model). Fix: pre-warm both models once, outside any request, by
running a search with the tool-env interpreter:

```bash
"C:/Users/Owner/AppData/Roaming/uv/tools/lean-explore/Scripts/python.exe" \
    Scripts/lit/test_lean_explore_search.py
```

After that, both models live in `~/.cache/huggingface/hub/` and the in-server
search loads them from disk. `Scripts/lit/prewarm_reranker.py` warms the
reranker alone if needed.

**CPU latency.** The `[local]` extra installs the CPU torch build
(`torch ...+cpu`, `cuda_available=False`), so both 0.6B transformers run on CPU:
a warm search is ~30 s (query embedding + reranking 50 candidates), and the
first search after server start adds a one-time model load. This is fine for
batch lemma lookup but not snappy. `rerank_top: 0` roughly halves it (skips the
reranker, keeps the embedding retrieval). A CUDA torch build would cut this to a
few seconds but is a heavier reinstall (`uv tool install --python 3.12
--with "torch --index-url https://download.pytorch.org/whl/cu121" ...`) and is
not currently configured. The MCP client default timeout (90 s) comfortably
covers a warm search once the models are cached; raise it for the first
cold-load call.

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
notation, not for search. There is no local semantic-search index over papers on
this machine.

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
