Close the crux `s o r r y` in `pairSum_le_expBound` (Q6, in
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`, ~line 986). The
scaffold is now essentially COMPLETE: block decomposition, reindexing, weight
factorization, the arithmetic core (`perPair_absWeight_bound`), AND the
per-fiber value bound (`fiber_value_bound`) are all PROVED. The ENTIRE residual
is now ONE integer combinatorial inequality plus the fiberwise assembly.

START: `lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`
(3 `s o r r y`s: the crux + 2 KNOWN-FALSE downstream - touch ONLY the crux).
If broader `lake build` stalls, SKIP.

## THE ONLY REMAINING OBLIGATION (per the in-file residual comment)

Define the canonical-root classification map `Phi : (p, T) |-> forest target`
`(k = #children, (h_j), (q_j, T_j))`, then close `pairSum_le_expBound` via:

1. **The integer fiber-count inequality (the one real remaining step):**
   `(#Phi^{-1} e) * (k! * prod_j m_j!) <= n!` for each forest target `e`. Prove
   it by an INJECTION `Phi^{-1} e  x  Perm(Fin k)  x  prod_j Perm(Fin m_j)  -->
   Perm(Fin n)` (equivalently orderings of the n slots): a preimage `(p,T)` plus
   an ordering of the k child-blocks plus orderings within each block determines
   an ordering of all n slots (root + blocks), and this is injective because the
   canonical-least-root + block structure lets you RECOVER `(p,T)` and the
   permutations from the total ordering. Then `#preimage * k! * prod m_j! =
   #(domain) <= #(Perm (Fin n)) = n!` by `Fintype.card_le_of_injective` +
   `Fintype.card_perm`.
2. **Fiberwise assembly:** `Finset.sum_fiberwise_of_maps_to` (or
   `Finset.sum_comp`/`Finset.sum_le_sum` grouped by `Phi`), then per fiber apply
   `fiber_value_bound` with `C = #Phi^{-1} e` and the integer inequality from (1),
   then match to the expanded RHS via `rhs_forest_expand` and close with
   `Finset.sum_le_sum_of_subset_of_nonneg`.

The child subcluster sums are `boundedTouchSum S hdec K h_j` (unrooted) giving
`B^k`; `h_j in nbhd g` by `tree_root_child_mem_nbhd`.

## Pitfalls (unchanged)

Root at a SINGLE canonical `g`-slot, multiplicity ONE (root-overcounted is FALSE
at x^3). Route spanning-tree cardinalities through `treeTerm_eq_tree_sum` +
`Finset.card_bij`; never force `isDefEq`/`whnf` on the graph `Fintype` instance.

## Constraints

- Preserve `pairSum_le_expBound` verbatim; do NOT touch the 2 known-false
  downstream theorems. No new `a x i o m`, `n a t i v e _ d e c i d e`,
  weakening. If you cannot fully close it, return the tightest residual (ideally
  the integer inequality as a named lemma) + progress.
- If `lake build` stalls, SKIP; return the proof as a patch.
