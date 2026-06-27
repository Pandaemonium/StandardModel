# Aristotle task: FMS-style finite graph W/Z composite audit

- project_id: 4d37f13e-bc2f-4580-9c73-26788056f39b
- status: integrated
- submitted: 2026-06-26
- job_type: audit
- source_prompt: AgentTasks/aristotle-submit/null-edge-fms-wz-composite-wave3-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-fms-wz-composite-wave3-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-open-convention-targets-wave3-20260626-20260626-080843.md
- expected_output: AgentTasks/null-edge-fms-wz-composite-audit.md

## Purpose

This job is part of the third Aristotle wave for null-edge items that remain genuinely unresolved after the convention-lock audit. It is focused on theorem/audit/prediction/model-decision targets rather than convention choices.

## Integration notes

When the job returns, keep conventions separate from theorem outcomes. Do not lock FMS composites, continuum limits, Krein stability, chirality, QCD obstruction maps, or prediction claims without proof/audit support.

## Integration (2026-06-26)

Audit deliverable placed at `AgentTasks/null-edge-fms-wz-composite-audit.md`. Key finding
(a correction / negative result): the schematic composite `O_e^a = H_s^dagger tau^a U_e H_t`
is **NOT gauge invariant** -- it transforms in the adjoint at the source vertex
(gauge-covariant, not invariant), because a single doublet cannot carry a global custodial
triplet index. Corrected composites: the singlet `O_e = H_s^dagger U_e H_t` (the existing T8
link-stiffness object) and, as the actual FMS W/Z observable, the Higgs-framed triplet
`W_e^a = (1/2) tr(sigma^a X_s^dagger U_e X_t)` with `X = (~H, H)/sqrt(H^dagger H) in SU(2)`.
Worked the vacuum expansion (leading fluctuation `(i/2) eps A_e^a`), separated
photon/stabilizer (`u(1)_em = ker B_EW`) from the three massive orbit directions, gave the
smallest Lean target (SU(2)_L gauge invariance of `W_e^a`) plus lemmas L1-L5, and a phrase
table. Recommends narrowing the CONVENTIONS.md FMS entry and updating proof-chain T11 with
the corrected definitions. Labelled reconstruction/structural, not a prediction. No
Lean/build in scope.
