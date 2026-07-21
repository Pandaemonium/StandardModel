# Null-edge reconstruction priorities

**Status:** research agenda, 2026-07-19. The items below are targets, not
established physical claims. Each target must return a theorem, a scoped
counterexample, or a sharpened missing hypothesis.

This agenda distills two independent ontology assessments supplied on
2026-07-19 and reconciles them with the current Lean result ledger and GR
foundations spine.

## Work opened on 2026-07-19

The first implementation wave attacks the three highest-dependency gates:

- **Order/count -> reconstructed null support:**
  `ReconstructedNullSupportConcentration.lean` proves the exact deterministic
  bridge needed to compose a primitive shell-concentration estimate with a
  uniformly convergent reconstructed metric. Weight outside the reconstructed
  epsilon-cone is bounded by weight outside the primitive
  `(epsilon - delta)`-shell. The probabilistic concentration and metric-error
  estimates remain open, but their composition is no longer informal.
  Aristotle project `695bcfb3-f956-4c37-8894-2713905d91d8` is separately
  attacking an exact Lagrange-polynomial rank-four projector from four isolated
  eigenvalues, turning the abstract selected-sector API into a constructive
  spectral selector while leaving gap and refinement stability explicit.
- **Relaxed `3+1` local dynamics:**
  `StayLaurentUnitarityClassification.lean` proves that exact unitarity of a
  range-one forward/stay/backward symbol is equivalent to ten finite
  coefficient identities. With no stay term, forward and backward ranges are
  forced to be orthogonal in both multiplication orders. This gives the HNU
  and decoded-stay searches an exact design certificate instead of a verbal
  relaxation.
- **Common-data realizability:** Aristotle project
  `bdfa33fa-1eb5-4697-9858-7e1c1776a09f` is attacking the image theorem for
  `M -> (M M^H, det M)`: determinant phase should be freely realizable at fixed
  momentum exactly when its squared magnitude matches `det(M M^H)`, with the
  phase-fixed residual fiber equal to `SU(2)`. This is the first direct test of
  which conventional data are restricted by one common null factor.

These are finite reconstruction lemmas, not a completed continuum theory.
They turn three broad directions into explicit interfaces that later
probabilistic, spectral, and gauge-curvature theorems can consume.

## Preferred primitive package

The strongest noncircular ontology begins with:

```text
events
+ causal order or extremal causal adjacency
+ count/measure
+ local finite quantum state algebra
+ causal amplitude or wave operator.
```

Dimension, metric, nullness, coframes, spin structure, connection, curvature,
massive propagation, particles, and continuum fields should be downstream.

In particular, distinguish:

- **premetric causal support:** the primitive order or retarded adjacency;
- **reconstructed nullness:** concentration of that support on the null cone
  of the metric reconstructed from the same causal data.

This avoids using a prior metric to define the primitive that is supposed to
generate the metric.

It also replaces the slogan “everything is an edge” with a more defensible
residence/transport principle: local degrees of freedom may reside at events,
but changes, correlations, and influence between events require causal
support. A scalar vacuum value need not travel like a fermionic channel; its
excitations and covariant differences still propagate through the same causal
substrate.

## Priority 1: order and count to an intrinsic Lorentzian metric

This is the upstream gate for the entire ontology.

Construct, on a refinement family of Lorentz-invariant random causal orders:

1. compact mesoscopic causal germs;
2. an intrinsic, basis-free probe algebra or selected probe subspace;
3. a normalized causal operator;
4. its potential-canceling corrected pairing;
5. a stable rank-four image with inertia `(1,3)`;
6. overlap transitions converging to a proper-orthochronous Lorentz cocycle;
7. determinant volume agreeing with count-derived volume;
8. concentration of primitive propagation near the reconstructed null cone.

Required scale regime:

```text
microscopic scale << probe scale << curvature scale.
```

Near-term target: show that the corrected self-adjoint weighted-difference
operator has a stable four-mode sector, quantitative gap, natural overlap
transport, and refinement persistence beyond the existing five-event witness.

**Kill condition:** no intrinsic selector can maintain rank four, Lorentzian
inertia, overlap coherence, and concentration without embedding data.

## Priority 2: reconstruct the minimal `3+1` matter dynamics

Develop an axiomatic reconstruction rather than another isolated walk:

```text
locality + unitarity + homogeneity + isotropy + minimality
-> Weyl propagation
+ parity partner
+ unique equivariant Plucker coupling
-> massive Dirac dynamics.
```

The theorem must include:

- a classification of the minimal range-one/two-channel walks under explicit
  symmetry assumptions, with counterexamples showing why each assumption is
  needed;
- an exact finite-depth local real-space rule;
- a complete zero- and pi-quasienergy census over the full Brillouin zone;
- a physical interpretation of every extra sector;
- a fixed-spacing low-energy Dirac theorem;
- anomaly and positivity obligations appropriate to the claimed sector.

Stay amplitudes, larger cells, auxiliary direction registers, multiple
substeps, body-centered-cubic/HNU geometries, and decoded physical subspaces
are all admissible. Literal movement of every internal component at every
substep is not a foundational requirement.

**Kill condition:** every architecture satisfying the stated physical gates
retains an unphysical partner or sacrifices locality, unitarity, positivity,
isotropy, or the Dirac tangent.

## Priority 3: classify what the common null data can realize

Prove a realizability theorem for the map

```text
(primitive spinor/frame data)
-> (momentum, complex mass, links, holonomy, defects, interactions).
```

Characterize the image and its fibers. Determine:

- which factorization changes are gauge redundancy;
- which change observable orientation or phase data;
- whether momentum, mass, connection, and interaction can vary independently;
- what compatibility, differential, or topological identities they obey;
- whether non-Abelian connection groups arise naturally for larger frames.

The gauge successor must distinguish an integrable phase texture from genuine
nonintegrable transport. It should derive exact local covariance, Wilson-loop
invariance, plaquette curvature, a conserved current, and a minimally coupled
continuum limit, while stating exactly which connections can arise from the
primitive frame data alone.

This is the central test separating a new physical restriction from a useful
reparametrization of independently supplied fields.

**Kill condition:** every arbitrary tuple of conventional fields is realizable
with no additional identity or restricted observable.

## Priority 4: proper time, internal clocks, and massive causal histories

Extend the finite null-count identity into an end-to-end emergence theorem.

1. Prove blockwise transported aggregate proper time converges to
   `integral sqrt(g(dx,dx))` in curved backgrounds.
2. Derive the narrow-packet internal phase rate and recover relativistic time
   dilation without identifying proper time with raw corner count.
3. Show that a null-supported massless kernel plus local mass insertions
   converges to the massive Dirac propagator.
4. Establish the scalar analogue for the massive Klein-Gordon retarded
   propagator, including its timelike interior tail.

**Kill condition:** the same causal substrate cannot recover both the light
cone and the known timelike massive propagator with controlled errors.

## Priority 5: fixed-spacing universality and renormalization

A fundamental finite ontology must work at a fixed microscopic scale, not only
as the regulator spacing tends to zero.

- derive the effective Hamiltonian from the exact walk logarithm on a stated
  low-energy band;
- calculate the leading finite-scale Lorentz-violating or dispersive
  operators and their symmetry classes;
- identify observational bounds or discrimination scales;
- enlarge the coupling family until it closes under spatial blocking;
- classify fixed points and relevant directions;
- prove that a neighborhood of microscopic rules flows to the same infrared
  Dirac/null-edge universality class.

**Kill condition:** relativistic behavior occurs only at a finely tuned rule
or disappears under admissible coarse-graining.

## Priority 6: close the metric-connection-holonomy triangle

On one refinement family, prove agreement among:

```text
causal-operator curvature
~ reconstructed connection curvature
~ area-normalized loop holonomy curvature.
```

Then prove a finite-to-continuum Lichnerowicz theorem in which the same scalar
curvature appears in

```text
D^2 -> nabla* nabla + R/4 + Phi^2 + ... .
```

The coefficient, locality, continuum mode census, and conventions must all be
explicit.

**Kill condition:** the three curvature estimators converge to inequivalent
objects or require incompatible reconstructed metrics.

## Priority 7: derive a universal stress tensor and equivalence principle

Using the reconstructed metric rather than a supplied coframe, derive a local
matter source from arbitrary admissible variations:

```text
T_mn = (2 / sqrt(|g|)) delta S_m / delta g^mn,
div T = 0.
```

Start with a scalar/Higgs sector, then repeat for fermions and gauge fields.
Show that all sectors couple to the same metric and one universal
gravitational coupling.

**Kill condition:** different matter sectors require inequivalent metric
estimators or independent gravitational couplings.

## Priority 8: one controlled interacting continuum QFT

Complete the many-fermion lift and local interaction in `1+1` dimensions
before attempting a complete interacting `3+1` theory.

Preferred benchmark:

- a local, unitary Fock-space update;
- exact number/parity and causal-support controls;
- a continuum limit to the massive Thirring or Schwinger model;
- one calculated scattering phase, bound-state energy, or current
  correlation matching the continuum theory.

This would establish that the ontology supports interacting field theory, not
only one-particle kinematics and finite pair kicks.

## Priority 9: identify the universal scale or clock-density sector

The scale-selection no-go should become a positive reconstruction theorem.
Investigate whether one order-native density or clock variable jointly fixes:

- conformal metric scale and volume;
- microscopic edge normalization;
- proper-time normalization;
- the dimensions of `|z|` and other matter couplings.

Count-derived and coframe-Gram scales must agree asymptotically or one must be
demoted; they cannot remain independent physical rulers.

**Kill condition:** the proposed universal density merely hides unrelated
dimensionful inputs without imposing cross-sector relations.

## Priority 10: derive the gravitational effective action

Only after Priorities 1, 6, and 7 should the program claim gravitational
dynamics. The target is a graph-derived nonflat refinement family whose coarse
effective action has the form

```text
integral sqrt(|g|) [(R - 2 Lambda)/(16 pi G) + a R^2 + b Ric^2 + ...]
+ matter,
```

with finite, nonzero, universal renormalized coupling and controlled stochastic,
boundary, nonlocal, and ultraviolet corrections.

The strongest intermediate demonstration would reconstruct the metric,
connection, common curvature, and matter source on one jointly stationary
nonflat family and recover the weak-field Poisson limit.

## Manuscript and communication consequences

Public presentation should lead with:

> **How can a world with only elementary causal propagation contain rest?**

Use “quantum causal adjacency” or “extremal causal support” for the primitive.
Reserve “null” for the finite supplied models or for the continuum property to
be reconstructed. Avoid a universal shortest coordinate-time tick and avoid
hidden classical trajectories.

Every major paper should contain:

1. an assumption budget: primitive, derived, represented, conventional, open;
2. a primitive-to-emergent dependency diagram;
3. a theorem/status map with finite, conditional, numerical, open, and killed
   arrows;
4. a fixed-spacing section distinct from refinement convergence;
5. explicit counterexamples showing why each classification assumption is
   needed;
6. one observable or cross-sector restriction that cannot be reproduced by
   simply renaming an assigned mass field.

## Work to deprioritize until metric reconstruction advances

- more GR-shaped identities on supplied coframes without intrinsic selection;
- cosmological-constant estimates without a derived scale and effective
  action;
- new particle/generation identifications unsupported by charge, anomaly,
  interaction, and full-spectrum results;
- further finite interaction fixtures without a locality or continuum bridge;
- atlas fitting that does not contribute to a convergence theorem.

These remain useful controls, but they do not discharge the upstream
reconstruction gate.
