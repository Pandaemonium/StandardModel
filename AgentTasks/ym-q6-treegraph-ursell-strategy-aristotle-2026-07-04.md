# Aristotle harvest: Q6 tree-graph / Ursell strategy

```yaml
aristotle:
  project_id: 34d675b8-b24c-4465-8c95-eb2365c93dd3
  task_id: cb526fcd-2ad2-4f5b-9ec7-e3f7aa063e81
  target_file: PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
  expected_module: RequestProject.Main
  submission_project: null
  output_dir: AgentTasks/aristotle-output/34d675b8-b24c-4465-8c95-eb2365c93dd3
  status: harvested
```

## Verdict

Aristotle confirms that the Q6 normalization

```text
|coeff X| * X.n! <= spanningTreeCount X
```

is the right Penrose / tree-graph normalization for ordered clusters, provided
`spanningTreeCount X` counts labeled spanning trees of the incompatibility graph
on `Fin X.n`.  It should not be replaced by the complete-graph tree count.

For the hard-core polymer setting, the concrete unnormalized Ursell sum is the
alternating sum over connected spanning subgraphs of the incompatibility graph:
`sum_H (-1)^(#edges H)`.  The genuine ordered-cluster coefficient divides this
integer by `X.n!`.

## Mathlib gap

Useful APIs exist in the pinned toolchain: finite simple graphs, `SimpleGraph`
tree/connectivity predicates, graph finiteness, edge finsets, and connected
graphs admitting spanning trees.

Missing APIs remain the actual hard content: no spanning-tree count theorem,
no matrix-tree/Kirchhoff theorem, no Cayley formula, and no Ursell/Mayer
alternating connected-subgraph machinery.

## Integrated

`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean` now uses the direct
finite definitions recommended by the report:

- `spanningTreeCount`: filters finite simple graphs on `Fin X.n` to those below
  the cluster incompatibility graph and satisfying `SimpleGraph.IsTree`.
- `ursellSum`: filters finite simple graphs below the incompatibility graph to
  connected spanning subgraphs and sums `(-1) ^ edgeFinset.card`.
- `treeGraphBound_ursell`: parks the concrete Penrose inequality as a dedicated
  theorem target with a documented draft proof handoff.

The abstract KP conclusion theorems remain intentionally conditional on
`ClusterCoeffData`.  That interface is still the correct way to prove the
abstract C1/C2/C3 KP tail package before the concrete Penrose theorem is
available.

## Recommended Next Step

Do not open a matrix-tree or Cayley front.  The next proof packages should be:

1. Easy graph support lemmas for the direct definitions, including disconnected
   support for `ursellSum` and basic `spanningTreeCount` facts.
2. The abstract KP tail-bound package against `ClusterCoeffData`.
3. A separate Penrose tree-graph inequality package for `treeGraphBound_ursell`.

The only executable proof placeholders in the integrated Q6 module are
documented draft handoffs in draft GateYM code.
