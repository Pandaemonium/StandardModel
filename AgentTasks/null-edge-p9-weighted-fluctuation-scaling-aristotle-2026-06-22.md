# Aristotle task: P9 weighted finite fluctuation scaling

Date: 2026-06-22

## Objective

Generalize the finite sign-source variance theorem from equal cell amplitudes
to arbitrary real amplitudes:

```text
sum_cfg weightedTotalSource(amp,cfg)^2 = (sum_i amp_i^2) * 2^N
```

After normalization by `2^N`, this gives variance `sum_i amp_i^2`.

Prompt:

```text
AgentTasks/aristotle-p9-weighted-fluctuation-scaling-prompt-20260622.md
```

Target:

```text
NullEdgeP9WeightedFluctuation/Core.lean
```

## Aristotle metadata

```yaml
aristotle:
  project_id: 4ddda2cc-0fe7-4e6e-b230-19fa8a209f6a
  task_id: 664ec9f6-462e-451b-9ed6-cbe5920a4bfa
  target_file: NullEdgeP9WeightedFluctuation/Core.lean
  expected_module: NullEdgeP9WeightedFluctuation.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-weighted-fluctuation-scaling-20260622-project
  output_dir: AgentTasks/aristotle-output/null-edge-p9-weighted-fluctuation-scaling-20260622-extracted
  status: integrated
```

Packaging note: focused standalone package, Mathlib only. The target elaborates
with eight intended proof holes before submission.

Verification before submission:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-weighted-fluctuation-scaling-20260622/NullEdgeP9WeightedFluctuation/Core.lean
lake exe cache get
lake env lean NullEdgeP9WeightedFluctuation/Core.lean
```

Integration note: Aristotle solved all targets with no statement changes. The
result was integrated as `PhysicsSM.Draft.NullEdgeP9WeightedFluctuation`; the
local repo proof was adjusted slightly to remove brittle `simp_all` behavior and
preserve docstrings.

Verification after integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9WeightedFluctuation.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeP9WeightedFluctuation.lean
git diff --check
lake build PhysicsSM.Draft.NullEdgeP9WeightedFluctuation
```
