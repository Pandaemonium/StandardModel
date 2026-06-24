# P9 source-visibility manuscript outline

**Status:** draft outline, 2026-06-23.
**Working title:** finite source visibility, observer channels, and residual
noise in causal diamonds.
**Related docs:** `Sources/Null_Edge_Key_Conjectures.md`,
`Sources/Null_Edge_Causal_Graph_Publication_Plan.md`,
`Sources/Null_Edge_Causal_Graph_Strengthened_Program.md`,
`Sources/Null_Edge_P9_Physics_Development.md`, and
`AgentTasks/null-edge-codex-overnight-run-postmortem-2026-06-23.md`.

## One-sentence thesis

The P9 paper should not claim to solve the cosmological-constant problem. It
should prove a finite source-visibility theorem stack: which causal-diamond
observer channels erase, preserve, or suppress internal source bookkeeping, and
which visible defects survive as bulk-readable signals under pre-specified
coarse-grainings.

## Claim boundary

The paper's strongest safe claim is:

> In finite causal-diamond models, source visibility is not intrinsic to a
> chain, edge, or defect alone. It is a property of a source together with an
> observer channel. Boundary-exact and projected-away data can be invisible,
> while visible closure/Pluecker-style defects can survive local readouts. Some
> coarse maps provably erase the signal, and Alexandrov-local subdiamond
> restrictions provably preserve the local readout.

The paper should explicitly avoid these stronger claims:

- no claim that the observed cosmological constant is explained;
- no claim that zero-mean microscopic bookkeeping is sufficient;
- no claim that every coarse-graining preserves the visible defect;
- no claim that fine-grained continuum behavior is required.
- no claim that beating the everpresent-Lambda `V^(-1/2)` benchmark is by
  itself enough to explain observed dark energy. A screen-supported residual
  may be too suppressed; an observed nonzero Lambda-scale signal likely needs a
  surviving global, harmonic, or unimodular residual mode.

The discrete-first standard is:

> Failure of fine-grained continuum resemblance is not a failure of P9. Failure
> means there is no stable, pre-specified coarse-grained observer channel whose
> large-scale readout separates hidden bookkeeping from visible source defects.

The physics target is now two-component:

```text
local vacuum bookkeeping -> exact/projected/screen-supported sector
observed Lambda-scale residual -> global or harmonic quotient, if present
```

This prevents a false victory. If source visibility suppresses local vacuum
noise from `V^(-1/2)` down to a codimension-two screen law
`sqrt(A) / V ~ V^(-3/4)` in four spacetime dimensions, that is excellent
vacuum filtering but is probably too small to be the observed dark energy by
itself. The program must separately identify any surviving `closed / exact`
harmonic mode that keeps the Hubble-scale `L^(-2)` order of magnitude.

## Intended contribution

P9 becomes publication-worthy if it delivers:

1. A precise finite language for source tests on causal diamonds.
2. Kernel-checked invisibility theorems for boundary-exact or projected-away
   data.
3. Kernel-checked visibility theorems for explicit finite defects.
4. A finite noise-response layer with positivity, Cauchy-Schwarz bounds, and
   residual-variance controls.
5. Coarse-map guardrails showing when a signal is erased, preserved, or
   artifact-prone.
6. A clear bridge to the cosmological-constant literature as motivation, not as
   a solved phenomenological result.

Newest finite theorem anchors:

- `NullEdgeP9OperationalGap`: the six-point T1 witness has an explicit
  bucket-level operational gap.
- `NullEdgeP9OperationalGapCoarseMap`: the named critical coarse map erases
  that operational gap, so visibility is not automatic under coarse-graining.
- `NullEdgeP9SubdiamondRestrictionPreservesLocalReadout`: Alexandrov/subdiamond
  restriction preserves local interval readouts under transitivity.
- `NullEdgeP9SubdiamondNonvacuity`: the proper subdiamond `(0,3)` still
  separates the two histories, so the preservation result is not merely a
  whole-diamond tautology.
- `NullEdgeP9NoncriticalCoarseErasure`: unrestricted surjective coarse maps are
  too broad; one map keeps the critical swapped pair distinct while still
  erasing the bucket-one local signature. The paper must therefore define an
  admissible coarse-map or observer-channel class before making stability
  claims.
- `NullEdgeP9ExactRecoveryAdmissibleCoarseMap`: common exact recovery is one
  sufficient admissibility certificate. A recoverable coarse map pulls every
  chosen fine distinguishing test back to a coarse observer test. This is a
  positive guardrail beside the erasure examples, not a claim that arbitrary or
  approximately recoverable coarse maps preserve visibility.
- `NullEdgeP9StochasticExactRecoveryObservablePullback`: the same sufficient
  admissibility idea now has a normalized stochastic version. For finite
  distributions and column-stochastic observer channels, common exact recovery
  pulls every fine distinguishing observable back to a coarse distinguishing
  observable.
- `NullEdgeP9StochasticExactRecoveryGap`: common exact stochastic recovery
  preserves the numerical expectation gap of the fine observable after
  pullback. This is the cleanest finite operational source-visibility theorem
  in the current P9 lane.
- `NullEdgeP9StochasticExactRecoveryComposition`: exact stochastic recovery is
  closed under composition on a selected source pair. This turns exact recovery
  from a one-shot certificate into a structurally usable sufficient class of
  admissible observer channels.
- `NullEdgeP9StochasticErasureNotRecoverable`: if a stochastic observer channel
  sends two genuinely distinct source distributions to the same coarse output,
  then exact recovery is impossible for that pair. This is the no-go side of
  the admissible-channel story.

## Proposed paper structure

### 1. Accessible overview

Purpose: explain why the cosmological-constant problem is partly a source
visibility problem.

Core story:

- Vacuum bookkeeping may be enormous microscopically.
- A finite observer does not see every microscopic degree of freedom.
- What matters is the response channel: which combinations source a readable
  bulk defect?
- The program tests this in finite causal diamonds before making continuum
  claims.

Suggested high-school-level analogy:

> A room can contain many tiny pushes in every direction. If they cancel in the
> way the wall sensor measures them, the wall reads no net pressure. If one
> organized pattern fails to cancel, the wall reads a force. P9 asks which
> causal-diamond sensors can tell the difference.

### 2. Motivation from the cosmological-constant problem

Purpose: situate P9 without overclaiming.

Discuss:

- vacuum energy as a source problem;
- why "large microscopic bookkeeping" does not automatically imply a large
  observed source if the observer channel has a kernel;
- Sorkin-style everpresent Lambda as a serious nearby idea: sign-changing
  fluctuations of order `1 / sqrt(V)`, with amplitude and observational
  constraints;
- stochastic-gravity noise kernels as a warning that zero mean is not enough.
- the hard comparison: P9 must predict an amplitude, suppression, or
  correlation structure different from the existing everpresent-Lambda
  benchmark, or else it is a reformulation rather than a new mechanism.

Message:

> P9 asks for a finite structural reason why hidden bookkeeping can be
> boundary-like, projected away, or mean-zero under the relevant observer
> channel, while visible defects remain source-visible.

The manuscript should make `predicted_deltaLambda_amplitude_vs_everpresent` a
top-line falsification gate. A finite channel that reproduces the usual
`1 / sqrt(V)` story without a new correlation or suppression handle is still
interesting finite Hodge theory, but it is not cosmological-constant leverage.
Conversely, a finite channel that suppresses residuals faster than
`1 / sqrt(V)` is source-filtering leverage, but not automatically a dark-energy
mechanism. The manuscript should separate:

```text
UV vacuum filtering:        local/exact/projected noise is invisible or small
observed dark-energy scale: surviving global/harmonic residual, if any
```

### 3. Finite causal-diamond setup

Purpose: define the playground before interpretation.

Objects:

- a finite causal diamond or finite poset interval;
- chains, edges, faces, and boundary maps;
- source assignments on finite cells;
- observer tests as linear functionals;
- response kernels and projected observer channels;
- local interval/readout functions.

Conventions to state:

- all results are finite;
- all response maps are chosen before seeing the signal;
- "hidden" means invisible to a specified channel, not nonexistent;
- "visible" means nonzero response under a specified finite test.

### 4. Source tests and visible defects

Purpose: isolate the minimum source algebra.

Lean spine:

- `NullEdgeP9ClosureDefect`
- `NullEdgeP9ClosureVisibleSource`
- `NullEdgeP9ClosureVisibleAny`
- `NullEdgeP9VisiblePluckerSourceAPI`

Narrative:

- closure is the finite analogue of source neutrality;
- visible closure defects are finite witnesses;
- Pluecker-style visible defects give a natural mass/source candidate;
- the paper should state exactly which tests see each defect.

Main result shape:

```text
visible defect + admissible test -> nonzero source readout
closed or neutral bookkeeping    -> zero readout for that channel
```

### 5. Boundary-exact invisibility

Purpose: prove that some microscopic bookkeeping is harmless for the chosen
readout.

Lean spine:

- `NullEdgeP9BoundaryExact`
- `NullEdgeP9BoundaryExactNoiseInvisible`
- `NullEdgeP9BoundaryExactPerturbationInvariant`
- `NullEdgeP9AntisymmetricMeanZero`
- `NullEdgeP9WeightedAntisymmetricMeanZero`
- `NullEdgeP9PairedCancellation`
- `NullEdgeP9MeanFluctuation`

Narrative:

- exact or boundary-supported data can be invisible to closed tests;
- paired cancellation and antisymmetry provide finite mean-zero mechanisms;
- mean-zero is a starting point, not the end of the argument;
- residual fluctuations must still be bounded by a response law.

Key caution:

> A zero mean source can still have a large variance. P9 is only useful if the
> response kernel and coarse channel suppress or control that variance.

### 6. Noise kernels and residual response

Purpose: turn the mean-zero story into a quantitative finite theory.

Lean spine:

- `NullEdgeP9NoiseResponseNonneg`
- `NullEdgeP9NoiseCauchySchwarz`
- `NullEdgeP9PositiveWeightNoiseZero`
- `NullEdgeP9NoiseKernelEntryRecovery`
- `NullEdgeP9NoiseKernelDeterminedByTests`
- `NullEdgeP9ResponseCharacterization`
- `NullEdgeP9WeightedSuppressionThreshold`
- `NullEdgeP9ResidualVarianceCellArea`
- `NullEdgeP9MaxWeightResidualBound`
- `NullEdgeP9WeightedBenchmarkBound`

Narrative:

- a source channel has both mean response and noise response;
- positivity and Cauchy-Schwarz give the finite guardrails;
- test families can determine kernel entries;
- weighted suppression benchmarks define what "small residual" means.

Potential central theorem:

```text
If source covariance lies mostly in the observer-channel kernel, then the
visible residual variance is bounded by the projected weight of the source.
```

The paper should include the finite scaling audit from
`Sources/Null_Edge_P9_Physics_Development.md`. If the surviving independent
fluctuations live on a codimension-two screen with area `A ~ L^2` in four
spacetime dimensions, then

```text
RMS(delta Lambda) ~ sqrt(A) / V ~ L^(-3) = V^(-3/4).
```

If they live on a null hypersurface measure `B ~ L^3`, then

```text
RMS(delta Lambda) ~ sqrt(B) / V ~ L^(-5/2) = V^(-5/8).
```

Both suppress faster than the everpresent-Lambda `V^(-1/2) ~ L^(-2)` law. This
is useful for filtering local vacuum noise, but it pushes the observed nonzero
dark-energy scale into a surviving harmonic/global sector.

### 7. Hodge/projector observer channels

Purpose: make observer-channel mixedness and source visibility precise.

Lean spine:

- `NullEdgeP9ClosedWitness`
- `NullEdgeP9BoundaryVisibleDecomp`
- `NullEdgeP9WeightedNoiseBound`
- `NullEdgeP9HarmonicProjectorResponse`
- `NullEdgeP9ProjectedNoiseKernel`
- `NullEdgeP9OrthogonalProjectorCore`
- `NullEdgeP9WeightedProjectorResidualOrthogonal`
- `NullEdgeP9WeightedProjectorPythagorean`
- `NullEdgeP9StrictProjectedKernel`
- `NullEdgeP9ConditionedResponseBound`
- `NullEdgeP9CoarseResidualVariance`
- `NullEdgeP9CoarseKernelPSD`
- `NullEdgeP9RankOneHarmonicTrace`
- `NullEdgeP9WeightedAdjointCore`
- `NullEdgeP9WeightedLaplacianEnergy`
- `NullEdgeP9WeightedLap1SelfAdjoint`
- `NullEdgeP9HarmonicKernelCore`
- `NullEdgeP9HodgeProjectorInstantiation`
- `NullEdgeP9CoarseBoundaryInvariance`
- `NullEdgeP9TwoCellTraceSeparation`

Narrative:

- finite Hodge decompositions give a natural observer-channel split;
- exact/boundary data can land in a projected-away sector;
- harmonic or selected-sector data can survive as observable response;
- projector identities give Pythagorean residual accounting.
- the full closed interval order complex may be contractible, so the paper must
  audit whether the intended harmonic sector is trivial before treating it as a
  Lambda channel.

Topology audit:

```text
full closed interval order complex
  -> likely contractible
  -> positive-degree harmonic sector may vanish

possible alternatives:
  proper interval with endpoints removed
  relative cohomology
  constant H^0 mode
  top relative mode
  low-lying near-harmonic spectral band
```

Projector convention:

```text
Delta_k = d_{k-1} d_{k-1}^* + d_k^* d_k
Pi_H = I - Delta_k^+ Delta_k
```

The pseudoinverse form should be preferred over ordinary inverse formulas,
since harmonic modes are exactly where ordinary invertibility fails.

What this section must not imply:

- that the chosen projector is physically unique;
- that Hodge language alone solves the amplitude problem;
- that continuum Hodge theory is already recovered.

### 8. Causal support and retarded response

Purpose: keep the response channel causal.

Lean spine:

- `NullEdgeP9CausalSupportBound`
- `NullEdgeP9RetardedNilpotentReach`
- `NullEdgeP9EdgeNeighborReach`
- `NullEdgeP9RetardedGreenSeries`

Narrative:

- a causal observer should not respond outside the causal reach of the source;
- finite nilpotent retarded series give a discrete response law candidate;
- support bounds prevent nonlocal readouts from masquerading as physics.

Potential theorem target:

```text
retarded response to a finite source is supported in the finite causal future
and has a bounded expansion depth in an acyclic diamond.
```

Source-response gate:

```text
S_geom(q_N), S_matter(psi, q_N)
J_N = - partial S_matter / partial q_N
L_N = partial^2 S_geom / partial q_N^2
L_N h_N = J_N + xi_N
Cov(xi_N) = K_N
observable noise = G_N K_N G_N^*
```

The paper should not treat `tr(K_N)` as the gravitational answer. The response
propagated by the Green operator is the quantity that must be bounded or
compared with cosmological noise benchmarks.

### 9. Intrinsic order observables and artifact controls

Purpose: prevent coordinate/window artifacts from being mistaken for physics.

Lean spine:

- `NullEdgeP9SelectedSectorTraceDensity`
- `NullEdgeP9BlockAliasingGuardrail`
- `NullEdgeP9OffsetWindowGuardrail`
- `NullEdgeP9BoundaryVolumeScaling`
- `NullEdgeP9DefectSensitivityBenchmark`
- `NullEdgeP9IntrinsicOrderObservables`
- `NullEdgeP9IsohistogramSeparation`
- `NullEdgeP9DiamondLocalSeparation`
- `NullEdgeP9CoarseMapErasureGuardrail`
- `NullEdgeP9DiamondLocalityNoiseInvariance`
- `NullEdgeP9SubdiamondRestrictionPreservesLocalReadout`

Narrative:

- in the six-point T1 witness, a diamond-local interval readout separates
  histories that global histograms miss;
- block/window artifacts must be diagnosed;
- the named critical-collapse coarse map erases that witness signal;
- Alexandrov-local restrictions preserve local interval-abundance readouts
  under the hypotheses of the banked finite theorem;
- unrestricted surjective coarse maps are too broad: a noncritical erasing map
  shows that P9 must specify an admissible coarse-map or observer-channel class.
- exact recovery gives one clean admissible observer-channel class: if a common
  recovery map restores the fine pair, the fine source test has a pulled-back
  coarse observer test.
- the stochastic exact-recovery version upgrades this from abstract tests to
  normalized finite source distributions, column-stochastic observer channels,
  and observable expectations.
- exact stochastic recovery preserves the actual expectation gap of pulled-back
  observables, not merely the existence of a distinguishing test.
- exact stochastic recovery composes, so the sufficient admissible-channel class
  survives layering of observer channels when each layer has common exact
  recovery on the relevant source pair.
- fully erased separated source pairs are not exactly recoverable, so this
  admissible-channel class excludes the known erasing-map pathology by design.
- spectral coarse maps should use whole eigenspace bands rather than individual
  eigenvectors when degeneracies are present.
- any coarse map should be fixed before inspecting flat/de Sitter labels and
  should state normalization, relabeling invariance, perturbation stability, and
  refinement behavior.

This section is the current best finite result from the autonomous run:

> In the implemented six-point witness, local source-visibility signals are
> meaningful only relative to a specified observer channel. The critical
> collapse erases the bucket-level gap, a proper subdiamond still sees a
> separator, and a noncritical erasing map shows that unrestricted coarse maps
> are not an admissible stability class.

### 10. The T1/T2/T3 ladder

Purpose: present the finite coarse-map results as a test hierarchy.

T1: diamond-local separation.

```text
There are finite diamond-local readouts that separate selected visible defects
from matched hidden bookkeeping.
```

T2 negative: coarse-map erasure.

```text
Some coarse maps collapse the interval-rank information needed for the visible
source readout, so the apparent signal disappears.
```

T3: locality/noise invariance.

```text
Local noise perturbations that do not alter the relevant local interval data do
not change the selected local readout.
```

T2 positive: subdiamond restriction.

```text
For Alexandrov-local subdiamonds, restriction preserves the local interval
abundance and local interval signature used by the readout.
```

Suggested theorem packaging:

- make the negative T2 theorem a guardrail, not a failure;
- make the positive T2 theorem the first "good observer channel" certificate;
- state that the next target is not arbitrary coarse-graining, but admissible
  coarse-graining.

### 11. Numerical pilot section

Purpose: propose numerical work without relying on it for proof.

Pilot goals:

- compare flat, defect, and deformed finite diamonds;
- sweep block offsets to detect window artifacts;
- compute intrinsic interval histograms and local interval signatures;
- estimate residual variance under selected projector channels;
- test whether the visible defect survives under subdiamond restriction and
  dies under critical erasure maps.

Deliverable:

```text
figures that show channel-dependent visibility, not proof of cosmology
```

### 12. Literature positioning

Purpose: show that P9 is not rediscovering existing work.

Sources to discuss:

- Sorkin and everpresent Lambda: sign-changing causal-set fluctuations,
  unimodular conjugacy, observational amplitude tension;
- stochastic gravity and noise kernels: zero mean versus residual variance;
- causal-set d'Alembertian and Benincasa-Sorkin-style curvature: finite
  retarded response and nonlocality;
- Sorkin-Johnston entropy/window effects: why window and boundary choices
  matter;
- finite Hodge theory, graph Laplacians, DEC/FEEC: projector and boundary
  decomposition tools;
- causal-set order-invariant observables: interval abundance, local
  subdiamonds, and intrinsic signatures.

Windowing caution:

> A spectral or screen window chosen after seeing the signal is the same
> epistemic failure mode as a block coarse map tuned after seeing the output.
> Any SJ-style area-law or noise-trace claim must use an intrinsic,
> pre-specified window rule and should pass offset/coarse-map robustness tests.

Differentiation:

> P9 adds a Lean-checked finite observer-channel theorem stack for visibility,
> erasure, projection, noise bounds, causal support, and subdiamond locality.

### 13. Missing pieces before a complete treatment

Mathematical gaps:

- consolidate the P9 API so definitions are shared rather than duplicated;
- prove a geometry-dependent finite diamond metric or response kernel;
- characterize admissible coarse maps;
- extend positive T2 from subdiamond restriction to broader coarse channels;
- prove a scaling theorem for residual variance under growing causal diamonds;
- compare the predicted residual amplitude and correlations with the
  everpresent-Lambda `1 / sqrt(V)` benchmark;
- define any spectral/window rule intrinsically, before numerical or theorem
  outcomes are inspected;
- distinguish bulk, boundary, screen, and topological scaling exponents instead
  of calling every sub-volume exponent an area law;
- connect visible Pluecker defects to the response channel in one theorem;
- decide whether harmonic/projected sectors have a physically preferred
  interpretation.

Physics gaps:

- identify the correct observer channel for semiclassical gravity;
- compare residual noise amplitude against cosmological constraints;
- show why hidden bookkeeping is boundary-like or projected away in physically
  relevant states;
- connect the finite source tests to an effective stress tensor or curvature
  response.

### 14. Demotion and failure criteria

P9 should be demoted if:

- every natural observer channel sees hidden bookkeeping as a bulk
  volume-scaling source;
- visible Pluecker-style defects cannot be distinguished from hidden
  bookkeeping by any pre-specified channel;
- residual variance remains too large under all physically plausible response
  laws;
- the response law merely recovers the known everpresent-Lambda scaling without
  a new correlation or suppression handle;
- source visibility depends on arbitrary coordinate windows rather than
  intrinsic causal-order data;
- spectral or screen windows are hand-tuned after seeing the signal;
- the only successful channels are tuned after seeing the defect.

P9 should be promoted if:

- a natural finite response channel projects hidden bookkeeping into a boundary
  or kernel sector;
- visible defects survive local intrinsic readouts;
- residual variance has a robust suppression or scaling law;
- the same channel admits causal support bounds and subdiamond locality;
- simulations show the same separation without tuning.

## Suggested theorem targets for the next Aristotle rounds

Status: proposed target names, not current Lean theorem inventory unless a
module path is named explicitly.

1. `subdiamond_restriction_separates_witness`
   - strengthen the current preservation theorem by adding an explicit visible
     witness that remains separated after restriction.

2. `interval_rank_threshold_dichotomy`
   - prove that one class of coarse maps preserves enough interval-rank data,
     while another class necessarily erases it.

3. `spectral_coarse_map_no_go`
   - test whether a purely low-mode spectral channel can see the same local
     defect, or prove that it loses the local information.

4. `plucker_source_pairs_with_projected_response`
   - connect the visible Pluecker source API to a selected response functional.

5. `retarded_response_respects_projected_kernel`
   - combine causal support with projected invisibility.

6. `weighted_residual_variance_scaling_for_partition`
   - state a finite partition theorem that bounds residual variance by maximum
     cell weight, number of cells, or selected-sector trace density.

7. `predicted_deltaLambda_amplitude_vs_everpresent`
   - compare the finite response law against the existing `1 / sqrt(V)`
     everpresent-Lambda benchmark and record whether the mechanism is genuinely
     different.

8. `sjWindow_rule_is_intrinsic_and_preSpecified`
   - formalize the discipline that any spectral/window channel used for an
     area-law or noise-trace claim is fixed before seeing the data.

9. `closedIntervalOrderComplex_contractible`
   - test whether the naive full closed diamond has any positive-degree
     harmonic sector to carry a Lambda channel.

10. `weightedHodgeProjector_eq_pseudoinverseProjector`
    - package the harmonic projector with the Moore-Penrose inverse in the
      chosen weighted metric.

11. `propagatedNoiseCovariance_eq_GKGadjoint`
    - move from source covariance to response covariance.

## Figure and table ideas

- Table 1: source types versus observer channels.
- Table 2: theorem inventory by section and Lean module.
- Figure 1: hidden exact source projected away, visible defect surviving.
- Figure 2: negative T2 erasure map versus positive T2 subdiamond restriction.
- Figure 3: residual variance before and after selected-sector projection.
- Figure 4: causal support cone for finite retarded response.

## Draft abstract

We develop a finite source-visibility framework for causal diamonds motivated by
the cosmological-constant problem. Rather than assuming that every microscopic
source contribution is directly visible to a gravitational observer, we model an
observer as a finite response channel on source data. In this setting,
boundary-exact and projected-away bookkeeping can be invisible, while explicit
closure or Pluecker-style defects can remain visible under selected local
tests. We prove finite positivity, Cauchy-Schwarz, projector, residual-variance,
causal-support, and coarse-map guardrail theorems in Lean. The main lesson is
not yet a cosmological prediction, but a sharp finite criterion: a proposed
source-visibility mechanism is meaningful only when its observer channel is
pre-specified, causal, intrinsic enough to avoid window artifacts, and stable
under admissible coarse-graining. We identify negative coarse maps that erase
the signal and positive Alexandrov-local restrictions that preserve the local
readout, giving a concrete ladder for future numerical and scaling tests.
