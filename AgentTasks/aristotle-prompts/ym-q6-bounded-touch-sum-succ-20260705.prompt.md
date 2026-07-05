# Aristotle proof job: Q6 `boundedTouchSum_succ_le`

You are acting as a Lean 4 proof-design and proof agent for a draft
mathematical physics formalization. The goal is the single remaining Q6
Kotecky-Preiss rooted-tree crux, not the broader cluster expansion.

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

The live project is Lean 4 / Mathlib pinned to `leanprover/lean4:v4.28.0`.
Check the target first with:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
```

The semantic context pack is included at:

```text
AgentTasks/context-packs/ym-q6-bounded-touch-sum-succ-20260705-20260704-224441.md
```

It is context-selection evidence only. Verify all theorem statements against
the Lean files.

## Current state

Aristotle project `68f1a8c1` was partially integrated. It proved the public
target `kp_tree_sum_bound` modulo exactly one remaining internal theorem:

```lean
theorem boundedTouchSum_succ_le (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h)) (K : Nat) (g : Gamma) :
    boundedTouchSum S hdec (K + 1) g
      <= |S.weight g| *
          Real.exp (sum h in nbhd S hdec g, boundedTouchSum S hdec K h)
```

The following pieces are already kernel-checked in
`PolymerKPConclusion.lean`:

- `treeTerm`;
- `treeTerm_nonneg`;
- `boundedTouchSum`;
- `boundedTouchSum_nonneg`;
- `sum_le_boundedTouchSum`;
- `boundedTouchSum_zero_le`;
- `boundedTouchSum_le_kpPsi`, assuming `boundedTouchSum_succ_le`;
- `kp_tree_sum_bound`, assuming `boundedTouchSum_succ_le`;
- `kpPsi_le_exp`.

So this job is not a retry of Q6. It is a proof attempt or proof-design job
for the exact finite labeled rooted-tree exponential-formula inequality above.

## Mathematical target

Prove, or sharply reduce, the inequality:

```text
boundedTouchSum (K+1) g
  <= |weight g| * exp (sum_{h incompatible with g} boundedTouchSum K h)
```

The intended combinatorial proof:

1. Expand `boundedTouchSum (K+1) g` as all connected ordered clusters of size at
   most `K+2` touching `g`, weighted by `spanningTreeCount / n! * absWeight`.
2. Overcount by choosing a root slot carrying `g`.
3. For each spanning tree of the cluster graph, delete the root. The remaining
   tree components are rooted at neighbors incompatible with `g`; each
   component contributes a bounded-touch-sum term at depth `K`.
4. Reconcile the ordered-cluster `1/n!` normalization with the root choice,
   unordered child blocks, and subtree factorials.
5. Bound the resulting finite sum by the exponential series.

This is a finite labeled rooted-tree / finite-species problem. It should not
require changing `PolymerSystem`, `KPCondition`, `Cluster`, `spanningTreeCount`,
`ClusterCoeffData`, `treeTerm`, or `boundedTouchSum`.

## Constraints

- Do not weaken `boundedTouchSum_succ_le` unless Lean exposes a true
  counterexample or missing hypothesis.
- Do not modify the non-target handoffs
  `kp_convergence_bound_of_selfIncompatible` or `kp_tail_bound`.
- Do not reproach the Penrose tree-graph inequality; it is already integrated
  as `TreeGraphInequality.lean`.
- You may add local helper definitions/lemmas in `PolymerKPConclusion.lean`.
- Prefer small named lemmas for root-slot overcounting, tree-root deletion,
  component partitioning, factorial bookkeeping, and the finite exponential
  bound.

## Success criteria

Best output:

1. A modified `PolymerKPConclusion.lean` with `boundedTouchSum_succ_le` proved.
2. `lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`
   passing.
3. A concise explanation of helper lemmas and any new dependencies.

Acceptable partial output:

1. A verified helper-lemma DAG that strictly narrows `boundedTouchSum_succ_le`.
2. The smallest remaining Lean statement for the next missing finite-species
   identity.
3. A short failure note classifying the blocker as Mathlib API, finite
   rooted-tree infrastructure, factorial normalization, or counterexample.

Do not introduce new assumptions, fake declarations, broad imports, or
executable escape hatches.
