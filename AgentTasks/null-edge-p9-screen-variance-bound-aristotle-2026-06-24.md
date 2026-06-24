# Aristotle focused job: P9 screen-supported variance bound

```yaml
aristotle:
  project_id: 1d7c0d2c-1d64-4a39-a4c6-b4535535ce83
  task_id: 2d3b69ac-7b52-41de-938a-a3c97a7e80a1
  target_file: NullEdgeP9ScreenVarianceBound/Core.lean
  expected_module: NullEdgeP9ScreenVarianceBound.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-screen-variance-bound-20260624-project
  source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-screen-variance-bound-20260624
  status: submitted
```

## Physics context

This job formalizes the scaling audit from
`Sources/Null_Edge_P9_Physics_Development.md`. If residual source noise is
supported on screen cells rather than volume cells, the second moment is bounded
by screen cell count. This is valuable as a local vacuum-source filtering result,
but the prompt should not overclaim that it explains the observed cosmological
constant. The updated physical reading is that observed dark energy, if treated
in this branch, likely requires a surviving harmonic/global/unimodular mode.

## Target

Fill the proof holes in:

```text
NullEdgeP9ScreenVarianceBound/Core.lean
```

The central targets are:

```lean
screenSecondMoment_le_card_mul_sigmaSq
normalized_screen_variance_bound
screen_bound_le_volume_bound
```

## Constraints

- Do not weaken theorem statements.
- Do not add fake constants or hidden assumptions.
- Small helper lemmas are welcome if useful.
- Keep imports minimal.
- Run:

```bash
lake env lean NullEdgeP9ScreenVarianceBound/Core.lean
```

## Completion report requested

Please end with:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- assumptions or nonstandard constructs used;
- suggested next theorem targets for screen, null-boundary, and harmonic
  residual scaling.
