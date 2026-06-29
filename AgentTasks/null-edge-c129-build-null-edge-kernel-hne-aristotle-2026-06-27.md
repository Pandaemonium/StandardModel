---
aristotle:
  project_id: ea3657b3-f2b9-492a-85fb-090addbefe35
  task_id: 3c231479-ef7a-4000-aff4-2821485d501d
  target_file: prompt-only
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-null-edge-overlap-program-20260627-project
  output_dir: AgentTasks/aristotle-output/ea3657b3-f2b9-492a-85fb-090addbefe35
  status: summary_integrated
---

# C129 Aristotle job: build candidate null-edge kernels H_ne

Date: 2026-06-27

## Prompt

Read the attached `ROUND_CONTEXT.md`.

This is a candidate-construction and audit job. Do not build the full repo.

Goal:

Construct and rank candidate null-edge overlap kernels `H_ne`.

Candidate forms may include:

```text
H_ne = Gamma_K (D_ne + W_branch - m0 R);
H_ne = Gamma_K (D_ne + W_Schur - m0 R);
H_ne = domain-wall transfer Hamiltonian;
H_ne = Hermitianized null-edge retarded operator plus matrix-valued Wilson term;
H_ne = Krein-Hermitian analogue.
```

Task:

For each candidate, audit:

- Hermitian or Krein-Hermitian adjointness;
- gauge covariance;
- whether the mass/window parameter can be chosen;
- whether the origin compression is balance-even or balance-odd;
- likely spectral gap;
- whether it is plausibly homotopic to the Wilson-overlap kernel;
- whether it has path-sum/resolvent control;
- likely obstruction.

Required output:

- Ranked candidate kernels.
- Exact finite-origin tests for each.
- Which candidate should be formalized first.
- Which candidate is most likely to be a null-edge reinterpretation of known
  overlap physics rather than a new ad hoc regulator.


## Submission log

Submitted via:

`powershell
aristotle submit --project-dir AgentTasks/aristotle-submit/gate-c1-null-edge-overlap-program-20260627-project <prompt from this task note>
`

Aristotle submit output:

`	ext
Project created: ea3657b3-f2b9-492a-85fb-090addbefe35

`

Aristotle tasks output:

`	ext
ID                                   CREATED              NAME                           STATUS         
---------------------------------------------------------------------------------------------------------
3c231479-ef7a-4000-aff4-2821485d501d 0 secs ago           ---
aristotle:
  project_id... QUEUED         

`

## Integration status

Summary integrated on 2026-06-27 into AgentTasks/null-edge-aristotle-gate-c1-completed-integration-3-2026-06-27.md, Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md, and AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md. Standalone Aristotle Lean artifacts were not promoted into trusted repo Lean in this pass.
