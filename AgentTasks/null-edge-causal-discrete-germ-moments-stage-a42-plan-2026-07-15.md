# Null-edge Stage A42 discrete marked-germ moment preregistration

**Status:** completed; held-out gate failed without changing settings or thresholds

**Pre-data target correction (2026-07-15):** The frozen A42 strata include
`L/R=0.20`, but the passing A41c artifact contains only `0.16` and smaller
ratios. Before any A42 development or held-out run, A41d was preregistered as a
deterministic target extension at exactly `0.20,0.16`. A41d certifies the live
coefficient convention and split-quadrature convergence only; it does not
replace the A41c asymptotic physics gate. No A42 setting or threshold changed.

## Question

At fixed finite `L/R`, does the one-row smeared causal-set operator on random
flat sprinklings concentrate around the A41 Poisson-mean moments when the
same marked-diamond count-depth cutoff is used?

This is an oracle polynomial control. Coordinates define the flat order and
the polynomial fields, but not the operator coefficients, interval counts,
cutoff depth, scale, or target moments. Intrinsic generator selection and weak
Ricci remain closed.

## Geometry and count cutoff

Use a four-dimensional Minkowski Alexandrov interval with

```text
p=(0,0,0,0), q=(2,0,0,0), x=(1,0,0,0), R=1.
```

Append `p`, `x`, and `q` as deterministic marked events to `N` random interior
events. Compute `ell=(Vol(I(p,q))/N)^(1/4)` from the supplied count-density
calibration.

For every predecessor `y` of `x`, compute from the order alone

```text
depth_count(y) = min(openCount(p,y)+1, openCount(y,q)+1),
nu_center = (pi/24) R^4 / ell^4 = N/16,
d_count(y) = depth_count(y)/nu_center.
```

Apply the frozen A41c smooth profiles to `d_count`. The marked endpoints are
localization indices, not a preferred frame inferred from one event.

## Frozen settings

Development:

```text
seed:         20261460
N:            5000, 10000
realizations: 2 per N
```

Held out:

```text
seed:         20261470
N:            5000, 10000, 20000
realizations: 4 per N
```

Every realization is reused across all four fixed strata:

```text
cutoff: primary (0.02,0.08), robustness (0.04,0.12)
L/R:    0.20, 0.16
```

No stratum is selected, discarded, or reweighted. Require `ell<L`; a sample
that violates it fails scale admissibility.

## Exact finite responses

Use the live project-sign row and the six A41c fields:

```text
cutoff * {1, t, t^2, x1^2, t^3, t x1^2}.
```

The discrete row is evaluated at `x`. For each `(cutoff,L/R)`, the target is
the order-`240` A41d continuum target at the same finite setting, not the
asymptotic d'Alembertian value.

Report direct field responses, induced metric diagonal and signature,
`Delta_ps`, individual normalized target errors, ensemble-mean target errors,
and standard deviations. Relabeling covariance is a structural unit test.

## Pass gate

All four held-out strata must satisfy:

1. exact live coefficient convention error below `1e-12`;
2. every realization is scale-admissible and the marked cutoff equals one at
   `x` and zero at `p,q`;
3. the `N=20000` ensemble-mean six-field relative error is below `0.20`, using
   denominator `max(1,|target|)` per field;
4. the `N=20000` ensemble-mean induced-metric relative error against the
   finite-scale continuum metric is below `0.15`;
5. ensemble-mean field error and metric error improve by at least `20%` from
   `N=5000` to `N=20000`;
6. the difference between discrete ensemble-mean and continuum `Delta_ps` is
   below `0.08` at `N=20000`;
7. at least `3/4` high-density realizations match the continuum metric
   signature;
8. no target value, coordinate component, or metric error changes a cutoff,
   row, scale, or sample.

Development results may find implementation errors but may not alter these
thresholds or settings.

## Branching rule

- If A42 passes, the finite-scale continuum and discrete rows are connected;
  preregister A43 with the same marked germ and an order-derived generator
  subspace before weak geometry.
- If ensemble means converge but individual variance remains large, retain
  the mean operator result and derive a stronger averaging/concentration
  schedule; do not claim pointwise geometry.
- If ensemble means do not approach the A41d finite targets, kill the tested discrete
  implementation/schedule and audit interval counts, endpoint conditioning,
  and `ell/L` separation.
- If only one cutoff passes, kill boundary stability for this germ family.

No curved sample, tetrad, curvature, or continuum-GR claim is opened in A42.
