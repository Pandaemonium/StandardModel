# Null-edge Stage A37 connection-convergence benchmark

**Status:** preregistered conditional gate passed; no continuum theorem or curvature result  
**Date:** 2026-07-15

## Question

A36 produced a finite Levi-Civita connection, but its `H=0.2` error worsened
when density doubled. A37 asks whether a count-scale schedule selected only on
flat nonlinear-chart controls can remove that regression while retaining a
nonzero coordinate-connection response.

For

\[
  y^a=u^a+\frac12Q^a{}_{mn}u^m u^n,
\]

the exact pivot targets are

\[
  \Gamma^a{}_{bc}=-Q^a{}_{bc},
  \qquad
  \partial_\lambda f=\frac12\operatorname{tr}Q_\lambda.
\]

The temporal chart tests shape and determinant scale together. The shear chart
has a nonzero connection but zero determinant-scale jet, so it tests the shape
channel independently. Both charts are flat and have zero physical curvature.

## Development selection

The A34 averaging multiplier `1.7` and tangent weight `0.2` are retained.
Development tests mapped-coordinate count-window multipliers `0.5`, `0.65`,
and `0.8`; center multipliers `1.2`, `1.5`, and `1.8`; and Poisson penalties
`0`, `0.03`, `0.1`, `0.3`, and `0.8` on four realizations at each of
`N=4000` and `N=8000`.

No curved target enters selection. The chosen setting is

```text
count window multiplier = 0.8
count center multiplier = 1.8
Poisson penalty = 0.8
```

It passes all flat development gates. Its worst median and ensemble connection
errors are `0.876` and `0.872`; the corresponding count-gradient errors are
`0.333` and `0.324`.

## Fresh held-out result

The held-out seed `20261380` is distinct from the development seed `20261370`.
Eight independent realizations are used in every cell.

| density | control | median metric | median scale jet | median connection | ensemble connection | zero baseline |
|---:|:---|---:|---:|---:|---:|---:|
| 4000 | affine flat | 0.14 | 0.09 | 0.62 | 0.56 | 0.00 |
| 4000 | shear flat | 0.12 | 0.09 | 0.85 | 0.83 | 1.00 |
| 4000 | temporal flat | 0.29 | 0.35 | 0.67 | 0.59 | 0.80 |
| 4000 | H=0.1 | - | - | 0.78 | 0.62 | - |
| 4000 | H=0.2 | - | - | 0.99 | 0.88 | - |
| 8000 | affine flat | 0.09 | 0.06 | 0.35 | 0.27 | 0.00 |
| 8000 | shear flat | 0.09 | 0.06 | 0.86 | 0.84 | 1.00 |
| 8000 | temporal flat | 0.18 | 0.32 | 0.60 | 0.53 | 0.80 |
| 8000 | H=0.1 | - | - | 0.51 | 0.32 | - |
| 8000 | H=0.2 | - | - | 0.76 | 0.63 | - |

Every metric is Lorentzian, and every flat cell has median metric error below
`0.30`. Both nonzero flat charts beat the zero-connection baseline in median
and ensemble error at both densities. Every high-density median and ensemble
connection error is subunit.

The preregistered worst-cell measures improve:

| measure | N=4000 | N=8000 |
|:---|---:|---:|
| worst median connection error | 0.993 | 0.856 |
| worst ensemble connection error | 0.882 | 0.840 |
| H=0.2 median connection error | 0.993 | 0.757 |

## Verdict

A37 passes its conditional two-density connection gate and removes the A36
high-curvature regression. It therefore permits exact second-jet and curvature
controls to begin.

This is not a connection-convergence theorem. The shear response amplitude is
only `0.24` at `N=4000` and `0.17` at `N=8000`, although its orthogonal noise
falls from `0.38` to `0.22` and its error remains below the zero baseline. More
densities and asymptotic scaling are required.

Coordinates, dimension, density calibration, probes, chart maps, support, and
mapped-coordinate count windows are supplied. The count windows are a
conditional volume oracle, not a bare-order construction. Curvature has not
been computed.

## Artifacts

- `Scripts/experiments/causal_connection_convergence.py`
- `Scripts/experiments/test_causal_connection_convergence.py`
- `AgentTasks/causal-connection-convergence-stage-a37-development-2026-07-15.json`
- `AgentTasks/causal-connection-convergence-stage-a37-heldout-2026-07-15.json`
