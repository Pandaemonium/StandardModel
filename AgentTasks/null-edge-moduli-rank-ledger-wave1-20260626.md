# Aristotle task: Moduli-rank prediction ledger and codimension gate

- project_id: 415617f5-8d10-446f-90f2-1a60f4dd68f4
- status: integrated
- submitted: 2026-06-26
- job_type: audit
- source_prompt: AgentTasks/aristotle-submit/null-edge-moduli-rank-ledger-wave1-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-moduli-rank-ledger-wave1-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-unified-mass-wave1-20260626-20260626-072657.md
- expected_output: AgentTasks/null-edge-moduli-rank-prediction-ledger.md

## Purpose

This job is part of the first Aristotle wave for the null-edge unified mass program. It follows the returned strategy report and focuses on one high-leverage finite proof or audit target.

## Integration notes

When the job returns, review semantic alignment before promoting any proof result from PhysicsSM/Draft/. For proof jobs, check conventions, signs, hidden assumptions, and whether the statement proves the intended mathematical claim rather than a weakened substitute.

## Integration (2026-06-26)

Audit deliverable placed at `AgentTasks/null-edge-moduli-rank-prediction-ledger.md`:
a coordinate ledger for `M_finite` (12 blocks) and `M_EFT` (g_1/g_2/g_3, v, lambda,
Yukawas, M_R, CKM/PMNS, Wilson coefficients) with redundancy-group annotations; a
naive parameter count (clearly labelled a first screen only: 19 SM-core, 28 with a
Majorana sector); the true prediction criterion `rank(dF) < dim M_EFT` or a relation
`R(theta_EFT) = 0` (codimension as the real criterion) with a mandatory
redundancy-hygiene procedure and T17 formalizable fragments; a ranked list of six
structural prediction candidates each with a smallest-useful target; and a failure-mode
section. Guardrail checklist confirms it does not call reconstruction a prediction and
flags fake deficits from gauge redundancy / basis / field redefinitions. No Lean/build
in scope.
