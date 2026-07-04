# Aristotle task note: Q6 abstract KP C1/C2 proof package

```yaml
aristotle:
  project_id: 071d1370-9599-4832-9765-cec65cbbee72
  task_id: 337e35f0-2561-4de1-b811-81715f64619f
  target_file: PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
  expected_module: PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion
  submission_project: AgentTasks/aristotle-submit/ym-q6-abstract-kp-proof-20260704-project
  output_dir: AgentTasks/aristotle-output/071d1370-9599-4832-9765-cec65cbbee72
  status: harvested+integrated-negative
```

## Purpose

Submit the first abstract KP proof package after the Q6 statement freeze and
tree-graph/Ursell audit.  The target is the C1/C2 layer against
`ClusterCoeffData`:

- `kp_cluster_summable`
- `kp_convergence_bound`

The concrete Penrose inequality `treeGraphBound_ursell` and the metric tail
theorem `kp_tail_bound` remain parked.

## Context Pack

Semantic context preflight:

```text
AgentTasks/context-packs/ym-q6-abstract-kp-proof-20260704-141307.md
```

## Local Pre-Submit State

- Dirty worktree contains unrelated Claude/T1 reflection edits; this Q6
  package deliberately avoids those files.
- Aristotle queue before submission: Q2 block-instantiation project
  `50024abf` still running; fewer than four YM jobs running, so another
  focused proof package is appropriate under the run rules.

## Submission Record

Prompt:

```text
AgentTasks/aristotle-prompts/ym-q6-abstract-kp-proof-20260704.prompt.md
```

Focused package:

```text
AgentTasks/aristotle-submit/ym-q6-abstract-kp-proof-20260704-project
```

Pre-submit checks:

```text
pwsh Scripts/prepare_aristotle_focused_submission.ps1 -JobName ym-q6-abstract-kp-proof-20260704 -RootModule PhysicsSM -SourceRoot . -LeanPath PhysicsSM/Draft/NullEdge/GateYM/PolymerKPCriterion.lean,PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean -TaskNote AgentTasks/ym-q6-abstract-kp-proof-aristotle-2026-07-04.md -ExtraPath AgentTasks/aristotle-prompts/ym-q6-abstract-kp-proof-20260704.prompt.md,AgentTasks/context-packs/ym-q6-abstract-kp-proof-20260704-141307.md,AgentTasks/ym-q6-treegraph-ursell-strategy-aristotle-2026-07-04.md
lake build PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion
lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
```

The focused package built successfully and the target check reached exactly
the four documented draft proof placeholders in `PolymerKPConclusion.lean`.
The first direct target-file check failed only because the package had not yet
materialized its local Mathlib/`PhysicsSM` module oleans; after
`lake exe cache get` and the package module build, the target check succeeded.

Submission:

```text
aristotle submit --project-dir AgentTasks/aristotle-submit/ym-q6-abstract-kp-proof-20260704-project <prompt>
```

Result:

```text
Project created: 071d1370-9599-4832-9765-cec65cbbee72
Task: 337e35f0-2561-4de1-b811-81715f64619f
Project status after submit: RUNNING
```

## Harvest / Integration

Aristotle returned COMPLETE, but the result is a statement-correction harvest,
not a clean proof of the original C1/C2 pair.

Headline finding: the old bare-KP C2 target `kp_convergence_bound` is false
without self-incompatibility.  The bare `KPCondition` controls only polymers
incompatible with `g`; if `g` is not incompatible with itself, the single
polymer weight is unconstrained.  Aristotle supplied a one-point counterexample
with no incompatibilities, unit weight, and zero energy.

Integrated source changes:

- added `kp_partial_sum_bound`, isolating the rooted tree-sum crux for C1;
- proved `kp_cluster_summable` from `kp_partial_sum_bound` by
  `summable_of_sum_le`;
- added the counterexample scaffold `cexSystem`, `cexDec`, `cexCoeff`,
  `cexSystem_KP`, `cexWitness`, and helpers;
- added the kernel-checked theorem `kp_convergence_bound_false`;
- replaced the false bare C2 target with
  `kp_convergence_bound_of_selfIncompatible`;
- added the same self-incompatibility hypothesis to `kp_tail_bound`.

Semantic review: accepted with correction.  The original `kp_convergence_bound`
statement was not retained as a public theorem, because it is now known false.
The corrected C2 and metric tail statements remain draft proof handoffs.

Local verification:

```text
lake env lean PhysicsSM/Draft/NullEdge/GateYM/PolymerKPConclusion.lean
lake build PhysicsSM.Draft.NullEdge.GateYM.PolymerKPConclusion
```

Both passed.  The file now has four intended draft proof placeholders:

- `treeGraphBound_ursell`;
- `kp_partial_sum_bound`;
- `kp_convergence_bound_of_selfIncompatible`;
- `kp_tail_bound`.

Axiom audit:

```text
kp_convergence_bound_false:
  [propext, Classical.choice, Quot.sound]
cexSystem_KP:
  [propext, Classical.choice, Quot.sound]
cexWitness_term:
  [propext, Classical.choice, Quot.sound]
kp_cluster_summable:
  [propext, s o r r yAx, Classical.choice, Quot.sound]
kp_convergence_bound_of_selfIncompatible:
  [propext, s o r r yAx, Classical.choice, Quot.sound]
```
