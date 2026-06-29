# Aristotle C110a: path-shell kernel bridge

Date: 2026-06-27

Dependency class: independent.

Project target:

`AgentTasks/aristotle-standalone/c110a-path-shell-kernel-bridge-20260627/C110aPathShellKernel/PathShellEnvelope.lean`

## Context

We are developing the controlled non-ultralocal Gate C1 branch:

```text
C1_NU:
  drop finite-range / exponential locality as a release requirement,
  but keep path-sum / resolvent / spectral / finite-volume control,
  true bad-sector inverse gap,
  ghost-zero exclusion,
  anomaly/Krein/gauge audits.
```

Recent C108/C110 path-sum work established, by report, summability of a
length-indexed envelope under subcritical path entropy and per-path damping.
Claude's review correctly noted that this is still too weak for kernel control:
an envelope theorem must first imply an actual bound on the finite shell
contribution.

This C110a job asks for that small finite bridge.

## Task

Complete the two Lean theorems in:

```text
AgentTasks/aristotle-standalone/c110a-path-shell-kernel-bridge-20260627/C110aPathShellKernel/PathShellEnvelope.lean
```

The intended mathematical content is:

```text
If a finite shell has at most N paths and every path contribution is at most A,
with A >= 0, then the shell contribution is at most N * A.
```

Please keep this Mathlib-only and finite-dimensional. Do not introduce physical
operator structures, gauge structures, projectors, or locality claims in this
job.

## Acceptance criteria

- Prove `shell_contribution_le_count_mul_amplitude`.
- Prove `shell_contribution_le_length_envelope`.
- Keep the theorem statements essentially equivalent unless a small Lean repair
  is necessary.
- Do not introduce new assumptions unrelated to the finite inequality.
- Final response should include the complete final contents of
  `PathShellEnvelope.lean`, because prior focused Aristotle jobs sometimes
  returned reports without extractable candidate files.

## Why this matters

This theorem is intentionally modest. It blocks the named overclaim:

```text
Envelope-as-kernel-control fallacy:
  a summable scalar envelope is not yet an operator-kernel control theorem
  until it bounds the actual finite shell contributions.
```

Later jobs can add matrix norms, gauge-covariant path amplitudes, regulator
limits, and summability of the length-indexed shell bounds.
