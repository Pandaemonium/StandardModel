# Aristotle focused job: P9 diamond screen visibility

```yaml
aristotle:
  project_id: d9be7683-bbab-48c3-ab52-4222a8aa8535
  task_id: b788daf7-b395-4a6e-b3a4-37b788112637
  target_file: NullEdgeP9DiamondScreenVisibility/Core.lean
  expected_module: NullEdgeP9DiamondScreenVisibility.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-diamond-screen-visibility-20260624-project
  source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-diamond-screen-visibility-20260624
  status: submitted
```

## Physics context

This is a high-value P9 source-visibility theorem. The finite physics claim is:
local vacuum bookkeeping that is boundary-exact should be invisible to closed
curvature-defect tests, while a source with a nonzero closed-test response
survives in a visible or harmonic/global quotient. This supports the updated
P9 interpretation in `Sources/Null_Edge_P9_Physics_Development.md`: P9 is a
local vacuum-source filtering mechanism, not by itself a direct explanation of
the observed cosmological constant.

## Target

Fill the proof holes in:

```text
NullEdgeP9DiamondScreenVisibility/Core.lean
```

The central targets are:

```lean
exactSource_pairing_closedTest_zero
exactSource_rankOne_noise_closedTest_zero
nonzero_closed_response_not_exact
```

## Constraints

- Do not weaken theorem statements.
- Do not add fake constants or hidden assumptions.
- Small helper lemmas are welcome if useful.
- Keep imports minimal.
- Run:

```bash
lake env lean NullEdgeP9DiamondScreenVisibility/Core.lean
```

## Completion report requested

Please end with:

- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- assumptions or nonstandard constructs used;
- suggested next theorem targets for the P9 source-visibility program.
