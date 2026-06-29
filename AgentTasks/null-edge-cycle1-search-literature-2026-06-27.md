# Cycle 1 search and literature note

Date: 2026-06-27

Purpose: record the Neo4j and literature-search evidence used for the current
Gate C1 Aristotle round.

## Local doc search

Command:

```text
Scripts/lit/neo4j_doc_search.py --query "Wilson Neuberger CKM texture GateC1_NU kappa homotopy non-ultralocal control" --k 8
```

Top hits were concentrated in:

```text
Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md
```

The search confirmed that the repo already has the non-ultralocal API, claim
boundary, and control-certificate framing. The new Pro contribution is not a
new branch, but a sharper role split:

```text
Wilson/Neuberger handles spacetime doubling.
CKM handles finite branch/flavor splitting.
```

## Paper chunk search

Command:

```text
Scripts/lit/neo4j_paper_search.py --query "Wilson Neuberger overlap CKM flavored mass null-edge Gate C1 homotopy locality index anomaly" --chunks --k 8
```

Most relevant returned chunks:

```text
Creutz, Kimura, Misumi, "Index Theorem and Overlap Formalism with Naive and
Minimally Doubled Fermions", arXiv:1011.0761.

Related minimally doubled and flavored-mass literature.

Furey/Hughes internal-space material relevant to the SMActsInternally audit.
```

Interpretation:

```text
CKM/flavored-overlap papers are strong supporting evidence that flavored mass
terms can split species and feed an overlap construction.

They do not by themselves prove that the actual null-edge kinetic kernel is
doubler-resolved.

Therefore the safest first physical import remains Wilson/Neuberger overlap,
with CKM as an internal finite texture.
```

## Search-informed next tasks

The next Aristotle round should focus on:

```text
C194: specify the null-edge Wilsonized kinetic endpoint and kappa certificate.
C195: turn Wilson/Neuberger source theorems into explicit import interfaces.
C196: define and audit the sector-signature map.
C197: check SMActsInternally for the Furey/Hughes factorization.
C198: design a multi-stage homotopy fallback if direct kappa control fails.
C199: high-level strategy audit for fastest GateC1_NU closure.
```
