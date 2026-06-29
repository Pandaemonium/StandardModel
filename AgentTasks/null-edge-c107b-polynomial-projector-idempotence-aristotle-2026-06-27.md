# Aristotle C107b: polynomial projector idempotence

Date: 2026-06-27

Dependency class: independent finite-algebra successor to C107.

Project target:

```text
AgentTasks/aristotle-standalone/c107b-polynomial-projector-idempotence-20260627/C107bPolynomialProjector/PolynomialProjector.lean
```

## Context

The controlled non-ultralocal Gate C1 route needs a finite spectral-projector
API before Riesz calculus:

```text
branch observable B
polynomial p selecting a finite target spectral island
Pi = p(B)
```

C107 established by report and recovered source that conjugation by an inverse
pair preserves matrix powers, idempotence, and polynomial evaluation via
`Polynomial.aeval`.

Claude's cycle-4 review recommended the next finite theorem:

```text
If p is idempotent on B, then p(B) is an idempotent matrix projector.
```

## Task

Complete the two Lean theorems in:

```text
C107bPolynomialProjector/PolynomialProjector.lean
```

The intended mathematical content is:

```text
Polynomial.aeval B (p * p - p) = 0
  => (Polynomial.aeval B p) * (Polynomial.aeval B p)
     = Polynomial.aeval B p.
```

and the equivalent direct evaluation variant:

```text
Polynomial.aeval B (p * p) = Polynomial.aeval B p
  => (Polynomial.aeval B p) * (Polynomial.aeval B p)
     = Polynomial.aeval B p.
```

## Acceptance criteria

- Keep the job Mathlib-only and finite-dimensional.
- Do not introduce spectral theory, gauge fields, branch observables, or
  physical release claims.
- Preserve the theorem intent. Minor Lean statement repairs are acceptable.
- Include the complete final contents of `PolynomialProjector.lean` in the final
  response, because recent Aristotle archives have repeatedly missed candidate
  files.

## Claim boundary

This proves only a finite algebra projector fact. It does not construct `B(U)`,
does not prove gauge covariance, and does not prove `C1_NU`.
