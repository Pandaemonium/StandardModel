# Aristotle: exact SU(2) crossing locking

Prove the finite two-band theorem that determinant-one unitarity locks a
`+1` crossing to `U=I` and a `-1` crossing to `U=-I`, together with pointwise
Bloch-family forms and determinant-minus-one negative controls.

```yaml
aristotle:
  project_id: 6f7b7727-e445-467d-8f56-e2391df5a410
  task_id: 0a5a58a4-74fe-4a36-994c-bcbfd880a4e3
  target_file: AgentTasks/aristotle-targets/codex_24h_b_su2_crossing_locking.lean
  expected_module: PhysicsSM.Draft.NullEdge.SU2CrossingLocking
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-su2-crossing-locking-20260711-project
  output_dir: AgentTasks/aristotle-output/6f7b7727-e445-467d-8f56-e2391df5a410
  status: canceled-after-two-hour-stall
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

## Stall disposition

At the two-hour limit, an instruct-mode request to return current work timed
out after three minutes.  An in-progress snapshot was downloaded before the
task was explicitly canceled.  The target snapshot still contained all six
original proof holes, so there was no proof artifact to integrate.

The core two matrix theorems were repackaged as the Mathlib-only retry recorded
in `ARISTOTLE_B_SU2_CROSSING_CORE_RETRY.md`.  The four elementary successor
statements will be composed only after that core is kernel-checked.
