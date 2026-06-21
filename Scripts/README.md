# Scripts

External tooling scripts for oracle generation, index building, and CI support.

Scripts here produce data used by the Lean project but are not themselves Lean code.
They may use Python, SageMath, Julia, or other languages.

## MCP servers

Literature search (`scholarly`), Zotero writes (`zotero_write`), a Neo4j
knowledge graph (`neo4j_graph`), and a local LLM (`local-qwen`) are configured in
[`../.mcp.json`](../.mcp.json). See [`MCP_SERVERS.md`](MCP_SERVERS.md) for what
each provides, the environment it needs, and the 2026-06-20 newline-framing fix.
Use `Scripts/mcp/mcp_call.py` to drive a server directly when a running client
session has not reconnected to pick up new or fixed tools.

## Local pre-commit wrapper

Use `Scripts/pre-commit.cmd` on Windows, or `Scripts/pre-commit.ps1` when
PowerShell script execution is allowed, instead of invoking `pre-commit`
directly from Codex or other sandboxed agents:

```powershell
cmd /c Scripts\pre-commit.cmd run --files EXECUTION_PLAN.md
cmd /c Scripts\pre-commit.cmd run --all-files
```

The wrappers set `PRE_COMMIT_HOME` to `.cache/pre-commit-store` inside the repository.
This avoids permission failures from tools trying to write to
`C:\Users\Owner\.cache\pre-commit` while the agent is sandboxed to the project
workspace.

## Lean placeholder checker

Use the comment-aware Lean scanner instead of raw grep when checking trusted
code for proof placeholders or escape hatches:

```powershell
python Scripts\check_forbidden_lean_tokens.py
python Scripts\check_forbidden_lean_tokens.py --include-draft PhysicsSM\Draft\Example.lean
python Scripts\check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM\Draft\Example.lean
```

It ignores Lean comments, docstrings, and strings, so project prose can remain
readable without flooding scans. The strict finite-computation flag is useful
for Aristotle outputs or other targets that must avoid compiled-evaluator
proofs.

## Aristotle submission packages

Use `Scripts/prepare_aristotle_submission.ps1` to create a slim project copy
under `AgentTasks/aristotle-submit/` before calling Aristotle:

```powershell
pwsh Scripts/prepare_aristotle_submission.ps1 `
  -JobName hamming-e8-theta-modular-form-20260516 `
  -TaskNote AgentTasks/hamming-e8-theta-modular-form-construction-aristotle-2026-05-16.md
```

The script copies root Lean config files and `PhysicsSM/`, excludes local build
state and old Aristotle artifacts, patches the copied SpherePacking dependency
to the remote Windows-safe fork, and prints the `aristotle submit` command.
Use `-IncludeSources`, `-IncludeScripts`, `-IncludeIndex`, or `-ExtraPath` when
a job needs additional context.

## Aristotle project integration

Use `Scripts/aristotle/integrate_completed.py` to fetch, extract, inspect, and
optionally copy idle Aristotle projects.  Aristotle API v3 uses a project/task
model: `aristotle submit` returns a project ID, `aristotle download` fetches
project files, and `aristotle show` / `aristotle tasks` inspect task state.

```powershell
python Scripts/aristotle/integrate_completed.py `
  --task-note AgentTasks/example-aristotle-2026-06-12.md `
  00000000-0000-0000-0000-000000000000
```

The script writes results under `AgentTasks/aristotle-output/<project-id>/`,
extracts archives with path traversal checks, reports candidate
`*Aristotle.lean` files, scans for proof-placeholder tokens, and runs as a dry
run by default.

Copy verified candidates into the live repository only with `--apply`:

```powershell
python Scripts/aristotle/integrate_completed.py `
  --task-note AgentTasks/example-aristotle-2026-06-12.md `
  --apply --build `
  00000000-0000-0000-0000-000000000000
```

Use `--from-list` to inspect every project currently reported by
`aristotle list` as `IDLE`.  Legacy `COMPLETE` and `COMPLETE_WITH_ERRORS`
status arguments are accepted by the helper as aliases for `IDLE`, for old
task-note compatibility.

## Subdirectory plan

```
Scripts/
  pre-commit.cmd        - Windows wrapper for a repo-local pre-commit cache
  pre-commit.ps1        - run pre-commit with a repo-local cache
  check_forbidden_lean_tokens.py - comment-aware Lean placeholder scanner
  prepare_aristotle_submission.ps1 - create a slim Aristotle project copy
  MCP_SERVERS.md        - MCP server reference (scholarly/zotero/neo4j/local-qwen)
  mcp/
    mcp_call.py         - minimal stdio MCP client for ad-hoc tool calls
  aristotle/
    integrate_completed.py - fetch, inspect, and optionally integrate Aristotle outputs
  oracle/
    sage_roots.py       — generate root system fixtures via SageMath
    lieart_branching.py — generate branching rule fixtures via LieART (Mathematica)
    sympy_gamma.py      — generate gamma matrix identity fixtures via SymPy
  index/
    build_index.py      — extract declaration metadata from Lean sources into JSON
    build_graph.py      — build knowledge graph from declaration metadata
```

## Oracle policy

- Oracle scripts must record tool name, version, and input conventions.
- Output is stored as numeric/symbolic fixture data only.
- GPL/LGPL tool outputs (FeynCalc, LieART) are stored as result tables only;
  no tool source code enters the Lean repository.
- Oracle fixtures validate; they do not prove.
