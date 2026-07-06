Prove the single remaining combinatorial `s o r r y` `pairSum_le_expBound` in
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` (around line 972; the
`s o r r y` is at line 986). This is the crux of the Q6 Kotecky-Preiss finite
convergence bound. It is a full finite-combinatorics development, NOT a Mathlib
lookup.

START: `lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`.
If any broader `lake build` is slow or stalls, SKIP it and return your best
verified target-file progress; do not spend the session on build latency.

TARGET (preserve this statement verbatim; do not weaken it):

```lean
lemma pairSum_le_expBound (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat) (g : Gamma) :
    (∑ p : (Σ m : Fin (K + 1 + 2), (Fin m.val -> Gamma)),
        (if Cluster.Touches S ⟨p.1.val, p.2⟩ g
          then ∑ _T ∈ (Finset.univ.filter
              (fun T : SimpleGraph (Fin (⟨p.1.val, p.2⟩ : Cluster S).n) =>
                T ≤ (⟨p.1.val, p.2⟩ : Cluster S).graph S hdec ∧ T.IsTree)),
              (⟨p.1.val, p.2⟩ : Cluster S).absWeight S
                / (Nat.factorial (⟨p.1.val, p.2⟩ : Cluster S).n : Real)
          else 0))
      <= |S.weight g| *
          ∑ k ∈ Finset.range (K + 3),
            (∑ h ∈ nbhd S hdec g, boundedTouchSum S hdec K h) ^ k
              / (Nat.factorial k : Real)
```

The sum is over pairs `(p, T)`: an ordered cluster `p` of size `n <= K+2`
touching `g`, and a spanning tree `T` of its incompatibility graph; each pair
contributes `absWeight(p)/n!`. Bound it by `|w g| * sum_{k<K+3} B^k/k!` with
`B = sum_{h in nbhd g} boundedTouchSum K h`.

## SCAFFOLDING ALREADY IN THE FILE (use it, do not re-prove it)

The proof DAG is heavily scaffolded already. These are proved and available
above the target in the same file - route through them:

- `exists_canonical_root` : a cluster touching `g` has a least slot carrying `g`
  (the canonical root).
- `rhs_forest_expand` : expands the RHS partial exponential into ordered child
  tuples via `Finset.sum_pow'` (the ordered-forest shape after deleting the
  canonical root).
- `factorial_mul_prod_factorial_le` : `k! * prod_j m_j! <= (1 + sum_j m_j)!`
  for positive child-block sizes (the multinomial normalization).
- `tree_root_child_mem_nbhd` : a spanning-tree edge leaving a slot carrying `g`
  lands on a child slot whose polymer lies in `nbhd S hdec g`.
- `treeRootChildren` : the finite set of root-adjacent slots, with
  `treeRootChildren_poly_mem_nbhd`, `treeRootChildren_subset_erase`,
  `treeRootChildren_card_add_one_le` (arity <= n-1).
- `treeRootDeletedGraph` : the induced graph on non-root slots, with adjacency
  equivalence and `treeRootChildAsDeleted`.
- `treeRootChildComponent` : connected component of a root child in the deleted
  graph, with child membership + reachability; `treeRootChildComponent_ne_of_ne`.
- `treeRootChildBlock` : finite wrapper around that component support, with
  membership equivalence, positive cardinality `treeRootChildBlock_card_pos`,
  size bound `treeRootChildBlock_card_add_one_le`, and
  `disjoint_treeRootChildBlock_of_ne` (distinct children => disjoint blocks).

So the block decomposition primitives EXIST. The remaining core is: (a) prove
the `treeRootChildBlock` objects PARTITION `(Fin n) \ {root}` for a spanning
tree rooted at the canonical `g`-slot; (b) monotone-reindex each block to
`Fin m_j` as a smaller ordered subcluster with its induced spanning tree,
preserving `absWeight` and size, touching `h_j := p(child_j) in nbhd g`;
(c) prove `absWeight p = |w g| * prod_j absWeight q_j`; (d) the multiplicity
bound `#preimages <= n!/(k! prod_j m_j!)`; (e) assemble via `Finset.sum_le_sum`
after grouping LHS by RHS index, using `rhs_forest_expand` and
`factorial_mul_prod_factorial_le`.

## INTENDED PROOF (canonical-root deletion + multinomial multiplicity)

For a pair `(p, T)`, `p : Fin n -> Gamma` touching `g`, `T` a spanning tree of
`graph p`:
1. Canonical root `r := least i with p i = g` (`exists_canonical_root`); root
   `T` at `r`.
2. Children `c_1 < ... < c_k` of `r`; deleting `r` splits `T` into subtrees on
   blocks `V_1..V_k` partitioning `(Fin n)\{r}`, `m_j := |V_j|`,
   `sum m_j = n-1` (the `treeRootChildBlock` partition).
3. Monotone-reindex each `V_j` to `Fin m_j`: subcluster `q_j`, spanning tree
   `T_j`, touching `h_j := p(c_j) in nbhd g`; `m_j <= K+1`, `k <= K+2`.
4. `absWeight p = |w g| * prod_j absWeight q_j`.
5. Map `(p,T) |-> (k, (h_j), (q_j,T_j))`, a term of the expanded RHS. The
   number of `(p,T)` at a fixed RHS index is at most the multinomial
   `n!/(k! prod_j m_j!)` (the canonical-least-root + increasing-child
   constraints only REMOVE possibilities). Since each pair weighs
   `|w g| prod absWeight q_j / n!` and `(n!/(k! prod m_j!))/n! =
   1/(k! prod m_j!)`, grouping gives `LHS <= RHS`.

The arithmetic heart is the multiplicity INEQUALITY `N <= n!/(k! prod m_j!)`
(with slack, children counted unrooted via `boundedTouchSum`), not an exact
species identity.

## VERIFIED SLACK (sanity)

Single self-incompatible polymer, weight `x>0`: `LHS = sum n^(n-2)/n! x^n`,
`B = sum m^(m-2)/m! x^m`, `RHS = x exp(B) = x + x^2 + x^3 + (7/6)x^4 + ...`, so
`LHS <= RHS` past leading order.

## CRITICAL: DO NOT USE THE ROOT-OVERCOUNTED REDUCTION (it is FALSE)

Bounding `boundedTouchSum (K+1) g` by the root-overcounted sum
`sum_p (#{r : p r = g}) * treeTerm p` is UNSOUND: overcounting by the number of
`g`-slots turns unrooted Cayley `m^(m-2)` into rooted `m^(m-1)`, which for a
single self-incompatible polymer of small weight `x` EXCEEDS the RHS at order
`x^3` once `K >= 1` (rooted `~ x + x^2 + 1.5 x^3` vs RHS `~ x + x^2 + x^3`).
Root at a SINGLE canonical `g`-slot with multiplicity one; the slack comes from
unrooted children `boundedTouchSum K h` vs rooted children.

## CRITICAL: decidability instance cost

The `Fintype`/`DecidablePred` instances on `SimpleGraph (Fin n)` are very
expensive. `spanningTreeCount` uses `by classical; exact ...`, so its internal
`Finset.filter` carries a classical-tactic decidability instance that does NOT
unify cheaply with an `open Classical` filter: `norm_cast`, `unfold` of
`spanningTreeCount`, and `rw [Finset.card_filter]` TIME OUT even at 1e6
heartbeats. The proved `treeTerm_eq_tree_sum` was closed via a `Finset.card_bij`
identity map, NOT defeq. Route through `treeTerm_eq_tree_sum` and
cardinality-congruence lemmas; avoid forcing `isDefEq`/`whnf` on the graph
`Fintype` instance.

## CONSTRAINTS

- No new `a x i o m`, `n a t i v e _ d e c i d e`, or statement weakening. If
  you cannot fully close it, return the SMALLEST residual sub-lemma(s) with DAG
  progress as a clean narrowing (a documented `s o r r y` on the residual is
  acceptable ONLY as a handoff, with the rest proved).
- Preserve `pairSum_le_expBound`'s statement verbatim; the downstream handoffs
  `kp_convergence_bound_of_selfIncompatible` and `kp_tail_bound` are OUT OF
  SCOPE - leave them untouched (their own `s o r r y`s stay).
- If `lake build` stalls, SKIP it and return the partial proof + smallest
  residual as text/patch. Do NOT spend the session on build latency.
