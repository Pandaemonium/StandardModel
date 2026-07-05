# Q6 `kp_partial_sum_bound` status after Aristotle `9eb41a7c`

Project: `9eb41a7c-a84c-49f1-a9ce-afabe02bd731`  
Task: `cf453907-bd90-4299-b09d-ea00371d74b1`  
Outcome: `COMPLETE_WITH_ERRORS`

## Summary

Aristotle did not close Q6 outright. It did, however, narrow the public target
`kp_partial_sum_bound` first to the named combinatorial theorem
`kp_tree_sum_bound`, while keeping the public statement unchanged. Subsequent
harvests now prove `kp_tree_sum_bound` modulo the smaller finite combinatorial
handoff `boundedTouchSum_succ_le_finitePartial`.

Integrated into `PolymerKPConclusion.lean`:

- `coeff_absWeight_le_treeTerm`;
- `nbhd`;
- `kpPsi`;
- `kpPsi_nonneg`;
- `kpPsi_le_exp`;
- `kp_tree_sum_bound` as the remaining documented handoff at this stage;
- `kp_partial_sum_bound` now derived from `kp_tree_sum_bound`.

## Remaining crux

After the later `68f1a8c1` and `961529bb` harvests, `kp_tree_sum_bound` is no
longer the smallest remaining statement. The current missing proof is
`boundedTouchSum_succ_le_finitePartial`, the finite labeled rooted-tree
exponential formula:

1. enlarge a finite family by nonnegativity;
2. root a cluster at a slot touching `g0`;
3. use relabeling symmetry to turn `1/n!` into the rooted `1/(n-1)!`
   normalization;
4. identify root-deleted tree components with the finite partial exponential
   recursion;
5. finish with the already-proved analytic partial-sum-to-exponential step.

This is comparable in size to the already-integrated Penrose tree-graph
inequality. Two high-effort Aristotle attempts did not close this final crux.

## Verification

```text
lake env lean PhysicsSM\Draft\NullEdge\GateYM\PolymerKPConclusion.lean
```

The check now passes with expected draft handoff warnings at
`boundedTouchSum_succ_le_finitePartial`,
`kp_convergence_bound_of_selfIncompatible`, and `kp_tail_bound`.
