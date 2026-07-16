# Stage A8: common-chart multi-row metric averaging

Date: 2026-07-15

## Question

Stage A7 independently validated the order-derived Johnston quadratic but
killed single-row trace rescaling.  Stage A8 asks whether the remaining
anisotropy and off-diagonal noise can be reduced by averaging several nearby
Benincasa-Dowker operator rows in one common recovered chart before applying
the quadratic trace condition.

This is the next flat-space part of the proposed pipeline

```text
C -> B_C -> Gamma_C -> g_C.
```

It is not a curvature or Einstein-dynamics test.

## Frozen architecture

The benchmark retains the Stage A7 settings

```text
events including endpoints: 10000
dimension: 4, supplied
density: supplied from the known interval volume
interval endpoints: supplied
spatial rank: 3, supplied
nonlocality scale L: 0.18
compact probe support: 0.65
metric-error thresholds: 0.50
```

For each sprinkling:

1. causal order and counting select the pivot and construct one Johnston
   lightcone chart;
2. candidate rows are all chart-visible events in the pivot's strict past
   whose recovered uncompact chart radius is at most the averaging radius;
3. the pivot is always included and there is no label-dependent row cap;
4. every selected operator row acts on the same compact coordinate and
   Johnston probe fields;
5. the corrected pairings are averaged in that common probe basis;
6. a best positive scalar is used only to score scale-free conformal shape;
7. only after that score, the independent Johnston quadratic supplies the
   trace factor `8 / mean(B_y q_{J,y})`.

The centered field is

```text
q_{J,y}(z) = (P^0(z)-P^0(y))^2
             - sum_i (P^i(z)-P^i(y))^2.
```

For every target row the implementation checks

```text
B_y q_{J,y} = 2 eta_ab Gamma_y(P^a, P^b).
```

The median relative residual is at machine precision in every tested radius.

The development run keeps all Johnston metric scores closed.  It uses only
coordinate-control metrics plus the Johnston scalar response.  A fresh seed
opens the Johnston metric once at the selected radius.

## Order-only row availability audit

Ten `N=10000` sprinklings were inspected before metric scoring.  The median
selected row counts, including the pivot, were:

| Radius | Median rows | Minimum | Maximum |
|---:|---:|---:|---:|
| 0.100 | 4.0 | 2 | 6 |
| 0.125 | 10.0 | 6 | 13 |
| 0.150 | 21.5 | 11 | 26 |
| 0.175 | 36.0 | 32 | 44 |
| 0.200 | 61.5 | 46 | 73 |

This fixed the development grid at radii
`0, 0.05, 0.075, 0.10, 0.125, 0.15, 0.175, 0.20`.

## Development selection

Artifact:

```text
AgentTasks/causal-johnston-multirow-metric-stage-a8-development-n10000-2026-07-15.json
```

Seed `20260727`, ten realizations.  Selection priority was:

1. maximum trace-normalized coordinate gate rate;
2. maximum coordinate conformal-shape gate rate;
3. minimum median trace-normalized error;
4. minimum median conformal-shape error.

| Radius | Median rows | Conformal passes | Median conformal error | Trace passes | Median trace error | Median `Bq` |
|---:|---:|---:|---:|---:|---:|---:|
| 0.000 | 1.0 | 20% | 0.650 | 10% | 1.020 | 2.240 |
| 0.050 | 1.0 | 10% | 0.650 | 10% | 1.020 | 2.210 |
| 0.075 | 2.0 | 20% | 0.700 | 10% | 1.040 | 1.890 |
| **0.100** | **4.0** | **20%** | **0.660** | **20%** | **0.970** | **1.490** |
| 0.125 | 8.5 | 10% | 0.820 | 10% | 1.410 | 1.130 |
| 0.150 | 17.0 | 0% | 0.960 | 0% | 2.960 | 0.650 |
| 0.175 | 32.0 | 0% | 0.990 | 0% | 6.000 | 0.360 |
| 0.200 | 56.5 | 0% | 1.000 | 0% | 12.740 | 0.150 |

Radius `0.10` was frozen for the held-out gate.  The sharp deterioration at
larger radii is already a kill for broad one-sided averaging in the pivot's
strict past.  At radius `0.15` and above, every averaged coordinate-control
matrix is negative definite.

## Held-out result

Artifact:

```text
AgentTasks/causal-johnston-multirow-metric-stage-a8-heldout-n10000-2026-07-15.json
```

Seed `20260728`, ten fresh realizations, frozen radius `0.10`.  The median row
count is `3.5`.

| Score | Pass rate | Median error |
|---|---:|---:|
| Coordinate conformal shape | 50% | 0.551 |
| Coordinate Johnston-trace normalized | 40% | 0.661 |
| Johnston pulled conformal shape | 30% | 0.569 |
| Johnston pulled trace normalized | 20% | 0.709 |

The raw pulled Johnston median error is `0.801`.  The median quadratic response
is `1.781`, giving a median trace factor `4.495`.  The local affine chart fit
remains controlled, with median fit error `0.083` and Jacobian condition
`1.170`.

No held-out median closes the `0.50` gate, and neither Johnston gate has a
majority of passing realizations.

## Paired diagnostic

After the held-out score was opened, the same sprinklings were rerun with the
pivot-only radius as a diagnostic control.  This comparison does not alter the
frozen selection or the gate verdict.

Artifact:

```text
AgentTasks/causal-johnston-multirow-metric-stage-a8-paired-control-n10000-2026-07-15.json
```

| Score | Pivot only | Radius 0.10 |
|---|---:|---:|
| Johnston conformal pass rate | 20% | 30% |
| Johnston conformal median error | 0.755 | 0.569 |
| Johnston trace pass rate | 10% | 20% |
| Johnston trace median error | 1.151 | 0.709 |
| Raw pulled Johnston median error | 0.778 | 0.801 |

Sparse averaging therefore reduces anisotropic shape noise after rescaling,
but does not improve the raw normalization and does not establish a stable
metric.

## Verdict

**Retain sparse common-chart averaging as a weak variance-reduction signal.**
On paired data, about four rows improve both the scale-free shape and the
independently trace-normalized pulled metric.

**Do not claim G2 closure.**  The selected held-out medians remain above the
frozen error threshold, the pass rates remain 30% and 20%, and the intrinsic
trace response remains far below eight.

**Kill the current broad one-sided neighborhood.**  Increasing the radius
systematically collapses the trace and drives the average to negative-definite
forms.  The likely finite-window mechanism is that every additional target is
in the pivot's past and therefore closer to the lower interval boundary.  This
is an interpretation of the data, not a proved cause.

The next estimator should not merely enlarge this neighborhood.  It needs one
of:

1. a common chart on a genuinely two-sided interior neighborhood;
2. an explicit finite-window or boundary correction for each operator row;
3. a regression that estimates and removes row bias before averaging.

Only after one of these closes the flat scale-free shape and concentration
gate should count-volume comparison or curved-background benchmarks begin.

## Files and checks

Implementation and tests:

```text
Scripts/experiments/causal_johnston_multirow_metric.py
Scripts/experiments/test_causal_johnston_multirow_metric.py
```

The implementation has tests for centered-quadratic vanishing, the exact
finite trace identity, nested target sets, relabeling equivariance, development
selection priority, and a finite small realization.  The generated JSON files
retain per-realization records for independent recomputation of every summary.
