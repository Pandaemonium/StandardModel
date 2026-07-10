# Whole-theory completion matrix

This is the run's architecture control surface. The manuscript claim matrix
audits individual statements; this matrix prevents a large set of correct local
results from being mistaken for a theory. The target is one candidate finite
null-information theory that runs from primitives to observable physics.

Closure grades:

- `D`: derived from earlier theory layers with a checked finite theorem.
- `H`: conditional theorem with all load-bearing hypotheses displayed.
- `I`: imported physical law, dictionary, constant, or calibration.
- `B`: explicit bridge conjecture with a finite avatar and kill condition.
- `O`: open layer whose exact mathematical interface is not yet fixed.
- `K`: proposed route killed by theorem or counterexample.

No row may end the night with only "future work." Every `B` or `O` row must name
an exact next statement, an Aristotle or analytic work package, a benchmark, and
a failure criterion. An imported law is acceptable only when the manuscript
identifies it as imported and does not count its consequences as predictions.

| Layer | Question a full theory must answer | Current mechanism or anchor | Required closure deliverable | Benchmark / confrontation | Grade at setup | Owner / status |
|---|---|---|---|---|---|---|
| Primitive ontology | What exists before particles and spacetime? | finite oriented null events/edges, amplitudes, labels, composition | minimal primitive-data declaration and equivalence/redundancy relation | enumerate smallest nontrivial histories and invariants | B | unclaimed / specify |
| State and gauge quotient | Which descriptions represent the same physical state? | `Carrier.KugoOjima`, `GenericFiniteHodge`, quotient/cohomology stack | one canonical state-space API connecting gauge quotient, cohomology, and representative choice | exact closed/exact/harmonic decomposition with gauge-variant control | D/B | Codex / compose |
| Positivity and probability | Why are physical norms and probabilities positive and normalized? | `KreinPositiveSectorWitness`, `PositiveHodgeDecoder`, `PositiveHodgePhysicalMass`, `PositiveSectorIntertwinerInvariance` | invariant physical-sector selection plus normalized state rule; isolate Born input or derive finite replacement | nondegenerate quartet has exact positive decoder formula and negative Krein control; rational boost transports the positive cone; measurement normalization separate | D/B | Codex / explicit quartet and presentation invariance closed; universal sector selection open |
| Kinematics and causal support | Why do primitive histories propagate on a null cone? | D4 shell/walk, anisotropic sector/no-gos, `SuccessiveAxisDiracWalk`, `SuccessiveAxisPositionWalk`, `CliffordDiagonalPositionBridge` | derive the Lorentzian/time-axis and supplied eigenbases; establish a quantitative compact-momentum and then position/PDE continuum limit | 12 roots, L=5 simultaneous and four-component position walks, complex kernel rank at most 3, exact `U_j D_j U_j^H=alpha_j`, moving support/norm control, spatial tangent `-iH`, `H^2`, fixed-momentum `3+1` V2 | D/H/B/K | Codex / simultaneous scalar-square identification killed; explicit finite spatial Route B landed; compact rate and physical continuum open |
| Dynamics and action | What law weights histories and evolves states? | `PluckerActionHessian`, `DiscretePluckerVariationalFlow`, `DiscretePluckerFlowStability`, `DiscretePluckerFlowRotation`, `FiniteUnitaryPathAction`, supplied oscillator group and unitary histories | derive/select one field-valued action from primitive data whose reductions yield both the scalar recurrence and spinor Dirac walk, then add interactions and a continuum limit | exact derivatives/EOM, full-window bound for `0<mu<4`, rotation conjugacy, and positive least-residual unitary action with jump/constant controls | D/H/B | Codex / selected scalar action and generic unitary action shell landed separately; shared primitive field action/interactions/continuum open |
| Mass | Why can mass arise from massless primitives? | determinant/Pluecker identities, `ArbitrarySpinorHodgeBridge`, `PluckerActionHessian`, `PluckerHessianSL2Invariance` | derive spinor decorations and action/decoder selection, then fix absolute units and observed values | arbitrary Gram/Hodge/action-curvature fixture, `4/25`,`9/25`, collinear zero, SL2 boost invariance, non-unimodular `64/25` control | D/H/B | Codex / arbitrary supplied pair's Pluecker invariant equals invariant Hodge cost and presentation-invariant action Hessian |
| Quantum composition | Why do amplitudes superpose and evolution remain unitary? | `CheckerboardPathSumTransferPower`, `CheckerboardOperatorHistoryBridge`, `UnitaryHistoryComposition`, `UnitaryCheckerboardTransfer`, channel APIs | derive the normalized coefficients/phases from primitive physical data and connect to interacting/local field evolution | exact value `85`, nontrivial `3/5,4/5` unitary gate/history, real-turn failure, Pauli order control | D/B | Codex / finite path-sum-to-unitary-history chain closed for normalized supplied parameters |
| Measurement and classical records | How do outcomes, probabilities, and stable records arise? | `FiniteInstrumentAPI`, recovery/channel stack; trace outcome rule imported | derive a record/decoherence model while preserving the explicit Born boundary | S25: Kraus completeness, half-half outcomes, projective repeatability, compatible no-disturbance, and noncommuting disturbance control | D/B/I | Claude / finite instrument consistency landed; Born rule imported and decoherence/classicality bridge open |
| Particles, spin, and statistics | What defines a particle species, spin, and exchange law? | positive-code classes, `NullFactorizationSpinFiber`, `SU2SpinHalfAction`, Fock modules | identify the SU(2) representation on physical cohomology, then add a statistics bridge or no-go | factor fiber, inner-product-preserving action, `U^2=-I`/`U^4=I`, exchange phase | D/O | Codex / defining spin-half representation landed; particle/statistics arrow open |
| Gauge interactions | Why do gauge connections and Yang-Mills-shaped terms appear? | carrier square, holonomy, four obstruction types, `GaugeMassGram` | derive local gauge action and charges from redundancy/composition rather than insert the group silently | plaquette/holonomy, Ward identity, and gauge-mass rank | H/B | unclaimed / compose |
| Higgs and symmetry breaking | What breaks symmetry, supplies longitudinal modes, and gives the scalar its mass? | `HiggsDofConservation`, `HiggsLongitudinalMode`, finite SSB job | finite order-parameter dynamics, reservoir mechanism, scalar Hessian mass, and thermodynamic-limit boundary | broken/unbroken generators, degeneracy control, Hessian spectrum | B/O | Codex / harvest-submit |
| Flavor and generations | Why mixing, CP violation, and the observed family structure? | `FiniteKMCP`, `KMPhaseCounting`, `FamilyRankNoGo`, `GenerationPermutationNoGo` | compose minimal CP phase theorem with an independent rank/family mechanism or state the exact missing principle | nonzero Jarlskog witness and rank-fixing controls | D/B | Codex / sharpen |
| Binding and many-body physics | Why composites, gaps, confinement-shaped behavior, and effective forces? | closure plane, binding invariants, Schur/Feshbach, Fock gap | multi-history interaction law and scaling beyond a hand-sized carrier | binding energy, seesaw, spectral gap, and enlargement/refinement tests | H/B | unclaimed / compose |
| Spacetime and geometry | How do metric, dimension, locality, and inertial frames emerge? | tetrahedral frame, soldering/coframe modules, spectral distance | reconstruct conformal class plus scale; explain why 3+1 and which decoration supplies tetrad data | causal cone, chain distance, local-frame covariance | H/B | Claude+Codex / compose |
| Gravity | Why does energy-information curve the reconstructed geometry? | `UnifiedActionVariation`, E-slot geometry, Lambda arithmetic | nonvacuous finite field equation, conservation/Ward identity, and continuum Jacobson/TEGR bridge | varying-soldering witness, weak-field/Newtonian recovery | B/O | Codex / formalize |
| Thermodynamics, time, classicality | Why entropy, irreversibility, a time arrow, and classical behavior? | `FiniteGibbsResponse`, `FiniteGibbsVariance`, channel monotones, recovery, canonical-ensemble roadmap | specify coarse graining and initial-state principle; derive finite monotonicity and identify thermodynamic limit | normalized `4/25` ensemble, both response derivatives, `Var=4/625`, `Var=0` iff spectrum constant, degenerate and Schottky controls | D/B/O | Codex+Claude / finite response, fluctuation positivity, and rigidity landed; irreversibility, time arrow, and thermodynamic limit open |
| Cosmology | Why expansion, vacuum response, Lambda, and cosmological initial conditions? | event-count/Lambda modules, vacuum-shift job | dynamical geometry-register model with disclosed statistics and scale-setting law | Lambda phase/count fluctuations and non-Poisson control | B/O | unclaimed / harvest |
| Continuum and QFT recovery | How does the finite model recover Lorentz-covariant local quantum field theory? | fixed/bounded symbol limits, finite/countable synthesis, `GeometricModeSynthesis`, finite tensor locality | derive a walk-specific envelope and synthesis existence, then prove infinite-volume/L2/PDE convergence and graph-derived local nets | exact geometric infinite-mode witness, Dirac propagator, dispersion, microcausality, finite-size scaling | H/O | Codex / generic countable theorem + explicit arithmetic witness landed; physical walk/PDE arrow unchanged |
| Standard Model dictionary | Which structures are derived, selected, or imported? | gauge/Higgs/flavor/spin finite interfaces | one explicit table for group, representations, charges, couplings, masses, mixing, and exceptions | reproduce selected dimensionless observables with parameter accounting | B/O | Claude / synthesis |
| Empirical prediction | What can the theory calculate that was not inserted or fitted? | `SIMULATION_BENCHMARKS.md` V0-V4 ladder; 20 families = 17 V0/V1 + three disclosed V2 | at least one pre-registered V4 candidate or a ranked route with required inputs fixed | held-out observable and numerical failure threshold | O | both / no honest V4 yet; coefficient forcing and absolute-scale derivation are prerequisites |

## Composition test

At least one chain must be executable and manuscript-visible by dawn:

```text
primitive null data
  -> gauge-equivalence class
  -> positive physical state
  -> finite action/evolution
  -> spectral or closure observable
  -> calibrated units
  -> known-physics benchmark
  -> falsifiable extrapolation
```

For every arrow, cite a theorem, a displayed imported principle, or an exact
bridge conjecture. A chain with an unnamed arrow is not an end-to-end result.

## Authorial standard

The manuscript should announce the theory before cataloguing its evidence. It
should explain why null information is the proposed common origin of quantum
state, mass, interaction, and geometry; derive as much of that claim as the
formal corpus supports; then identify the small, explicit frontier separating
the present candidate theory from a completed physical theory. Boundaries must
increase precision and research pressure, not reduce the work to tentative
analogies.

## Landings affecting rows (2026-07-09 23:45 PDT, Claude)

- **State and gauge quotient**: Carrier/KreinChainEquivalence landed (intertwiner
  half: cohomology matching both ways, decoder agreement up to homotopy, spectrum
  under conjugation, positive inertia with finrank).  Together with
  DecoderChainHomotopy the presentation-equivalence layer is now D at the finite
  level; invariant sector selection stays B.
- **Kinematics and causal support**: RapidityInformationDistance landed (velocity
  addition = tanh law, speed limit, rapidity = log distance, boost-invariant det).
  Benchmark S07 LANDED (exact).  Row remains D/H with the frame dictionary advancing.
- **Mass**: Carrier/PositiveHodgeRayleigh landed - variational least-cost mass with
  the Kugo-Ojima radical + ghost-positivity hypotheses, attainment at the harmonic
  representative, and the necessity counterexample.  The mass row's "compose
  invariant/spectral/dynamical" deliverable now has its variational vertex.
  Benchmarks S01/S02 LANDED.
- **Flavor and generations**: SpectralMonodromyDichotomy landed - Hermitian loops
  cannot braid ordered real spectra (no-go half), Z3 sheet monodromy exists on the
  complexified companion family (positive half).  Generation-as-monodromy is now a
  controlled dichotomy: it needs complexified moduli or degeneracy crossings, else
  eigenvector holonomy.  Row stays D/B with a sharpened mechanism space.
- **Spacetime and geometry**: SpectralChainDistance landed (n-point Connes-style
  distance = weighted geodesic, additivity, scale covariance, edge-block commutator
  grounding).  The order+scale reconstruction now extends beyond two points.
- **Cosmology**: GeometryRegisterLambda landed (Lambda observable exactly through
  geometry-register coherence; pi-periodicity; decohered constancy) and
  VacuumShiftEnsemble landed (extensive vacuum shift = ensemble redundancy; sector
  correlator invariance; ARISTOTLE KILL of the pi-quadratic negative control -
  N^2 = N mod 2 on counts (1,2) - with the corrected absorbable theorem landed and
  the true pi/2 negative control queued).  Benchmark S12 LANDED.  Volume statistics
  remain I/B.
- **Empirical prediction**: the laboratory exists
  (Scripts/sim/null_information_lab.py), twenty families PASS: seventeen at
  V0/V1 plus three disclosed V2 reproductions (fixed-momentum free `1+1` and
  `3+1` Dirac propagation, and an independent three-level finite-difference
  fluctuation-response check). The equal-degeneracy Schottky row is retained as
  a V0/V1 algebraic self-consistency check because its normalized gap cancels.
  No V4 candidate has been tested; the prediction deliverable is unchanged.

## Codex composition landings (2026-07-09 23:39 PDT)

- **Quantum composition:** `CheckerboardAmplitudeGluing` proves exact
  multiplicativity under history concatenation while carrying the intermediate
  direction, with a nonzero boundary-turn witness. This is a derivation arrow,
  not a conjunction.
- **Mass:** `CanonicalGramTurnDictionary` proves the free Pluecker mass operator
  equals the complexified turn channel for the displayed pair `e0, m e1`, and
  proves a fixed pair cannot encode two distinct turn scales. The equality is
  derived after the dictionary; derivation of the dictionary remains B.
- **Continuum:** `FixedMomentumManyStepContinuum` proves an explicit fixed-time
  `D(k,m)t^2/n` operator-norm bound and convergence to exact Dirac evolution.
  Uniform momentum, position-space, PDE, and `3+1` limits remain open.
- **Spin:** `NullFactorizationSpinFiber` identifies the full right `U(2)` fiber
  of an invertible positive momentum factor and its determinant-fixed `SU(2)`
  reduction, with a nontrivial concrete orbit. Representations, Wigner rotations,
  and spin-statistics remain open.
- **Hodge correction:** under genuine nilpotence, radicality, and decoder descent,
  exact-representative spectral cost is constant. The earlier nonzero affine
  variation uses a non-nilpotent projection and is not a cohomology-class witness.
- **Uniform continuum rung:** `BoundedMomentumManyStepContinuum` replaces the
  pointwise constant by one explicit `Dbox(K,M)` valid for every
  `|k| <= K`, `|m| <= M`, and proves the common `1/n` envelope tends to zero.
  Position-space and PDE convergence remain open.
- **Hodge-Pluecker composition:** `HodgePluckerMassBridge` proves that, under
  the displayed bridge hypothesis `mu2 = m^2`, every exact representative's
  class cost equals the canonical Pluecker invariant. A single nonzero
  nilpotent/shared-spinor fixture realizes `4/25` on both sides.

## Codex second composition wave (2026-07-10 00:42 PDT)

- **Quantum composition:** `CheckerboardPathSumTransferPower` now proves the
  exact sum over all finite two-direction histories is the indicated matrix
  element of the transfer power. `HistoryOperatorMonoidalDagger` upgrades
  scalar gluing to sequential, dagger, and parallel operator composition with
  a noncommuting Pauli control. Gate assignment and unitarity remain inputs.
- **Mass/positivity correction:** `quartet_class_cost_eq_canonical_plucker`
  connects the nondegenerate four-dimensional Hodge quartet, rather than the
  older degenerate fixture, to the canonical nonzero `4/25` Pluecker value.
  The general `mu2=m^2` bridge remains a displayed hypothesis.
- **3+1 kinematics:** `Clifford3Plus1WalkSymbol` proves exact 4x4 Clifford
  relations, component-velocity spectrum `+/-1`, and
  `H(k,m)^2=(|k|^2+m^2)I`. This is an internal algebraic prerequisite, not yet
  a BCC lattice step, summed history propagator, or 3+1 continuum theorem.

## Codex keystone wave (2026-07-10 01:45 PDT)

- **Primitive directions to mass API:** `D4NullRaySpinorFactorization` gives
  every selected future axial D4 null ray an explicit Gaussian-integer spinor
  whose rank-one Hermitian image is the corresponding half-Pauli vector. This
  closes an exact dictionary into the project's Pluecker API for the selected
  alphabet; it does not derive the alphabet or preferred time axis.
- **Unitary quantum histories:** `UnitaryHistoryComposition` proves finite
  sequential histories and equal-length parallel Kronecker histories remain
  two-sided unitary whenever each supplied local gate is unitary.
  `UnitaryCheckerboardTransfer` now proves the exact path-sum transfer belongs
  to that class for the displayed normalized coefficients and phases.
- **Parameterized physical mass:** `quartetSAt m` retains the same
  nondegenerate indefinite pairing and genuine nilpotent constraint while
  deriving class cost `m^2` for every exact representative. The project-level
  bridge proves this equals canonical Pluecker mass for every real `m` without
  the former `mu2=m^2` premise; `2/5` and `3/5` are distinct controls.
- **Countable continuum rung:** `SummableFourierContinuumLift` proves an exact
  countable synthesis error bound and norm convergence under a summable
  nonnegative mode envelope, with a normalized geometric witness. The open
  arrow is now walk-specific envelope construction and then PDE/L2 recovery,
  rather than countable summation itself.
- **Arbitrary-pair physical mass:** `ArbitrarySpinorHodgeBridge` composes the
  general Gram-derived turn scale with the nondegenerate quartet decoder, so
  every supplied spinor pair's exact class cost equals its Pluecker invariant.
  Decoration and decoder selection remain physical inputs.
  `PluckerActionHessian` now realizes the same invariant as an exact finite
  action curvature. `DiscretePluckerVariationalFlow` now derives an exact
  recurrence from a selected adjacent-link action, and
  `DiscretePluckerFlowStability` proves a positive-definite conserved form and
  all-iterate bound. Primitive selection of that action remains open.
- **Normalized finite quantum engine:** `UnitaryCheckerboardTransfer` proves
  that the same transfer appearing in the exact path sum is two-sided unitary
  under `c^2+s^2=1`, imaginary turn phase, and unit outgoing phases. Combined
  with `UnitaryHistoryComposition`, every finite replicated history is unitary.
  A nontrivial `3/5,4/5` witness and real-turn failure control are guarded.

## Codex dynamics and D4 wave (2026-07-10 03:37 PDT)

- **Concrete D4 dynamics:** `ExplicitSixChannelCoin` supplies a nonidentity
  two-sided-unitary `6x6` coin and composes it with the periodic null shift.
  Its three axis pairs are decoupled, and the full coin square has nonzero
  off-diagonal entry `24i/25`; therefore the full coin is not itself a
  Clifford involution. A restricted 3+1 Dirac sector remains open.
- **Four-plus-two architecture:** `SixFourInvariantBlock` gives an injective,
  isometric four-component inclusion and exact block intertwining after a
  coordinate choice and the necessary `A 0 = 0` condition. It is a constructed
  architecture, not an instantiation of the concrete D4 coin or shift.
- **Finite conserved dynamics:** `PluckerOscillatorDynamics` and
  `PluckerOscillatorGroup` make the supplied Pluecker scale the stiffness of an
  exact determinant-one reversible oscillator family with inverse, composition,
  and conserved energy. S16 checks one and 25 steps at `m=2/5`. This supplied
  oscillator group is kept distinct from the selected action-derived recurrence
  and stability theorem checked by S19.
- **Thermodynamic finite model:** `FiniteGibbsResponse` and
  `FiniteGibbsVariance` prove positivity, normalization,
  `d log Z/d beta = -mean E`, `d mean E/d beta = -Var(E)`, and `Var(E) >= 0`.
  The Pluecker gap gives exact variance `4/625` at beta zero, and zero variance
  is equivalent to a constant spectrum. S22 independently differentiates the
  mean energy of the three-level spectrum `(0,4/25,9/25)` and reproduces the
  centered variance with second-order finite-difference convergence. S20 is an
  algebraic Schottky self-consistency check, not an external V2 reproduction.
  Irreversibility, coarse graining, physical temperature calibration, and the
  thermodynamic limit remain open.
- **Joint decorated-pair seam:** `PluckerJointTheoryWitness` now packages one
  supplied pair through Hodge cost, action Hessian, conserved variational-flow
  stiffness, two-level Gibbs spectrum, logarithmic response, and fluctuation
  response. The exact `4/25` fixture is nondegenerate and the collinear fixture
  collapses mass, action curvature, and variance together. This is one genuine
  shared-witness chain across the Mass, Dynamics, and Thermodynamics rows.
  `PluckerDiracCarrierBridge` now feeds that literal `massSq` into the two-level
  Gibbs gap, the internal `3+1` Clifford square, and the split-step tangent. The
  rational pair gives Dirac mass `4/25` and exact square `5641/625`; the
  collinear pair removes both the gap and the zero-momentum generator. This
  closes the finite parameter-identification seam to Kinematics, but does not
  prove that the scalar and spinor dynamics arise from one field-valued action,
  derive the decorations/frame, or close the Primitive-to-Kinematics seam.
  Benchmark S23 runs the whole finite joint chain on one exact configuration
  and rejects an independently substituted `9/25` Gibbs gap. S24 then regresses
  the same `4/25` pair mass against the exact internal `3+1` Dirac square and
  detects an independently substituted Dirac mass.
- **Generic unitary action shell:** `FiniteUnitaryPathAction` assigns every
  selected finite unitary history its sum-of-squared-residuals action, proves
  nonnegativity, identifies action zero exactly with the selected link EOM, and
  derives on-shell norm conservation. A scalar jump has action one while a
  constant identity history has action zero. This is a least-residual
  characterization, not the still-open field action that must derive both the
  Pluecker recurrence and Dirac walk.

## Measurement row advance (2026-07-10 05:03 PDT, Claude)

- **Measurement and classical records**: FiniteInstrumentAPI landed (b5e0773e) -
  normalization, positivity, projective repeatability, compatible no-disturbance,
  qubit witness + noncommuting disturbance control.  Row moves O -> D/B/I: instrument
  consistency D (finite), record stability D (projective case), Born outcome rule
  explicitly I (imported; postulate P4), decoherence/record model still B.  Disjoint
  from and composing with Codex's Kraus no-signaling lane.

## Sprint additions (2026-07-10 06:32, Claude)

- **Measurement row**: S25 landed - exact V1 regression of FiniteInstrumentAPI
  (normalization, repeatability, compatible no-disturbance, disturbance
  control). The row's benchmark deliverable is now executable.
- **Composition test**: the one-carrier closure pair is IN FLIGHT
  (claude-null-chain-joint-witness 9014b77f); on landing, the chain
  primitive -> gauge class -> positive state -> spectral mass -> dynamics ->
  benchmark -> falsifier is theorem-linked on a single witness with the
  single scalar mu^2 displayed end to end.
- **Quantum composition row**: contextuality fixture in flight (b980d39b).
- **Particles/spin/statistics row**: finite spin-statistics interface in
  flight (680e2f13); the locality-forced identification remains the named
  open bridge.

## Bridge-wave additions (2026-07-10 07:12, Claude)

- **Dynamics/action row**: bridge (ii) reduction half in flight (82624587) -
  spinor walk and scalar variational flow as two reductions of one unimodular
  step via Cayley-Hamilton, conserved quadratic shared.
- **Quantum composition / locality rows**: bridge (iv) net rung in flight
  (9f447ed0) - isotony + disjoint commutativity over all regions of a
  three-site lattice.
- **Gauge interactions row**: bridge (vii) seed in flight (c120b23e) - the
  witness decoder's automorphism group classified exactly; derived U(1) on
  the physical class. Method-level: charge groups as decoder outputs.
- **Measurement row**: spin-statistics interface LANDED (SpinStatisticsInterface);
  **Cosmology row**: vacuum-shift negative control LANDED
  (VacuumShiftNegativeControl) - the redundancy row is now witness+control
  complete.

## Audience-wave additions (2026-07-10 08:05, Claude)

- **Dynamics/action row**: bridge (ii) reduction half LANDED
  (SharedActionReduction) - spinor walk and scalar variational flow are two
  reductions of one unimodular step; conserved quadratic shared.  Benchmark
  S26 executes the full Composition-test chain on one scalar.
- **Gauge interactions row**: bridge (vii) seed LANDED
  (DecoderAutomorphismGroup) - the witness decoder's symmetry group derived
  exactly; U(1) charge on the physical class is an output.  Method-level.
- **Measurement row**: MerminPeres benchmark S27 executes the contextuality
  obstruction exhaustively (512 valuations, zero satisfying).
- **Higgs row**: both seeds benchmarked (S28); stiffness as output in both
  mechanisms, with the subcritical control.
- **Continuum/QFT row**: the Brillouin-zone doubling audit is in flight
  (e7f8ed51) - the audience's first technical question becomes a theorem
  (pi-mode doubler exhibited, mass gaps both cones uniformly).

## Hard-problem wave (2026-07-10 09:20, Claude)

- **Mass row / Paper I centerpiece**: PlueckerMassOperator LANDED - the mass
  operator is now DERIVED from the wedge coordinate (Bz^2 = det P, hero
  identity, derived evolution); the 'parameter wired into modules' objection
  is answered by theorem.
- **Locality row**: FiniteRegionNet LANDED - isotony + disjoint
  commutativity over all regions (three sites).
- **Continuum row**: the fixed-momentum max-entry telescope snapshot
  (`7d5a9d2d`) is hole-free and passes locally; the live tree already contains
  stronger operator-norm compact-box many-step theorems in `1+1` and ordered
  `3+1`, so this is a reusable independent route rather than the remaining
  closure step.
- **Positivity row**: `PositiveSectorSelectionDichotomy` LANDED from
  `99a0e4b5`. A strict real spectral gap is sufficient for a positive invariant
  eigendirection, while a nonreal eigenvalue forces its eigendirection neutral.
  The exceptional/repeated-root boundary is deliberately not promoted to a
  biconditional.
- **Measurement row**: `FiniteEffectValuationHomogeneity` LANDED from the
  completed portion of `d0b9c616`. Positivity and finite additivity imply
  monotonicity and real `[0,1]` homogeneity by rational squeeze, with no
  continuity assumption; an explicit nonempty valuation class is guarded. The
  cross-basis linear extension and density-matrix representation remain active
  in the same Aristotle project.
- **Scale row**: `DiscreteDimensionalTransmutation` LANDED from `8ec5d15e`:
  exact inverse-coupling invariant, step-independent exponential scale, and
  nonperturbative flatness. The recursion and coefficient remain supplied.

## Codex Fourier/L2 advance (2026-07-10 09:25 PDT)

- **Continuum row**: `FiniteZModPlancherel` LANDED from an in-progress
  Aristotle snapshot (`3fb4cfc5`), with all requested statements unchanged and
  locally kernel checked. It proves vector-valued forward and inverse DFT
  energy identities, the normalized finite `L2` wave-packet error bound, and
  a one-mode normalization control.
- **Exact local-symbol bridge**: `Finite3Plus1FourierBridge` LANDED from
  `codex-finite-fourier-symbol-conjugacy` (`1d093252`). The actual live local
  operator preserves every product plane-wave sector and acts there by the
  exact ordered three-axis-plus-mass finite-character block.
- **Analytic sign bridge**: `Finite3Plus1AnalyticSignBridge` LANDED from the
  completed convention job `9620f01b`. It proves the exact negative-lattice-
  momentum conversion for every axis and the complete ordered local symbol,
  with a quarter-zone `-i` control. The product-DFT bundle remains separate.
- **Countable L2 bridge**: `CountableL2WavepacketConvergence` LANDED. Mathlib's
  Tannery theorem now gives total countable squared-error convergence from
  pointwise mode convergence plus one summable squared envelope, with a nonzero
  one-mode fixture.
- **Complex 3+1 mass core**: `Pluecker3Plus1ComplexMass` LANDED from the
  completed core of `64ead89b`. The live Clifford representation now has a
  phase-retaining Hermitian `mass4(z)` with square `|z|^2 I`, exact full Dirac
  square, real-axis reduction, chiral covariance, exact unitary mass-coin group
  law, and a `3+4i` control. `ComplexPlueckerLocalWalk` now inserts that coin
  into the finite position update with exact norm preservation and an exact
  ordered plane-wave block. Transporting the compact rate through phase
  conjugacy is the narrow successor.
- **Remaining continuum obligation**: package the product three-torus Fourier
  equivalence, construct the walk-specific square-summable envelope, and
  identify its limiting multiplier with the Dirac PDE propagator under an
  infinite-volume/continuum Fourier isometry.
- **Carrier moduli row**: `Carrier.DecoderModuliClassification` LANDED from
  `b037861c`. For the actual `Q=E01` positive-Hodge carrier, all commuting
  decoders have a five-coordinate normal form, exact `Q R + R Q` deformations
  are precisely the zero-physical-coordinate slice, and `D(2,2)` completely
  classifies chain-homotopy classes. Distinct same-mass and different-mass
  controls make the quotient nonvacuous. Arbitrary-carrier classification is
  still open.
