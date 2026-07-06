Prove the combinatorial `s o r r y` `pairSum_le_expBound` in
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` (statement around
line 972, `s o r r y` at line 986). This is the crux of the Q6 Kotecky-Preiss
finite convergence bound.

This is an INDEPENDENT second attack running in parallel with another job that
uses the canonical-root-deletion strategy. **Deliberately do NOT rely on the
canonical-root single-deletion route.** Explore a genuinely different proof
architecture so the two attacks do not share a failure mode. Candidate
alternative architectures (pick the most promising, or combine):

1. **Strong induction on `K` (cluster-size budget)** rather than on tree
   structure: relate `boundedTouchSum (K+1) g` to `boundedTouchSum K h` for
   neighbors `h` directly, via the recursive structure of the touch predicate,
   bounding the size-`(K+2)` term by a convolution of smaller bounded-touch
   sums. The RHS partial exponential `sum_{k<K+3} B^k/k!` is exactly the
   truncated exponential generating function of such a convolution; try to
   match order-by-order in the size grading.
2. **Direct injective/weight-preserving encoding** of the pair `(p,T)` (ordered
   cluster + spanning tree) into the ordered-forest index set of the expanded
   RHS (`rhs_forest_expand` gives that index set), proving the encoding is at
   most `n!/(k! prod m_j!)`-to-one by an explicit combinatorial injection with
   quantified multiplicity, WITHOUT going through connected-component block
   objects.
3. **Exponential-formula / species bound**: bound the tree-weighted cluster sum
   by the exponential of the single-polymer neighbor sum using a labeled-species
   composition identity (rooted trees = root x SEQ/SET of subtrees), realized as
   an inequality with the multinomial slack, truncated at the finite budget.

START: `lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`.
If any broader `lake build` is slow, SKIP it and return best target-file
progress.

TARGET (preserve verbatim; do not weaken):

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

## AVAILABLE (proved above the target - use freely)

`exists_canonical_root`, `rhs_forest_expand` (RHS -> ordered child tuples via
`Finset.sum_pow'`), `factorial_mul_prod_factorial_le`
(`k! prod m_j! <= (1+sum m_j)!`), `tree_root_child_mem_nbhd`, `treeRootChildren`
+ arity bounds, `treeRootDeletedGraph`, `treeRootChildComponent`,
`treeRootChildBlock` + `disjoint_treeRootChildBlock_of_ne`, and crucially
`treeTerm_eq_tree_sum` (matches the two spanning-tree filters via
`Finset.card_bij`, NOT defeq).

## KNOWN-FALSE SHAPE (do not resurrect)

Bounding by the root-OVERCOUNTED sum `sum_p (#{r:p r=g}) * treeTerm p` is
UNSOUND: it turns unrooted Cayley `m^(m-2)` into rooted `m^(m-1)`, exceeding the
RHS at order `x^3` for `K>=1`. Any correct route roots/injects with
multiplicity ONE per canonical index and takes its slack from unrooted vs rooted
children.

## VERIFIED SLACK (sanity)

Single self-incompatible polymer weight `x>0`: `LHS = sum n^(n-2)/n! x^n`,
`B = sum m^(m-2)/m! x^m`, `RHS = x exp(B) = x + x^2 + x^3 + (7/6)x^4 + ...`;
`LHS <= RHS` past leading order.

## decidability instance cost

`Fintype`/`DecidablePred` on `SimpleGraph (Fin n)` is very expensive;
`spanningTreeCount` (via `by classical`) does not unify cheaply with an
`open Classical` filter - `norm_cast`/`unfold`/`rw [Finset.card_filter]` time
out. Route through `treeTerm_eq_tree_sum` and cardinality-congruence; never
force `isDefEq`/`whnf` on the graph `Fintype` instance.

## CONSTRAINTS

- No new `a x i o m`, `n a t i v e _ d e c i d e`, statement weakening. Partial
  progress + smallest residual `s o r r y` handoff acceptable if you cannot
  fully close it.
- Leave `kp_convergence_bound_of_selfIncompatible` and `kp_tail_bound`
  untouched.
- If `lake build` stalls, SKIP it; return partial proof + residual as
  text/patch.
