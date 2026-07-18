# Kernel check: corrected total-residual greedy composition

Date: 2026-07-16  
Work item: `GRAV-ATLAS-PACKING-001`  
Status: standalone proof prepared for later integration

## Result

`GreedyTotalResidual.geometric_coverage_lower_bound` proves the exact rational
factor

```text
(1 - (1 - 1 / k)^k) * optimum <= covered k
```

from a positive natural `k`, zero initial coverage, an average-marginal lower
bound at every step, and accumulation of each gain into total coverage.

The use of **total** covered cardinality is essential. A proposed fallback that
measured only the intersection with one benchmark union was rejected: ordinary
greedy dominance permits gain outside that benchmark and cannot contract the
intersection deficit by itself.

## Boundary

This theorem composes selector inequalities. It does not prove the separate
finite-set average-marginal witness, assert that the causal family contains a
good cover, or establish an atlas, operator, metric, or G2 result.

## Verification

```text
lake env lean AgentTasks/aristotle-standalone/greedy-total-residual-20260716/GreedyTotalResidual/GreedyTotalResidual.lean
```

The submitted Aristotle source for project
`393284aa-586d-4bcd-ad15-f03d63a1131f` was not modified. After that result is
harvested and its three frozen finite-set statements survive semantic audit,
this composition can be integrated with them into one guarded draft module.
