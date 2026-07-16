# Null-edge Stage A34 spread-row chart shape-jet benchmark

**Status:** completed positive conditional control; bare-graph first-jet gate remains open  
**Date:** 2026-07-15

## Question

A33 showed that the nearest-row local fit could not resolve exact nonzero
metric-shape jets induced by nonlinear coordinates on flat spacetime. A34 asks
whether the missing signal lives at a wider mesoscopic scale. It retains the
same zero, temporal, and shear chart controls, but selects rows by deterministic
farthest-point spreading across the full averaging ball.

## Locked protocol

- All selection backgrounds are flat.
- Both `N=4000` and `N=8000` enter development selection.
- A viable setting must choose a strictly positive tangent weight and beat the
  zero-derivative baseline in worst-cell median and ensemble error.
- Every pivot tensor must remain Lorentzian.
- The worst pivot median shape error must not exceed `0.30`.
- Candidate averaging multipliers are `1.1`, `1.4`, `1.7`, and `1.9`.
- Spread selection uses supplied embedding coordinates; it is not intrinsic
  bare-order reconstruction.

## Selection result

| averaging multiplier | selected weight | worst median | worst ensemble | worst pivot shape | pivot gate |
|---:|---:|---:|---:|---:|:---:|
| 1.1 | 0.1 | 0.980 | 0.966 | 0.260 | pass |
| 1.4 | 0.4 | 0.854 | 0.723 | 0.306 | fail |
| 1.7 | 0.2 | 0.842 | 0.822 | 0.265 | pass |
| 1.9 | 0.2 | 0.818 | 0.817 | 0.315 | fail |

The frozen selector chooses averaging multiplier `1.7` and tangent weight
`0.2`. Unlike A33, this is a nonzero estimator that beats the zero baseline on
both normalized criteria while preserving the pivot-tensor gate.

## Verdict

A34 is the first positive nonvacuity control for the operator-shape first jet.
The useful change is mesoscopic row coverage, not rowwise nonlinear
normalization. This justifies a fresh curved evaluation with the setting frozen
before seeing a curved target.

It does not establish convergence or close G2. Dimension, coordinates, probes,
windows, response normalization, and the spread geometry are supplied. The
errors remain large enough that a connection may only be tested as a
conditional numerical bridge.

## Artifacts

- `Scripts/experiments/causal_spread_chart_shape_jet.py`
- `Scripts/experiments/test_causal_spread_chart_shape_jet.py`
- `AgentTasks/causal-spread-chart-shape-jet-stage-a34-development-2026-07-15.json`
