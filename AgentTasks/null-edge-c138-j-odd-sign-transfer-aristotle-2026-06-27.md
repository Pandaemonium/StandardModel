---
project_id: a7152d81-c41e-44fa-94ec-3f811062877c
task_id: pending
status: summary_integrated
created: 2026-06-27
round: gate-c1-breakthrough-round-2
---

# Aristotle C138: J-odd sign-transfer theorem

Goal: Prove or sharply characterize when a balance-odd Wilson/flavored seed survives the sign functional calculus.

Context: C123/C126/C131 show that `J`-oddness is necessary at the origin, and that a `J`-symmetric kernel gives `Odd_J(sign(H)) = 0`. C136 gives a finite witness where `Odd_J(W_branch) != 0` and `Odd_J(sign(H)) != 0`. We need a theorem between those endpoints.

Requested deliverables:

1. A finite matrix theorem giving sufficient conditions for `Odd_J(sign(H_even + lambda H_odd)) != 0`.
2. Conditions should be useful for Gate C1: spectral gap, dominance, anticommutation, or perturbative stability are all acceptable if stated cleanly.
3. Include a no-go/counterexample showing `Odd_J(W) != 0` alone is insufficient if such a counterexample exists.
4. Connect the result to the C136 finite seed and the C134 gauge-safe branch-Pauli seed.
5. If possible, provide standalone Lean over finite complex matrices; otherwise provide theorem statements and proof plan.

Success criterion: a usable sign-transfer lemma or a precise obstruction that tells us what extra hypothesis the kernel must satisfy.
## Submission status

Submitted on 2026-06-27. Project: a7152d81-c41e-44fa-94ec-3f811062877c. Task: .

## Integration status

Summary integrated on 2026-06-27 into AgentTasks/null-edge-aristotle-gate-c1-completed-integration-7-2026-06-27.md, Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md, and AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md. Standalone Aristotle Lean artifact was not promoted into trusted repo Lean in this pass.
