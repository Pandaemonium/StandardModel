# Null-edge Stage A44t off-center finite-target benchmark

## Verdict

**TARGET GENERATION PASS; CENTER-TARGET REUSE FAIL.** The relative-null
quadrature is stable and retains Lorentzian signature at every frozen
displacement. The A41d center target is nevertheless not an admissible target
for a regional pivot set.

## Results

| pivot | six-channel shift | relative metric shift | signature |
|---|---:|---:|---:|
| center | 0.000 | 0.000 | `(1,3,0)` |
| time `-0.05` | 0.090 | 0.019 | `(1,3,0)` |
| time `+0.05` | 0.338 | 0.119 | `(1,3,0)` |
| space `0.05` | 0.009 | 0.027 | `(1,3,0)` |
| space `0.10` | 0.034 | 0.063 | `(1,3,0)` |
| space `0.15` | 0.072 | 0.100 | `(1,3,0)` |
| mixed `-0.05,+0.10` | 0.166 | 0.056 | `(1,3,0)` |
| mixed `+0.05,+0.10` | 0.307 | 0.114 | `(1,3,0)` |

Every low/high maximum operator difference is below `0.02`, and every metric
Frobenius difference is below `0.02`. The center evaluation independently
reproduces the symmetric A41 quadrature, including its nonzero finite
temporal-affine boundary response.

## Interpretation

The asymmetry between pastward and futureward time displacements is expected
for a retarded operator inside a compact outer taper. It is finite boundary
bias, not stochastic noise. A regional average must therefore subtract or
compare with one continuum target per selected pivot before its covariance is
interpreted as concentration.

Machine-readable artifact:
`AgentTasks/causal-offcenter-target-stage-a44t-2026-07-15.json`.

This audit uses deterministic coordinate-oracle pivots only. It does not
select graph pivots or establish a graph limit.
