# Null-edge Stage A41e finite-target extension benchmark

**Date:** 2026-07-15

## Verdict

**PASS as target generation, but scientifically excludes the proposed A43
window.** Every coefficient and order-`160/240` quadrature check passes. The
finite targets reveal that increasing `L/R` enough to lower A42 noise also
allows boundary contamination to destroy the Lorentzian principal symbol in
three of four strata.

| cutoff | `L/R` | `B1` | `Bt` | `Btt` | `Bxx` | metric error | `Delta_ps` | signature |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| primary | 0.30 | -7.21 | 5.80 | -1.09 | -0.80 | 0.93 | 1.00 | `(0,4,0)` |
| primary | 0.25 | -3.37 | 2.25 | 1.53 | -1.25 | 0.35 | 0.10 | `(1,3,0)` |
| robustness | 0.30 | -7.95 | 6.70 | -1.73 | -0.61 | 1.11 | 1.00 | `(0,4,0)` |
| robustness | 0.25 | -10.78 | 6.19 | -0.45 | -1.12 | 0.72 | 1.00 | `(0,4,0)` |

Artifact:
`AgentTasks/causal-continuum-kernel-moments-stage-a41e-2026-07-15.json`.

No random concentration or continuum result follows from A41e.
