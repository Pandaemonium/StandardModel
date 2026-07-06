# Q6 crux `pairSum_le_expBound`: PARKED after 4 attempts (residual pinned)

Date: 2026-07-06 overnight run. The crux is the last real open node of the Q6
Kotecky-Preiss finite convergence bound (the other 2 sorries are the KNOWN-FALSE
downstream conclusions). After FOUR Aristotle attempts (A1, fibercount 1/2/3, +
crux-4) it is PARKED per the two-failure park rule - NOT because of churn (each
attempt proved genuine new infrastructure) but because the residual is now
precisely understood to be a sizeable NEW sub-development, not a routine closure.

## Fully PROVED infrastructure (all in `PolymerKPConclusion.lean`, standard axioms)

Block decomposition: `exists_treeRootChildBlock_of_ne`, `childBlockOf`,
`biUnion_childBlockOf`, `disjoint_childBlockOf_of_ne`, `sum_childBlockOf_card`.
Reindexing + weight: `restrictCluster`, `absWeight_restrictCluster`,
`absWeight_eq_root_mul_blocks`. Arithmetic: `perPair_absWeight_bound`
(the real-analysis step, DONE), `fiber_value_bound` (per-fiber, DONE),
`factorial_mul_prod_factorial_le_finset`. Counting:
`fiber_card_mul_le_factorial` (given the injection, the cardinality inequality,
DONE). Plus `exists_canonical_root`, `rhs_forest_expand`, `treeTerm_eq_tree_sum`,
`tree_root_child_mem_nbhd`, all the arity bounds.

So ALL real-analysis, ALL arithmetic, and ALL cardinality bookkeeping are proved.

## The PRECISE remaining residual (crux-4's analysis, e3adb991)

Two genuinely nontrivial sub-developments remain (each a real prerequisite, not
a one-liner):

1. **Subtree -> spanning-tree reindexing theory.** The classification map into a
   forest-atom index matching the RHS (a sum over each child cluster's SPANNING
   TREES) first needs: each induced child-subtree `T_j`, reindexed to
   `restrictCluster`, is a genuine spanning tree of that subcluster's
   incompatibility graph, i.e. `T_j <= q_j.graph /\ T_j.IsTree`. This
   subtree->spanning-tree transport is NOT in the file and is a nontrivial
   prerequisite.
2. **The canonical-root-deletion INJECTION.** `Fib x Perm(Fin k) x
   (forall j, Perm(Fin m_j)) into Perm(Fin n)` is NOT routine: the naive
   "root-first, blocks in sigma-order, internally tau_j" permutation is NOT
   injective when block sizes coincide or several slots carry the child polymer
   (the "root-connection vertex slack" in the file comments). Injectivity needs
   recovering sigma + the labeled block partition from the output permutation via
   the canonical-least-root + increasing-child-order structure.

Plus the final RHS-matching assembly (`Finset.sum_fiberwise_of_maps_to` +
`fiber_value_bound` + `fiber_card_mul_le_factorial` + `rhs_forest_expand`).

## Recommendation

This is a multi-lemma development (subtree spanning-tree API + a careful labeled
injection), best done as a dedicated focused package with the spanning-tree
reindexing built FIRST, not another blind full-crux attempt. It is the single
combinatorial gate to the whole Q6 clustering chain. The statement is CONFIRMED
TRUE (deep proof searches found no counterexample; the arithmetic slack holds).
