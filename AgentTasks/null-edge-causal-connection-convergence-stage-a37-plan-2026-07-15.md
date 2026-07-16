# Null-edge Stage A37 connection-convergence preregistration

**Status:** preregistered; no result claimed  
**Date:** 2026-07-15

## Objective

Determine whether the A36 nonuniform curved connection error comes from the
count-scale derivative and whether one frozen mesoscopic schedule can recover a
chart-covariant Levi-Civita connection at two densities.

This stage is a gate before curvature. It does not estimate a Riemann tensor.

## Frozen inputs

- Retain the A29 aggregate response correction.
- Retain the A34 spread-row operator estimator and tangent weight unless a new
  flat-only development split replaces them.
- Retain the A24 count-volume normalization at the pivot.
- Do not tune on de Sitter or any other curved target.
- Continue to treat coordinates, dimension, probes, density calibration, and
  mesoscopic support as supplied conditional inputs.

## Development controls

Select any count-gradient window or penalty only on independent two-density
Poisson controls containing both zero and prescribed nonzero log-volume
gradients. Selection must be covariant under invertible affine changes of the
supplied probes and must retain a nonzero response.

The metric/connection development suite then uses flat spacetime in three
charts:

- affine coordinates, with zero target connection;
- the A33 temporal quadratic chart, with exact nonzero target connection;
- the A33 shear quadratic chart, with exact nonzero target connection.

The two quadratic charts have zero curvature despite their nonzero
Christoffel symbols. They therefore separate chart response from physical
curvature and prevent a zero-connection estimator from passing vacuously.

## Held-out evaluation

After freezing all choices, evaluate fresh realizations at `N=4000` and
`N=8000` for the three flat charts and the existing `H=0.1` and `H=0.2`
conformal backgrounds. Report:

- Lorentzian signature rate and pivot metric error;
- shape-jet and count-scale-jet errors separately;
- median, ensemble, and worst-realization connection errors;
- response amplitude and orthogonal noise for each nonzero flat-chart target;
- the density-refinement ratio in every cell;
- results with estimated, zero, and target scale jets.

## Pass conditions

All of the following are required:

1. Every held-out pivot metric is Lorentzian and each cell has median metric
   error below `0.30`.
2. Both nonzero flat-chart connections beat the zero-connection baseline in
   median and ensemble error at both densities.
3. No selector chooses a zero shape or scale response when the exact target is
   nonzero.
4. Every high-density cell has subunit median and ensemble connection error.
5. The worst-cell median and ensemble errors improve when density doubles, and
   the `H=0.2` cell no longer exhibits the A36 regression.

## Kill conditions

The current connection estimator is killed if no flat-selected mesoscopic
window satisfies the pass conditions, if the nonlinear flat charts remain
below their orthogonal noise, or if curved improvement requires target-tuned
parameters. A failure leaves curvature closed and returns the program to the
metric/count first-jet estimator.

## Successor

Only after an A37 pass should Stage A38 introduce exact second-jet controls and
compare connection scalar curvature with the causal-operator scalar
`-2 B_C 1`. Area reconstruction and holonomy curvature form a later independent
comparison; they must not be calibrated to force agreement.
