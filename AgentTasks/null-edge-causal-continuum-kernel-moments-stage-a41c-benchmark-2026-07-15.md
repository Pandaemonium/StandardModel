# Null-edge Stage A41c continuum kernel-moment benchmark

**Date:** 2026-07-15

## Verdict

**PASS.** The exact Poisson-averaged project-sign causal operator converges on
both preregistered smooth Alexandrov germs to the `(+---)` d'Alembertian
moments without any scalar, rank-one, drift, or potential correction.

This closes the deterministic continuum-normalization subgate. It does not
prove that the discrete random operator concentrates around these moments or
that an intrinsic function algebra exists.

## Controls

- Live discrete/continuum coefficient relative error: exactly `0`.
- Poisson broad-layer transform: independently checked against a direct sum.
- Outer retarded time and inner proper variable are split at every analytic
  cutoff branch intersection.
- Every `160/240` comparison passes the frozen relative/absolute tolerance.
- Largest absolute low/high difference: about `5.0e-6`, on the primary
  constant response at `L/R=0.16`; its relative difference passes.

## Results

| cutoff | `L/R` | `B1` | `Bt` | `Btt` | `Bxx` | metric error | ratio error | `Delta_ps` | max zero residual |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| primary | 0.16 | 0.75 | -0.18 | 2.40 | -1.67 | 0.17 | 0.44 | 0.18 | 0.79 |
| primary | 0.125 | 0.28 | 0.00 | 2.18 | -1.79 | 0.10 | 0.22 | 0.10 | 0.44 |
| primary | 0.10 | 0.14 | 0.02 | 2.11 | -1.87 | 0.06 | 0.13 | 0.06 | 0.27 |
| primary | 0.08 | 0.08 | 0.02 | 2.07 | -1.91 | 0.04 | 0.08 | 0.04 | 0.17 |
| primary | 0.065 | 0.05 | 0.02 | 2.04 | -1.94 | 0.03 | 0.05 | 0.02 | 0.11 |
| robustness | 0.16 | 2.57 | -1.15 | 2.96 | -1.69 | 0.27 | 0.75 | 0.27 | 2.57 |
| robustness | 0.125 | 0.72 | -0.24 | 2.34 | -1.80 | 0.12 | 0.30 | 0.13 | 0.72 |
| robustness | 0.10 | 0.34 | -0.09 | 2.19 | -1.87 | 0.07 | 0.17 | 0.08 | 0.34 |
| robustness | 0.08 | 0.19 | -0.04 | 2.11 | -1.91 | 0.05 | 0.10 | 0.05 | 0.19 |
| robustness | 0.065 | 0.11 | -0.02 | 2.07 | -1.94 | 0.03 | 0.07 | 0.03 | 0.13 |

At `L/R=0.065`, both profiles have signature `(+---)`, relative metric error
about `0.03`, response-ratio error below `0.07`, `Delta_ps` below `0.03`, and
maximum zero-target residual below `0.15`. Metric errors reduce by `84.5%` and
`89.0%`; lower-moment residuals reduce by `85.7%` and `95.0%`.

## Scientific consequence

The A39/A40 failure is not explained by a wrong asymptotic scalar
normalization of the published smeared kernel. The finite temporal bias seen
in A29 is consistent with a boundary/nonlocality-scale effect and should not
be promoted to a fundamental rank-one operator correction.

At finite `L/R`, lower retarded moments remain appreciable and differ between
cutoffs. Any discrete test must compare against the finite-scale continuum
moments, not directly against `(0,0,2,-2,0,0)`. Only after discrete
concentration is established may the `L/R -> 0` limit be combined with
`ell/L -> 0`.

## Successor

A42 tests one-row discrete moments on random flat marked diamonds using oracle
polynomials and the same count-depth cutoffs. It does not select intrinsic
generators or open weak curvature.

Artifact:
`AgentTasks/causal-continuum-kernel-moments-stage-a41c-2026-07-15.json`.

No graph-to-manifold, curvature, or continuum-GR claim follows from A41c.
