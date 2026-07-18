# Aristotle job: marked Alexandrov layer-zero shell

Date: 2026-07-16  
Work item: `GRAV-ORDER-OPERATOR-001`  
Status: integrated

Semantic context pack:
`AgentTasks/context-packs/marked-alexandrov-layer-shell-20260716-20260716-212145.md`
(SHA-256 `2E8AC5F8276A51FFD1B94A65A97AD51F00664420C960059FDA679B1EFAC029C3`).

## Objective

Prove the exact order-only gates for the marked-Alexandrov shell proposal. For
every finite strict causal order, the zero-open-interval past layer of a marked
event is an antichain, is disjoint from the proposed positive layers one and
three, and is transported exactly by every causal-order isomorphism.

## Exact target

`AgentTasks/aristotle-standalone/marked-alexandrov-layer-shell-20260716/MarkedAlexandrovLayerShell/Core.lean`

Preserve every public definition and theorem statement. Small private helpers
are welcome. Do not add comparability, local finiteness, embedding, coordinate,
or cardinality assumptions. If a target is false, return the minimal
counterexample and corrected statement.

## Proof idea

If `y < z < x`, then `z` is an inhabitant of the open interval from `y` to
`x`, so its cardinality is positive. This contradicts membership of `y` in
layer zero. Distinct layers are disjoint because one event cannot have two
different open-interval counts. Relabeling follows from an explicit
equivalence of open-interval subtypes.

## Scope boundary

This job proves a finite antichain and equivariance fact only. It does not
select a three-dimensional harmonic sector, identify spatial distance, derive
a time direction from an unmarked sprinkling, recover Lorentz invariance, or
establish any continuum statement.

## Preflight

`lake env lean` accepts the focused source under the pinned toolchain with
exactly seven intended proof-hole warnings and no errors. Source SHA-256:
`FF605C26B8DE0DB1C3F6C93B771091688A5FB56FB913E5E5609F3ABE64577FA9`.
The changed-document semantic-index refresh exceeded its three-minute bound;
the context pack therefore uses the last complete index plus the verbatim
focused source. No theorem statement was changed because of that timeout.

## Submission metadata

```yaml
aristotle:
  project_id: 4da526c9-e7dd-4607-8c1a-6f8365723d77
  task_id: 1599e45b-a4a8-48b3-ad92-01c2d74a7863
  target_file: MarkedAlexandrovLayerShell/Core.lean
  expected_module: MarkedAlexandrovLayerShell.Core
  source_root: AgentTasks/aristotle-standalone/marked-alexandrov-layer-shell-20260716
  submission_project: AgentTasks/aristotle-submit/marked-alexandrov-layer-shell-20260716-project
  integration_target: PhysicsSM/Draft/NullEdge/MarkedAlexandrovShellInertia.lean
  output_dir: AgentTasks/aristotle-output/4da526c9-e7dd-4607-8c1a-6f8365723d77
  status: integrated
```

Submitted as a focused Mathlib package. Aristotle reported the project as
created and the task as `QUEUED`; no wait loop was started.

## Integration

The completed candidate preserved all seven public statements, added only two
private interval-map helpers, and contained no proof holes. The candidate file
replayed locally under the pinned toolchain. Its nonduplicate shell,
disjointness, and layer-equivariance results were adapted to the existing
project causal-order definitions in
`PhysicsSM/Draft/NullEdge/MarkedAlexandrovShellInertia.lean`.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdge/MarkedAlexandrovShellInertia.lean
lake build PhysicsSM.Draft.NullEdge.MarkedAlexandrovShellInertia
```

Both passed. The production headline guards report only `propext`,
`Classical.choice`, and `Quot.sound`.
