# Literature-search log — overnight all-mass run 2026-07-09 (one line per search)

Cadence: before each assembly rung leaning on prior art (RUN_PLAN sec 5).
Verify + add any cited source to Null_Edge_References.md before the manuscript
cites it.

<!-- append below -->
2026-07-08T23:09:22.1222958-07:00 Codex/Spark GoalIV|SuiteD: literature/API sweep done; high-priority refs = Jacobson1995, Eling-Guedens-Jacobson2006 non-eq Clausius, gr-qc/0208036 Regge teleparallel, arXiv:1204.4339 higher-gauge teleparallel, f(T,B)/f(Q) thermodynamics shortlist; Lean API checks = elazarg/kraft (Kraft.lean, InformationTheory/Coding/*), RemyDegenne/testing-lower-bounds (TestingLowerBounds.lean), Hayata-Yamasaki-Group/lean-quantum (Quantum.lean), lecopivo/SciLean (SciLean.lean); claim grade MEMO/reference until source chunks/modules are verified.
2026-07-08T23:20 Claude SuiteA/RP: chunk search 'OS reflection positivity selects Lorentzian signature'. STRONG hits: Besnard, 'On the definition of spacetimes in NCG' I+II (arXiv:1611.07830, 1611.07842) - Krein structure compatible with real structure exists iff space/time orientable; Lorentzian signature characterized from NCG data. Finite Pseudo-Riemannian Spectral Triples + SM (arXiv:1804.09482). -> cite for SignatureForcing/RPSelectsLorentzian + Suite A operator-to-geometry; verify before manuscript cite.
2026-07-08T23:20 Claude GoalIII/SuiteB: chunk search 'quantum walk decimation emergent Lorentz z=1'. STRONG hits: 'Discrete spacetime, quantum walks and relativistic wave equations' (arXiv:1802.03910, rotational invariance ch16); 'QED from Quantum Cellular Automata: symmetry/locality/positive-energy tension' (arXiv:2503.05998). -> cite for Goal III relativity-at-fixed-point + CheckerboardCarrierBridge; the QCA no-go tension is a kill-condition reference.
2026-07-08T23:28 Claude PhysLean sweep (lean-explore packages=[Physlib]) for Goal III/Suite A physics objects: PhysLean has LorentzGroup (restricted, parity, rotations; mem_iff_transpose_mul_minkowskiMatrix_mul_self = Lambda^T eta Lambda = eta) and Dirac gamma matrices (spaceTime.gamma.gamma_in_diracAlgebra). -> seed Goal III(e) discrete-boost-covariance + Suite A signature jobs with these convention decls (clean-room port, do NOT import; PhysLean version-pinned off v4.28.0).
2026-07-09T00:17:01.7485841-07:00 Codex/Spark-fallback GoalII|SuiteC: Neo4j vector scripts timed out (`--k 5` paper/chunk/doc); scholarly/web fallback found KM 1973 (`CP-Violation in the Renormalizable Theory of Weak Interaction`, PTP 49), Jarlskog/CKM invariant literature, Jenkins-Manohar-Stoffer 2008 `Rephasing invariants of quark and lepton mixing matrices` with explicit N x N parameter count `(N-1)(N-2)/2`, and CKM rephasing-invariant parametrization (PhysRevD.49.3787); claim grade MEMO/reference until paper chunks/full modules are verified. Spark sidecar still running for richer ranked hits.
2026-07-09T00:15 Claude SuiteA: chunk search 'finite spectral triple Connes distance recovers causal order Malament conformal/scale'. No strong NEW hits beyond the Besnard NCG signature papers already logged (1611.07830/1611.07842) + Franco-Eckstein Lorentzian causal spectral triples - those remain the citation anchors for SuiteAOp2Geom's finite Malament (dCausal=1/m, order mass-independent, scale=E-slot).
2026-07-09T00:31:58.1497928-07:00 Codex/Spark GoalII|SuiteC: compact literature/API sweep for finite KM CP-phase counting + general-N incidence/corank; ranked sources include KM 1973, CKM property/parametrization references, rephasing invariants of quark/lepton mixing matrices, generalized Jarlskog invariants, cycle-nullity/cycle-space references; Lean leads = Mathlib `SimpleGraph.IncMatrix`, `SimpleGraph.Finite`, `SimpleGraph.LapMatrix`, `LinearAlgebra.Dimension.RankNullity`; status reference/MEMO only pending chunk/module verification.
2026-07-09T01:45 Claude GoalI: chunk search 'color singlet positivity confinement finite Krein bound state below threshold gap'. No strong hits in the null-edge collections (the finite toy hadron is more lattice-QCD-flavored than the collection's null-edge/NCG focus); Goal1Hadron stays a self-contained toy without a direct prior-art anchor - fine, it claims no continuum QCD. Existing lattice-confinement refs (Osterwalder-Seiler etc., already in the manuscript) remain the closest context.
2026-07-09T03:05 Claude S4a/GoalIII: chunk search 'RG relevant/irrelevant operators universality Dirac fixed point from discrete quantum walk'. No strong new hits in the null-edge collections beyond the already-logged discrete-spacetime quantum-walk refs (1802.03910, QED-from-QCA 2503.05998); those remain the anchors for the S4a channel-RG kill-test (77f8da10) and Goal III basin-membership.
2026-07-09T06:25 Claude gravity+QFT unification: two chunk searches. (a) thermodynamic/entropic gravity -> Jacobson gr-qc/9504004 (Einstein eq of state), 1505.04753 (entanglement equilibrium), 1812.01596 (causal diamonds), gr-qc/0602001 (non-eq/f(R)). (b) NCG spectral-action gravity+SM -> Chamseddine-Connes-Marcolli hep-th/0610241, quiver/Bratteli spectral action 2401.03705 (DISCRETE precedent), finite-spectral-triple Dirac moduli 0902.2068, semi-Riemannian/Krein NCG-SM 1812.00038 / 1210.6575. Both routes have discrete precedents our finite Krein spectral triple can imitate. Fed the 4 unification jobs + future-dir P-L. Sources to add to References before any manuscript citation.
2026-07-09T07:05:00-07:00 Codex/Spark Lambda sidecar: finite/unimodular Lambda + count/volume conjugacy + Poisson-vs-hyperuniform + spectral-action channel sweep. Ranked anchors: astro-ph/0209274, arXiv:1210.2589, Living Rev causal set 10.1007/s41114-019-0023-1, gr-qc/0009099, arXiv:2203.15714, arXiv:0904.4841, gr-qc/0605006, cond-mat/0311532, PhysRep hyperuniformity 1801.06924, hep-th/9606001, hep-th/0605011; internal anchors `Sources/NERD_2.md` and `Sources/Underexplored_Angles_Lit_Review.md`. Status: reference/MEMO until source chunks are verified before manuscript citation.
2026-07-09T08:30 Claude PhysLean/port: lean-explore packages=['Physlib'] 'Minkowski metric signature'. Found PhysLean `minkowskiMatrix {d} = LieAlgebra.Orthogonal.indefiniteDiagonal (Fin 1) (Fin d) R` = diag(1,-1,-1,...) (mostly-minus, MATCHES our eta). indefiniteDiagonal is MATHLIB, so directly portable (no PhysLean import). Also Lorentz.minkowskiProduct/contrMetric (PhysLean). Spawned port job minkowski-physlean-port (ground our eta in indefiniteDiagonal + PhysLean provenance). Kraft package (elazarg/kraft) referenced for kraft-compression-mass port.
2026-07-09T08:45 Claude gravity/§7: chunk 'teleparallel torsion spectral action Einstein-Hilbert matter coupling'. Hits: Teleparallel Gravity as a Higher Gauge Theory (arXiv:1204.4339 - directly supports TeleparallelSoldering), Lorentz signature + twisted spectral triples (arXiv:1710.04965 - Krein/Lorentzian spectral action), Connes-Chamseddine gravity+SM coupling (hep-th/0610241 chunk 66). Add 1204.4339 + 1710.04965 to References before the §7 rewrite cites them.

## 2026-07-09 ~mid-morning - Claude - Poisson-vs-hyperuniform sprinkling (Lambda C-fork kill)
- Tool: neo4j_paper_search.py --chunks, null-edge collections.
- Query: causal set sprinkling number variance Poisson fluctuations hyperuniform region.
- FINDING (import): Poisson sprinkling is the UNIQUE Lorentz-invariant discretization
  (arXiv:1010.5514 "Quantum Fields on Causal Sets" ch.22: Poisson chosen so the causet
  picks out no direction; arXiv:1903.11544 ch.11: any regular discretization breaks
  rotational/translational symmetry, "not regular in all frames"). => the hyperuniform
  branch of the Lambda fork is NOT free: it costs Lorentz invariance.
- USE: sharpens manuscript 10a fork - cross-links to landed RPSelectsLorentzian (s8):
  IF the framework's Lorentzian selection governs count statistics THEN Poisson =>
  everpresent-Lambda survives. Concrete form of the open C: count-Lorentz-invariance
  => Poisson => everpresent. Graded import (Sorkin/Bombelli-Henson-Sorkin), bridge = C.
- Sources to verify+add to References: arXiv:1010.5514 (Sorkin/Johnston/... QFT on causets),
  arXiv:1903.11544 (Surya, "The causal set approach to quantum gravity", Living Reviews).

## 2026-07-09 ~afternoon - Claude - celestial-sphere null directions / spinor-helicity prior art
- Tool: neo4j_paper_search.py --chunks, null-edge collections.
- Query: celestial sphere null directions spinor helicity spherical harmonics scattering amplitudes conformal.
- PRIOR ART (bears on ORIGINALITY honesty of s3/s2b):
  * arXiv:1212.5605 (Scattering Amplitudes & the Positive Grassmannian) ch.5: null momenta =>
    2x2 p^{a bdot} has det=0 => rank 1 => p=lambda~lambda. EXACT kinematic core under our
    MassNullDecomposition (massless <=> det P=0 <=> rank-1). => our det-P statement is [comp]/
    [import] spinor-helicity, NOT [orig]; contribution = finite kernel-checked formalization.
  * arXiv:1709.04891 (Arkani-Hamed-Huang-Huang, "All Masses and Spins"): massive spinor-helicity
    decomposes into little-group/null pieces. Prior art for "massive = two null pieces" + s2b
    polarization counting.
  * arXiv:2301.06203 ("Zig-Zag Theory of Massive Spinning Particles", ambitwistor): zig-zag framing
    of massive particles' principal null directions. Prior art for the s2b Penrose-zigzag picture.
- ACTION: add 3 refs (below), check s3/s2b originality tags do not claim the PHYSICS picture as orig.

## 2026-07-09 ~afternoon - Claude - central-thesis originality check (mass from masslessness)
- Tool: neo4j_paper_search.py --chunks, null-edge collections.
- Query: mass generated from massless lightlike constituents geometric misalignment two null momenta rest mass emergent.
- ORIGINALITY FINDING (bears on the HEADLINE claim): "mass = hidden masslessness" is an old,
  distinguished lineage: Bars twistor/2T (hep-th/0512091) "mass = component of momentum in a
  higher dimension" (Kaluza-Klein), massless-in-D+1; also causal-set massless diffusion
  (0810.5591). The manuscript did NOT acknowledge this -> ORIGINALITY OVER-CLAIM RISK on the title.
- ACTION (done): added a "What is, and is not, new here" paragraph to 2b - the general notion is
  [import] (KK/Bars/2T/Zitterbewegung/preon lineage); the [orig] contribution is the FINITE
  null-edge-disagreement (mass^2=det P Plucker) mechanism + kernel-checked grade. +Bars ref.
- Honest posture strengthened: the lineage supplies the picture; the contribution is the finite theorem.

## 2026-07-09 ~mid-afternoon - Claude - QCD trace-anomaly / hadron mass origin (red-team follow-up)
- Tool: neo4j_paper_search.py --chunks. Query: proton mass origin QCD trace anomaly gluon field
  energy dynamical chiral symmetry breaking not constituent quark mass.
- RESULT: null-edge collection returned only lattice-QCD fermion technicalities (minimally-doubled
  fermions, ChPT pion mass) - NOT the Ji/trace-anomaly proton-mass decomposition. No strong new
  prior art in-collection. The red-team's point (proton mass ~ trace anomaly, not constituent
  mass) is textbook QCD, does not need a graph citation to honor.
- ACTION: check s6 (hadron) honestly distinguishes the KINEMATIC det-P bookkeeping from the
  DYNAMICAL QCD mass mechanism (trace anomaly) - do not let det-P claim to "explain" hadron mass.

## 2026-07-09 ~mid-afternoon - Claude - VERIFY the BHS Lorentz core (s10a correction)
- Tool: neo4j_paper_search.py --chunks. Query: Poisson sprinkling unique Lorentz invariant discreteness
  without breaking Lorentz symmetry random lattice frame.
- VERIFIED (the [import] the s10a correction now relies on): arXiv:gr-qc/0605006 "Discreteness without
  symmetry breaking: A Theorem" - Bombelli, Henson, Sorkin (top hit 0.884, exact title+authors in graph).
  Poisson = unique Lorentz-invariant discrete point process on Minkowski. This is the REAL "hyperuniform
  => not Lorentz" (not the exchangeability lemma LambdaFrameConstraint proves).
- CORROBORATION: arXiv:gr-qc/0311055 (Henson, "QG Phenomenology, Lorentz Invariance and Discreteness"):
  non-random discretization has empty/overfull regions in boosted frames => prefers a frame => breaks
  Lorentz. Also 1903.11544 (Surya), 1010.5514 (QFT on causets) reconfirmed.
- ACTION: upgraded BHS + added gr-qc/0311055 to References (NEEDS-VERIFY -> VERIFIED).

## 2026-07-09 ~late-afternoon - Claude - verify the Chamseddine-Connes heat-kernel [import] (s7 correction)
- Tool: neo4j_paper_search.py --chunks. Query: Chamseddine Connes spectral action heat kernel
  Seeley-DeWitt Einstein-Hilbert from Dirac operator.
- CONFIRMED (the [import] the s7 correction leans on): the spectral action's EH emergence REQUIRES
  the heat-kernel expansion (Gilkey's theorem on the Dirac square) - explicit in CCM hep-th/0610241
  ch.81 ("square of the Dirac operator... suitable to apply the standard local formulas for the heat
  expansion"), and 2401.03705 ("spectral action... reduces to Einstein's gravity if the spectral triple
  is dual to a Riemannian manifold"). Both ALREADY in References. This directly supports the audit's
  point: the finite avatar (no manifold/heat kernel) CANNOT reproduce a2~integral R - so finite
  tr(D^2)=EH is labeling. CC-orig ref note upgraded to CONTENT-VERIFIED.

## 2026-07-09 ~late-afternoon - Claude - verify the CC-problem [import] (s10a order-0 correction)
- Tool: neo4j_paper_search.py --chunks. Query: cosmological constant problem vacuum energy matter loops
  renormalize 120 orders Weinberg.
- CONFIRMED: the matter-loop vacuum-energy renormalization (the ~120-orders CC problem the s10a order-0
  correction leans on) is in-graph via Burgess review arXiv:1309.4133 ("The Cosmological Constant Problem:
  Why it's hard to get Dark Energy from Micro-physics"). Supports the correction: matter loops DO feed
  Lambda, so the order-0 'no channel pathway' ASSUMES the feedback away (honest about the toy, not the vacuum).
- Weinberg1989 ref note upgraded to CONTENT-VERIFIED via Burgess.

## 2026-07-09 ~late-afternoon - Claude - verify sequestering/unimodular [import] (s10a three-Lambda)
- Tool: neo4j_paper_search.py --chunks. Query: unimodular gravity sequester vacuum energy global constraint
  decoupled integration constant trace-free Einstein.
- VERIFIED + STRENGTHENED s10a [import]s:
  * arXiv:0710.1675 (Sorkin, "Is the CC a nonlocal quantum residue of discreteness of the causal set
    type?") - the everpresent-Lambda ORIGIN paper. Upgrades TBD-SorkinCC2007 from NEEDS-VERIFY.
  * arXiv:2304.03819 ("Aspects of Everpresent Lambda (I)") - RECENT, on-point: derives everpresent-Lambda
    from causal sets + UNIMODULAR gravity (global volume-constraint path integral). Grounds BOTH the
    everpresent mechanism (LambdaEdgeCount) AND the three-Lambda sequestering (LambdaThreeSplit). Best
    single s10a [import]. Added VERIFIED.
- s10a mechanism citations now graph-verified end to end (Sorkin origin + unimodular derivation + BHS Lorentz).

## 2026-07-09 ~late-afternoon - Claude - s10a observational posture (DESI/everpresent-Lambda tests)
- Tool: neo4j_paper_search.py --chunks. Query: DESI evolving dark energy w not minus one dynamical
  dark energy observational evidence.
- FOUND the observational companion: arXiv:2307.13743 (Das-Nasiri-Yazdi, Imperial, "Aspects of
  Everpresent Lambda (II): Cosmological Tests of Current Models") - confronts everpresent-Lambda
  (stochastic fluctuating dark energy from causal sets + unimodular) with cosmological data. This is
  where the s10a fork's fluctuating-vs-rigid question is actually adjudicated.
- ACTION: added 2307.13743 to References (VERIFIED); cited it in s10a 'What this is, and is not'
  posture paragraph as the [import] observational test. Directly grounds the Priority-A observational-
  posture concern (the fork now points to the real cosmological-test paper, honestly [import]).

## 2026-07-09 ~late-afternoon - Claude - verify ADGS everpresent-Lambda anchor (s10a [import])
- Tool: neo4j_paper_search.py --chunks. Query: everpresent Lambda 1/sqrt volume Ahmed Dodelson Greene
  Sorkin causal set.
- ADGS original (astro-ph/0209274) not a separate graph chunk, BUT its everpresent-Lambda mechanism
  (fluctuating Lambda ~ 1/sqrt(V) from causal-set discreteness) is CONTENT-CONFIRMED via the verified
  citing/extending chain already in-graph: Aspects I (2304.03819), Aspects II (2307.13743), Sorkin
  (0710.1675). ADGS ref note upgraded to CONTENT-CONFIRMED.
- NET: s10a everpresent-Lambda [import] now grounded end-to-end - ADGS origin (via chain) + Aspects I/II
  (mechanism+observational tests) + Sorkin (origin) + BHS (Lorentz) + Weinberg/Burgess (CC problem).
  Every s10a imported citation is now verified or content-confirmed.

## 2026-07-09 ~late-afternoon - Claude - READ the everpresent-Lambda observational VERDICT (not just cite it)
- Tool: neo4j_paper_search.py --chunks. Query: DESI DR2 BAO dark energy w0 wa evolving 3 sigma 2025.
- DESI DR2 (2503.14738) not in-graph (very recent). BUT read the CONTENT of the observational-test paper
  2307.13743 (Aspects II): chunk 12 = fits SN Ia better than LambdaCDM for only ~0.017% (16/90000) of
  realizations; chunk 2 = STRUGGLES with CMB (non-vanishing ISW, unlike LambdaCDM). => the everpresent
  model is currently DISFAVORED, not a success.
- ACTION: corrected s10a posture to report the CURRENT VERDICT (live but disfavored: rare SN fit + CMB
  struggle), not just 'friendly to a deviation'. This is 'keep every sentence honest' applied to the
  observational posture - reading the paper's content, reporting the unfavorable result faithfully. +ref note.
