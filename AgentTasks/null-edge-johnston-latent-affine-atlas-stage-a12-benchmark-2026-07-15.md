# Null-edge Johnston latent-affine atlas Stage A12 benchmark

Date: 2026-07-15

## Questions

1. Why were Stage A11 local charts unavailable on some held-out targets?
2. After repairing availability, can a shared affine latent geometry reconcile
   the local Johnston charts without singular or ill-conditioned maps?

## Construction

`Scripts/experiments/causal_johnston_latent_affine_atlas.py` retains the
order-derived Stage A9 target chart but adds a causal-depth eligibility rule:
every nonpivot target must have at least six strict predecessors and six strict
successors. This uses only the causal relation and is applied before attempting
the rank-three local lightcone factorization.

All surviving charts are initialized by the Stage A11 overlap-weighted `O(3)`
synchronization. One pivot chart fixes the global gauge. The other charts are
fitted to a leave-one-chart-out latent consensus by affine least squares, with
a development-grid penalty toward the synchronized orthogonal maps.

The gate requires complete post-filter chart availability, at least 80% of all
pairwise edges, a connected graph, optimizer convergence, median common-event
geometry error at most `0.25`, maximum transform condition at most `10`, all
transform singular values in `[0.10,10]`, and affine cocycles below `1e-10`.
Metric and curvature scores remain closed.

Dimension, density, endpoints, rank three, all chart radii, the depth threshold,
and regularization remain supplied.

## Availability diagnosis

The unavailable Stage A11 targets were not random factorization failures. On
the previous held-out seed, every unavailable event had only one or two strict
predecessors or successors, so its lightcone could not support spatial rank
three. The distorted global MDS neighborhood had selected causal-boundary
events as apparent neighbors.

The retained post-hoc replay is
`AgentTasks/causal-johnston-latent-affine-atlas-stage-a12-selector-replay-n4000-2026-07-15.json`.
At `N=4000`, seed `20260805`, its median raw target count is `15`, median
eligible count is `9`, median retention is `0.692`, and all retained targets
have available charts with a complete pairwise graph. This replay diagnoses an
already opened seed and is not a new held-out pass.

## Development

Artifact:
`AgentTasks/causal-johnston-latent-affine-atlas-stage-a12-development-n2500-2026-07-15.json`

Five `N=2500` realizations used seed `20260806`, target radius `0.075`, overlap
radius `0.10`, depth threshold `6`, and four affine penalties.

| penalty | convergence rate | atlas pass rate | O(3) geometry | independent affine | joint affine | max condition | minimum singular value |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 0% | 0% | 0.508 | 0.432 | 0.400 | 8.184 | 0.115 |
| 0.01 | 60% | 0% | 0.508 | 0.432 | 0.460 | 1.483 | 0.669 |
| 0.10 | 60% | 0% | 0.508 | 0.432 | 0.502 | 1.054 | 0.949 |
| 1.00 | 100% | 0% | 0.508 | 0.432 | 0.508 | 1.005 | 0.995 |

All retained chart attempts succeed and every pairwise graph is complete. The
unregularized fit lowers the median residual but fails to converge in every
realization and individual samples develop condition above `24` and minimum
singular value near `0.016`. The frozen rule therefore selects penalty `1.0`,
the only setting with 100% convergence and uniformly stable maps.

## Held-out test

Artifact:
`AgentTasks/causal-johnston-latent-affine-atlas-stage-a12-heldout-n4000-2026-07-15.json`

Three fresh `N=4000` realizations used seed `20260807` and frozen penalty `1.0`.

- depth-filtered chart availability: `100%`
- pairwise edge fraction: `100%`
- fit convergence rate: `100%`
- median target count: `8`
- median synchronized `O(3)` geometry error: `0.442`
- median independently optimal affine residual: `0.381`
- median joint affine geometry error: `0.446`
- median maximum transform condition: `1.005`
- median minimum transform singular value: `0.996`
- median maximum affine cocycle residual: `2.2e-16`
- latent-affine atlas pass rate: `0%`

## Verdict

Retain the causal-depth target filter. It repairs a real order-side selector
defect and converts the previous chart-availability failure into complete
post-filter availability and overlap coverage.

Kill the current pivot-anchored affine latent consensus as a sufficient atlas
repair. Stable regularization leaves the geometric mismatch essentially
unchanged, while the lower-error unregularized route is nonconvergent and can
collapse spatial directions. Exact affine cocycles do not compensate for poor
common-event geometry.

The next atlas test must revise the local coordinate reconstruction itself,
most naturally through a multi-anchor interval embedding or a jointly factored
spacetime coordinate model. Metric transport, curvature, and curved-background
claims remain closed behind that gate.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_johnston_latent_affine_atlas.py`
- `python -m ruff check Scripts/experiments/causal_johnston_latent_affine_atlas.py Scripts/experiments/test_causal_johnston_latent_affine_atlas.py`
- Development, held-out, and diagnostic-replay settings and seeds are retained
  in the JSON artifacts above.
