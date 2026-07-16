# Archive baseline source tranche 2

## Metadata

- Work item: `ARCHIVE-BASELINE-001`
- Operator: Codex / Archivist
- Date: 2026-07-13
- Scope: four remaining foundational source rows

This tranche resolves four `NEEDS-VERIFY` rows without promoting any
program-internal theorem. It distinguishes primary content checks from DOI
metadata and leaves every transfer hypothesis explicit.

## Resolved rows

### Nielsen-Ninomiya

- Canonical graph key: `CP84QBM4`.
- Primary papers:
  - DOI `10.1016/0550-3213(81)90361-8`, proof by homotopy theory;
  - DOI `10.1016/0550-3213(81)90524-1`, intuitive topological proof.
- Checked boundary: the second paper's primary abstract presents the no-go for
  Weyl fermions/chiral lattice QCD and explicitly says that dropping the
  charge/complex-field assumptions changes the conclusion. The original text
  also displays locality, translation invariance, Hermiticity, and exact local
  quantized charge assumptions.
- Project scope: comparison only. This is not a universal no-go for all finite
  null-edge walks and is not substituted for the project's scoped alias proof.

### McKean-Singer

- DOI: `10.4310/jdg/1214427880`.
- Canonical metadata: H. P. McKean, Jr. and I. M. Singer, "Curvature and the
  eigenvalues of the Laplacian," *Journal of Differential Geometry* 1 (1967),
  43-69.
- Disposition: `PRIMARY-METADATA-VERIFIED`, not content-checked. The row is an
  analytic heat-kernel/index comparison only. Compact elliptic geometry,
  operator domains, and normalization remain claim-scope debt.

### Malament

- DOI: `10.1063/1.523436`.
- Primary abstract record: AIP content preserved by the U.S. Department of
  Energy OSTI record `7310021`.
- Checked boundary: the title assertion is proved; the causal-structure
  corollary is explicitly scoped to past- and future-distinguishing
  spacetimes. The result does not determine metric scale or construct a finite
  tetrad/decoration.

### Hawking-King-McCarthy

- DOI: `10.1063/1.522874`.
- Primary abstract record: AIP content preserved by OSTI record `4057748`.
- Checked boundary: the path topology is proposed for strongly causal
  spacetimes and determines causal, differential, and conformal structure.
  It does not provide volume scale, a canonical finite decoration, or a field
  equation.

## Evidence and service notes

- Neo4j semantic lookup returned the existing Nielsen-Ninomiya node
  `CP84QBM4` first at score `0.868`.
- Exact external searches used the primary publisher records where available
  and OSTI's preserved AIP metadata/abstracts for the two causal-order papers.
- The unauthenticated Semantic Scholar and Crossref endpoints returned HTTP
  429 during this pass. No missing record was inferred from those rate limits.
- No Zotero or Neo4j mutation was performed in this tranche.

## Remaining debt

The pre-existing `TBD-NielsenNinomiya1981` / INSPIRE 155854 stub was
reconciled with canonical graph key `CP84QBM4` and deleted. Its unsupported
claim that Krein `J`-hermiticity "trades" the Nielsen-Ninomiya no-go was not
carried forward: the verified source row remains a comparison only. Any future
evasion claim requires a separate atomic theorem and work item.

Six actual `NEEDS-VERIFY` rows remain:

1. Connes real-structure / KO convention.
2. Tomita-Takesaki state-dependent modular convention.
3. Shale-Stinespring implementability.
4. Hyperuniformity and Coulomb sum rules.
5. Koide's original relation.
6. Wilczek's "Mass without mass" essays.

The Zotero duplicate for arXiv `1709.04891` also remains manual library debt;
the Neo4j graph identity is already canonical.
