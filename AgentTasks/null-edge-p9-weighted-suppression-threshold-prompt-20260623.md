# Aristotle focused job: weighted residual suppression threshold

```yaml
job_name: null-edge-p9-weighted-residual-suppression-threshold-20260623
status: submitted
project_id: 5579296d-ca61-4852-8d9a-592cdf3676ca
source_staged_from: AgentTasks/aristotle-standalone/null-edge-p9-weighted-suppression-threshold
prepared_project: AgentTasks/aristotle-submit/null-edge-p9-weighted-residual-suppression-threshold-20260623-project
target_module: NullEdgeP9WeightedSuppressionThreshold.Core
target_file: NullEdgeP9WeightedSuppressionThreshold/Core.lean
expected_check: lake env lean NullEdgeP9WeightedSuppressionThreshold/Core.lean
```

## Task

Prove `amplitudeSqSum_ge_totalScale_sq_div_card`, `weighted_residual_cannot_beat_everpresent_of_extensive`, and `sub_extensive_of_beats_everpresent` in `NullEdgeP9WeightedSuppressionThreshold/Core.lean` without changing the definitions or the theorem statements.

This theorem establishes the necessary condition threshold for weighted residual noise to beat $1/\sqrt{V}$ everpresent-Lambda scaling in the P9 cosmological-constant branch. It proves that sub-extensivity of total scale is a strict prerequisite for any suppression distribution to work.

## Constraints

- Do not weaken or rename the theorems.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeP9WeightedSuppressionThreshold/Core.lean
```

## Completion report requested

Please end with a brief report listing:
- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.
