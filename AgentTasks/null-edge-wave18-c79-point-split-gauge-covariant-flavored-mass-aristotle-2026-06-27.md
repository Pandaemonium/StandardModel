# Aristotle task C79: point-split gauge-covariant flavored-mass construction plan

```yaml
aristotle:
  project_id: 1f6b303d-334f-48f7-9036-41f195d28098
  task_id: 09e5d3db-13d9-4d1c-b66f-df1371ff2234
  target_file: AgentTasks/null-edge-point-split-gauge-covariant-flavored-mass-plan.md
  expected_module: report-only
  submission_project: AgentTasks/aristotle-submit/null-edge-wave18-flavored-mass-overlap-gate-c-20260627-project
  output_dir: AgentTasks/aristotle-output/1f6b303d-334f-48f7-9036-41f195d28098
  status: integrated
```

Context pack:

- `AgentTasks/context-packs/gate-c-flavored-mass-overlap-20260627-065620.md`

Wave context:

- `AgentTasks/null-edge-wave18-flavored-mass-overlap-analysis-2026-06-27.md`
- `AgentTasks/null-edge-wave17-submissions-2026-06-27.md`

Kind: no-build strategy/audit.

Goal:

Produce a no-build construction plan for making the point-split/flavored-mass operators gauge-covariant in position space.

Wave 17 has a null-Wilson gauge-covariance job. This job should focus on the flavored/branch-projector version: point-split projectors built from shifts, link-dressed versions, branch signs, and the relation to a Hermitian spectral-flow kernel.


Requested deliverable:

Write `AgentTasks/null-edge-point-split-gauge-covariant-flavored-mass-plan.md` with:

```text
1. the free-field momentum-space point-split projectors P_a(q);
2. the finite-shift position-space representation;
3. how to link-dress those shifts for gauge covariance;
4. whether backward/advanced shifts live in the Krein double or the causal update block;
5. which terms preserve primitive null transport as finite composites;
6. a proposed Lean theorem package for gauge-covariant branch projectors.
```


Scope guardrails:

Do not claim the link-dressed operator is local, ghost-safe, or prediction-grade. Explicitly list new moduli/counterterms and whether the construction breaks tetrahedral symmetry.


## Submission record, 2026-06-27

Submitted to Aristotle.

```text
project_id: 1f6b303d-334f-48f7-9036-41f195d28098
task_id: 09e5d3db-13d9-4d1c-b66f-df1371ff2234
submission_project: AgentTasks/aristotle-submit/null-edge-wave18-flavored-mass-overlap-gate-c-20260627-project
target: AgentTasks/null-edge-point-split-gauge-covariant-flavored-mass-plan.md
```

## Integration record, 2026-06-27

Integrated into the live repo by Codex.

```text
project_id: 1f6b303d-334f-48f7-9036-41f195d28098
task_id: 09e5d3db-13d9-4d1c-b66f-df1371ff2234
copied_files:
  - AgentTasks/null-edge-point-split-gauge-covariant-flavored-mass-plan.md
summary: AgentTasks/aristotle-output/1f6b303d-334f-48f7-9036-41f195d28098/ARISTOTLE_SUMMARY.md
```

No local Lean build or pre-commit was run during this integration pass.
