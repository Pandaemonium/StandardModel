---
aristotle:
  project_id: d277393d-d8c9-4676-b564-e97724ab2ddb
  task_id: f1e651d7-da45-4d3e-ba50-82f998455560
  target_file: prompt-only
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-pro-synthesis-round-20260627-project
  output_dir: AgentTasks/aristotle-output/d277393d-d8c9-4676-b564-e97724ab2ddb
  status: summary_integrated
---

# C121 Aristotle job: Riesz-projector bridge formal skeleton

Date: 2026-06-27

## Prompt

Read the attached `ROUND_CONTEXT.md`.

This is a theorem-design and formalization-planning job. Do not build the full
repo.

Goal:

Turn Pro's origin-to-branch bridge into a formal skeleton that separates finite
matrix algebra from analytic perturbation theory.

Task:

1. State a finite-dimensional Riesz/spectral-island bridge theorem:

Given an analytic or continuous matrix family `B(q,U)` and an isolated spectral
cluster at `(q,U) = (0,1)`, define the projector by a contour/Riesz formula or a
finite polynomial surrogate. Prove or state rank stability and projector
stability while the island gap remains open.

2. State the gauge covariance theorem:

If

```text
B(U^g) = rho(g) B(U) rho(g)^{-1},
```

then the polynomial or Riesz projector satisfies:

```text
P(U^g) = rho(g) P(U) rho(g)^{-1}.
```

3. State exactly what extra hypotheses are needed before the projector becomes a
physical Gate C1 branch selector:

```text
origin C1-Origin+;
Weyl tangent-residue witness;
bad-sector inverse gap;
Krein-positive residue;
no ghost-zero removal.
```

4. Provide counterexamples showing that nonzero origin chiral trace alone does
   not imply a stable branch projector.

5. Recommend which portion should become the next focused Lean job.

Important:

Do not claim physical release from the Riesz projector alone. This is the bridge
from finite origin selector to a stable near-origin branch-line projector under
spectral-island hypotheses.


## Submission log

Submitted via:

`powershell
aristotle submit --project-dir AgentTasks/aristotle-submit/gate-c1-pro-synthesis-round-20260627-project <prompt from this task note>
`

Aristotle submit output:

`	ext
Project created: d277393d-d8c9-4676-b564-e97724ab2ddb

`

Aristotle tasks output:

`	ext
ID                                   CREATED              NAME                           STATUS         
---------------------------------------------------------------------------------------------------------
f1e651d7-da45-4d3e-ba50-82f998455560 0 secs ago           ---
aristotle:
  project_id... QUEUED         

`

## Integration status

Summary integrated on 2026-06-27 into AgentTasks/null-edge-aristotle-gate-c1-completed-integration-3-2026-06-27.md, Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md, and AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md. Standalone Aristotle Lean artifacts were not promoted into trusted repo Lean in this pass.
