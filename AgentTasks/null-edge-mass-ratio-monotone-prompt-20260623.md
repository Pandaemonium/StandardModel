# Aristotle focused job: mass ratio monotonicity under unital Bloch contraction

```yaml
job_name: null-edge-mass-ratio-monotone-20260623
status: integrated
project_id: 3feed7da-777d-4e16-8b46-345be34536fc
source_staged_from: AgentTasks/aristotle-standalone/null-edge-mass-ratio-monotone
prepared_project: AgentTasks/aristotle-submit/null-edge-mass-ratio-monotone-project
target_module: NullEdgeMassRatioMonotone.Core
target_file: NullEdgeMassRatioMonotone/Core.lean
expected_check: lake env lean NullEdgeMassRatioMonotone/Core.lean
```

## Task

Prove `massRatio_monotone_under_unital_bloch_contraction` in `NullEdgeMassRatioMonotone/Core.lean` without changing the definitions or the theorem statement.

```lean
theorem massRatio_monotone_under_unital_bloch_contraction
    (r : Vec3) (f : Vec3 -> Vec3)
    (h_norm_le : normSq r ≤ 1)
    (h_contract : normSq (f r) ≤ normSq r) :
    massRatio r ≤ massRatio (f r) := by
```

This theorem proves that the mass ratio increases (or stays the same) under a unital Bloch contraction (a coarse-graining observer channel), showing relative entropy / distinguishability monotonicity at the level of the qubit space.

## Constraints

- Do not weaken or rename the theorem.
- Do not add new assumptions, fake constants, or non-kernel escape hatches.
- Keep imports minimal.
- Verify with:

```bash
lake env lean NullEdgeMassRatioMonotone/Core.lean
```

## Completion report requested

Please end with a brief report listing:
- solved targets;
- any statement or definition changes;
- remaining proof holes, if any;
- any assumptions or nonstandard constructs used.
