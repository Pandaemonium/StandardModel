# Literature queue

Use this queue for planned, in-progress, and integrated literature searches.

Template:

```text
## YYYY-MM-DD - Topic

Status: proposed | searching | triaged | ingested | integrated | dropped
Related gate: C0 | C1 | D | E | F | H | publication | other

Question:
- ...

Candidate sources:
- ...

Zotero/Neo4j status:
- ...

Takeaways:
- ...
```

## Current candidate searches

- Chiral lattice fermion constructions after taste-only no-go: overlap,
  domain-wall, Ginsparg-Wilson, mirror-decoupling, and null-edge-compatible
  variants.
- Accretive/non-normal Wilson regulators and branch-gap proofs for
  non-Hermitian or retarded/advanced doubled operators.
- Finite spectral triple restrictions on allowed finite Dirac operators,
  especially order-one, real structure, and forbidden leptoquark/proton-decay
  blocks.

## 2026-06-27 - C1 chiral release after taste-only no-go

Status: triaged
Related gate: C1

Question:

- After C88 shows taste-only origin polarization fails, what literature lanes
  remain credible for physical chiral release?

Searches:

- Neo4j paper search:
  `Gate C1 chiral release overlap domain wall Ginsparg Wilson mirror decoupling propagator zeros`
- Neo4j paper search:
  `RA Wilson regulator anti Hermitian positive scalar gap non Hermitian lattice fermions`
- Neo4j repo-doc search:
  `C1 physical chiral release overlap domain wall spinor-line projector taste-only no-go`
- Web/arXiv search for overlap/domain-wall/Ginsparg-Wilson chiral gauge theory,
  single-Weyl/domain-wall lattice formulations, and propagator-zero ghost
  warnings.

Candidate sources:

- Golterman-Shamir `2311.12790`, propagator zeros and lattice chiral gauge
  theories.
- Golterman-Shamir `2505.20436`, constraints on symmetric mass generation for
  lattice chiral gauge theories.
- Luscher `hep-lat/9802011`, exact chiral symmetry and the Ginsparg-Wilson
  relation.
- `2402.09774`, lattice Weyl fermions on a single curved surface.
- Catterall `2311.02487`, reduced Kahler-Dirac fermions and mirror/measure
  issues.
- Kimura-Creutz-Misumi `1011.0761`, overlap/index diagnostics with naive and
  minimally doubled fermions.

Zotero/Neo4j status:

- The main sources are already present in the Neo4j paper graph with Zotero keys
  for the null-edge collection. No new ingestion was required in this loop.

Takeaways:

- C1 should not be pursued as taste-only branch dressing. The next real C1 route
  should be overlap/domain-wall/Ginsparg-Wilson/spinor-line structure with a
  gauge-coupled ghost audit.
- The single-domain-wall result is useful as a warning: free single-Weyl
  localization can become vectorlike after gauge topology is included.
- Ghost safety needs more than scalar residue positivity; it should separate
  BRST/cohomological safety from Krein positivity.

## 2026-06-27 - Ghost-safety hardening and Gate H order-one sources

Status: triaged
Related gate: C1 | H

Question:

- Which literature sources support C90's ghost-safety hardening and the H9
  legal finite Dirac/order-one forbidden-block route?

Searches:

- Neo4j paper search:
  `BRST ghost zero Krein positivity lattice chiral gauge Wilson regulator projected release`
- Neo4j paper search:
  `finite spectral triple finite Dirac order one leptoquark proton decay Standard Model internal Dirac`

Candidate sources:

- Golterman-Shamir `2311.12790`, propagator zeros become gauge-coupled ghost
  states.
- Golterman-Shamir `2505.20436`, propagator zeros may require enlarged
  elementary-plus-composite interpolating-field bases and still face generalized
  no-go pressure.
- Bochniak-Sitarz `1804.09482`, finite pseudo-Riemannian spectral triples and
  the Standard Model.
- Cacic `0902.2068`, moduli spaces of Dirac operators for finite spectral
  triples.

Zotero/Neo4j status:

- These sources are already present in the local Neo4j paper graph. No new
  ingestion was required in this loop.

Takeaways:

- C90 should avoid treating `PostGaugeResiduePositive` as sufficient. A safer
  API separates BRST/cohomological safety, Krein positivity, and explicit
  absence or removability of gauge-coupled ghost zeros.
- H9's forbidden finite-Dirac route should be framed as finite spectral-triple
  order-one/moduli restriction work, not as a Furey-only claim.

## 2026-06-27 - C89/C90 concrete regulator and C1 source refresh

Status: triaged
Related gate: C0 | C1

Question:

- Does the literature refresh change the next C89/C90 move after the
  RA-Wilson C0 and projected-release hardening packets?

Searches:

- Neo4j paper search:
  `RA Wilson overlap domain-wall Ginsparg Wilson regulator concrete instantiation ghost zeros chiral gauge`
- Neo4j repo-doc search:
  `C89 RA-Wilson concrete instantiation C90 projected Gate C ghost safety BRST Krein`
- Web/arXiv search:
  Golterman-Shamir `2311.12790`, Luscher `hep-lat/9802011`, and single curved
  surface Weyl/domain-wall `2402.09774`.

Candidate sources:

- Golterman-Shamir `2311.12790`, propagator zeros and lattice chiral gauge
  theories.
- Luscher `hep-lat/9802011`, exact chiral symmetry on the lattice and the
  Ginsparg-Wilson relation.
- `2402.09774`, lattice Weyl fermions on a single curved surface.
- Golterman-Shamir `2505.20436`, constraints on symmetric mass generation.
- Kimura-Creutz-Misumi `1110.2482`, overlap/index diagnostics with naive and
  minimally doubled fermions.

Zotero/Neo4j status:

- The core sources are already present in the local paper graph. No new
  ingestion was required in this cycle.

Takeaways:

- The search supports the current C89/C90 order: first instantiate concrete
  C0 RA-Wilson species health, then harden projected release language.
- C1 still needs an overlap/domain-wall/Ginsparg-Wilson or spinor-line
  mechanism. RA-Wilson C0 evidence must not be promoted to physical chiral
  release.
- The doc-search query hit a Windows Unicode output failure on the first
  attempt and should be retried with UTF-8 output in future loops.

## 2026-06-27 - Cycle 1 C89/C90 overlap and ghost-zero refresh

Status: triaged
Related gate: C0 | C1

Question:

- After submitting C89/C90, does the current literature lane support moving
  immediately to C1 interface jobs?

Searches:

- Neo4j paper search:
  `concrete Wilson regulator overlap kernel Ginsparg Wilson projected chiral gauge ghost zeros RA Wilson`
- Neo4j repo-doc search:
  `C89 concrete RA-Wilson C90 projected release hardening C0 C1`

Candidate sources:

- Luscher `hep-lat/9802011`, exact lattice chiral symmetry and
  Ginsparg-Wilson.
- Golterman-Shamir `2311.12790`, propagator-zero ghost warning.
- Golterman-Shamir `2505.20436`, generalized no-go pressure and interpolating
  field lesson.
- Kimura-Creutz-Misumi `1110.2482` / `1011.0761`, overlap/index diagnostics
  for naive/minimally doubled fermions.

Zotero/Neo4j status:

- All useful sources returned by this search were already present locally; no
  new ingestion was required.

Takeaways:

- The literature supports Claude's recommendation: after C89/C90, the next wave
  should include a C1-facing overlap/Ginsparg-Wilson or domain-wall interface,
  not only more C0 polish.
## 2026-06-27 - Cycle 2 C1 overlap/domain-wall source refresh

Status: triaged
Related gate: C1

Question:

- What literature supports the first C1-facing interface after C89/C90?

Searches:

- Neo4j paper search:
  `Ginsparg Wilson overlap interface exact lattice chirality index theorem domain wall vectorlike obstruction null-edge`
- Neo4j repo-doc search:
  `C1 overlap Ginsparg Wilson interface domain wall anti-vectorialization Gate C1`

Candidate sources:

- `2402.09774`, single curved-surface Weyl/domain-wall vectorialization warning.
- `hep-lat/9803002`, extended Nielsen-Ninomiya theorem.
- Luscher `hep-lat/9802011`, exact chiral symmetry and Ginsparg-Wilson.
- Kimura-Creutz-Misumi `1011.0761` / `1110.2482`, overlap/index diagnostics.
- Minimally doubled four-dimensional index diagnostics `2602.19767`.

Zotero/Neo4j status:

- Returned sources are already in the local graph. No new ingestion was required.

Takeaways:

- C93 is a good C1 interface only if it requires an index/nontriviality slot and
  explicitly treats domain-wall vectorialization as a side condition.
- A future C94 should probably instantiate C93 against RA-Wilson and report the
  first missing field, rather than starting a second abstract interface.
