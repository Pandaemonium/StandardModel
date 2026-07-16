# Null-edge causal-kernel diagonal variance audit

**Date:** 2026-07-15

## Verdict

The exact positive diagonal second-moment contribution explains the scale and
much of the magnitude of the A42 fluctuations. It is not the full row
variance: off-diagonal shared-sprinkling covariance and random count-depth
taper fluctuations remain outside this calculation.

## Exact kernel moments

Write the broad-layer factor in the falling-factorial basis,

```text
f(N,e)=(1-e)^N sum_i a_i(e) (N)_i,  i=0,1,2,3.
```

The identities

```text
(N)_i (N)_j = sum_k binom(i,k) binom(j,k) k! (N)_(i+j-k),
E[s^N (N)_d] = (lambda s)^d exp(lambda(s-1))
```

give an exact finite expression for `E[f^2]`. A direct Poisson sum checks the
implementation. At fixed `z=e*lambda`, symbolic expansion gives

```text
Var f(N,e)
  = e*exp(-2z)*z*(4z^3-36z^2+75z-30)^2/9 + O(e^2).
```

The first two finite-binomial moments are also exact, using

```text
E[s^K (K)_d] = (n)_d (p s)^d (1-p+p s)^(n-d).
```

This separates deterministic finite-count bias from stochastic variance.

## Diagonal continuum term

The Poisson Mecke identity makes the sum of squared individual predecessor
contributions an exact integral. For operator prefactor `A`, density
`rho=1/(e L^4)`, and predecessor coefficient `A*e`, the common multiplier is

```text
A^2 * e / L^4.
```

The script integrates this term against the exact kernel second moment and
the squared angular field classes. It does not assume that different
predecessors are independent.

At `N=20000`:

| cutoff | `L/R` | `e` | predicted sd `B1` | predicted sd `Bt` | predicted sd `Btt` | predicted sd `Bxx` |
|---|---:|---:|---:|---:|---:|---:|
| primary | 0.30 | 0.0129 | 3.24 | 1.12 | 0.42 | 0.11 |
| primary | 0.25 | 0.0268 | 9.74 | 3.38 | 1.27 | 0.31 |
| primary | 0.20 | 0.0654 | 38.22 | 13.05 | 4.79 | 1.23 |
| primary | 0.16 | 0.1598 | 161.32 | 53.19 | 18.74 | 5.42 |
| robustness | 0.30 | 0.0129 | 2.71 | 0.83 | 0.28 | 0.08 |
| robustness | 0.25 | 0.0268 | 8.20 | 2.59 | 0.89 | 0.22 |
| robustness | 0.20 | 0.0654 | 32.65 | 10.27 | 3.47 | 0.88 |
| robustness | 0.16 | 0.1598 | 140.92 | 43.27 | 14.18 | 3.93 |

Every order `48/72` comparison agrees within `1.35e-6` relative.

## Comparison with A42

At `L/R=0.20`, A42's observed versus diagonal-predicted standard deviations
for the primary taper were `61.36/38.22` on `B1` and `7.74/4.79` on `Btt`.
For the robustness taper they were `39.11/32.65` and `3.43/3.47`. At
`L/R=0.16`, observed values are about `2.1-2.5` times the diagonal prediction
in the constant and temporal-quadratic channels.

The diagonal term therefore captures the correct order of magnitude, while
the residual covariance becomes more important as `e` grows. A42's failure is
already expected from the diagonal term; it does not require an anomalous
preferred-frame effect.

## Consequence

The one-term asymptotic suppresses interval-count variance with
`e=(ell/L)^4`, but the operator prefactor gives the familiar naive fluctuation
scale

```text
sqrt(e)/L^2 = ell^2/L^4.
```

Thus a joint pointwise schedule needs `ell^2/L^4 -> 0`; the weaker condition
`ell/L -> 0` is not enough for this diagnostic. The boundary scaling `L`
proportional to `sqrt(ell*R)` does not suppress
this estimate. Mesoscopic averaging may weaken the pointwise requirement, but
its overlap covariance must be measured or bounded before claiming that.

Artifact:
`AgentTasks/causal-kernel-diagonal-variance-audit-2026-07-15.json`.

No complete concentration theorem, Lorentz-recovery theorem, curvature result,
or continuum-GR claim follows from this diagonal audit.
