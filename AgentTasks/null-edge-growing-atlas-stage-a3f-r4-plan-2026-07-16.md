# Stage A3f-R4 preregistration: growing bounded-multiplicity causal atlas

Date: 2026-07-16
Work item: `GRAV-GROWING-ATLAS-001`
Status: preregistered for independent review; do not execute before approval

## Question and inherited evidence

Can the complete count-band family support a genuinely growing selected atlas
whose protected-core nerve remains connected without collapsing into a full,
unbounded-multiplicity simplex?

The question is narrower than G2. R3, cited with provenance incident
`INC-2026-07-16-A3F-R3-DUPLICATE-RUN`, found that the complete family
increasingly saturates the independent order bulk. R2 found that unconstrained
`K=16` greedy selection captures `95.6%-99.7%` of the complete-family union.
However, all 30 R2 selected overlap graphs were complete, and selected maximum
multiplicity was `15` or `16`. The selector therefore produced a centrally
over-collapsed nerve, not evidence for a locally finite atlas.

`ProtectedCoreAtlasNerve.fullCommonOverlap_card_le_bound` now proves the exact
finite obstruction: if every selected core shares an event and multiplicity is
bounded everywhere by `m`, then the atlas has at most `m` charts. A growing
atlas with fixed multiplicity must break the full common intersection.

## Frozen graph and core construction

For `N` random events plus the standard top endpoint, use the existing
balanced schedule

```text
n_R = N^(3/4),  n_S = N^(1/2),  n_L = N^(1/4).
```

Construct every comparable endpoint pair whose stored inclusive interval count
lies in `[0.90,1.10] n_R`. For buffer rungs `beta in (0.80,1.00)`, use

```text
H_beta = beta^4 n_S,
Core_beta(p,q) = {x in I(p,q) |
                  H_beta <= C(p,x)+1 and H_beta <= C(x,q)+1},
Bulk_beta = {x | indegree(x) >= H_beta and outdegree(x) >= H_beta}.
```

`C(u,v)` is the open interval count. The stored inclusive value `C+1` is
compared directly with `H_beta`. Coordinates generate only the oracle causal
relation and are deleted before candidate, selector, nerve, and gate logic.

## Growing cardinality

The selected cardinality is fixed before development as

```text
K_N = ceil(2 N^(1/4)).
```

Thus `K_6000=18` and `K_12000=21`. The factor two is the smallest integer
multiple that continues the spent `K=16` scale while obeying the
kernel-checked necessary order `K_N=Omega(N^(1/4))`. A realization is invalid
if the complete family has fewer than `K_N` candidates; do not silently select
fewer.

## Capacity-constrained greedy selector

For a fixed multiplicity cap `m`, maintain eventwise selected multiplicity.
At each step, a candidate is feasible only if adding its complete protected
core keeps every event multiplicity at most `m`. Among feasible candidates:

1. maximize marginal coverage of `Bulk_beta`;
2. among those, maximize marginal all-event coverage;
3. archive the complete exact tie orbit;
4. sample uniformly from that tie orbit with the dedicated selector stream.

Reject empty cores. Select exactly `K_N` distinct candidates or mark the cell
infeasible. Replaying the same seed state must reproduce every tie orbit and
choice.

## Random-feasible controls

The paired control is not called a uniform feasible subset. Draw five
independent uniform random priority orderings of the complete candidate family,
then accept each candidate in priority order exactly when it is nonempty and
respects the same cap `m`, stopping at `K_N`. These random-feasible controls are
replayable but need not be uniform over all feasible subsets. Every draw must
reach `K_N`; otherwise the realization is `INADMISSIBLE` rather than an
automatic selector win. Archive all five controls and use the median control
coverage in each channel as `U` in the saturation-aware metrics. The fixed odd
draw count reduces control noise without inspecting either fresh seed.

## Frozen development rule

Capacity candidates are

```text
m in (5, 8, 12).
```

They are fixed constants across density. The development seed is
`2026071610`, with `N=(6000,12000)`, three realizations per density, and both
buffer rungs. Evaluate all three caps on each shared realization. Choose the
smallest `m` for which at least two of three realizations pass every
per-realization gate at every density and buffer rung. If no cap qualifies,
the stage stops after archiving development and, subject to the outcome
accounting below, kills this selector family only when the decisive cells are
`FAIL`-driven.

The choice is made automatically inside the frozen runner. No output is
inspected and no threshold is changed between development and confirmation.

## Nerve observables

For each selected atlas, archive:

- all-event and independent-bulk coverage;
- complete-family union coverage on the same realization;
- eventwise multiplicity histogram and maximum;
- repeated-given-covered-bulk fraction;
- every occupied pair-overlap edge;
- every occupied triple-overlap triangle;
- overlap-graph connectedness and edge density;
- fraction of selected charts incident to at least one occupied triangle;
- whether all selected cores have a common event;
- unconstrained greedy coverage as a descriptive upper control only.

Edges and triangles mean literal nonempty common protected-core intersections,
matching `ProtectedCoreAtlasNerve.PairOverlap` and `TripleOverlap`. The full
common-intersection flag matches `CommonOverlap univ`.

## Saturation-aware metrics

For selected coverage `G`, random-feasible coverage `U`, and complete-family
coverage `C`, define separately on all events and the independent bulk

```text
family_capture = G / C,
headroom_capture = (G - U) / (C - U).
```

A ratio is admissible only when its denominator is positive. Headroom capture
additionally requires `C-U >= 0.02`; smaller headroom is not evidence for
selector superiority. Ratios are not clipped.

If `C-U < 0.02` for either all-event or bulk headroom at a realization,
that realization is `INADMISSIBLE` (control saturation): it neither passes nor
fails gate 11, and it feeds the outcome accounting below. Control saturation
is not evidence for or against selector superiority.

## Per-realization gates

A cap/density/buffer cell passes one realization only if:

1. all resource, seed replay, candidate, carrier, core, independent-bulk,
   containment, induced-count, factorization, and relabeling tripwires pass;
2. constrained greedy and all five random-feasible controls select exactly
   `K_N`;
3. selected maximum multiplicity is at most `m`;
4. the selected overlap graph is connected;
5. the selected cores do not have a full common intersection;
6. overlap edge density is strictly below `0.90`;
7. at least `0.80` of selected charts participate in an occupied triangle;
8. repeated-given-covered-bulk coverage is at least `0.35`;
9. selected bulk coverage is at least `0.70`;
10. all-event and bulk `family_capture` are each at least `0.80`;
11. all-event and bulk `headroom_capture` are each at least `0.50`; and
12. at least one greedy step after the first has positive all-event marginal.

The multiplicity and non-full-intersection gates are mandatory topology gates,
not diagnostics that can be waived for high coverage.

Gate 5 is kernel-entailed by gate 3 plus `K_N > m`
(`fullCommonOverlap_card_le_bound`); it is retained as an implementation
tripwire, and a gate-5 failure with gate 3 passing is an implementation halt
(`INADMISSIBLE`), not scientific evidence. The multiplicity cap simultaneously
bounds occupied nerve dimension.

Each cap/density/buffer/realization evaluation has exactly one outcome:
`PASS` (all twelve gates hold with all tripwires and resources clean), `FAIL`
(a gate among 2-12 fails with resources and tripwires clean), or
`INADMISSIBLE` (resource failure, candidate family smaller than `K_N`, control
shortfall, an implementation-tripwire halt, or a degenerate headroom
denominator). Development: a cap qualifies at a cell only if at least two of
three realizations `PASS`. If no cap qualifies and every decisive
disqualification is `FAIL`-driven, the selector family is killed. If any
decisive disqualification is `INADMISSIBLE`-driven, the stage outcome is
resource/degeneracy-inconclusive: archive everything, do not kill, and a
successor preregistration may adjust only resources or seeds. Held-out: a cell
passes only if at least four of five realizations `PASS`; a held-out failure
kills the family only if `FAIL`-driven cells decide it. `INADMISSIBLE`-driven
shortfalls are inconclusive.

A constrained-greedy shortfall is a gate-2 `FAIL`: it is the scientific claim
being tested under the fixed cap. A random-feasible-control shortfall is
`INADMISSIBLE`: without a full-size paired control, selector superiority is not
measured. This asymmetry is intentional.

## Fresh held-out confirmation

If development chooses a cap, continue automatically with held-out seed
`2026071611`, the same two densities and two buffer rungs, and five new
realizations per density. Only the chosen cap is evaluated as the primary
held-out selector; the other caps are not run on held-out data.

If the stage stops at development, seed `2026071611` is retired unconsumed and
may not be reused by any successor design; successors preregister fresh seeds.

A held-out density/buffer cell passes if at least four of five realizations pass
all per-realization gates. For each buffer rung, the cross-density absolute
drift of clustered median all-event `family_capture`, bulk `family_capture`,
all-event `headroom_capture`, bulk `headroom_capture`, repeated coverage, and
triangle participation must be at most `0.15`. The stage passes only if both
buffer rungs pass both densities and all drift gates.

## Exact controls before execution

Before either seed is consumed:

1. `lake build PhysicsSM.Draft.NullEdge.ProtectedCoreAtlasNerve` passes with
   the full-common-overlap obstruction guarded;
2. inherited greedy and core-containment modules build;
3. exhaustive finite set systems verify the capacity selector against a
   brute-force feasibility oracle;
4. adding any selected core never exceeds the cap, including tie branches;
5. small exact cores verify pair edges, triple triangles, full intersection,
   multiplicity histograms, connectivity, and chart participation;
6. event and candidate relabeling preserve selected distributions in law and
   every nerve statistic;
7. development and held-out seed trees, including all five random-feasible
   control streams per cap/cell, are disjoint and replay exactly;
8. resource failure is structurally distinct from zero coverage; and
9. the run-specific sentinel atomically reserves the sentinel and every output
   path of the chained run (development archive, held-out artifact, and any
   incremental logs) with exclusive creation before seed spawning or
   computation; any existing path causes a hard refusal.

The runner must pin the approved plan hash, implementation hash, test hash,
both seeds, both densities, realization counts, rungs, cap candidates, and all
thresholds. Existing sentinel or output paths cause a hard refusal. Do not
rerun a consumed seed.

## Resource ceiling

- Complete candidate ceiling: `4000` per realization; no truncation or sampling.
- Peak process working set: `6 GiB`.
- Wall time: `600 s` per sprinkling, including all development caps or the one
  held-out cap evaluated on that sprinkling.
- Dense relation ceiling: `(12001)^2` Booleans.
- Existing NumPy, SciPy, and psutil only.
- One automatically chained development-plus-held-out run whose sentinel
  exclusively reserves every declared output path before computation.

Resource failure is inconclusive for the scaling claim and cannot be converted
to a scientific kill by substituting zero.

## Kill and successor rules

Subject to the outcome accounting above, kill the displayed
capacity-constrained selector family if no development cap qualifies or the
chosen cap fails held-out confirmation because decisive cells are
`FAIL`-driven. Retain the exact nerve and full-intersection obstruction even on
a kill. Do not relax the cap, coverage, headroom, connectivity, triangle,
density, seed, or resource gates after output.

If the held-out gate passes, the next stage may preregister bounded-dimensional
transition reconstruction on occupied overlaps. It may not open source rows,
operators, G2, a tetrad, spin lift, curvature, stress-energy, or Einstein
dynamics. A passing R4 result is finite `M [comp]` evidence on flat
manifold-generated controls, not a continuum atlas theorem.
