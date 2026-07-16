# Stage A3c: fixed-density larger-diamond support control

## Objective

Test whether the Stage A3b same-interior shell failure is caused by the finite
Alexandrov boundary. The experiment changes only global four-volume: expected
density, discreteness scale `ell`, operator scale `L`, adjacent ratio, selector
scales, interior bands, shell bands, and gate thresholds remain fixed.

This is an external numerical oracle plus a separate kernel-checked finite
no-go. Neither part establishes a continuum limit.

## Frozen volume control

Starting from `N_1 = 1200` and duration `T_1 = 1`, an integer volume
multiplier `m` is implemented by

```text
N_m = m N_1
T_m = m^(1/4) T_1.
```

Because a four-dimensional Alexandrov volume scales as `T^4`, this holds

```text
ell = (V(T_m) / N_m)^(1/4)
```

fixed at `0.10219728214404318`. The operator scale remains `L = 0.18`, the
adjacent ratio remains `r = 1.25`, and the three selector scales remain

```text
(s/r, s, r*s) =
(0.10850404095237087,
 0.13563005119046360,
 0.16953756398807948).
```

The best Stage A3 count tuple and the `80%` randomized-mark gate are unchanged.
Coordinates generate each oracle causal relation and are not inspected again.

## Exact sparse implementation

The dense open-interval matrix was replaced by an exact sparse inclusive-count
matrix. If `R` is the strict relation matrix, the implementation computes

```text
C_plus = (R @ R) .* R + R.
```

The entry on a comparable pair is its open-interval count plus one; every
noncomparable entry is absent. Links remain represented with value one. Unit
tests compare the full matrix, all three interiors, common marks, and every
shell count against the previous dense reference.

The sparse backend reproduces the archived A3b JSON exactly. At `N = 1200`,
the mean inclusive-count runtime falls from about `0.98 s` for the dense
prototype to `0.0083 s`; the mathematical output is unchanged.

Implementation and tests:

```text
Scripts/experiments/causal_adjacent_scale_availability.py
Scripts/experiments/causal_larger_diamond_support.py
Scripts/experiments/test_causal_adjacent_scale_availability.py
Scripts/experiments/test_causal_larger_diamond_support.py
```

## Frozen ladder result

Ten fresh realizations were run at each preassigned volume multiplier:

| volume | N | duration | median common-interior fraction | all shells nonempty | all shells >= 4 | largest-shell median | largest-shell mean | gate |
|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 1 | 1200 | 1.000 | 19.40% | 6.12% | 1.93% | 0 | 0.23 | fail |
| 2 | 2400 | 1.189 | 35.99% | 25.84% | 17.19% | 0 | 4.70 | fail |
| 4 | 4800 | 1.414 | 48.46% | 45.44% | 36.97% | 0 | 24.01 | fail |

Every realization has a common interior and at least one rank-capable mark, but
a uniformly sampled common mark remains far below the frozen `80%` threshold.
The strong monotone response at fixed local scales confirms that the finite
boundary is a major part of the A3b scarcity.

Machine-readable output:

```text
AgentTasks/causal-larger-diamond-support-stage-a3c-2026-07-16.json
```

## Exploratory volume-eight point

Five additional fresh realizations at `m = 8`, `N = 9600`, and
`T = 1.68179` were used only to diagnose the trend:

| median common-interior fraction | all shells nonempty | all shells >= 4 | largest-shell median | largest-shell mean | gate |
|---:|---:|---:|---:|---:|---|
| 59.64% | 58.03% | 50.85% | 4 | 66.26 | fail |

The shell is becoming available because it grows with the infrared diamond.
That is not local convergence. No larger-volume run is authorized merely to
force the old `80%` gate to pass.

Machine-readable exploratory output:

```text
AgentTasks/causal-larger-diamond-support-stage-a3c-m8-exploratory-2026-07-16.json
```

## Continuum locality diagnosis

In `3+1` Minkowski spacetime, timelike hyperbolic coordinates about a marked
event have

```text
t = -tau cosh(chi)
r =  tau sinh(chi)
d^4 y = tau^3 sinh(chi)^2 d tau d chi d Omega.
```

A fixed interval-volume band is a fixed proper-time band
`tau in [tau_1, tau_2]`. Its rapidity coordinate still ranges over
`chi in [0, infinity)`, and

```text
integral_0^infinity sinh(chi)^2 d chi
```

diverges. A finite Alexandrov diamond supplies an infrared rapidity cutoff;
enlarging the diamond removes that cutoff. Two-sided interiority excludes
global boundary events but does not compactify the shell relative to the
marked event.

This explains the numerical growth and changes its interpretation. Eventual
global-shell availability would be an infrared-volume effect, not a finite
local cotangent sector.

## Kernel-checked finite no-go

`PhysicsSM/Draft/NullEdge/RetardedShellInfraredNoGo.lean` constructs, for every
natural number `n`, a three-level finite strict causal order with:

- `n` private bottom events;
- `n` shell sources;
- one common marked event;
- interior and shell count bands `[1,1]`;
- nonzero minimum past/future abundance `1`.

Every source passes the two-sided interior test, every source has open-interval
count zero to the mark, and the marked shell has cardinality exactly `n`:

```text
arbitrarily_large_fixedInterval_shell (n) :
  shell.card = n /\
  forall y in shell, openIntervalCount y mark = 0
```

The theorem has a build-enforced standard assumption footprint
`[propext, Classical.choice, Quot.sound]`. It has no proof handoff.

## Verdict

**Boundary dependence is confirmed.** The same shell definition becomes more
available as the global diamond grows while all local scales are fixed.

**The global count-band shell is rejected as a locality construction.** Its
population is infrared-cutoff dependent in the continuum geometry, and finite
causal orders allow arbitrary shell cardinality at a fixed minimal interval
count even with nonzero two-sided abundance.

The earlier rank theorem remains correct and useful: fewer than four shell
events forbid a visible rank-four sector. The converse was never sufficient,
and A3c now shows why increasing shell cardinality cannot repair locality.

Do not launch the generalized-cluster eigensolver on the global shell. No
larger-volume run can rehabilitate its cardinality as a locality certificate:
crossing the old availability threshold would only confirm infrared growth.

## Next decision

Replace the global shell by a compact order-derived carrier:

1. construct a local Alexandrov bracket `p < x < q` using only order/count
   data, or retain the full equivariant ensemble when no canonical bracket
   exists;
2. evaluate retarded support inside the induced finite order on that carrier;
3. require stability under refinement of the carrier and under overlap of
   independently selected brackets;
4. only then construct a basis-free spectral cluster with emergent rank.

This returns the probe program to the existing Alexandrov-germ architecture
and makes compact support, boundary scale, and refinement compatibility
explicit reconstruction obligations.

Independent Claude-family replay reproduced the archived frozen ladder,
verified the sparse semantics and guarded finite no-go, and approved this
split verdict in
`AutonomousLab/reviews/CLAUDE_REVIEW_A3C_BOUNDARY_CONTROL_2026-07-16.md`.

## Verification commands

```text
lake env lean PhysicsSM/Draft/NullEdge/RetardedShellInfraredNoGo.lean
lake build PhysicsSM.Draft.NullEdge.RetardedShellInfraredNoGo
cd Scripts/experiments
python -m unittest test_causal_adjacent_scale_availability.py test_causal_larger_diamond_support.py test_causal_intrinsic_probe_metric.py
ruff check causal_adjacent_scale_availability.py causal_larger_diamond_support.py test_causal_adjacent_scale_availability.py test_causal_larger_diamond_support.py
python causal_larger_diamond_support.py --realizations 10 --output ../../AgentTasks/causal-larger-diamond-support-stage-a3c-2026-07-16.json
python causal_larger_diamond_support.py --volume-multipliers 8 --realizations 5 --seed 2026071604 --output ../../AgentTasks/causal-larger-diamond-support-stage-a3c-m8-exploratory-2026-07-16.json
```
