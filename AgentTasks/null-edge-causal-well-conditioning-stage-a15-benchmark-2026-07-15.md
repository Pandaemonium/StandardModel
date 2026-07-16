# Null-edge causal well-conditioning Stage A15 benchmark

Date: 2026-07-15

## Question

Do flat Poisson sprinklings satisfy finite sampled versions of the three
well-conditioning conditions used by Madsen's 2026 approximate-isometry
theorem, and can the current order-derived Johnston chart expose the required
well-conditioned 3+1 anchor scaffold?

## Construction and scope

`Scripts/experiments/causal_well_conditioning_audit.py` keeps two logically
different tests separate.

The **embedding audit** uses the known synthetic embedding, as the definition
of a well-conditioned embedding requires:

1. F1 checks exact agreement between the causal relation and the relation
   induced by the embedded coordinates.
2. F2 samples 24 deep-interior causal diamonds at each proper-time scale
   `0.25`, `0.30`, `0.35`, and `0.40`, comparing open-interval count with
   `rho c_4 tau^4`.
3. F3 computes the exact longest-chain edge count in every sampled interval.
   Development estimates one dimensionless coefficient in
   `H/(rho^(1/4) tau)`; held-out tests use that value unchanged.

This is a sampled finite-density surrogate. It does not prove Madsen's uniform
F2 and F3 bounds over every admissible continuum diamond.

The separate **intrinsic scaffold audit** uses no sprinkling coordinate during
selection. It builds the full order-derived Johnston chart, chooses an
order-derived deep pivot, and assigns five distinct events nearest Madsen's
ideal anchor offsets at supplied scales. It then tests normalized proximity,
the smallest singular value and condition number of the 4 by 4 anchor frame,
strict lower-to-upper chronology, active-ball event count, and the fraction of
active events causally bracketed by every anchor.

The F2 gate requires p90 relative count error at most `0.60` and p90
Poisson/log-standardized error at most `1.0`. The F3 gate requires p90 relative
chain-time error at most `0.35` and scale-to-scale coefficient spread at most
`0.20`. The scaffold gate requires normalized proximity at most `1.50`,
normalized minimum singular value at least `0.25`, frame condition at most
`50`, at least eight active events, and causal coverage at least `0.95`.

Dimension, density, global endpoints, scale windows, and thresholds remain
supplied. Metric and curvature scores remain closed.

## Development

Artifact:
`AgentTasks/causal-well-conditioning-stage-a15-development-n2500-2026-07-15.json`

Five `N=2500` realizations used seed `20260820`. The development-only median
longest-chain coefficient is

```text
mu_4 = 1.05051433598341.
```

Every realization passes sampled F1, F2, and F3. Aggregated medians are:

- count relative error: median `0.130`, p90 `0.342`
- count Poisson/log-standardized p90: `0.548`
- chain-time relative error: median `0.095`, p90 `0.271`
- chain coefficient scale spread: `0.054`

The intrinsic scaffold gate fails at every scale:

| scaffold scale | active events | proximity / scale | min singular / scale | condition | causal coverage | pass rate |
|---:|---:|---:|---:|---:|---:|---:|
| 0.03 | 6 | 1.60 | 0.68 | 48.6 | 0.50 | 0% |
| 0.04 | 18 | 1.89 | 0.63 | 49.5 | 0.72 | 0% |
| 0.05 | 42 | 2.53 | 0.22 | 130.5 | 0.905 | 0% |

The frozen selection chooses `0.05` because it has the best causal coverage,
despite failed proximity, singular-value, condition-number, and coverage
thresholds. No oracle coordinate control enters this selection.

## Held-out test

Artifact:
`AgentTasks/causal-well-conditioning-stage-a15-heldout-n4000-2026-07-15.json`

Three fresh `N=4000` realizations used seed `20260825`, frozen coefficient
`1.05051433598341`, and frozen scaffold scale `0.05`.

The sampled embedding audit again passes in every realization:

- F1 pass rate: `100%`
- F2 pass rate: `100%`
- F3 pass rate: `100%`
- median count relative error: `0.095`
- median count relative p90: `0.267`
- median count Poisson/log-standardized p90: `0.527`
- median chain-time relative error: `0.100`
- median chain-time relative p90: `0.238`
- median chain coefficient scale spread: `0.087`

The intrinsic scaffold still has zero passes:

- median active event count: `32`
- median normalized anchor proximity: `2.22`
- median normalized minimum singular value: `0.162`
- median frame condition number: `182.7`
- median active-ball causal coverage: `0.969`

Higher density improves count errors and causal coverage, but it does not
repair the recovered frame. The frame moves closer to rank loss and becomes
more ill-conditioned.

## Verdict

**Retain the F1/F2/F3 scale window as positive conditional evidence.** Flat
Poisson sprinklings pass the sampled order, count-volume, and frozen
longest-chain proper-time gates at both densities. This supplies a concrete
manifoldlikeness component and a density-calibrated timelike scale observable.
It does not establish uniform well-conditioning or derive density from a bare
graph.

**Kill nearest-ideal-anchor selection in the current Johnston chart.** The
order-derived chart finds anchors whose cones almost cover the active ball,
but their frame is not a stable tetrad. Causal coverage alone is therefore no
more sufficient for tetrad reconstruction than held-out causal stress was for
metric reconstruction in Stage A14.

The next anchor candidate should be selected directly for combinatorial
trilateration conditioning, using independent past/future anchors and a
max-volume or smallest-singular-value objective, rather than proximity in a
distorted global chart. It must freeze that objective before any metric or
sprinkling-coordinate control is opened.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_well_conditioning_audit.py`
- `python -m ruff check Scripts/experiments/causal_well_conditioning_audit.py Scripts/experiments/test_causal_well_conditioning_audit.py`
- Development and held-out commands, settings, per-realization gates, and
  frozen values are retained in the JSON artifacts.

## Primary source

- Nathan Madsen, "On the Uniqueness of Embeddings of Causal Sets,"
  [arXiv:2607.05840](https://arxiv.org/abs/2607.05840), especially Definition
  2.6, the anchor-scaffold lemma, Lorentzian trilateration identity, and
  approximate-isometry theorem.
