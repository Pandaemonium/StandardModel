# Aristotle task: Krein double self-adjointness and stability counterexamples

- project_id: b1075f03-fa52-4e1b-a377-2315387adbf0
- status: integrated
- submitted: 2026-06-26
- job_type: proof
- source_prompt: AgentTasks/aristotle-submit/null-edge-krein-double-counterexample-wave5-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-krein-double-counterexample-wave5-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-gate-a-b-c-wave5-20260626-20260626-094628.md
- expected_output: PhysicsSM/Draft/KreinDoubleAndCounterexamples.lean

## Purpose

This job is part of the next Gate A/B/C wave after integration triage. It targets verification, sign/gating foundations, finite null-solder frame foundations, branch-count kill-switch interpretation, or Krein hygiene.

## Integration notes

When the job returns, use the trusted theorem promotion policy and sign/normalization dashboard before promoting any result. Gate A and Gate C outcomes control whether later finite-square, continuum, and chirality jobs may proceed.

## Integration (2026-06-26)

Integrated into `PhysicsSM/Draft/KreinDoubleAndCounterexamples.lean` (namespace
`PhysicsSM.Draft`), wired into `PhysicsSMDraft.lean`; report at
`AgentTasks/null-edge-krein-double-counterexample-report.md`. This is the Lean realization
of the earlier krein-stability audit. Layer A (algebraic hygiene): `Ddbl_kreinSelfAdjoint`
(the retarded/advanced double `D_dbl` is `J_dbl`-self-adjoint for EVERY `D_+`, hence
constrains no spectrum), with `sharp_sharp`/`sharp_mul`/`Jdbl_isFundamental`. Layer B
(NOT implied by A), concrete `2x2` counterexamples on `J = diag(1,-1)`:
`jselfadj_not_real_spectrum` (J-self-adjoint with nonreal eigenvalue `i`),
`jselfadj_not_stable` (eigenvalue `1+2i`, positive real part = growing mode), and
`doubling_not_positive` (Hermitian `D_+` whose Krein double has `D_- D_+ = -I` and
`D_dbl^2 = -I`). Confirms the locked guardrail: Krein J-self-adjointness implies neither
real spectrum, positivity, unitarity, nor stability. New names (`sharp`, `Ddbl`, `Jdbl`,
`J2`, `A1`, `A2`, `Dp0`) confirmed collision-free by full `lake build PhysicsSMDraft`
(exit 0). `#print axioms` clean; pre-commit clean.
