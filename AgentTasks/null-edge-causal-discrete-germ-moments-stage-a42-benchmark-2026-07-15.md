# Null-edge Stage A42 discrete marked-germ moment benchmark

**Date:** 2026-07-15

## Verdict

**FAIL.** The preregistered finite-sprinkling schedule does not concentrate
around the quadrature-certified A41d continuum moments. This kills the tested
density, scale, and four-realization averaging schedule; it does not kill the
continuum kernel validated by A41c.

## Structural controls

- Live source-to-project coefficient relative error: below `1e-12`.
- Every sample satisfies `ell<L`.
- Every marked cutoff is exactly zero at the endpoints and one at the pivot.
- Unit tests verify strict interval counts and relabeling covariance.
- Every random realization is reused across all four strata.

## Held-out results

At `N=20000`:

| cutoff | `L/R` | `ell/L` | field error | metric error | `Delta_ps` difference | signature rate |
|---|---:|---:|---:|---:|---:|---:|
| primary | 0.20 | 0.51 | 3.65 | 0.47 | 0.40 | 0.50 |
| primary | 0.16 | 0.63 | 4.83 | 1.15 | 0.12 | 0.25 |
| robustness | 0.20 | 0.51 | 4.16 | 0.31 | 0.24 | 1.00 |
| robustness | 0.16 | 0.63 | 5.60 | 0.66 | 0.16 | 0.25 |

All four strata fail the frozen field-error `<0.20` and metric-error `<0.15`
gates. All four also fail the `Delta_ps` agreement gate. Metric errors improve
from `N=5000` by `23%-63%`; field errors improve at `L/R=0.16` by `69%-88%`
but worsen at `0.20`. Only the robustness `0.20` stratum reaches the required
signature rate.

Median individual errors are substantially larger than errors of the four-run
ensemble mean. At `N=20000`, median field errors range from `4.47` to `120.40`
and median metric errors from `0.65` to `7.99`. This is a variance and
two-scale-separation failure, not a borderline finite bias.

## Scientific consequence

The condition `ell<L` is too weak for this observable. The tested high-density
ratios `ell/L=0.51-0.63` do not realize `ell << L`, and cancellation among the
broad-layer coefficients remains noisy. The next experiment must be preceded
by an analytic variance or concentration audit and should use substantially
smaller `ell/L`, explicit mesoscopic averaging, or both.

Artifacts:

- `AgentTasks/causal-discrete-germ-moments-stage-a42-development-2026-07-15.json`
- `AgentTasks/causal-discrete-germ-moments-stage-a42-heldout-2026-07-15.json`

No intrinsic function algebra, curvature estimator, or continuum-GR claim is
opened by A42.
