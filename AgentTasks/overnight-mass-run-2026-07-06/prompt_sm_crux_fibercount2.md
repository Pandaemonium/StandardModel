Close the single remaining `s o r r y` in `pairSum_le_expBound` (the Q6
Kotecky-Preiss labeled rooted-tree exponential crux) in
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` (~line 986). The
scaffold is now VERY complete - both the block decomposition AND the arithmetic
core are proved. Only the geometric fiber-count injection + final assembly remain.

START: `lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`
(reports 3 `s o r r y`s; yours is `pairSum_le_expBound`; the other two are
KNOWN-FALSE downstream statements - DO NOT touch them). If broader `lake build`
stalls, SKIP.

## Everything already proved (use directly - do NOT re-prove)

Block decomposition: `exists_treeRootChildBlock_of_ne`, `childBlockOf`,
`biUnion_childBlockOf` (cover), `disjoint_childBlockOf_of_ne` (disjoint),
`sum_childBlockOf_card` (sizes sum to n-1). Reindexing + weight factorization:
`restrictCluster`, `absWeight_restrictCluster`, `absWeight_eq_root_mul_blocks`
(`absWeight p = |w (p r)| * prod_j absWeight q_j`). Arithmetic core:
`factorial_mul_prod_factorial_le_finset` (`(#s)! * prod_{j in s} (m j)! <=
(1 + sum m j)!`) and **`perPair_absWeight_bound`** (`absWeight p / n! <=
|w g|/k! * prod_j (absWeight q_j / m_j!)`). Plus `exists_canonical_root`,
`rhs_forest_expand` (RHS -> ordered child tuples), `treeTerm_eq_tree_sum`
(spanning-tree filters via `Finset.card_bij`), the arity bounds, and
`tree_root_child_mem_nbhd`.

## THE RESIDUAL (the only remaining task)

Assemble `pairSum_le_expBound` from the pieces above via the classification map
`(p, T) |-> (k = #children, (h_j = p(child_j)), (q_j = restrictCluster over
childBlockOf_j, T_j = induced tree))`:

1. **Group the LHS by the classification map.** Each `(p,T)` touching `g` with
   spanning tree `T` maps to a forest target; use `perPair_absWeight_bound` so
   each term is `<= |w g|/k! * prod_j (absWeight q_j / m_j!)`.
2. **Fiber-count / multiplicity.** Bound the number of `(p,T)` mapping to a fixed
   forest target: the canonical-least-root + increasing-child constraints make
   the map at most one-to-one into the ordered arrangements already counted by
   `rhs_forest_expand`'s index set (an INJECTION of each fiber, with slack). So
   grouping and summing gives `LHS <= RHS` by `Finset.sum_le_sum` /
   `Finset.sum_le_sum_of_subset` after matching indices with `rhs_forest_expand`.
3. The children's subcluster sums `sum_{(q_j,T_j)} absWeight q_j / m_j!` are
   exactly `boundedTouchSum S hdec K h_j` (unrooted), giving the `B^k` factor;
   `h_j in nbhd g` by `tree_root_child_mem_nbhd`.

The arithmetic (`perPair_absWeight_bound`) is DONE; the residual is the
COMBINATORIAL bookkeeping of the classification map + its fiber injectivity +
matching to `rhs_forest_expand`.

## Pitfalls

- Root at a SINGLE canonical `g`-slot, multiplicity ONE (the root-overcounted
  sum is FALSE at order x^3). Slack from unrooted vs rooted children.
- `spanningTreeCount` (`by classical`) does NOT unify cheaply with `open
  Classical` filters - route through `treeTerm_eq_tree_sum` + `Finset.card_bij`;
  never force `isDefEq`/`whnf` on the graph `Fintype` instance.

## Constraints

- Preserve the `pairSum_le_expBound` statement verbatim. Do NOT touch the two
  KNOWN-FALSE downstream theorems. No new `a x i o m`, `n a t i v e _ d e c i d e`,
  weakening. Partial progress + tightened residual OK if you cannot fully close.
- If `lake build` stalls, SKIP; return the proof as a patch.
