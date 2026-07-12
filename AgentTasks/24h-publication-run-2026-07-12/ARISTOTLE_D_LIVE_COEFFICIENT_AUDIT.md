# Hostile audit: live four-component coefficient convergence

Audit `LiveWeighted3Plus1Walk.liveModeError_tendsto_zero` and its exact
dependency chain. Check that the actual matrix action is bounded by the stated
L2 operator norm, that the square-summation is nonvacuous, that zeroing outside
the box is not mislabeled as full error convergence, and that no physical-space
or PDE claim follows without Fourier reconstruction. Return exact manuscript
wording and the smallest remaining bulk-plus-tail/Fourier theorem.

```yaml
aristotle:
  project_id: 5e7cf467-9fc5-42ae-a24e-83f3502e8bdf
  task_id: 8543250d-cf7b-4e7e-9318-ca265e1d237f
  target_file: PhysicsSM/Draft/NullEdge/LiveWeighted3Plus1Walk.lean
  expected_module: hostile-audit-report
  submission_project: AgentTasks/aristotle-submit/codex-24h-d-live-coefficient-audit-20260711-project
  output_dir: AgentTasks/aristotle-output/5e7cf467-9fc5-42ae-a24e-83f3502e8bdf
  status: canceled-after-2h-no-report
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Canceled under the run's two-hour stall rule after downloading
`stall-snapshot.zip`. The snapshot contained only the original task note and
source tree; Aristotle had produced no audit report. This timeout is not an
audit verdict.
