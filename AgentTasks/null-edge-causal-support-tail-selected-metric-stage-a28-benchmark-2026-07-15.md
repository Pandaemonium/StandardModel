# Null-edge expanded-support tail-selected metric Stage A28 benchmark

Date: 2026-07-15

## Question

Does the operator-shape failure come primarily from compact-probe truncation,
and can a selector that controls signature tails, row support, and conditioning
produce a density-stable conformal representative?

## Flat-only selection

Two new flat development grids scan

```text
cL in {0.55, 0.65, 0.75}
cS in {1.2, 1.4, 1.6, 1.8}
cA in {0.9, 1.1}
```

at `N=4000` and `N=8000`. The selector prioritizes minimum signature rate,
worst individual unit-volume shape error, minimum row-support fraction, worst
design condition, and only then median shape error. No curved score enters.

The frozen setting is

```text
cL = 0.75, cS = 1.8, cA = 1.1.
```

It has development signature rate `1.0`, full row support, worst individual
shape error `0.539`, worst median shape error `0.293`, and worst design
condition `18.35`.

## Fresh evaluation

Artifacts:

- `AgentTasks/causal-support-tail-selected-fused-metric-stage-a28-heldout-n4000-2026-07-15.json`
- `AgentTasks/causal-support-tail-selected-fused-metric-stage-a28-heldout-n8000-2026-07-15.json`

| `N` | `H` | signature rate | median fused metric error | ensemble error | oracle-volume error | count-volume mismatch | first-jet error |
|---:|---:|---:|---:|---:|---:|---:|---:|
| `4000` | `0.0` | `1.00` | `0.349` | `0.276` | `0.039` | `0.081` | `6.713` |
| `4000` | `0.1` | `1.00` | `0.312` | `0.265` | `0.126` | `0.070` | `6.772` |
| `4000` | `0.2` | `1.00` | `0.363` | `0.403` | `0.019` | `0.030` | `8.630` |
| `8000` | `0.0` | `1.00` | `0.341` | `0.333` | `0.058` | `0.142` | `4.375` |
| `8000` | `0.1` | `1.00` | `0.366` | `0.342` | `0.084` | `0.053` | `4.039` |
| `8000` | `0.2` | `1.00` | `0.418` | `0.411` | `0.066` | `0.165` | `3.528` |

All `27` fresh metrics are Lorentzian and every operator regression saturates
its row cap. This repairs A26-A27's signature tails. Tensor errors remain in a
narrow `0.31-0.42` band instead of decreasing uniformly.

## Verdict

**Retain expanded support and tail/conditioning selection.** They stabilize
signature and local regression support across density and curvature.

**Do not claim tensor convergence.** The remaining mean metric is nearly
diagonal but its temporal response is approximately twice the spatial response.
Expanded support removes tail instability, not this systematic kernel bias.

**Keep the first-jet gate closed.** It improves with density but remains much
larger than the tensor error. The next stage must correct the finite response
covariantly before differentiating it.

## Verification

- `python -m pytest -q Scripts/experiments/test_causal_support_tail_selected_fused_metric.py Scripts/experiments/test_causal_operator_count_fused_metric.py`
- `python -m ruff check Scripts/experiments/causal_support_tail_selected_fused_metric.py Scripts/experiments/test_causal_support_tail_selected_fused_metric.py`

## Provenance

- A23-A27 for the shrinking schedule, shape objective, and failed median-only
  selectors.
- A24-A25 for count-volume fusion.
- The tail/row selector is a program-internal finite-density audit.
