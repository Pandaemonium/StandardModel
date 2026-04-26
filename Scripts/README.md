# Scripts

External tooling scripts for oracle generation, index building, and CI support.

Scripts here produce data used by the Lean project but are not themselves Lean code.
They may use Python, SageMath, Julia, or other languages.

## Subdirectory plan

```
Scripts/
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
