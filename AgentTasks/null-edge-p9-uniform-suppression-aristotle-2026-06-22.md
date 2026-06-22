# Aristotle task: P9 uniform residual-source suppression

Date: 2026-06-22

## Objective

Prove the finite suppression corollary for uniformly spread residual sources:

```text
normalized second moment = A^2 / N
```

This turns the weighted fluctuation theorem into a concrete large-`N`
suppression statement for the P9 cosmological-constant/source-visibility branch.

Prompt:

```text
AgentTasks/aristotle-p9-uniform-suppression-prompt-20260622.md
```

Target:

```text
NullEdgeP9UniformSuppression/Core.lean
```

## Aristotle metadata

```yaml
aristotle:
  project_id: 3b956553-e339-40e4-8790-fe7baabe2469
  task_id: ca964778-b4b4-4840-b5d4-0c681de1122e
  target_file: NullEdgeP9UniformSuppression/Core.lean
  expected_module: NullEdgeP9UniformSuppression.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-uniform-suppression-20260622-project
  output_dir: AgentTasks/aristotle-output/null-edge-p9-uniform-suppression-20260622-extracted
  status: integrated
```

Packaging note: focused standalone package, Mathlib only. The target elaborates
with seven intended proof holes before submission.

Verification before submission:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-uniform-suppression-20260622/NullEdgeP9UniformSuppression/Core.lean
lake exe cache get
lake env lean NullEdgeP9UniformSuppression/Core.lean
```

Integration note: Aristotle solved all targets with no statement changes in the
standalone package. The repo module
`PhysicsSM.Draft.NullEdgeP9UniformSuppression` integrates the result as a
corollary of `PhysicsSM.Draft.NullEdgeP9WeightedFluctuation`, avoiding duplicated
sign-source lemmas and using propositional nonzero hypotheses for readability.

Verification after integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9UniformSuppression.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeP9UniformSuppression.lean
git diff --check
lake build PhysicsSM.Draft.NullEdgeP9UniformSuppression
```
