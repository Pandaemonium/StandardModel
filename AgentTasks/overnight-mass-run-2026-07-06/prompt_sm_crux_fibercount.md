Close the single remaining `s o r r y` in `pairSum_le_expBound` (the Q6
Kotecky-Preiss labeled rooted-tree exponential crux) in
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`. A prior job proved
the ENTIRE structural scaffold; ONE residual remains, and it is now sharply
isolated. Closing it turns the whole Q6 clustering chain live.

START: `lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`
(reports exactly the three known `s o r r y`s; yours is the one in
`pairSum_le_expBound`, ~line 986). If broader `lake build` stalls, SKIP.

## What is ALREADY PROVED in the file (use these - do not re-prove)

The canonical-root-deletion scaffold is complete and sorry-free:
- Block partition of non-root slots: `exists_treeRootChildBlock_of_ne` (every
  non-root slot lies in some root child's block), `childBlockOf` (non-dependent
  wrapper), `biUnion_childBlockOf` (blocks cover all non-root slots),
  `disjoint_childBlockOf_of_ne` (distinct children -> disjoint blocks),
  `sum_childBlockOf_card` (block sizes sum to `n-1`).
- Block reindexing + weight factorization: `restrictCluster` (monotone reindex
  of a cluster to a slot subset), `absWeight_restrictCluster`,
  `absWeight_eq_root_mul_blocks` (`absWeight p = |w (p r)| * prod_j absWeight q_j`
  over the child blocks).
- Arity/size bounds (`treeRootChildren_card_add_one_le`,
  `treeRootChildBlock_card_add_one_le`), the multinomial normalization
  `factorial_mul_prod_factorial_le` (`k! prod m_j! <= (1+sum m_j)!`), the
  neighbor-membership `tree_root_child_mem_nbhd`, and the RHS expansion
  `rhs_forest_expand` (RHS partial exponential -> ordered child tuples).
- `exists_canonical_root`, `treeTerm_eq_tree_sum` (matches the two spanning-tree
  filters via `Finset.card_bij`, NOT defeq - see the decidability note).

## THE ONE RESIDUAL (the entire remaining task)

The **multiplicity fiber-count + final regrouping**:

1. **Multiplicity bound.** For a fixed RHS "forest target" (a choice of arity
   `k`, neighbor labels `(h_j)`, and child subcluster/tree pairs `(q_j, T_j)`),
   the number of pairs `(p, T)` on the LHS that classify to it is at most the
   multinomial `n! / (k! * prod_j m_j!)`. Construct the classification map
   `(p,T) |-> (k, (h_j), (q_j, T_j))` using the proved partition
   (`childBlockOf` + `sum_childBlockOf_card`) and reindexing (`restrictCluster`,
   `absWeight_eq_root_mul_blocks`), and bound each fiber by an INJECTION into the
   ordered-partition arrangements of the `n-1` non-root labels (the multinomial
   counts the ways to distribute `n-1` labels into `k` ordered blocks of sizes
   `m_j`; the canonical-least-root + increasing-child constraints only REMOVE
   possibilities, giving `<=`).
2. **Regrouping.** Group the LHS sum by the classification map, apply the
   multiplicity bound and `absWeight_eq_root_mul_blocks` so each grouped term is
   `<= |w g| * prod_j absWeight q_j / (k! prod_j m_j!)` (using
   `(n!/(k! prod m_j!))/n! = 1/(k! prod m_j!)`), then match to the expanded RHS
   via `rhs_forest_expand` and close with `Finset.sum_le_sum` /
   `factorial_mul_prod_factorial_le`.

## Verified slack (sanity)

Single self-incompatible polymer weight `x>0`: `LHS = sum n^(n-2)/n! x^n`,
`B = sum m^(m-2)/m! x^m`, `RHS = x exp(B)`; `LHS <= RHS` past leading order. The
root-OVERcounted route (rooting at every g-slot) is FALSE at order `x^3` - root
with multiplicity ONE; slack comes from unrooted vs rooted children.

## decidability instance cost (critical)

`spanningTreeCount` uses `by classical`; its filter does NOT unify cheaply with
`open Classical` filters (`norm_cast`/`unfold`/`rw [Finset.card_filter]` time
out). Route through `treeTerm_eq_tree_sum` and `Finset.card_bij` cardinality
congruence; never force `isDefEq`/`whnf` on the graph `Fintype` instance.

## Constraints

- Preserve the `pairSum_le_expBound` statement verbatim. Do NOT touch the two
  downstream theorems (they are separately known FALSE and documented; out of
  scope) or the crux's neighbors.
- No new `a x i o m`, `n a t i v e _ d e c i d e`, statement weakening. If you
  cannot fully close it, return the smallest residual with a tightened handoff.
- If `lake build` stalls, SKIP; return the proof as a patch/text.
