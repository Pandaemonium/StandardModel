# Aristotle task: finite Dirac-slash square root core

Date: 2026-06-21

## Objective

Prove the static finite Dirac square-root theorem for a `2 x 2` visible
momentum block in a tiny standalone Lean package.

Target file:

```text
NullEdgeDiracSlashCore/Finite.lean
```

Expected module:

```text
NullEdgeDiracSlashCore.Finite
```

## Theorem targets

```lean
sigmaMomentum_det_eq_minkowskiNorm
sigma_mul_barSigma_eq_norm
barSigma_mul_sigma_eq_norm
chiralDiracSlash_sq_eq_norm
chiralDiracSlash_sq_eq_mass_of_norm_eq
```

## Why this matters

This is the first operator-level square root of the Plucker mass theorem.  The
trusted `PhysicsSM.Spinor.PluckerMass` result proves the determinant/mass
square.  This focused target proves that the corresponding chiral Dirac slash
squares to that scalar under explicit `(+---)` and Pauli-block conventions.

## Proof guidance

- Expand the `2 x 2` matrices by `fin_cases`.
- Use `Matrix.det_fin_two` for the determinant target.
- For the block-square theorem, split by `Sum.inl`/`Sum.inr` cases on row and
  column indices.
- The final bridge theorem should follow from `chiralDiracSlash_sq_eq_norm`
  and the hypothesis identifying `minkowskiNorm p` with `mass`.

## Constraints

- Keep this package standalone: no `PhysicsSM` imports.
- Do not weaken theorem statements silently.
- Do not change the signature convention without documenting it.
- Final target file should contain no proof holes or escape-hatch declarations.

## Local validation before submission

```text
lake env lean AgentTasks/aristotle-standalone/null-edge-dirac-slash-core-20260621/NullEdgeDiracSlashCore/Finite.lean
```

Result before submission: passed with exactly five intended proof-hole warnings.

## Aristotle metadata

```yaml
aristotle:
  project_id: bb34e744-5d5c-4a4f-98cc-e40156f0d866
  task_id: 19754975-341d-4ab9-9630-3221bae6fa38
  target_file: NullEdgeDiracSlashCore/Finite.lean
  expected_module: NullEdgeDiracSlashCore.Finite
  submission_project: AgentTasks/aristotle-submit/null-edge-dirac-slash-core-20260621-project
  output_dir: AgentTasks/aristotle-output/bb34e744-5d5c-4a4f-98cc-e40156f0d866
  status: integrated
```

Submitted 2026-06-21. `aristotle submit` created project
`bb34e744-5d5c-4a4f-98cc-e40156f0d866`; `aristotle tasks` reported task
`19754975-341d-4ab9-9630-3221bae6fa38` as `QUEUED`.

Integrated 2026-06-21 after `aristotle tasks` reported task
`19754975-341d-4ab9-9630-3221bae6fa38` as `COMPLETE`.
Fetched output to
`AgentTasks/aristotle-output/bb34e744-5d5c-4a4f-98cc-e40156f0d866`.

Aristotle proved all five static Dirac-slash targets. The result was ported
into:

```text
PhysicsSM/Draft/NullEdgeDiracSlashCore.lean
```

and imported by `PhysicsSMDraft.lean`.

Post-integration checks:

```text
lake env lean PhysicsSM/Draft/NullEdgeDiracSlashCore.lean
lake build PhysicsSM.Draft.NullEdgeDiracSlashCore
lake env lean PhysicsSMDraft.lean
python Scripts/check_forbidden_lean_tokens.py --include-draft --forbid-native-decide PhysicsSM/Draft/NullEdgeDiracSlashCore.lean
```
