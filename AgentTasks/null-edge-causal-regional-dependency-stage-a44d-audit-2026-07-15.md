# Null-edge Stage A44D regional information-flow audit

**Status:** complete-graph dependency obstruction identified

## Exact implementation trace

The compact A44 regional estimator has two different notions of locality.

1. Its realized polynomial field is zero outside the tapered past support of a
   selected pivot.
2. The random computation deciding that support is not local to that visible
   set.

`select_deep_pivots` ranks every eligible event by
`min(globalPastCount, globalFutureCount)`. Changing an event anywhere in the
sprinkling can therefore change the threshold, a tie, or the selected set.

For a selected pivot, `marked_past_statistics` computes the global future count
of every predecessor. `marked_row_data` uses that count in
`min(pastCount, futureCount)` before applying the smooth taper. Points outside
the pivot's past can therefore change which predecessor weights are nonzero.
The interval count entering the retarded kernel is restricted to the pivot
past, but that does not localize the selector or taper.

## Consequence for the covariance theorem

For unconditional selected-row observables on one random sprinkling, the
conservative atom read set is all events. Every pair of rows therefore overlaps
and the safe dependency graph is complete. With `m` selected pivots its maximum
degree is `m-1`.

The kernel-checked theorem
`RegionalCovariance.dependencyVarianceBound_complete` shows

```text
dependencyVarianceBound m (m - 1) sigmaSq kappa
  = sigmaSq * kappa + sigmaSq * (1 - kappa) / m.
```

This does not prove a nonzero variance floor; the expression is an upper bound.
It does prove that dependency degree alone cannot certify concentration for the
current architecture. A separate theorem that `kappa_N -> 0`, or a genuinely
local information-flow redesign, is required.

The live module now also proves the exact asymptotic reduction: if selected
pivot count diverges, the one-row variance scale converges to a finite limit,
and the normalized complete-graph covariance ratio satisfies
`kappa_N -> 0`, then the complete-dependency variance bound tends to zero. This
does not prove any of those physical premises; it isolates covariance decay as
the remaining probabilistic bridge without invoking an effective-count proxy.

The exact finite theorem is intentionally stronger than an empirical effective
pivot count. The A44N effective counts summarize three realized residual
ledgers; they do not bound population covariance ratios or dependency degree.

## Repair candidates

- Define each row inside an order-derived outer Alexandrov germ and compute
  both taper depth and interval data only from that germ.
- Select anchors from an independent thinning, then evaluate rows on the
  complementary process conditional on the anchors.
- Use independently generated graphs as the averaging units and treat
  within-graph regional averaging only as variance reduction inside each unit.
- Retain the current global architecture only with a preregistered replicated
  estimate and analytic upper bound for the complete-graph covariance ratio
  `kappa_N` along refinement.

No `N=200000` or held-out run is needed to establish this information-flow
fact. Density escalation should wait until the successor observable states
which repair it uses.

Focused Aristotle project `476b4880-407d-4661-9dec-48b2b3797ec3` is auditing
whether the exact current estimator admits the required covariance decay or
forces one of these repairs.
