# Null-edge Stage A35 spread-row fused first-jet benchmark

**Status:** completed positive conditional first-jet control; convergence not established  
**Date:** 2026-07-15

## Question

A34 selects a nonzero shape-jet response using only exact flat nonlinear-chart
controls. A35 freezes that choice and asks whether the full count-scaled inverse
metric and its first jet remain controlled on fresh flat and conformally curved
samples.

## Frozen inputs

- A34 averaging multiplier `1.7` and tangent weight `0.2`.
- A29 response weight `0.6`.
- A31 count-gradient penalty `0.1`.
- A24 count scale and the existing support/operator schedule.
- No curved result enters parameter selection.

## Held-out results

All entries below are medians except the ensemble column.

| density | H | rows | pivot shape | pivot metric | raw shape jet | selected shape jet | zero full jet | selected full jet | unweighted full jet | oracle-scale full jet | ensemble full jet | count gradient |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 4000 | 0.0 | 253 | 0.099 | 0.110 | 2.664 | 0.533 | 0.358 | 0.698 | 2.938 | 0.565 | 0.571 | 0.357 |
| 4000 | 0.1 | 253 | 0.149 | 0.148 | 2.252 | 0.450 | 0.459 | 0.630 | 2.280 | 0.479 | 0.527 | 0.452 |
| 4000 | 0.2 | 253 | 0.108 | 0.131 | 2.167 | 0.433 | 0.407 | 0.653 | 2.333 | 0.442 | 0.417 | 0.399 |
| 8000 | 0.0 | 358 | 0.060 | 0.060 | 1.798 | 0.360 | 0.306 | 0.453 | 1.822 | 0.360 | 0.363 | 0.306 |
| 8000 | 0.1 | 358 | 0.081 | 0.105 | 1.619 | 0.324 | 0.402 | 0.556 | 1.670 | 0.316 | 0.459 | 0.401 |
| 8000 | 0.2 | 358 | 0.069 | 0.103 | 1.727 | 0.345 | 0.562 | 0.674 | 1.946 | 0.344 | 0.514 | 0.562 |

Every fused metric has signature `(1,3,0)`. The selected shape-jet error is
below `0.54` in every cell and improves at doubled density in all three
backgrounds. The selected full-jet median is below `0.70` everywhere. The raw
and unweighted shape derivatives are much worse.

The full jet does not improve uniformly: the `H=0.2` median rises from `0.653`
to `0.674`, tracking deterioration in the count gradient. Replacing the scale
jet by the target value gives `0.316-0.565`, which localizes much of the
remaining curved error to the count-scale derivative rather than the recovered
shape derivative.

## Verdict

A35 is the first positive conditional first-jet result in the pipeline. It
supports constructing a provisional Levi-Civita connection from one common
reconstructed metric field and its derivative.

This is not a convergence theorem and not a bare-graph result. Coordinates,
dimension, probes, windows, density calibration, response normalization, and
spread selection are supplied. The zero-tangent estimator is numerically
smaller in several curved cells but is physically inadmissible because A34
requires response to exact nonzero chart jets. Curvature remains closed pending
connection control and a second-derivative protocol.

## Artifacts

- `Scripts/experiments/causal_spread_fused_first_jet.py`
- `Scripts/experiments/test_causal_spread_fused_first_jet.py`
- `AgentTasks/causal-spread-fused-first-jet-stage-a35-heldout-n4000-2026-07-15.json`
- `AgentTasks/causal-spread-fused-first-jet-stage-a35-heldout-n8000-2026-07-15.json`
