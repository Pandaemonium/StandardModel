# Null-edge Higgs 3+1 retarded-tail benchmark

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Status: pre-registered numerical continuum gate

## Question

Can the link-path scalar response reproduce both parts of the retarded massive
Klein-Gordon kernel in `3+1` Minkowski spacetime:

1. the light-cone distribution inherited from the massless kernel; and
2. the mass-dependent timelike tail inside the cone?

This is the first numerical gate needed before interpreting the finite radial
Higgs series as continuum scalar propagation.

## Locked continuum target

Use mostly-minus signature and the convention

```text
(Box + m^2) G_ret = delta.
```

For a future-directed separation with proper time `tau`, the target is

```text
G_ret(tau) = delta(tau^2)/(2*pi)
  - m * J1(m*tau)/(4*pi*tau) * theta(tau^2).
```

The delta contribution must be tested distributionally. No pointwise error at
the light cone is admissible as the primary metric.

## Locked finite kernel

For each Poisson sprinkling of density `rho` into a fixed physical
four-dimensional Alexandrov region, construct the target-row/source-column
link matrix `L`. Use Johnston's amplitudes without fitting:

```text
a(rho) = sqrt(rho)/(2*pi*sqrt(6))
b(m,rho) = -m^2/rho
Phi = a(rho) * L
G_fin = sum_{k >= 0} b(m,rho)^k * Phi^(k+1).
```

The sum terminates by finite strict-order nilpotence. For distinct endpoints,
the optional identity convention is irrelevant; if diagonal entries are
retained, report them separately as contact terms.

Do not replace `L` by the causal matrix, `exp(L)`, or a fitted weighted kernel
inside this gate. Those are separate preregistered branches.

## Sampling design

- Fix the physical region and endpoint/test-function supports before drawing
  random causal sets.
- Use at least three development densities and two fresh held-out densities.
- Keep physical `m` fixed across the density ladder and require
  `m^2 / sqrt(rho)` to decrease into Johnston's asymptotic regime.
- Use independent deterministic seed blocks for development and held-out runs.
- Record event counts, realized densities, boundary distances, and link counts.
- Exclude no realization after inspecting propagator error. Predeclare only
  objective resource-failure and malformed-sprinkling exclusions.

The exact density ladder, realization count, seed list, smooth test functions,
and computational budget must be frozen in a machine-readable run manifest
before launching the first development realization.

## Observables

Choose smooth compactly supported source and probe functions with four locked
support classes:

1. near-cone future support;
2. shallow timelike interior support;
3. deep timelike interior support; and
4. spacelike or past negative controls.

For every pair, compare the ensemble-averaged finite pairing

```text
sum_x,y mu_rho(x) mu_rho(y) f(x) G_fin(x,y) g(y)
```

with the continuum distributional pairing. Report separately:

- massless near-cone normalization error;
- massive-minus-massless interior-tail error;
- sign agreement of the first Bessel lobe;
- cross-density drift after the locked normalization;
- realization variance and concentration trend; and
- exact finite leakage outside the supplied causal future.

The massive-minus-massless comparison is primary for the tail because it
cancels the common light-cone distribution at fixed test functions.

## Frozen success gate

Pass only if all of the following hold on held-out densities without refitting:

1. the massless distributional error improves from the lowest to the highest
   held-out density;
2. the massive-minus-massless interior-tail error improves on every locked
   interior test pair;
3. the predicted tail sign is correct on every test pair wholly inside the
   first Bessel lobe;
4. the highest-density ensemble error is smaller than its lowest-density value
   by more than the preregistered bootstrap uncertainty;
5. past and spacelike controls are exactly zero up to declared arithmetic
   tolerance; and
6. no fitted density power, mass rescaling, or endpoint renormalization is
   introduced after development freeze.

Absolute numerical ceilings must be set from a pilot that is disjoint from all
development and held-out seeds, then frozen before the result run.

## Kill conditions

Kill this exact Johnston-link branch if any of the following survives the full
frozen density ladder:

- massless normalization converges but the interior massive tail does not;
- the tail has the wrong sign or an order-one stable shape discrepancy;
- realization variance grows quickly enough to prevent concentration of the
  distributional pairing;
- apparent agreement requires replacing `m^2/rho` by a fitted density power;
- boundary corrections dominate and do not decrease under the locked
  protected-support design; or
- a nonzero response appears outside the supplied causal future.

Do not rescue a killed branch by silently changing `L` to the causal matrix or
`exp(L)`. Register the successor as a distinct kernel-selection experiment.

## Higgs interpretation boundary

Passing this gate would validate a free scalar retarded kernel with a supplied
mass. It would not yet prove:

- the gauge-invariant FMS remainder is controlled;
- the Higgs mass is dynamically generated;
- a curved-spacetime Hadamard state exists;
- the full nonabelian doublet propagates by the same kernel;
- the measured `125 GeV` scale follows from graph data; or
- the scalar stress response sources an emergent Einstein equation.

Only after the scalar gate passes should the radial potential curvature and
leading FMS coefficient be composed with it.

## Primary provenance

- Steven Johnston, *Particle propagators on discrete spacetime*,
  arXiv:0806.3083, especially equations (3.25) and (3.44).
- Steven Johnston, *Quantum Fields on Causal Sets*, arXiv:1010.5514.
- Steven Shuman, *Path Sums for Propagators in Causal Sets*,
  arXiv:2307.08864.
