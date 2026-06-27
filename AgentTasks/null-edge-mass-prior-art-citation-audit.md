# Null-edge origin-of-mass: prior-art and citation audit (P1 / P1.5 / P2)

Compiled: 2026-06-26. Job type: source/literature and prior-art citation audit
(written audit only; no Lean, Lake, pre-commit, or build/check command was run).

Scope: this audit consolidates and stress-tests the prior-art citations used by
the null-edge origin-of-mass manuscript line, per `PROMPT.md`. Primary inputs:

- `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md` (Section 10
  "Relation to prior work", Section 13 conventions, the open-tasks citation log).
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` (P1-F and P2-F
  "Literature anchors" blocks).
- `AgentTasks/null-edge-unified-mass-grand-strategy-report.md` Sections A, E, F.
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` Sections 17-19.
- Supporting hits in `Sources/NullStrand_Open_Questions_For_Frontier_Models.md`
  and `Sources/NullStrand_Lean_Roadmap_Improved.md`.

## Method and verification posture (read first)

This is an **offline desk audit**. It does not, and by the job constraints
cannot, perform live INSPIRE-HEP / Crossref / arXiv lookups. Therefore:

- Every metadata field below is transcribed from the cited project source. The
  "Source-claimed status" column records what the manuscript/plan asserts about
  how the item was checked (e.g. "INSPIRE-HEP 2026-06-25"); it is **not** an
  independent re-verification by this audit.
- The "Audit flag" column marks items as `ok-as-recorded` (internally
  consistent across sources, standard well-known reference) or `unverified`
  (recent, single-source, conflicting, or non-arXiv items that a human must
  confirm before submission).
- **No DOI or journal reference has been invented.** Where a source records "no
  DOI", that is preserved. Where no source supplies a DOI, the field is left
  blank and flagged, not filled.

Guardrail note already documented in the sources, and worth repeating here as a
cautionary precedent: a prior literature pass in
`NullStrand_Open_Questions_For_Frontier_Models.md` recorded that two arXiv IDs
from an upstream analysis (`2501.10336`, `2602.19767`) were **hallucinated** and
had to be replaced by the real papers `1110.2482` and `1011.0761`. This is
direct in-repo evidence that citation IDs in this program must be checked
against a live database before any submission; treat the present table as a
consolidation to verify, not as a verification of record.

---

## 1. Citation table

### 1.1 Core prior-art cluster (P1 "relation to prior work")

| Key | Authors / title | arXiv id | Journal ref | DOI | Source-claimed status | Audit flag |
| --- | --- | --- | --- | --- | --- | --- |
| AHH-massive | Arkani-Hamed, Huang, Huang, *Scattering amplitudes for all masses and spins* | `1709.04891` | JHEP 11 (2021) 070 | `10.1007/JHEP11(2021)070` | INSPIRE-HEP, 2026-06-25 | ok-as-recorded |
| KKL-twistor | Kim, Kim, Lee (massive twistor / relativistic spherical top) | `2102.07063` | J. Phys. A 54 (2021) 335203 | `10.1088/1751-8121/ac11be` | INSPIRE-HEP, 2026-06-25 | ok-as-recorded |
| Chin-Lee | Seungbeom Chin, Sangmin Lee, *Momentum bispinor, two-qubit entanglement and twistor space* (2014) | `1407.2492` | none (arXiv-only preprint) | none — **do not cite a DOI** | Crossref/arXiv, 2026-06-25: arXiv-only, no journal DOI | ok-as-recorded (no-DOI confirmed by source) |
| PST | Peres, Scudo, Terno, *Quantum entropy and special relativity* | `quant-ph/0203033` | PRL 88, 230402 | `10.1103/PhysRevLett.88.230402` | Semantic Scholar, 2026-06-25; Zotero key `QDUD2CDE` | ok-as-recorded |
| Gingrich-Adami | Gingrich, Adami, *Quantum entanglement of moving bodies* | `quant-ph/0205179` | PRL 89, 270402 | `10.1103/PhysRevLett.89.270402` | Semantic Scholar, 2026-06-25; Zotero key `Z2MFSJJU` | ok-as-recorded |
| posGrass | Arkani-Hamed et al., positive Grassmannian / `Gr(2,n)` minor stratification | `1212.5605` | (book/preprint) | not recorded | recorded in P1-F anchors and Manuscript §10 | unverified (no journal/DOI recorded; confirm canonical reference and authorship string) |
| DST-closure | Dupuis, Speziale, Tambornino, spinor-network closure / loop-gravity closure constraint | `1201.2120` | not recorded | not recorded | recorded in Manuscript §10 and Pub-Plan §1092 | unverified (confirm full author/title, journal, DOI) |
| Wilczek-mwm | Wilczek, "mass without mass" (QCD origin of hadron mass) | none (non-arXiv) | not recorded | not recorded | **flagged in Manuscript open-tasks as the one anchor still to verify** | unverified (conceptual/popular anchor; see §3 and §4) |

### 1.2 Spectral-action / gauge-network cluster (P2-F and prediction gate)

| Key | Authors / title | arXiv id | Journal ref | DOI | Source-claimed status | Audit flag |
| --- | --- | --- | --- | --- | --- | --- |
| CCM | Chamseddine, Connes, Marcolli, *Gravity and the standard model with neutrino mixing* | `hep-th/0610241` | not recorded | not recorded | recorded in Roadmap G5 and OQ prediction-gate | unverified (well-known paper; confirm Adv. Theor. Math. Phys. ref + DOI before citing metadata) |
| MvS-gaugenet | Marcolli, van Suijlekom, *Gauge networks in noncommutative geometry* | `1301.3480` | not recorded | not recorded | recorded in Pub-Plan P2-F anchors | unverified (confirm J. Geom. Phys. ref + DOI) |
| PerezSanchez | Perez-Sanchez, comment on gauge networks / lattice spectral action losing the Higgs scalar | `2508.17338` | not recorded | not recorded | recorded in Pub-Plan P2-F anchors | unverified (very recent; confirm existence, authorship, and that the claim attributed to it is accurate) |

### 1.3 FMS / gauge-invariant Higgs language cluster (P1.5)

| Key | Authors / title | arXiv id | Journal ref | DOI | Source-claimed status | Audit flag |
| --- | --- | --- | --- | --- | --- | --- |
| Maas-FMS | Axel Maas, *The Frohlich-Morchio-Strocchi mechanism: an underestimated legacy* | `2305.01960` | not recorded | not recorded | Working Plan §19 records "checked against arXiv" | unverified (confirm published venue/DOI if any; title string per §19) |
| FMS-orig | Frohlich, Morchio, Strocchi (original FMS mechanism) | not recorded | not recorded | not recorded | named conceptually in Working Plan §19, no key given | unverified (the *primary* FMS reference is cited only second-hand via Maas; add the original FMS paper(s) if FMS is invoked) |

### 1.4 Adjacent / secondary anchors mentioned in sources (not core P1, listed for completeness)

| Key | Authors / title | arXiv id | DOI/journal | Audit flag |
| --- | --- | --- | --- | --- |
| Fullwood et al. | Fullwood, Vedral, Guzman-Gonzalez, unnormalized linear-entropy / Lorentzian-symmetry framing | `2604.07471` | not recorded | unverified (arXiv id `2604.*` implies 2026-04; very recent, single-source in Pub-Plan; confirm id, authorship, and relevance) |
| Quillen | Quillen, superconnections | n/a (1985, *Topology*) | not recorded | unverified (classic; supply canonical citation if used) |
| Ackermann-Tolksdorf | generalized Lichnerowicz formula | not recorded | not recorded | unverified |
| Bianconi | topological Dirac operator | not recorded | not recorded | unverified |
| Lorentzian/Krein guardrails | van den Dungen; Bizi-Brouder-Besnard; Besnard-Bizi; Devastato-Farnsworth-Lizzi-Martinetti; Martinetti-Singh; Strohmaier (`math-ph/0110001`); Franco (`1210.6575`); Besnard-Bizi (`1611.07830`, `1611.07842`) | mixed | Zotero keys only for several | unverified (P2-only; Zotero-key-only items need id/DOI resolution before external citation) |
| Cauchy-Binet / Gram | classical determinant identity (no single canonical paper) | n/a | n/a | cite a standard linear-algebra text, not a preprint |

---

## 2. Novelty-boundary paragraphs per prior-art cluster

For each cluster: what is already in the literature, and exactly what P1 / P1.5 /
P2 does and does not add. These are written to be paste-ready into a
"relation to prior work" section, and they deliberately keep the P1 novelty
narrow (finite-bundle Plucker mass identity; massless iff projectively
collinear; frame-audited normalization; formalization).

**Massive spinor-helicity (AHH `1709.04891`).** The literature already writes a
single massive momentum as a pair of `SU(2)` little-group spinors, i.e. one
massive momentum as two null spinors — the `n = 2` *reverse* direction, which is
textbook bookkeeping. P1 adds the `n`-edge **forward** direction: an arbitrary
finite bundle of null edges whose invariant mass squared equals the total
pairwise Plucker spread `sum_{i<j} |psi_i ∧ psi_j|^2`, together with the exact
massless-iff-projectively-collinear criterion, reality/nonnegativity, `SL(2,C)`
covariance, twistor-chart matching, and a machine-checked formalization. P1 does
**not** add a new amplitudes formalism, new little-group representation theory,
or any dynamics; it is a kinematic identity packaged as a kernel-checked
theorem.

**Two-twistor mass models (KKL `2102.07063`).** Realizing a massive particle
from two twistors, and showing the massive-twistor / relativistic spherical-top
model reproduces the AHH spectrum on quantization, is established. P1 recovers
exactly this as the `n = 2` case of its twistor-chart section and then
generalizes to arbitrary `n`. P1 does **not** quantize the model, derive a
spectrum, or claim a new twistor construction; the contribution is the finite
multi-twistor pairwise-mass identity and its explicit determinant-vs-trace
normalization audit.

**Chin-Lee mass/concurrence (`1407.2492`).** Chin and Lee already identify the
two-twistor / momentum-bispinor mass with two-qubit concurrence by restricting
to the unit-energy hyperplane. P1 keeps the **invariant** determinant mass
strictly separate from any normalized-energy (`m/E`) quantity, and the
mass/concurrence analogy is explicitly *not* claimed as the novelty. What P1
adds relative to Chin-Lee is the frame-audited separation of invariant `det(P)`
from frame-relative `m/E`, the `n`-edge generalization, and the formalization —
not the bare analogy.

**Frame-dependence guardrails (PST `quant-ph/0203033`; Gingrich-Adami
`quant-ph/0205179`).** These are cited as *guardrails*, not as precedents being
extended: reduced spin and entanglement quantities can be frame-dependent under
boosts. P1's job here is defensive — it states that its novelty is the
boost-invariant determinant identity and its formalized packaging, precisely so
that the paper is not read as another frame-dependent "spin/entanglement under
boosts" result. P1 adds nothing to the PST/Gingrich-Adami analyses; it cites
them to delimit what it is *not* claiming.

**Positive Grassmannian / Plucker background (`1212.5605`).** The right-hand
side of the mass identity is a sum of squared `Gr(2,n)` Plucker coordinates, and
the massless locus is the rank-one cone where all `2x2` minors vanish. The
positive-Grassmannian stratification is established mathematics. P1 uses it only
as a *remark* connecting the massless locus to minor stratification; it does
**not** prove anything new about the positive Grassmannian or amplitude
positivity, and this connection should be kept as a one-line geometric remark to
avoid overclaiming an amplitudes result.

**Spinor-network closure / loop gravity (DST `1201.2120`).** The
Dupuis-Speziale-Tambornino closure constraint is an established loop-gravity
object. P1's celestial-moment form reads `C = sum_i w_i n_i = 0` as the
rest-frame / moment-map condition, i.e. it *reinterprets* the closure constraint
as a mass identity (`m^2 = (E^2 - |C|^2)/4`). P1 does **not** contribute to loop
quantum gravity, intertwiner spaces, or spin-network dynamics; it only borrows
the closure object as a packaging of the rest-frame condition. (Note: in the
current draft this lives in the standalone celestial-moment artifact, flagged
for promotion or appendix status.)

**Spectral action / gauge networks (Chamseddine-Connes-Marcolli
`hep-th/0610241`; Marcolli-van Suijlekom `1301.3480`).** The spectral-action
construction of the Standard Model, and the finite-spectral-triple "gauge
networks" on graphs, are the closest established prior art to the P2
super-Dirac-square program. P2 does **not** claim a new spectral triple or a
new spectral-action prediction; it targets a *dual-soldered, null-supported,
Krein/Lorentzian* operator whose graded square separates null kinetic shell,
curvature, frame defect, and `Phi_H^2` mass block **without double-counting**.
The honest boundary: CCM and Marcolli-van Suijlekom are Euclidean
finite-spectral-triple precedents; the null/Lorentzian/Krein adaptation and the
no-double-counting `K_null = Phi_H^2` on-shell relation are the proposed
contributions, and they are currently draft/target, not proved. The
Perez-Sanchez comment (`2508.17338`) should be cited as a *cautionary* anchor
(naive lattice spectral action can lose the Higgs scalar in the continuum
limit), not as support.

**Wilczek "mass without mass" (QCD anchor).** That most of the proton/neutron
mass is the energy of nearly massless confined constituents is standard QCD
physics and Wilczek's well-known framing. P1 uses it only as the *physical
intuition* for Part I; the theorem is explicitly described as the clean
kinematic skeleton of that picture, **not** a derivation of QCD, confinement,
the trace anomaly, or the hadron spectrum. This is the single highest-overreach
risk in the paper (see §3), so the cite must stay at the level of motivation.

**FMS / gauge-invariant Higgs language (Maas `2305.01960`; original FMS).** The
Frohlich-Morchio-Strocchi mechanism and gauge-invariant composite-operator
description of physical W/Z/Higgs excitations are established. P1.5 adopts
FMS-style language as a *discipline* (never "the local gauge symmetry breaks as
an observable"); the Abelian-Higgs link-stiffness theorem and the electroweak
stabilizer kernel/rank theorem are reconstruction/structural results, not new
FMS physics. P1.5 adds: the explicit finite gauge-invariant link-stiffness
identity `S_H = v^2 sum_e |w_e - 1|^2` on a (claimed) null substrate, and the
honest statement that, absent the surrounding null-edge theorem package, this is
ordinary lattice gauge-Higgs theory with null labels.

---

## 3. Unsafe or currently under-verified phrases and citations

### 3.1 Under-verified citation metadata (must resolve before submission)

- **Wilczek "mass without mass"** — non-arXiv; flagged by the manuscript itself
  as the one anchor still to verify. No DOI/venue is recorded anywhere in the
  sources. Do not attach a fabricated reference; either cite a specific,
  well-known Wilczek source verbatim once confirmed, or describe it as a widely
  used physics framing without a precise locator. Marked `unverified`.
- **Positive Grassmannian `1212.5605`** — id recorded but no journal/DOI and the
  author string ("Arkani-Hamed et al.") is loose; confirm the canonical
  reference before citing.
- **DST closure `1201.2120`** — only id and a paraphrased author list recorded;
  confirm full author/title/journal/DOI.
- **CCM `hep-th/0610241`** and **Marcolli-van Suijlekom `1301.3480`** — ids
  recorded but no journal/DOI; well-known papers, but the metadata must be
  filled from a live lookup, not guessed.
- **Perez-Sanchez `2508.17338`** and **Fullwood et al. `2604.07471`** — both are
  very recent (2025-08 and 2026-04 by their ids), single-source, and unverified;
  confirm they exist and that the in-text claims attributed to them are accurate
  before relying on them.
- **Maas FMS `2305.01960`** and the **original FMS paper** — confirm venue/DOI;
  add the primary FMS reference rather than citing FMS only via Maas.
- **Zotero-key-only Lorentzian/Krein guardrails** (van den Dungen,
  Bizi-Brouder-Besnard, etc.) — resolve to arXiv id/DOI before any external
  citation; Zotero keys are not citable identifiers.
- **General precedent flag:** the in-repo record of two previously hallucinated
  ids (`2501.10336`, `2602.19767`) means *all* ids in this table should be
  re-checked against a live database before submission, even the
  `ok-as-recorded` ones.

### 3.2 Unsafe phrasing (overclaim risks flagged across Sections A, E, F and 17-19)

Avoid (these draw correct referee objections):

- "We explain the origin of all mass."
- "All mass is (the same) Plucker spread / trapped light."
- "The Plucker theorem derives the proton mass."
- "The gauge symmetry breaks" / "spontaneous breaking of a local symmetry" as an
  *observable* fact (use FMS gauge-invariant composites instead).
- "spectral gap" applied to the **P1 Plucker invariant** (it is a rest-frame
  invariant of a state / finite bivector norm, not an operator spectral gap;
  reserve "spectral gap" for operator spectra, Hessians, mass matrices, Dirac
  squares in P1.5/P2).
- "predicts" / "derives" for any quantity that is an input (Yukawas, `g, g'`,
  `v`, `lambda`, `Lambda_QCD`).
- "the null lattice gives the Standard Model" (without the full theorem package).
- "Krein self-adjoint, therefore stable / unitary / real spectrum."
- Title caution: "The Origin of Mass: matter as trapped, disagreeing light" is
  fine for the **expository** companion (P1-E) but overclaims for the formal
  paper; the formal venue should use "Invariant Mass from Finite Null-Spinor
  Bundles: A Frame-Audited Plucker Theorem."

Citation-adjacent overclaim to avoid specifically:

- Do **not** present the mass/concurrence analogy (Chin-Lee) as P1's novelty —
  the PST / Gingrich-Adami guardrails exist precisely because reduced
  spin/entanglement is frame-dependent; lead with the boost-invariant identity.
- Do **not** present the `Gr(2,n)` / positive-Grassmannian connection as an
  amplitudes-positivity result; keep it a geometric remark.
- Do **not** cite CCM/Marcolli-van Suijlekom as *support* for a P2 prediction;
  CCM is also a cautionary tale (the ~170 GeV Higgs-mass miss), and the
  Perez-Sanchez comment warns the scalar can be lost in a naive lattice limit.

---

## 4. Recommended bibliography blocks

Two blocks are recommended: a tight one for the **formal P1** paper, and a
broader one for the **expository companion** (and forward-pointers to P1.5/P2).
Items still flagged `unverified` in §1 are marked `[verify]` here; do not
typeset their DOIs/venues until a live lookup confirms them, and never invent a
DOI for the arXiv-only Chin-Lee item.

### 4.1 Formal P1 ("Invariant Mass from Finite Null-Spinor Bundles")

Core, directly load-bearing:

1. Arkani-Hamed, Huang, Huang, *Scattering amplitudes for all masses and
   spins*, arXiv:1709.04891, JHEP 11 (2021) 070,
   DOI 10.1007/JHEP11(2021)070. [massive spinor-helicity; `n=2` reverse direction]
2. Kim, Kim, Lee, massive-twistor / relativistic spherical top, arXiv:2102.07063,
   J. Phys. A 54 (2021) 335203, DOI 10.1088/1751-8121/ac11be. [two-twistor mass]
3. Chin, Lee, *Momentum bispinor, two-qubit entanglement and twistor space*,
   arXiv:1407.2492 (arXiv-only; **no DOI**). [mass/concurrence; kept distinct]
4. Peres, Scudo, Terno, arXiv:quant-ph/0203033, PRL 88 (2002) 230402,
   DOI 10.1103/PhysRevLett.88.230402. [frame-dependence guardrail]
5. Gingrich, Adami, arXiv:quant-ph/0205179, PRL 89 (2002) 270402,
   DOI 10.1103/PhysRevLett.89.270402. [frame-dependence guardrail]

Background remarks (keep to one line each):

6. Arkani-Hamed et al., positive Grassmannian, arXiv:1212.5605. [verify
   author/venue] [`Gr(2,n)` minor stratification; massless = rank-one cone]
7. Dupuis, Speziale, Tambornino, spinor-network closure, arXiv:1201.2120.
   [verify author/title/venue] [celestial-moment rest-frame condition]
8. A standard linear-algebra reference for the Cauchy-Binet / Gram determinant
   identity (textbook, not a preprint).

Motivational anchor (Part I only, no precise locator unless confirmed):

9. Wilczek, "mass without mass" framing of the QCD origin of hadron mass.
   [verify — non-arXiv; resolve to a specific Wilczek source]

### 4.2 Expository companion (P1-E) and P1.5/P2 forward-pointers

Include all of §4.1, plus:

10. Chamseddine, Connes, Marcolli, *Gravity and the standard model with neutrino
    mixing*, arXiv:hep-th/0610241. [verify venue/DOI] [spectral-action precedent
    and cautionary Higgs-mass miss]
11. Marcolli, van Suijlekom, *Gauge networks in noncommutative geometry*,
    arXiv:1301.3480. [verify venue/DOI] [closest finite-spectral-triple graph
    prior art]
12. Perez-Sanchez, comment on gauge networks / lattice spectral action,
    arXiv:2508.17338. [verify — recent] [cautionary: scalar can be lost in the
    continuum limit]
13. Maas, *The Frohlich-Morchio-Strocchi mechanism: an underestimated legacy*,
    arXiv:2305.01960. [verify venue/DOI] [gauge-invariant Higgs language]
14. Original Frohlich-Morchio-Strocchi reference(s). [add — currently cited only
    via Maas]

Optional P2 operator-theory anchors (cite only if the relevant P2 section ships):
Quillen superconnections; Ackermann-Tolksdorf generalized Lichnerowicz; Bianconi
topological Dirac; and the Lorentzian/Krein guardrail set (van den Dungen;
Bizi-Brouder-Besnard; Besnard-Bizi `1611.07830`/`1611.07842`; Strohmaier
`math-ph/0110001`; Franco `1210.6575`). All `[verify]` — resolve Zotero-key-only
items to ids/DOIs first.

The Fullwood-Vedral-Guzman-Gonzalez item (arXiv:2604.07471) is **not**
recommended for inclusion until verified (very recent, single-source).

---

## 5. Summary verdict

- The **core P1 cluster** (AHH, KKL, Chin-Lee, PST, Gingrich-Adami) is
  internally consistent across the manuscript draft and the publication plan,
  with metadata the sources claim to have checked against INSPIRE-HEP / Semantic
  Scholar / Crossref. These are `ok-as-recorded`; the Chin-Lee no-DOI status is
  confirmed and must be respected.
- The **background, spectral-action, and FMS clusters** are recorded with arXiv
  ids but largely without journal/DOI metadata, and several items
  (`2508.17338`, `2604.07471`, the original FMS paper, all Zotero-key-only
  guardrails) are single-source and `unverified`. None of these should have
  DOIs/venues typeset until a live lookup confirms them.
- The **only genuinely missing anchor** the sources flag for verification is the
  non-arXiv **Wilczek "mass without mass"** reference; it remains `unverified`.
- The **P1 novelty boundary** is correctly narrow and should stay so: the
  finite-bundle Plucker mass identity, the massless-iff-projectively-collinear
  criterion, the frame-audited invariant-vs-normalized (`det(P)` vs `m/E`)
  distinction, and the machine-checked formalization. Everything else (QCD,
  Yukawa/Higgs/EW mechanisms, spectral-action prediction, neutrino mass) belongs
  to clearly-labeled later layers and must not be presented as derived in P1.
- **Before submission:** re-resolve every id/DOI against a live database (the
  in-repo hallucinated-id precedent makes this mandatory), add the original FMS
  reference, and resolve or downgrade the Wilczek anchor.
