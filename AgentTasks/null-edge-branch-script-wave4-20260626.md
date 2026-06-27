# Aristotle task: Branch-count script implementation only

- project_id: 2c3684eb-cdbd-41ab-ab7b-fdc95eacbd8a
- status: integrated
- submitted: 2026-06-26
- job_type: integration-freeze wave
- source_prompt: AgentTasks/aristotle-submit/null-edge-branch-script-wave4-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-branch-script-wave4-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-integration-freeze-wave4-20260626-20260626-092041.md
- expected_output: Scripts/experiments/null_edge_branch_count.py

## Purpose

This job is part of the Pro-recommended integration-freeze wave. It reduces risk before launching further broad proof work by extracting dependencies, normalizing conventions, protecting trusted promotion, or bounding branch-count interpretation.

## Integration notes

When the job returns, use it to decide whether later proof jobs should proceed, pause, or be downgraded. Do not treat integration policy, branch criteria, or manuscript rewrite recommendations as proof of physical claims.

## Integration (2026-06-26)

**Overwrote** `Scripts/experiments/null_edge_branch_count.py` with the revised oracle
(378 -> 717 lines): adds an explicit 4x4 Dirac gamma representation, the determinant-level
tests `det c(p) = (p^2)^2` and `det(i c(p) + m gamma5) = (m^2 - p^2)^2`, a 16-point corner
scan, energy-slice real/complex enumeration, an optional torus grid scan, and
machine-readable JSON/CSV output with CLI flags (`--outdir`, `--grid`, `--slice-grid`,
`--mass`, `--h`, `--seed`, `--tol`). The prior version (from job 6e22a037, wave2) was a
strict subset at the same path; this is its deliberate expansion, same conventions and
reproduced numbers. Report at `AgentTasks/null-edge-branch-script-report.md`. Sanity-run:
internal regression checks pass to machine precision (`inverse_gram_max_abs_error ~ 2e-16`,
`G^{-1} = -3/4 I + 1/4 J`), warning corner `q=(pi,pi,pi,0)` gives `p^2=0` with kernel dim 2,
5 massless corners. Oracle/exploration tool, not a proof (AGENTS.md CAS/oracle policy).
pre-commit clean.
