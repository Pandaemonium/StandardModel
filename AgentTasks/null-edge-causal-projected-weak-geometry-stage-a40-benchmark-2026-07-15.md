# Stage A40: projected weak-geometry audit

Date: 2026-07-15

Status: preregistered projected calculus killed on the causal operator

## Objective

Determine whether A39's strong eventwise topology was too demanding by
projecting every operator and corrected-product-defect output back to the same
rank-15 degree-two algebra before constructing weak Hessian, `Gamma2`, and
Ricci.

The protocol was frozen in
`AgentTasks/null-edge-causal-projected-weak-geometry-stage-a40-plan-2026-07-15.md`.

## Weak calculus

With `P_L` the degree-two envelope projector, A40 defines

\[
\begin{aligned}
  \Box_L^w f &=P_L\Box_L f,\\
  \Gamma_L^w(f,h)&=P_L\Gamma_L(f,h),
\end{aligned}
\]

then forms the A38 weak Hessian and `Gamma2` entirely from these projected
operations. The Bochner remainder is evaluated on the full orbit of events
with maximal two-sided causal depth, so ties introduce no label choice.

## Independent implementation control

Before interpreting the causal result, the same projected code was tested on
a dense centered four-dimensional finite-difference d'Alembertian with
signature `(+---)`.

| flat chart | metric signature | Hessian norm | weak Ricci residual |
|---|---|---:|---:|
| temporal quadratic | `(+---)` | 2.02 | `4.5e-12` |
| shear quadratic | `(+---)` | 3.78 | `3.2e-5` |

The affine control has zero Hessian, `Gamma2`, and Ricci to the numerical zero
floor. Thus the implementation reproduces A38's distinction between nonzero
coordinate connection and zero physical curvature.

## Development selection

Oracle-only development used `N=300,600`, two realizations per density, seed
`20261410`, and the frozen A39 grids. No setting passed the Lorentzian weak-
metric structural gate. The preregistered minimax failure was

```text
cL = 0.45
retained depth fraction = 0.15
```

Johnston and random scores remained closed until that setting was frozen.

## Held-out result

Fresh seed `20261420` supplied four realizations at both densities.

| sector | N | Lorentz rate | weak double | weak triple | weak Ricci residual |
|---|---:|---:|---:|---:|---:|
| oracle affine | 300 | 0.50 | 0.755 | 1.027 | 0.976 |
| oracle affine | 600 | 0.50 | 0.553 | 1.039 | 1.007 |
| oracle temporal | 300 | 0.50 | 0.710 | 1.069 | 1.020 |
| oracle temporal | 600 | 0.50 | 0.530 | 1.075 | 0.989 |
| oracle shear | 300 | 0.50 | 0.783 | 1.089 | 0.999 |
| oracle shear | 600 | 0.50 | 0.533 | 1.031 | 1.015 |
| Johnston | 600 | 0.50 | 0.603 | 1.018 | 0.994 |
| random | 600 | 0.50 | 0.384 | 1.158 | 0.975 |

The nonlinear Hessians are nonzero in every chart/density median, so the test
does not pass or fail vacuously by returning zero geometry. The worst oracle
weak-Ricci residual changes only from `1.020` to `1.015`. Projection sometimes
slightly reduces the strong triple defect, but never makes it small; weak
double defects are not uniformly below their strong counterparts.

The Johnston high-density weak metric is Lorentzian in only half the samples.
Its median condition number is about `293`, its weak-Ricci cancellation is
`0.994`, and it does not beat the random control.

## Verdict

Only two preregistered conditions pass:

```text
rank/projector structure: pass
nonzero nonlinear Hessian: pass
all signature, locality, Ricci, and Johnston controls: fail
overall held-out gate: fail
```

A40 kills the global degree-two **projected** weak calculus at the tested
densities and schedule. Weak projection is not enough to turn the current
retarded causal operator into a second-order local calculus.

This does not contradict A38. A38 uses a known local d'Alembertian and is
independently reproduced by the A40 implementation. The failure lies in the
graph-side operator/algebra/region combination.

## Next architecture

Do not try higher polynomial degree or another global projector first. The
evidence now points to two admissible successors:

1. derive the continuum moment response of the retarded kernel analytically
   and normalize the scalar operator itself before extracting geometry; or
2. construct a genuinely local algebra germ on an intrinsic Alexandrov patch,
   with an inner core separated from its zero-extension boundary, then test
   strong and weak locality as the core/patch scale ratio shrinks.

The local-germ route must preserve basis/projector covariance and include a
random-subspace control. The analytic route must derive, rather than fit, the
A29 temporal/spatial response and retain the exact potential cancellation.

## Artifacts

- `Scripts/experiments/causal_projected_weak_geometry.py`
- `Scripts/experiments/test_causal_projected_weak_geometry.py`
- `AgentTasks/causal-projected-weak-geometry-stage-a40-development-2026-07-15.json`
- `AgentTasks/causal-projected-weak-geometry-stage-a40-heldout-2026-07-15.json`

## Provenance

- A38 kernel-checked weak-Hessian/`Gamma2` conventions.
- A39 basis-independent degree-two algebra envelope.
- User-supplied Pro analysis emphasizing weak geometry before pointwise
  Christoffels.
- Numerical implementation, controls, and gate design are original project
  work.
