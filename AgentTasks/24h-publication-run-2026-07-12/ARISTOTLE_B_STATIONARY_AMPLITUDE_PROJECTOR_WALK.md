# Aristotle: stationary-amplitude projector walk

Prove the generic exact range-one Laurent expansion and unitarity of the
projector-controlled stationary-amplitude walk. The projectors are not assumed
to commute. Preserve the explicit noncommuting rational witness and its
nonzero onsite coefficient.

Integration verdict: the generic construction and witness landed, but three
submitted statements required mathematical correction. The Laurent expansion
needs `z != 0`, and the adjoint of each controlled phase remains in the same
forward/backward family with inverse phase rather than swapping families. The
counterexamples and corrected signatures are documented in the live module.

```yaml
aristotle:
  project_id: bb365801-8c75-4344-80c2-8d0a089a33ca
  task_id: 5f0d7970-b2f8-4f2f-8b95-28eebbe7a237
  target_file: AgentTasks/aristotle-targets/codex_24h_b_stationary_amplitude_projector_walk.lean
  expected_module: PhysicsSM.Draft.NullEdge.StationaryAmplitudeProjectorWalk
  submission_project: AgentTasks/aristotle-submit/codex-24h-b-stationary-amplitude-projector-walk-20260711-project
  output_dir: AgentTasks/aristotle-output/bb365801-8c75-4344-80c2-8d0a089a33ca
  status: integrated
  run: 24h-publication-run-2026-07-12
  owner: Codex
```
