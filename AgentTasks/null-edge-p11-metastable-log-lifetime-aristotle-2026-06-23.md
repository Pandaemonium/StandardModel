# Aristotle task: P11 metastable log lifetime

Target project: `null-edge-p11-metastable-log-lifetime-20260623`

Target file:

```text
NullEdgeP11MetastableLogLifetime/Core.lean
```

```yaml
aristotle:
  project_id: b9327e56-86db-44da-a819-9657b0504b93
  target_file: NullEdgeP11MetastableLogLifetime/Core.lean
  expected_module: NullEdgeP11MetastableLogLifetime.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p11-metastable-log-lifetime-20260623-project
  status: integrated
```

Goal: close the proof holes in a focused standalone Mathlib package.

Scientific value: this gives P11 the smallest clean theorem behind the
metastable lifetime formula `tau = Delta t / (-log |lambda|)`.

Required final report:

- solved targets;
- whether any theorem statement or definition changed;
- any remaining proof holes or placeholder constructs;
- exact Lean command run;
- axiom profile if available.
