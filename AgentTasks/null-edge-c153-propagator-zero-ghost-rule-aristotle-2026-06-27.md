---
project_id: 8db82bfa-9769-4579-9ade-c0b8cd5c998c
task_id: pending
status: summary_integrated
created: 2026-06-27
round: gate-c1-literature-spine
---

# Aristotle C153: propagator-zero ghost rule from Golterman-Shamir

Goal: Turn the propagator-zero warning into a Gate C1 audit checklist and theorem-design no-go.

Key references: Golterman-Shamir 2023 (`8NRUZ46K`, arXiv `2311.12790`), Poppitz-Shang 2010 (`WPPE5WBW`, arXiv `1003.5896`). Related internal result: C139 Schur-Feshbach bad-sector inverse-gap theorem.

Requested deliverables:

1. Summarize the precise failure mode: why propagator zeros can act like ghost states when gauge fields are turned on.
2. Translate this into Gate C1 language: bad branches must be removed by inverse-propagator gaps or overlap/domain-wall projection, not by zeros.
3. Connect to C139: heavy-block invertibility gives an acceptable finite no-ghost audit.
4. State a no-go/audit theorem-design checklist for future candidate kernels.
5. Give examples of acceptable and unacceptable mirror-removal mechanisms.

Success criterion: a crisp ghost-rule section suitable for the main Gate C1 docs.

## Submission status

Submitted on 2026-06-27. Project: 8db82bfa-9769-4579-9ade-c0b8cd5c998c. Task: .

## Integration status

Summary integrated on 2026-06-27 into AgentTasks/null-edge-aristotle-gate-c1-completed-integration-5-2026-06-27.md, Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md, and AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md. Standalone Aristotle Lean artifacts were not promoted into trusted repo Lean in this pass.
