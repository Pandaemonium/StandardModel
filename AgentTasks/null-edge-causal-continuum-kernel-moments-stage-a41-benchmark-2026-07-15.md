# Null-edge Stage A41 continuum kernel-moment benchmark

**Date:** 2026-07-15

## Verdict

**REVISE.** The frozen A41 window fails, but it does not trigger the kernel
kill condition. Both smooth compact-support profiles converge rapidly toward
the project d'Alembertian, have Lorentzian quadratic pairings at the smallest
scale, and reduce metric error by more than `80%`. The final zero-target
residual and the registered low/high quadrature agreement remain outside the
frozen thresholds.

## Exact controls

- The closed Poisson transform of the broad-layer kernel agrees with a direct
  truncated Poisson sum in all unit controls.
- The live discrete row agrees exactly with the continuum convention used by
  the script: after source-to-project conversion the operator is
  `A[phi(x) - L^-4 integral W phi]`.
- This exposes a sign error in equation (1) of the harvested Aristotle audit,
  which displayed `A[-phi(x) + L^-4 integral W phi]` while labeling it as the
  project `(+---)` convention. A global sign does not alter the scalar
  principal-symbol ratio or its no-go criterion.
- The initial implementation used unsplit tensor-product quadrature. Its
  physical settings and results are preserved in the A41 JSON artifact.

## Frozen results

High-order (`240`) values are shown. `Btt` and `Bxx` denote the direct
responses to `t^2` and one spatial square; their targets are `2` and `-2`.

| cutoff | `L/R` | `B1` | `Bt` | `Btt` | `Bxx` | metric error | ratio error | max zero residual | quadrature pass |
|---|---:|---:|---:|---:|---:|---:|---:|---:|:---:|
| primary | 0.25 | -3.37 | 2.25 | 1.53 | -1.25 | 0.35 | 0.23 | 3.37 | yes |
| primary | 0.20 | 2.52 | -1.15 | 3.16 | -1.53 | 0.35 | 1.07 | 2.52 | yes |
| primary | 0.16 | 0.75 | -0.18 | 2.40 | -1.67 | 0.17 | 0.44 | 0.79 | no |
| primary | 0.125 | 0.28 | 0.00 | 2.18 | -1.79 | 0.10 | 0.22 | 0.44 | no |
| primary | 0.10 | 0.14 | 0.02 | 2.11 | -1.87 | 0.06 | 0.13 | 0.27 | no |
| robustness | 0.25 | -10.78 | 6.19 | -0.45 | -1.12 | 0.72 | 1.40 | 10.78 | yes |
| robustness | 0.20 | 1.91 | -1.13 | 3.37 | -1.57 | 0.39 | 1.15 | 1.91 | yes |
| robustness | 0.16 | 2.57 | -1.15 | 2.96 | -1.69 | 0.27 | 0.75 | 2.57 | yes |
| robustness | 0.125 | 0.72 | -0.24 | 2.34 | -1.80 | 0.12 | 0.30 | 0.72 | no |
| robustness | 0.10 | 0.34 | -0.09 | 2.19 | -1.87 | 0.07 | 0.17 | 0.34 | no |
| none | 0.10 | 0.00 | 0.12 | 1.99 | -1.88 | 0.05 | 0.06 | 0.18 | yes |

The primary metric error falls by `81.6%` and its maximum zero-target residual
by `91.9%`. The robustness reductions are `89.7%` and `96.8%`. At `L/R=0.10`
both smooth pairings have signature `(+---)`. The failed quadrature checks are
small absolute differences (`1e-5` to `3e-4`) amplified by the inverse powers
of `L`, not stable wrong-sign responses.

## Interpretation

The finite A41 window is not yet asymptotic enough for the registered
zero-target threshold. It nevertheless contradicts the hypothesis of a stable
order-one temporal/spatial mismatch: both quadratic channels approach their
targets together. Therefore the current evidence favors compact-support
boundary bias over a fundamental scalar-normalization no-go.

The smooth cutoff introduces known analytic branch surfaces in the transformed
proper variable. A41b will split quadrature exactly at those frozen surfaces
and extend to smaller predeclared scales. This is a numerical-method revision,
not a change of kernel, cutoff, target, or fitted response.

## Artifact and verification

- Artifact:
  `AgentTasks/causal-continuum-kernel-moments-stage-a41-2026-07-15.json`
- Script: `Scripts/experiments/causal_continuum_kernel_moments.py`
- Tests: `Scripts/experiments/test_causal_continuum_kernel_moments.py`
- Initial unit run: `4 passed`; the subsequent live-convention test raises the
  maintained suite to `5 passed`.

No random graph, curved background, empirical response correction, or
continuum-GR claim is opened by this result.
