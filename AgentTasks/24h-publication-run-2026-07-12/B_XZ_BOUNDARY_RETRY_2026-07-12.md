# Gate B xz-boundary retry

This isolated target asks for the exact iff on the only phase-minus-one
boundary containing an identity point. The scaffold already supplies the
`ty = 0` witness and exact axis walk matrices.

```yaml
aristotle:
  project_id: bbe67325-e473-4df9-aef3-ee59c74d1d24
  task_id: d55fc262-5e18-4310-9274-3d984e307997
  target_file: AgentTasks/aristotle-targets/codex_24h_b_stationary_weyl_xz_boundary.lean
  expected_module: PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylXZBoundary
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-stationary-weyl-xz-boundary-20260712-project
  output_dir: pending
  status: canceled-after-three-hour-stall-no-progress
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Final snapshot: both reduction lemmas retain their original proof holes, so
the displayed iff theorem cannot be promoted. The job was canceled under the
two-hour stall rule; the exact snapshot is archived under
`AgentTasks/aristotle-output/bbe67325-e473-4df9-aef3-ee59c74d1d24/`.
