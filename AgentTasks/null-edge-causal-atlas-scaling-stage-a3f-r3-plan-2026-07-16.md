# Stage A3f-R3 preregistration: complete-family bulk-saturation scaling

## Status and claim boundary

**Status:** preregistered before implementation or fresh-seed execution  
**Proposed work item:** `GRAV-ATLAS-SCALING-001`  
**Parent:** killed packing item `GRAV-ATLAS-PACKING-001`  
**Claim grade if successful:** finite-size measurement of complete-family bulk
saturation under the balanced order-only schedule; no selected atlas,
operator locality, G2, tetrad, curvature, source, or Einstein dynamics

The spent A3f-R2 artifact generated the post-hoc hypothesis

```text
S_N(beta) = 1 - a_beta N^(-1/2) + o(N^(-1/2)),
```

where `S_N` is complete-candidate-union coverage of the independently defined
order bulk. This stage tests that form on fresh, interleaved densities. It does
not reuse R2 as confirmatory evidence and does not select a greedy atlas.

## Frozen order-side construction

Use the corrected balanced schedule at fixed global duration one:

```text
n_R proportional to N^(3/4),
n_S proportional to N^(1/2),
n_L proportional to N^(1/4),
n_R(4800) = 2048,
n_S(4800) = 12.6992084157456.
```

At each density, construct the complete comparable-pair family whose ambient
inclusive interval count lies in `[0.90,1.10] n_R`. For each candidate
`A(p,q)` and `beta in (0.80,1.00,1.25)`, use

```text
H_beta = beta^4 n_S,
Core_H(p,q) = {x | p < x < q,
                   H_beta <= C(p,x)+1,
                   H_beta <= C(x,q)+1},
Bulk_H = {x | indegree(x) >= H_beta and outdegree(x) >= H_beta}.
```

Here `C(u,v)` denotes the strict open-interval count, so the stored inclusive
count is exactly `C(u,v)+1`. The implementation compares that stored inclusive
count directly with `H_beta`; the bulk predicate compares the corresponding
strict global degrees with the same real threshold.

Materialize the complete candidate list before evaluating coverage. Stream
each core into one all-event union mask and one bulk-union mask; do not retain
the candidate-by-event core matrix. Archive candidate counts, carrier and core
size summaries, union counts, bulk counts, and every replay tripwire.

The exact theorem
`AtlasCoreBulkContainment.protectedCore_family_union_subset_orderBulk` must
typecheck with its guarded standard axiom footprint before execution. The
finite identity

```text
complete_union_all_event_coverage
  = bulk_fraction * complete_union_bulk_coverage
```

must hold to floating roundoff from archived integer counts.

## Post-hoc scaling form, frozen for confirmation

Define

```text
S_N(beta) = complete_union_bulk_coverage,
D_N(beta) = sqrt(N) * (1 - S_N(beta)).
```

R2 supplies design centers only:

```text
a_0.8 = 12.85,
a_1.0 = 17.16,
a_1.25 = 26.73.
```

For descriptive reporting, archive `D_N/a_beta`. The primary confirmatory
criterion is cross-density stability, not closeness to these fitted centers.
Archive every realization-level `D_N` value. The confirmatory drift statistic
is realization-clustered: first take the median `S_N` over the five
realizations at each density, then form `D_N = sqrt(N) * (1 - median S_N)`.

## Frozen execution

- Fresh seed: `2026071609`.
- Densities: `N=(6000,12000)` random events plus the standard top endpoint.
- Duration: one.
- Realizations: five per density.
- Buffer-radius rungs: `(0.80,1.00,1.25)`.
- Complete candidate resource ceiling: 4000 per realization.
- Dense causal-relation ceiling at `N=12000`: `12001^2` Boolean entries.
- Peak process working-set ceiling: 6 GiB, sampled with `psutil` after relation,
  inclusive-count, candidate, and each-rung phases.
- Per-realization wall-time ceiling: 600 seconds.
- Existing NumPy, SciPy, and psutil only.
- Separate child streams for every sprinkling; no selector or uniform-control
  streams exist in this stage.
- No greedy selection, chosen atlas, overlap graph, source-row evaluator,
  polynomial probe, eigensolver, metric, or coordinate-control phase.

Exceeding a resource ceiling fails that realization without truncating,
sampling, or changing the complete family. A resource failure uses a
structurally distinct record with unavailable coverages encoded as `None`; it
does not substitute zero coverage.

## Exact gates before sprinkling

1. `AtlasCoreBulkContainment.lean` and `GreedyAtlasCoverage.lean` build with
   their guarded footprints and no proof gaps.
2. The closed `F_4` law, count/proper-time conversion, and balanced exponents
   retain all reviewed controls.
3. Dense and sparse interval counts agree on chain and branching controls.
4. Complete candidates, streamed cores, the independent bulk, union counts,
   and `S_N` map under exhaustive event and candidate relabeling controls.
5. Streamed complete unions equal the existing materialized-core unions on
   exhaustive small systems and deterministic synthetic orders.
6. Every streamed core lies in its carrier and in the independent bulk; the
   integer factorization of all-event coverage passes exactly.
7. All sprinkling child streams are distinct, reproducible, and directly
   replayable from archived seed words.
8. Every order-side API is coordinate free and imports no selector,
   support-row, eigensolver, or metric-control function.
9. Raw and runtime-normalized artifact hashes use the reviewed A3f-R2
   canonicalization and are printed at write time.

Any exact failure kills the run before fresh sprinkling.

## Frozen empirical gates

For one density/rung cell to be admissible, at least four of five realizations
must satisfy all resource, candidate-abundance, containment, factorization,
and replay tripwires, with at least 16 complete candidates and nonempty bulk.

A buffer rung passes the scaling test only if:

- median `S_N(beta)` is strictly larger at `N=12000` than at `N=6000`;
- median complete-union all-event coverage is strictly larger at `N=12000`;
- the relative drift of median scaled deficit is at most `0.20`, namely
  `abs(D_12000-D_6000) / max(D_12000,D_6000) <= 0.20`;
- each density's median bulk fraction differs by at most `0.05` from the flat
  `F_4` prediction evaluated at its archived `H_beta/N`; and
- no zero denominator is counted as stability.

The stage passes only if an adjacent pair among `(0.80,1.00)` or
`(1.00,1.25)` passes every condition. In addition, the narrowest rung must
have median complete-union all-event coverage at least `0.60` at `N=12000`;
otherwise the balanced family is not computationally capable of supporting
the next growing-atlas gate in the accessible range.

## Kill and successor rules

Kill the displayed `N^(-1/2)` family-saturation law if no adjacent pair passes.
Kill the accessible balanced-family route if the `beta=0.8`, `N=12000`
capability floor fails with valid resources and candidate abundance. A resource
failure is reported separately and does not count as geometric evidence.

Do not alter the seed, densities, schedule, band, rungs, tolerances, resource
ceilings, or duration after output. Do not reinterpret the spent R2 seed as
fresh evidence. Even a complete pass opens only a separately preregistered
growing-atlas measurement with `K_N=Omega(N^(1/4))` and a saturation-aware
headroom score. Source rows, operators, G2, tetrads, curvature, stress-energy,
and Einstein dynamics remain closed.
