# Aristotle task: Finite chiral checkerboard square with a constant Yukawa mass block

- project_id: 68195a9e-3b2e-4048-bb20-b8f6e1fa9179
- status: integrated
- submitted: 2026-06-26
- job_type: proof
- source_prompt: AgentTasks/aristotle-submit/null-edge-yukawa-checkerboard-wave1-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-yukawa-checkerboard-wave1-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-unified-mass-wave1-20260626-20260626-072657.md
- expected_output: PhysicsSM/Draft/NullEdgeYukawaCheckerboard.lean

## Purpose

This job is part of the first Aristotle wave for the null-edge unified mass program. It follows the returned strategy report and focuses on one high-leverage finite proof or audit target.

## Integration notes

When the job returns, review semantic alignment before promoting any proof result from PhysicsSM/Draft/. For proof jobs, check conventions, signs, hidden assumptions, and whether the statement proves the intended mathematical claim rather than a weakened substitute.

## Integration (2026-06-26)

Integrated into `PhysicsSM/Draft/NullEdgeYukawaCheckerboard.lean` (namespace
`PhysicsSM.Draft`, imports `Mathlib`), wired into `PhysicsSMDraft.lean`. Headline
results: `yukawa_checkerboard_square` (T5 chiral square, on-shell `K = Phi^2` with
`Phi^2 = M Mᴴ` / `Mᴴ M`), `nonzero_eigenvalue_swap` and
`yukawa_nonzero_eigenvalue_correspondence` (T6 rectangular singular-value
correspondence = shared squared Dirac masses), and `yukawa_ker_self` /
`yukawa_ker_adjoint` (zero-mode kernels). Sign convention aligned with `D^2 = -K + Phi^2`.
Labelled reconstruction, not prediction (`M` is an arbitrary linear map). Note: the
proofs use the `decide` simp/aesop discharger (`+decide`), not `native_decide`.
Verification: `lake env lean` exit 0; targeted `lake build` exit 0; `#print axioms`
only `propext, Classical.choice, Quot.sound`; pre-commit clean (end-of-file-fixer
appended a missing final newline).
