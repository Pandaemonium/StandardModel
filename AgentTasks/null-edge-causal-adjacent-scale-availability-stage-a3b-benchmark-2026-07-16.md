# Stage A3b: adjacent-scale availability benchmark

## Objective

Determine whether the Stage A3 failure to produce an adjacent selector-scale
window was intrinsic to the finite causal order or partly caused by scanning
fixed fractions of the supplied operator scale `L`. This is an order-only
external numerical oracle, not a proof or a continuum result.

The benchmark deliberately stops before constructing a generalized spectral
cluster. Its only question is whether a common two-sided interior and a
rank-capable retarded shell are available at all three scales.

## Frozen change

Stage A3 used fixed values of `s/L`. Stage A3b changes only the scale schedule.
For discreteness scale `ell`, operator scale `L`, and adjacent ratio `r`, it
sets

```text
s = sqrt(ell * L)
scales = (s/r, s, r*s).
```

The geometric mean maximizes the smaller multiplicative clearance to `ell`
and `L`. The strict hierarchy

```text
ell < s/r < s < r*s < L
```

therefore exists exactly when

```text
L / ell > r^2.
```

With `ell = (V/N)^(1/4)`, this is the analytic event-count condition

```text
N > V r^8 / L^4.
```

For the frozen `duration = 1`, `L = 0.18`, and `r = 1.25`, the continuous
threshold is `N > 743.2393838678859`. Thus `N = 400` could not have supported
the requested scale triple under any central-scale choice; `N = 800` has only
`0.9%` multiplicative clearance at each end.

All count-side parameters remain frozen at the best Stage A3 tuple:

```text
interior band = [0.5, 2]
interior abundance threshold = 0.25
retarded shell band = [0.5, 4]
minimum shell cardinality = 4
availability threshold = 0.80
```

For every realization, the experiment intersects the three two-sided
interiors. At every common mark it counts retarded-shell points separately at
all three scales. A mark is rank-capable only if every shell has at least four
points. No embedding coordinate, target metric, signature, affine score, or
four-mode truncation enters the construction or gate.

Implementation and tests:

```text
Scripts/experiments/causal_adjacent_scale_availability.py
Scripts/experiments/test_causal_adjacent_scale_availability.py
```

## Development result

Ten independent realizations were run at each development density for which
the analytic hierarchy exists. The `N = 400` row was rejected before
sprinkling.

| N | hierarchy | common-interior realizations | median common marks | all shells nonempty | all shells >= 4 | realizations with any capable mark | gate |
|---:|---|---:|---:|---:|---:|---:|---|
| 400 | absent | not run | - | - | - | - | fail |
| 800 | present | 100% | 87.5 | 1.33% | 0.33% | 20% | fail |
| 1200 | present | 100% | 232.5 | 7.63% | 2.49% | 100% | fail |

The per-scale shell medians expose the bottleneck:

| N | `s/r` shell median | `s` shell median | `r*s` shell median |
|---:|---:|---:|---:|
| 800 | 14 | 0 | 0 |
| 1200 | 20 | 1 | 0 |

The hierarchy and common interior have therefore been recovered, but a mark
sampled uniformly from that common interior almost never has a rank-capable
shell at all three scales. The largest-scale shell is the dominant failure.

Machine-readable development output:

```text
AgentTasks/causal-adjacent-scale-availability-stage-a3b-2026-07-16.json
```

## Exploratory density extension

Three frozen, order-only realizations at `N = 2400` were run to check the scale
of the trend. This small sample is diagnostic, not a validation pass:

| N | endpoint clearance | median common marks | all shells nonempty | all shells >= 4 | largest-shell median |
|---:|---:|---:|---:|---:|---:|
| 2400 | 15.8% | 509 | 7.13% | 3.23% | 0 |

The rank-capable mark rate is only slightly above the `N = 1200` result and
remains far below `0.80`. Although each exploratory realization contains at
least one capable mark, selecting such a rare mark would require an additional
order-side rule and would not satisfy the frozen randomized-mark availability
gate.

Machine-readable exploratory output:

```text
AgentTasks/causal-adjacent-scale-availability-stage-a3b-n2400-exploratory-2026-07-16.json
```

## Verdict

**The scale-scheduling part of the Stage A3 diagnosis is repaired.** A strict
adjacent hierarchy is analytically available above a known finite-density
threshold, and common interiors occur in every evaluated realization.

**The support sector still fails.** Same-scale interior restriction leaves the
largest retarded shell empty for the median common mark at every evaluated
density. The all-three-scale rank-capable mark rate is `0.33%`, `2.49%`, and
`3.23%` at `N = 800, 1200, 2400`, far below the frozen `80%` threshold.

Do not launch the generalized-cluster eigensolver on this shell definition.
Doing so would spend spectral complexity on a sector that is absent at almost
every order-selected mark.

## Next decision

The next experiment should isolate the boundary mechanism with one frozen
change:

1. enlarge the Alexandrov interval while holding `ell`, `L`, `r`, and all
   count bands fixed, scaling `N` with volume;
2. if the largest-shell median remains zero, reject same-scale source
   interiority and pre-register one nested-interior boundary rule;
3. optimize the all-pairs count implementation before higher-density scans;
4. construct the generalized eigensolver only after the randomized-mark shell
   availability gate passes.

This result does not weaken the corrected causal-operator pairing or its
coordinate-probe calibration. It narrows the unresolved G2 bridge to an
intrinsic boundary/support construction.

## Verification commands

```text
cd Scripts/experiments
python -m py_compile causal_adjacent_scale_availability.py test_causal_adjacent_scale_availability.py
python -m unittest test_causal_adjacent_scale_availability.py
ruff check causal_adjacent_scale_availability.py test_causal_adjacent_scale_availability.py
python causal_adjacent_scale_availability.py --realizations 10 --output ../../AgentTasks/causal-adjacent-scale-availability-stage-a3b-2026-07-16.json
python causal_adjacent_scale_availability.py --events 2400 --realizations 3 --seed 2026071601 --output ../../AgentTasks/causal-adjacent-scale-availability-stage-a3b-n2400-exploratory-2026-07-16.json
```
