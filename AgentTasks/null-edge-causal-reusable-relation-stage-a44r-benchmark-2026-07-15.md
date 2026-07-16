# Null-edge Stage A44r reusable-relation resource benchmark

## Verdict

**PROTOTYPE PASS; LARGE RUN NOT AUTHORIZED.** The bit-packed transitive
relation preserves exact A42/A44 count semantics and removes repeated causal
predicate construction for regional pivots. The frozen development run passed
every exactness and resource threshold.

## Measured results

| random events | selected pivots | raw cache | build | regional responses |
|---:|---:|---:|---:|---:|
| 5000 | 9 | 3,131,878 B | 0.863 s | 0.0067 s |
| 10000 | 9 | 12,513,753 B | 3.181 s | 0.0294 s |
| 20000 | 8 | 50,027,503 B | 12.925 s | 0.0792 s |

The first selected `N=5000` pivot exactly matches the direct predecessor,
global-depth, and open-interval counts. All six polynomial response channels
are finite. Raw file size is exactly `n*ceil(n/8)` at every density. The
conservative scratch bound for the frozen two-dimensional construction block
is `5,373,952` bytes.

## Extrapolation boundary

Quadratic extrapolation from the highest measured density to `N=400000` and
256 pivots gives:

- raw packed relation: `20,000,550,003` bytes, about `18.63 GiB`;
- construction: `5,169 s`;
- 256 regional responses: `1,014 s`;
- total: `6,183 s`, about `1.72 h`.

This is an explicit engineering estimate, not a scaling theorem. It omits
filesystem degradation, covariance realizations, and physical scoring. The
large run remains closed pending a measured `N=100000` calibration, a frozen
physical schedule, and full same-graph covariance analysis.

Machine-readable artifact:
`AgentTasks/causal-reusable-relation-stage-a44r-2026-07-15.json`.

## Claim boundary

This result advances feasibility only. It does not show that regional rows
concentrate, recover a Lorentzian metric, derive scale, or approximate GR.
