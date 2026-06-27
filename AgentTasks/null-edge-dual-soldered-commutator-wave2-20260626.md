# Aristotle task: Flat affine dual-soldered commutator symbol theorem

- project_id: 96c40dde-bed2-4c5d-947b-a43bfa5203ca
- status: integrated
- submitted: 2026-06-26
- job_type: proof
- source_prompt: AgentTasks/aristotle-submit/null-edge-dual-soldered-commutator-wave2-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-dual-soldered-commutator-wave2-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-mass-gates-wave2-20260626-20260626-073627.md
- expected_output: PhysicsSM/Draft/NullEdgeDualSolderedCommutator.lean

## Purpose

This job is part of the second Aristotle wave for the null-edge unified mass gates. It targets the gate-based blocker decomposition from Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md Section 20.

## Integration notes

When the job returns, review semantic alignment before promoting any proof result from PhysicsSM/Draft/. For proof jobs, check conventions, signs, hidden assumptions, and whether the theorem proves the intended mathematical claim rather than a weakened substitute.

## Integration (2026-06-26)

Integrated into `PhysicsSM/Draft/NullEdgeDualSolderedCommutator.lean` (namespace
`PhysicsSM.Draft`, imports `Mathlib`), wired into `PhysicsSMDraft.lean`. Headline
results: `nullEdge_commutator` (exact finite commutator), `nullEdge_commutator_affine`
(`[D_h, M_f] = c(df)` for affine `f`, trivial transport), `dual_frame_duality` /
`dual_frame_reconstruction` / `clifford_symbol_reconstruction` (dual-solder symbol
recovery). Uses the active dual-soldered architecture `D_h = sum_a c(alpha^a)(T_a - I)/h`
only; the diagonal trace-obstruction operator is deliberately avoided, per guardrails.
Verification: `lake env lean` exit 0; targeted `lake build` exit 0; `#print axioms`
on the headline theorems shows only `propext, Classical.choice, Quot.sound`; pre-commit
clean. Smooth continuum limit explicitly out of scope (finite/flat half of T13).
