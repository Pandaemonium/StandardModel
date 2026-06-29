# Cycle 3 search and literature note

Date: 2026-06-27

Purpose: record search results after integrating C194-C203.

## Neo4j doc search

Command:

```text
Scripts/lit/neo4j_doc_search.py --query "C194 C201 C202 ReferenceIsGapped NullEdgeKineticCloseEnough gamma_free kappa GateC1 critical path" --k 10
```

The search surfaced older Gate C branch-locus/API notes and the earlier
branch-classifier API. The useful reminder is:

```text
The kappa/gamma_free route must still be connected to the existing branch API:
branch classifier, physical-sector projector, ghost safety, and sector release.
```

## Neo4j paper chunk search

Command:

```text
Scripts/lit/neo4j_paper_search.py --query "spectral gap perturbation Riesz projection stability overlap Dirac index homotopy Wilson Neuberger" --chunks --k 10
```

Useful hits:

```text
Creutz-Kimura-Misumi flavored-overlap papers:
  still useful for flavored mass and spectral-flow intuition.

Ginsparg-Wilson/minimal-doubling reviews:
  reinforce that exact GW operators are generally non-ultralocal.

Discrete/metric graph index theorem literature:
  potentially useful for graph intuition, not first-line C1 closure.
```

## Scholarly/arXiv/web search

Scholarly arXiv/INSPIRE queries were sparse for the exact phrase "gapped
homotopy", so a web search was used for standard mathematical perturbation
sources.

Useful sources:

```text
Kato, Perturbation Theory for Linear Operators:
  classical source for isolated spectral subspaces and Riesz projection
  stability.

Davis-Kahan sin-theta theorem:
  practical finite-dimensional matrix subspace perturbation estimate.

Hasenfratz-Laliena-Niedermayer, "The index theorem in QCD with a finite cutoff",
hep-lat/9801021:
  missing lattice index source flagged by C203.

Fujikawa, "A continuum limit of the chiral Jacobian in lattice gauge theory",
hep-th/9811235:
  secondary source discussing the Hasenfratz-Laliena-Niedermayer and Luscher
  lattice index/Jacobian framework.
```

Search URLs used:

```text
https://webhomes.maths.ed.ac.uk/~v1ranick/papers/kato1.pdf
https://arxiv.org/html/2510.22393v1
https://inspirehep.net/literature/479984
https://link.aps.org/doi/10.1103/PhysRevD.60.074505
```

## Search-informed next tasks

The next Aristotle round should target:

```text
C204: promote real C193/C194/C201/C202 artifacts into project draft modules,
      explicitly avoiding the unsafe C200 reconstruction.
C205: prove ReferenceIsGapped for the concrete Wilson+CKM reference.
C206: specify concrete H_ne and NullEdgeKineticCloseEnough inputs.
C207: assemble a GateC1_NU_Free theorem from C193/C194/C201/C196/C202.
C208: audit and add the missing index/projection perturbation sources.
```
