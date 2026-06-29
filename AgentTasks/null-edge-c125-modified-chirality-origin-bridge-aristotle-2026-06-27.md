---
aristotle:
  project_id: 66582704-8e2c-48a1-8f00-a275d3a836d2
  task_id: bee3da19-557b-46f8-a922-32bd82227ccf
  target_file: prompt-only
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-flavored-overlap-round-20260627-project
  output_dir: AgentTasks/aristotle-output/66582704-8e2c-48a1-8f00-a275d3a836d2
  status: summary_integrated
---

# C125 Aristotle job: modified chirality origin bridge

Date: 2026-06-27

## Prompt

Read the attached `ROUND_CONTEXT.md`.

This is a theorem-design job. Do not build the full repo.

Goal:

Clarify how the current finite-origin chirality test using `Gamma` should relate
to Ginsparg-Wilson modified chirality `Gamma_hat`.

The project currently uses finite-origin diagnostics such as:

```text
Tr_K0(Gamma P0) != 0.
```

An overlap/GW release likely uses a modified chirality:

```text
Gamma_hat = Gamma (1 - a R D)
```

or a null-edge analogue.

Task:

1. State the risk of conflating `Gamma` and `Gamma_hat`.

2. Propose a finite bridge theorem:

```text
origin Gamma-trace certificate
  + overlap/GW hypotheses
  -> released Gamma_hat index/chirality statement
```

or explain why no such theorem follows without extra assumptions.

3. Identify the minimal extra hypotheses:

- spectral gap for the sign kernel,
- stable branch projector,
- compatibility of `P0` with the overlap projector,
- no singular crossing,
- correct Weyl tangent symbol.

4. Give counterexamples where `Tr(Gamma P0) != 0` but the released GW chirality
   is not physically meaningful.

5. Recommend the minimal finite Lean theorem that should be attempted first.

Important:

Do not weaken the distinction between origin diagnostic chirality and released
Ginsparg-Wilson chirality.


## Submission log

Submitted via:

`powershell
aristotle submit --project-dir AgentTasks/aristotle-submit/gate-c1-flavored-overlap-round-20260627-project <prompt from this task note>
`

Aristotle submit output:

`	ext
Project created: 66582704-8e2c-48a1-8f00-a275d3a836d2

`

Aristotle tasks output:

`	ext
ID                                   CREATED              NAME                           STATUS         
---------------------------------------------------------------------------------------------------------
bee3da19-557b-46f8-a922-32bd82227ccf 0 secs ago           ---
aristotle:
  project_id... QUEUED         

`

## Integration status

System.Collections.Hashtable.Label

Project: $(System.Collections.Hashtable.Id)

Integrated into:

- Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md section 23.
- AgentTasks/null-edge-aristotle-gate-c1-completed-integration-2-2026-06-27.md.

Note: Aristotle reported standalone clean builds where applicable, but this pass did not promote returned Lean files into trusted PhysicsSM modules and did not run local Lean verification.
