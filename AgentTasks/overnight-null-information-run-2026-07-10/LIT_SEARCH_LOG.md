# Literature and Lean-package search log

Minimum cadence: one pass per agent every 30 minutes. Spark is preferred for
parallel work; direct search is the required fallback if Spark is unavailable,
out of budget, or unresponsive. Claims depending on a paper's interior require
full-text/chunk verification.

| Local time | Agent | Topic/query | Method | Ranked sources/packages | Exact useful result/convention | Action/provenance |
|---|---|---|---|---|---|---|
| 2026-07-09 23:12 PDT | Codex | WAY conservation limits, finite charge reservoirs, and Lean swap/Kronecker APIs | PhysLean `lean-explore`; Mathlib `lean-explore`; Neo4j full-text chunks; arXiv web search after scholarly 429/overconstrained query | Ahmadi-Jennings-Rudolph, arXiv:1209.0921; Kuramochi-Tajima, arXiv:2208.13494; Yamaguchi-Mitsuhashi, arXiv:2411.04766; Mathlib `Matrix.swap`, `Matrix.kronecker_mem_unitary`; PhysLean returned charge-spectrum declarations but no WAY/reference-frame API | Literature supports asymmetry/reference-frame resources and exact conservation obstructions; it does not identify the Higgs with a finite swap. Use Mathlib's permutation/Kronecker shapes as reference, retain direct finite witness, and label it basis charge exchange rather than universal coherent operation. PhysLean has no directly reusable declaration under the current version-pinned search. |

## 2026-07-09 23:28 PDT | Claude | lit/package pass 1

- lean-explore (Physlib scope): measurement/POVM/instrument -> NO instrument or
  POVM API in PhysLean; nearest objects are QuantumMechanics.FiniteTarget
  (finite-dim QM, timeEvolutionMatrix) and the CanonicalEnsemble probability
  stack. Conventions to cross-check for the dynamics/measurement dictionary.
- lean-explore (all packages): CPTP/Kraus/partial trace -> lean-quantum's
  CPTPMap API is the theorem-shape reference for the F3 finite instrument API:
  CPTPMap.of_kraus_CPTPMap, CPTPMap.traceLeft, CPTPMap.replacement,
  CPTPMap.purify, channel capacity stack. Version-pinned away from our build:
  clean-room reference ONLY; no import. The finite instrument job should
  mirror: instrument = finite family of CP maps summing to TP; outcome
  probability = trace of branch output; no-disturbance = marginal equality.
- Action: informs the F3 measurement-instrument Aristotle job (queued) and the
  S13 benchmark row.

| 2026-07-09 23:39 PDT | Codex | quantitative quantum-walk-to-Dirac convergence, 3+1 walk lifts, and amplitude composition | PhysLean and Mathlib `lean-explore`; scholarly INSPIRE-HEP fallback after Semantic Scholar 429; Neo4j full-text chunk search | Mlodinow-Brun arXiv:1802.03910; Arrighi-Facchini arXiv:1609.00305; Arrighi et al. arXiv:1803.01015; Manighalam-Kon arXiv:1909.07531; D'Ariano et al. arXiv:1406.1021; PhysLean `QuantumMechanics.FiniteTarget.timeEvolution*`; Mathlib `CompactConvergenceCLM`, `UniformConvergenceCLM` | Literature supports 3+1 and curved-spacetime quantum-walk continuum programs and identifies the coin flip as a mass term, but does not supply our quantitative theorem. PhysLean supplies finite evolution shapes, not walk convergence. Action: landed exact amplitude concatenation; harvested fixed-momentum `D(k,m)t^2/n`; launched bounded-momentum uniformization `405dc47e` and explicit 3+1 Clifford-walk algebra `3be91060`. |
| 2026-07-10 00:35 PDT | Codex | finite Fourier lift, massive SU(2) spin representation, and positive physical cohomology | Mathlib/PhysLean `lean-explore`; Neo4j full-text chunk search | Mathlib `FourierTransform.fourier_sum`, `SchwartzMap.norm_fourier_toBoundedContinuousFunction_le_toLp_one`, `Fourier.norm_fourierIntegral_le_integral_norm`; PhysLean `Fermion.rightHandedRep`, `Fermion.leftLeftToMatrix_ρ`, `StandardModel.HiggsVec.gaugeGroupI_smul_inner`, finite quadratic-form APIs; arXiv:1802.03910, 2006.08927, 2203.08087, 1709.04891, 1807.05044 | Finite-sum/Fourier norm shapes support a cardinality-factor lift but not an infinite-volume PDE. Massive spin literature identifies the determinant-fixed SU(2) fiber with polarization representations, but does not identify our cohomology classes. BRST-specific graph hits were weak; retain the explicit finite quartet proof rather than importing an analogy. Action: submitted `92331c27` finite Fourier lift, `adb502b2` SU(2) spin-half action, `8bac8cce` quartet positivity, and `c6d496f0` normalized Clifford unitary step. |
| 2026-07-10 01:24 PDT | Codex | D4 null-ray spinor factorization and summable infinite Fourier synthesis | PhysLean/Mathlib `lean-explore`; Neo4j full-text chunk search | PhysLean `PauliMatrix.pauliMatrix`, `PauliMatrix.pauliBasis`, Pauli Lorentz-tensor declarations; Mathlib `tendstoUniformly_tsum`, `MeasureTheory.hasSum_setToFun_of_dominated_convergence`, `ZLattice.tsumNormRPowBound`; Foster-Jacobson arXiv:1610.01142; Mlodinow-Brun arXiv:1802.03910; Arrighi-Facchini-Forets arXiv:1505.07023 | PhysLean fixes the Pauli convention needed to factor selected null rays but does not provide the D4 selection. Literature stresses that discrete grid, unitarity, causality, and continuum symmetry are separate requirements; no source makes D4/BCC automatic. Action: submitted explicit six-ray factorization `a7666500` and summable-envelope Fourier lift `30a9b761`, retaining time-axis selection and walk-envelope instantiation as open. |
| 2026-07-10 01:56 PDT | Codex | physical checkerboard-transfer normalization and countable Fourier convergence | Neo4j full-text chunk search; Mathlib/PhysLean `lean-explore`; scholarly backends attempted but arXiv query overconstrained and Semantic Scholar returned 429 | Mlodinow-Brun arXiv:1802.03910; Arrighi-Di Molfetta arXiv:1803.01015; Arrighi-Facchini-Forets arXiv:1505.07023; Bialynicki-Birula hep-th/9304070; Foster-Jacobson arXiv:1610.01142; Mathlib `tendstoUniformly_tsum`, `dist_le_tsum_of_dist_le_of_tendsto0`, `summable_norm_geometric_of_norm_lt_one`; PhysLean `QuantumMechanics.FiniteTarget.timeEvolution*`, `Matrix.trace_unitary_conj` | The literature treats discrete locality, unitarity, symmetry, and continuum recovery as separate obligations; 3D/BCC constructions use an explicit coin and do not make our transfer normalization automatic. Mathlib provides summable-tail and uniform-series infrastructure; PhysLean provides finite evolution conventions, not checkerboard normalization. Action: keep `2df7fa8b` and `30a9b761` as distinct proof targets and do not upgrade them to a physical continuum walk until both land and the walk-specific envelope is instantiated. |
| 2026-07-10 02:24 PDT | Codex | six-direction D4 walk to four-component Dirac sector; dynamical rather than definitional decoder selection | Neo4j full-text chunk search; Mathlib/PhysLean `lean-explore` | Mlodinow-Brun arXiv:1802.03910 chunks on 3D directional projectors, parity, and noncommuting axis steps; Farrelly-Streich arXiv:2006.08927 on higher-dimensional QCA constraints; Mathlib `comp_equiv_dotProduct_comp_equiv`, `inner_sum`, `sum_inner`; PhysLean `varGradient`, `HasVarGradientAt`, `ClassicalMechanics.euler_lagrange_varGradient`, `StandardModel.HiggsField.EffectivePotential.termOfMassDim` | Literature supports using direction projectors and symmetry constraints to reduce a 3D walk's internal space; it does not provide an automatic `6 -> 4` intertwiner. Mathlib has the finite reindex/inner-product shapes for the D4 shift proof. PhysLean suggests an action/Hessian route for selecting a decoder, but no declaration derives our `quartetSAt` from Pluecker data. Action: keep `1253313b` as finite shift/unitarity only, require a separate coin-Clifford intertwiner/no-go theorem, and treat a finite action/Hessian selection theorem as the next dynamics rung after `5f5379b8`. |
| 2026-07-10 02:54 PDT | Codex | conservation after Pluecker action; invariant four-component sector inside six-channel D4 walk | Neo4j full-text chunk search; PhysLean `lean-explore` | Mlodinow-Brun arXiv:1802.03910 chunks on directional projectors, parity/noncorrelation, successive-axis 3D walks, and four-dimensional internal space; D'Ariano et al. arXiv:1406.1021; PhysLean `ClassicalMechanics.HarmonicOscillator.energy_conservation_of_equationOfMotion`, `.hamiltonian_eq_energy`, `.lagrangian` | Literature favors projector/symmetry or successive-axis architectures rather than raw direction-count identification. PhysLean gives the clean reference shape for the next dynamics rung: EOM implies conserved oscillator energy. Action: landed the direct `6 != 4` no-go, launched explicit six-channel coin and constructive `6 = 4 + 2`, and reserve a Pluecker-frequency oscillator conservation theorem as the next post-strategy proof. |
| 2026-07-10 03:24 PDT | Codex | concrete invariant sectors in 3D quantum walks; finite canonical-ensemble response | Neo4j abstract and full-text chunk search | Mlodinow-Brun arXiv:1802.03910; Arrighi et al. arXiv:1803.01015; D'Ariano et al. arXiv:1601.04832; Farrelly-Streich arXiv:2006.08927; harmonic-oscillator partition-function chunk in arXiv:1311.7146 | The strongest 3D reference uses a product of axis walks and derives a four-dimensional internal space from parity, axis symmetry, and anticommutation; this warns that a first-four-channel projector for our block coin is an invariant but anisotropic two-axis sector, not yet 3+1 Dirac. The canonical-ensemble search confirms the standard `d log Z / d beta = -mean energy` target, but the local corpus has no project-specific finite proof. Action: launched concrete projector/shift, SL2 Hessian invariance, reversible oscillator group, and finite Gibbs-response jobs; the next audit must reject any promotion of the anisotropic rank-four block to a Dirac sector. |
| 2026-07-10 03:40 PDT | Codex | successive-axis four-component route around the six-channel obstruction | Neo4j full-text chunk search | Mlodinow-Brun arXiv:1802.03910 chunks 2, 5, 12, 13, and 20; QCA review arXiv:2503.05998 chunks 6-7 | The reference 3D walk is a product of three one-dimensional axis walks acting on the same internal space. Parity and axis noncorrelation force anticommuting internal operators; the massive case doubles the internal dimension to four and the coin flip supplies the mass term. This supports a separate successive-axis `C^4` construction, not a reinterpretation of the current simultaneous six-direction block coin. Action: pre-register Route B as the next kinematics target if `cc870ab1` confirms only an anisotropic two-axis rank-four sector. |
| 2026-07-10 04:07 PDT | Codex | split-step Dirac convergence and discrete variational stability | Neo4j full-text chunk search | Arrighi et al. arXiv:1803.01015 chunk 3; Mlodinow-Brun arXiv:1802.03910 chunks 2, 4, and 20; Discrete Exterior Calculus arXiv:math/0508341 chunks 32-37 | Operator splitting is an established route from one-dimensional Dirac walks to higher-dimensional Dirac equations, but exact factor unitarity, first-order generator recovery, spatial shifts, and convergence rate remain distinct obligations. DEC literature supports deriving discrete Euler-Lagrange equations from a discrete Hamilton principle and seeking conservation/stability properties rather than attaching dynamics afterward. Action: keep `293514db` as the internal split-step/generator theorem, `535b0922` as the action-derived recurrence, and `04affe6e` as its positive-definite all-iterate stability theorem; no continuum claim before shifts and a quantitative product-limit bound land. |
| 2026-07-10 04:34 PDT | Codex | position-space successive-axis Dirac walks and two-level Schottky response | Neo4j full-text chunk search; arXiv web search for Schottky references | Mlodinow-Brun arXiv:1802.03910 chunks 7-8 and 20; Arrighi et al. arXiv:1803.01015 chunk 3; Arnault et al. arXiv:1911.09791 chunks 3-4; de Souza et al. arXiv:1504.07525; Hasegawa arXiv:1205.2058 | The literature's Route B uses an explicit position Hilbert space, conditional projectors, and successive axis shifts; the landed internal product is only its coin/generator core. Two-level gaps produce the standard Schottky heat-capacity anomaly. Action: Audit 11 now demands the exact position-register theorem and quantitative norm/rate; S20 lands a disclosed analytic Schottky V2 anchored to the new variance theorem, not a material prediction. |

## 2026-07-10 05:10 PDT | Claude | lit/package pass 2

- lean-explore (Physlib): PhysLean has `CanonicalEnsemble.twoState` with
  `twoState_partitionFunction_apply`, `twoState_probability_fst`, AND
  `fluctuation_dissipation_theorem_finite`.  Directly relevant to the landed
  `FiniteGibbsResponse`/`GibbsFluctuationResponse` lane and the S20 Schottky V2
  row: @Codex, cross-check sign/normalization conventions against PhysLean's
  two-state ensemble before the dawn audit cites Schottky as a reproduction;
  PhysLean's fluctuation-dissipation shape also suggests the natural next
  ensemble theorem is already convention-pinned externally.  Clean-room only.
- Instrument lane: no PhysLean POVM/instrument API (pass 1 stands); the landed
  FiniteInstrumentAPI has no external convention conflict.

| 2026-07-10 05:28 PDT | Codex | Clifford eigenbasis bridge, successive-axis spatial Dirac walk, compact-momentum `3+1` product rate, and independent multilevel response | Neo4j full-text chunk search; primary arXiv/web search; Mathlib source/API search | Mlodinow-Brun arXiv:1802.03910 chunks 7-8 and 17; Arrighi et al. arXiv:1803.01015 chunk 3; Childs et al. arXiv:1912.08854; Mathlib `Matrix.IsHermitian.eigenvectorUnitary`, `.spectral_theorem`, `NormedSpace.exp_nsmul`, matrix exponential and L2 operator-norm APIs | The literature explicitly realizes a 3D walk as successive conditional shifts through complementary internal projectors; this supports conjugating the component sign table by exact per-axis eigenbases, not identifying the diagonal table directly with off-diagonal Clifford generators. First-order unsymmetrized Trotter error is the correct target because the Clifford summands do not commute. The local thermodynamic search adds no stronger source than PhysLean's finite fluctuation theorem; S22 therefore remains an independent theorem confrontation rather than a material fit. Action: launch the exact sign-table/eigenbasis/position-symbol bridge and a compact-box `3+1` `O(1/n)` proof; retain a commutator control against any `O(1/n^2)` over-claim. |
| 2026-07-10 06:32 PDT | Codex + Spark | finite unitary path actions and exact EOM terminology | Spark local Neo4j abstract/chunk search followed by primary web lookup | Debbasch, arXiv:1806.02313; D'Ariano et al., arXiv:1406.1021; Mlodinow-Brun, arXiv:1802.03910; McClean-Parkhill-Aspuru-Guzik, PNAS 2013, DOI 10.1073/pnas.1308069110 | Debbasch supplies a genuine stationary discrete action for unitary quantum automata; Feynman's clock supplies the closest quadratic variational-history precedent. No source in the scoped corpus identifies `sum_t ||psi_(t+1)-U psi_t||^2` as the canonical Dirac-walk action. Action: caption `FiniteUnitaryPathAction` as a positive least-residual action characterization whose zero locus is the selected EOM, not as a primitive derivation of the walk or as the shared Pluecker field action. |
| 2026-07-10 06:32 PDT | Codex | bounded noncommuting product-formula rates | Spark failed from context exhaustion; direct Neo4j abstract/chunk fallback, then primary arXiv search | Childs-Su-Tran-Wiebe-Zhu, arXiv:1912.08854; Hahn-Hartung-Burgarth-Facchi-Yuasa, arXiv:2410.03059 | The local scoped graph returned no useful product-formula hit. Primary literature confirms first-order Lie-Trotter bounds for general noncommuting summands and warns that simple upper bounds can be very loose; explicit lower bounds make noncommutation a real first-order control. Action: retain the audited `O(1/n)` compact-box target and its deliberately generous constant; any `O(1/n^2)` claim requires a separate palindromic step. |

## 2026-07-10 06:48 PDT | Claude | lit pass 3 (Higgs self-mass routes)

- **NJL/composite (route 1)**: Willey, PRD 48 (1993) 2877 - the continuum NJL
  ratio m_sigma^2/m_f^2 is REGULARIZATION-AMBIGUOUS (not removed in the
  singular linear-sigma limit).  Consequence: do not cite m_sigma = 2 m_dyn
  as settled continuum fact; the finite mean-field model has NO regularization
  ambiguity, so its exact gap/curvature relations stand on their own.  Also:
  Suzuki PRD 44 (1991) 3628 (composite-Higgs/top-condensate mass predictions
  via Bardeen-Hill-Lindner RG) as the composite-route precedent.
- **WAY-quantitative (route 2)**: Tajima-Yamaguchi-Takagi-Kuramochi,
  arXiv:2507.23760 - universal cost-irreversibility tradeoffs;
  general-resource WAY theorems (measurement failure probability inversely
  proportional to resource cost).  The right anchor for the
  Higgs-as-reference-resource sum rule.  Statement design is delicate
  (population transfer needs NO coherence; the obstruction concerns the
  coherent gate); deferred to a named target rather than a rushed statement.
- **Near-criticality (route 3)**: Steingasser arXiv:2405.02415 - all THREE
  Higgs-potential parameters (mass term / quartic / constant) near critical
  values marking quantum phase transitions (hierarchy / metastability /
  cosmological constant as one pattern); Espinosa arXiv:1512.01222
  (state-of-the-art near-criticality); Marzola-Raidal arXiv:1510.00710
  (relaxation mechanisms predicting near-criticality).  This is the
  literature form of the run's criticality-unification conjecture.
- Action: two jobs submitted this pass (composite gap; criticality seed);
  WAY sum rule logged as named target.  Clean-room; no code imported.

## 2026-07-10 08:39 PDT | Codex | Paper-I novelty and doubling audit

- Succi, Fillion-Gourdeau, and Palpacelli, *EPJ Quantum Technology* 2, 12
  (2015), explicitly relate exponential Dirac mass matrices to quantum-walk
  Euler angles through tangent formulas. Therefore `tan(a mu)` is not claimed
  as novel in isolation; the paper's contribution is the exact recursive
  checkerboard-kernel scaling composed with a Pluecker-derived complex rest
  operator and machine verification.
- Gupta and Short, arXiv:2601.15885, accepted by *Physical Review A* on
  2026-07-01, distinguish low-energy fermion doublers from high-energy
  pseudo-doublers and construct stationary-amplitude walk families to control
  them. The present `(pi,pi)` Floquet partner is now called a pseudo-doubler,
  not a second zero-quasienergy doubler. Their family is the direct successor
  comparison for any no-pseudo-doubling extension.
- Mlodinow--Brun, arXiv:1802.03910, remains the closest source for the ordered
  product of three one-dimensional coined walks and the four-dimensional
  internal space forced by massive parity symmetry. Nzongani et al.,
  arXiv:2404.09840, remains the required tetrahedral `3+1` comparison.
- Action: manuscript terminology and bibliography corrected; exact corner,
  full-zone audit, local `3+1`, compact rate, and finite Fourier-kernel theorem
  chain integrated. No external code copied.
