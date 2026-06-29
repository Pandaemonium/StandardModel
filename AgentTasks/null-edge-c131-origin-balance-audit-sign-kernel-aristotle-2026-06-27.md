---
aristotle:
  project_id: ab87465f-395b-4f33-8206-ca22afb59bff
  task_id: 36af2704-f780-4512-8634-6c44a44581a4
  target_file: prompt-only
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-null-edge-overlap-program-20260627-project
  output_dir: AgentTasks/aristotle-output/ab87465f-395b-4f33-8206-ca22afb59bff
  status: summary_integrated
---

# C131 Aristotle job: origin balance audit for sign kernel

Date: 2026-06-27

## Prompt

Read the attached `ROUND_CONTEXT.md`.

This is a finite-origin theorem-design job. Do not build the full repo.

Goal:

Design the exact origin diagnostic for a null-edge overlap kernel.

Let:

```text
T0 = sign(H_ne(0,1)) restricted to K0.
```

Task:

1. Define:

```text
Odd_J(T0) = (T0 - J T0 J) / 2.
```

2. State the diagnostic:

```text
Odd_J(T0) != 0;
Tr_K0(Gamma (1 + T0) / 2) != 0.
```

3. Prove or state the no-go:

If `H_ne(0,1)` commutes with `J`, then `sign(H_ne(0,1))` commutes with `J`, so
the diagnostic fails under the C108 trace-cancellation hypotheses.

4. State positive finite witnesses.

5. Explain how this diagnostic relates to, but does not replace, the GW
relation and modified chirality.

6. Provide a Lean-friendly theorem stack based first on polynomial sign
approximations or finite spectral projectors.

## Submission note

Submission attempted after C128-C130 on 2026-06-27, but Aristotle returned:

```text
ERROR - You have too many projects in progress. Cancel a running task or wait
for one to complete before starting another.
```

Resume by submitting this note first once the Aristotle queue has capacity.

## Submission log

Submitted via:

`powershell
aristotle submit --project-dir AgentTasks/aristotle-submit/gate-c1-null-edge-overlap-program-20260627-project <prompt from this task note>
`

Aristotle submit output:

`	ext
Project created: ab87465f-395b-4f33-8206-ca22afb59bff

`

Aristotle tasks output:

`	ext
ID                                   CREATED              NAME                           STATUS         
---------------------------------------------------------------------------------------------------------
36af2704-f780-4512-8634-6c44a44581a4 0 secs ago           ---
aristotle:
  project_id... QUEUED         

`

## Integration status

Summary integrated on 2026-06-27 into AgentTasks/null-edge-aristotle-gate-c1-completed-integration-3-2026-06-27.md, Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md, and AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md. Standalone Aristotle Lean artifacts were not promoted into trusted repo Lean in this pass.
