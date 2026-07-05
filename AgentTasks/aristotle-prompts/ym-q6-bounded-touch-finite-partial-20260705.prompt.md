# Aristotle proof/design job: Q6 `boundedTouchSum_succ_le_finitePartial`

You are acting as a Lean 4 proof-design and proof agent for a draft
mathematical physics formalization. The goal is the narrowed Q6
Kotecky-Preiss finite rooted-tree/species counting crux, not the broader
cluster expansion and not the already-proved analytic exponential step.

Formatting: ASCII only, LF line endings. In prose, spell Lean placeholder or
escape-hatch tokens with spaces, e.g. `s o r r y`, `a x i o m`.

## Repository context

Project: `PhysicsSM`, draft GateYM Yang-Mills ladder.

This focused submission package contains the files needed for the target:

- `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPCriterion.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/TreeGraphInequality.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`
- `AgentTasks/fourday-ym-run-2026-07-05/Q6_KP_PARTIAL_SUM_STATUS.md`
- `AgentTasks/fourday-ym-run-2026-07-05/Q6_KP_TREE_SUM_BOUND_STATUS.md`
- `AgentTasks/fourday-ym-run-2026-07-05/Q6_BOUNDED_TOUCH_SUM_SUCC_STATUS.md`

The live project is Lean 4 / Mathlib pinned to `leanprover/lean4:v4.28.0`.
Check the target first with:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
```

The semantic context pack is included at:

```text
AgentTasks/context-packs/ym-q6-bounded-touch-finite-partial-20260705-20260704-235448.md
```

It is context-selection evidence only. Verify all theorem statements against
the Lean files.

## Current state

Three Aristotle harvests already reduced the Q6 KP chain:

- `9eb41a7c`: `kp_partial_sum_bound` now follows from `kp_tree_sum_bound`.
- `68f1a8c1`: `kp_tree_sum_bound` now follows from the bounded-touch-sum
  recursion layer.
- `961529bb`: `boundedTouchSum_succ_le` is now proved from the finite partial
  theorem below, using `boundedTouchSum_nonneg` and
  `Real.sum_le_exp_of_nonneg`.

The single remaining proof placeholder on this chain is now:

```lean
theorem boundedTouchSum_succ_le_finitePartial (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat) (g : Gamma) :
    boundedTouchSum S hdec (K + 1) g
      <= |S.weight g| *
          sum k in Finset.range (K + 3),
            (sum h in nbhd S hdec g, boundedTouchSum S hdec K h) ^ k
              / (Nat.factorial k : Real)
```

The following pieces are already kernel-checked in
`PolymerKPConclusion.lean`:

- `treeTerm`;
- `treeTerm_nonneg`;
- `boundedTouchSum`;
- `boundedTouchSum_nonneg`;
- `sum_le_boundedTouchSum`;
- `boundedTouchSum_zero_le`;
- `boundedTouchSum_succ_le`, assuming the finite-partial theorem above;
- `boundedTouchSum_le_kpPsi`;
- `kp_tree_sum_bound`;
- `kp_partial_sum_bound`;
- `kp_cluster_summable`.

So this job is not a retry of Q6. It is a proof attempt or proof-design job
for exactly the finite partial-sum bound above.

## Mathematical target

Prove, or sharply reduce, the finite inequality:

```text
boundedTouchSum (K+1) g
  <= |weight g| * sum_{k < K+3}
       (sum_{h incompatible with g} boundedTouchSum K h)^k / k!
```

The intended combinatorial proof:

1. Expand `boundedTouchSum (K+1) g` as all connected ordered clusters of size at
   most `K+2` touching `g`, weighted by `treeTerm`.
2. Overcount by choosing a root slot carrying `g`.
3. For each spanning tree of the cluster graph, delete the root. The remaining
   tree components are rooted at neighbors incompatible with `g`; each
   component contributes a bounded-touch-sum term at depth `K`.
4. Reconcile the ordered-cluster `1/n!` normalization with root choice,
   unordered child blocks, and subtree factorials. This is the real work.
5. Sum over the number of child components `k`; the finite range
   `Finset.range (K + 3)` is intentionally larger than needed and should be
   convenient.

This is a finite labeled rooted-tree / finite-species problem. It should not
require changing `PolymerSystem`, `KPCondition`, `Cluster`, `spanningTreeCount`,
`ClusterCoeffData`, `treeTerm`, or `boundedTouchSum`.

## Constraints

- Do not weaken `boundedTouchSum_succ_le_finitePartial` unless Lean exposes a
  true counterexample or missing hypothesis.
- Do not modify the non-target handoffs
  `kp_convergence_bound_of_selfIncompatible` or `kp_tail_bound`.
- Do not reproach the Penrose tree-graph inequality; it is already integrated
  as `TreeGraphInequality.lean`.
- You may add local helper definitions/lemmas in `PolymerKPConclusion.lean`.
- Prefer small named lemmas for root-slot overcounting, tree-root deletion,
  component partitioning, permutation invariance, and factorial bookkeeping.

## Success criteria

Best output:

1. A modified `PolymerKPConclusion.lean` with
   `boundedTouchSum_succ_le_finitePartial` proved.
2. `lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`
   passing.
3. A concise explanation of helper lemmas and any new dependencies.

Acceptable partial output:

1. A verified helper-lemma DAG that strictly narrows
   `boundedTouchSum_succ_le_finitePartial`.
2. The smallest remaining Lean statement for the next missing finite-species
   identity.
3. A short failure note classifying the blocker as Mathlib API, finite
   rooted-tree infrastructure, permutation/factorial normalization, or
   counterexample.

Do not introduce new assumptions, fake declarations, broad imports, or
executable escape hatches.
