# Aristotle task: Super-Dirac grading sign and Phi_H^2 double-counting audit

- project_id: 2204d007-0993-4d62-9a68-3e72076f37e2
- status: integrated
- submitted: 2026-06-26
- job_type: audit
- source_prompt: AgentTasks/aristotle-submit/null-edge-super-dirac-sign-audit-wave1-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-super-dirac-sign-audit-wave1-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-unified-mass-wave1-20260626-20260626-072657.md
- expected_output: AgentTasks/null-edge-super-dirac-sign-double-counting-audit.md

## Purpose

This job is part of the first Aristotle wave for the null-edge unified mass program. It follows the returned strategy report and focuses on one high-leverage finite proof or audit target.

## Integration notes

When the job returns, review semantic alignment before promoting any proof result from PhysicsSM/Draft/. For proof jobs, check conventions, signs, hidden assumptions, and whether the statement proves the intended mathematical claim rather than a weakened substitute.

## Integration (2026-06-26)

Audit deliverable placed at `AgentTasks/null-edge-super-dirac-sign-double-counting-audit.md`:
a step-by-step derivation under the five grading hypotheses
(`Gamma_s^2=1`, `{Gamma_s,C_a}=0`, `[Gamma_s,nabla_a]=0`, `[Gamma_s,Phi]=0`,
`[C_a,Phi]=0`) of `D = i D_N + Gamma_s Phi` => `D^2 = -D_N^2 + Phi^2 - i Gamma_s sum_a C_a[nabla_a,Phi]`
with the kinetic split `D_N^2 = Box_null + C_diamond + T_frame`; a sign table for the
`Phi`-odd (tachyonic flip) and `chi_E`-vs-`Gamma_s` confusion cases; a no-double-counting
checklist tying the Plucker/null spread and `Phi_H^2` into the single matching relation
`K_h(xi) = eigenvalue(Phi_H^2)` (forbidding the additive form); the fermion-vs-W/Z
separation table; and a recommended smallest Lean target for the later graded-square job.
The report's recommended Lean targets are written as proof-plan skeletons (no proving in
scope); it contains no trusted Lean. No Lean/build in scope.
