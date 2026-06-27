# Aristotle task: Finite tetrad-postulate frame-term vanishing theorem

- project_id: b5635fbd-1c19-40ca-ad7f-4eca82e5ef46
- status: integrated
- submitted: 2026-06-26
- job_type: proof
- source_prompt: AgentTasks/aristotle-submit/null-edge-finite-tetrad-postulate-wave2-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-finite-tetrad-postulate-wave2-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-mass-gates-wave2-20260626-20260626-073627.md
- expected_output: PhysicsSM/Draft/NullEdgeFiniteTetradPostulate.lean

## Purpose

This job is part of the second Aristotle wave for the null-edge unified mass gates. It targets the gate-based blocker decomposition from Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md Section 20.

## Integration notes

When the job returns, review semantic alignment before promoting any proof result from PhysicsSM/Draft/. For proof jobs, check conventions, signs, hidden assumptions, and whether the theorem proves the intended mathematical claim rather than a weakened substitute.

## Integration (2026-06-26)

Integrated into `PhysicsSM/Draft/NullEdgeFiniteTetradPostulate.lean` (namespace
`PhysicsSM.Draft`, imports `Mathlib`), wired into `PhysicsSMDraft.lean`; report at
`AgentTasks/null-edge-finite-tetrad-postulate-report.md` (T15). Modeled over an
arbitrary non-commutative `Ring R` indexed by a finite `iota`: `frameComm a b = [nab a, C b]`,
`Tframe = sum_{a,b} C_a [nab_a, C_b] nab_b`, `Kplus = sum C_a C_b nab_a nab_b`,
`DN = sum C_a nab_a`, `Boxnull`/`Cdiamond` with `[Invertible (4:R)]`. Headline results:
`frame_term_vanishes` (tetrad postulate `[nab_a,C_b]=0` => `Tframe=0`),
`dirac_square_decomp` (`D_N^2 = Kplus + Tframe`), `boxnull_add_cdiamond`
(`Boxnull+Cdiamond=Kplus`), `dirac_square_full_decomp` (`D_N^2 = Boxnull+Cdiamond+Tframe`,
the NULLSTRAND convention), `dirac_square_full_of_tetrad`. Names `DN`/`Tframe`/`Kplus`/
`Boxnull`/`Cdiamond` confirmed collision-free in `PhysicsSM.Draft` (the
`PhysicsSM.NullStrand.DualSolder` namesakes are a distinct namespace). Guardrail: the
defect is removed only under an explicit tetrad-postulate hypothesis, never silently;
when absent `Tframe` is kept as a separate summand. Verification: `lake env lean` exit 0;
targeted `lake build` exit 0; `#print axioms` only `propext, (Classical.choice,)
Quot.sound`; pre-commit clean. Defect classification when the postulate fails is out of
scope (see report).
