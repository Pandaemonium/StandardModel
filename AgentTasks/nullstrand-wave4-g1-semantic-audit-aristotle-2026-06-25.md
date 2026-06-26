# Aristotle task: wave 4 G1 semantic audit and strengthening

Date: 2026-06-25

## Objective

Audit the newly integrated `finiteIIDNullStrand_master` and
`checkerboardBohmBell_master` for semantic alignment. Confirm whether they prove
the intended finite G1 claims, identify any projection-shell or assumption-bundle
weakness, and strengthen them if the existing bank supports it.

## Build instruction

The submission package intentionally omits `.lake`. Do not run full
`lake build`. If targeted checks work on the two master files, use them only as
cheap checks. If dependency setup fails or looks slow, skip build and return a
semantic audit plus patchable Lean.

## Requested output

- A theorem-by-theorem audit of hypotheses and conclusions for
  `finiteIIDNullStrand_master` and `checkerboardBohmBell_master`.
- Patchable Lean that tightens names, docstrings, hypotheses, or helper lemmas
  without weakening statements.
- A whitelist of assumptions/fields each theorem still depends on.
- A recommendation: "G1 candidate only", "G1 substantially closed", or "needs
  replacement", with precise reasons.

## Files and context

- `AgentTasks/context-packs/nullstrand-wave4-g1-audit-20260625-150653.md`
- `PhysicsSM/NullStrand/Master/FiniteModel.lean`
- `PhysicsSM/NullStrand/Master/Checkerboard.lean`
- `PhysicsSM/NullStrand/Probability/Trajectory.lean`
- `PhysicsSM/NullStrand/Ergodic/IIDStrongLaw.lean`
- `PhysicsSM/NullStrand/ZigZag/LatticeBeable.lean`
- `Sources/NullStrand_Lean_Roadmap_Improved.md`

## Aristotle metadata

```yaml
aristotle:
  project_id: 300e86eb-533e-4406-99be-c01c1864fe8c
  task_id: f1592029-e3f6-4592-a20a-b1e68f504b1a
  target_file: PhysicsSM/NullStrand/Master/FiniteModel.lean
  expected_module: PhysicsSM.NullStrand.Master.FiniteModel
  submission_project: AgentTasks/aristotle-submit/nullstrand-wave4-g1-semantic-audit-20260625-project
  output_dir: AgentTasks/aristotle-output/300e86eb-533e-4406-99be-c01c1864fe8c
  status: integrated
```

## Integration

Integrated into `PhysicsSM/NullStrand/Master/FiniteModel.lean` and
`PhysicsSM/NullStrand/Master/Checkerboard.lean`.
Report: `AgentTasks/nullstrand-wave4-g1-semantic-audit-report-aristotle-2026-06-25.md`.
