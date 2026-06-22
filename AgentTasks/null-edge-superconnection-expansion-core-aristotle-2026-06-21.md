# Aristotle task: finite superconnection expansion core

Date: 2026-06-21

## Objective

Prove the finite block expansion for a superconnection-like odd operator split
into a differential/codifferential part and a Higgs/Yukawa zero-form part.

Target file:

```text
NullEdgeSuperconnectionCore/Expansion.lean
```

Expected module:

```text
NullEdgeSuperconnectionCore.Expansion
```

## Theorem targets

```lean
finiteSuperconnection_sq_leftBlock
finiteSuperconnection_sq_rightBlock
finiteSuperconnection_sq_offBlock_zero_left
finiteSuperconnection_sq_offBlock_zero_right
finiteSuperconnection_sq_leftBlock_noCross
finiteSuperconnection_sq_rightBlock_noCross
```

## Why this matters

This is the finite Quillen/Lichnerowicz-style expansion target for the causal
super-Dirac proposal.  It isolates the algebraic statement that the square of
`d + delta + Phi + Phi^dagger` decomposes into Laplacian, cross/curvature, and
Higgs mass blocks.

## Proof guidance

- Work entrywise with `Sum.inl`/`Sum.inr` cases.
- The diagonal block targets should reduce to matrix multiplication and
  distributivity.
- The off-diagonal targets vanish because the product of two odd off-diagonal
  block matrices is diagonal.
- The no-cross targets should follow by rewriting the cross-term hypotheses in
  the expanded block formulas.

## Constraints

- Keep this package standalone: no `PhysicsSM` imports.
- Do not weaken theorem statements silently.
- Final target file should contain no proof holes or escape-hatch declarations.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-superconnection-expansion-core-20260621/NullEdgeSuperconnectionCore/Expansion.lean
```

Result before submission: passed with exactly six intended proof-hole warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: 66b812a4-25b0-4575-9897-eeb0d92f0724
  task_id: 27a36881-9eb5-41c4-9dfd-a2dc07d705d9
  target_file: NullEdgeSuperconnectionCore/Expansion.lean
  expected_module: NullEdgeSuperconnectionCore.Expansion
  submission_project: AgentTasks/aristotle-submit/null-edge-superconnection-expansion-core-20260621-project
  output_dir: AgentTasks/aristotle-output/66b812a4-25b0-4575-9897-eeb0d92f0724
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`66b812a4-25b0-4575-9897-eeb0d92f0724`; `aristotle tasks` reported task
`27a36881-9eb5-41c4-9dfd-a2dc07d705d9` as `QUEUED`.

Integrated 2026-06-21 after `aristotle tasks` reported task
`27a36881-9eb5-41c4-9dfd-a2dc07d705d9` as `COMPLETE`.
Fetched output to
`AgentTasks/aristotle-output/66b812a4-25b0-4575-9897-eeb0d92f0724`.

Aristotle proved all six finite superconnection expansion targets. The result
was ported into:

```text
PhysicsSM/Draft/NullEdgeSuperconnectionExpansionCore.lean
```

and imported by `PhysicsSMDraft.lean`.

Post-integration checks:

```text
lake env lean PhysicsSM/Draft/NullEdgeSuperconnectionExpansionCore.lean
lake build PhysicsSM.Draft.NullEdgeSuperconnectionExpansionCore
lake env lean PhysicsSMDraft.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeSuperconnectionExpansionCore.lean
```
