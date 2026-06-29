---
project_id: baadc86f-c5f0-4f5d-9fdc-a7a39fae489e
task_id: pending
status: summary_integrated
created: 2026-06-27
round: gate-c1-breakthrough-round-2
---

# Aristotle C142: homotopy/import theorem for overlap/domain-wall inheritance

Goal: State the theorem that lets us stop inventing a new regulator if the null-edge kernel is homotopic to a standard overlap/domain-wall kernel.

Context: C128 and C129 support reference-model-first thinking. Candidate A is the cheap Hermitian null-edge overlap kernel; Candidate C is the domain-wall transfer-Hamiltonian import route. We need a clean import theorem.

Requested deliverables:

1. A theorem statement: if `H_ne(t)` is a continuous/gauge-covariant gapped homotopy from a reference overlap/domain-wall kernel to the null-edge kernel, then the GW branch-selection, index/anomaly class, and projector rank/chirality data transfer.
2. Separate finite algebra, spectral-gap/homotopy, locality, and anomaly-line assumptions.
3. Identify the minimal finite Lean core that can be proved now, e.g. rank stability of spectral projectors plus sign-kernel projector algebra.
4. Identify which assumptions must remain physics/literature imports.
5. Provide a go/no-go decision rule for native mode versus import mode.

Success criterion: a rigorous interface contract for using known overlap/domain-wall physics as the proven model and interpreting it in null-edge terms.
## Submission status

Submitted on 2026-06-27. Project: baadc86f-c5f0-4f5d-9fdc-a7a39fae489e. Task: .

## Integration status

Summary integrated on 2026-06-27 into AgentTasks/null-edge-aristotle-gate-c1-completed-integration-5-2026-06-27.md, Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md, and AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md. Standalone Aristotle Lean artifacts were not promoted into trusted repo Lean in this pass.
