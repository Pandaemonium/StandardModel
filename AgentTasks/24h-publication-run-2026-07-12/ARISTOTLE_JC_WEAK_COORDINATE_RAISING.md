# Aristotle target: exact weak-coordinate raising matrix

## Objective

Close all holes in
`AgentTasks/aristotle-targets/codex_24h_jc_weak_coordinate_raising.lean`
without changing any statement. Compute the exact two-coordinate action of the
trusted `weakRaisingGenerator` and retain both basis controls.

## Semantic boundary

- This is one coordinate infinitesimal `so(10)` generator.
- It is not an `sl(2)` triple, compact real form, group representation, or
  physical `SU(2)_L` theorem.
- Do not swap the coordinate order or repair the sign.

## Verification

Run first:

```text
lake env lean AgentTasks/aristotle-targets/codex_24h_jc_weak_coordinate_raising.lean
```

```yaml
aristotle:
  project_id: ec71b329-76eb-44dc-8428-097f3df81d23
  task_id: pending
  target_file: AgentTasks/aristotle-targets/codex_24h_jc_weak_coordinate_raising.lean
  expected_module: none-task-target
  submission_project: AgentTasks/aristotle-submit/codex-24h-jc-weak-coordinate-raising-20260711-project
  output_dir: AgentTasks/aristotle-output/ec71b329-76eb-44dc-8428-097f3df81d23
  status: submitted
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
