# Aristotle task: finite recoverability toy witness

Date: 2026-06-22

## Objective

Prove the T3 relative-entropy recoverability toy witness: merging a hidden bit
loses information strictly and has no exact recovery for two distinct
distributions.

Prompt:

```text
AgentTasks/aristotle-recoverability-toy-prompt-20260622.md
```

Target:

```text
PhysicsSM/Draft/NullEdgeRecoverabilityToy.lean
```

## Aristotle metadata

```yaml
aristotle:
  project_id: 95795ba9-6e20-4590-a6aa-6785a68607f7
  task_id: ccbdba71-f00b-4f1d-8cd4-5d87e7375241
  target_file: PhysicsSM/Draft/NullEdgeRecoverabilityToy.lean
  expected_module: PhysicsSM.Draft.NullEdgeRecoverabilityToy
  submission_project: AgentTasks/aristotle-submit/null-edge-recoverability-toy-20260622-project
  output_dir: AgentTasks/aristotle-output/95795ba9-6e20-4590-a6aa-6785a68607f7
  status: submitted
```

Submitted 2026-06-22. `aristotle submit` created project
`95795ba9-6e20-4590-a6aa-6785a68607f7`; `aristotle tasks` reported task
`ccbdba71-f00b-4f1d-8cd4-5d87e7375241` as `QUEUED`, and `aristotle list`
reported the project as `RUNNING`.

Packaging note: focused package with the standalone relative-entropy scaffold
and the toy target. The helper found five intended proof holes and no
escape-hatch declarations. A local package build timed out during dependency
setup before reaching the target, so post-return local verification is required.
