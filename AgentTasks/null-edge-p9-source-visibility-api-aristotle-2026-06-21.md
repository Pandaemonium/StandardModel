# Aristotle task: P9 source-visibility API design

Date: 2026-06-21

## Objective

Ask Aristotle to design the finite diamond/source API needed before the P9
cosmological-constant/source-visibility branch can be submitted as proof work.

Prompt:

```text
AgentTasks/aristotle-p9-source-visibility-api-prompt-20260621.md
```

Submission project:

```text
AgentTasks/aristotle-submit/null-edge-p9-source-visibility-api-20260621-project
```

## Expected output

- finite API definitions separating visible closure, BF/surface closure, and
  observer invisibility;
- theorem dependency graph;
- toy counterexample or model separating rest-frame closure from source
  invisibility;
- confidence scores for physics alignment;
- proof jobs ready for future focused Aristotle submissions.

## Aristotle metadata

```yaml
aristotle:
  project_id: f01ec82f-ccac-44b6-b2c3-7b55433a2394
  task_id: 36b5bb31-2626-4ad5-ac39-c4935e655df9
  target_file: AgentTasks/null-edge-p9-source-visibility-api-output.md
  expected_module: none
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-source-visibility-api-20260621-project
  output_dir: AgentTasks/aristotle-output/f01ec82f-ccac-44b6-b2c3-7b55433a2394
  status: report_integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`f01ec82f-ccac-44b6-b2c3-7b55433a2394`; `aristotle tasks` reported task
`36b5bb31-2626-4ad5-ac39-c4935e655df9` as `QUEUED`, and `aristotle list`
reported the project as `RUNNING`.

Packaging note: this is a no-build design package. Aristotle warned that the
curated package includes Lean context files but no `lean-toolchain` or `.lake`
directory. That is acceptable for this strategy/API job and should not be
interpreted as a failed proof-package setup.

Completed and integrated 2026-06-21:

- Downloaded the result archive and copied the design note into
  `AgentTasks/null-edge-p9-source-visibility-api-output.md`.
- Left the optional Lean scaffold in the Aristotle output directory for now,
  because it is a non-imported roadmap scaffold rather than a reviewed repo
  module.
- The design note's most useful corrections:
  - visible closure is rest-frame closure, not source invisibility;
  - BF closure is the source-invisibility candidate;
  - boundary-exact data should imply BF closure and hence zero source;
  - squared source additivity is false without an orthogonality condition;
  - a two-antipodal-edge toy model separates visible closure from invisibility.
- The next proof-ready targets from this report are:
  `boundaryExact_implies_bfClosed`,
  `visibleClosure_not_sourceInvisibility_counterexample`,
  `closureDefect_additive_under_gluing`, and
  `diamondSource_additive_iff_orthogonal`.
