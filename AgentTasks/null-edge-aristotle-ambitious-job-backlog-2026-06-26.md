# Null-edge Aristotle ambitious job backlog

Date: 2026-06-26.

Purpose: collect a launch menu of large, important Aristotle jobs for the
null-edge/null-strand mass and super-Dirac program. This is intentionally
ambitious. Aristotle should be used as the proof-specialist and deep-audit agent
for the hardest Lean, mathematics, physics, and strategy tasks in this repo.

Guiding rule: each job should test or build a real gate. Avoid small polish jobs
unless they unblock a proof, an audit, or a manuscript claim boundary.

Status labels:

| Status | Meaning |
| --- | --- |
| Submitted | Already sent to Aristotle; await return or incorporation. |
| Returned | Aristotle has returned it; integrate or use as context. |
| Next | Good near-term candidate once current jobs land. |
| Future | Ambitious later candidate. |
| Contingent | Submit only if an earlier gate succeeds or fails in a specific way. |

Job types:

| Type | Meaning |
| --- | --- |
| Proof | Lean formalization/proof job. |
| Audit | No-build mathematical, physical, or semantic audit. |
| Strategy | No-build plan/architecture job. |
| Source | Literature, citation, and provenance job. |
| Prediction | Moduli, spectral-action, or codimension job. |
| Manuscript | Paper-structure and claim-boundary job. |

## Returned foundation jobs

| ID | Status | Type | Aristotle project | Ambitious target | Expected durable artifact |
| --- | --- | --- | --- | --- | --- |
| R1 | Returned | Strategy | `87530423-050a-43be-80d1-1db49501ba81` | Grand strategy for the null-edge unified mass plan. | `AgentTasks/null-edge-unified-mass-grand-strategy-report.md` |
| R2 | Returned | Strategy | `87530423-050a-43be-80d1-1db49501ba81` | Full P1 to P1.5 to P2 theorem chain. | `AgentTasks/null-edge-unified-mass-proof-chain.md` |
| R3 | Returned | Strategy | `87530423-050a-43be-80d1-1db49501ba81` | Next Aristotle job wave design. | `AgentTasks/null-edge-unified-mass-aristotle-next-jobs.md` |
| R4 | Returned | Audit | `31c2b320-3029-40a7-b62e-e6785a87c4fc` | Convention remainder audit. | `AgentTasks/null-edge-conventions-remainder-audit.md` |

## Submitted jobs awaiting return or incorporation

| ID | Status | Type | Aristotle project | Ambitious target | Expected durable artifact |
| --- | --- | --- | --- | --- | --- |
| S1 | Submitted | Proof | `68195a9e-3b2e-4048-bb20-b8f6e1fa9179` | Yukawa checkerboard square plus rectangular singular-value theorem. | `PhysicsSM/Draft/NullEdgeYukawaCheckerboard.lean` |
| S2 | Submitted | Proof | `48a2d51f-c9b3-470b-8ac8-bbe07705ce3d` | Electroweak stabilizer kernel and rank. | `PhysicsSM/Draft/NullEdgeElectroweakStabilizer.lean` |
| S3 | Submitted | Proof | `4c452451-75a7-4369-bdf1-8ae007d67f24` | Abelian Higgs gauge-invariant link stiffness. | `PhysicsSM/Draft/NullEdgeAbelianHiggsLink.lean` |
| S4 | Submitted | Audit | `2204d007-0993-4d62-9a68-3e72076f37e2` | Super-Dirac sign and `Phi_H^2` double-counting audit. | `AgentTasks/null-edge-super-dirac-sign-double-counting-audit.md` |
| S5 | Submitted | Source | `0abc9ebc-9f37-4736-8f7a-0905246f0b11` | Prior-art and citation verification for P1/P1.5/P2. | `AgentTasks/null-edge-mass-prior-art-citation-audit.md` |
| S6 | Submitted | Prediction | `415617f5-8d10-446f-90f2-1a60f4dd68f4` | Moduli-rank prediction ledger and codimension gate. | `AgentTasks/null-edge-moduli-rank-prediction-ledger.md` |
| S7 | Submitted | Audit | `6e22a037-284c-45e6-91cc-10067ba274cb` | Flat determinant branch-count and no-doubling protocol. | `AgentTasks/null-edge-flat-branch-count-protocol.md` |
| S8 | Submitted | Proof | `24277f1f-9a74-4039-baf6-94f1a9386ebe` | Scalar/gauge null kinetic reconstruction theorem. | `PhysicsSM/Draft/NullEdgeScalarKineticReconstruction.lean` |
| S9 | Submitted | Proof | `96c40dde-bed2-4c5d-947b-a43bfa5203ca` | Flat affine dual-soldered commutator theorem. | `PhysicsSM/Draft/NullEdgeDualSolderedCommutator.lean` |
| S10 | Submitted | Proof | `b5635fbd-1c19-40ca-ad7f-4eca82e5ef46` | Finite tetrad-postulate frame-term vanishing. | `PhysicsSM/Draft/NullEdgeFiniteTetradPostulate.lean` |
| S11 | Submitted | Audit | `4d37f13e-bc2f-4580-9c73-26788056f39b` | FMS-style finite graph W/Z composite audit. | `AgentTasks/null-edge-fms-wz-composite-audit.md` |
| S12 | Submitted | Strategy | `6bb035e3-4c3d-4466-9001-33148957cdb1` | Continuum square-limit and Lichnerowicz compatibility strategy. | `AgentTasks/null-edge-continuum-square-limit-strategy.md` |
| S13 | Submitted | Audit | `5f8e4aa4-d578-4ee8-b7aa-680fc11a450d` | Krein physical-sector stability audit. | `AgentTasks/null-edge-krein-stability-audit.md` |
| S14 | Submitted | Strategy | `d4d2804d-c449-464b-9944-82f0313c6a57` | Chiral mechanism decision strategy. | `AgentTasks/null-edge-chiral-mechanism-strategy.md` |
| S15 | Submitted | Proof | `148ad477-a504-4a30-b096-81845693435b` | Standard Model one-generation anomaly cancellation proof. | `PhysicsSM/Draft/StandardModelAnomalyAudit.lean` |
| S16 | Submitted | Audit | `715dfd7b-d6cb-41e2-ae65-dea04489dbf5` | QCD boundary and finite obstruction-map scoping audit. | `AgentTasks/null-edge-qcd-obstruction-scope.md` |

## Gate A: convention freeze and finite sign algebra

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| A1 | Next | Proof | Kernel-clean `superDirac_square_sign_audit` theorem with positive and negative sign cases. | Locks the most dangerous `+Phi_H^2` versus `-Phi_H^2` trap in Lean. | `PhysicsSM/Draft/NullEdgeSuperDiracSignAudit.lean` |
| A2 | Next | Proof | Four explicit tiny matrix counterexamples for wrong grading assumptions. | Prevents future agents from repairing sign errors by conflating gradings. | `PhysicsSM/Draft/NullEdgeGradingCounterexamples.lean` |
| A3 | Next | Audit | Update `docs/CONVENTIONS.md` from the convention audit recommendations. | Finishes convention-locking without declaring theorem outcomes by convention. | `AgentTasks/null-edge-conventions-integration-audit.md` |
| A4 | Future | Proof | Formalize the canonical obstruction datum as an abstract finite schema. | Makes every mass claim state its `B`, kernel locus, and claim label. | `PhysicsSM/Draft/CanonicalObstructionDatum.lean` |
| A5 | Future | Audit | Global scan of docs for forbidden or unsafe phrases. | Protects manuscripts from overclaiming `origin of all mass`, gauge-breaking, or prediction language. | `AgentTasks/null-edge-claim-language-audit.md` |
| A6 | Future | Proof | Formal alias and normalization theorem for `K_null`, `Box_null`, and older `K_h` notation. | Removes naming drift in the kinetic operator. | `PhysicsSM/Draft/NullEdgeKineticNormalization.lean` |
| A7 | Future | Manuscript | Create a one-page convention appendix template for P1/P1.5/P2. | Gives every paper the same sign, metric, grading, and claim-label spine. | `Sources/Null_Edge_Convention_Appendix_Template.md` |

## Gate B: finite dual-soldered algebra and P1/P1.5 theorem spine

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| B1 | Next | Proof | Simplex/tetrahedral null-solder frame theorem in general dimension. | Locks the dual-frame algebra and prevents dimension-overclaim. | `PhysicsSM/Draft/NullSolderFrameSimplex.lean` |
| B2 | Next | Proof | Diagonal trace obstruction theorem. | Proves why the diagonal `c(ell_a^flat)` operator is not the active architecture. | `PhysicsSM/Draft/NullEdgeDiagonalObstruction.lean` |
| B3 | Next | Proof | Explicit tetrahedral 3+1 inverse-Gram calculation. | Supplies the algebra used in scalar kinetic and branch-count audits. | `PhysicsSM/Draft/TetrahedralNullGram.lean` |
| B4 | Next | Proof | Full finite square decomposition `D_N^2 = K_null + C_diamond + T_frame`. | Gives the finite algebra core of P2. | `PhysicsSM/Draft/NullEdgeFiniteSquareDecomposition.lean` |
| B5 | Future | Proof | Abstract mass-shell matching theorem for `ker(-K tensor I + I tensor B^dagger B)`. | Prevents double-counting and clarifies how kinetic and obstruction sides meet. | `PhysicsSM/Draft/MassShellMatching.lean` |
| B6 | Future | Proof | Package `B_Pl` explicitly as the canonical Plucker obstruction map. | Turns P1 from an identity into the first canonical-obstruction instance. | `PhysicsSM/Spinor/PluckerObstruction.lean` |
| B7 | Future | Proof | Promote celestial monopole/dipole and rest-frame closure guardrail into trusted surface. | Strengthens P1 and prevents closure-equals-massless confusion. | `PhysicsSM/Spinor/CelestialMomentMass.lean` |
| B8 | Future | Proof | Formalize invariant versus frame-relative mass normalization. | Keeps `det(P)` separate from `det(rho_{p|u})` and `m/E`. | `PhysicsSM/Spinor/FrameAuditedMass.lean` |
| B9 | Future | Proof | SL(2,C) covariance wrapper for the finite Plucker mass theorem. | Gives P1 its Lorentz-covariance theorem rather than prose assurance. | `PhysicsSM/Spinor/PluckerMassCovariance.lean` |
| B10 | Future | Proof | Twistor-chart matching theorem with determinant versus trace normalization. | Differentiates P1 from prior two-twistor models and prevents normalization drift. | `PhysicsSM/Spinor/TwistorPluckerMatch.lean` |
| B11 | Future | Proof | Electroweak coefficient theorem for `m_W`, `m_Z`, and photon masslessness in physics-Hermitian convention. | Turns EW structural theorem into coefficient-level reconstruction. | `PhysicsSM/Draft/NullEdgeElectroweakCoefficients.lean` |
| B12 | Future | Proof | Higgs radial Hessian theorem `m_h^2 = 2 lambda v^2` under fixed scalar normalization. | Adds the scalar-potential obstruction as a clean appendix theorem. | `PhysicsSM/Draft/HiggsRadialHessian.lean` |
| B13 | Future | Proof | Majorana/seesaw Schur-complement theorem. | Gives neutrinos a precise stress-test without claiming a model. | `PhysicsSM/Draft/NeutrinoSeesawSchur.lean` |
| B14 | Future | Strategy | Takagi factorization formalization scoping. | Decides whether a Majorana diagonalization theorem is realistic in current Mathlib. | `AgentTasks/takagi-factorization-formalization-scope.md` |
| B15 | Future | Proof | Nonzero singular-value correspondence for rectangular maps, packaged for Yukawa blocks. | Makes rank deficiency, zero modes, and family masses precise. | `PhysicsSM/Draft/RectangularYukawaSpectrum.lean` |
| B16 | Future | Manuscript | P1.5 theorem note assembling Yukawa, Abelian Higgs, EW stabilizer, and scalar kinetic reconstruction. | Turns scattered bridge theorems into a publishable finite reconstruction paper. | `Sources/Null_Edge_P15_Quadratic_Obstructions_Theorem_Note.md` |

## Gate C: flat branch count, no-doubling, Krein, and chirality

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| C1 | Next | Proof | Determinant branch-count theorem for the tetrahedral flat symbol at high-symmetry points. | Tests the suspected high-momentum null branch directly. | `PhysicsSM/Draft/TetrahedralBranchCount.lean` |
| C2 | Next | Audit | Implement and interpret a flat periodic branch-count script. | Fastest serious failure detector for the retarded operator. | `Scripts/experiments/null_edge_branch_count.py` |
| C3 | Future | Proof | Classify `q = (pi, pi, pi, 0)` as determinant-zero, nonzero-symbol branch. | Converts the warning example into a formal data point. | `PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean` |
| C4 | Future | Audit | Massive branch count for `det(iD_+(q) + Gamma_s Phi) = 0`. | Checks whether mass blocks lift unwanted branches or introduce instabilities. | `AgentTasks/null-edge-massive-branch-count-audit.md` |
| C5 | Future | Proof | Finite Krein double self-adjointness theorem. | Provides the exact Lorentzian adjointness result without overclaiming stability. | `PhysicsSM/Draft/KreinDoubleSelfAdjoint.lean` |
| C6 | Future | Audit | Finite-box Krein spectral stability computation. | Determines whether `J`-self-adjointness produces dangerous complex modes. | `Scripts/experiments/null_edge_krein_spectrum.py` |
| C7 | Future | Proof | Counterexample theorem: `J`-self-adjoint does not imply real spectrum. | Keeps future claims honest and review-proof. | `PhysicsSM/Draft/KreinCounterexamples.lean` |
| C8 | Future | Strategy | Nielsen-Ninomiya assumption audit for the null-edge architecture. | Makes the claimed evasion conditions explicit. | `AgentTasks/null-edge-nielsen-ninomiya-assumption-audit.md` |
| C9 | Future | Proof | SSH/Jackiw-Rebbi finite domain-wall zero-mode pilot. | Tests a concrete chiral mechanism before SM claims. | `PhysicsSM/Draft/DomainWallZeroModePilot.lean` |
| C10 | Future | Audit | Overlap/Ginsparg-Wilson compatibility with retarded/Krein operator. | Decides whether an overlap-like route is viable. | `AgentTasks/null-edge-overlap-compatibility-audit.md` |
| C11 | Future | Proof | Hypercharge anomaly cancellation for three generations and optional sterile neutrino. | Extends the submitted one-generation anomaly audit. | `PhysicsSM/Draft/StandardModelThreeGenerationAnomaly.lean` |
| C12 | Future | Strategy | Chiral sector decision gate after branch count and anomaly jobs return. | Selects or rejects the first real chiral mechanism. | `AgentTasks/null-edge-chiral-sector-decision-gate.md` |
| C13 | Next | Audit | Minimally doubled fermion comparison audit for the flat null-edge operator. | Compares the tetrahedral retarded operator to Misumi, Golterman-Shamir, Weber, and Boricci-Creutz/Karsten-Wilczek branch classifications. | `AgentTasks/null-edge-minimally-doubled-comparison-audit.md` |
| C14 | Next | Audit | Propagator-zero classification table for every high-momentum branch. | Classifies zeros as physical poles, doublers, kinematical zeros, ghost-like singularities, gapped taste partners, projected artifacts, complex instabilities, or redesign triggers. | `AgentTasks/null-edge-propagator-zero-classification.md` |
| C15 | Next | Audit | Counterterm and spin-taste warning audit for BC-like null-edge operators. | Adds branch-control counterterms to the moduli ledger and checks whether prediction/codimension hopes survive. | `AgentTasks/null-edge-counterterm-moduli-audit.md` |
| C16 | Future | Proof | Formal finite high-symmetry nodal-structure theorem for the flat tetrahedral symbol. | Converts the branch-classification table into reusable kernel-checked finite data. | `PhysicsSM/Draft/TetrahedralNodalStructure.lean` |
| C17 | Next | Audit | Spectral-graph species-count audit for the finite null-edge matrix. | Uses spectral-graph lattice-fermion methods to compare finite graph nullity, boundary dependence, and topological dependence with the momentum-symbol branch table. | `AgentTasks/null-edge-spectral-graph-species-audit.md` |
| C18 | Next | Audit | Modified/flavored chirality audit for Gate C zero modes. | Checks whether ordinary chirality misclassifies minimally doubled or graph-native zero modes, and whether a flavored chirality operator is needed. | `AgentTasks/null-edge-flavored-chirality-audit.md` |

## Gate D: continuum symbol, square limit, curvature, and scalar/gauge kinetics

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| D1 | Next | Proof | Smooth local symbol asymptotic `[D_h, M_f] = c(df) + O(h)` in a simplified finite-difference model. | First true continuum estimate beyond affine algebra. | `PhysicsSM/Draft/NullEdgeSmoothSymbolAsymptotic.lean` |
| D2 | Next | Strategy | Estimate framework selection: filters, asymptotic notation, or normed finite-difference API. | Prevents continuum jobs from drowning in analysis infrastructure. | `AgentTasks/null-edge-continuum-estimate-framework.md` |
| D3 | Future | Proof | Curvature diamond coefficient theorem in a flat-to-curved perturbative model. | Tests whether `C_diamond` has the right Pauli/curvature normalization. | `PhysicsSM/Draft/NullEdgeCurvatureDiamond.lean` |
| D4 | Future | Proof | Finite holonomy around null diamonds gives gauge curvature to leading order. | Bridges graph holonomy to continuum field strength. | `PhysicsSM/Draft/NullDiamondHolonomyCurvature.lean` |
| D5 | Future | Proof | Frame-term classification theorem under controlled frame variation. | Distinguishes tetrad defect, torsion-like term, and bad continuum contamination. | `PhysicsSM/Draft/NullEdgeFrameDefectClassification.lean` |
| D6 | Future | Audit | Lichnerowicz comparison audit: exact target formula and convention map. | Prevents false continuum claims and fixes signs before proof work. | `AgentTasks/null-edge-lichnerowicz-comparison-audit.md` |
| D7 | Future | Proof | Commuting-square theorem in the flat scalar case. | First prototype for `D_h^2 -> D_cont^2`. | `PhysicsSM/Draft/FlatContinuumSquareLimit.lean` |
| D8 | Future | Proof | Scalar/gauge kinetic continuum limit from inverse-Gram null quadrature. | Shows Higgs/gauge kinetics are genuinely null-edge reconstructed. | `PhysicsSM/Draft/ScalarGaugeNullKineticLimit.lean` |
| D9 | Future | Strategy | Lorentzian versus Euclidean spectral-action compatibility audit. | Decides what can be responsibly imported from spectral action methods. | `AgentTasks/lorentzian-spectral-action-compatibility-audit.md` |
| D10 | Future | Proof | Super-Dirac square with nonconstant `Phi_H` and Higgs-gradient term. | Proves the full `-i Gamma_s C_a [nabla_a, Phi_H]` structure. | `PhysicsSM/Draft/NullEdgeSuperDiracGradient.lean` |
| D11 | Future | Audit | Retarded/advanced continuum stability and causal support audit. | Checks whether causal support survives scaling. | `AgentTasks/null-edge-retarded-advanced-continuum-audit.md` |
| D12 | Future | Strategy | Full Gate D acceptance/failure review after D1-D11. | Decides whether to continue, redesign, or freeze as finite reconstruction. | `AgentTasks/null-edge-gate-d-decision-review.md` |
| D13 | Next | Strategy | DEC Hodge-Dirac convergence adaptation strategy. | Tests whether Gate D can inherit the Dabetic-Hiptmair DEC/Hodge-Dirac convergence scaffold instead of inventing a continuum proof from scratch. | `AgentTasks/null-edge-dec-hodge-dirac-convergence-strategy.md` |
| D14 | Next | Audit | Connection-Laplacian convergence audit for gauge holonomy. | Maps finite graph holonomy and Higgs covariant-gradient terms to Zahariev/Singer-Wu style connection-Laplacian convergence hypotheses. | `AgentTasks/null-edge-connection-laplacian-convergence-audit.md` |
| D15 | Next | Audit | Causal-set d'Alembertian comparison and falsification probe. | Compares retarded/advanced null-edge scaling with known causal-set d'Alembertian failures and local alternatives. | `AgentTasks/null-edge-causal-dalembertian-falsification-probe.md` |
| D16 | Future | Source | Generalized Lichnerowicz and Dirac-Yukawa source pack. | Gives the super-Dirac square work a precise continuum comparison class for connection-Laplacian plus curvature/endomorphism terms. | `AgentTasks/null-edge-generalized-lichnerowicz-source-pack.md` |

## Gate E: electroweak, gauge-invariant composites, chirality, and physics audits

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| E1 | Next | Proof | Gauge invariance theorem for corrected FMS finite link composite. | Converts FMS wording into a formal finite observable. | `PhysicsSM/Draft/FMSFiniteLinkComposite.lean` |
| E2 | Future | Proof | Vacuum/trivialization expansion of FMS composite to W/Z field component. | Shows usual W/Z fields arise as leading gauge-invariant composite fluctuations. | `PhysicsSM/Draft/FMSCompositeExpansion.lean` |
| E3 | Future | Proof | Photon stabilizer and W/Z orbit decomposition in composite language. | Aligns EW stabilizer theorem with gauge-invariant observables. | `PhysicsSM/Draft/EWCompositeStabilizer.lean` |
| E4 | Future | Audit | Gauge-language manuscript audit across all null-edge papers. | Prevents local gauge-breaking overclaim in public drafts. | `AgentTasks/null-edge-gauge-language-manuscript-audit.md` |
| E5 | Future | Proof | Finite Abelian Higgs small-holonomy expansion with explicit remainder. | Separates exact stiffness from mass-term approximation. | `PhysicsSM/Draft/AbelianHiggsSmallHolonomy.lean` |
| E6 | Future | Proof | Non-Abelian Higgs link-stiffness theorem for compact matrix groups. | Moves from U(1) toy model toward EW-like structure. | `PhysicsSM/Draft/NonAbelianHiggsLinkStiffness.lean` |
| E7 | Future | Proof | EW link-stiffness theorem on finite graph with Higgs doublet. | Connects edge functional directly to EW orbit obstruction. | `PhysicsSM/Draft/EWHiggsLinkStiffness.lean` |
| E8 | Future | Strategy | Chiral anomaly plus FMS plus branch-count integration review. | Checks whether the physics sector is coherent enough for P2. | `AgentTasks/null-edge-physics-audit-integration-review.md` |
| E9 | Future | Source | FMS, EW reviews, Higgs mechanism, and lattice gauge-Higgs source pack. | Gives P1.5/P2 trustworthy citations and novelty boundaries. | `AgentTasks/null-edge-ew-higgs-source-pack.md` |
| E10 | Future | Manuscript | Referee-response memo for `just lattice gauge theory with null labels`. | Prepares the hardest predictable objection. | `AgentTasks/null-edge-lattice-gauge-referee-response.md` |
| E11 | Next | Audit | Quiver spectral-action comparison and novelty-boundary audit. | Compares null-edge graph/Higgs claims against Bratteli-network/quiver spectral-action reconstructions so the manuscript states exactly what is null-edge-specific. | `AgentTasks/null-edge-quiver-spectral-action-comparison.md` |
| E12 | Next | Source | FMS source pack and finite composite-observable theorem plan. | Consolidates gauge-invariant electroweak composite language before formalizing W/Z/H physical excitation claims. | `AgentTasks/null-edge-fms-composite-source-pack.md` |

## Gate F: prediction, spectral action, moduli rank, and constraints

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| F1 | Next | Prediction | Turn moduli ledger into a ranked list of possible codimension constraints. | Chooses the first real prediction target. | `AgentTasks/null-edge-codimension-candidate-ranking.md` |
| F2 | Future | Prediction | Spectral-action parameter-count and redundancy audit. | Tests whether the finite data merely reparametrize EFT. | `AgentTasks/null-edge-spectral-action-parameter-audit.md` |
| F3 | Future | Prediction | Candidate coupling relation from finite spectral action. | First route to a structural relation among `g_1`, `g_2`, `g_3`, and `lambda`. | `AgentTasks/null-edge-coupling-relation-candidate.md` |
| F4 | Future | Proof | Formal parameter-count lemma for simplified finite model versus EFT target. | Kernel-checks the first moduli-rank toy version. | `PhysicsSM/Draft/FiniteEFTParameterCount.lean` |
| F5 | Future | Strategy | Yukawa texture/rank constraint search. | Looks for the most plausible non-numerical mass prediction. | `AgentTasks/null-edge-yukawa-texture-constraint-search.md` |
| F6 | Future | Strategy | Generation-number constraint search. | Tests whether finite geometry can force or explain three generations. | `AgentTasks/null-edge-generation-number-strategy.md` |
| F7 | Future | Proof | Forbidden Pauli counterterm theorem in simplified finite square. | A structural prediction candidate independent of exact masses. | `PhysicsSM/Draft/ForbiddenPauliCounterterm.lean` |
| F8 | Future | Audit | Lorentz-dispersion correction estimate and experimental-bound triage. | If branch structure survives, checks whether deviations are constrained. | `AgentTasks/null-edge-dispersion-correction-audit.md` |
| F9 | Future | Prediction | Full `F : M_finite -> M_EFT` rank/codimension audit after P2 data. | Decides reconstruction versus prediction honestly. | `AgentTasks/null-edge-full-moduli-rank-audit.md` |
| F10 | Contingent | Manuscript | Prediction-gate paper outline. | Only appropriate if at least one codimension relation survives. | `Sources/Null_Edge_Prediction_Gate_Manuscript_Plan.md` |
| F11 | Future | Prediction | Counterterm-rank impact audit after Gate C branch-control proposals. | Prevents tuned branch-control counterterms from being hidden outside the finite-to-EFT moduli ledger. | `AgentTasks/null-edge-counterterm-rank-impact-audit.md` |
| F12 | Next | Prediction | Quiver/spectral-action parameter-count comparison for prediction gate. | Checks whether null-edge finite data reduce parameters relative to generic quiver or finite spectral-action reconstructions. | `AgentTasks/null-edge-quiver-parameter-count-audit.md` |

## QCD boundary and future color-gap jobs

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| Q1 | Next | Manuscript | QCD boundary paragraph package for P1 and P1.5. | Keeps proton-mass language honest while preserving motivation. | `Sources/Null_Edge_QCD_Boundary_Language.md` |
| Q2 | Future | Strategy | Minimal finite color-Hamiltonian toy model scoping. | Decides whether any honest `B_QCD` route exists. | `AgentTasks/finite-color-hamiltonian-scope.md` |
| Q3 | Contingent | Proof | Color-singlet projection gap in a finite toy Hamiltonian. | First possible seed of a finite QCD obstruction map. | `PhysicsSM/Draft/FiniteColorSingletGap.lean` |
| Q4 | Contingent | Audit | Trace anomaly boundary and source audit. | Prevents QCD-scale and proton-mass overclaims. | `AgentTasks/qcd-trace-anomaly-boundary-audit.md` |
| Q5 | Contingent | Strategy | Compare Plucker accounting to parton-model invariant mass decompositions. | Clarifies what P1 can and cannot say about hadrons. | `AgentTasks/plucker-parton-accounting-audit.md` |

## Source, literature, and provenance jobs

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| L1 | Future | Source | Massive spinor-helicity and twistor prior-art differentiation. | Defends P1 novelty precisely. | `AgentTasks/spinor-helicity-twistor-prior-art-audit.md` |
| L2 | Future | Source | Positive Grassmannian and Plucker-coordinate source pack. | Places P1 in established finite geometry. | `AgentTasks/plucker-grassmannian-source-pack.md` |
| L3 | Future | Source | Spinor-network closure versus null-bundle mass audit. | Separates rest-frame closure from masslessness. | `AgentTasks/spinor-network-closure-source-audit.md` |
| L4 | Future | Source | Lichnerowicz and generalized Dirac operator source pack. | Supports P2 continuum comparison. | `AgentTasks/lichnerowicz-dirac-source-pack.md` |
| L5 | Future | Source | Non-Hermitian lattice fermion and Nielsen-Ninomiya evasion source pack. | Supports branch-count and chiral mechanism audits. | `AgentTasks/nonhermitian-lattice-fermion-source-pack.md` |
| L6 | Future | Source | Krein/Lorentzian spectral triples source pack. | Prevents overclaiming Lorentzian stability. | `AgentTasks/krein-lorentzian-spectral-source-pack.md` |
| L7 | Future | Source | Spectral action and SM parameter relation source pack. | Supports prediction-gate work. | `AgentTasks/spectral-action-parameter-source-pack.md` |
| L8 | Future | Source | Neutrino Majorana/Takagi/seesaw source audit. | Keeps neutrino discussion model-neutral. | `AgentTasks/neutrino-seesaw-source-audit.md` |
| L9 | Next | Source | DEC/FEEC Hodge-Dirac convergence source pack. | Anchors Gate D in known cochain-to-continuum convergence theorems. | `AgentTasks/dec-hodge-dirac-convergence-source-pack.md` |
| L10 | Next | Source | Graph spectral species and flavored-chirality source pack. | Anchors Gate C in spectral-graph and minimally doubled fermion diagnostics. | `AgentTasks/graph-species-flavored-chirality-source-pack.md` |
| L11 | Next | Source | Quiver spectral-action and Bratteli-network source pack. | Supports novelty boundaries for finite graph Yang-Mills-Higgs reconstruction. | `AgentTasks/quiver-spectral-action-source-pack.md` |
| L12 | Next | Source | Causal-set d'Alembertian stability source pack. | Turns causal-set continuum failures into explicit Gate D falsification tests. | `AgentTasks/causal-set-dalembertian-source-pack.md` |

## Manuscript and publication jobs

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| M1 | Next | Manuscript | Formal P1 claim-boundary and title rewrite. | Makes the strongest paper review-safe. | `Sources/Null_Edge_P1_Formal_Revision_Plan.md` |
| M2 | Future | Manuscript | Expository P1 companion outline using poetic language safely. | Preserves public-facing power without weakening formal P1. | `Sources/Null_Edge_P1_Expository_Companion_Plan.md` |
| M3 | Future | Manuscript | P1 theorem-to-Lean crosswalk audit. | Ensures the paper claims exactly what Lean proves. | `AgentTasks/p1-theorem-to-lean-crosswalk-audit.md` |
| M4 | Future | Manuscript | P1.5 finite obstruction paper skeleton. | Converts bridge theorems into a paper. | `Sources/Null_Edge_P15_Finite_Obstructions_Manuscript_Plan.md` |
| M5 | Future | Manuscript | P2 finite super-Dirac algebra paper skeleton. | Makes the finite operator core publishable even before prediction. | `Sources/Null_Edge_P2_SuperDirac_Finite_Algebra_Plan.md` |
| M6 | Future | Manuscript | P2b branch-count and Krein audit paper skeleton. | Turns possible negative results into publishable structure. | `Sources/Null_Edge_P2b_Branch_Krein_Audit_Plan.md` |
| M7 | Future | Manuscript | Referee-response dossier for all known objections. | Prepares for skeptical review before submission. | `AgentTasks/null-edge-referee-response-dossier.md` |
| M8 | Future | Manuscript | Claim-ledger table generation for every paper. | Keeps representation/reconstruction/structural/prediction labels visible. | `AgentTasks/null-edge-claim-ledger-paper-tables.md` |
| M9 | Future | Manuscript | Publication sequence decision review after current Aristotle wave lands. | Chooses whether to prioritize P1, P1.5, or P2 finite algebra. | `AgentTasks/null-edge-publication-sequence-review.md` |

## Integration and quality-control jobs

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| I1 | Next | Audit | Aristotle returns integration triage for all current wave jobs. | Prevents incompatible returned assumptions from entering docs or Lean. | `AgentTasks/aristotle-wave-integration-triage.md` |
| I2 | Future | Audit | Semantic alignment audit of all draft Lean statements against docs. | Ensures proofs are proving the intended physics/maths. | `AgentTasks/null-edge-draft-lean-semantic-audit.md` |
| I3 | Future | Audit | Hidden assumption and convention drift audit for `PhysicsSM/Draft/NullEdge*.lean`. | Catches signs, scalar fields, basis, and normalization drift early. | `AgentTasks/null-edge-draft-hidden-assumption-audit.md` |
| I4 | Future | Proof | Promote one completed draft theorem package to trusted surface. | Converts Aristotle proof output into durable repo progress. | Target depends on returned theorem. |
| I5 | Future | Strategy | Decide which finite algebra jobs should become one module hierarchy. | Prevents disconnected draft files from becoming technical debt. | `AgentTasks/null-edge-module-hierarchy-plan.md` |
| I6 | Future | Audit | Pre-submission P1/P1.5 source provenance audit. | Ensures every nontrivial claim has source and convention provenance. | `AgentTasks/null-edge-prepublication-provenance-audit.md` |

## Gate H: internal-spectrum, anomaly, Furey bridge, and legal Yukawa blocks

Provenance: ChatGPT Pro feedback supplied 2026-06-26 in attachment
`ed7c2aa4-281b-4576-9f2c-b0d502052127/pasted-text.txt`.

Gate H is the internal-sector companion to the null-edge kinetic gates. It uses
Furey/formal anomaly work as a candidate internal Standard Model fiber, not as a
solution to the null-edge kinetic core.

Scheduling rule:

```text
Furey/anomaly work supports internal spectrum, chirality, anomaly, and legal
Yukawa-block consistency.

Null-edge work still owns null kinetic geometry, Pluecker mass, dual soldering,
the super-Dirac square, branch count, and continuum scaling.
```

Do not present Furey as explaining null-edge mass. Present it as supplying a
kernel-checked candidate internal fiber on which the null-edge super-Dirac
operator may act.

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| H1 | Next | Proof | Define a reusable `NullEdgeInternalSpectrum` API independent of Furey. | Gives the null-edge program a clean target for internal charge, grading, and multiplet data. | `PhysicsSM/Draft/NullEdgeInternalSpectrum.lean` |
| H2 | Next | Proof | Prove a Furey-to-null-edge one-generation bridge mapping to `standardModelOneGeneration`. | Reuses the trusted anomaly package instead of rebuilding anomaly arithmetic. | `PhysicsSM/Draft/FureyNullEdgeOneGeneration.lean` |
| H3 | Next | Proof | Anomaly inheritance theorem from `toChiralMultipletList = standardModelOneGeneration`. | Turns internal-spectrum matching into local and Witten anomaly freedom. | `PhysicsSM/Draft/NullEdgeInternalAnomalyInheritance.lean` |
| H4 | Next | Proof | Legal Yukawa flip classification against hypercharge, weak, and color neutrality. | Converts draft Yukawa bookkeeping into a reusable finite theorem package. | `PhysicsSM/Draft/NullEdgeLegalYukawaFlips.lean` |
| H5 | Future | Proof | Build `Phi_H` from legal Furey/null-edge flips and prove gauge neutrality, internal oddness, and square-to-mass-block. | Makes the internal zero-order mass block non-arbitrary while preserving the `Gamma_s`/`chi_E` separation. | `PhysicsSM/Draft/FureyPhiHBlock.lean` |
| H6 | Future | Audit | Singlet-completion audit: identify what Furey forces versus what is added to complete one SM generation. | Distinguishes reconstruction from prediction and avoids overclaiming right-handed singlet data. | `AgentTasks/null-edge-furey-singlet-completion-audit.md` |
| H7 | Future | Audit | Triality/generation audit. | Separates "three anomaly-free relabeled copies" from "three physical generations are forced." | `AgentTasks/null-edge-furey-triality-generation-audit.md` |
| H8 | Future | Prediction | Internal-sector codimension audit for representations, Yukawa texture, rank, or forced zeros. | Tests whether Furey/null-edge internal constraints become a genuine prediction gate. | `AgentTasks/null-edge-furey-internal-codimension-audit.md` |
| H9 | Future | Strategy | Decide whether Furey is optional internal realization, preferred realization, or core assumption. | Prevents mixing the division-algebra internal-spectrum story too early with the null-edge kinetic story. | `AgentTasks/null-edge-furey-role-decision.md` |
| H10 | Future | Audit | Kähler-Dirac anomaly comparison for null-edge cochain/form-degree fermions. | Tests whether form-degree Dirac structure produces anomaly or flavor-count constraints relevant to chirality and prediction gates. | `AgentTasks/null-edge-kahler-dirac-anomaly-comparison.md` |
| H11 | Next | Audit | Finite spectral-triple moduli comparison for internal Dirac blocks. | Compares `Phi_H`/internal zero-order blocks against finite spectral-triple Dirac-operator moduli so prediction language does not hide free internal parameters. | `AgentTasks/null-edge-finite-spectral-triple-moduli-audit.md` |

Claim-boundary rule:

```text
Gate H can make the internal chiral spectrum anomaly-safe and non-arbitrary.
It does not solve super-Dirac signs, determinant branches, Krein stability,
continuum Lichnerowicz limits, QCD confinement, or numerical Yukawa values.
```

Architecture rule:

```text
H_total = H_null/spin/graph tensor H_internal/Furey

D_N   acts on the null/spin/graph factor.
Phi_H acts on the internal/Furey factor through legal Higgs/Yukawa maps.
```

The grading rule remains:

```text
Phi_H is odd under internal grading chi_E.
Phi_H commutes with spacetime chirality Gamma_s.
```

## Suggested next launch waves

## Pro feedback update: integration freeze before expansion

Provenance: ChatGPT Pro feedback supplied 2026-06-26 in attachment
`7881faf4-ad66-45f7-a25c-8aa908ea951c/pasted-text.txt`.

Operational rule:

```text
Integrate before expanding.
```

The submitted Aristotle waves already stress-test the architecture across
Yukawa, electroweak, Abelian Higgs, sign/double-counting, source provenance,
moduli rank, determinant branches, scalar/gauge reconstruction, dual soldering,
tetrad defects, FMS composites, continuum square limits, Krein stability,
chirality, anomaly cancellation, and QCD scoping. The next high-value round is
therefore not another broad proof wave. It is an integration-freeze wave.

Hard scheduling rule:

```text
No Wave 4 proof jobs should be launched until returned jobs have been triaged
for assumptions, signs, frame normalization, and claim labels.
```

Gate A is now a hard prerequisite:

```text
Gate A must pass before any finite square theorem is promoted.
```

This means B4-style finite square decomposition may be developed experimentally,
but it should not enter a trusted surface until A1/A2/A3 settle the sign,
grading, and convention integration issues.

Gate B ordering is tightened:

```text
B1 -> B3 -> B2 -> B4
```

B1/B3 establish the null-solder frame and inverse-Gram normalization; B2 then
proves why the diagonal operator is not active; B4 then uses the dual-soldered
coefficients `C_a = c(alpha^a)` without ambiguity.

Add dependency note:

```text
S8 scalar/gauge null kinetic reconstruction must be re-audited against B1/B3
before promotion.
```

Gate C is a possible kill switch:

```text
Do not launch heavy D-continuum work until C1/C2 return.
```

Branch-count raw implementation and branch-count interpretation should be split:

```text
C2a: implement script and output raw branch data.
C2b: interpret branches against acceptance/failure criteria.
```

Krein finite theorem and counterexample should travel together:

```text
C5 + C7
```

The finite `J`-self-adjointness theorem is useful, but the counterexample that
`J`-self-adjointness does not imply real spectrum/stability is equally important
for preventing overclaim.

Gate D should wait except for D2:

```text
D2 estimate-framework selection before D1 smooth symbol asymptotic.
```

Gate E should wait for S11:

```text
S11 -> E1 -> E2 -> E3
```

Do not formalize an FMS composite before the returned FMS audit identifies the
correct composite.

Gate F remains strategic until P2 data exist:

```text
F1 may rank candidate constraints.
F2 should be a parameter-audit template only, not a conclusion about prediction.
```

Integration invariant for all returned proof jobs:

```text
Every trusted theorem must declare its metric, grading, kinetic-sign, and
frame-normalization imports.
```

### Added integration-control jobs

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| G0 | Next | Strategy | Dependency graph generator for all null-edge Aristotle jobs and assumptions. | The job graph is too large to manage mentally. | `AgentTasks/null-edge-job-dependency-dag.md` |
| G1 | Next | Audit | Trusted theorem promotion policy for `PhysicsSM/Draft/*`. | Prevents compiled but semantically misaligned proofs from entering trusted code. | `AgentTasks/null-edge-trusted-theorem-promotion-policy.md` |
| G2 | Next | Audit | Sign and normalization dashboard across returned files. | Prevents `K`, `Box`, `D^2`, `Phi_H^2`, metric, and frame drift. | `AgentTasks/null-edge-sign-normalization-dashboard.md` |
| G3 | Next | Audit | Branch-count acceptance criteria before interpreting branch data. | Prevents post hoc reinterpretation of high-momentum determinant-zero branches. | `AgentTasks/null-edge-branch-count-acceptance-criteria.md` |
| G4 | Next | Audit | Null-edge specificity audit for every P1.5 theorem. | Answers the referee question: what uses null edges rather than graph labels? | `AgentTasks/null-edge-specificity-audit.md` |

### Revised immediate wave: integration freeze

| Priority | Jobs |
| --- | --- |
| 1 | I1, G0 |
| 2 | A3, G1, G2 |
| 3 | M1, G3, G4 |
| 4 | C2a only if it can proceed independently from interpretation |

### Revised Wave 4: convention and finite core

| Priority | Jobs |
| --- | --- |
| 1 | A1, A2, A6 |
| 2 | B1, B3, B2 |
| 3 | integrate S8/S9/S10 returned outputs |
| 4 | B4 only after A1/A2 and B1/B3 |

### Revised Wave 5: branch/Krein kill switch

| Priority | Jobs |
| --- | --- |
| 1 | C1, C2b, C3 |
| 2 | C5, C7 |
| 3 | C6 if C5/C7 are stable enough |
| 4 | C8 only after branch-count evidence exists |

### Revised Wave 6: P1.5 theorem packaging

| Priority | Jobs |
| --- | --- |
| 1 | integrate S1/S2/S3 |
| 2 | B15 if S1 did not cover singular values cleanly |
| 3 | E1 only after S11 |
| 4 | B16/M4 P1.5 theorem note |

### Revised Wave 7: continuum and prediction

| Priority | Jobs |
| --- | --- |
| 1 | D2 before D1 |
| 2 | D6 before D3/D4/D7 |
| 3 | F1 as candidate ranking |
| 4 | F2 only as parameter-audit template |

### Safe publication fallback matrix

| Failure | Downgrade | Safe fallback |
| --- | --- | --- |
| dual-soldered symbol fails | freeze graph-operator branch | P1 only: finite Plucker theorem |
| determinant branch fatal | redesign retarded operator | publish no-go/branch-count audit |
| Krein instability | mark retarded/Krein branch unstable | finite algebra only, no dynamics |
| scalar/gauge null kinetic fails | Higgs/W/Z only graph reconstruction | P1.5 as standard graph-Higgs bridge |
| FMS composite fails | remove physical W/Z composite claims | keep rank/stabilizer algebra only |
| chirality fails | no SM chirality claim | vector-like toy model only |
| full-rank `F` | reconstruction not prediction | publish finite reconstruction architecture |
| no `B_QCD` | QCD boundary only | keep QCD as motivation |

Wave 4, after current submitted jobs return:

| Priority | Jobs |
| --- | --- |
| 1 | A1, A2, A3 |
| 2 | B1, B2, B3, B4 |
| 3 | C1, C2, C5 |
| 4 | M1, I1 |

Wave 5, if Gate B finite algebra is healthy:

| Priority | Jobs |
| --- | --- |
| 1 | B5, B6, B7, B8 |
| 2 | D1, D2, D3, D4 |
| 3 | E1, E2 |
| 4 | F1, F2 |

Wave 6, if branch count and Krein audits are not fatal:

| Priority | Jobs |
| --- | --- |
| 1 | C4, C6, C8, C9 |
| 2 | D5, D6, D7, D8 |
| 3 | E8, F3, F5 |
| 4 | M4, M5, M6 |

## Hard stop and downgrade criteria

Submit downgrade/review jobs rather than more proof jobs if any of these occur:

| Trigger | Downgrade action |
| --- | --- |
| No dual-soldered finite symbol can be proved. | Freeze graph-operator branch as related finite algebra and revise P2 claims. |
| Determinant branch count shows unavoidable physical doublers. | Launch redesign/no-go audit before more continuum work. |
| Krein audit shows unavoidable growing physical modes. | Treat retarded/Krein branch as unstable until redesigned. |
| Scalar/gauge null kinetic reconstruction fails. | Downgrade Higgs/W/Z null-edge claims to graph reconstruction with null labels. |
| FMS composite cannot be made gauge invariant. | Stop electroweak physical-excitation claims and rewrite gauge language. |
| Chiral mechanism fails or forces vector-like spectrum. | Downgrade Standard Model chirality claims. |
| `F : M_finite -> M_EFT` is full rank with no relation. | Keep program as unified reconstruction, not prediction. |
| No finite `B_QCD` can be specified. | Keep QCD as motivation/boundary only. |

## Pro synthesis scheduling update after literature pass - 2026-06-26

Provenance: ChatGPT Pro feedback supplied in attachment
`492f4b4d-8bb9-45bc-a2d2-e0baf0513631/pasted-text.txt`.

The next Aristotle waves should use the literature pass to sharpen existing
jobs rather than broaden the backlog indiscriminately.

### Gate D refinement

Use D13/D14/D15/D16 as a staged continuum strategy:

```text
D13: positive DEC/Hodge-Dirac proxy and hypothesis checklist.
D14: connection/holonomy perturbation using Zahariev/Singer-Wu style
     connection-Laplacian hypotheses.
D16: generalized Lichnerowicz/Dirac-Yukawa target formula and convention map.
D15: retarded/Lorentzian causal-set-style stability pressure as a falsification
     probe, not as a direct no-go theorem.
```

Do not submit heavy continuum limit theorem jobs until the positive proxy,
symbol theorem, and Gate C branch audit are stable.

### Gate C refinement

Use C14/C17/C18 as one package:

```text
C14: determinant/propagator-zero classification table.
C17: graph-native spectral nullity and species audit.
C18: flavored-chirality audit, but only after the branch set is known.
```

Acceptance language:

```text
retardedness removes coefficient-vector doublers,
not determinant-level Lorentzian branch singularities.
```

Every branch should be labelled as a physical pole, physical doubler,
kinematical zero, ghost-like propagator zero, Krein artifact, cutoff
high-momentum branch, or redesign trigger.

### Gate E/F refinement

Use E1/E11/F12/H11 together to protect novelty and prediction language:

```text
E1: corrected FMS finite composite theorem, only after the FMS audit fixes the
    observable.
E11: quiver/spectral-action novelty boundary.
F12: parameter-count comparison against quiver and finite spectral-action
     freedom.
H11: finite spectral-triple moduli audit for internal Dirac blocks.
```

Prediction remains off unless one of these jobs produces a genuine codimension
constraint, forbidden operator, restricted Yukawa texture/rank, anomaly-selected
representation, chirality/flavor count, or generation constraint.

### Gate A/B near-term emphasis

The most valuable proof work remains:

```text
A1/A6: super-Dirac sign and kinetic normalization.
B1/B3/B4: null-solder frame, inverse-Gram normalization, finite square.
B6/B9: Pluecker obstruction and covariance for P1.
S8/S9: scalar/gauge null quadrature and affine dual-soldered commutator.
```

The finite square should be marketed as a finite dual-soldered null-edge
generalized Lichnerowicz formula, not as a new discovery that Dirac squares
produce Laplacian plus curvature.


## Pro follow-up blocker queue after literature pass - 2026-06-26

Provenance: ChatGPT Pro feedback supplied in attachment
`b0575fe8-3825-4615-90e4-d250135768b7/pasted-text.txt`. The update sharpens the
next jobs rather than broadening the backlog.

### Scheduling rule

Gate C must be treated as a release gate before strong P2 claims:

```text
branch geometry -> flavored chirality -> ghost/counterterm audit.
```

Gate D starts with a positive DEC/Hodge-Dirac proxy:

```text
D0 positive proxy -> connection/Clifford perturbation -> null quadrature
-> Lorentzian/Krein audit -> retarded/advanced audit.
```

Gate E/F/H must be FMS-composite, moduli-ledger, and internal-legality first.

### Added candidate jobs

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| FU-C1 | Next | Audit | Branch geometry of the actual dual-soldered determinant symbol. | Decides whether the determinant-zero set is finite and isolated enough for flavored chirality, or whether the operator needs branch lifting/redesign. | `AgentTasks/null-edge-actual-symbol-branch-geometry.md` |
| FU-C2 | Contingent | Proof | Branch-projector flavored chirality theorem `Gamma_f = sum epsilon_rho P_rho Gamma_s P_rho`. | Turns the modeled flavored-chirality witness into a theorem derived from the actual symbol. | `PhysicsSM/Draft/NullEdgeBranchProjectorFlavoredChirality.lean` |
| FU-C3 | Next | Audit | Gauge-coupled ghost and propagator-zero audit for Gate C branches. | Applies the Golterman-Shamir warning: dangerous zeros are acceptable only if a physical-sector or composite-field theorem removes them. | `AgentTasks/null-edge-gauge-coupled-ghost-zero-audit.md` |
| FU-C4 | Next | Audit | Cutoff symmetry and counterterm ledger for every branch-control mechanism. | Ensures branch counterterms are counted in the finite-to-EFT moduli ledger before prediction language is used. | `AgentTasks/null-edge-branch-counterterm-ledger.md` |
| FU-D0 | Next | Strategy | Positive DEC/Hodge-Dirac proxy theorem plan. | Gives Gate D a tractable first target before Lorentzian/Krein/retarded complications. | `AgentTasks/null-edge-d0-positive-dec-proxy-plan.md` |
| FU-D1 | Contingent | Proof | Flat local symbol theorem `[D_h,M_f] = c(df) + O(h)` in a fixed decorated chart. | First continuum theorem that does not overclaim the full Lorentzian limit. | `PhysicsSM/Draft/NullEdgeFlatLocalSymbolAsymptotic.lean` |
| FU-E1 | Next | Proof | Gauge-invariant FMS finite link composite plus vacuum expansion plan. | Converts electroweak FMS language from citation discipline into a theorem target. | `PhysicsSM/Draft/NullEdgeFMSFiniteComposite.lean` |
| FU-F1 | Next | Prediction | Full moduli/counterterm ledger template for P2 and prediction claims. | Tests whether null-edge structure reduces EFT freedom or merely reconstructs it. | `AgentTasks/null-edge-full-moduli-counterterm-ledger.md` |
| FU-H1 | Next | Audit | Internal legality role audit for Gate H after the Furey/anomaly work. | Keeps internal spectrum and legal Yukawa maps separate from the null kinetic core. | `AgentTasks/null-edge-gate-h-internal-legality-role-audit.md` |
| FU-M1 | Next | Manuscript | Strong-P2-claim gate review. | Prevents finite super-Dirac architecture from being marketed as continuum dynamics or prediction before Gates C/D/F pass. | `AgentTasks/null-edge-strong-p2-claim-gate-review.md` |

### Hard stop and downgrade additions

| Trigger | Action |
| --- | --- |
| determinant branches form unavoidable physical doublers | redesign operator or add controlled branch lifting |
| determinant zeros become gauge-coupled ghost-like propagator singularities | fatal unless a composite-field theorem removes them |
| no viable `Gamma_f` or index/chirality mechanism exists | downgrade Standard Model chirality claim |
| DEC positive proxy fails | downgrade continuum claims to finite algebra |
| Lorentzian/Krein spectrum has unavoidable growing physical modes | redesign retarded/Krein layer |
| FMS composite cannot be made gauge-invariant | keep only stabilizer algebra, not physical W/Z composite claim |
| finite Dirac/quiver moduli absorb all EFT parameters | reconstruction, not prediction |
| no `B_QCD` theorem exists | QCD remains motivation and boundary |

### Demoted blocker

Finite irreducible Markov-chain strong laws are no longer a physics gate unless
the process is nonstationary, nonirreducible, or time-dependent. Keep Markov SLLN
work as formalization/library support, not as a blocker for the finite
null-edge mass program.


## Gate C spin-taste fork after Durr-Weber / Creutz / Weber literature - 2026-06-26

Provenance: Claude literature-search results supplied in attachment
`99aecf52-9edf-412e-a01a-0e30d2ed2fe2/pasted-text.txt`, plus Codex source
checks. Full detail is in `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
Section 27.

### New scheduling rule

Do not ask Aristotle to prove bare `OperatorForcesAlignment` as though ordinary
chirality of the raw Dirac branch kernel must be scalar. First compute the raw
kernel and chirality compression.

```text
Pker Gamma_s Pker
```

is the decisive finite computation.

### Added candidate jobs

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| C23 | Next | Proof | Explicit tetrahedral Clifford symbol and branch-kernel computation. | Builds the missing `c(p(q))` object and determines whether the raw branch kernel is one- or two-dimensional. | `PhysicsSM/Draft/NullEdgeTetrahedralCliffordSymbol.lean` |
| C24 | Next | Proof/Audit | Compute `Pker Gamma_s Pker` on every high-momentum branch. | Decides Route A bare-symbol release versus Route B species-split release. | `PhysicsSM/Draft/NullEdgeBranchKernelChirality.lean` |
| C25 | Contingent | Proof | Point-splitting / branch-projector construction for the tetrahedral null-edge branches. | Operationalizes Creutz-style mode isolation as projectors `P_a`. | `PhysicsSM/Draft/NullEdgeTetrahedralPointSplitting.lean` |
| C26 | Contingent | Proof | Species-splitting or flavored-mass operator for Route B. | Turns a likely bare-symbol degeneracy into a controlled modified-operator Gate C theorem. | `PhysicsSM/Draft/NullEdgeSpeciesSplitGateC.lean` |
| C27 | Contingent | Audit | Counterterm/moduli impact of the species-splitting term. | Decides whether Route B remains reconstruction or can still support prediction language. | `AgentTasks/null-edge-species-splitting-moduli-impact.md` |
| C28 | Future | Source | Hyperdiamond zero-mode comparison pack. | Compares the tetrahedral null-edge symbol with the 4D hyperdiamond/BC/KW zero-mode literature. | `AgentTasks/null-edge-hyperdiamond-zero-mode-source-pack.md` |

### Updated outcome labels

```text
Route A RELEASE:
  bare tetrahedral symbol forces aligned branch chirality.

Route B CONDITIONAL RELEASE:
  bare tetrahedral symbol is chirality-degenerate, but a controlled point-split
  or species-split operator forces aligned branch chirality.

NO-GO / REDESIGN:
  neither raw nor controlled species-split construction yields isolated branches
  with usable modified chirality and acceptable counterterm/moduli behavior.
```


## Gate C release theorem v2 jobs after Pro response - 2026-06-26

Provenance: ChatGPT Pro response in attachment
`eb7adca4-b47f-4874-9135-8aa1fa43f553/pasted-text.txt`. Full integration is in
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` Section 28.

### New Aristotle instruction for C21/C22-style jobs

Do not stop at `Pker Gamma_s Pker`. The fastest Route A/Route B fork is that
compression, but the fastest Gate C decision also needs the local nodal dimension
of the determinant-zero set.

Add these requested outputs to future Gate C jobs:

```text
rank c(p_a);
dim ker c(p_a);
dim(ker c(p_a) cap H_+);
dim(ker c(p_a) cap H_-);
trace(Pker Gamma_s Pker);
finite spectrum/eigenvalue data for Pker Gamma_s Pker;
local dimension of {q : p(q)^2 = 0} near each branch;
point-split projector values P_a(q_b) = delta_ab.
```

### Additional jobs

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| C29 | Next | Proof/Audit | Local nodal-dimension theorem for `det D_+(q)=0` near every high-momentum branch. | Decides whether the high-momentum zeros are isolated species or extended nodal loci. | `PhysicsSM/Draft/NullEdgeLocalNodalDimension.lean` |
| C30 | Next | Proof | Point-split projector model `P_a(q)` for the four three-pi branches. | Gives the first explicit Creutz-style branch projector candidate. | `PhysicsSM/Draft/NullEdgePointSplitProjectors.lean` |
| C31 | Future | Proof | Gauge-covariant or link-dressed point-split branch projectors. | Upgrades the free-field projector model to a physical finite graph theorem. | `PhysicsSM/Draft/NullEdgeGaugeCovariantBranchProjectors.lean` |
| C32 | Future | Proof/Audit | Species-splitting operator `M_split = r tau` and flavored spectral-flow diagnostic. | Converts likely Route B into a controlled modified-operator Gate C theorem. | `PhysicsSM/Draft/NullEdgeSpeciesSplitSpectralFlow.lean` |
| C33 | Future | Audit | Retardedness and Krein audit for cosine/backward-shift projector terms. | Checks whether point splitting stays in the spectral double or contaminates the causal update block. | `AgentTasks/null-edge-point-splitting-retarded-krein-audit.md` |
| C34 | Future | Prediction/Audit | Canonical-versus-tunable species-splitting ledger. | Decides whether splitting is benign branch control or a new modulus that weakens prediction claims. | `AgentTasks/null-edge-species-splitting-prediction-ledger.md` |

### Route labels for reports

```text
Route A:
  Bare symbol has isolated branches and scalar aligned raw chirality.

Route B:
  Bare symbol is chiral-paired or chirality-mixed, but point-split/taste or
  species-split chirality can classify the branch sector.

Extended-nodal redesign:
  determinant-zero set is not an isolated branch set, so minimally doubled
  projectors require modification or operator redesign.
```

### Species-splitting classification

| Case | Backlog interpretation |
| --- | --- |
| fixed by tetrahedral symmetry, gauge covariance, locality, null support, and minimality | benign branch-control counterterm |
| required but tunable | new modulus; prediction language off |
| finite polynomial in null-edge shifts | primitive transports remain null, but composite paths must be documented |
| direct non-null edge | violates primitive-null architecture unless redesigned |
| backward shifts in causal update | retardedness violation; move to Krein spectral double or redesign |
| ghost behavior after gauge coupling | fatal unless composite/interpolating-field theorem removes it |


## Gate C Route B hand-proof jobs after Pro response - 2026-06-26

Provenance: ChatGPT Pro response supplied in attachment
`5e70b9a3-b369-4973-80bc-a41be4c54d7c/pasted-text.txt`. Full integration is in
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` Section 29.

### New default expectation

Do not treat bare `OperatorForcesAlignment` as the likely outcome. The expected
bare result is:

```text
p(q^(a)) = -3/2 ell_a^flat;
D_+(q^(a)) is a nonzero null slash;
rank D_+(q^(a)) = 2;
dim ker D_+(q^(a)) = 2;
the kernel has one plus-chiral and one minus-chiral line;
Pker Gamma_s Pker is mixed/traceless.
```

If this lands, Gate C moves to Route B: point-split projectors, taste signs,
species splitting, Krein audit, gauge-ghost audit, and counterterm/moduli
accounting.

### Added candidate jobs

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| C35 | Next | Proof | Exact high-branch covector theorem `p(q^(a)) = -3/2 ell_a^flat`. | Converts scalar branch data into the actual Clifford symbol at the branch. | `PhysicsSM/Draft/NullEdgeTetrahedralCliffordSymbol.lean` |
| C36 | Next | Proof/Audit | Exact determinant-zero branch-line theorem `p(q_a=0, q_b=pi+t)^2 = 0`. | Tests whether high branches are isolated species or extended nodal curves. | `PhysicsSM/Draft/NullEdgeLocalNodalDimension.lean` |
| C37 | Next | Proof | Nonzero-null-slash rank/kernel/chiral-split theorem. | Proves the expected raw kernel is two-dimensional and chiral-paired. | `PhysicsSM/Draft/NullEdgeNullSlashKernel.lean` |
| C38 | Contingent | Proof | Bare alignment no-go: `Pker Gamma_s Pker` is not `+/- Pker` on the high branches. | If true, kills Route A cleanly and safely redirects Gate C to Route B. | `PhysicsSM/Draft/NullEdgeBareAlignmentNoGo.lean` |
| C39 | Next | Proof | Point-split high-branch projectors `P_a(q)` and `P_a(q^(b)) = delta_ab`. | Provides the first concrete Creutz-style branch-isolation API for Route B. | `PhysicsSM/Draft/NullEdgePointSplitProjectors.lean` |
| C40 | Next | Proof | Linear taste function `T_lin = 1/2(cos q_1 + cos q_2 - cos q_3 - cos q_4)` and branch values `T_lin(q^(a)) = g5_a`. | Gives a low-range taste-sign model for `Gamma_f = Gamma_s T`. | `PhysicsSM/Draft/NullEdgeLinearTasteOperator.lean` |
| C41 | Contingent | Proof/Audit | Species-splitting lift of the exact high nodal line, especially `M_split = r T_lin`. | Tests whether Route B can gap the high nodal curve while leaving the origin branch unlifted. | `PhysicsSM/Draft/NullEdgeSpeciesSplitNodalLine.lean` |
| C42 | Contingent | Audit | Route B cost ledger: retardedness, Krein placement, gauge-ghost behavior, and counterterms for point splitting. | Prevents the branch-control term from being mis-sold as a prediction or primitive causal step. | `AgentTasks/null-edge-route-b-branch-control-cost-ledger.md` |

### Acceptance labels

```text
Route A surprise:
  the bare four-component symbol has scalar aligned raw chirality.

Route B expected:
  the bare symbol is chiral-paired; the signs (+,+,-,-) are taste/species signs
  defined only after projectors, spin-taste decomposition, or species splitting.

Extended-nodal Route B:
  the high branches sit on exact determinant-zero curves, so branch splitting or
  a modified physical operator is required before species-count language is
  publication-safe.
```


## Route B literature-driven jobs after Claude review - 2026-06-26

Provenance: Claude literature review supplied in chat on 2026-06-26. Full
integration is in `Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md`
Section 30.

### Literature scheduling update

The collection already supports Route B. The next wave should use the literature
as proof strategy, not just as citation padding:

```text
2112.13501 Yumoto-Misumi:
  use spectral-graph / DFT methods to classify determinant-zero loci.

1611.08388 Weber:
  audit whether flavored species splitting can be symmetry-forced rather than
  freely tuned.

2311.12790 Golterman-Shamir:
  require a gauge-coupled ghost-zero audit before Gate C release.
```

### Added candidate jobs

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| C43 | Next | Literature/Proof strategy | Spectral-graph proof plan for tetrahedral determinant-zero classification using Yumoto-Misumi `2112.13501`. | Gives a principled method to decide isolated branches versus exact nodal curves/sheets. | `AgentTasks/null-edge-spectral-graph-nodal-classification-plan.md` |
| C44 | Next | Proof | DFT/spectral-graph zero-locus theorem for the flat tetrahedral symbol. | Turns the branch-line observation into a systematic determinant-zero classification. | `PhysicsSM/Draft/NullEdgeSpectralGraphNodalSet.lean` |
| C45 | Next | Literature/Audit | Weber `1611.08388` no-fine-tuning audit for `M_split = r T` and `T_lin`. | Decides whether Route B splitting is symmetry-forced branch control or a new modulus. | `AgentTasks/null-edge-weber-flavored-qcd-splitting-audit.md` |
| C46 | Contingent | Proof/Audit | Symmetry-forced species-splitting theorem, if Weber's mechanism adapts. | Could promote Route B from reconstruction toward a genuine finite constraint. | `PhysicsSM/Draft/NullEdgeSymmetryForcedSpeciesSplit.lean` |
| C47 | Next | Literature/Audit | Golterman-Shamir propagator-zero ghost audit for the Gate C release theorem. | Makes explicit the gauge-coupled ghost hazard that flavored signs alone cannot rule out. | `AgentTasks/null-edge-golterman-shamir-ghost-zero-audit.md` |
| C48 | Contingent | Proof/Audit | Gauge-coupled ghost-zero exclusion or composite-field escape theorem. | Required before any Route B flavored index can be promoted to a physical Gate C release. | `PhysicsSM/Draft/NullEdgeGateCGhostZeroSafety.lean` |
| C49 | Next | Ingestion | Add `2311.12790` and `1611.08388` to Zotero/Neo4j with Gate C / Route B tags. | Closes the two literature gaps and makes the sources semantically searchable. | Zotero/Neo4j ingestion record |

### Updated release blocker

```text
Gate C is not released by flavored signs alone.

Gate C release requires:
  determinant-zero classification,
  point-split/taste or species-split branch control,
  a symmetry/moduli verdict for the splitting terms,
  Krein stability,
  and an explicit gauge-coupled ghost-zero audit.
```


## Post-C21 projected Gate C jobs after Gemini report - 2026-06-26

Provenance: Gemini Deep Research report supplied in attachment
`dd68f951-5bd4-4377-bb31-12b20bda5a05/pasted-text.txt`, filtered through the
C21 and C22 integration reports. Full integration is in
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` Section 31.

### Scheduling update

C21 refutes bare single-chirality assignment. Do not submit more jobs trying to
prove bare `OperatorForcesAlignment` unless they are explicitly framed as
regression checks or no-go refinements.

The new target is:

```text
OperatorForcesAlignmentAfterProjection.
```

Gate C release must now be the conjunction of:

```text
NodalSetControlled;
BranchProjectorsControlled;
ProjectedKernelOneDim;
ProjectedChiralityAligned;
ProjectedKreinPositive;
GhostZeroSafe;
SpeciesSplittingAudited.
```

### Added candidate jobs

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| C50 | Next | Proof/API | Post-C21 projected Gate C release criterion. | Replaces the dead bare alignment target with a decomposed Route B release theorem. | `PhysicsSM/Draft/NullEdgeProjectedGateCRelease.lean` |
| C51 | Next | Proof | Concrete projected branch chirality theorem for point-split/taste projectors. | Proves the actual `OperatorForcesAlignmentAfterProjection` content for an explicit projector, if possible. | `PhysicsSM/Draft/NullEdgeProjectedBranchChirality.lean` |
| C52 | Next | Proof/Audit | Projected kernel dimension theorem: projected high-branch survivor is one-dimensional. | Converts the c21 two-dimensional chiral-paired kernel into a Route B one-dimensional physical survivor. | `PhysicsSM/Draft/NullEdgeProjectedKernelDimension.lean` |
| C53 | Next | Proof/Strategy | Stable-C-symmetry or positive-sector criterion for Krein-positive survivors. | Tests Gemini's Krein suggestion without assuming it; respects C22's chirality/Krein split. | `PhysicsSM/Draft/NullEdgeKreinPositiveReleaseCriterion.lean` |
| C54 | Next | Proof/API | Ghost-zero safety predicate and classification theorem. | Makes Golterman-Shamir safety a formal Gate C clause rather than prose. | `PhysicsSM/Draft/NullEdgeGateCGhostZeroSafety.lean` |
| C55 | Contingent | Strategy/Audit | Composite/interpolating-field escape theorem for kinematical zeros. | Only route for treating propagator zeros as harmless rather than fatal ghosts. | `AgentTasks/null-edge-composite-interpolating-field-zero-escape.md` |
| C56 | Next | Audit | Species-splitting moduli classification after projected release. | Decides whether Route B is forced, constrained, tunable, or prediction-killing. | `AgentTasks/null-edge-species-splitting-moduli-classification.md` |
| C57 | Future | Integration | Final Gate C release checklist crosswalk. | Prevents flavored index, Krein positivity, and ghost safety from being conflated. | `AgentTasks/null-edge-final-gate-c-release-crosswalk.md` |

### Hard guardrails

```text
Projected chirality does not imply Krein positivity.
Krein J-self-adjointness does not imply spectral stability.
Stable C-symmetry is a theorem target, not a background assumption.
Flavored index does not imply ghost safety.
Unclassified propagator zeros block Gate C.
Gauge-coupled ghost zeros are fatal unless an explicit composite-field theorem
removes them from the physical gauge sector.
```


## Furey/Baez/DVT bridge jobs after internal spectral-triple correction - 2026-06-26

Provenance: Claude follow-up analysis supplied in attachment
`66a2b3a1-f6dd-48f3-be76-73d4d74a1143/pasted-text.txt`. Full integration is in
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` Section 33.

### Scheduling correction

The Furey pillar should primarily be used to fill the internal half of the
finite almost-commutative product:

```text
D = i D_N tensor 1 + Gamma_s tensor Phi_H.
```

Do not make Furey responsible for solving Gate C unless a concrete compatibility
theorem with the branch projector is proved.

### Added candidate jobs

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| FUR-H1 | Next | Proof | Computed Furey internal spectrum bridge from actual `J` states to `NullEdgeInternalSpectrum`. | Removes the posited charge-table layer and docks two kernel-checked islands. | `PhysicsSM/Draft/NullEdgeFureyInternalSpectrum.lean` |
| FUR-H2 | Next | Proof/Audit | Identify `chi_E` with the Furey/Krasnov complex structure or grading. | Discharges the abstract internal grading in the super-Dirac square using derived internal data. | `PhysicsSM/Draft/NullEdgeFureyChiE.lean` |
| FUR-H3 | Next | Proof/Strategy | Formalize conjugate ideal `J*` and close `FureyRightHandedSectorOpen`. | Supplies the missing 7 right-handed singlets instead of appending them conventionally. | `PhysicsSM/Algebra/Furey/ConjugateIdeal.lean` |
| FUR-H4 | Next | Proof/Strategy | Gauge-covariant `Phi_H : J -> J*` with `chi_E` oddness and `Gamma_s` compatibility. | The lynchpin that turns abstract `Phi_H` into a Furey-derived finite internal Dirac block. | `PhysicsSM/Draft/NullEdgeFureyPhiH.lean` |
| FUR-H5 | Next | Proof/API | Assemble `D = i D_N tensor 1 + Gamma_s tensor Phi_H` and reuse the Gate A finite square. | Produces the finite almost-commutative product theorem joining null-edge and Furey halves. | `PhysicsSM/Draft/NullEdgeFureyAlmostCommutativeProduct.lean` |
| FUR-H6 | Future | Proof/Audit | DVT/Jordan cubic/triality constraints on legal `Phi_H` textures. | Tests whether the internal algebra gives structural Yukawa constraints rather than only free moduli. | `AgentTasks/null-edge-dvt-yukawa-constraint-audit.md` |
| FUR-E1 | Future | Proof/Audit | Compare Furey/Hughes `SU(3)_C x U(1)_EM` stabilizer with finite FMS photon stabilizer. | Checks whether electromagnetic survival is selected by both internal algebra and orbit stiffness. | `PhysicsSM/Draft/NullEdgeFureyEWStabilizerComparison.lean` |
| FUR-C1 | Future | Proof/Audit | Furey ideal projector compatibility with post-C21 branch projection. | Secondary Gate C path: determine whether internal ideals constrain physical branch selectors. | `PhysicsSM/Draft/NullEdgeFureyProjectedBranchChirality.lean` |
| FUR-L1 | Next | Literature/Ingestion | Add Furey `1806.00612`, Furey `1810.10465`, and Baez-Huerta `0904.1556` to Zotero/Neo4j. | The repo cites and uses this literature; it should be in the searchable corpus. | Zotero/Neo4j ingestion record |

### Claim labels

```text
Furey-derived internal half:
  plausible primary unification route.

Furey-derived mass values:
  not supported.

Furey-derived Gate C release:
  speculative until a branch/internal projector compatibility theorem exists.

Furey-derived right-handed sector:
  open until J* is formalized.
```


## Update - Wave 12/13 integrated targets and next ambitious jobs

Wave 12 and Wave 13 changed the backlog shape. The Route-B Gate C path is now
precise, and the Furey layer has concrete Lean entry points.

Completed/integrated items to mark down:

| Item | Status |
|---|---|
| Projected branch chirality | Integrated as `NullEdgeProjectedBranchChirality`. |
| Species splitting of nodal lines | Integrated as `NullEdgeSpeciesSplitNodalLine`; split coefficient remains free. |
| Gauge-covariant branch projectors | Integrated as `NullEdgeGaugeCovariantBranchProjectors`; covariance is not ghost safety. |
| Composite-zero escape taxonomy | Integrated as `NullEdgeCompositeZeroEscape`. |
| Furey internal spectrum | Integrated as `NullEdgeFureyInternalSpectrum`. |
| Furey `chi_E` audit | Integrated as `NullEdgeFureyChiE`; use number parity, not complex structure. |
| Furey conjugate ideal | Integrated as `Algebra/Furey/ConjugateIdeal`. |
| Furey `Phi_H` interface | Integrated as `NullEdgeFureyPhiH`. |
| Furey almost-commutative product | Integrated as `NullEdgeFureyAlmostCommutativeProduct`. |
| Furey/FMS photon stabilizer match | Integrated as `NullEdgeFureyEWStabilizerComparison`. |

New ambitious backlog entries:

| Proposed ID | Title | Goal |
|---|---|---|
| C63 | Post-gauge ghost-safety/residue theorem | Instantiate the ghost-zero safety contract for the projected, link-dressed Route-B physical sector. Prove the survivors are pole-like/positive-residue rather than Golterman-Shamir ghost zeros, or produce a clean no-go. |
| C64 | Full nodal-set exhaustion audit | Go beyond the certified branch lines and classify the complete determinant-zero locus of the tetrahedral symbol plus split term. Either prove exhaustion or isolate remaining components as a release blocker. |
| C65 | Canonical species selector or no-go | Determine whether the physical sector `{0,2}` is canonically selected by orientation, Krein sign, energy sign, or internal grading. If not, prove the selection remains a convention/modulus. |
| FUR-H7 | Concrete Furey `Phi_H` on `J` and `J*` | Replace the abstract `L/R` interface with maps on the live Furey ideal and conjugate-ideal modules. Check gauge covariance, `chi_E` oddness, and square compatibility. |
| FUR-H8 | Number-parity `chi_E` on the actual Furey ideal | Define the occupation-number parity grading on the actual Furey model, prove involution/parity properties, and test anti-commutation with the concrete `Phi_H`. |
| FUR-H9 | Coordinate conjugate-ideal bridge to live octonions | Connect `Algebra/Furey/ConjugateIdeal` to the existing `Jbar`/octonion modules and remove the current coordinate/live-tree gap. |


### C59 addendum

`NullEdgeProjectedGateCRelease` is now integrated. Future Gate C jobs should use
its seven-clause `ProjectedGateCRelease` certificate as the target shape. The
next missing concrete clauses are especially the post-gauge ghost-safety/residue
clause and any canonical-selection/no-go theorem for the retained sector.


### C65 integrated

`NullEdgeCanonicalSpeciesSelector` is integrated. Mark the canonical selector job
as resolved conditionally: the retained pair is canonical relative to locked
Krein data, but not absolutely canonical from chirality/taste/energy/grading.
Next jobs should either derive the Krein lock from a deeper structure or keep it
as an explicit release input.


## Literature update - 2026-06-26

Newly curated papers sharpen the backlog but do not remove the main blockers.
See `AgentTasks/null-edge-literature-gate-furey-search-2026-06-26.md`.

Backlog changes:

| Job/theme | Update |
|---|---|
| C63 ghost safety | Add a positive-residue/pole-like survivor condition inspired by KW/BC dispersion and eigenvalue taste-splitting papers. |
| C64 nodal exhaustion | Use graph-matrix/lattice-operator equivalence as a normal-form strategy. |
| K3 Krein lock | No literature shortcut found; keep the derive-or-no-go framing. |
| FUR-H7A/H8A/H9A | Todorov and Furey-Hughes support the narrow bridge jobs, especially complex-structure caution and left-right Higgs/triality representation carriers. |
| FUR-H10 | Use Gesteau matrix-Yukawa duality as motivation for dimension/codimension audit, not magnitude prediction. |

Curation note: eight papers were manually added to Zotero and upserted into
Neo4j after arXiv API rate limits blocked `lit_ingest.py`. Paper embeddings were
refreshed successfully.


### C63 and K3 integrated

C63 resolves the ghost-safety API shape but leaves the actual projected-operator
residue positivity / `PostGaugeGhostSafe` theorem open. K3 resolves the Krein
lock question negatively: the sign pattern is not forced by the currently
formalized data, so future Gate C statements should name the sheet/causal
orientation lock explicitly.


## Furey edge-fiber and left-action jobs after Pro follow-up

Provenance: ChatGPT Pro feedback supplied in attachment
`ed9b7b7e-37d6-4e91-9267-fd2514c0a742/pasted-text.txt`. Full synthesis is in
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` Section 36.

### Scheduling correction

The next Furey jobs should not ask Furey to solve the null-edge kinetic core.
They should dock the Furey finite internal fiber to the null-edge product
operator:

```text
H_edge = H_null/spin/Krein/branch tensor H_Furey/internal
D      = i D_N tensor 1 + Gamma_s tensor Phi_H
```

Hard convention: Furey particle states should be formalized as modules/minimal
left ideals for the associative left-action algebra generated by
complex-octonion left multiplication operators, not as unqualified ideals of the
raw nonassociative complex octonions.

### Added ambitious jobs

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| FUR-H11 | Next | Proof/API | Define `OctonionLeftActionAlgebra` as the associative operator algebra generated by complex-octonion left multiplications. | Locks the safe mathematical object behind the Furey ideal language and prevents raw nonassociative ideal confusion. | `PhysicsSM/Algebra/Furey/LeftActionAlgebra.lean` |
| FUR-H12 | Next | Proof/API | Package `FureyIdealModule` and `PrimitiveIdempotentReference` as `J = A_F p`. | Turns the Furey internal state space into a reusable module object for edge fibers and `Phi_H`. | `PhysicsSM/Algebra/Furey/IdealModule.lean` |
| FUR-H13 | Next | Proof/Strategy | Build `OrientedEdgeInternalFiber` and a reversal functor separating dualization, charge conjugation, and edge orientation. | Prevents conflating incoming/outgoing status, particle/antiparticle status, and chirality. | `PhysicsSM/Draft/NullEdgeFureyEdgeFiber.lean` |
| FUR-H14 | Next | Proof/API | Define `NodeIntertwiner` as gauge-equivariant, `chi_E`-typed multilinear maps between incident Furey fibers. | Keeps node composition in associative linear-map/intertwiner language rather than raw octonion multiplication. | `PhysicsSM/Draft/NullEdgeFureyNodeIntertwiner.lean` |
| FUR-H15 | Next | Proof | Construct `PhiHFromFureyIdeals` on `J plus J*` or conjugate sectors and prove gauge covariance, `chi_E` oddness, and `Gamma_s` evenness. | The main theorem docking Furey's internal layer to the existing finite super-Dirac square. | `PhysicsSM/Draft/NullEdgePhiHFromFureyIdeals.lean` |
| FUR-H16 | Future | Audit/Prediction | `IntertwinerCodimensionAudit` for Furey-compatible Yukawa/Higgs maps. | Decides whether Furey restricts generic Yukawa freedom or remains reconstruction. | `AgentTasks/null-edge-furey-intertwiner-codimension-audit.md` |
| FUR-C2 | Future | Proof/Audit | `PreservesFureyIdealStructure` for branch projectors, Higgs maps, and ghost-prone operators. | Tests whether the Furey internal projector helps the projected Gate C sector without pretending it proves ghost safety. | `PhysicsSM/Draft/NullEdgeFureyProjectorCompatibility.lean` |

### Claim labels

```text
Safe:
  Furey supplies a finite internal fiber and legal-map language.

Conditional:
  Furey may restrict Phi_H textures if an intertwiner codimension theorem is
  proved.

Speculative:
  Furey may help select the internal part of the Gate C physical sector.

Unsafe:
  Furey proves Gate C, ghost safety, Krein positivity, right-handed completion,
  three generations, or numerical Yukawa values.
```


## Claude calibration after Furey-fiber synthesis

Provenance: Claude analysis supplied in attachment
`dd8b5295-8531-402c-b340-c20a8701799b/pasted-text.txt`. Full synthesis is in
`Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md` Section 37.

### Backlog correction

Many broad Furey bridge jobs are now lower priority because the repo already has
kernel-checked versions of the main bridge surface: internal spectrum, anomaly
inheritance, lawful `Phi_H`, occupation-parity `chi_E`, and the
almost-commutative product square. Keep Furey work focused on right-handed
completion, moduli/codimension, and theorem consolidation.

The binding blocker is Gate C after C64:

```text
the bare determinant-zero locus has off-branch zeros;
the natural g5 species split does not gap q_star;
full nodal-set control is not yet proved.
```

### Added/refocused jobs

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| C66 | Next | Proof/Strategy | Full cyclotomic nodal-set classification for the tetrahedral determinant-zero locus. | Stops discovering off-branch zeros one at a time and attacks the actual C64 blocker. | `PhysicsSM/Draft/NullEdgeNodalSetCyclotomic.lean` |
| C67 | Contingent | Proof | Richer species-splitting term that gaps the full classified off-branch locus while preserving the origin. | Tests whether Route B can control all unwanted zeros after C66 identifies them. | `PhysicsSM/Draft/NullEdgeCyclotomicSpeciesSplit.lean` |
| C68 | Contingent | Proof/API | Projected-sector nodal-control release theorem. | Honest fallback if bare full-locus control is too strong: Gate C releases only for projected physical zeros, not the bare determinant locus. | `PhysicsSM/Draft/NullEdgeProjectedNodalControl.lean` |
| C69 | Contingent | Audit | Off-branch zero sector audit: Krein sign, residue, and ghost status of every non-branch component. | Determines whether off-branch zeros are fatal, discardable, or removable by composite/projection data. | `AgentTasks/null-edge-off-branch-zero-sector-audit.md` |
| FUR-H17 | Next | Proof/Consolidation | `NullEdgeInvolutionDistinctness`: theorem-level non-identification witnesses among `Gamma_s`, `chi_E`, Krein `J`, edge orientation, charge conjugation, dualization, Furey complex structure, and branch/taste sign. | Cheap defensive module preventing the most likely convention conflations. | `PhysicsSM/Draft/NullEdgeInvolutionDistinctness.lean` |
| FUR-H18 | Contingent | Proof/Promotion | Consolidate existing Furey bridge theorems into one review-friendly interface module. | Avoids redundant proof work while making the already-formalized Furey-fiber bridge easy to cite. | `PhysicsSM/Draft/NullEdgeFureyBridgeSummary.lean` |

### Scheduling note

Recommended next serious Gate C package:

```text
1. C66 full nodal-set classification;
2. C69 off-branch zero sector audit;
3. either C67 richer split or C68 projected-sector release, depending on what
   C66 finds.
```

Recommended cheap safety package:

```text
FUR-H17 NullEdgeInvolutionDistinctness.
```

Recommended Track A pause:

```text
Wait for the FUR-H10-style intertwiner/moduli audit before upgrading any Furey
claim from reconstruction to prediction.
```
## Furey/Baez source-ingest backlog refinement - 2026-06-27

Provenance: follow-up Furey/Baez analysis in attachment
`81a90b3d-0fff-4d16-9783-12ccb41c01e3/pasted-text.txt`; papers ingested via
`Scripts/lit/lit_ingest.py` into Zotero and Neo4j.

### Source anchors now available

| arXiv ID | Zotero key | Use |
| --- | --- | --- |
| `2606.15235` | `DJRMU4CB` | Exceptional-Jordan source for SM gauge group and internal stabilizer comparison. |
| `2209.13016` | `6VI58VGH` | Furey-Hughes one-generation internal-spectrum docking source. |
| `1806.00612` | `Z232K7IU` | Division-algebraic ladder-operator gauge-symmetry source. |
| `0904.1556` | `MZZEZUWA` | Baez-Huerta GUT/SM representation scaffold. |
| `math/0105155` | `WRIM6ZI7` | Octonion/Clifford/spinor background and convention anchor. |

### Promoted/refined jobs

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| FUR-H16 | Promote to Next | Audit/Prediction | `FureyBaezIntertwinerCodimensionAudit`: compute the legal `Phi_H`/Yukawa intertwiner space over the Furey/Baez/DVT internal module and compare its dimension/codimension with generic SM Yukawa freedom. | This is the cleanest Gate F test for whether Furey/Baez gives structural prediction rather than reconstruction. | `AgentTasks/null-edge-furey-baez-intertwiner-codimension-audit.md` |
| FUR-E2 | Next | Proof/Audit | `FureyBaezEMStabilizerComparison`: compare the internal electromagnetic generator/stabilizer from Furey/Baez/DVT with `ker(X -> X H_0)` in the finite electroweak orbit-stiffness theorem. | Tests whether photon survival is selected by both the internal algebra and the Higgs stabilizer theorem. | `PhysicsSM/Draft/NullEdgeFureyBaezEMStabilizerComparison.lean` or report first. |
| FUR-H19 | Next | Proof/API | `FureyRightHandedSectorCompletion`: formalize the `J*` or conjugate-sector bridge and prove the missing right-handed singlets match the all-left SM convention. | Closes the main internal-spectrum docking gap before stronger Furey claims are made. | `PhysicsSM/Draft/NullEdgeFureyRightHandedSector.lean` |
| FUR-H20 | As needed | Proof/API | `FureyLeftActionConventionBridge`: state the associative left-action operator-algebra guardrail and expose bridge lemmas avoiding raw octonion associativity assumptions. | Protects all Furey/null-edge docking work from nonassociative convention drift. | `PhysicsSM/Draft/NullEdgeFureyLeftActionConventionBridge.lean` |

### Scheduling rule

```text
Run FUR-H16/FUR-E2/FUR-H19 as Gate H/F support.
Do not treat them as Gate C release jobs.
Gate C remains a separate kinetic/nodal/Krein/ghost problem.
```
## Wave 17 null-Wilson Gate C pivot - 2026-06-27

Provenance: Pro analysis in attachment
`cb87110d-9401-4269-8256-a94546549fe0/pasted-text.txt`, responding to the
post-C66 Gate C state.

### Strategic decision

```text
Do not release Gate C for bare D_+.
Release Gate C, if possible, for a regulated/projected physical operator D_phys.
```

Bare `D_+` should be marked `FATAL-FOR-NAIVE-FLAT`, not fatal for the broader
program. The next wave should prove or audit the null-Wilson/projected route.

### Added jobs

| ID | Status | Type | Ambitious target | Why it matters | Output |
| --- | --- | --- | --- | --- | --- |
| C70 | Next | Proof | `NullEdgeNullWilsonRegulator`: prove `W(q)=sum_a(1-cos q_a)` vanishes only at the origin on the real torus and is positive on every non-origin real point; specialize to known C64/C66 witnesses. | Converts the full-nodal-locus blocker into a standard Wilson-regulator cost ledger. | `PhysicsSM/Draft/NullEdgeNullWilsonRegulator.lean` |
| C71 | Next | Audit/Strategy | Null-Wilson operator placement: should the term be `Gamma_s R_W`, a scalar Wilson kernel, an overlap/domain-wall kernel, or a projected physical-sector regulator? | Prevents a sign/grading mistake from contaminating Gate A and the chiral sector. | `AgentTasks/null-edge-null-wilson-operator-placement-audit-report.md` |
| C72 | Next | Proof/API | `NullEdgeProjectedGateCWilsonRelease`: state and prove the v3 API theorem that regulated nodal control plus projected chirality, Krein positivity, post-gauge residue positivity, and moduli audit imply Gate C release for `D_phys`. | Makes the new release target explicit and prevents accidental release claims for bare `D_+`. | `PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean` |
| C73 | Next | Proof/Audit | Gauge-covariant null-Wilson link dressing for `R_W^A = (r/(2h)) sum_a (2 - T_a^A - (T_a^A)^sharp)`. | Ensures the regulator can live in the gauge-covariant null-edge architecture. | `PhysicsSM/Draft/NullEdgeNullWilsonGaugeCovariance.lean` |
| C74 | Next | Audit/Strategy | Post-gauge residue/ghost-safety theorem plan for the regulated/projected operator. | Converts Golterman-Shamir ghost warnings into concrete finite residue-sign obligations. | `AgentTasks/null-edge-null-wilson-residue-ghost-safety-plan.md` |
