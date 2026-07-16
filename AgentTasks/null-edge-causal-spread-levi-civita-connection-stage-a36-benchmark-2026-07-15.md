# Null-edge Stage A36 spread-row Levi-Civita connection benchmark

**Status:** completed conditional finite connection control; convergence and curvature remain open  
**Date:** 2026-07-15

## Question

Given the A35 inverse metric `G` and first jet `dG`, A36 asks whether the
standard inverse-derivative identity and Levi-Civita formula produce a finite
connection with controlled target error. The covariant metric jet is derived as

\[
  \partial_\lambda g=-g(\partial_\lambda G)g,
\]

and no independent connection field is supplied.

## Controls

Unit tests check the inverse-derivative formula by finite difference, symmetry
of the two lower connection indices, metric compatibility, and affine probe
covariance. The benchmark reuses the A35 fresh samples without retuning.

| density | H | median connection error | ensemble error | target connection norm |
|---:|---:|---:|---:|---:|
| 4000 | 0.0 | 0.792 | 0.594 | 0.000 |
| 4000 | 0.1 | 0.863 | 0.641 | 0.340 |
| 4000 | 0.2 | 0.779 | 0.450 | 0.735 |
| 8000 | 0.0 | 0.599 | 0.412 | 0.000 |
| 8000 | 0.1 | 0.720 | 0.564 | 0.340 |
| 8000 | 0.2 | 0.926 | 0.657 | 0.735 |

Torsion and metric-compatibility residuals are at floating-point roundoff,
roughly `10^-16`. That is an algebraic consequence of the construction, not an
independent continuum test.

## Verdict

All six median and ensemble connection errors are subunit, so the A35 field can
feed a finite Levi-Civita construction without numerical blowup. Flat and
`H=0.1` errors improve at doubled density. The `H=0.2` median worsens from
`0.779` to `0.926`, however, so connection convergence is not established.

No curvature is computed. Before opening the curvature triangle, the next gate
must demonstrate a nonvacuous two-density connection trend on zero and nonzero
flat-chart controls together with the curved backgrounds, or isolate and repair
the count-scale derivative responsible for the nonuniform curved behavior.
Coordinates, density, dimension, probes, windows, and target comparisons remain
supplied.

## Artifacts

- `Scripts/experiments/causal_spread_levi_civita_connection.py`
- `Scripts/experiments/test_causal_spread_levi_civita_connection.py`
- `AgentTasks/causal-spread-levi-civita-connection-stage-a36-2026-07-15.json`
