# Codex proof job: finite position-register successive-axis walk

Close every proof in `SuccessiveAxisPositionWalk/Core.lean` without changing the
finite torus, four-component state space, local one-site source-position map,
conditional shift, pointwise coin, factor order, tetrahedral sign table, or
controls.

Prove:

- each channel-dependent one-site translation is bijective;
- conditional shifts preserve the finite complex inner product;
- a pointwise two-sided-unitary `4x4` coin preserves that inner product;
- the ordered mass/x/y/z composition is exactly norm preserving;
- the concrete five-site shift is nonidentity;
- deleting the origin fails norm preservation.

This is the first actual position-space/local-shift layer for Route B. It does
not yet prove that the supplied sign table and coins realize the landed Clifford
generators, nor any continuum/Trotter limit. Keep those boundaries explicit.
Run `lake env lean SuccessiveAxisPositionWalk/Core.lean`.

```yaml
aristotle:
  project_id: 624c8719-13a9-488c-a0fc-036f18457f9b
  target_file: SuccessiveAxisPositionWalk/Core.lean
  expected_module: SuccessiveAxisPositionWalk.Core
  submission_project: AgentTasks/aristotle-submit/codex-successive-axis-position-walk-20260710-project
  output_dir: AgentTasks/aristotle-output/624c8719-13a9-488c-a0fc-036f18457f9b
  status: idle; harvested and integrated with live Clifford factors
```
