# Null-edge conformal multirow metric Stage A23 benchmark

Date: 2026-07-15

## Question

Can a shrinking mesoscopic schedule and local multirow averaging remove Stage
A22's signature variance and absolute normalization bias, while also exposing
the first metric jet needed by the finite Levi-Civita bridge?

## Construction and scope

`Scripts/experiments/causal_conformal_multirow_metric.py` samples the same
physical-volume conformal de Sitter controls as Stage A22. It inserts an
interior calibration pivot at `t=0.7T` and evaluates retarded causal-operator
rows on nearby events. Each row receives its own target-centered compact
coordinate-probe germ. Open-interval counts for every selected row are
computed in one exact float32 BLAS block.

The mesoscopic schedule is

```text
L = cL sqrt(ell T),
S = cS sqrt(L T),
A = cA L,
```

where `ell` is the supplied discreteness scale, `L` the operator nonlocality
scale, `S` the compact support radius, and `A` the row-neighborhood radius.
Consequently `ell/L -> 0`, `L/S -> 0`, and `L,S,A -> 0` under density
refinement. An affine regression of row pairings against four coordinate
offsets estimates the metric intercept and all four first derivatives.

Coordinates still select the pivot neighborhood and probe germs. Dimension,
density, the de Sitter family, and the schedule class remain supplied. This is
not intrinsic reconstruction from a bare graph and computes no connection or
curvature.

## Flat-only development selection

Development scans

```text
cL in {0.45, 0.55, 0.65},
cS in {1.2, 1.4},
cA in {0.7, 0.9}.
```

Only four `N=4000`, `H=0` controls select the setting. The selector first keeps
the maximum signature-success rate, admits settings within `0.05` of the best
ensemble metric error, and then minimizes the flat zero-jet residual. Curved
metric and derivative targets remain unopened. The frozen choice is

```text
cL = 0.65,   cS = 1.4,   cA = 0.9.
```

At development density, the flat median neighborhood contains `93.5` rows.
Every selected-background development ensemble is Lorentzian. Ensemble metric
errors for `H=0`, `0.1`, and `0.2` are `0.420`, `0.397`, and `0.450`; relative
conformal-response errors are `5.1%` and `15.2%`.

The first-jet gate fails already in development. Dimensionless unrestricted
ensemble errors are `1.675`, `1.553`, and `2.020`. Projecting onto the supplied
conformal ansatz reduces some noise but does not recover the temporal slope
reliably.

## Held-out `N=4000`

Artifact:
`AgentTasks/causal-conformal-multirow-metric-stage-a23-heldout-n4000-2026-07-15.json`

Four fresh realizations per background use seed `20260940`. All twelve fitted
metrics have signature `(1,3,0)`. Median row counts are `96`, `90`, and `84`.

| `H` | ensemble metric error | median sample error | median volume error |
|---:|---:|---:|---:|
| `0.0` | `0.497` | `0.519` | `1.345` |
| `0.1` | `0.399` | `0.409` | `1.275` |
| `0.2` | `0.418` | `0.438` | `1.715` |

Relative conformal-response errors improve to `2.5%` and `11.5%`. This is a
real gain over Stage A22's `15%` and `19%` at the same event count.

The unrestricted first-jet errors are `1.762`, `1.061`, and `1.576` at
ensemble level, with median sample errors above `3.4`. Under the supplied
conformal projection, temporal-slope relative errors are still `66%` and
`41%`; spatial-gradient noise remains visible.

## `N=8000` refinement

Artifact:
`AgentTasks/causal-conformal-multirow-metric-stage-a23-refinement-n8000-2026-07-15.json`

Three fresh realizations per background use seed `20260950`. The schedule
shrinks the flat scales from approximately `(L,S,A)=(0.179,0.592,0.161)` to
`(0.164,0.567,0.148)`, while the median flat row count grows from the capped
`96` to `137`. All nine metrics are Lorentzian.

Relative conformal-response errors improve further to `0.4%` and `6.9%`.
Absolute ensemble metric errors remain `0.504`, `0.507`, and `0.434`, while
median volume errors remain `0.978`, `1.017`, and `1.201`.

The derivative does not refine: unrestricted ensemble first-jet errors are
`1.201`, `2.386`, and `2.313`. Projected temporal errors are `170%` and `81%`.
The non-monotone slope behavior rules out interpreting the lower `N=4000`
projected errors as convergence.

## Verdict

**Retain shrinking-scale target-centered multirow averaging.** It removes the
observed signature failures, substantially improves relative conformal
response, and satisfies the correct asymptotic scale inequalities by
construction.

**Fail absolute metric-volume reconstruction.** The common conformal response
is accurate only after normalization to the flat estimate. Determinant volume
remains wrong by order one and does not approach zero error at the tested
density refinement.

**Fail the unrestricted first-jet gate.** Affine row regression produces a
well-defined tensor-valued estimate, but its slopes are noise- and
support-dominated and do not converge on fresh higher-density controls. The
finite `CausalMetricFirstJet` and `CausalLeviCivita` theorems therefore remain
uninstantiated analytic interfaces.

The next stage should reconstruct the local Weyl factor independently from
count volume, then combine that scale with the better-concentrated operator
conformal shape. Metric-volume agreement must be checked before retrying the
first jet. This follows the Malament split: order supplies conformal geometry;
counting owes the scale.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_conformal_multirow_metric.py`
- `python -m ruff check Scripts/experiments/causal_conformal_multirow_metric.py Scripts/experiments/test_causal_conformal_multirow_metric.py`
- Development, held-out, and refinement artifacts retain every row count,
  schedule scale, fitted metric and jet, covariance residual, seed, and sample.

## Provenance

- Benincasa and Dowker, arXiv:1001.2725.
- Belenchia, Benincasa, and Dowker, arXiv:1510.04656.
- The supplied Pro analysis identified metric reconstruction, count-volume
  agreement, and finite coordinate derivatives as the immediate bridges.
