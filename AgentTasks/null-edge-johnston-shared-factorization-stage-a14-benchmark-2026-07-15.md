# Null-edge Johnston shared-factorization Stage A14 benchmark

Date: 2026-07-15

## Question

Can one repair the incompatible local charts of Stage A13 by assigning one
spatial coordinate vector to every event and fitting all count-derived causal
distance constraints against those shared variables?

## Construction

`Scripts/experiments/causal_johnston_shared_factorization.py` retains
Johnston's count-derived time coordinate and comparable-pair spatial distance.
It selects one central Alexandrov interval at the frozen Stage A13 half-time
`0.25`, then fits a single spatial coordinate matrix by weighted stress.

The fit uses 80% training constraints. Endpoint constraints always remain in
training. Interior comparable pairs with at least two open-interval events
form the causal held-out set. A separate held-out sample of unrelated pairs
tests the inequality

```text
spatial distance >= absolute time difference.
```

Spatial ranks one through five are fitted independently. The smallest rank
within one standard error of the lowest held-out causal mean-square error is
selected. Known sprinkling coordinates are sealed off until post-selection
affine and causal-relation controls. No causal-operator metric or curvature
score is opened.

The factorization gate requires convergence, selected spatial rank three,
held-out causal relative RMSE at most `0.25`, and unrelated-pair violation
fraction at most `0.05`. The geometry gate additionally requires median local
affine error at most `0.25`, full rank-four local Jacobians, and causal
sensitivity and specificity at least `0.90`.

Dimension, density, global endpoints, local scale, candidate ranks, and all
thresholds remain supplied. The global Johnston chart is used only as an
order-derived numerical initialization and a post-fit baseline.

## Development

Artifact:
`AgentTasks/causal-johnston-shared-factorization-stage-a14-development-n2500-2026-07-15.json`

Five `N=2500` realizations used seed `20260812`. Three noncausal hinge
penalties were compared.

| penalty | median carrier | selected-rank counts | convergence | causal RMSE | unrelated violation | shared affine | baseline affine | sensitivity | specificity | gate passes |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 0.0 | 226 | 2:1, 4:1, 5:3 | 80% | 0.316 | 0.116 | 0.782 | 0.157 | 0.843 | 0.949 | 0% |
| 0.1 | 226 | 2:1, 4:3, 5:1 | 80% | 0.319 | 0.108 | 0.768 | 0.157 | 0.837 | 0.951 | 0% |
| 1.0 | 226 | 3:3, 4:2 | 80% | 0.332 | 0.093 | 0.727 | 0.138 | 0.845 | 0.956 | 0% |

Every factorization and geometry gate rate is zero. The frozen selection rule
therefore chooses penalty `0.0` by its slightly lower held-out causal error;
the affine controls and expected dimension do not influence that choice.

## Held-out test

Artifact:
`AgentTasks/causal-johnston-shared-factorization-stage-a14-heldout-n4000-2026-07-15.json`

Three fresh `N=4000` realizations used seed `20260817` and the frozen zero
penalty.

- median carrier count: `383`
- median causal training-pair count: `7379`
- median causal held-out-pair count: `511`
- selected spatial rank: `4` in all three realizations
- convergence rate: `2/3`
- median held-out causal relative RMSE: `0.190`
- median unrelated-pair violation fraction: `0.1025`
- median unrelated timelike-margin relative RMSE: `0.107`
- median shared-coordinate affine error: `0.497`
- median Johnston-initialization affine error: `0.113`
- median affine Jacobian condition number: `2.43`
- median causal sensitivity: `0.909`
- median causal specificity: `0.959`
- factorization and geometry gate rates: `0%`

The held-out causal-distance statistic alone improves and crosses its threshold.
That apparent success is rejected by three independent controls: every sample
selects four spatial dimensions, about ten percent of untouched unrelated
pairs become timelike, and the fit makes affine geometry more than four times
worse than its initialization. Full-rank local Jacobians do not rescue a
five-dimensional selected probe space.

## Verdict

Kill direct weighted partial-distance stress as the shared-coordinate bridge.
Giving each event one coordinate vector removes chart-transition ambiguity by
construction, but the objective absorbs count and time-coordinate distortions
into extra spatial directions and destroys the useful local geometry already
present in the Johnston initialization.

This is not a no-go for shared-event reconstruction. It rules out optimizing
comparable-pair Euclidean distance stress, even with untouched causal and
noncausal constraints and cross-validated rank. A successor needs an
independent geometric conditioning principle, not another penalty scan. The
most relevant next audit is an order-volume-chain well-conditioning test and
anchor scaffold, followed by reconstruction constrained by those anchors.
Madsen's 2026 approximate-isometry theorem supplies a timely external target
for that gate; it does not itself provide the missing reconstruction algorithm.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_johnston_shared_factorization.py`
- `python -m ruff check Scripts/experiments/causal_johnston_shared_factorization.py Scripts/experiments/test_causal_johnston_shared_factorization.py`
- Development and held-out commands, settings, seeds, per-rank errors, and
  per-realization results are retained in the JSON artifacts.

## Primary sources

- Steven Johnston, "Embedding Causal Sets into Minkowski Spacetime,"
  [arXiv:2111.09331](https://arxiv.org/abs/2111.09331).
- Steven Johnston, "Simpler Embeddings of Causal Sets into Minkowski
  Spacetime," [arXiv:2502.09701](https://arxiv.org/abs/2502.09701).
- Nathan Madsen, "On the Uniqueness of Embeddings of Causal Sets,"
  [arXiv:2607.05840](https://arxiv.org/abs/2607.05840).
