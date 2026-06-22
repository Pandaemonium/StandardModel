# Aristotle task: finite P9 BF-closure no-bulk toy theorem

Date: 2026-06-22

## Objective

Prove the second finite P9 source-visibility toy core: under a chain-complex
condition on two incidence matrices, a twice-boundary source vanishes and hence
does not contribute to any finite bulk source pairing.

This is the BF-closure companion to
`PhysicsSM.Draft.NullEdgeP9BoundarySource`: it captures the finite algebraic
prototype of "closed surface bookkeeping has no bulk divergence."

Prompt:

```text
AgentTasks/aristotle-p9-bf-closure-no-bulk-prompt-20260622.md
```

Target:

```text
NullEdgeP9BFClosure/Finite.lean
```

## Aristotle metadata

```yaml
aristotle:
  project_id: 789f2c53-5107-42cb-abfe-5377a6e3d973
  task_id: a046d404-d956-4598-9ea3-c91028407b16
  target_file: PhysicsSM/Draft/NullEdgeP9BFClosure.lean
  expected_module: PhysicsSM.Draft.NullEdgeP9BFClosure
  submission_project: AgentTasks/aristotle-submit/null-edge-p9-bf-closure-no-bulk-20260622-project
  output_dir: AgentTasks/aristotle-output/789f2c53-5107-42cb-abfe-5377a6e3d973
  status: integrated
```

Packaging note: focused standalone package, Mathlib only. The target is intended
to elaborate with three proof holes before submission.

Submitted 2026-06-22. `aristotle submit` created project
`789f2c53-5107-42cb-abfe-5377a6e3d973`; `aristotle tasks` reported task
`a046d404-d956-4598-9ea3-c91028407b16` as `QUEUED`, and `aristotle list`
reported the project as `RUNNING`.

Verification before submission:

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-p9-bf-closure-no-bulk-20260622/NullEdgeP9BFClosure/Finite.lean
lake exe cache get
lake env lean NullEdgeP9BFClosure/Finite.lean
```

The final two commands were run inside
`AgentTasks/aristotle-submit/null-edge-p9-bf-closure-no-bulk-20260622-project`.

## Result

Integrated 2026-06-22 as `PhysicsSM.Draft.NullEdgeP9BFClosure`. Aristotle
closed all three focused proof targets without statement changes, new
assumptions, or escape-hatch declarations. The integrated repo version keeps the
same theorem content but uses ASCII spelling and the `PhysicsSM.Draft`
namespace.

The proved declarations are:

```text
boundarySource_comp_eq_zero_of_chainComplex
sourcePairing_boundarySource_comp_eq_zero_of_chainComplex
sourcePairing_eq_of_add_boundarySource_comp
```

Verification after integration:

```text
lake env lean PhysicsSM/Draft/NullEdgeP9BFClosure.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeP9BFClosure.lean
git diff --check
lake build PhysicsSM.Draft.NullEdgeP9BFClosure
```
