# Null-edge Stage A43 low-epsilon marked-row concentration preregistration

**Status:** invalidated after development; held-out seed never opened

## Protocol integrity record

A41e target generation passed after this protocol was frozen. The protocol
failed to require that every finite target itself have Lorentzian signature.
The development output exposed that omission: both `L/R=0.30` targets and the
robustness `L/R=0.25` target have signature `(0,4,0)` and
`Delta_ps=1`. Concentration onto those targets would not advance Lorentz
recovery. A43 was therefore stopped before the held-out seed `20261490` was
opened. No threshold or stratum was changed.

## Question

At fixed finite `L/R`, does the one-row project-sign causal operator
concentrate around its Poisson-mean quadratic responses once the effective
kernel count is increased to the regime predicted by the exact diagonal
second-moment audit?

This is a pointwise flat-oracle concentration test. It does not select an
intrinsic function algebra, average pivots inside one graph, take `L/R -> 0`,
or open curvature.

## Frozen settings

Use the same marked diamond, strict interval counts, count-depth taper, six
oracle polynomial fields, and coefficient convention as A42. Every realization
is reused across the four strata.

```text
development seed:       20261480
development N:          10000, 20000
development replicates: 8 per N

held-out seed:           20261490
held-out N:              10000, 20000
held-out replicates:     32 per N

cutoffs: primary (0.02,0.08), robustness (0.04,0.12)
L/R:     0.30, 0.25
```

At `N=20000`, the exact scale parameters are approximately

```text
L/R=0.30: ell/L=0.337, epsilon=0.0129, effective count=77.3
L/R=0.25: ell/L=0.405, epsilon=0.0268, effective count=37.3
```

Targets are the order-`240` A41e finite Poisson means at the same cutoff and
scale. The `B1` potential/boundary channel is reported but not included in the
metric-concentration gate; the corrected product pairing cancels scalar
multiplication potentials exactly. No target value changes a sample, row,
cutoff, or scale.

## Reported observables

For every sample and ensemble report:

- all six raw operator responses and standard deviations;
- quadratic response error on `B(t^2),B(x1^2)`;
- induced diagonal metric error and signature;
- principal-symbol mismatch and finite-target difference;
- lower-order response error on `t,t^3,t*x1^2`;
- `B1` separately;
- empirical/diagonal-predicted standard-deviation ratios for the two quadratic
  channels.

## Held-out pass gate

Every one of the four strata must satisfy at `N=20000`:

1. exact coefficient, endpoint-cutoff, and scale-admissibility controls;
2. ensemble quadratic-response error below `0.15`;
3. ensemble induced-metric error below `0.15`;
4. principal-symbol mismatch difference from the finite target below `0.08`;
5. lower-order three-field response error below `0.30`;
6. quadratic and metric ensemble errors each improve by at least `15%` from
   `N=10000`;
7. at least `24/32` individual rows match the finite-target Lorentzian
   signature;
8. empirical standard deviations of `B(t^2)` and `B(x1^2)` are each at most
   three times the exact diagonal prediction.

Development results may expose implementation errors but may not alter these
settings or thresholds.

## Branching rule

- If all strata pass, retain pointwise finite-scale concentration and move to
  a preregistered joint schedule with decreasing `L/R` and
  `ell^2/L^4 -> 0` before local-algebra selection.
- If ensemble means pass but individual signature fails, kill pointwise
  reconstruction at this schedule and test a same-graph mesoscopic average
  with overlap covariance reported.
- If only `0.30` passes, retain it as a finite concentration witness but kill
  scale robustness; do not infer a continuum limit.
- If quadratic means fail, audit off-diagonal covariance and random taper
  before changing scales again.
- If the empirical/diagonal ratio exceeds three, the diagonal model is not a
  sufficient schedule predictor and a covariance bound is mandatory.

No Lorentz-recovery theorem, graph-to-manifold theorem, curvature result, or
continuum-GR claim follows from A43 alone.
