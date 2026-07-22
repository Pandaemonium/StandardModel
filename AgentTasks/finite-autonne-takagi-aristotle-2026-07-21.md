# Aristotle task: full finite Autonne-Takagi factorization

Date: 2026-07-21
Owner: Codex
Work item: `MASS-ORIGIN-001`
Status: submitted
Project: `d9f27b37-cf14-4395-899e-1b7e0d02bca2`
Task: `83d1563f-050e-4d47-bb82-a5f837f4a451`

## Objective

Eliminate the single proof handoff in
`PhysicsSM/Draft/NullEdge/FiniteAutonneTakagi.lean` without changing its
statement. For every finite complex symmetric matrix, including singular
matrices and matrices with repeated singular values, construct the
phase-compatible unitary singular basis and hence the full Autonne-Takagi
congruence.

## Exact target

```text
exists_phase_paired_basis_of_symmetric
```

The already-hole-free theorem
`FiniteTakagiMajoranaPartial.exists_autonneTakagi_of_phase_pairing` composes
the target into `exists_autonneTakagi`.

## Mathematical content

Ordinary Hermitian diagonalization of `A^H A` is not sufficient: within every
zero or repeated singular-value subspace, the basis must be rotated so that

```text
A * U.transpose^H = U * diagonal(sigma).
```

The symmetry hypothesis is `A.transpose = A`. The output singular values are
real and nonnegative. No invertibility, nonzero determinant, distinct-spectrum,
or positivity hypothesis may be added.

A viable route is to use the anti-linear map induced by complex conjugation
and `A` on each singular subspace, prove the required conjugation isometric
involution after dividing by a positive singular value, and choose a fixed
real basis there. The zero singular subspace must be handled separately. An
equivalent rigorous finite-dimensional construction is welcome.

Lean API audit (2026-07-21): `lean-explore` found no existing Mathlib
Autonne-Takagi declaration. In particular,
`LinearMap.IsSymmetric.eigenvectorBasis` and
`LinearMap.IsSymmetric.toMatrix_eigenvectorBasis` use inner-product symmetry
(Hermitian self-adjointness), not the transpose symmetry `A.transpose = A`.
They may support an auxiliary Hermitian spectral step, but invoking them as the
main diagonalization would prove a similarity theorem with the wrong
convention. The focused package therefore retains the anti-linear
phase-pairing crux explicitly.

## Honesty gates

- Do not replace unitary congruence by similarity diagonalization.
- Do not assume a simple spectrum or delete zero singular values.
- Do not return only the squared-singular basis already proved in
  `FiniteTakagiMajoranaPartial.lean`.
- Do not introduce assumptions or escape-hatch declarations.
- If the exact statement exposes a convention error, return the smallest exact
  counterexample and corrected equation; do not silently alter the target.
- This theorem classifies finite Majorana mass matrices. It does not determine
  flavor coefficients, absolute scales, mixings, or physical poles.

## Provenance

The theorem shape follows Dieci, Papini, and Pugliese, arXiv:2110.15918. The
repository literature memo is
`AutonomousLab/work/NE-DYNAMICS/CODEX_LITERATURE_TAKAGI_MASS_SEMANTICS_2026-07-21.md`.

## Verification

Run:

```text
lake env lean PhysicsSM/Draft/NullEdge/FiniteAutonneTakagi.lean
```

Report the proof architecture, any missing Mathlib API, the final axiom
footprint, and whether the theorem still includes zero/repeated singular
values.

The nonredirecting status response confirmed that the theorem remains open and
still includes `n = 0`, zero singular values, and repeated singular values.
The exact blocker is the construction of an orthonormal nonnegative
antilinear-eigenvector basis for `x |-> A * star x`, including the zero
eigenspace and the positive/negative pairing under multiplication by `i`.
Mathlib supplies the real self-adjoint spectral theorem but not this packaged
conjugate-linear fixed-basis result. Aristotle recommends continuing the
original run while the two split alternatives proceed.

```yaml
aristotle:
  project_id: d9f27b37-cf14-4395-899e-1b7e0d02bca2
  task_id: 83d1563f-050e-4d47-bb82-a5f837f4a451
  target_file: PhysicsSM/Draft/NullEdge/FiniteAutonneTakagi.lean
  expected_module: PhysicsSM.Draft.NullEdge.FiniteAutonneTakagi
  submission_project: AgentTasks/aristotle-submit/finite-autonne-takagi-20260721-project
  output_dir: AgentTasks/aristotle-output/d9f27b37-cf14-4395-899e-1b7e0d02bca2
  status: submitted
```

## Status query - 2026-07-21 15:50 PDT

After approximately 1 hour 40 minutes the proof task remained in progress and
the event stream reported 15 percent completion.  A nonredirecting
`continue --mode ask` query requested the exact current construction, Lean
blocker, statement/assumption status, and a recommendation to wait or split a
smaller helper.  The remote proof task was left running unchanged.

## Two-hour stall review - 2026-07-21 16:20 PDT

Downloaded and preserved a non-disruptive in-progress snapshot under
`AgentTasks/aristotle-output/d9f27b37-cf14-4395-899e-1b7e0d02bca2/`.
The snapshot contains substantive progress: the entire conversion from a
supplied orthonormal Takagi-column family to the unitary matrix equation and
final congruence is filled.  Exactly one private theorem remains open,
`exists_orthonormal_takagi_columns`, which is the genuine antilinear basis
existence crux.  Because the task is making mathematical progress rather than
looping in a build, it remains running after review.

A literature fallback is now recorded in
`AutonomousLab/work/NE-DYNAMICS/CODEX_TAKAGI_REALIFICATION_ROUTE_2026-07-21.md`:
the `2n x 2n` real symmetric doubling of Dieci--Papini--Pugliese reduces the
nonzero part to Mathlib's real symmetric spectral theorem and isolates the
zero-kernel basis as the final separate branch.

## Three-hour split - 2026-07-21 17:30 PDT

The task remains at 25 percent after more than three hours. A fresh snapshot
still has exactly one open private theorem,
`exists_orthonormal_takagi_columns`; the downstream matrix and congruence
assembly remains complete. The original task is retained because it has made
substantive progress, but two independent focused alternatives are now being
submitted: one constrained to the real-symmetric doubling proof and one to the
antiunitary fixed-basis proof. Neither may remove zero or repeated singular
values.
