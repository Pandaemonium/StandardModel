# C222 Aristotle task: exact local promotion surface

Date: 2026-06-28

Purpose: inspect copied real artifacts and local C21/branch modules to advise
safe Draft promotion.

```yaml
aristotle:
  project_id: a10bb682-a5ba-4589-800f-b86b3b5d8ada
  task_id: 0c1444dd-4b5b-413e-99d7-44b4980296b6
  target_file: none
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-exact-local-promotion-surface-c222
  prompt_file: AgentTasks\aristotle-prompts\gate-c1-exact-local-promotion-surface-c222.prompt.md
  output_dir: AgentTasks/aristotle-output/a10bb682-a5ba-4589-800f-b86b3b5d8ada
  status: integrated
```

## Requested result

Return promotion surface, collision risks, target files, allowed edit operations,
first Clifford bridge theorem, and stop conditions.

## Integration status

Integrated into docs. Returned artifacts remain external until locally promoted and checked.

## Submission output

`	ext
WARNING: Your project contains .lean files but no lean-toolchain is present.
Aristotle works best with Lean Toolchain leanprover/lean4:v4.28.0

WARNING: Your project contains .lean files but no .lake folder.
Aristotle works better with access to your project's dependencies.
Did you forget to run `lake build`?

Project created: a10bb682-a5ba-4589-800f-b86b3b5d8ada
`

## Task query output

`	ext
ID                                   CREATED              NAME                           STATUS         
---------------------------------------------------------------------------------------------------------
0c1444dd-4b5b-413e-99d7-44b4980296b6 11 secs ago          Project name: gate-c1-exact... QUEUED         
`

## Integration summary

Integrated. Returned exact promotion surface: promote only C193/C194/C201/C202 self-contained artifacts; leave C21/branch external; first bridge theorem branchKernel_chiralIndex_zero.

See also: AgentTasks/null-edge-aristotle-gate-c1-completed-integration-23-2026-06-28.md.
