# Aristotle task: checkerboard Bohm-Bell G1 master

Date: 2026-06-25

## Objective

State and prove, or scaffold as far as honestly possible, a real
`checkerboardBohmBell_master` theorem. It should assemble existing checkerboard
equivariance/null-step lemmas with trajectory-measure infrastructure rather than
assuming the conclusions as fields.

## Requested output

- Patchable Lean for a new `PhysicsSM/NullStrand/Master/Checkerboard.lean` or
  a carefully revised existing master module.
- A theorem named `checkerboardBohmBell_master` if possible.
- Concrete helper lemmas connecting `latticeBeable_oneStep_equivariant`,
  `latticeBeable_nStep_equivariant`, `actualShift_speed_eq_c`, and finite
  trajectory probability.
- If full assembly is blocked, return a precise blocker list and a smaller
  next proof target.

## Files to inspect first

- `PhysicsSM/NullStrand/ZigZag/LatticeBeable.lean`
- `PhysicsSM/NullStrand/ZigZag/QuantumWalk.lean`
- `PhysicsSM/NullStrand/Probability/Trajectory.lean`
- `PhysicsSM/NullStrand/Master/FiniteModel.lean`
- `PhysicsSM/Spinor/Checkerboard.lean`
- `PhysicsSM/Spinor/CheckerboardDynamics.lean`
- `AgentTasks/null-strand-roadmap-hardening-report-aristotle-2026-06-25.md`

## Constraints

- Do not call a one-step identity a trajectory theorem.
- Do not use an abstract `Prop` bundle as the master proof.
- Keep the result finite and explicit; continuum limits are out of scope.

## Aristotle metadata

```yaml
aristotle:
  project_id: 5d2f7646-f24b-4646-a375-19644de5aaa2
  task_id: feeb54c5-438d-4a56-9600-0f5fc66e9fbf
  target_file: PhysicsSM/NullStrand/Master/Checkerboard.lean
  expected_module: PhysicsSM.NullStrand.Master.Checkerboard
  submission_project: AgentTasks/aristotle-submit/nullstrand-g1-checkerboard-master-20260625-project
  output_dir: AgentTasks/aristotle-output/5d2f7646-f24b-4646-a375-19644de5aaa2
  status: integrated
```

## 2026-06-25 integration

Integrated into `PhysicsSM/NullStrand/Master/Checkerboard.lean` and imported
from `PhysicsSM/NullStrand.lean`.

Primary addition:

- `checkerboardBohmBell_master`

Copied report:
`AgentTasks/nullstrand-g1-checkerboard-master-completion-report-2026-06-25.md`.
