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

## 2026-06-27 - Cycle 3 ghost-safety source refresh

Status: triaged
Related gate: C0 | C1

Question:

- What literature supports separating scalar residue positivity, Krein
  positivity, exact chirality, and C0 species health from full ghost safety?

Searches:

- Neo4j paper search:
  `Golterman Shamir propagator zeros ghost gauge coupled BRST Krein positivity residue lattice chiral gauge`
- Neo4j repo-doc search:
  `ghost zero safety PostGaugeResiduePositive BRST Krein NoGaugeCoupledGhostZeros C90 C92`

Candidate sources:

- Golterman-Shamir `2311.12790`, propagator zeros as gauge-coupled ghost states.
- Golterman-Shamir `2505.20436`, interpolating-field/composite-basis lesson.
- Catterall/reduced Kahler-Dirac mirror-sector measure literature.
- Luscher `hep-lat/9802011`, exact chirality not equal to ghost safety.
- `2402.09774`, domain-wall vectorialization warning.

Zotero/Neo4j status:

- Returned sources are already present locally. No new ingestion was required.

Takeaways:

- C92 should include concrete countermodels or it should be considered weak.
- Exact chirality and Krein positivity must be kept separate from ghost safety.
## 2026-06-27 cycle 4

Mandatory literature/repo search performed.

Paper query:

```text
overlap Ginsparg Wilson interface concrete instantiation Wilson kernel spectral gap index nontrivial null edge
```

Key hits:

- Kimura-Creutz-Misumi overlap/index work for naive/minimally doubled fermions, arXiv:1110.2482 and arXiv:1011.0761.
- Nielsen-Ninomiya extension warning, arXiv:hep-lat/9803002.
- Luscher exact lattice chiral symmetry / GW relation, arXiv:hep-lat/9802011.

Repo-doc query:

```text
C94 instantiate C93 overlap interface RA Wilson kernel gap index anti vectorialization
```

The first run hit a Windows stdout encoding failure; UTF-8 rerun completed.
## 2026-06-27 cycle 5

Mandatory literature/repo search performed.

Paper query:

```text
Wilson regulator removal overlap chiral index vectorlike mirror decoupling Ginsparg Wilson regulator limit
```

Key hits:

- Luescher exact chiral symmetry / Ginsparg-Wilson relation, arXiv:hep-lat/9802011.
- Reduced Kahler-Dirac mirror/measure warnings, arXiv:2311.02487.
- Golterman-Shamir propagator-zero ghost warning, arXiv:2311.12790.
- Golterman-Shamir SMG constraints, arXiv:2505.20436.
- Nielsen-Ninomiya extension, arXiv:hep-lat/9803002.
- Minimally doubled counterterm warnings, arXiv:0910.2597 and arXiv:1006.2009.

Repo-doc query:

```text
regulator removal consistency C1 anti vectorialization Wilson overlap null edge
```
## 2026-06-27 cycle 6

Mandatory literature/repo search performed.

Paper query:

```text
lattice chiral gauge mirror decoupling anomaly conservation nonvectorlike witness finite branch table regulator removal
```

Key hits:

- Reduced Kahler-Dirac mirror/measure warnings, arXiv:2311.02487.
- Golterman-Shamir propagator-zero ghost warning, arXiv:2311.12790.
- Golterman-Shamir SMG constraints, arXiv:2505.20436.
- Luescher exact chiral symmetry / Ginsparg-Wilson relation, arXiv:hep-lat/9802011.
- Nielsen-Ninomiya / absence of lattice neutrinos no-go lane.
- Minimally doubled counterterm/taste-breaking warnings.

Repo-doc query:

```text
C95 anti-vectorialization C96 regulator removal vectorlike witness anomaly conservation
```
## 2026-06-27 cycle 7 literature record

Query/source:

- Web/arXiv-style search phrase: `anti-vectorialization vectorlike spectrum chiral index finite branch table lattice chiral gauge`.
- Repo search phrase: `C95 anti-vectorialization vectorlike spectrum nonzero index C0 health branch table`.

Result summary:

- Relevant comparison lanes remain overlap/Ginsparg-Wilson chiral index, Nielsen-Ninomiya pressure, minimally doubled spectral/index diagnostics, Golterman-Shamir propagator-zero safety, reduced Kahler-Dirac chiral regularization, and spectral-graph species counting.
- Repo search found no stronger pre-existing C95-style finite anti-vectorialization API beyond the returned C95 module.

Plan impact:

- Reinforced that C95 is only a finite bookkeeping guardrail unless connected to a real operator/regulator line.
- Reinforced the need for a data-carrying nonzero chiral witness rather than interface shape alone.

Follow-up:

- Use these lanes when hardening C95 and when auditing C98/C93 returns.
## 2026-06-27 cycle 8 literature record

Query/source:

- Web/arXiv query: `overlap Ginsparg Wilson chiral index mirror fermions vectorlike regulator removal lattice chiral gauge theories`.
- Web/arXiv query: `Golterman Shamir propagator zeros lattice chiral gauge theories ghost mirror fermions`.
- Web/arXiv query: `anti-vectorlike chiral index lattice fermion spectrum vectorlike pairs`.

Sources opened:

- Golterman-Shamir, `arXiv:2311.12790`, `Propagator zeros and lattice chiral gauge theories`.
- Golterman-Shamir, `arXiv:2505.20436`, `Constraints on the symmetric mass generation paradigm for lattice chiral gauge theories`.
- Luscher, `arXiv:hep-lat/9802011`, `Exact chiral symmetry on the lattice and the Ginsparg-Wilson relation`.

Result summary:

- Propagator zeros and mirror-sector vectorlike constraints remain central hazards for any C1 release claim.
- Overlap/Ginsparg-Wilson chiral-index language remains the correct comparison class for a future non-toy index witness.

Plan impact:

- Supports C99 as an independent finite chiral-index substrate job.
- Reinforces that C97/C98 must stay planning-only until connected to real operator data.
## 2026-06-27 cycle 9 literature record

Query/source:

- Web/arXiv query: `finite dimensional chiral index Z2 graded operator kernel dimension plus minus linear algebra`.
- Web/arXiv query: `Ginsparg Wilson finite dimensional index trace gamma5 Dirac operator kernel chiral zero modes`.
- Web/arXiv query: `lattice chiral index finite matrix gamma5 hermitian Dirac operator kernel plus minus`.

Source anchors:

- Luscher, `arXiv:hep-lat/9802011`, exact chiral symmetry and the Ginsparg-Wilson relation.
- Golterman-Shamir, `arXiv:2311.12790`, propagator zeros and lattice chiral gauge theories.
- Golterman-Shamir, `arXiv:2505.20436`, constraints on symmetric mass generation for lattice chiral gauge theories.

Result summary:

- Reinforced that the next useful C1 index layer must compute index from operator/kernel data, not from arbitrary toy count fields.
- No new source displaced the current C99-first plan.

Plan impact:

- Keep C99 as the active finite index-substrate job.
- Avoid more toy count-field jobs unless C99 fails.
## 2026-06-27 cycle 10 literature record

Query/source:

- Web/arXiv query: `finite-dimensional Ginsparg Wilson relation index theorem trace gamma5 finite matrix`.
- Web/arXiv query: `overlap Dirac operator finite lattice index kernel chirality theorem`.
- Web/arXiv query: `Ginsparg Wilson index finite lattice chiral zero modes trace gamma5`.

Source anchors:

- Luscher, `arXiv:hep-lat/9802011`, exact chiral symmetry and the Ginsparg-Wilson relation.
- Golterman-Shamir, `arXiv:2311.12790`, propagator zeros and lattice chiral gauge theories.
- Golterman-Shamir, `arXiv:2505.20436`, constraints on symmetric mass generation for lattice chiral gauge theories.

Result summary:

- Reinforced that a finite chiral-index substrate needs a grading/gamma5 analogue and index computed from kernel data.
- No new literature lead displaced the current C99/C93/C92/C89 wait strategy.

Plan impact:

- Added explicit grading-involution criterion to the C99 acceptance note.
## 2026-06-27 cycle 11 literature record

Query/source:

- Web/arXiv query: `lattice chiral gauge theory overlap domain wall mirror fermion decoupling exact chiral symmetry review`.
- Web/arXiv query: `Kaplan domain wall fermions chiral gauge mirror decoupling overlap Narayanan Neuberger`.
- Web/arXiv query: `finite lattice chiral gauge theory Ginsparg Wilson domain wall mirror fermions no-go`.

Source anchors:

- Luscher, `arXiv:hep-lat/9802011`, exact chiral symmetry and Ginsparg-Wilson relation.
- Golterman-Shamir, `arXiv:2311.12790`, propagator zeros and lattice chiral gauge theories.
- Golterman-Shamir, `arXiv:2505.20436`, constraints on symmetric mass generation for lattice chiral gauge theories.

Result summary:

- No new source displaced the current queue. The literature continues to support waiting for the overlap/GW interface, ghost-zero API, and regulator/removal handle before reviving C94/C96.

Plan impact:

- No new science job launched. Local effort went to integration-helper repair.
## 2026-06-27 cycle 12 literature record

Query/source:

- Web/arXiv query: `Neuberger overlap Dirac operator index theorem finite lattice gamma5 trace`.
- Web/arXiv query: `Ginsparg Wilson relation exact lattice chiral symmetry finite volume index theorem`.
- Web/arXiv query: `domain wall fermions overlap index chiral gauge finite lattice mirror sector`.

Source anchors:

- Luscher, `arXiv:hep-lat/9802011`, exact lattice chiral symmetry and Ginsparg-Wilson relation.
- Neuberger / overlap-Dirac index literature as the finite-volume index comparison lane.
- Golterman-Shamir, `arXiv:2311.12790` and `arXiv:2505.20436`, for propagator-zero and mirror/vectorlike hazards.

Result summary:

- Reinforced that C99 needs a gamma5-like grading/operator compatibility relation, not just derived counts.
- Reinforced that C99/C99b remain substrate/template layers, not release evidence.

Plan impact:

- C99 audit template hardened.
- C99b benchmark job submitted.
## 2026-06-27 cycle 13 literature record

Query/source:

- Web/arXiv query: `Ginsparg Wilson relation finite dimensional index grading involution chiral operator`.
- Web/arXiv query: `finite lattice overlap Dirac operator index gamma5 kernel theorem Neuberger`.
- Web/arXiv query: `Luscher exact chiral symmetry lattice index theorem Ginsparg Wilson finite volume`.

Source anchors:

- Luscher, `arXiv:hep-lat/9802011`, exact lattice chiral symmetry and Ginsparg-Wilson relation.
- Neuberger / overlap-Dirac finite index lane.
- Golterman-Shamir, `arXiv:2311.12790` and `arXiv:2505.20436`, for propagator-zero and mirror/vectorlike hazards.

Result summary:

- Reinforced the C99-v2 requirement: explicit gamma5-like grading/involution and D/Gamma compatibility are needed before the finite index substrate can be called strong.

Plan impact:

- C99 integrated only as fallback.
- C99-v2 submitted for the missing structural layer.
## 2026-06-27 - Lateral-analysis new lanes (energy correlators, causal fermion systems, 1D SMG)

Status: proposed
Related gate: publication | C1 | other

Question:

- Which genuinely new (not-yet-ingested) sources does the 2026-06-27 lateral
  analysis introduce, beyond the lattice-chiral lane already in this queue?

Candidate sources (ingest pending; not yet in Zotero/Neo4j):

- Larkoski-Salam-Thaler, energy correlation functions for jet substructure,
  `arXiv:1305.0007`, and the review `arXiv:2410.16368`. Collision for the
  Plucker hierarchy (conjecture 5 in `Sources/Null_Edge_Key_Conjectures.md`):
  energies plus pairwise angles, higher-point correlators for multi-prong
  substructure; the `k=2` Plucker obstruction may be the two-point member of a
  null-edge event-shape ladder.
- Causal fermion systems introduction, `arXiv:2411.06450`. Boundary marker for
  `Sources/Null_Edge_Interaction_Ontology.md`: test whether the Plucker spread
  is a simple finite causal-action term.
- One-dimensional symmetric mass generation without fermion doubling,
  `arXiv:2606.24713`. Toy-zoo mirror for the Gate C redesign roadmap section 6.5.
- Kaplan lattice-fermion lectures, `arXiv:0912.2560`, review anchor for the
  C1-alternatives framing (domain-wall / overlap / Ginsparg-Wilson).

Zotero/Neo4j status:

- Not yet ingested. Pending user go-ahead, run `Scripts/lit/lit_ingest.py` with
  the `IN_COLLECTION` edge to `9W59V3K9`; pre-add existence check keyed on
  arxiv_id (not title) to avoid duplicates. The Golterman-Shamir,
  reduced-Kahler-Dirac, and Ginsparg-Wilson sources cited by the lateral
  analysis are already present from earlier cycles and must not be re-added.

Takeaways:

- The energy-correlator lane is the concrete payoff of the Plucker-hierarchy
  idea and is the most novel addition; prioritize it for ingest.
- Among the lattice-chiral additions only `2606.24713` (1D SMG) and `0912.2560`
  (Kaplan review) are candidate new entries; the rest are already covered.
