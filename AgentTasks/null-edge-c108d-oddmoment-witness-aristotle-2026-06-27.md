# Aristotle C108d: odd-moment witness and nonzero trace criterion

Date: 2026-06-27

Dependency class: independent finite algebra successor to C108/C108b/C108c.

Project target:

```text
AgentTasks/aristotle-standalone/c108d-oddmoment-witness-20260627/C108dOddMomentWitness/OddMomentWitness.lean
```

## Context

The controlled non-ultralocal Gate C1 route needs a native branch observable
`B(U)`. The finite origin-observable stack now says:

```text
C108:
  if B commutes with the balance symmetry J, polynomial selectors p(B)
  have zero chiral trace.

C108b:
  if a selector has nonzero chiral trace, B must have a nonzero J-odd component.

C108c:
  chiral trace only sees the J-odd part:
  ChiralTrace Gamma P = ChiralTrace Gamma (OddPart J P).
```

Claude's C108c review recommended making this stack nonvacuous with a concrete
finite witness and packaging the nonzero criterion as a positive search test.

## Task

Complete the theorems in:

```text
C108dOddMomentWitness/OddMomentWitness.lean
```

The target theorems are:

```text
chiralTrace_ne_zero_iff_oddPart
concrete_two_by_two_odd_witness
```

The concrete witness should use:

```text
Gamma2 = diag(1,-1)
Jswap2 = [[0,1],[1,0]]
B = Gamma2
p = X
```

and prove:

```text
Jswap2^2 = 1,
Jswap2 * Gamma2 = -(Gamma2 * Jswap2),
OddPart Jswap2 Gamma2 = Gamma2,
ChiralTrace Gamma2 (aeval Gamma2 X) = 2,
ChiralTrace Gamma2 (aeval Gamma2 X) != 0.
```

## Acceptance criteria

- Keep the job Mathlib-only and finite-dimensional.
- Preserve the finite algebra content. Minor Lean statement repairs are
  acceptable.
- Do not introduce gauge fields, spectral islands, branch-observable physics, or
  C1 release claims.
- Prefer explicit matrix calculations for the 2 by 2 witness.
- Include the complete final contents of `OddMomentWitness.lean` in the final
  response because recent Aristotle archives have repeatedly missed candidate
  files.

## Claim boundary

This theorem shows the finite origin criterion is nonvacuous and gives a
positive search test. It does not construct a null-edge-native branch observable
and does not prove Gate C1 release.
