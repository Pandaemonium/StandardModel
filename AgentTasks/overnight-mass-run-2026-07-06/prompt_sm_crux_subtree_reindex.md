Advance the Q6 crux subtree-reindexing layer in
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`.

Do **not** try to close the full `pairSum_le_expBound` theorem in this job.
Target only the indexing-alignment bridge identified by Aristotle project
`0feb82f9` and the new Codex lemmas already in the file.

Start command:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
```

Expected current state: the file elaborates with the three pre-existing draft
handoffs: the crux and two known-false downstream statements. Do not touch the
two known-false downstream statements.

## Current proved ingredients

The file now has:

- `treeRootChildBlock_mem_iff_reachable`
- `comap_isAcyclic_of_injective`
- `treeRootDeletedGraph_acyclic`
- `comap_orderIso_connected_of_component`
- `treeRootChildBlock_deletedGraph_connected`
- `treeRootChildBlock_deletedGraph_isTree`
- `restrictCluster_comap_le_graph`
- `childBlock_comap_le_restrictCluster_graph`

Together these prove that each child component is a canonically reindexed tree
inside the root-deleted graph, and that any block-comap of the original tree is
a subgraph of the corresponding restricted cluster graph.

## Target theorem

Prove the remaining alignment needed to turn the deleted-component tree into a
spanning tree of the actual restricted child cluster used by the RHS atom.

The exact statement may be adjusted for type convenience, but preserve the
mathematical content:

```lean
lemma childBlock_restrictCluster_subtree_isTree
    (S : PolymerSystem Gamma)
    (hdec : forall g h, Decidable (S.incompatible g h))
    (X : Cluster S) (T : SimpleGraph (Fin X.n)) (r j : Fin X.n)
    (hT : T.IsTree) (hj : j ∈ treeRootChildren T r)
    (hTle : T <= X.graph S hdec) :
    let B := (childBlockOf T r j).image (fun v => v.1)
    let Tj := SimpleGraph.comap
      (fun i : Fin B.card => (B.orderIsoOfFin rfl i : Fin X.n)) T
    Tj <= (restrictCluster S X B).graph S hdec ∧ Tj.IsTree
```

If the `let` form is painful, split it into two lemmas:

1. `childBlock_comap_le_restrictCluster_graph` already exists, so reuse it or
   strengthen it if needed.
2. Prove the `IsTree` half for the image-block reindexing:

```lean
lemma childBlock_comap_isTree
    (T : SimpleGraph (Fin n)) (r j : Fin n)
    (hT : T.IsTree) (hj : j ∈ treeRootChildren T r) :
    (SimpleGraph.comap
      (fun i : Fin (((childBlockOf T r j).image (fun v => v.1)).card) =>
        (((childBlockOf T r j).image (fun v => v.1)).orderIsoOfFin rfl i : Fin n))
      T).IsTree
```

## Proof hint

The hard part is transporting `treeRootChildBlock_deletedGraph_isTree`, whose
vertex type is `Fin (treeRootChildBlock T r j hj).card`, to the graph whose
vertex type is `Fin (((childBlockOf T r j).image Subtype.val).card)`.

Use that, under `hj`,

```lean
childBlockOf T r j = treeRootChildBlock T r j hj
```

and that `Subtype.val` is injective, so the image block has the same cardinality
and the two `orderIsoOfFin` enumerations are order-compatible. A graph isomorphism
or connected/acyclic transport along the resulting `Fin` equivalence is fine.

Useful existing facts:

- `childBlockOf`, `dif_pos hj`
- `Finset.card_image_of_injOn`
- `Finset.orderIsoOfFin`
- `SimpleGraph.Connected.map`
- `SimpleGraph.Walk.IsCycle.map`
- `comap_isAcyclic_of_injective`
- `treeRootChildBlock_deletedGraph_isTree`
- `restrictCluster_comap_le_graph`

## Constraints

- No new assumptions, no statement weakening, no broad refactor.
- Do not add new handoff markers unless the returned result is a deliberately
  documented theorem statement freeze; a complete proof of the alignment lemma is
  strongly preferred.
- If full build stalls, skip it and return the target patch plus the exact Lean
  errors or proof state.
- Preserve `pairSum_le_expBound` verbatim.

## Aristotle metadata

```yaml
aristotle:
  project_id: 28c6c395-a92d-4ac4-891a-fad007a1eb2a
  task_id: 5698fca7-a700-4345-8447-8fe71e9e4431
  target_file: PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion
  submission_project: AgentTasks/aristotle-submit/sm-crux-subtree-reindex-20260706-project
  output_dir: AgentTasks/aristotle-output/28c6c395-a92d-4ac4-891a-fad007a1eb2a
  status: submitted
```
