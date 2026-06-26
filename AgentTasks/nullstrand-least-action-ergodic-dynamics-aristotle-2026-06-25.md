# Aristotle task: least-action selector and ergodic dynamics cluster

Date: 2026-06-25

## Objective

Advance the finite dynamics path after G1 leaves: prove as much as possible of
LA-003/LA-004 and ERG-002/003/004, connecting least-action current selection to
coarse velocity and clock-rate convergence where the current APIs permit.

## Requested output

- Patchable Lean for least-action uniqueness and induced equivariant rates.
- Patchable Lean for coarse-velocity / clock-rate long-run consequences of the
  i.i.d. strong-law theorem, if the existing APIs support them.
- A precise split between what is already finite and what needs a Markov/mixing
  theorem or new process construction.
- Helper lemmas are welcome if named and documented.

## Files to inspect first

- `PhysicsSM/NullStrand/NullLift/FiniteLeastAction.lean`
- `PhysicsSM/NullStrand/NullLift/FiniteResidualCurrent.lean`
- `PhysicsSM/NullStrand/Probability/Finite.lean`
- `PhysicsSM/NullStrand/Probability/Trajectory.lean`
- `PhysicsSM/NullStrand/Ergodic/IIDStrongLaw.lean`
- `PhysicsSM/NullStrand/NullFiber/FluxFinite.lean`
- `AgentTasks/null-strand-roadmap-hardening-report-aristotle-2026-06-25.md`

## Constraints

- Do not present an existence theorem as uniqueness.
- Keep finite current/rate statements separate from trajectory convergence.
- If a needed theorem is absent from Mathlib, return the exact missing lemma.

## Aristotle metadata

```yaml
aristotle:
  project_id: c96fdc80-e071-4d59-99d2-b9194699efd5
  task_id: 5945de75-f1d1-42d7-b8b3-8af30b7c6554
  target_file: PhysicsSM/NullStrand/NullLift/FiniteLeastAction.lean
  expected_module: PhysicsSM.NullStrand.NullLift.FiniteLeastAction
  submission_project: AgentTasks/aristotle-submit/nullstrand-least-action-ergodic-dynamics-20260625-project
  output_dir: AgentTasks/aristotle-output/c96fdc80-e071-4d59-99d2-b9194699efd5
  status: failed_after_nudge_no_output
```

## 2026-06-25 nudge

Sent `aristotle continue --mode instruct` to project
`c96fdc80-e071-4d59-99d2-b9194699efd5`: skip full `lake build` and dependency
rebuilds; return patchable Lean or precise blockers.

## 2026-06-25 triage

The original task was canceled by the nudge path and its replacement failed
without patchable Lean output. No live integration was performed. This lane is
being resubmitted with an explicit instruction not to run full `lake build`.
