# Q6 bounded-touch finite-partial status

Aristotle project `9c34ed74-cd15-4ee7-ba6f-b6a48c0beda7`, task
`d8bc89dc-2e21-465b-8194-dc7a7dc50467`, completed on 2026-07-05.

## Outcome

Partial harvest: sound narrowing plus verified pitfall analysis, not full Q6
closure.

The public target `boundedTouchSum_succ_le_finitePartial` no longer carries its
own proof placeholder. It is now proved from:

- `boundedTouchSum_eq_touchOnly`, fully proved locally: the connectedness guard
  inside `boundedTouchSum` is redundant because disconnected ordered clusters
  have `spanningTreeCount = 0`, hence `treeTerm = 0`.
- `touchOnlySum_le_expBound`, the single remaining finite-species
  proof-placeholder crux in this chain.

Everything downstream through `boundedTouchSum_succ_le`,
`boundedTouchSum_le_kpPsi`, `kp_tree_sum_bound`, `kp_partial_sum_bound`, and
`kp_cluster_summable` is unchanged except that the dependency now routes
through `touchOnlySum_le_expBound`. The older draft handoffs
`kp_convergence_bound_of_selfIncompatible` and `kp_tail_bound` remain untouched.

## Verified pitfall

Do not use the root-overcounted reduction
`sum p, (#{r : poly r = g}) * treeTerm p`.

That route is unsound: it turns the unrooted Cayley count `m^(m-2)` into the
rooted count `m^(m-1)`. In the single self-incompatible polymer model of small
weight `x`, this already exceeds the desired right-hand side at order `x^3`
for `K >= 1`:

```text
rooted overcount:  ~ x + x^2 + 1.5 * x^3
desired RHS:       ~ x + x^2 + x^3
```

A correct proof must root at one canonical `g`-slot with multiplicity one.

## Smallest remaining statement

```lean
lemma touchOnlySum_le_expBound (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat) (g : Gamma) :
    (sum p : (Sigma m : Fin (K + 1 + 2), (Fin m.val -> Gamma)),
        (if Cluster.Touches S <p.1.val, p.2> g
          then treeTerm S hdec <p.1.val, p.2> else 0))
      <= |S.weight g| *
          sum k in Finset.range (K + 3),
            (sum h in nbhd S hdec g, boundedTouchSum S hdec K h) ^ k
              / (Nat.factorial k : Real)
```

The displayed snippet uses angle brackets for readability; the Lean file uses
the actual subtype constructor syntax.

## Blocker classification

The residual proof is finite labeled rooted-tree / finite-species
exponential-formula infrastructure. A proof likely needs:

- a canonical-root spanning-tree deletion map at the `SimpleGraph (Fin m)`
  level;
- a multinomial label-distribution bound reconciling ordered-cluster
  `1 / m!`, child `1 / k!`, and subtree `prod 1 / n_j!` normalizations as an
  injection with slack, not as an exact identity.

This is a real combinatorial development, comparable in scope to the
integrated Penrose tree-graph inequality, not a Mathlib lookup or a factorial
one-liner.
