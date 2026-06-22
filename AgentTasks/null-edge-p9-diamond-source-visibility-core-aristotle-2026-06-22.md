# Aristotle task: unified P9 diamond-source visibility core

Date: 2026-06-22

## Objective

Consolidate the P9 source-visibility toy modules into one focused API and prove
the first general visible-fan rest-energy theorem:

```text
visible closure C = 0 -> momentMassSq = E^2 / 4
```

This follows the P9 source-visibility audit recommendation after five
low-threshold atoms were banked.

Prompt:

```text
AgentTasks/aristotle-p9-diamond-source-visibility-core-prompt-20260622.md
```

Target:

```text
NullEdgeP9DiamondSourceVisibility/Core.lean
```

## Aristotle metadata

```yaml
aristotle:
  project_id: dcd2f8b7-1e42-4bb6-9a18-0940cebfeed6
  task_id: 6d232228-aeea-4136-af3e-b7b672279f7b
  target_file: NullEdgeP9DiamondSourceVisibility/Core.lean
  expected_module: NullEdgeP9DiamondSourceVisibility.Core
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-diamond-source-visibility-core-v2-20260622-project
  output_dir: AgentTasks/aristotle-output/null-edge-p9-diamond-source-visibility-core-20260622-extracted
  status: integrated
```

Packaging note: focused standalone package, Mathlib only. The target is intended
to elaborate with six proof holes before submission.

Submission note: the first focused package directory developed a local `.lake`
cache problem on Windows, so the clean `v2` package above is the submitted
project. The standalone source itself was checked in the repo before packaging,
and the `v2` package passed `lake env lean` with exactly the intended proof
holes before submission.

Integration note: Aristotle returned all six proof holes solved with no
statement changes. The proofs were integrated into
`PhysicsSM.Draft.NullEdgeP9DiamondSourceVisibilityCore` with docstrings and a
final newline preserved.

Verification:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9DiamondSourceVisibilityCore.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeP9DiamondSourceVisibilityCore.lean
git diff --check
lake build PhysicsSM.Draft.NullEdgeP9DiamondSourceVisibilityCore
```
