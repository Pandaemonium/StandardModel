# Aristotle C107c: polynomial projector covariance assembly

Date: 2026-06-27

Dependency class: independent / soft-dependent finite algebra assembly.

Project target:

```text
AgentTasks/aristotle-standalone/c107c-polynomial-projector-covariance-20260627/C107cPolynomialProjector/ProjectorCovariance.lean
```

## Context

The controlled non-ultralocal Gate C1 route needs a finite polynomial projector
API before introducing analytic Riesz projectors or physical branch observables.

Already completed by Aristotle report and recovered sources:

```text
C107:
  Polynomial.aeval (S * B * T) p = S * (Polynomial.aeval B p) * T
  under S*T=1 and T*S=1.

C107b:
  Polynomial.aeval B (p * p - p) = 0
    => Polynomial.aeval B p is idempotent.
```

Claude's cycle-6 review recommended the next finite assembly theorem:

```text
the conjugated polynomial projector is idempotent and equals p(SBT).
```

## Task

Complete the theorem in:

```text
C107cPolynomialProjector/ProjectorCovariance.lean
```

The intended mathematical content is:

```text
S*T = 1, T*S = 1,
Polynomial.aeval B (p*p - p) = 0
  =>
  (S*p(B)*T)^2 = S*p(B)*T
  and
  p(S*B*T) = S*p(B)*T.
```

You may prove the needed C107/C107b finite algebra facts locally in this file;
do not import from the standalone recovered task directories unless that is
easier in the submitted package.

## Acceptance criteria

- Keep the job Mathlib-only and finite-dimensional.
- Do not introduce gauge fields, branch observables, spectral theory, Riesz
  projectors, or physical release claims.
- Preserve the theorem intent. Minor Lean statement repairs are acceptable.
- Include the complete final contents of `ProjectorCovariance.lean` in the final
  response, because recent Aristotle archives have repeatedly missed candidate
  files.

## Claim boundary

This proves only finite polynomial-projector algebra. It does not construct
`B(U)`, does not prove an origin chiral index, and does not prove `C1_NU`.
