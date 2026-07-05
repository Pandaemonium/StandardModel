# Q6 root-child block decomposition: distinct children give disjoint deleted blocks

Prove the next finite graph-geometry helper(s) for the Q6
`pairSum_le_expBound` DAG in
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`.

This is a focused follow-up after the local helper commits that introduced:

- `treeRootChildren`;
- `treeRootDeletedGraph`;
- `treeRootChildAsDeleted`;
- `treeRootChildComponent`;
- `treeRootChildBlock`.

## Included context

This submission package includes:

- `AgentTasks/context-packs/ym-q6-root-child-block-decomposition-20260705-20260705-140246.md`
  (generated from the available doc/Lean semantic index; the immediate doc-index
  refresh attempt timed out after about three minutes, so the live source files
  are authoritative);
- `AgentTasks/fourday-ym-run-2026-07-05/Q6_PAIRSUM_EXP_BOUND_DAG_PROGRESS.md`;
- `PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` as the target.

Start with:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
```

If a full build is slow, skip it and return the best target-file progress.

## Target theorem shapes

Please try to add and prove these lemmas in
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`, near the existing
`treeRootChildBlock` helper:

```lean
lemma treeRootChildComponent_ne_of_ne {n : Nat} (T : SimpleGraph (Fin n))
    (r j k : Fin n) (hT : T.IsTree)
    (hj : j ∈ treeRootChildren T r) (hk : k ∈ treeRootChildren T r)
    (hjk : j ≠ k) :
    treeRootChildComponent T r j hj ≠ treeRootChildComponent T r k hk := by
  ...

lemma disjoint_treeRootChildBlock_of_ne {n : Nat} (T : SimpleGraph (Fin n))
    (r j k : Fin n) (hT : T.IsTree)
    (hj : j ∈ treeRootChildren T r) (hk : k ∈ treeRootChildren T r)
    (hjk : j ≠ k) :
    Disjoint (treeRootChildBlock T r j hj) (treeRootChildBlock T r k hk) := by
  ...
```

These statements typecheck against the current source if the bodies are left as
proof placeholders. Do not weaken the statements unless you find a genuine
mathematical issue; if a helper hypothesis is missing, report it explicitly.

## Intended argument

For `treeRootChildComponent_ne_of_ne`, suppose two distinct root children `j`
and `k` generate the same component in the root-deleted graph. Then `j` and `k`
are reachable in `treeRootDeletedGraph T r`, hence reachable in `T` by a walk
that never uses the root slot. Together with the two tree edges `T.Adj r j` and
`T.Adj r k`, this gives a cycle in `T`, contradicting `hT : T.IsTree`.

Equivalently, in a tree, removing a vertex separates the connected components
indexed by the neighbors of that vertex. We only need the child-component
separation lemma above, not the whole partition theorem yet.

For `disjoint_treeRootChildBlock_of_ne`, use component separation plus the
membership equivalence `mem_treeRootChildBlock`. If a vertex lay in both
blocks, it would be a common support vertex of both connected components, so
the components would be equal.

Relevant existing local helpers:

- `mem_treeRootChildren`;
- `treeRootDeletedGraph_adj`;
- `treeRootChildAsDeleted_coe`;
- `treeRootChild_mem_component`;
- `treeRootChildComponent_reachable`;
- `mem_treeRootChildBlock`;
- `treeRootChild_mem_block`;
- `treeRootChildBlock_reachable`.

Useful Mathlib areas are likely:

- `SimpleGraph.Walk`;
- `SimpleGraph.Reachable`;
- `SimpleGraph.ConnectedComponent.mem_supp_iff`;
- `SimpleGraph.ConnectedComponent.eq_of_common_vertex`;
- the `SimpleGraph.IsTree` / acyclicity API in
  `Mathlib.Combinatorics.SimpleGraph.Connectivity`.

## Constraints

- Preserve all existing public theorem statements.
- Do not add new assumptions unless the proof genuinely requires one and you
  explain why.
- Do not introduce new escape hatches in trusted code. The target file is draft,
  but the desired result here is a kernel-checked helper pair.
- If the full pair is too hard, return the smallest residual lemma with a
  precise proof plan and the current Lean error.
- The downstream `pairSum_le_expBound`,
  `kp_convergence_bound_of_selfIncompatible`, and `kp_tail_bound` handoffs are
  out of scope; leave them untouched.
