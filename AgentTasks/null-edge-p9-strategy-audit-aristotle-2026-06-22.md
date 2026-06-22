# Aristotle task: P9 source-visibility strategy/audit

Date: 2026-06-22

## Objective

Ask Aristotle to evaluate the new finite P9 source-visibility theorem atoms and
rank the next proof targets toward a coherent `DiamondSourceVisibility` API.

This is a strategy/audit job, not a proof-filling job.

Prompt:

```text
AgentTasks/aristotle-p9-strategy-audit-prompt-20260622.md
```

Target:

```text
NullEdgeP9Strategy/Stub.lean
```

## Aristotle metadata

```yaml
aristotle:
  project_id: b4a64238-2247-4889-935c-9696cf600694
  task_id: eda403b1-4cc3-47e9-97bb-13b0cf985870
  target_file: report
  expected_module: strategy_only
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-strategy-audit-20260622-project
  output_dir: AgentTasks/aristotle-output/b4a64238-2247-4889-935c-9696cf600694
  status: report_integrated
```

Packaging note: focused package with a trivial Lean root plus P9 docs/modules as
context. No code integration should happen directly from this job.

Submitted 2026-06-22. `aristotle submit` created project
`b4a64238-2247-4889-935c-9696cf600694`; `aristotle tasks` reported task
`eda403b1-4cc3-47e9-97bb-13b0cf985870` as `QUEUED`, and `aristotle list`
reported the project as `RUNNING`.

Verification before submission:

```text
lake env lean NullEdgeP9Strategy/Stub.lean
```

This was run inside
`AgentTasks/aristotle-submit/null-edge-p9-strategy-audit-20260622-project`.

## Result

The Aristotle task returned `COMPLETE_WITH_ERRORS`, but the error was harmless
for this strategy-only request: it did not produce a Lean candidate, but it did
produce a useful audit report. A cleaned ASCII copy is integrated at:

```text
AgentTasks/null-edge-p9-source-visibility-audit-2026-06-22.md
```

Main conclusion: the five new P9 theorem atoms are a useful grammar but not yet
a threshold-bearing physics result. The next high-ROI work is a unified
`DiamondSourceVisibility` API plus a general closed-visible-fan rest-energy
theorem.
