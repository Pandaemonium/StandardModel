# Aristotle proof/design job: Q6 `touchOnlySum_le_expBound`

You are acting as a Lean 4 proof-design and proof agent for a draft
mathematical physics formalization. The goal is the narrowed Q6 finite
labeled-rooted-tree/species counting crux in the Kotecky-Preiss ladder.

Formatting: ASCII only, LF line endings. In prose, spell Lean placeholder or
escape-hatch tokens with spaces, e.g. `s o r r y`, `a x i o m`.

## Repository context

Project: `PhysicsSM`, draft GateYM Yang-Mills ladder.

This focused submission package contains the files needed for the target:

- `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPCriterion.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/TreeGraphInequality.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`
- `AgentTasks/fourday-ym-run-2026-07-05/Q6_BOUNDED_TOUCH_FINITE_PARTIAL_STATUS.md`

The live project is Lean 4 / Mathlib pinned to `leanprover/lean4:v4.28.0`.
Check the target first with:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
```

The semantic context pack is included at:

```text
AgentTasks/context-packs/ym-q6-touch-only-exp-bound-20260705-20260705-013659.md
```

It is context-selection evidence only. Verify every statement against the Lean
files.

## Current state

Q6 has been reduced through several verified partial Aristotle harvests:

- `kp_partial_sum_bound` now follows from `kp_tree_sum_bound`.
- `kp_tree_sum_bound` now follows from the bounded-touch recursion layer.
- `boundedTouchSum_succ_le` is now proved from
  `boundedTouchSum_succ_le_finitePartial` plus the analytic theorem
  `Real.sum_le_exp_of_nonneg`.
- `boundedTouchSum_succ_le_finitePartial` is now proved from
  `boundedTouchSum_eq_touchOnly` plus the theorem below.

The single remaining proof placeholder in this chain is:

```lean
lemma touchOnlySum_le_expBound (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat) (g : Gamma) :
    (sum p : (Sigma m : Fin (K + 1 + 2), (Fin m.val -> Gamma)),
        (if Cluster.Touches S { n := p.1.val, poly := p.2 } g
          then treeTerm S hdec { n := p.1.val, poly := p.2 } else 0))
      <= |S.weight g| *
          sum k in Finset.range (K + 3),
            (sum h in nbhd S hdec g, boundedTouchSum S hdec K h) ^ k
              / (Nat.factorial k : Real)
```

The exact Lean syntax in the file uses subtype constructor notation
`<p.1.val, p.2>` rather than the record literal shown above; use the file as
authoritative.

Already proved in `PolymerKPConclusion.lean`:

- `spanningTreeCount_eq_zero_of_not_connected`;
- `spanningTreeCount_pos_of_connected`;
- `ursellSum_eq_zero_of_not_connected`;
- `treeTerm`;
- `treeTerm_nonneg`;
- `boundedTouchSum`;
- `boundedTouchSum_nonneg`;
- `sum_le_boundedTouchSum`;
- `boundedTouchSum_zero_le`;
- `boundedTouchSum_eq_touchOnly`;
- `boundedTouchSum_succ_le_finitePartial`, assuming `touchOnlySum_le_expBound`;
- `boundedTouchSum_succ_le`;
- `boundedTouchSum_le_kpPsi`;
- `kp_tree_sum_bound`;
- `kp_partial_sum_bound`;
- `kp_cluster_summable`.

So this is not a retry of Q6. It is a proof attempt or proof-design job for
exactly the finite touch-only exponential-formula bound above.

## Mathematical target

Prove, or sharply reduce, the finite inequality:

```text
sum over ordered clusters of size <= K+2 touching g of treeTerm
  <= |weight g| * sum_{k < K+3}
       (sum_{h incompatible with g} boundedTouchSum K h)^k / k!
```

The intended proof is finite combinatorics:

1. For each connected ordered cluster touching `g`, choose one canonical slot
   whose polymer is `g`.
2. For each spanning tree of the cluster incompatibility graph, delete the
   canonical root.
3. The root-adjacent components are rooted at polymers incompatible with `g`.
   Each component should be bounded by a `boundedTouchSum S hdec K h` term.
4. Reconcile the ordered-cluster `1 / n!` normalization with root choice,
   unordered child blocks, and subtree normalizations. The finite range
   `Finset.range (K + 3)` is intentionally generous.

## Known pitfall: do not use root overcounting

Do not first bound by

```text
sum p, (#{r : poly r = g}) * treeTerm p
```

That route is unsound. It turns the unrooted Cayley count `m^(m-2)` into the
rooted count `m^(m-1)`. In the one self-incompatible polymer model of small
weight `x`, it exceeds the desired RHS at order `x^3` for `K >= 1`:

```text
rooted overcount:  ~ x + x^2 + 1.5 * x^3
desired RHS:       ~ x + x^2 + x^3
```

A correct proof must root at a single canonical `g`-slot with multiplicity one.
If that canonical-root construction cannot be completed, return the smallest
verified helper theorem and the exact next missing statement.

## Constraints

- Do not weaken `touchOnlySum_le_expBound` unless Lean exposes a genuine false
  statement or missing hypothesis.
- Do not modify the non-target handoffs
  `kp_convergence_bound_of_selfIncompatible` or `kp_tail_bound`.
- Do not reproach the Penrose tree-graph inequality; it is already integrated
  as `TreeGraphInequality.lean`.
- You may add local helper definitions/lemmas in `PolymerKPConclusion.lean`.
- Prefer small named lemmas for canonical-root selection, tree-root deletion,
  component partitioning, permutation invariance, and factorial bookkeeping.

## Success criteria

Best output:

1. A modified `PolymerKPConclusion.lean` with
   `touchOnlySum_le_expBound` proved.
2. `lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`
   passing.
3. A concise explanation of helper lemmas and any new dependencies.

Acceptable partial output:

1. A verified helper-lemma DAG that strictly narrows
   `touchOnlySum_le_expBound`.
2. The smallest remaining Lean statement for the next missing finite-species
   identity.
3. A short failure note classifying the blocker as Mathlib API, finite
   rooted-tree infrastructure, permutation/factorial normalization, or
   counterexample.

Do not introduce new assumptions, fake declarations, broad imports, or
executable escape hatches.
