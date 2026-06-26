# Aristotle task: wave 4 least-action and ergodic dynamics push

Date: 2026-06-25

## Objective

Advance the finite dynamics route beyond the current weighted-Laplacian and
strong-law bank. Aim for as much of LA-003/LA-004 and ERG-002/ERG-003/ERG-004
as the existing APIs allow: uniqueness of least-action currents/rates,
equivariance of the selected dynamics, and finite ergodic consequences.

## Build instruction

The submission package intentionally omits `.lake`. Do not run full
`lake build`. If a targeted command against one edited file works, use it only
as a cheap check. If dependency setup fails or looks slow, skip build and return
patchable Lean plus exact blockers.

## Requested output

- Patchable Lean for the most natural least-action/dynamics modules.
- Broad but reviewable helper lemmas: weighted Laplacian range facts,
  uniqueness under zero-sum constraints, preservation of invariant laws, and
  iteration lemmas for finite kernels.
- If a target is not yet well-posed, give the smallest corrected theorem
  statement and the precise missing API.
- A completion report with solved lemmas, failed lemmas, and suggested next
  focused Aristotle targets.

## Files and context

- `AgentTasks/context-packs/nullstrand-wave4-least-action-ergodic-20260625-150653.md`
- `PhysicsSM/NullStrand/ZigZag/MinimalRates.lean`
- `PhysicsSM/NullStrand/Probability/Finite.lean`
- `PhysicsSM/NullStrand/Ergodic/IIDStrongLaw.lean`
- `PhysicsSM/NullStrand/Master/FiniteModel.lean`
- `Sources/NullStrand_Lean_Roadmap_Improved.md`

## Aristotle metadata

```yaml
aristotle:
  project_id: b02280e4-ec8c-48e8-ab29-4513e3490c22
  task_id: b3190408-07b7-4796-b7b5-5c710c072097
  target_file: PhysicsSM/NullStrand/ZigZag/MinimalRates.lean
  expected_module: PhysicsSM.NullStrand.ZigZag.MinimalRates
  submission_project: AgentTasks/aristotle-submit/nullstrand-wave4-least-action-ergodic-20260625-project
  output_dir: AgentTasks/aristotle-output/b02280e4-ec8c-48e8-ab29-4513e3490c22
  status: integrated
```

## Integration

Integrated into `PhysicsSM/NullStrand/Ergodic/RefreshChain.lean`,
`PhysicsSM/NullStrand/NullLift/FiniteLeastAction.lean`, and
`PhysicsSM/NullStrand/ZigZag/MinimalRates.lean`.
Report: `AgentTasks/nullstrand-wave4-least-action-ergodic-report-aristotle-2026-06-25.md`.
