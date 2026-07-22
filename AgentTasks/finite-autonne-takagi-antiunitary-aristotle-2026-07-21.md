# Aristotle task: finite Autonne-Takagi by antiunitary fixed bases

Date: 2026-07-21
Owner: Codex
Work item: `MASS-ORIGIN-001`
Status: submitted

## Objective

Close `exists_phase_paired_basis_of_symmetric` for every finite complex
symmetric matrix through the antiunitary-involution proof. On each nonzero
singular-value eigenspace of `A^H A`, normalize the antilinear map induced by
`A` and conjugation, prove that it is an isometric involution, and construct an
orthonormal fixed basis. Treat the zero singular subspace separately.

The exact output convention is

```text
A * U.transpose^H = U * diagonal(sigma)
```

with every `sigma i >= 0`, including zero and repeated singular values.

## Honesty gates

- Do not assume an invertible matrix, simple spectrum, or positive singular
  values.
- Do not replace transpose symmetry by Hermitian self-adjointness.
- Do not return only the already-proved squared-singular decomposition.
- Do not change the target statement or introduce escape-hatch declarations.
- If the full theorem remains blocked, return a compilable abstract theorem
  giving a fixed orthonormal basis for a finite-dimensional antiunitary
  involution, with the exact hypotheses needed by the Takagi application.

## Verification

Run `lake env lean FiniteAutonneTakagi/Main.lean` first. Report the proof
architecture, final axiom footprint, and repeated/zero-spectrum coverage.

```yaml
aristotle:
  project_id: fa760c91-59e3-41f9-b0d2-23fb864e7d34
  task_id: 4d8baf83-90fa-458b-a4c4-d3d4d3a0dce6
  target_file: PhysicsSM/Draft/NullEdge/FiniteAutonneTakagi.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteAutonneTakagi
  submission_project: AgentTasks/aristotle-submit/finite-autonne-takagi-antiunitary-20260721-project
  output_dir: AgentTasks/aristotle-output/fa760c91-59e3-41f9-b0d2-23fb864e7d34
  status: submitted
```
