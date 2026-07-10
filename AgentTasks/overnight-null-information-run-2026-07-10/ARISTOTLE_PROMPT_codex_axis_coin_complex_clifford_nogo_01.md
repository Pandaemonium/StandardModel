# Codex proof job: complex-scalar Clifford-block no-go

Close every proof in `AxisCoinNoGo/Core.lean` without changing the coin,
dimensions, scalar field, kernel-rank bound, nonzero eigenkernel control, or
final no-go statement.

The decisive strengthening over the parallel positive-real job is:

- for every `r : Complex`, the kernel of `U^2 - r I` has complex dimension at
  most three;
- at `r = -7/25 + 24 i/25` that kernel is genuinely nonzero, so the argument is
  not a false universal-invertibility claim;
- consequently no injective coin-invariant inclusion of `Complex^4` can carry a
  restriction `H` satisfying `H^2 = r I` for any complex scalar.

Use the exact decomposition `U = B direct-sum B direct-sum B`, with the two
distinct eigenvalue squares `-7/25 +/- 24 i/25`. A dimension/rank proof is
preferred. Do not weaken the result to real or positive scalars, and do not
generalize the conclusion beyond this explicit simultaneous axis-block coin.
Run `lake env lean AxisCoinNoGo/Core.lean` after replacing every handoff hole.

```yaml
aristotle:
  project_id: 4deb8628-88a6-44e7-80cb-25db059bfec3
  target_file: AxisCoinNoGo/Core.lean
  expected_module: AxisCoinNoGo.Core
  submission_project: AgentTasks/aristotle-submit/codex-axis-coin-complex-clifford-nogo-20260710-project
  output_dir: AgentTasks/aristotle-output/4deb8628-88a6-44e7-80cb-25db059bfec3
  status: idle; harvested and integrated
```
