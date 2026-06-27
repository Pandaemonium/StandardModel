# Aristotle task: NullSolderFrame, simplex frame, inverse Gram, and diagonal obstruction

- project_id: f2fb447c-8bdc-4579-961e-450fb96ff71f
- status: integrated
- submitted: 2026-06-26
- job_type: proof
- source_prompt: AgentTasks/aristotle-submit/null-edge-null-solder-frame-foundations-wave5-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-null-solder-frame-foundations-wave5-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-gate-a-b-c-wave5-20260626-20260626-094628.md
- expected_output: PhysicsSM/Draft/NullSolderFrameFoundations.lean

## Purpose

This job is part of the next Gate A/B/C wave after integration triage. It targets verification, sign/gating foundations, finite null-solder frame foundations, branch-count kill-switch interpretation, or Krein hygiene.

## Integration notes

When the job returns, use the trusted theorem promotion policy and sign/normalization dashboard before promoting any result. Gate A and Gate C outcomes control whether later finite-square, continuum, and chirality jobs may proceed.

## Integration (2026-06-26)

Integrated into `PhysicsSM/Draft/NullSolderFrameFoundations.lean` (namespace
`PhysicsSM.Draft`, with the `NullSolderFrame` structure + its `PhysicsSM.Draft.NullSolderFrame`
method namespace), wired into `PhysicsSMDraft.lean`; report at
`AgentTasks/null-edge-null-solder-frame-foundations-report.md`. Gate B ordering B0->B1->B3->B2:
B0 `NullSolderFrame` data package (`alpha_apply_ell`, `reconstruction`, `gram_invGram`); B1/B3
general-dimension simplex Gram/inverse-Gram with `simplex_gram_mul_invGram` (`G G^{-1}=I` for
all `d>=2`) and the tetrahedral `tetra_inverse_gram` (`G^{-1} = -3/4 I + 1/4 J`); B2 the
diagonal **trace obstruction** `diag_soldering_ne_id` / `simplex_diag_soldering_ne_id` -- on a
null frame no diagonal soldering `sum_a c(ell_a^flat) nabla` can equal the identity (trace 0 vs
trace d>0), the precise reason the diagonal architecture is rejected and the dual covectors
`alpha^a` must carry the symbol. Finite linear algebra; no continuum/dimension claim (the
tetrahedron is just the `d=4` simplex). New names (`NullSolderFrame`, `simplexGram`, `allOnes`,
`diagOp`, ...) collision-free by full `lake build PhysicsSMDraft` (exit 0). `#print axioms`
clean; pre-commit clean. (Module emits harmless `ring`->`ring_nf` linter suggestions; no
errors.)
