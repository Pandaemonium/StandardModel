# Aristotle task: null-edge convention remainder audit

- project_id: 31c2b320-3029-40a7-b62e-e6785a87c4fc
- status: submitted
- submitted: 2026-06-26
- job_type: no-build audit
- source_prompt: AgentTasks/aristotle-submit/null-edge-conventions-remainder-audit-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-conventions-remainder-audit-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-conventions-audit-20260626-20260626-074713.md
- expected_output: AgentTasks/null-edge-conventions-remainder-audit.md

## Purpose

Audit the remaining unlocked conventions after docs/CONVENTIONS.md was tightened. The goal is to separate true convention choices from theorem/audit/prediction outcomes, and recommend any further safe convention locks.

## Integration notes

When the job returns, update docs/CONVENTIONS.md only for items Aristotle shows are genuine convention choices. Do not lock branch-count, continuum, Krein stability, chirality, QCD, or prediction outcomes unless Aristotle gives a theorem/audit path rather than a convention assertion.
