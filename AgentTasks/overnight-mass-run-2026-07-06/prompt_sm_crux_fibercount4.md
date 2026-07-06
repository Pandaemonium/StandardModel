Close the crux `s o r r y` `pairSum_le_expBound` (Q6) in
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` (~line 986). ALL the
arithmetic and counting infrastructure is now PROVED; only TWO things remain: the
explicit canonical-root-deletion INJECTION and the fiberwise ASSEMBLY.

START: `lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`
(3 `s o r r y`s: the crux + 2 KNOWN-FALSE downstream - touch ONLY the crux).

## Fully proved and in scope (use directly)

- `perPair_absWeight_bound`: `absWeight p / n! <= |w g|/k! * prod_j (absWeight q_j / m_j!)`.
- `fiber_value_bound`: given `C * (k! * prod m_j!) <= n!`, bounds the fiber's total.
- **`fiber_card_mul_le_factorial`**: given an injection
  `Fib x Perm (Fin k) x (forall j, Perm (Fin (m j))) ↪ Perm (Fin n)`, concludes
  `#Fib * (k! * prod_j m_j!) <= n!`. (All cardinality bookkeeping done.)
- Block decomposition (`childBlockOf`, `biUnion_childBlockOf`,
  `disjoint_childBlockOf_of_ne`, `sum_childBlockOf_card`), reindexing
  (`restrictCluster`, `absWeight_eq_root_mul_blocks`), `exists_canonical_root`,
  `rhs_forest_expand`, `treeTerm_eq_tree_sum`, `tree_root_child_mem_nbhd`.

## The TWO remaining tasks

1. **Construct the injection** `Fib x Perm(Fin k) x (forall j, Perm(Fin m_j)) ↪
   Perm(Fin n)` for a fixed forest target, where `Fib` = preimage of that target
   under the canonical-root classification map `Phi`. Idea: given a preimage
   `(p,T)` (which determines the canonical root `r`, the child blocks `V_j`, and
   the reindexings), plus an ordering `sigma` of the `k` blocks and orderings
   `tau_j` within each block, BUILD a permutation of `Fin n` (an ordering of all n
   slots: root first, then blocks in `sigma` order, each internally `tau_j`).
   INJECTIVITY: from the resulting `Perm (Fin n)` you can RECOVER `r` (the image of
   0), the block partition (via the canonical structure), hence `(p,T)`, `sigma`,
   `tau_j`. Use `Function.Injective` directly; the canonical-least-root + block
   structure is what makes recovery well-defined.
2. **Fiberwise assembly of `pairSum_le_expBound`:** group the LHS by `Phi`
   (`Finset.sum_fiberwise_of_maps_to` or `Finset.sum_comp`), apply
   `fiber_value_bound` per fiber with `C = #Fib` and `hC` from
   `fiber_card_mul_le_factorial` (step 1's injection), then match the grouped sum
   to the expanded RHS via `rhs_forest_expand` and close with
   `Finset.sum_le_sum_of_subset_of_nonneg`. The child sums are
   `boundedTouchSum S hdec K h_j` (unrooted, giving `B^k`); `h_j in nbhd g` by
   `tree_root_child_mem_nbhd`.

## Pitfalls

Single canonical `g`-root, multiplicity ONE. Route spanning-tree cardinalities
through `treeTerm_eq_tree_sum` + `Finset.card_bij`; never force `isDefEq`/`whnf`
on the graph `Fintype` instance.

## Constraints

- Preserve `pairSum_le_expBound` verbatim; do NOT touch the 2 known-false
  downstream. No new `a x i o m`, `n a t i v e _ d e c i d e`, weakening. If you
  cannot fully close it, return the injection as a named lemma (the tightest
  residual). If `lake build` stalls, SKIP; return the proof as a patch.
