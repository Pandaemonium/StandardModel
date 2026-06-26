# Aristotle task: synchronization holonomy path-independence

Date: 2026-06-25

## Objective

Push the synchronization-curvature lane beyond commuting-kernel algebra toward
the honest SYNC-003 path-independence theorem. The goal is a finite theorem
parameterized by an explicit hidden transport rule, not an unconditional
entanglement-curvature equivalence.

## Requested output

- Patchable Lean for path-independence / flatness statements in the existing
  synchronization modules.
- Minimal helper definitions if the current API cannot express diamond
  holonomy cleanly.
- A precise boundary explaining which claims remain rule-dependent.

## Files to inspect first

- `PhysicsSM/NullStrand/Synchronization/*.lean`
- `PhysicsSM/NullStrand/Entanglement/*.lean`
- `PhysicsSM/NullStrand/Clock/InternalHolonomy.lean`
- `PhysicsSM/NullStrand/ZigZag/ChiralCurrent.lean`
- `AgentTasks/null-strand-roadmap-hardening-report-aristotle-2026-06-25.md`

## Constraints

- Do not prove or state an unconditional entanglement-implies-curvature iff.
- Keep hidden transport selectors explicit.
- Finite graph/diamond hypotheses must be named in the theorem statement.

## Aristotle metadata

```yaml
aristotle:
  project_id: 5df79eef-ec6c-45f3-85d3-2890e2d22d7f
  task_id: e04a751a-33e0-4468-a743-9d7bc447f586
  target_file: PhysicsSM/NullStrand/Synchronization
  expected_module: multiple
  submission_project: AgentTasks/aristotle-submit/nullstrand-sync-holonomy-pathindependence-20260625-project
  output_dir: AgentTasks/aristotle-output/5df79eef-ec6c-45f3-85d3-2890e2d22d7f
  status: failed_after_nudge_no_output
```

## 2026-06-25 nudge

Sent `aristotle continue --mode instruct` to project
`5df79eef-ec6c-45f3-85d3-2890e2d22d7f`: skip full `lake build` and dependency
rebuilds; return patchable Lean or precise blockers.

## 2026-06-25 triage

The original task was canceled by the nudge path and its replacement failed
without patchable Lean output. No live integration was performed. This lane is
being resubmitted with an explicit instruction not to run full `lake build`.
