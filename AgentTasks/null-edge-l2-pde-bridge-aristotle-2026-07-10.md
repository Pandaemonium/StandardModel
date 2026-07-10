# Aristotle task: infinite-volume L2 multiplier bridge

## Objective

Prove both theorems in
`NullEdgeL2PDEBridge/UniformL2Multiplier.lean` without changing their
statements.  Add small helper lemmas if useful.  Run the target file directly
before any broad build.

The scientific use is precise: the null-edge project already has a uniform
operator-norm `O(1/n)` estimate for its complex `3+1` momentum symbol.  This
target should turn that pointwise relative bound into an `L2` multiplier
convergence theorem for every `MemLp` wave packet.  Do not claim a Fourier
isometry, a lattice-to-continuum identification, or PDE convergence beyond the
stated multiplier theorem.

## Context

- Context pack:
  `AgentTasks/context-packs/null-edge-l2-pde-bridge-20260710-105012.md`
- Lean version: project pin Lean 4.28.0.
- Preferred APIs: `eLpNorm_mono_ae`, `eLpNorm_const_smul`, `MemLp.eLpNorm_lt_top`,
  order squeeze/tendsto lemmas for `ENNReal`.
- The theorem statements must remain over general real normed spaces; complex
  spinors inherit the required real normed-space structure.

## Acceptance

- No proof placeholders or new assumptions.
- Both statements unchanged.
- `lake env lean NullEdgeL2PDEBridge/UniformL2Multiplier.lean` passes.

```yaml
aristotle:
  project_id: b4b82493-818d-48db-b7e1-148396c9e3e2
  target_file: NullEdgeL2PDEBridge/UniformL2Multiplier.lean
  expected_module: NullEdgeL2PDEBridge.UniformL2Multiplier
  submission_project: AgentTasks/aristotle-submit/null-edge-l2-pde-bridge-20260710-project
  output_dir: AgentTasks/aristotle-output/b4b82493-818d-48db-b7e1-148396c9e3e2
  status: integrated
```

## Integration note

The returned proofs preserved both statements and introduced no placeholders.
They were copied into the standalone source and promoted, with project
namespace/provenance/guards, to
`PhysicsSM/Draft/NullEdge/ContinuumL2MultiplierBridge.lean`.

Local verification:

- `lake env lean PhysicsSM/Draft/NullEdge/ContinuumL2MultiplierBridge.lean`
- `lake env lean AgentTasks/aristotle-standalone/null-edge-l2-pde-bridge-20260710/NullEdgeL2PDEBridge/UniformL2Multiplier.lean`
