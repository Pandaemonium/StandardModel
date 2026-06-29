---
project_id: cfd74d5c-0a43-4015-9ce1-47812d5a0457
task_id: pending
status: summary_integrated
created: 2026-06-27
round: gate-c1-breakthrough-round-2
---

# Aristotle C139: Schur-Feshbach bad-sector inverse-gap theorem

Goal: Turn the Schur-generated Wilson story into a true bad-sector gap theorem.

Context: C121 gives a spectral-island/projector bridge. C122 gives resolvent/path-sum control. C126 derives Schur parity and shows heavy-block invertibility avoids propagator-zero substitution. Gate C1 needs a theorem saying the unwanted sector is genuinely gapped by the inverse propagator, not removed by a zero.

Requested deliverables:

1. A finite block-matrix theorem with light/heavy decomposition, heavy block invertibility, Schur complement, and an explicit lower bound or invertibility result on the bad sector.
2. Conditions under which `P_bad D_phys P_bad` is invertible or norm-bounded below.
3. A connection to Schur parity: show how a balance-odd `W_eff = V M^{-1} W` can coexist with the bad-sector gap.
4. A counterexample showing why origin oddness or Schur nonzero alone does not imply a bad-sector gap.
5. Standalone Lean preferred; theorem-design acceptable if the analytic norm statement is too broad.

Success criterion: a finite theorem package we can cite as the no-ghost, no-propagator-zero bad-sector audit.
## Submission status

Submitted on 2026-06-27. Project: cfd74d5c-0a43-4015-9ce1-47812d5a0457. Task: .

## Integration status

Summary integrated on 2026-06-27 into AgentTasks/null-edge-aristotle-gate-c1-completed-integration-4-2026-06-27.md, Sources/Null_Edge_Gate_C1_Nonultralocal_Release_Plan.md, and AgentTasks/null-edge-pro-current-status-blockers-2026-06-27.md. Standalone Aristotle Lean artifacts were not promoted into trusted repo Lean in this pass.
