# Stage A3f preregistration: outer-first buffered causal atlas

## Status and claim boundary

**Status:** invalidated before implementation or execution; do not run  
**Work item:** `GRAV-ATLAS-COVERAGE-001`  
**Claim grade if successful:** external finite atlas/support control only; no
G2 pass, continuum theorem, tetrad, curvature, or Einstein dynamics

## Pre-implementation stop notice

No selector, test suite, or benchmark was implemented or executed from this
version. A scale audit found three errors before data generation:

1. `M(H,m) = (2 H^(1/4) + m^(1/4))^4` makes a centered shifted
   subdiamond have expected count `m`; it is only a lower bound on the full
   two-sided protected core, not the protected-core volume itself.
2. Count fourth roots are Alexandrov volume radii. They become proper times
   only after multiplication by `(pi/24)^(-1/4)` in flat four-dimensional
   Minkowski space.
3. Fixed outer, buffer, and core counts at increasing density shrink every
   physical scale in lockstep with the discreteness radius. They do not realize
   the required hierarchy `ell << L << S << R`.

The independent-placement baseline below consequently uses the wrong core
volume: for example, `H=4` and `M=1024` give an exact continuum protected-core
expectation of about `458.98`, not `64`. The corrected exact law, numerical
audit, and shrinking schedule are frozen in
`null-edge-causal-atlas-coverage-stage-a3f-r1-plan-2026-07-16.md`. This file is
retained as the preregistration record and must not be used to launch a run.

Stage A3e killed selecting a deep symmetric outer bracket around an already
chosen mark. At its frozen proper depths, even an ideal construction could
reach only about 7.7 percent of the global diamond volume before endpoint-band,
excess, and nesting losses. Stage A3f reverses the order: sample compact outer
regulators first, construct their buffered protected cores, measure coverage of
an independently defined order bulk, and only then evaluate marks in covered
cores. Rare successful-core conditioning cannot replace the coverage gate.

Coordinates may generate the oracle causal relation. They are forbidden for
candidate selection, regulator sampling, core construction, bulk definition,
coverage, overlap, mark sampling, support evaluation, and every Phase 1 gate.
They may be reopened only if all Phase 1 gates pass.

## Analytic target ladder

Let `H` be an inclusive count-depth buffer from each outer endpoint. Under
four-volume scaling, an outer interval with inclusive count target

```text
M(H,m) = (2 H^(1/4) + m^(1/4))^4
```

has a collinear continuum core with expected count `m`. Freeze

```text
buffers H = (4, 8, 16, 32)
target core count m = 64.
```

The corresponding real outer targets are approximately

```text
M(4,64)  = 1024
M(8,64)  = 1470.03
M(16,64) = 2174.12
M(32,64) = 3310.40.
```

All are below the smaller frozen density `N=4800`. The next doubled buffer,
`H=64`, requires `5184` events and is excluded before execution by the
two-density resource ceiling.

The refinement schedule holds the global diamond duration fixed at one and
doubles the random-event count from `4800` to `9600`. Fixed count targets then
have shrinking physical diameter as `ell` decreases. The atlas size scales
from `K=128` to `K=256`, keeping

```text
lambda = K m / N = 1.7067
P(covered) = 1 - (1 - m/N)^K approximately 0.821
P(multiplicity >= 2 | covered) approximately 0.622
```

nearly constant under an independent-placement baseline. The frozen gates of
0.50 total coverage and 0.40 repeated coverage are below this baseline while
remaining nonvacuous. This is a heuristic calibration, not a theorem about
correlated Alexandrov cores. Failure measures that correlation and candidate
scarcity rather than an arithmetically impossible target.

## Frozen candidate and sampling law

For each buffer `H`, an outer candidate is a comparable pair `p < q` whose
inclusive interval count lies in

```text
[0.90 M(H,64), 1.10 M(H,64)].
```

The candidate set is exact and relabeling equivariant. At `N=4800`, sample 128
candidates uniformly without replacement; at `N=9600`, sample 256. Retain all
if fewer exist, but fail the candidate-availability gate. The realized atlas is
not pointwise invariant under a coupled relabeling, but its probability law is:
every `K`-subset of the equivariant candidate set has equal probability. Event
labels are not scores or tie breakers.

The protected core of `A(p,q)` at buffer `H` is

```text
{x | p < x < q,
     H <= C(p,x) + 1,
     H <= C(x,q) + 1}.
```

All counts are ambient counts. Exact causal convexity identifies them with the
induced counts on the outer carrier. No preselected mark enters candidate or
core construction.

## Independent order-bulk denominator

For each buffer `H`, define the order bulk independently of atlas success:

```text
Bulk_H = {x | x has at least H causal predecessors
                and at least H causal successors}.
```

This denominator uses only global in/out degree and is fixed before candidate
sampling. It is not the union of successful cores. Report both all-event core
coverage and `Bulk_H` coverage. A rung with an empty bulk fails nonvacuity.

## Support and overlap evaluation

After atlas and coverage statistics are frozen, sample eight marks without
replacement from the covered part of `Bulk_H`, using a child RNG stream
distinct from sprinkling and regulator sampling. This conditioning is permitted
only because coverage itself is a primary gate.

At each sampled mark, retain at most eight containing atlas carriers, sampled
uniformly without replacement by another dedicated stream. Recompute the
unchanged A3b three-scale interiors and retarded shells in every induced outer
carrier. Record:

- rank-capable rate;
- raw-shell source-closure rate, with the denominator formed before source
  interiority;
- carrier cardinality;
- normalized shell-count disagreement across independently selected carriers;
  and
- whether the mark has at least two containing cores.

The primary unit is a realization. Carrier values are clustered at marks, then
marks at realizations. Pooled carrier statistics are diagnostic only.

## Frozen execution

- Random events: `N=(4800,9600)`.
- Duration: `1` at both densities.
- Realizations: five per density.
- Seed: `2026071607`.
- Buffers: `(4,8,16,32)`.
- Target core count: `64`.
- Candidate band: `[0.90,1.10]` times the analytic target.
- Atlas sizes: `(128,256)` at `(4800,9600)`.
- Support marks: eight covered-bulk marks per rung.
- Containing carriers: at most eight per support mark.
- Separate child streams: sprinkling, four regulator samples, four mark samples,
  and four containing-carrier samples at each density and realization.
- No eigensolver and no coordinates in Phase 1.

## Frozen exact gates

1. The target formula reproduces the displayed four buffer targets and rejects
   `H=64` at `N=4800`.
2. Dense and sparse inclusive counts agree on chain and branching controls.
3. Candidate sets, protected cores, bulk predicates, coverage multiplicities,
   and containing-carrier relations map exactly under relabeling.
4. Uniform `K`-subset sampling is used only after constructing the complete
   equivariant candidate set; exhaustive small-set frequencies are uniform.
5. Every protected-core event belongs to the outer carrier and ambient/induced
   interval counts agree on a runtime tripwire.
6. Raw-shell closure forms its denominator before source interiority.
7. Every RNG role consumes a distinct reproducible child stream.
8. Selector, bulk, core, coverage, and Phase 1 APIs have no coordinate argument.

Any exact failure kills the run before sprinkling.

## Frozen Phase 1 gates

A buffer rung passes one realization only if:

- the complete candidate set has at least the frozen atlas size;
- all-event core coverage is at least `0.50`;
- `Bulk_H` is nonempty and its core coverage is at least `0.60`;
- at least `0.40` of covered bulk events have core multiplicity at least two;
- eight covered-bulk support marks are available;
- realization-median rank-capable carrier rate is at least `0.80`;
- realization-median minimum raw-shell source-closure rate is at least `0.80`;
- at least `0.80` of support marks have two evaluated containing carriers; and
- realization-median normalized shell-count disagreement is at most `0.25`.

A rung passes one density only if at least four of five realizations pass. Stage
A3f passes Phase 1 only if at least one adjacent pair among `(4,8)`, `(8,16)`,
or `(16,32)` passes at both densities. Between `N=4800` and `N=9600`, each
rung's median realization-clustered coverage, rank, and closure rates may differ
by at most `0.10`.

Every stability Boolean is false unless both densities have positive
denominators and positive rank medians. Zero versus zero is never stability.

## Frozen Phase 2 controls

Coordinates may be reopened only if Phase 1 passes. On the archived selection:

- median coordinate-metric disagreement across containing carriers is at most
  `0.25`;
- median coordinate-control metric error is at most `0.50`; and
- at least `0.80` of rank-capable carriers have signature `(1,3,0)`.

These controls do not provide an intrinsic probe basis and cannot close G2.

## Kill and successor rules

Kill the frozen atlas before any eigensolver if an exact gate fails, no adjacent
buffer pair passes both densities, candidate scarcity defeats the declared
sampling law, coverage or repeated coverage fails, source closure/rank fails,
overlap shell counts are unstable, refinement drift persists, or a reached
Phase 2 control fails.

Do not alter the density ladder, buffer ladder, target-core count, candidate
band, atlas density, mark or carrier sampling, thresholds, seed, or duration
after output. Do not enlarge the global diamond, select only successful
realizations, condition the coverage denominator on atlas cores, or lower a
gate to rescue the run.

If coverage passes but support fails, retain only the finite atlas-coverage
fact and kill its operator interpretation. If two adjacent rungs pass both
phases, a separately preregistered successor may test a broader shrinking
schedule before any intrinsic spectral cluster.
