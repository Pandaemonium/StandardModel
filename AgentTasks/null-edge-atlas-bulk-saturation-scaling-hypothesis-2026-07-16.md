# Atlas bulk-saturation scaling hypothesis from spent A3f-R2 data

## Status and boundary

**Status:** post-hoc hypothesis generation from the spent R2 artifact  
**Not confirmatory evidence:** the same R2 values may not test the law proposed
here  
**Claim boundary:** candidate-family coverage scaling only; no greedy selector,
growing atlas, operator locality, G2, or continuum metric reconstruction

The exact theorem in
`PhysicsSM/Draft/NullEdge/AtlasCoreBulkContainment.lean` proves that every
protected candidate core and every finite union of such cores lies in the
independently defined two-sided order bulk at the same count threshold. Thus
the observed all-event complete-union fraction has the exact finite
factorization

```text
complete_union_all = bulk_fraction * complete_union_bulk_saturation.
```

The external flat four-dimensional law `F_4` calibrates the first factor. The
second factor is the remaining family-capability statistic.

## Spent-data observation

For the R2 medians, let

```text
S_N(beta) = complete_union_bulk_coverage,
D_N(beta) = sqrt(N) * (1 - S_N(beta)).
```

| `N` | `beta` | `S_N` | `1-S_N` | `D_N` |
|---:|---:|---:|---:|---:|
| 4800 | 0.80 | 0.8121 | 0.1879 | 13.02 |
| 4800 | 1.00 | 0.7506 | 0.2494 | 17.28 |
| 4800 | 1.25 | 0.6069 | 0.3931 | 27.24 |
| 9600 | 0.80 | 0.8707 | 0.1293 | 12.67 |
| 9600 | 1.00 | 0.8262 | 0.1738 | 17.03 |
| 9600 | 1.25 | 0.7325 | 0.2675 | 26.21 |

The scaled deficits move by only about `1.4%` to `3.9%` under a density
doubling. This suggests the post-hoc finite-size form

```text
S_N(beta) = 1 - a_beta N^(-1/2) + o(N^(-1/2)),
```

with design centers

```text
a_0.8 = 12.85,
a_1.0 = 17.16,
a_1.25 = 26.73.
```

These constants and the exponent were discovered from R2 and cannot be claimed
as an R2 prediction. They may only define a fresh confirmatory measurement.

## Relation to the growing-atlas no-go

Complete-family saturation and selected-atlas cardinality are distinct. The
kernel-checked finite bound in `GreedyAtlasCoverage.lean` gives

```text
card(selected union) <= K_N * maximum core cardinality.
```

Under the balanced schedule, one core has at most `O(N^(3/4))` events, so
fixed `K=16` has vanishing global coverage and any nonzero continuum target
needs `K_N=Omega(N^(1/4))`. The proposed saturation law concerns whether the
*complete family* approaches the order bulk. Even if confirmed, a separately
preregistered growing-atlas stage remains necessary.

## Confirmatory consequence

A fresh interleaved density pair can test the exponent without reusing the R2
density ladder. If the law holds, then for `N=6000` and `N=12000` the medians
of `D_N(beta)` should agree within a preregistered relative tolerance and
family saturation should increase at every retained rung. Failure would kill
the displayed `N^(-1/2)` law and may kill the balanced complete-family route,
depending on whether candidate abundance and resource tripwires pass.
