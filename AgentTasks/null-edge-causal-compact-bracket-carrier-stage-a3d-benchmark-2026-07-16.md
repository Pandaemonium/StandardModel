# Stage A3d: compact count-balanced bracket carrier gate

## Objective and claim boundary

Stage A3d tests whether the infrared-dependent global shell killed in A3c can
be replaced by a compact, order-derived Alexandrov bracket around each marked
event. Brackets, carriers, induced interiors, and retarded support use only the
causal relation and inclusive interval counts. Coordinates are reopened only
after selection for a declared metric control.

This is an external finite numerical oracle. It is not a continuum theorem,
a G2 pass, or an intrinsic tetrad reconstruction.

## Frozen selector

For `p < x < q`, let `a=C(p,x)`, `b=C(x,q)`, and `c=C(p,q)` be inclusive
interval counts. Candidate half intervals satisfy

```text
0.75 (L/ell)^4 <= a,b <= 1.25 (L/ell)^4.
```

The order-only count-volume rapidity excess is

```text
E(p,x,q) = c / (a^(1/4) + b^(1/4))^4.
```

The tight cap is `E <= 1.5`; the loose cap is `E <= 2.0`. When more than 32
brackets pass a cap, the selector retains the 16 smallest and 16 largest
scores plus all cutoff ties. This tests both the aligned core and the declared
compactness boundary without event-label tie breaking.

The carrier is the open interval `A(p,q)={z | p<z<q}`. Every interior and shell
predicate is recomputed in its induced finite order. The global A3b interior
is used only to sample marks before bracket construction.

## Exact implementation audit

Six hostile selector tests pass:

- the collinear count composition has unit excess;
- low and high score strata are both retained;
- a nine-element exact tie orbit is retained in full despite a nominal cap of
  two;
- the selected endpoint ensemble is exactly relabeling equivariant;
- induced counts agree with global counts on a genuine branching partial
  order;
- the selector API has no coordinate argument.

Together with the inherited sparse count tests, 17 focused tests pass and
Ruff reports no findings.

## Frozen run

Five fresh realizations were run at each fixed-density four-volume multiplier
`1,2,4`, with eight order-randomized common-interior marks per realization.
The supplied scales, bands, rapidity caps, score strata, gates, and seed
`2026071605` were unchanged after preregistration.

| volume | N | qualifying-mark median | clustered rank median | carrier median | overlap metric disagreement | refinement disagreement | coordinate metric error | Lorentzian rate |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 1 | 1200 | 25.0% | 0 | 156.00 | 0.515 | 0.144 | 1.035 | 25.0% |
| 2 | 2400 | 37.5% | 0 | 177.75 | 0.694 | 0.227 | 1.081 | 7.1% |
| 4 | 4800 | 50.0% | 0 | 177.25 | 0.743 | 0.352 | 1.057 | 21.9% |

The multiplier-two to multiplier-four carrier-size drift is only `0.281%`.
The compact bracket therefore succeeds at one narrow task: its finite support
size no longer grows with the global infrared diamond.

That success does not produce usable local geometry. Across all 120 sampled
marks and 1,143 tight brackets, the pooled fractions for which the mark lies
in the induced common three-scale interior are

```text
m=1: 0
m=2: 0
m=4: 0.00380.
```

Per-mark median shell cardinalities at every volume are `(1,0,0)` across the
three adjacent scales. No realization contains a rank-capable qualifying
mark, so the zero rank drift is vacuous. The overlap-existence gate passes,
but overlapping brackets disagree strongly on the coordinate-control pairing.

Machine-readable output:

```text
AgentTasks/causal-compact-bracket-carrier-stage-a3d-2026-07-16.json
```

## Gate disposition

Passed:

- exact order/count and equivariance tests;
- global-boundary stability of carrier cardinality;
- overlap-pair availability.

Failed:

- bracket availability plus all-three-scale rank;
- compactness-cap refinement stability (`0.352 > 0.25`);
- overlap metric stability (`0.743 > 0.25`);
- coordinate metric control (`1.057 > 0.50`);
- Lorentzian signature control (`0.219 < 0.80`).

The construction fails its preregistered gate and must be killed before any
intrinsic eigensolver.

## Interpretation

The count-volume excess is useful: it removes global infrared growth without
choosing coordinates or a frame. The failure comes from using the same compact
bracket as both boundary regulator and evaluation neighborhood. Half intervals
at the operator scale leave essentially no induced-order buffer for the mark
or its largest adjacent shell. The carrier is compact but over-truncated.

Do not widen the endpoint band, raise the rapidity caps, lower the rank gate,
or increase the global diamond to rescue this run. A legitimate successor
must introduce a different architecture: a nested outer regulator and inner
evaluation region, with an explicit count buffer between them. Before any
run, it must prove or exactly test that induced interval counts are preserved
on the inner region, preregister a nonvacuous local-interiority threshold, and
retain realization-clustered inference.

## Verification

```text
cd Scripts/experiments
python -m py_compile causal_compact_bracket_carrier.py test_causal_compact_bracket_carrier.py
python -m unittest test_causal_compact_bracket_carrier.py test_causal_larger_diamond_support.py test_causal_adjacent_scale_availability.py
ruff check causal_compact_bracket_carrier.py test_causal_compact_bracket_carrier.py
python causal_compact_bracket_carrier.py --realizations 5 --output ../../AgentTasks/causal-compact-bracket-carrier-stage-a3d-2026-07-16.json
```
