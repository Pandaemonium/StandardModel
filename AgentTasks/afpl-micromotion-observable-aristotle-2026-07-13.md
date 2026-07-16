# Aristotle target: basis-invariant micromotion anti-collapse fixture

Prove every target in `MicromotionObservable/FirstPulseTrace.lean` without
changing the definitions or statements. The central theorem must show that
two equal-endpoint unitary loops have different first-pulse traces and that
the trace survives simultaneous unitary conjugation. This is deliberately not
called a winding number; it is a finite observable any future winding must
refine. Run the narrow file first and return exact axiom footprints.

```yaml
aristotle:
  project_id: 4770da4b-f70b-433b-86fe-53fa6abd812e
  target_file: MicromotionObservable/FirstPulseTrace.lean
  expected_module: MicromotionObservable.FirstPulseTrace
  submission_project: AgentTasks/aristotle-submit/afpl-micromotion-observable-20260713-project
  output_dir: AgentTasks/aristotle-output/4770da4b-f70b-433b-86fe-53fa6abd812e
  status: submitted
```

## Semantic correction and replay

The first submitted distinctness target used Boolean inequality through a
coercion. It was cancelled before integration. The corrected theorem uses
propositional inequality, all proofs and guards pass locally, and the
proof-complete package is under independent replay:

```yaml
aristotle_v2:
  project_id: 10a7109d-135f-4e55-af89-06a0b3cdcc2c
  target_file: MicromotionObservable/FirstPulseTrace.lean
  submission_project: AgentTasks/aristotle-submit/afpl-micromotion-observable-20260713-v2-project
  output_dir: AgentTasks/aristotle-output/10a7109d-135f-4e55-af89-06a0b3cdcc2c
  status: submitted
```
