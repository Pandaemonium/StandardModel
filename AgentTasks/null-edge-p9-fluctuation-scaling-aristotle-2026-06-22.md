# Aristotle task: P9 finite fluctuation scaling

Date: 2026-06-22

## Objective

Prove the finite sign-source fluctuation identities needed for the P9
cosmological-constant/source-visibility branch:

```text
sum_cfg totalSource(cfg)   = 0
sum_cfg totalSource(cfg)^2 = N * 2^N
```

This is the exact finite algebra behind a `sqrt(N)` residual-source pilot.

Prompt:

```text
AgentTasks/aristotle-p9-fluctuation-scaling-prompt-20260622.md
```

Target:

```text
NullEdgeP9FluctuationScaling/Core.lean
```

## Aristotle metadata

```yaml
aristotle:
  project_id: 75f0e4c0-7944-4bca-83f3-fd26c96976a7
  task_id: cdb32722-14a6-4e62-9446-ee2d042e2216
  target_file: NullEdgeP9FluctuationScaling/Core.lean
  expected_module: NullEdgeP9FluctuationScaling.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-fluctuation-scaling-20260622-project
  output_dir: AgentTasks/aristotle-output/null-edge-p9-fluctuation-scaling-20260622-extracted
  status: integrated
```

Packaging note: focused standalone package, Mathlib only. The target elaborates
with seven intended proof holes before submission.

Verification before submission:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-fluctuation-scaling-20260622/NullEdgeP9FluctuationScaling/Core.lean
lake exe cache get
lake env lean NullEdgeP9FluctuationScaling/Core.lean
```

Integration note: Aristotle solved all seven targets with no statement changes.
The result was integrated as
`PhysicsSM.Draft.NullEdgeP9FluctuationScaling`, preserving docstrings and repo
text hygiene.

Verification after integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9FluctuationScaling.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeP9FluctuationScaling.lean
git diff --check
lake build PhysicsSM.Draft.NullEdgeP9FluctuationScaling
```
