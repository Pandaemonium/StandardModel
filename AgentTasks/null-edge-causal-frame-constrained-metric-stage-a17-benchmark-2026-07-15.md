# Null-edge frame-constrained metric Stage A17 benchmark

Date: 2026-07-15

## Question

Can the conditioned A16 anchors turn incompatible Johnston lightcone charts
into one shared local coordinate patch, and can interval counts then recover a
common Lorentzian metric and coframe on that patch?

## Construction and scope

`Scripts/experiments/causal_frame_constrained_metric.py` reuses the A16 deep
pivot, 12-event causal cross, three validation pivots, and max-volume
five-anchor selector. The selected anchors fix one affine gauge. Each local
chart is mapped exactly to the first chart on those anchors, and every event
represented in at least two charts receives the arithmetic-mean coordinate,
the least-squares shared-event consensus.

The five boundary anchors fix the gauge but are excluded from metric
regression. Regression uses only the strict common-bracket interior, where the
interval-count asymptotic is intended. Twenty percent of non-anchor causal
intervals with at least two open-interval events are held out. For a symmetric
metric `g`, the remaining interval equations are linear in its ten components:

```text
(z_j - z_i)^T g (z_j - z_i) = tau_count(i,j)^2.
```

The ridge prior is the average of the three Minkowski forms transported into
the anchor gauge. This is intrinsic to the supplied Johnston charts, but it is
still a Lorentzian chart prior. Stage A17 therefore stabilizes and tests a
conditional 3+1 metric model; it does not derive signature or dimension from a
bare order.

The development scan compares ridge coefficients `0`, `0.01`, `0.1`, and
`1.0`. Selection uses no sprinkling coordinate. Its intrinsic metric gate
requires:

- Lorentzian inertia `(1,3,0)`;
- coframe factorization residual at most `1e-10`;
- held-out interval relative RMSE at most `0.20`;
- held-out timelike-sign retention at least `0.95`;
- unrelated-pair timelike violation at most `0.10`;
- whole-carrier causal sensitivity at least `0.80`; and
- causal specificity at least `0.95`.

The intrinsic coordinate gate requires at least 24 previously unused interior
events and both leave-one-chart-out and consensus-dispersion errors at most
`0.85`. Post-selection oracle gates require coordinate error at most `0.75`,
metric error at most `0.75`, and conformal metric error at most `0.60`.

Dimension, density, global endpoints, anchor scale, and the chart-level
Minkowski form remain supplied. The factorization `g = e eta e^T` derives one
local coframe representative after a metric passes. It does not construct a
tetrad bundle, spin structure, connection, or curvature.

## Development

Artifact:
`AgentTasks/causal-frame-constrained-metric-stage-a17-development-n2500-2026-07-15.json`

Five `N=2500` realizations use seed `20260820`.

| ridge | Lorentzian fits | intrinsic metric pass | interval RMSE | noncausal violation |
|---:|---:|---:|---:|---:|
| 0 | 0/5 | 0% | 0.107 | 0.450 |
| 0.01 | 4/5 | 20% | 0.127 | 0.140 |
| 0.1 | 5/5 | 100% | 0.149 | 0.081 |
| 1.0 | 5/5 | 40% | 0.228 | 0.073 |

The frozen selector chooses `0.1`. The unregularized fit has slightly lower
interval error but the wrong inertia in every realization; the strongest
ridge fails the interval and timelike-sensitivity controls. At the selected
setting, median held-out timelike-sign retention is `0.991`, metric condition
is `3.81`, oracle coordinate error is `0.668`, oracle metric error is `0.556`,
and oracle determinant-volume error is `0.302`.

Finite-density chart consistency remains uneven: the intrinsic coordinate gate
passes `3/5`, the oracle coordinate gate `4/5`, the oracle metric gate `3/5`,
and the full local-tetrad gate `2/5`.

## Held-out test

Artifact:
`AgentTasks/causal-frame-constrained-metric-stage-a17-heldout-n4000-2026-07-15.json`

Three fresh `N=4000` realizations use seed `20260825` and ridge `0.1` with all
other settings unchanged. Every intrinsic and oracle gate passes in all three
realizations. Held-out medians are:

- shared carrier events: `106`
- previously unused evaluation events: `94`
- chart leave-one-out error: `0.582`
- chart consensus dispersion: `0.488`
- metric inertia: `(1,3,0)` in `3/3`
- metric condition: `1.73`
- held-out interval relative RMSE: `0.094`
- held-out timelike-sign retention: `1.000`
- unrelated-pair timelike violation: `0.041`
- whole-carrier causal sensitivity and specificity: `0.950`, `0.983`
- oracle coordinate error: `0.237`
- oracle metric error: `0.317`
- oracle conformal metric error: `0.294`
- oracle determinant-volume error: `0.198`

The exact eigendecomposition coframe factorization is at floating-point
roundoff in every sample. The result repairs A16's failed affine reconstruction
control on a substantially larger out-of-sample carrier, and it recovers both
metric shape and absolute determinant scale relative to the known embedding.

## Verdict

**Retain the frame-constrained shared patch and interval metric regression.**
This is the first held-out lane in the sequence where shared coordinates,
Lorentzian metric regression, causal signs, coframe factorization, and oracle
coordinate/metric controls all pass together. It supplies a concrete local
interface for the existing finite metric, coframe, and Levi-Civita algebra.

**Do not call it GR from a bare graph or a derived spin geometry.** The ridge
prior transports an already supplied 3+1 Minkowski form from Johnston charts;
density, endpoints, dimension, and anchor scale are also supplied. A single
patch has no transition cocycle, tetrad bundle, spin lift, connection
convergence, curvature, stress tensor, or dynamics.

The next benchmark should construct several overlapping A17 patches, transport
their fitted metrics and coframes across overlaps, and test metric agreement,
Lorentz transition defects, cocycles, orientation/time-orientation, and the
finite spin-lift obstruction. Connection and curvature scores remain closed
until that bundle-level gate passes.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_frame_constrained_metric.py`
- `python -m ruff check Scripts/experiments/causal_frame_constrained_metric.py Scripts/experiments/test_causal_frame_constrained_metric.py`
- Development and held-out commands, settings, per-sample tensors and gates,
  and frozen selection are retained in the JSON artifacts.

## Provenance

- Steven Johnston, "Embedding Causal Sets into Minkowski Spacetime,"
  Class. Quantum Grav. 39 (2022) 095006, arXiv:2111.09331v2, for the local
  interval-volume charts.
- Nathan Madsen, "On the Uniqueness of Embeddings of Causal Sets,"
  arXiv:2607.05840, for the conditioning and anchor-trilateration target.
