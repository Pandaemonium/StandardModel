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
  status: integrated
```

Submitted 2026-06-22. `aristotle submit` created project
`95795ba9-6e20-4590-a6aa-6785a68607f7`; `aristotle tasks` reported task
`ccbdba71-f00b-4f1d-8cd4-5d87e7375241` as `QUEUED`, and `aristotle list`
reported the project as `RUNNING`.

Packaging note: focused package with the standalone relative-entropy scaffold
and the toy target. The helper found five intended proof holes and no
escape-hatch declarations. A local package build timed out during dependency
setup before reaching the target, so post-return local verification is required.

## Result

Integrated 2026-06-22 from Aristotle project
`95795ba9-6e20-4590-a6aa-6785a68607f7`. The returned
`NullEdgeRecoverabilityToy` proof closed the finite hidden-bit merge witness:
strict observer loss, no exact recovery, and strictly positive recoverability
gap for every candidate recovery channel. Its dependency
`NullEdgeRelativeEntropyObserverRoadmap` was also promoted from standalone
artifact to live draft scaffold and imported by `PhysicsSMDraft.lean`.

Verification:

```text
lake build PhysicsSM.Draft.NullEdgeRelativeEntropyObserverRoadmap
lake env lean PhysicsSM/Draft/NullEdgeRecoverabilityToy.lean
lake build PhysicsSM.Draft.NullEdgeRecoverabilityToy
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeRelativeEntropyObserverRoadmap.lean PhysicsSM/Draft/NullEdgeRecoverabilityToy.lean PhysicsSM/Draft/NullEdgePluckerCelestialBridge.lean
```
