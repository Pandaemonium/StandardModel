# Null-edge / NullStrand reference map

Status: live provenance aid, not a final bibliography.
Last updated: 2026-07-07.

This file is the null-edge counterpart of `Sources/Paper_References.md`.  It
tracks source keys, identifiers, and claim-boundary roles for the null-edge /
NullStrand program.  A row here is not, by itself, a claim that the source proves
one of this repo's theorems.  It records the current citation state so future
docstrings and manuscript claims can cite precise keys only after statement and
convention checks.

Lean-side provenance records can use the lightweight metadata vocabulary in
`PhysicsSM/Meta/SourceTrace.lean`: `SourceRef`, `SourceRole`,
`VerificationStatus`, `ConventionCheck`, and `TraceRecord`.  The Markdown table
here remains the human-facing source map; `SourceTrace.lean` gives declaration
and fixture provenance a typed shape.

Status labels:

- `KEYED-LOCAL`: the run log records a Zotero/Neo4j key or a local graph hit.
- `ID-ONLY`: an arXiv/DOI identifier is present locally, but no source key is
  recorded in this file yet.
- `NEEDS-VERIFY`: author-name-only or otherwise not checked enough for outward
  citation.
- `NO-FULLTEXT`: metadata exists locally, but chunk-level theorem support is not
  available in the local graph.

## Core carrier / Weitzenbock / graph Dirac sources

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `BQJAG9TR` | `hep-th/9503153` | Ackermann-Tolksdorf, "The generalized Lichnerowicz formula and analysis of Dirac operators" | Candidate continuum Weitzenbock/Lichnerowicz comparison for carrier-square and curvature-slot wording (chunk-matched, not yet quoted). | KEYED-LOCAL; full-text chunks located 2026-07-08, not yet manuscript-citation-quoted |
| `2DEG7MT2` | `0708.3707` | "First order approach and index theorems for discrete and metric graphs" | Discrete graph Dirac/index comparison for W1 brick-2 design. | KEYED-LOCAL |
| `WW6TKVH8` | `2203.02782` | "Laplace and Dirac Operators on Graphs" | Secondary graph-Dirac background. | KEYED-LOCAL |
| `DCIW87IM` | `1301.3480` | "Gauge networks in noncommutative geometry" | Finite graph/covariant-edge Dirac scaffold for carrier `D = sum c(alpha_e) nabla_e`. | KEYED-LOCAL |
| `GU9K5KKW` | `hep-lat/0309120` | "Dirac-Kahler fermion with noncommutative differential forms on a lattice" | Lattice shift-exchange / non-Leibniz mechanism for torus `Q_C`; use as convention/framing, not proof of this repo's scalar readout. | KEYED-LOCAL |

## Strong-coupling / closure / reflection-positivity sources

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `SMH5768W` | DOI `10.1016/0003-4916(78)90039-8` | Osterwalder-Seiler, "Gauge field theories on a lattice" | OS1 and QC strong-coupling background; finite Lean rungs remain clean-room finite algebra. | KEYED-LOCAL, NO-FULLTEXT |
| `UARD9T5Q` | DOI `10.1007/3-540-11559-5` | Seiler, *Gauge Theories as a Problem of Constructive Quantum Field Theory and Statistical Mechanics* | Constructive gauge-theory / strong-coupling background. | KEYED-LOCAL, NO-FULLTEXT |
| `N7SIEMAC` | DOI `10.1007/BF01206134` | Tomboulis-Yaffe, "Finite Temperature SU(2) Lattice Gauge Theory" | TY partition-ratio/reflection-positivity lineage for finite center-twist and QC normalization. | KEYED-LOCAL, NO-FULLTEXT |
| `K9FIBTZC` | `0808.3442` | Kanazawa SU(N) generalization / notation layer | SU(N) center-twist notation and Tomboulis-Yaffe lineage. | KEYED-LOCAL |
| `T2Z3STSB` | `1811.09770` | Ising lattice gauge Wilson-loop material | Secondary Z2 lattice-gauge comparison for finite transfer/readout. | KEYED-LOCAL, no local full-text chunks in round 14 |
| `5NACST85` | `2204.12737` | Shen-Zhu-Zhu functional-inequality route | Alternative explicit small-coupling route; not the current Lean first rung. | KEYED-LOCAL |
| `AXAWAGGB` | `1412.5148` | Gaiotto-Kapustin-Seiberg-Willett, "Generalized Global Symmetries" | Modern one-form center-symmetry framing for finite twist backgrounds. | KEYED-LOCAL, framing only |

## Chirality / overlap / index comparison sources

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `BEG87SU5` | `hep-lat/9808010` | Neuberger overlap locality record | Overlap/locality comparison for finite Ginsparg-Wilson and index files. | KEYED-LOCAL |
| `TBD-NielsenNinomiya` | TBD | Nielsen-Ninomiya no-go theorem | Classical doubling no-go comparison for finite signed-zero-count skeletons. | NEEDS-VERIFY |
| `N68MN4ET` | `hep-lat/9802011` | Luscher, "Exact chiral symmetry on the lattice and the Ginsparg-Wilson relation" | Candidate lattice-chirality convention; exact lattice chiral symmetry from the GW relation (chunk-matched, not yet quoted). | KEYED-LOCAL; full-text chunks located 2026-07-08, not yet manuscript-citation-quoted |
| `TBD-NeubergerOverlap` | TBD | Neuberger overlap operator | Imported overlap-operator convention beyond the local finite algebra. | NEEDS-VERIFY |
| `TBD-McKeanSinger` | TBD | McKean-Singer index theorem | Analytic comparison only; do not cite for finite PSA/sector additivity until a precise theorem anchor is checked. | NEEDS-VERIFY |
| `TBD-AtiyahSinger` | TBD | Atiyah-Singer index theorem | Continuum comparison for index language. | NEEDS-VERIFY |

## Krein / modular / positivity sources

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `TBD-TemporalLorentzianSpectralTriples` | `1210.6575` | "Temporal Lorentzian Spectral Triples" | Krein-adjoint and fundamental-symmetry comparison for carrier `#` wording. | ID-ONLY |
| `TBD-SemiRiemannianNCGThesis` | `1812.00038` | "Semi-Riemannian NCG, Gauge Theory, and the SM" | Indefinite spectral triple / chirality / finite IST comparison. | ID-ONLY |
| `TBD-KreinFermionicAction` | `1505.01939` | "Krein spectral triples and the fermionic action" | Krein-square / fermionic-action comparison. | ID-ONLY |
| `TBD-GuptaBleuler` | TBD | Gupta-Bleuler physical-state construction | Name-only import behind the finite quotient analogy. | NEEDS-VERIFY |
| `TBD-KugoOjima` | TBD | Kugo-Ojima quartet / physical-subspace criterion | Name-only import; current finite witness is kernel-checked but carrier/Gauss wiring remains OPEN. | NEEDS-VERIFY |
| `TBD-BognarOrAzizovIokhvidov` | TBD | Indefinite inner-product / Pontryagin-space reference | Functional-analysis backing for finite positive-sector framing. | NEEDS-VERIFY |
| `TBD-ConnesNCG` | TBD | Connes noncommutative geometry / real structures | Convention source for `J_C` / KO terminology. | NEEDS-VERIFY |
| `TBD-TomitaTakesaki` | TBD | Tomita-Takesaki modular theory | Convention source for `J_mod`; state dependence must be explicit. | NEEDS-VERIFY |
| `TBD-ShaleStinespring` | TBD | Shale-Stinespring implementability | Continuum gate / obstruction. | NEEDS-VERIFY |
| `TBD-JonesThompson` | TBD | Jones / Thompson-group covariance obstruction | Continuum gate / obstruction. | NEEDS-VERIFY |

## Gravity / causal-order / teleparallel sources

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `TBD-TeleparallelHigherGauge` | `1204.4339` | "Teleparallel Gravity as a Higher Gauge Theory" | Teleparallel torsion/coframe framing for E-slot interpretation. | ID-ONLY |
| `TBD-WittenPET` | TBD | Witten positive energy theorem | Continuum positive-energy comparison for E/gravity-slot aspirations. | NEEDS-VERIFY |
| `TBD-WeinbergWitten` | TBD | Weinberg-Witten theorem | Gravity/redundancy obligation; exact hypotheses are load-bearing. | NEEDS-VERIFY |
| `TBD-Marolf` | TBD | Marolf gravitational charge / no-local-stress-energy comparison | Gravity/redundancy obligation; exact statement not pinned. | NEEDS-VERIFY |
| `TBD-Jacobson` | TBD | Jacobson thermodynamic gravity comparison | Fallback interpretive comparison only until exact source anchor is checked. | NEEDS-VERIFY |
| `TBD-Malament` | TBD | Malament causal order/conformal structure theorem | NullStrand order-vs-scale split; exact theorem anchor needed. | NEEDS-VERIFY |
| `TBD-HawkingKingMcCarthy` | TBD | Hawking-King-McCarthy causal order result | NullStrand order-vs-scale split; exact theorem anchor needed. | NEEDS-VERIFY |
| `TBD-SorkinBenincasaDowker` | TBD | Causal-set order/number and action literature | Emergent geometry comparison; exact sources not pinned here. | NEEDS-VERIFY |

## Octonion / Furey / Standard Model bridge sources

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `Furey2015` | `1603.04078` in `Paper_References.md`, but ID mismatch flagged | Furey, "Charge Quantization from a Number Operator" | Charge-as-number-operator convention for Furey internal spectrum. | NEEDS-VERIFY for ID reconciliation |
| `Furey2018a` | `1806.00612` | Furey ladder-operator / SM symmetry source | Ladder and charge-table comparison; use through project convention bridge, not verbatim signs. | KEYED in `Paper_References.md` |
| `TBD-FureyHughes2022` | `2210.10126` | Furey-Hughes division-algebraic symmetry-breaking paper | O -> H -> C and symmetry-breaking cascade mentioned in Furey/Baez survey. | ID-ONLY |
| `FureyHughes2024` | `2409.17948` | "Three Generations and a Trio of Trialities" | Triality/family-symmetry comparison. | KEYED in `Paper_References.md` |
| `Baez2002` | `math/0105155` | Baez, "The Octonions" | Octonion background; not verbatim convention source for this repo's XOR basis. | KEYED in `Paper_References.md` |
| `BaezHuerta2010` | `0904.1556` | Baez-Huerta GUT square | SM group and Z6 comparison. | KEYED in `Paper_References.md` |
| `TBD-DistlerGaribaldi` | TBD | Distler-Garibaldi Standard Model no-go / index comparison | Gauge-outer and SM-selection no-go comparison; exact statement needed. | NEEDS-VERIFY |
| `TBD-SpringerVeldkamp` | TBD | Springer-Veldkamp local triality / projective geometry source | Triality algebra comparison; exact chapter/theorem needed. | NEEDS-VERIFY |

## Massive kinematics / checkerboard / mass-values sources

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `TBD-ArkaniHamedHuangHuang2017` | `1709.04891` | Arkani-Hamed, Huang, Huang massive spinor-helicity source | Massive little-group / null-split comparison in P1.  This is the template: named and arXiv-keyed, but still needs a local bibliography key. | ID-ONLY |
| `TN53N8J2` | `1610.01142` | "Spin on a 4D Feynman Checkerboard" | Checkerboard/null-zigzag toy comparison. | KEYED-LOCAL |
| `TBD-PenroseZigZag` | `1107.4909` | "The zig-zag road to reality" | Penrose zig-zag / two-Weyl-spinor mass comparison. | ID-ONLY |
| `TBD-FeynmanCheckerboard` | TBD | Feynman checkerboard source | Standard 1+1 checkerboard dispersion comparison. | NEEDS-VERIFY |
| `TBD-Koide1982` | TBD | Koide original relation | Q07 / T-solder mass-values comparison. | NEEDS-VERIFY |
| `TBD-WilczekMassWithoutMass` | TBD | Wilczek "Mass without mass" essay | Framing only, not theorem support. | NEEDS-VERIFY |
| `TBD-PDGLeptonMasses` | TBD | PDG or equivalent data source | Numerical precision for Koide/comparison claims. | NEEDS-VERIFY |

## All-mass related-work anchors (2026-07-08 lit review)

Surfaced by the comprehensive review
(`Sources/Null_Edge_All_Mass_Literature_Review_2026-07-08.md`) and now cited in
the manuscript §2a / References. `ID-ONLY` pending Zotero keying + convention
check; Neo4j MCP was down this session, so ingest via `Scripts/lit/lit_ingest.py`
(existence-check on arXiv id first). The three flagged as novelty-critical
(closest prior art) are marked `[CRITICAL]`.

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `TBD-BiziBrouderBesnard2016` | `1611.07062` | Bizi-Brouder-Besnard, "Space and time dimensions of algebras ... Lorentzian NCG" | `[CRITICAL]` Krein spectral triple SOLVING fermion doubling = the §6/§8 Krein-positive-sector move; narrows §2a novelty. | ID-ONLY |
| `TBD-Barrett2007` | `hep-th/0608221` | Barrett, "A Lorentzian version of the NCG of the Standard Model" | `[CRITICAL]` finite Lorentzian + SM prior art (Fable-flagged gap). | ID-ONLY, NEEDS-VERIFY |
| `TBD-FosterJacobson2016-4D` | `1610.01142` | Foster-Jacobson, "Spin on a 4D Feynman Checkerboard" | `[CRITICAL]` 4D null-face checkerboard Dirac, projection amplitudes, no doubling; closest carrier prior art (already keyed `TN53N8J2`; elevated to must-cite in §2a). | KEYED-LOCAL |
| `TBD-Connes2006` | `hep-th/0608226` | Connes, "NCG and the SM with neutrino mixing" | KO-dimension-6 fermion-doubling cure; SM+gravity+see-saw. | ID-ONLY |
| `TBD-BakirciogluArnaultArrighi2025` | `2505.07900` | Bakircioglu-Arnault-Arrighi, "Fermion Doubling in Quantum Cellular Automata" | Chiral doubler-free neutrino-like QCA + Nielsen-Ninomiya evasion (F7). | ID-ONLY |
| `TBD-NielsenNinomiya1981` | INSPIRE 155854 | Nielsen-Ninomiya, "Absence of neutrinos on a lattice" | The no-go traded by the Krein `J`-hermiticity route (F7, §8). | ID-ONLY |
| `TBD-Zwanziger1991` | DOI `10.1016/0550-3213(91)90581-H` | Zwanziger, "Vanishing zero-momentum lattice gluon propagator and color confinement" | Confinement = singlets get real mass by reflection positivity; the prior form of §6 balanced closure (F2). | ID-ONLY |
| `TBD-YangEtAl2018` | `1808.08677` | Yang et al., "Proton Mass Decomposition from the QCD EMT" | The proton mass budget (§4, §5); scheme-dependence. | ID-ONLY |
| `TBD-Liu2021` | `2103.15768` | Liu, "Proton mass decomposition and hadron cosmological constant" | RG-invariant vs scheme-dependent decomposition; the §4a/§5 caveat's exact ref. | ID-ONLY |
| `TBD-NuFIT60-2024` | `2410.05380` | Esteban et al., NuFIT-6.0 | Neutrino oscillation global fit; the P-ν comparison target. | ID-ONLY |
| `TBD-Sumino2009` | `0812.2103` | Sumino, family gauge symmetry and Koide's formula | The "Sumino bar" (QED running) a Koide route must clear (§5). | ID-ONLY |
| `TBD-CecchiniLesourdZeidler2023` | `2307.05277` | Cecchini-Lesourd-Zeidler, positive mass with dominant-energy shields | Extra timelike spinor direction; the shape of F4 (finite Witten positive-mass). | ID-ONLY |
| `TBD-Golovnev2024` | `2411.14089` | Golovnev, "Is there any Trinity of Gravity ...?" | Skeptical critique of the geometric trinity; cite for §7 honesty. | ID-ONLY |
| `TBD-OsborneVerstraete2005` | `quant-ph/0502176` | Osborne-Verstraete, general n-qubit CKW monogamy | Entanglement-monogamy prior art for F3 (mass monogamy as Plücker superadditivity). | ID-ONLY |
| `TBD-Nandi2022` | `2204.13649` | Nandi, G-concurrence monogamy in higher dimension | The higher-dim wedge/determinant concurrence closest to Plücker mass (F3). | ID-ONLY |
| `TBD-MeltonMichaelsenRuzziconi2026` | `2606.27421` | Melton-Michaelsen-Ruzziconi, "Observing Massive Scattering from Null Infinity" | Massive <-> timelike infinity = the celestial reading of the thesis (F9). | ID-ONLY |
| `TBD-FernandezProcacci2006` | `math-ph/0605041` | Fernandez-Procacci, cluster-expansion bounds via Penrose identity | Target abstraction for the forest-injection bounty (Kotecky-Preiss lineage). | ID-ONLY |
| `TBD-ToobySmith2024-HepLean` | `2405.08863` | Tooby-Smith, "HepLean: Digitalising high energy physics" | Machine-verified physics already exists; narrows §2a methodology claim. | ID-ONLY |
| `TBD-ElvangHuang2013` | `1308.1697` | Elvang-Huang, "Scattering Amplitudes" | Canonical spinor-helicity `det P` kinematics reference (§3). | ID-ONLY |
| `TBD-Kull2002` | `quant-ph/0212053` | Kull, checkerboard on dense-rational 2D Minkowski | Non-continuous-spacetime checkerboard precedent (§2a). | ID-ONLY |

## Next provenance actions

1. Resolve the `ID-ONLY` entries into bare Zotero/Neo4j keys or downgrade their
   manuscript usage to name-only background with explicit verification debt.
2. For each `NEEDS-VERIFY` row, run `Scripts/lit/neo4j_paper_search.py --query`
   to identify the paper and `--chunks` when the claim depends on an internal
   theorem, convention, or hypothesis.
3. Before any outward citation, add section/theorem/page anchors where possible
   and record the convention check: signature, grading, chirality, octonion
   basis, normalization, and scalar field.
4. Keep this file synchronized with `LIT_LOG.md`, manuscript claim grades, and
   Lean module docstrings.  Do not promote a source from `NEEDS-VERIFY` based on
   author memory alone.
5. When a Lean declaration or oracle fixture needs structured provenance, add a
   `TraceRecord`-shaped note using `PhysicsSM.Meta.SourceTrace` vocabulary:
   source role, verification status, locator, and explicit convention checks.
