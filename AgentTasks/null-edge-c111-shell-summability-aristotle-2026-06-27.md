# Aristotle C111: Banach-valued shell summability bridge

Date: 2026-06-27

Dependency class: independent / soft-dependent successor to C110b.

Project target:

```text
AgentTasks/aristotle-standalone/c111-shell-summability-20260627/C111ShellSummability/ShellSummability.lean
```

## Context

The controlled non-ultralocal Gate C1 route needs path-sum control that goes
beyond finite shell bounds:

```text
C110b:
  finite shell norm bound

C111:
  summability over shell lengths
```

C110b, by Aristotle report and recovered source, proves:

```text
per-path norm bound + path-count bound
  => norm of finite shell sum <= path-count * amplitude-bound.
```

Claude's cycle-5 review recommended the next theorem: if the scalar envelope
over shell lengths is summable, then the Banach-valued shell kernel series is
summable and its total norm is bounded by the scalar envelope sum.

## Task

Complete the two Lean theorems in:

```text
C111ShellSummability/ShellSummability.lean
```

The main intended theorem is:

```text
Summable (fun n => pathCount n * ampBound n)
  and finite shell norm bounds
  =>
  Summable (fun n => ShellKernel (shell n) amplitude)
  and
  norm (tsum shell kernels) <= tsum scalar envelopes.
```

The file repeats the C110b finite shell theorem locally so it can be proved
self-contained.

## Acceptance criteria

- Prove `shell_kernel_norm_le_count_mul_amplitude`.
- Prove `total_shell_kernel_summable`, or if the exact total-norm bound needs a
  small statement repair, explain the repair and preserve the intended theorem.
- Keep the job Mathlib-only.
- Do not introduce gauge fields, branch observables, spectral projectors,
  locality claims, or physical release claims.
- Include the complete final contents of `ShellSummability.lean` in the final
  response because recent Aristotle archives have repeatedly missed candidate
  files.

## Claim boundary

This proves only a Banach-valued summability estimate. It does not prove gauge
covariance, locality, regulator stability, or `C1_NU`.
