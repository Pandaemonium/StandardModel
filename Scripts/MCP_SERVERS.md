# MCP servers (literature search, Zotero, knowledge graph, local LLM)

This project wires up four Model Context Protocol (MCP) servers in
[`.mcp.json`](../.mcp.json) at the repo root. They give coding/research agents
literature search, a Zotero writer, a Neo4j knowledge graph, and a local LLM.

These are developer/research tooling, not part of the Lean build.

## Servers

| Name | Purpose | Command | Source |
|---|---|---|---|
| `scholarly` | Literature search across **Semantic Scholar, OpenAlex, arXiv, INSPIRE-HEP, Crossref, Europe PMC, Unpaywall** | `python .../scholarly_wrapper/src/server.py` | `C:/Projects/AutoLab/COGLab/infrastructure/mcp/scholarly_wrapper/src/server.py` |
| `zotero_write` | Write items into the Zotero library (user `19894138`) | `python .../zotero-writer/src/server.py` | `C:/Tools/mcp/zotero-writer/src/server.py` |
| `neo4j_graph` | Read/write a Neo4j knowledge graph | `cmd.exe /c .../neo4j_mcp/run.bat` | Go binary `neo4j-mcp.exe` |
| `local-qwen` | Local generative LLM via Ollama (summarize / distill / notation-map) | `python Scripts/oracle/local_mcp_bridge.py` | [`oracle/local_mcp_bridge.py`](oracle/local_mcp_bridge.py) |

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

# Call a tool (arguments as JSON)
python Scripts/mcp/mcp_call.py scholarly search-arxiv --args '{"query":"Feynman checkerboard Dirac propagator","limit":10}'
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
