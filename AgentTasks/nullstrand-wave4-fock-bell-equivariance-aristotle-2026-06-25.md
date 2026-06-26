# Aristotle task: wave 4 Fock/Bell equivariance push

Date: 2026-06-25

## Objective

Push the Fock/Bell lane from total-mass preservation toward the strongest
honest finite direction-marginal equivariance result that can be expressed in
the current API. Repair naming drift if the existing public theorem is weaker
than its name suggests.

## Build instruction

The submission package intentionally omits `.lake`. Do not run full
`lake build`. If a targeted command such as
`lake env lean PhysicsSM/NullStrand/BellQFT/FockCutoff.lean` works, use it only
as a cheap check. If dependency setup fails or looks slow, skip build and return
patchable Lean plus exact blockers.

## Requested output

- Patchable Lean for `PhysicsSM/NullStrand/BellQFT/FockCutoff.lean` and nearby
  helper files.
- Either a stronger direction-marginal equivariance theorem, or a precise rename
  and documentation patch explaining that the live theorem is only total-mass
  preservation.
- Helper lemmas for composition/iteration of marginal preservation if they fit.
- A short completion report naming solved targets, changed statements, remaining
  proof holes, and any hidden assumptions.

## Files and context

- `AgentTasks/context-packs/nullstrand-wave4-fock-bell-20260625-150653.md`
- `PhysicsSM/NullStrand/BellQFT/FockCutoff.lean`
- `PhysicsSM/NullStrand/BellQFT/BlockSupport.lean`
- `PhysicsSM/NullStrand/BellQFT/BornSafety.lean`
- `PhysicsSM/NullStrand/Probability/Finite.lean`
- `Sources/NullStrand_Lean_Roadmap_Improved.md`

## Aristotle metadata

```yaml
aristotle:
  project_id: 35d0411c-524b-4ccb-89e6-ee16233f24f2
  task_id: 2bcf3082-b08e-4bec-a289-3e28cfb2979c
  target_file: PhysicsSM/NullStrand/BellQFT/FockCutoff.lean
  expected_module: PhysicsSM.NullStrand.BellQFT.FockCutoff
  submission_project: AgentTasks/aristotle-submit/nullstrand-wave4-fock-bell-equivariance-20260625-project
  output_dir: AgentTasks/aristotle-output/35d0411c-524b-4ccb-89e6-ee16233f24f2
  status: integrated
```

## Integration

Integrated into `PhysicsSM/NullStrand/BellQFT/FockCutoff.lean`.
Report: `AgentTasks/nullstrand-wave4-fock-bell-equivariance-report-aristotle-2026-06-25.md`.
