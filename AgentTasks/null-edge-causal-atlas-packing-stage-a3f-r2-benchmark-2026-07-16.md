# Stage A3f-R2 benchmark: equivariant greedy causal-atlas packing

## Disposition

**Status:** killed under the frozen empirical gate  
**Scope of kill:** the displayed two-density complete-family, bulk-first greedy
`K=16` packing mechanism with the frozen absolute and paired-improvement gates  
**Retained:** the complete-family construction, exact tie-orbit law, finite
greedy guarantee, deterministic replay, connected selected overlaps, positive
marginal expansion, exact protected-union containment in the independent bulk,
and the positive diagnosis that greedy nearly saturates the available family
union  
**Not established:** operator locality, G2, a graph-derived tetrad, curvature
convergence, physical stress-energy, or Einstein dynamics

The plan received independent pre-run `APPROVE` in
`AutonomousLab/reviews/CLAUDE_REVIEW_A3F_R2_PACKING_PLAN_2026-07-16.md`.
All exact gates then passed before the held-out seed `2026071608` was opened.
The benchmark ran once without retuning.

## Artifact and hashes

The machine-readable artifact is
`AgentTasks/causal-atlas-packing-stage-a3f-r2-2026-07-16.json`.

- Raw file SHA-256:
  `221ea58dedcc964cbbe0275bc8a082c03e653f0140a80367354727167ac5a4a7`.
- Scientific-content SHA-256:
  `c8476e3e99b3b48cbce6f135d5289f27e6f7085e6a7670d54671f86c2190612b`.
- Canonicalization: parse the JSON; recursively remove every object field
  named `runtime_seconds`; serialize with
  `json.dumps(payload, sort_keys=True, separators=(",", ":"))`; hash the
  resulting UTF-8 bytes with no trailing newline.
- Artifact size: `911017` bytes.

Both hashes were printed when the artifact was first written and reproduced
after the run with the public helper functions in
`Scripts/experiments/causal_atlas_packing.py`.

## Exact pre-run verification

The finite selector theorem is landed in
`PhysicsSM/Draft/NullEdge/GreedyAtlasCoverage.lean`. It kernel-checks the
average-marginal witness, greedy dominance, one-step residual contraction,
finite geometric iteration, exact finite-step factor, event relabeling, and a
singleton anti-vacuity control. The audited declarations have the standard
Mathlib footprint `[propext, Classical.choice, Quot.sound]`.

```text
lake env lean PhysicsSM/Draft/NullEdge/GreedyAtlasCoverage.lean
lake build PhysicsSM.Draft.NullEdge.GreedyAtlasCoverage
```

Both commands passed. The targeted build completed all 8026 jobs. The Python
pre-run suite then passed all 45 tests, and Ruff was clean. Those controls
cover the flat protected-core formula, count normalization, balanced schedule,
complete candidate and core construction, independent bulk, two-level exact
tie orbits, relabeling, exhaustive small-set optimal coverage, the finite
geometric factor, uniform control sampling, all seven random streams,
containment and induced-count tripwires, hash canonicalization, zero
denominators, and the coordinate/operator firewall.

## Frozen result

| `N` | buffer radius | median candidates | complete-union all | complete-union bulk | greedy all | greedy bulk | uniform all | greedy minus uniform | realizations passing |
|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| 4800 | 0.80 | 53 | 0.523 | 0.812 | 0.522 | 0.805 | 0.489 | 0.035 | 0/5 |
| 4800 | 1.00 | 53 | 0.381 | 0.751 | 0.380 | 0.743 | 0.352 | 0.028 | 0/5 |
| 4800 | 1.25 | 53 | 0.200 | 0.607 | 0.199 | 0.606 | 0.181 | 0.018 | 0/5 |
| 9600 | 0.80 | 732 | 0.631 | 0.871 | 0.613 | 0.848 | 0.536 | 0.078 | 5/5 |
| 9600 | 1.00 | 732 | 0.500 | 0.826 | 0.483 | 0.799 | 0.397 | 0.082 | 0/5 |
| 9600 | 1.25 | 732 | 0.317 | 0.732 | 0.303 | 0.700 | 0.240 | 0.063 | 0/5 |

At `N=4800`, no rung met the complete-family feasibility precondition. The
narrowest rung came closest, but its median all-event union was `0.523`, below
the frozen `0.60` family floor. At `N=9600`, the `0.8` rung met every absolute
per-realization gate in all five realizations, including greedy all-event and
bulk coverage, repeated coverage, connected overlap, and positive later
marginals. Its density gate still failed because the median paired improvement
over the fresh uniform control was `0.0777`, below the frozen `0.10` floor.

That improvement failure is not evidence against the selector. At the same
cell, the median complete-union coverage was `0.6309` and the median uniform
coverage was `0.5356`. The median realization-level maximum headroom available
to **any** selector was therefore only `0.0953`, already below the frozen
`0.10` floor. Even a selector returning the whole complete-family union could
not have passed. Greedy captured `97.2%` of that union. The improvement gate
was saturation-blind and arithmetically unsatisfiable at the only cell passing
the absolute gates. This flaw was independently identified in the post-run
Claude review; it does not change the frozen stage failure, but it makes
retention of the selector mandatory for an accurate diagnosis.

All other density/rung combinations failed the complete-family all-event or
bulk feasibility floor and therefore could not pass the greedy stage. No rung
passed both densities, no adjacent rung pair passed, and
`stage_passes_packing_gate=false`. The operator gate remains false and G2
remains closed.

## What the run establishes

The selector is positively retained. The ratios of median greedy all-event
coverage to median complete-union coverage range from about `95.6%` to `99.7%`
across the six density/rung cells. Every one of the 30 greedy atlases improved
on its paired uniform control, all 30 selected overlap graphs were connected,
and all 30 had a positive all-event marginal after the first choice. Every
resource, containment, induced-count, greedy-replay, and uniform-replay
tripwire passed. The complete candidate counts ranged from `46` to `127` at
`N=4800` and from `619` to `811` at `N=9600`, so scarcity and the resource
ceiling were not the problem.

The remaining problem is finite-density family geometry. Complete-union
coverage rises sharply from `N=4800` to `N=9600`, and the cross-density drifts
of greedy all-event coverage are `0.092`, `0.103`, and `0.104` across the three
rungs. The first lies within the frozen `0.10` drift threshold, while the other
two narrowly exceed it; none can be interpreted as a passing refinement
because no density gate passed. Repeated-given-covered rates remain high,
roughly `0.82` to `0.91`, so central correlation persists even after greedy
diversification. **`M [comp]`**.

The exact finite decomposition is landed in
`PhysicsSM/Draft/NullEdge/AtlasCoreBulkContainment.lean`. Each candidate bottom
endpoint plus its past open interval injects into the complete predecessor set
of a core event, and dually on the future side. Hence every protected core and
every finite protected-core union lies in the atlas-independent two-sided
order bulk at the same threshold. The guarded assumption footprint is
`[propext, Classical.choice, Quot.sound]`.

All-event complete-union coverage therefore factors exactly as

```text
bulk fraction * complete-family saturation of bulk.
```

The median bulk fractions are `(0.65,0.52,0.33)` at `N=4800` and
`(0.72,0.60,0.42)` at `N=9600`; median family saturation of bulk rises from
`(0.81,0.75,0.61)` to `(0.87,0.83,0.73)`. The external flat `F_4` law already
calibrates the bulk-fraction factor. Candidate-family saturation is the
remaining stochastic quantity.

## Scientific boundary and successor

This result does not kill order-only outer atlases in an asymptotic sense. It
kills the preregistered claim that this two-density schedule already supplies a
stable complete family from which `K=16` greedy packing beats the same-
realization uniform control by at least `0.10` while meeting the absolute
coverage floors at both densities.

The exact greedy theorem and finite selector should be retained. There is also
a separate asymptotic cardinality correction. If every selected protected core
has cardinality at most `B_N`, then the kernel-checked finite union bound gives

```text
selected union <= K_N B_N.
```

On the balanced schedule `B_N=O(N^(3/4))`, so fixed `K=16` forces global
coverage `O(N^(-1/4)) -> 0`. A continuum atlas with nonzero global coverage
therefore needs `K_N=Omega(N^(1/4))`; fixed `K=16` was only a finite-density
gate. The outer proper duration also shrinks very slowly,
`T_R=O(N^(-1/16))`, and is still about `0.808` and `0.774` at the two tested
densities. Full derivation and theorem anchors are in
`AgentTasks/null-edge-growing-atlas-cardinality-no-go-2026-07-16.md`.

A successor must first address complete-family convergence before any
source-row or operator test, with memory-safe evaluation at additional
densities and a preregistered finite-size scaling law. It must then use a
preregistered growing `K_N` and a saturation-aware selector score such as the
fraction of available union-over-uniform headroom captured, alongside absolute
coverage and overlap gates. Thresholds require fresh development data and a
new held-out seed. The successor may not lower the present gates, reuse seed
`2026071608` as held-out evidence, add coordinate separation, or open the
source/operator phase on the current artifact.

Independent empirical review:
`AutonomousLab/reviews/CLAUDE_REVIEW_A3F_R2_EMPIRICAL_2026-07-16.md`
(`APPROVE`, no blockers). The review independently reproduced both hashes, all
six raw-record medians, all 120 tripwires, and the unsatisfiable-headroom
finding without executing the spent benchmark seed.
