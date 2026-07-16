# Null-edge Stage A33 quadratic-chart shape-jet benchmark

**Status:** completed nonvacuity kill test; first-jet gate remains closed  
**Date:** 2026-07-15

## Question

A31-A32 isolate the aggregate unit-volume shape derivative as the active G2
failure. Shrinking that derivative on a flat zero-jet target would be vacuous:
the same estimator must respond to a genuine nonzero coordinate metric jet.

A33 therefore changes coordinates on flat spacetime by

\[
  y^a=u^a+\frac12 Q^a{}_{mn}u^m u^n.
\]

The Jacobian is the identity at the pivot, so the pivot metric remains
Minkowski, while

\[
  \partial_\lambda g_y
    =Q_\lambda\eta+\eta Q_\lambda^{\mathsf T}
\]

gives an exact nonzero target first jet. The determinant projection supplies
the exact unit-volume shape jet.

## Controls and split

Three flat charts are evaluated on shared sprinklings:

- `zero`: the ordinary affine chart;
- `temporal`: `Q[0,0,0]=0.8`;
- `shear`: `Q[0,1,1]=1.5`.

Development uses `N=4000` and `N=8000`, six realizations at each density, the
frozen A28 operator schedule, and A29 response weight `0.6`. Candidate scalar
tangent weights are `0`, `0.1`, `0.2`, `0.3`, `0.4`, `0.5`, `0.6`, `0.8`, and
`1`. No curved background enters selection.

Unit tests verify the identity pivot Jacobian, the exact metric-jet formula by
finite difference, and nonzero determinant-normalized shear response.

## Selection result

| Tangent weight | worst cell median error | worst cell ensemble error | all-cell median |
|---:|---:|---:|---:|
| 0.0 | 1.000 | 1.000 | 0.693 |
| 0.1 | 1.057 | 1.002 | 0.760 |
| 0.2 | 1.224 | 1.033 | 1.063 |
| 0.4 | 1.930 | 1.172 | 1.702 |
| 0.6 | 2.752 | 1.386 | 2.382 |
| 1.0 | 4.441 | 2.052 | 4.053 |

The frozen selector chooses `w=0`. That is not a viable derivative estimator;
it is the explicit kill outcome. Every nonzero response is less accurate than
discarding the derivative entirely.

The pivot tensor remains concentrated, with median shape errors
`0.117-0.183`. The first jet does not. At `N=8000`, the ensemble response
amplitude along the exact temporal target is `0.622` with orthogonal noise
`2.639` times the target norm. Along the shear target the amplitude is only
`0.134`, with orthogonal noise `1.727` times the target norm. Doubling density
does not produce uniform response convergence.

## Verdict

A33 closes a loophole in the prior diagnosis: the problem is not merely a
de Sitter scale derivative or a zero-jet flat fluctuation. The current
aggregate estimator does not resolve first-jet covariance under reasonable
nonlinear probe changes at the tested densities and mesoscopic schedule.

The zero tangent weight is rejected as physically vacuous. Connection and
curvature remain closed. The next experiment must search for a wider
mesoscopic averaging window or a constrained local-polynomial estimator using
the same zero/nonzero chart controls. It may not tune on curved targets or
accept a derivative estimator that only succeeds by returning zero.

## Artifacts

- `Scripts/experiments/causal_quadratic_chart_shape_jet.py`
- `Scripts/experiments/test_causal_quadratic_chart_shape_jet.py`
- `AgentTasks/causal-quadratic-chart-shape-jet-stage-a33-development-2026-07-15.json`
