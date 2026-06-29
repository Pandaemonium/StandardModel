---
aristotle:
  project_id: ad032c20-55a9-4131-adcf-59b9bcfda70a
  task_id: 1115f1f6-0759-41b9-a754-50a267b7c4a9
  target_file: prompt-only
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-pro-synthesis-round-20260627-project
  output_dir: AgentTasks/aristotle-output/ad032c20-55a9-4131-adcf-59b9bcfda70a
  status: summary_integrated
---

# C118 Aristotle job: Schur-complement odd-source criterion

Date: 2026-06-27

## Prompt

Read the attached `ROUND_CONTEXT.md`.

This is a finite-dimensional theorem-design job for the null-edge Gate C1
program. Do not build the full repo.

Goal:

Formalize the Schur-Feshbach parity criterion suggested by Pro.

Setup:

Let `L` be the light/origin space and `H` the heavy/gapped auxiliary space. Let
`J_L : L -> L` and `J_H : H -> H` be balance involutions. Let:

```text
V : H -> L,
M_inv : H -> H,
W : L -> H.
```

Assume parities:

```text
J_L V J_H = sigma_V V;
J_H M_inv J_H = sigma_M M_inv;
J_H W J_L = sigma_W W.
```

where each `sigma_*` is `+1` or `-1`.

Define:

```text
Sigma = V M_inv W : L -> L.
```

Task:

1. State and prove the finite parity theorem:

```text
J_L Sigma J_L = (sigma_V sigma_M sigma_W) Sigma.
```

2. State the C1 corollary:

```text
Sigma is balance-odd exactly when sigma_V sigma_M sigma_W = -1.
```

3. Give a small concrete 2 x 2 or 4 x 4 witness where the Schur self-energy is
   balance-odd and has nonzero chiral trace with a simple `Gamma`.

4. Give the negative-control theorem: if all three ingredients are balance-even,
   the Schur self-energy is balance-even and cannot by itself be the missing
   C1 origin polarizer under the C108 trace-cancellation hypotheses.

5. Provide a Lean-friendly API sketch using finite-dimensional matrices or
   linear maps over `Complex`.

Important:

This job does not need to prove physical release, gauge covariance, anomaly
claims, or path-sum control. It is the finite algebraic test for whether a Schur
channel can create the missing balance-odd origin term.


## Submission log

Submitted via:

`powershell
aristotle submit --project-dir AgentTasks/aristotle-submit/gate-c1-pro-synthesis-round-20260627-project <prompt from this task note>
`

Aristotle submit output:

`	ext
Project created: ad032c20-55a9-4131-adcf-59b9bcfda70a

`

Aristotle tasks output:

`	ext
ID                                   CREATED              NAME                           STATUS         
---------------------------------------------------------------------------------------------------------
1115f1f6-0759-41b9-a754-50a267b7c4a9 0 secs ago           ---
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
