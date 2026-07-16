# Null-edge Stage A31 Poisson scale-gradient benchmark

**Status:** completed conditional numerical control; first-jet gate remains
closed  
**Date:** 2026-07-15

## Question

Stage A30 showed that differentiating the A29 retarded-moment correction is
algebraically sound, but the determinant/count-fused first jet remained noisy.
A30 attributed the dominant failure to the A24 affine count-factor gradient.
A31 tests that attribution directly.

## Estimator and split

The A24 pivot factor is retained. Only its derivative is replaced. Local
window counts are fitted with

\[
  N_i\sim\operatorname{Poisson}
  \left(E\exp(\theta_0+x_i^\mu\theta_\mu)\right),
  \qquad
  \partial_\mu f=-\frac12 f\theta_\mu.
\]

The slope penalty uses the observed center scatter matrix
\(\sum_i x_i x_i^{\mathsf T}\). Its quadratic form is invariant under an
invertible linear change of the supplied probe coordinates. Unit tests check
exact log-linear recovery, affine covariance, and suppression of flat
zero-gradient noise.

Penalty selection used only synthetic Poisson count controls on flat support:

- densities `N=4000` and `N=8000`;
- `12` realizations per density;
- one zero log-volume gradient and three nonzero temporal, spatial, and mixed
  gradients;
- candidates `0`, `0.1`, `0.3`, `1`, `3`, and `10`.

The frozen selector chose `lambda=0.1`. Its worst cell median normalized error
was `0.564`, compared with `0.583` without regularization. The stronger
penalties progressively suppressed the nonzero response and were rejected.

## Held-out results

The table reports median dimensionless errors. `raw gradient` is the A24 affine
factor fit, `A31 gradient` is the Poisson fit, and the jet columns fuse the same
A29 corrected tensor with the indicated scale derivative.

| Density | Background | raw gradient | A31 gradient | raw jet | A31 jet | zero-scale jet | oracle-scale jet |
|---|---:|---:|---:|---:|---:|---:|---:|
| 4000 | H=0.0 | 0.639 | 0.572 | 5.156 | 5.156 | 5.175 | 5.175 |
| 4000 | H=0.1 | 0.392 | 0.236 | 6.159 | 6.159 | 6.159 | 6.155 |
| 4000 | H=0.2 | 0.639 | 0.349 | 5.591 | 5.582 | 5.633 | 5.592 |
| 8000 | H=0.0 | 0.515 | 0.470 | 3.944 | 3.951 | 3.948 | 3.948 |
| 8000 | H=0.1 | 0.555 | 0.447 | 4.242 | 4.233 | 4.260 | 4.235 |
| 8000 | H=0.2 | 0.632 | 0.592 | 4.366 | 4.370 | 4.393 | 4.321 |

The A31 gradient improves in five of six cells and substantially in both
curved `N=4000` cells. Ensemble gradient errors are `0.145-0.258` at `N=4000`
and `0.151-0.365` at `N=8000`. The pivot tensor remains healthy: all held-out
metrics are Lorentzian, median tensor errors are `0.166-0.199`, and median
oracle-volume errors are `0.5%-13.5%`.

## Decisive control

The fused first jet does not materially improve. More importantly, replacing
the estimated scale gradient by either zero or the exact target gradient gives
essentially the same error. Therefore the scale-gradient estimate is not the
dominant A30 failure.

The error is already present in the derivative of the determinant-normalized
operator shape. The corrected, unnormalized operator-jet medians are
`3.13-3.19` at `N=4000` and `2.37-2.76` at `N=8000`; determinant normalization
raises the fused values to roughly `4-6` independently of which scale
gradient is supplied.

## Verdict

A31 is a useful estimator improvement and a falsification of A30's causal
diagnosis. It does **not** open the Levi-Civita gate. The next stage should
decompose the corrected operator jet into determinant/trace and unit-volume
shape derivatives, test each on flat zero-jet controls, and regularize or
replace the shape derivative before any connection or curvature fit.

The broader bare-graph debts are unchanged: coordinates, dimension, density,
windows, response normalization, and the probe quotient remain supplied.

## Artifacts

- `Scripts/experiments/causal_poisson_scale_gradient.py`
- `Scripts/experiments/test_causal_poisson_scale_gradient.py`
- `AgentTasks/causal-poisson-scale-gradient-stage-a31-development-2026-07-15.json`
- `AgentTasks/causal-poisson-scale-gradient-stage-a31-heldout-n4000-2026-07-15.json`
- `AgentTasks/causal-poisson-scale-gradient-stage-a31-heldout-n8000-2026-07-15.json`
