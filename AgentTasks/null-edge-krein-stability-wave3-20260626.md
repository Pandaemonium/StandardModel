# Aristotle task: Krein physical-sector stability audit

- project_id: 5f8e4aa4-d578-4ee8-b7aa-680fc11a450d
- status: integrated
- submitted: 2026-06-26
- job_type: audit
- source_prompt: AgentTasks/aristotle-submit/null-edge-krein-stability-wave3-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-krein-stability-wave3-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-open-convention-targets-wave3-20260626-20260626-080843.md
- expected_output: AgentTasks/null-edge-krein-stability-audit.md

## Purpose

This job is part of the third Aristotle wave for null-edge items that remain genuinely unresolved after the convention-lock audit. It is focused on theorem/audit/prediction/model-decision targets rather than convention choices.

## Integration notes

When the job returns, keep conventions separate from theorem outcomes. Do not lock FMS composites, continuum limits, Krein stability, chirality, QCD obstruction maps, or prediction claims without proof/audit support.

## Integration (2026-06-26)

Audit deliverable placed at `AgentTasks/null-edge-krein-stability-audit.md`. States the
finite Krein double theorem (`J = J^dagger = J^{-1}`, `A^sharp = J A^dagger J`,
`D_- = D_+^sharp`) precisely and emphasizes it holds for every `D_+` and therefore
constrains no spectrum. Worked counterexamples on `J = diag(1,-1)`: a J-self-adjoint matrix
with purely imaginary spectrum, one with a growing conjugate pair, and a doubling example
with `spec(D_dbl)` purely imaginary -- so **J-self-adjointness implies neither real spectrum
nor stability** (reinforces the locked guardrail). Provides a seven-step finite-box spectral
audit protocol, two-layer acceptance criteria (algebraic hygiene vs physical-sector
stability) with the banned "Krein self-adjoint therefore stable" false-acceptance called
out, and a smallest-useful Lean handoff target (the doubling identity over concrete complex
matrices) plus a NumPy checker. Coordinates with, without duplicating, the determinant
branch-count audit. No Lean/build in scope.
