# Aristotle task: observer partial trace and visible congruence

Date: 2026-06-23

## Goal

Fill the proof holes in the standalone Lean file:

```text
NullEdgeObserverPartialTrace/Core.lean
```

This proves the finite-index backbone of the observer-channel mass conjecture:
the resolution observer's hidden partial trace commutes with a visible boost
acting as `A tensor I`, and therefore `SL(2,C)` visible boosts preserve the
determinant of the unnormalized visible block.

## Instructions for Aristotle

- Keep the theorem statements semantically unchanged.
- You may add small helper lemmas for finite sums or matrix entries.
- Do not add new assumptions unless clearly explained.
- Run the narrow command first:

```text
lake env lean NullEdgeObserverPartialTrace/Core.lean
```

## Metadata

```yaml
aristotle:
  project_id: 24d7e228-3636-4398-801f-32dc0cca70a6
  task_id: 90f52761-d9d8-4edc-b1af-98cb423a265b
  target_file: NullEdgeObserverPartialTrace/Core.lean
  expected_module: NullEdgeObserverPartialTrace.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-observer-partial-trace-20260623-project
  output_dir: AgentTasks/aristotle-output/24d7e228-3636-4398-801f-32dc0cca70a6
  status: integrated
```

## Integration note

Integrated as:

```text
PhysicsSM.Draft.NullEdgeObserverPartialTrace
```

Scientific value: finite hidden partial trace commutes with visible congruence,
and `SL(2,C)` visible congruence preserves the determinant of the unnormalized
resolution output.
