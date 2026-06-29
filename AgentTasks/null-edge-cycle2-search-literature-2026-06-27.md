# Cycle 2 search and literature note

Date: 2026-06-27

Purpose: record the search evidence after C193 completed the free
Wilson+CKM mass-window theorem.

## Neo4j doc search

Command:

```text
Scripts/lit/neo4j_doc_search.py --query "C193 gamma_free sign window kappa homotopy Wilson Neuberger CKM sector signature GateC1" --k 10
```

Most relevant local hits were older Gate C decision-protocol material and
recent Gate C1 non-ultralocal planning. The useful reminder was that sign
splitting alone is not enough:

```text
Gate C still requires determinant/propagator-zero enumeration,
species/taste/nodal classification, branch selection, inverse gap, and ghost
safety.
```

C193 should therefore be treated as the reference sign-window certificate, not
as a full release theorem.

## Neo4j paper chunk search

Command:

```text
Scripts/lit/neo4j_paper_search.py --query "overlap Dirac operator spectral gap sign function homotopy index stability Wilson kernel locality admissibility" --chunks --k 10
```

Useful hits:

```text
Properties of minimally doubled fermions:
  notes that exact Ginsparg-Wilson operators are not ultralocal.

Creutz-Kimura-Misumi flavored-overlap papers:
  point splitting and flavored mass terms support species/flavor splitting,
  but do not replace the Wilson/Neuberger reference import for the actual
  null-edge kinetic operator.

Discrete/metric graph index theorem literature:
  possibly relevant to graph operator intuition, but not the first C1 source
  lane.
```

## Scholarly/arXiv search

Semantic Scholar-backed search was rate-limited. arXiv searches returned the
core source stack:

```text
Neuberger, "Exactly massless quarks on the lattice", hep-lat/9707022:
  overlap determinant/sign-function construction with Wilson kernel, no
  unwanted doubling.

Neuberger, "More about exactly massless quarks on the lattice",
hep-lat/9801031:
  constructed matrix obeys the Ginsparg-Wilson relation.

Luscher, "Exact chiral symmetry on the lattice and the Ginsparg-Wilson
relation", hep-lat/9802011:
  exact lattice chiral symmetry and modified chiral transformation.

Hernandez-Jansen-Luscher, "Locality properties of Neuberger's lattice Dirac
operator", hep-lat/9808010:
  exponential locality under smooth/admissible gauge hypotheses.

Adams, "Axial anomaly and topological charge in lattice gauge theory with
Overlap Dirac operator", hep-lat/9812003:
  continuum anomaly/index density in the physical mass window.

Luscher, "Abelian chiral gauge theories on the lattice with exact gauge
invariance", hep-lat/9811032, and "Lattice regularization of chiral gauge
theories to all orders of perturbation theory", hep-lat/0006014:
  determinant-line/anomaly-free chiral gauge source lane.

Golterman-Shamir, "Propagator zeros and lattice chiral gauge theories",
arXiv:2311.12790:
  propagator zeros can behave as ghost states when gauge fields are turned on.

Golterman-Shamir, "Constraints on the symmetric mass generation paradigm for
lattice chiral gauge theories", arXiv:2505.20436:
  newer constraint paper relevant to the no-ghost/no-zero-removal audit.
```

## Search-informed next tasks

C193 changes the next task selection:

```text
C200: promote/port the C193 theorem package into a project draft module.
C201: prove an abstract sign-pattern stability theorem using gamma_free.
C202: prove/plan a Riesz or spectral-projector persistence theorem for the
      physical branch under a maintained gap.
C203: create a source-backed theorem-contract map for the overlap reference
      stack, with exact claim boundaries and source IDs.
```

These complement the running C194-C199 jobs.
