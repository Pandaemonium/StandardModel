# Null-edge retarded-moment metric first-jet Stage A30 benchmark

Date: 2026-07-15

## Question

Does exact differentiation of the successful A29 temporal projector, followed
by determinant normalization and independent count-scale differentiation,
produce a stable curved inverse-metric first jet?

## Construction

The local affine operator fit now returns both the retarded moment `m` and its
first jet. A30 differentiates

```text
q = m^T G^-1 m
T = m m^T / q
G_r = G + (r - 1) T
```

using

```text
d(G^-1) = -G^-1 (dG) G^-1
dq = (dm)^T G^-1 m + m^T G^-1 dm + m^T d(G^-1) m
dT = (dm m^T + m dm^T)/q - (m m^T) dq/q^2.
```

It then applies the exact A25 derivative of determinant normalization and the
A24 count-factor gradient. Finite differences and arbitrary affine probe
changes test the formula independently. The A29 flat calibration remains
frozen at `r=0.60`; curved jets do not enter selection.

## Results

Artifacts:

- `AgentTasks/causal-retarded-moment-metric-first-jet-stage-a30-heldout-n4000-2026-07-15.json`
- `AgentTasks/causal-retarded-moment-metric-first-jet-stage-a30-heldout-n8000-2026-07-15.json`

| `N` | `H` | median metric error | raw operator jet error | corrected operator jet error | fused jet error | ensemble fused jet error |
|---:|---:|---:|---:|---:|---:|---:|
| `4000` | `0.0` | `0.159` | `3.25` | `2.84` | `5.53` | `2.13` |
| `4000` | `0.1` | `0.144` | `4.60` | `3.79` | `6.64` | `3.24` |
| `4000` | `0.2` | `0.234` | `4.20` | `3.29` | `5.64` | `2.81` |
| `8000` | `0.0` | `0.200` | `3.94` | `2.97` | `5.26` | `2.00` |
| `8000` | `0.1` | `0.122` | `3.37` | `2.77` | `4.63` | `2.82` |
| `8000` | `0.2` | `0.144` | `4.04` | `2.93` | `4.03` | `2.77` |

Every metric remains Lorentzian and the A29 tensor scores are reproduced. The
projector derivative consistently improves the operator-only jet. Full fusion
is worse because the independently fitted count-factor gradient is noisy;
spatial fused-jet noise remains `3.1-5.2`, and curved temporal relative errors
remain between roughly `6` and `20`.

## Verdict

**Retain the exact differentiated projector.** Its finite-difference and affine
covariance tests pass, and it reduces operator-only jet error in every tested
cell.

**Reject the present fused first jet.** The A24 count-scale gradient, already
known not to converge uniformly, now dominates the corrected shape derivative.

**Keep Levi-Civita and curvature gates closed.** The immediate successor is a
separately calibrated count-volume gradient estimator with zero-gradient and
nonzero-gradient Poisson controls. It must be frozen before another curved
fusion test.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_retarded_moment_metric_first_jet.py Scripts/experiments/test_causal_retarded_moment_debiased_metric.py Scripts/experiments/test_causal_operator_count_fused_metric.py`
- `python -m ruff check Scripts/experiments/causal_retarded_moment_metric_first_jet.py Scripts/experiments/test_causal_retarded_moment_metric_first_jet.py Scripts/experiments/causal_retarded_moment_debiased_metric.py Scripts/experiments/test_causal_retarded_moment_debiased_metric.py`

## Provenance

- Standard matrix-inverse and quotient differentiation.
- A29 for the retarded-moment tensor correction.
- A24-A25 for count-scale and determinant fusion.
