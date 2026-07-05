# Q6 `touchOnlySum_le_expBound` -- narrowing + proof-design status

Session 2026-07-05. Target file:
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`.

## Outcome (this session)

Verified narrowing of the Q6 crux, no new assumptions / axioms / executable
escape hatches.

* NEW verified lemma `treeTerm_eq_tree_sum` (no `s o r r y`): rewrites the
  single-cluster summand `treeTerm S hdec X` as an explicit sum over the
  spanning trees of the incompatibility graph,
  `treeTerm X = sum_{T <= graph, T.IsTree} (absWeight X / n!)`. This exposes the
  spanning tree `T`, which is the object the canonical-root deletion acts on.
* `touchOnlySum_le_expBound` is now PROVED (no `s o r r y` in its own body)
  from the strictly more structured residual `pairSum_le_expBound` via
  `treeTerm_eq_tree_sum` (a term-wise `Finset.sum_congr` rewrite under the
  `Touches` guard).
* The single remaining Q6 placeholder is now `pairSum_le_expBound` -- the
  labeled rooted-tree exponential-formula inequality with the spanning tree
  made explicit. This is the smallest remaining statement (see below).

The two downstream handoffs `kp_convergence_bound_of_selfIncompatible` and
`kp_tail_bound` are untouched (their `s o r r y`s are pre-existing and out of
scope for this task).

## Smallest remaining Lean statement

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

Equivalently: the sum over pairs `(p, T)` -- an ordered cluster `p` of size
`n <= K+2` touching `g`, and a spanning tree `T` of its incompatibility graph
-- of `absWeight(p)/n!`, is at most
`|w g| * sum_{k < K+3} B^k / k!` with `B = sum_{h in nbhd g} boundedTouchSum K h`.

## Verified slack (why the inequality is true, with room to spare)

Single self-incompatible polymer, weight `x > 0` (the pitfall model). Then
`nbhd(g) = {g}`, every size-`m` cluster's incompatibility graph is `K_m`
(spanning-tree count `m^(m-2)`), and, ignoring the finite range cut-offs (large
`K`), as formal power series in `x`:

```
LHS = sum_{n>=1} n^(n-2)/n! x^n            = x + (1/2)x^2 + (1/2)x^3 + ...
B   = sum_{m>=1} m^(m-2)/m! x^m            = x + (1/2)x^2 + (1/2)x^3 + ...
RHS = x * exp(B) = x + x^2 + x^3 + (7/6)x^4 + ...
```

So LHS <= RHS with a large margin at every order past the leading `x`. The
root-overcounted route (see the caution in the source) instead produces
`sum_n n^(n-1)/n! x^n = x + x^2 + (3/2)x^3 + ...`, which exceeds RHS at `x^3`;
that is why one must root with multiplicity one.

## Intended proof (canonical-root deletion + multinomial multiplicity)

For a pair `(p, T)` with `p : Fin n -> Gamma` touching `g` and `T` a spanning
tree of `graph p`:

1. Canonical root `r := least i with p i = g` (exists by `Touches`). `T` is
   connected, so root it at `r`.
2. Children `c_1 < ... < c_k` of `r` in `T`; deleting `r` splits `T` into
   subtrees on vertex blocks `V_1,...,V_k` partitioning `(Fin n) \ {r}`,
   `m_j := |V_j|`, `sum m_j = n-1`.
3. Monotone-reindex each `V_j` to `Fin m_j`, giving a connected subcluster
   `q_j` with spanning tree `T_j`, touching `h_j := p(c_j)`. Since `c_j` is
   `T`-adjacent to `r`, `S.incompatible g h_j`, so `h_j in nbhd g`; and
   `m_j <= n-1 <= K+1`, `k <= n-1 <= K+2`.
4. `absWeight p = |w g| * prod_j absWeight q_j`.
5. Map `(p,T) |-> (k, (h_j), (q_j, T_j))`, a term of the expanded RHS
   `RHS = |w g| * sum_{k<K+3} (1/k!) * sum_{(h_j)} prod_j (sum_{(q_j,T_j)} absWeight(q_j)/m_j!)`.
   The number of `(p,T)` mapping to a fixed RHS index is at most the
   multinomial coefficient `n! / (k! * prod_j m_j!)` (distributing `n` slots
   into the root and ordered blocks, with the canonical-least-`g`-root and
   increasing-child constraints only removing possibilities). Since each such
   pair has weight `|w g| * prod absWeight(q_j) / n!` and
   `(n!/(k! prod m_j!)) / n! = 1/(k! prod m_j!)`, grouping the LHS by RHS index
   gives `LHS <= RHS`.

The arithmetic heart is the multiplicity bound `N <= n!/(k! * prod m_j!)`; it
is an inequality with slack (children are counted *unrooted* via
`boundedTouchSum`), not an exact species identity -- this is where the
unrooted-vs-rooted slack lives.

## Suggested sub-lemma DAG for a future dedicated pass

* `canonicalRoot`: `Fin n` from a `Touches g` witness (e.g. `Nat.find` /
  `Finset.min'`), with `poly (canonicalRoot) = g` and minimality.
* `rootDeletion`: from `(T : SimpleGraph (Fin n))`, `T.IsTree`, root `r`,
  produce the child set and the block partition of `(Fin n) \ {r}` into the
  connected components of the deleted tree; each block carries an induced tree.
* `blockReindex`: monotone `Fin m_j ~ V_j` transporting the induced tree to a
  subcluster spanning tree; `absWeight`/size invariance.
* `expBound_forest_expand`: expand the RHS `sum_k B^k/k!` into a sum over
  ordered forests of subcluster/tree pairs (multinomial / `Finset.sum_pow`).
* `multiplicity_le_multinomial`: `#preimages <= n!/(k! prod m_j!)`.
* `pairSum_le_expBound`: assemble via `Finset.sum_le_sum` after grouping the
  LHS pairs by their RHS image.

## Blocker classification

Finite labeled rooted-tree / finite-species infrastructure plus
permutation/factorial (multinomial) normalization. NOT a Mathlib lookup and
NOT a factorial one-liner. Comparable in scope to the already-integrated
Penrose tree-graph inequality (`TreeGraphInequality.lean`).

Practical implementation note discovered this session: the `Fintype` /
`DecidablePred` instances on `SimpleGraph (Fin n)` are very expensive. In
particular `spanningTreeCount` is defined via `by classical; exact ...`, so its
internal `Finset.filter` carries the `classical`-tactic decidability instance,
which does not unify cheaply with an `open Classical` filter. Tactics that force
`isDefEq`/`whnf` across these instances (`norm_cast`, `unfold` of
`PenroseTreeGraph.spanningTreeCount`, `rw [Finset.card_filter]` on the
spanning-tree filter) time out even at 1e6 heartbeats. `treeTerm_eq_tree_sum`
was proved by matching the two filters through a `Finset.card_bij` identity map
rather than by defeq; any dedicated pass should route through
`treeTerm_eq_tree_sum` and cardinality-congruence lemmas and avoid defeq on the
graph `Fintype` instance.
