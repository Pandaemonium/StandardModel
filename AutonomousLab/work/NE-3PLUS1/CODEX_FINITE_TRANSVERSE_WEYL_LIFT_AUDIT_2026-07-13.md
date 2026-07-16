# Finite transverse Weyl lift: integration audit

## Verdict

The Aristotle return from job `9eb52ec3-fafd-4db5-aa32-fe41c9f9e953` contains
a useful exact finite theorem cluster, but its original domain-wall,
Callan-Harvey, and doubling-escape interpretation outran the displayed
operator.  The live integration retains the algebra and rejects those claims.

## What is proved

- A connected real symmetric three-site nearest-neighbor chain has the exact
  nonzero kernel vector `w = (2, 0, -1)`.
- The kernel is exactly one-dimensional.
- The square certificate is `Mchain^2 = 5 I - w w^T`.
- On vectors orthogonal to `w`, the exact quadratic identity is
  `||Mchain v||^2 = 5 ||v||^2` in the displayed dot-product form.
- For the separable lift
  `Hfull(k) = Mchain tensor I + I tensor (k dot sigma)`, the kernel sector
  intertwines exactly with the continuum Pauli symbol `k dot sigma`.
- The local coefficient Jacobian of that Pauli symbol has determinant `+1`.

## What is not proved

- The tangential symbol is not a local periodic three-dimensional lattice
  operator, so Nielsen-Ninomiya has not been escaped.
- The additive lift lacks the anticommuting gamma coupling of a genuine
  domain-wall Dirac operator.
- The three-site vector is left weighted, but no chain family or asymptotic
  boundary-localization theorem is present.
- No opposite-chirality partner, bulk invariant, anomaly inflow, or
  Callan-Harvey cancellation is identified.
- The transverse complement identity is not a full-operator uniform gap;
  eigenvalues of the commuting summands can cancel.
- No primitive-null, discrete-time, gauge, or thermodynamic theorem follows.

## Role in the 3+1 attack

Treat the module as a composable **transverse kernel selector**.  A genuine
successor must replace `k dot sigma` by a local alias-audited tangential walk
and couple the transverse coordinate through an anticommuting mass/gamma
structure.  This makes the next target precise instead of declaring victory:

1. construct a finite domain-wall Dirac family with exact kernel restriction;
2. prove a transverse gap uniformly over the admitted tangential momenta;
3. locate the compensating chirality in a bulk invariant or second boundary;
4. only then ask for a primitive-null discrete-time realization.

## Live source

`PhysicsSM/Draft/NullEdge/FiniteTransverseWeylLift.lean`

The module compiles under the pinned toolchain and carries local and central
assumption-footprint guards.  The intended cross-family review is semantic:
check especially whether any surviving docstring still implies physical
boundary localization, a full gap, or a doubling escape.
