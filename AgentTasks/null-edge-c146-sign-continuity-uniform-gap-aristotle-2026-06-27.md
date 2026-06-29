---
project_id: c14a7279-e454-4896-a2d6-8bcf922076d1
task_id: pending
status: summary_integrated
created: 2026-06-27
round: gate-c1-breakthrough-round-3
---

# Aristotle C146: sign-continuity under a uniform spectral gap

Goal: Close the analytic handoff left by C130, or isolate the exact theorem needed.

Context: C130 proves the finite homotopy/index route except for the estimate that `sign(H_t)` varies continuously when `H_t` is Hermitian and uniformly gapped. C142 is pursuing the broader homotopy/import interface; this job should focus narrowly on the analytic estimate.

Requested deliverables:

1. State the cleanest finite-dimensional theorem: for a norm-continuous Hermitian path `H_t` with spectrum bounded away from zero by `delta > 0`, `sign(H_t)` is norm-continuous.
2. Provide a Lean-friendly proof route, preferably using functional calculus, spectral projectors, or `sign(H) = H (H^2)^(-1/2)`.
3. If full Lean proof is feasible in standalone Mathlib, provide it.
4. If not, give exact missing Mathlib lemmas and a staged proof plan.
5. Include a counterexample showing gap closure is essential.

Success criterion: close or sharply localize the C130 homotopy handoff.

## Submission status

Submitted on 2026-06-27. Project: c14a7279-e454-4896-a2d6-8bcf922076d1. Task: .

## Integration status

Summary integrated on 2026-06-27 into AgentTasks/null-edge-aristotle-gate-c1-completed-integration-5-2026-06-27.md, Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md, and AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md. Standalone Aristotle Lean artifacts were not promoted into trusted repo Lean in this pass.
