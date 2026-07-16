# Stage A10: overlapping lightcone atlas transition gate

Date: 2026-07-15

## Question

Stage A9 closed the held-out flat operator controls under two-sided averaging,
but its cubic full-interval MDS chart failed the local coordinate-pullback test.
Stage A10 asks whether many higher-accuracy Johnston lightcone charts can form a
consistent local atlas whose row metrics can be transported into one pivot
frame.

The atlas transition gate is a prerequisite.  Johnston metric scores remain
closed unless that gate passes.

## Architecture

`Scripts/experiments/causal_johnston_local_atlas_metric.py` uses the Stage A9
full chart only to select a two-sided target set.  For each selected target it:

1. constructs a fresh Johnston lightcone chart from cached endpoint-volume
   time and radius data;
2. evaluates the retarded operator row on compact probes in that local chart;
3. identifies events embedded by both the target and pivot charts;
4. centers their spatial coordinates and fits an `O(3)` Procrustes transition;
5. transports the target pairing into the pivot frame;
6. tests transition residuals and all available triangle cocycles.

The fit is order-derived and event-relabeling covariant.  Known sprinkling
coordinates enter only the closed coordinate-control scores.  A target whose
past or future is too small for rank three is retained in the denominator of
the chart-availability fraction instead of silently disappearing.

The finite centered trace identity is checked in every local chart.  Median
relative residuals remain below `5e-16` in development.

## Frozen gates

```text
dimension: 4, supplied
density and endpoints: supplied
spatial rank: 3, supplied
nonlocality scale L: 0.18
probe support: 0.65
registration radius: 0.30 in development
maximum median registration residual: 0.25
maximum median cocycle residual: 0.25
metric-error threshold: 0.50
```

An atlas sample passes only if every selected chart and transition exists and
both median transition and cocycle residuals are below their thresholds.  The
pivot-only radius is a diagnostic baseline and is excluded from selection
whenever any nontrivial target set exists.

## Development

Artifact:

```text
AgentTasks/causal-johnston-local-atlas-stage-a10-development-n2500-2026-07-15.json
```

Five `N=2500` realizations, seed `20260802`.  Johnston metric scores are closed.

| Radius | Median rows | Chart availability | Median transition residual | Median cocycle residual | Atlas passes | Coordinate conformal passes | Coordinate trace passes |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 0.040 | 2 | 100% | 0.415 | 0.044 | 40% | 0% | 0% |
| 0.050 | 7 | 100% | 0.445 | 0.162 | 20% | 0% | 0% |
| 0.060 | 11 | 100% | 0.530 | 0.255 | 0% | 40% | 20% |
| 0.075 | 24 | 100% | 0.530 | 0.274 | 0% | 80% | 80% |

The formal selector chooses radius `0.040` because atlas validity precedes
metric quality, but even that radius has only 40% atlas passes and no metric
passes.  The larger radius is nevertheless informative: local-row averaging
has median coordinate conformal error `0.299` and intrinsic-trace error `0.349`,
while the transition prerequisite fails.

This is the opposite of a license to ignore the atlas gate.  It shows that the
local operator metrics are useful before their coordinate transformations are
coherent enough to combine geometrically.

## Registration-scale audit

On one frozen development realization at radius `0.075`, registration radii
from `0.12` through `1.0` leave the median orthogonal transition residual near
`0.52`.  The best median cocycle residual is about `0.15`.  The failure is not
removed by changing the overlap radius.

Two post-development diagnostics were evaluated without opening Johnston
metric scores:

* unconstrained `GL(3)` least squares lowers median transition residual only to
  `0.447`, raises median cocycle residual to `0.385`, and produces a maximum
  transition condition number near `58`;
* rotation plus one spatial scale gives residual `0.507` and cocycle residual
  `0.264`.

The mismatch is therefore not explained by choosing `O(3)` instead of a simple
linear or similarity gauge.  It contains substantial nonlinear chart noise.

## Independent density transition test

Artifact:

```text
AgentTasks/causal-johnston-local-atlas-stage-a10-transition-heldout-n4000-2026-07-15.json
```

Three fresh `N=4000` realizations, seed `20260803`, radius `0.075`, and
registration radius `0.15`.  Johnston metric scores remain closed.

| Transition/control score | Result |
|---|---:|
| Median rows | 8 |
| Median chart availability | 100% |
| Median overlap count | 374 |
| Median transition residual | 0.274 |
| Median cocycle residual | 0.052 |
| Atlas pass rate | **0%** |
| Coordinate conformal pass rate | 100% |
| Coordinate conformal median error | 0.405 |
| Coordinate trace pass rate | 67% |
| Coordinate trace median error | 0.454 |

The three samples fail for different explicit reasons: one median transition
residual is about `0.34`, one chart-availability fraction is `0.875`, and the
third transition residual is about `0.274`.  Transition and cocycle errors do
improve with density, but the frozen prerequisite does not close.

## Verdict

**Retain local lightcone row metrics and explicit atlas diagnostics.**  Their
coordinate controls improve with averaging, and the median cocycle residual
falls sharply at higher density.

**Do not open or claim a Johnston atlas metric.**  The pre-registered
transition prerequisite has zero passes at `N=4000`, so the final metric score
was correctly kept closed.

**Kill independent pairwise Procrustes registration at the current finite
density and thresholds.**  This is a scoped protocol kill, not a no-go for an
asymptotic local atlas.

The next credible registration mechanism is a joint synchronization problem:

1. fit all overlapping chart rotations simultaneously rather than pairwise;
2. weight overlaps by order-derived support and rank diagnostics;
3. minimize one global consistency functional with explicit gauge freedom;
4. test transition cocycles on held-out overlaps;
5. only then transport and open local Johnston metrics.

This follows the simultaneous-registration direction already suggested in
Johnston's 2022 lightcone-embedding paper and directly targets the observed
pairwise inconsistency.

## Verification surface

```text
Scripts/experiments/causal_johnston_local_atlas_metric.py
Scripts/experiments/test_causal_johnston_local_atlas_metric.py
```

Tests cover exact spatial-gauge recovery, metric transport, cocycle
composition, nontrivial-radius selection, and a finite closed-score
realization.  JSON artifacts retain all per-realization summaries.
