# Provenance / source-gap audit - newest manuscript and NullStrand materials

**Job:** ne-solo-lane-lit-provenance-source-gap-audit-20260707
**Date:** 2026-07-07
**Type:** audit only (no source edits made; see "Edit discipline" below)
**Claim calculus used:** the P1 grades `T` / `T|H` / `M` / `C` and originality
tags `[orig] / [comp] / [import] / [interp]` (AGENTS.md "Physics conventions").

## 0. Scope, method, and a snapshot caveat

Audited artifacts (the newest manuscript-facing and NullStrand materials in this
workspace):

- `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft_v3.md` (P1 v3, 2026-07-07)
- `Sources/Null_Edge_Program_Charter_2026-07-07.md`
- `Sources/Null_Edge_Publication_Outlines_2026-07-07.md`
- `Sources/Furey_Baez_Octonions_Standard_Model_Survey.md`
- `PhysicsSM/Draft/NullEdge/Carrier/WeitzenbockQC_TorusModel_DESIGN.md`
- `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum_NOTES.md`

Provenance machinery in the repo, for reference:

- `Sources/Paper_References.md` - the only structured, source-keyed bibliography
  (`[Baez2002]`, `[Furey2018a]`, ...). It is scoped to the octonionic Standard
  Model paper ("Verified Octonionic Algebra ...", last updated 2026-06-02) and
  does NOT cover the null-edge / NullStrand program.
- `PhysicsSM/Meta/SourceTrace.lean` - a stub; defines only `SourceKind`
  (`paper | book | repo | oracle | cleanroom`). No per-declaration records yet.
- Provenance rule (AGENTS.md "Provenance"): every nontrivial declaration inspired
  by a paper/book/repo/CAS records source + convention in a docstring or metadata
  file, and no source is claimed to support a theorem unless statement AND
  conventions were checked.

**Method.** Read all six artifacts plus the convention/provenance docs
(`AGENTS.md`, `docs/CONVENTIONS.md`, `docs/NULLSTRAND.md`); enumerated every
precise identifier (arXiv/doi) and every author-name-only citation; classified
each nontrivial claim as imported fact / computational check / interpretation /
original conjecture; matched each against an existing source key or convention
note.

**Objective finding on citation density.** Across the four newest null-edge
documents there are exactly TWO precise identifiers:

- `1709.04891` (Arkani-Hamed-Huang-Huang) in P1 v3 section 12, and
- `arXiv:hep-lat/0309120` in the torus design doc (a "cf." in a Lean docstring).

Every other external result is cited by author surname only (Coleman-Mandula,
Weinberg-Witten, Marolf, Nielsen-Ninomiya, Ginsparg-Wilson, Connes,
Chamseddine-Connes-van Suijlekom, Boyle-Farnsworth, Distler-Garibaldi,
Springer-Veldkamp, Jones, Shale-Stinespring, Jacobson, Malament,
Hawking-King-McCarthy, Sorkin, Benincasa-Dowker, Koide, Wilczek,
Pereira-Vargas, Zubkov, Nester, Maluf, Witten, Osterwalder-Seiler, Wilson 1974,
Gersch, Kauffman-Noyes, Schulman, Destri-de Vega, McKean-Singer, Atiyah-Singer,
Luescher, Kugo-Ojima, Gupta-Bleuler, Lichnerowicz, ...). None resolves to a
source key, arXiv/doi, or a section/theorem anchor.

**Snapshot caveat (limits this audit's reach).** Many cross-referenced provenance
files are NOT present in this workspace and could not be checked: `Sources/NERD_1..4.md`,
`Sources/Ontology_extensions.md`, `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`,
`docs/NERD_ROADMAP.md`, `docs/DOCUMENT_MAP.md`, `docs/BUILD.md`, and the
`AgentTasks/fable_parallel/Q0{1..8}_answer.md` memos that the Charter and Outlines
lean on for their strongest claims. Where a claim's stated provenance is one of
those memos, this audit can only flag that the backing is (a) internal working
notes, not the peer-reviewed literature, and (b) not verifiable from this
snapshot. Both Charter and Outlines already say literature identifiers are
"unverified until pulled through the Neo4j pipeline" and set a "no unverified
citations" submission gate (Outlines checklist item 4); the gaps below are the
concrete backlog behind those gates.

## 1. Gaps: paper/convention-dependent claims lacking precise provenance

Each row: claim (location) -> classification -> missing provenance. "Classification"
distinguishes imported fact `[import]`, computational/kernel check `[comp]/M`,
interpretation `[interp]`, and pre-registered conjecture `C`.

### 1A. Octonion / Furey / Baez cluster

1. **Furey-Hughes "Division algebraic symmetry breaking" (O -> H -> C cascade,
   Spin(10) -> Pati-Salam -> LR -> SM+B-L).** Survey section 2.3 and references
   list `arXiv:2210.10126`. `[import]`. **Gap:** this paper has NO entry in
   `Paper_References.md` (which keys only [FureyHughes2024] = 2409.17948). Needs a
   dedicated source key.
2. **Furey arXiv-ID inconsistencies (already self-flagged).** `Paper_References.md`
   flags: `[Furey2015]` cited as `1603.04078` in the ref list but `1603.04783` in
   `Basic.lean`; `[Furey2018b]` given `arXiv:1910.08395` yet published PLB 785
   (2018) - the arXiv month (2019-10) postdates the stated 2018 publication;
   `Basic.lean` cites `1805.06631` for a similarly titled Furey paper. `[import]`.
   **Gap:** ID-vs-DOI reconciliation not yet done. (Left untouched here: requires
   external verification, see Edit discipline.)
3. **Charter "Q04" identity `str_{Lambda C^n}(g) = det(1 - g|_{C^n})` and the
   claim that the Furey-octonion and Connes routes are "one object in two
   coordinate systems" (Chevalley `C (x) O` with fixed unit = `Lambda(C^3)`;
   XOR-Fano basis = strand-monomial labeling).** `[interp]` + `[comp]`. **Gap:**
   the Chevalley/pure-spinor identification and the supertrace anomaly identity
   are stated with no source; the convention bridge to this repo's XOR octonion
   basis (CONVENTIONS.md "Octonions", Locked) is asserted, not checked against
   `PhysicsSM.Algebra.Octonion.ConventionBridge`.
4. **`NullEdgeFureyInternalSpectrum_NOTES.md`: computed `J`-state charge multiset
   `{0,-1/3,-1/3,-1/3,-2/3,-2/3,-2/3,-1}`, anomaly cancellation, one-generation
   realization.** `M [comp]` (n a t i v e _ d e c i d e; draft-trust per AGENTS.md). **Gap
   (minor):** the notes name the in-repo eigenvalue theorems (`AnomalyBridge.Q_op_*`)
   but not the external source key ([Furey2015]/[Furey2018a]) for the charge = scaled
   number-operator convention that fixes the sign/normalization of `Q_op`.

### 1B. Teleparallel / gravity cluster

5. **E-slot "gravity-shaped" / "discrete-teleparallel" reading; `2E = C(T) + C(S)`
   torsion-contraction.** Outlines outline 2; P1 v3 layer 2.5. `[interp]` (form-level
   `M` for the identity; the teleparallel READING is interpretation). **Gap:** the
   teleparallel anchors are name-only: "Pereira-Vargas/Zubkov (discrete
   teleparallelism EXISTS)" and "Nester/Maluf/Witten anchors (T [import],
   lit-verified)". No section/theorem, no arXiv/doi. The Charter's Q02 correction
   ("individual block traces are not redecoration-invariant; no 'gravity action =
   E-slot trace' language") is a convention/no-overclaim note that itself needs a
   citable home.
6. **Gravity claim U2 (Weinberg-Witten + Marolf: no covariant conserved
   `T^{mu nu}` on `V'/N`; emergent redundancy as obligation).** Charter U2.
   `C` (conjecture) resting on `[import]` no-go theorems. **Gap:** Weinberg-Witten
   and Marolf are name-only; the precise statement/hypotheses of each theorem (which
   are load-bearing for "obligation, not bonus") are not pinned. Jacobson (fallback
   "field equations without a graviton") likewise name-only.
7. **Malament / Hawking-King-McCarthy / Sorkin / Benincasa-Dowker
   (order -> conformal class; "order + number = geometry"; damped layered transport
   kernel).** `docs/NULLSTRAND.md` "Universal null frames" attributes these to
   `Sources/Ontology_extensions.md` sec 6. `[import]`. **Gap:** the backing file is
   absent from this snapshot; no arXiv/doi/section for any of the four.

### 1C. Modular / QFT / positivity cluster

8. **Physical-sector positivity = Witt geometry of the constraint span; finite
   Gupta-Bleuler; definitizability "vacuous in finite dimensions"; `dim(V'/N) = ind(D)`.**
   P1 v3 layer 4; Charter U1; Outlines outline 5. `C` / `MEMO` grade, backed by
   `AgentTasks/fable_parallel/Q01_answer.md`. **Gap:** Gupta-Bleuler and Kugo-Ojima
   are name-only; the finite-dimensional definitizability claim and the Krein/Pontryagin
   framing need a functional-analysis citation (Bognar or Azizov-Iokhvidov class of
   source). Backing memo not in snapshot.
9. **Three distinct `J` operators (`J_K` Krein, `J_C` real structure, `J_mod` Tomita
   modular, state-dependent).** CONVENTIONS.md "Three J operators (Gate C0)", Locked;
   Charter "Standing terminology guard". `[interp]/[import]`. **Gap:** the
   Tomita-Takesaki modular-conjugation and KO-dimension real-structure facts are
   convention/import claims with no citation (Connes NCG for `J_C`/KO-dimension;
   Tomita-Takesaki for `J_mod`). This is a convention note that should name its sources.
10. **Shale-Stinespring HS-implementability gate; Jones Thompson-group covariance
    obstruction; uniform-majorant "finite shadow of the Hilbert-Space-Structure
    Condition".** Charter "Continuum gates". `[import]` no-go/obstruction inputs.
    **Gap:** all name-only; each is load-bearing for a specific gate and needs a
    theorem-level anchor.

### 1D. RG / Schur cluster

11. **"Coarse-graining generates `Q_A` by Layer K - the thesis as an RG fact,
    confirmed independently by the Schur route of Q08"; "retardedness IS the hidden
    Wilson term (exact dispersion identity)"; exact GW relation `R = 1/2` with grading
    = chirality composed with edge-orientation reversal.** Charter "Continuum gates";
    P1 v3 layer 2. `C`/`MEMO` (+ `M` for the 1+1D GW identity). **Gap:** the "Schur
    route" (Q08) and "Layer K" are internal labels with no external anchor;
    Ginsparg-Wilson and Luescher (the Luescher lattice chiral symmetry underpinning
    the index) are name-only. GW/Luescher are exactly the kind of imported convention
    where sign/normalization must match before the `R = 1/2` claim can cite them.

### 1E. Chirality / anomaly cluster

12. **Nielsen-Ninomiya (doubling no-go); Ginsparg-Wilson descent; overlap operator
    `gamma5 D + D gamma5 = D gamma5 D`; chiral index = half signature difference;
    McKean-Singer protection family; Atiyah-Singer as the continuum comparison.**
    P1 v3 sections 11 & layer 3; Outlines outline 1. `M [comp]` for the finite Lean
    results; `[import]` for the classical theorems they are compared to. **Gap:** NN,
    GW, overlap (Neuberger), McKean-Singer, and Atiyah-Singer are all name-only. The
    Outlines outline-1 "relation to Nielsen-Ninomiya (we protect, they forbid)" is an
    `[interp]` bridge that must cite NN precisely to be defensible.
13. **Witten SU(2) anomaly / mod-2 KO decoration; Distler-Garibaldi ("cannot derive
    SM without extra states" -> index-zero corollary); Springer-Veldkamp local
    triality (L4c); Spin(8)/D4 triality as the unique order-3 outer automorphism;
    Hurwitz terminality of O.** Charter "Generations". `C` (triality-as-monodromy) on
    `[import]` structural facts. **Gap:** all name-only; Distler-Garibaldi and
    Springer-Veldkamp are explicitly flagged as "cheap kernel target" / "load-bearing
    algebraic transcription" yet carry no citation.

### 1F. Positive-sector / "positive light" language cluster

14. **"Future-pointing lightlike", future-cone positivity, `det = E^2 - |p|^2`,
    rest-frame `C = 0`, positive-source variant.** P1 v3 sections 1, 6, 7. `M` (the
    soldering/cone identities are kernel-clean draft: `GateI1.Core`,
    `NullEdgeP9DiamondSourceVisibilityCore`). **Provenance status: GOOD** - anchored
    to in-repo checked identities, explicitly "rests on a checked identity, not a
    citation". The one residual gap is the mostly-minus signature convention
    (CONVENTIONS.md "Metric signature", Locked) not being cross-referenced at the
    point of use in the manuscript.
15. **Kugo-Ojima positive-sector witness `(2,1)` vs same-charge `(1,2)` no-go;
    "non-vacuous positive quotient".** P1 v3 layer 2.5 / section 11; Outlines outline 5.
    `M` (finite linear algebra) but the NAME "Kugo-Ojima" imports a QFT convention.
    **Gap:** Kugo-Ojima quartet-mechanism citation missing; the identification of the
    finite witness with the Kugo-Ojima physical-subspace criterion is `[interp]` and
    currently unsupported (the manuscript itself marks the carrier/Gauss wiring OPEN,
    which is the honest hedge).

### 1G. Massive-kinematics / checkerboard imports (P1 body)

16. **Massive little group `SU(2)` on minimal null splits `[import: Arkani-Hamed-Huang-Huang]`;
    massive spinor-helicity `1709.04891`.** P1 v3 sections 6, 12. `[import]` + `[comp/orig]`
    packaging. **Provenance status: BEST IN CLASS** - named, arXiv-keyed, grade-tagged.
    Use as the template. Minor: not yet in a bibliography file.
17. **Feynman checkerboard / Penrose zigzag; Gersch, Jacobson-Schulman,
    Kauffman-Noyes, Destri-de Vega.** P1 v3 sections 5, 10, 12; Outlines outline 4.
    `[import]`; the exact 1+1D bracket identity is `M [orig]`. **Gap:** checkerboard
    literature is name-only; the "standard checkerboard dispersion" quoted for
    `cos(omega a) = cos(k a) cos(mu a)` needs a specific source.
18. **"Mass without mass" (Wilczek essay) and Koide's original.** P1 v3 sections 4, 12;
    layer 5. `[import]`. **Gap: already self-flagged** - "two imports ... remain
    flagged for source verification before submission." Koide recurs 5x (equipartition
    gate M-KOIDE) and needs the original Koide reference plus a current PDG/pole-mass
    source for the `9 x 10^-6` precision figure.
19. **Confinement area law: Wilson 1974, Osterwalder-Seiler.** Outlines outline 3.
    `M [comp]` for the finite Lean area law; `[import]` for the physics. **Gap:**
    both name-only (Wilson has a bare year; Osterwalder-Seiler no year/venue).

## 2. Required source type per gap

| Gap | Cluster | Required source type |
|---|---|---|
| 1 Furey-Hughes symmetry breaking | octonion | source key + arXiv/doi (paper) |
| 2 Furey ID/DOI mismatch | octonion | provenance reconciliation (Lean decl + DOI check) |
| 3 Chevalley/supertrace identity | octonion | paper theorem + convention note vs XOR basis |
| 4 computed J charges | octonion | Lean declaration provenance (charge=number-operator convention key) |
| 5 teleparallel E-slot | gravity | paper section + convention note (no-overclaim) |
| 6 WW+Marolf/Jacobson | gravity | theorem statement + hypotheses (paper) |
| 7 Malament/HKM/Sorkin/BD | gravity | paper/theorem; restore backing file |
| 8 finite Gupta-Bleuler positivity | modular/QFT | functional-analysis book/paper + memo provenance |
| 9 three J operators | modular/QFT | convention note citing Connes (KO) + Tomita-Takesaki |
| 10 Shale-Stinespring/Jones/UM | modular/QFT | theorem-level anchors (papers) |
| 11 RG/Schur, retardedness=Wilson | RG-Schur | internal memo provenance + GW/Luescher paper anchors |
| 12 NN/GW/overlap/MKS/AS | chirality/anomaly | theorem-level anchors (papers) |
| 13 Witten/Distler-Garibaldi/Springer-Veldkamp/triality | chirality/anomaly | paper theorem + algebra text (Springer-Veldkamp book) |
| 14 future-cone positivity | positive-sector | convention cross-ref (signature); Lean anchor already good |
| 15 Kugo-Ojima witness | positive-sector | paper + interpretation caveat (convention note) |
| 16 AHHH little group | kinematics | source key (already arXiv-tagged) |
| 17 checkerboard | kinematics | paper sources (several) |
| 18 Wilczek/Koide/PDG | values | essay + original paper + data source (PDG) |
| 19 Wilson/Osterwalder-Seiler | confinement | paper year/venue |

CAS/oracle fixtures: gap 4 (and any `n a t i v e _ d e c i d e` charge computation) falls under
the AGENTS.md "CAS and oracle policy" - the `n a t i v e _ d e c i d e` lattice computations are
draft-trust and should record tool/version and stay out of trusted Lean, which the
notes already respect. No new CAS fixture provenance gaps were found in the audited files.

## 3. Proposed SourceTrace / docstring entries (safe wording)

Wording deliberately avoids asserting that a source PROVES a project claim; it
records inspiration/comparison and defers the statement-and-convention match. These
are PROPOSALS for maintainers to apply after Neo4j/Zotero verification, not applied
edits.

**(a) New null-edge bibliography file** `Sources/Null_Edge_References.md`, mirroring
the `Paper_References.md` `[Key]` format, scoped to the null-edge/NullStrand program.
Seed keys (verify IDs before adding): `[ArkaniHamedHuangHuang2017] arXiv:1709.04891`,
`[NielsenNinomiya1981]`, `[GinspargWilson1982]`, `[Neuberger1998]`,
`[Luscher1998]`, `[ColemanMandula1967]`, `[WeinbergWitten1980]`, `[Marolf]`,
`[Wilson1974]`, `[OsterwalderSeiler1978]`, `[Koide1982]`, `[Wilczek_MassWithoutMass]`,
`[Kugo Ojima1979]`, `[DistlerGaribaldi2010]`, `[SpringerVeldkamp2000]`,
`[FureyHughes2022 arXiv:2210.10126]`.

**(b) Manuscript / doc SourceTrace stanza template** (safe wording):

```
Source: <Author Year>, <venue>, arXiv/doi:<id>, <section/theorem>.
Role: [import] classical input compared against, NOT a proof of the project claim.
Convention check: <signature / grading / normalization matched? which lemma?> - PENDING.
Grade of the project claim that cites it: <M | C | T|H>.
```

**(c) Torus design doc** (`WeitzenbockQC_TorusModel_DESIGN.md`, line 110): the
`(cf. arXiv:hep-lat/0309120.)` in `shift_mul_pointwise` is an unverified pointer for
an elementary lattice covariant-difference identity. Safe replacement:

```
Note (convention): this is the standard lattice covariant shift-past-gauge
identity; proved here from the definitions (clean-room), not taken from a source.
See a lattice gauge theory text for the same relation; the "cf." arXiv id above is
UNVERIFIED and should be confirmed or dropped before the brick ships.
```

**(d) Lean provenance for `NullEdgeFureyInternalSpectrum`** (module docstring
addition): record the charge = scaled number-operator convention key.

```
Provenance: charge-as-number-operator convention from Furey (charge quantization
from a number operator; verify arXiv 1603.04078 vs 1603.04783 against DOI) and the
ladder-operator table of Furey 2018 (arXiv:1806.00612). The Q_op eigenvalue signs/
normalization follow this repo's XOR octonion basis via
PhysicsSM.Algebra.Octonion.ConventionBridge, NOT Furey verbatim (AGENTS.md octonion
rule). Charges here are re-COMPUTED (n a t i v e _ d e c i d e, draft-trust), not copied.
```

**(e) Convention note for the three-J terminology guard** (CONVENTIONS.md /
Charter): add "citing Connes NCG (real structure / KO-dimension) for `J_C` and
Tomita-Takesaki modular theory for `J_mod`" so the separation rule names its imports.

## 4. Top five source-key additions / Neo4j-Zotero searches (highest traceability gain)

Ranked by how many load-bearing claims each unblocks:

1. **Stand up `Sources/Null_Edge_References.md` and pull every name-only citation
   through the Neo4j pipeline** (`Scripts/lit/neo4j_paper_search.py --query` for
   relevance, `--chunks` for the exact section a lemma/convention lives in). This is
   the single highest-leverage action: it satisfies Outlines checklist item 4 and
   converts ~35 name-only mentions into keyed, section-anchored references. Priority
   sub-batch (block the most claims): Nielsen-Ninomiya, Ginsparg-Wilson, Neuberger
   overlap, Luescher lattice chiral symmetry, McKean-Singer, Atiyah-Singer.
2. **Weinberg-Witten + Marolf (+ Jacobson fallback) exact statements** for the
   gravity/redundancy obligation (Charter U2). Zotero search + `--chunks` on the
   hypotheses; without the precise no-go hypotheses the "obligation not bonus"
   framing is unsupported.
3. **Gupta-Bleuler / Kugo-Ojima + finite-dimensional Krein/Pontryagin positivity
   reference** (e.g. Bognar or Azizov-Iokhvidov indefinite-inner-product source),
   plus surfacing the `Q01_answer.md` memo provenance. Unblocks P1 layer 4, Charter
   U1, and Outlines outline 5 - the program's positivity keystone.
4. **Teleparallel anchors: Pereira-Vargas, Zubkov, Nester, Maluf, Witten** for the
   E-slot "discrete-teleparallel" reading (Outlines outline 2). Neo4j `--chunks` to
   confirm each says what is attributed, then key them; carry the Q02 no-overclaim
   correction ("no gravity-action = E-slot-trace") as a cited convention note.
5. **Furey provenance reconciliation:** verify `1603.04078` vs `1603.04783` and
   `1910.08395` vs the 2018 PLB DOI against Zotero/DOI, add the missing
   Furey-Hughes 2022 "Division algebraic symmetry breaking" (`arXiv:2210.10126`)
   key, and confirm the Chevalley/`Lambda(C^3)` = XOR-Fano bridge against
   `PhysicsSM.Algebra.Octonion.ConventionBridge` before the Charter's "one object,
   two coordinate systems" claim is repeated outward.

## 5. Edit discipline (why no source files were changed)

Per the "audit job; do not make broad edits unless a minimal correction is obvious"
constraint and the "do not assert that a source proves a claim unless statement and
conventions match" constraint: none of the corrections above is unambiguously safe
without external verification (arXiv/DOI resolution, Neo4j full-text, Zotero).
Changing an arXiv ID, adding a bibliography entry, or rewording a docstring citation
could itself introduce a wrong or overclaiming provenance line. The two self-flagged
items (Furey IDs in `Paper_References.md`; Wilczek/Koide in P1 v3 section 12) are
already marked for verification in place and were left as-is. This report is the
deliverable; applying section 3's proposals is the follow-up once section 4's
searches are run.

## 6. Positive findings (provenance that is already sound)

- P1 v3's grade calculus and layered status map are exemplary: every non-exposition
  sentence is graded, imports are tagged `[import]`, and the manuscript repeatedly
  refuses spectral language until the positivity gate closes.
- The future-cone / positive-light kinematics (gap 14) rest on in-repo kernel-checked
  identities rather than citations - the intended provenance model.
- The AHHH little-group import (gap 16) is the template to copy: named + arXiv-keyed
  + grade-tagged.
- Both Charter and Outlines already pre-register a "no unverified citations" gate;
  this audit populates the backlog behind it rather than discovering an unguarded
  overclaim.
