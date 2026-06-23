# Aristotle task: P9 weighted adjoint core

```yaml
aristotle:
  project_id: 32a7fb73-8801-453d-8f8c-5c794e4dbe30
  task_id: 5b7e3e29-4a4c-4ecf-ac45-88fcd21e353e
  target_file: NullEdgeP9WeightedAdjointCore/Core.lean
  expected_module: NullEdgeP9WeightedAdjointCore.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-weighted-adjoint-core-20260623-project
  output_dir: AgentTasks/aristotle-output/32a7fb73-8801-453d-8f8c-5c794e4dbe30
  status: integrated
  integrated_file: PhysicsSM/Draft/NullEdgeP9WeightedAdjointCore.lean
  integrated_module: PhysicsSM.Draft.NullEdgeP9WeightedAdjointCore
```

Close the proof holes without changing definitions or theorem statements.

Scientific role: first Tier-A explicit finite Hodge ingredient for P9. With
diagonal positive finite metrics on adjacent cochain spaces, the codifferential
defined in the file should be the weighted adjoint of the coboundary.

## Submission note

Submitted as focused Aristotle project
`32a7fb73-8801-453d-8f8c-5c794e4dbe30`.

## Integration note

Integrated on 2026-06-23 as
`PhysicsSM.Draft.NullEdgeP9WeightedAdjointCore`.

The integrated theorems are:

- `weighted_adjoint_coboundary_codiff`
- `codiff_zero_of_zero_target_metric`

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9WeightedAdjointCore.lean
lake build PhysicsSM.Draft.NullEdgeP9WeightedAdjointCore
lake env lean PhysicsSMDraft.lean
rg -n "\b(sorry|admit|axiom|opaque|unsafe def|native_decide)\b" PhysicsSM/Draft/NullEdgeP9WeightedAdjointCore.lean
rg -n "[^\x00-\x7F]" PhysicsSM/Draft/NullEdgeP9WeightedAdjointCore.lean
```

All targeted checks passed. Aristotle's returned proof used Unicode inverse,
sum, forall, and not-equal symbols; the integrated proof was translated to
ASCII Lean syntax. The first umbrella import check raced the targeted build and
failed before the `.olean` existed; rerunning after the targeted build passed.
