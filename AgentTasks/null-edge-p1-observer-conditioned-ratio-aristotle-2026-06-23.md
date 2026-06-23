# Aristotle task: P1 observer-conditioned mass ratio

Target project: `null-edge-p1-observer-conditioned-ratio-20260623`

Target file:

```text
NullEdgeP1ObserverConditioned/Core.lean
```

```yaml
aristotle:
  project_id: bf397487-cd52-44c3-906d-ac883ed8922c
  target_file: NullEdgeP1ObserverConditioned/Core.lean
  expected_module: NullEdgeP1ObserverConditioned.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p1-observer-conditioned-ratio-20260623-project
  output_dir: AgentTasks/aristotle-output/bf397487-cd52-44c3-906d-ac883ed8922c
  status: integrated
```

Goal: close the proof hole in a focused standalone Mathlib package.

Scientific value: this is the scalar algebra behind the observer-conditioned
celestial state `rho_{p|u}`: invariant mass is `det(P)`, while mixedness gives
`m / (p dot u)` only after the observer energy is fixed.

Required final report:

- solved target names;
- whether any theorem statement or definition changed;
- any remaining proof holes or placeholder constructs;
- exact Lean command run;
- axiom profile if available.
