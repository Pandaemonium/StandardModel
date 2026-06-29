Project name: gate-c1-graph-matrix-source-contract-c223

You are Aristotle, working on the StandardModel Lean/null-edge project.

Cycle 7 search recovered two graph-matrix support papers:

```text
Yumoto-Misumi, "Lattice fermions as spectral graphs", arXiv:2112.13501.
Yumoto-Misumi, "Equivalence of lattice operators and graph matrices",
arXiv:2311.11320.
```

Task:

1. Write a doc-ready source-contract insertion for these papers.
2. Map each paper to exact Gate C1 certificate fields:

```text
H_ref.graph_matrix_representation;
H_ref.wilson_laplacian_term;
H_ref.corner_or_DFT_diagonalization;
H_ref.species_count_support.
```

3. State what these sources do not support.
4. Identify whether either should affect `H_ne`.
5. Return a concise paragraph/table for the docs.

Success criteria:

```text
Support H_ref only.
No claim about H_ne or full GateC1_NU.
Clear source-to-field mapping.
```

Please finish with:

```text
Source-contract table:
Allowed claims:
Forbidden claims:
Doc insertion text:
```
