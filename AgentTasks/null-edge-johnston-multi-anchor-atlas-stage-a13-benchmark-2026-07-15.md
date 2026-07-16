# Null-edge Johnston multi-anchor atlas Stage A13 benchmark

Date: 2026-07-15

## Question

Does replacing each single-pivot lightcone chart by a full Johnston embedding
of a count-derived local Alexandrov interval repair local coordinate covariance?

## Construction

`Scripts/experiments/causal_johnston_multi_anchor_atlas.py` applies the retained
Stage A12 causal-depth filter and caps the nearest eligible targets at twelve.
For every target and supplied anchor half-time it:

1. estimates proper time from the target to every causal predecessor and
   successor by interval counts;
2. selects the predecessor and successor nearest the requested half-time;
3. restricts to their full Alexandrov interval;
4. estimates the endpoint duration from counts;
5. reruns Johnston's full spatial-distance completion and MDS inside that local
   interval;
6. synchronizes the resulting spatial frames and scores their actual overlaps.

The transition gate requires complete chart availability, at least 80% edge
coverage, a connected graph, median synchronization mismatch and common-event
geometry error at most `0.15` and `0.25`, median embedding-coordinate affine
control at most `0.25`, and cocycle error at most `1e-10`. The full atlas gate
also requires at least 80% of charts to select spatial rank three by their
dominant eigenvalue gap.

Dimension, density, global endpoints, target radius and cap, rank three, local
endpoint scales, and all thresholds remain supplied. Metric and curvature
scores remain closed.

## Development

Artifact:
`AgentTasks/causal-johnston-multi-anchor-atlas-stage-a13-development-n2500-2026-07-15.json`

Five `N=2500` realizations used seed `20260808` and anchor half-times `0.15`,
`0.20`, and `0.25`.

| half-time | availability | median carrier | edge fraction | connected rate | synchronized geometry | local affine error | rank-three fraction | transition passes |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0.15 | 0.917 | 27.5 | 0.333 | 40% | 1.137 | 0.820 | 0.000 | 0% |
| 0.20 | 1.000 | 62.5 | 0.742 | 100% | 1.302 | 0.852 | 0.000 | 0% |
| 0.25 | 1.000 | 203.5 | 1.000 | 100% | 1.219 | 0.777 | 0.083 | 0% |

Every full-atlas pass rate is also zero. The frozen rule selects half-time
`0.25` because it is the only scale with complete availability and edge
coverage, despite its failed geometry and rank controls.

## Held-out test

Artifact:
`AgentTasks/causal-johnston-multi-anchor-atlas-stage-a13-heldout-n4000-2026-07-15.json`

Three fresh `N=4000` realizations used seed `20260811` and frozen half-time
`0.25`.

- median used target count: `12`
- chart availability: `100%`
- pairwise edge fraction: `100%`
- connected-graph rate: `100%`
- median local carrier count: `320`
- median independently optimal `O(3)` overlap residual: `1.074`
- median synchronization mismatch: `0.474`
- median synchronized common-event geometry residual: `1.153`
- median local affine-fit error against sprinkling coordinates: `0.673`
- median dominant rank-three fraction: `0.000`
- median synchronized cocycle maximum: `1.7e-15`
- transition and full-atlas pass rates: `0%`

## Verdict

Kill this particular local multi-anchor construction. Larger local intervals
solve availability and overlap coverage, but independently applying the
one-anchor min-plus spatial completion and MDS to each interval produces charts
that disagree more strongly than the Stage A10 lightcone charts. The failure is
already visible before synchronization in the independent overlap and local
affine controls, and density increase does not rescue it.

This is not a no-go for multi-anchor reconstruction. It rules out separate
local full-MDS embeddings with independently chosen count-derived endpoint
pairs. The next candidate must solve one joint spacetime factorization from
overlapping interval constraints, sharing event coordinates during the fit
rather than attempting to register incompatible embeddings afterward.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_johnston_multi_anchor_atlas.py`
- `python -m ruff check Scripts/experiments/causal_johnston_multi_anchor_atlas.py Scripts/experiments/test_causal_johnston_multi_anchor_atlas.py`
- Development and held-out commands, settings, and seeds are retained in the
  JSON artifacts above.
