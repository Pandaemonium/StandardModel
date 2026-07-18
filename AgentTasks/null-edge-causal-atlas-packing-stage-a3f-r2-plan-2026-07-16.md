# Stage A3f-R2 preregistration: equivariant greedy causal-atlas packing

## Status and claim boundary

**Status:** preregistered before implementation or fresh-seed execution  
**Work item:** `GRAV-ATLAS-PACKING-001`  
**Parent:** killed uniform-atlas item `GRAV-ATLAS-COVERAGE-001`  
**Claim grade if successful:** external finite order-atlas packing and overlap
control only; no operator locality, G2 pass, tetrad, curvature, source, or
Einstein dynamics

Stage A3f-R1 found abundant outer candidates and calibrated individual cores,
but a uniform `K=16` atlas spent five to seven union-volumes on duplicate
coverage. This stage changes only the atlas selector. It keeps `K`, the
corrected shrinking schedule, outer band, buffer rungs, density ladder, and
coverage thresholds fixed.

The selector uses no preselected mark. Coordinates may generate the oracle
causal relation and are then discarded. Candidate construction, protected
cores, the bulk, greedy scores, tie orbits, uniform controls, overlaps, and all
gates use only order and ambient interval counts.

## Frozen geometry and candidate family

Use the independently reviewed A3f-R1 schedule at fixed global duration one:

```text
N = (4800, 9600)
n_R proportional to N^(3/4)
n_S proportional to N^(1/2)
n_L proportional to N^(1/4)
n_R(4800) = 2048
n_S(4800) = 12.6992084157456
beta = (0.80, 1.00, 1.25)
H_beta = beta^4 n_S
```

At each density, construct the complete comparable-pair family whose ambient
inclusive interval count lies in `[0.90,1.10] n_R`. For every candidate
`A(p,q)`, construct the order-only protected core

```text
Core_H(p,q) = {x | p < x < q,
                   H <= C(p,x)+1,
                   H <= C(x,q)+1}.
```

The independent bulk is fixed before atlas selection:

```text
Bulk_H = {x | indegree(x) >= H and outdegree(x) >= H}.
```

The complete candidate family and every core are materialized before the first
greedy choice. If more than 2000 candidates occur in one realization, fail the
resource gate rather than truncating or sampling the family.

## Frozen greedy selector

Select exactly `K=16` distinct candidates without replacement. Start with
empty covered sets. At each step:

1. score every available candidate by its number of newly covered events in
   `Bulk_H`;
2. retain the complete orbit attaining the maximum bulk marginal;
3. within that orbit, retain the complete orbit attaining maximum new
   all-event coverage;
4. sample uniformly from this final exact tie orbit using the rung's dedicated
   child stream;
5. archive the two maximum scores, every member of the final tie orbit, and
   the chosen candidate; then update both covered sets.

No event label is a score or tie breaker. Under an order relabeling, every
marginal score and exact tie orbit maps to its image, so the realized choice is
equivariant in probability law. The all-event secondary score cannot override
the primary independent-bulk maximum.

For the finite universe `Bulk_H`, standard greedy maximum coverage gives

```text
greedy_K >= (1 - (1 - 1/K)^K) OPT_K,
```

and therefore at `K=16` the factor is approximately `0.644`. A focused Lean
target must first kernel-check the average-marginal witness, greedy dominance,
one-step residual contraction, geometric iteration, and event-relabeling
control. This theorem controls the selector but does not assert that the
causal candidate family contains a good cover.

## Analytic feasibility pin

At `N=4800`, `beta=0.8`, the reviewed flat calibration predicts one core of
about `1087` events, or `0.226` of the global random-event count. Sixteen such
cores contain about `3.62` all-event volumes before overlap, giving substantial
headroom over the `0.50` union gate. The corresponding R1 sampled cores matched
the individual-size calibration. Thus a packing failure is not forced by the
single-core arithmetic; it measures the joint causal-diamond geometry.

For every realization and rung, also report the complete-candidate union. A
complete union with all-event coverage below `0.60` or bulk coverage below
`0.80` fails the feasibility gate before the greedy result is interpreted.

## Fresh uniform control

On the same fresh causal relation and complete candidate family, sample an
independent uniform `K=16` atlas using a distinct child stream. It is a control,
not a fallback. The primary greedy atlas must improve median all-event coverage
by at least `0.10` over this fresh uniform control at each density for a rung to
pass. The archived A3f-R1 seed is not reused.

## Frozen execution

- Fresh seed: `2026071608`.
- Densities: `N=(4800,9600)` random events plus the standard top endpoint.
- Duration: one.
- Realizations: five per density.
- Buffer-radius rungs: `(0.80,1.00,1.25)`.
- Atlas size: 16 for greedy and 16 for the independent uniform control.
- Separate child streams: sprinkling, three greedy tie streams, and three
  uniform-control streams per realization.
- Complete candidate resource ceiling: 2000 per realization.
- No support-row evaluator, polynomial probe, eigensolver, metric, or
  coordinate-control phase.

## Exact gates before sprinkling

1. The focused Lean file typechecks without proof holes and preserves every
   preregistered public statement.
2. The closed core law, count/proper-time conversion, and balanced exponents
   retain their 11 reviewed controls.
3. Dense and sparse counts agree on chain and branching controls.
4. Complete candidates, every protected core, independent bulk, marginal
   scores, exact tie orbits, greedy selections in law, coverage
   multiplicities, and overlap graphs map under exhaustive relabeling controls.
5. Exhaustive small finite set systems compare greedy coverage with exact
   optimal `K`-coverage and satisfy the finite geometric approximation bound.
6. Uniform controls sample only after complete candidate construction and are
   uniform on exhaustive small controls.
7. Every selected core lies in its carrier; bounded ambient/induced count
   tripwires pass.
8. All seven RNG roles are distinct, reproducible, and directly replayable
   from archived seed words.
9. Every order-side API is coordinate free and imports no support-row,
   eigensolver, or metric-control function.

Any exact failure kills the run before fresh sprinkling.

## Frozen empirical gates

A greedy rung passes one realization only if:

- 16 to 2000 complete candidates exist;
- the complete-candidate union covers at least `0.60` of all events and `0.80`
  of the independent bulk;
- the greedy atlas covers at least `0.50` of all events and `0.60` of the bulk;
- at least `0.35` of covered bulk events have multiplicity at least two;
- the graph whose vertices are selected cores and whose edges are nonempty
  core intersections is connected;
- at least one greedy step after the first has positive all-event marginal;
  and
- all runtime count and replay tripwires pass.

A rung passes one density only if at least four of five greedy realizations
pass and the median all-event coverage improvement over the same-realization
uniform control is at least `0.10`. The stage passes only if an adjacent pair
among `(0.80,1.00)` or `(1.00,1.25)` passes both densities. For each passing
rung, cross-density drift of median all-event, bulk, repeated, and greedy-minus-
uniform coverage is at most `0.10`. Zero denominators never count as stability.

## Kill and successor rules

Kill A3f-R2 if its theorem, exact controls, resource ceiling, complete-union
feasibility, greedy coverage, improvement, connected-overlap, clustered
density, adjacent-rung, or refinement gates fail. Do not alter the selector,
tie law, fresh seed, `K`, density ladder, schedule, rungs, outer band,
thresholds, or duration after output.

Even a complete pass establishes only a finite packed atlas. A separately
preregistered successor may then distinguish probe data, protected evaluation
centers, and row-source support on the archived greedy germs. No rank-four
projector or operator branch comparison opens in this item.
