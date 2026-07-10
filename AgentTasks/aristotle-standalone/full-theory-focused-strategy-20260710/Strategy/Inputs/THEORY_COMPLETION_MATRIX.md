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
| Positivity and probability | Why are physical norms and probabilities positive and normalized? | `KreinPositiveSectorWitness`, `PositiveHodgeDecoder`, `KreinHodgeNoGo` | invariant positive-sector selection plus normalized state rule; isolate Born input or derive finite replacement | positive/negative sector controls and measurement normalization | D/B | Codex / open bridge |
| Kinematics and causal support | Why do primitive histories propagate on a null cone? | exact checkerboard and tetrahedral null histories | common finite causal-support law in 1+1 and 3+1, with frame dictionary | exact path support and luminal front benchmark | D/H | Claude / compose |
| Dynamics and action | What law weights histories and evolves states? | `FourChannelPathActionCapstone`, `CarrierDynamicsCapstone`, variational groundwork | one displayed action/evolution principle producing carrier equations and conserved quantities | norm/energy/action regression and harmonic-oscillator/Dirac recovery | H/B | unclaimed / flagship |
| Mass | Why can mass arise from massless primitives? | determinant/Pluecker identities, spectral decoder, turns and closure | compose invariant, spectral, and dynamical mass into one theorem-backed dictionary with scope conditions | mass shell, concurrence, turn density, and gap benchmarks | D/B | Claude+Codex / compose |
| Quantum composition | Why do amplitudes superpose and evolution remain unitary? | finite path sums, transfer operators, channel APIs | compositional history algebra with unitarity or precisely named dilation input | interference, norm conservation, and decoherence controls | H/B | Claude / formalize |
| Measurement and classical records | How do outcomes, probabilities, and stable records arise? | recovery/channel stack; pending finite instrument API | normalized finite instrument, no-disturbance theorem, record/decoherence model, and explicit Born boundary | nonprojective Kraus fixture and repeated-record stability | O | Claude / submit |
| Particles, spin, and statistics | What defines a particle species, spin, and exchange law? | positive-code classes, spin-fiber job, Fock modules | stabilizer/automorphism definition of species, spin representation, and a statistics bridge or no-go | finite spin fiber, exchange phase, multiparticle-state count | B/O | Codex / harvest |
| Gauge interactions | Why do gauge connections and Yang-Mills-shaped terms appear? | carrier square, holonomy, four obstruction types, `GaugeMassGram` | derive local gauge action and charges from redundancy/composition rather than insert the group silently | plaquette/holonomy, Ward identity, and gauge-mass rank | H/B | unclaimed / compose |
| Higgs and symmetry breaking | What breaks symmetry, supplies longitudinal modes, and gives the scalar its mass? | `HiggsDofConservation`, `HiggsLongitudinalMode`, finite SSB job | finite order-parameter dynamics, reservoir mechanism, scalar Hessian mass, and thermodynamic-limit boundary | broken/unbroken generators, degeneracy control, Hessian spectrum | B/O | Codex / harvest-submit |
| Flavor and generations | Why mixing, CP violation, and the observed family structure? | `FiniteKMCP`, `KMPhaseCounting`, `FamilyRankNoGo`, `GenerationPermutationNoGo` | compose minimal CP phase theorem with an independent rank/family mechanism or state the exact missing principle | nonzero Jarlskog witness and rank-fixing controls | D/B | Codex / sharpen |
| Binding and many-body physics | Why composites, gaps, confinement-shaped behavior, and effective forces? | closure plane, binding invariants, Schur/Feshbach, Fock gap | multi-history interaction law and scaling beyond a hand-sized carrier | binding energy, seesaw, spectral gap, and enlargement/refinement tests | H/B | unclaimed / compose |
| Spacetime and geometry | How do metric, dimension, locality, and inertial frames emerge? | tetrahedral frame, soldering/coframe modules, spectral distance | reconstruct conformal class plus scale; explain why 3+1 and which decoration supplies tetrad data | causal cone, chain distance, local-frame covariance | H/B | Claude+Codex / compose |
| Gravity | Why does energy-information curve the reconstructed geometry? | `UnifiedActionVariation`, E-slot geometry, Lambda arithmetic | nonvacuous finite field equation, conservation/Ward identity, and continuum Jacobson/TEGR bridge | varying-soldering witness, weak-field/Newtonian recovery | B/O | Codex / formalize |
| Thermodynamics, time, classicality | Why entropy, irreversibility, a time arrow, and classical behavior? | channel monotones, recovery, canonical-ensemble roadmap | specify coarse graining and initial-state principle; derive finite monotonicity and identify thermodynamic limit | entropy production, recovery loss, recurrence and reversed-state controls | B/O | Claude / formalize |
| Cosmology | Why expansion, vacuum response, Lambda, and cosmological initial conditions? | event-count/Lambda modules, vacuum-shift job | dynamical geometry-register model with disclosed statistics and scale-setting law | Lambda phase/count fluctuations and non-Poisson control | B/O | unclaimed / harvest |
| Continuum and QFT recovery | How does the finite model recover Lorentz-covariant local quantum field theory? | quantitative walk continuum, pending local net and many-step jobs | controlled refinement category, local net, renormalized observables, and regulator-error bounds | Dirac propagator, dispersion, microcausality, finite-size scaling | H/O | Claude / flagship |
| Standard Model dictionary | Which structures are derived, selected, or imported? | gauge/Higgs/flavor/spin finite interfaces | one explicit table for group, representations, charges, couplings, masses, mixing, and exceptions | reproduce selected dimensionless observables with parameter accounting | B/O | Claude / synthesis |
| Empirical prediction | What can the theory calculate that was not inserted or fitted? | `SIMULATION_BENCHMARKS.md` V0-V4 ladder | at least one pre-registered V4 candidate or a ranked route with required inputs fixed | held-out observable and numerical failure threshold | O | both / select |

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
  (Scripts/sim/null_information_lab.py), seven families PASS at V0/V1.  No V4
  candidate yet; the row's deliverable is unchanged.
