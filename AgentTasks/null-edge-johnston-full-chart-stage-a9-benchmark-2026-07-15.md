# Stage A9: full-chart two-sided metric averaging

Date: 2026-07-15

## Question

Stage A8 found that sparse common-chart averaging reduced some single-row
noise, but every larger neighborhood in the pivot's strict past developed a
strong finite-window bias.  Stage A9 asks whether a simultaneous embedding of
the full causal interval can supply a genuinely two-sided neighborhood and
separate the operator-concentration problem from the chart-convergence
problem.

The experiment remains within the flat part of

```text
C -> B_C -> Gamma_C -> g_C.
```

No curvature or Einstein-dynamics score is opened.

## Source and implementation

`Scripts/experiments/causal_johnston_full_embedding.py` clean-room implements
equations (2), (4), (6), (8), and (12)-(20) of:

```text
Steven Johnston,
"Simpler Embeddings of Causal Sets into Minkowski Spacetime",
Phys. Rev. D 111 (2025) 106020,
arXiv:2502.09701.
```

Given supplied dimension, density, and interval endpoints, the construction:

1. converts inclusive interval counts into causal-pair proper times;
2. derives a global time coordinate;
3. derives Euclidean spatial distances for causally related pairs;
4. completes spacelike distances by the paper's one-anchor min-plus rule;
5. forms the polarized spatial Gram matrix;
6. keeps the three largest positive MDS modes.

Every event is embedded simultaneously.  Sprinkling coordinates enter only in
external scores.  The implementation tests the inclusive-count formula,
min-plus completion, exact Euclidean MDS recovery, event-relabeling covariance,
and recovered causal order.

The all-pairs interval count uses float32 BLAS.  Counts are sums of zeros and
ones and remain below the checked `2^24` consecutive-integer bound, so the
floating result is exactly integral before conversion back to `int32`.  This
is still an external numerical oracle, not a kernel proof.

## Full-chart validation

Artifacts:

```text
AgentTasks/causal-johnston-full-embedding-stage-a9-development-2026-07-15.json
AgentTasks/causal-johnston-full-embedding-stage-a9-scaling-2026-07-15.json
```

The development artifact contains five realizations at each of
`N=500,1000,1500`.  The two larger points are single-sample scaling audits.

| N | Local affine error | Quadratic error | Causal sensitivity | Specificity | Spatial-distance error |
|---:|---:|---:|---:|---:|---:|
| 500 | 0.60 | 0.69 | 0.78 | 0.95 | 0.41 |
| 1000 | 0.36 | 0.67 | 0.94 | 0.94 | 0.35 |
| 1500 | 0.29 | 0.59 | 0.96 | 0.95 | 0.32 |
| 2500 | 0.24 | 0.47 | 0.97 | 0.98 | 0.26 |
| 4000 | 0.39 | 0.27 | 0.97 | 0.99 | 0.22 |

The `N=4000` inner quadratic error is `0.22` and its correlation is `0.92`.
The chart therefore carries useful order-derived geometry, but local affine
accuracy is not monotone.  The dominant spatial eigenvalue gap selects rank
five in every development realization and both scaling audits, never the
supplied rank three.  Dimension remains a failed gate.

The exact global construction is cubic in event count through all-pairs
interval counting and min-plus completion.  BLAS makes `N=4000` practical,
but direct `N=10000` use remains an inappropriate target without localization
or landmark methods.

## Two-sided metric architecture

`Scripts/experiments/causal_johnston_full_multirow_metric.py` centers the full
chart at the same order-selected pivot used in earlier stages and selects every
event inside a recovered Euclidean ball.  Unlike Stage A8, targets may be in
the pivot's strict past, strict future, or spacelike to it.  Each retarded
operator row acts on one common compact probe chart.

The benchmark scores scale-free conformal shape before either of two intrinsic
trace estimators:

1. average all row pairings, then multiply by
   `8 / mean(B_y q_{J,y})`;
2. positively trace-normalize each row, then average the admissible rows.

The centered identity

```text
B_y q_{J,y} = 2 eta_ab Gamma_y(P^a,P^b)
```

holds with median relative residual below `2e-15`.  Johnston metric scores are
closed during development.

## Development selection

Artifact:

```text
AgentTasks/causal-johnston-full-multirow-stage-a9-development-n2500-2026-07-15.json
```

Five `N=2500` realizations, seed `20260731`, `L=0.18`, probe support `0.65`,
and metric threshold `0.50`.  The radius grid runs from the pivot-only baseline
through `0.175`, just below `L`.

The selected setting is radius `0.15` with trace-after-average.  Median target
counts are:

```text
260 total = 8 strict past + 7 strict future + 246 spacelike + pivot.
```

The median recovered time offset is `-7.0e-5`, so the target set is balanced
instead of drifting toward one interval boundary.

| Coordinate-control score | Pass rate | Median error |
|---|---:|---:|
| Scale-free conformal shape | 60% | 0.389 |
| Trace after averaging | 0% | 0.852 |
| Rowwise positive trace | 0% | 9.960 |

Conformal error improves steadily from `0.91` at the pivot to `0.39` near the
selected radius.  This reverses the Stage A8 one-sided collapse.  Rowwise
normalization is unstable and is killed.

## Frozen held-out result

Artifact:

```text
AgentTasks/causal-johnston-full-multirow-stage-a9-heldout-n4000-2026-07-15.json
```

Three fresh `N=4000` realizations, seed `20260801`, radius `0.15`, and
trace-after-average frozen before opening Johnston metric scores.  The median
neighborhood has 138 rows: 12 strict past, 8 strict future, 117 spacelike, and
the pivot.  Its mean recovered time offset is `5.5e-4`.

### Operator control

| Coordinate-control score | Pass rate | Median error |
|---|---:|---:|
| Scale-free conformal shape | **100%** | **0.234** |
| Johnston-trace normalized | **100%** | **0.398** |

This is the first held-out closure of both flat operator-control gates.  It
shows that the smeared causal operator can recover a concentrated Lorentzian
metric after genuinely two-sided mesoscopic averaging, conditional on the
supplied chart, dimension, density, endpoints, rank, `L`, and support.

### Recovered-chart metric

Two scores must be kept distinct.

The **direct chart-basis** comparison treats the Johnston MDS coordinates as
the candidate Minkowski chart:

| Direct Johnston score | Pass rate | Median error |
|---|---:|---:|
| Scale-free conformal shape | **100%** | **0.245** |
| Johnston-trace normalized | 67% | **0.252** |

All three direct matrices have signature `(+---)`.  These are strong
conditional chart-coordinate results.

The **coordinate-pulled** comparison fits a local Jacobian from recovered to
oracle coordinates and tests tensorial agreement up to that change of probes:

| Pulled Johnston score | Pass rate | Median error |
|---|---:|---:|
| Scale-free conformal shape | 67% | 0.417 |
| Johnston-trace normalized | **0%** | **1.583** |

Median local affine-fit error is `0.541`.  The fitted Jacobian varies strongly
with fitting radius because the full MDS chart contains local nonlinear and
outlier distortion.  Direct chart-basis success therefore cannot be promoted
to covariant metric reconstruction.

The median intrinsic quadratic response is `1.895`, not eight.  Its trace
factor correctly calibrates the coordinate operator control, but it cannot
repair an inaccurate chart transition map.

## Verdict

**Retain the full-chart two-sided neighborhood.**  It removes the one-sided
finite-window failure and closes both held-out coordinate operator controls.
This is a substantial positive bridge: the leading flat-space bottleneck is no
longer operator shape or concentration when a suitable common chart is
supplied.

**Retain the direct chart-basis metric as conditional evidence only.**  It is
Lorentzian in every held-out realization, closes the conformal gate, and has a
low trace-normalized median error.

**Do not claim G2 closure.**  Covariant pullback fails, spatial rank is still
imposed and contradicted by the dominant gap, absolute density and both scales
are supplied, the selected chart radius does not contain a density-stable event
count, and count-volume agreement is untested.

**Kill equal-weight rowwise trace normalization.**  Near-zero positive
responses produce unstable factors and severe errors.

The next estimator should be a local atlas rather than a larger global MDS:

1. construct overlapping high-accuracy Johnston lightcone charts;
2. align their spatial frames on common order-derived carriers;
3. transport row metrics into a pivot chart before averaging;
4. verify cocycle consistency and probe-change covariance;
5. only then compare count and metric volumes.

This directly targets the remaining transition-map debt while preserving the
newly closed operator-control result.

## Verification surface

Implementation and tests:

```text
Scripts/experiments/causal_johnston_full_embedding.py
Scripts/experiments/test_causal_johnston_full_embedding.py
Scripts/experiments/causal_johnston_full_multirow_metric.py
Scripts/experiments/test_causal_johnston_full_multirow_metric.py
```

Tests cover source formulas, exact MDS recovery, min-plus completion,
relabeling covariance, two-sided target selection, trace identity, estimator
selection, and finite end-to-end realizations.  Every JSON artifact retains
per-realization data needed to recompute its summaries.
