# Aristotle task C72: projected Gate C Wilson release API

```yaml
aristotle:
  project_id: b34c82a7-383c-4325-9eaa-62a0d3ef7f37
  task_id: 3772d7e7-61c1-411e-aea0-5309f795a074
  target_file: PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean
  expected_module: PhysicsSM.Draft.NullEdgeProjectedGateCWilsonRelease
  submission_project: AgentTasks/aristotle-submit/null-edge-wave17-null-wilson-gate-c-20260627-project
  output_dir: AgentTasks/aristotle-output/b34c82a7-383c-4325-9eaa-62a0d3ef7f37
  status: submitted
```

Context pack:

- `AgentTasks/context-packs/null-edge-gate-c-null-wilson-20260627-063900.md`

Goal: add an API-level release theorem for Gate C v3.

Target module:

```text
PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean
```

Requested shape:

```text
structure NullWilsonRegulatedNodalControl ...
structure PostGaugeResiduePositive ...
structure WilsonRegulatorAudited ...

projectedGateCRelease_from_wilson_residue :
  NullWilsonRegulatedNodalControl D_phys ->
  BranchProjectorsControlled D_phys ->
  ProjectedKernelOneDim D_phys ->
  ProjectedChiralityAligned D_phys ->
  ProjectedKreinPositive D_phys ->
  PostGaugeResiduePositive D_phys ->
  SpeciesSplittingAudited R_W ->
  GateCReleased D_phys
```

Reuse existing predicates from `NullEdgeProjectedGateCRelease`,
`NullEdgeGateCGhostZeroSafety`, and related modules where possible. If the
existing names differ, create a thin compatibility wrapper rather than changing
old definitions.

Guardrail:

This theorem releases Gate C only for `D_phys`, never for bare `D_+`.


## Submission record, 2026-06-27

Submitted to Aristotle.

```text
project_id: b34c82a7-383c-4325-9eaa-62a0d3ef7f37
task_id: 3772d7e7-61c1-411e-aea0-5309f795a074
submission_project: AgentTasks/aristotle-submit/null-edge-wave17-null-wilson-gate-c-20260627-project
target: PhysicsSM/Draft/NullEdgeProjectedGateCWilsonRelease.lean
```
