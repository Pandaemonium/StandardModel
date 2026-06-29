---
aristotle:
  project_id: 241bd9cf-b2d1-41ef-90fe-bc7aff41cba7
  task_id: 9990c2c1-b521-4507-ad6b-dd1f1a147295
  target_file: prompt-only
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-flavored-overlap-round-20260627-project
  output_dir: AgentTasks/aristotle-output/241bd9cf-b2d1-41ef-90fe-bc7aff41cba7
  status: summary_integrated
---

# C123 Aristotle job: matrix-valued Wilson origin criterion

Date: 2026-06-27

## Prompt

Read the attached `ROUND_CONTEXT.md`.

This is a finite-dimensional theorem-design job. Do not build the full repo.

Goal:

Design the finite algebraic origin test for a matrix-valued Wilson/flavored-mass
term `W_branch`.

Setup:

Let `K0` be a finite origin kernel with balance involution `J`, chirality
operator `Gamma`, and candidate matrix-valued Wilson term `W`.

Task:

1. State the finite no-go:

```text
If [W, J] = 0, then W cannot by itself provide an origin polarizer under the
C108 trace-cancellation hypotheses.
```

2. State the finite necessary condition:

```text
Odd_J(W) = (W - J W J) / 2 != 0.
```

3. State a stronger sign-kernel target:

```text
Odd_J(sign(Gamma_K (D0 + W - m0 R))) != 0.
```

4. Give a small 2 x 2 or 4 x 4 witness where `W` is matrix-valued,
   balance-odd, gauge-neutral in a toy sense, and yields nonzero chiral trace.

5. Give a counterexample where `W` is non-scalar but still balance-even, so it
   fails C1.

6. Provide a Lean-friendly API sketch using matrices over `Complex`, with
   `Odd_J`, `Even_J`, and `ChiralTrace`.

Important:

Do not claim physical release. This job is only the finite origin criterion for
matrix-valued Wilson/flavored-mass terms.


## Submission log

Submitted via:

`powershell
aristotle submit --project-dir AgentTasks/aristotle-submit/gate-c1-flavored-overlap-round-20260627-project <prompt from this task note>
`

Aristotle submit output:

`	ext
Project created: 241bd9cf-b2d1-41ef-90fe-bc7aff41cba7

`

Aristotle tasks output:

`	ext
ID                                   CREATED              NAME                           STATUS         
---------------------------------------------------------------------------------------------------------
9990c2c1-b521-4507-ad6b-dd1f1a147295 0 secs ago           ---
aristotle:
  project_id... QUEUED         

`

## Integration status

Summary integrated on 2026-06-27 into AgentTasks/null-edge-aristotle-gate-c1-completed-integration-3-2026-06-27.md, Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md, and AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md. Standalone Aristotle Lean artifacts were not promoted into trusted repo Lean in this pass.
