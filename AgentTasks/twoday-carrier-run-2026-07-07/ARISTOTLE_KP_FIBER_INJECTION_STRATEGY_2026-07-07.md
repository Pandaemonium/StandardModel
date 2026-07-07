# Aristotle KP Fiber-Injection Strategy Job

Submitted: 2026-07-07 02:45 PDT

```yaml
aristotle:
  project_id: 53109f20-b972-4daa-b0e5-a27defe3c387
  task_id: a363505b-0782-4903-a74e-da6c32129047
  target_file: PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion
  submission_project: AgentTasks/aristotle-submit/tc-kp-fiber-injection-strategy-20260707-0245
  output_dir: AgentTasks/aristotle-output/53109f20-b972-4daa-b0e5-a27defe3c387
  status: complete
```

## Purpose

Focused strategy job for the OS1/KP route after the grand-strategy review
forbade more zero-coupling rungs. The target is not to prove all of
`pairSum_le_expBound`, but to identify the smallest honest next Lean lemma for
the canonical-root fiber-injection/regrouping blocker.

## Context Pack

- `AgentTasks/context-packs/kp-fiber-injection-next-20260707-0245-20260707-023821.md`

## Packet

- `PROMPT.md`
- `PolymerKPConclusion.lean`
- `PolymerKPCriterion.lean`
- `TreeGraphInequality.lean`
- `CONTEXT_PACK.md`
- `THREAD_BOARD.md`
- `LEDGER.md`

## Requested Output

`KP_FIBER_INJECTION_STRATEGY_20260707.md` with:

- viability verdict for the current route;
- smallest next Lean target;
- forest target/fiber-map data structure;
- proof plan with likely Mathlib APIs;
- simplifications avoiding unnecessary tree-isomorphism work;
- ranked next three lemmas after the first one lands.

## Harvest

Result saved under ignored output:

- `AgentTasks/aristotle-output/53109f20-b972-4daa-b0e5-a27defe3c387/kp-fiber-injection-strategy-20260707/tc-kp-fiber-injection-strategy-20260707-0245_aristotle/KP_FIBER_INJECTION_STRATEGY_20260707.md`

Verdict: the route is viable as stated, with no weakening warranted. The sound
shape is canonical single-root classification plus unrooted children; the
remaining difficulty is proof labor, not a false counting statement.

Smallest next Lean target: add a local well-formedness lemma for the
canonical-root child-forest classification map, roughly
`classify_child_forest_wf`, proving the child count bound, child block size
bound, neighborhood membership, touch witness, and restricted-subgraph relation
from existing lemmas. Only after that should the fixed-forest fiber-count
injection into `Perm (Fin n)` be attempted.

Ranked follow-up lemmas:

- fixed-forest fiber-count injection feeding `fiber_card_mul_le_factorial`;
- LHS summand constancy on classification fibers plus `fiber_value_bound`;
- final `pairSum_le_expBound` assembly by fiberwise regrouping and RHS forest
  expansion.

## Local Follow-Up

Codex landed the first Aristotle-recommended support lemma in
`PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`:

- `treeRootChildren_card_lt_of_cluster_bound`;
- `restrictCluster_childBlock_n_lt_of_cluster_bound`;
- `restrictCluster_childBlock_touches_root_child`;
- `root_child_forest_wf`.

These prove the child count/size bounds, neighborhood membership, touch
witness, and restricted-subgraph relation for the root-child forest. The next
KP blocker is now the fixed-forest fiber-count injection into `Perm (Fin n)`.

Verification:

- `lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean`
- `lake build PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion`
- `#print axioms` for the four new declarations: ordinary footprint
  `[propext, Classical.choice, Quot.sound]`.
