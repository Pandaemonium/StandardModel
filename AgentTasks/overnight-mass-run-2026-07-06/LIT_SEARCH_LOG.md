# Literature added to Neo4j (overnight run, targeted at our challenges)

Real time ~06:00. 7 papers ingested into the null-edge Neo4j graph (collection
`9W59V3K9`) + embedded (semantically searchable via
`Scripts/lit/neo4j_paper_search.py`). NOTE: the `zotero_write` MCP server is NOT
wired in this session, so these were added DIRECT-TO-NEO4J (via
`lit_ingest.fetch_arxiv_meta` + `upsert_node`), with `paper_key = normalized
arxiv_id` and `source = 'arxiv-direct'`. Backfill the canonical Zotero item keys
when `zotero_write` is available (dedup is on `arxiv_id`/`doi`, so re-running the
full ingest will find and can re-key them).

## For the Q6 CRUX `pairSum_le_expBound` (the parked challenge)

The graph previously had ZERO cluster-expansion papers (top hits were unrelated
network-Laplacian papers). The crux's `pairSum_le_expBound` IS the Kotecky-Preiss
labeled-rooted-tree / tree-graph bound; these are the canonical machinery:

- **math-ph/0605041** - Fernandez & Procacci, "Cluster expansion for abstract
  polymer models. New bounds from an old approach" (2007). THE reference: the
  Penrose identity for truncated functions + iterated transformations to bound
  tree-graph expansions. The crux's tree-sum bound is exactly this shape.
- **2001.00652** - "Abstract polymer gas. A simple INDUCTIVE proof of the
  Fernandez-Procacci criterion" (2020). HIGH interest: an inductive proof that
  may SIDESTEP the explicit labeled-tree injection the crux is currently stuck on
  (`CRUX_PARKED_STATUS.md` residual #2). Recommended reading before the next crux
  attempt.
- **cond-mat/0309352** - Scott & Sokal, "The repulsive lattice gas, the
  independent-set polynomial, and the Lovasz local lemma" (2005). The tree bound /
  independent-set-polynomial view; Penrose, Shearer, Dobrushin lineage.
- **0707.0016** - Procacci, "Abstract polymer models with general pair
  interactions" (2007). Generalization.

## For the RP-LINK / transfer-gap / sign-rep character-expansion lane

- **2606.19362** - "Reflection-Positive Construction of a Four-Dimensional SU(N)
  Yang-Mills Theory with Mass Gap and Confinement" (2026). Source-mined on
  2026-07-06; detailed notes:
  `AgentTasks/paper-units/faizal-shabir-2606-19362-mining.md`. This is the
  closest recent blueprint for the project's Track A, but should be cited as a
  recent claim/audit roadmap, NOT as settled resolution of the continuum mass
  gap. Extracted spine: reflection-positive Wilson lattice -> positive transfer
  operator -> strong-coupling character/polymer expansion -> area law + temporal
  clustering -> finite-a transfer gap -> gauge-covariant FRD/locality ->
  reflection-positive multiscale blocking -> interlacing with summable defects
  -> OS limits/reconstruction -> universality by Lipschitz/telescoping ->
  claimed weak-coupling identification. Best immediate imports: Q6/Q7
  tree-graph/KP convergence, finite exponential-clustering-to-transfer-gap,
  abstract summable-defect gap transport, and finite Wilson-loop area-law
  transport. Audit cautions: the completely-monotone slice-projector proof needs
  a precise half-operator statement; gauge fixing/FMR/ghost/horizon-projector
  layers are avoidable in our finite first targets; gauge-covariant FRD and
  weak-coupling entry are the load-bearing continuum audit points.
- **1506.04197** - Jaffe & Janssens, "Characterization of Reflection Positivity:
  Majoranas and Spins" (2015). Necessary+sufficient RP conditions on a Clifford
  (Majorana) algebra with a reflection automorphism - the framework for the
  fermionic single-cut RP (`FermionicSingleCutRP.lean`) landed this run.
- **1802.09037** - "Reflection Positivity - A Representation Theoretic
  Perspective" (2018). General RP reference (the slab RP + Peter-Weyl context).

## Verification

All 7 are now top hits for their topic queries (e.g. the KP query returns
math-ph/0605041 at 0.87, 2001.00652/0707.0016 next; the RP+mass-gap query returns
2606.19362 at 0.86). Tags: cluster-expansion, reflection-positivity, fermionic-rp,
yang-mills-mass-gap (all also `null-edge`).

---

# Round 2 (comprehensive): 12 more papers across all challenge lanes

Total this session: 19 papers. Coverage probes first (to target real gaps):
checkerboard, octonion/exceptional-Jordan SM (incl. 2026 `2606.15235`),
Wilson-Dirac/doubling (Ginsparg-Wilson, Nielsen-Ninomiya) were ALREADY
well-covered - so those were NOT re-added. The gaps below were empty.

## Probabilistic / rigorous lattice gauge theory (the Chatterjee school) - YM lane

The graph had none of the modern rigorous lattice-gauge literature (the
verification-debt register cited Chatterjee "from memory"):
- **1803.01950** - Chatterjee, "Yang-Mills for probabilists" (foundational
  overview of rigorous lattice YM as probability).
- **1502.07719** - Chatterjee, "Rigorous solution of strongly coupled SO(N)
  lattice gauge theory in the large N limit" (strong-coupling Wilson loops =
  convergent sum over lattice-string trajectories; gauge-string duality).
- **2304.08286** - "Free energy and quark potential in Ising lattice gauge
  theory via CLUSTER EXPANSION" - DIRECT hit: Z2 gauge + cluster expansion + the
  quark potential, exactly the project's Z2/Q6 setup.
- **2505.16585** - "Expanded regimes of area law for lattice Yang-Mills" (area
  law beyond strong coupling - the YM1 area-law lane).
- **1811.09770** - "Wilson loops in Ising lattice gauge theory" (the Z2 lane).

## Higgs-confinement / Fradkin-Shenker - NE-U6 electroweak (the kill-condition)

- **1704.06201** - "Fradkin-Shenker Continuity and 'Instead-of-Confinement'
  Phase" - the modern reference for the NE-U6 kill-condition (FS continuity is
  phase-diagram connectivity, NOT mechanism identity).
- **1506.00862** - "On the Higgs-Confinement Complementarity".

## Reflection positivity (extra)

- **1201.3415** - RP + Kallen-Lehmann representation of 2-point functions.

## Origin of mass / "mass without mass" - NE-U5 (the mass thesis's core provenance)

The normative mass doc cites Wilczek "mass without mass" as prose; now in-graph:
- **1206.7114** - Wilczek, "Origins of Mass" - THE anchor: ~all visible mass is
  the back-reaction of QCD gluon fields, not the Higgs. Direct NE-U5 provenance.
- **hep-ph/9410274** - Ji, "A QCD Analysis of the Mass Structure of the Nucleon"
  (the EMT trace-anomaly mass decomposition - mass from quantum loop effects).
- **2603.06770** - "Mass Without Mass from a Berry-Shifted SU(3) Holonomy Rotor"
  (2026) - striking parallel to the null-edge (C)losure obstruction: mass with no
  primitive mass input, from an SU(3) holonomy. Worth a close read for the
  unification thesis.
- **1811.02803** - "The origin of the nucleon mass" (modern lattice).

## Round 3 (2026-07-06, WIDE-run cycle HB22) - nonabelian strong-coupling gap

Frontier query: rigorous convergent character/cluster expansion, RP, nonabelian
strong-coupling mass gap. `scholarly` meta-search (search-papers) is the working
backend this cycle (arxiv/semantic-scholar single-backend returned empty for the
long queries; inspirehep needs short queries).

- **0808.3442** (INGESTED, Zotero `K9FIBTZC`) - Kanazawa, "Generalizing the
  Tomboulis-Yaffe Inequality to SU(N) LGT and General Classical Spin Systems"
  (Ann. Phys. 2009). RP -> a box insensitive to boundary conditions has a nonzero
  mass gap; extended SU(2)->SU(N); strong-coupling expansion verifies the
  insensitivity. MINED in `TOMBOULIS_YAFFE_ROUTE_MINE.md`: a KP-free route to the
  nonabelian gap, algebraically close to our landed RP + OS machinery.
- **DOI 10.1142/s0219887826501148** (recorded, DOI-only no arXiv) - Faizal-Shabir
  "Reflection Positivity and a Finite-a Strong-Coupling Gap in Lattice SU(N)
  Yang-Mills: Part(1)". Int.J.Geom.Methods journal companion to the blueprint
  arXiv:2606.19362 (in graph as DOI 10.1002/prop.70097).
- **DOI 10.1142/s0219887826501136** (recorded, DOI-only) - Faizal-Shabir Part(2),
  "Reflection-Positive Renormalization and the Persistence of the Mass Gap":
  step-scaling / gap-persistence-under-renormalization - the continuum-limit angle
  our finite theorem deliberately does not claim.
- Also seen (not new/not ingested): Kanwar-Wagman 2103.02602 (real-time LGT,
  character expansion convergence via contour deformation); old pre-arXiv
  strong-coupling mass-gap series (Nucl.Phys.B 1986/1987, SU(2) cluster expansion).

## Round 4 (2026-07-06, cycle HB26) - Nielsen-Ninomiya / T-leg necessity

- **hep-lat/0209060** (INGESTED r3 tail, Zotero IB8F3BSP) - Forcrand-Jahn, SU(2)/SO(3)
  vortex free energy (the electric-twist order parameter Z^-/Z for the SU(2) TY port).
- **2105.10977** (INGESTED, Zotero X2P68FKS) - "Naive Lattice Fermion without
  Doublers". MINE for the T-leg: it EVADES doubling, so it must break an N-N
  assumption (locality / hermiticity / translation-invariance). This pins the
  honest necessity statement for `DoublingTurnPrice`: chiral symmetry ⟹ forced
  doubling is CONDITIONAL on {local, hermitian, translation-invariant}; the "price
  of the turn" is precisely giving one of those up. Feeds the sm-doubling-audit
  red-team's necessity-direction question (85814661).

## Round 5 (2026-07-06, cycle HB29) - the single C-gate (SU(N) construction)

- **2506.00284** (INGESTED, Zotero Q942D77M) - "A Constructive Proof of Existence
  and Mass Gap for Pure SU(3) Yang-Mills in 4D". MINE for the single C-gate: the
  rigorous SU(3) RP-measure -> mass-gap construction target. Read for the
  Haar-measure / RP / transfer-matrix route that would discharge the TwistSystem's
  modeled hypotheses (hW, Z_le) in the genuinely nonabelian case. Complements the
  in-graph Faizal-Shabir blueprint 2606.19362.
- Also seen (no arxiv, not ingested): "Constructive Existence of Quantum
  Yang-Mills on R^4"; Seiler LNP 159 (Osterwalder-Seiler, the classic RP
  construction). The C-gate literature is now well-mapped.

## Round 6 (2026-07-06, HB31 saturation batch) - mass decomposition + div-algebra
- hep-th/9506115 (DW2RXBBI), 2006.16274 (845WNTMG) - NCG anomaly cancellation +
  octonion/trace-dynamics unification (lane B provenance).
- 2601.13070, 2506.23902 (INGESTED) - lattice-QCD validation of the hadron
  mass / TRACE-ANOMALY decomposition + nucleon-mass sigma-terms. Direct NE-U5
  provenance (mass = QCD gluon-field back-reaction, not the Higgs), complementing
  Wilczek 1206.7114 and Ji hep-ph/9410274 already in-graph.

## Round 7 (2026-07-06, saturation cadence) - the parked Q6 crux (KP convergence)
- 2112.13134 (INGESTED) - "Cluster Expansions: Necessary and Sufficient Convergence
  Conditions" - a fresh rigorous angle on the parked Q6 crux pairSum_le_expBound
  (the KP/Fernandez-Procacci tree-graph bound, codex's lane). Newer than the
  Fernandez-Procacci math-ph/0605041 (already in-graph). Worth mining for the exact
  convergence criterion shape if the Q6 crux is revisited.

## Round 8 (2026-07-06, saturation cadence) - Ginsparg-Wilson / lattice chiral
- hep-lat/9802011 (Luscher, INGESTED) - "Exact chiral symmetry on the lattice and
  the Ginsparg-Wilson relation" - THE definitive account of how lattice fermions
  keep an exact (modified) chiral symmetry, circumventing Nielsen-Ninomiya. Direct
  T-leg mine: the GW relation is precisely the "price" - chiral symmetry is
  deformed, not broken, at the cost of a specific {D,gamma5} = a D gamma5 D
  structure. Feeds the genuine N-N no-go + its evasion (the honest T-leg necessity).
- hep-lat/0405024 (INGESTED) - review of chiral symmetry on the lattice.
- Also: hep-lat/0105032 (domain-wall + chiral gauge theories).

## Round 9-10 (2026-07-06, saturation) - overlap / index theorem (T-leg)
- hep-lat/9808026 (INGESTED) - exact-chiral-symmetry axial current on the lattice
  (the overlap/GW conserved current); feeds sm-overlap-dirac.
- 1905.03963 (INGESTED) - topology + index theorem on the lattice (the index =
  signed zero/chirality count - the continuum content behind the crossing no-go).
- Also seen: 2501.02873 (eta invariant of the massive Wilson-Dirac operator).

## Round 11 (2026-07-06) - CONCEPTUAL SYNTHESIS mine (support for the Fable-5 brief)
Reframed goal: Fable-5 drives the *conceptual* synthesis (common-carrier verdict,
unifying principle), so this round targets prior art on a SINGLE relational/spectral
origin of mass - the candidate "common carrier" the brief asks Fable to adjudicate.
- 1004.0464 (Chamseddine-Connes, INGESTED, key 8HGA475I) - "NCG as a Framework for
  Unification of all Fundamental Interactions including Gravity, Part I". THE canonical
  spectral-action reference: gauge + Higgs + gravity from one Dirac operator D and
  Tr f(D/Lambda). Directly relevant to the brief's conjecture that our null-edge
  operator D = sum_a c(alpha^a) nabla_{ell_a} is a Dirac operator and mass is
  Tr f(D) content - i.e. the common carrier might be spectral. Feed to Fable.
- "E8 Symmetry and Spectral Geometry in Quantized Spacetime: A Geometric Origin of
  Fermion Mass Hierarchies and Koide's Relation" (2025, DOI 10.20944/preprints
  202511.0938.v1; no arxiv) - ties our V-lane (E8-240) to a *spectral-geometric*
  origin of the fermion MASS hierarchy + Koide. Cross-lane bridge candidate (V<->mass).
- "Spectral Noncommutative Gauge Geometry from Interaction Operator Algebras: Emergent
  Yang-Mills Structure, Flavor Geometry..." (2026, DOI 10.2139/ssrn.6767918; no arxiv)
  - emergent YM (C-lane) + flavor/mass geometry from an operator algebra - a single
  carrier producing both closure (YM) and turn (flavor) structure. High-value for the
  common-carrier question; treat as unvetted preprint.
- "QICT: Receiver Distinguishability and the Spectral Derivation of Standard-Model
  Structure" (2026, DOI 10.20944/preprints202604.0323.v5; no arxiv) - a *relational*
  finite-quotient derivation selecting the Connes algebra C+H+M3(C) and deriving mass
  sums / PMNS from finite endpoint transport. Startlingly close in spirit to the
  null-edge relational-obstruction thesis; unvetted preprint, flag to Fable as
  possible parallel/prior-art (NOT endorsed).
- Furey PhD thesis "Standard model physics from an algebra?" (R(x)C(x)H(x)O acting on
  itself) - the canonical division-algebra->SM reference for Lane B / brief 6.5.
  (Already the intellectual source of the Furey lane; ensure in-graph.)
- NEGATIVE SIGNAL (worth telling Fable): a direct search for prior art on "mass as
  obstruction to lightlike/null transport / relational origin of inertia" returned
  NO close hits - the specific null-edge-obstruction framing appears distinctive.
  The nearest neighbors are all spectral/NCG or division-algebra, not null-edge.
