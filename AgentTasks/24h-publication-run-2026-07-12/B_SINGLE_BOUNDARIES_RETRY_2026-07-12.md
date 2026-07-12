# Gate B single-boundary retry

Three independent exact exclusions remain after harvesting the stalled
phase-minus-one boundary census. The solved shared calculations now live in
`StationaryAmplitudeWeylBoundaryScaffold`.

```yaml
aristotle:
  project_id: 1a74593b-f3ab-418b-9fa8-4728178f2bad
  task_id: 35848abb-cf92-4338-805b-34a059f3a9ce
  target_file: AgentTasks/aristotle-targets/codex_24h_b_stationary_weyl_single_boundaries.lean
  expected_module: PhysicsSM.Draft.NullEdge.StationaryAmplitudeWeylSingleBoundaries
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-stationary-weyl-single-boundaries-20260712-project
  output_dir: pending
  status: canceled-after-three-hour-stall-no-progress
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Final snapshot: all three requested boundary theorems still contain their
original proof holes. No lemma was eligible for integration. The job was
canceled under the two-hour stall rule; the exact snapshot is archived under
`AgentTasks/aristotle-output/1a74593b-f3ab-418b-9fa8-4728178f2bad/`.
