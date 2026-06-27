# Aristotle task: Prior-art and citation verification for null-edge mass papers

- project_id: 0abc9ebc-9f37-4736-8f7a-0905246f0b11
- status: integrated
- submitted: 2026-06-26
- job_type: audit
- source_prompt: AgentTasks/aristotle-submit/null-edge-lit-prior-art-audit-wave1-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-lit-prior-art-audit-wave1-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-unified-mass-wave1-20260626-20260626-072657.md
- expected_output: AgentTasks/null-edge-mass-prior-art-citation-audit.md

## Purpose

This job is part of the first Aristotle wave for the null-edge unified mass program. It follows the returned strategy report and focuses on one high-leverage finite proof or audit target.

## Integration notes

When the job returns, review semantic alignment before promoting any proof result from PhysicsSM/Draft/. For proof jobs, check conventions, signs, hidden assumptions, and whether the statement proves the intended mathematical claim rather than a weakened substitute.

## Integration (2026-06-26)

Audit deliverable placed at `AgentTasks/null-edge-mass-prior-art-citation-audit.md`:
a citation table (arXiv id / journal ref / DOI / claimed-status / audit flag) across the
prior-art targets (massive spinor-helicity 1709.04891, two-twistor mass 2102.07063,
Chin-Lee 1407.2492 arXiv-only, positive Grassmannian 1212.5605, spinor-network closure
1201.2120, spectral action hep-th/0610241, gauge networks 1301.3480, FMS/Maas 2305.01960,
Wilczek anchor), per-cluster novelty-boundary paragraphs, a list of unsafe/under-verified
phrases, and recommended bibliography blocks. Guardrails honored: no invented DOIs/journal
refs; uncertain metadata marked `unverified`; states plainly this was an offline desk
audit (metadata transcribed from project sources, not re-verified via live databases) and
lists items to confirm before submission, including the previously hallucinated-id
precedent and the still-unverified non-arXiv Wilczek anchor. No Lean/build in scope.
