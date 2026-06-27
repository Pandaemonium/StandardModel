# Aristotle task: Scalar/gauge null kinetic reconstruction theorem

- project_id: 24277f1f-9a74-4039-baf6-94f1a9386ebe
- status: integrated
- submitted: 2026-06-26
- job_type: proof
- source_prompt: AgentTasks/aristotle-submit/null-edge-scalar-kinetic-reconstruction-wave2-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-scalar-kinetic-reconstruction-wave2-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-mass-gates-wave2-20260626-20260626-073627.md
- expected_output: PhysicsSM/Draft/NullEdgeScalarKineticReconstruction.lean

## Purpose

This job is part of the second Aristotle wave for the null-edge unified mass gates. It targets the gate-based blocker decomposition from Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md Section 20.

## Integration notes

When the job returns, review semantic alignment before promoting any proof result from PhysicsSM/Draft/. For proof jobs, check conventions, signs, hidden assumptions, and whether the theorem proves the intended mathematical claim rather than a weakened substitute.

## Integration (2026-06-26)

Integrated into `PhysicsSM/Draft/NullEdgeScalarKineticReconstruction.lean` (namespace
`PhysicsSM.Draft`, imports `Mathlib`), wired into `PhysicsSMDraft.lean`; report at
`AgentTasks/null-edge-scalar-kinetic-reconstruction-report.md` (Working Plan 19.4, T8/T13).
Headline results: `repr_eq_apply_predual` (dual coordinate = edge evaluation `xi(ell_a)`),
`covector_bilin_reconstruction` (`B xi eta = sum_{a,b} B(alpha^a,alpha^b) xi(ell_a) eta(ell_b)`),
`inverse_gram` (the weights `G^{ab}=g^{-1}(alpha^a,alpha^b)` are the matrix inverse of the
Gram matrix `g_{ab}`), `inverse_gram_reconstruction`, `higgs_kinetic_reconstruction`
(`<DH,DH>_{g^{-1}} = sum G^{ab}(nab_a H)(nab_b H)`), and `euclidean_collapse_guardrail`
(the naive positive edge sum `sum_a (nab_a H)^2` is recovered only in the diagonal
`G^{ab}=delta^{ab}` case, so this is not Euclidean graph-Higgs with null labels). Soldered
to dual covectors `alpha^a` (not diagonal flats `ell_a^flat`), per guardrails; nondegeneracy
encoded via the inverse musical map `sharp = g-sharp`. Verification: `lake env lean` exit 0;
targeted `lake build` exit 0; `#print axioms` only `propext, Classical.choice, Quot.sound`;
pre-commit clean. Nondegeneracy-from-Mathlib-instance, complex/multi-component Higgs, and
covariant/continuum extensions out of scope (see report).
