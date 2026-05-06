# Scripts

External tooling scripts for oracle generation, index building, and CI support.

Scripts here produce data used by the Lean project but are not themselves Lean code.
They may use Python, SageMath, Julia, or other languages.

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

## Subdirectory plan

```
Scripts/
  pre-commit.cmd        - Windows wrapper for a repo-local pre-commit cache
  pre-commit.ps1        - run pre-commit with a repo-local cache
  oracle/
    sage_roots.py       — generate root system fixtures via SageMath
    lieart_branching.py — generate branching rule fixtures via LieART (Mathematica)
    sympy_gamma.py      — generate gamma matrix identity fixtures via SymPy
  index/
    build_index.py      — extract declaration metadata from Lean sources into JSON
    build_graph.py      — build knowledge graph from declaration metadata
  ci/
    check_no_sorry.sh   — shell script for local no-sorry checking
```

## Oracle policy

- Oracle scripts must record tool name, version, and input conventions.
- Output is stored as numeric/symbolic fixture data only.
- GPL/LGPL tool outputs (FeynCalc, LieART) are stored as result tables only;
  no tool source code enters the Lean repository.
- Oracle fixtures validate; they do not prove.
