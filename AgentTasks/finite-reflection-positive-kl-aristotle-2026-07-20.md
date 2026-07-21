# Aristotle task: finite reflected-time Kallen-Lehmann kernel

Date: 2026-07-20
Owner: Codex
Work item: `MASS-ORIGIN-001`
Status: integrated

## Objective

Close the five proof holes in
`FiniteReflectionPositiveKL/FiniteReflectionPositiveKL.lean` without changing
the theorem statements:

1. expand the reflected Hankel quadratic form as an exact weighted sum of
   channel-amplitude squares;
2. derive reflection positivity from nonnegative spectral weights;
3. reconstruct nonnegative Euclidean transfer energies for eigenvalues in
   `(0,1]`;
4. identify transfer powers with exponentials of those energies; and
5. prove the explicit two-level visible/blind mass-channel control.

This is intentionally a finite two-point theorem. It must not be presented as
full Osterwalder-Schrader positivity, field-algebra reconstruction, an
infinite-volume spectral theorem, or a continuum mass-gap result. Preserve the
zero-overlap control: a positive transfer eigenvalue is not an observed mass
unless the chosen observable has nonzero spectral weight in that channel.

## Provenance and context

Clean-room theorem design from:

- K. Usui, arXiv:1201.3415, especially the A1-A4 reconstruction ladder;
- M. Luscher, Commun. Math. Phys. 54 (1977) 283-292; and
- K. Osterwalder and E. Seiler, Ann. Phys. 110 (1978) 440-471.

Semantic context pack:
`AgentTasks/context-packs/finite-reflection-positive-kl-20260720-220816.md`.
The repository already has more general finite reflection-positive-kernel and
transfer-Hilbert APIs. This focused target is a compact spectral
sum-of-squares consumer and must not be described as their replacement.

## Verification

Run the narrow target first:

```text
lake env lean FiniteReflectionPositiveKL/FiniteReflectionPositiveKL.lean
```

Do not weaken the hypotheses or replace exact equalities by inequalities. Small
helper lemmas are welcome. Return the exact completed source even if a broader
project build is slow.

```yaml
aristotle:
  project_id: 3b51906d-3dd8-485f-948d-572a31d2bd72
  task_id: a3873a7d-2c9d-41ae-b0f6-0b650ea26d3c
  target_file: FiniteReflectionPositiveKL/FiniteReflectionPositiveKL.lean
  expected_module: FiniteReflectionPositiveKL.FiniteReflectionPositiveKL
  submission_project: AgentTasks/aristotle-submit/finite-reflection-positive-kl-20260720-project
  output_dir: AgentTasks/aristotle-output/3b51906d-3dd8-485f-948d-572a31d2bd72
  status: integrated
```

## Integration result

All five theorem statements returned unchanged and were integrated as
`PhysicsSM/Draft/NullEdge/FiniteReflectionPositiveKL.lean`. The module has
build-enforced standard-assumption guards and a nondegenerate visible/blind
two-level control. It is registered as a finite two-point spectral consumer,
not as full field-algebra reflection positivity or a continuum mass-gap result.
