# Aristotle target: concrete Jbar' span preservation

## Objective

Close the single proof hole in
`AgentTasks/aristotle-targets/codex_24h_jc2_span_preservation.lean` without
changing the statement. Use the imported concrete basis action and the trusted
span API. Do not define preservation by transporting the Fock action.

This is the isolated blocker from the canceled broad operator-intertwiner job
`40a38072`.

```yaml
aristotle:
  project_id: c0ff465f-c5af-4f75-a486-936bae64b3ce
  task_id: aaf09984-0453-42ed-886f-28d27ba3bcdd
  target_file: AgentTasks/aristotle-targets/codex_24h_jc2_span_preservation.lean
  expected_module: none-task-target
  submission_project: AgentTasks/aristotle-submit/codex-24h-jc2-span-preservation-20260711-project
  output_dir: AgentTasks/aristotle-output/c0ff465f-c5af-4f75-a486-936bae64b3ce
  status: canceled-after-2h-unchanged
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Canceled under the run's two-hour stall rule after downloading
`stall-snapshot.zip`. The target was byte-for-byte unchanged; no partial proof
was available to harvest. Any resubmission must split the concrete basis cases
rather than repeat this whole span goal.
