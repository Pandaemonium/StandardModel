# Aristotle task: Live verification and semantic review of returned draft proofs

- project_id: bd07958e-2e94-4db6-ba15-f3cbde6f5514
- status: integrated
- submitted: 2026-06-26
- job_type: verification
- source_prompt: AgentTasks/aristotle-submit/null-edge-live-proof-verification-wave5-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-live-proof-verification-wave5-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-gate-a-b-c-wave5-20260626-20260626-094628.md
- expected_output: AgentTasks/null-edge-live-proof-verification-report.md

## Purpose

This job is part of the next Gate A/B/C wave after integration triage. It targets verification, sign/gating foundations, finite null-solder frame foundations, branch-count kill-switch interpretation, or Krein hygiene.

## Integration notes

When the job returns, use the trusted theorem promotion policy and sign/normalization dashboard before promoting any result. Gate A and Gate C outcomes control whether later finite-square, continuum, and chirality jobs may proceed.

## Integration (2026-06-26)

Verification report placed at `AgentTasks/null-edge-live-proof-verification-report.md`: the
job's own semantic review of returned draft proofs. Treated as an input, NOT as ground truth:
the authoritative verification of record is my own kernel check this session -- full
`lake build PhysicsSMDraft` (exit 0) plus `#print axioms` on every wave5 headline theorem
(only `propext, Classical.choice, Quot.sound`; no `Lean.ofReduceBool`). No Lean/build entered
the trusted tree from this report itself. pre-commit clean.
