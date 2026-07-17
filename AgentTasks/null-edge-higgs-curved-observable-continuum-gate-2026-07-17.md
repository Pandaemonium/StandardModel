# Null-edge Higgs curved-observable continuum gate

Date: 2026-07-17
Work item: `GRAV-ORDER-OPERATOR-001`
Status: pre-registered reconstruction gate

## Question

What would be required to upgrade the finite statement

> a gauge-invariant radial Higgs response is a weighted sum over causal chains

to a continuum statement about a Higgs excitation in curved spacetime?

The upgrade must not assume that a Higgs quantum follows one null edge, or that
an arbitrary curved spacetime has a preferred particle interpretation.

## Finite input already landed

The present finite model has the following kernel-checked inputs:

- the Higgs multiplet is vertex-local internal zero-form data;
- gauge-covariant differences are evaluated across links;
- a parallel frozen-modulus vacuum has zero link cost but can induce a nonzero
  local Yukawa chirality-flip operator;
- the gauge mass matrix is a positive-semidefinite Gram matrix of vacuum-orbit
  tangents, with zero directions exactly at stabilizers;
- the gauge-invariant radial observable is
  `O(H; H0) = ||H||^2 - ||H0||^2`;
- its exact finite expansion has linear, mixed, and quadratic terms;
- the leading FMS response is a nonzero scalar multiple of the elementary
  radial response when the supplied vacuum is nonzero;
- uniform, measured, and curvature-dependent diagonal insertions give exact
  finite two-sided retarded resolvents on strict orders;
- diagonal local physics changes causal-chain amplitudes but does not create
  support outside the primitive strict-past relation;
- the local nonminimal action response separates volume and curvature channels.

These statements do not yet define a continuum quantum field or particle.

## H1: Retarded operator convergence

Choose a sequence of finite causal structures `C_n` with reconstruction maps
into a globally hyperbolic spacetime region, together with:

- event measures `mu_n`;
- primitive retarded kernels `K_n`;
- curvature estimators `R_n`;
- bare mass and curvature-coupling conventions;
- source and field sampling maps.

For

```text
M_n(x,x) = mu_n(x) * (m0^2 + xi * R_n(x))
G_n = K_n * sum_r (-M_n * K_n)^r,
```

prove convergence against compactly supported test functions to the retarded
fundamental solution of the convention-locked continuum operator

```text
P = Box_g + m0^2 + xi * R.
```

The theorem must state the density/nonlocality scaling, boundary treatment,
probability mode if sprinklings are random, operator normalization, and whether
the convergence is pointwise, in probability, in expectation, or
distributional. Distributional convergence is the preferred primary target.

Kill condition: a stable nonvanishing discrepancy in the test-function pairing
after all pre-registered finite-size, boundary, and normalization controls.

## H2: Gauge-invariant observable convergence

Let

```text
O_n(x) = H_n(x)^dagger H_n(x) - H0_n(x)^dagger H0_n(x).
```

Construct a finite connected two-point functional and prove a controlled split

```text
<O_n O_n>_c = Z_n * G_n + Remainder_n,
```

where `Z_n` is the finite leading radial coefficient and the remainder contains
the mixed and quadratic FMS channels. A continuum Higgs claim requires:

- exact finite gauge invariance;
- convergence of `Z_n` under a declared field normalization;
- a proved bound or convergent description of `Remainder_n`;
- compatibility with the operator limit in H1.

The leading finite scaling alone is not evidence that the full composite and
elementary propagators share a continuum pole.

Kill condition: the remainder develops a lower singularity or spectral feature
that invalidates the proposed leading radial interpretation in the declared
regime.

## H3: Curved-spacetime state and particle gate

On a generic globally hyperbolic curved spacetime, formulate the continuum
claim locally and covariantly through gauge-invariant field algebras and
two-point distributions. Require a Hadamard or corresponding microlocal
spectrum condition before defining renormalized local composite observables or
stress response.

Do not require or claim a global momentum-space pole on a generic background.
Use the word `particle`, a one-particle mass, or an LSZ pole only after adding a
stationary, adiabatic, or asymptotically flat regime that supplies the needed
state and spectral interpretation. In the general curved case, the primary
observable is the local gauge-invariant two-point response, not a trajectory.

Kill condition: the proposed particle claim depends on a preferred vacuum or
time translation that the reconstructed geometry does not supply.

## H4: Gravitational response gate

The local insertion `xi * R` in H1 is not by itself a stress tensor. Vary the
same finite matter action with respect to the reconstructed geometry and retain
both channels

```text
delta (mu * xi * R * ||H||^2)
  = xi * ||H||^2 * (delta mu * R + mu * delta R)
```

with the declared overall action sign. Then prove:

- the graph/coframe realization of `delta R`;
- compatibility with the reconstructed metric convention;
- gauge invariance;
- the discrete conservation identity paired with the geometry equation;
- convergence to the convention-locked improved scalar stress tensor.

Kill condition: the finite curvature response cannot be made compatible with
the connection/Bianchi structure or leaves an order-one conservation defect in
the same scaling regime used for H1.

## Interpretation rule

Until H1-H4 are passed, the defensible ontology is:

- a Higgs configuration is local field data on events;
- its covariant variation is link-supported;
- its retarded response is a sum over causal chains;
- its physical radial channel is gauge-invariant and composite;
- its vacuum can be link-parallel while changing fermion, gauge, and gravity
  operators;
- no literal Higgs path, continuum pole, or 125 GeV prediction has been
  derived.

## Primary provenance

- Nomaan X, Fay Dowker, and Sumati Surya, *Scalar Field Green Functions on
  Causal Sets*, arXiv:1701.07212.
- Dionigi M. T. Benincasa and Fay Dowker, *The Scalar Curvature of a Causal
  Set*, arXiv:1001.2725.
- Axel Maas and Rene Sondenheimer, *Gauge-invariant description of the Higgs
  resonance and its phenomenological implications*, arXiv:2009.06671.
- Stefan Hollands and Robert M. Wald, *Quantum fields in curved spacetime*,
  arXiv:1401.2026.
