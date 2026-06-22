# Aristotle task: finite super-Dirac block-square core

Date: 2026-06-21

## Objective

Prove the finite block-matrix algebra behind the causal super-Dirac proposal
in a tiny standalone Lean package.

Target file:

```text
NullEdgeSuperDiracCore/BlockSquare.lean
```

Expected module:

```text
NullEdgeSuperDiracCore.BlockSquare
```

## Theorem targets

```lean
offDiagonal_sq_leftBlock
offDiagonal_sq_rightBlock
offDiagonal_sq_offBlock_zero_left
offDiagonal_sq_offBlock_zero_right
chirality_anticommutes_offDiagonal
hodgeDirac_sq_leftBlock
hodgeDirac_sq_rightBlock
scalarFlip_sq_eq_massSq
```

## Why this matters

This isolates the algebraic skeleton of the proposed finite causal
super-Dirac operator.  The target proves that an odd first-order operator on
`L + R` squares to diagonal Laplacian/mass blocks, that chirality anticommutes
with the odd operator, and that a scalar Higgs/Yukawa flip block squares to
`m^2`.

## Proof guidance

- Use `ext` and split row/column indices by `Sum.inl`/`Sum.inr`.
- The square-block theorems should reduce directly to matrix multiplication
  and the zero blocks in `offDiagonal`.
- The chirality anticommutator is entrywise case analysis.
- The Hodge-Dirac theorems should reuse the off-diagonal square theorems.
- The scalar flip theorem should split the four block cases and use the
  identity-matrix entries.

## Constraints

- Keep this package standalone: no `PhysicsSM` imports.
- Do not weaken theorem statements silently.
- Do not add assumptions beyond finite index types and decidable equality.
- Final target file should contain no proof holes or escape-hatch declarations.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-super-dirac-block-core-20260621/NullEdgeSuperDiracCore/BlockSquare.lean
```

Result before submission: passed with exactly eight intended proof-hole
warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 970a406e-ec91-47fb-bcd4-c30a22f073fc
  task_id: 9d33c443-d4c1-4b12-b11e-08ab98921418
  target_file: NullEdgeSuperDiracCore/BlockSquare.lean
  expected_module: NullEdgeSuperDiracCore.BlockSquare
  submission_project: AgentTasks/aristotle-submit/null-edge-super-dirac-block-core-20260621-project
  output_dir: AgentTasks/aristotle-output/970a406e-ec91-47fb-bcd4-c30a22f073fc
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`970a406e-ec91-47fb-bcd4-c30a22f073fc`; `aristotle tasks` reported task
`9d33c443-d4c1-4b12-b11e-08ab98921418` as `QUEUED`.

Integrated 2026-06-21 after `aristotle tasks` reported task
`9d33c443-d4c1-4b12-b11e-08ab98921418` as `COMPLETE`.
Fetched output to
`AgentTasks/aristotle-output/970a406e-ec91-47fb-bcd4-c30a22f073fc`.

Aristotle proved all eight finite super-Dirac block-square targets. The result
was ported into:

```text
PhysicsSM/Draft/NullEdgeSuperDiracBlockCore.lean
```

and imported by `PhysicsSMDraft.lean`.

Post-integration checks:

```text
lake env lean PhysicsSM/Draft/NullEdgeSuperDiracBlockCore.lean
lake build PhysicsSM.Draft.NullEdgeSuperDiracBlockCore
lake env lean PhysicsSMDraft.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeSuperDiracBlockCore.lean
```
