# Codex proof job: action-derived flow conjugate to an exact rotation

Close every proof in `ActionFlowRotation/Core.lean` without changing the
recurrence, phase-coordinate map, rotation, hypotheses, `mu=4/25` witness, or
wrong-cosine control.

The main composition theorem must prove that the selected Euler-Lagrange
recurrence is not merely bounded: after an injective coordinate change it is
exactly a unit-circle rotation with conserved Euclidean phase energy. For the
Pluecker fixture use `c=23/25` and `s=4*sqrt(6)/25`; prove the normalization and
nonzero denominator exactly. Keep `c=3/5` as the failure control because it does
not match the recurrence trace.

This bridges the action-derived recurrence to a reversible rotation law. It
does not derive the adjacent-link action, a physical time calibration, or a
continuum field equation. Run `lake env lean ActionFlowRotation/Core.lean`.

```yaml
aristotle:
  project_id: e4dfa6d2-cc6f-4785-a50d-720701e96ca3
  target_file: ActionFlowRotation/Core.lean
  expected_module: ActionFlowRotation.Core
  submission_project: AgentTasks/aristotle-submit/codex-action-flow-rotation-conjugacy-20260710-project
  output_dir: AgentTasks/aristotle-output/e4dfa6d2-cc6f-4785-a50d-720701e96ca3
  status: idle; original target found false, corrected theorem integrated
```
