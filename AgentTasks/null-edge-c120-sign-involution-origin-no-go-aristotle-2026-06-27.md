---
aristotle:
  project_id: 1f1d427a-b84b-4cc4-9771-77cf449c7377
  task_id: 68ea2742-65be-4022-a6e0-17424abb8b08
  target_file: prompt-only
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-pro-synthesis-round-20260627-project
  output_dir: AgentTasks/aristotle-output/1f1d427a-b84b-4cc4-9771-77cf449c7377
  status: summary_integrated
---

# C120 Aristotle job: sign-involution origin no-go and escape criterion

Date: 2026-06-27

## Prompt

Read the attached `ROUND_CONTEXT.md`.

This is a finite-dimensional theorem-design job for the null-edge overlap/sign
route. Do not build the full repo.

Pro's Furey/Hughes-inspired top selector candidate is:

```text
T_br = sign(H_ne);
P_phys = (1 + T_br) / 2.
```

But this route fails if the origin kernel compression of `H_ne` is balance-even.

Task:

1. State a finite theorem:

If `H0` commutes with the balance involution `J`, then any polynomial spectral
sign approximation `p(H0)` also commutes with `J`.

2. State a finite spectral theorem:

If `sign(H0)` is defined by a finite spectral decomposition and `H0` commutes
with `J`, then `sign(H0)` commutes with `J`.

3. Combine with the current C108 trace-cancellation hypothesis to conclude:

```text
Tr(Gamma (1 + sign(H0)) / 2) = 0
```

under the standard balanced-origin assumptions.

4. State the minimal escape criterion:

```text
Odd_J(P0 sign(H_ne(0,1)) P0) != 0
```

and preferably:

```text
Tr_K0(Gamma (1 + P0 sign(H_ne(0,1)) P0) / 2) != 0.
```

5. Give a small finite witness where a sign/involution projector does escape,
   and explain why it is only an origin witness, not a C1 release.

6. Provide a Lean-friendly API sketch using finite matrices, polynomial
   functional calculus first, and spectral/sign decomposition only as a later
   analytic/theorem-design layer.

Important:

This job is intended to prevent a renamed balance-even Wilson kernel from
masquerading as a successful null-edge overlap solution.


## Submission log

Submitted via:

`powershell
aristotle submit --project-dir AgentTasks/aristotle-submit/gate-c1-pro-synthesis-round-20260627-project <prompt from this task note>
`

Aristotle submit output:

`	ext
Project created: 1f1d427a-b84b-4cc4-9771-77cf449c7377

`

Aristotle tasks output:

`	ext
ID                                   CREATED              NAME                           STATUS         
---------------------------------------------------------------------------------------------------------
68ea2742-65be-4022-a6e0-17424abb8b08 0 secs ago           ---
aristotle:
  project_id... QUEUED         

`

## Integration status

System.Collections.Hashtable.Label

Project: $(System.Collections.Hashtable.Id)

Integrated into:

- Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md section 22.
- AgentTasks/null-edge-aristotle-gate-c1-completed-integration-2026-06-27.md.

Note: Aristotle reported standalone clean builds where applicable, but this pass did not promote returned Lean files into trusted PhysicsSM modules and did not run local Lean verification.
