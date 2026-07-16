# Null-edge Stage A44r reusable-relation resource preregistration

**Status:** prototype passed; no Phase B physics data opened

## Question

Can the exact A42/A44 strict-order rows be evaluated at several order-selected
pivots without recomputing causal predicates for every pivot and without an
unpacked dense relation matrix?

This is a development-only implementation and resource gate. It does not test
continuum concentration, choose a physical branch, or authorize a large random
run.

## Frozen implementation

Store the strict transitive relation as little-endian packed bits. During one
bounded two-dimensional construction pass, accumulate every event's global
past and future count. For a selected pivot `x`, recover its past from column
`x` and compute

```text
n(y,x) = popcount(relation_row(y) AND pivot_past(x)).
```

This must equal the literal number of events `z` satisfying `y < z < x`.
Coordinates may construct the flat oracle relation but may not select pivots or
alter counts after the cache is built.

## Frozen development settings

- seed: `20261520`, spawned once per density;
- random events: `5000`, `10000`, `20000`;
- outer diamond duration: `2.0`;
- project-sign compact nonlocal branch;
- cutoff: primary `(0.02, 0.08)`;
- `L/R=0.20`;
- minimum pivots: `8`, with every tied depth retained;
- relation row block: `32`;
- relation column block: `4096`;
- popcount row block: `128`;
- extrapolation target only: `N=400000`, `256` pivots.

There is no held-out split because this stage measures algorithmic exactness
and resources, not a physical response. The generated polynomial responses are
used only as finite-output and pipeline controls.

## Prototype pass conditions

1. Packed order, global counts, every tested pivot interval count, and regional
   responses agree with the direct implementation exactly or to `1e-12` for
   floating responses.
2. The `N=5000` benchmark's first selected pivot repeats a direct interval-count
   comparison.
3. Raw cache size is exactly `n*ceil(n/8)` bytes for total point count `n`.
4. Every density selects at least eight pivots and all six responses are finite.
5. Projected raw `N=400000` relation storage is at most `24 GiB`, and the frozen
   construction block's conservative scratch bound is at most `512 MiB`.
6. Quadratic extrapolation of construction plus 256-pivot extraction from the
   highest measured density is at most 12 hours.

Failure of a resource threshold kills this backend or setting, not either
causal-operator architecture.

## Authorization boundary

Passing this prototype does **not** authorize `N=400000`. A separate stage must
first benchmark at least `N=100000`, verify disk and wall-time scaling, freeze
the physical density/pivot schedule, and retain the full same-graph covariance
ledger. The A44 order-only tied-depth selector is mandatory.

## Frozen-run verdict

All six prototype conditions passed. The `N=20000` cache used `50027503`
bytes, built in `12.93 s`, and evaluated eight selected pivots in `0.079 s`.
Quadratic extrapolation to `N=400000`, 256 pivots gives `20000550003` raw
bytes and `6183 s` total. This extrapolation is not an authorization; Stage
A44r2 must supply the measured `N=100000` point.
