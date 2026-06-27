# Aristotle task: Continuum square-limit and Lichnerowicz compatibility strategy

- project_id: 6bb035e3-4c3d-4466-9001-33148957cdb1
- status: integrated
- submitted: 2026-06-26
- job_type: audit
- source_prompt: AgentTasks/aristotle-submit/null-edge-continuum-square-limit-wave3-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-continuum-square-limit-wave3-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-open-convention-targets-wave3-20260626-20260626-080843.md
- expected_output: AgentTasks/null-edge-continuum-square-limit-strategy.md

## Purpose

This job is part of the third Aristotle wave for null-edge items that remain genuinely unresolved after the convention-lock audit. It is focused on theorem/audit/prediction/model-decision targets rather than convention choices.

## Integration notes

When the job returns, keep conventions separate from theorem outcomes. Do not lock FMS composites, continuum limits, Krein stability, chirality, QCD obstruction maps, or prediction claims without proof/audit support.

## Integration (2026-06-26)

Audit deliverable placed at `AgentTasks/null-edge-continuum-square-limit-strategy.md`. Lays
out a staged theorem sequence S1-S7 from the finite dual-soldered operator + finite square
decomposition to a Lorentzian Dirac/Lichnerowicz-type continuum square, cross-mapped to the
T13-T16 chain and Gate A-D structure, with per-stage hypotheses/output/tools/failure
signatures and a finite-algebra-vs-genuine-analysis classification. Pins down what
`T_frame -> 0` must mean (genuine vanishing or controlled bounded torsion/spin-connection
survival; forbidden: `O(h^-1)` divergence, unnamed `O(1)` contamination, silent absorption)
and what comparison to generalized Lichnerowicz formulas may/may not claim. Smallest next
targets: S1 flat affine commutator symbol (d=4 tetrahedral, trivial transport) and the
`superDirac_square_sign_audit` four-case table. Guardrails: continuum theorem not claimed
proved by the finite square; `sum_a c(alpha^a) nabla_{ell_a}` kept active; diagonal operator
only as negative comparison; Lorentzian inverse-Gram kept distinct from positive graph
energy. No Lean/build in scope.
