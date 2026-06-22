# Aristotle task: finite hidden-isometry core

Date: 2026-06-21

## Objective

Replace the stalled full-PhysicsSM two-twistor hidden-channel job with a tiny
standalone Mathlib package proving the core finite hidden-isometry theorem.

Target file:

```text
NullEdgeHiddenIsometry/Finite.lean
```

Expected module:

```text
NullEdgeHiddenIsometry.Finite
```

## Theorem targets

Main target:

```lean
visibleReducedDensity_hiddenMixFinite_eq
```

Useful helper target:

```lean
visibleReducedDensity_hiddenMixFinite_entry_eq
```

## Proof guidance

Expand both sides entrywise. The left side has entries:

```text
sum_k (sum_i U k i * psi i a) * conj(sum_j U k j * psi j b)
```

Rearrange finite sums to:

```text
sum_i sum_j (sum_k U k i * conj(U k j)) * psi i a * conj(psi j b)
```

Then use the column-isometry hypothesis:

```text
sum_k U k i * conj(U k j) = if i = j then 1 else 0
```

The off-diagonal terms vanish and the diagonal terms reduce to
`visibleReducedDensity psi a b`.

## Constraints

- Keep this package standalone: no `PhysicsSM` imports.
- Do not add assumptions beyond finite column isometry.
- Do not weaken theorem statements silently.
- Fully proved helper lemmas in the same file are welcome.
- Final target file should contain no proof holes or escape-hatch declarations.

## Local validation before submission

```text
lake env lean NullEdgeHiddenIsometry/Finite.lean
```

## Aristotle metadata

```yaml
aristotle:
  project_id: 34463997-1e52-4f88-be99-0c96651d7ddb
  task_id: a4870afc-c25c-4488-9a19-ee2088dc5fac
  target_file: NullEdgeHiddenIsometry/Finite.lean
  expected_module: NullEdgeHiddenIsometry.Finite
  submission_project: AgentTasks/aristotle-submit/null-edge-hidden-isometry-core-20260621-project
  output_dir: AgentTasks/aristotle-output/34463997-1e52-4f88-be99-0c96651d7ddb
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`34463997-1e52-4f88-be99-0c96651d7ddb`; `aristotle tasks` reported task
`a4870afc-c25c-4488-9a19-ee2088dc5fac` as `QUEUED`.

Local validation before submission:

```text
lake env lean AgentTasks/aristotle-submit/null-edge-hidden-isometry-core-20260621-project/NullEdgeHiddenIsometry/Finite.lean
```

Result: passed with exactly one intended proof-hole warning.

Integrated 2026-06-21 after `aristotle tasks` reported task
`a4870afc-c25c-4488-9a19-ee2088dc5fac` as `COMPLETE`.
Fetched output to
`AgentTasks/aristotle-output/34463997-1e52-4f88-be99-0c96651d7ddb`.

Aristotle proved the standalone finite hidden-isometry core:

```lean
visibleReducedDensity_hiddenMixFinite_entry_eq
visibleReducedDensity_hiddenMixFinite_eq
```

The proof was ported into:

```text
PhysicsSM/Draft/NullEdgeTwoTwistorHiddenChannelAristotle.lean
```

Post-integration checks:

```text
lake env lean PhysicsSM/Draft/NullEdgeTwoTwistorHiddenChannelAristotle.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeTwoTwistorHiddenChannelAristotle.lean
```
