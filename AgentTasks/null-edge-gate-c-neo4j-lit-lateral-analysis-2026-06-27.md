# Gate C Neo4j literature search and lateral analysis

Date: 2026-06-27.

## Neo4j search capability test

Neo4j is reachable through the MCP `neo4j_graph` server.

Schema smoke test:

- `Paper`, `PaperChunk`, `NEDoc`, and `NEChunk` nodes are present.
- `PaperChunk.text` contains paper full-text chunks.
- `NEChunk.text` contains repo/document chunks.

Index smoke test:

```text
SHOW FULLTEXT INDEXES
```

returned no full-text indexes. So native Neo4j/Lucene full-text search is not
currently configured.

```text
SHOW VECTOR INDEXES
```

returned online vector indexes:

```text
paper_embedding
paper_chunk_embedding
ne_chunk_embedding
```

Conclusion:

- Keyword substring search over full text is possible by Cypher `CONTAINS`, but
  it is not using a native full-text index.
- Semantic search over full paper text is available through
  `Scripts/lit/neo4j_paper_search.py --chunks`, which queries
  `paper_chunk_embedding`.
- Semantic search over repo/doc chunks is available through
  `Scripts/lit/neo4j_doc_search.py`, which queries `ne_chunk_embedding`.

Representative Cypher keyword smoke test:

```cypher
MATCH (c:PaperChunk)
WHERE toLower(c.text) CONTAINS 'propagator zeros'
RETURN c.paper_key, c.arxiv_id, c.section, c.ord, substring(c.text,0,360)
LIMIT 5
```

returned chunks from Golterman-Shamir `2311.12790` and the 2025 constraints
paper `2505.20436`.

## Literature hits relevant to Gate C

Semantic full-text paper chunk search surfaced these anchors:

- Golterman-Shamir, "Propagator zeros and lattice chiral gauge theories",
  arXiv:2311.12790. This is the hard ghost-zero guardrail: propagator zeros
  coupled to gauge fields can act as ghost states, contribute anomalies like
  poles, and damage unitarity.
- Golterman-Shamir, "Constraints on the symmetric mass generation paradigm for
  lattice chiral gauge theories", arXiv:2505.20436. This strengthens the mirror
  / propagator-zero warning and suggests that avoiding zeros may require a
  larger field/interpolating set.
- Luscher, "Exact chiral symmetry on the lattice and the Ginsparg-Wilson
  relation", hep-lat/9802011. This is the clean overlap/GW symmetry anchor:
  lattice chiral symmetry is realized differently from naive chirality.
- Creutz-Kimura-Misumi, "Index Theorem and Overlap Formalism with Naive and
  Minimally Doubled Fermions", arXiv:1011.0761, plus the related arXiv:1110.2482
  paper. These support flavored masses, point splitting, spectral flow, and
  overlap constructions for nonstandard kernels.
- Creutz, "Minimal doubling and point splitting", arXiv:1009.3154. This is the
  branch/species point-splitting anchor.
- Durr-Weber, "Minimally doubled fermions and topology in 2D", arXiv:2108.11766,
  and newer minimally doubled index work arXiv:2602.19767. These support the
  lesson that topology/chirality sensitivity may require species-splitting or
  modified chirality operators.
- Kaplan, "Chiral Symmetry and Lattice Fermions", arXiv:0912.2560. This is the
  domain-wall/overlap/GW review anchor for C1 routes.
- "A Lattice Formulation of Weyl Fermions on a Single Curved Surface",
  arXiv:2402.09774. This is a useful anti-vectorialization warning: even a
  single-wall Weyl-looking construction can recover an opposite chirality mode
  when gauge/topological data are included.

## Lateral Gate C analysis

The literature supports the current C0/C1 split and sharpens it.

### 1. Bank C0 as a theorem

If the external doubled symbol is anti-Hermitian and `W(q) >= 0`, then:

```text
||(A(q) + r W(q) I) v||^2
  = ||A(q) v||^2 + r^2 W(q)^2 ||v||^2.
```

This proves a lower singular-value bound `>= r W(q)`. For
`W(q) = sum_a (1 - cos q_a)`, this gaps every non-origin real-torus zero without
classifying the full determinant-zero locus. This is excellent C0 evidence and
should be closed as C0 only.

### 2. Treat raw overlap as a hazard to test

The direct overlap kernel:

```text
X_rho(q) = D_+(q) + r W(q) I - rho I
H_rho(q) = Gamma_s X_rho(q)
```

requires the shifted Hermitian kernel to be invertible. If an unwanted
determinant-zero branch germ satisfies `q(t) -> 0`, `D_+(q(t)) v(t) = 0`, and
`r W(q(t)) = rho` for some small `rho`, then `X_rho(q(t)) v(t) = 0`. The sign
function is singular. Raw unprojected overlap on the full bare `D_+` is
therefore not a default C1 route; it needs a mass-window theorem.

### 3. Look for the null-edge-native escape hatch

The most native possible C1 route is a branch classifier:

```text
T_br^2 = 1
```

or a projector:

```text
Pi_br(q)
```

that is not scalar on the balanced origin kernel and separates branch germs,
not merely taste labels. If such data exist with locality/quasi-locality,
gauge neutrality, and Krein positivity, then projected overlap or a
spinor-line Wilson lift has a concrete route. If no such classifier can be
analytic/local/gauge-safe, Gate C must move to domain-wall or controlled
quasi-local projected constructions.

### 4. Strengthen the scalar no-go

The scalar Wilson no-go should be generalized:

```text
Any analytic, translation-invariant deformation that is scalar on the balanced
origin kernel and vanishes at least quadratically at the origin cannot turn the
origin kernel into one Weyl line.
```

This classifies the minimal non-scalar escape hatch. A C1 mechanism must change
the origin kernel's line structure, not just add an irrelevant scalar branch
cost.

### 5. Make C1 a release datum

Gate C1 should be a theorem about a record:

```text
ReleaseData =
  (D_gap, Pi_phys, D_phys, Gamma_lat, physical/Krein data)
```

not about a bare corrected symbol. Required clauses should include:

```text
C0 species gap;
physical projector local or controlled quasi-local;
one Weyl line selected at the origin;
mirror sector absent or true inverse-propagator gapped;
no gauge-charged propagator-zero removal;
continuum Weyl symbol on the retained line;
positive physical sector;
anomaly accounting.
```

## Suggested Aristotle jobs

1. C101: formal C0 scalar-Wilson gap closeout.
2. C102: direct-overlap shifted-kernel singular-crossing theorem.
3. C103: scalar-on-origin balanced-kernel no-go.
4. C104: branch classifier / `T_br` / `Pi_br` exists-or-no-go API.
5. C105: release-datum and domain-wall/projected-overlap route audit.
