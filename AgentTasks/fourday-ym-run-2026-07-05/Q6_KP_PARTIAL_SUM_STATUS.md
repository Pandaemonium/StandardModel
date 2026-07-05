# Q6 `kp_partial_sum_bound` status after Aristotle `9eb41a7c`

Project: `9eb41a7c-a84c-49f1-a9ce-afabe02bd731`  
Task: `cf453907-bd90-4299-b09d-ea00371d74b1`  
Outcome: `COMPLETE_WITH_ERRORS`

## Summary

Aristotle did not close Q6 outright. It did, however, narrow the public target
`kp_partial_sum_bound` to one named combinatorial crux,
`kp_tree_sum_bound`, while keeping the public statement unchanged.

Integrated into `PolymerKPConclusion.lean`:

- `coeff_absWeight_le_treeTerm`;
- `nbhd`;
- `kpPsi`;
- `kpPsi_nonneg`;
- `kpPsi_le_exp`;
- `kp_tree_sum_bound` as the remaining documented handoff;
- `kp_partial_sum_bound` now derived from `kp_tree_sum_bound`.

## Remaining crux

`kp_tree_sum_bound` is the rooted KP tree-sum estimate. Aristotle identified
the missing proof as a labeled rooted-tree exponential formula:

1. enlarge a finite family by nonnegativity;
2. root a cluster at a slot touching `g0`;
3. use relabeling symmetry to turn `1/n!` into the rooted `1/(n-1)!`
   normalization;
4. identify root-deleted tree components with the exponential recursion
   `kpPsi`;
5. finish with `kpPsi_le_exp`.

This is comparable in size to the already-integrated Penrose tree-graph
inequality. Two high-effort Aristotle attempts did not close this final crux.

## Verification

```text
lake env lean PhysicsSM\Draft\NullEdge\GateYM\PolymerKPConclusion.lean
```

The check passes with the expected draft handoff warnings at
`kp_tree_sum_bound`, `kp_convergence_bound_of_selfIncompatible`, and
`kp_tail_bound`.
