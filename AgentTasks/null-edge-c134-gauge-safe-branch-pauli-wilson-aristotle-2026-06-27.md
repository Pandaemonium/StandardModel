---
aristotle:
  project_id: 7a3c096b-0fcf-4010-84f0-1de56aeb1118
  task_id: 3768ea63-bb99-4683-8cc8-80706f712492
  target_file: prompt-only
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/gate-c1-qubit-qutrit-origin-round-20260627-project
  output_dir: AgentTasks/aristotle-output/7a3c096b-0fcf-4010-84f0-1de56aeb1118
  status: summary_integrated
---

# C134 Aristotle job: gauge-safe branch-Pauli Wilson term

Date: 2026-06-27

## Prompt

Read the attached `ROUND_CONTEXT.md`.

This is a finite-dimensional theorem-design job. Do not build the full repo.

Goal:

Design a gauge-safe matrix-valued Wilson/flavored-mass term using the
branch-qubit/internal-qutrit picture.

Candidate form:

```text
W_branch =
  Pauli_branch tensor SpinFactor tensor InternalGaugeSafeFactor.
```

Task:

1. State conditions for `W_branch` to be balance-odd under the branch involution
   `J`.

2. State conditions for `W_branch` to commute with, or transform covariantly
   under, the internal gauge representation.

3. State conditions for the Hermitian/Krein-Hermitian overlap kernel:

```text
H_ne = Gamma_K (D_ne + W_branch - m0 R)
```

to be admissible at the finite-origin algebra level.

4. Provide examples and counterexamples:

- internal-only term: gauge-safe but balance-even, so fails;
- branch-only term: balance-odd but may ignore chirality/gauge constraints;
- branch-Pauli tensor internal identity: simplest possible success candidate;
- branch-Pauli tensor noncentral internal factor: possible gauge-breaking false
  positive.

5. Recommend the smallest Lean theorem to prove first.

Important:

Do not claim physical release. This is a disciplined finite search space for
`W_branch`.

## Submission note

Held initially because the Aristotle queue is at or near the in-progress project
limit. Submit after C131/C132 or after earlier jobs complete.

## Submission log

Submitted via:

`powershell
aristotle submit --project-dir AgentTasks/aristotle-submit/gate-c1-qubit-qutrit-origin-round-20260627-project <prompt from this task note>
`

Aristotle submit output:

`	ext
Project created: 7a3c096b-0fcf-4010-84f0-1de56aeb1118

`

Aristotle tasks output:

`	ext
ID                                   CREATED              NAME                           STATUS         
---------------------------------------------------------------------------------------------------------
3768ea63-bb99-4683-8cc8-80706f712492 0 secs ago           ---
aristotle:
  project_id... QUEUED         

`

## Integration status

Summary integrated on 2026-06-27 into AgentTasks/null-edge-aristotle-gate-c1-completed-integration-3-2026-06-27.md, Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md, and AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md. Standalone Aristotle Lean artifacts were not promoted into trusted repo Lean in this pass.
