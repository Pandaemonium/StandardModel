# Phenomenology map: from carrier diagnostics to GR observables

Date: 2026-07-16  
Role activation: `role-20260716-061729-b1bc3c49`  
Project: `NE-GRAVITY-SCALE`  
Immediate item: `GRAV-LOCAL-CARRIER-001`

## Executive boundary

The program has no physical gravity prediction yet. It has order-side carrier
diagnostics, conditional continuum identities, and imported GR benchmark
reductions. The observable ladder must therefore begin with a pre-physical
locality falsifier and only later introduce dimensional weak-field,
equivalence-principle, wave, and cosmological tests.

The first legitimate physical target is not a precision cosmological fit. It is
a single-calibration Newton/redshift universality test: calibrate one Newton
coupling from one compact source, then predict other radii, source profiles,
clock sectors, graph densities, and carrier refinements without retuning.

## Input and unit ledger

| Quantity | Status | Units | Fitted or supplied use | Held-out obligation |
|---|---|---|---|---|
| Event count `N` and interval counts | Graph data | dimensionless | Never fit to a target metric | Repeat at new counts and outer volumes |
| Discreteness scale `ell` | Currently supplied from density | length | May set simulation units only | Must eventually be reconstructed or declared fundamental input |
| Operator/nonlocality scale `L` | Currently supplied | length | Development schedule only | Predictions must survive an admissible `ell << L << L_curv` window |
| Adjacent ratio, count bands, bracket excess cap, carrier cap | Algorithmic hyperparameters | dimensionless | Freeze on development data | No retuning after held-out seeds or volume ladder are opened |
| Coordinates and target metric | Oracle control only | length and length-squared | Forbidden for mark/carrier selection | May score a selected carrier after the order-only decision |
| Speed `c` | Physical conversion | length/time | Fix from the matter/null propagation sector or choose relativistic units | Same value must govern gravitational waves and redshift |
| Planck constant `hbar` | Physical conversion | action | Imported until the quantum sector fixes it | Horizon/entropy normalization cannot be claimed before this bridge |
| Newton coupling `G` | Open physical parameter | length-cubed/(mass time-squared) | One weak-field renormalization datum at most | Predict all other source profiles, radii, clock sectors, and densities |
| Cosmological coefficient `Lambda` | Open action coefficient | inverse length-squared | Either predict from graph dynamics or fit once and label it fitted | Predict expansion/growth history and fluctuations without epoch-by-epoch tuning |
| Matter mass/energy `M,E` | Open observable dictionary | mass, energy | Must come from a separately normalized matter state/action | Same normalization must source geometry and inertial response |

In `c=hbar=1` units, `ell` and `L` remain lengths, the causal operator has
inverse-length-squared units, `G` has length-squared units, and `Lambda` has
inverse-length-squared units. Count ratios, overlap Jaccard scores, signature
rates, and normalized residuals are dimensionless.

## Benchmark 0: compact-carrier locality

**Observable.** For randomized common-interior marks, measure the realization-
clustered rank-capable rate, median induced-carrier size, overlap Jaccard score,
nested tight/loose metric disagreement, overlap-pair metric disagreement, and
post-selection coordinate-control error.

**Fitted/supplied inputs.** The A3d density, `ell`, `L`, adjacent schedule,
count bands, excess-score rule, eight-mark sample, tight/loose bracket cap, and
all thresholds are frozen before the output is opened.

**Held out.** Fresh seeds at fixed-density outer-volume multipliers 1, 2, and 4;
coordinates are hidden until order-only mark and bracket selection is complete.

**Units.** All primary scores are dimensionless except carrier cardinality.

**Sensitivity.** This benchmark is maximally sensitive to outer-volume leakage,
endpoint-band tuning, tie truncation, cardinality-driven rank, and unstable
overlaps. It is intentionally insensitive to a later eigensolver because that
stage is not yet authorized.

**Concrete falsifier.** Kill the compact-bracket carrier before spectral work if
the exact finite-order tests fail; fewer than four multiplier-4 realizations meet
the preregistered availability/rank gates; multiplier-2 to multiplier-4 rank
drift exceeds `0.10`; median carrier-size drift exceeds `15%`; overlap coverage,
Jaccard, metric disagreement, coordinate-control error, or Lorentzian-signature
rates fail the frozen A3d thresholds. No post-failure retuning counts as the same
hypothesis.

## Benchmark 1: distributional Lorentz leakage

**Observable.** For boost-related sprinkling ensembles, compare the joint
distribution of intrinsic carrier sizes, normalized operator moments, overlap
statistics, and low-energy dispersion. Define a dimensionless anisotropy score

\[
  A_k = \max_{\hat n,\hat m}
  \frac{|\omega(k\hat n)-\omega(k\hat m)|}{\omega(k)}.
\]

**Fitted/supplied inputs.** Fix one density/refinement schedule and one operator
normalization on unboosted development ensembles. A Lorentz transformation may
generate the control pair before coordinates are discarded but may not alter
the order-side algorithm.

**Held out.** Boost rapidities, momentum directions, carrier refinements,
outer-volume windows, and regular-lattice negative controls.

**Units.** `A_k` and two-sample distribution distances are dimensionless;
`omega` is inverse time and `k` inverse length.

**Sensitivity.** Preferred-frame leakage, finite-window conditioning,
coordinate-tuned decorations, and anisotropic dispersion.

**Concrete falsifier.** The proposed law-level Lorentz recovery fails if the
held-out operator law changes under boosts beyond preregistered sampling error,
or if anisotropy approaches a nonzero continuum plateau. Small finite-sample
anisotropy is not exact invariance; the final claim requires a distributional
theorem.

## Benchmark 2: Newton response and source universality

**Observable.** After a graph action and physical matter source exist, recover a
weak static potential `Phi` and define

\[
  Q_N(r)=\frac{r^2 |\partial_r\Phi(r)|}{G M},
  \qquad
  R_P=\frac{\nabla^2\Phi}{4\pi G\rho}.
\]

In an exterior Newton regime, `Q_N` should approach one; in a resolved source,
`R_P` should approach one where `rho` is nonzero.

**Fitted inputs.** Calibrate `G` once from source A at one development radius
`r0`. Fix the matter energy normalization before this calibration. No separate
normalization is permitted for geometry and inertial mass.

**Held out.** Other radii; source B with the same total mass but a different
profile; at least one different source amplitude; graph density; carrier scale;
orientation; and outer boundary size.

**Units.** `Phi` has units of velocity-squared; both `Q_N` and `R_P` are
dimensionless. In relativistic units, `GM/r` is dimensionless.

**Sensitivity.** Incorrect Einstein-Hilbert normalization, nonuniversal matter
coupling, nonlocal tails, finite-boundary contamination, and source-dependent
renormalization.

**Concrete falsifier.** Kill the GR interpretation if no common held-out plateau
of `Q_N` exists; if its plateau depends on source profile, matter species,
orientation, or graph density; or if one fitted `G` cannot predict the resolved
Poisson response within an error shrinking under refinement. A fitted inverse-
square curve on one source is not a pass.

## Benchmark 3: gravitational redshift and equivalence principle

**Observable.** Use a matter-sector phase or spectral clock at two stationary
locations and test

\[
  Q_z = \frac{\Delta\nu/\nu}{\Delta\Phi/c^2}.
\]

The weak-field target is `Q_z = 1`. Compare passive clock redshift with the
free-fall acceleration inferred from Benchmark 2.

**Fitted inputs.** Reuse `c`, `G`, and the matter normalization from prior
sectors. No clock-specific gravity coefficient.

**Held out.** Potential differences, clock gaps, internal carrier realizations,
matter species, and refinements.

**Units.** Frequency and potential ratios combine to dimensionless `Q_z`.

**Sensitivity.** Composition dependence, mismatch between proper-time and
force coupling, and a graph clock whose ticking was inserted rather than
derived.

**Concrete falsifier.** A nonvanishing species- or gap-dependent limit of
`Q_z-1`, or disagreement between passive redshift and free-fall coupling after
one shared calibration, defeats universal metric coupling.

## Benchmark 4: tensor-wave propagation

**Observable.** Linearize the derived graph dynamics about its flat sector and
measure polarization count, constraint modes, wave speed, damping, and
dispersion,

\[
  \omega^2=c^2k^2\left[1+\alpha(k\ell)^p+\cdots\right].
\]

**Fitted inputs.** Reuse `c`; choose a development momentum window only. The
coefficient `alpha` and power `p` are predictions or exclusions, not tuning
parameters per direction.

**Held out.** Wave vectors, directions, polarizations, amplitudes, graph seeds,
and refinements.

**Units.** `omega` is inverse time, `k` inverse length, and `alpha` dimensionless
for the displayed scaling.

**Sensitivity.** Extra scalar/vector gravitons, preferred-frame dispersion,
instability, and unsuppressed nonlocal tails.

**Concrete falsifier.** No two-polarization transverse low-energy sector,
nonunit wave speed relative to the matter light cone in the continuum limit,
or an instability at arbitrarily small `k` kills the Einstein-gravity limit.

## Benchmark 5: FLRW response and cosmological holdout

**Observable.** Only after a graph-derived homogeneous reduction exists, test

\[
  Q_F(z)=\frac{H(z)^2-\Lambda/3}{8\pi G\rho(z)/3},
  \qquad
  Q_C=\frac{\dot\rho+3H(\rho+p)}{H\rho}.
\]

The targets are `Q_F=1` and `Q_C=0` where denominators are nonzero.

**Fitted inputs.** Reuse weak-field `G`. Either derive `Lambda`, or fit it once
and label it a fitted action coefficient. Select matter equations of state from
the matter dynamics, not independently at every epoch.

**Held out.** Expansion epochs, matter/radiation mixtures, initial conditions,
graph volumes, and perturbation growth. A held-out inhomogeneous mode is required
before a cosmological success claim.

**Units.** `H` is inverse time; `Lambda` inverse length-squared; `Q_F` and `Q_C`
are dimensionless in `c=1` units.

**Sensitivity.** Imported FLRW ansatz, hidden epoch-dependent fitting, failure of
stress-energy conservation, finite-volume count fluctuations, and a cosmological
coefficient unrelated to the local weak-field normalization.

**Concrete falsifier.** The cosmological branch fails if the graph-derived
homogeneous action does not share the weak-field `G`, if the continuity residual
does not vanish under refinement, or if one `Lambda` cannot predict held-out
epochs and perturbations. The current conditional Friedmann identities do not
run this test because the reduced Einstein-Hilbert action and FLRW variables are
supplied.

## Ranked execution order

1. Run Benchmark 0 exactly as preregistered in A3d. This is the current carrier
   gate and can kill the architecture cheaply.
2. If it passes, run Benchmark 1 as a law-level preferred-frame falsifier while
   proving the corresponding distributional covariance theorem.
3. Build one graph-localized matter/action witness and run Benchmark 2 with one
   fitted `G` and two source profiles.
4. Reuse every fitted conversion in Benchmark 3; do not add a clock coupling.
5. Run wave and cosmological tests only after the finite variational law,
   conservation identity, and continuum curvature bridge exist.

## Single decisive physical falsifier

The highest-information physical experiment is the **two-source one-calibration
test**:

1. Construct two compact static matter sources with equal derived total energy
   and different radial profiles.
2. Fit `G` from source A at one radius.
3. Hold out all other radii, source B, graph density, orientation, and carrier
   refinement.
4. Require one shrinking-error Newton plateau for both sources and use the same
   potential to predict a held-out matter-clock redshift.

This one test simultaneously attacks universal coupling, nonlocal tails,
boundary dependence, source normalization, equivalence of inertial and
gravitational response, and proper-time coupling. Failure cannot be repaired by
the already formalized coefficient arithmetic or conditional FLRW identities.
