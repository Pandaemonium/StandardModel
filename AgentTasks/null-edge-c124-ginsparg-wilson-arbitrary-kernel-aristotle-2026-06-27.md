---
aristotle:
  project_id: c65df36f-75bf-45f6-bae9-7fa768d3b221
  task_id: b6c79d4a-e108-482e-b1a5-140b20145f20
  target_file: prompt-only
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-flavored-overlap-round-20260627-project
  output_dir: AgentTasks/aristotle-output/c65df36f-75bf-45f6-bae9-7fa768d3b221
  status: summary_integrated
---

# C124 Aristotle job: Ginsparg-Wilson algebra for arbitrary Hermitian kernel

Date: 2026-06-27

## Prompt

Read the attached `ROUND_CONTEXT.md`.

This is a finite-dimensional theorem-design job. Do not build the full repo.

Goal:

State the algebraic overlap/Ginsparg-Wilson theorem for an arbitrary Hermitian
or Krein-Hermitian kernel, specialized enough to guide the null-edge flavored
overlap route.

Task:

1. Start with a finite-dimensional operator `H` satisfying the right
   Hermitian/Krein-Hermitian hypotheses and with no zero spectrum so
   `epsilon = sign(H)` is defined.

2. Define an overlap-style operator, for example:

```text
D = rho (1 + Gamma epsilon)
```

or the normalized variant you recommend.

3. State the algebraic assumptions needed on `Gamma` and `epsilon` to derive a
   Ginsparg-Wilson relation:

```text
D Gamma + Gamma D = const * D Gamma D
```

or a generalized relation with a kernel `R`.

4. Define the modified chirality:

```text
Gamma_hat = Gamma (1 - a R D)
```

or the appropriate finite version.

5. State the exact identities:

```text
Gamma_hat^2 = 1;
D Gamma_hat = - Gamma D;
index/trace relation if available.
```

under explicit hypotheses.

6. Identify which parts are pure finite matrix algebra and which require
   spectral/analytic assumptions.

Important:

This job should clarify what algebra the null-edge flavored-overlap construction
must satisfy. Do not assume the null-edge kernel already has the needed
properties; list them explicitly.


## Submission log

Submitted via:

`powershell
aristotle submit --project-dir AgentTasks/aristotle-submit/gate-c1-flavored-overlap-round-20260627-project <prompt from this task note>
`

Aristotle submit output:

`	ext
Project created: c65df36f-75bf-45f6-bae9-7fa768d3b221

`

Aristotle tasks output:

`	ext
ID                                   CREATED              NAME                           STATUS         
---------------------------------------------------------------------------------------------------------
b6c79d4a-e108-482e-b1a5-140b20145f20 0 secs ago           ---
aristotle:
  project_id... QUEUED         

`

## Integration status

Summary integrated on 2026-06-27 into AgentTasks/null-edge-aristotle-gate-c1-completed-integration-3-2026-06-27.md, Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md, and AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md. Standalone Aristotle Lean artifacts were not promoted into trusted repo Lean in this pass.
