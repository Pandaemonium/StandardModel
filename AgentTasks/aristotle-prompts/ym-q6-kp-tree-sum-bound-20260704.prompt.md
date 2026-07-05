# Aristotle strategy/proof-design job: Q6 `kp_tree_sum_bound`

You are acting as a Lean 4 proof-design and proof agent for a draft
mathematical physics formalization. The goal is the now-isolated Q6
Kotecky-Preiss rooted tree-sum crux, not the broader cluster expansion.

Formatting: ASCII only, LF line endings. In prose, spell Lean placeholder or
escape-hatch tokens with spaces, e.g. `s o r r y`, `a x i o m`.

## Repository context

Project: `PhysicsSM`, draft GateYM Yang-Mills ladder.

This focused submission package contains the files needed for the target:

- `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPCriterion.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/TreeGraphInequality.lean`
- `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`
- `AgentTasks/fourday-ym-run-2026-07-05/Q6_KP_PARTIAL_SUM_STATUS.md`

The live project is Lean 4 / Mathlib pinned to `leanprover/lean4:v4.28.0`.
Check the target first with:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
```

The semantic context pack is included at:

```text
AgentTasks/context-packs/ym-q6-kp-tree-sum-bound-20260704-20260704-211659.md
```

It is context-selection evidence only. Verify all theorem statements against
the Lean files.

## Current state

The prior Aristotle project `9eb41a7c` returned `COMPLETE_WITH_ERRORS`.
It usefully narrowed Q6:

- `coeff_absWeight_le_treeTerm` is proved.
- `nbhd`, `kpPsi`, `kpPsi_nonneg`, and `kpPsi_le_exp` are proved.
- `kp_partial_sum_bound` is now derived from one remaining lemma:
  `kp_tree_sum_bound`.

So the current target is not to re-prove the analytic KP recursion. It is to
solve, or sharply design, the missing labeled rooted-tree exponential formula
behind `kp_tree_sum_bound`.

## Exact target

Please prove this theorem in
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`, if feasible:

```lean
theorem kp_tree_sum_bound
    (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (hKP : KPCondition S hdec) (g0 : Gamma)
    (s : Finset {X : Cluster S // X.Connected S hdec /\ X.Touches S g0}) :
    (s.sum (fun X => (spanningTreeCount S hdec X.1 : Real)
        / (Nat.factorial X.1.n : Real) * X.1.absWeight S))
      <= |S.weight g0| * Real.exp (S.energy g0)
```

Do not change its public statement unless you find a genuine counterexample or
a precise missing hypothesis. If the theorem is too large to close in one job,
return the smallest kernel-checked lemma DAG that would close it.

## Mathematical target

The intended proof shape is:

1. Use nonnegativity to enlarge `s` to all relevant clusters of bounded size.
2. Use `X.Touches S g0` to choose or overcount by a root slot carrying a
   polymer incompatible with `g0`.
3. Use relabeling symmetry of `Fin X.n` to reconcile the ordered-cluster
   `1/n!` normalization with the rooted `1/(n-1)!` normalization.
4. Prove the labeled rooted-tree exponential formula: deleting the root
   partitions the remaining slots into rooted subtree blocks, and the finite
   set-partition coefficients match the exponential recursion defining
   `kpPsi`.
5. Finish using `kpPsi_le_exp`.

The prior job reports that concrete one-slot and two-slot cases match the
current normalization. Please preserve that semantics unless Lean exposes a
real mismatch.

## Useful constraints

- Keep `PolymerSystem`, `KPCondition`, `Cluster`, `spanningTreeCount`, and
  `ClusterCoeffData` unchanged.
- Do not reproach the Penrose tree-graph inequality; it is already integrated.
- Do not touch the non-target Q6 handoffs
  `kp_convergence_bound_of_selfIncompatible` and `kp_tail_bound`.
- You may add local helper definitions/lemmas in `PolymerKPConclusion.lean`.
- Prefer small named lemmas for: root-slot overcounting, slot relabeling,
  rooted tree decomposition, and the finite exponential/set-partition identity.

## Success criteria

Best output:

1. A modified `PolymerKPConclusion.lean` with `kp_tree_sum_bound` proved.
2. `lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`
   passing, with no new theorem-surface drift.
3. A concise explanation of the helper lemmas.

Acceptable partial output:

1. A verified helper-lemma DAG that strictly narrows `kp_tree_sum_bound`.
2. A precise remaining Lean statement for the next missing combinatorial
   identity.
3. A short failure note explaining whether the issue is Mathlib API, missing
   finite species infrastructure, normalization, or a true counterexample.

Do not weaken the theorem silently, and do not introduce new assumptions,
fake declarations, broad imports, or executable escape hatches.
