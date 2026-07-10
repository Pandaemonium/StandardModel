# Codex proof job: universal Clifford-block no-go for the axis coin

Close every proof in `AxisCoinNoGo/Core.lean` without changing the coin,
inclusion, scalar field, positivity condition, or controls. Preserve both
sides of the result:

- the explicit first-four-channel inclusion is injective and coin-invariant;
- nevertheless no injectively embedded four-dimensional invariant restriction
  can square to `r I` for any positive real `r`.

Prefer the stronger kernel route: prove `U^2-rI` is injective for every real
`r` by the exact `2x2` block determinant
`(-7/25-r)^2 + (24/25)^2 > 0`, then compose the intertwiner twice and use the
assumed scalar square. The nonzero off-diagonal `24i/25` control must remain.

This is a no-go for the landed simultaneous axis-block coin, not for all quantum
walk coins and not for the separate successive-axis four-component route.

```yaml
aristotle:
  project_id: 1881e9fc-6204-45eb-90aa-e3115a1dadb3
  target_file: AxisCoinNoGo/Core.lean
  expected_module: AxisCoinNoGo.Core
  submission_project: AgentTasks/aristotle-submit/codex-axis-coin-clifford-block-nogo-20260710-project
  output_dir: AgentTasks/aristotle-output/1881e9fc-6204-45eb-90aa-e3115a1dadb3
  status: idle; harvested and integrated
```
