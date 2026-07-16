# Null-edge Stage A44r2 measured scaling preregistration

**Status:** frozen before the `N=100000` resource run

## Question

Does the exact packed-relation implementation retain its measured quadratic
resource behavior at the first density large enough to calibrate a serious A44
development schedule?

This stage is resource-only. It does not open a continuum target, a held-out
seed, or a concentration verdict.

## Frozen settings

- seed: `20261530`;
- random events: `100000`;
- outer duration: `2.0`;
- primary compact cutoff `(0.02,0.08)` at `L/R=0.20`;
- minimum order-selected pivots: `16`, retaining all depth ties;
- relation blocks: `32 x 4096`;
- popcount block: `128`;
- disk-backed temporary packed relation, deleted after measurement;
- comparison baseline: the frozen A44r `N=20000` measurement.

## Gate

1. Raw relation size equals `n*ceil(n/8)` and the temporary volume has at least
   twice that free before construction.
2. At least 16 tied-depth pivots are selected and all six responses are finite.
3. Build and regional-response times are each no more than three times the
   quadratic A44r prediction, including the pivot-count factor for responses.
4. The refined `N=400000`, 256-pivot extrapolation remains below `24 GiB` and
   12 hours.

Passing closes only the reusable-count resource precondition. A physical A44N
development schedule must still be separately frozen and must retain the full
same-graph covariance ledger. `N=400000` remains unauthorized.
