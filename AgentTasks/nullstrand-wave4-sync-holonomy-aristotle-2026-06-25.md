# Aristotle task: wave 4 synchronization and holonomy path-independence

Date: 2026-06-25

## Objective

Push the synchronization lane toward path-independence and curvature-defect
statements. Connect commuting-kernel algebra, internal holonomy, and any finite
defect/flatness lemmas that can be stated without importing speculative graph
physics.

## Build instruction

The submission package intentionally omits `.lake`. Do not run full
`lake build`. If targeted `lake env lean` works on the edited file, use it only
as a cheap check. If dependency setup fails or looks slow, skip build and return
patchable Lean plus exact blockers.

## Requested output

- Patchable Lean for `Clock/InternalHolonomy.lean` or the most appropriate
  synchronization module.
- A finite theorem relating commuting local transports to path-independence.
- A theorem or precise scaffold relating failure of path-independence to a
  holonomy/curvature defect.
- A completion report with proof state, statement changes, and next proof cuts.

## Files and context

- `AgentTasks/context-packs/nullstrand-wave4-sync-holonomy-20260625-150653.md`
- `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean`
- `PhysicsSM/NullStrand/ZigZag/QuantumWalk.lean`
- `PhysicsSM/NullStrand/Probability/Finite.lean`
- `Sources/NullStrand_Lean_Roadmap_Improved.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`

## Aristotle metadata

```yaml
aristotle:
  project_id: c7746d3c-5f9d-4cc8-8d4f-4dff88f4cb3a
  task_id: 409e1c31-d96c-42b7-8dc3-02607225d3ec
  target_file: PhysicsSM/NullStrand/Clock/InternalHolonomy.lean
  expected_module: PhysicsSM.NullStrand.Clock.InternalHolonomy
  submission_project: AgentTasks/aristotle-submit/nullstrand-wave4-sync-holonomy-20260625-project
  output_dir: AgentTasks/aristotle-output/c7746d3c-5f9d-4cc8-8d4f-4dff88f4cb3a
  status: integrated
```

## Integration

Integrated into `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean`.
Report: `AgentTasks/nullstrand-wave4-sync-holonomy-report-aristotle-2026-06-25.md`.
