# Null-edge Stage A32 rowwise shape-first-jet benchmark

**Status:** completed kill test; first-jet gate remains closed  
**Date:** 2026-07-15

## Question

A31 showed that neither a zero nor an exact scale gradient repairs the fused
first jet. A32 asks whether the failure comes from applying the nonlinear A29
response correction and determinant normalization after fitting noisy affine
metric and moment fields.

The alternative applies both operations independently to every local operator
row and fits the resulting unit-volume shapes afterward.

## Locked protocol

- A29 temporal response weight: `0.6`.
- A28 operator schedule: `(cL,cS,cA)=(0.75,1.8,1.1)`.
- A24 count schedule: `(cW,cC)=(0.65,1.2)`.
- A31 count-gradient penalty: `0.1`.
- No new target-tuned parameter or curved selector.
- A row is retained only when its raw metric is Lorentzian and its retarded
  moment is timelike. Both conditions are invariant under invertible affine
  probe changes.

Unit tests check exact cancellation of a conformal row factor, rejection of a
non-Lorentzian row, and covariance under a determinant-one probe change.

## Results

| Density | Background | retained rows | post-fit pivot error | rowwise pivot error | post-fit shape-jet error | rowwise shape-jet error | rowwise signature rate |
|---|---:|---:|---:|---:|---:|---:|---:|
| 4000 | H=0.0 | 71.9% | 0.159 | 0.937 | 7.120 | 7.169 | 20% |
| 4000 | H=0.1 | 80.5% | 0.148 | 0.589 | 5.359 | 5.059 | 40% |
| 4000 | H=0.2 | 73.4% | 0.228 | 0.789 | 5.373 | 7.217 | 20% |
| 8000 | H=0.0 | 79.9% | 0.159 | 0.558 | 3.413 | 5.770 | 25% |
| 8000 | H=0.1 | 74.2% | 0.131 | 1.327 | 4.780 | 14.952 | 0% |
| 8000 | H=0.2 | 79.1% | 0.167 | 0.843 | 3.517 | 7.634 | 0% |

The rowwise operation loses roughly `20%-30%` of the observations before the
fit. More seriously, it destroys the A29 pivot-tensor gain: median shape error
rises from `0.131-0.228` to `0.558-1.327`. Refinement does not restore stable
signature or reduce the shape jet uniformly.

## Verdict

This implementation is killed. Individual operator rows are too noisy for a
nonlinear correction and determinant normalization before aggregation.
Invariant filtering does not cure the resulting selection and normalization
noise.

The correction must remain at the stable aggregate-tensor level. The next
first-jet control should fit the tangent derivative around that aggregate with
explicit trace/shape constraints. A nonzero-shape-jet calibration must come
from a known nonlinear coordinate transformation of flat spacetime, not from
curved target tuning or from shrinking every derivative toward zero.

Connection and curvature remain closed. Coordinates, density, dimension,
probes, windows, and response normalization are still supplied.

## Artifacts

- `Scripts/experiments/causal_rowwise_shape_first_jet.py`
- `Scripts/experiments/test_causal_rowwise_shape_first_jet.py`
- `AgentTasks/causal-rowwise-shape-first-jet-stage-a32-heldout-n4000-2026-07-15.json`
- `AgentTasks/causal-rowwise-shape-first-jet-stage-a32-heldout-n8000-2026-07-15.json`
