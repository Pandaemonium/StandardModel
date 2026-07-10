# Codex proof job: finite Pluecker action and Hessian mass

Close every proof in `PluckerAction/Core.lean` without changing definitions,
statements, coefficients, or controls. Prove that the supplied spinor pair's
Pluecker disagreement defines a nonnegative finite action, its exact Taylor
formula has the displayed EOM, and its positive-direction Hessian is precisely
the Pluecker mass. Preserve the noncollinear EOM equivalence, two distinct
nonzero rational curvatures, and collinear flat control.

This is the action-principle successor to the landed arbitrary-spinor Hodge
bridge and is modeled clean-room on PhysLean variational/Euler-Lagrange theorem
shapes. It should let the live project identify `quartetSAt(turnScale psi phi)`
as the Hessian operator of a finite action built from the spinor pair.

Do not claim the action itself, spinor decorations, vacuum, units, or observed
masses are uniquely derived from primitive graph data. The theorem derives EOM
and Hessian consequences from the displayed finite action.

Run `lake env lean PluckerAction/Core.lean`; return the complete file.

Context pack:
`AgentTasks/context-packs/plucker-action-hessian-20260710-20260710-023342.md`.

```yaml
aristotle:
  project_id: 1df692db-8204-479c-8db4-5dd8d1359299
  target_file: PluckerAction/Core.lean
  expected_module: PluckerAction.Core
  submission_project: AgentTasks/aristotle-submit/codex-plucker-action-hessian-20260710-project
  output_dir: AgentTasks/aristotle-output/1df692db-8204-479c-8db4-5dd8d1359299
  status: idle; harvested and integrated
```
