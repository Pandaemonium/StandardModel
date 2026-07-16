# Null-edge Stage A41b continuum kernel-moment benchmark

**Date:** 2026-07-15

## Verdict

**NUMERICAL METHOD INCOMPLETE.** Every registered physical moment gate passes
for both smooth cutoffs, but the independent `160/240` quadrature comparison
fails. Under the preregistered branching rule, this is not a physics pass and
does not open random sprinklings.

The live discrete/continuum coefficient relative error is exactly zero.

## Results

| cutoff | `L/R` | `B1` | `Bt` | `Btt` | `Bxx` | metric error | ratio error | `Delta_ps` | max zero residual | quadrature pass |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|:---:|
| primary | 0.16 | 0.75 | -0.18 | 2.40 | -1.67 | 0.17 | 0.44 | 0.18 | 0.79 | yes |
| primary | 0.125 | 0.28 | 0.00 | 2.18 | -1.79 | 0.10 | 0.22 | 0.10 | 0.44 | no |
| primary | 0.10 | 0.14 | 0.02 | 2.11 | -1.87 | 0.06 | 0.13 | 0.06 | 0.27 | no |
| primary | 0.08 | 0.08 | 0.02 | 2.07 | -1.91 | 0.04 | 0.08 | 0.04 | 0.17 | no |
| primary | 0.065 | 0.05 | 0.02 | 2.04 | -1.94 | 0.03 | 0.05 | 0.02 | 0.11 | no |
| robustness | 0.16 | 2.57 | -1.15 | 2.96 | -1.69 | 0.27 | 0.75 | 0.27 | 2.57 | yes |
| robustness | 0.125 | 0.72 | -0.24 | 2.34 | -1.80 | 0.12 | 0.30 | 0.13 | 0.72 | no |
| robustness | 0.10 | 0.34 | -0.09 | 2.19 | -1.87 | 0.07 | 0.17 | 0.08 | 0.34 | no |
| robustness | 0.08 | 0.19 | -0.04 | 2.11 | -1.91 | 0.05 | 0.10 | 0.05 | 0.19 | no |
| robustness | 0.065 | 0.11 | -0.02 | 2.07 | -1.94 | 0.03 | 0.07 | 0.03 | 0.13 | no |

At the final scale both cutoffs pass signature, metric, ratio, `Delta_ps`, and
zero-target thresholds. Metric errors reduce by `84.5%` and `89.0%`; maximum
zero-target residuals reduce by `85.7%` and `95.0%`.

The quadrature disagreement is concentrated in the lower moments and grows as
the inverse powers of `L` amplify small integration errors. At `L/R=0.065`,
the largest low/high absolute differences are about `0.0049` and `0.0056` for
the constant response. The transformed proper-variable cutoff surfaces are
split exactly, but their intersections with the retarded-time domain are not.

## Decision

Freeze A41c with the same kernel, profiles, scales, targets, and pass
thresholds. Split the outer retarded-time quadrature at every point where a
cutoff depth surface meets either the radial axis or the null/diamond radial
boundary. If A41c still misses quadrature tolerance, replace the method with
adaptive or higher-precision integration before interpreting the moments.

Artifact:
`AgentTasks/causal-continuum-kernel-moments-stage-a41b-2026-07-15.json`.

No graph, curvature, or continuum-GR gate is opened.
