# Aristotle task: QCD boundary and finite obstruction-map scoping audit

- project_id: 715dfd7b-d6cb-41e2-ae65-dea04489dbf5
- status: integrated
- submitted: 2026-06-26
- job_type: audit
- source_prompt: AgentTasks/aristotle-submit/null-edge-qcd-obstruction-scope-wave3-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-qcd-obstruction-scope-wave3-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-open-convention-targets-wave3-20260626-20260626-080843.md
- expected_output: AgentTasks/null-edge-qcd-obstruction-scope.md

## Purpose

This job is part of the third Aristotle wave for null-edge items that remain genuinely unresolved after the convention-lock audit. It is focused on theorem/audit/prediction/model-decision targets rather than convention choices.

## Integration notes

When the job returns, keep conventions separate from theorem outcomes. Do not lock FMS composites, continuum limits, Krein stability, chirality, QCD obstruction maps, or prediction claims without proof/audit support.

## Integration (2026-06-26)

Audit deliverable placed at `AgentTasks/null-edge-qcd-obstruction-scope.md`. Verdict:
the program should NOT define any near-term finite `B_QCD`; QCD stays strictly
boundary/motivation, and no QCD-labelled theorem job should enter the theorem waves until
a finite color Hamiltonian or color-holonomy gap theorem (`H_color^finite|_singlets >=
Delta > 0`) exists. Enumerates the five requirements for a genuine finite `B_QCD`, gives
two honest de-labelled abstract toy models (with naming guardrails), and supplies verbatim
P1/P1.5 claim-boundary wording plus a prohibitions list. Guardrails: `B_QCD` not defined by
analogy; Plucker mass never implied to derive proton mass; confinement / running /
Lambda_QCD / trace anomaly / hadron spectrum kept outside all current theorem claims. No
Lean/build in scope.
