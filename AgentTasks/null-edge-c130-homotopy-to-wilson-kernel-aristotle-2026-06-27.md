---
aristotle:
  project_id: 7826db07-b1e2-4630-b291-585aca54c73a
  task_id: e80df436-d765-4bfc-9af1-39d6518a0376
  target_file: prompt-only
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-null-edge-overlap-program-20260627-project
  output_dir: AgentTasks/aristotle-output/7826db07-b1e2-4630-b291-585aca54c73a
  status: summary_integrated
---

# C130 Aristotle job: homotopy to Wilson kernel

Date: 2026-06-27

## Prompt

Read the attached `ROUND_CONTEXT.md`.

This is a theorem-design job. Do not build the full repo.

Goal:

Develop the gap-preserving homotopy route:

```text
H_t = (1 - t) H_W + t H_ne.
```

Task:

1. State the finite-dimensional theorem:

If `H_t` is Hermitian for all `t` and has a uniform spectral gap around zero,
then `sign(H_t)` varies continuously/norm-continuously and the overlap index is
constant.

2. State the gauge-covariant/admissible-background version.

3. State what kind of estimates would be needed to prove the gap does not close
for a null-edge `H_ne`.

4. Give counterexamples showing how the homotopy can fail by spectral crossing.

5. Explain how this imports the known overlap anti-doubling mechanism if
successful.

6. Suggest the smallest Lean-friendly finite matrix theorem to formalize first.

Important:

This is the main "inherit known physics" shortcut. Be explicit about every
hypothesis needed.


## Submission log

Submitted via:

`powershell
aristotle submit --project-dir AgentTasks/aristotle-submit/gate-c1-null-edge-overlap-program-20260627-project <prompt from this task note>
`

Aristotle submit output:

`	ext
Project created: 7826db07-b1e2-4630-b291-585aca54c73a

`

Aristotle tasks output:

`	ext
ID                                   CREATED              NAME                           STATUS         
---------------------------------------------------------------------------------------------------------
e80df436-d765-4bfc-9af1-39d6518a0376 0 secs ago           ---
aristotle:
  project_id... QUEUED         

`

## Integration status

Summary integrated on 2026-06-27 into AgentTasks/null-edge-aristotle-gate-c1-completed-integration-4-2026-06-27.md, Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md, and AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md. Standalone Aristotle Lean artifacts were not promoted into trusted repo Lean in this pass.
