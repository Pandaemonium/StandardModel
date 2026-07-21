# Aristotle task: Fourier/Sobolev domain for the maximal HNU Hamiltonian

Date: 2026-07-21
Owner: Codex
Work item: `CONT-FOURIER-001`
Status: integrated

## Objective

Prove the unitary-conjugation and Fourier multiplier/derivative bridges needed
to interpret the self-adjoint momentum-space HNU Hamiltonian as a closed
position-space Dirac operator on an explicit graph or Sobolev domain.

## Claim boundary

Abstract unitary conjugation is not by itself a differential-operator
identification. Fourier normalization and domain equality must be explicit.

Semantic context:
`AgentTasks/context-packs/hnu-fourier-sobolev-domain-20260721-024108.md`.

```yaml
aristotle:
  project_id: 505e0520-4ebb-4a2e-b924-8604403d61b4
  task_id: 0f781389-ce04-42b5-8041-c74bd354027e
  target_file: PhysicsSM/Draft/NullEdge/HNUFourierPositionOperator.lean
  expected_module: PhysicsSM.Draft.NullEdge.HNUFourierPositionOperator
  submission_project: AgentTasks/aristotle-standalone/hnu-fourier-sobolev-domain-20260721
  output_dir: AgentTasks/aristotle-output/505e0520-4ebb-4a2e-b924-8604403d61b4
  status: integrated
```

## Harvest and verification

The return proves exact unitary conjugation of partially defined operators,
self-adjointness, closedness, graph pullback, graph-norm equality, and the
Schwartz Fourier derivative identity with Mathlib's `2 * pi` convention. It
explicitly reports that vector-valued Sobolev-domain identification remains
blocked on a missing weak-derivative/weighted-Fourier theorem.

Integrated as `HNUFourierPositionOperator.lean` with a build-enforced guard.

```text
lake env lean PhysicsSM/Draft/NullEdge/HNUFourierPositionOperator.lean
lake build PhysicsSM.Draft.NullEdge.HNUFourierPositionOperatorAxiomGuard
```

Both checks passed. No proof placeholders or compiler-trusted evaluation are
present in the integrated module.
