# Aristotle C108c: odd-part chiral trace identity

Date: 2026-06-27

Dependency class: independent finite algebra successor to C108/C108b.

Project target:

```text
AgentTasks/aristotle-standalone/c108c-oddpart-chiraltrace-20260627/C108cOddPartChiralTrace/OddPartTrace.lean
```

## Context

C108 says balance-even selectors have zero chiral trace. C108b says nonzero
chiral trace requires a nonzero balance-odd branch-observable component.

Claude recommended the quantitative identity:

```text
ChiralTrace Gamma P = ChiralTrace Gamma (OddPart J P)
```

when `J^2 = 1` and `J` anti-commutes with `Gamma`.

This says the origin chiral trace sees only the `J`-odd part.

## Task

Complete the theorems in:

```text
C108cOddPartChiralTrace/OddPartTrace.lean
```

The main theorem is:

```text
chiralTrace_eq_chiralTrace_oddPart
```

and the polynomial-selector corollary:

```text
chiralTrace_polynomial_aeval_eq_chiralTrace_oddPart
```

## Acceptance criteria

- Keep the job Mathlib-only and finite-dimensional.
- Preserve the finite algebra content. Minor Lean statement repairs are
  acceptable.
- Do not introduce gauge fields, spectral islands, branch-observable physics, or
  C1 release claims.
- Include the complete final contents of `OddPartTrace.lean` in the final
  response because recent Aristotle archives have repeatedly missed candidate
  files.

## Claim boundary

This theorem gives a quantitative identity for the origin-fiber chiral trace. It
does not construct a branch observable and does not prove release.
