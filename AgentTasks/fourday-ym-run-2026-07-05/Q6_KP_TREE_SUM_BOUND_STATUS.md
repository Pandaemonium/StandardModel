# Q6 `kp_tree_sum_bound` harvest status

Harvest: Aristotle `68f1a8c1`, task `f24433fb`.

## Outcome

This is a partial integration, not a full Q6 closure.  The public theorem
`kp_tree_sum_bound` now has a proof term in Lean, and Aristotle `961529bb`
has narrowed its remaining dependency to exactly one finite combinatorial
handoff:

```text
boundedTouchSum_succ_le_finitePartial
```

That theorem is the finite labeled rooted-tree exponential-formula crux before
passing from a finite partial exponential-series sum to `Real.exp`.  The
analytic step `boundedTouchSum_succ_le` is now proved from it.  The older
handoffs `kp_convergence_bound_of_selfIncompatible` and `kp_tail_bound` remain
untouched.

## Integrated DAG

New or sharpened objects in `PolymerKPConclusion.lean`:

- `treeTerm`: the normalized spanning-tree summand used in
  `kp_tree_sum_bound`;
- `treeTerm_nonneg`;
- `boundedTouchSum`: the finite enlargement over connected clusters touching a
  root polymer with size bounded by depth;
- `boundedTouchSum_nonneg`;
- `sum_le_boundedTouchSum`: any finite touching-cluster family is bounded by
  `boundedTouchSum` at depth `s.sup (fun X => X.1.n)`;
- `boundedTouchSum_zero_le`: the depth-zero case;
- `boundedTouchSum_succ_le_finitePartial`: the sole remaining finite rooted-tree
  exponential-formula handoff;
- `boundedTouchSum_succ_le`: now the proved analytic reduction from the finite
  partial-sum handoff to the exponential recursion;
- `boundedTouchSum_le_kpPsi`: the induction from the handoff to `kpPsi`;
- `kp_tree_sum_bound`: now derived from the bounded-touch-sum chain and
  `kpPsi_le_exp`.

## Remaining crux

`boundedTouchSum_succ_le_finitePartial` should follow by rooting a connected
cluster touching `g`, deleting the root, partitioning the remaining slots into
child subtrees rooted at polymers incompatible with `g`, and reconciling the
ordered `1/n!` normalization with the finite partial-sum exponential recursion.
This is finite labeled-tree infrastructure, not a KP statement ambiguity.

## Verification

`lake env lean PhysicsSM\Draft\NullEdge\GateYM\PolymerKPConclusion.lean`
passes with the expected draft handoff warnings at:

- `boundedTouchSum_succ_le_finitePartial`;
- `kp_convergence_bound_of_selfIncompatible`;
- `kp_tail_bound`.
