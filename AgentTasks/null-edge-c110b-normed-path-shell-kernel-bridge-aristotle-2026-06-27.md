# Aristotle C110b: normed path-shell kernel bridge

Date: 2026-06-27

Dependency class: independent successor to C110a.

Project target:

```text
AgentTasks/aristotle-standalone/c110b-normed-path-shell-kernel-bridge-20260627/C110bPathShellKernel/NormedPathShell.lean
```

## Context

The controlled non-ultralocal Gate C1 route needs path-sum control that bounds
actual operator or matrix kernels, not only scalar envelopes.

C110a recovered a scalar finite shell theorem:

```text
sum of scalar weights <= path-count bound * amplitude bound
```

Claude's cycle-3 review correctly said that the real kernel bridge should be:

```text
norm of finite path-amplitude sum <= path-count bound * amplitude bound
```

This C110b job asks for that theorem in a Mathlib-only normed additive group.

## Task

Complete the two Lean theorems in:

```text
C110bPathShellKernel/NormedPathShell.lean
```

The intended mathematical content is:

```text
If every path amplitude in a finite shell has norm <= A,
and the shell has at most N paths,
then the norm of the total shell amplitude is <= N * A.
```

Use the finite triangle inequality / `norm_sum_le` style theorem plus the
cardinality bound.

## Acceptance criteria

- Prove `shell_kernel_norm_le_count_mul_amplitude`.
- Prove `shell_kernel_norm_le_length_envelope`.
- Keep the job Mathlib-only and finite-dimensional.
- Do not introduce gauge fields, branch observables, spectral projectors, or
  physical release claims.
- Include the complete final contents of `NormedPathShell.lean` in the final
  response, because recent Aristotle archives have repeatedly missed candidate
  files.

## Claim boundary

This proves only a finite norm inequality. It does not prove convergence of the
length sum, gauge covariance of amplitudes, locality, or `C1_NU`.
