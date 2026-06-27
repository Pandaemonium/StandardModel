# Aristotle task: Standard Model one-generation anomaly cancellation proof

- project_id: 148ad477-a504-4a30-b096-81845693435b
- status: integrated
- submitted: 2026-06-26
- job_type: proof
- source_prompt: AgentTasks/aristotle-submit/null-edge-sm-anomaly-audit-wave3-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-sm-anomaly-audit-wave3-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-open-convention-targets-wave3-20260626-20260626-080843.md
- expected_output: PhysicsSM/Draft/StandardModelAnomalyAudit.lean

## Purpose

This job is part of the third Aristotle wave for null-edge items that remain genuinely unresolved after the convention-lock audit. It is focused on theorem/audit/prediction/model-decision targets rather than convention choices.

## Integration notes

When the job returns, keep conventions separate from theorem outcomes. Do not lock FMS composites, continuum limits, Krein stability, chirality, QCD obstruction maps, or prediction claims without proof/audit support.

## Integration (2026-06-26)

Despite the job name ("audit"), the deliverable is a proof: integrated into
`PhysicsSM/Draft/StandardModelAnomalyAudit.lean` (namespace `PhysicsSM.Draft.SMAnomaly`),
wired into `PhysicsSMDraft.lean`; report at `AgentTasks/null-edge-sm-anomaly-audit-report.md`.
Discharges all four one-generation anomaly conditions (U(1), U(1)^3, SU(2)^2 U(1),
SU(3)^2 U(1)) by exact rational arithmetic, plus the harmless-`nu_R^c` extension.
Guardrail: standard anomaly arithmetic only, not a claim that the null-edge construction
realises the chiral SM; nothing about doubling. Verified by full
`lake build PhysicsSMDraft` (exit 0); `#print axioms` clean
(`propext, Classical.choice, Quot.sound`); pre-commit clean. See the wave1/wave3 ledger
entry in `null-edge-sm-anomaly-audit-wave3-20260626.md` (this file).
