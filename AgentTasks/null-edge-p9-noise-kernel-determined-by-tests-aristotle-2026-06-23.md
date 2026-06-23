# Aristotle task: P9 noise kernel determined by observer tests

Target project: `null-edge-p9-noise-kernel-determined-by-tests-20260623`

Target file:

```text
NullEdgeP9NoiseKernelDeterminedByTests/Core.lean
```

```yaml
aristotle:
  project_id: 21bd32fa-3bfe-4a4d-a9b3-cbec08971fb5
  target_file: NullEdgeP9NoiseKernelDeterminedByTests/Core.lean
  expected_module: NullEdgeP9NoiseKernelDeterminedByTests.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-noise-kernel-determined-by-tests-20260623-project
  status: integrated
```

Goal: close the proof holes in a focused standalone Mathlib package.

Scientific value: this turns the P9 stochastic-gravity guardrail into finite
linear algebra. If every observer test has zero quadratic noise response, then
the full finite noise kernel is zero entrywise. This is the correct strengthening
of "mean-zero source" into actual noise invisibility.

Required final report:

- solved target names;
- whether any theorem statement or definition changed;
- any remaining proof holes or placeholder constructs;
- exact Lean command run;
- a x i o m profile if available.
