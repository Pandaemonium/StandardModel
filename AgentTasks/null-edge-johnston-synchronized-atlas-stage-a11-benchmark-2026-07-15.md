# Null-edge Johnston synchronized-atlas Stage A11 benchmark

Date: 2026-07-15

## Question

Can simultaneous synchronization of all overlapping Johnston spatial frames
repair the transition failure seen under independent pivot-based Procrustes
registration in Stage A10?

## Construction

`Scripts/experiments/causal_johnston_synchronized_atlas.py` retains the Stage
A10 order-derived local lightcone charts and the Stage A9 full-chart target
selector. It fits every available pairwise `O(3)` overlap, builds an
overlap-weighted connection Laplacian, takes its three lowest modes, projects
each chart block back to `O(3)`, and fixes the remaining global gauge at the
order-selected pivot.

The synchronized transitions obey their triangle cocycles algebraically. That
is not counted as a physical pass. Each synchronized transition is scored again
on the original common chart events, and the atlas gate additionally requires
complete chart availability, a connected overlap graph, at least 80% of all
target-pair edges, median overlap-geometry error at most `0.25`, median
synchronization mismatch at most `0.15`, and maximum cocycle error at most
`1e-10`.

Dimension four, density, interval endpoints, rank three, target radius, and
registration radii remain supplied. Embedding coordinates generate the causal
order but are not used to fit transitions. Metric scores remain closed.

## Development

Artifact:
`AgentTasks/causal-johnston-synchronized-atlas-stage-a11-development-n2500-2026-07-15.json`

Five `N=2500` realizations used seed `20260804`, target radius `0.075`, and
registration radii `0.10`, `0.15`, `0.20`, and `0.30`.

| registration radius | atlas pass rate | median availability | median edge fraction | independent residual | sync mismatch | synchronized geometry |
|---:|---:|---:|---:|---:|---:|---:|
| 0.10 | 0% | 1.000 | 0.997 | 0.542 | 0.130 | 0.563 |
| 0.15 | 0% | 1.000 | 0.997 | 0.542 | 0.130 | 0.563 |
| 0.20 | 0% | 1.000 | 0.997 | 0.558 | 0.159 | 0.596 |
| 0.30 | 0% | 1.000 | 0.997 | 0.618 | 0.258 | 0.693 |

The maximum synchronized cocycle residual stays near `2e-15`. Radius `0.10`
was selected by the frozen rule because it has the lowest synchronized
overlap-geometry residual among tied zero-pass settings.

## Held-out test

Artifact:
`AgentTasks/causal-johnston-synchronized-atlas-stage-a11-heldout-n4000-2026-07-15.json`

Three independent `N=4000` realizations used seed `20260805`, target radius
`0.075`, and the frozen registration radius `0.10`.

- synchronized-atlas pass rate: `0%`
- median target count: `15`
- median chart availability: `0.692`
- median target-pair edge fraction: `0.462`
- connected available-chart graph rate: `100%`
- median independent pairwise residual: `0.344`
- median synchronization mismatch: `0.049`
- median synchronized overlap-geometry residual: `0.349`
- median maximum synchronized cocycle residual: `1.4e-15`

## Verdict

Simultaneous `O(3)` synchronization successfully separates gauge inconsistency
from chart geometry: it produces one globally coherent spatial gauge with tiny
cycle error and small held-out edge mismatch. It does not make the local
Johnston coordinates agree on their common events, and it cannot repair missing
rank-three charts. The frozen atlas gate therefore remains closed.

Kill simultaneous frame synchronization as a sufficient repair for the Stage
A10 atlas. Retain the connection-Laplacian diagnostic. The next test should fit
a shared latent overlap geometry or modify the local multi-anchor embedding,
with availability and geometric residuals scored before reopening transported
metric or curvature observables.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_johnston_synchronized_atlas.py`
- `python -m ruff check Scripts/experiments/causal_johnston_synchronized_atlas.py Scripts/experiments/test_causal_johnston_synchronized_atlas.py`
- Exact development and held-out commands are encoded in the retained JSON
  settings and seeds above.
