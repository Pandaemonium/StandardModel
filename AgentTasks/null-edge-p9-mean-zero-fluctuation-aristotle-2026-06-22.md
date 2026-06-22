# Aristotle task: finite P9 mean-zero fluctuation core

Date: 2026-06-22

## Objective

Prove a finite guardrail for the P9 source-fluctuation branch:

```text
antisymmetric hidden relabeling -> zero total source
two-point sign source           -> zero mean, nonzero second moment
```

This is the first algebraic pilot for a mean-zero residual source rather than a
cosmology theorem.

Prompt:

```text
AgentTasks/aristotle-p9-mean-zero-fluctuation-prompt-20260622.md
```

Target:

```text
NullEdgeP9MeanZeroFluctuation/Finite.lean
```

## Aristotle metadata

```yaml
aristotle:
  project_id: 11e12028-c36f-4a35-8ecc-156717122f13
  task_id: 50f97a14-c11c-4a1c-bea4-a3225a067bcb
  target_file: PhysicsSM/Draft/NullEdgeP9MeanZeroFluctuation.lean
  expected_module: PhysicsSM.Draft.NullEdgeP9MeanZeroFluctuation
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-mean-zero-fluctuation-20260622-project
  output_dir: AgentTasks/aristotle-output/11e12028-c36f-4a35-8ecc-156717122f13
  status: integrated
```

Packaging note: focused standalone package, Mathlib only. The target is intended
to elaborate with four proof holes before submission.

Submitted 2026-06-22. `aristotle submit` created project
`11e12028-c36f-4a35-8ecc-156717122f13`; `aristotle tasks` reported task
`50f97a14-c11c-4a1c-bea4-a3225a067bcb` as `QUEUED`, and `aristotle list`
reported the project as `RUNNING`.

Verification before submission:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-mean-zero-fluctuation-20260622/NullEdgeP9MeanZeroFluctuation/Finite.lean
lake exe cache get
lake env lean NullEdgeP9MeanZeroFluctuation/Finite.lean
```

The final two commands were run inside
`AgentTasks/aristotle-submit/null-edge-p9-mean-zero-fluctuation-20260622-project`.

## Result

Integrated 2026-06-22 as
`PhysicsSM.Draft.NullEdgeP9MeanZeroFluctuation`. Aristotle closed all four
focused proof targets without weakening statements, adding assumptions, or using
escape-hatch declarations. The integrated repo version strengthens
`meanZero_of_equiv_antisymm` by removing an unused `[DecidableEq omega]`
hypothesis flagged by the project build linter.

The proved declarations are:

```text
meanZero_of_equiv_antisymm
twoPointSignSource_meanZero
twoPointSignSource_secondMoment_eq_two
exists_meanZero_nonzero_secondMoment
```

Verification after integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9MeanZeroFluctuation.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeP9MeanZeroFluctuation.lean
git diff --check
lake build PhysicsSM.Draft.NullEdgeP9MeanZeroFluctuation
```
