# Aristotle task: wave 4 finite graph super-Dirac spike

Date: 2026-06-25

## Objective

Make the graph/super-Dirac idea concrete at the smallest finite level. Seek a
finite graph operator whose square has an auditable support/decomposition
statement related to causal adjacency, Bell current support, or a holonomy-like
defect block. If the current architecture cannot support that theorem, return a
minimal API proposal with Lean stubs in draft/handoff form only.

## Build instruction

The submission package intentionally omits `.lake`. Do not run full
`lake build`. If targeted `lake env lean` works on one edited file, use it only
as a cheap check. If dependency setup fails or looks slow, skip build and return
patchable Lean plus exact blockers.

## Requested output

- Patchable Lean for `PhysicsSM/NullStrand/Graph/Support.lean`, a new trusted
  finite graph module, or a draft/handoff module if the statement is still too
  speculative.
- A concrete finite operator statement involving support of powers/squares.
- A clear no-go or blocker if the desired super-Dirac square theorem is not yet
  semantically well-posed.
- A completion report separating proven finite graph facts from speculative
  super-Dirac interpretation.

## Files and context

- `AgentTasks/context-packs/nullstrand-wave4-graph-superdirac-20260625-150722.md`
- `PhysicsSM/NullStrand/Graph/Support.lean`
- `PhysicsSM/NullStrand/BellQFT/BlockSupport.lean`
- `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean`
- `Sources/NullStrand_Lean_Roadmap_Improved.md`
- `Sources/Null_Edge_Causal_Graph_Publication_Plan.md`

## Aristotle metadata

```yaml
aristotle:
  project_id: 07fef5d8-a77b-4934-b8a6-e1091278a764
  task_id: 85a7618f-2a9c-44c5-8857-5f7c3594a6ea
  target_file: PhysicsSM/NullStrand/Graph/Support.lean
  expected_module: PhysicsSM.NullStrand.Graph.Support
  submission_project: AgentTasks/aristotle-submit/nullstrand-wave4-graph-superdirac-20260625-project
  output_dir: AgentTasks/aristotle-output/07fef5d8-a77b-4934-b8a6-e1091278a764
  status: integrated
```

## Integration

Integrated into `PhysicsSM/NullStrand/Graph/Support.lean`.
Report: `AgentTasks/nullstrand-wave4-graph-superdirac-report-aristotle-2026-06-25.md`.
