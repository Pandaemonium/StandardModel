# Dynamical mass-covariance target

## Objective

Upgrade the static covariance classification of the derived rest family
`{B_z}` to the momentum-dependent Dirac generator
`H(k,z) = k Gamma + B_z`.

The target separates the two exact branches:

- same-momentum covariance preserves `Gamma` and is the diagonal chiral phase
  circle modulo global phase;
- orientation reversal is the antidiagonal coset and is covariant only when
  accompanied by parity `k -> -k`.

This closes the finite generator-level dynamical covariance loop. It does not
claim a classification of every symmetry of the ordered `3+1` split-step
regulator.

Target:
`AgentTasks/aristotle-standalone/codex-24h-dynamical-mass-covariance-20260712/DynamicalMassCovariance/Target.lean`.

```yaml
aristotle:
  project_id: 2635219c-e0be-4dbd-ade0-4130eddb4dd6
  task_id: bd027307-d7cb-4c9f-ab39-b24b510c22ff
  target_file: DynamicalMassCovariance/Target.lean
  expected_module: DynamicalMassCovariance.Target
  submission_project: AgentTasks/aristotle-submit/codex-24h-dynamical-mass-covariance-20260712-project
  output_dir: AgentTasks/aristotle-output/2635219c-e0be-4dbd-ade0-4130eddb4dd6
  status: landed-and-guarded
  run: 24h-publication-run-2026-07-12
  owner: Codex
```

Preflight: the target typechecks under the pinned toolchain with exactly seven
documented proof holes. The required semantic context-pack attempt was made,
but Neo4j at `127.0.0.1:7687` refused the connection; the focused package is
self-contained and records its full mathematical scope in the module docstring.

Harvest: all seven statements were preserved. The live module
`DynamicalMassCovariance` passes direct Lean and targeted build with only
`propext`, `Classical.choice`, and `Quot.sound`. The actual ordered finite-walk
covariance successor is Aristotle project
`47f71b37-fb7a-4727-a297-255f6d603af2`.
