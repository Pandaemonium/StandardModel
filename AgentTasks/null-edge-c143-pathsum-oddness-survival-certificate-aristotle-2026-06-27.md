---
project_id: 34b67708-565a-40c8-9618-422f8a36514f
task_id: pending
status: summary_integrated
created: 2026-06-27
round: gate-c1-breakthrough-round-2
---

# Aristotle C143: path-sum oddness survival certificate

Goal: Compose C122 path-sum control with the Gate C1 oddness diagnostic.

Context: The user prefers combinatorial/path-integral style control over assuming strict ultralocality. C122 proves shell-count tail bounds and oddness survival when a finite partial odd contribution dominates the tail. Gate C1 needs this packaged as a certificate for nonlocal null-edge kernels.

Requested deliverables:

1. Define a certificate using shell counts, amplitude bounds, and a finite odd partial sum.
2. Prove the certificate implies the limiting path-sum operator has nonzero `Odd_J`.
3. If possible, connect this to `sign(H)` or resolvent/Neumann approximations used to define `sign(H)`.
4. Include failure modes: ratio at boundary, conditional convergence, or cancellation of the odd finite piece by the tail.
5. Standalone Lean preferred for the finite/summability layer; theorem-design acceptable for the sign-functional-calculus bridge.

Success criterion: a reusable non-ultralocal locality/oddness certificate in the user's preferred combinatorial style.
## Submission status

Submitted on 2026-06-27. Project: 34b67708-565a-40c8-9618-422f8a36514f. Task: .

## Integration status

Summary integrated on 2026-06-27 into AgentTasks/null-edge-aristotle-gate-c1-completed-integration-5-2026-06-27.md, Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md, and AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md. Standalone Aristotle Lean artifacts were not promoted into trusted repo Lean in this pass.
