# Null-edge Stage A41 continuum kernel-moment preregistration

**Status:** preregistered; no quadrature result claimed

## Question

Does the exact Poisson mean of the implemented four-dimensional smeared
Benincasa-Dowker kernel recover the project-sign d'Alembertian on compactly
supported scalar germs, with temporal and spatial quadratic responses
converging together without the empirical A29 rank-one correction?

This stage separates analytic kernel normalization and boundary effects from
sprinkling noise, intrinsic generator selection, and finite algebra
projection. A failure here blocks another random-graph curvature run.

## Source and convention lock

- The discrete kernel is equations (8)-(9) of Benincasa and Dowker,
  [arXiv:1001.2725](https://arxiv.org/abs/1001.2725).
- The continuum target and curved scalar term are source-checked against
  Belenchia, Benincasa, and Dowker,
  [arXiv:1510.04656](https://arxiv.org/abs/1510.04656).
- The source `(-+++)` row is multiplied by `-1`; the project target is
  `Box = partial_t^2 - sum_i partial_i^2` with signature `(+---)`.
- In four dimensions, `C4 = pi/24`, `epsilon = (ell/L)^4`, and the exact
  Poisson transform of the broad-layer factor is

```text
E[f(N,epsilon)]
  = exp(-epsilon lambda)
    [1 - 9 epsilon lambda + 8 (epsilon lambda)^2
       - (4/3) (epsilon lambda)^3].
```

Since `rho epsilon = L^-4`, the project-sign continuum mean is

```text
B_L phi(x) = a_L phi(x)
  - (a_L/L^4) integral_{J^-(x)} exp(-z) P(z) phi(y) d^4y,
a_L = 4/(sqrt(6) L^2),
z = Vol(I(y,x))/L^4,
P(z) = 1 - 9z + 8z^2 - (4/3)z^3.
```

The implementation must verify the Poisson-transform identity independently
against a truncated direct Poisson sum before using this continuum kernel.

## Marked-diamond germ

Fix the flat Alexandrov interval with endpoints

```text
p = (-R,0,0,0), q = (R,0,0,0), x = (0,0,0,0), R = 1.
```

For `y` in `I(p,q)`, define the endpoint-volume depth

```text
d(y) = min(tau(p,y)^4, tau(y,q)^4) / R^4.
```

This is the continuum counterpart of the order/count `boundaryDepth` in
`AlexandrovAlgebraGerm.lean`. A fixed smooth step is zero below `d0`, one
above `d1`, and smoothly interpolated between them. No target operator value
or metric component selects either profile.

Primary and robustness profiles are frozen as

```text
primary:    (d0,d1) = (0.02,0.08)
robustness: (d0,d1) = (0.04,0.12).
```

The no-cutoff indicator of `I(p,q)` is a negative boundary control. It is not
smooth at the interval boundary and is not eligible to establish convergence.

## Fields and exact targets

Multiply every polynomial by the selected cutoff. Since the cutoff is exactly
one on a neighborhood of `x`, its derivatives do not change the local target.
Rotational symmetry reduces the direct operator moments to:

| Field class | Representative | `Box phi(x)` |
|---|---|---:|
| constant | `1` | `0` |
| affine temporal | `t` | `0` |
| affine spatial | `x1` | `0` by angular symmetry |
| quadratic temporal | `t^2` | `2` |
| quadratic spatial diagonal | `x1^2` | `-2` |
| quadratic mixed | `t x1`, `x1 x2` | `0` by angular symmetry |
| cubic temporal | `t^3` | `0` |
| cubic temporal-spatial | `t x1^2` | `0` |
| other cubic classes | odd angular classes | `0` |

The induced coordinate pairing is one half of the quadratic response, hence
its target is `diag(1,-1,-1,-1)`.

## Deterministic quadrature

Use spherical symmetry for the angular moments and Gauss-Legendre quadrature
in retarded time `u=-t` and scaled proper separation
`w=(u^2-r^2)/L^2`. The exponential is then `exp(-C4 w^2)`, avoiding a
shrinking boundary layer in the raw radial variable. Angular averages use
`E[x_i^2]=r^2/3`; all odd or mixed classes are set to their exact symmetry
zero only after a separate angular-symmetry test.

The frozen scale sequence is

```text
L/R = 0.25, 0.20, 0.16, 0.125, 0.10.
```

Every reported value must agree between tensor-product orders `160` and `240`
to relative tolerance `2e-5`, with absolute tolerance `2e-6` near zero.

## Registered diagnostics

For each cutoff and scale report:

1. `|B_L 1(x)|` and `|B_L t(x)|`;
2. temporal and spatial quadratic responses;
3. relative Frobenius error of the induced diagonal pairing;
4. temporal/spatial response-ratio error from `-1`;
5. absolute cubic residuals for `t^3` and `t x1^2`;
6. low/high quadrature disagreement;
7. the same diagnostics for the no-cutoff boundary control.

## Pass gate

A41 passes only if both smooth profiles satisfy all of the following:

1. all low/high quadrature comparisons meet the registered tolerance;
2. the final induced metric has signature `(+---)`;
3. final relative metric error is below `0.20`;
4. final temporal/spatial response-ratio error is below `0.15`;
5. final constant, affine, and each cubic absolute residual is below `0.20`;
6. metric error and the maximum zero-target residual each decrease by at least
   `40%` from `L/R=0.25` to `L/R=0.10`;
7. no fitted scalar or rank-one correction is used.

The no-cutoff control is expected to fail or converge more slowly, but its
behavior is diagnostic and is not itself a pass requirement.

## Kill and successor rules

Kill the current kernel implementation or convention if either smooth profile
has a stable wrong sign, a nonconvergent temporal/spatial ratio, or an
order-one compact-support residual at the smallest scale after quadrature
convergence is established.

If A41 passes, preregister A42 on random sprinklings using marked-diamond
count-depth cutoffs and protected cores. A42 must first use supplied oracle
polynomials to isolate graph fluctuations; intrinsic generator selection is a
later subgate. If A41 fails, do not compensate by fitting the A29 response
weight. Audit the kernel formula, sign, and source hypotheses analytically.

No finite A41 outcome is a continuum-GR derivation.
