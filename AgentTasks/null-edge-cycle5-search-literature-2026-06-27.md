# Cycle 5 search and literature note

Date: 2026-06-27

Purpose: record search results after integrating C209-C213.

## Neo4j doc search

Command:

```text
Scripts/lit/neo4j_doc_search.py --query "GateC1_NU_Free concrete carrier basis exact field H_ref H_ne kappa operator freeze NullEdgeActualCliffordSymbol" --k 10
```

Most relevant hits:

```text
Sources/NullStrand_Lean_Roadmap_Improved.md:
  Gate C warnings that the bare tetrahedral symbol is chirality-balanced and
  not itself a release.

PhysicsSM/Draft/NullEdgeActualCliffordSymbol.lean notes:
  existing actual Clifford-symbol work should be reused for the C205
  anticommutation/norm bridge.

PhysicsSM/Draft/NullEdgeBranchClassifierAPI.lean:
  existing branch-classifier API should be connected to C196/C207.
```

## Neo4j paper chunk search

Command:

```text
Scripts/lit/neo4j_paper_search.py --query "finite matrix spectral gap exact arithmetic Wilson Dirac overlap operator Clifford lattice fermions" --chunks --k 10
```

Most useful result:

```text
Yumoto-Misumi, "Lattice fermions as spectral graphs", arXiv:2112.13501:
  Wilson/naive/domain-wall Dirac matrices can be studied as spectral graphs;
  DFT diagonalization is used to count species/zero eigenvalues.
```

Interpretation:

```text
This is relevant to the concrete finite-matrix operator-freeze task, especially
if we represent the Wilson reference as an exact finite matrix and diagonalize
with a DFT-style basis.
```

## Scholarly/arXiv search

Recovered:

```text
Yumoto-Misumi, "Lattice fermions as spectral graphs", arXiv:2112.13501.
```

Other narrow searches for Dirac-Kahler/noncommutative forms and very specific
Luscher momentum assumptions did not return useful direct hits in this pass.

## Search-informed next tasks

```text
C214: finite carrier/basis/operator freeze proposal using existing project
      Clifford and branch modules.
C215: concrete H_ref matrix-entry theorem and DFT/spectral-graph route.
C216: concrete H_ne endpoint matrix-entry and transport route.
C217: exact/interval arithmetic plan for proving the kappa inequality.
C218: strategy job deciding whether to do local Lean promotion before more
      speculative jobs.
```
