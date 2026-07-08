# Spark literature sweep references - 2026-07-07

Status: research handoff artifact, not a final bibliography.

Purpose: collect primary or near-primary references that can advance the
null-edge / NullStrand finite carrier program across proof, audit, and strategy
lanes. A row here is not a claim that the source proves one of our results. It
records a source to check, key, chunk-search, and cite only after semantic and
convention review.

## Method and confidence labels

- Spark subagents were used as requested. The chirality/index, gravity/causal,
  and strong-coupling lanes returned useful compact bibliographies. Several
  other Spark workers failed from inherited context pressure, so their lanes were
  completed by direct primary-source search in this session.
- Local context used: `Sources/Null_Edge_References.md` and
  `AgentTasks/twoday-carrier-run-2026-07-07/LIT_LOG.md`.
- A local Neo4j vector recheck was attempted, but `neo4j_paper_search.py` failed
  while loading the sentence-transformer model with Windows OS error 1455
  ("paging file is too small"). Treat this document as not having refreshed the
  vector graph.
- `ANCHOR`: direct DOI/arXiv/publisher page or Spark direct DOI was checked.
- `LOCAL`: already appears in the local null-edge source map or literature log.
- `CANDIDATE`: good target for ingestion or chunk search, but do not use as an
  outward theorem-support citation until verified.

## Highest-value additions

These are the strongest immediate additions to the source map or SourceTrace
work, ranked by expected effect on current lanes.

| Source | Identifier | Lane | Why it matters | Next action |
|---|---|---|---|---|
| Nielsen-Ninomiya I and II | DOI `10.1016/0550-3213(81)90361-8`; DOI `10.1016/0550-3213(81)90524-1` | Chirality/no-doubling | Baseline no-go assumptions for any finite chirality claim. | Key in Zotero/Neo4j; cite only for assumption audits. |
| Ginsparg-Wilson | DOI `10.1103/PhysRevD.25.2649` | Chirality/index | Modified lattice chiral symmetry relation. | Add to chirality source map with sign/normalization note. |
| Neuberger overlap sequence | `hep-lat/9707022`, `hep-lat/9801031` | Chirality/index | Concrete overlap/Ginsparg-Wilson realization. | Resolve local key `BEG87SU5` against exact paper/title. |
| Luscher exact lattice chirality | `hep-lat/9802011`; DOI `10.1016/S0370-2693(98)00423-7` | Chirality/index | Explains how Ginsparg-Wilson evades the no-go hypotheses. | Key and chunk-search before manuscript use. |
| Luescher chiral gauge construction | `hep-lat/9811032`; `hep-lat/0006014` | Anomaly/chiral gauge | Needed to separate local anomaly cancellation from finite construction. | Ingest if not already present. |
| Gupta and Bleuler originals | DOI `10.1088/0370-1298/63/7/301`; Helv. Phys. Acta 23 (1950), 567-586 | Krein/physical quotient | Foundational indefinite-metric physical-state construction. | Use as analogy only; do not cite for positivity. |
| Kugo-Ojima | DOI `10.1143/PTPS.66.1` | Krein/Gauss/BRST | Canonical physical-subspace/quartet criterion. | Key and chunk-search for exact physical-state statement. |
| Bognar; Azizov-Iokhvidov | DOI `10.1007/978-3-642-65567-8`; Wiley 1989 | Pontryagin/Krein | Functional-analysis backing for finite positive-sector language. | Add as background references. |
| Barrett Lorentzian NCG | `hep-th/0608221`; DOI `10.1063/1.2408400` | Finite IST / NCG | Lorentzian signature and fermion-doubling fix in NCG Standard Model. | Compare KO/signature conventions before using. |
| Furey-Hughes one-generation and breaking papers | `2209.13016`; `2210.10126` | Octonion/Furey | Directly relevant to avoiding misleading complex-octonion ideal language. | Add candidate rows and chunk-search for exact actions. |
| Furey-Hughes trio of trialities | `2409.17948`; DOI `10.1016/j.physletb.2025.139473` | Octonion/triality/generations | Newest relevant division-algebra three-generation/triality anchor. | Ingest and review convention compatibility. |
| Kibble/Sciama/Hehl torsion sources | DOI `10.1063/1.1703702`; `10.1103/RevModPhys.36.463`; `10.1103/RevModPhys.48.393` | Teleparallel/torsion | Historical and structural tetrad/torsion anchors. | Use to audit tetrad versus graph-origin claims. |
| Malament/HKM/Kronheimer-Penrose | DOI `10.1063/1.523436`; `10.1063/1.522874`; `10.1017/S030500410004144X` | Causal reconstruction | Precise causal-order to topology/conformal-structure anchors. | Use to enforce Malament split in prose. |
| Weinberg-Witten/Marolf | DOI `10.1016/0370-2693(80)90212-9`; DOI `10.1103/PhysRevLett.114.031104` | Emergent gravity no-go | Hard constraints on naive emergent spin-2/local-kinematics claims. | Put into no-go/audit lane. |
| Osterwalder-Seiler/Luscher transfer matrix | DOI `10.1016/0003-4916(78)90039-8`; DOI `10.1007/BF01614090` | Reflection positivity | Direct lattice positivity/transfer-matrix anchors. | Chunk-search before using for finite model claims. |
| Kotecky-Preiss/Fernandez-Procacci | DOI `10.1007/BF01211762`; DOI `10.1007/s00220-007-0279-2` | Polymer/KP | Best abstract polymer convergence toolkit for fixed-forest lanes. | Feed to Aristotle KP strategy jobs. |

## Carrier, graph Dirac, and finite NCG

| Source | Identifier | Status | Helps with | Caveat |
|---|---|---|---|---|
| Branson, Gilkey et al., "The generalized Lichnerowicz formula and analysis of Dirac operators" | `hep-th/9503153`; local key `BQJAG9TR` | LOCAL | Continuum `D^#D` / curvature-slot comparison. | Continuum theorem, not a finite carrier proof. |
| Bandara et al., "First order approach and index theorems for discrete and metric graphs" | `0708.3707`; local key `2DEG7MT2` | LOCAL | Discrete graph Dirac/index comparison. | Graph setting differs from decorated null-edge carrier. |
| Mamatra et al., "Laplace and Dirac Operators on Graphs" | `2203.02782`; local key `WW6TKVH8` | LOCAL | Secondary graph Dirac background. | Secondary, use for orientation not theorem support. |
| Marcolli and van Suijlekom, "Gauge networks in noncommutative geometry" | `1301.3480`; local key `DCIW87IM` | LOCAL | Finite graph/covariant-edge Dirac scaffold. | Need chunk-level comparison for exact covariant edge operator. |
| D'Andrea et al., Dirac-Kaehler/noncommutative lattice forms | `hep-lat/0309120`; local key `GU9K5KKW` | LOCAL | Shift-exchange and non-Leibniz lattice mechanism. | Framing only for our finite scalar readout. |

## Chirality, overlap, index, and anomalies

| Source | Identifier | Status | Helps with | Caveat |
|---|---|---|---|---|
| Nielsen and Ninomiya, "Absence of neutrinos on a lattice: I" | DOI `10.1016/0550-3213(81)90361-8` | ANCHOR | Formal no-doubling assumptions. | Assumptions must be displayed before invoking. |
| Nielsen and Ninomiya, "Absence of neutrinos on a lattice: II" | DOI `10.1016/0550-3213(81)90524-1` | ANCHOR | Topological proof/no-go intuition. | Same caveat; not a blanket theorem against every finite model. |
| Nielsen and Ninomiya, "A no-go theorem for regularizing chiral fermions" | DOI `10.1016/0370-2693(81)91026-1` | ANCHOR | General no-go statement and review. | Use for assumptions, not rhetoric. |
| Friedan, "A Proof of the Nielsen-Ninomiya Theorem" | Commun. Math. Phys. 85 (1982), 481-490 | ANCHOR | Independent proof and technical-gap repair. | Need exact theorem hypotheses before citation. |
| Ginsparg and Wilson, "A remnant of chiral symmetry on the lattice" | DOI `10.1103/PhysRevD.25.2649` | ANCHOR | Ginsparg-Wilson relation. | Criterion, not by itself an operator construction. |
| Neuberger, "Exactly massless quarks on the lattice" | `hep-lat/9707022`; DOI `10.1016/S0370-2693(97)01368-3` | ANCHOR | Overlap construction avoiding doubling. | Depends on Wilson-kernel and admissibility details. |
| Neuberger, "More about exactly massless quarks on the lattice" | `hep-lat/9801031`; DOI `10.1016/S0370-2693(98)00355-4` | ANCHOR | Shows overlap operator satisfies Ginsparg-Wilson relation. | Operator-specific. |
| Neuberger, "A practical implementation of the Overlap-Dirac operator" | DOI `10.1103/PhysRevLett.81.4060` | CANDIDATE | Practical overlap implementation and zero modes. | Numerical approximations are separate from Lean proof. |
| Luscher, "Exact chiral symmetry on the lattice and the Ginsparg-Wilson relation" | `hep-lat/9802011`; DOI `10.1016/S0370-2693(98)00423-7` | ANCHOR | Exact modified finite-spacing chiral symmetry. | Modified symmetry, not naive continuum chirality. |
| Narayanan and Neuberger, "A construction of lattice chiral gauge theories" | `hep-th/9411108`; DOI `10.1016/0550-3213(95)00111-5` | CANDIDATE | Overlap chiral gauge construction. | Long technical source; chunk-search before use. |
| Hasenfratz, Laliena, Niedermayer, "The index theorem in QCD with a finite cut-off" | `hep-lat/9801021`; DOI `10.1016/S0370-2693(98)00315-3` | CANDIDATE | Lattice index theorem at finite cutoff. | Fixed-point/GW setting, not universal. |
| Luscher, "Abelian chiral gauge theories on the lattice with exact gauge invariance" | `hep-lat/9811032`; DOI `10.1016/S0550-3213(99)00115-7` | CANDIDATE | Nonperturbative Abelian chiral gauge construction. | Abelian scope. |
| Luscher, "Lattice regularization of chiral gauge theories to all orders of perturbation theory" | `hep-lat/0006014`; DOI `10.1088/1126-6708/2000/06/028` | CANDIDATE | Perturbative all-orders anomaly-cancellation framework. | Perturbative; global anomalies separate. |
| Kikukawa and Nakayama, electroweak lattice anomaly cancellation | `hep-lat/0005015`; DOI `10.1016/S0550-3213(00)00714-8` | CANDIDATE | Standard Model electroweak anomaly cancellation on lattice. | Cohomological framework and lattice assumptions. |
| Bar and Campos, "Global anomalies in chiral gauge theories on the lattice" | `hep-lat/0001025`; DOI `10.1016/S0550-3213(00)00182-6` | CANDIDATE | Global anomaly obstruction. | Does not supply a cure by itself. |
| McKean and Singer, "Curvature and the eigenvalues of the Laplacian" | DOI `10.4310/jdg/1214427880` | ANCHOR | Heat-kernel index comparison. | Analytic continuum result only. |
| Atiyah and Singer, "The Index of Elliptic Operators I" | Ann. Math. 87 (1968), 484-530 | ANCHOR | Continuum index theorem vocabulary. | Use only as analogy unless theorem statement matches. |

## Krein spaces, physical quotients, and modular structure

| Source | Identifier | Status | Helps with | Caveat |
|---|---|---|---|---|
| Gupta, "Theory of Longitudinal Photons in Quantum Electrodynamics" | DOI `10.1088/0370-1298/63/7/301` | ANCHOR | Indefinite metric plus physical-state condition. | Analogy only; QED construction is not our finite quotient. |
| Bleuler, "Eine neue Methode zur Behandlung der longitudinalen und skalaren Photonen" | Helv. Phys. Acta 23 (1950), 567-586 | ANCHOR | Complementary Gupta-Bleuler source. | German original; use metadata carefully. |
| Kugo and Ojima, "Local Covariant Operator Formalism..." | DOI `10.1143/PTPS.66.1` | ANCHOR | BRST/quartet physical-subspace criterion. | Do not infer finite positivity or confinement without hypotheses. |
| Bognar, *Indefinite Inner Product Spaces* | DOI `10.1007/978-3-642-65567-8` | ANCHOR | Krein/Pontryagin functional-analysis background. | Background book, not physics claim support. |
| Azizov and Iokhvidov, *Linear Operators in Spaces with an Indefinite Metric* | Wiley 1989 | ANCHOR | Operator theory in indefinite metric spaces. | Book metadata only; no DOI found in this pass. |
| Franco, "Temporal Lorentzian Spectral Triples" | `1210.6575` | ANCHOR | Global time and fundamental symmetry in Lorentzian NCG. | Depends on 3+1/global-time structure. |
| van den Dungen, "Krein spectral triples and the fermionic action" | `1505.01939` | ANCHOR | Krein spectral triples and fermionic action. | Almost-commutative examples, not finite carrier theorem. |
| Semi-Riemannian NCG thesis/source | `1812.00038` | LOCAL/CANDIDATE | Semi-Riemannian spectral-triple conventions. | Thesis-level; cite precise results only after checking. |
| Barrett, "A Lorentzian version of the non-commutative geometry of the Standard Model" | `hep-th/0608221`; DOI `10.1063/1.2408400` | ANCHOR | Lorentzian signature and NCG fermion-doubling issue. | KO/signature conventions must be matched. |
| Takesaki, *Tomita's Theory of Modular Hilbert Algebras and its Applications* | DOI `10.1007/BFb0065832` | ANCHOR | Modular conjugation and state dependence. | Modular `J` is state/operator-algebraic; do not conflate with finite charge conjugation. |
| Shale, "Linear symmetries of free boson fields" | DOI `10.1090/S0002-9947-1962-0137504-6` | ANCHOR | Implementability and Fock-space obstruction background. | Bosonic field setting. |
| Shale and Stinespring, "Spinor representations of infinite orthogonal groups" | J. Math. Mech. 14 (1965), 315-322 | ANCHOR | Fermionic implementability/Fock obstruction background. | Need original PDF/metadata before outward citation. |
| Jones, "Some unitary representations of Thompson's groups F and T" | `1412.7740`; J. Comb. Algebra 1 (2017), 1-44 | ANCHOR | Thompson/local-scale representation obstruction lane. | Strategy/audit source, not a direct physics theorem. |

## Noncommutative geometry and finite Standard Model structure

| Source | Identifier | Status | Helps with | Caveat |
|---|---|---|---|---|
| Connes and Lott, "Particle Models and Noncommutative Geometry" | DOI `10.1016/0920-5632(91)90120-4` | ANCHOR | Early NCG particle-model construction. | Historical conventions differ from later KO-dimension fix. |
| Connes, "Noncommutative geometry and reality" | DOI `10.1063/1.531241` | ANCHOR | Real structures, KR-theory, NCG `J`. | Do not identify with modular or physical quotient `J` without map. |
| Chamseddine and Connes, "The Spectral Action Principle" | `hep-th/9606001`; DOI `10.1007/s002200050126` | ANCHOR | Spectral action framework. | Euclidean/action framework; Lorentzian adaptations separate. |
| Chamseddine, Connes, Marcolli, "Gravity and the standard model with neutrino mixing" | `hep-th/0610241` | ANCHOR | KO-dimension 6 finite geometry and neutrino mixing. | Some predictions historically shifted; use for structure. |
| Connes, "Noncommutative Geometry and the standard model with neutrino mixing" | `hep-th/0608226` | ANCHOR | Conceptual finite-space structure and fermion doubling fix. | Must compare with Barrett and later treatments. |
| Barrett, Lorentzian NCG Standard Model | `hep-th/0608221`; DOI `10.1063/1.2408400` | ANCHOR | Lorentzian signature version and mass terms. | Signature conventions matter. |
| Besnard and Brouder, Lorentzian Standard Model / B-L extension | DOI `10.1103/PhysRevD.103.035003` | CANDIDATE | Modern Lorentzian NCG extension. | Later-model source; use after primary NCG anchors. |

## Octonions, division algebras, triality, and Furey lane

| Source | Identifier | Status | Helps with | Caveat |
|---|---|---|---|---|
| Baez, "The Octonions" | `math/0105155`; DOI `10.1090/S0273-0979-01-00934-X` | ANCHOR/LOCAL | Octonion, Clifford, spinor, exceptional-group overview. | Project uses XOR binary-label convention, not Baez directly. |
| Baez and Huerta, "The Algebra of Grand Unified Theories" | `0904.1556` | ANCHOR | Division algebra/GUT orientation. | Review/framing source. |
| Springer and Veldkamp, *Octonions, Jordan Algebras and Exceptional Groups* | DOI `10.1007/978-3-662-12622-6` | ANCHOR | Algebraic octonion/Jordan/exceptional-group grounding. | Book; cite exact theorem/section. |
| Dray and Manogue, *The Geometry of the Octonions* | World Scientific 2015 | CANDIDATE | Octonion geometry and triality conventions. | Need exact metadata/section before citation. |
| Distler and Garibaldi, "There is no Theory of Everything inside E8" | `0905.2658`; DOI `10.1007/s00220-010-1006-y` | ANCHOR | Representation-theoretic no-go/audit for E8 overclaims. | Applies to stated E8 embedding hypotheses. |
| Furey, "Charge quantization from a number operator" | `1603.04078`; DOI `10.1016/j.physletb.2015.01.023` | ANCHOR/LOCAL | Division-algebra ladder operators and charge quantization. | Avoid raw "minimal left ideal of complex octonions" wording; use operator algebra/module language. |
| Furey, "Standard model physics from an algebra?" | `1611.09182` | CANDIDATE | Thesis-level roadmap for `R x C x H x O`. | Thesis; cite precise definitions only after checking. |
| Furey, "SU(3)C x SU(2)L x U(1)Y (x U(1)X) as a symmetry of division algebraic ladder operators" | `1806.00612`; DOI `10.1140/epjc/s10052-018-5844-7` | ANCHOR/LOCAL | Standard Model group action from ladder symmetries. | Convention mapping to project octonions required. |
| Furey, "Three generations, two unbroken gauge symmetries, and one eight-dimensional algebra" | `1910.08395`; DOI `10.1016/j.physletb.2018.08.032` | ANCHOR | Three-generation complex-octonion construction. | Needs careful semantic audit against project's safe object language. |
| Furey and Hughes, "One generation of Standard Model Weyl representations as a single copy of R x C x H x O" | `2209.13016`; DOI `10.1016/j.physletb.2022.136959` | ANCHOR | Single-generation Weyl representation and doubling issue. | Still requires convention bridge and Lorentz-action audit. |
| Furey and Hughes, "Division algebraic symmetry breaking" | `2210.10126`; DOI `10.1016/j.physletb.2022.137186` | ANCHOR | Spin(10) to Pati-Salam to LR to SM+B-L cascade. | Model-building source; formalize algebra first. |
| Furey and Hughes, "Three Generations and a Trio of Trialities" | `2409.17948`; DOI `10.1016/j.physletb.2025.139473` | ANCHOR | New triality/generation/Higgs representation source. | Very important but needs fresh convention audit. |
| Furey, "An Algebraic Roadmap of Particle Theories" | arXiv `2312.12377` and related; DOI family includes `10.1002/andp.202400322`, `10.1002/andp.202400323`, `10.1002/andp.202400324` | CANDIDATE | Recent high-level particle-theory network and checkpoints. | Verify exact part/DOI before SourceTrace use. |
| Todorov, exceptional Jordan algebra / Standard Model sources | e.g. DOI `10.1142/S0217751X1850118X` | CANDIDATE | Alternative exceptional Jordan algebra framing. | Convention-heavy; lower priority than Furey/Hughes and Springer/Veldkamp. |
| Gresnigt, minimal ideals / complete gauge symmetries | DOI `10.1140/epjc/s10052-020-8141-1` | CANDIDATE | Nearby division-algebra Standard Model construction. | Compare assumptions before citing. |

## Teleparallel, causal-order, causal-set, and emergent-gravity lanes

| Source | Identifier | Status | Helps with | Caveat |
|---|---|---|---|---|
| Kibble, "Lorentz Invariance and the Gravitational Field" | DOI `10.1063/1.1703702` | ANCHOR | Vierbein/local connection from local Lorentz/Poincare invariance. | Historical notation. |
| Sciama, "The Physical Structure of General Relativity" | DOI `10.1103/RevModPhys.36.463` | ANCHOR | Spin/torsion coupling orientation. | Broad conceptual source. |
| Hehl, von der Heyde, Kerlick, Nester, "General Relativity with Spin and Torsion" | DOI `10.1103/RevModPhys.48.393` | ANCHOR | Einstein-Cartan/Sciama-Kibble torsion-spin baseline. | Review source; still convention-heavy. |
| Hayashi and Shirafuji, "New General Relativity" | DOI `10.1103/PhysRevD.19.3524` | ANCHOR | Teleparallel/Weitzenbock action-level formulation. | Not identical to GR for all parameter choices. |
| Aldrovandi and Pereira, *Teleparallel Gravity: An Introduction* | DOI `10.1007/978-94-007-5143-9` | ANCHOR | Modern teleparallel gauge/tetrad reference. | Book-level synthesis. |
| Maluf, "The teleparallel equivalent of general relativity" | `1303.3897`; DOI `10.1002/andp.201200272` | ANCHOR | TEGR review, energy-momentum, tetrads/torsion. | Review source. |
| Baez and Wise, "Teleparallel Gravity as a Higher Gauge Theory" | `1204.4339` | LOCAL/ANCHOR | Higher-gauge/coframe/torsion framing. | Program analogy only unless exact definitions match. |
| Kronheimer and Penrose, "On the structure of causal spaces" | DOI `10.1017/S030500410004144X` | ANCHOR | Abstract causal-space/poset grounding. | Extra data needed for metric/spinor structures. |
| Hawking, King, McCarthy, "A new topology for curved space-time..." | DOI `10.1063/1.522874` | ANCHOR | Causal, differential, conformal structure bridge. | Smooth/causality assumptions required. |
| Malament, "The class of continuous timelike curves determines the topology of spacetime" | DOI `10.1063/1.523436` | ANCHOR | Causal-order/topology reconstruction. | Supplies conformal/topological half, not scale/decorations. |
| Bombelli, Lee, Meyer, Sorkin, "Space-time as a causal set" | DOI `10.1103/PhysRevLett.59.521` | ANCHOR | Locally finite causal-set proposal. | Quantum dynamics open. |
| Rideout and Sorkin, "A Classical Sequential Growth Dynamics for Causal Sets" | DOI `10.1103/PhysRevD.61.024002` | CANDIDATE | Causal-set growth dynamics. | Classical stochastic dynamics, not final quantum theory. |
| Benincasa and Dowker, "The Scalar Curvature of a Causal Set" | `1001.2725`; DOI `10.1103/PhysRevLett.104.181301` | ANCHOR | Retarded causal-set d'Alembertian/curvature approximation. | Approximation and nonlocality scale assumptions. |
| Surya, "The causal set approach to quantum gravity" | DOI `10.1007/s41114-019-0023-1` | CANDIDATE | Modern causal-set roadmap. | Review source. |
| Witten, "A New Proof of the Positive Energy Theorem" | DOI `10.1007/BF01208277` | ANCHOR | Spinor positive-energy theorem. | Requires asymptotic flatness/spin hypotheses. |
| Schoen and Yau, "Proof of the positive mass theorem" | DOI `10.1103/PhysRevLett.43.1457` | ANCHOR | Independent geometric positive-mass theorem. | Original dimension/technical restrictions matter. |
| Weinberg and Witten, "Limits on Massless Particles" | DOI `10.1016/0370-2693(80)90212-9` | ANCHOR | Emergent spin-1/spin-2 no-go constraints. | Only under stated Lorentz/current/stress-tensor hypotheses. |
| Jacobson, "Thermodynamics of Spacetime" | `gr-qc/9504004`; DOI `10.1103/PhysRevLett.75.1260` | ANCHOR | Thermodynamic route to Einstein equation. | Not a microscopic emergence proof. |
| Marolf, "Emergent Gravity Requires Kinematic Nonlocality" | `1409.2509`; DOI `10.1103/PhysRevLett.114.031104` | ANCHOR | Local-kinematics no-go audit. | Depends on boundary-Hamiltonian/locality assumptions. |
| Carlip, "Challenges for Emergent Gravity" | `1207.2504` | CANDIDATE | Useful no-go/problem checklist. | Review/essay source. |

## Strong coupling, reflection positivity, center symmetry, and polymers

| Source | Identifier | Status | Helps with | Caveat |
|---|---|---|---|---|
| Wilson, "Confinement of quarks" | DOI `10.1103/PhysRevD.10.2445` | ANCHOR | Wilson action, Wilson loops, strong-coupling area-law intuition. | Early normalization conventions. |
| Balian, Drouffe, Itzykson, "Gauge fields on a lattice. III" | DOI `10.1103/PhysRevD.11.2104` | CANDIDATE | Explicit strong-coupling expansion machinery. | Early plaquette conventions. |
| Kogut and Susskind, "Hamiltonian formulation of Wilson's lattice gauge theories" | DOI `10.1103/PhysRevD.11.395` | CANDIDATE | Hamiltonian/transfer-matrix picture. | Different normalization from Euclidean finite-edge setup. |
| Drell, Weinstein, Yankielowicz, "Strong-coupling field theories. II" | DOI `10.1103/PhysRevD.14.1627` | CANDIDATE | Matter-coupled strong-coupling structure. | Fermion formalism convention-dependent. |
| Osterwalder and Schrader, "Axioms for Euclidean Green's functions" | DOI `10.1007/BF01645738` | ANCHOR | Reflection positivity and reconstruction baseline. | General QFT axioms, not model-specific. |
| Osterwalder and Schrader, "Axioms for Euclidean Green's functions. II" | DOI `10.1007/BF01608978` | ANCHOR | OS refinement. | Abstract. |
| Osterwalder and Seiler, "Gauge field theories on a lattice" | DOI `10.1016/0003-4916(78)90039-8`; local key `SMH5768W` | LOCAL/ANCHOR | Lattice gauge physical positivity and transfer matrix. | Local graph has no full-text chunks. |
| Luscher, "Construction of a selfadjoint, strictly positive transfer matrix..." | DOI `10.1007/BF01614090` | ANCHOR | Strictly positive transfer matrix. | Requires compatible action choices. |
| Seiler, *Gauge Theories as a Problem of Constructive QFT and Statistical Mechanics* | DOI `10.1007/3-540-11559-5`; local key `UARD9T5Q` | LOCAL | Constructive strong-coupling background. | No local full-text chunks. |
| Tomboulis and Yaffe, "Finite Temperature SU(2) Lattice Gauge Theory" | DOI `10.1007/BF01206134`; local key `N7SIEMAC` | LOCAL/ANCHOR | Center twist and partition-ratio lineage. | Finite-temperature SU(2) scope. |
| Borgs and Seiler, "Lattice Yang-Mills theory at nonzero temperature and the confinement problem" | DOI `10.1007/BF01208780` | CANDIDATE | Wilson/Polyakov/'t Hooft order parameter inequalities. | Finite-temperature emphasis. |
| Borgs, "Area law for spatial Wilson loops..." | DOI `10.1016/0550-3213(85)90582-6` | CANDIDATE | Direct area-law result via expansion tools. | Spatial loops at finite temperature. |
| Polyakov, "Thermal properties of gauge fields and quark liberation" | DOI `10.1016/0370-2693(78)90737-2` | CANDIDATE | Polyakov-loop/order-parameter origin. | Semirigorous. |
| 't Hooft, "On the phase transition towards permanent quark confinement" | DOI `10.1016/0550-3213(78)90153-0` | CANDIDATE | Center symmetry/confinement phase framing. | Translate into modern one-form language carefully. |
| Svetitsky and Yaffe, "Critical behavior at finite-temperature confinement transitions" | DOI `10.1016/0550-3213(82)90172-9` | CANDIDATE | Center-symmetry universality map. | Matter/global-form caveats. |
| Gaiotto, Kapustin, Seiberg, Willett, "Generalized Global Symmetries" | `1412.5148`; DOI `10.1007/JHEP02(2015)172`; local key `AXAWAGGB` | LOCAL/ANCHOR | One-form center symmetry. | Structural framing, not a finite proof. |
| Aharony, Seiberg, Tachikawa, "Reading between the lines..." | DOI `10.1007/JHEP08(2013)115` | CANDIDATE | Line operators and gauge-group global form. | Convention-heavy. |
| Kapustin and Seiberg, "Coupling a QFT to a TQFT and duality" | DOI `10.1007/JHEP04(2014)001` | CANDIDATE | Topological sectors and symmetry/duality. | High-level structural source. |
| Kotecky and Preiss, "Cluster expansion for abstract polymer models" | DOI `10.1007/BF01211762` | ANCHOR | Core polymer convergence criterion. | Requires explicit polymer weights and compatibility graph. |
| Fernandez and Procacci, "Cluster expansion for abstract polymer models. New bounds from an old approach" | `math-ph/0605041`; DOI `10.1007/s00220-007-0279-2` | ANCHOR | Improved abstract polymer bounds. | Not lattice-gauge-specific. |
| Bissacot, Fernandez, Procacci, Scoppola, "On the Convergence of Cluster Expansions for Polymer Gases" | DOI `10.1007/s10955-010-9956-1` | CANDIDATE | Comparison of convergence criteria. | Secondary to KP/FP for current Lean target. |
| Brydges, "A short course on cluster expansion" | Les Houches 1986 | CANDIDATE | Practical tutorial for cluster-expansion applications. | Lecture notes. |

## Spinor-helicity, twistors, checkerboard, and mass-data lane

| Source | Identifier | Status | Helps with | Caveat |
|---|---|---|---|---|
| Arkani-Hamed, Huang, Huang, "Scattering Amplitudes For All Masses and Spins" | `1709.04891`; DOI `10.1007/JHEP11(2021)070` | ANCHOR | Massive spinor-helicity and little-group indices. | On-shell amplitude formalism, not finite carrier proof. |
| Penrose and MacCallum, "Twistor theory: An approach..." | Phys. Rep. 6 (1972), 241-315 | CANDIDATE | Classic twistor bridge. | Needs exact DOI/section before citation. |
| Albonico, Geyer, Mason, "From Twistor-Particle Models to Massive Amplitudes" | `2203.08087` | ANCHOR | Massive particle phase space as twistor pairs. | Modern amplitude/twistor context. |
| Penrose-related "The zig-zag road to reality" | `1107.4909` | LOCAL/CANDIDATE | Massive Dirac as helicity/Weyl zig-zag picture. | Interpretive; not a Standard Model mass theorem. |
| Feynman and Hibbs, *Quantum Mechanics and Path Integrals* | McGraw-Hill 1965, problem 2-6 | CANDIDATE | Original checkerboard path-integral source. | Book/problem reference; use carefully. |
| Feynman, "Space-Time Approach to Non-Relativistic Quantum Mechanics" | DOI `10.1103/RevModPhys.20.367` | ANCHOR | Path-integral background. | Nonrelativistic; checkerboard appears elsewhere. |
| Gaveau, Jacobson, Kac, Schulman, "Relativistic Extension..." | DOI `10.1103/PhysRevLett.53.419` | CANDIDATE | Relativistic Brownian/checkerboard link. | Needs exact mapping to null-edge model. |
| Jacobson and Schulman, "Quantum stochastics: the passage..." | J. Phys. A 17 (1984), 375-383 | CANDIDATE | Relativistic to nonrelativistic path integral. | Check DOI before outward cite. |
| "Spin on a 4D Feynman Checkerboard" | `1610.01142`; local key `TN53N8J2` | LOCAL | 4D checkerboard spin toy model. | Toy model/framing source. |
| Koide, "New view of quark and lepton mass hierarchy" | DOI `10.1103/PhysRevD.28.252` | ANCHOR | Original Koide relation context. | Phenomenological; not source of a derived theorem. |
| Particle Data Group, *Review of Particle Physics* | PDG 2026 page says RPP 2026 to be published in Int. J. Mod. Phys. A 41, 2630011 (2026) | ANCHOR | Current lepton/quark empirical values. | Use official PDG values with date and version. |
| NIST CODATA 2022 constants | NIST official CODATA pages; RMP DOI `10.1103/RevModPhys.97.025002` | ANCHOR | Electron/muon mass ratios and constants. | PDG may be preferred for particle listings; CODATA for constants. |

## Broad no-go and Standard Model structure

| Source | Identifier | Status | Helps with | Caveat |
|---|---|---|---|---|
| Coleman and Mandula, "All Possible Symmetries of the S Matrix" | DOI `10.1103/PhysRev.159.1251` | ANCHOR | Spacetime/internal symmetry separation. | Theorem hypotheses must be displayed. |
| Weinberg and Witten, "Limits on Massless Particles" | DOI `10.1016/0370-2693(80)90212-9` | ANCHOR | Emergent gauge/gravity overclaim guardrail. | Hypothesis-limited. |
| Bouchiat, Iliopoulos, Meyer, anomaly-free electroweak source | DOI `10.1016/0370-2693(72)90532-1` from secondary refs | CANDIDATE | Classical anomaly-cancellation provenance. | Verify exact title/metadata before keying. |
| Georgi and Glashow, "Unity of All Elementary-Particle Forces" | DOI `10.1103/PhysRevLett.32.438` | ANCHOR | SU(5) unification and hypercharge embedding baseline. | Minimal SU(5) phenomenology is not viable as-is. |
| Pati and Salam, "Lepton number as the fourth color" | DOI `10.1103/PhysRevD.10.275` | ANCHOR | Pati-Salam gauge structure. | Source conventions must be separated from Furey-Hughes use. |

## Suggested reading packets for collaborators or Aristotle

1. Chirality/no-doubling packet:
   Nielsen-Ninomiya I/II; Ginsparg-Wilson; Neuberger 1997/1998; Luscher 1998;
   Hasenfratz-Laliena-Niedermayer; Luscher 1999/2000; Kikukawa-Nakayama.

2. Krein/physical quotient packet:
   Gupta; Bleuler; Kugo-Ojima; Bognar; Azizov-Iokhvidov; Franco; van den
   Dungen; Barrett; Takesaki.

3. Octonion/Furey packet:
   Baez; Springer-Veldkamp; Distler-Garibaldi; Furey 2015/2018/2019;
   Furey-Hughes 2022 one-generation; Furey-Hughes 2022 breaking;
   Furey-Hughes 2024/2025 triality.

4. Teleparallel/causal packet:
   Kibble; Sciama; Hehl et al.; Hayashi-Shirafuji; Aldrovandi-Pereira;
   Maluf; Baez-Wise; Kronheimer-Penrose; HKM; Malament; Bombelli et al.;
   Benincasa-Dowker.

5. Strong-coupling/reflection-positive packet:
   Wilson; Kogut-Susskind; Osterwalder-Schrader I/II; Luscher transfer
   matrix; Osterwalder-Seiler; Tomboulis-Yaffe; GKSW; Kotecky-Preiss;
   Fernandez-Procacci.

6. Kinematics/checkerboard packet:
   Arkani-Hamed-Huang-Huang; Penrose/MacCallum; Albonico-Geyer-Mason;
   Feynman-Hibbs; Gaveau-Jacobson-Kac-Schulman; `1610.01142`; Koide; PDG.

## Source-map follow-up

- Add keyed candidate rows for every `CANDIDATE` source that passes an exact
  DOI/arXiv/title check.
- Run `Scripts/lit/neo4j_paper_search.py --chunks` after RAM/page-file pressure is
  relieved; do not use this sweep as a substitute for chunk-level support.
- For manuscript-facing claims, attach claim labels (`T`, `T|H`, `M`, `C`) only
  after matching hypotheses, conventions, scalar field, signs, and basis order.
- For Lean docstrings, prefer the smallest direct source: e.g. Ginsparg-Wilson
  for the relation, Luscher for exact lattice chiral symmetry, Neuberger for
  overlap, and Nielsen-Ninomiya only for the no-go assumptions.
