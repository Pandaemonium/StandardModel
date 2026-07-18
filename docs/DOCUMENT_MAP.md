# Document map: the master list

Hand-curated index of the repository's important documents. One line each,
with a status tag. Update this map whenever a top-level or program-defining
document is added, superseded, or frozen. (Machine-generated declaration
indexes live in `Index/`; this file is for humans and agents deciding what to
read.)

Status tags: **[LIVE]** actively maintained, read for current truth -
**[STABLE]** correct and current, changes rarely - **[DRAFT-MS]** manuscript
in progress - **[HISTORICAL]** era document, kept for provenance; do not treat
as current state.

## If you read only five

1. `README.md` - what this repository is. [STABLE]
2. `AGENTS.md` - the working contract for all contributors. [STABLE]
3. `NULL_EDGE_RESULTS.md` - the flagship program's results map by trust level. [LIVE]
4. `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex` - the focused principal theorem paper. [DRAFT-MS]
5. `AgentTasks/twoday-carrier-run-2026-07-07/SYNTHESIS_BEYOND_MASS.md` - the forward synthesis. [LIVE]

## Entry points and contracts

- `README.md` - front door: flagship program, assets, trust model, build. [STABLE]
- `AGENTS.md` - always-on agent/contributor rules; conventions; policies. [STABLE]
- `CLAUDE.md` - pointer to AGENTS.md for Claude Code. [STABLE]
- `GEMINI.md` - Gemini-facing contract mirror. [STABLE]

## Operational guides (docs/ and Scripts/)

- `AutonomousLab/README.md` - front door for the Autonomous Fundamental Physics
  Lab: persistent five-year research organization, cross-model roles,
  portfolio/state, evidence gates, reproducibility, and executable lab-control
  tooling. [LIVE]
- `AutonomousLab/FIVE_YEAR_PLAN.md` - 2026-2031 hard-exam roadmap from finite
  foundations through QFT, gravity, Standard Model/cosmology, prediction, and
  external judgment. [LIVE]
- `docs/BUILD.md` - build, toolchain pin, Windows fixes, verification commands. [STABLE]
- `docs/ARISTOTLE.md` - Aristotle submission/integration mechanics and loop. [STABLE]
- `docs/CONVENTIONS.md` - project conventions and convention-lock status. [STABLE]
- `docs/NULLSTRAND.md` - null-edge orientation, guardrails, architecture; incl. the Malament conformal-vs-scale split. [LIVE]
- `docs/NERD_ROADMAP.md` - the NERD program master roadmap (v2.1). [LIVE]
- `docs/DOCUMENT_MAP.md` - this file. [LIVE]
- `Scripts/MCP_SERVERS.md` - MCP tooling: Lean LSP, lean-explore, literature/Neo4j/Zotero pipelines. [STABLE]
- `Scripts/README.md` - script inventory. [STABLE]

## Program state and results

- `NULL_EDGE_RESULTS.md` - key results of the null-edge program, graded by trust; carrier-layer update appended 2026-07-07. [LIVE]
- `PROGRESS.md` - the whole repository's highest-value achievements, small by design. [LIVE]
- `NORTH_STAR.md` - the mission statement (2026-04); mission stands, flagship execution is the null-edge program. [HISTORICAL]
- `EXECUTION_PLAN.md` - milestone plan of the octonion/Furey/E8 era. [HISTORICAL]
- `OPEN_QUESTIONS.md` - curated formalization questions (April 2026 survey era). [HISTORICAL]
- `FUTURE_DIRECTIONS.md` - eight-direction strategy map (May 2026 era). [HISTORICAL]

## The null-edge program: core documents

- `Sources/Null_Edge_GR_Literature_Audit_2026-07-18.md` - primary-source audit of null-lattice and first-order discrete gravity. Its full Schaden deep read extracts the spinor/Pfaffian null-frame geometry, centered-plaquette proper time, manifold-admissibility projector, gauge slice, and measure, while flagging the arXiv-v2 Hermitian-conjugate link reversal as different from the repo's inverse-holonomy action. `PhysicsSM/Draft/NullEdge/SchadenProperTimeBridge.lean` kernel-checks the centered-plaquette identity and its exact dictionary to the squared Pluecker mass scalar. `PhysicsSM/Draft/NullEdge/SchadenNullFrameAdmissibility.lean` kernel-checks the Pfaffian/triangle/determinant chain, identifies strict negative length determinant with coframe nondegeneracy, and exposes the six-predecessor backward-simplex gate without claiming it is dynamically enforced. The audit identifies Kur-Glasser as the nearest Euler-equation precedent, Kheyfets-LaFave-Miller null-strut calculus as the earlier null-link evolution precedent, applies Neiman's null-cell focusing obstruction, separates the current rank-two curvature image from a physical graviton count using Dittrich-Hoehn, and records both modern weak-curvature convergence templates and the older Miller/Brewin warning that pointwise residual decay is not the same as weak or solution convergence. [LIVE]

- `AutonomousLab/work/SPIRAL-LAYER/CLAUDE_SPIRAL_LAYER_PROGRAM_NOTE_2026-07-16.md` -
  the spiral-layer program note: the kernel-checked answer to "does mass
  zig-zag or spiral?" - the three-layer breakdown (mass magnitude
  orientation-blind; per-corner amplitude hairpin-maximal; phase/spin/CP
  in the oriented content), the conjecture ledger with all three gates
  now anchored (C1 polygon solid-angle law closed via the fan induction;
  C2 complete via all-orders planar CP-inertness plus the two-family
  Jarlskog toy; C3 anchored via the cap-square Berry factor and the
  framed area law with exact rectangle constant in
  `PhysicsSM/Draft/NullEdge/GateYM/FramedAreaLawTransfer.lean`). Lean
  anchors: fourteen `PhysicsSM/Draft/NullEdge/*Aristotle.lean` spiral
  modules (SpinCornerBargmann, HairpinLunePhase, ChiralSpiralCommutator,
  SpinCornerFourCycle, ChiralSpiralMassive, PlanarCornerReality,
  BargmannSolidAngle, BargmannCocycle, BargmannFanInduction,
  BargmannJarlskogToy, CapSquareBerry) with build-enforced
  standard-three guards throughout. [LIVE]
- `NULL-EDGE_TARGET_AUDIENCE.md` - publication-positioning memo: optimize Paper I for discrete relativistic quantum dynamics and the quantum-walk/QCA community; specifies the required comparison, spectrum, doubling, continuum, `3+1`, artifact, and outreach audits. [LIVE]
- `Sources/Null_Edge_From_Area_to_Dirac_Gap_Manuscript_Draft_2026-07-10.tex` - focused principal theorem draft: null-spinor area, the Pluecker-derived odd mass operator and exact unitary corner dictionary, full-zone `1+1` audit, and an exactly local finite `3+1` successive-axis extension with a phase-retaining complex rest operator, compact-box rate, exact three-torus Plancherel/wave-packet control, compact-support momentum-space `L2` convergence, explicit reversibility/causal cone, and an exact high-symmetry audit. The latter classifies all massless corners and proves explicit `+1`/`-1` body-center modes for every mass angle, so the current cubic regulator is globally ungapped; a separate theorem excludes the naive degree-one stationary-amplitude repair under the full involutory Dirac tangent. This is the impact-first Paper I draft; lattice-to-PDE identification, regulator replacement, interactions, and broader ontology are explicitly deferred. [DRAFT-MS]
- `Sources/Null_Edge_GR_Foundations_Spine_2026-07-17.md` - canonical concise GR architecture and literature audit. It separates manifold-conditioned reconstruction from dynamical manifold selection, enforces one operator-derived metric/curvature/matter/action chain, lists F0-F9 completeness gates, and points to `PhysicsSM/Draft/NullEdge/GRFoundations.lean` as the Lean facade. The facade includes the affine interval-action no-go, determinant coframe-volume response, finite Palatini-to-Einstein composition, exact incidence boundary cancellation, the nonlinear and joint two-field chart actions, spinor-null coframe reconstruction, directed-carrier Levi-Civita/Ricci reconstruction, aggregate-weight coframe coverage, exact independent pointwise-connection variation, its local Euler coefficient and conformal Levi-Civita no-go, gauge-covariant periodic link/plaquette holonomy, scalar and Euclidean finite-fiber link/face Palatini divergence equations, an exact abstract Krein predecessor adjoint, a spacetime-derived Lorentz-bivector representation preserved by the concrete null-edge `SL(2,C)` action, an exact nonlinear right-trivialized Lorentz-plaquette tangent with additive identity-link limit, the full Krein-paired face Euler/divergence chain, a continuous action-visible curvature extractor with a conditional stationarity-to-limit Einstein theorem, a shrinking-plaquette curvature control, and Bianchi-to-source conservation. The long framework note remains the experimental ledger. [LIVE]
- `PhysicsSM/Draft/NullEdge/EinsteinEquationVariation.lean` through `FiniteEinsteinHilbertActionResponse.lean`, together with `CoframeVolumeMetricVariation.lean`, `FinitePalatiniEinsteinHilbertVariation.lean`, `FinitePalatiniBoundaryCancellation.lean`, `FinitePalatiniCoframeChartAction.lean`, `NullEdgeCoframeEinsteinBridge.lean`, `DirectedNullEdgeLeviCivitaEinstein.lean`, `NullEdgeAggregateCoframeEinstein.lean`, `FiniteDirectedPalatiniConnectionVariation.lean`, `FinitePeriodicPalatiniEulerEquation.lean`, `NullEdgePalatiniJointAction.lean`, `FinitePeriodicLinkConnection.lean`, `FinitePeriodicLinkPalatiniVariation.lean`, `FinitePeriodicCovariantLinkPalatiniVariation.lean`, `FinitePeriodicKreinLinkAdjoint.lean`, `LorentzBivectorKreinBridge.lean`, `LorentzBivectorLieAlgebraBridge.lean`, `LorentzPlaquetteTangent.lean`, `LorentzCoframePalatiniFace.lean`, `FinitePeriodicKreinLinkPalatiniVariation.lean`, `FinitePeriodicCoframeKreinPalatiniVariation.lean`, `NonlinearLorentzPalatiniResponse.lean`, `NonlinearLorentzPalatiniAction.lean`, `NonlinearLorentzPalatiniCurveDerivative.lean`, `NonlinearLorentzPalatiniEuler.lean`, `NonlinearLorentzPalatiniCoframeVariation.lean`, `NonlinearLorentzPalatiniCurvatureExtraction.lean`, `NonlinearLorentzPalatiniEinsteinBridge.lean`, `NonlinearLorentzPalatiniEinsteinResponse.lean`, `NonlinearLorentzPalatiniCurvatureLimit.lean`, and `GraphPlaquetteCurvatureLimit.lean` - guarded F6-F8 curvature, action-variation, and decorated-geometry chain. The fixed interval action is affine and nonstationary, but the Palatini successor derives `delta det(e)=-(det(e)/2)<g,delta gInv>`, composes a Ricci-plus-boundary response into the weighted Einstein tensor, proves closed-carrier incidence cancellation, and constructs nonlinear finite actions. Four spinor null edges derive the primitive coframe, Gram metric, inverse, and volume; directed targets derive forward Levi-Civita coefficients, coordinate curvature, symmetric Ricci response, and scalar contraction. Null-column-preserving tangents cannot alone reach all ten metric components, but every coframe is uniquely an aggregate `EA` of a nondegenerate null frame, and aggregate weights have full symmetric metric reach. The joint action has the finite Einstein equation as its metric partial and the exact `Delta H + Gamma H + H Gamma` pointwise-connection response as its independent-connection partial; the canonical periodic flat chart is stationary in that channel. The periodic local audit derives the exact six-term ordered Euler coefficient and proves that the forward-difference null-edge Christoffel candidate fails even torsion-free stationarity on a three-site conformal witness. The corrected curvature substrate attaches group-valued transports to periodic links and proves conjugation covariance and flatness/path-independence. Its additive tangent actions pair scalar and finite-fiber face weights with plaquette curls; exact periodic summation by parts reduces antisymmetric-face stationarity to vanishing backward discrete divergence, with predecessor finite-fiber transport entering through its transpose. An abstract fundamental symmetry upgrades that transpose to the exact Krein predecessor adjoint `J U^T J`; the mostly-minus spacetime metric derives the rotation/boost bivector ordering and split `J`, and every eta-Lorentz matrix, including the concrete null-edge `SL(2,C)` action, preserves it. The six-vector is exactly equivalent to the matrix Lorentz Lie algebra, and the exact nonlinear right-trivialized plaquette response remains in that image and reduces to the additive curl at identity transport. The scalar ordered holonomy action has the matching holonomy-weighted response, exactly recovers the Krein/additive response at identity links, and now has canonical invertible curves `U exp(t hat(delta A))` whose ordinary derivatives equal that response, plus exact four-family nonidentity local link Euler coefficients whose vanishing is equivalent to derivative stationarity. The same action has an exact quadratic coframe-line expansion, sixteen local tetrad equations, and joint `6 + 16` stationarity. Its trace functional has a unique six-component Krein-dual curvature representative; antisymmetrizing that field leaves the ordered action unchanged and rewrites it exactly as a finite Palatini pairing. The full ordered face action uses the complementary coframe-derived curvature-face coefficient, whose proper-Lorentz covariance gives exact gauge invariance of the concrete scalar action. The arbitrary-coframe determinant identity, exact coframe-response formula, and equivalence between finite coframe stationarity and the mixed vacuum Einstein equations are kernel-checked. A continuous linear trace extractor is exactly calibrated on Lorentz generators; supplied first-order group-holonomy refinements give convergence of the action-visible antisymmetric curvature, and stationary refinements at fixed coframe pass to the limiting mixed vacuum Einstein equation. A shrinking-plaquette witness supplies nonzero curvature. Derivation of the frame and weights from the operator sector, equality with the causal-operator metric, graph-derived refinement and coframe convergence, metric dual-cell weighting, Levi-Civita selection, identification of the limiting target with common Riemann curvature, and global continuum variation remain open. [DRAFT-LEAN]
- `Sources/Null_Edge_General_Relativity_Framework_Note_2026-07-14.md` - claim-graded general-relativity reconstruction and conditional derivation: kernel-checked 1+1 null-tick aggregation; an operator-first metric proposal with exact potential-canceling principal-symbol algebra and four-probe convergence transport in `PhysicsSM/Draft/NullEdge/CausalOperatorMetric.lean`; a concrete finite strict-order realization with exact local/smeared four-dimensional Benincasa-Dowker kernels, relabeling and scale covariance, function-level corrected pairing, and a varying-carrier intrinsic-probe convergence interface in `PhysicsSM/Draft/NullEdge/FiniteCausalOrderOperator.lean`; an executable 4D coordinate-probe calibration with a finite two-scale signature/variance window; Stage A2/A3 intrinsic-probe and support kills; an A3b max-clearance adjacent schedule; an A3c fixed-density larger-diamond control and guarded arbitrary-cardinality theorem that reject the global count shell as local support; and a Stage A4 Johnston interval-volume construction that conditionally recovers relabeling-covariant local charts while failing the frozen operator and emergent-dimension gates; relative count/scale controls; finite coframe, concrete `SL(2,C)` central-sign, quotient spin-obstruction, parallel transport, Cartan/commutator and component-contracted Bianchi, and Lichnerowicz geometry; a selected interval-count/effective-action dynamics route with Jacobson, spectral, and teleparallel comparisons; and a falsifiable G0-G8 ladder. Its guarded finite G3/G4/G5 theorem chain is `PhysicsSM/Draft/NullEdge/FiniteConnectionGeometry.lean`, with the torsionful companion in `PhysicsSM/Draft/NullEdge/FiniteCartanBianchi.lean`, explicit tensor contraction in `PhysicsSM/Draft/NullEdge/FiniteContractedBianchi.lean`, and conditional final Bianchi-to-source cancellation in `PhysicsSM/Draft/NullEdge/FiniteGravityConservation.lean`; it explicitly separates machine-checked finite algebra and embedding-based calibration from the still-open compact intrinsic probe carrier, dimensional selection, operator convergence, manifoldlike phase, and continuum Einstein-action bridge. [LIVE]
- `PhysicsSM/Draft/NullEdge/LorentzBivectorLieAlgebraBridge.lean` - exact convention bridge from the physical six-component `(12,13,23,01,02,03)` bivector fiber to the matrix Lorentz Lie algebra. It proves two-sided coordinate recovery and identifies the Krein product with `-1/2` times the generator trace pairing. This makes the nonlinear plaquette/face contraction type-correct; the action-curve successor closes differentiable variation, while Levi-Civita selection remains open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/LorentzPlaquetteTangent.lean` - exact nonlinear product/inverse response of group-valued Lorentz plaquette holonomy. It proves the four-corner adjoint formula, Lorentz Lie-algebra closure under eta-Lorentz links, and exact reduction to the oriented additive plaquette curl at identity transport. It is the guarded right-trivialized response used by the scalar action successor. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ProperLorentzExponential.lean`, `NonlinearLorentzPalatiniResponse.lean`, `NonlinearLorentzPalatiniAction.lean`, `NonlinearLorentzPalatiniCurveDerivative.lean`, `NonlinearLorentzPalatiniEuler.lean`, `NonlinearLorentzPalatiniCoframeVariation.lean`, `NonlinearLorentzPalatiniCurvatureExtraction.lean`, `NonlinearLorentzPalatiniEinsteinBridge.lean`, `NonlinearLorentzPalatiniEinsteinResponse.lean`, `NonlinearLorentzPalatiniCurvatureLimit.lean`, `NonlinearLorentzPalatiniVaryingCoframeLimit.lean`, `PhysicalLorentzPlaquetteRefinement.lean`, `PhysicalLorentzPlaquetteEinsteinAudit.lean`, `VacuumWeylCurvatureTarget.lean`, `VacuumWeylPeriodicRefinementAristotle.lean`, `PeriodicVacuumWeylMeanObstruction.lean`, `PeriodicVacuumWeylNullWave.lean`, `PeriodicVacuumWeylNullWaveProperLift.lean`, `PeriodicVacuumWeylNullWaveFullNoGo.lean`, and `PeriodicVacuumWeylNullWaveJointNoGo.lean` - exact six-coordinate nonlinear response, scalar ordered action `-1/2 tr(hat(B_ab)(H_ab-I))`, inverse orientation `H_ba=H_ab^(-1)`, holonomy-weighted product/inverse response, exact identity-link agreement with the coframe-derived Krein/additive theory, exact proper-Lorentz gauge invariance of the concrete coframe action, canonical invertible curves `U exp(t hat(delta A))` realizing every link variation, exact preservation of the proper eta-Lorentz subgroup along those curves, equality between ordinary action derivatives and the nonlinear response, exact four-family nonidentity local link Euler coefficients, supported component extraction, derivative stationarity iff all six local coefficients vanish, an ordinary coframe derivative with sixteen local coefficients, joint `6 + 16` stationarity, an exact rewrite as a Palatini pairing with the unique extracted antisymmetric six-component curvature field, the arbitrary-coframe determinant/scalar-curvature bridge, the exact response and stationarity-to-mixed-Einstein identities, a conditional action-visible curvature-limit passage to the mixed vacuum equation for jointly convergent varying coframes and curvature, a nonzero commuting-shift periodic-square realization with exact proper eta-Lorentz exponential links and plaquettes, a proof that global conformal rescaling cannot repair the square stationarity obstruction, a separate nonzero algebraic vacuum-Weyl target satisfying metric-lowered pair exchange, first Bianchi, and all identity-coframe vacuum equations, exact periodic mean/Bianchi no-go theorems ruling out site-independent and scalar-checkerboard additive realizations, and a periodically exact two-site null wave whose proper eta-Lorentz lift has exact vacuum-Einstein/coframe stationarity. The full null-wave coframe response has rank six with a complete ten-parameter kernel, and exact determinant/link identities rule out every invertible jointly stationary coframe while those links are fixed at nonzero area. The separate orthochronous sign, metric dual-cell weighting, Levi-Civita selection, graph-derived refinement/convergence proofs, construction of a nonflat nonlinear jointly stationary link/coframe backreaction witness, and identification of the limiting target with continuum Riemann curvature remain open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniWeakEinsteinLimit.lean` - finite weak-test and changing-carrier successor to the nonlinear Palatini chain. It proves exact equivalence among pointwise mixed Einstein equations, all finite test-tensor pairings, and coframe stationarity; proves the weighted counterpart for nonzero site volumes; and conditionally passes stationary refinements with changing finite carriers to a vanishing limiting weak functional. Actual weak convergence and continuum identification remain open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniLinearizedTorsionSelection.lean` - first P8(a) selection theorem for the independent connection sector. At the identity tetrad, all twenty-four linearized Palatini link coefficients vanish exactly when all twenty-four Cartan torsion components vanish. It also isolates the exact quadratic finite-spacing defect and passes shrinking identity-link stationary families with a fixed first coframe jet, on changing carriers, to zero torsion. Its successor removes the identity-tetrad restriction. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniGeneralTorsionSelection.lean` - arbitrary-invertible-tetrad P8(a) successor at identity link transport. Conjugated Hodge/exterior-square covariance reduces every coframe with a supplied inverse to the identity theorem, proving all twenty-four linearized connection coefficients vanish exactly when Cartan torsion vanishes. The finite `h L + h^2 Q` and changing-carrier fixed-jet endpoints extend to any fixed invertible center coframe; an explicit anisotropic background proves nonidentity applicability. Nonidentity links, full connection-dependent torsion, nonlinear Levi-Civita uniqueness, varying-jet control, and graph-derived refinement remain open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniAffineConnectionTorsionSelection.lean` - first connection-dependent P8(a) successor. It derives the Lorentz four-vector and Palatini bivector tangents, their Hodge commutation and Krein-skew sign, and identifies the arbitrary-invertible-tetrad linear connection equation with `de + omega wedge e = 0` under the predecessor convention. The finite affine residual is exactly `h L + h^2 Q - h^3 C`; a nonzero shrinking-spacing family forces zero covariant torsion, and a connection-generated coframe jet witnesses nonvacuity. Exact exponential links, agreement with the full nonlinear link Euler equation, nonlinear local uniqueness, varying jets, and graph refinement remain open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/PeriodicVacuumWeylLinearizedBackreaction.lean` and `Scripts/oracle/null_wave_linearized_backreaction.py` - exact identity-background Hessian successor to the fixed-link no-go. Lean proves all 48 link and 32 coframe equations for explicit curved plus-like and cross-like coupled perturbations and their full real span, proves that their curls are independent vacuum-Riemann directions, proves a flat injective 12-parameter local Lorentz family lies in the joint kernel, and proves that no nonzero plus/cross combination is gauge. The independent exact-rational oracle reports an 80-variable Hessian of rank 52 and nullity 28 with curvature image of rank exactly two on the complete kernel. Lean supplies the rank-two lower bound; the oracle still supplies the global upper bound excluding a third curvature direction elsewhere in the kernel. Nonlinear continuation, gauge-reduced propagation, Levi-Civita selection, and refinement convergence remain open. [DRAFT-LEAN/ORACLE]
- `PhysicsSM/Draft/NullEdge/LorentzCoframePalatiniFace.lean` and `FinitePeriodicCoframeKreinPalatiniVariation.lean` - explicit orientation-`0123` Lorentz Hodge star, internal coframe bivector `star(e_a wedge e_b)`, and the complementary curvature-face coefficient `(1/2) epsilon^(cdab) star(e_c wedge e_d)`. All six complement signs, ordered antisymmetry, proper-Lorentz Hodge commutation, covariance of both face fields, and exact specialization into the Krein link Euler/divergence equation are checked. Metric dual-cell volume weighting and Levi-Civita selection remain open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/RelativeScaleTetradBridge.lean` - guarded finite
  G2-G3-G4 composition of count-derived relative length, Weyl-Lorentz coframe
  transitions, and inverse-area holonomy-curvature normalization. Relative
  scales and supplied Lorentz transitions combine into an exact overlap
  cocycle; the sixteen-to-one witness gives transition `2 I` and metric/area
  factor four. Regions, coframes, Lorentz transitions, plaquettes, holonomies,
  and the global unit remain reconstruction inputs. [DRAFT-LEAN]
- `AgentTasks/overnight-null-information-run-2026-07-10/PAPER_I_NOVELTY_AUDIT_2026-07-10.md` - claim-by-claim priority/positioning audit: separates classical Pluecker and established tangent/successive-axis machinery from the defensible new synthesis, and corrects the Floquet `pi` mode to pseudo-doubler terminology. [LIVE]
- `Sources/Null_Edge_General_Audience_Manuscript_2026-07-09.tex` - illustrated general-audience companion, centered on null primitive motion, emergent timelike drift, stepped-time checkerboards, and visual explanations of aperture/closure/turn/soldering; technical qualifications are carried in footnotes and a formal-anchor appendix. [DRAFT-MS]
- `Sources/Null_Edge_Mass_Rank_Defect_Manuscript_2026-07-09.tex` - broad technical research-program manuscript: canonical null-edge mass invariant, information/concurrence dictionary, finite carrier square, positive Hodge decoder, exact checkerboard/tetrahedral dynamics, binding, protected modes, falsifiers, and build anchors. It remains a source/companion draft, not the focused Paper I lede. [DRAFT-MS]
- `Sources/Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md` - the ALL-mass manuscript (2026-07-08 overnight): every mass channel in null-edge terms, college-accessible Part I, grades throughout, anchor table. Companion to (not replacement for) the P1 draft. [DRAFT-MS]
- `Sources/Null_Edge_All_Mass_Literature_Review_2026-07-08.md` - related-work and novelty-gap review for the all-mass manuscript; close prior art and must-cite source-debt list. [LIVE]
- `Sources/Toward_a_complete_finite_null-information_theory.md` - verbatim Pro
  source essay expanding the carrier into a local operational process theory
  across QM, QFT, RG, phases, gravity, holography, and cosmology. It is an idea
  source, not a graded theorem inventory; use the Round-9 triage below for claim
  status. [SOURCE-ANALYSIS]
- `Sources/A_broader_physics_of_finite_null_information.md` - verbatim Pro
  information dictionary spanning charge, spin, fields, Higgs, locality,
  thermodynamics, and gravity, with eight proposed theorem lanes. [SOURCE-ANALYSIS]
- `Sources/A_moduli_theory_of_self-decoding_null_information.md` - verbatim Pro
  proposal to replace one carrier by a moduli/equivalence theory of decoders;
  includes chain homotopy, variational mass, recovery, Lambda, and monodromy
  targets. [SOURCE-ANALYSIS]
- `AgentTasks/overnight-allmass-run-2026-07-09/2026-07-10_PRO_complete-finite-null-information.md` - graded deduplication of the complete-process essay against landed modules and prior Pro rounds; records the four new finite jobs and the analytic/refinement targets deliberately deferred. [LIVE]
- `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft_v3.md` - P1 manuscript v3 (2026-07-07 rewrite for clarity/impact; college-accessible Part I; status map incl. carrier layer). [DRAFT-MS]
- `Sources/Null_Edge_P1_Origin_of_Mass_Manuscript_Draft.md` - P1 manuscript v2 (superseded by v3; retained for provenance). [HISTORICAL]
- `Sources/Null_Edge_Publication_Portfolio_2026-07-10.md` - active theorem-led publication order, gates, and venue strategy. [LIVE]
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md` - superseded June P1-P12 publication taxonomy, retained for provenance. [ARCHIVE]
- `Sources/Null_Edge_Publication_Outlines_2026-07-07.md` - five Letter-caliber outlines (P13, P2-R, P14, P4-R, P15 + future slots). [LIVE]
- `Sources/Ontology_extensions.md` - graded steer memo (teleparallel E-slot, positivity routes, index/spectral-action framing); integrated 2026-07-07. [STABLE]
- `Sources/Null_Edge_Program_Charter_2026-07-07.md` - the post-audit program charter (U0-U5 claim ladder, amendments, declared losses, kills). [LIVE]
- `Sources/Null_Edge_QCD_Mass_Roadmap_2026-07-07.md` - the closure-channel endgame: staged path (S1-S7) from the pinned strong-coupling stack to mass from QCD, with claim ceilings and the Clay boundary named. [LIVE]
- `AgentTasks/fable_parallel/Q01_answer.md` - positivity crux solved to its
  boundary at memo level; the finite Kugo-Ojima witness/no-go is now
  kernelized in `KreinPositiveSectorWitness`, while the carrier-level
  `dim(V'/N) = ind(D)` wiring remains an open theorem target. [STABLE]
- `PhysicsSM/Draft/NullEdge/Carrier/PositiveHodgeDecoder.lean` - explicit finite
  Hodge representative theorem, positive non-exact harmonic class with separate
  spectral mass, and matched negative-sign no-go; generic finite Hodge
  generalization now lives in `GenericFiniteHodge`. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/Carrier/GenericFiniteHodge.lean` - generic finite
  Hilbert-Hodge theorem for nilpotent differentials: unique harmonic
  representatives modulo exact vectors and compatible decoder descent.
  [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/Carrier/KreinHodgeNoGo.lean` - exact `2x2`
  counterexample showing that a nilpotent Krein-self-adjoint charge can have
  zero Krein Laplacian, trivial cohomology, and harmonic vectors that are not
  closed. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/Carrier/DecoderChainHomotopy.lean` - finite decoder
  moduli core: exact presentation shifts `D -> D+QR+RQ`, cross-carrier
  intertwining `D'U-UD=Q'R+RQ`, induced cohomology-action invariance, and an
  explicit distinct positive-decoder witness. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/Carrier/DecoderModuliClassification.lean` - complete
  moduli classification for the live three-state positive-Hodge carrier:
  every decoder commuting with `Q=E01` has a five-coordinate normal form, the
  four zero-physical coordinates are exactly `Q R + R Q` gauge, and `D 2 2` is
  a complete invariant with canonical representatives and nondegenerate
  same-mass/different-mass controls. Universal carrier classification remains
  open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ChannelShearModuli.lean` - first exact moduli result
  for the four-channel classification program: a faithful additive
  determinant-one rational shear family preserves the total of three ordered
  even channels and every linear type submodule, while a nonzero middle
  channel makes distinct shear parameters give distinct refinements. This is
  a residual type-compatible subgroup. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ChannelRefinementTorsor.lean` - full type-only
  affine-fibre classification: after choosing any base refinement with fixed
  total, every ordered three-channel refinement is reached by a unique
  zero-sum admissible shift. A nonzero admissible direction proves the fibre
  is non-singleton. The physical selector-preserving quotient remains open.
  [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ChannelSelectorUniqueness.lean` - conditional
  uniqueness theorem for channel refinements: two internal decompositions
  carrying the same pair of sign gradings with four distinct joint eigenvalues
  coincide. The theorem does not derive the second grading from the carrier;
  locality, edge exchange, word degree, positivity, and information
  monotonicity remain candidate intrinsic selectors. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ChannelNaturalityNoGo.lean` - maximal-symmetry
  selector obstruction: every score invariant under all translations of an
  additive torsor is constant, and a nontrivial type-only refinement torsor
  admits no uniquely preferred refinement defined by a fully invariant
  predicate. A successful selector must break the residual symmetry or justify
  a smaller physical quotient. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ChannelSelectorRigidity.lean` - exact additive
  selector criterion: a homomorphic selector rigidifies the full fixed-total
  refinement fibre iff it is injective on zero-sum shifts. A nonzero rational
  ambiguity direction injects `Q`, so no finite-valued additive selector can
  rigidify that fibre. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ChannelSelectorDescent.lean` - exact source-to-
  representation intrinsicality gate: kernel preservation is necessary for
  selector descent and, under surjective evaluation, sufficient with a unique
  descended selector; includes the killed-relation obstruction. This is
  generic quotient infrastructure, not a live physical selector. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ChannelSelectorQuotient.lean` - exact generic
  quotient by a supplied selector kernel, with class equality equivalent to
  selector indistinguishability and canonical equivalence to the selector
  range. Standard first-isomorphism infrastructure; no selector is thereby
  made physical. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ChannelSolderDegreeNoGo.lean` - live
  presentation-dependence kill for raw solder degree: the nonzero represented
  word `P=c1*c1#` is idempotent, so degree-two and degree-four presentations
  coincide and no additive represented selector can read both degrees.
  [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ChannelTraceSelectorNoGo.lean` - intrinsic
  represented-selector boundary: componentwise matrix trace is
  conjugation-invariant but blind to an explicit nonzero trace-zero zero-sum
  shear, so it cannot rigidify the complete fixed-total fibre. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ChannelQuadraticSelectorFamily.lean` - exact
  variational selector family: every positive diagonal quadratic channel cost
  has a unique weighted-barycentric minimizer, while two explicit positive
  metrics select different decompositions of the same nonzero total. This
  proves selection after choosing a metric, not a canonical physical metric.
  [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ChannelQuadraticInnerLift.lean` - exact lift of the
  weighted selector theorem to arbitrary real inner-product channel spaces:
  completion of squares, sharp lower bound, global unique minimizer, and
  metric-disagreement control. The inner product and weights are supplied,
  not physically derived. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ChannelKreinMetricNoGo.lean` - exact positive-metric
  obstruction on the live carrier: a nonzero chirality-even,
  Krein-self-adjoint matrix has adjoint-induced self-pairing `-2`, so
  `trace(A# B)` is not positive semidefinite on the retained even self-adjoint
  sector. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ChannelKreinSectorSignature.lean` - exhaustive
  normal-form and signature classification of the live even
  Krein-self-adjoint rational carrier sector: six unique coordinates with four
  positive and two negative square directions. It does not derive which
  positive subspace is physical. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ChannelCommutatorSelectorClassification.lean` -
  structural scalar-selector theorem on the live represented carrier: every
  rational-linear functional annihilating all commutators is a scalar multiple
  of trace and therefore noninjective, with an explicit nonzero trace-zero
  witness. Nonlinear, vector-valued, spectral, locality, positivity, and
  information selectors remain outside its scope. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/HalfWindingFieldPositionClassification.lean` -
  exhaustive 16-field four-site compression classification and exact
  same-derived-winding counterexample. Winding/wall count alone does not
  determine the signature; the repaired finite criterion also requires wall
  position relative to reflection-fixed sites. Compressed-sector no-mode is
  not promoted to a complete-walk, topological, or stability claim.
  [DRAFT-LEAN]
- `AgentTasks/overnight-publication-run-2026-07-11/FOUR_CHANNEL_CLASSIFICATION_PROGRAM.md`
  - active Paper F program separating the exact chosen four-term carrier-square
  expansion, the canonical chirality odd/even split, residual even-sector
  moduli, and the additional selector problem. [LIVE]
- `AgentTasks/overnight-publication-run-2026-07-11/PAPER_F_MANUSCRIPT_ARCHITECTURE_2026-07-11.md`
  - negative-classification manuscript architecture: theorem spine, abstract,
  section order, nearest-work confrontation, publication fork, and prohibited
  upgrades. The stronger positive-selector route remains separate. [LIVE]
- `AgentTasks/overnight-publication-run-2026-07-11/HELP_NEEDED_2026-07-11.md`
  - standalone collaborator brief ranking the seven hardest remaining bridges:
    decomposition equivalence, operational phase consequences, strict `3+1`
    locality, changing-lattice convergence, the corrected defect invariant,
    geometric many-body causality, and nonzero scale selection. Each ask records
    the landed frontier, closure criterion, kill condition, and misleading
    routes already excluded. [LIVE]
- `AgentTasks/overnight-publication-run-2026-07-11/PRO_RESPONSE_DISPOSITION_2026-07-11.md`
  - implementation disposition of Pro's blocker response: endomorphism-
    cohomology quotient, free phase-defect and reflection-index handoff to
    Fable, sequential-to-layer CAR successor, low/high continuum synthesis,
    homogeneous scale-selection no-go, and Laurent-unit resource theorem.
    External formulas and citations remain proposals until independently
    checked and kernel-transcribed. [LIVE]
- `PhysicsSM/Draft/NullEdge/ChannelPositiveSectorModuli.lean` - guarded exact
  rational Krein boost producing a second injective positive four-coordinate
  family, with norm preservation and an explicit norm-one member outside the
  diagonal family. This proves represented positive-sector nonuniqueness, not a
  physical selector or full Grassmannian classification. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ChannelPositiveComplementDisk.lean` - guarded
  rational open-disk classification of positive complements containing the
  three named even channels, with unique disk coordinate/nonzero scale, strict
  interior, and null-boundary controls. No physical disk point or final
  carrier/gauge quotient is selected. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ChannelPhysicalCohomology.lean` - guarded finite
  contraction theorem: a chain map has zero induced physical action exactly
  when it is null-homotopic, and every physical endomorphism has an explicit
  lift. The rational witness/control triple proves nonvacuity and that the
  chain-map condition is load-bearing. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/Carrier/WardPhysicalCohomology.lean` - guarded
  instantiation of the contraction theorem on the existing positive
  Ward/descent witness. Its explicit charge, reverse-arrow contraction, and
  one-dimensional physical inclusion/projection satisfy the full contraction
  packet; zero physical action is exactly null homotopy and every physical
  endomorphism lifts. Derivation from the full null-edge carrier,
  finite-range homotopies, and the full carrier-automorphism quotient remain
  open.
  [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/Carrier/PhysicalHomotopyLocality.lean` - guarded
  finite-range theorem for the explicit cohomological homotopy. Matrix ranges
  add under composition; `S*X+(P*X)*S` and `Q*H+H*Q` have displayed radius
  budgets. An exact path witness attains distance two, while a distant
  projector control violates radius one. Full-carrier derivation of local
  contraction/projector data remains open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/Carrier/WardAutomorphismQuotient.lean` - guarded
  complete coordinate classification of charge-commuting, Krein-form-
  preserving automorphisms of the finite positive Ward witness. Physical
  compression is exactly the final coordinate; physical-identity maps are
  constraint-exact. Includes a nonidentity exact shear and a physical phase
  that is provably non-exact. The initially proposed `U^*G*U=1` condition is
  explicitly refuted and corrected to `U^*G*U=G`. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/PluckerMassOperator.lean` - general two-spinor
  centerpiece for the focused Paper I draft: the complex Pluecker coordinate
  defines an odd Hermitian rest operator whose square is the momentum
  determinant; includes the exact Dirac square, phase covariance, and
  collinear gap-closing theorem. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/FullBlochSplitDeterminants.lean`,
  `FullBlochSplitPlus.lean`, and `FullBlochSplitMinus.lean` - exact
  all-momentum `4x4` determinant formulas for the live ordered successive-axis
  walk at Floquet eigenvalues `+1` and `-1`, with an explicit definitional
  bridge to `Compact3Plus1DiracRate.splitStep` and the body-center simultaneous
  zero control.  These are spectral criteria, not an alias-free regulator.
  [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/FullBlochZeroClassification.lean` - complete
  zero- and pi-quasienergy crossing classification for the principal massive
  branch of the live ordered split walk: both determinant polynomials vanish
  exactly at the simultaneous body-center cosine locus. Includes the
  `cos(theta)=0` extra-zero boundary control. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/CommutatorWilsonStrictnessKill.lean` - exact
  family-scoped locality obstruction for a proposed commutator-Wilson repair:
  integer Fourier frequencies are strict finite range but make the zone-edge
  gate trivial and retain all three even-corner aliases; the noninteger
  rational-Pythagorean de-aliasing certificate is therefore nonlocal.
  [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/PluckerMassDynamics.lean` and
  `CornerWalkEquivalence.lean` - explicit rest eigenvectors, decomposition
  independence, exact mass-coin group law, and the finite `cos^n` checkerboard
  kernel scaling with corner ratio `-i tan(a mu)`. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/FermionDoublingAudit.lean` - exact massless
  `{0, pi}` band-touching set, massive discriminant bound, and the Floquet
  zone-edge partner audit for the focused `1+1` walk. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/Compact3Plus1DiracRate.lean`,
  `Compact3Plus1RefinedWindowRate.lean`,
  `Local3Plus1RateBridge.lean`, `FiniteWalkPositionConvergence.lean`,
  `FiniteZModPlancherel.lean`, `Finite3Plus1FourierBridge.lean`,
  `Finite3Plus1AnalyticSignBridge.lean`, `FiniteTorus3Plancherel.lean`,
  `FiniteTorus3WalkWavepacket.lean`, `Finite3Plus1BrillouinAudit.lean`,
  `ContinuumL2MultiplierBridge.lean`, `CompactSupportL2WalkBridge.lean`,
  `FiniteWalkOnsiteEquivalenceObstruction.lean`, `LocalQCAProperties.lean`,
  `StationaryAmplitudeNoGo.lean`, `StationaryAmplitudeLiveAxisNoGo.lean`,
  `WilsonDiracRegulator.lean`, `FloquetDeterminantCriterion.lean`, and
  `CountableL2WavepacketConvergence.lean` -
  exact finite local `3+1` norm preservation, ordered x/y/z/mass symbol,
  compact-box `O(1/n)` rate and a refined `3+1` many-step bound retaining
  `exp(|t| B4/n)` rather than `exp(B4)`, finite Fourier-kernel lifts in `1+1`
  and `3+1`,
  exact vector-valued one-axis and product-three-torus
  Plancherel/wave-packet bounds, exact
  finite-character blocks on every product plane wave, the finite-to-analytic
  negative-momentum conversion with a quarter-zone sign control, an explicit
  two-sided local-cycle inverse and strict causal cone, the exact eight-corner
  parity/alias classification, explicit massive body-center `+1` and `-1`
  eigenmodes for every mass angle, an onsite-equivalence obstruction, the
  degree-one Laurent no-go forcing a stationary amplitude to vanish under
  origin normalization, exact all-momentum unitarity, and a full involutory
  tangent, its three direct
  specializations to the live axis generators, the Wilson--Dirac scalar square,
  uniform massive Hamiltonian gap, and massless zero-set theorem removing all
  non-origin cubic corners at the local-Hamiltonian level, generic exact
  determinant-zero criteria for nonzero `+1` and `-1` Floquet modes, and a
  countable Tannery `L2` theorem, plus the measure-theoretic theorem that a
  vanishing uniform relative multiplier bound forces `L2` convergence, and its
  walk-specific compact-support specialization with explicit `O(1/n)` envelope.
  Completing the changing-lattice/continuum Fourier and PDE identification,
  extending beyond compact support, and converting the Wilson spectral repair
  into a strictly finite-range discrete-time regulator remain open.
  [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/Pluecker3Plus1ComplexMass.lean` - phase-retaining
  four-component Pluecker rest operator in the live Clifford representation;
  proves Hermiticity, `mass4(z)^2 = |z|^2 I`, the complete relativistic square,
  real-axis reduction, chiral phase covariance, and the exact unitary
  one-parameter mass-coin group law, with a `3+4i` control.
  `ComplexPlueckerLocalWalk.lean` inserts that coin into the actual finite local
  walk and proves exact norm preservation and plane-wave-sector invariance.
  `VariablePlueckerLocalWalk.lean` promotes the Pluecker coordinate to an
  arbitrary position-dependent field, including collinear zero sites, and
  proves exact norm preservation, a two-sided inverse, a strict one-cycle
  causal cone, constant-profile reduction, and local collinearity control.
  `VariablePlueckerPhaseConnection.lean` proves exact covariance under a
  site-dependent chiral phase, identifies the induced endpoint link on every
  Clifford shift, and factors the full conjugated walk into linked spatial
  shifts plus the pointwise-rotated Pluecker field without choosing an
  argument branch at zero sites.
  `ComplexPlueckerCheckerboardPathSum.lean` assigns each directed history edge
  the corresponding entry of the actual complex Pluecker mass coin and proves
  the full orientation-sensitive path sum equals its transfer power; a
  `3+4i` control separates the nonzero `z` and conjugate-`z` turn factors.
  `GlobalPhaseWindingNoGo.lean` proves that a globally lifted real phase has
  zero total increment on a finite periodic cycle, so nonzero winding requires
  branch, patch-transition, or independent link data; an explicit three-link
  periodic field has winding one and is proved not to be the raw increment of
  any global real vertex phase.
  `ChiralFlipMode.lean` supplies the generic finite protection engine for a
  chiral unitary matrix: conjugation-closed unimodular characteristic roots
  give `det W = (-1)^mult(-1)`, so determinant `-1` forces an exact `-1`
  eigenvector and, in even dimension, an exact `+1` partner.  A nontrivial
  sigma-x witness and identity control prevent a vacuous sign argument.  A
  `SignWallDefectRouteB.lean` supplies the next conditional composition: an
  isometric invariant-sector compression inherits chirality and unitarity, and
  compressed determinant `-1` lifts a nonzero reflection-even flip mode to the
  full register.  The sector embedding and determinant sign are still
  hypotheses; the concrete spinor-derived wall instantiation is a separate
  gate.  Some control/assigned-wall declarations in that draft module use
  documented compiled evaluation, while the Route-B headline declarations
  carry standard-axiom pins in `OvernightTheoryAxiomGuard.lean`.
  `StrictQCAMinimalArchitecture.lean` proves a scoped architecture lower bound:
  no three-axis four-channel range-one single-factor Laurent QCA can retain the
  exact live Dirac tangents and exact all-momentum unitarity while adding a
  nonzero stationary Wilson-like channel.  Exact zero-stationary factors and a
  noninvolutory-tangent escape witness establish nonvacuity and the first
  viable relaxation.  The stronger even-corner theorem proves all three
  even-parity zone corners exactly alias the origin after any momentum-
  independent onsite coin, including the complex Pluecker mass coin.
  `LaurentUnitResource.lean` proves the cross-architecture one-dimensional
  ring precursor: every unit Laurent polynomial over a field is a nonzero
  scalar times a unique monomial, every genuine two-term polynomial is a
  nonunit, and the determinant of an invertible finite Laurent matrix is a
  unique monomial. This is a strict-QCA resource theorem at ring level, not a
  `3+1` no-doubling theorem or physical index identification.
  `LaurentFlowIndex.lean` packages that unique determinant exponent as an
  additive invariant under matrix composition, proves identity exponent zero
  and pure-shift normalization, and gives a one-channel two-shift
  noninvertibility control. It remains an algebraic one-variable precursor,
  not yet a physical GNVW-index or `3+1` theorem.
  `PlueckerPhaseDefectSpectrum.lean` proves an exact symbolic two-site
  free-carrier phase-defect polynomial, its equal-modulus hypothesis control,
  zero-gap locus, and common-phase conjugacy. It establishes phase-sensitive
  spectral data in that finite Hamiltonian, not topological protection or a
  localized interacting defect.
  `Carrier/PluckerScaleSelectionNoGo.lean` proves the landed positive Pluecker
  action is quartic under common primitive-spinor scaling and has no nonzero
  stationary scale whenever the unscaled action is positive; an exact
  orthogonal-spinor witness has action `1/2`.  Selecting a nonzero mass thus
  requires a competing homogeneity, constraint, ensemble scale, or additional
  dimensionful input; the exact potential `(t^2-c)^2` is the positive control,
  selecting nonzero minima only after the scale `c` is supplied.
  `FiniteHomogeneousScaleNoGo.lean` proves the generic radial theorem behind
  that example: any positive finite action with exact positive-natural-degree
  homogeneity has strictly positive unit-scale radial derivative and therefore
  no stationary nonzero scale.  Degree zero is the flat boundary control, and
  an exact quartic unit witness has derivative four.  The theorem does not
  exclude dimensional transmutation in a refining family with running
  dimensionless couplings.
  `BareGraphScaleReconstruction.lean` now separates relabeling symmetry from
  physical identifiability. Positive invariant data remain closed under
  global rescaling, while the sharper observation-level theorem proves that a
  scale-blind bare observation cannot exactly reconstruct a positive
  Weyl-weight-one target across a nonunit rescaling. The theorem has an
  explicit constant-observation witness and does not derive a continuum
  realization map, density, or coframe. `RelativeGraphScaleReconstruction.lean`
  then proves the density-free relative four-dimensional Weyl profile from
  positive counts and supplied representative volumes. [DRAFT-LEAN]
  `OneLoopDimensionalTransmutation.lean` proves the complementary unit-
  covariance boundary: simultaneous rescaling of reference and invariant
  scales leaves the running dimensionless coupling unchanged and rescales the
  generated scale linearly. It does not derive the beta function, physical
  coupling, reference unit, or measured scale. [DRAFT-LEAN]
  `TemporalBlockingRG.lean` defines exact two-step temporal blocking, proves
  closure of the mass-only Pluecker subgroup, gives an exact x-y quarter-turn
  counterexample to closure of the scalar-parameter split family, and
  identifies the generated submonoid as the canonical smallest
  multiplicatively closed enlargement.
  `FiniteCARFockBasic.lean` defines the occupation-basis fermionic Fock space
  over any linearly ordered finite-mode label type and proves creation and
  annihilation nilpotency plus all same-mode and distinct-mode canonical
  anticommutation relations.  It is the algebraic first rung toward a local
  second-quantized Pluecker walk; the determinant-minor lift begins in the next
  module, while its full covariance and inherited locality remain targets.
  `FiniteCARSecondQuantization.lean` defines the determinant-minor exterior
  lift `Gamma(U)` for every finite one-particle matrix, proves vacuum and exact
  one-particle agreement, conserves particle number and parity, proves the
  full creation-operator covariance identity by ordered-minor Laplace
  expansion, and proves the exact exterior-functor laws
  `Gamma(1) = 1` and `Gamma(UV) = Gamma(U) Gamma(V)`, together with
  conjugate-transpose compatibility for every ordered-minor coefficient and
  the exact two-sided inverse law for a one-particle unitary.  It also proves
  the corresponding Fock adjoint identity and exact preservation of the finite
  occupation-basis Hermitian inner product. `CARAnnihilationLocality.lean`
  adds exact creation/annihilation adjointness, annihilation covariance for
  every complex one-particle matrix, and relation-filtered coefficient-support
  laws on both creation and annihilation. These are finite algebraic support
  statements, not a Lieb--Robinson bound or interacting causal cone.
  `PlueckerQuarticInteraction.lean` gives an explicit four-mode quartic
  pair-transfer observable: its forward two-particle amplitude is the primitive
  spinor wedge `z`, its reverse amplitude is `conj z`, and a `3+4i` primitive
  fixture proves orientation sensitivity that a norm-only free gap cannot see.
  Its associated normalized phase-weighted pair kick is complex-linear,
  exactly involutive, and preserves the full finite occupation-basis inner
  product; it is packaged as an explicit complex-linear equivalence.  The
  quartic operator is Hermitian on the full finite Fock space,
  and the kick equals that operator on
  the distinguished pair sector while acting as the identity off it; both
  nontrivial actions are confined to that rank-two block.  At unit phase the
  quartic square is exactly the pair-sector projector, giving its minimal
  finite dynamical polynomial.  The
  kick fixes every one-particle occupation basis state but is nontrivial on the
  two-particle witness. `PlueckerPairKickNonQuasiFree.lean` proves that no
  one-particle matrix has determinant-minor lift equal to this kick: singleton
  agreement forces the matrix to be the identity, which contradicts the exact
  pair action. This is
  a finite unitary two-particle witness, not yet an operator-exponential theorem,
  a second-quantized local walk, or a continuum field theory.
  `PlueckerCausalCone.lean` places that same pair operation on an arbitrary
  embedded four-mode block as an even quartic CAR polynomial. It proves exact
  disjoint-block commutation, unit-phase involutivity, a nonzero phase-transfer
  witness, and finite scheduled support propagation in the strong even-CAR sense: supported
  operators commute with every creation and annihilation generator outside the
  declared region. Its weaker occupation-transition footprint is retained only
  as infrastructure and is explicitly not a locality definition. The result is
  finite and schedule-level. `PlueckerGeometricCone.lean` adds a genuine
  graph-neighborhood theorem: under a reflexive neighborhood and a
  `BlockLocal` hypothesis on every sequential gate, strong CAR support lies in
  the corresponding iterated ball.  It includes a contiguous nontrivial block
  and an explicit far block failing locality. `PlueckerLayerCone.lean` upgrades
  this to circuit layers: pairwise-disjoint local gates consume one
  neighborhood expansion per layer, so a schedule is bounded by its layer
  depth rather than its gate count. The result does not prove sharpness,
  Hilbert-space unitarity, free-walk composition, an operator exponential,
  scattering, a continuum limit, or a higher-dimensional Jordan--Wigner
  theorem.
  `PlueckerQuarticNotOneBody.lean` adds the matching generator-level boundary:
  every standard number-preserving one-body CAR generator has zero matrix
  element between the displayed disjoint pairs, while the Hermitian Pluecker
  quartic transfer has the exact nonzero unit-phase element. This remains a
  fixed four-mode certificate, not a spatial-locality or scattering theorem.
  `ChangingLatticePDECore.lean` proves the exact `L2` bulk-plus-ultraviolet-tail
  bound needed to wrap fixed-space multiplier convergence in a genuine
  changing-lattice sampling/interpolation theorem, and proves that the `L2`
  tail outside measurable monotone bands vanishes when those bands exhaust
  frequency space.  Their composition proves abstract global `L2` convergence
  whenever the in-band multiplier error tends to zero.
  `ChangingModeEmbedding.lean` supplies a concrete coefficient-space layer:
  restriction from common `Z^3` modes to `[-N,N]^3`, literal zero-padding back,
  exact finite/common-space energy equality, nested exhaustion, and strong
  square-summable tail convergence with zero-mode and outside-box controls.
  `SobolevTailRate.lean` strengthens that layer quantitatively: finite weighted
  mode energy of order `s` bounds the squared cutoff residual by
  `(N+2)^(-s)`, with a nonzero just-outside-face delta control.
  Scaled finite-torus/continuum Fourier isometries and the final position-space
  PDE identification remain successor gates.
  `Finite3Plus1ProductDFTCore.lean` proves the exact positive-character product
  harmonic analysis used by the live finite walk: unit-modulus plane waves,
  row and column orthogonality for every nonzero torus size, and cancellation
  of the exact `1/sqrt(siteCard)` normalization.
  `LiveDFTComposition.lean` composes that core into exact normalized
  forward/inverse transform round trips, Parseval, finite-sum and local-step
  linearity, the transform of a single plane-wave mode, a complete finite mode
  expansion, and exact conjugacy of the live local step to its finite momentum
  character block. `Finite3Plus1AnalyticSignBridge.lean` closes the convention
  gate exactly: the finite block equals the analytic ordered block at the
  negative lattice angle, with a nonzero quarter-zone sign fixture. The live
  DFT module also proves the exact inverse-transform factorization and the
  all-finite-time symbol-power law.
  `Finite3Plus1FourierBridge.lean` additionally proves that every character
  phase diagonal, every conjugated axis block, and the full ordered
  axis/axis/axis/mass character block are exactly unitary for arbitrary real
  mass and step parameters.
- `Scripts/sim/null_edge_regulator_benchmark.py` and
  `AgentTasks/null-edge-so-what-closure-2026-07-10/HELD_OUT_REGULATOR_BENCHMARK.md`
  - pre-registered high-momentum benchmark of the exact even-corner alias
  theorem, body-center modes, and Wilson corner gap, with an unregulated
  negative control and fixed kill thresholds. [ORACLE]
  `ComplexPlueckerRateTransfer.lean` proves Hamiltonian/flow conjugacy, equality
  of the conjugacy-defined and explicit complex steps, and the uniform
  complex-phase compact rate. [DRAFT-LEAN]
- `Scripts/experiments/causal_operator_metric.py`,
  `Scripts/experiments/test_causal_operator_metric.py`, and
  `AgentTasks/null-edge-causal-operator-metric-stage-a-benchmark-2026-07-15.md`
  - external 4D Minkowski sprinkling calibration of the corrected
  Benincasa-Dowker operator pairing, with explicit source/project signature
  conversion, compact calibration probes, affine-covariance controls, density
  and nonlocality-scale sweeps, and pre-registered successor/kill conditions.
  This is positive evidence for a finite metric-recovery window, not intrinsic
  reconstruction from a bare order. [ORACLE]
- `Scripts/experiments/causal_intrinsic_probe_metric.py`,
  `Scripts/experiments/causal_interior_support_scan.py`,
  `Scripts/experiments/causal_adjacent_scale_availability.py`,
  `Scripts/experiments/causal_larger_diamond_support.py`, and the Stage
  A2/A3/A3b/A3c benchmark notes under `AgentTasks/` - order-only construction
  audits for intrinsic causal-operator metric probes. Stage A2 kills profile
  PCA, raw lowest singular modes, and fixed normal smoothing; Stage A3 confirms
  their retarded-support failure and records every proposed interior/shell tuple.
  Stage A3b proves analytically when its max-clearance three-scale schedule fits
  between `ell` and `L`: the hierarchy and common interior are recovered above
  `N > 743.239`. Stage A3c holds all local scales fixed and finds rank-capable
  mark rates rising from `1.93%` to `36.97%` over a fourfold volume increase,
  then `50.85%` at exploratory volume eight. The growth diagnoses an infrared
  boundary cutoff rather than local convergence and kills the global shell as
  a probe carrier; a compact Alexandrov germ remains open. [ORACLE]
- `Scripts/experiments/causal_johnston_probe_metric.py`,
  `Scripts/experiments/test_causal_johnston_probe_metric.py`, and
  `AgentTasks/null-edge-johnston-probe-stage-a4-benchmark-2026-07-15.md` -
  clean-room interval-volume lightcone embedding after Johnston
  (arXiv:2111.09331v2). With dimension, density, endpoints, and rank three
  supplied, it recovers relabeling-covariant local probe charts whose
  high-density metric error approaches the coordinate control. The frozen
  operator-error and emergent-rank gates both fail, so this is a conditional
  reconstruction result rather than a bare-order G2 pass. [ORACLE]
- `Scripts/experiments/causal_johnston_operator_control_scan.py`,
  `Scripts/experiments/test_causal_johnston_operator_control_scan.py`, and
  `AgentTasks/null-edge-johnston-operator-stage-a5-benchmark-2026-07-15.md` -
  coordinate-only operator-window selection at order-selected pivots followed
  by a held-out Johnston test. All frozen per-realization flat-space gates
  fail. A target-fitted scalar reveals a good ensemble conformal shape but
  cannot repair absolute normalization or eventwise concentration, so curved
  benchmarks remain blocked by the flat operator control. [ORACLE]
- `PhysicsSM/Draft/NullEdge/CausalMetricFirstJet.lean` - guarded finite
  coordinate-derivative identity: a supplied inverse metric and exact corrected
  principal-symbol pairing recover the target first jet by lowering an index,
  with exact invariance under scalar zeroth-order potentials. This is a
  conditional algebraic bridge, not a construction of probes, charts, or the
  metric. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/CausalLeviCivita.lean` - guarded componentwise
  recovery of metric first jets followed by the standard finite Christoffel
  construction. Exact inverse and metric-jet symmetry premises imply coordinate
  torsion-freeness and metric compatibility. This closes the finite algebraic
  interface while leaving probe, atlas, invertibility, and convergence premises
  open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/FiniteCausalOrderOperator.lean`,
  `Scripts/experiments/causal_johnston_operator_control_scan.py`, and
  `AgentTasks/null-edge-intrinsic-quadratic-normalization-stage-a6-benchmark-2026-07-15.md`
  - kernel-checked centered-product identity and its interval-volume
  quadratic-moment calibration. The exact identity lands, but the tested
  single-interval estimator is biased, frequently nonpositive, and has zero
  development or held-out normalization-gate passes. This is a scoped
  estimator kill, not count-derived scale reconstruction. [DRAFT-LEAN/ORACLE]
- `Scripts/experiments/causal_johnston_quadratic_probe.py`,
  `Scripts/experiments/test_causal_johnston_quadratic_probe.py`, and
  `AgentTasks/null-edge-johnston-quadratic-normalization-stage-a7-benchmark-2026-07-15.md`
  - two-stage validation of the basis-gauge-invariant Johnston Lorentzian
  quadratic followed by a trace-normalization test. The quadratic reaches 100%
  held-out probe passes at `N=10000` and is retained; single-row `Bq=8`
  rescaling worsens held-out metric errors and is killed. Conformal-shape
  averaging, dimension selection, and count-volume agreement remain open.
  [ORACLE]
- `Scripts/experiments/causal_johnston_multirow_metric.py`,
  `Scripts/experiments/test_causal_johnston_multirow_metric.py`, and
  `AgentTasks/null-edge-johnston-multirow-metric-stage-a8-benchmark-2026-07-15.md`
  - common-chart averaging of order-selected nearby operator rows, with
  scale-free shape scored before the independently validated Johnston trace.
  Sparse averaging gives a paired reduction in pulled metric error but misses
  the held-out gate; broader strict-past neighborhoods collapse to
  negative-definite averages. This retains a variance-reduction clue while
  killing the current one-sided averaging rule. [ORACLE]
- `Scripts/experiments/causal_johnston_full_embedding.py`,
  `Scripts/experiments/causal_johnston_full_multirow_metric.py`, their tests,
  and
  `AgentTasks/null-edge-johnston-full-chart-stage-a9-benchmark-2026-07-15.md`
  - clean-room Johnston 2025 full-interval spatial-distance completion and
  MDS, followed by genuinely two-sided operator-row averaging. The frozen
  held-out coordinate controls close both flat metric gates, and direct chart
  components are Lorentzian, but local coordinate pullback and emergent-rank
  gates fail. This advances G2 from operator concentration to local-atlas and
  chart-transition convergence without claiming covariant metric recovery.
  [ORACLE]
- `Scripts/experiments/causal_johnston_local_atlas_metric.py`,
  `Scripts/experiments/test_causal_johnston_local_atlas_metric.py`, and
  `AgentTasks/null-edge-johnston-local-atlas-stage-a10-benchmark-2026-07-15.md`
  - overlapping Johnston lightcone charts with order-derived pairwise spatial
  registration, explicit chart-availability and cocycle gates, and transported
  row metrics kept closed behind those gates. Local coordinate controls and
  higher-density cocycles improve, but the frozen transition gate has zero
  `N=4000` passes. This kills independent pairwise Procrustes registration at
  current density and points to simultaneous chart synchronization. [ORACLE]
- `Scripts/experiments/causal_johnston_synchronized_atlas.py`,
  `Scripts/experiments/test_causal_johnston_synchronized_atlas.py`, and
  `AgentTasks/null-edge-johnston-synchronized-atlas-stage-a11-benchmark-2026-07-15.md`
  - overlap-weighted connection-Laplacian synchronization of every available
  local Johnston spatial frame. It makes transition cocycles exact to
  roundoff and lowers held-out synchronization mismatch, but common-event
  geometry and chart availability still fail the frozen atlas gate. This kills
  frame synchronization alone and moves the next test to a shared latent
  overlap geometry or revised multi-anchor chart. [ORACLE]
- `Scripts/experiments/causal_johnston_latent_affine_atlas.py`,
  `Scripts/experiments/test_causal_johnston_latent_affine_atlas.py`, and
  `AgentTasks/null-edge-johnston-latent-affine-atlas-stage-a12-benchmark-2026-07-15.md`
  - order-only causal-depth filtering followed by a pivot-anchored shared
  affine latent atlas. The filter repairs the observed chart-availability
  defect and is retained; stable affine consensus still fails common-event
  geometry, while unregularized improvements are nonconvergent and can collapse
  spatial directions. This kills further gauge-only repair and points to a
  revised multi-anchor coordinate construction. [ORACLE]
- `Scripts/experiments/causal_johnston_multi_anchor_atlas.py`,
  `Scripts/experiments/test_causal_johnston_multi_anchor_atlas.py`, and
  `AgentTasks/null-edge-johnston-multi-anchor-atlas-stage-a13-benchmark-2026-07-15.md`
  - count-derived local Alexandrov intervals followed by separate full
  Johnston distance completion and MDS in each interval. Larger intervals fix
  availability and overlap coverage but strongly fail common-event geometry,
  local affine, and emergent-rank controls. This kills separate local full-MDS
  charts and moves the next test to a joint shared-coordinate spacetime
  factorization. [ORACLE]
- `Scripts/experiments/causal_johnston_shared_factorization.py`,
  `Scripts/experiments/test_causal_johnston_shared_factorization.py`, and
  `AgentTasks/null-edge-johnston-shared-factorization-stage-a14-benchmark-2026-07-15.md`
  - one shared spatial coordinate vector per event, fitted against frozen
  training comparable-pair distances and noncausal inequalities, with
  held-out rank selection and post-fit affine controls. Held-out causal stress
  improves, but every `N=4000` realization selects four spatial dimensions,
  unrelated-pair and affine controls fail, and the fit degrades its Johnston
  initialization. This kills direct partial-distance stress and moves the next
  test to order-volume-chain conditioning and an intrinsic anchor scaffold.
  [ORACLE]
- `Scripts/experiments/causal_well_conditioning_audit.py`,
  `Scripts/experiments/test_causal_well_conditioning_audit.py`, and
  `AgentTasks/null-edge-causal-well-conditioning-stage-a15-benchmark-2026-07-15.md`
  - sampled implementation of Madsen's F1 exact order, F2 count-volume, and
  F3 longest-chain proper-time conditions, followed by a separate intrinsic
  anchor-scaffold audit. Every frozen `N=4000` F1/F2/F3 audit passes, providing
  positive manifoldlikeness and timelike-scale evidence, but the recovered
  five-anchor frame is nearly rank-deficient and has zero scaffold passes.
  This kills nearest-ideal-anchor selection and moves tetrad extraction to a
  combinatorial max-volume trilateration selector. [ORACLE]
- `Scripts/experiments/causal_trilateration_tetrad_selector.py`,
  `Scripts/experiments/test_causal_trilateration_tetrad_selector.py`, and
  `AgentTasks/null-edge-causal-trilateration-tetrad-selector-stage-a16-benchmark-2026-07-15.md`
  - exact common-bracket construction and a combinatorial max-volume frame
  selected by worst-case conditioning across three order-derived Johnston
  lightcone charts. Every held-out intrinsic and true-coordinate frame passes
  its conditioning gate, repairing Stage A15's rank defect, but chart
  transitions and held-out local affine reconstruction still fail. Retain the
  frame selector as a scaffold component; a joint frame-constrained coordinate
  solve is required before claiming a tetrad field or opening curvature.
  [ORACLE]
- `Scripts/experiments/causal_frame_constrained_metric.py`,
  `Scripts/experiments/test_causal_frame_constrained_metric.py`, and
  `AgentTasks/null-edge-causal-frame-constrained-metric-stage-a17-benchmark-2026-07-15.md`
  - three A16 anchor-aligned lightcone charts form one shared-event patch;
  count-derived proper times then fit a common symmetric metric with a frozen
  transported-chart ridge, followed by exact Lorentzian coframe factorization.
  Every held-out local coordinate, metric, causal-sign, volume, and coframe
  gate passes. This is a conditional local metric/coframe bridge, not bare-order
  signature emergence or a tetrad/spin bundle; overlapping-patch transition
  and spin-lift controls are next. [ORACLE]
- `Scripts/experiments/causal_tetrad_bundle_atlas.py`,
  `Scripts/experiments/test_causal_tetrad_bundle_atlas.py`, and
  `AgentTasks/null-edge-causal-tetrad-bundle-atlas-stage-a18-benchmark-2026-07-15.md`
  - several independently reconstructed A17 patches are selected by intrinsic
  quality and overlap, then audited for held-out affine transitions, metric
  covariance, Lorentz coframe defects, cocycles, and orientation/time-
  orientation sign gauges. Held-out overlap and orientability pass throughout,
  but the metric-bundle and spin-prerequisite gates pass only one of three
  realizations. This rejects overlap maximization as a sufficient tetrad-bundle
  selector and keeps the exact spin obstruction unopened. [ORACLE]
- `Scripts/experiments/causal_compatible_tetrad_bundle.py`,
  `Scripts/experiments/test_causal_compatible_tetrad_bundle.py`, and
  `AgentTasks/null-edge-causal-compatible-tetrad-bundle-stage-a19-benchmark-2026-07-15.md`
  - A18's independently fitted local patches are selected by affine/Lorentz
  compatibility, metric covariance, cocycles, and orientability using disjoint
  transition-fit and selector-validation overlap slices; a third overlap slice
  remains untouched for final testing. The selector passes four of five
  development realizations but zero of three frozen held-out realizations.
  Retain the three-way evaluation protocol, reject compatibility-only selection
  as a tetrad-bundle construction, and move the conditional atlas lane to joint
  metric/coframe synchronization while retaining operator-metric reconstruction
  as the primary bare-graph G2 target. No exact spin class is computed. [ORACLE]
- `Scripts/experiments/causal_synchronized_tetrad_bundle.py`,
  `Scripts/experiments/test_causal_synchronized_tetrad_bundle.py`, and
  `AgentTasks/null-edge-causal-synchronized-tetrad-bundle-stage-a20-benchmark-2026-07-15.md`
  - three local metrics are fitted jointly against their retained
  count-interval regressions and overlap-covariance penalties, with disjoint
  selector and untouched test slices for both local constraints and affine
  transitions. Development freezes synchronization weight `0.1`; all three
  fresh held-out realizations pass local fidelity, transition, metric-bundle,
  orientation, and spin-prerequisite gates. This closes a conditional
  synchronized metric-bundle subgate, not bare-order signature or scale
  emergence and not an exact spin structure. Global affine-gauge
  synchronization is next; the corrected causal-operator metric remains the
  primary G2 target. [ORACLE]
- `PhysicsSM/Draft/NullEdge/SynchronizedTetradBundle.lean` and
  `PhysicsSM/Draft/NullEdge/SynchronizedTetradBundleAxiomGuard.lean` - exact
  rational matrix bridge from supplied row-metric covariance and affine chart
  cocycles to Lorentz internal transitions and their internal cocycle, with a
  nonidentity 1+1 boost witness. The axiom guard pins every theorem to the
  standard Mathlib base. Charts, coframes, exact covariance, orientation, spin
  lifts, and convergence remain inputs or separate debts. [DRAFT-LEAN]
- `Scripts/experiments/causal_global_affine_tetrad_bundle.py`,
  `Scripts/experiments/test_causal_global_affine_tetrad_bundle.py`, and
  `AgentTasks/null-edge-causal-global-affine-tetrad-bundle-stage-a21-benchmark-2026-07-15.md`
  - three chart-to-global affine gauges are fitted from overlap training events;
  exact gauge ratios define pair transitions, and one pooled constant metric
  and coframe are pulled back to every patch. All three held-out realizations
  preserve untouched interval and transition geometry while affine, metric,
  Lorentz, and internal cocycles hold to roundoff. This closes an exact
  conditional flat-bundle and identity-spin control, not curved geometry or a
  nontrivial spin structure. Position-dependent metric jets are next. [ORACLE]
- `Scripts/experiments/causal_conformal_operator_metric.py`,
  `Scripts/experiments/test_causal_conformal_operator_metric.py`, and
  `AgentTasks/null-edge-causal-conformal-operator-metric-stage-a22-benchmark-2026-07-15.md`
  - flat-selected corrected causal-operator metric calibration on
  physical-volume sprinklings of conformal de Sitter diamonds. Fresh curved
  controls detect the relative conformal response, and `N=8000` stabilizes
  Lorentzian signature, but absolute metric normalization and determinant
  volume remain biased. This retains a curved operator-response signal while
  failing the absolute G2 scale/volume gate. [ORACLE]
- `Scripts/experiments/causal_conformal_multirow_metric.py`,
  `Scripts/experiments/test_causal_conformal_multirow_metric.py`, and
  `AgentTasks/null-edge-causal-conformal-multirow-metric-stage-a23-benchmark-2026-07-15.md`
  - shrinking-scale, target-centered multirow causal-operator calibration on
  conformal de Sitter controls. It closes all held-out and refinement signature
  checks and sharply improves relative conformal response, but absolute metric
  volume and the unrestricted metric first jet fail to converge. This retains
  the multirow schedule while moving G2 to independent count-volume Weyl-scale
  reconstruction before another derivative attempt. [ORACLE]
- `Scripts/experiments/causal_count_volume_weyl_metric.py`,
  `Scripts/experiments/test_causal_count_volume_weyl_metric.py`, and
  `AgentTasks/null-edge-causal-count-volume-weyl-metric-stage-a24-benchmark-2026-07-15.md`
  - shrinking local Alexandrov count windows with disjoint Poisson fit and
  pivot-validation thinnings. Given the conformal class, held-out counts
  recover the absolute inverse-metric Weyl factor to a few percent and the
  independent count/metric volume mismatch reaches roughly `10-15%` at
  `N=8000`. Window placement remains coordinate-defined and the scale gradient
  fails uniformly, so this closes only a conditional absolute-scale control.
  [ORACLE]
- `Scripts/experiments/causal_fused_operator_count_metric.py`,
  `Scripts/experiments/test_causal_operator_count_fused_metric.py`, and
  `AgentTasks/null-edge-causal-fused-operator-count-metric-stage-a25-benchmark-2026-07-15.md`
  - same-sprinkling fusion of A23's operator conformal ray with A24's disjoint-
  count volume form through determinant normalization. Held-out volume errors
  fall from order one to a few percent while every fused metric stays
  Lorentzian, but tensor-shape and first-jet errors remain large and fail
  refinement. This closes conditional volume fusion, not full G2 metric
  reconstruction. [ORACLE]
- `Scripts/experiments/causal_shape_selected_fused_metric.py`,
  `Scripts/experiments/test_causal_shape_selected_fused_metric.py`, and
  `AgentTasks/null-edge-causal-shape-selected-fused-metric-stage-a26-benchmark-2026-07-15.md`
  - flat-only reselection of the A23 regulator by determinant-normalized
  conformal-shape error, followed by unchanged A25 count-volume fusion on fresh
  curved seeds. Several tensor scores improve sharply and volume remains
  controlled, but one held-out curved cell loses Lorentzian signature and flat
  error worsens at doubled density. Retain shape-first selection; reject the
  current setting as a uniform G2 limit. [ORACLE]
- `Scripts/experiments/causal_multidensity_shape_selected_fused_metric.py`,
  `Scripts/experiments/test_causal_multidensity_shape_selected_fused_metric.py`,
  and
  `AgentTasks/null-edge-causal-multidensity-shape-selected-fused-metric-stage-a27-benchmark-2026-07-15.md`
  - minimax determinant-normalized shape selection over independent flat
  `N=4000` and `N=8000` development ensembles, followed by untouched curved
  seeds. The selected smaller averaging ball fails held-out signature and tail
  errors at `N=4000` despite better high-density curved scores. This kills
  median-only multi-density selection and adds minimum row support, conditioning,
  and tail-risk gates to the next operator-shape stage. [ORACLE]
- `Scripts/experiments/causal_support_tail_selected_fused_metric.py`,
  `Scripts/experiments/test_causal_support_tail_selected_fused_metric.py`, and
  `AgentTasks/null-edge-causal-support-tail-selected-metric-stage-a28-benchmark-2026-07-15.md`
  - expanded compact-probe support with two-density flat selection on signature
  tails, worst shape, row support, and conditioning. All fresh metrics remain
  Lorentzian with saturated rows, but tensor errors plateau near `0.3-0.4`,
  isolating a systematic temporal/spatial response bias. [ORACLE]
- `Scripts/experiments/causal_retarded_moment_debiased_metric.py`,
  `Scripts/experiments/test_causal_retarded_moment_debiased_metric.py`, and
  `AgentTasks/null-edge-causal-retarded-moment-debiased-metric-stage-a29-benchmark-2026-07-15.md`
  - affine-covariant temporal projector derived from the retarded kernel's
  positive first moment, with one response weight selected on two flat
  densities before curved evaluation. All `27` fresh metrics are Lorentzian;
  median full-tensor errors are below `0.30` in every cell and mostly below
  `0.20`. This closes a conditional pivot-tensor control, not intrinsic G2 or a
  differentiated metric field. [ORACLE]
- `Scripts/experiments/causal_retarded_moment_metric_first_jet.py`,
  `Scripts/experiments/test_causal_retarded_moment_metric_first_jet.py`, and
  `AgentTasks/null-edge-causal-retarded-moment-first-jet-stage-a30-benchmark-2026-07-15.md`
  - exact derivative of the A29 moment projector followed by determinant and
  count-scale fusion. Finite-difference and affine covariance tests pass, and
  operator-only jet errors improve, but the noisy count-factor gradient makes
  the fused first jet fail at both densities. Connection and curvature remain
  closed pending a separately calibrated count-volume gradient. [ORACLE]
- `Scripts/experiments/causal_poisson_scale_gradient.py`,
  `Scripts/experiments/test_causal_poisson_scale_gradient.py`, and
  `AgentTasks/null-edge-causal-poisson-scale-gradient-stage-a31-benchmark-2026-07-15.md`
  - affine-covariant penalized Poisson fit selected on zero- and nonzero-gradient
  controls at two densities. It improves the count gradient in five of six
  held-out cells, but zero-gradient and exact-target-gradient fusion controls
  leave the `4-6` first-jet error unchanged. This revises the A30 diagnosis:
  the determinant-normalized operator-shape derivative is now the active gate.
  Connection and curvature remain closed. [ORACLE]
- `Scripts/experiments/causal_rowwise_shape_first_jet.py`,
  `Scripts/experiments/test_causal_rowwise_shape_first_jet.py`, and
  `AgentTasks/null-edge-causal-rowwise-shape-first-jet-stage-a32-benchmark-2026-07-15.md`
  - order-of-operations test that applies the A29 correction and determinant
  normalization to individual rows before fitting the shape field. It rejects
  `20%-30%` of rows and destroys the stable pivot tensor, with rowwise shape
  errors `0.56-1.33` and signature rates at most `40%`. This implementation is
  killed; the successor must constrain the derivative around the aggregate
  tensor and retain a nonzero-shape-jet coordinate control. [ORACLE]
- `Scripts/experiments/causal_quadratic_chart_shape_jet.py`,
  `Scripts/experiments/test_causal_quadratic_chart_shape_jet.py`, and
  `AgentTasks/null-edge-causal-quadratic-chart-shape-jet-stage-a33-benchmark-2026-07-15.md`
  - exact nonlinear-coordinate controls on flat spacetime with zero, temporal,
  and shear unit-volume shape jets. Two-density selection chooses zero tangent
  weight; every nonzero response is worse, and the high-density shear amplitude
  is only `0.134` with larger orthogonal noise. Returning zero is rejected as a
  vacuous derivative. The present first-jet estimator therefore fails probe-
  chart covariance and cannot feed a connection. [ORACLE]
- `Scripts/experiments/causal_spread_chart_shape_jet.py`,
  `Scripts/experiments/test_causal_spread_chart_shape_jet.py`, and
  `AgentTasks/null-edge-causal-spread-chart-shape-jet-stage-a34-benchmark-2026-07-15.md`
  - deterministic farthest-point spread across the supplied averaging-ball
  coordinates. Two-density flat-chart selection freezes averaging multiplier
  `1.7` and nonzero tangent weight `0.2`; it beats the zero derivative while
  preserving the pivot-tensor gate. This is a positive conditional nonvacuity
  control, not intrinsic bare-order reconstruction. [ORACLE]
- `Scripts/experiments/causal_spread_fused_first_jet.py`,
  `Scripts/experiments/test_causal_spread_fused_first_jet.py`, and
  `AgentTasks/null-edge-causal-spread-fused-first-jet-stage-a35-benchmark-2026-07-15.md`
  - fresh flat and conformally curved evaluation with the A34 setting frozen.
  All metrics are Lorentzian; selected shape-jet medians are `0.324-0.533` and
  full-jet medians are below `0.70`. Shape improves with density, but the full
  high-curvature result does not because the count-scale gradient worsens.
  This opens a conditional first-jet bridge without establishing convergence.
  [ORACLE]
- `Scripts/experiments/causal_spread_levi_civita_connection.py`,
  `Scripts/experiments/test_causal_spread_levi_civita_connection.py`, and
  `AgentTasks/null-edge-causal-spread-levi-civita-connection-stage-a36-benchmark-2026-07-15.md`
  - Levi-Civita connection derived from the A35 inverse metric and first jet.
  Torsion and metric compatibility hold algebraically and all median connection
  errors are subunit, but the `H=0.2` error worsens at doubled density. This is
  finite conditional control, not connection convergence; curvature remains
  closed. [ORACLE]
- `AgentTasks/null-edge-causal-connection-convergence-stage-a37-plan-2026-07-15.md`
  - preregistered successor using affine and exact quadratic flat charts to
  separate nonzero coordinate connection from physical curvature. It requires
  two-density connection improvement and removal of the A36 high-curvature
  regression before any second-jet or curvature estimator is opened. [PLAN]
- `Scripts/experiments/causal_connection_convergence.py`,
  `Scripts/experiments/test_causal_connection_convergence.py`, and
  `AgentTasks/null-edge-causal-connection-convergence-stage-a37-benchmark-2026-07-15.md`
  - flat-only selection of a mapped-coordinate count-scale schedule followed by
  eight fresh realizations in affine/quadratic flat charts and held-out curved
  backgrounds at two densities. Every preregistered conditional connection
  gate passes: worst median and ensemble errors improve and the A36 `H=0.2`
  regression disappears. This opens exact second-jet controls, not a bare-order
  or asymptotic theorem. [ORACLE]
- `PhysicsSM/Draft/NullEdge/CausalOperatorWeakGeometry.lean`,
  `Scripts/experiments/causal_operator_weak_geometry.py`,
  `Scripts/experiments/test_causal_operator_weak_geometry.py`, and
  `AgentTasks/null-edge-causal-operator-weak-geometry-stage-a38-benchmark-2026-07-15.md`
  - one-operator weak-geometry successor to A37. Exact finite theorems identify
  the corrected pairing with the double multiplication commutator on one and
  prove multiplication-potential invariance of the normalized operator,
  double/triple commutators, weak Hessian, and normalized `Gamma2`. Flat
  temporal/shear quadratic-chart controls retain a nonzero Hessian signal while
  weak Ricci tends to zero. This is a supplied-operator control, not an
  intrinsic mesoscopic-algebra or causal-set curvature result. [LIVE/ORACLE]
- `Scripts/experiments/causal_mesoscopic_algebra.py`,
  `Scripts/experiments/test_causal_mesoscopic_algebra.py`, and
  `AgentTasks/null-edge-causal-mesoscopic-algebra-stage-a39-benchmark-2026-07-15.md`
  - first basis-independent degree-two mesoscopic-algebra audit. Rank 15,
  generator-product closure, and affine `GL(4)` projector covariance pass near
  roundoff. The preregistered strong operator/locality gate fails even for the
  oracle sector: region-mean signature is unstable, strong triple commutators
  remain near one, and Johnston does not beat the random control. Retain the
  algebra projector; kill this global-region/strong-`L2` topology and move to a
  projected weak calculus before causal `Gamma2`. [ORACLE]
- `Scripts/experiments/causal_projected_weak_geometry.py`,
  `Scripts/experiments/test_causal_projected_weak_geometry.py`, and
  `AgentTasks/null-edge-causal-projected-weak-geometry-stage-a40-benchmark-2026-07-15.md`
  - projected weak-calculus successor retaining A39's rank-15 envelope. The
  implementation independently reproduces flat nonlinear-coordinate Ricci
  cancellation for a local finite-difference d'Alembertian, but the causal
  operator fails: weak triple defects and flat Ricci residuals stay near one,
  weak signature is unstable, and Johnston does not beat random fields. This
  kills global projection as the repair and redirects the graph-side program
  to analytic kernel normalization or a local Alexandrov algebra germ.
  [ORACLE]
- `PhysicsSM/Draft/NullEdge/AlexandrovAlgebraGerm.lean` - exact marked-diamond
  local-germ API with two-sided count depth, protected cores, tapered cutoffs,
  localization, and relabeling covariance. It supplies no preferred
  interval, dimension, continuum chart, or physical scale. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/AlexandrovGermPacking.lean` - finite bare-order
  ensemble of all maximum-cardinality eligible marked-diamond packings with
  pairwise vertex-disjoint closed carriers. Maximum packings exist, transport
  exactly under order isomorphism, have invariant ensemble cardinality and
  uniform averages, and admit explicit nonvacuity controls. The ensemble avoids
  a symmetry-breaking canonical representative but proves no packing-growth,
  stochastic-independence, or continuum theorem. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/AlexandrovGermPairEstimand.lean` - exact uniform
  distinct-ordered-pair average over the complete maximum-packing ensemble,
  including the intrinsic mean-square score difference and normalized
  covariance estimand `1-q/2`. All constructions are relabeling invariant;
  marginal variance, internally local germ scores, covariance decay, and a
  random-order limit remain open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/AlexandrovGermInternalOperator.lean` - induced
  causal order on a marked diamond's closed carrier, causal-convexity and exact
  ambient/induced interval-count equality, internal boundary depth and taper,
  and exact equality between induced local/smeared operators and ambient
  operators on zero extension. It adds uniform protected-anchor residual
  scores and a fully order-derived cutoff-control score connected to the
  maximum-packing pair estimand. Physical metric probes, targets, stochastic
  covariance decay, and continuum convergence remain open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/AlexandrovNestedGerm.lean` - exact finite
  outer-regulator/inner-germ interface. A supplied two-sided count buffer gives
  closed-carrier inclusion, induced interval-count preservation, equality of
  layered operators under nested zero extension, and additive protected-core
  depth transport. A five-event chain witness prevents vacuity. It derives neither
  a preferred nested pair nor buffer scale, and does not prove stochastic
  availability or continuum convergence. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/GreedyAtlasCoverage.lean` - finite set-system core
  for order-equivariant atlas selection. It proves the average-marginal
  witness, greedy dominance, one-step and finite-horizon residual contraction,
  the exact `1-(1-1/k)^k` coverage factor, relabeling preservation, and the
  cardinality bound `card(union) <= K*B`. The latter forces
  `K_N=Omega(N^(1/4))` for nonzero global coverage when chart cardinalities are
  `O(N^(3/4))`. It controls a selector and necessary atlas growth; it does not
  prove candidate-family saturation or G2. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/AtlasCoreBulkContainment.lean` - exact finite
  bridge from protected chart cores to the independently defined order bulk.
  Endpoint-plus-open-interval embeddings prove every protected core and every
  finite protected-core union lies in the two-sided predecessor/successor bulk
  at the same threshold. This factors all-event union coverage into bulk
  fraction times family saturation, but does not prove saturation or a
  continuum limit. [DRAFT-LEAN]
- `Scripts/experiments/causal_atlas_scaling.py` and
  `AgentTasks/null-edge-causal-atlas-scaling-stage-a3f-r3-benchmark-2026-07-16.md`
  - fresh two-density complete-family test of the post-hoc
  `1-S_N = O(N^(-1/2))` form. All six cells pass the frozen scaling, flat
  `F_4`, capability, resource, and tripwire gates. This is finite stochastic
  evidence only; growing atlas cardinality, overlap complexity, and G2 remain
  open. Every citation carries
  `INC-2026-07-16-A3F-R3-DUPLICATE-RUN` until Director review because two blind
  concurrent launches wrote the frozen path; independent review retained the
  second artifact with full disclosure. [EXPERIMENT]
- `PhysicsSM/Draft/NullEdge/IntrinsicProbeSubspace.lean` - basis-free natural
  scalar-probe sectors under finite-order isomorphism. The zero-sum field
  subspace transports exactly, has real rank four on the five-event antichain,
  and feeds an exactly covariant corrected operator pairing on every closed
  Alexandrov carrier. The same symmetric control proves that every zero-sum
  probe selected as an individually natural vector vanishes, so a physical
  probe frame must transform inside a subspace up to basis change. The rank-four
  control is cardinality-driven and does not establish causal dimension,
  Lorentzian signature, or continuum probe convergence. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/RankFourCarrierProbeSector.lean`,
  `PhysicsSM/Draft/NullEdge/EquivariantProbeSectorSelector.lean`, and
  `PhysicsSM/Draft/NullEdge/EquivariantInvolutionProbeProjector.lean` - the
  corrected local target is a supplied rank-four subspace of the full carrier
  probe space, selected basis-free as a kernel, range, projector, or positive
  eigenspace. Intertwining maps transport each sector exactly. Projectors and
  involutions are polynomially equivalent, so the involution interface removes
  eigenvector ordering but does not derive graph structure, a four-mode gap,
  or Lorentzian inertia. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/EquivariantPolynomialProbeProjector.lean` - exact
  basis-free functional-calculus naturality. Intertwining carrier operators
  transport every common real-polynomial filter and its range; source
  idempotence and rank-four certificates transport to the target, and the
  selected range packages as the existing carrier projector. The module does
  not derive the operator, polynomial, spectral gap, source rank, Lorentzian
  inertia, overlap compatibility, or continuum tetrad. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/RetardedPolynomialProjectorNoGo.lean` - exact
  algebraic obstruction to selecting a proper sector from a one-spectrum
  operator: every idempotent real-polynomial filter of `a I + N` with
  nilpotent `N` is zero or identity. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/FiniteStrictPastNilpotence.lean` - exact finite
  causal-combinatorial bridge: every arbitrarily weighted strict-past operator
  on a nonempty finite transitive irreflexive relation is nilpotent at the
  event-cardinality power, with a nonzero two-event square-zero control.
  [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/LayeredOperatorPolynomialNoGo.lean` - composes the
  abstract polynomial obstruction with strict-past nilpotence and proves that
  the bundled operator is pointwise equal to the production layered causal
  operator. Direct idempotent polynomial filters of both the local source and
  active smeared project-sign operators are therefore zero or identity. This
  excludes only one-sided retarded polynomial selection, not corrected
  symmetric, normal, Hermitian, or richer constraint operators. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/BareGraphPermutationProjectorNoGo.lean` - exact
  symmetry obstruction for the natural real scalar vertex-probe module. A
  fully permutation-equivariant idempotent has range dimension among
  `0,1,n-1,n`, hence cannot have rank four for `n>=6`. Together with the
  five-event zero-sum control, this rules out a refinement-stable universal
  scalar selector on maximally symmetric bare graphs while leaving asymmetric,
  decorated, edge/cochain, and spin-probe routes open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ProtectedCoreProbeProjectorTransition.lean` - on
  the literal protected-core overlap of the active atlas, a supplied shared
  idempotent projector, two intertwining restriction squares, shared-range
  liftability, and restricted injectivity derive equal selected images and a
  unique pair transition. An overlap with fewer than four events fails the
  rank-four injectivity gate. The graph still owes all projectors, liftability,
  Lorentzian inertia, triple compatibility, and refinement convergence.
  [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/AtlasFractionalPackingDual.lean` - kernel-checked
  weighted incidence dual for bounded-multiplicity atlases. A nonnegative
  rational hitting certificate on the complete candidate family bounds every
  selected subfamily by `cap * totalWeight`; the common-event obstruction is
  its unit point-mass case. External optimization may search for certificates,
  but the module neither produces one nor constructs an atlas. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/ProbeFrameLorentzGauge.lean` - packages the active
  smeared causal operator as a linear map and its corrected carrier pairing as
  a symmetric bilinear form. Four-probe frames are bases of the natural probe
  subspace; their Gram matrices obey exact change-of-basis congruence. If one
  frame gives the mostly-minus Minkowski matrix, the other normalized frames
  differ from it exactly by Lorentz transformations. The existence of such a
  frame is invariant under order isomorphism and implies nondegeneracy. Frame
  existence, Lorentzian inertia on physical carriers, mode convergence, and a
  smooth tetrad remain open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/RetardedProbeSupportGate.lean` - formalizes the
  order-only two-sided interior and retarded-shell architecture used by the A3
  intrinsic-probe support audit. Interval-band abundance, shell membership,
  shell cardinality, and qualitative visibility of every intrinsic probe
  subspace are exactly invariant under order isomorphism. Injective restriction
  to a shell gives `finrank P <= shell.card`, so fewer than four shell events
  kernel-checkably forbid a visible rank-four sector. A four-leaf, one-top
  order realizes the sharp rank-four/cardinality-four case. This necessary
  availability gate does not prove quantitative coverage, Lorentzian inertia,
  product quality, or continuum convergence. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/RetardedShellInfraredNoGo.lean` - explicit
  arbitrary-cardinality counterweight to the shell rank obstruction. For every
  `n`, a three-level finite strict order has `n` two-sided-interior shell
  sources in one fixed minimal interval-count band, with nonzero past/future
  abundance and zero intervening events to the mark. Hence shell cardinality
  can grow without any change in local interval count. Together with the A3c
  larger-diamond oracle, this rejects the global count shell as a locality
  certificate while preserving its necessary rank bound. [DRAFT-LEAN/ORACLE]
- `PhysicsSM/Draft/NullEdge/ProbeFrameWeylScaleBridge.lean` - proves that
  simultaneous rescaling of the active operator's discreteness and nonlocality
  lengths preserves its smearing ratio and gives the operator, corrected
  carrier form, and fixed-frame Gram matrix exact inverse-square Weyl weight.
  Composition with count-derived relative scale gives reciprocal covariant and
  contravariant factors: the supplied coframe metric scales by
  `relativeAreaScale`, while the operator principal-symbol Gram matrix scales
  by its inverse. A sixteen-to-one count witness realizes factors `4` and
  `1/4`. This is finite scale compatibility, not derivation of the probe frame,
  Lorentzian inertia, convergence, or absolute scale. [DRAFT-LEAN]
- `Scripts/experiments/causal_continuum_kernel_moments.py`,
  `Scripts/experiments/test_causal_continuum_kernel_moments.py`, and
  `AgentTasks/null-edge-causal-continuum-kernel-moments-stage-a41c-benchmark-2026-07-15.md`
  - analytic Poisson-mean and segmented-quadrature audit of the project-sign
  smeared causal operator on two smooth Alexandrov germs. A41c passes the
  small-scale metric, principal-symbol, lower-moment, and quadrature gates
  without the A29 correction. This is deterministic continuum normalization,
  not discrete concentration or intrinsic algebra reconstruction. [ORACLE]
- `Scripts/experiments/causal_discrete_germ_moments.py`,
  `Scripts/experiments/test_causal_discrete_germ_moments.py`, and
  `AgentTasks/null-edge-causal-discrete-germ-moments-stage-a42-benchmark-2026-07-15.md`
  - marked-row finite-sprinkling concentration test against quadrature-certified
  A41d finite targets. Coefficient, relabeling, endpoint-cutoff, and scale checks
  pass, but all four held-out field/metric strata fail at `ell/L=0.51-0.63`.
  This kills the tested schedule and moves G2 to analytic variance control and
  stronger two-scale separation or mesoscopic averaging. [ORACLE]
- `Scripts/experiments/causal_kernel_diagonal_variance.py`,
  `Scripts/experiments/test_causal_kernel_diagonal_variance.py`, and
  `AgentTasks/null-edge-causal-kernel-diagonal-variance-audit-2026-07-15.md`
  - exact Poisson and finite-binomial kernel second moments plus the positive
  diagonal Mecke contribution on the marked germ. It explains the scale and
  much of the magnitude of A42 fluctuations while explicitly excluding
  off-diagonal shared-sprinkling and random-taper covariance. [ORACLE]
- `PhysicsSM/Draft/NullEdge/CausalOperatorTwoScale.lean` - exact scale
  identities for broad-layer epsilon, effective kernel count, and the
  conditional amplitude diagnostic `ell^2/L^4`. It proves that the schedule
  `L^2=c^2 ell R` leaves this diagnostic constant; no probabilistic theorem is
  claimed. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/CausalOperatorKernelMoments.lean` and
  `AgentTasks/null-edge-causal-operator-concentration-variance-aristotle-2026-07-15.md`
  - exact broad-layer falling-factorial product identity, source-locked closed
  Poisson and finite-binomial moment formulas, nonnegative fixed-`z` leading
  coefficient, and a Chebyshev wrapper conditional on an explicit total
  variance bound. The formulas are not promoted to a causal-set probability
  law, and random atoms, taper depth, and same-graph covariance remain open.
  [DRAFT-LEAN/AUDIT]
- `Sources/Null_Edge_Causal_Operator_Locality_Variance_Audit_2026-07-15.md` -
  source- and convention-locked interpretation of the compact-support limit,
  the A42-A43 variance obstruction, and the Boguna-Krioukov intrinsic local
  d'Alembertian. It opens a preregistered comparison between a compact nonlocal
  regional observable with full overlap covariance and a clean-room local
  distance/neighborhood challenger; neither is promoted. [LIVE]
- `AgentTasks/null-edge-causal-operator-fork-stage-a44-plan-2026-07-15.md` -
  frozen architecture-level preregistration for that comparison. It requires
  common polynomial controls and held-out concentration gates, full same-graph
  covariance for the regional branch, and explicit intrinsic-distance error
  for the local branch before either can advance to curvature. [PLAN]
- `PhysicsSM/Draft/NullEdge/LocalCausalOperatorMoments.lean`,
  `Scripts/experiments/causal_local_operator_moments.py`,
  `Scripts/experiments/test_causal_local_operator_moments.py`, and
  `AgentTasks/null-edge-causal-local-operator-moments-stage-a44a-benchmark-2026-07-15.md`
  - exact and coordinate-oracle Phase A control for the Boguna-Krioukov local
  stencil after source-to-project sign conversion. Constants, affine and mixed
  moments, temporal/spatial quadratics, hyperboloid moments, and the `(+---)`
  diagonal pass in dimensions `1+1` through `3+1`; an asymmetric neighborhood
  exposes affine leakage. Intrinsic distances, random concentration, and
  curved response remain open. [DRAFT-LEAN/ORACLE]
- `PhysicsSM/Draft/NullEdge/RegionalCovariance.lean`,
  `Scripts/experiments/causal_regional_operator_covariance.py`,
  `Scripts/experiments/test_causal_regional_operator_covariance.py`, and
  `AgentTasks/null-edge-causal-regional-covariance-stage-a44n-control-2026-07-15.md`
  - exact A44 regional support layer. A tied count-depth selector and the full
  compact-row pipeline are relabeling covariant, while the finite and empirical
  ledgers retain every ordered off-diagonal same-graph product. The live module
  also proves the conditional dependency-degree covariance and Chebyshev
  bounds, plus the complete-dependency identity separating the persistent
  `sigmaSq*kappa` term. Positive and negative shared-covariance controls pass;
  no physical concentration claim is opened. [DRAFT-LEAN/ORACLE]
- `PhysicsSM/Draft/NullEdge/FiniteCausalOverlap.lean`,
  `Scripts/experiments/causal_overlap_distance.py`, and
  `Scripts/experiments/test_causal_overlap_distance.py` - exact finite
  common-Alexandrov count ratio used by the local operator's spacelike-distance
  input. The ratio is symmetric, bounded in `[0,1]`, and invariant under order
  isomorphism, with explicit finite fork and partial-overlap controls. The
  conditional `1+1` distance and arbitrary-dimensional asymptotic proxy are
  homogeneous in supplied proper time, making the scale debt explicit. The
  module does not derive proper time, dimension, inversion, or absolute scale.
  [DRAFT-LEAN/ORACLE]
- `Scripts/experiments/causal_reusable_relation.py`,
  `Scripts/experiments/causal_regional_resource_gate.py`,
  `Scripts/experiments/causal_regional_scaling_gate.py`, and the A44r/A44r2
  plans, benchmarks, and JSON artifacts under `AgentTasks/` - exact bit-packed
  strict relation reused for global depth and per-pivot interval popcounts.
  Direct semantics pass, and measured `N=100000` storage/time follows the
  preregistered quadratic prediction. This closes a resource precondition, not
  regional concentration or large-run authorization. [ORACLE]
- `Scripts/experiments/causal_offcenter_continuum_targets.py`,
  `Scripts/experiments/causal_offcenter_target_audit.py`, and the A44t records
  under `AgentTasks/` - relative-null and exact angular-cap quadrature for the
  finite Poisson-mean target at arbitrary pivots. Quadrature and signature
  controls pass, while center-target reuse fails because compact retarded
  boundary bias is strongly time-asymmetric. A44N now requires one oracle
  finite target per order-selected pivot. [ORACLE]
- `Scripts/experiments/causal_selected_pivot_target_calibration.py` and the
  A44p plan, benchmark, and JSON artifact under `AgentTasks/` - one-graph
  `N=100000` meeting of the exact packed rows, tied-depth selector, full
  17-channel affine/quadratic envelope, and certified target at each selected
  pivot. The target gate passes and the regional mean is Lorentzian, but full
  metric error is `0.546` and major-channel effective pivot counts are only
  about `4-12`. This opens a fresh multi-graph development covariance gate,
  not held-out concentration or curvature. [ORACLE]
- `Scripts/experiments/causal_regional_multigraph_development.py`, its tests,
  and the A44N plan, benchmark, checkpoints, and aggregate JSON under
  `AgentTasks/` - three fresh independent `N=100000` graphs pass every frozen
  development gate. All regional metrics are Lorentzian, `44/48` pivot metrics
  are Lorentzian, metric errors are `0.203-0.400`, and the exact covariance
  decomposition closes to `5.33e-15`. This retains Branch N and permits a
  separate `N=200000` development preregistration, not held-out concentration,
  curvature, or `N=400000`. [ORACLE]
- `AgentTasks/null-edge-causal-regional-dependency-stage-a44d-audit-2026-07-15.md`
  - implementation-level information-flow audit showing that global pivot
  selection and global predecessor future counts make the conservative
  selected-row read-overlap graph complete. Density escalation is deferred
  until covariance-ratio decay is proved or the selector/taper is localized.
  [AUDIT]
- `AgentTasks/null-edge-causal-regional-kappa-decay-aristotle-2026-07-15.md`,
  its standalone `RegionalCovarianceDecayAudit.lean`, and semantic context pack
  - focused Aristotle strategy/no-go audit for the remaining complete-graph
  covariance ratio. The returned audit gives a `REVISE` verdict: deepest-pivot
  coalescence is incompatible with the separated-germ regime normally needed
  for covariance decay, while global selection and future counts defeat direct
  stabilization. The integrated Lean endpoint proves that vanishing normalized
  row difference and unit normalized variances imply `kappa_N -> 1`; the
  coalescence and stochastic-continuity premises remain open. It recommends
  separated order-derived outer germs for same-graph concentration and
  independent whole graphs for inference on unchanged A44. Project
  `476b4880-407d-4661-9dec-48b2b3797ec3`. [ARISTOTLE-COMPLETE]
- `AgentTasks/null-edge-causal-regional-covariance-bound-aristotle-2026-07-15.md`
  and its standalone `RegionalCovarianceBound.lean` - completed focused
  Aristotle task integrated into the live regional module. The kernel-checked
  dependency-degree bound `sigmaSq*(1+degree*kappa)/m` and conditional
  Chebyshev wrapper keep graph-overlap degree, covariance ratio, outside signs,
  and physical variance as explicit unproved obligations. [ARISTOTLE-COMPLETE]
- `Scripts/experiments/causal_discrete_germ_concentration.py`,
  `Scripts/experiments/test_causal_discrete_germ_concentration.py`, and
  `AgentTasks/null-edge-causal-discrete-germ-concentration-stage-a43-benchmark-2026-07-15.md`
  - low-epsilon successor stopped after development because three of four
  finite targets are negative definite. This exposes a finite no-overlap
  between the tested low-noise and two-profile Lorentzian-mean windows; its
  held-out seed was never opened. [ORACLE]
- `PhysicsSM/Draft/NullEdge/RetardedMomentMetricDebias.lean` and
  `PhysicsSM/Draft/NullEdge/RetardedMomentMetricDebiasAxiomGuard.lean` - exact
  affine-probe covariance of the A29-A30 moment norm, temporal response
  projector, corrected inverse metric, and first jets, plus a nonidentity
  rational correction witness. Aristotle supplied six reviewed proof bodies;
  the guard pins their standard dependency footprint. All graph, chart, response,
  and continuum inputs remain conditional. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/DiscreteDimensionalTransmutation.lean` - exact
  positive discrete one-loop-shaped flow, inverse-coupling invariant,
  step-independent exponential scale, nonperturbative flatness beyond every
  coupling power, and the `1/3 -> 1/4 -> 1/5` control. The flow law and
  coefficient remain supplied; no physical beta function or measured scale is
  claimed. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/FiniteEffectValuationHomogeneity.lean` - finite
  qubit-effect valuation ladder: zero value, monotonicity, natural/rational
  homogeneity, and real `[0,1]` homogeneity derived by rational squeeze without
  assuming continuity, plus an explicit density-matrix valuation witness. The
  full Busch-Gleason density-matrix representation remains an active successor.
  [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/GaugeMassGram.lean` - finite reference-orbit theorem:
  the gauge-mass matrix is a positive Gram matrix, its null directions are
  stabilizers, and an explicit witness separates one broken from one unbroken
  generator. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/SelfConsistentDecoder.lean` - finite two-level Gibbs
  feedback theorem: fixed-point existence, weak-coupling uniqueness, and an
  explicit nonboundary self-consistent witness. [DRAFT-LEAN]
- `AgentTasks/fable_parallel/Q02_answer.md` - gravity slot: Lemma-0 invariance, corrected telescoping + P-probe kill, TEGR coefficient derivation, certificates. [STABLE]
- `AgentTasks/fable_parallel/Q03_answer.md` - the four-theorem no-go audit; verdict table; charter source. [STABLE]
- `AgentTasks/fable_parallel/Q04_answer.md` - SM selection: B-L no-go for the naked triple; internal null-strand principle; pentad selection up to (4,1); anomaly = supertrace identity; octonion/Connes dictionary. [STABLE]
- `AgentTasks/fable_parallel/Q05_answer.md` - generations: triality-as-monodromy (3 forced by D4; menu {1,3}); gauge-outer rail; Fano/E8 kills; CKM/PMNS dichotomy from Z/3 rep theory. [STABLE]
- `AgentTasks/fable_parallel/Q06_answer.md` - continuum limit: benchmark ladder R0-R6; retardedness = Wilson term; exact GW with edge-reversal grading; UM/covariance gates; refinement category. [STABLE]
- `AgentTasks/fable_parallel/Q07_answer.md` - mass values: equipartition Q = 2/V (Koide = 45deg x 3); T-SOLDER; leg-level sqrt-m; hierarchy = path overlap; GATE M-KOIDE. NOTE: the gate's Route-A operationalization was killed by probe P1 (2026-07-07, measured kappa = 3/2); the equipartition identity is unaffected. [STABLE]
- `AgentTasks/fable_parallel/Q08_answer.md` - second quantization: Fock commutes with GB quotient; finite Kugo-Ojima free; canonical wedge interaction; RG = Schur; infinity's two doors. [STABLE]
- `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` - the unified-mass-model working plan (detail behind the results map). [LIVE]
- `Sources/Luminal_Motion_Checkerboard_Research_Program.md` - the checkerboard program (bridges to the carrier via the turn/corner dictionary). [LIVE]
- `docs/NERD_ROADMAP.md` - see operational guides; also the program's gate structure. [LIVE]

- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEinsteinBridge.lean` - exact site-local density/scalar-contraction base for the nonlinear action. It proves the left-inverse cofactor identity `PalatiniDensity(e,F) = -det(e) ScalarCurvature(e^{-1},F)` for every ordered curvature field, rewrites the concrete nonlinear action as the corresponding determinant-weighted scalar-curvature sum, rewrites its ordinary coframe response as a sum of extracted-curvature Palatini-density responses, and proves the mixed Ricci/scalar contraction identities used by the response successor. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniEinsteinResponse.lean` - exact arbitrary-coframe first-response bridge. For face-antisymmetric curvature it proves that the Palatini-density response is `det(e)` times the mixed Einstein coframe coefficient paired with an arbitrary tetrad variation. It follows that each of the sixteen concrete coframe Euler coefficients has this form, coframe stationarity is equivalent to all finite equations `2 Ric^d_c - delta^d_c R = 0`, and joint stationarity is exactly the six-component link Euler system together with those sixteen equations. Levi-Civita selection, dual-cell weighting, and continuum Riemann/refinement identification remain open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniCurvatureLimit.lean` - exact and conditional action-visible curvature-limit bridge. It packages the six Palatini trace probes as a continuous linear map on arbitrary `4 x 4` matrix increments, proves identity on Lorentz-generator coordinates, and carries supplied shrinking-area first-order group-holonomy expansions to the exact antisymmetrized curvature field used by the action. At fixed invertible coframe, stationarity at every refinement implies the mixed vacuum Einstein equation for the limiting target. A flat identity-holonomy family witnesses the first-order interface. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniVaryingCoframeLimit.lean` - exact conditional successor allowing the finite coframe and its inverse to vary with refinement. It proves joint continuity of mixed Ricci, scalar, and Einstein entries in inverse-coframe and curvature components; proves that exact finite left inverses remain left inverses under simultaneous componentwise convergence; and passes stationary varying-coframe refinements to all limiting mixed vacuum Einstein equations. The graph still owes the refinement and convergence proofs, Levi-Civita selection, and identification of the target with continuum Riemann curvature. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniWeakEinsteinLimit.lean` - exact finite fundamental lemma and conditional changing-carrier weak endpoint. Delta tests identify vanishing against every finite test tensor with all pointwise mixed Einstein equations; nonzero explicit site volumes preserve that equivalence; and both are composed with the nonlinear coframe-stationarity theorem. For a refinement whose finite site type may change with the level, convergence of the weighted residual pairings implies that the limiting functional vanishes on every test. The graph still owes the test sampler, dual volumes, weak topology and convergence proof, compactness or stability, and continuum Einstein-tensor identification. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniLinearizedTorsionSelection.lean` - exact identity-tetrad torsion bridge for the nonlinear action's independent-connection equation. An explicit convention-locked `4 x 6` coordinate map identifies the twenty-four linearized `D(e wedge e)=0` coefficients with the twenty-four Cartan torsion components and proves equivalence of their vanishing. The exact finite face residual is `h L + h^2 Q`; therefore stationary identity-link refinements with nonzero `h -> 0` and a fixed first jet select zero torsion even when the carrier changes. The general-tetrad successor below removes the identity-coframe restriction. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniGeneralTorsionSelection.lean` - arbitrary-invertible-tetrad torsion bridge at identity link transport. It proves general internal-basis covariance through the conjugated Palatini transport `-H C(L) H`, reduces supplied-inverse coframes to the identity theorem, and certifies a nonidentity anisotropic witness. The finite-spacing defect and changing-carrier fixed-jet endpoint hold at every fixed invertible center coframe. Nonidentity links, connection-dependent torsion, nonlinear Levi-Civita uniqueness, metric compatibility, varying jets, and graph-derived refinement remain open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/NonlinearLorentzPalatiniAffineConnectionTorsionSelection.lean` - affine Lorentz-link tangent bridge from the general-tetrad Palatini map to connection-dependent Cartan torsion. It proves the explicit Lorentz tangent is Hodge-compatible and Krein-skew, so predecessor transport produces the covariant coframe velocity whose antisymmetrization is `de + omega wedge e` up to the documented global sign. The exact finite residual has cubic form `h L + h^2 Q - h^3 C`; shrinking exact equations force torsion-free transport for the fixed jet, and an explicit connection-generated family prevents vacuity. Full exponential-link Euler equivalence and nonlinear Levi-Civita uniqueness remain open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/PhysicalLorentzPlaquetteRefinement.lean` - nonflat physical refinement witness and conditional Einstein specialization. It proves `exp(A_n hat(F))` has action-visible first-order limit `F`, certifies the exponential links as eta-preserving with determinant `+1`, and realizes exact opposite exponential plaquettes on the two columns of a commuting-shift `2 x 2` periodic square. Every other ordered face is flat, and nonzero `F` gives a nonzero target field. A stronger refinement structure records proper eta-Lorentz membership for every link, and the varying-coframe Einstein endpoint accepts it directly. The successor audit rules out joint stationarity of every nonzero target for the static identity-coframe ansatz. Graph derivation, orthochronous sign, construction of a stationary varying-coframe replacement, Levi-Civita selection, and continuum Riemann identification remain open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/PhysicalLorentzPlaquetteEinsteinAudit.lean` - exact Einstein and Euler audit of the physical square. At the identity coframe it classifies the limiting mixed vacuum equation: five target components vanish and only the internal `23` rotation on the spacetime `01` plaquette survives. That component violates metric-lowered curvature pair exchange. An exact local link Euler coefficient has area-normalized limit twice its amplitude, so the survivor eventually fails connection stationarity. Combining both sectors proves that no nonzero target in the square family can be jointly stationary at every shrinking refinement level with a static identity coframe. A varying-coframe stationary construction remains open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/VacuumWeylCurvatureTarget.lean` - nonzero convention-locked algebraic target for the next refinement. It constructs a two-parameter diagonal curvature operator with bivector coordinates `(-x-y,y,x,x,y,-x-y)`, proves face antisymmetry, metric-lowered pair exchange, algebraic first Bianchi, and vanishing mixed Ricci, scalar, and Einstein tensors at the identity coframe, and packages the nonzero unit member. It is not yet a group-valued plaquette refinement or stationary varying-coframe solution. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/PeriodicVacuumWeylMeanObstruction.lean` - exact necessary conditions for realizing the vacuum-Weyl target by first-order periodic links. It proves componentwise zero site sum and the three-direction discrete Bianchi identity for every additive plaquette curl, rules out exact and fixed-carrier site-independent nonzero Weyl limits, and shows that both parameters of any site-decorated diagonal Weyl field with fixed bivector eigenplanes must be shift invariant. The scalar unit specialization and explicit zero-mean `2 x 2` checkerboard are therefore not realizable. Boundary, twisted-bundle, nonlinear-leading, or genuinely frame-mixed escapes remain open. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/PeriodicVacuumWeylNullWave.lean` - first constructive frame-mixed escape from the periodic diagonal no-go. On a two-site carrier it realizes a plus-polarized null-wave curvature as the exact additive curl of two transverse null-rotation link potentials. The curvature is nonzero pointwise with opposite site amplitudes, face-antisymmetric, metric-lowered pair symmetric, algebraic- and discrete-Bianchi, and exactly Ricci, scalar, and mixed-Einstein flat at identity coframe. [DRAFT-LEAN]
- `PhysicsSM/Draft/NullEdge/PeriodicVacuumWeylNullWaveProperLift.lean` - exact proper eta-Lorentz lift of the two-site null wave. Commuting nilpotent null rotations turn every plaquette into the exponential of its additive curl without a BCH correction; the trace extractor returns exactly area times the target, and the identity coframe is exactly finite coframe-stationary. One exact link Euler coefficient is `-2 * area`, so at nonzero area the same static coframe is neither connection-stationary nor jointly stationary. A jointly stationary varying coframe, Levi-Civita selection, and graph-derived refinement remain open. [DRAFT-LEAN]

## Overnight run 2026-07-08 (AgentTasks/overnight-allmass-run-2026-07-08/)

- `RUN_PLAN.md` - constitution: co-equal Claude+Codex, tier-K targets, lit cadence, discipline. [LIVE]
- `MANUSCRIPT_SPEC.md` - the all-mass manuscript spec with audit gates G1-G5 and the anchor rule. [LIVE]
- `GOAL_PROMPT_CLAUDE.md`, `GOAL_PROMPT_CODEX.md` - executor standing orders (Codex: Spark subagents for external lit). [STABLE]
- `LEDGER.md`, `LIT_SEARCH_LOG.md` - append-only coordination + literature logs. [LIVE]
- `S1CC_RESOLUTION.md` - the central positivity crux framed as a conditional structured no-go: finite balance engine landed, physical `J Q_C|V'/N` bridge still MEMO; theorem ladder + kill conditions. [LIVE]
- `STRENGTHENING_ROADMAP.md` - post-review strengthening targets T1-T7, including the two-edge positive-sector witness, bridge split, Pauli-term test, and checkerboard continuum anchor. [LIVE]
- `T2_MULTIEDGE_ESCAPE_FINDING.md` - MEMO/oracle finding that a two-edge Cl(4) carrier supplies a `J`-positive sector under aperture dominance; Lean witness still open. [LIVE]
- `DELTA_BINDING_ENERGY_FINDING.md` - MEMO/oracle finding splitting the naive S3/S4 bridge into a free equality target plus a closure-controlled binding-defect conjecture. [LIVE]
- `C4_SECTORED_INDEX_AND_STRATEGY.md` - Fable call-02: the reflection-sectored chiral index (double-pinning is Lefschetz, not winding) + the ranked next-target strategy. [LIVE]
- `DYNAMICS_GROUNDWORK.md` - PhysLean-inspired clean-room dynamics roadmap
  (D1 finite action/EOM, D2 conservation, D3 transfer evolution, D4 RG flow,
  D5 canonical ensemble) plus implemented finite D1-D5 seeds, quadratic
  mass-shell/symmetry scaffolds, and simulation harness.
  [LIVE]
- `MORNING_REPORT.md` - short dawn report for the user; read before the scorecard. [LIVE]
- `HONEST_SCORECARD.md` - the run's honest accounting (landings, oracles, kills, remainder); finalized near dawn. [LIVE]
- `Null_Edge_All_Mass_Manuscript_2026-07-08_v1.md` (Sources/) - see manuscripts. [DRAFT-MS]
- `COLLABORATOR_BRIEF_2026-07-08.md` - standalone external brief: status snapshot + the seven hardest challenges (C1-C7) + closed-routes list; safe to send outside. [STABLE]

## Overnight run 2026-07-09 (AgentTasks/overnight-allmass-run-2026-07-09/)

- `RUN_PLAN.md` - theorem-suite constitution, audit gates, agent lanes, and
  public Lean reference-package policy. [LIVE]
- `GOAL_PROMPT_CLAUDE.md`, `GOAL_PROMPT_CODEX.md` - executor standing orders.
  [LIVE]
- `LEDGER.md` - append-only coordination and theorem-job state. [LIVE]
- `2026-07-09_PRO_broader-physics-null-information.md` - triage of the
  finite-null-information reconstruction program: gauge-mass Gram landing,
  spin-fiber job, existing anchors, missing theorem layers, and the required
  Hilbert-vs-Krein adjoint correction. [LIVE]
- `2026-07-09_FABLE_positive-hodge-structural-audit.md` - structural audit of
  quotient positivity, Hilbert-vs-Krein Hodge theory, rank-vs-area language,
  reconstruction circularity, generation monodromy, and the next theorem
  targets. [LIVE]

## Overnight run 2026-07-10 (AgentTasks/overnight-null-information-run-2026-07-10/)

- `RUN_PLAN.md` - constitution for the manuscript, formalization, and
  proof-linked simulation run; includes evidence gates, Aristotle cadence,
  literature cadence, division of labor, and the 07:00 hard audit switch.
  [LIVE]
- `GOAL_PROMPT_CLAUDE.md`, `GOAL_PROMPT_CODEX.md` - co-equal executor standing
  orders for manuscript/simulation and proof/audit leadership. [LIVE]
- `COLLABORATOR_BRIEF_2026-07-10.md` - standalone scientific brief for external
  strategy, literature, and theorem-design reviews. [LIVE]
- `MANUSCRIPT_CLAIM_MATRIX.md` - claim-to-theorem-to-witness-to-simulation-to-
  falsifier evidence registry for the strengthened manuscript. [LIVE]
- `THEORY_COMPLETION_MATRIX.md` - whole-theory architecture registry from
  primitive ontology through dynamics and known physics to empirical
  prediction; prevents local theorem accumulation from substituting for a
  unified theory. [LIVE]
- `SIMULATION_BENCHMARKS.md` - benchmark ladder and validation registry,
  separating exact fixtures, theorem regressions, reproductions, calibrated
  fits, and genuine predictions. [LIVE]
- `DOCUMENT_INTAKE_MAP.md` - operational decomposition of the three finite
  null-information source essays into existing anchors and next proof rungs.
  [LIVE]
- `LEDGER.md`, `LIT_SEARCH_LOG.md`, `FOLLOWUP_JOBS.md` - append-only
  coordination, literature, and Aristotle follow-up records. [LIVE]
- `HONEST_SCORECARD.md`, `MORNING_REPORT.md` - dawn claim/trust audit and final
  user-facing report templates. [LIVE]

## Overnight publication run 2026-07-11 (AgentTasks/overnight-publication-run-2026-07-11/)

- `RUN_PLAN.md` - publication-first constitution: Paper A ship target, decisive
  theorem races for Papers B-E, top-tier referee gates, Aristotle/literature
  cadence, artifact standard, and the 07:00 hard audit. [LIVE]
- `GOAL_PROMPT_CODEX.md`, `GOAL_PROMPT_CLAUDE.md` - co-equal standing orders
  for proof/artifact leadership and Fable manuscript/positioning leadership.
  [LIVE]
- `PAPER_GATE_MATRIX.md`, `MANUSCRIPT_CLAIM_MATRIX.md`,
  `REFEREE_OBJECTION_REGISTER.md` - publication readiness, exact claim anchors,
  and hostile-referee dispositions. [LIVE]
- `ARISTOTLE_QUEUE.md`, `LEDGER.md`, `LIT_SEARCH_LOG.md` - ranked proof fleet,
  append-only coordination, and literature/package provenance. [LIVE]
- `ARTIFACT_MANIFEST.md`, `HONEST_SCORECARD.md`, `MORNING_REPORT.md` - release
  requirements and dawn handoff. [LIVE]

## 24-hour publication run 2026-07-11 to 2026-07-12 (AgentTasks/24h-publication-run-2026-07-12/)

- `RUN_PLAN.md` - successor constitution rooted in the verified 55-module
  publication baseline; prioritizes Paper C stability/index, Paper D
  changing-lattice composition, Paper E interacting dynamics, Paper F
  decorated-carrier classification, and a theorem-gated Jordan-Clifford bridge
  for the Furey-Baez manuscript.
  [LIVE]
- `JORDAN_CLIFFORD_BRIDGE_PROGRAM.md` - proposed dependency chain from a nested
  exceptional-Jordan flag to weak/color spaces, Furey's exterior module, a
  five-mode generation, and the representation-level `Z6` kernel; includes
  semantic corrections, source-verification tasks, and field-theory gates.
  [LIVE]
- `GOAL_PROMPT_CODEX.md`, `GOAL_PROMPT_CLAUDE.md` - disjoint default lanes,
  shared harvest/audit rules, and a 09:45 PDT July 12 completion target. [LIVE]
- `ARISTOTLE_QUEUE.md`, `PAPER_GATE_MATRIX.md`,
  `REFEREE_OBJECTION_REGISTER.md` - inherited-job disposition, first-wave
  theorem targets, publication gates, and hostile-referee tests. [LIVE]
- `LEDGER.md`, `LIT_SEARCH_LOG.md`, `MANUSCRIPT_CLAIM_DELTA.md`,
  `ARTIFACT_MANIFEST.md` - append-only coordination and deltas from the
  audited July 11 baseline. [LIVE]
- `HONEST_SCORECARD.md`, `FINAL_REPORT.md` - final independent audit and
  two-pass-verifier handoff templates. [LIVE]

## Active run: two-day carrier run (AgentTasks/twoday-carrier-run-2026-07-07/)

- `RUN_PLAN.md` - the run's constitution (roles, cadences, discipline). [LIVE]
- `LEDGER.md` - append-only coordination log; the run's ground truth. [LIVE]
- `THREAD_BOARD.md` - work queue with done-conditions. [LIVE]
- `FABLE_QUEUE.md` - standing escalation channel for conceptual blockers. [LIVE]
- `SYNTHESIS_BEYOND_MASS.md` - the index-trinity frame, positivity reroutes, checkerboard bridge, ranked ladder. [LIVE]
- `FABLE_HANDOFF_HARDEST_PIECES.md` - Fable's attack plans for the twelve hardest open pieces (sharpened targets, routes, pre-registered outcomes, packaging). [STABLE]
- `NULLEDGE_PROGRAM_AND_EXTENSIONS.md` - collaborator-facing overview + ranked extensions. [STABLE]
- `WITNESS_SATISFIABILITY.md` - the glue-witness mathematics (kernel transcription OPEN). [LIVE]
- `ARISTOTLE_PLAYBOOK.md`, `FABLE_CALL_PROTOCOL.md`, `LIT_NEO4J_PROTOCOL.md` - run protocols. [STABLE]
- `fable-parallel/` - self-contained briefing + ten deep-work question packets (Q01-Q10) with README; results land in `fable-parallel/results/`. [LIVE]
- `GOAL_PROMPT_CLAUDE.md`, `GOAL_PROMPT_CODEX.md` - executor standing orders. [STABLE]

## Publications and manuscripts (Sources/)

- P1 manuscript and publication plan/outlines - see null-edge core above.
- `Sources/Hamming_ConstructionA_E8_Manuscript_Revision.md` (+ `_Draft`, `_Review`, `.tex`) - the E8 paper. [DRAFT-MS]
- `Sources/CodeLatticeE8_Publication_Theorem_Map.md` - theorem map for the E8 artifact. [STABLE]
- `Sources/CodeLatticeE8_Trust_Report.md` - trust/verification report for the E8 artifact. [STABLE]
- `Sources/Furey_Baez_DVT_Formalization_Paper_Outline.md` - octonion/SM formalization paper outline. [STABLE]
- `Sources/Furey_Baez_Octonion_SM_Formalization_Manuscript_2026-07-11.tex` - the
  Furey + Baez/DVT formalization manuscript (draft v1, written from the outline
  against the live trusted tree; compiles clean; AFM-targeted). [DRAFT-MS]

## Research references and surveys (Sources/, selected)

- `Sources/Furey_Baez_Octonions_Standard_Model_Survey.md` - the division-algebra SM survey. [STABLE]
- `Sources/Null_Edge_References.md` - live null-edge/NullStrand source-key and
  verification-status map; conservative, not a final bibliography. [LIVE]
- `Sources/Baez_Standard_Model_Octonions_Lean_Proof_Plan.md` - proof plan for the Baez route. [STABLE]
- `Sources/Exceptional_Jordan_Projective_Geometry_Lit_Search.md` - J3(O) literature. [STABLE]
- `Sources/NERD_1.md` ... `NERD_4.md` - NERD program foundational analyses. [STABLE]
- `Sources/ChatGPT_Pro_NullEdge_Unification_Synthesis_2026-06-25.md` - external synthesis memo. [HISTORICAL]
- `Sources/A_null-strand_Bohm-Bell_theory.md` - null-strand foundations memo. [STABLE]
- `Sources/NullStrand_Lean_Roadmap.md` (+ blueprint DAG, traceability CSVs) - null-strand Lean planning. [HISTORICAL]

## Lean code anchors (what to open first)

- `PhysicsSM.lean` - project root/imports.
- `PhysicsSM/Spinor/PluckerMass.lean` - the trusted P1 kinematic mass theorem.
- `PhysicsSM/Draft/NullEdge/Carrier/` - the carrier layer (Weitzenboeck,
  Krein, witnesses, index protection); `CarrierAxiomGuard.lean` is the
  build-enforced flagship list for the lane.
- `PhysicsSM/Draft/NullEdge/GateYM/SlabAxiomGuard.lean` - the closure/gauge
  lane's guard (area law, transfer gap, QC bridge).
- `PhysicsSM/Draft/NullEdge/GateC1/`, `GateC2.lean`, `GateI1.lean` - chirality
  substrate and index/certified-sign layers.
- `CodeLatticeE8.lean` (+ `CodeLatticeE8/Publication/TheoremIndex.lean`) - the
  E8 publication artifact and its compile-checked theorem index.
- `PhysicsSM/Algebra/Octonion/` - the XOR-basis octonion core and
  `ConventionBridge`.

## Maintenance rules

1. New top-level or program-defining doc -> add a line here in the right
   category, with a status tag, in the same commit.
2. Superseding a doc -> retag the old one [HISTORICAL] and add a banner line
   at its top pointing here; do not delete.
3. Run directories get ONE block while active; on run completion, collapse to
   the run's final report + ledger and retag.
