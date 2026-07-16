# Null-edge retarded-moment debiased metric Stage A29 benchmark

Date: 2026-07-15

## Question

Can the stabilized A28 response bias be removed covariantly using a timelike
direction derived from the retarded operator itself, without inserting the
target frame into curved evaluation?

## Construction

For each operator row, positive absolute kernel weights define a probe-space
first moment. The local affine fit supplies its pivot value `m`. Given the raw
inverse metric `G`, define

```text
q = m^T G^-1 m
T = m m^T / q
S = G - T
G_r = r T + S.
```

Under an invertible affine probe change `A`, `G` and `m` transform as
`A G A^T` and `A m`; consequently `q` is invariant and `G_r` transforms as
`A G_r A^T`. The implementation tests this covariance directly.

Six flat realizations at each of `N=4000` and `N=8000` select one positive
weight from `0.30` through `0.70` by signature rate and worst individual
unit-volume shape error. The frozen result is

```text
r = 0.60.
```

Every calibration moment is timelike. Its spatial components are typically
around `1e-3`, while its past-directed temporal component is approximately
`-0.30`. No curved sample enters selection.

## Fresh `N=4000`

Artifact:
`AgentTasks/causal-retarded-moment-debiased-metric-stage-a29-heldout-n4000-2026-07-15.json`

| `H` | signature rate | raw shape error | corrected shape error | median fused metric error | ensemble error | oracle-volume error | count-volume mismatch |
|---:|---:|---:|---:|---:|---:|---:|---:|
| `0.0` | `1.00` | `0.275` | `0.177` | `0.197` | `0.045` | `0.070` | `0.139` |
| `0.1` | `1.00` | `0.379` | `0.156` | `0.155` | `0.061` | `0.091` | `0.164` |
| `0.2` | `1.00` | `0.502` | `0.257` | `0.259` | `0.198` | `0.062` | `0.086` |

## Fresh `N=8000`

Artifact:
`AgentTasks/causal-retarded-moment-debiased-metric-stage-a29-heldout-n8000-2026-07-15.json`

| `H` | signature rate | raw shape error | corrected shape error | median fused metric error | ensemble error | oracle-volume error | count-volume mismatch |
|---:|---:|---:|---:|---:|---:|---:|---:|
| `0.0` | `1.00` | `0.248` | `0.158` | `0.168` | `0.082` | `0.091` | `0.206` |
| `0.1` | `1.00` | `0.311` | `0.128` | `0.129` | `0.048` | `0.044` | `0.092` |
| `0.2` | `1.00` | `0.375` | `0.130` | `0.135` | `0.104` | `0.051` | `0.191` |

All `27` fresh metrics are Lorentzian. Every median full-metric error is below
`0.30`, five of six are below `0.20`, and the strong-curvature error improves
from `0.259` to `0.135` under density refinement.

## Verdict

**Retain the retarded-moment split as the first successful conditional tensor
metric correction.** It is probe-affine covariant, uses no curved target, and
passes the tested signature/tensor gate across both densities.

**Do not claim bare-graph metric reconstruction.** Coordinates, dimension,
density, support, count windows, and the flat-calibrated response weight remain
supplied. The `4-21%` independent volume mismatch is controlled but not yet a
convergence theorem.

**Keep the first-jet and curvature gates closed.** This stage intentionally
corrects only the pivot metric. The next test must differentiate the moment
projector and count-volume fusion rather than attaching the failed A28 jet to
the corrected tensor.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_retarded_moment_debiased_metric.py Scripts/experiments/test_causal_conformal_multirow_metric.py`
- `python -m ruff check Scripts/experiments/causal_retarded_moment_debiased_metric.py Scripts/experiments/test_causal_retarded_moment_debiased_metric.py Scripts/experiments/causal_conformal_multirow_metric.py Scripts/experiments/test_causal_conformal_multirow_metric.py`

## Provenance

- A28 for the stabilized expanded-support operator metric.
- A24-A25 for independent count-volume scale and determinant fusion.
- The temporal/spatial projector split is standard Lorentzian linear algebra;
  the retarded-kernel moment and calibration protocol are program-internal.
