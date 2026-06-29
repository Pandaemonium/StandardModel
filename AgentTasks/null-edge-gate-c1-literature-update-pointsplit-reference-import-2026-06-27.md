# Null-edge Gate C1 literature update: point-split and flavored-overlap route

Date: 2026-06-27

Searches performed:

```text
web: point splitting flavored mass naive overlap minimally doubled fermions
web: Adams staggered overlap flavored mass
web: staggered overlap locality
Neo4j chunks: point splitting flavored mass naive overlap minimally doubled fermions sector signature spectral flow
Neo4j chunks: staggered overlap flavored mass Adams locality admissibility taste dependent mass
Neo4j chunks: Ginsparg Wilson overlap index theorem anomaly gapped homotopy sign function locality
```

## Key references

1. Creutz, Kimura, Misumi, `Index Theorem and Overlap Formalism with Naive and Minimally Doubled Fermions`, arXiv:1011.0761 / JHEP 2010.

Use:

```text
point splitting implements flavored mass terms;
spectral flow of Hermitian Dirac operators detects index;
naive overlap kernels with flavored masses can yield single-flavor overlap.
```

2. Kimura, Creutz, Misumi, arXiv:1110.2482.

Use:

```text
same point-splitting/flavored-mass framework, with emphasis on species doublers
and overlap kernels whose flavor count depends on mass choice.
```

3. Adams, `Pairs of chiral quarks on the lattice from staggered fermions`, arXiv:1008.2833.

Use:

```text
flavored mass reduces staggered tastes and converts flavored chiral symmetry to
unflavored Ginsparg-Wilson symmetry; domain-wall truncation exists.
```

4. Chreim, Hoelbling, Zielinski, `Locality of staggered overlap operators`, arXiv:2203.06116.

Use:

```text
staggered overlap locality is provable under admissibility conditions;
locality/control should be an explicit certificate, not a free consequence.
```

## Impact on null-edge Gate C1

The literature supports treating `W_branch` as a flavored/species-splitting mass,
not an arbitrary correction. But C163 shows the pure product mass has a multiplet
obstruction. So the best reference-matched direction is:

```text
point-split parity mass
  + level-resolving Adams/Wilson-style term
  -> one-sector window
  -> direct flavored-overlap or abstract block reference import.
```

This is compatible with the C159 reference-import architecture and the C156
path-shell/locality certificate.
