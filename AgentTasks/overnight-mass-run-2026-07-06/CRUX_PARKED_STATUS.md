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

## 2026-07-06 Codex increment: first subtree-reindexing bridge

After Aristotle result `0feb82f9` confirmed that the missing layer begins with
subtree-to-spanning-tree reindexing, Codex added the first kernel-checked pieces
of that layer:

- `treeRootChildBlock_mem_iff_reachable`: child-block membership is exactly
  reachability from the root child in the root-deleted graph.
- `comap_isAcyclic_of_injective`: injective graph pullbacks preserve
  acyclicity.
- `treeRootDeletedGraph_acyclic`: deleting the root from a tree leaves an
  acyclic graph.
- `comap_orderIso_connected_of_component`: component connectedness transported
  through the canonical `Fin A.card` ordering.
- `treeRootChildBlock_deletedGraph_connected` and
  `treeRootChildBlock_deletedGraph_isTree`: each root-child component is a
  canonically reindexed tree inside the root-deleted graph.
- `restrictCluster_comap_le_graph` and
  `childBlock_comap_le_restrictCluster_graph`: once a child subtree is aligned
  with a restricted cluster block, the subgraph relation
  `T_j <= q_j.graph` is available.

This does **not** close `pairSum_le_expBound`; it advances residual (1) by
proving the deleted-component subtree is a tree and by isolating the restricted
cluster subgraph half. The remaining bridge is to align the `Fin card` indexing
of `treeRootChildBlock` with the `Fin card` indexing of
`(childBlockOf T r j).image Subtype.val`, so the proved deleted-graph tree can
be transported onto the exact restricted child cluster used by the RHS atom.

## Recommendation

This is a multi-lemma development (subtree spanning-tree API + a careful labeled
injection), best done as a dedicated focused package with the spanning-tree
reindexing built FIRST, not another blind full-crux attempt. It is the single
combinatorial gate to the whole Q6 clustering chain. The statement is CONFIRMED
TRUE (deep proof searches found no counterexample; the arithmetic slack holds).
(Codex is actively building residual (1)'s subtree-reindexing bridge - see the
increment above; do NOT collide with its `PolymerKPConclusion.lean` edits.)

## Literature (added to Neo4j 2026-07-06; see `LIT_SEARCH_LOG.md`)

`pairSum_le_expBound` IS the Kotecky-Preiss / Fernandez-Procacci tree-graph
bound. These are now in the null-edge graph (collection `9W59V3K9`; search via
`Scripts/lit/neo4j_paper_search.py`), directly supporting the work above:

- **`2001.00652`** ("A simple INDUCTIVE proof of the Fernandez-Procacci
  criterion") - HIGHEST priority: an inductive argument that may AVOID the
  explicit labeled-tree injection (residual (2)) entirely. If it ports, Codex's
  subtree-reindexing bridge feeds it without the hard injection.
- **`math-ph/0605041`** (Fernandez-Procacci) - the Penrose-identity + iterated
  tree-graph bound; the canonical form of exactly this inequality.
- **`cond-mat/0309352`** (Scott-Sokal) - the tree bound via the independent-set
  polynomial; the Penrose/Shearer/Dobrushin lineage for the multiplicity count.
- **`2606.19362`** (2026, RP construction of 4D SU(N) YM with mass gap) - the
  convergent character/polymer expansion in exactly the Q6/Q7 context; mine for
  the clustering assembly downstream of this crux.
