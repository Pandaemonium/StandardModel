---
aristotle:
  project_id: bbad005f-ce9e-4c29-a14f-f1497e350991
  task_id: 40556473-9ad8-4fb9-a167-188653814e12
  target_file: prompt-only
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-null-edge-overlap-program-20260627-project
  output_dir: AgentTasks/aristotle-output/bbad005f-ce9e-4c29-a14f-f1497e350991
  status: summary_integrated
---

# C128 Aristotle job: translate overlap to Gate C1

Date: 2026-06-27

## Prompt

Read the attached `ROUND_CONTEXT.md`.

This is a theorem-design and dictionary job. Do not build the full repo.

Goal:

Write the standard overlap/Ginsparg-Wilson construction entirely in Gate C1
language.

Task:

Produce an exact translation table:

```text
standard overlap object | Gate C1 / null-edge object | required audit
```

Include:

- Wilson kernel `H_W`;
- sign function `sign(H_W)`;
- overlap Dirac operator `D_ov`;
- Ginsparg-Wilson relation;
- modified chirality `Gamma_hat`;
- projectors `P_hat,+/-`;
- kernel/origin space `K0`;
- balance involution `J`;
- finite-origin diagnostic trace;
- spectral gap/admissibility condition;
- locality/control theorem;
- index/anomaly statement;
- bad-sector/mirror interpretation.

Then state the minimal null-edge theorem:

```text
If H_ne satisfies the same algebraic, spectral, gauge, and locality hypotheses
as the reference overlap kernel, then D_ov,ne satisfies the same GW branch
selection theorem.
```

Important:

Do not invent a new model. This job is a reference-model translation and audit
map.


## Submission log

Submitted via:

`powershell
aristotle submit --project-dir AgentTasks/aristotle-submit/gate-c1-null-edge-overlap-program-20260627-project <prompt from this task note>
`

Aristotle submit output:

`	ext
Project created: bbad005f-ce9e-4c29-a14f-f1497e350991

`

Aristotle tasks output:

`	ext
ID                                   CREATED              NAME                           STATUS         
---------------------------------------------------------------------------------------------------------
40556473-9ad8-4fb9-a167-188653814e12 0 secs ago           ---
aristotle:
  project_id... QUEUED         

`

## Integration status

Summary integrated on 2026-06-27 into AgentTasks/null-edge-aristotle-gate-c1-completed-integration-3-2026-06-27.md, Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md, and AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md. Standalone Aristotle Lean artifacts were not promoted into trusted repo Lean in this pass.
