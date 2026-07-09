# Null-edge / NullStrand reference map

Status: live provenance aid, not a final bibliography.
Last updated: 2026-07-09.

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
| `BVJBTK8J` | `1601.04832` | "Free quantum field theory from quantum cellular automata: derivation of Weyl, Dirac and Maxwell quantum cellular automata" | QCA/free-field comparison for discrete Dirac constructions; background only. | KEYED-LOCAL; Neo4j hit 2026-07-08 |
| `B7IRW5HZ` | `hep-th/9304070` | "Dirac and Weyl equations on a lattice as quantum cellular automata" | Early lattice Dirac/Weyl-as-QCA comparison. | KEYED-LOCAL; Neo4j hit 2026-07-08 |
| `arxiv:2503.05998` | `2503.05998` | "Quantum Electrodynamics from Quantum Cellular Automata, and the Tension Between Symmetry, Locality and Positive Energy" | QCA/positive-energy comparison; adjacent background, not support for null-edge claims. | KEYED-LOCAL; Neo4j hit 2026-07-08 |
| `TBD-NeubergerOverlap` | TBD | Neuberger overlap operator | Imported overlap-operator convention beyond the local finite algebra. | NEEDS-VERIFY |
| `TBD-McKeanSinger` | TBD | McKean-Singer index theorem | Analytic comparison only; do not cite for finite PSA/sector additivity until a precise theorem anchor is checked. | NEEDS-VERIFY |
| `TBD-AtiyahSinger` | TBD | Atiyah-Singer index theorem | Continuum comparison for index language. | NEEDS-VERIFY |

## Krein / modular / positivity sources

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `TBD-TemporalLorentzianSpectralTriples` | `1210.6575` | "Temporal Lorentzian Spectral Triples" | Krein-adjoint and fundamental-symmetry comparison for carrier `#` wording. | ID-ONLY |
| `Bizi2018-SemiRiemannianNCGThesis` | `1812.00038` | N. Bizi, "Semi-Riemannian NCG, Gauge Theory, and the SM" PhD thesis (2018) | Indefinite spectral triple over Z2-graded Krein space; grading involution adjoint sign flip Gamma^ddag = (-1)^q Gamma — NCG precedent for the S6 closure grading b being Krein-ddag-odd. Cited in manuscript S6 refs. | VERIFIED (abstract + full-text chunks 75/79/87/88; author confirmed via arXiv) |
| `vandenDungen2016-KreinFermionicAction` | `1505.01939` | K. van den Dungen, "Krein spectral triples and the fermionic action", Math. Phys. Anal. Geom. 19 (2016) 4 | Krein-space spectral triples; fundamental-symmetry decomposition K = K+ (+) K-; indefinite-inner-product setting for the S6 balanced-closure form. Cited in manuscript S6 refs ([import] setting; anticonjugation-forces-balance is [orig]). | VERIFIED (abstract + full-text chunk 4; author/doi confirmed via arXiv) |
| `Gupta1950-LongitudinalPhotons` | doi:10.1088/0370-1298/63/7/301 | S. N. Gupta, "Theory of longitudinal photons in quantum electrodynamics", Proc. Phys. Soc. A63 (1950) 681 | Indefinite-metric QED + modified supplementary condition — classic precedent for the S6 physical-subspace/quotient analogy. Paired with Bleuler 1950. | VERIFIED (abstract + doi via inspireHEP lit/3551; abstract explicitly = indefinite metric + supplementary condition) |
| `Bleuler1950-LongScalarPhotons` | Helv. Phys. Acta 23 (1950) 567 | K. Bleuler, "Eine neue Methode zur Behandlung der longitudinalen und skalaren Photonen" | Companion to Gupta 1950; indefinite-metric physical-state selection. | VERIFIED-CLASSIC (standard record; German original, no arXiv; universally paired with Gupta) |
| `KugoOjima1979-LocalCovariant` | doi:10.1143/PTPS.66.1 | T. Kugo, I. Ojima, "Local Covariant Operator Formalism of Nonabelian Gauge Theories and Quark Confinement Problem", Prog. Theor. Phys. Suppl. 66 (1979) 1 | BRS-charge quartet / physical-subspace criterion; develops "general theory of indefinite metric quantum fields" — the nonabelian Gauss-sector precedent for S6. Finite witness kernel-checked; full carrier/Gauss wiring still OPEN. | VERIFIED (abstract + doi via inspireHEP lit/8189, 1223 cites) |
| `AzizovIokhvidov1989-IndefiniteMetric` | Wiley (1989); survey doi:10.1007/bf01375563 (1981) | T. Ya. Azizov, I. S. Iokhvidov, "Linear Operators in Spaces with an Indefinite Metric" | Standard Krein-space operator-theory monograph: `J`-self-adjoint / `J`-unitary operators, fundamental symmetry. Functional-analysis backing for the finite positive-sector framing and the `J`-self-adjoint-generator ⇒ `J`-unitary-flow lemma (S9a / kreinflow target). Companion: J. Bognár, "Indefinite Inner Product Spaces", Springer (1974). | VERIFIED (authors/doi via crossref; canonical monograph) |
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
| `TBD-Jacobson` | `gr-qc/9504004` | Jacobson, "Thermodynamics of spacetime: the Einstein equation of state" | Equation-of-state framing for the finite `JacobsonClausius` avatar (§7); Lambda enters as the integration constant. Manuscript §7 now names it. | ID-ONLY; verify chunk before quoting |
| `TBD-ChamseddineConnesMarcolli` | `hep-th/0610241` | Chamseddine-Connes-Marcolli, "Gravity and the standard model with neutrino mixing" | Spectral-action gravity+SM; the `SpectralActionAvatar`/`EinsteinHilbertTerm` order-2/4 split is the finite avatar. | ID-ONLY |
| `TBD-QuiverSpectralAction` | `2401.03705` | "Bratteli networks and the spectral action on quivers" | Discrete/finite spectral-action precedent for our finite Krein carrier. | ID-ONLY |
| `TBD-TwistedSpectralTriples` | `1710.04965` | "Lorentz signature and twisted spectral triples" | Lorentzian/Krein spectral-triple + spectral-action anchor (§7 unification). | ID-ONLY |
| `TBD-Malament` | TBD | Malament causal order/conformal structure theorem | NullStrand order-vs-scale split; exact theorem anchor needed. | NEEDS-VERIFY |
| `TBD-HawkingKingMcCarthy` | TBD | Hawking-King-McCarthy causal order result | NullStrand order-vs-scale split; exact theorem anchor needed. | NEEDS-VERIFY |
| `TBD-SorkinBenincasaDowker` | TBD | Causal-set order/number and action literature | Emergent geometry comparison; exact sources not pinned here. | NEEDS-VERIFY |

## Cosmological constant sources (2026-07-09, for §10a + the Lambda doc)

Manuscript §10a and `Null_Edge_Cosmological_Constant_2026-07-09.md` cite these. All
`ID-ONLY`/`NEEDS-VERIFY`: the manuscript's own claims are graded **M** (the finite
scaling arithmetic) with the mechanism/conjugacy explicitly `[import]`; verify these
before any outward-facing quotation of their internal results.

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `TBD-EverpresentLambda` | `astro-ph/0209274` | Ahmed-Dodelson-Greene-Sorkin, "Everpresent Lambda" | THE `Lambda ~ 1/sqrt(V)` prediction; §10a names it as the imported mechanism our finite scaling (`LambdaEdgeCount`) routes through the native edge count. | ID-ONLY; verify magnitude claim before quoting |
| `TBD-SorkinCC2007` | TBD | Sorkin, "Is the cosmological constant a nonlocal quantum residue of discreteness?" | Everpresent-Lambda origin/framing. | NEEDS-VERIFY |
| `TBD-JacobsonEntanglementEq` | `1505.04753` | Jacobson, "Entanglement equilibrium and the Einstein equation" | Modern entanglement version of the equation-of-state route. | ID-ONLY |
| `TBD-CausalDiamondsAdS` | `1812.01596` | "Gravitational thermodynamics of causal diamonds in (A)dS" | Causal-diamond thermodynamics (our finite slab/diamond avatar). | ID-ONLY |
| `TBD-DESIDR2` | `2503.14738` | DESI DR2 BAO cosmological measurements | Observational posture: ~3.1sigma hint of evolving dark energy (friendly, NOT a confirmation of this framework). | ID-ONLY; do not overstate |
| `TBD-Planck2018` | `1807.06209` | Planck 2018 results VI: cosmological parameters | Rigid-LambdaCDM baseline for the observational posture. | ID-ONLY |
| `TBD-Hyperuniformity` | TBD | Torquato-Stillinger hyperuniformity; Martin-Yalcin, Stillinger-Lovett (Coulomb sum rules) | The hyperuniform branch of the count-statistics fork (`LambdaCountDichotomy`): constraint-induced sub-extensive number fluctuations. | NEEDS-VERIFY |
| `TBD-QFTonCausets` | `arXiv:1010.5514` | Sorkin (school), "Quantum Fields on Causal Sets" | Poisson sprinkling is the UNIQUE Lorentz-invariant discretization (ch.22: chosen so the causet picks out no direction) - the fork's Lorentz cost of the hyperuniform branch. | ID-ONLY (graph-verified title); verify the invariance argument before quoting |
| `TBD-SuryaLRR` | `arXiv:1903.11544` | Surya, "The causal set approach to quantum gravity" (Living Reviews) | Any regular discretization breaks rotational/translational symmetry ("not regular in all frames", ch.11) - corroborates the Poisson=Lorentz-invariance link for the fork. | ID-ONLY (graph-verified title); verify before quoting |

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
check; after the 2026-07-08 Neo4j restart, several local keys were confirmed,
but ID-only rows still need `Scripts/lit/lit_ingest.py` / chunk-level checks
(existence-check on arXiv id first). The three flagged as novelty-critical
(closest prior art) are marked `[CRITICAL]`; source-status wording is deliberately
conservative until local chunks are quoted.

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `TBD-BiziBrouderBesnard2016` | `1611.07062` | Bizi-Brouder-Besnard, "Space and time dimensions of algebras with applications to Lorentzian noncommutative geometry and quantum electrodynamics" | `[CRITICAL]` finite/Lorentzian/Krein NCG and fermion-doubling solution; narrows §2a novelty. | ID-ONLY; arXiv verified 2026-07-08, no local key/chunk yet |
| `TBD-Barrett2007` | `hep-th/0608221` | Barrett, "A Lorentzian version of the non-commutative geometry of the standard model of particle physics" | `[CRITICAL]` Lorentzian NCG Standard Model and fermion-doubling removal prior art. | ID-ONLY; arXiv verified 2026-07-08, no local key/chunk yet |
| `TBD-FosterJacobson2016-4D` | `1610.01142` | Foster-Jacobson, "Spin on a 4D Feynman Checkerboard" | `[CRITICAL]` 4D null-face checkerboard Dirac, projection amplitudes, no doubling; closest carrier prior art (already keyed `TN53N8J2`; elevated to must-cite in §2a). | KEYED-LOCAL; Neo4j key `TN53N8J2` confirmed 2026-07-08 |
| `TBD-Connes2006` | `hep-th/0608226` | Connes, "NCG and the SM with neutrino mixing" | KO-dimension-6 fermion-doubling cure; SM+gravity+see-saw. | ID-ONLY |
| `TBD-BakirciogluArnaultArrighi2025` | `2505.07900` | Bakircioglu-Arnault-Arrighi, "Fermion Doubling in Quantum Cellular Automata" | QCA-era fermion-doubling prior art; manuscript novelty must not imply this analysis is absent. | ID-ONLY; arXiv verified 2026-07-08, no local key/chunk yet |
| `TBD-MlodinowBrun2018` | `1802.03910` | Mlodinow-Brun, "Discrete spacetime, quantum walks, and relativistic wave equations", PRA 97 (2018) 042131 | Mass-side QW comparator (§2a): 4D coin forces Dirac gammas; coin-flip operator = mass term; massless when switched off. Rhymes with the Cl(4) carrier + critical line; not budget support. | KEYED-LOCAL; in null-edge collection, chunks quoted 2026-07-08 |
| `TBD-BisioDArianoPerinottiTosini2016` | `1601.04842` | Bisio-D'Ariano-Perinotti-Tosini, "Weyl, Dirac and Maxwell Quantum Cellular Automata" | Prior-art setup for the §9a scattering sim: 1D Dirac QCA barrier scattering (section "Scattering against a potential barrier"). Not budget support. | KEYED-LOCAL; in null-edge collection, chunk quoted 2026-07-08 |
| `TBD-NielsenNinomiya1981` | INSPIRE 155854 | Nielsen-Ninomiya, "Absence of neutrinos on a lattice" | The no-go traded by the Krein `J`-hermiticity route (F7, §8). | ID-ONLY |
| `TBD-Zwanziger1991` | DOI `10.1016/0550-3213(91)90581-H` | Zwanziger, "Vanishing of zero-momentum lattice gluon propagator and color confinement" | Positivity-violation / confinement prior-art comparison; background only, not theorem support for null-edge balanced closure. | ID-ONLY; DOI/title verified 2026-07-08, no local key/chunk yet |
| `TBD-Ji1995` | `hep-ph/9410274` | Ji, "QCD analysis of the mass structure of the nucleon", PRL 74 (1995) 1071 | The named Ji decomposition (§4/§4a target); previously listed in Provenance but absent - added 2026-07-08. | ID-ONLY |
| `TBD-Wilson1974` | DOI `10.1103/PhysRevD.10.2445` | K. G. Wilson, "Confinement of quarks", PRD 10 (1974) 2445 | The Wilson action (§6 M-theorem subject). | ID-ONLY |
| `TBD-GinspargWilson1982` | DOI `10.1103/PhysRevD.25.2649` | Ginsparg-Wilson, "A remnant of chiral symmetry on the lattice", PRD 25 (1982) 2649 | The GW relation (§8 load-bearing). | ID-ONLY |
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
| `TBD-ToobySmith2024-HepLean` | `2405.08863` | Tooby-Smith, "HepLean: Digitalising high energy physics" | Machine-verified high-energy physics already exists; narrows §2a methodology claim. | ID-ONLY; arXiv verified 2026-07-08, no local key/chunk yet |
| `TBD-ElvangHuang2013` | `1308.1697` | Elvang-Huang, "Scattering Amplitudes" | Canonical spinor-helicity `det P` kinematics reference (§3). | ID-ONLY |
| `TBD-Kull2002` | `quant-ph/0212053` | Kull, checkerboard on dense-rational 2D Minkowski | Non-continuous-spacetime checkerboard precedent (§2a). | ID-ONLY |
| `TBD-PhysLean-Weyl` | `2405.08863` | Tooby-Smith, PhysLean (`Physlib/Relativity/.../Weyl/Metric.lean`) | Convention cross-check for §3: `spinorWedge` = PhysLean left-handed Weyl metric `!![0,1;-1,0]` (clean-room match, verified 2026-07-08); see `docs/PHYSLEAN.md`. | KEYED-LOCAL (source clone) |

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
