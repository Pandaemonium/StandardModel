# Null-edge Stage A41d finite-target extension benchmark

**Date:** 2026-07-15

## Verdict

**PASS within the target-generation boundary.** A41d supplies the two finite
continuum moment strata required by A42. It certifies the live coefficient
convention and low/high quadrature agreement only; it is not an asymptotic
metric gate.

## Results

| cutoff | `L/R` | quadrature pass | maximum absolute difference |
|---|---:|---:|---:|
| primary | 0.20 | yes | `3.765e-6` |
| primary | 0.16 | yes | `4.997e-6` |
| robustness | 0.20 | yes | `2.564e-6` |
| robustness | 0.16 | yes | `4.151e-7` |

The artifact is explicitly marked `target_only`. Metric and principal-symbol
biases at these finite scales are retained in the target rather than used to
select or reject a stratum.

Artifact:
`AgentTasks/causal-continuum-kernel-moments-stage-a41d-2026-07-15.json`.

No discrete concentration, graph reconstruction, or continuum-GR claim
follows from A41d.
