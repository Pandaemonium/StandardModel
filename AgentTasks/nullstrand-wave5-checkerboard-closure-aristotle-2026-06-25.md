# Aristotle task: wave 5 checkerboard master caveat closure

Date: 2026-06-25

## Objective

Close or sharpen the checkerboard caveat identified in the wave-4 semantic
audit. Either strengthen `checkerboardBohmBell_master` toward the intended full
Minkowski null-step statement, or make the public theorem names/docstrings
precisely match the finite statement that is actually proved.

## Build instruction

The submission package intentionally omits `.lake`. Do not run full `lake build`.
If targeted checks work, use:

```powershell
lake env lean PhysicsSM/NullStrand/Master/Checkerboard.lean
lake env lean PhysicsSM/NullStrand/ZigZag/LatticeBeable.lean
```

If dependency setup fails or looks slow, skip build and return patchable Lean
plus exact blockers.

## Requested output

- Patchable Lean for `PhysicsSM/NullStrand/Master/Checkerboard.lean` and any
  required checkerboard helper module.
- A strengthened null-step theorem if the current model supports it.
- If strengthening is not semantically valid, rename or document the theorem so
  it cannot be mistaken for the stronger claim.
- A compact assumption/caveat list suitable for copying into the publication
  plan.

## Files and context

- `AgentTasks/context-packs/nullstrand-wave5-checkerboard-closure-20260625-161755.md`
- `PhysicsSM/NullStrand/Master/Checkerboard.lean`
- `PhysicsSM/NullStrand/ZigZag/LatticeBeable.lean`
- `PhysicsSM/NullStrand/Probability/Trajectory.lean`
- `Sources/NullStrand_Lean_Roadmap_Improved.md`

## Aristotle metadata

```yaml
aristotle:
  project_id: 70b07462-f6e9-46ec-b55d-350b45a7bdb6
  task_id: c9ee9a83-a983-487c-a172-11b7392276b7
  target_file: PhysicsSM/NullStrand/Master/Checkerboard.lean
  expected_module: PhysicsSM.NullStrand.Master.Checkerboard
  submission_project: AgentTasks/aristotle-submit/nullstrand-wave5-checkerboard-closure-20260625-project
  output_dir: AgentTasks/aristotle-output/70b07462-f6e9-46ec-b55d-350b45a7bdb6
  status: integrated
```

## Integration notes

2026-06-25 Codex integration pass:

- Integrated Aristotle's strengthened checkerboard null-step API into:
  - `PhysicsSM/NullStrand/ZigZag/LatticeBeable.lean`
  - `PhysicsSM/NullStrand/Master/Checkerboard.lean`
  - `PhysicsSM/NullStrand/Master/FiniteModel.lean`
- The public `checkerboardBohmBell_master` statement now includes genuine
  Minkowski nullity for each chirality branch, not only time-component
  normalization.
- Added the concrete strengthened checkerboard witness returned by Aristotle.

Verification:

- `lake build PhysicsSM.NullStrand.ZigZag.LatticeBeable`
- `lake build PhysicsSM.NullStrand.Master.Checkerboard`
- `lake build PhysicsSM.NullStrand.Master.FiniteModel`
