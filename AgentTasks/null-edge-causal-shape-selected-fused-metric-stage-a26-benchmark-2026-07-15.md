# Null-edge shape-selected fused metric Stage A26 benchmark

Date: 2026-07-15

## Question

Did A23 choose the wrong operator setting by prioritizing a first-jet score that
later failed, and can flat-only selection on determinant-normalized conformal
shape close A25's tensor-metric obstruction without disturbing count volume?

## Selection protocol

`Scripts/experiments/causal_shape_selected_fused_metric.py` rescored the frozen
A23 `N=4000` development samples. Only `H=0` samples entered selection. For
each Lorentzian operator metric `G`, it formed

```text
shape(G) = G / abs(det G)^(1/4)
```

and compared this unit-volume representative with the flat target. Signature
rate was prioritized, followed by median, ensemble-mean, and maximum shape
error. No curved target or fresh seed entered selection.

The selected setting is

```text
cL = 0.65, cS = 1.2, cA = 0.9.
```

Its development signature rate is `1.0`, median unit-volume shape error is
`0.132`, ensemble-mean shape error is `0.059`, and maximum shape error is
`0.273`. A23 had selected `cS=1.4` because its score included the now-failed
first jet. A26 then applies the unchanged A25 determinant/count-volume fusion.

Coordinates, density, dimension, probe germs, count windows, and scale
schedules remain supplied. This is a conditional selector audit.

## Held-out `N=4000`

Artifact:
`AgentTasks/causal-shape-selected-fused-metric-stage-a26-heldout-n4000-2026-07-15.json`

Four fresh realizations per background use seed `20261120`.

| `H` | signature rate | median fused metric error | ensemble metric error | oracle-volume error | count-volume mismatch | first-jet error |
|---:|---:|---:|---:|---:|---:|---:|
| `0.0` | `1.00` | `0.131` | `0.092` | `0.096` | `0.099` | `4.561` |
| `0.1` | `1.00` | `0.168` | `0.162` | `0.050` | `0.083` | `7.064` |
| `0.2` | `0.50` | `0.573` | `0.459` | `0.041` | `0.190` | `6.649` |

The first two backgrounds improve sharply over A25's roughly `0.51-0.63`
median tensor errors. The stronger-curvature cell fails the signature gate:
two of four fused metrics are negative definite. The benchmark records these
failures rather than aborting.

## `N=8000` refinement

Artifact:
`AgentTasks/causal-shape-selected-fused-metric-stage-a26-refinement-n8000-2026-07-15.json`

Three fresh realizations per background use seed `20261130` and doubled row and
count-center caps.

| `H` | signature rate | median fused metric error | ensemble metric error | oracle-volume error | count-volume mismatch | first-jet error |
|---:|---:|---:|---:|---:|---:|---:|
| `0.0` | `1.00` | `0.489` | `0.423` | `0.007` | `0.061` | `5.395` |
| `0.1` | `1.00` | `0.261` | `0.278` | `0.011` | `0.015` | `5.290` |
| `0.2` | `1.00` | `0.166` | `0.117` | `0.079` | `0.141` | `5.166` |

All refinement metrics are Lorentzian, and the strong-curvature shape improves
substantially. Flat and weak-curvature errors do not improve monotonically,
however. The first jet remains order one in every cell.

## Verdict

**Retain shape-first flat selection as the correct selector objective after
volume has been split off.** It exposes that A23's failed derivative objective
had selected a materially worse conformal representative.

**Reject this single-density setting as a G2 solution.** The gains are not
uniform in density or curvature, and one held-out cell loses Lorentzian
signature. The next selector must be preregistered on multiple flat development
densities, or the estimator itself must remove the support-induced anisotropic
bias. A curved score must not be used to choose it.

**Keep first-jet, Levi-Civita, and curvature gates closed.** Determinant/count
fusion remains sound, but it cannot stabilize a regulator-dependent conformal
shape or its derivative.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_shape_selected_fused_metric.py Scripts/experiments/test_causal_operator_count_fused_metric.py`
- `python -m ruff check Scripts/experiments/causal_fused_operator_count_metric.py Scripts/experiments/test_causal_operator_count_fused_metric.py Scripts/experiments/causal_shape_selected_fused_metric.py Scripts/experiments/test_causal_shape_selected_fused_metric.py`
- Both JSONs retain selection scores, fresh seeds, individual samples, fused
  matrices, signatures, count-volume controls, and first-jet diagnostics.

## Provenance

- A23 for the frozen flat development grid and shrinking-scale estimator.
- A24/A25 for independent count-volume reconstruction and determinant fusion.
- Standard determinant normalization of a four-dimensional inverse metric.
