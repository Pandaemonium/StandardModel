# Aristotle task: Chiral mechanism decision strategy for null-edge fermions

- project_id: d4d2804d-c449-464b-9944-82f0313c6a57
- status: integrated
- submitted: 2026-06-26
- job_type: audit
- source_prompt: AgentTasks/aristotle-submit/null-edge-chiral-mechanism-wave3-20260626-project/PROMPT.md
- submission_project: AgentTasks/aristotle-submit/null-edge-chiral-mechanism-wave3-20260626-project
- context_pack: AgentTasks/context-packs/null-edge-open-convention-targets-wave3-20260626-20260626-080843.md
- expected_output: AgentTasks/null-edge-chiral-mechanism-strategy.md

## Purpose

This job is part of the third Aristotle wave for null-edge items that remain genuinely unresolved after the convention-lock audit. It is focused on theorem/audit/prediction/model-decision targets rather than convention choices.

## Integration notes

When the job returns, keep conventions separate from theorem outcomes. Do not lock FMS composites, continuum limits, Krein stability, chirality, QCD obstruction maps, or prediction claims without proof/audit support.

## Integration (2026-06-26)

Audit deliverable placed at `AgentTasks/null-edge-chiral-mechanism-strategy.md`. Compares
four chirality mechanisms (internal chiral representation; domain-wall/defect zero modes;
overlap/Ginsparg-Wilson; non-Hermitian/Krein imbalance) against the dual-soldered
super-Dirac architecture. Recommends piloting domain-wall/defect zero modes first (with the
internal chiral representation as the anomaly-bookkeeping layer), rejects the pure
non-Hermitian/Krein route as a hazard, and defers overlap/GW until a Hermitian/J-positive
kernel exists. Proposes the smallest finite toy theorem (1D SSH / Jackiw-Rebbi domain-wall
zero mode with index count + mandatory mirror-mode honesty lemma), failure conditions F1-F5,
and ready-to-dispatch follow-up prompts C1-C4. Guardrails: chirality treated as an unlocked
model choice; NN1-NN4 hypotheses made explicit with the evaded one named per mechanism;
determinant-level branch-count and Krein non-overclaim honored. Note: occurrences of the
token "sorry" in the file are inside illustrative Lean shape blocks / a failure criterion,
not actual proofs. No Lean/build in scope.
