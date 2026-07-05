# Q6 crux: prove `pairSum_le_expBound` (labeled rooted-tree exponential inequality)

Prove the single remaining `s o r r y` for the Q6 Kotecky-Preiss finite
convergence crux: `pairSum_le_expBound` in
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`. This is a full
finite-combinatorics development (comparable in scope to the already-integrated
Penrose tree-graph inequality in `TreeGraphInequality.lean`), NOT a Mathlib
lookup or a one-liner.

## Included context

This submission package includes:

- `AgentTasks/context-packs/ym-q6-pairsum-exp-bound-20260705-20260705-080917.md`
  (fresh context pack; the doc-index refresh immediately before generation
  timed out, so use the included source files as the source of truth);
- `AgentTasks/fourday-ym-run-2026-07-05/Q6_TOUCHONLY_EXP_BOUND_NARROWING.md`
  (the verified narrowing note from the previous Aristotle harvest);
- `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` as the target.

Start with the narrow check
`lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`.
If a broader build is slow, skip it and return the best verified target-file
progress rather than spending the session on build latency.

## The target (exact current statement)

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

## Intended proof (canonical-root deletion + multinomial multiplicity)

For a pair `(p, T)` with `p : Fin n -> Gamma` touching `g`, `T` a spanning tree
of `graph p`:

1. Canonical root `r := least i with p i = g` (exists by `Touches`); root `T`
   at `r` (connected since a tree).
2. Children `c_1 < ... < c_k` of `r`; deleting `r` splits `T` into subtrees on
   vertex blocks `V_1..V_k` partitioning `(Fin n) \ {r}`, `m_j := |V_j|`,
   `sum m_j = n-1`.
3. Monotone-reindex each `V_j` to `Fin m_j`: connected subcluster `q_j` with
   spanning tree `T_j`, touching `h_j := p(c_j)`. Since `c_j` is `T`-adjacent to
   `r`, `S.incompatible g h_j`, so `h_j in nbhd g`; and `m_j <= K+1`, `k <= K+2`.
4. `absWeight p = |w g| * prod_j absWeight q_j`.
5. Map `(p,T) |-> (k, (h_j), (q_j,T_j))`, a term of the expanded RHS
   `|w g| * sum_{k<K+3} (1/k!) sum_{(h_j)} prod_j (sum_{(q_j,T_j)} absWeight q_j / m_j!)`.
   The number of `(p,T)` mapping to a fixed RHS index is at most the multinomial
   `n!/(k! prod_j m_j!)` (distributing `n` slots into root + ordered blocks; the
   canonical-least-root and increasing-child constraints only REMOVE
   possibilities). Since each pair weighs `|w g| prod absWeight q_j / n!` and
   `(n!/(k! prod m_j!))/n! = 1/(k! prod m_j!)`, grouping LHS by RHS index gives
   `LHS <= RHS`.

The arithmetic heart is the multiplicity bound `N <= n!/(k! prod m_j!)` (an
INEQUALITY with slack, since children are counted unrooted via
`boundedTouchSum`), not an exact species identity.

## Suggested sub-lemma DAG

- `canonicalRoot` : `Fin n` from a `Touches g` witness (`Nat.find`/`Finset.min'`),
  with `p (canonicalRoot) = g` and minimality.
- `rootDeletion` : from `T.IsTree` + root `r`, the child set and block partition
  of `(Fin n) \ {r}` into deleted-tree components; each block an induced tree.
- `blockReindex` : monotone `Fin m_j ~ V_j` transporting the induced tree to a
  subcluster spanning tree; `absWeight`/size invariance.
- `expBound_forest_expand` : expand `sum_k B^k/k!` into a sum over ordered
  forests of subcluster/tree pairs (`Finset.sum_pow`/multinomial).
- `multiplicity_le_multinomial` : `#preimages <= n!/(k! prod m_j!)`.
- `pairSum_le_expBound` : assemble via `Finset.sum_le_sum` after grouping.

## Verified slack (sanity, holds with margin)

Single self-incompatible polymer, weight `x>0`: `LHS = sum n^(n-2)/n! x^n`,
`B = sum m^(m-2)/m! x^m`, `RHS = x exp(B) = x + x^2 + x^3 + (7/6)x^4 + ...` so
`LHS <= RHS` past leading order. The root-OVERcounted route gives
`sum n^(n-1)/n! x^n` which exceeds RHS at `x^3` - so root with multiplicity one.

## Critical implementation note (decidability instance cost)

The `Fintype`/`DecidablePred` instances on `SimpleGraph (Fin n)` are very
expensive. `spanningTreeCount` is defined via `by classical; exact ...`, so its
internal `Finset.filter` carries the classical-tactic decidability instance,
which does NOT unify cheaply with an `open Classical` filter: `norm_cast`,
`unfold` of `spanningTreeCount`, and `rw [Finset.card_filter]` on the
spanning-tree filter TIME OUT even at 1e6 heartbeats. The already-proved
`treeTerm_eq_tree_sum` was closed by matching the two filters through a
`Finset.card_bij` identity map, NOT by defeq. Route through
`treeTerm_eq_tree_sum` and cardinality-congruence lemmas; avoid forcing
`isDefEq`/`whnf` on the graph `Fintype` instance.

## Constraints

- No new `a x i o m`, `s o r r y` (except the target's own residual if you can
  only partially close it), `n a t i v e _ d e c i d e`, or statement weakening.
  If you cannot fully close it, return the SMALLEST residual sub-lemma(s) with
  the DAG progress, as a clean narrowing.
- **If `lake build` stalls or is slow, SKIP the build and return what you have**
  (partial proof + smallest residual). Do not spend the session on the build.
- Preserve the statement of `pairSum_le_expBound` verbatim; the two downstream
  handoffs `kp_convergence_bound_of_selfIncompatible` and `kp_tail_bound` are
  out of scope - leave them untouched.
