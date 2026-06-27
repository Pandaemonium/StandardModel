# Aristotle task: Formal high-momentum tetrahedral null branch theorem

- project_id: 3d728b3e-c575-4c9a-adb9-46666bc0cc9a
- status: integrated
- submitted: 2026-06-26
- job_type: proof
- source_prompt: AgentTasks/aristotle-submit/null-edge-high-momentum-branch-proof-wave5-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-high-momentum-branch-proof-wave5-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-gate-a-b-c-wave5-20260626-20260626-094628.md
- expected_output: PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean

## Purpose

This job is part of the next Gate A/B/C wave after integration triage. It targets verification, sign/gating foundations, finite null-solder frame foundations, branch-count kill-switch interpretation, or Krein hygiene.

## Integration notes

When the job returns, use the trusted theorem promotion policy and sign/normalization dashboard before promoting any result. Gate A and Gate C outcomes control whether later finite-square, continuum, and chirality jobs may proceed.

## Integration (2026-06-26)

Integrated into `PhysicsSM/Draft/TetrahedralHighMomentumNullBranch.lean` (namespace
`PhysicsSM.Draft.TetrahedralNullBranch`, nested -> collision-safe), wired into
`PhysicsSMDraft.lean`; report at `AgentTasks/null-edge-high-momentum-branch-proof-report.md`.
Formalizes the warning corner and full `{0,pi}^4` classification of the flat tetrahedral
retarded dual-soldered symbol: `warning_uT_Ginv_u` (`q=(pi,pi,pi,0)` has `u^T G^{-1} u = 0`
with `u != 0`), `threePi_null` (all four three-pi corners), `corner_qform`
(`u^T G^{-1} u = k^2 - 3k`), the 16-corner counts (`count_null`=5 = 1 origin + 4 high-momentum,
`count_spacelike`=10, `count_timelike`=1), and `pSq_mink_eq_qform` (the explicit mostly-minus
Minkowski build matches the edge-coordinate form). Guardrail carried verbatim: this is finite
branch DATA, not a physical doubler theorem; determinant-level nullity is necessary not
sufficient; Krein J-sign / gauge / energy-slice / h-scaling still required. The corner-count
proofs use `decide +kernel`/`+revert` (trusted kernel decide, NOT native_decide). Verified:
full `lake build PhysicsSMDraft` exit 0; `#print axioms` only
`propext, Classical.choice, Quot.sound` (no `Lean.ofReduceBool`); pre-commit clean.
