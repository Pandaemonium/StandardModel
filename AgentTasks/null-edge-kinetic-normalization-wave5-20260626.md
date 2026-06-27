# Aristotle task: Kinetic naming and mass-shell normalization theorem package

- project_id: fa483891-d434-4467-8d34-5652c61e5468
- status: integrated
- submitted: 2026-06-26
- job_type: proof
- source_prompt: AgentTasks/aristotle-submit/null-edge-kinetic-normalization-wave5-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-kinetic-normalization-wave5-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-gate-a-b-c-wave5-20260626-20260626-094628.md
- expected_output: PhysicsSM/Draft/NullEdgeKineticNormalization.lean

## Purpose

This job is part of the next Gate A/B/C wave after integration triage. It targets verification, sign/gating foundations, finite null-solder frame foundations, branch-count kill-switch interpretation, or Krein hygiene.

## Integration notes

When the job returns, use the trusted theorem promotion policy and sign/normalization dashboard before promoting any result. Gate A and Gate C outcomes control whether later finite-square, continuum, and chirality jobs may proceed.

## Integration (2026-06-26)

Integrated into `PhysicsSM/Draft/NullEdgeKineticNormalization.lean` (namespace
`PhysicsSM.Draft`, imports `PhysicsSM.Draft.NullEdgeFiniteTetradPostulate`), wired into
`PhysicsSMDraft.lean`; report at `AgentTasks/null-edge-kinetic-normalization-report.md`.
Resolves the dashboard naming conflicts: fixes ONE canonical name `Knull` (= `Boxnull`;
aliases `Box_null`/`K_h`/`K`) and `Kfull` (= `Kplus`), with identity lemmas
`Kfull_eq_Knull_add_Cdiamond`, `dirac_square_eq_Knull_add_Cdiamond_add_Tframe`, and the
load-bearing guardrail `Kfull_eq_Knull_iff_Cdiamond_zero` (C-2: `Kplus`/`K_full` equals
`K_null` ONLY when `C_diamond = 0`, so they must never be conflated -- prevents silent
curvature double-counting). `mass_shell_iff` captures `-K_null + Phi_H^2 = 0 <-> K_null =
Phi_H^2` (the single on-shell relation, never additive `m_Plucker^2 + m_Higgs^2`).
Naming/finite-algebra normalization, not a continuum theorem. Verified: full
`lake build PhysicsSMDraft` exit 0; `#print axioms` clean; pre-commit clean.
