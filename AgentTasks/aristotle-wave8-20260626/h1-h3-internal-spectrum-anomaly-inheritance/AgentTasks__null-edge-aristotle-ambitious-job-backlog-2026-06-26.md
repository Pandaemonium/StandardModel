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
| D14 | Next | Audit | Connection-Laplacian convergence audit for gauge holonomy. | Maps finite graph holonomy and Higgs covariant-gradient terms to Ramanan/Singer-Wu style connection-Laplacian convergence hypotheses. | `AgentTasks/null-edge-connection-laplacian-convergence-audit.md` |
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
