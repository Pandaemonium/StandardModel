# Aristotle task: finite Autonne-Takagi by realification

Date: 2026-07-21
Owner: Codex
Work item: `MASS-ORIGIN-001`
Status: submitted

## Objective

Close `exists_phase_paired_basis_of_symmetric` for every finite complex
symmetric matrix by the real-symmetric doubling route. Preserve zero and
repeated singular values and the exact convention

```text
A * U.transpose^H = U * diagonal(sigma).
```

Write `A = B + i C` and construct the real symmetric doubled matrix
`[[B,C],[C,-B]]`. Use its orthonormal spectral decomposition, its eigenvalue
pairing involution, and an explicit treatment of the zero eigenspace to
reconstruct orthonormal complex Takagi columns. Do not assume invertibility,
simple spectrum, or nonzero singular values.

The mathematical source is Dieci, Papini, and Pugliese, arXiv:2110.15918.
The repository route memo is
`AutonomousLab/work/NE-DYNAMICS/CODEX_TAKAGI_REALIFICATION_ROUTE_2026-07-21.md`.

## Honesty gates

- Do not replace unitary congruence by similarity diagonalization.
- Do not return only a basis for `A^H A`.
- Do not weaken the theorem or alter the transpose/conjugation convention.
- If Mathlib lacks a required basis-selection API, isolate the smallest exact
  helper theorem and leave the main statement unchanged.

## Verification

Run `lake env lean FiniteAutonneTakagi/Main.lean` first. Report the final axiom
footprint and whether the theorem still covers singular and repeated spectra.

```yaml
aristotle:
  project_id: 4773355a-32e3-4061-ba73-45a5c400c8d6
  task_id: a612672d-71c4-41cc-b2f7-4bb5be0bd7b9
  target_file: PhysicsSM/Draft/NullEdge/FiniteAutonneTakagi.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteAutonneTakagi
  submission_project: AgentTasks/aristotle-submit/finite-autonne-takagi-realification-20260721-project
  output_dir: AgentTasks/aristotle-output/4773355a-32e3-4061-ba73-45a5c400c8d6
  status: submitted
```
