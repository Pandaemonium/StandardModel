# Cycle 4 search and literature note

Date: 2026-06-27

Purpose: record search results after integrating C204-C208.

## Neo4j doc search

Command:

```text
Scripts/lit/neo4j_doc_search.py --query "C205 C206 kappaBranch kappaKin kappaWil gamma_free H_ne Clifford anticommutation ReferenceIsGapped concrete instantiation" --k 10
```

Top relevant hits pointed to existing null-edge Clifford-symbol work:

```text
PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean;
NullEdgeTetrahedralCliffordSymbol planning notes;
NullEdgeBranchClassifierAPI.lean.
```

Interpretation:

```text
The concrete C205 Clifford anticommutation/norm input should be connected to
the existing actual Clifford-symbol module before inventing new symbols.
```

## Neo4j paper chunk search

Command:

```text
Scripts/lit/neo4j_paper_search.py --query "Wilson Dirac operator Clifford anticommutation spectral gap overlap Neuberger mass window proof" --chunks --k 10
```

Useful hits:

```text
Ginsparg-Wilson/minimal-doubling literature:
  reinforces the non-ultralocal/GW context.

Wilson fermion spectral-graph literature:
  relevant to expressing Wilson Dirac structure as graph/spectral data.

General Dirac/Lichnerowicz literature:
  secondary support for Clifford norm-square identities.
```

## Scholarly/arXiv search

Queries:

```text
Wilson Dirac operator spectral gap mass window overlap fermions Neuberger proof
Hasenfratz Laliena Niedermayer index theorem finite cutoff Ginsparg Wilson
Narayanan Neuberger chiral determinant vacuum overlap lattice
Davis Kahan sin theta theorem spectral subspace perturbation arxiv
```

Results:

```text
Narayanan-Neuberger, "Chiral Determinant as an Overlap of Two Vacua",
hep-lat/9307006, was recovered directly.

Kaplan-Schmaltz, "Domain Wall Fermions and the Eta Invariant",
hep-th/9510197, was also recovered as determinant/domain-wall support.

The other exact source queries did not return direct arXiv hits in this pass;
C208's source-audit queue remains the better guide for those.
```

## Search-informed next tasks

```text
C209: map existing NullEdgeActualCliffordSymbol/BranchClassifier work into the
      C205 ReferenceIsGapped anticommutation input.
C210: prove exact-match kappa zero in the flat aligned endpoint, or isolate the
      first nonzero mismatch.
C211: prepare a real-artifact draft-promotion execution checklist with exact
      source artifact paths and target files.
C212: build the GateC1_NU_Free concrete-instantiation checklist from C205/C206.
C213: determinant-line source follow-up for Narayanan-Neuberger and
      Hasenfratz-Laliena-Niedermayer.
```
