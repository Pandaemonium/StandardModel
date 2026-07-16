# Null-edge Stage A43 low-epsilon concentration development audit

**Date:** 2026-07-15

## Verdict

**INVALID SUCCESSOR; HELD-OUT UNOPENED.** The implementation and development
run are valid, but three of four finite continuum targets are non-Lorentzian.
The preregistration omitted an explicit target-signature precondition. A43 was
stopped rather than allowing accurate concentration onto the wrong symbol to
count as progress.

## Development evidence

At `N=20000`, eight development realizations give:

| cutoff | `L/R` | `ell/L` | quadratic error | metric error | lower error | target `Delta_ps` | signature-match rate |
|---|---:|---:|---:|---:|---:|---:|---:|
| primary | 0.30 | 0.34 | 0.10 | 0.10 | 0.06 | 1.00 | 0.88 |
| primary | 0.25 | 0.40 | 0.31 | 0.27 | 0.53 | 0.10 | 0.62 |
| robustness | 0.30 | 0.34 | 0.14 | 0.17 | 0.11 | 1.00 | 1.00 |
| robustness | 0.25 | 0.40 | 0.57 | 0.44 | 0.27 | 1.00 | 0.75 |

The apparently good `0.30` concentration is concentration around a negative-
definite target, not Lorentz recovery. Only the primary `0.25` target is
Lorentzian, and its development metric gate fails.

## Consequence

At this density, the low-noise window selected by the exact diagonal audit and
the two-profile Lorentzian finite-mean window do not overlap. Increasing `L`
is therefore not an admissible repair for A42. The next route must keep `L/R`
inside the Lorentzian mean window while lowering `ell` much more aggressively,
or define and analyze a same-graph mesoscopic average that suppresses variance
without changing the operator scale.

Development artifact:
`AgentTasks/causal-discrete-germ-concentration-stage-a43-development-2026-07-15.json`.

There is deliberately no A43 held-out artifact.
