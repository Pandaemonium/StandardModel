# Aristotle task: Flat determinant branch-count and no-doubling protocol

- project_id: 6e22a037-284c-45e6-91cc-10067ba274cb
- status: integrated
- submitted: 2026-06-26
- job_type: audit
- source_prompt: AgentTasks/aristotle-submit/null-edge-flat-branch-count-wave2-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-flat-branch-count-wave2-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-mass-gates-wave2-20260626-20260626-073627.md
- expected_output: AgentTasks/null-edge-flat-branch-count-protocol.md

## Purpose

This job is part of the second Aristotle wave for the null-edge unified mass gates. It targets the gate-based blocker decomposition from Sources/Null_Edge_Unified_Mass_Model_Working_Plan.md Section 20.

## Integration notes

When the job returns, review semantic alignment before promoting any proof result from PhysicsSM/Draft/. For proof jobs, check conventions, signs, hidden assumptions, and whether the theorem proves the intended mathematical claim rather than a weakened substitute.

## Integration (2026-06-26)

Audit deliverables placed at `AgentTasks/null-edge-flat-branch-count-protocol.md`
(determinant-level branch-count protocol for the tetrahedral 3+1 dual frame) and
`Scripts/experiments/null_edge_branch_count.py` (stdlib-only oracle, not a proof).
Key findings (numerically checked by the oracle): the branch test reduces to the
scalar `p(q)^2 = m^2`; the warning point `q=(pi,pi,pi,0)` is a genuine high-momentum
determinant-level null branch (`p(q) != 0` but `p(q)^2 = 0`, 2-dim Clifford kernel);
the massless null set is a 2-real-dimensional variety (5 of 16 corners null), not
isolated points; generic real spatial slices give complex-energy branches. Verdict:
as it stands the operator does NOT pass the naive no-doubling claim (Gate C open).
No Lean/build was in scope; this is an audit, not a safety proof. Files pass
ASCII/whitespace/final-newline hygiene.
