# Null-edge / NullStrand reference map

Status: live provenance aid, not a final bibliography.
Last updated: 2026-07-13.

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
- `PRIMARY-METADATA-VERIFIED`: title, authors, venue, and canonical identifier
  were checked against a publisher, institutional repository, or primary
  preprint record; this does not establish theorem-level support.
- `CONTENT-CHECKED`: the cited source text or abstract was checked for the
  specifically stated claim boundary.
- `SOURCE-MISMATCH`: the named source does not support the role previously
  assigned to it; the unsupported role remains explicit source debt.

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
| `CP84QBM4` | DOI `10.1016/0550-3213(81)90361-8`; companion DOI `10.1016/0550-3213(81)90524-1` | H. B. Nielsen, M. Ninomiya, "Absence of neutrinos on a lattice: (I). Proof by homotopy theory" and "(II). Intuitive topological proof" | Classical doubling no-go comparison only. The source theorem uses a complex-field/charge formulation together with locality, translation invariance, Hermiticity, and exact local quantized charge assumptions; it is not a no-go for every finite null-edge walk and does not replace the project's architecture-scoped alias theorem. | KEYED-LOCAL; CONTENT-CHECKED 2026-07-13 against the primary publisher abstract and original-paper metadata |
| `N68MN4ET` | `hep-lat/9802011` | Luscher, "Exact chiral symmetry on the lattice and the Ginsparg-Wilson relation" | Candidate lattice-chirality convention; exact lattice chiral symmetry from the GW relation (chunk-matched, not yet quoted). | KEYED-LOCAL; full-text chunks located 2026-07-08, not yet manuscript-citation-quoted |
| `BVJBTK8J` | `1601.04832` | "Free quantum field theory from quantum cellular automata: derivation of Weyl, Dirac and Maxwell quantum cellular automata" | QCA/free-field comparison for discrete Dirac constructions; background only. | KEYED-LOCAL; Neo4j hit 2026-07-08 |
| `B7IRW5HZ` | `hep-th/9304070` | "Dirac and Weyl equations on a lattice as quantum cellular automata" | Early lattice Dirac/Weyl-as-QCA comparison. | KEYED-LOCAL; Neo4j hit 2026-07-08 |
| `arxiv:2503.05998` | `2503.05998` | "Quantum Electrodynamics from Quantum Cellular Automata, and the Tension Between Symmetry, Locality and Positive Energy" | QCA/positive-energy comparison; adjacent background, not support for null-edge claims. | KEYED-LOCAL; Neo4j hit 2026-07-08 |
| `9H7HA39S` | `hep-lat/9707022`; DOI `10.1016/S0370-2693(97)01368-3` | H. Neuberger, "Exactly massless quarks on the lattice," Phys. Lett. B 417 (1998) 141-144 | Primary overlap-determinant convention beyond the local finite algebra. The abstract states the finite-matrix formula, absence of unwanted doubling, and no fine tuning; it does not prove the project's finite overlap claims. | KEYED-LOCAL; CONTENT-CHECKED 2026-07-13 against the primary arXiv record |
| `doi:10.4310/jdg/1214427880` | DOI `10.4310/jdg/1214427880` | H. P. McKean, Jr., I. M. Singer, "Curvature and the eigenvalues of the Laplacian," J. Differential Geom. 1 (1967) 43-69 | Heat-kernel/index comparison only. It does not imply the project's finite PSA or sector-additivity statements; applying its analytic formula requires a separate compact elliptic geometric setting and convention audit. | PRIMARY-METADATA-VERIFIED 2026-07-13 against the journal/DOI record; CLAIM-SCOPE-DEBT |
| `doi:10.2307/1970715` | DOI `10.2307/1970715` | M. F. Atiyah, I. M. Singer, "The index of elliptic operators. I," Ann. Math. 87 (1968) 484-530 | Continuum comparison for index language only. Applicability to a specific null-edge operator still requires the analytic Fredholm, ellipticity, compactness, and convention hypotheses to be displayed separately. | PRIMARY-METADATA-VERIFIED 2026-07-13 against the Annals record; CLAIM-SCOPE-DEBT |

## Krein / modular / positivity sources

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `TBD-TemporalLorentzianSpectralTriples` | `1210.6575` | "Temporal Lorentzian Spectral Triples" | Krein-adjoint and fundamental-symmetry comparison for carrier `#` wording. | ID-ONLY |
| `Bizi2018-SemiRiemannianNCGThesis` | `1812.00038` | N. Bizi, "Semi-Riemannian NCG, Gauge Theory, and the SM" PhD thesis (2018) | Indefinite spectral triple over Z2-graded Krein space; grading involution adjoint sign flip Gamma^ddag = (-1)^q Gamma — NCG precedent for the S6 closure grading b being Krein-ddag-odd. Cited in manuscript S6 refs. | VERIFIED (abstract + full-text chunks 75/79/87/88; author confirmed via arXiv) |
| `vandenDungen2016-KreinFermionicAction` | `1505.01939` | K. van den Dungen, "Krein spectral triples and the fermionic action", Math. Phys. Anal. Geom. 19 (2016) 4 | Krein-space spectral triples; fundamental-symmetry decomposition K = K+ (+) K-; indefinite-inner-product setting for the S6 balanced-closure form. Cited in manuscript S6 refs ([import] setting; anticonjugation-forces-balance is [orig]). | VERIFIED (abstract + full-text chunk 4; author/doi confirmed via arXiv) |
| `TBD-FinitePseudoRiemannianST` | `arXiv:1804.09482` | "Finite Pseudo-Riemannian Spectral Triples and The Standard Model" | The closest prior art for the finite Krein carrier: FINITE pseudo-Riemannian (indefinite/Krein) spectral triples + the SM, incl. "the Krein structure for finite spectral triples". Supports the honest [import] status of the FINITE framework (the machine-verification is the [orig] contribution, not the framework). | VERIFIED 2026-07-09 (graph chunks 4/5, finite Krein spectral-triple + SM content) |
| `Gupta1950-LongitudinalPhotons` | doi:10.1088/0370-1298/63/7/301 | S. N. Gupta, "Theory of longitudinal photons in quantum electrodynamics", Proc. Phys. Soc. A63 (1950) 681 | Indefinite-metric QED + modified supplementary condition — classic precedent for the S6 physical-subspace/quotient analogy. Paired with Bleuler 1950. | VERIFIED (abstract + doi via inspireHEP lit/3551; abstract explicitly = indefinite metric + supplementary condition) |
| `Bleuler1950-LongScalarPhotons` | Helv. Phys. Acta 23 (1950) 567 | K. Bleuler, "Eine neue Methode zur Behandlung der longitudinalen und skalaren Photonen" | Companion to Gupta 1950; indefinite-metric physical-state selection. | VERIFIED-CLASSIC (standard record; German original, no arXiv; universally paired with Gupta) |
| `KugoOjima1979-LocalCovariant` | doi:10.1143/PTPS.66.1 | T. Kugo, I. Ojima, "Local Covariant Operator Formalism of Nonabelian Gauge Theories and Quark Confinement Problem", Prog. Theor. Phys. Suppl. 66 (1979) 1 | BRS-charge quartet / physical-subspace criterion; develops "general theory of indefinite metric quantum fields" — the nonabelian Gauss-sector precedent for S6. Finite witness kernel-checked; full carrier/Gauss wiring still OPEN. | VERIFIED (abstract + doi via inspireHEP lit/8189, 1223 cites) |
| `AzizovIokhvidov1989-IndefiniteMetric` | Wiley (1989); survey doi:10.1007/bf01375563 (1981) | T. Ya. Azizov, I. S. Iokhvidov, "Linear Operators in Spaces with an Indefinite Metric" | Standard Krein-space operator-theory monograph: `J`-self-adjoint / `J`-unitary operators, fundamental symmetry. Functional-analysis backing for the finite positive-sector framing and the `J`-self-adjoint-generator ⇒ `J`-unitary-flow lemma (S9a / kreinflow target). Companion: J. Bognár, "Indefinite Inner Product Spaces", Springer (1974). | VERIFIED (authors/doi via crossref; canonical monograph) |
| `TBD-ConnesNCG` | TBD | Connes noncommutative geometry / real structures | Convention source for `J_C` / KO terminology. | NEEDS-VERIFY |
| `TBD-TomitaTakesaki` | TBD | Tomita-Takesaki modular theory | Convention source for `J_mod`; state dependence must be explicit. | NEEDS-VERIFY |
| `TBD-ShaleStinespring` | boson case DOI `10.1090/S0002-9947-1962-0137504-6`; fermion case J. Math. Mech. 14 (1965) 315 (DOI to add) | D. Shale, "Linear symmetries of free boson fields," Trans. Amer. Math. Soc. 103 (1962) 149-167 (boson/symplectic); D. Shale, W. F. Stinespring, "Spinor representations of infinite orthogonal groups," J. Math. Mech. 14 (1965) 315-322 (fermion/orthogonal) | Continuum gate / obstruction. The implementability criterion: a Bogoliubov transformation is unitarily implementable on the boson (resp. fermion) Fock space iff its off-diagonal block is Hilbert-Schmidt; boson case = symplectic (Shale 1962), fermion case = orthogonal (the eponymous Shale-Stinespring 1965). Used as a continuum non-implementability obstruction; the finite null-edge lane does not instantiate the Hilbert-Schmidt hypothesis, so this is a comparison/boundary source, not theorem support. | PARTIAL 2026-07-13: boson-case Shale 1962 DOI VERIFIED via Crossref; fermion-case Shale-Stinespring 1965 named from canonical bibliography, J. Math. Mech. DOI/full-text NOT yet checked - keep partial until the 1965 identifier is confirmed |
| `K68ST6N4` | `1412.7740` | V. F. R. Jones, "Some unitary representations of Thompson's groups F and T" | Constructs unitary representations and interprets Thompson-group elements as local scale transformations in a naive AQFT attempt. It is not a covariance-obstruction theorem. | KEYED-LOCAL; SOURCE-MISMATCH 2026-07-13: no obstruction result verified, so that advertised role remains source debt |

## Gravity / causal-order / teleparallel sources

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `TBD-TeleparallelHigherGauge` | `1204.4339` | "Teleparallel Gravity as a Higher Gauge Theory" | Teleparallel torsion/coframe framing for E-slot interpretation. | ID-ONLY |
| `doi:10.1007/BF01208277` | DOI `10.1007/BF01208277` | E. Witten, "A new proof of the positive energy theorem," Commun. Math. Phys. 80 (1981) 381-402 | Continuum positive-energy comparison for E/gravity-slot aspirations. No finite-carrier positivity claim follows without the theorem's asymptotic, constraint, regularity, and spin hypotheses. | PRIMARY-METADATA-VERIFIED 2026-07-13; CLAIM-SCOPE-DEBT |
| `doi:10.1016/0370-2693(80)90212-9` | DOI `10.1016/0370-2693(80)90212-9` | S. Weinberg, E. Witten, "Limits on massless particles," Phys. Lett. B 96 (1980) 59-62 | Gravity/redundancy obligation. The source's two no-go statements require, respectively, a Lorentz-covariant conserved current or Lorentz-covariant energy-momentum tensor; these hypotheses are load-bearing. | CONTENT-CHECKED 2026-07-13 against the primary abstract and canonical DOI record |
| `PCHEN9K7` | `1409.2509`; DOI `10.1103/PhysRevLett.114.031104` | D. Marolf, "Emergent Gravity requires (kinematic) non-locality" | Refines the emergent-gravity obstruction: universal coupling makes the on-shell Hamiltonian a boundary term, so a low-energy parent with local kinematics freezes bulk dynamics unless kinematics or time evolution changes. | KEYED-LOCAL; CONTENT-CHECKED 2026-07-13 against the primary arXiv text; not a theorem about this project's carrier |
| `TBD-Jacobson` | `gr-qc/9504004` | Jacobson, "Thermodynamics of spacetime: the Einstein equation of state" | Equation-of-state framing for the finite `JacobsonClausius` avatar (§7); Lambda enters as the integration constant. Manuscript §7 names it as the [import] equation-of-state route (which the audit notes is one of several known-equivalent presentations). | VERIFIED 2026-07-09 (graph chunk 0: exact title + T. Jacobson + the "entropy proportional to horizon area + dQ=TdS" derivation; also the non-equilibrium extension gr-qc/0602001) |
| `TBD-ChamseddineConnesMarcolli` | `hep-th/0610241` | Chamseddine-Connes-Marcolli, "Gravity and the standard model with neutrino mixing" | Spectral-action gravity+SM; the `SpectralActionAvatar`/`EinsteinHilbertTerm` order-2/4 split is the finite avatar. | ID-ONLY |
| `TBD-QuiverSpectralAction` | `2401.03705` | "Bratteli networks and the spectral action on quivers" | Discrete/finite spectral-action precedent for our finite Krein carrier. | ID-ONLY |
| `TBD-TwistedSpectralTriples` | `1710.04965` | "Lorentz signature and twisted spectral triples" | Lorentzian/Krein spectral-triple + spectral-action anchor (§7 unification). | ID-ONLY |
| `doi:10.1063/1.523436` | DOI `10.1063/1.523436` | D. B. Malament, "The class of continuous timelike curves determines the topology of spacetime," J. Math. Phys. 18 (1977) 1399-1404 | Primary anchor for the order side of the NullStrand order-vs-scale split. The source proves the title assertion and states the causal-structure corollary for past- and future-distinguishing spacetimes; it does not recover metric scale, a finite graph tetrad, or dynamics. | CONTENT-CHECKED 2026-07-13 against the AIP abstract preserved by OSTI |
| `doi:10.1063/1.522874` | DOI `10.1063/1.522874` | S. W. Hawking, A. R. King, P. J. McCarthy, "A new topology for curved space-time which incorporates the causal, differential, and conformal structures," J. Math. Phys. 17 (1976) 174-181 | Primary path-topology anchor for the order side of the split, explicitly scoped to strongly causal spacetimes. The source does not supply volume scale, a canonical finite decoration, or a gravitational field equation. | CONTENT-CHECKED 2026-07-13 against the AIP abstract preserved by OSTI |
| `doi:10.1103/PhysRevLett.59.521` | DOI `10.1103/PhysRevLett.59.521` | L. Bombelli, J. Lee, D. Meyer, R. D. Sorkin, "Space-time as a causal set" | Foundational order-plus-number proposal: causal order represents conformal information and local finiteness supplies number/volume. It is a program postulate, not a proof that a finite order has a unique manifold approximation or selects GR dynamics. | PRIMARY METADATA AND CLAIM ROLE CHECKED 2026-07-17 |
| `TBD-CausalTopology` | `gr-qc/0604124` | S. Major, D. Rideout, S. Surya, "On Recovering Continuum Topology from a Causal Set" | Thickened-antichain nerve construction recovering continuum homology for causal sets faithfully embedded in a suitable globally hyperbolic spacetime at sufficient density. This is manifold-conditioned reconstruction, not intrinsic manifold selection. | PRIMARY ARXIV ABSTRACT AND FULL-TEXT CHUNKS CHECKED 2026-07-17 |
| `TBD-CausalSequentialGrowth` | `gr-qc/9904062` | D. P. Rideout, R. D. Sorkin, "A Classical Sequential Growth Dynamics for Causal Sets" | Primary example separating causal-set dynamics from kinematical sprinkling. It derives a family of classical stochastic growth laws from internal temporality, discrete covariance, Bell causality, and normalization; it does not establish a four-dimensional GR phase. | PRIMARY ARXIV ABSTRACT AND FULL-TEXT CHUNKS CHECKED 2026-07-17 |
| `JUVWME9X` | `1001.2725`; DOI `10.1103/PhysRevLett.104.181301` | D. M. T. Benincasa, F. Dowker, "The Scalar Curvature of a Causal Set" | Primary source for retarded causal-set operators approximating the continuum d'Alembertian and curvature term, and for the resulting action construction. It does not by itself anchor the broader order-plus-number reconstruction slogan. | KEYED-LOCAL; CONTENT-CHECKED 2026-07-13; separate order/number source remains explicit debt |
| `TBD-BelenchiaBenincasaDowker` | `1510.04656` | A. Belenchia, D. M. T. Benincasa, F. Dowker, "The continuum limit of a 4-dimensional causal set scalar d'Alembertian" | Proves convergence of the mean operator to `Box` in 4D Minkowski space and to `Box - R/2` in curved spacetime under displayed field and geometry conditions. Mean convergence is not individual-causal-set concentration or dynamical manifold selection. | PRIMARY ARXIV ABSTRACT CHECKED 2026-07-17; claim boundary cross-checked against local full-text search |
| `WCCDDR3H` | `2007.13192`; DOI `10.1088/1361-6382/abc274` | L. Machet, J. Wang, "On the continuum limit of Benincasa-Dowker-Glaser causal set action" | Continuum-limit evidence on causally convex diamonds: Einstein-Hilbert bulk plus a codimension-two joint contribution. It supports treating the boundary term as part of the primary action gate, not as an afterthought. | KEYED-LOCAL; PRIMARY ARXIV ABSTRACT AND FULL-TEXT CHUNKS CHECKED 2026-07-17 |
| `TBD-LoomisCarlip` | `1709.00064` | S. P. Loomis, S. Carlip, "Suppression of non-manifold-like sets in the causal set path integral" | Shows a phase suppressing one large class of nonmanifoldlike causal sets for a Lorentzian path integral with the causal-set Einstein-Hilbert action. It is evidence for a dynamical-selection route, not a general manifoldlike-phase theorem. | PRIMARY ARXIV ABSTRACT CHECKED 2026-07-17 |
| `STUCFHB7` | `1903.11544`; DOI `10.1007/s41114-019-0023-1` | S. Surya, "The causal set approach to quantum gravity" | Primary modern review for the faithful-embedding/Hauptvermutung boundary, Lorentzian nonlocality, reconstruction observables, causal-set actions, and the unresolved dynamics of a manifoldlike phase. | KEYED-LOCAL; ABSTRACT AND RELEVANT FULL-TEXT CHUNKS CHECKED 2026-07-17 |

## Causal-operator locality sources (2026-07-16)

These sources delimit the retarded-shell locality result in the GR program.
They establish the prior Lorentzian nonlocality and causal-layer setting; they
do not contain the project's exact arbitrary-cardinality finite family, its
two-sided abundance condition, or the frozen A3c outer-volume control.

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `doi:10.1007/JHEP06(2014)024` | `1403.1622`; DOI `10.1007/JHEP06(2014)024` | S. Aslanbeigi, M. Saravani, R. D. Sorkin, "Generalized causal set d'Alembertians" | Primary nearest work for open-interval-count layers: a past `n`th neighbor has exactly `n` events in the open interval to the target. The paper frames the resulting operators as Lorentz-invariant, retarded, and nonlocal, with a supplied nonlocality scale. It does not prove the project's finite abundance-conditioned shell theorem. | CONTENT-CHECKED 2026-07-16 against the primary arXiv full text and the Springer DOI record; no local Zotero key recovered while the live service was unavailable |
| `I72KXVQA` | `2506.18745`; DOI `10.1103/np89-qzjp` | M. Boguna, D. Krioukov, "Local d'Alembertian for causal sets," Phys. Rev. D 113, 024046 (2026) | Primary challenger to globally nonlocal layer operators. It constructs intrinsic local neighborhoods from causal-set timelike and spacelike distance estimators and proves a Minkowski continuum limit under its displayed scaling assumptions. It does not derive dimension or absolute scale from bare order, and its signature is opposite the project's `(+---)` convention. | REPOSITORY KEY RECOVERED; CONTENT-CHECKED 2026-07-16 against arXiv v1 full text, the arXiv journal record, and canonical Crossref metadata; live Zotero lookup unavailable |
| `doi:10.1103/PhysRevD.110.024008` | `2401.17376`; DOI `10.1103/PhysRevD.110.024008` | M. Boguna, D. Krioukov, "Measuring spatial distances in causal sets via causal overlaps" | Distance-reconstruction input used by the local-operator challenger. Its overlap-to-distance conversion still uses dimension-dependent and proper-time/scale inputs, so it is not an independent solution of the bare-order dimension-and-scale gate. | CONTENT-CHECKED in `Sources/Null_Edge_Causal_Operator_Locality_Variance_Audit_2026-07-15.md`; canonical DOI metadata rechecked 2026-07-16; no local Zotero key recovered |

## Cosmological constant sources (2026-07-09, for §10a + the Lambda doc)

Manuscript §10a and `Null_Edge_Cosmological_Constant_2026-07-09.md` cite these. All
`ID-ONLY`/`NEEDS-VERIFY`: the manuscript's own claims are graded **M** (the finite
scaling arithmetic) with the mechanism/conjugacy explicitly `[import]`; verify these
before any outward-facing quotation of their internal results.

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `TBD-EverpresentLambda` | `astro-ph/0209274` (PRD 69 (2004) 103523) | Ahmed-Dodelson-Greene-Sorkin, "Everpresent Lambda" | THE `Lambda ~ 1/sqrt(V)` prediction; §10a names it as the imported mechanism our finite scaling (`LambdaEdgeCount`) routes through the native edge count. | ID-ONLY for the original; CONTENT-CONFIRMED 2026-07-09 via the verified citing/extending chain (Aspects I `2304.03819` + II `2307.13743`, Sorkin `0710.1675`) which reproduce the fluctuating `1/sqrt(V)` mechanism |
| `TBD-SorkinCC2007` | `arXiv:0710.1675` | Sorkin, "Is the cosmological constant a nonlocal quantum residue of discreteness of the causal set type?" | Everpresent-Lambda origin/framing (the fluctuating-Lambda-from-causet-count argument). | VERIFIED 2026-07-09 (graph chunk 8, exact title + everpresent-Lambda content) |
| `TBD-AspectsEverpresentLambda` | `arXiv:2304.03819` | Surya-Nomaan-X et al., "Aspects of Everpresent Lambda (I): A Fluctuating Cosmological Constant from Spacetime Discreteness" | THE on-point recent [import] for s10a: derives everpresent-Lambda from causal sets + UNIMODULAR gravity (global volume-constraint path integral) - grounds both the everpresent mechanism AND the three-Lambda sequestering (LambdaThreeSplit). | VERIFIED 2026-07-09 (graph chunks 3/18/20, unimodular volume-constraint derivation) |
| `TBD-AspectsEverpresentLambdaII` | `arXiv:2307.13743` | Das-Nasiri-Yazdi (Imperial), "Aspects of Everpresent Lambda (II): Cosmological Tests of Current Models" | The OBSERVATIONAL companion; s10a posture cites it AND its VERDICT: the everpresent model in its present form fits SN Ia better than LambdaCDM only for ~0.017% of realizations (16/90000) and STRUGGLES with CMB (non-vanishing ISW). Live but currently DISFAVORED - not a success. | VERIFIED 2026-07-09 (graph chunks 2/12: SN-fit rarity + CMB/ISW struggle) |
| `TBD-JacobsonEntanglementEq` | `1505.04753` | Jacobson, "Entanglement equilibrium and the Einstein equation" | Modern entanglement version of the equation-of-state route. | ID-ONLY |
| `TBD-CausalDiamondsAdS` | `1812.01596` | "Gravitational thermodynamics of causal diamonds in (A)dS" | Causal-diamond thermodynamics (our finite slab/diamond avatar). | ID-ONLY |
| `TBD-DESIDR2` | `2503.14738` | DESI DR2 BAO cosmological measurements | Observational posture: ~3.1sigma hint of evolving dark energy (friendly, NOT a confirmation of this framework). | ID-ONLY; do not overstate |
| `TBD-Planck2018` | `1807.06209` | Planck 2018 results VI: cosmological parameters | Rigid-LambdaCDM baseline for the observational posture. | ID-ONLY |
| `TBD-Hyperuniformity` | TBD | Torquato-Stillinger hyperuniformity; Martin-Yalcin, Stillinger-Lovett (Coulomb sum rules) | The hyperuniform branch of the count-statistics fork (`LambdaCountDichotomy`): constraint-induced sub-extensive number fluctuations. | NEEDS-VERIFY |
| `TBD-QFTonCausets` | `arXiv:1010.5514` | Sorkin (school), "Quantum Fields on Causal Sets" | Explains why homogeneous Poisson sprinkling is used to avoid a preferred frame in distribution. It does not establish uniqueness among all Lorentz-invariant point-process laws. | CONTENT-CHECKED 2026-07-12 against graph chunk 22; do not quote a uniqueness theorem |
| `TBD-SuryaLRR` | `arXiv:1903.11544` | Surya, "The causal set approach to quantum gravity" (Living Reviews) | Any regular discretization breaks rotational/translational symmetry ("not regular in all frames", ch.11) - corroborates the Poisson=Lorentz-invariance link for the fork. | ID-ONLY (graph-verified title); verify before quoting |
| `HG5ZI36W` | `arXiv:gr-qc/0605006`; DOI `10.1142/S0217732309031958` | Bombelli-Henson-Sorkin, "Discreteness without symmetry breaking: A Theorem" | Proves that no measurable Lorentz-equivariant map sends a Poisson sprinkling of Minkowski space to a spacetime direction, even locally. Corollaries exclude an intrinsic finite frame, finite direction set, or finite-valency graph. It does NOT classify all Lorentz-invariant point-process laws or prove that every hyperuniform law breaks Lorentz invariance. | FULL-TEXT VERIFIED 2026-07-12 (Neo4j chunks 3, 6, 8; source audit in `AutonomousLab/work/NE-LORENTZ/LITERATURE_AUDIT_POISSON_LORENTZ_2026-07-12.md`); bare local key and DOI reconciled 2026-07-16 |
| `TBD-DowkerSorkinZeroOne` | `arXiv:1909.06070` | Dowker-Sorkin, "Symmetry-breaking and zero-one laws" | Extends the no-symmetry-breaking analysis: a Poisson sprinkling cannot select a distinguished spatial/temporal orientation, spacetime lattice, or lattice of timelike directions; proves the underlying zero-one law from first principles. The authors call general preservation conjectural and note that no non-Poisson Poincare-invariant sprinkling example was known, rather than asserting uniqueness. | FULL-TEXT VERIFIED 2026-07-12 (Zotero/Neo4j key `342HA4DS`, 17 chunks) |
| `TBD-QGPhenomLorentz` | `arXiv:gr-qc/0311055` | Henson, "Quantum Gravity Phenomenology, Lorentz Invariance and Discreteness" | Gives the physical intuition that regular fixed discretizations expose preferred-frame artifacts under boosts and explains the distributional Lorentz covariance of causal-set sprinklings. It does not prove uniqueness of the Poisson law. | CONTENT-CHECKED 2026-07-12 against graph chunks; do not use as a classification theorem |
| `TBD-Weinberg1989` | RMP 61 (1989) 1 | Weinberg, "The cosmological constant problem" | The ~120-orders discrepancy IS matter-loop feedback into Lambda; s10a cites it as the [import] reason the order-0 invariance ASSUMES the feedback away. | CONTENT-VERIFIED 2026-07-09 via Burgess review `arXiv:1309.4133` (in-graph, matter-loop vacuum-energy renormalization); Weinberg RMP ID still to add |
| `R4P8ESMS` | `1309.6562`; DOI `10.1103/PhysRevLett.112.091304` | N. Kaloper, A. Padilla, "Sequestering the Standard Model Vacuum Energy" | Sequestering comparison for the three-Lambda split. The primary abstract claims cancellation of protected-sector vacuum energy, including loop and phase-transition contributions, in its global finite-spacetime framework. This is not derived by the finite null-edge model. | KEYED-LOCAL; CONTENT-CHECKED 2026-07-13; Henneaux-Teitelboim companion remains source debt |
| `TBD-ChamseddineConnes-orig` | PRL 77 (1996) 4868; CMP 186 (1997) 731 | Chamseddine-Connes, "The spectral action principle" | The ORIGINAL heat-kernel/Seeley-deWitt theorem making `a2 ~ integral R` - the [import] CONTENT the finite s7 avatar labels but does NOT reproduce (no manifold/short-time limit in finite dim). | CONTENT-VERIFIED 2026-07-09: the heat-expansion mechanism (Gilkey's theorem on the Dirac square) is in-graph via CCM `hep-th/0610241` ch.81 + `2401.03705`; original PRL/CMP IDs still to be added |

## Octonion / Furey / Standard Model bridge sources

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `EQUGNJWS` | `1603.04078`; DOI `10.1016/j.physletb.2015.01.023` | C. Furey, "Charge Quantization from a Number Operator," Phys. Lett. B 742 (2015) 195-199 | Charge-as-number-operator convention for the Furey internal spectrum. The apparent year/identifier mismatch is benign: the journal article appeared in 2015 and the arXiv record was posted in 2016. Project basis products still require `ConventionBridge`. | KEYED-LOCAL; CONTENT-CHECKED and ID-RECONCILED 2026-07-13 |
| `Furey2018a` | `1806.00612` | Furey ladder-operator / SM symmetry source | Ladder and charge-table comparison; use through project convention bridge, not verbatim signs. | KEYED in `Paper_References.md` |
| `TBD-FureyHughes2022` | `2210.10126` | Furey-Hughes division-algebraic symmetry-breaking paper | O -> H -> C and symmetry-breaking cascade mentioned in Furey/Baez survey. | ID-ONLY |
| `FureyHughes2024` | `2409.17948` | "Three Generations and a Trio of Trialities" | Triality/family-symmetry comparison. | KEYED in `Paper_References.md` |
| `Baez2002` | `math/0105155` | Baez, "The Octonions" | Octonion background; not verbatim convention source for this repo's XOR basis. | KEYED in `Paper_References.md` |
| `BaezHuerta2010` | `0904.1556` | Baez-Huerta GUT square | SM group and Z6 comparison. | KEYED in `Paper_References.md` |
| `CEQ6URHZ` | `0905.2658`; DOI `10.1007/s00220-010-1006-y` | J. Distler, S. Garibaldi, "There is no 'Theory of Everything' inside E8," Commun. Math. Phys. 298 (2010) 419-436 | No-go comparison for embeddings of gravity and Standard Model gauge data into real or complex E8 under the paper's explicit particle-content, chirality, and representation hypotheses. It is not a no-go for every E8-inspired model. | KEYED-LOCAL; CONTENT-CHECKED 2026-07-13 against the primary text, including Theorem 10.1 scope |
| `doi:10.1007/978-3-662-12622-6` | DOI `10.1007/978-3-662-12622-6` | T. A. Springer, F. D. Veldkamp, *Octonions, Jordan Algebras and Exceptional Groups* (2000), chapter "Triality," pp. 37-67 | Triality and exceptional-algebra comparison. This book is not a verbatim convention source for the repository's XOR basis. | PRIMARY-METADATA-VERIFIED 2026-07-13 against the publisher record; theorem-level convention bridge remains required |

## Massive kinematics / checkerboard / mass-values sources

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `TBD-ArkaniHamedHuangHuang2017` | `1709.04891` | Arkani-Hamed, Huang, Huang massive spinor-helicity source | Massive little-group / null-split comparison in P1.  This is the template: named and arXiv-keyed, but still needs a local bibliography key. | ID-ONLY |
| `TN53N8J2` | `1610.01142` | "Spin on a 4D Feynman Checkerboard" | Checkerboard/null-zigzag toy comparison. | KEYED-LOCAL |
| `TBD-PenroseZigZag` | `1107.4909` (DOI `10.1088/1751-8113/44/34/345304`) | Colin-Wiseman, "The zig-zag road to reality", J. Phys. A 44 (2011) 345304 | Backs the CENTRAL thesis: a massive Dirac electron of given helicity = superposition of positive- and negative-energy Weyl particles (the Penrose zig-zag), moving luminally; "all fermions are fundamentally massless" (mass from Higgs). The pos/neg-energy Weyl split is exactly the `MassShellProjectors` energy projectors. HONEST CAVEAT (from the abstract): the all-times-luminal picture holds for a SINGLE Dirac electron but the authors conclude it does NOT carry to the many-body QFT case - cite for the zig-zag / mass-from-massless framing, not for a many-body luminal theory. | VERIFIED (arXiv abstract + DOI, 2026-07-09) |
| `TBD-FeynmanHibbs1965` | book, Problem 2-6 | Feynman-Hibbs, *Quantum Mechanics and Path Integrals* | Original 1+1 checkerboard problem and turn-weighted null-history formulation. | BIBLIOGRAPHY-VERIFIED 2026-07-09; exact problem cross-checked against later literature |
| `TBD-JacobsonSchulman1984` | DOI `10.1088/0305-4470/17/2/023` | Jacobson-Schulman, "Quantum stochastics: the passage from a relativistic to a non-relativistic path integral", J. Phys. A 17 (1984) 375-383 | Corner-count/path-integral and continuum comparison used as `[import]`; finite exact path-sum target remains separately kernel-checked. | DOI/title/authors/year VERIFIED via Crossref 2026-07-09 |
| `TBD-Earle2011Checkerboard` | `1012.1564` | Keith A. Earle, "Notes on The Feynman Checkerboard Problem" | Explicit corner-class formulas and propagator cross-check; also warns that older Kauffman-Noyes formulas fail simple cases, so landed oracle-validated conventions remain authoritative. | VERIFIED arXiv metadata + Neo4j full-text chunks 1, 4-7 on 2026-07-09 |
| `TBD-Koide1982` | DOI `10.1103/PhysRevD.28.252`; erratum DOI `10.1103/PhysRevD.29.1544` | Y. Koide, "New view of quark and lepton mass hierarchy," Phys. Rev. D 28 (1983) 252 (erratum Phys. Rev. D 29 (1984) 1544) | Q07 / T-solder mass-values comparison. The charged-lepton relation `Q = (m_e + m_mu + m_tau)/(sqrt(m_e) + sqrt(m_mu) + sqrt(m_tau))^2 = 2/3`. Per Koide's own later distinction (arXiv `1701.01921`) this is the empirical "formula B" that holds for POLE masses (recognized as excellent only after the 1992 tau-mass measurement) and "may be an accidental coincidence"; it is a phenomenological relation, NOT a derived theorem, and a running/QED correction (the Sumino route, `TBD-Sumino2009`) is needed to explain why pole masses fit. Comparison target only, not theorem support. | PRIMARY-METADATA-VERIFIED 2026-07-13 via Crossref (PRD 28 252 + erratum PRD 29 1544); claim scope recorded (empirical pole-mass relation, possibly coincidental); earliest 1982 Lett. Nuovo Cim. 34, 201 announcement not separately DOI-checked |
| `TBD-WilczekMassWithoutMass` | TBD | Wilczek "Mass without mass" essay | Framing only, not theorem support. | NEEDS-VERIFY |
| `PDG2024` | S. Navas et al. (Particle Data Group), Phys. Rev. D 110, 030001 (2024) | *Review of Particle Physics* 2024 particle listings and summary tables | Canonical experimental-data source for lepton masses used in Koide or comparison calculations. Numerical values and uncertainty propagation must be extracted and version-pinned in the calculation record, not copied from memory. | PRIMARY-METADATA-VERIFIED 2026-07-13 against the official PDG site; numerical-extraction debt remains |

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
| `TBD-BakirciogluArnaultArrighi2025` | `2505.07900` | Bakircioglu-Arnault-Arrighi, "Fermion Doubling in Quantum Cellular Automata" | QCA-era fermion-doubling analysis and flavor-staggering-only repair. In `3+1`, Eqs. (4.10)-(4.12) organize the eight symmetry sheets as a `Z2^3` three-qubit flavor register, with flavored spatial shifts `S_j tensor X_j`, time translation `T tensor X tensor X tensor X`, and eight translated direct-space sublattices. Secs. 5.2 and 6 give the eight-cover interpretation and the chiral-symmetry/no-go boundary. | CONTENT-CHECKED 2026-07-13 against arXiv v3 full text; use as prior architecture, not evidence that the eight flavors are Standard Model particle states |
| `TBD-MlodinowBrun2018` | `1802.03910` | Mlodinow-Brun, "Discrete spacetime, quantum walks, and relativistic wave equations", PRA 97 (2018) 042131 | Mass-side QW comparator (§2a): 4D coin forces Dirac gammas; coin-flip operator = mass term; massless when switched off. Rhymes with the Cl(4) carrier + critical line; not budget support. | KEYED-LOCAL; in null-edge collection, chunks quoted 2026-07-08 |
| `TBD-BisioDArianoPerinottiTosini2016` | `1601.04842` | Bisio-D'Ariano-Perinotti-Tosini, "Weyl, Dirac and Maxwell Quantum Cellular Automata" | Prior-art setup for the §9a scattering sim: 1D Dirac QCA barrier scattering (section "Scattering against a potential barrier"). Not budget support. | KEYED-LOCAL; in null-edge collection, chunk quoted 2026-07-08 |
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
| `3VBEK82X` | `1407.2492` | S. Chin and S. Lee, "Momentum bispinor, two-qubit entanglement and twistor space" | Direct prior art for the massive-momentum-bispinor / two-qubit-entanglement correspondence. Requires the manuscript to grade the momentum-density/concurrence identification `[import]`; local novelty is the null-edge Cauchy-Binet formalization and carrier integration. | KEYED-LOCAL; abstract and full-text chunks verified 2026-07-09 |
| `TBD-Englert1996` | DOI `10.1103/PhysRevLett.77.2154` | B.-G. Englert, "Fringe Visibility and Which-Way Information: An Inequality", Phys. Rev. Lett. 77 (1996) 2154 | External complementarity comparison for the exact finite `MassCoherenceDuality` identity; the Lean theorem is a model-specific equality, not a reproof of Englert's operational inequality. | DOI/title/author/year VERIFIED via Crossref 2026-07-09 |
| `TBD-MeltonMichaelsenRuzziconi2026` | `2606.27421` | Melton-Michaelsen-Ruzziconi, "Observing Massive Scattering from Null Infinity" | Massive <-> timelike infinity = the celestial reading of the thesis (F9). | ID-ONLY |
| `TBD-FernandezProcacci2006` | `math-ph/0605041` | Fernandez-Procacci, cluster-expansion bounds via Penrose identity | Target abstraction for the forest-injection bounty (Kotecky-Preiss lineage). | ID-ONLY |
| `TBD-ToobySmith2024-HepLean` | `2405.08863` | Tooby-Smith, "HepLean: Digitalising high energy physics" | Machine-verified high-energy physics already exists; narrows §2a methodology claim. | ID-ONLY; arXiv verified 2026-07-08, no local key/chunk yet |
| `TBD-ElvangHuang2013` | `1308.1697` | Elvang-Huang, "Scattering Amplitudes" | Canonical spinor-helicity `det P` kinematics reference (§3). | ID-ONLY |
| `TBD-Kull2002` | `quant-ph/0212053` | Kull, checkerboard on dense-rational 2D Minkowski | Non-continuous-spacetime checkerboard precedent (§2a). | ID-ONLY |
| `TBD-PhysLean-Weyl` | `2405.08863` | Tooby-Smith, PhysLean (`Physlib/Relativity/.../Weyl/Metric.lean`) | Convention cross-check for §3: `spinorWedge` = PhysLean left-handed Weyl metric `!![0,1;-1,0]` (clean-room match, verified 2026-07-08); see `docs/PHYSLEAN.md`. | KEYED-LOCAL (source clone) |

## Finite exchange topology / graph braid groups

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `TBD-Ghrist1999GraphBraid` | `math/9905023` | Robert Ghrist, "Configuration Spaces and Braid Groups on Graphs in Robotics" | Primary source for configuration spaces and braid groups of particles constrained to finite graphs; supports the finite exchange-history target, not a Bose/Fermi collapse. | ARXIV VERIFIED 2026-07-09 |
| `TBD-FarleySabalka2005` | `math/0410539` | Daniel Farley and Lucas Sabalka, "Discrete Morse Theory and Graph Braid Groups", Algebraic \& Geometric Topology 5 (2005) | Discrete Morse model for computing graph braid groups; theorem-shape reference for a finite configuration-history complex. | ARXIV/JOURNAL VERIFIED 2026-07-09 |

## Anomalous-Floquet 3+1 route

Anchor papers for the anomalous-Floquet route to a strict 3+1 single Weyl (AF0
landed `FloquetMicromotionSchedule`, OD5 `OpenDiamondCausalExhaustion`, AF-ladder
in flight). See `AutonomousLab/work/NE-3PLUS1/CODEX_ANOMALOUS_FLOQUET_3PLUS1_ROUTE_2026-07-13.md`
and `CLAUDE_SKEPTIC_AF3_AF4_INVARIANT_PREANALYSIS_2026-07-13.md`. Clean-room the
theorem shape and invariants from the mathematical definitions; do not copy code.

| Key | Identifier | Source | Role | Status |
|---|---|---|---|---|
| `TBD-HigashikawaNakagawaUeda2019` | `1806.06868` | Higashikawa, Nakagawa, Ueda, "Floquet chiral magnetic effect", Phys. Rev. Lett. 123, 066403 (2019) | Existence proof for the route: a single Weyl fermion (forbidden statically by Nielsen-Ninomiya) realized via a topologically nontrivial Floquet unitary; AZ-class classification of Floquet unitaries. Provenance for AF0-AF6. | INSPIREHEP VERIFIED 2026-07-13 |
| `TBD-BesshoSato2021` | `2006.04204` | Bessho, Sato, "Nielsen-Ninomiya Theorem with Bulk Topology: Duality in Floquet and Non-Hermitian Systems", Phys. Rev. Lett. 127, 196404 (2021) | The Nielsen-Ninomiya extension permitting bulk chiral fermions in dynamical systems via intrinsic bulk topology; theorem-shape for the AF no-go evasion. | INSPIREHEP VERIFIED 2026-07-13 |
| `TBD-RudnerLindnerBergLevin2013` | `1212.3324` | Rudner, Lindner, Berg, Levin, "Anomalous edge states and the bulk-edge correspondence for periodically-driven two dimensional systems", Phys. Rev. X 3, 031005 (2013) | Anomalous Floquet (AFAI) edge modes at 0 and pi persist with zero bulk Chern; the `W3` winding invariant and the boundary anomaly-inflow framing (open-diamond boundary-mode audit). | ARXIV VERIFIED 2026-07-13 |
| `TBD-UmerBomantaraGong2021` | `2009.09189` | Umer, Bomantara, Gong, "Dynamical characterization of Weyl nodes in Floquet Weyl semimetal phases", Phys. Rev. B 103, 094309 (2021) | The correct AF3/AF4 invariant model: a dynamical winding distinguishing 0 vs pi/T Floquet Weyl nodes (both sectors host nodes, momentum-close); guards against the pi_4(U)=0 vacuous 4D-winding trap. | ARXIV VERIFIED 2026-07-13 |
| `TBD-Kikukawa2002` | `hep-lat/0105032` | Kikukawa, "Domain wall fermion and chiral gauge theories on the lattice with exact gauge invariance", Phys. Rev. D65 (2002) 074504 | Domain-wall chiral-gauge construction with exact gauge invariance; the transverse/domain-wall selector method cited for the two-fine-tick null-dilation pivot (an auxiliary direction selecting a chiral boundary sector). | ARXIV VERIFIED 2026-07-13 |
| `TBD-AokiFukayaKan2025` | `2502.03045` | Aoki, Fukaya, Kan, "Lattice Weyl Fermion on a Single Spherical Domain-Wall", arXiv:2502.03045 (LATTICE2024 proceedings) | Weyl fermion as an edge-localized mode on a spherical domain wall, with ADDITIONAL zero modes appearing near monopoles when gauge fields are present - the concrete "opposite chirality reappears elsewhere when topology/gauge demand it" warning cited for the dilation/transverse-selector pivot; matches the doublers-relocate hazard flagged in the HNURealSpace dilation review. | ARXIV VERIFIED 2026-07-13 |

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
