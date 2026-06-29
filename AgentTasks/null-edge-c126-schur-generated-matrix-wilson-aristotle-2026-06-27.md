---
aristotle:
  project_id: 68710c7d-75f9-4134-b644-6620e54dc709
  task_id: 2a4d67bf-802d-4ec5-8094-247a45edf809
  target_file: prompt-only
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-flavored-overlap-round-20260627-project
  output_dir: AgentTasks/aristotle-output/68710c7d-75f9-4134-b644-6620e54dc709
  status: summary_integrated
---

# C126 Aristotle job: Schur-generated matrix Wilson term

Date: 2026-06-27

## Prompt

Read the attached `ROUND_CONTEXT.md`.

This is a finite-dimensional theorem-design job. Do not build the full repo.

Goal:

Investigate whether the matrix-valued Wilson/flavored-mass term should be
derived from a Schur-Feshbach self-energy rather than hand-built.

Setup:

```text
W_eff = V M^{-1} W.
```

Known parity criterion:

```text
J_L W_eff J_L = (sigma_V sigma_M sigma_W) W_eff.
```

Task:

1. State a theorem saying when `W_eff` can serve as a balance-odd
   matrix-valued Wilson term:

```text
sigma_V sigma_M sigma_W = -1
```

plus any Hermitian/Krein/gauge conditions needed.

2. State conditions under which:

```text
H_ne = Gamma_K (D_ne + W_eff - m0 R)
```

is Hermitian or Krein-Hermitian.

3. State the finite origin test:

```text
Odd_J(P0 W_eff P0) != 0
```

and the stronger sign test:

```text
Odd_J(P0 sign(H_ne) P0) != 0.
```

4. Explain how a Schur-generated `W_eff` also supplies a true bad-sector gap,
   and what extra hypotheses are needed to avoid propagator-zero mirror
   removal.

5. Give a small witness or toy block model.

Important:

Separate the finite algebraic Wilson-generation theorem from the later physical
release theorem.


## Submission log

Submitted via:

`powershell
aristotle submit --project-dir AgentTasks/aristotle-submit/gate-c1-flavored-overlap-round-20260627-project <prompt from this task note>
`

Aristotle submit output:

`	ext
Project created: 68710c7d-75f9-4134-b644-6620e54dc709

`

Aristotle tasks output:

`	ext
ID                                   CREATED              NAME                           STATUS         
---------------------------------------------------------------------------------------------------------
2a4d67bf-802d-4ec5-8094-247a45edf809 0 secs ago           ---
aristotle:
  project_id... QUEUED         

`

## Integration status

Summary integrated on 2026-06-27 into AgentTasks/null-edge-aristotle-gate-c1-completed-integration-3-2026-06-27.md, Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md, and AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md. Standalone Aristotle Lean artifacts were not promoted into trusted repo Lean in this pass.
